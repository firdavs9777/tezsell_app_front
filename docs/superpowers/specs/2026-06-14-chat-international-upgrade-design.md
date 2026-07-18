> **SUPERSEDED (2026-07-19):** absorbed into [`2026-07-19-chat-advanced-karrot-design.md`](2026-07-19-chat-advanced-karrot-design.md). Do not execute the 2026-06-14 plan.

# Chat International Upgrade — Design Spec

**Date:** 2026-06-14
**Status:** Approved scope, ready to plan
**Author:** Claude (brainstorming session with firdavs9777)

## Context

Tezsell was built as a Karrot-style hyper-local marketplace targeting Uzbekistan only. Single-country traction has not met expectations. The product direction is shifting to enter developed second-hand marketplace markets (Korea, Japan, US — Karrot/Mercari/OfferUp territory) following the Karrot playbook of hyper-local density per-country rather than a global single-app model.

This spec covers the **chat subsystem upgrade only**, scoped to land it at the polish bar those markets expect. It is one input to the international pivot; product-market fit, listing liquidity, and trust mechanisms are larger levers and out of scope here.

## Honest framing

Korean (Karrot/Bunjang/JoongoNara), Japanese (Mercari/Jimoty), and US (OfferUp/FB Marketplace/Craigslist) markets are deeply entrenched and extremely hard to enter. Chat quality will not be what wins or loses there. This upgrade exists because:

1. Reliability gaps (no heartbeat, no offline queue, no retry) will cause data loss in any market.
2. Several improvements (translation, listing-in-thread) are international table-stakes.
3. Current chat already has reactions/replies/edits/voice/15-locale UI — the foundation is solid (~6.5/10). Rewrite would be waste.

## Goal

Bring Tezsell chat to international polish without rewriting the architecture. Layer enhancements on top of the existing Riverpod `ChatNotifier` + split `ChatList/ChatRoom` WebSocket services. Add three new top-level services. Keep what works.

## Reference implementation

BananaTalk (`/Users/firdavsmutalipov/Projects/BananaTalk/bananatalk_app`) was surveyed for portable patterns. Worth borrowing:

- Socket.IO-style reconnect with adaptive backoff + network-aware triggers (heartbeat, connectivity events)
- Optimistic message pattern with `localId` tracking
- Deterministic state reconstruction (avoids duplicate-state bugs on socket reconnect)
- Inline translation caching per session
- Debounced connection-status UI (3s delay before showing "reconnecting")

Not worth borrowing (language-learning-specific, not marketplace): corrections, voice rooms, self-destruct messages, polls, stickers, mentions, forwarding.

## Architecture

Keep existing structure:
- `ChatNotifier` (Riverpod `StateNotifier<ChatState>`)
- `ChatListWebSocketService` (list-level updates)
- `ChatRoomWebSocketService` (per-room messages)

Add three new top-level pieces:

| Service | Purpose | Lifecycle |
|---|---|---|
| `MessageQueueService` | Persistent send queue (sqflite). Optimistic local append + drain-on-reconnect. | App-singleton |
| `MessageTranslationService` | REST client + per-session in-memory cache | App-singleton |
| `ConnectionStateController` | Debounced WS connectivity state; drives global disconnect banner | App-singleton |

All three notify `ChatNotifier` via streams or callbacks; they do not live inside Riverpod state.

## Features

### 1. Reliability (~3 days)

- **Heartbeat:** ping every 25s on both WS connections. No pong within 10s → force reconnect. Port from BananaTalk `ChatSocketService`.
- **Reconnect:** extend max attempts from 3 to ~10. Trigger on `connectivity_plus` restore events in addition to WS errors. Keep exponential backoff (2s, 4s, 8s, capped at 30s).
- **Auth migration:** stop putting `?token=` in WS URL. Backend sends auth as first message after open OR via `Sec-WebSocket-Protocol` header (decide with backend). **Backend change required.** Frontend supports BOTH old and new during rollout window.
- **Disconnect banner:** sticky banner across chat list + chat room when offline >3s. Hides 1s after reconnect to kill flicker.

### 2. Optimistic + offline send queue (~3 days)

- `MessageQueueService` persists to sqflite. Each entry: `localId, chatRoomId, kind (text/image/voice), payload, status, createdAt, attempts`.
- Send flow:
  1. Notifier appends optimistic bubble with `status: sending`, carrying `localId`.
  2. Entry persisted to queue.
  3. If WS connected, attempt immediate send.
- Reconnect / `connectivity_plus` online event → drain queue oldest-first.
- Server ACK matched by `localId` → swap optimistic bubble for server-canonical message.
- Failure: 3 retries with backoff → `status: failed` → per-bubble retry button.
- **Hard requirement:** app-kill + restart must still drain the queue. Test this explicitly.

### 3. Translation (~5 days)

- **Model additions on `Message`:** `translatedText: String?`, `translationLanguage: String?`, `translationProvider: String?`, `detectedLanguage: String?`.
- **UI:** "Translate" affordance on bubbles whose `detectedLanguage` differs from user locale. Tap → fetch → inline translation under original. Toggle to hide.
- **Backend:** `POST /messages/{id}/translate?target=<locale>` → `{translatedText, provider, detectedLanguage, cached}`. **Backend change required.**
- **Caching:** session-level `Map<messageId, TranslationResult>` per chat room. Cleared on chat dispose.
- **User pref:** "Auto-translate to my language" toggle in chat settings. **Default OFF** (cost + privacy). When ON, eagerly translate on message arrival, gate per-room.
- **v1 scope:** inbound only. Outbound translation (write UZ → recipient sees JA) is a much bigger UX shift; defer.

