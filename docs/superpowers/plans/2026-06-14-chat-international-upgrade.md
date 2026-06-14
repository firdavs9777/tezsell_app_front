# Chat International Upgrade — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Upgrade Tezsell chat to international-market polish (Korea/Japan/US) without rewriting the architecture. Layer reliability, offline-queue, in-thread listing card, inbound translation, search, and mute/archive on top of the existing Riverpod `ChatNotifier`.

**Architecture:** Keep current `ChatNotifier` + split `ChatListWebSocketService`/`ChatRoomWebSocketService`. Add three top-level services (`MessageQueueService`, `MessageTranslationService`, `ConnectionStateController`) that notify the notifier via streams. Extend `ChatMessage` and `ChatRoom` models with required fields.

**Tech Stack:** Flutter 3.24+, Dart 3.10+, Riverpod 2.4, `web_socket_channel` 2.4, `shared_preferences` 2.2, `connectivity_plus` (new), `http` 1.1 / `dio` 5.0.

**Spec:** [`docs/superpowers/specs/2026-06-14-chat-international-upgrade-design.md`](../specs/2026-06-14-chat-international-upgrade-design.md)

---

## Deviations from spec

- **Queue persistence uses `shared_preferences`, not `sqflite`.** Reasoning: send-queue is typically <100 entries, sqflite would add a new dependency and migration concern, `shared_preferences` is already a project dep and the existing pin/block features use it. Pragma over purity.
- **`connectivity_plus` is added as a new dependency** (not yet in pubspec). Required for network-aware reconnect.

## Backend coordination checklist (read first)

Before starting Phase 2+, confirm with backend:

1. **`localId` echo in send response** — server must accept a client `local_id` field on POST/WS-send and echo it back on the persisted message. Blocks Task 8.
2. **`productId` on chat rooms** — does `ChatRoom` JSON include `product_id` (or similar) for product-initiated chats? Blocks Task 11.
3. **Translation endpoint** — `POST /messages/{id}/translate?target=<locale>`. Blocks Task 15.
4. **Per-room search endpoint** — `GET /chats/{id}/messages?q=...&before=<ts>`. Blocks Task 19 (fallback: local-only).
5. **WS auth via first-message** — server accepts `{"type": "auth", "token": "..."}` post-connect. Blocks Task 5. Frontend supports both during rollout.

If a dependency is not ready, the dependent task is blocked but other phases can proceed.

---

## Phase 1 — Reliability foundation

### Task 1: Add `connectivity_plus` + `ConnectionStateController`

**Files:**
- Modify: `pubspec.yaml` (add dep)
- Create: `lib/service/connection_state_controller.dart`
- Create: `test/services/connection_state_controller_test.dart`

- [ ] **Step 1: Add dependency**

Edit `pubspec.yaml` under `dependencies`:

```yaml
  connectivity_plus: ^6.0.5
```

Run: `flutter pub get`
Expected: `Got dependencies!`

- [ ] **Step 2: Write the failing test**

Create `test/services/connection_state_controller_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:app/service/connection_state_controller.dart';

void main() {
  group('ConnectionStateController', () {
    test('emits offline after debounce period when set to disconnected', () async {
      final controller = ConnectionStateController(debounce: const Duration(milliseconds: 50));
      final states = <ConnectionState>[];
      final sub = controller.stream.listen(states.add);

      controller.setSocketConnected(false);
      await Future.delayed(const Duration(milliseconds: 100));

      expect(states.last, ConnectionState.offline);
      await sub.cancel();
      controller.dispose();
    });

    test('does not emit offline if reconnect happens before debounce', () async {
      final controller = ConnectionStateController(debounce: const Duration(milliseconds: 50));
      final states = <ConnectionState>[];
      final sub = controller.stream.listen(states.add);

      controller.setSocketConnected(false);
      await Future.delayed(const Duration(milliseconds: 20));
      controller.setSocketConnected(true);
      await Future.delayed(const Duration(milliseconds: 80));

      expect(states, isNot(contains(ConnectionState.offline)));
      await sub.cancel();
      controller.dispose();
    });
  });
}
```

- [ ] **Step 3: Run test to verify it fails**

Run: `flutter test test/services/connection_state_controller_test.dart`
Expected: FAIL with `Target of URI doesn't exist` or similar.

- [ ] **Step 4: Implement the controller**

Create `lib/service/connection_state_controller.dart`:

```dart
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

enum ConnectionState { online, offline, reconnecting }

class ConnectionStateController {
  ConnectionStateController({
    Duration debounce = const Duration(seconds: 3),
    Connectivity? connectivity,
  })  : _debounce = debounce,
        _connectivity = connectivity ?? Connectivity() {
    _connectivitySub = _connectivity.onConnectivityChanged.listen((result) {
      _networkAvailable = !result.contains(ConnectivityResult.none);
      _recompute();
    });
  }

  final Duration _debounce;
  final Connectivity _connectivity;
  late final StreamSubscription _connectivitySub;
  final StreamController<ConnectionState> _controller = StreamController.broadcast();

  bool _socketConnected = false;
  bool _networkAvailable = true;
  Timer? _debounceTimer;
  ConnectionState _emitted = ConnectionState.online;

  Stream<ConnectionState> get stream => _controller.stream;
  ConnectionState get current => _emitted;

  void setSocketConnected(bool connected) {
    _socketConnected = connected;
    _recompute();
  }

  Stream<bool> get networkRestored => _connectivity.onConnectivityChanged
      .map((result) => !result.contains(ConnectivityResult.none))
      .where((available) => available);

  void _recompute() {
    final desired = (_socketConnected && _networkAvailable)
        ? ConnectionState.online
        : ConnectionState.offline;

    if (desired == _emitted) return;

    _debounceTimer?.cancel();
    if (desired == ConnectionState.online) {
      // online state emitted immediately
      _emitted = desired;
      _controller.add(desired);
    } else {
      // offline state debounced to avoid flicker
      _debounceTimer = Timer(_debounce, () {
        _emitted = desired;
        _controller.add(desired);
      });
    }
  }

  Future<void> dispose() async {
    _debounceTimer?.cancel();
    await _connectivitySub.cancel();
    await _controller.close();
  }
}
```

- [ ] **Step 5: Run test to verify it passes**

Run: `flutter test test/services/connection_state_controller_test.dart`
Expected: All tests PASS.

- [ ] **Step 6: Commit**

```bash
git add pubspec.yaml pubspec.lock lib/service/connection_state_controller.dart test/services/connection_state_controller_test.dart
git commit -m "feat(chat): add ConnectionStateController with debounced offline state"
```

---

### Task 2: Heartbeat ping/pong on WebSocket services

**Files:**
- Modify: `lib/service/websocket_service.dart` (both `ChatListWebSocketService` and `ChatRoomWebSocketService` classes)
- Create: `test/services/websocket_heartbeat_test.dart`

- [ ] **Step 1: Write the failing test**

Create `test/services/websocket_heartbeat_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:app/service/websocket_service.dart';

void main() {
  group('WebSocket heartbeat', () {
    test('ChatListWebSocketService exposes pingInterval and pongTimeout', () {
      final svc = ChatListWebSocketService();
      expect(svc.pingInterval, const Duration(seconds: 25));
      expect(svc.pongTimeout, const Duration(seconds: 10));
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/services/websocket_heartbeat_test.dart`
Expected: FAIL — `pingInterval` getter not defined.

- [ ] **Step 3: Add heartbeat to `ChatListWebSocketService`**

In `lib/service/websocket_service.dart`, inside `ChatListWebSocketService`:

