# Neighborhood Management — Karrot-Style Location Screen

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the current map-pick location flow with a Karrot-faithful neighborhood management system: a tappable AppBar chip that shows a quick-switch sheet, and a full-screen map page where users can see their GPS position alongside verified neighborhood pins, switch instantly, and verify a new location only when physically present.

**Architecture:** Two new widgets (`NeighborhoodSwitcherSheet`, `NeighborhoodManagementPage`) replace `MapLocationFilterPage`. The AppBar chip gains a bottom-sheet switcher; the full map page is routed at `/location/manage`. All existing provider/verification infrastructure is reused.

**Tech Stack:** Flutter, Riverpod 2.x, flutter_map + OpenStreetMap tiles (already in project), geolocator (already in project), existing `NeighborhoodVerifier` widget, `go_router`.

---

## International Considerations

This is a global app. All design decisions account for international use:

- **Map tiles:** OpenStreetMap covers every country. No tile configuration changes needed.
- **Neighborhood names:** The backend reverse-geocodes names in the local script/language. `Neighborhood.displayName` / `.name` / `.city` are already locale-aware. Never hardcode name formatting.
- **Text overflow:** Neighborhood names in Arabic, Korean, Japanese, Chinese, or Uzbek Cyrillic can be long. All chips, pins, and list tiles must use `maxLines: 1, overflow: TextOverflow.ellipsis`.
- **RTL support:** Use `start`/`end` semantics in padding (e.g., `EdgeInsetsDirectional`), not `left`/`right`. Flutter's `Directionality` widget handles layout flipping automatically.
- **Localization:** Every user-facing string goes through `AppLocalizations`. Add keys to `app_en.arb` (and the 13 other `.arb` files) — no hardcoded English strings.
- **GPS:** Works identically worldwide. The `NeighborhoodVerifier` backend endpoint handles reverse geocoding for any coordinate.

---

## Screen 1 — AppBar Quick-Switcher Sheet

**Trigger:** User taps the location chip in `TabsScreen`'s AppBar (the existing `_buildLocationChip` widget).

**Current behaviour:** Navigates to `/change-city` → `MapLocationFilterPage`.  
**New behaviour:** Shows a `NeighborhoodSwitcherSheet` bottom sheet.

### NeighborhoodSwitcherSheet widget

File: `lib/widgets/maps/neighborhood_switcher_sheet.dart`

- `showModalBottomSheet` with `shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20)))` and `isScrollControlled: false`.
- **Drag handle** at top centre (32×4 px, `colorScheme.onSurfaceVariant.withValues(alpha: 0.3)`).
- **Title row:** "My Neighborhoods" (`titleMedium`, bold). A `TextButton` "Manage on map →" at right that pushes `/location/manage` and closes the sheet.
- **Neighborhood list:** one `ListTile` per `VerifiedNeighborhood` in `verifiedNeighborhoodsProvider` (0–2 items):
  - Leading: `CircleAvatar` with neighborhood initial letter, `colorScheme.primaryContainer` background when active, `colorScheme.surfaceContainerHighest` when inactive.
  - Title: `neighborhood.displayName` (or `.city` if non-empty, else `.name`). Bold when active.
  - Subtitle: verified date — `"Verified [relative time]"` (e.g., "Verified 3 days ago"). Use `timeago` package (already in project).
  - Trailing: `Icon(Icons.check_circle_rounded, color: colorScheme.primary)` when active, nothing when inactive.
  - `tileColor`: `colorScheme.primaryContainer.withValues(alpha: 0.15)` when active.
  - `onTap`: set `activeNeighborhoodIndexProvider` to this item's index → close sheet → invalidate `productsProvider` + `servicesProvider` so the feed refreshes.
- **Empty state** (0 verified neighborhoods): an illustration-free message — "No verified neighborhoods yet. Open the map to verify where you are." with an "Open map" button.
- **Bottom button** (always shown if ≥ 1 neighborhood): outlined button "📍 Open map to verify new location" → pushes `/location/manage` and closes sheet.
- **No confirmation on switch.** Instant, like Karrot.

### TabBar change

`_buildLocationChip` in `tab_bar.dart`: remove the `_navigateToLocationChange` call; replace `onTap` with:
```dart
onTap: () => showModalBottomSheet(
  context: context,
  builder: (_) => ProviderScope.overrides([], child: NeighborhoodSwitcherSheet()),
),
```
(Use `ConsumerWidget` inside the sheet — it shares the same `ProviderScope`.)

---

## Screen 2 — NeighborhoodManagementPage

