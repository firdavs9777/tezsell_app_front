# Internationalization & Maps — Design Doc

**Date:** 2026-05-10
**Status:** Approved by user (sections 1–5)
**Implementation skill next:** `superpowers:writing-plans`
**Phase 1 commitment:** Yes (this doc)
**Phases 2–4 commitment:** Roadmap only

## TL;DR

Replace the static OSM image map with an interactive `flutter_map`-powered location system, add a Carrot-Korea-style neighborhood verification model, and lay foundations for full multi-language internationalization in later phases. Phase 1 ships only the map + neighborhood work; languages, country/region globalization, currency expansion, and address-format polish stay on the roadmap.

---

## 1. Roadmap

### Phase 1 (this design — committed)
*"Maps, properly. Carrot-style location model."*

- Replace static OSM image map with interactive `flutter_map` everywhere a map appears
- Map-first picker (drop pin / drag / GPS) for property + service creation
- Photon-powered autocomplete search in the picker
- Backend gains `place_id` / `formatted_address` / `country_code` / `region` / `city` on property + service location schemas
- One-time backfill of existing listings via reverse-geocoding script
- **Carrot-style profile-level neighborhood verification** (1–2 neighborhoods, GPS-within-100m enforcement, 60-day re-verify cadence)
- **Visibility filtering** for products + services by user's verified neighborhoods + radius slider
- Real estate stays city-scale (no neighborhood filter)
- Listing privacy: approximate ~300m circle on products/services detail until buyer-seller chat initiated; real estate exact pin
- `change_city` page becomes implicit (derived from verified neighborhood; page itself unlinked from primary nav)
- "Expand to city" fallback when neighborhood is empty
- New strings added to existing EN/UZ/RU ARBs only — no new languages yet

### Phase 2 — Locale expansion + auth internationalization (deferred)
- Locale whitelist becomes config-driven (driven by ARB files present, not a hardcode)
- RTL plumbing (`Directionality`, mirrored widgets, asset variants)
- Add 3–5 new languages including 1 RTL (Arabic baseline)
- Wire the unused `country_code_picker` for phone auth
- Currency expansion: full ISO 4217 instead of ex-Soviet-only
- Translation pipeline (machine-translate ARBs as a baseline, human-review)

### Phase 3 — Search-by-map + real-estate radius (deferred)
- "Search this area" / draw-on-map for products/services
- Radius search for real estate
- Saved searches with location alerts

### Phase 4 — Per-country polish + provider swap (deferred)
- Per-country address formats
- Per-country phone formats
- Region-specific defaults (e.g. KR → KRW + Seoul-area neighborhood pre-fill)
- Tile/geocoding provider swap from public OSM to vendor (MapTiler) once traffic justifies it

---

## 2. Phase 1 Scope (Locked Decisions)

### Touchpoints
- Property detail page → embedded interactive map
- Property creation → full-screen map-first picker
- Service detail page → embedded interactive map
- Service creation → full-screen map-first picker
- Profile / first-launch → neighborhood verifier flow
- Products tab + Services tab → radius slider + neighborhood badge

### Out of scope (deferred)
- Search-by-map / draw-on-map → phase 3
- Real-estate radius / draw-on-map → phase 3
- New languages → phase 2
- RTL → phase 2
- Country/phone/currency picker → phase 2
- `change_city` UI rebuild → phase 2 (page exists but unlinked from primary nav)

### Map / geo stack
- **Map widget:** `flutter_map` (already in `pubspec.yaml`, currently unused)
- **Tiles:** OSM raster tiles (`tile.openstreetmap.org`), with proper attribution + User-Agent header
- **Geocoding (lat/lng ↔ address):** Nominatim public free instance
- **Place search / autocomplete:** Photon public free instance (`photon.komoot.io`)
- **GPS:** existing `geolocator` package
- **Wrapper:** `MapsProvider` interface so phase 4 can swap to MapTiler / Mapbox / Google Maps without UI refactor

