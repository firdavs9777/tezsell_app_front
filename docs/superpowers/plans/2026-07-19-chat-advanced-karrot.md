# Plan A — Karrot-Style Advanced Chat Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Listing-anchored (Karrot-style) chat with seller transaction actions, a reliability core (optimistic send/offline outbox/ticks), and a rich messenger layer (reply, edit, delete, reactions, forward, pin, voice, translation, search, mute/archive, typing/presence) at BananaTalk polish level.

**Architecture:** Extend the existing Django `chat` app (models already carry `delivery_status`, `reply_to`, `reactions`, `is_edited/is_deleted`, `TypingIndicator`, `UserPresence`) and the existing Flutter Riverpod `ChatNotifier` + split list/room WebSocket services. No rewrites — additive fields, endpoints, WS events, and widgets.

**Tech Stack:** Django 4 + DRF + Channels (daphne), pytest; Flutter + Riverpod + go_router, `web_socket_channel`, `shared_preferences`; new Flutter deps: `connectivity_plus`, `record`, `audioplayers`.

**Spec:** `docs/superpowers/specs/2026-07-19-chat-advanced-karrot-design.md` (supersedes the 2026-06-14 chat plan — do NOT execute that one).

## Global Constraints

- **Two repos.** Backend: `/Users/firdavsmutalipov/Desktop/tezsell-app` (branch `feat/chat-advanced-backend`). Flutter: `/Users/firdavsmutalipov/Desktop/Sabzi_Market/app` (branch `feat/chat-advanced`). Never mix commits.
- **Chat URLs are mounted at `chats/`** (`myproject/urls.py`: `path('chats/', include('chat.urls'))`), and `chat/urls.py` paths have NO extra `api/` prefix — e.g. message list is `/chats/<chat_id>/messages/`. New endpoints follow the same style.
- **Strict listing origin:** new rooms require a listing (product|service|property). Legacy rooms (all listing fields null) stay readable. `StartChatWithUserView`/`GetOrCreateDirectChatView` are closed to non-staff after Task 2.
- **Edit window: 15 minutes**, sender-only, blocked when deleted. Delete: `for_me` (per-user hide) | `for_everyone` (sender-only; content blanked).
- **Reactions: one emoji per user per message** (replace on change), stored in the existing `Message.reactions` JSONField shape `{"👍": [user_id, ...]}`.
- **Transaction actions: product rooms only.** Actions `reserve|sold|available`, seller-only. `sold` additionally emits a review-CTA system message.
- **`local_id`:** client-generated uuid string ≤64 chars; backend persists + echoes it on ack/broadcast; duplicate (room, local_id) send must NOT create a second message — return the existing one.
- **i18n:** every new user-facing string in `lib/l10n/app_en.arb` + `app_ru.arb` + `app_uz.arb`, accessed via `AppLocalizations`; generated `lib/l10n/app_localizations*.dart` are git-tracked — commit them after `flutter gen-l10n`.
- **Auth (Flutter):** SharedPreferences key `'token'`, header `Authorization: Token <token>` (NOT `auth_token`).
- **Out of scope:** polls, stickers, GIFs, corrections, self-destruct, themes, bookmarks, group chats, call changes, forwarding to external apps, E2E, cursor pagination.
- Commit after every task with targeted `git add` (the Flutter repo may carry unrelated WIP — never `git add -A`).
- TDD on backend: every endpoint/WS change gets pytest coverage in `chat/tests/` (create the package if `chat/tests.py` is a single file — keep the existing file importable or migrate it; implementer verifies). Flutter: model/unit tests where logic is pure; UI tasks gate on `flutter analyze` (zero issues on touched files).

## File Structure

**Backend (`tezsell-app`)** — all inside the existing `chat/` app unless noted:
- `chat/models.py` — ChatRoom listing FKs; Message new fields; new `RoomState`, `QuickReplyTemplate`, `MessageTranslation` models.
- `chat/serializers.py` — listing summary on room serializer; message serializer additions.
- `chat/views.py` — new `StartChatFromListingView`, `RoomTransactionView`, `MessagePinView`, `MessageForwardView`, `RoomStateView`, `QuickReplyView`, `MessageTranslateView`; extend `ChatMessageDetailView` (edit window / delete modes), `MessageReactionView` (one-per-user).
- `chat/urls.py` — new routes.
- `chat/consumer.py` — local_id echo/dedup, typing/presence broadcast, new event types, push gating.
- `products/models.py` — `is_reserved`.
- `chat/tests/` — one test module per task.

