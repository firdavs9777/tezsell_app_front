# Plan E — Profile Advanced (Trust Surface)

> **For agentic workers:** REQUIRED SUB-SKILL: superpowers:subagent-driven-development. Spec+plan combined; survey-grounded. Execute after Plan D (path fixes + trust block land there) and Plan A (sold flow feeds reviews).

**Goal:** Surface the complete-but-invisible Karrot trust system on profiles, add review flows tied to transactions, and finish my-listings management (sold/hide), analytics entry, vacation mode.

**Key survey findings:**
- Backend trust system is COMPLETE (`Transaction`→`Review`(tags, buyer/seller)→`UserTrustScore` manner temp + badges) with zero UI consumers.
- Own profile header shows only Listings/Followers/Following; public profile (`user_profile_screen.dart`) shows no rating/trust/vacation either.
- My-listings has edit/delete but NO mark-sold/hide.
- `seller_analytics_screen.dart` exists but unlinked from profile menu; vacation-mode widgets + backend exist, toggle not placed.
- Review flow: Plan A emits a review CTA on "sold" — this plan builds the screen it opens.

## Global Constraints
- Branches: backend `feat/profile-advanced-backend`, Flutter `feat/profile-advanced`. i18n EN/RU/UZ + committed generated l10n.

## Tasks

### Task 1 (BE): Transaction auto-creation + review eligibility
Files: `reviews/views.py`, chat transaction hook (Plan A's `RoomTransactionView`), tests.
- On `sold` action in a product chat room: create/update `reviews.Transaction` (buyer = other participant, seller, item = product, status `completed`, `agreed_price` = product price). Idempotent per (room, product).
- `GET /api/reviews/pending/` → transactions where requester hasn't reviewed yet (powers CTA + profile nudge).

### Task 2 (FE): Write-review screen
Files: new `lib/pages/reviews/write_review_screen.dart`, `reviews_provider.dart`, route `/review/write/:transactionId`.
- Stars (1–5), Karrot-style quick tags (from backend `ReviewTag` list), optional text; submit → `POST` review; chat CTA (Plan A) and pending-review nudge route here.

### Task 3 (FE): Trust on public profile
Files: `lib/pages/profile/user_profile_screen.dart`.
- Manner-temperature dial (reuse `trust_score_widget.dart`), rating avg + review count, badges row, vacation badge (`VacationBadge`); "Reviews (N)" section → reviews list screen (paginated, tag chips + stars + text).

### Task 4 (FE): Trust on own profile
Files: `profile_header.dart`, `shaxsiy.dart`.
- Header adds temperature chip next to avatar; new menu entries: "My reviews" (received/given tabs), "Pending reviews (N)" nudge card when nonzero, "Seller analytics" (links existing screen), Vacation mode toggle (existing widget) in settings section.

### Task 5 (FE+BE): My-listings management v2
Files: `my_products.dart`, `my_services.dart`; BE: verify product PATCH permits owner `is_sold`/`is_active` (extend `UserProfileProduct*` views if not), tests.
- Per-listing overflow: Mark sold / Back to available / Hide (is_active=False) / Edit / Delete; sold items get overlay + move to a "Sold" tab. Mark-sold prompts buyer pick from that product's chat rooms (Plan A linkage) to create the Transaction — skippable ("sold elsewhere").

### Task 6 (FE): Followers polish
Files: `profile_follow_list_sheet.dart`, `user_profile_follow_list.dart`.
- Unify the two implementations into one widget; show trust temp per row; follow/unfollow optimistic.

### Task 7: Integration verification
- Suites green/analyze clean; smoke: sell in chat → both sides review → temperatures move; public profile shows dial/badges/reviews; my-listings sold/hide; vacation toggle reflects on public profile.

## Out of scope
Badge gamification UI beyond display, profile sharing QR, ID verification, business profiles.
