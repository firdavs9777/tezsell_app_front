# Plan B — Nearby + Map, Karrot-Grade

> **For agentic workers:** REQUIRED SUB-SKILL: superpowers:subagent-driven-development. Execute AFTER Plan A. Design decisions embedded below (spec+plan combined; survey-grounded).

**Goal:** Turn Nearby into a real Karrot "내 근처": distance-aware browsing, map browse for ALL verticals (real estate included), marker clustering, ratings surfaced on services, working real-estate search, and one shared geo pipeline.

**Key survey findings this plan exploits:**
- Real-estate map endpoints ALREADY EXIST (`real_estate/urls.py`: `/api/map/bounds/`, `/api/map/stats/`, `PropertyMapSerializer`) — zero-backend map browse for properties.
- `ItemsMapView` (flutter_map/OSM multi-pin) already proven on Products/Services; Real Estate has none.
- Geo filtering is a duplicated bounding-box hack (`myproject/utils/mixins.py` + `real_estate/views/filters.py`) — no distance values, no nearest-sort.
- `reviews.Review`/`UserTrustScore` exist but no rating surfaces on service cards/detail.
- `real_estate_search.dart` is a dummy stub. `lib/service/places_service.dart` is a 0-byte dead file.

## Global Constraints
- Repos/branches: backend `feat/nearby-map-advanced-backend`, Flutter `feat/nearby-map-advanced`. Chat endpoints/branches from Plan A must be merged first.
- Map stack stays **flutter_map + OSM** (provider abstraction untouched; no Google SDK).
- No PostGIS migration — annotate haversine distance in Python/SQL on the bbox-prefiltered queryset (bbox prefilter keeps it cheap).
- i18n EN/RU/UZ for all new strings; generated l10n committed.

## Tasks

### Task 1 (BE): Shared geo pipeline + distance annotation
Files: `myproject/utils/mixins.py`, `real_estate/views/filters.py`, tests.
- Extract one `apply_geo_filter(qs, lat, lng, radius_km)` used by BOTH mixin and PropertyFilter (kill the duplicate).
- Add haversine `distance_km` computed per row post-bbox (Python annotate on the page slice — page sizes ≤20 make this trivial) and include in list serializers when center provided.
- New `sort=nearest` param: order the page candidates by computed distance (bbox-prefiltered qs, `order_by` fallback `-created_at`).
- Tests: bbox correctness, distance value sanity (known coords), nearest ordering.

### Task 2 (BE): Service rating aggregation on list/detail
Files: `services/serializers.py`, `services/views.py`, tests.
- Add `rating_avg`, `rating_count` to service list/detail serializers, aggregated from `reviews.Review` via seller's completed transactions on that listing type (verify the generic-FK linkage in `reviews/models.py`; if reviews attach to transactions on the LISTING, aggregate per listing; else per seller — implementer confirms and documents which).
- Tests for aggregation correctness + null-safe when no reviews.

### Task 3 (FE): Distance labels + nearest sort UI
Files: `products_list.dart`, `main_service.dart`, `real_estate_main.dart`, product/service card widgets, providers.
- Cards show "1.2 km" chip when `distance_km` present. Sort control (Fresh | Nearest) wired to `sort=nearest`.
- i18n keys: `sortFresh`, `sortNearest`, `distanceKm` (ICU `{km}`).

### Task 4 (FE): Real-estate map browse (list↔map toggle)
Files: `real_estate_main.dart`, new `lib/pages/real_estate/real_estate_map_view.dart`, `real_estate_provider.dart`.
- Bounds-fetch `GET /real_estate/api/map/bounds/?north=…` on camera idle (debounced 400ms), render pins via `ItemsMapView` pattern (price-labeled markers), tap → preview card → detail. Toggle identical UX to products/services.

### Task 5 (FE): Marker clustering everywhere
Files: `lib/widgets/maps/items_map_view.dart`, pubspec (`flutter_map_marker_cluster` or supercluster package — implementer picks the maintained one compatible with the pinned flutter_map version).
- Cluster badges with counts; splits on zoom; products/services/real-estate all inherit via `ItemsMapView`.

### Task 6 (FE): Real-estate search — implement for real
Files: `real_estate_search.dart`, `real_estate_provider.dart`.
- Wire to existing backend property filters (title/district/price/beds/type); debounced query, recent searches (SP), empty/error states. Kill the hardcoded dummies.

### Task 7 (FE): Nearby hub v2
Files: `nearby_hub.dart`, new `nearby_feed_strip.dart`.
- Keep category cards; add a "Near you now" horizontal strip above them: latest 10 items across services+properties within active radius (two parallel fetches, merged by distance) with distance chips; tap-through.
- Rating stars on the Services card row items (from Task 2 fields) + on service list cards/detail header.

### Task 8 (FE): Radius UX upgrade
Files: `radius_slider.dart`, `neighborhood_switcher_sheet.dart`.
- Replace preset chips with a bottom-sheet map preview: circle overlay on active neighborhood + slider (1–20km continuous) + City option; persists to existing `radiusProvider`. (No polygon draw — out of scope.)

### Task 9 (Cleanup): dead code + audit
- Delete `lib/service/places_service.dart` (0 bytes). Verify `change_city.dart` route still needed after neighborhood management (if unreachable, note for Plan G — don't delete yet).
- `flutter analyze` + backend pytest green. Final smoke: map browse all three verticals, clustering, nearest sort, radius sheet.

## Out of scope
POI/local-business layer, Jobs/Shops verticals, polygon draw, PostGIS, Google Maps swap.

## Open questions (flag before execution)
1. Rating aggregation basis: per-listing vs per-seller (Task 2) — implementer investigates, controller decides.
2. Cluster package choice given flutter_map version pin.