```dart
  static const Duration _pingInterval = Duration(seconds: 25);
  static const Duration _pongTimeout = Duration(seconds: 10);

  Duration get pingInterval => _pingInterval;
  Duration get pongTimeout => _pongTimeout;

  Timer? _pingTimer;
  Timer? _pongDeadline;

  void _startHeartbeat() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(_pingInterval, (_) {
      if (_channel == null) return;
      _channel!.sink.add(json.encode({'type': 'ping'}));
      _pongDeadline?.cancel();
      _pongDeadline = Timer(_pongTimeout, () {
        _isConnected = false;
        _channel?.sink.close();
      });
    });
  }

  void _onPong() {
    _pongDeadline?.cancel();
  }

  void _stopHeartbeat() {
    _pingTimer?.cancel();
    _pongDeadline?.cancel();
    _pingTimer = null;
    _pongDeadline = null;
  }
```

In the existing `_channel!.stream.listen(...)` handler, after `final message = json.decode(data);` add:

```dart
            if (message['type'] == 'pong') {
              _onPong();
              return;
            }
            if (message['type'] == 'connection_established') {
              _isConnected = true;
              _startHeartbeat();
            }
```

In `onDone:` and `onError:` blocks, add `_stopHeartbeat();`.

- [ ] **Step 4: Apply same heartbeat pattern to `ChatRoomWebSocketService`**

Repeat the same `_pingTimer`/`_pongDeadline` fields, `_startHeartbeat`/`_onPong`/`_stopHeartbeat` methods, and stream-handler updates in the `ChatRoomWebSocketService` class within the same file.

- [ ] **Step 5: Run test to verify it passes**

Run: `flutter test test/services/websocket_heartbeat_test.dart`
Expected: PASS.

- [ ] **Step 6: Commit**

```bash
git add lib/service/websocket_service.dart test/services/websocket_heartbeat_test.dart
git commit -m "feat(chat): add 25s heartbeat to chat WebSocket services"
```

---

### Task 3: Network-aware reconnect with extended backoff

**Files:**
- Modify: `lib/service/websocket_service.dart`
- Create: `test/services/websocket_reconnect_test.dart`

- [ ] **Step 1: Write the failing test**

Create `test/services/websocket_reconnect_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:app/service/websocket_service.dart';

void main() {
  group('Reconnect backoff', () {
    test('computeBackoff returns capped exponential delays', () {
      expect(ChatRoomWebSocketService.computeBackoff(0), const Duration(seconds: 2));
      expect(ChatRoomWebSocketService.computeBackoff(1), const Duration(seconds: 4));
      expect(ChatRoomWebSocketService.computeBackoff(2), const Duration(seconds: 8));
      expect(ChatRoomWebSocketService.computeBackoff(3), const Duration(seconds: 16));
      expect(ChatRoomWebSocketService.computeBackoff(4), const Duration(seconds: 30));
      expect(ChatRoomWebSocketService.computeBackoff(9), const Duration(seconds: 30));
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/services/websocket_reconnect_test.dart`
Expected: FAIL — `computeBackoff` not defined.

- [ ] **Step 3: Add backoff function + extend reconnect**

In both `ChatListWebSocketService` and `ChatRoomWebSocketService` in `lib/service/websocket_service.dart`, add:

```dart
  static const int maxReconnectAttempts = 10;

  static Duration computeBackoff(int attempt) {
    final seconds = (2 << attempt).clamp(2, 30);
    return Duration(seconds: seconds);
  }
```

Replace the existing 3-attempt reconnect logic to use `maxReconnectAttempts` and `computeBackoff(_reconnectAttempt)`.

- [ ] **Step 4: Add network-restore trigger**

Add a `Connectivity` listener in the connect method (or constructor) that calls reconnect when `ConnectivityResult.none` transitions to anything else:

```dart
import 'package:connectivity_plus/connectivity_plus.dart';

  StreamSubscription? _connectivitySub;

  void _watchNetwork() {
    _connectivitySub?.cancel();
    bool wasOffline = false;
    _connectivitySub = Connectivity().onConnectivityChanged.listen((result) {
      final isOffline = result.contains(ConnectivityResult.none);
      if (wasOffline && !isOffline && !isConnected) {
        _reconnectAttempt = 0;
        connectToChatList(); // or connectToChatRoom(roomId) in the room service
      }
      wasOffline = isOffline;
    });
  }
```

Call `_watchNetwork()` from the connect entry-point. Cancel the subscription in `dispose()`/`disconnect()`.

- [ ] **Step 5: Run test to verify it passes**

Run: `flutter test test/services/websocket_reconnect_test.dart`
Expected: PASS.

- [ ] **Step 6: Commit**

```bash
git add lib/service/websocket_service.dart test/services/websocket_reconnect_test.dart
git commit -m "feat(chat): extend WS reconnect to 10 attempts with capped backoff + network-restore trigger"
```

---

### Task 4: DisconnectBanner widget + integration

**Files:**
- Create: `lib/pages/chat/widgets/disconnect_banner.dart`
- Create: `test/widgets/chat/disconnect_banner_test.dart`
- Modify: `lib/pages/chat/chat_list.dart`
- Modify: `lib/pages/chat/chat_room.dart`

- [ ] **Step 1: Write the failing widget test**

Create `test/widgets/chat/disconnect_banner_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/pages/chat/widgets/disconnect_banner.dart';
import 'package:app/service/connection_state_controller.dart';

void main() {
  testWidgets('renders when offline, hides when online', (tester) async {
    final stream = StreamController<ConnectionState>();

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: DisconnectBanner(stateStream: stream.stream)),
    ));
    expect(find.text('Reconnecting…'), findsNothing);

    stream.add(ConnectionState.offline);
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('Reconnecting…'), findsOneWidget);

    stream.add(ConnectionState.online);
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('Reconnecting…'), findsNothing);

    await stream.close();
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/widgets/chat/disconnect_banner_test.dart`
Expected: FAIL — `DisconnectBanner` not defined.

- [ ] **Step 3: Implement the widget**

Create `lib/pages/chat/widgets/disconnect_banner.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:app/service/connection_state_controller.dart';

class DisconnectBanner extends StatelessWidget {
  const DisconnectBanner({super.key, required this.stateStream});

  final Stream<ConnectionState> stateStream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectionState>(
      stream: stateStream,
      initialData: ConnectionState.online,
      builder: (context, snapshot) {
        final visible = snapshot.data == ConnectionState.offline;
        return AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child: visible
              ? Container(
                  width: double.infinity,
                  color: Colors.orange.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text('Reconnecting…',
                          style: TextStyle(color: Colors.white, fontSize: 13)),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        );
      },
    );
  }
}
```

- [ ] **Step 4: Add a Riverpod provider for `ConnectionStateController`**

In `lib/providers/provider_root/chat_provider.dart`, near the existing providers:

```dart
import 'package:app/service/connection_state_controller.dart';

final connectionStateControllerProvider = Provider<ConnectionStateController>((ref) {
  final controller = ConnectionStateController();
  ref.onDispose(() => controller.dispose());
  return controller;
});
```

- [ ] **Step 5: Wire banner into chat list and chat room**

In `lib/pages/chat/chat_list.dart`, wrap the existing body in a Column with the banner above it:

```dart
import 'package:app/pages/chat/widgets/disconnect_banner.dart';

// in the build method, replacing the current body:
final connController = ref.watch(connectionStateControllerProvider);
return Scaffold(
  appBar: ...,
  body: Column(
    children: [
      DisconnectBanner(stateStream: connController.stream),
      Expanded(child: /* existing chat list body */),
    ],
  ),
);
```

Repeat in `lib/pages/chat/chat_room.dart` (place banner just below the AppBar, above the message list).

- [ ] **Step 6: Run test to verify it passes**

Run: `flutter test test/widgets/chat/disconnect_banner_test.dart`
Expected: PASS.

- [ ] **Step 7: Commit**

```bash
git add lib/pages/chat/widgets/disconnect_banner.dart lib/pages/chat/chat_list.dart lib/pages/chat/chat_room.dart lib/providers/provider_root/chat_provider.dart test/widgets/chat/disconnect_banner_test.dart
git commit -m "feat(chat): show debounced disconnect banner in chat list + room"
```

---

### Task 5: WebSocket auth migration (backend-coordinated)

**Files:**
- Modify: `lib/service/websocket_service.dart`

