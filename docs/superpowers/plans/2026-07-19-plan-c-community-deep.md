# Plan C — Community Deep (v2)

> **For agentic workers:** REQUIRED SUB-SKILL: superpowers:subagent-driven-development. Spec+plan combined; survey-grounded. Builds directly on Community v1 (shipped 2026-07-19).

**Goal:** Make the Community tab lively and safe: images in composer (pipe already built!), own-post edit/delete, threaded replies, report/moderation, search, popular sort, and community notifications in the bell.

**Key survey findings:**
- Composer image upload is FULLY wired backend+provider (`createPost(images:)`, `CommunityPostImage`) — only the picker UI is missing. Quick win.
- `CommunityPostDetailView` is GET-only — no edit/delete for authors.
- `CommunityComment` has no parent FK — flat only.
- `moderation.Report.CONTENT_TYPES` lacks community types entirely; `ReportContentDialog` never invoked from community screens.
- No search, no popular sort, no comment pagination; Community bell was deferred in v1 (tab uses no notification provider).

## Global Constraints
- Branches: backend `feat/community-v2-backend`, Flutter `feat/community-v2`. Six categories stay fixed. i18n EN/RU/UZ + committed generated l10n.

## Tasks

### Task 1 (FE): Composer image picker  ← quick win
Files: `community_composer.dart`.
- Photo grid row (max 5) via the app's existing image-picking pattern (grep products' new-listing flow and reuse its picker/permission handling), preview thumbs with remove, wired to existing `createPost(images:)`. Analyze clean.

### Task 2 (BE): Own-post edit/delete + comment delete
Files: `community/views.py`, `community/urls.py`, tests.
- `CommunityPostDetailView` → `RetrieveUpdateDestroyAPIView` with author-only IsOwner permission for PUT/DELETE (body/category editable; images add/remove via separate `POST /posts/<id>/images/` + `DELETE /posts/<id>/images/<image_id>/`).
- `DELETE /posts/<id>/comments/<comment_id>/` — comment author or post author. `comment_count` recomputed.

### Task 3 (BE): Threaded replies
Files: `community/models.py`, serializers, views, tests.
- `CommunityComment.parent = FK('self', null=True, related_name='replies')` (one level deep only — reject parent-of-parent with 400).
- Comments GET returns top-level paginated (page_size 20) with nested `replies` + `reply_count`. Notification `community_reply` to parent comment author (register in `Notification.TYPE_CHOICES` + migration).

### Task 4 (BE): Report/moderation integration
Files: `moderation/models.py` (+migration), community hooks, tests.
- Add `('community_post', 'Community Post'), ('community_comment', 'Community Comment')` to `Report.CONTENT_TYPES`. Verify moderation admin resolution flow handles them (content lookup switch — extend where content is resolved).

### Task 5 (BE): Search + popular sort + category counts
Files: `community/views.py`, tests.
- Feed params: `q` (body icontains), `sort=popular` (annotate `score = like_count + comment_count*2`, order `-score, -created_at`, last-7-days window when popular).
- `GET /community/api/posts/counts/?district_id=` → `{question: n, …}` per category (single aggregate query).

### Task 6 (FE): Feed v2 — search, sort, counts, edit/delete, report
Files: `community_main.dart`, `community_detail.dart`, new `community_edit.dart`, provider/service.
- Search field in app bar area; Fresh|Popular toggle; chips show counts; own posts get edit/delete via overflow menu (edit screen mirrors composer); others' posts/comments get Report via existing `ReportContentDialog` with the new content types.

### Task 7 (FE): Replies UI + comment pagination
Files: `community_detail.dart`.
- Reply affordance per comment, indented reply list (collapsed >2 with "View N replies"), reply composer targets parent; load-more pagination for top-level comments.

### Task 8 (FE): Community notifications in the bell
Files: `tab_bar.dart`, `notification_provider.dart` pattern, new `communityNotificationProvider`.
- Provider consuming existing notification stream filtered to `community_*` types; bell shown on Community tab (index 1) — closes the v1 deferral. Badge + dropdown reuse `NotificationBell`.

### Task 9: Integration verification
- Backend suite green; analyze clean; smoke: post with photos → edit → reply → report → popular sort → bell shows like/comment/reply events.

## Out of scope
Polls, groups/clubs, digests ("N new posts"), post scheduling, deeper nesting than 1 level.
