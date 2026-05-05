# Chat Optimization — Design Spec

**Date:** 2026-05-06
**Status:** Doc-only this session — chat has heavy WIP that blocks safe refactoring.
**Author:** Claude (autonomous run while user was asleep)

## Goal

Identify the highest-value optimization targets in the chat subsystem, capture
concrete refactoring guidance, and defer code changes until the user's in-flight
chat overhaul is committed.

## Why doc-only

`git diff --stat` against the chat subsystem at the start of this session:

| File | Lines changed |
|---|---|
| `chat_list.dart` | +686 / −305 (essentially a rewrite) |
| `chat_provider.dart` | +450 lines of changes |
| `chat_room.dart` | +98 lines |
| `chat_app_bar.dart` | +68 |
| `message_bubble.dart` | +108 |
| `chat_shimmer.dart` | +30 |
| `message_list.dart` | +8 |
| `user_list.dart` | +2 |

Refactoring on top of this WIP would create unmergeable conflicts. Every chat file
the user is actively editing is also a primary refactor candidate, so there is no
useful overlap to exploit.

## Empirical findings

### `chat_room.dart` is the project's largest file at 1733 lines

Method map (from `grep` for `_buildX` / async methods):

```
171  _loadOlderMessages
253  _toggleAudioPlayback
373  _saveEditedMessage
497  _buildScrollToBottomButton
574  _pickAndSendImage
690  _handleVoiceRecordingComplete
750  _toggleRecording
964  _buildChatBody             (~120 LOC)
1086 _buildMessageInput        (~355 LOC — biggest single block)
1441 _startRecording
1478 _stopRecording
1536 _buildMicButton
1575 _buildRecordingUI         (~95 LOC)
1669 _buildLockedUI
```

The voice recording flow alone (start/stop/lock/UI/mic button + handlers) is ~400 LOC
and is the obvious first extraction target. After that, `_buildMessageInput` should
become its own widget composed from sub-widgets.

### Other chat files are reasonably sized

`chat_list.dart` (676), `user_list.dart` (989), `message_bubble.dart` (586) are not
small but they're not god-files either. `chat_provider.dart` (size unknown — heavy WIP)
might warrant a split when the user's overhaul is done.

### `chat_helpers.dart` is sparse and English-only

27 lines. `formatTimestamp` returns hardcoded `'Today' / 'Yesterday' / '<n> days ago'`
strings — should use `AppLocalizations`. Existing keys to use: there are several
`time_*_ago` and `time_just_now` keys already in the ARBs (see `product_detail.dart`
WIP for usage pattern).

## Refactoring plan (post-WIP-merge)

### Phase A — extract voice recording (chat_room.dart 1733 → ~1300)

Create `lib/pages/chat/widgets/voice_recorder.dart` containing:

- `VoiceRecorder` widget — owns the mic button, recording UI, locked UI, gesture
  handling. Receives a `void Function(File audioFile, int duration) onComplete`
  callback and a recording-permitted flag from the parent.
- Internally uses the existing recording package; lifts `_startRecording`,
  `_stopRecording`, `_buildMicButton`, `_buildRecordingUI`, `_buildLockedUI`,
  `_handleVoiceRecordingComplete`, and `_toggleRecording` out of `chat_room.dart`.

Risk: medium. The recording flow has its own state machine (recording, locked,
canceled) that must move with it. Test by recording, locking, sending; recording
and canceling; recording in different network states.

### Phase B — extract message input composition (chat_room.dart → ~900)

Create `lib/pages/chat/widgets/message_composer.dart`:

- `MessageComposer` widget — text field, send button, attachment button, voice
  recorder slot, edit/reply preview slot.
- Receives controllers and callbacks from parent; doesn't own the text controller
  (parent does, since edit-mode replaces its content).

This is the second-largest single block (`_buildMessageInput`, ~355 LOC).

### Phase C — split chat_provider.dart by concern (post-WIP)

Until the user's WIP lands, the current shape is unknown. Likely split candidates:
- `chat_message_provider.dart` — message list + send/edit/delete
- `chat_socket_provider.dart` — websocket lifecycle + reconnect
- `chat_typing_provider.dart` — typing indicators + presence
- `chat_unread_provider.dart` — unread counts and last-read tracking

Decide AFTER reading the post-WIP version of `chat_provider.dart`.

### Phase D — `chat_helpers.dart` localization

Pass `BuildContext` to `formatTimestamp`, switch to `AppLocalizations` time keys.
Update call sites accordingly. ~30 minutes.

## Safe additions in this session

This session adds `lib/pages/chat/widgets/chat_time_format.dart` — a new file with
pure (context-free) helpers for relative time formatting and same-day detection.
The new file does NOT replace `chat_helpers.dart`; it adds a parallel helper that
takes `AppLocalizations` and returns localized strings. Call sites can migrate
incrementally after the WIP merge.

Why a new file rather than editing `chat_helpers.dart`:
- `chat_helpers.dart` is itself untouched in the current WIP, but its consumers
  (`chat_list.dart`, `chat_room.dart`) are heavily modified. Migrating to localized
  formatting would force changes in those WIP files.
- A new helper sits alongside the existing one; the user can switch over when
  they finish their chat overhaul.

## Bugs and concerns spotted (not fixed)

These need confirmation against the post-WIP code:

1. **`formatTimestamp` is hardcoded English.** Will display 'Today' / 'Yesterday' /
   '4 days ago' regardless of locale. Confirmed in `chat_helpers.dart:12-25`.
2. **`chat_room.dart:300` has a `print` statement** (`'📤 Sending reply to message …'`).
   Should be `AppLogger.debug` for consistency with the rest of the codebase.
3. **No clear error boundary for socket disconnect during voice recording.** Worth
   verifying behavior: if socket drops mid-recording, does the audio file get
   stuck in a temp directory?

## Out of scope

- Refactoring chat-list/chat-room itself (deferred to post-WIP-merge).
- Adding tests (chat has zero tests; that's its own project).
- Performance work (image caching, list virtualization). The chat list already uses
  the standard list builders; there's no visible smoking gun.

## Next session

1. Wait for the user to commit or merge their chat WIP.
2. Read the post-WIP versions of `chat_room.dart` and `chat_provider.dart`.
3. Execute Phase A (voice recorder extraction) as a dedicated branch.
4. Iterate on B/C/D after A lands.
