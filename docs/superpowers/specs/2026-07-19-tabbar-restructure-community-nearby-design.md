# Tab-bar Restructure — "Carrot of the World" IA (Spec #1)

**Date:** 2026-07-19
**Status:** Approved (design)
**Scope:** Restructure the main tab bar into a global Karrot-style information
architecture. Ship the new skeleton — including a lightweight **Community v1**
feed and a merged **Nearby** hub — while deferring the full community vision to
its own follow-up spec.

---

## 1. Goal & Context

The app (**Tezsell**) is a Karrot-style hyperlocal marketplace. Going "global
Karrot" is primarily an information-architecture problem, not a backend one: the
Django backend already has a multi-country `Country → Region → District`
hierarchy with currency, GPS-tagged listings (`latitude/longitude +
country_code`), and Karrot-style neighborhood verification
(`accounts.User.verified_neighborhoods`, max 2).

The one genuine gap versus real Karrot is a **community / neighborhood feed**
("동네생활") — Karrot's actual moat. This spec introduces it in a lightweight
form and restructures the tab bar to match Karrot's proven global layout.

### Current tab bar (before)

Index → tab: `0 Products · 1 Services · 2 Chat · 3 Real Estate · 4 Profile`
(see `lib/pages/tab_bar/tab_bar.dart`).

### New tab bar (after)

Index → tab: `0 Home · 1 Community · 2 Nearby · 3 Chat · 4 My`

