# Plan D — Home / Products Advanced

> **For agentic workers:** REQUIRED SUB-SKILL: superpowers:subagent-driven-development. Spec+plan combined; survey-grounded. Execute after Plan A (uses `is_reserved` from A-Task-4 and listing-anchored chat entry).

**Goal:** Karrot-grade home feed and product page: real filters & sorts, wired offers (backend already complete), seller trust block on the PDP, saved-search alerts, recently-viewed, and interest counters.

**Key survey findings this plan exploits (all "built but unwired"):**
- **Offers**: full backend negotiation flow (`reviews/models.py:Offer`, accept/decline/counter views) + `MakeOfferButton` widget exist — but the button is never placed on `product_detail.dart`. The offers inbox exists with nothing feeding it.
- **Trust**: `UserTrustScore` (manner temperature 36.5°C), `Review`, `trust_score_widget.dart` all exist, UI never imports them — AND Flutter calls wrong paths (`trust-score/` vs backend `score/`; `users/<id>/reviews/` vs `user/<id>/`), so it silently no-ops.
- **Saved searches + alerts**: providers/services fully built (`saved_searches_*`, `search_alerts_*`), zero UI entry points. `favorites.SavedSearch` even stores min/max price that nothing uses.
- **Recently viewed**: model+provider+service built, never surfaced.
- `BaseListingListView.get()` hardcodes `-created_at`; no price/condition params server-side. `viewCount` never incremented.

## Global Constraints
- Branches: backend `feat/products-advanced-backend`, Flutter `feat/products-advanced`. i18n EN/RU/UZ + committed generated l10n. Targeted git adds only.

## Tasks

### Task 1 (BE): List API — sorts + filters + view counting
Files: `myproject/utils/mixins.py`, `products/views.py`, tests.
- Params: `price_min`, `price_max`, `condition` (new|used), `sort` in `fresh|price_asc|price_desc|popular` (popular = `-likeCount, -viewCount`). Nearest arrives via Plan B — keep param namespace compatible.
- `ProductDetailView.get` increments `viewCount` via `F()+1` (throttle: only when viewer != owner).
- Tests: each param, combined, ordering.

### Task 2 (BE): Fix trust/review path drift + PDP payload
Files: `reviews/urls.py` (add alias routes matching Flutter: `trust-score/<user_id>/`, `users/<user_id>/reviews/` — keep old paths), `products/serializers.py`, tests.
- Product detail serializer gains `seller` block: `{id, username, avatar, trust_temperature, rating_avg, review_count, response_label}` sourced from `UserTrustScore` (null-safe defaults 36.5/0).

### Task 3 (BE): Card interest counters
Files: `products/serializers.py`, `products/views.py`, tests.
- List serializer adds `chat_count` (ChatRoom rows with `product_id=<id>` — from Plan A linkage) alongside existing `likeCount`. Detail too.

### Task 4 (FE): Filters & sort UI
Files: `products_list.dart`, new `lib/pages/products/widgets/product_filter_sheet.dart`, `product_provider.dart`.
- Filter sheet: price range (min/max fields), condition toggle, applied-filters chips row; sort dropdown (Fresh/Nearest*/Price ↑/Price ↓/Popular — Nearest greyed until Plan B lands). Provider threads params.

### Task 5 (FE): Offers wired end-to-end
Files: `product_detail.dart` (place `MakeOfferButton` — respect `accepts_offers`/`minimum_offer_percent`), `offers_screen.dart` (accept/decline/counter actions verified against backend), seller notification tap-through.
- Offer accepted → prompt "chat with buyer" via Plan A `startFromListing`.

### Task 6 (FE): Seller trust block on PDP
Files: `product_detail.dart`, reuse `trust_score_widget.dart`, `reviews_service.dart` (verify paths now resolve after Task 2).
- Seller section becomes: avatar, name, manner-temperature dial (compact), rating stars + count, tap → public profile. Cards: "N ❤ · N 💬" counter row using Task 3 fields.

### Task 7 (FE): Saved searches + keyword alerts UI
Files: `product_search.dart`, new `saved_searches_screen.dart`, wire `saved_searches_provider` + `search_alerts_provider`.
- Search screen: bell-plus "Save this search" (query + current filters), manage screen (list/delete/toggle alert); alert hits ride the existing notification bell (verify backend emits — if `search_alerts` backend delivery is absent, alerts are local-only v1: on app open, run saved queries, badge new counts — implementer verifies backend support first and documents which mode shipped).

### Task 8 (FE): Recently viewed + sold/reserved chips
Files: `products_list.dart` (horizontal "Recently viewed" strip above feed via existing `recently_viewed_provider`; record views on PDP open), product cards (Reserved amber chip from `is_reserved`, Sold overlay already exists).

### Task 9: Integration verification
- Backend pytest green; analyze clean; smoke: filter+sort combos, make offer→counter→accept→chat, trust block renders real data, save search→alert, recently-viewed strip, reserved chip.

## Out of scope
Recommendation ranking/ML, promoted listings, price-drop tracking, bulk seller tools.