### 4. Listing card in chat thread (~3 days)

- **Backend assumption:** chat rooms started from a product carry `productId`. **Verify before starting.** If not, backend ticket first.
- New `ListingHeaderCard` widget pinned at top of chat room. Collapses on scroll to a thin bar showing title + price.
- Shows: product thumbnail, title, price, status badge (Available / Sold / Reserved). Tap → product detail page.
- Absent for general user-to-user DMs with no product context.
- For sold/reserved products, status badge is unmistakable — prevents buyers from negotiating dead listings.

### 5. In-room message search (~2 days)

- Search icon in app bar → inline search field below app bar.
- Local-first: filter currently-loaded messages.
- If no hit and pagination has more, hit `GET /chats/{id}/messages?q=...&before=<oldest_loaded>`. **Backend change required, or fall back to local-only and document the limit.**
- Tap result → animate scroll to message, highlight briefly (300ms fade).

### 6. Mute / archive (~2 days)

- **v1 = local only via `shared_preferences`** (matches existing pin pattern). Trade-off: doesn't sync across devices. Acceptable for first ship; defer server-side sync to v2.
- Mute v1 behavior: suppress the in-app/foreground notification AND don't bump the unread-count badge for that room. **Background FCM still arrives** because the server doesn't know the room is muted — true silent push requires a server-side mute flag and is deferred.
- Archive = separate "Archived" tab in chat list. Archived rooms hidden from main list but still receive new messages.
- Extend existing swipe-action menu with mute + archive alongside pin + delete.

### 7. Better states (~2 days)

- Failed-send retry button per-bubble (depends on §2)
- Disconnect banner (depends on §1)
- Translation-error inline state ("couldn't translate, tap to retry")
- Empty-search state, empty-archived state
- Network-loss banner persists into chat room (not just chat list)

## Out of scope (explicit)

To prevent drift:

- RTL layout — Korea/Japan/US don't need it. Revisit if Gulf market enters scope.
- Voice/video calls — current WebRTC stubs are broken; rip out or leave dormant, not part of this work.
- Cross-device pin/mute/archive sync — defer to v2.
- Outbound message translation — defer.
- Voice rooms, polls, stickers, mentions, corrections, forwarding — not marketplace features.
- Rewriting `chat_room.dart` (1733 LOC). The 2026-05-06 chat optimization spec covers that separately; this work should not bundle the refactor.

## Backend dependencies

Must coordinate with backend before frontend work starts:

1. **Translation endpoint** — `POST /messages/{id}/translate`. Provider choice (Google/DeepL/Papago) up to backend.
2. **WS auth via header or first-message** — current `?token=` query approach must be replaced.
3. **Per-room message search endpoint** — `GET /chats/{id}/messages?q=...`. Acceptable fallback: local-only search, documented limit.
4. **Confirm `productId` on chat rooms** — if missing, add it.
5. **Echo `localId` in send ACK** — server must accept a client-generated `localId` in the send-message request and include it in the persisted-message response (REST and WS event) so the client can reconcile its optimistic bubble with the canonical server message. Without this, the queue can't match ACKs reliably.

## Data model changes

- `Message` adds: `localId`, `status` (sending/sent/delivered/read/failed), `translatedText`, `translationLanguage`, `translationProvider`, `detectedLanguage`.
- `ChatRoom` adds: `productId` (if not present), local `isMuted`, local `isArchived` (in shared_preferences only — not on the model itself if backend doesn't store).

## Testing

- **Widget tests:** `ListingHeaderCard`, translation toggle on `message_bubble`, disconnect banner.
- **Service tests:** `MessageQueueService` — persistence across restart, drain on reconnect, retry/failure flow, ACK matching by localId.
- **Integration test:** send 3 messages while WS offline → reconnect → all three arrive on server in original send order.
- **Manual test matrix:**
  - Send during airplane mode → restore → message arrives
  - Translate Korean bubble while user locale is Uzbek
  - Open chat for sold listing → header shows "Sold"
  - Archive chat → new message arrives → unread badge in archived tab
  - Force-kill mid-send → reopen → queue drains

## Risk callouts

| Risk | Mitigation |
|---|---|
| Translation API cost spirals with auto-translate ON | Default OFF, rate-limit per-user server-side, surface daily quota in settings |
| WS auth header migration causes double-deploy ordering bug | Frontend supports both old query-param AND new header during rollout; backend deploys first |
| Queue + optimistic + WS dedup has three sources of truth | Single source-of-truth rule: server message replaces optimistic on `localId` match; never deduplicate by content. Budget extra time for reconciliation edge cases. |
| Backend doesn't carry `productId` on chat rooms | Verify in week 1; if missing, blocks §4. Sequence §4 last if uncertain. |
| `chat_room.dart` is 1733 LOC and untouched here | Adding listing card + search + new states without extracting widgets first may bloat it further. Extract sub-widgets opportunistically but don't bundle the full refactor. |

## Order of work

Sequenced by dependency and value:

1. **Reliability + WS auth move** — foundation, unblocks rollout-safety for later work.
2. **Optimistic + offline queue** — foundation, must precede failed-send UI.
3. **Listing card** — highest user-visible international win, validates backend `productId` assumption.
4. **Translation** — core international feature.
5. **Search + mute/archive + state polish** — finishing touches.

**Estimate: 3–4 weeks for one engineer.**

## Open questions for v2

Not blocking this spec; record for later:

- Server-side mute/archive sync across devices
- Outbound translation
- Push notification mute (currently foreground-only)
- Read receipts privacy toggle (per-user opt-out) — Korean/Japanese users expect this
- Spam/scam detection (international markets see more of both)