### Carrot-style neighborhood model
- User can verify **1–2** neighborhoods on profile
- Verification requires **GPS accuracy ≤100m** (otherwise rejected, retry up to 3x with "low confidence" escape)
- **Re-verify every 60 days**, soft prompt 3x then mandatory before products/services nav
- Verified neighborhoods persist on backend (User model), survive reinstall
- **Server-side re-verify** of GPS accuracy (anti-spoof — reject implausibly precise readings)
- **Rate limit:** max 5 verify attempts per user per 24h
- Categories that use neighborhood filtering: **products + services**
- Categories that don't: **real estate** (stays city-scale)
- Empty neighborhood fallback: explicit "Expand to {city}" button (no silent expansion)

### Listing privacy (phase 1)
- Products + services: detail-page map shows **300m approximate circle**, exact pin hidden
- Exact pin **revealed when buyer initiates chat** with seller (both parties see exact pin from then on)
- Real estate: exact pin always shown (industry-standard for real estate)

### Migration strategy
- **Backend:** one-time `python manage.py backfill_locations` reverse-geocodes existing properties + services via Nominatim, populates new fields. Idempotent. Rate-limited 1 req/sec (~3h overnight for ~10k records).
- **Frontend:** existing users see one-time forced verification prompt on first launch after upgrade. Cannot use products/services tabs until they verify. Real estate accessible without verification.
- **Backend deploy must precede frontend deploy.** Old client + new backend works (params are optional). New client + old backend would 404 on `/verify_neighborhood` POST — handled gracefully but degraded UX.

---

## 3. Architecture

### Layer 1: `MapsProvider` abstraction (`lib/services/maps/`)

```dart
abstract class MapsProvider {
  Future<List<Place>> searchPlaces(String query, {LatLng? near, String? sessionToken});
  Future<Place> reverseGeocode(LatLng latLng);
  Future<Place> forwardGeocode(String address);
  Future<Neighborhood?> getNeighborhood(LatLng latLng);
  TileLayer get tileLayer;
  Widget get attributionBadge;
}
```

- **Phase 1:** `OsmMapsProvider` (Nominatim + Photon + OSM tiles)
- **Future:** `GoogleMapsProvider`, `MapTilerProvider` drop-in replacements
- Active provider selected via `mapsProviderProvider` Riverpod state

### Layer 2: UI widgets (`lib/widgets/maps/`)

| Widget | Replaces / new | Used in |
|---|---|---|
| `MapView` | Replaces `property_map_widget.dart` static-image guts | Property + service detail pages |
| `LocationPicker` | New | Property + service creation flows |
| `PlaceSearchField` | New | Inside `LocationPicker` |
| `NeighborhoodVerifier` | New | Profile, post-launch forced flow |
| `RadiusSlider` | New | Products + services list filter bar |

### Layer 3: Domain models (`lib/providers/provider_models/`)

```dart
class Place {
  final String? placeId;       // OSM place_id or null if not from a provider lookup
  final String? formattedAddress;
  final double lat;
  final double lng;
  final String? countryCode;   // ISO 3166-1 alpha-2
  final String? region;
  final String? city;
  final String? neighborhood;  // smallest admin level available
}

class Neighborhood {
  final String id;             // composite: "{country_code}:{osm_place_id}" or similar
  final String name;
  final String displayName;    // localized: "Yunusabad, Tashkent, Uzbekistan"
  final String countryCode;
  final String region;
  final String city;
  final double centroidLat;
  final double centroidLng;
}

class VerifiedNeighborhood {
  final Neighborhood neighborhood;
  final DateTime verifiedAt;
  final double gpsAccuracyM;
  final bool lowConfidence;    // user accepted >100m accuracy
}
```

### Layer 4: State (`lib/providers/provider_root/`)

- `verifiedNeighborhoodsProvider` — StateNotifier persisting to backend (so it survives reinstall) + cached in SharedPreferences
- `activeNeighborhoodProvider` — which of the 1–2 the user is browsing in
- `radiusProvider` — selected radius (1km / 3km / 5km / 10km / "city")
- Existing `productProvider` + `serviceProvider` extended with optional `neighborhoodId` + `radiusKm` query params
- Existing `realEstateProvider` unchanged

### Layer 5: Backend integration (Django)

**Models extended:**
- `Property.location` → adds `place_id`, `formatted_address`, `country_code`, `region`, `city`
- `Service.location` → same five fields
- `User` → adds `verified_neighborhoods` (JSON or related table) with up to 2 entries