> **Prerequisite:** Backend must support `{"type":"auth","token":"..."}` as the first inbound message. Frontend supports BOTH old query-param and new first-message during rollout.

- [ ] **Step 1: Add a feature flag**

In `lib/service/websocket_service.dart`, near the top:

```dart
const bool kUseHeaderAuth = bool.fromEnvironment('USE_WS_HEADER_AUTH', defaultValue: true);
```

- [ ] **Step 2: Modify connect to send auth message OR fall back to query token**

In `ChatListWebSocketService.connectToChatList()` (and the matching method in `ChatRoomWebSocketService`), replace the URL construction:

```dart
      final uri = kUseHeaderAuth
          ? Uri.parse(wsUrl)
          : Uri.parse('$wsUrl?token=$token');
      _channel = WebSocketChannel.connect(uri);

      if (kUseHeaderAuth) {
        _channel!.sink.add(json.encode({'type': 'auth', 'token': token}));
      }
```

- [ ] **Step 3: Manual rollout test**

After backend deploys auth-message support, smoke-test:

```bash
flutter run --dart-define=USE_WS_HEADER_AUTH=true
```

Open chat — confirm `connection_established` arrives. Then test with `false` to confirm old path still works.

- [ ] **Step 4: Commit**

```bash
git add lib/service/websocket_service.dart
git commit -m "feat(chat): support first-message auth for WS, fall back to query token via flag"
```

---

## Phase 2 — Optimistic + offline send queue

### Task 6: Extend `ChatMessage` with localId + status

**Files:**
- Modify: `lib/providers/provider_models/message_model.dart` (`ChatMessage` class)
- Create: `test/providers/chat_message_test.dart`

- [ ] **Step 1: Write the failing test**

Create `test/providers/chat_message_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:app/providers/provider_models/message_model.dart';

void main() {
  group('ChatMessage status fields', () {
    test('defaults status to sent for messages with server id', () {
      final m = ChatMessage(
        id: 1,
        content: 'hi',
        sender: User(id: 1, username: 'a'),
        timestamp: DateTime.now(),
      );
      expect(m.status, MessageStatus.sent);
      expect(m.localId, isNull);
    });

    test('optimistic message carries localId and sending status', () {
      final m = ChatMessage(
        localId: 'local_abc',
        status: MessageStatus.sending,
        content: 'hi',
        sender: User(id: 1, username: 'a'),
        timestamp: DateTime.now(),
      );
      expect(m.localId, 'local_abc');
      expect(m.status, MessageStatus.sending);
      expect(m.id, isNull);
    });

    test('copyWith preserves localId when only status changes', () {
      final m = ChatMessage(
        localId: 'x',
        status: MessageStatus.sending,
        content: 'hi',
        sender: User(id: 1, username: 'a'),
        timestamp: DateTime.now(),
      );
      final updated = m.copyWith(status: MessageStatus.failed);
      expect(updated.localId, 'x');
      expect(updated.status, MessageStatus.failed);
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/providers/chat_message_test.dart`
Expected: FAIL — `MessageStatus`, `status`, `localId`, `copyWith` not defined.

- [ ] **Step 3: Implement model additions**

In `lib/providers/provider_models/message_model.dart`, add above `ChatMessage`:

```dart
enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
  failed;

  String toJson() => name;

  static MessageStatus fromJson(String? value) {
    switch (value) {
      case 'sending':
        return MessageStatus.sending;
      case 'failed':
        return MessageStatus.failed;
      case 'delivered':
        return MessageStatus.delivered;
      case 'read':
        return MessageStatus.read;
      case 'sent':
      default:
        return MessageStatus.sent;
    }
  }
}
```

In the `ChatMessage` constructor add fields and parameters:

```dart
  final String? localId;
  final MessageStatus status;
  final int attemptCount;

  ChatMessage({
    this.id,
    this.localId,
    this.status = MessageStatus.sent,
    this.attemptCount = 0,
    // ...existing params
  });
```

Add a `copyWith`:

```dart
  ChatMessage copyWith({
    int? id,
    String? localId,
    MessageStatus? status,
    int? attemptCount,
    String? content,
    bool? isRead,
    List<int>? readBy,
    bool? isEdited,
    bool? isDeleted,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      localId: localId ?? this.localId,
      status: status ?? this.status,
      attemptCount: attemptCount ?? this.attemptCount,
      messageType: messageType,
      content: content ?? this.content,
      file: file,
      fileUrl: fileUrl,
      duration: duration,
      sender: sender,
      timestamp: timestamp,
      updatedAt: updatedAt,
      isRead: isRead ?? this.isRead,
      readBy: readBy ?? this.readBy,
      isEdited: isEdited ?? this.isEdited,
      isDeleted: isDeleted ?? this.isDeleted,
      replyTo: replyTo,
      reactions: reactions,
    );
  }
```

