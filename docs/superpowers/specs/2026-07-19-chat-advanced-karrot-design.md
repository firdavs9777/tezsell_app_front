# Plan A — Karrot-Style Advanced Chat

**Date:** 2026-07-19
**Status:** Approved (design)
**Supersedes:** `2026-06-14-chat-international-upgrade-design.md` and its plan
(`2026-06-14-chat-international-upgrade.md`). That plan was written before the
July chat-file rewrites (WIP snapshot `c1b006d`) and is stale at step level;
its still-valid decisions are absorbed here.
**Reference app:** BananaTalk (`/Users/firdavsmutalipov/Projects/BananaTalk`) —
feature/polish donor for the messenger layer. BananaTalk has no marketplace
linkage; the listing-anchor design is Karrot's, not BananaTalk's.

---

## 1. Goal

Make Tezsell chat a Karrot-grade **transactional** chat: every conversation is
anchored to a listing (product/service/property), with seller transaction
actions in-thread, plus a rich messenger layer (reply/edit/delete/reactions/
voice/forward/pin/translation/search) at BananaTalk polish level.

## 2. Scope decisions (locked with user)

- **Feature tier:** Karrot-core + rich messenger polish (BananaTalk-derived).
- **Chat origin:** **Strict listing-required.** New chats can only start from a
  listing detail page ("Chat with seller"). The pick-a-user flow
  (`lib/pages/chat/user_list.dart` entry point) is removed from the chat tab.
  Legacy listing-less rooms remain readable.
- **Approach:** one fresh spec+plan superseding the June plan.

## 3. What already exists (build on, don't rebuild)

**Django (`tezsell-app/chat/`):**
- `Message` already has: `message_type` (text/image/voice/system), `content`,
  `file`, `duration`, `delivery_status` (sending/sent/delivered/read/failed),
  `delivered_at`, `is_read`, `read_by` M2M, `is_edited`, `is_deleted`,
  `reply_to` self-FK, `reactions` JSONField (`{"👍": [user_id...]}`)
- `TypingIndicator`, `UserPresence`, `BlockedUser`, `CallHistory` models exist.
- Channels consumers (`chat/consumer.py`): chat-list socket + room socket with
  `create_chatroom`, `request_list`, `new_message` events.
- `Product.is_sold`, `is_active` exist. `reviews` app exists.

**Flutter:** Riverpod `ChatNotifier` + split list/room WebSocket services;
chat_list/chat_room recently rewritten (July WIP). Shimmer, message bubbles,
date separators partially present.

## 4. Design

### 4.1 Listing-anchored chats (core)

**Backend:**
- `ChatRoom` gains: `product = FK(products.Product, null=True)`,
  `service = FK(services.Service, null=True)`,
  `property = FK(real_estate.Property, null=True)`,
  `listing_type = CharField(choices: product|service|property, null=True)`.
  Exactly one FK set when `listing_type` is set; enforced in `clean()`/API.
  Legacy rooms: all null.
- **Create-or-get endpoint:** `POST /chats/api/rooms/start/` with
  `{listing_type, listing_id}` → returns existing room for (requester, owner,
  listing) or creates one. Requester ≠ owner (400 on self-chat). New-room
  creation via the old pick-a-user path is disabled at the API level for
  non-staff.
- Room serializers include a `listing` summary object: `{type, id, title,
  price, currency, image_url, status}` (status: available|reserved|sold for
  products; null otherwise).

**Flutter:**
- "Chat with seller" button on product/service/property detail pages →
  `start` endpoint → open room.
- Chat tab: remove the user-list FAB/entry; chat list rows show listing
  thumbnail (fallback avatar), title, price line under the participant name.
- In-thread **pinned listing card** at top: image, title, price, status chip;
  tap → listing detail.
- **Quick chips** (buyer side, shown while thread has <2 buyer messages):
  "Is this still available?" / "Can you lower the price?" /
  "Where can we meet?" — localized EN/RU/UZ, tap = send as text.

### 4.2 Transaction flow (products only, v1)

- `Product.is_reserved = BooleanField(default=False, db_index=True)`.
- Endpoint: `POST /chats/api/rooms/<id>/transaction/` with
  `{action: reserve|sold|available}` — seller-only, product rooms only.
  Side effects: update product flags, create a `system` message in the room
  ("Seller marked this item as reserved"), broadcast via WS, listing card
  chip updates.
- On `sold`: also emit a system message to the buyer with a review CTA;
  Flutter renders it with a "Leave a review" button → existing reviews flow.
- Service/property rooms: no transaction actions (inquiry-only).

### 4.3 Reliability core (absorbed from June spec)

- **Optimistic send + `local_id`:** client generates `local_id` (uuid); WS/REST
  send carries it; backend persists it on the message (see §4.4) and echoes it
  in the ack and in the `new_message` broadcast; client reconciles optimistic
  bubble → real message, dedups on reconnect replay (same `local_id` in a room
  → not re-created).
- **Offline outbox:** unsent messages persisted in `shared_preferences`
  (decision carried from June: queue is small; no sqflite), retried with
  backoff on reconnect; failed state on bubble with tap-to-retry.