**Endpoints extended:**
- `GET /api/products/?neighborhood_id=X&radius_km=Y` (both optional; absent → all listings)
- `GET /api/services/?neighborhood_id=X&radius_km=Y`
- `POST /api/users/me/verify_neighborhood` — validates GPS accuracy server-side, reverse-geocodes, persists
- `DELETE /api/users/me/verified_neighborhoods/{id}`

**Real estate endpoints:** unchanged.

### Layer 6: Migration

- `python manage.py backfill_locations` — Django management command, rate-limited Nominatim reverse-geocode for every Property + Service. Idempotent (only fills records where `place_id IS NULL`). Logs failures per-record.
- Frontend gates `products` + `services` tabs behind `verifiedNeighborhoodsProvider.isNotEmpty`; first-launch users see `NeighborhoodVerifier` modal.

### Cleanup that comes along

- Delete `property_map_widget.dart`'s `staticmap.openstreetmap.de` URL builder — replace internals with `MapView`
- Remove `change_city` from primary nav (page itself stays for phase 2)
- Wire the dormant `flutter_map` + `latlong2` deps that have been sitting in pubspec unused

---

## 4. Data Flows

### Flow 1: Verify a neighborhood

1. User taps "Verify Neighborhood"
2. `geolocator.getCurrentPosition(desiredAccuracy: best)`
3. If accuracy >100m → "Move to an open area" sheet, retry; after 3 fails offer "low confidence" escape
4. `mapsProvider.getNeighborhood(latLng)` via Nominatim reverse-geocode
5. Confirm sheet: "You're in {neighborhood.displayName}, {city}, {country}" with [Confirm] [Cancel]
6. `POST /api/users/me/verify_neighborhood {lat, lng, accuracy, neighborhood_id}`
7. Backend re-verifies accuracy server-side (anti-spoof), persists, returns updated user
8. `verifiedNeighborhoodsProvider` state updates
9. If user has <2 verified, show "Add a second neighborhood?" CTA (dismissible)

### Flow 2: Create a property/service with map picker

1. User taps "Sell an item" / "Post a service"
2. Standard form fields (title, description, photos)
3. User taps "Set location" field
4. `LocationPicker` opens full-screen, map-first, centered on user's verified neighborhood
5. User can: drag the pin, tap to drop pin, type to search (Photon autocomplete), or tap "Use current GPS"
6. Each gesture triggers reverse-geocode → updates the address bar at top
7. User taps "Confirm location"
8. Form receives `Place`
9. On submit: `POST /api/products/` (or `/api/services/`) — backend persists all five new fields + lat/lng

### Flow 3: View a property/service detail

1. `GET /api/products/{id}` → `Place` fields included in response
2. `MapView` renders:
   - Real estate → exact pin at (lat, lng)
   - Product / service → approximate circle (300m) centered at (lat, lng), no pin
3. After buyer initiates chat (products/services only):
   - `POST /api/conversations` creates the chat + flips a flag on the listing-conversation pair
   - Both parties' detail-page maps now show the exact pin (not just the circle)

### Flow 4: Browse products/services

1. User opens products tab
2. Read `activeNeighborhoodProvider` + `radiusProvider` from state
3. `GET /api/products/?neighborhood_id=X&radius_km=Y`
4. Empty result → show "No items in {neighborhood.name} within {radius}km" + "Expand to {city}" button (re-fetches with `neighborhood_id` only, no radius)
5. List renders normally
6. User changes radius via slider → re-fetch (debounced 300ms)
7. User taps neighborhood badge in nav → switches `activeNeighborhoodProvider` between the 1–2 verified

### Flow 5: Migration day

**Backend (run before phase 1 ships):**
1. `manage.py backfill_locations`
2. For each Property/Service with `lat,lng` but no `place_id`: Nominatim reverse-geocode (rate-limited 1 req/sec)
3. Save `place_id`, `formatted_address`, `country_code`, `region`, `city`
4. ~10k records → ~3 hours overnight, $0 cost

**Frontend (phase 1 release):**
1. On app launch: `GET /api/users/me`
2. If `user.verified_neighborhoods.isEmpty`: show `NeighborhoodVerifier` as modal bottom sheet on first navigation to products or services tab
3. Real estate tab unaffected
4. User completes Flow 1 → tab unlocks