Update `ChatMessage.fromJson` to read `local_id` and `status` if present (server echoes `local_id` per the backend dep).

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/providers/chat_message_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/providers/provider_models/message_model.dart test/providers/chat_message_test.dart
git commit -m "feat(chat): add localId, status, attemptCount to ChatMessage"
```

---

### Task 7: `MessageQueueService` with shared_preferences persistence

**Files:**
- Create: `lib/service/message_queue_service.dart`
- Create: `test/services/message_queue_service_test.dart`

- [ ] **Step 1: Write the failing test**

Create `test/services/message_queue_service_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/service/message_queue_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('MessageQueueService', () {
    test('enqueues and persists across instances', () async {
      final queue = MessageQueueService();
      await queue.load();
      await queue.enqueue(QueuedMessage(
        localId: 'a1',
        chatRoomId: 7,
        kind: QueueKind.text,
        payload: {'content': 'hi'},
        createdAt: DateTime(2026, 6, 14),
      ));
      expect(queue.pending.length, 1);

      final queue2 = MessageQueueService();
      await queue2.load();
      expect(queue2.pending.length, 1);
      expect(queue2.pending.first.localId, 'a1');
    });

    test('markFailed increments attempts and marks failed at limit', () async {
      final queue = MessageQueueService();
      await queue.load();
      await queue.enqueue(QueuedMessage(
        localId: 'a1',
        chatRoomId: 7,
        kind: QueueKind.text,
        payload: {'content': 'hi'},
        createdAt: DateTime(2026, 6, 14),
      ));

      await queue.markFailed('a1');
      expect(queue.pending.first.attempts, 1);
      await queue.markFailed('a1');
      await queue.markFailed('a1');

      expect(queue.pending.first.status, QueueStatus.failed);
      expect(queue.pending.first.attempts, 3);
    });

    test('remove drops entry by localId', () async {
      final queue = MessageQueueService();
      await queue.load();
      await queue.enqueue(QueuedMessage(
        localId: 'a1',
        chatRoomId: 7,
        kind: QueueKind.text,
        payload: {'content': 'hi'},
        createdAt: DateTime(2026, 6, 14),
      ));
      await queue.remove('a1');
      expect(queue.pending, isEmpty);
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/services/message_queue_service_test.dart`
Expected: FAIL — class not defined.

- [ ] **Step 3: Implement the queue**

Create `lib/service/message_queue_service.dart`:

```dart
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

enum QueueKind { text, image, voice }

enum QueueStatus { pending, failed }

class QueuedMessage {
  QueuedMessage({
    required this.localId,
    required this.chatRoomId,
    required this.kind,
    required this.payload,
    required this.createdAt,
    this.attempts = 0,
    this.status = QueueStatus.pending,
  });

  final String localId;
  final int chatRoomId;
  final QueueKind kind;
  final Map<String, dynamic> payload;
  final DateTime createdAt;
  int attempts;
  QueueStatus status;

  Map<String, dynamic> toJson() => {
        'local_id': localId,
        'chat_room_id': chatRoomId,
        'kind': kind.name,
        'payload': payload,
        'created_at': createdAt.toIso8601String(),
        'attempts': attempts,
        'status': status.name,
      };

  factory QueuedMessage.fromJson(Map<String, dynamic> j) => QueuedMessage(
        localId: j['local_id'] as String,
        chatRoomId: j['chat_room_id'] as int,
        kind: QueueKind.values.byName(j['kind'] as String),
        payload: Map<String, dynamic>.from(j['payload'] as Map),
        createdAt: DateTime.parse(j['created_at'] as String),
        attempts: j['attempts'] as int? ?? 0,
        status: QueueStatus.values.byName(j['status'] as String? ?? 'pending'),
      );
}

class MessageQueueService {
  static const String _prefsKey = 'chat_message_queue_v1';
  static const int maxAttempts = 3;

  final List<QueuedMessage> _pending = [];
  final StreamController<List<QueuedMessage>> _controller =
      StreamController.broadcast();

  List<QueuedMessage> get pending => List.unmodifiable(_pending);
  Stream<List<QueuedMessage>> get changes => _controller.stream;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    _pending.clear();
    if (raw == null) return;
    final list = (json.decode(raw) as List).cast<Map<String, dynamic>>();
    _pending.addAll(list.map(QueuedMessage.fromJson));
    _controller.add(pending);
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _prefsKey, json.encode(_pending.map((e) => e.toJson()).toList()));
    _controller.add(pending);
  }

  Future<void> enqueue(QueuedMessage m) async {
    _pending.add(m);
    await _persist();
  }

  Future<void> remove(String localId) async {
    _pending.removeWhere((m) => m.localId == localId);
    await _persist();
  }

  Future<void> markFailed(String localId) async {
    final idx = _pending.indexWhere((m) => m.localId == localId);
    if (idx < 0) return;
    final m = _pending[idx];
    m.attempts += 1;
    if (m.attempts >= maxAttempts) {
      m.status = QueueStatus.failed;
    }
    await _persist();
  }

  Future<void> dispose() async {
    await _controller.close();
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/services/message_queue_service_test.dart`
Expected: PASS (3 tests).

- [ ] **Step 5: Commit**

```bash
git add lib/service/message_queue_service.dart test/services/message_queue_service_test.dart
git commit -m "feat(chat): add MessageQueueService with shared_preferences persistence"
```

---

### Task 8: Wire queue into `ChatNotifier` send flow

**Files:**
- Modify: `lib/providers/provider_root/chat_provider.dart`
- Modify: `lib/service/chat_api_service.dart` (add localId to send request)

- [ ] **Step 1: Add provider and inject queue**

In `chat_provider.dart`:

```dart
import 'package:app/service/message_queue_service.dart';

final messageQueueServiceProvider = Provider<MessageQueueService>((ref) {
  final svc = MessageQueueService();
  // load on first read
  svc.load();
  ref.onDispose(() => svc.dispose());
  return svc;
});
```

- [ ] **Step 2: Refactor send flow to use optimistic + queue**

Find the existing `sendMessage` method in `ChatNotifier`. Replace its body to:

1. Generate `localId` (`'local_${DateTime.now().microsecondsSinceEpoch}_${chatRoomId}'`).
2. Build optimistic `ChatMessage` with `status: MessageStatus.sending`, `localId`, no `id`.
3. Append to `state.messages`.
4. Enqueue in `MessageQueueService`.
5. Call `chatApiService.sendMessage(..., localId: localId)`.
6. On success: server response includes `local_id` — find optimistic by `localId`, replace with server message. Remove from queue.
7. On failure: call `queue.markFailed(localId)`. Update optimistic message status to `failed` if `attempts >= maxAttempts`.

Concrete shape:

```dart
  Future<void> sendMessage(int chatRoomId, String content) async {
    final localId = 'local_${DateTime.now().microsecondsSinceEpoch}_$chatRoomId';
    final me = _currentUser; // however ChatNotifier already gets user
    final optimistic = ChatMessage(
      localId: localId,
      status: MessageStatus.sending,
      content: content,
      sender: me,
      timestamp: DateTime.now(),
    );

    _safeUpdateState(state.copyWith(messages: [...state.messages, optimistic]));

    final queue = _ref.read(messageQueueServiceProvider);
    await queue.enqueue(QueuedMessage(
      localId: localId,
      chatRoomId: chatRoomId,
      kind: QueueKind.text,
      payload: {'content': content},
      createdAt: DateTime.now(),
    ));

    try {
      final server = await chatApiService.sendMessage(
        chatRoomId: chatRoomId,
        content: content,
        localId: localId,
      );
      _reconcileOptimistic(localId, server);
      await queue.remove(localId);
    } catch (_) {
      await queue.markFailed(localId);
      _markOptimisticFailed(localId);
    }
  }

  void _reconcileOptimistic(String localId, ChatMessage server) {
    final messages = state.messages.map((m) {
      if (m.localId == localId) {
        return server.copyWith(localId: localId, status: MessageStatus.sent);
      }
      return m;
    }).toList();
    _safeUpdateState(state.copyWith(messages: messages));
  }

  void _markOptimisticFailed(String localId) {
    final messages = state.messages.map((m) {
      if (m.localId == localId) {
        return m.copyWith(status: MessageStatus.failed, attemptCount: m.attemptCount + 1);
      }
      return m;
    }).toList();
    _safeUpdateState(state.copyWith(messages: messages));
  }
```

- [ ] **Step 3: Update `chatApiService.sendMessage` signature**

In `lib/service/chat_api_service.dart`, add `String? localId` to the send method signature and include `'local_id': localId` in the POST body. Update the response parser to read `local_id` back from the server message.

- [ ] **Step 4: Manual test**

```bash
flutter run
```

Send a message — confirm it appears immediately (sending) and transitions to sent. Throttle network to airplane mode (developer tools), send a message — confirm it shows sending then failed after retries.

- [ ] **Step 5: Commit**

```bash
git add lib/providers/provider_root/chat_provider.dart lib/service/chat_api_service.dart
git commit -m "feat(chat): optimistic send with localId reconciliation + queue persistence"
```

---

### Task 9: Drain queue on reconnect + connectivity restore

**Files:**
- Modify: `lib/providers/provider_root/chat_provider.dart`

- [ ] **Step 1: Add a drain method to `ChatNotifier`**

```dart
  Future<void> _drainQueue() async {
    final queue = _ref.read(messageQueueServiceProvider);
    final pending = queue.pending
        .where((m) => m.status == QueueStatus.pending)
        .toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    for (final m in pending) {
      try {
        final server = await chatApiService.sendMessage(
          chatRoomId: m.chatRoomId,
          content: m.payload['content'] as String,
          localId: m.localId,
        );
        _reconcileOptimistic(m.localId, server);
        await queue.remove(m.localId);
      } catch (_) {
        await queue.markFailed(m.localId);
      }
    }
  }
```

- [ ] **Step 2: Trigger drain on WS reconnect**

In the notifier where WS `connection_established` events are handled, call `_drainQueue()`.

- [ ] **Step 3: Trigger drain on connectivity restore**

In the notifier's init, subscribe to `ref.read(connectionStateControllerProvider).stream` and call `_drainQueue()` when transitioning back to `online`.

```dart
  void _watchConnection() {
    final conn = _ref.read(connectionStateControllerProvider);
    _connectionSub = conn.stream.listen((state) {
      if (state == ConnectionState.online) {
        _drainQueue();
      }
    });
  }
```

- [ ] **Step 4: Manual test**

Send 2 messages in airplane mode (both go to failed via retry exhaustion). Toggle airplane mode off. Tap retry on each (next task) OR confirm `_drainQueue` re-attempts pending entries.

- [ ] **Step 5: Commit**

```bash
git add lib/providers/provider_root/chat_provider.dart
git commit -m "feat(chat): drain message queue on WS reconnect + connectivity restore"
```

---

### Task 10: Retry button + failed-state UI in `message_bubble.dart`

**Files:**
- Modify: `lib/pages/chat/widgets/message_bubble.dart`
- Create: `test/widgets/chat/message_bubble_status_test.dart`

- [ ] **Step 1: Write the failing widget test**

Create `test/widgets/chat/message_bubble_status_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/pages/chat/widgets/message_bubble.dart';
import 'package:app/providers/provider_models/message_model.dart';

void main() {
  testWidgets('shows retry button when status is failed', (tester) async {
    final msg = ChatMessage(
      localId: 'x',
      status: MessageStatus.failed,
      content: 'oops',
      sender: User(id: 1, username: 'me'),
      timestamp: DateTime.now(),
    );

    var retried = false;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: MessageBubble(
          message: msg,
          isMine: true,
          onRetry: () => retried = true,
        ),
      ),
    ));

    expect(find.byIcon(Icons.refresh), findsOneWidget);
    await tester.tap(find.byIcon(Icons.refresh));
    expect(retried, isTrue);
  });

  testWidgets('shows spinner when status is sending', (tester) async {
    final msg = ChatMessage(
      localId: 'x',
      status: MessageStatus.sending,
      content: 'hi',
      sender: User(id: 1, username: 'me'),
      timestamp: DateTime.now(),
    );

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: MessageBubble(message: msg, isMine: true)),
    ));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/widgets/chat/message_bubble_status_test.dart`
Expected: FAIL — `onRetry` and status indicators not present.

- [ ] **Step 3: Add status indicators to `MessageBubble`**

In `lib/pages/chat/widgets/message_bubble.dart`, add an `onRetry` callback to the widget constructor and render a small status indicator next to the timestamp:

```dart
  final VoidCallback? onRetry;

  Widget _buildStatusIndicator() {
    switch (message.status) {
      case MessageStatus.sending:
        return const SizedBox(
          width: 12, height: 12,
          child: CircularProgressIndicator(strokeWidth: 1.5),
        );
      case MessageStatus.failed:
        return IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: const Icon(Icons.refresh, size: 16, color: Colors.red),
          onPressed: onRetry,
        );
      case MessageStatus.sent:
      case MessageStatus.delivered:
        return const Icon(Icons.check, size: 14, color: Colors.grey);
      case MessageStatus.read:
        return const Icon(Icons.done_all, size: 14, color: Colors.blue);
    }
  }