**Flutter (`app`)**:
- `lib/providers/provider_models/message_model.dart` + chat room model — field additions.
- `lib/service/chat_api_service.dart`, `lib/service/websocket_service.dart`, `lib/providers/provider_root/chat_provider.dart` — reliability + new actions.
- `lib/service/connection_state_controller.dart`, `lib/service/message_outbox_service.dart` — new.
- `lib/pages/chat/` — `chat_list.dart`, `chat_room.dart`, `widgets/*` extended; new widgets: `listing_card.dart`, `quick_chips.dart`, `message_actions_sheet.dart`, `reply_preview_bar.dart`, `reaction_chips.dart`, `pinned_messages_bar.dart`, `voice_recorder_bar.dart`, `voice_bubble.dart`, `forward_picker_sheet.dart`, `chat_search_bar.dart`, `media_gallery_screen.dart`, `quick_replies_panel.dart`.
- `lib/pages/products/product_detail.dart`, `lib/pages/service/details/*`, `lib/pages/real_estate/real_estate_detail.dart` — "Chat with seller" buttons.
- `lib/l10n/app_{en,ru,uz}.arb` — new keys.

---

## PHASE 1 — Backend

### Task 1: ChatRoom listing linkage + listing summary

**Files:**
- Modify: `chat/models.py` (ChatRoom), `chat/serializers.py` (ChatRoomSerializer)
- Test: `chat/tests/test_listing_linkage.py`