**Re-verify cadence:**
1. On launch, for each verified neighborhood: if `(now - verifiedAt) > 60 days` → mark as expired
2. First expired neighborhood → soft prompt on next products/services nav, dismissible 3 times
3. 4th launch with expired → mandatory verify before products/services unlock

---

## 5. Error Handling & Edge Cases

### External-service failures

| Failure | Detection | UX | Recovery |
|---|---|---|---|
| Nominatim down / 503 | HTTP timeout or 5xx | "Couldn't identify your neighborhood right now" sheet with retry | Retry up to 2x with backoff. After 3 fails, fallback to forward-geocoding from `lat,lng` and persist as **unverified**. Re-resolve on next launch. |
| Nominatim 429 | HTTP 429 | Same UX as above | Backoff longer (10s, then 30s). Log to AppLogger so we can monitor frequency — signal to migrate to MapTiler. |
| Photon down (search) | Empty/error response | "Search unavailable — drop a pin instead" inline | Picker still works via map gesture + reverseGeocode |
| OSM tile server down / 502 | `flutter_map` `errorBuilder` | Tiles show as gray; toast: "Map tiles unavailable" | Picker still functions (markers drawn via overlay layer, not tiles) |
| GPS off | Permission/getCurrent error | "Turn on location" sheet → opens Settings | User cannot complete verification. Tab stays gated. |
| Permission `deniedForever` | Permission status | Sheet: "Location is required for products/services. Real estate works without it." → Open settings | Real estate accessible. Products/services stay gated. |
| GPS accuracy >100m | `Position.accuracy` exceeds threshold | "Move to an open area" with current accuracy in meters | Retry. After 3 attempts, offer "low confidence" escape (saves with `low_confidence: true` for moderation) |

### Coverage / data-quality edges

| Case | Behavior |
|---|---|
| Nominatim returns no admin neighborhood (rural area, OSM gap) | Fall through admin levels: suburb → village → district → region. Note in confirm sheet: "Specific neighborhood unavailable — using {fallback level}". Still saves as verified. |
| Reverse-geocode wrong country (border/GPS drift) | Show country prominently in confirm sheet. User must tap Confirm explicitly. No silent acceptance. |
| User abroad / VPN / shifted GPS | No-op. Trust the GPS reading. We do not cross-check IP. User can legitimately verify abroad. |
| Photon returns 0 results | "No matches — try broader term, or drop a pin." Picker stays usable. |
| Photon results in wrong country | Sort user's country first; don't hide other-country results (user might be searching abroad). |

### Listing visibility edges

| Case | Behavior |
|---|---|
| User has 1 verified, switches to empty second slot | Empty slot shows "Add a neighborhood" CTA |
| Only verified neighborhood expires | Soft prompt 3x, then mandatory verify before products/services. Real estate unaffected. Owner's existing listings unaffected. |
| Empty radius result | "No items in {neighborhood} within {radius}km" + "Expand to {city}" button |
| User deletes a verified neighborhood that has tagged listings | Listings keep their original `place_id`/lat/lng. They don't follow user verification state. (Owner location and listing location are independent.) |

### Backend-service failures

| Failure | Behavior |
|---|---|
| `POST /verify_neighborhood` 5xx | Retry sheet. State stays unverified locally; SharedPreferences cache only updates after backend success. |
| `GET /api/products/?neighborhood_id=…` 5xx | Existing list error UI + retry button |
| Backfill script crashes mid-run | Idempotent (only fills `place_id IS NULL`). Re-run picks up. Per-record failure logs. |

### Migration / cross-version edges

| Case | Behavior |
|---|---|
| Old client (pre-phase-1) hits new backend | Backend ignores `neighborhood_id` if absent. Old client gets unfiltered list — same as today. No-break. |
| New client + old backend (during deploy gap) | `verify_neighborhood` 404 → caught and shown as "Verification temporarily unavailable" rather than blocking. Backend deploy must precede frontend. |
| Migration script never run | Existing listings have no `place_id`. Detail map still works (uses lat/lng). Browse filter excludes them (no neighborhood association) — they disappear from results. **Hard requirement: backfill runs before phase 1 client ships.** |