File: `lib/pages/location/neighborhood_management_page.dart`

Route: `/location/manage` (add to `app_router.dart`).  
Entry points: "Open map" from switcher sheet; Profile → Location settings menu item.

### AppBar
- `← My Neighborhoods` title.
- No actions.

### Map layer stack (bottom → top)

1. **`TileLayer`** — OpenStreetMap tiles (`https://tile.openstreetmap.org/{z}/{x}/{y}.png`). Attribution text `"© OpenStreetMap contributors"` in a `RichAttributionWidget`.
2. **`CircleLayer`** — GPS accuracy ring. One `CircleMarker` at current GPS position; radius = `position.accuracy` metres; `color: Colors.blue.withValues(alpha: 0.12)`, `borderColor: Colors.blue.withValues(alpha: 0.4)`, `borderStrokeWidth: 1`.
3. **`MarkerLayer` — GPS blue dot.** `LatLng(position.latitude, position.longitude)`. Widget: 14×14 px `Container` — filled `Colors.blue`, `border: Border.all(color: Colors.white, width: 2)`, circular, `boxShadow`.
4. **`MarkerLayer` — Neighborhood pins.** One marker per `VerifiedNeighborhood`:
   - Widget: a `Column` with a label bubble above a pin icon.
   - Label bubble: `colorScheme.primary` background (active) or `colorScheme.surfaceContainerHighest` (inactive). Text: `neighborhood.displayName` truncated to 18 chars max, white (active) or `onSurface` (inactive). `maxLines: 1, overflow: TextOverflow.ellipsis`.
   - Pin icon: `Icons.location_on_rounded`, size 28, `colorScheme.primary` (active) or `colorScheme.outline` (inactive).
   - Tapping a pin: same as tapping its chip — instant switch.

### Top overlay — floating chips bar

`Positioned(top: 12, left: 12, right: 12)` — a `Wrap` (handles long names, RTL):
- One chip per verified neighborhood. `FilterChip` or a custom `Container`:
  - Selected (active): filled `colorScheme.primary`, white label.
  - Unselected: white fill, `colorScheme.outline` border, `onSurface` label.
  - Label: `neighborhood.displayName` (or `.city` / `.name`), `maxLines: 1, overflow: TextOverflow.ellipsis`, max width ~140 px.
  - `onSelected` / `onTap`: set `activeNeighborhoodIndexProvider` → invalidate feeds.
- Chips have `elevation: 2` and a subtle shadow.

### FAB — "Verify here"

`FloatingActionButton.extended`:
- Label: `l.verify_here` (new l10n key).
- Icon: `Icons.my_location_rounded`.
- Always visible.
- `onPressed`: calls `_onVerifyHere()` (see Verification Flow below).

### GPS stream

On page open:
1. Request location permission (already handled by `NeighborhoodVerifier`; here just check `Geolocator.checkPermission()`).
2. Subscribe to `Geolocator.getPositionStream(locationSettings: LocationSettings(accuracy: LocationAccuracy.high))`.
3. Update `_currentPosition` state on each event → re-render blue dot and accuracy ring.
4. On first position fix: animate map camera to include current position AND all verified neighborhood centroids in bounds (`MapController.fitCamera(CameraFit.bounds(...))`).
5. Cancel stream in `dispose()`.

### Camera initial state

If no GPS yet: centre on the active neighborhood's `centroidLat`/`centroidLng`, zoom 13.  
If GPS available: `CameraFit.bounds` to include GPS + all neighborhood centroids, padding 60 px.

---

## Screen 3 — Verification Flow

Triggered by FAB tap → `_onVerifyHere()`:

### Step A — Check capacity

```
verified = ref.read(verifiedNeighborhoodsProvider)
if (verified.length < 2):
    _startVerification()   // skip to Step B
else:
    _showEvictionWarning(oldest: verified.reduce((a,b) => a.verifiedAt.isBefore(b.verifiedAt) ? a : b))
```

### Step B — Eviction warning (only when at max 2)

`showModalBottomSheet` — not dismissible by dragging (`isDismissible: false, enableDrag: false`):
- **Title:** `l.verify_new_location` (new key).
- **Warning box** (`colorScheme.errorContainer`): `l.eviction_warning(oldestName)` — e.g., "Adding this location will remove **Gangnam-gu** (your oldest). This cannot be undone."
- **Buttons:** `Cancel` (outlined) and `Verify` (filled primary).
- Cancel → close sheet, do nothing.
- Verify → close sheet → `_startVerification()`.

### Step C — NeighborhoodVerifier