- **ConnectionStateController:** single source of connection truth; debounced
  reconnect banner (show only after 3s disconnected — BananaTalk polish);
  `connectivity_plus` (new dep) for network-aware reconnect.
- **Delivered/read ticks:** one grey tick sent, two grey delivered, two green
  read (driven by `delivery_status` + WS receipt events `message_delivered`
  / `messages_read`). Read-marker sent when messages become visible.

### 4.4 Rich messenger layer

Backend additions:
- `Message.forwarded_from = FK('self', null=True)` + `is_forwarded` bool.
- `Message.is_pinned`, `pinned_at`, `pinned_by` (FK User, null=True).
- `Message.local_id = CharField(max_length=64, null=True, db_index=True)`
  (echo/dedup support; unique per room enforced app-side).
- `Message.metadata = JSONField(default=dict, blank=True)` — extensible
  per-message data; v1 uses it for voice waveform amplitudes.
- `Message.deleted_for = M2M(User)` — delete-for-me; `is_deleted` = delete
  for everyone (content blanked, bubble shows "Message deleted").
- Edit endpoint (sender-only, **15-min window**, blocked if deleted);
  delete endpoint (`for_me` | `for_everyone`, everyone = sender-only).
- Reactions endpoints (add/remove; one emoji per user per message —
  stored in existing `reactions` JSONField).
- `RoomState` per (room,user): `is_muted`, `muted_until`, `is_archived`,
  `is_pinned` — new model; room-list endpoint filters/orders accordingly.
- `QuickReplyTemplate` (user, text, order) — saved seller snippets CRUD.
- **Translation:** `POST /chats/api/messages/<id>/translate/` with
  `{target}` → cached per (message, target) in a `MessageTranslation` model;
  provider = Google Translate v2 REST (key via env; graceful 503 if unset).
- **Search:** `GET /chats/api/messages/search/?q=&room_id=` (icontains,
  paginated) + room-list search by participant/listing title.
- WS events added to room consumer: `typing_start/stop` → broadcast;
  `presence` (online/last-seen from `UserPresence`, updated on
  connect/disconnect); `message_edited`, `message_deleted`,
  `reaction_updated`, `message_pinned`, `transaction_updated`.

Flutter additions:
- **Long-press message actions sheet** (container UX): Reply, React (picker),
  Copy, Translate, Edit (own+window), Pin, Forward, Delete.
- **Swipe-to-reply** with animated icon reveal + haptic (BananaTalk pattern);
  reply preview above input; quoted block in bubble, tap→scroll to original.
- **Reactions:** double-tap = ❤️; chips under bubble with counts.
- **Voice messages:** hold-mic record with live waveform (new deps: `record`,
  `audioplayers`; waveform amplitudes sampled client-side, stored in message
  metadata JSON), playback bubble with progress. Mic↔send cross-fade in input.
- **Forward:** picker of your other rooms.
- **Pinned bar:** tap cycles pinned messages, jump-to-message.
- **Media gallery screen** per room (images/videos/voice tabs) from messages.
- **Link previews:** client-side fetch of og:title/og:image with cache;
  render card in bubble (no backend work).
- **Drafts:** per-room draft text persisted in `shared_preferences`.
- **Quick replies:** seller's saved snippets surfaced above keyboard via a
  "+" panel; CRUD screen.
- **Search UI:** in-room search bar with prev/next match; list search field.
- **Mute/archive/pin chats:** swipe actions on list rows + room menu;
  archived section collapsed at list bottom; muted rooms badge-silent.
- **Presence/typing:** online dot + "last seen …" in app bar; animated
  3-dot typing indicator replacing subtitle (BananaTalk pattern).
- **Polish:** grouped-bubble corner radii (first/middle/last in group),
  haptics on actions, shimmer skeletons for list/room load, unread divider,
  date separator chips, scroll-to-bottom FAB with unseen-count badge.

### 4.5 Push & notifications

Existing FCM push stays; add: no push for muted rooms (server-side check),
push only when recipient has no live room socket (avoid double-notify —
BananaTalk pattern), reply/reaction pushes reference message preview.

## 5. Out of scope (explicit)

Polls, stickers, GIF picker (external API key), language corrections,
self-destruct/secret chats, per-chat themes, bookmarks, group chats, call
system changes, message scheduling, story references, cursor pagination
migration (keep page/limit), E2E encryption.

## 6. Success criteria

1. New chat can ONLY be started from a listing; thread shows pinned listing
   card; list rows show listing thumbnail+price. Legacy rooms still open.
2. Seller can Reserve/Sold/Available from a product thread; buyer sees system
   message + updated chip in real time; Sold triggers review CTA.
3. Kill network mid-send → message queues, banner appears after 3s, restore
   network → auto-resends, no duplicates (local_id dedup), ticks progress
   sent→delivered→read.
4. Reply, edit (≤15 min), delete (me/everyone), react, forward, pin, voice
   record/playback, translate, in-room search all work end-to-end against
   the Django backend, with WS live updates on both sides.
5. Typing indicator and online/last-seen visible in thread app bar.
6. Mute silences push+badge; archive hides from main list; drafts survive
   app restart. All new strings localized EN/RU/UZ.
7. Backend: pytest green for every new endpoint/WS event; Flutter:
   `flutter analyze` clean; existing tests pass.