### Anti-abuse

- **Server-side accuracy re-check:** backend rejects verifications with implausibly precise GPS (e.g. <1m claimed accuracy from a desktop browser).
- **Verification velocity rate limit:** max 5 verify attempts per user per 24h.
- **No IP geofencing in phase 1.** Too many false positives (VPNs, travelers). Revisit if abuse becomes real.

---

## 6. Testing

### Unit tests (Dart, `test/`)
- `OsmMapsProvider` — mock HTTP. Search returns parsed `Place` list, reverse-geocode handles 200/429/500/empty admin level, `getNeighborhood` falls back through admin levels (suburb → village → district → region)
- `verifiedNeighborhoodsProvider` — add/remove, max-2 enforced, expiration, persistence to SharedPreferences mock
- `radiusProvider` — default value, persistence, change notifies dependent providers
- `Place` / `Neighborhood` JSON parsing — round-trip with backend response shapes; missing-fields tolerance for migration period
- Privacy circle math — center + 300m radius rendering, transition to exact pin on contact flag

### Widget tests (`test/`)
- `LocationPicker` — tap on map → marker moves + reverse-geocode + address bar updates. Type → autocomplete. Confirm → returns Place.
- `NeighborhoodVerifier` — GPS denied → "open settings" sheet. Accuracy >100m → retry. Successful verify → POST + state update.
- `RadiusSlider` — drag → debounced state change. Renders correct radius labels in active locale.
- `MapView` (read-only) — pin for real estate, circle for product/service, attribution badge visible.

### Integration tests (`integration_test/`)
1. **Verify-and-browse**: cold launch → mocked GPS → verify neighborhood → land on products tab → list filtered by neighborhood (assert filter param in network call).
2. **Create-and-display**: create a property using `LocationPicker` → submit → navigate to detail → assert `MapView` renders with chosen Place (assert `place_id`/`formatted_address` end-to-end).

### Backend tests (Django)
- `verify_neighborhood` — accepts valid GPS, rejects accuracy >100m, rejects 6th attempt in 24h (rate limit), rejects implausible accuracy (anti-spoof)
- `Property.create` with new fields — persists all five, backwards-compatible with old clients omitting them
- `/api/products/?neighborhood_id=X&radius_km=Y` — filters correctly, ignores absent params, handles invalid `neighborhood_id` gracefully
- `backfill_locations` — idempotent, rate-limited, per-record failure logging, doesn't double-fill

### Manual test plan (real hardware, iOS + Android)
1. First-launch verification flow on fresh install — GPS accuracy, confirm neighborhood, products/services tabs gated until verified, real estate not gated
2. Create a listing in each of: products, services, real estate. Map picker UX in each, `place_id` ends up in network request
3. Detail page maps: products/services show 300m circle, real estate shows exact pin
4. Privacy circle reveal: initiate a chat from product detail (different user). Reload detail. Confirm exact pin now visible
5. Re-verify after 60 days: fast-forward `verifiedAt` via debug build. Soft prompt → 4th launch mandatory
6. Empty radius result: verify in low-density neighborhood. Browse with 1km radius. "Expand to city" button works
7. OSM tile failure: block `tile.openstreetmap.org`. Map shows gray + toast, picker still functions
8. Nominatim 429: forced rate-limit response. Graceful fallback message, no crash
9. GPS denied: system-level deny. "Open settings" path works, no crash
10. Listings backfill verification: open a property listed before phase 1, confirm `formatted_address` present, appears in browse with correct neighborhood

### Performance smoke
- `flutter_map` with 100 pins — measure frame rate. Target: 60fps on a mid-tier 2022 Android.
- Photon autocomplete latency from public instance, p95. If >2s, surface "search is slow" hint after 1.5s loading.
- Reverse-geocode in picker after each pan-stop — debounced 500ms to avoid hammering Nominatim.

---

## 7. Backend Coordination (Django)

This design assumes backend access (confirmed: user controls the backend repo). Backend work is on the critical path for phase 1; cannot ship frontend without it.

**New backend tasks (rough order):**