Show `NeighborhoodVerifier` widget in a `showModalBottomSheet` (existing widget handles all GPS stages: `idle → requesting → confirming → submitting → done/error`). The verifier internally calls `addEvictingOldest()` which performs FIFO eviction on the provider.

On `done`: close the sheet. The map reacts automatically because it watches `verifiedNeighborhoodsProvider` — the new pin appears and camera adjusts. Set the new neighborhood as active (index of the newly added item).

---

## Files

### Create

| File | Purpose |
|------|---------|
| `lib/pages/location/neighborhood_management_page.dart` | Full map screen (Screen 2 + 3) |
| `lib/widgets/maps/neighborhood_switcher_sheet.dart` | Bottom sheet (Screen 1) |

### Modify

| File | Change |
|------|--------|
| `lib/pages/tab_bar/tab_bar.dart` | `_buildLocationChip` tap → show `NeighborhoodSwitcherSheet` |
| `lib/pages/shaxsiy/shaxsiy.dart` | Location menu item → `context.push('/location/manage')` |
| `lib/config/app_router.dart` | Add `/location/manage` route; redirect `/change-city` → `/location/manage` |
| `lib/l10n/app_en.arb` (+ 13 other `.arb` files) | Add new l10n keys (see below) |

### Delete

| File | Reason |
|------|--------|
| `lib/pages/change_city/map_location_filter.dart` | Fully replaced by `NeighborhoodManagementPage` |

---

## New l10n Keys

Add to `app_en.arb` and all other `.arb` files:

```json
"my_neighborhoods": "My Neighborhoods",
"manage_on_map": "Manage on map",
"no_neighborhoods_yet": "No verified neighborhoods yet. Open the map to verify where you are.",
"open_map_to_verify": "Open map to verify new location",
"verify_here": "Verify here",
"verify_new_location": "Verify new location",
"eviction_warning": "Adding this location will remove {name} (your oldest). This cannot be undone.",
"@eviction_warning": { "placeholders": { "name": { "type": "String" } } },
"verified_n_days_ago": "Verified {days} days ago",
"@verified_n_days_ago": { "placeholders": { "days": { "type": "int" } } },
"active_neighborhood": "Active",
"switch_neighborhood_success": "Switched to {name}",
"@switch_neighborhood_success": { "placeholders": { "name": { "type": "String" } } }
```

---

## Data Flow Summary

```
AppBar chip tap
  └─► NeighborhoodSwitcherSheet
        reads: verifiedNeighborhoodsProvider, activeNeighborhoodIndexProvider
        writes: activeNeighborhoodIndexProvider (on tap)
        navigate: push /location/manage

/location/manage → NeighborhoodManagementPage
  reads: verifiedNeighborhoodsProvider, activeNeighborhoodIndexProvider
  writes: activeNeighborhoodIndexProvider (chip/pin tap)
  GPS: Geolocator.getPositionStream()
  FAB tap:
    if full → EvictionWarningSheet
    NeighborhoodVerifier (existing widget)
      writes: verifiedNeighborhoodsProvider.addEvictingOldest()
              activeNeighborhoodIndexProvider (set to new item's index)
    both → invalidate productsProvider + servicesProvider
```

---

## Error Handling

- **GPS permission denied:** FAB tap shows a `SnackBar` with `l.location_permission_denied_settings` and a "Settings" action (`Geolocator.openAppSettings()`). Map still shows neighborhood pins; blue dot is hidden.
- **GPS timeout (>15 s):** Show snackbar "Couldn't get GPS fix. Move to an open area and try again." Blue dot shows last known position if available.
- **Verification server error:** `NeighborhoodVerifier` already handles `MapsException`, `MapsRateLimitException`, `MapsServerException` with retry options.
- **No verified neighborhoods:** Quick-switch sheet shows empty state. Management page shows only the blue dot and the "Verify here" FAB.

---

## Spec Self-Review

- No TBD or placeholder sections.
- All strings use l10n keys; no hardcoded English.
- `_buildLocationChip` tap path is explicit (showModalBottomSheet, not navigation).
- Route `/change-city` redirected (not deleted from router) to avoid crashes from any deep-links.
- `NeighborhoodVerifier` reused as-is — no changes to its internal GPS logic.
- RTL and long-name overflow addressed explicitly.
- `timeago` package already in `pubspec.yaml` (used elsewhere in the project).
- Camera fit logic handles the edge case of 0 verified neighborhoods (centre on GPS only).
- Eviction warning is non-dismissible to prevent accidental swipe-away.
