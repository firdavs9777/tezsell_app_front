// lib/service/connection_state_controller.dart
//
// Tracks the effective chat-connection state by combining two independent
// signals:
//   1. Device network reachability, via `connectivity_plus`.
//   2. The chat WebSocket's own up/down status, reported by the socket
//      services via [setSocketState].
//
// `connectivity_plus` 7.x's `onConnectivityChanged` emits
// `Stream<List<ConnectivityResult>>` (a list, since a device can have more
// than one active interface). We're offline only when every result in the
// list is `ConnectivityResult.none`.
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

/// Effective chat-connection state as seen by the UI.
enum ConnState {
  /// Network reachable and the chat WebSocket is up.
  connected,

  /// Network reachable but the chat WebSocket has not (yet) reported
  /// `connection_established` — e.g. mid-reconnect.
  connecting,

  /// Device has no reachable network interface.
  offline,
}

/// Singleton-ish controller: use [ConnectionStateController.instance].
/// Socket services call [setSocketState] on connect/disconnect/error;
/// this class independently watches device connectivity and combines both
/// into a single [ConnState] stream plus a debounced [shouldShowBanner]
/// stream for UI.
class ConnectionStateController {
  ConnectionStateController._internal() {
    _connectivitySub =
        Connectivity().onConnectivityChanged.listen(_onConnectivityChanged);
  }

  static final ConnectionStateController instance =
      ConnectionStateController._internal();

  final StreamController<ConnState> _stateController =
      StreamController<ConnState>.broadcast();
  final StreamController<bool> _bannerController =
      StreamController<bool>.broadcast();

  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;
  Timer? _bannerTimer;

  ConnState _current = ConnState.connecting;
  bool _socketUp = false;
  bool _networkUp = true;
  bool _bannerShown = false;

  /// Emits whenever the effective connection state changes.
  Stream<ConnState> get stream => _stateController.stream;

  /// Current effective connection state.
  ConnState get current => _current;

  /// Emits `true` only after the connection has been continuously
  /// non-[ConnState.connected] for 3 seconds; emits `false` immediately
  /// upon reconnecting.
  Stream<bool> get shouldShowBanner => _bannerController.stream;

  /// Called by socket services (chat list / chat room) to report whether
  /// the underlying WebSocket is currently up.
  void setSocketState(bool up) {
    if (_socketUp == up) return;
    _socketUp = up;
    _recompute();
  }

  void _onConnectivityChanged(List<ConnectivityResult> results) {
    final networkUp = results.any((r) => r != ConnectivityResult.none);
    if (_networkUp == networkUp) return;
    _networkUp = networkUp;
    _recompute();
  }

  void _recompute() {
    final next = !_networkUp
        ? ConnState.offline
        : (_socketUp ? ConnState.connected : ConnState.connecting);

    if (next != _current) {
      _current = next;
      _stateController.add(_current);
    }
    _updateBannerTimer();
  }

  void _updateBannerTimer() {
    if (_current == ConnState.connected) {
      _bannerTimer?.cancel();
      _bannerTimer = null;
      if (_bannerShown) {
        _bannerShown = false;
        _bannerController.add(false);
      }
      return;
    }

    // Already counting down or already shown — nothing to do.
    if (_bannerTimer != null || _bannerShown) return;

    _bannerTimer = Timer(const Duration(seconds: 3), () {
      _bannerTimer = null;
      if (_current != ConnState.connected) {
        _bannerShown = true;
        _bannerController.add(true);
      }
    });
  }

  void dispose() {
    _connectivitySub?.cancel();
    _bannerTimer?.cancel();
    _stateController.close();
    _bannerController.close();
  }
}
