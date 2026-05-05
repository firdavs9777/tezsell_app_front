# Profile (shaxsiy) Optimization — Design Spec

**Date:** 2026-05-06
**Status:** Phase A executed overnight (follow sheet + menu card primitives extracted).
**Author:** Claude (autonomous run while user was asleep)

## Goal

Reduce file size of profile pages, extract reusable building blocks, and lay
groundwork for the rest of the section.

## Context

Profile (`lib/pages/shaxsiy/`) has minimal WIP overlap (only 4 lines each in
`favorite_products.dart` and `saved_properties.dart`). This makes it the
safest part of the codebase to refactor in this session.

File sizes at start of session:

| File | Lines |
|---|---|
| `shaxsiy.dart` | **1388** (god-file with 3 classes) |
| `security/main_security.dart` | 903 |
| `customer_center/customer_center.dart` | 825 |
| `inquires/main_inquiries.dart` | 733 |
| `profile-terms/terms_and_conditions.dart` | 712 |
| `properties/saved_properties.dart` | 701 (4 lines WIP) |
| `my-products/product_edit.dart` | 674 |
| `main_profile/profile_edit.dart` | 665 |
| `my-services/service_edit.dart` | 630 |
| `my-products/my_products.dart` | 629 |
| `my-services/my_services.dart` | 620 |
| `inquires/main_inquiries.dart` | 733 |

## Phase A — extracted overnight

`shaxsiy.dart` 1388 → 1105 lines (−20%, contained refactor).

Two new widget files in `lib/pages/shaxsiy/widgets/`:

1. **`profile_follow_list_sheet.dart`** — extracts `_FollowListSheet` (now
   `ProfileFollowListSheet`, public `ConsumerWidget`) and `_FollowUserTile`
   (now private `_FollowUserTile` inside the same file). 230 lines, fully
   self-contained.

2. **`profile_menu_card.dart`** — extracts `_buildMenuCard` and
   `_buildSectionTitle` into `ProfileMenuCard` and `ProfileSectionTitle`
   widgets. 94 lines. Replaces 13+ call sites in `shaxsiy.dart`.

`flutter analyze` is clean (no errors; pre-existing warnings unchanged).

## Phase B — deferred

These extractions are queued but not done in this session. Each is bounded
and low-risk; main reason to defer was scope/time.

### B1: Instagram-style profile header (200 lines → new file)

Extract `_buildInstagramStyleHeader`, `_buildStatColumn`, `_formatCount`, and
`_getProfileImage` into `widgets/profile_header.dart` as `ProfileHeader`
widget.

Inputs:
- `UserInfo user`
- `int totalListings`
- `int? followersCount`
- `int? followingCount`
- `VoidCallback onShowFollowers`
- `VoidCallback onShowFollowing`
- `VoidCallback onEditProfile`
- `Future<void> Function()` for the avatar tap (image viewer push)

Notes: the profile-image URL prefixing (using `baseUrl` constant for relative
paths) should move with `_getProfileImage`. The image-viewer navigation can
either move into the header or stay in the parent via callback.

### B2: Language and theme dialogs (~210 lines → 2 new files)

Extract `_showLanguageDialog` + `_buildLanguageOption` into
`widgets/profile_language_dialog.dart` as a top-level
`showProfileLanguageDialog(BuildContext, WidgetRef)` function.

Same for theme: `widgets/profile_theme_dialog.dart` exposing
`showProfileThemeDialog(BuildContext, WidgetRef)`.

Both functions read/write to providers internally; the parent just calls
the function.

### B3: Role-conditional cards (~200 lines → 1-3 new files)

`_buildSavedPropertiesCard`, `_buildAgentCard`, `_buildAdminSection` are
each Consumer-builder cards that watch token/agent-status providers. Each
should become its own widget:

- `widgets/profile_saved_properties_card.dart` → `ProfileSavedPropertiesCard`
- `widgets/profile_agent_card.dart` → `ProfileAgentCard`
- `widgets/profile_admin_section.dart` → `ProfileAdminSection`

Each takes `AppLocalizations? localizations` and is a `ConsumerWidget`.

### B4: State widgets (~70 lines → 1 file)

`_buildErrorState` and `_buildEmptyState` → `widgets/profile_state_widgets.dart`
exposing `ProfileErrorState` and `ProfileEmptyState`. Both take callbacks for
retry / refresh / logout.

### Expected size after Phase B

`shaxsiy.dart` should reach ~350-400 lines after B1-B4. The remaining content
is page orchestration (state, fetch, build composition) — appropriate for a
ConsumerStatefulWidget page.

## Phase C — other large profile files

Each of these is its own brainstorm; they share the pattern of being a
single-page form/list with the build method dominated by inline widgets:

- `security/main_security.dart` (903) — likely has multiple sections
  (password change, 2FA, login history) that can split.
- `customer_center/customer_center.dart` (825) — categories + faq + form.
- `inquires/main_inquiries.dart` (733) — list + create form.
- `profile-terms/terms_and_conditions.dart` (712) — likely a long-text page;
  may not benefit from splitting (text-only pages often shouldn't be split).
- `properties/saved_properties.dart` (701) — has WIP, defer.
- `my-products/product_edit.dart` (674) — pattern matches `product_new.dart`
  Phase 1 work; can apply same widget split.
- `main_profile/profile_edit.dart` (665) — same pattern.
- `my-services/service_edit.dart` (630) — same.
- `my-products/my_products.dart` (629) — list page.
- `my-services/my_services.dart` (620) — list page.

These should be tackled file-by-file with their own brainstorms; doing them
in bulk loses the per-file design check.

## Out of scope

- Adding tests (none exist for these pages; that's its own initiative).
- Performance optimization (list virtualization, image caching) — no smoking
  gun visible.
- Renaming `shaxsiy` (Uzbek for "personal") to `profile` — that's a separate
  cosmetic refactor across the whole codebase.

## Bugs / smells noted (not fixed)

1. `_showLanguageDialog._buildLanguageOption` calls `_showSuccess('Language
   changed to $language')` — hardcoded English. Should localize.
2. `_showThemeDialog._buildThemeOption` same issue: `_showSuccess('Theme
   changed to $theme')` is hardcoded English.
3. `shaxsiy.dart:48` `_userInfoFuture` field is set in `initState` but never
   read after `_refreshProfile` reassigns it. The `_fetchAllData()` future
   in the FutureBuilder is what actually drives the UI. Dead state.
4. `shaxsiy.dart:973-991` `_buildEmptyState` shows hardcoded
   `'No user data available.'` — should localize.

## Next session

1. Review Phase A commit; manually smoke-test (open profile, verify menu
   cards render, taps navigate correctly, follow sheet opens).
2. If Phase A is good, proceed to B1 (Instagram header) — biggest single
   block remaining at ~200 lines.
3. Then B2/B3/B4 in any order; each is independent.
4. Then pick a Phase C target.