```

Insert `_buildStatusIndicator()` in the row that contains the timestamp (after timestamp text, only for `isMine`).

- [ ] **Step 4: Wire up `onRetry` in `chat_room.dart`**

In `lib/pages/chat/chat_room.dart`, where `MessageBubble` is constructed, pass:

```dart
onRetry: msg.status == MessageStatus.failed
    ? () => ref.read(chatNotifierProvider.notifier).retryMessage(msg.localId!)
    : null,
```

Add `retryMessage` to `ChatNotifier`:

```dart
  Future<void> retryMessage(String localId) async {
    final queue = _ref.read(messageQueueServiceProvider);
    final entry = queue.pending.firstWhere((m) => m.localId == localId);
    // reset attempts and re-attempt
    entry.attempts = 0;
    entry.status = QueueStatus.pending;
    _markOptimisticRetrying(localId);
    await _drainQueue();
  }

  void _markOptimisticRetrying(String localId) {
    final messages = state.messages.map((m) {
      if (m.localId == localId) return m.copyWith(status: MessageStatus.sending);
      return m;
    }).toList();
    _safeUpdateState(state.copyWith(messages: messages));
  }
```

- [ ] **Step 5: Run test to verify it passes**

Run: `flutter test test/widgets/chat/message_bubble_status_test.dart`
Expected: PASS.

- [ ] **Step 6: Commit**

```bash
git add lib/pages/chat/widgets/message_bubble.dart lib/pages/chat/chat_room.dart lib/providers/provider_root/chat_provider.dart test/widgets/chat/message_bubble_status_test.dart
git commit -m "feat(chat): show send-status icons and retry button on failed messages"
```

---

## Phase 3 — Listing card in chat thread

### Task 11: Add `productId` + `ProductSnapshot` to `ChatRoom`

**Files:**
- Modify: `lib/providers/provider_models/message_model.dart` (add `ProductSnapshot` + `ChatRoom.productSnapshot`)
- Create: `test/providers/chat_room_product_test.dart`

> **Prerequisite:** Confirm backend returns `product` (or `product_id`) on chat room JSON. If only `product_id`, fetch product separately for snapshot.

- [ ] **Step 1: Write the failing test**

Create `test/providers/chat_room_product_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:app/providers/provider_models/message_model.dart';