**Interfaces:**
- Produces: `ChatRoom.product|service|property` (nullable FKs, `on_delete=SET_NULL`), `ChatRoom.listing_type` (`CharField(choices=[('product','Product'),('service','Service'),('property','Property')], max_length=10, null=True, blank=True, db_index=True)`; serializer field `listing` → `{type, id, title, price, currency, image_url, status}` or `null` for legacy rooms. `status`: `'sold'` if product.is_sold else `'reserved'` if product.is_reserved else `'available'`; `null` for service/property. (`is_reserved` arrives in Task 4 — until then compute status treating missing attr as False via `getattr`.)

- [ ] **Step 1: Write failing tests** — room with product FK serializes `listing.type=='product'`, `listing.title`, `listing.status=='available'`; legacy room serializes `listing is None`; room with service FK gives `price=None`-safe summary. Use existing model factories/fixtures style from `chat/tests.py`/`conftest.py`.
- [ ] **Step 2: Add model fields** to `ChatRoom`:

```python
    listing_type = models.CharField(
        max_length=10, null=True, blank=True, db_index=True,
        choices=[('product', 'Product'), ('service', 'Service'), ('property', 'Property')],
    )
    product = models.ForeignKey('products.Product', null=True, blank=True,
                                on_delete=models.SET_NULL, related_name='chat_rooms')
    service = models.ForeignKey('services.Service', null=True, blank=True,
                                on_delete=models.SET_NULL, related_name='chat_rooms')
    property = models.ForeignKey('real_estate.Property', null=True, blank=True,
                                 on_delete=models.SET_NULL, related_name='chat_rooms')
```

- [ ] **Step 3: `makemigrations chat`**, run tests → model part passes.
- [ ] **Step 4: Serializer** — add `listing = serializers.SerializerMethodField()` to `ChatRoomSerializer.fields`; implement `get_listing` returning the summary dict (first image via the listing's `images` related manager; title from `name`/`title` per model — Product uses `title`, Service uses `name`, Property uses `title`; implementer verifies field names in the three models and uses the real ones).
- [ ] **Step 5: Run tests → pass. Commit** `feat(chat): listing linkage on ChatRoom + listing summary serializer`.

### Task 2: Start-chat-from-listing endpoint; close listing-less creation

**Files:**
- Modify: `chat/views.py`, `chat/urls.py`
- Test: `chat/tests/test_start_from_listing.py`

**Interfaces:**
- Produces: `POST /chats/start-from-listing/` body `{listing_type: 'product'|'service'|'property', listing_id: int}` → 200 `{room: <ChatRoomSerializer>, created: bool}`. Create-or-get keyed on (requester, owner, listing). 400 if requester is the listing owner (self-chat) or listing missing/inactive. Owner derived per type: Product.userName / Service.userName / Property.owner (implementer verifies exact FK names — Product owner FK is `userName`).
- `StartChatWithUserView` and `GetOrCreateDirectChatView` return 403 for non-staff (`request.user.is_staff` exempt for admin tooling).

- [ ] **Step 1: Failing tests** — start from product creates room with FKs + participants {buyer, seller} + `created=True`; second call returns same room `created=False`; self-chat 400; `StartChatWithUserView` now 403 for regular user.
- [ ] **Step 2: Implement `StartChatFromListingView(APIView)`** — resolve listing by type/id, owner FK, `ChatRoom.objects.filter(listing_type=..., <type>_id=..., participants=requester).filter(participants=owner)` get-or-create (wrap creation in `transaction.atomic()`), set room `name` to the listing title, add both participants.
- [ ] **Step 3: Route** `path('start-from-listing/', StartChatFromListingView.as_view(), name='start-from-listing')` BEFORE `<int:pk>/`.
- [ ] **Step 4: Gate the two legacy views** — first line of `post`/`get`: `if not request.user.is_staff: return Response({'detail': 'Chats must start from a listing.'}, status=403)`.
- [ ] **Step 5: Tests pass. Commit** `feat(chat): start-from-listing endpoint; require listing origin`.

### Task 3: Message model additions

**Files:**
- Modify: `chat/models.py` (Message), `chat/serializers.py` (MessageSerializer)
- Test: `chat/tests/test_message_fields.py`

**Interfaces:**
- Produces on `Message`: `local_id = CharField(max_length=64, null=True, blank=True, db_index=True)`; `metadata = JSONField(default=dict, blank=True)`; `is_forwarded = BooleanField(default=False)`; `forwarded_from = FK('self', null=True, blank=True, on_delete=SET_NULL, related_name='forwards')`; `is_pinned = BooleanField(default=False)`; `pinned_at = DateTimeField(null=True, blank=True)`; `pinned_by = FK(User, null=True, blank=True, on_delete=SET_NULL, related_name='pinned_messages')`; `deleted_for = ManyToManyField(User, related_name='deleted_messages', blank=True)`. All serialized read-only except `local_id` and `metadata` (writable on create only).

- [ ] **Step 1: Failing tests** — create message with local_id + waveform metadata roundtrips; serializer exposes the new fields; `deleted_for.add(user)` then filter excludes it for that user (`Message.objects.exclude(deleted_for=user)`).
- [ ] **Step 2: Add fields, `makemigrations chat`.**
- [ ] **Step 3: Serializer additions** + ensure `ChatMessageView.get` excludes messages `deleted_for=request.user` and blanks content for `is_deleted` ones (`content` → `''`, add `"deleted": true` via existing `is_deleted` field — verify current GET behavior and adjust).
- [ ] **Step 4: Tests pass. Commit** `feat(chat): message local_id/metadata/forward/pin/deleted_for fields`.

### Task 4: Reserved status + transaction endpoint

**Files:**
- Modify: `products/models.py`, `chat/views.py`, `chat/urls.py`
- Test: `chat/tests/test_transaction.py`

**Interfaces:**
- Produces: `Product.is_reserved = BooleanField(default=False, db_index=True)`. `POST /chats/<int:chat_id>/transaction/` body `{action: 'reserve'|'sold'|'available'}` — seller-only (403 otherwise), product rooms only (400 otherwise). Effects: reserve → `is_reserved=True, is_sold=False`; sold → `is_sold=True, is_reserved=False`; available → both False. Creates a `system` Message in the room with `metadata={'transaction': action}`; on `sold` a second system message with `metadata={'review_cta': True, 'product_id': <id>}`. Both broadcast via channel layer to the room group (same group naming the consumer already uses — implementer reads `chat/consumer.py` to reuse the exact `group_send` shape used for new messages).

- [ ] **Step 1: Failing tests** — seller reserve 200 + product flag + system message with metadata; buyer attempt 403; non-product room 400; sold creates review CTA message.
- [ ] **Step 2: Add `is_reserved`, `makemigrations products`.**
- [ ] **Step 3: Implement `RoomTransactionView`** (wrap product update + system messages in `transaction.atomic()`; after commit, `async_to_sync(channel_layer.group_send)` the new messages + a `transaction_updated` event with the new listing status).
- [ ] **Step 4: Route, tests pass. Commit** `feat(chat): product reserve/sold transaction actions with system messages`.

### Task 5: Edit window / delete modes / reactions dedup / pin / forward

**Files:**
- Modify: `chat/views.py` (`ChatMessageDetailView`, `MessageReactionView`), `chat/urls.py`
- Test: `chat/tests/test_message_actions.py`

**Interfaces:**
- Edit (`PUT .../messages/<id>/`): sender-only, ≤15 min from `timestamp` (403 `{'detail': 'Edit window expired.'}` after), rejected if `is_deleted`. Sets `is_edited=True`.
- Delete (`DELETE .../messages/<id>/?mode=for_me|for_everyone`, default `for_me`): `for_me` → add requester to `deleted_for` (any participant); `for_everyone` → sender-only, sets `is_deleted=True`, blanks `content`, clears `file`.
- Reactions (`POST .../messages/<id>/reaction/` `{emoji}`): one emoji per user — remove the user's id from every other emoji list first; posting the SAME emoji again removes it (toggle). Response returns the updated `reactions` dict.
- New: `POST /chats/<int:chat_id>/messages/<int:message_id>/pin/` (toggle; any participant; sets/clears `is_pinned/pinned_at/pinned_by`) and `POST /chats/<int:chat_id>/messages/<int:message_id>/forward/` `{target_room_id}` → creates a copy in target room (requester must be participant of both) with `is_forwarded=True, forwarded_from=<original>`, content/file/type copied. Returns the new message.

- [ ] **Step 1: Failing tests** for all five behaviors (edit inside/outside window via `freezegun` or manual `timestamp` override; delete both modes; reaction replace + toggle; pin toggle; forward copies content and links original).
- [ ] **Step 2: Extend/implement views** (read the existing `ChatMessageDetailView.put/delete` and `MessageReactionView.post` first; modify minimally to meet the contract, preserving existing WS notify calls).
- [ ] **Step 3: Routes for pin/forward. Tests pass. Commit** `feat(chat): edit window, delete modes, reaction dedup, pin, forward`.

### Task 6: RoomState (mute/archive/pin) + QuickReplyTemplate

**Files:**
- Modify: `chat/models.py`, `chat/views.py`, `chat/urls.py`, `chat/serializers.py`
- Test: `chat/tests/test_room_state.py`

**Interfaces:**
- `RoomState`: FKs `room`, `user` (unique_together), `is_muted=False`, `muted_until=DateTimeField(null=True)`, `is_archived=False`, `is_pinned=False`, `updated_at`.
- `QuickReplyTemplate`: FK `user`, `text=CharField(200)`, `order=IntegerField(default=0)`, timestamps.
- `POST /chats/<int:chat_id>/state/` body any of `{is_muted, muted_until, is_archived, is_pinned}` → upsert own RoomState; `ChatRoomSerializer` gains `state` (own RoomState or defaults) — pass `request` in context.
- `GET/POST /chats/quick-replies/`, `DELETE /chats/quick-replies/<int:pk>/` — own templates only.
- Room list ordering: pinned rooms first, then `-updated_at`; archived rooms EXCLUDED from default list, included with `?archived=1`.

- [ ] **Step 1: Failing tests** — mute upsert + serializer shows state; archived room absent from default list, present with `?archived=1`; pinned sorts first; quick-reply CRUD scoped to owner.
- [ ] **Step 2: Models + migrations; Step 3: views/routes/serializer + `ChatListView.get` ordering/filter changes; Step 4: tests pass. Commit** `feat(chat): per-user room state (mute/archive/pin) and quick replies`.

### Task 7: Message translation endpoint

**Files:**
- Modify: `chat/models.py`, `chat/views.py`, `chat/urls.py`
- Test: `chat/tests/test_translation.py`

**Interfaces:**
- `MessageTranslation`: FK `message` (related_name `translations`), `target_language=CharField(8)`, `translated_text=TextField()`, `provider=CharField(20, default='google')`, `created_at`; unique_together (message, target_language).
- `POST /chats/messages/<int:message_id>/translate/` `{target: 'en'|'ru'|'uz'|...}` → cached translation if exists, else call Google Translate v2 REST (`https://translation.googleapis.com/language/translate/v2`, key from `settings.GOOGLE_TRANSLATE_API_KEY` / env `GOOGLE_TRANSLATE_API_KEY`); no key configured → 503 `{'detail': 'Translation not configured.'}`. Requester must be room participant. Empty/`is_deleted` message → 400.

- [ ] **Step 1: Failing tests** — cached path returns without HTTP (pre-create a MessageTranslation); no-key path → 503; non-participant → 403. Mock `requests.post` for the live path test.
- [ ] **Step 2: Model + migration; view with `requests` call (10s timeout, surface 502 on provider error); route. Tests pass. Commit** `feat(chat): per-message translation with caching`.

### Task 8: WS consumer upgrades + push gating

**Files:**
- Modify: `chat/consumer.py`, `chat/utils.py` (or wherever push sending lives — implementer locates the FCM call used on new messages)
- Test: `chat/tests/test_consumer.py` (use `channels.testing.WebsocketCommunicator`)

**Interfaces:**
- Send path accepts `local_id` and echoes it in the ack to sender AND in the `new_message` broadcast. Duplicate (room, local_id) within existing messages → return the existing message in the ack, create nothing.
- New client→server events on the room consumer: `typing_start`/`typing_stop` → broadcast `{type:'typing', user_id, is_typing}` to others; server tracks nothing durable (TypingIndicator model optional — do not add DB writes on every keystroke).
- Presence: on room-socket connect/disconnect update `UserPresence` (`is_online`, `last_seen`) and broadcast `{type:'presence', user_id, is_online, last_seen}` to the room group.
- Server→client events added: `message_edited`, `message_deleted` (mode), `reaction_updated` (message_id, reactions), `message_pinned` (message_id, is_pinned), `transaction_updated` (listing status) — emitted from the Task 4/5 views via `group_send`; consumer handler methods relay them.
- Push gating: before FCM send on new message — skip if recipient has RoomState `is_muted` (and `muted_until` unexpired) for that room; skip if recipient currently has a live room-socket connection for that room (track connected user ids per room in a class-level registry or channel-layer group presence — implementer picks the simplest reliable mechanism given single-process daphne deploy, documents the limitation for multi-process).

- [ ] **Step 1: Failing consumer tests** — connect/auth (reuse existing test patterns from `chat/testchat.py`/`tests.py` if present), send with local_id → ack echoes it; duplicate send → same message id; typing broadcast reaches second communicator; presence broadcast on disconnect.
- [ ] **Step 2: Implement consumer changes; Step 3: wire view-side `group_send` for the five relay events (adjust Tasks 4/5 code where marked); Step 4: push gating with tests (mock FCM).**
- [ ] **Step 5: Full `chat/tests/` suite green. Commit** `feat(chat): ws local_id echo/dedup, typing, presence, relay events, push gating`.

## PHASE 2 — Flutter foundation

### Task 9: Dependencies + i18n strings

**Files:**
- Modify: `pubspec.yaml`, `lib/l10n/app_en.arb`, `app_ru.arb`, `app_uz.arb` (+ commit regenerated `lib/l10n/app_localizations*.dart`)

**Interfaces:**
- Produces deps: `connectivity_plus: ^6.0.0`, `record: ^5.0.0`, `audioplayers: ^6.0.0` (resolve exact compatible versions with `flutter pub add`).
- Produces `AppLocalizations` getters (all three locales, EN values shown; RU/UZ translated naturally):
  `chatWithSeller` "Chat with seller"; `chatQuickAvailable` "Is this still available?"; `chatQuickPrice` "Can you lower the price?"; `chatQuickMeet` "Where can we meet?"; `chatReserve` "Reserve"; `chatMarkSold` "Mark as sold"; `chatMarkAvailable` "Back to available"; `chatStatusReserved` "Reserved"; `chatStatusSold` "Sold"; `chatStatusAvailable` "Available"; `chatSysReserved` "Seller marked this item as reserved"; `chatSysSold` "Seller marked this item as sold"; `chatSysAvailable` "This item is available again"; `chatLeaveReview` "Leave a review"; `chatReply` "Reply"; `chatEdit` "Edit"; `chatEdited` "edited"; `chatDelete` "Delete"; `chatDeleteForMe` "Delete for me"; `chatDeleteForEveryone` "Delete for everyone"; `chatMessageDeleted` "Message deleted"; `chatCopy` "Copy"; `chatCopied` "Copied"; `chatForward` "Forward"; `chatForwarded` "Forwarded"; `chatForwardTo` "Forward to…"; `chatPin` "Pin"; `chatUnpin` "Unpin"; `chatPinnedMessages` "Pinned messages"; `chatTranslate` "Translate"; `chatTranslationFailed` "Translation unavailable"; `chatShowOriginal` "Show original"; `chatSearchInChat` "Search in chat"; `chatNoResults` "No results"; `chatMute` "Mute"; `chatUnmute` "Unmute"; `chatArchive` "Archive"; `chatUnarchive` "Unarchive"; `chatArchived` "Archived"; `chatPinChat` "Pin chat"; `chatUnpinChat` "Unpin chat"; `chatTyping` "typing…"; `chatOnline` "online"; `chatLastSeen` "last seen {time}" (placeholder); `chatConnecting` "Reconnecting…"; `chatSendFailed` "Not sent. Tap to retry"; `chatVoiceMessage` "Voice message"; `chatRecordingHint` "Release to send, slide to cancel"; `chatQuickReplies` "Quick replies"; `chatAddQuickReply` "Add quick reply"; `chatMediaGallery` "Media"; `chatUnreadDivider` "Unread messages"; `chatDraft` "Draft"; `chatSelfChatError` "You can't chat about your own listing".
  (Follow each arb file's existing conventions; `@`-metadata in en only; `chatLastSeen` uses an ICU placeholder `{time}`.)

- [ ] **Step 1:** `flutter pub add connectivity_plus record audioplayers` → builds.
- [ ] **Step 2:** Add all keys to the three arbs; `flutter gen-l10n`; verify getters exist; `flutter analyze` unchanged-clean.
- [ ] **Step 3: Commit** (pubspec + lock + arbs + generated l10n) `feat(chat): deps and i18n strings for advanced chat`.

### Task 10: Dart model extensions

**Files:**
- Modify: `lib/providers/provider_models/message_model.dart` (and the chat-room model class it contains or its sibling — implementer locates `ChatRoom`/`ChatMessage` classes actually used by `chat_provider.dart`)
- Test: `test/chat_models_test.dart`

**Interfaces:**
- `ChatMessage` gains: `localId`, `metadata` (Map), `isForwarded`, `forwardedFromId`, `isPinned`, `reactions` (Map<String, List<int>>), `replyToId`+`replyPreview` (parse nested reply object if serializer nests it — verify), `isEdited`, `isDeleted`, `deliveryStatus` enum (sending/sent/delivered/read/failed) with an additional client-only `queued` state, `translation` (String?, client-side cache of fetched translation).
- `ChatRoom` gains: `listing` object (`ChatListing {type, id, title, price, currency, imageUrl, status}` — nullable) and `state` (`RoomState {isMuted, isArchived, isPinned}` with defaults).
- All `fromJson` null-safe with defaults; `copyWith` extended.

- [ ] **Step 1: Failing tests** — fromJson parses listing summary, reactions map, local_id echo, state defaults when absent.
- [ ] **Step 2: Implement; tests pass; analyze clean. Commit** `feat(chat): model fields for listing anchor and rich messaging`.

### Task 11: Reliability core

**Files:**
- Create: `lib/service/connection_state_controller.dart`, `lib/service/message_outbox_service.dart`
- Modify: `lib/service/websocket_service.dart`, `lib/providers/provider_root/chat_provider.dart`, `lib/pages/chat/chat_room.dart` (send path + bubble status), `lib/widgets/` reconnect banner widget
- Test: `test/message_outbox_test.dart`

**Interfaces:**
- `ConnectionStateController`: exposes `Stream<ConnState>` (connected/connecting/offline) fed by socket callbacks + `connectivity_plus`; `shouldShowBanner` only after 3s continuous non-connected (debounce timer).
- `MessageOutboxService`: `enqueue(OutboxEntry)`, `pendingFor(roomId)`, `remove(localId)`, persisted as JSON list under SP key `chat_outbox_v1`; `OutboxEntry {localId, roomId, content, type, filePath?, createdAt, attempts}`.
- Send path: generate `localId` (uuid v4 via existing `uuid` dep or timestamp+random), append optimistic bubble (status sending), send via WS with `local_id`; ack with matching `local_id` → replace optimistic with server message; timeout 10s or socket down → status failed + enqueue; on reconnect drain outbox (attempts+1, give up→failed after 5). Incoming `new_message` with a `local_id` already shown → replace, never duplicate.
- Ticks in bubble: sending=clock icon, sent=✓, delivered=✓✓, read=✓✓ primary-colored, failed=error icon tap-to-retry.

- [ ] **Step 1: Failing outbox tests** (pure Dart: enqueue/persist/restore/drain order/dedup by localId — mock SharedPreferences with `SharedPreferences.setMockInitialValues`).
- [ ] **Step 2: Implement services; Step 3: wire provider/send path + banner + ticks; Step 4: tests + analyze. Commit** `feat(chat): optimistic send, offline outbox, connection banner, ticks`.

### Task 12: Listing-anchor UI + entry points

**Files:**
- Create: `lib/pages/chat/widgets/listing_card.dart`, `lib/pages/chat/widgets/quick_chips.dart`
- Modify: `lib/pages/chat/chat_list.dart` (row listing thumbnail+price; remove user-list entry point), `lib/pages/chat/chat_room.dart` (pinned card + chips), `lib/service/chat_api_service.dart` (`startFromListing`), product/service/property detail pages ("Chat with seller" button)
- Test: analyze + existing tests

**Interfaces:**
- `chat_api_service.startFromListing({required String listingType, required int listingId}) → Future<ChatRoom>` (POST `/chats/start-from-listing/`).
- Listing card: 64px thumbnail, title (1 line), price+currency, status chip (Available=green/Reserved=amber/Sold=grey, l10n), tap → push the listing's detail route (`/product/:id` etc.). Renders only when `room.listing != null`.
- Quick chips: horizontal chips above input shown when `room.listing != null` && current user != seller && user's own messages in room < 2; tap sends chip text as normal message.
- Detail pages: primary "💬 Chat with seller" button (hidden on own listings) → `startFromListing` → navigate to room. Self-chat 400 → snackbar `chatSelfChatError`.
- `chat_list.dart`: rows show listing thumbnail (fallback: avatar) + title + price under participant name; REMOVE the FAB/action that opened `user_list.dart` (file stays, route dead — deleting the route is fine if nothing else references it).

- [ ] Steps: implement widgets → wire room screen → wire list rows + remove entry → wire 3 detail buttons → `flutter analyze` clean → commit `feat(chat): listing-anchored chat UI and entry points`.

## PHASE 3 — Flutter rich layer

### Task 13: Transaction UI

**Files:**
- Modify: `lib/pages/chat/chat_room.dart`, `lib/pages/chat/widgets/chat_app_bar.dart`, `lib/pages/chat/widgets/message_bubble.dart` (system style), `lib/service/chat_api_service.dart`

**Interfaces:**
- Seller-only app-bar menu on product rooms: Reserve / Mark sold / Back to available → `POST /chats/<id>/transaction/`; listing card chip updates from `transaction_updated` WS event (also refresh on response).
- System messages render centered pill style; `metadata.review_cta==true` renders a "Leave a review" filled button routing to the existing review flow for that product (implementer greps `reviews` usage in Flutter for the existing entry point; if none exists, route to product detail).

- [ ] Steps: API method → menu (visible when `room.listing?.type=='product'` && current user is seller — seller id must be exposed in the listing summary or room participants; verify and extend Task 1's serializer with `seller_id` if needed, coordinating a tiny backend commit) → system bubble + CTA → analyze → commit `feat(chat): reserve/sold transaction UI with system messages`.

### Task 14: Actions sheet + reply

**Files:**
- Create: `lib/pages/chat/widgets/message_actions_sheet.dart`, `lib/pages/chat/widgets/reply_preview_bar.dart`
- Modify: `message_bubble.dart` (long-press, swipe-to-reply, quoted block), `chat_room.dart`, `chat_provider.dart`, `chat_api_service.dart`

**Interfaces:**
- Long-press bubble → HapticFeedback + bottom sheet: Reply, React (emoji row: ❤️👍😂😮😢🙏 + custom later), Copy, Translate, Pin/Unpin, Forward, Edit (own+`timestamp` within 15 min), Delete. Options contextual (no Edit on others'/deleted; no Translate on own).
- Swipe-to-reply: horizontal drag right on any bubble, animated reply-icon reveal (opacity+scale on drag progress), haptic at trigger threshold (~60px), sets reply target (BananaTalk `message_bubble.dart` pattern).
- Reply preview bar above input (author + snippet + cancel); sent message carries `reply_to`; bubble shows quoted block, tap → animate-scroll to original (highlight flash).

- [ ] Steps: sheet widget → swipe gesture → preview bar + send wiring → quoted block + scroll-to → analyze → commit `feat(chat): message actions sheet and reply/quote with swipe gesture`.

### Task 15: Reactions, edit, delete UI

**Files:**
- Create: `lib/pages/chat/widgets/reaction_chips.dart`
- Modify: `message_bubble.dart`, `chat_provider.dart`, `chat_api_service.dart`, `chat_room.dart`

**Interfaces:**
- Double-tap bubble → toggle ❤️. Reaction chips under bubble (emoji+count, own reaction highlighted; tap chip toggles). Live update via `reaction_updated` WS event.
- Edit: input bar switches to edit mode (banner "Editing message", prefilled, ✓ submits PUT); bubble shows `chatEdited` suffix; `message_edited` WS updates live.
- Delete: confirm dialog with For me / For everyone (latter only own); deleted-for-everyone renders italic `chatMessageDeleted`; `message_deleted` WS updates live.

- [ ] Steps: API methods (reaction/edit/delete with mode) → chips + double-tap → edit mode → delete dialog → WS handlers in provider → analyze → commit `feat(chat): reactions, edit, and delete UI`.

### Task 16: Forward + pin UI

**Files:**
- Create: `lib/pages/chat/widgets/forward_picker_sheet.dart`, `lib/pages/chat/widgets/pinned_messages_bar.dart`
- Modify: `message_bubble.dart` (forwarded label), `chat_room.dart`, `chat_api_service.dart`, `chat_provider.dart`

**Interfaces:**
- Forward: sheet lists user's other rooms (listing thumbnail+name, search filter) → POST forward → snackbar confirm. Forwarded bubble shows small `chatForwarded` label.
- Pin: toggle from actions sheet; `pinned_messages_bar` under app bar when any pinned — shows latest pinned snippet, tap cycles through pinned + scrolls to message; long-press bar → unpin current. Live via `message_pinned` WS.

- [ ] Steps: API methods → picker sheet → pinned bar + cycle/scroll → WS handler → analyze → commit `feat(chat): forward and pinned messages`.

### Task 17: Voice messages

**Files:**
- Create: `lib/pages/chat/widgets/voice_recorder_bar.dart`, `lib/pages/chat/widgets/voice_bubble.dart`
- Modify: `chat_room.dart` input bar (mic↔send cross-fade), `chat_api_service.dart` (multipart voice upload), `chat_provider.dart`

**Interfaces:**
- Input bar: text empty → mic button (AnimatedSwitcher cross-fade with send). Hold to record: pulsing mic, elapsed timer, live waveform bars from `record` amplitude stream (sample ~50ms, keep last 100, bar height 4+amp*40 — BananaTalk pattern), slide-left to cancel; release → upload.
- Upload: existing message POST with `message_type='voice'`, `file`, `duration` seconds, `metadata={'waveform': [ints 0..100]}`.
- `voice_bubble`: play/pause via `audioplayers`, waveform progress fill, duration label. One player at a time (stop previous).
- iOS/Android mic permission: reuse existing permission handling if present; else add NSMicrophoneUsageDescription / RECORD_AUDIO with the graceful denial snackbar.

- [ ] Steps: recorder bar → upload path (+optimistic voice bubble w/ outbox skip: voice sends direct, failed→retry chip) → playback bubble → permissions → analyze → commit `feat(chat): voice messages with waveform`.

### Task 18: Translation + search UI

**Files:**
- Create: `lib/pages/chat/widgets/chat_search_bar.dart`, `lib/pages/chat/widgets/media_gallery_screen.dart`
- Modify: `message_bubble.dart`, `chat_room.dart`, `chat_list.dart`, `chat_api_service.dart`

**Interfaces:**
- Translate (actions sheet, others' text messages): POST translate with target = current app locale → bubble shows translated text + `chatShowOriginal` toggle; cache in message model; 503 → `chatTranslationFailed` snackbar.
- In-room search: app-bar search icon → inline search bar, GET `/chats/<id>/search/?q=`, prev/next arrows jump+highlight matches.
- Chat-list search: filter field over rooms (participant name OR listing title, client-side).
- Media gallery: room menu → screen with tabs Images / Voice, grid from messages with `message_type` image/voice (paginate via existing messages endpoint filtered client-side v1).
- Link previews: in `message_bubble.dart`, detect first URL in text, fetch og tags client-side (http GET, 3s timeout, in-memory cache keyed by URL, silent fail) → card (title/domain/image) under text. No backend.

- [ ] Steps: translate flow → in-room search → list search → gallery → link previews → analyze → commit `feat(chat): translation, search, media gallery, link previews`.

### Task 19: Room management + drafts + quick replies

**Files:**
- Create: `lib/pages/chat/widgets/quick_replies_panel.dart`
- Modify: `chat_list.dart` (swipe actions, archived section), `chat_room.dart` (drafts, panel), `chat_api_service.dart`, `chat_provider.dart`

**Interfaces:**
- List row swipe actions (Dismissible/Slidable per existing deps — verify; else `flutter pub add flutter_slidable`): left = Mute/Unmute + Pin/Unpin, right = Archive. POST `/chats/<id>/state/`. Pinned rooms sort first (📌 icon); archived collapse into an "Archived" expandable section at list bottom; muted rooms show 🔕 and suppress badge count client-side too.
- Drafts: per-room text saved to SP key `chat_draft_<roomId>` on change (debounced 500ms), restored on open, cleared on send; list row shows `chatDraft` prefix in red when a draft exists.
- Quick replies: "+" button by input → panel with user's saved templates (GET/POST/DELETE `/chats/quick-replies/`), tap inserts into input; manage (add/delete) inline in panel.

- [ ] Steps: state API + swipe actions + sections → drafts → quick replies panel → analyze → commit `feat(chat): mute/archive/pin, drafts, quick replies`.

### Task 20: Typing/presence + final polish

**Files:**
- Modify: `chat_app_bar.dart`, `chat_room.dart`, `message_bubble.dart`, `websocket_service.dart`, `chat_provider.dart`, `lib/pages/chat/widgets/message_list.dart`

**Interfaces:**
- Typing: send `typing_start` on first keystroke, `typing_stop` after 3s idle/send; app-bar subtitle swaps to animated 3-dot + `chatTyping` when peer typing.
- Presence: subtitle shows `chatOnline` with green glow dot, else `chatLastSeen(relative)`; from `presence` WS events + room fetch.
- Polish pass: grouped-bubble radii (first/middle/last of same-sender run — dedicated `_bubbleRadius()`), unread divider row on open at first unread, date separator chips (verify existing, keep), scroll-to-bottom FAB with unseen count badge appearing after 300px scroll-up, haptics on: long-press, swipe-reply trigger, reaction, record start/stop; shimmer skeletons on list+room first load (reuse `skeleton_loader.dart`).

- [ ] Steps: typing both directions → presence → polish items each verified visually → analyze → commit `feat(chat): typing, presence, and bubble/list polish`.

### Task 21: Integration verification

**Files:** none new (fixes only)

- [ ] **Step 1:** Backend: full `chat/` pytest suite green; `python manage.py check` clean.
- [ ] **Step 2:** Flutter: `flutter analyze` (no new issues), `flutter test` (all non-network tests pass).
- [ ] **Step 3:** Static cross-checks: every new endpoint the Flutter code calls exists in `chat/urls.py` (grep both sides and diff); every WS event name emitted by backend has a Flutter handler and vice versa (list both, compare).
- [ ] **Step 4:** Manual smoke script (run app + backend if available): start chat from a product → quick chip → reserve → sold → review CTA; airplane-mode send → restore → dedup; reply/edit/delete/react/pin/forward/voice/translate/search; mute→no badge; archive→section; typing/presence with two accounts.
- [ ] **Step 5:** Fix whatever surfaced, commit `fix(chat): integration fixes from smoke pass`.

---

## Self-Review Notes (spec coverage map)

- §4.1 listing anchor → Tasks 1, 2 (backend), 12 (UI). Strict origin → Task 2 gating + Task 12 entry-point removal.
- §4.2 transactions → Tasks 4 (backend), 13 (UI). Review CTA → 4 + 13.
- §4.3 reliability → Tasks 3 (local_id field), 8 (echo/dedup), 11 (client core). Banner debounce 3s → 11.
- §4.4 rich layer → backend Tasks 3, 5, 6, 7, 8; UI Tasks 14–20. Media gallery/link previews/drafts/quick replies → 18, 19. Push gating → 8.
- §4.5 push → Task 8. §5 exclusions respected — no task builds excluded features.
- i18n before all UI tasks → Task 9 precedes 12–20. Known risk: Task 13 may need `seller_id` in the listing summary — flagged inline for a coordinated backend tweak.