1. Schema migration: add `place_id`, `formatted_address`, `country_code`, `region`, `city` to `Property.location` + `Service.location`
2. Schema migration: add `verified_neighborhoods` to User (JSONField with list-of-2, or related table — engineer's choice)
3. Endpoint: `POST /api/users/me/verify_neighborhood` (validation, anti-spoof, rate limit, persistence)
4. Endpoint: `DELETE /api/users/me/verified_neighborhoods/{id}`
5. Filter params on existing `GET /api/products/` + `GET /api/services/` (`neighborhood_id`, `radius_km` optional)
6. Conversation creation flips a "buyer-contacted" flag on the property/service for the privacy-pin reveal
7. Management command: `backfill_locations` — Nominatim reverse-geocode existing data, idempotent, rate-limited
8. Backend tests (see section 6)

**Deploy order:** backend → run backfill → frontend.

---

## 8. Risks & Open Questions

### Risks

| Risk | Likelihood | Mitigation |
|---|---|---|
| Public Nominatim / Photon ToS pushback at scale | Low for phase 1, medium long-term | `MapsProvider` abstraction lets us swap to MapTiler in phase 4 without UI rewrite. Monitor 429 rate. |
| OSM admin coverage poor in user's region (Carrot model degrades) | Medium in Central Asia | Fallback through admin levels (suburb → village → district → region). Accept low-resolution neighborhoods rather than refusing verification. |
| Existing users frustrated by forced verification | Medium | One-time event. Real estate tab still works without it. Soft messaging at the prompt. |
| Backend deploy lag breaks new clients | Low if coordinated | Deploy backend first; frontend release blocked on backfill completion |
| Ten thousand reverse-geocode calls hit Nominatim ToS | Low at 1 req/sec for 3h overnight | Schedule low-traffic window; communicate via User-Agent header per OSM ToS |
| User abuse of "low confidence" escape to verify wherever | Low | Backend logs `low_confidence: true` separately; can flag for moderation if abuse emerges |

### Resolved during brainstorm
- ~~Google Maps vs OSM~~ → OSM (cost-driven; swap path exists)
- ~~Phase 1 scope = locales or maps?~~ → Maps; locales are phase 2
- ~~Carrot mechanics: how strict?~~ → Strict (a + c + e from question 11)
- ~~Backend control?~~ → Yes, schema can change
- ~~Migration?~~ → Backfill listings, force user re-verify
- ~~Categories using neighborhood model?~~ → Products + services only; real estate stays city-scale

### Still open (can be deferred to plan / phase 2)
- Self-host vs continue-with-public for Nominatim/Photon long-term — defer to phase 4 or until 429 monitoring forces the issue
- `change_city` page disposition long-term — defer to phase 2 country picker work; phase 1 just unlinks it from primary nav
- Concrete language list for phase 2 — defer to phase 2 brainstorm
- Translation pipeline (machine-translate vs crowdsource vs vendor) — defer to phase 2

---

## 9. Implementation Order Hint (for `writing-plans`)

This is a hint, not a prescription — `writing-plans` will produce the actual ordered plan.

**Suggested independent tracks (parallelizable where appropriate):**

- **Track A — `MapsProvider` foundation:** abstraction interface, `OsmMapsProvider` impl, basic widget tests. Unblocks every other track.
- **Track B — Backend schema + endpoints:** migrations, new endpoints, backend tests. Independent of frontend tracks.
- **Track C — UI widgets:** `MapView`, `LocationPicker`, `PlaceSearchField`, `NeighborhoodVerifier`, `RadiusSlider`. Depends on Track A.
- **Track D — Riverpod state:** `verifiedNeighborhoodsProvider`, `activeNeighborhoodProvider`, `radiusProvider`. Depends on Track B (for backend sync).
- **Track E — Wire-up:** plug widgets into property/service detail + create flows, gate products/services tabs behind verification. Depends on Tracks A/B/C/D.
- **Track F — Backfill script:** Django management command. Independent; runs before E ships.
- **Track G — Cleanup:** delete static-OSM URL builder, unwire `change_city` from primary nav, prune any now-unused imports.

**Hard ordering constraints:**
- B + F must complete and run on production before E can ship to users
- A unblocks C
- E is the last track

---

*End of design.*