void main() {
  test('ChatRoom.fromJson parses product snapshot', () {
    final json = {
      'id': 1,
      'name': 'chat',
      'participants': [],
      'is_group': false,
      'product': {
        'id': 42,
        'title': 'Vintage chair',
        'price': '15000',
        'currency': 'UZS',
        'thumbnail_url': 'https://example.com/c.jpg',
        'status': 'available',
      },
    };
    final room = ChatRoom.fromJson(json);
    expect(room.productSnapshot, isNotNull);
    expect(room.productSnapshot!.id, 42);
    expect(room.productSnapshot!.title, 'Vintage chair');
    expect(room.productSnapshot!.status, ProductStatus.available);
  });

  test('ChatRoom.fromJson tolerates absent product (general DM)', () {
    final json = {'id': 1, 'name': 'chat', 'participants': [], 'is_group': false};
    final room = ChatRoom.fromJson(json);
    expect(room.productSnapshot, isNull);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/providers/chat_room_product_test.dart`
Expected: FAIL.

- [ ] **Step 3: Add `ProductSnapshot` + field**

In `message_model.dart`:

```dart
enum ProductStatus { available, reserved, sold;
  static ProductStatus fromJson(String? v) {
    switch (v) {
      case 'reserved': return ProductStatus.reserved;
      case 'sold': return ProductStatus.sold;
      default: return ProductStatus.available;
    }
  }
}

class ProductSnapshot {
  ProductSnapshot({
    required this.id,
    required this.title,
    required this.price,
    required this.currency,
    required this.status,
    this.thumbnailUrl,
  });

  final int id;
  final String title;
  final String price;
  final String currency;
  final ProductStatus status;
  final String? thumbnailUrl;

  factory ProductSnapshot.fromJson(Map<String, dynamic> j) => ProductSnapshot(
        id: j['id'] as int,
        title: j['title'] as String? ?? '',
        price: (j['price'] ?? '').toString(),
        currency: j['currency'] as String? ?? '',
        thumbnailUrl: j['thumbnail_url'] as String?,
        status: ProductStatus.fromJson(j['status'] as String?),
      );
}
```

Add `final ProductSnapshot? productSnapshot;` to `ChatRoom`, thread it through the constructor and `fromJson` (read `json['product']` if present).

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/providers/chat_room_product_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/providers/provider_models/message_model.dart test/providers/chat_room_product_test.dart
git commit -m "feat(chat): parse product snapshot on ChatRoom"
```

---

### Task 12: `ListingHeaderCard` widget

**Files:**
- Create: `lib/pages/chat/widgets/listing_header_card.dart`
- Create: `test/widgets/chat/listing_header_card_test.dart`

- [ ] **Step 1: Write the failing widget test**

Create `test/widgets/chat/listing_header_card_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/pages/chat/widgets/listing_header_card.dart';
import 'package:app/providers/provider_models/message_model.dart';

void main() {
  testWidgets('renders title, price and Sold badge', (tester) async {
    final snap = ProductSnapshot(
      id: 1,
      title: 'Vintage chair',
      price: '15000',
      currency: 'UZS',
      status: ProductStatus.sold,
    );

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: ListingHeaderCard(product: snap, onTap: () {})),
    ));

    expect(find.text('Vintage chair'), findsOneWidget);
    expect(find.textContaining('15000'), findsOneWidget);
    expect(find.text('Sold'), findsOneWidget);
  });

  testWidgets('omits Sold badge for available', (tester) async {
    final snap = ProductSnapshot(
      id: 1, title: 't', price: '1', currency: 'UZS',
      status: ProductStatus.available,
    );
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: ListingHeaderCard(product: snap, onTap: () {})),
    ));
    expect(find.text('Sold'), findsNothing);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/widgets/chat/listing_header_card_test.dart`
Expected: FAIL — class not defined.

- [ ] **Step 3: Implement the widget**

Create `lib/pages/chat/widgets/listing_header_card.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:app/providers/provider_models/message_model.dart';

class ListingHeaderCard extends StatelessWidget {
  const ListingHeaderCard({super.key, required this.product, required this.onTap});

  final ProductSnapshot product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              if (product.thumbnailUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: CachedNetworkImage(
                    imageUrl: product.thumbnailUrl!,
                    width: 48, height: 48, fit: BoxFit.cover,
                  ),
                )
              else
                Container(width: 48, height: 48, color: Colors.grey.shade300),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text('${product.price} ${product.currency}',
                        style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                  ],
                ),
              ),
              if (product.status != ProductStatus.available)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: product.status == ProductStatus.sold
                        ? Colors.red.shade100
                        : Colors.amber.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    product.status == ProductStatus.sold ? 'Sold' : 'Reserved',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: product.status == ProductStatus.sold
                          ? Colors.red.shade900
                          : Colors.amber.shade900,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/widgets/chat/listing_header_card_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/pages/chat/widgets/listing_header_card.dart test/widgets/chat/listing_header_card_test.dart
git commit -m "feat(chat): add ListingHeaderCard with Sold/Reserved badges"
```

---

### Task 13: Integrate header card into `chat_room.dart`

**Files:**
- Modify: `lib/pages/chat/chat_room.dart`

- [ ] **Step 1: Place the card under the AppBar, above the message list**

In `chat_room.dart`, inside the Scaffold body:

```dart
import 'package:app/pages/chat/widgets/listing_header_card.dart';
import 'package:go_router/go_router.dart';

// where chatRoom is available:
final product = chatRoom.productSnapshot;

return Column(
  children: [
    DisconnectBanner(stateStream: connController.stream),
    if (product != null)
      ListingHeaderCard(
        product: product,
        onTap: () => context.go('/products/${product.id}'),
      ),
    Expanded(child: /* existing message list */),
    /* existing input area */
  ],
);
```

- [ ] **Step 2: Manual test**

Run the app, open a product chat — confirm header shows. Open a non-product DM — confirm no header. Open a sold product chat — confirm "Sold" badge.

- [ ] **Step 3: Commit**

```bash
git add lib/pages/chat/chat_room.dart
git commit -m "feat(chat): show listing header card at top of product chats"
```

---

## Phase 4 — Translation

### Task 14: Add translation fields to `ChatMessage`

**Files:**
- Modify: `lib/providers/provider_models/message_model.dart`
- Create: `test/providers/chat_message_translation_test.dart`

- [ ] **Step 1: Write the failing test**

Create `test/providers/chat_message_translation_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:app/providers/provider_models/message_model.dart';

void main() {
  test('ChatMessage has translation fields, default null', () {
    final m = ChatMessage(
      id: 1, content: 'hi',
      sender: User(id: 1, username: 'a'),
      timestamp: DateTime.now(),
    );
    expect(m.translatedText, isNull);
    expect(m.translationLanguage, isNull);
    expect(m.translationProvider, isNull);
    expect(m.detectedLanguage, isNull);
  });

  test('copyWith sets translation fields', () {
    final m = ChatMessage(
      id: 1, content: '안녕',
      sender: User(id: 1, username: 'a'),
      timestamp: DateTime.now(),
    );
    final t = m.copyWith(
      translatedText: 'hello',
      translationLanguage: 'en',
      translationProvider: 'google',
      detectedLanguage: 'ko',
    );
    expect(t.translatedText, 'hello');
    expect(t.detectedLanguage, 'ko');
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/providers/chat_message_translation_test.dart`
Expected: FAIL.

- [ ] **Step 3: Extend `ChatMessage`**

Add to `ChatMessage`:

```dart
  final String? translatedText;
  final String? translationLanguage;
  final String? translationProvider;
  final String? detectedLanguage;
```

Add to constructor params (optional, default null). Extend `copyWith` to accept these four fields. Update `fromJson` to read `detected_language` from server response if present.

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/providers/chat_message_translation_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/providers/provider_models/message_model.dart test/providers/chat_message_translation_test.dart
git commit -m "feat(chat): add translation fields to ChatMessage"
```

---

### Task 15: `MessageTranslationService` with session cache

**Files:**
- Create: `lib/service/message_translation_service.dart`
- Create: `test/services/message_translation_service_test.dart`
- Modify: `lib/service/chat_api_service.dart` (add `translateMessage` REST call)

- [ ] **Step 1: Write the failing test**

Create `test/services/message_translation_service_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:app/service/message_translation_service.dart';

class _FakeApi implements TranslationApi {
  int calls = 0;
  @override
  Future<TranslationResult> translate(int messageId, String target) async {
    calls += 1;
    return TranslationResult(
      translatedText: 'hello',
      provider: 'google',
      detectedLanguage: 'ko',
    );
  }
}

void main() {
  test('caches translation per message+target within session', () async {
    final api = _FakeApi();
    final svc = MessageTranslationService(api: api);
    final a = await svc.translate(1, 'en');
    final b = await svc.translate(1, 'en');
    expect(a.translatedText, 'hello');
    expect(b.translatedText, 'hello');
    expect(api.calls, 1);
  });

  test('does not cache across target languages', () async {
    final api = _FakeApi();
    final svc = MessageTranslationService(api: api);
    await svc.translate(1, 'en');
    await svc.translate(1, 'ja');
    expect(api.calls, 2);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/services/message_translation_service_test.dart`
Expected: FAIL.

- [ ] **Step 3: Implement the service**

Create `lib/service/message_translation_service.dart`:

```dart
class TranslationResult {
  TranslationResult({
    required this.translatedText,
    required this.provider,
    required this.detectedLanguage,
  });
  final String translatedText;
  final String provider;
  final String detectedLanguage;
}

abstract class TranslationApi {
  Future<TranslationResult> translate(int messageId, String target);
}

class MessageTranslationService {
  MessageTranslationService({required this.api});
  final TranslationApi api;
  final Map<String, TranslationResult> _cache = {};

  String _key(int id, String target) => '$id:$target';

  Future<TranslationResult> translate(int messageId, String target) async {
    final k = _key(messageId, target);
    final hit = _cache[k];
    if (hit != null) return hit;
    final result = await api.translate(messageId, target);
    _cache[k] = result;
    return result;
  }

  void clearRoom(int chatRoomId) {
    // session-scoped, cleared on dispose of chat room provider — see chat_provider.dart
    _cache.clear();
  }
}
```

- [ ] **Step 4: Implement the REST call**

In `lib/service/chat_api_service.dart`, add a `translateMessage` method calling `POST /messages/{id}/translate?target=<locale>` and returning a `TranslationResult`. Wire `ChatApiService` to also implement `TranslationApi`.

- [ ] **Step 5: Run test to verify it passes**

Run: `flutter test test/services/message_translation_service_test.dart`
Expected: PASS.

- [ ] **Step 6: Commit**

```bash
git add lib/service/message_translation_service.dart lib/service/chat_api_service.dart test/services/message_translation_service_test.dart
git commit -m "feat(chat): add MessageTranslationService with per-session cache"
```

---

### Task 16: Translation toggle in `message_bubble.dart`

**Files:**
- Modify: `lib/pages/chat/widgets/message_bubble.dart`
- Modify: `lib/pages/chat/chat_room.dart`
- Modify: `lib/providers/provider_root/chat_provider.dart`

- [ ] **Step 1: Add provider for translation service**

In `chat_provider.dart`:

```dart
final messageTranslationServiceProvider = Provider<MessageTranslationService>((ref) {
  final api = ref.read(chatApiServiceProvider); // existing provider
  return MessageTranslationService(api: api);
});
```

- [ ] **Step 2: Add `onTranslate` callback to `MessageBubble`**

In `MessageBubble`, add `final Future<void> Function()? onTranslate;` and a small "Translate" affordance — a `TextButton.icon` below the message text, only shown if `message.detectedLanguage != null && message.detectedLanguage != userLocale && message.translatedText == null`.

When `translatedText != null`, render it under the original message text in a lighter color with a small "via Google" / `translationProvider` footnote and a "Hide" button to clear it.

- [ ] **Step 3: Wire `onTranslate` in chat_room.dart**

```dart
onTranslate: () => ref.read(chatNotifierProvider.notifier).translateMessage(msg.id!),
```

Add to `ChatNotifier`:

```dart
  Future<void> translateMessage(int messageId) async {
    final svc = _ref.read(messageTranslationServiceProvider);
    final locale = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    try {
      final result = await svc.translate(messageId, locale);
      _applyTranslation(messageId, result, locale);
    } catch (_) {
      // Task 22 adds the translationFailed flag + retry UI.
      // For now, swallow — user can retry by tapping Translate again.
    }
  }

  void _applyTranslation(int messageId, TranslationResult r, String target) {
    final messages = state.messages.map((m) {
      if (m.id == messageId) {
        return m.copyWith(
          translatedText: r.translatedText,
          translationLanguage: target,
          translationProvider: r.provider,
          detectedLanguage: r.detectedLanguage,
        );
      }
      return m;
    }).toList();
    _safeUpdateState(state.copyWith(messages: messages));
  }
```

- [ ] **Step 4: Manual test**

Open a chat with messages in a language different from device locale. Tap Translate on a message — confirm translation appears inline.

- [ ] **Step 5: Commit**

```bash
git add lib/pages/chat/widgets/message_bubble.dart lib/pages/chat/chat_room.dart lib/providers/provider_root/chat_provider.dart
git commit -m "feat(chat): inline translation toggle on message bubbles"
```

---

### Task 17: "Auto-translate to my language" preference

**Files:**
- Create: `lib/pages/chat/widgets/chat_settings_sheet.dart`
- Modify: `lib/pages/chat/chat_room.dart` (open sheet from AppBar overflow)
- Modify: `lib/providers/provider_root/chat_provider.dart` (eager translate when ON)

- [ ] **Step 1: Persist the preference**

Use `shared_preferences` key `chat_auto_translate_<userId>`. Add a small read/write helper in `chat_provider.dart`:

```dart
final autoTranslateProvider = StateNotifierProvider<AutoTranslateNotifier, bool>(
  (ref) => AutoTranslateNotifier(),
);

class AutoTranslateNotifier extends StateNotifier<bool> {
  AutoTranslateNotifier() : super(false) {
    _load();
  }
  static const _key = 'chat_auto_translate';
  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool(_key) ?? false;
  }
  Future<void> toggle(bool v) async {
    state = v;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, v);
  }
}
```

- [ ] **Step 2: Add `ChatSettingsSheet` with the toggle**

Create `lib/pages/chat/widgets/chat_settings_sheet.dart` — a simple `Consumer` widget with a `SwitchListTile` bound to `autoTranslateProvider`. Label: "Auto-translate to my language". Subtitle: warning about API cost.

- [ ] **Step 3: Open sheet from chat room AppBar overflow menu**

In `chat_room.dart`, in the existing PopupMenuButton add an item "Chat settings" → opens `showModalBottomSheet(builder: (_) => const ChatSettingsSheet())`.

- [ ] **Step 4: Eager translate on inbound message when ON**

In the WS message handler in `ChatNotifier`, after appending the new message, check `ref.read(autoTranslateProvider)`. If true and `detectedLanguage != device locale`, call `translateMessage(msg.id)`.

- [ ] **Step 5: Manual test**

Toggle on, send self a foreign-language test message via another account. Confirm it arrives pre-translated. Toggle off, confirm translations stop happening eagerly.

- [ ] **Step 6: Commit**

```bash
git add lib/pages/chat/widgets/chat_settings_sheet.dart lib/pages/chat/chat_room.dart lib/providers/provider_root/chat_provider.dart
git commit -m "feat(chat): add per-user auto-translate preference (default OFF)"
```

---

## Phase 5 — Search + mute/archive + polish

### Task 18: `MessageSearchBar` widget + local filter

**Files:**
- Create: `lib/pages/chat/widgets/message_search_bar.dart`
- Modify: `lib/pages/chat/widgets/chat_app_bar.dart` (add search icon)
- Modify: `lib/pages/chat/chat_room.dart` (toggle search, filter messages)

- [ ] **Step 1: Add `searchQuery` to chat state**

In `ChatState`, add `final String chatRoomSearchQuery;` (default `''`). Add a setter on `ChatNotifier`:

```dart
  void setRoomSearchQuery(String q) {
    _safeUpdateState(state.copyWith(chatRoomSearchQuery: q));
  }
```

- [ ] **Step 2: Build the search bar widget**

Create `lib/pages/chat/widgets/message_search_bar.dart`:

```dart
import 'package:flutter/material.dart';

class MessageSearchBar extends StatelessWidget {
  const MessageSearchBar({super.key, required this.onChanged, required this.onClose});
  final ValueChanged<String> onChanged;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: TextField(
          autofocus: true,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: 'Search messages…',
            isDense: true,
            border: InputBorder.none,
            suffixIcon: IconButton(icon: const Icon(Icons.close), onPressed: onClose),
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 3: Add search toggle in `chat_app_bar.dart`**

Add a search `IconButton` that flips a local `bool _searching` state. When true, replace the AppBar title with `MessageSearchBar` and call `setRoomSearchQuery`.

- [ ] **Step 4: Filter messages by query**

In `chat_room.dart`, where the message list is built:

```dart
final query = state.chatRoomSearchQuery.toLowerCase();
final visible = query.isEmpty
    ? state.messages
    : state.messages.where((m) =>
        (m.content ?? '').toLowerCase().contains(query) ||
        (m.translatedText ?? '').toLowerCase().contains(query)).toList();
```

- [ ] **Step 5: Manual test**

Open chat, tap search, type a substring — confirm only matching messages render.

- [ ] **Step 6: Commit**

```bash
git add lib/pages/chat/widgets/message_search_bar.dart lib/pages/chat/widgets/chat_app_bar.dart lib/pages/chat/chat_room.dart lib/providers/provider_root/chat_provider.dart
git commit -m "feat(chat): in-room message search with local filter"
```

---

### Task 19: Server-side search fallback for older messages

**Files:**
- Modify: `lib/service/chat_api_service.dart` (add `searchMessages` endpoint call)
- Modify: `lib/providers/provider_root/chat_provider.dart` (escalate to server when no local hit)

> **Prerequisite:** Backend endpoint `GET /chats/{id}/messages?q=...&before=<ts>` must be available. If not, skip this task and document the local-only limit in the README.

- [ ] **Step 1: Add API method**

```dart
  Future<List<ChatMessage>> searchMessages(int chatRoomId, String q) async {
    final resp = await _client.get(Uri.parse('$baseUrl/chats/$chatRoomId/messages?q=$q'));
    if (resp.statusCode != 200) throw Exception('search failed');
    final list = (json.decode(resp.body) as List).cast<Map<String, dynamic>>();
    return list.map(ChatMessage.fromJson).toList();
  }
```

- [ ] **Step 2: Escalate on no-local-hit, debounced 400ms**

In `ChatNotifier.setRoomSearchQuery`:

```dart
  Timer? _searchDebounce;

  void setRoomSearchQuery(String q) {
    _safeUpdateState(state.copyWith(chatRoomSearchQuery: q));
    _searchDebounce?.cancel();
    if (q.isEmpty) return;
    _searchDebounce = Timer(const Duration(milliseconds: 400), () async {
      final localHits = state.messages.where((m) =>
        (m.content ?? '').toLowerCase().contains(q.toLowerCase())).isNotEmpty;
      if (localHits) return;
      try {
        final older = await chatApiService.searchMessages(state.activeChatRoomId!, q);
        // prepend older messages without duplicates (by id)
        final existingIds = state.messages.map((m) => m.id).toSet();
        final merged = [
          ...older.where((m) => !existingIds.contains(m.id)),
          ...state.messages,
        ];
        _safeUpdateState(state.copyWith(messages: merged));
      } catch (_) { /* swallow */ }
    });
  }
```

- [ ] **Step 3: Manual test**

Search for a word from a much-older message that hasn't been paginated in yet — confirm server returns hits and they merge into the list.

- [ ] **Step 4: Commit**

```bash
git add lib/service/chat_api_service.dart lib/providers/provider_root/chat_provider.dart
git commit -m "feat(chat): server-side search fallback for older messages"
```

---

### Task 20: Mute / archive (local) + swipe actions

**Files:**
- Create: `lib/service/chat_local_prefs_service.dart`
- Modify: `lib/pages/chat/chat_list.dart`
- Modify: `lib/providers/provider_root/chat_provider.dart`

- [ ] **Step 1: Create the local prefs service**

```dart
import 'package:shared_preferences/shared_preferences.dart';

class ChatLocalPrefsService {
  static const _mutedKey = 'chat_muted_rooms_v1';
  static const _archivedKey = 'chat_archived_rooms_v1';

  Future<Set<int>> _readSet(String key) async {
    final p = await SharedPreferences.getInstance();
    return (p.getStringList(key) ?? const []).map(int.parse).toSet();
  }

  Future<void> _writeSet(String key, Set<int> ids) async {
    final p = await SharedPreferences.getInstance();
    await p.setStringList(key, ids.map((e) => e.toString()).toList());
  }

  Future<Set<int>> mutedRooms() => _readSet(_mutedKey);
  Future<Set<int>> archivedRooms() => _readSet(_archivedKey);

  Future<void> setMuted(int roomId, bool muted) async {
    final ids = await mutedRooms();
    muted ? ids.add(roomId) : ids.remove(roomId);
    await _writeSet(_mutedKey, ids);
  }

  Future<void> setArchived(int roomId, bool archived) async {
    final ids = await archivedRooms();
    archived ? ids.add(roomId) : ids.remove(roomId);
    await _writeSet(_archivedKey, ids);
  }
}
```

- [ ] **Step 2: Expose via Riverpod + augment chat list state**

Add `Set<int> mutedRoomIds` and `Set<int> archivedRoomIds` to `ChatState`. Load both on chat list init. Add notifier methods `toggleMute(int id)` and `toggleArchive(int id)`.

- [ ] **Step 3: Extend swipe-action menu in `chat_list.dart`**

In the existing `Dismissible`/`Slidable` swipe action menu for each chat row, add:

```dart
SlidableAction(
  icon: state.mutedRoomIds.contains(room.id) ? Icons.volume_up : Icons.volume_off,
  label: state.mutedRoomIds.contains(room.id) ? 'Unmute' : 'Mute',
  onPressed: (_) => ref.read(chatNotifierProvider.notifier).toggleMute(room.id),
),
SlidableAction(
  icon: state.archivedRoomIds.contains(room.id) ? Icons.unarchive : Icons.archive,
  label: state.archivedRoomIds.contains(room.id) ? 'Unarchive' : 'Archive',
  onPressed: (_) => ref.read(chatNotifierProvider.notifier).toggleArchive(room.id),
),
```

Show a small mute icon next to muted rooms' titles.

- [ ] **Step 4: Suppress in-app notifications for muted rooms**

Where the chat list shows the unread count badge: if `room.id` is in `mutedRoomIds`, hide the badge. Where in-app FCM banners are surfaced (foreground handler in `push_notification_service.dart`), skip showing for muted room IDs.

- [ ] **Step 5: Manual test**

Mute a chat → confirm badge hidden, in-app banner suppressed. Background FCM still arrives (expected limitation).

- [ ] **Step 6: Commit**

```bash
git add lib/service/chat_local_prefs_service.dart lib/pages/chat/chat_list.dart lib/providers/provider_root/chat_provider.dart
git commit -m "feat(chat): local mute and archive with swipe actions"
```

---

### Task 21: Archived chat list tab

**Files:**
- Modify: `lib/pages/chat/chat_list.dart`

- [ ] **Step 1: Add a two-tab layout**

Wrap the chat list body in a `DefaultTabController(length: 2)` with `TabBar` (`All`, `Archived`). Filter the visible chat-room list per tab:

```dart
final visible = state.allChatRooms.where((r) {
  final isArchived = state.archivedRoomIds.contains(r.id);
  return isCurrentTab == 0 ? !isArchived : isArchived;
}).toList();
```

- [ ] **Step 2: Add empty state for archived tab**

If `archivedRoomIds.isEmpty && currentTab == 1`, render `Center(child: Text('No archived chats'))`.

- [ ] **Step 3: Manual test**

Archive a chat → confirm it moves out of "All" and into "Archived". New message arrives in archived chat → confirm it stays in archived tab (does not auto-unarchive). Unread badge still bumps.

- [ ] **Step 4: Commit**

```bash
git add lib/pages/chat/chat_list.dart
git commit -m "feat(chat): split chat list into All/Archived tabs"
```

---

## Final sweep

### Task 22: Translation-error inline state

**Files:**
- Modify: `lib/pages/chat/widgets/message_bubble.dart`
- Modify: `lib/providers/provider_root/chat_provider.dart`

- [ ] **Step 1: Add per-message translation error flag**

Add `final bool translationFailed;` to `ChatMessage` (default false). Extend `copyWith` to accept it. In `ChatNotifier.translateMessage`, replace the `catch` block to call a new `_applyTranslationError(messageId)` that maps the message via `copyWith(translationFailed: true)` and updates state.

- [ ] **Step 2: Render error + retry**

In `message_bubble.dart`, if `translationFailed`, show small red text "Couldn't translate, tap to retry" with `onTap → onTranslate()`.

- [ ] **Step 3: Commit**

```bash
git add lib/providers/provider_models/message_model.dart lib/pages/chat/widgets/message_bubble.dart
git commit -m "feat(chat): show inline retry for failed translations"
```

---

## Manual test matrix (run before merge)

- [ ] Airplane mode → send 3 messages → restore network → all arrive in order
- [ ] Force-kill app while message is in flight → reopen → queue drains
- [ ] Translate a Korean message while device locale is Uzbek → translation renders
- [ ] Open chat for a sold listing → header shows "Sold" badge
- [ ] Archive a chat → new message arrives → unread badge bumps in archived tab
- [ ] Mute a chat → in-app banner suppressed, badge hidden
- [ ] Search older message that's not paginated in → server returns + merges
- [ ] WS auth fails → reconnect attempts respect backoff, banner shows after 3s
- [ ] Toggle auto-translate ON → inbound foreign-language messages translate eagerly
- [ ] Network drop in chat room → banner appears 3s after WS loss, clears on reconnect

## Integration test

**Files:**
- Create: `test/integration/chat_offline_send_test.dart`

A scripted integration test that:
1. Mocks `chatApiService.sendMessage` to throw `SocketException`.
2. Calls `notifier.sendMessage(roomId, 'a')`, `sendMessage(roomId, 'b')`, `sendMessage(roomId, 'c')`.
3. Asserts queue has 3 entries, all `sending`, after retry exhaustion all `failed`.
4. Swaps mock to return server messages with echoed `local_id`.
5. Triggers `connectionStateController.setSocketConnected(true)`.
6. Asserts queue is empty and `state.messages` has 3 server-canonical messages in original send order.

Run: `flutter test test/integration/chat_offline_send_test.dart`

Commit:

```bash
git add test/integration/chat_offline_send_test.dart
git commit -m "test(chat): offline send + reconnect drains queue in order"
```

---

## Done criteria

- All tasks have green tests
- Manual test matrix runs clean on iOS sim + Android emulator
- No regressions in existing chat behavior (reactions, replies, edits, voice, image)
- Backend dependencies #1-#5 deployed and verified
- `flutter analyze` clean
- Spec deviation (`shared_preferences` for queue, `connectivity_plus` added) noted in PR description