| # | Tab | Change | Gating |
|---|-----|--------|--------|
| 0 | 🏠 **Home** | Keep as-is (today's Products marketplace) | 🔒 neighborhood |
| 1 | 👥 **Community** | **NEW — build v1** | 🔒 neighborhood |
| 2 | 📍 **Nearby** | **MERGE** Services + Real Estate into a category hub | per-category |
| 3 | 💬 **Chat** | Keep as-is | — |
| 4 | 👤 **My** | Keep as-is (today's Profile / Shaxsiy) | — |

---

## 2. Tab-by-tab design

### 2.1 Home (keep as-is)

Today's `ProductsList` marketplace, still wrapped in `NeighborhoodGate`.
Contextual "Sell" compose entry unchanged. No functional change beyond the
label/index remap in §4.

### 2.2 Community (new — v1)

Neighborhood-gated feed of local posts. **Layout: rich cards** — top filter
chips (All + the six categories), photo-friendly post cards, a floating
"✏️ Write" compose button.

**v1 post categories (six):**
`Question · Recommendation · Free/Giveaway · Lost & Found · Alert/Notice ·
General`

**v1 post shape:** author, auto-assigned verified neighborhood, category, text
body, **optional photos (0–N)**, `created_at`. Interactions: **like** and
**comments**.

**Backend — new Django `community` app.** Mirror the existing `services`
patterns (comments already exist as `ServiceComment` / `ServiceCommentReply`;
reuse that shape).

- `CommunityPost` — FK `author → User`, FK `neighborhood_district → District`
  (plus `latitude/longitude/country_code` snapshot like `Product`/`Service`),
  `category` (choices enum for the six), `body` (Text), timestamps.
- `CommunityPostImage` — FK `post`, image (mirror `ServiceImage`).
- `CommunityPostLike` — FK `post`, FK `user`, unique-together.
- `CommunityComment` (+ optional `CommunityCommentReply`) — mirror
  `ServiceComment` / `ServiceCommentReply`.
- REST endpoints: list (neighborhood + category + radius filtered), create,
  detail, like/unlike, comment CRUD. Follow existing DRF conventions in
  `services`.

**Frontend (`lib/pages/community/`):**
- `community_main.dart` — the rich-card feed with category filter chips,
  wrapped in `NeighborhoodGate`.
- `community_detail.dart` — post detail + comment thread.
- `community_composer.dart` — create-post form (category, body, photos).
- `providers/provider_root/community_provider.dart` — feed state + create.
- `communityNotificationProvider` — new notification provider (comments/likes
  on your posts), consistent with existing per-tab notification providers.
- `service/community_api_service.dart` — REST client.

### 2.3 Nearby (merge Services + Real Estate)

**Layout: category hub** — a landing screen of category cards the user drills
into:

- 🛠 **Services** — 🔒 neighborhood-gated (as today).
- 🏢 **Real Estate** — 🌍 city-scale, browsable without verification (as today).
- 💼 **Jobs** / 🏪 **Local shops** — greyed "Coming soon" placeholders (no
  functionality this spec).

v1 shows **category cards only** — no mixed "recent nearby" preview feed.

**Re-parenting:** existing Services and Real Estate screens/routes are reached
*from inside* the Nearby hub rather than from top-level tabs. Nothing about the
Services or Real Estate feature screens themselves changes — including
`real_estate/agent/*` (agent dashboard, become-agent) and both search screens.
Only their entry point moves.

**Per-category gating (decision):** `NeighborhoodGate` wraps only the Services
sub-view inside Nearby. Real Estate stays un-gated. Rationale: a plumber must be
close; an apartment can be anywhere in the city — the two verticals have
genuinely different locality.

### 2.4 Chat / My (keep as-is)

`MessagesList` and `ShaxsiyPage` unchanged apart from the label/index remap.

---

## 3. Compose model

Contextual per-tab compose (Karrot-style), no global "+":
- Home → "Sell an item"
- Community → "Write a post"
- Nearby → "Register a service" / "List a property" (from within the respective
  sub-view)

---

## 4. Cross-cutting mechanics (the risky part)

All of the following live in `lib/pages/tab_bar/tab_bar.dart` and must be
remapped consistently. The index shift is the main source of regressions.

| Concern | Today | After |
|---------|-------|-------|
| `_getPageInfo` index → page | 0 Products, 1 Services, 2 Chat, 3 RealEstate, 4 Profile | 0 Home(Products), 1 Community, 2 Nearby, 3 Chat, 4 My |
| `_selectPage` invalidations | `case 0 → productsProvider`, `case 1 → servicesProvider` | 0 → products; 2 → services/real-estate as needed |
| Search FAB (`_shouldShowSearchFAB`, `_navigateToSearch`) | indices 0,1,3 | index 0 (Home) + inside Nearby's sub-views; Community search deferred |
| Notification bell (`_getNotificationProvider`) | 0 product, 1 service, 2 chat, 3 realEstate | 0 product, 1 community, 2 (services+realEstate combined), 3 chat |
| Bottom-nav items (`_ModernBottomNav.items`) | 5 current icons/labels | 🏠 Home, 👥 Community, 📍 Nearby, 💬 Chat, 👤 My |
| `NeighborhoodGate` wrapping | Products, Services | Home, Community, and Services sub-view only |
| Deep links / `initialIndex` callers | old indices | audit every `TabsScreen(initialIndex:)` and `context.go('/…tab…')` caller for the new mapping |

**Notification provider for Nearby:** combine `serviceNotificationProvider` and
`realEstateNotificationProvider` unread counts for the single Nearby bell (or
show the badge on whichever sub-view is active). Keep it simple; exact rollup
can be refined in implementation.

**i18n:** new labels (`Home`, `Community`, `Nearby`, `My`) and Community strings
need entries in the EN/RU/UZ localization files, following the existing
`AppLocalizations` pattern.

---

## 5. Out of scope (deferred to Community deep-spec)

- Additional community categories (Ask-for-help, Hobby/Meetup, etc.), polls,
  local groups/clubs.
- Jobs and Local-shops verticals inside Nearby (placeholders only here).
- Community search, rich moderation tuning, notifications beyond
  like/comment-on-your-post.
- Any mixed "recent nearby" aggregate feed in the Nearby hub.

---

## 6. Success criteria

1. New five-tab bar renders with correct labels/icons/order and correct active
   states.
2. Community v1: a verified user can create a post (category + body + optional
   photos), see it in the neighborhood-gated feed, like it, and comment.
3. Nearby hub lists category cards; Services opens gated, Real Estate opens
   city-scale; existing service/real-estate/agent flows all still reachable.
4. No regressions from the index remap: search FAB, notification bells, deep
   links, and `NeighborhoodGate` all behave correctly per §4.
5. All new user-facing strings localized in EN/RU/UZ.
