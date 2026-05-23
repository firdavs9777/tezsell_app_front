# Karrot-Style Location in Profile Edit — Design Spec
Date: 2026-05-23

## Problem

The app has two location systems that are partially in conflict:

| System | Files | Behaviour |
|---|---|---|
| **New (neighborhood)** | `MapLocationFilterPage`, `activeNeighborhoodProvider`, `verifiedNeighborhoodsProvider` | Map-picked lat/lng area; Karrot priority in `ProductsList` + `ServiceMain` |
| **Old (district)** | `ProfileEditScreen` dropdowns, `updateUserInfo(locationId:)` | Country→Region→District cascade; sends `district_id` FK to backend |

`/profile/edit` still renders the old 3-level dropdown cascade. Category drill-down pages (`FilteredProducts`, `FilteredServices`) ignore `activeNeighborhoodProvider`. The "Location" menu in `shaxsiy.dart` uses `Navigator.push` instead of GoRouter.

## Goals

1. Replace the 3 dropdowns in `profile_edit.dart` with a Karrot-style map location card.
2. Fix `FilteredProducts` and `FilteredServices` to respect `activeNeighborhoodProvider` (same Karrot priority already in `ProductsList`/`ServiceMain`).
3. Fix `shaxsiy.dart` Location menu to use `context.push('/change-city')`.
4. Make `locationId` optional in `updateUserInfo` so map-only picks (which have no district FK) can save.

## Out of Scope

- `ProductSearch` / `ServiceSearch` — lower impact, separate task
- Backend changes — `district_id` stays optional; backend already handles null gracefully

---

## Architecture

### Two-layer location model (preserved)

```
activeNeighborhoodProvider  ←  map pick  (browse filter, ephemeral-ish)
user.location (backend)     ←  district FK (profile home base, persistent)
```

These remain loosely coupled. Profile edit updates the backend home base. The map filter (`/change-city`) updates the browse neighborhood. They can be the same place or different.

---

## Changes

### 1. `lib/providers/provider_root/profile_provider.dart`

**`ProfileService.updateUserInfo` signature:**
```dart
// Before
Future<UserInfo> updateUserInfo({
  String? username,
  required int locationId,
  File? profileImage,
  String? countryCode,
})

// After
Future<UserInfo> updateUserInfo({
  String? username,
  int? locationId,       // nullable — map-only picks omit district_id
  File? profileImage,
  String? countryCode,
})
```

In the body, only add `district_id` to `formDataMap` when `locationId != null`.

Also remove the `SharedPreferences.setString('userLocation', locationId.toString())` side-effect when `locationId` is null — don't overwrite a valid stored value with null.

### 2. `lib/pages/shaxsiy/main_profile/profile_edit.dart`

**Remove entirely:**
- State fields: `countriesList`, `selectedCountry`, `regionsList`, `districtsList`, `selectedRegion`, `selectedRegionId`, `selectedDistrict`, `isLoadingCountries`, `isLoadingRegions`, `isLoadingDistricts`
- Methods: `_fetchCountries`, `_fetchRegions`, `_fetchDistricts`, `_onCountryChanged`, `_onRegionChanged`
- Widget imports: nothing extra needed beyond what's already there
- The `Future.wait([..., _fetchCountries()])` call in `_initializeData`

**Add:**
- State field: `_pickedNeighborhoodLabel` (`String?`) — display label for a freshly picked location; starts null
- Method: `_navigateToPickLocation()` — pushes `/change-city`, on return reads `activeNeighborhoodProvider` for the new label
- Widget: `_LocationCard` — tappable card showing current location + map arrow icon

**`_initializeData` simplified:**
```dart
Future<void> _initializeData() async {
  setState(() => isLoading = true);
  try {
    currentUser = await ref.read(profileServiceProvider).getUserInfo();
    _usernameController.text = currentUser!.username;
  } catch (e) {
    _showError('Failed to load profile data: $e');
  } finally {
    setState(() => isLoading = false);
  }
}
```

**`_saveProfile` simplified:**
```dart
await ref.read(profileServiceProvider).updateUserInfo(
  username: _usernameController.text.trim(),
  locationId: null,   // neighborhood picks don't resolve to district FK
  profileImage: selectedImage,
);
```

**Location card display logic:**
Priority: `_pickedNeighborhoodLabel` (just picked this session) → `activeNeighborhoodProvider` city/name → `user.location.district + region`.

```
╔═══════════════════════════════════════╗
║  My Neighborhood                      ║
║  ─────────────────────────────────    ║
║  📍  Chilonzor, Tashkent          →  ║
║      Tap to change on map             ║
╚═══════════════════════════════════════╝
```

Full-width tappable card with `OutlineInputBorder` style to match the other form fields. Arrow icon on the right. Tapping calls `_navigateToPickLocation`.

### 3. `lib/pages/shaxsiy/shaxsiy.dart`

**Location menu card** (line ~279):
```dart
// Before
onTap: () => Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const MapLocationFilterPage()),
),

// After
onTap: () => context.push('/change-city'),
```

### 4. `lib/pages/products/filtered_products.dart`

In `_loadInitialProducts` and `_loadMoreProducts`, add Karrot priority:

```dart
final activeNbhd = ref.read(activeNeighborhoodProvider);
final radius = ref.read(radiusProvider);
final useNeighborhood = activeNbhd != null;

await ref.read(productsServiceProvider).getFilteredProducts(
  currentPage: ...,
  pageSize: 12,
  categoryName: widget.categoryName,
  regionName: useNeighborhood ? '' : widget.regionName,
  districtName: useNeighborhood ? '' : widget.districtName,
  districtId: useNeighborhood ? null : widget.districtId,
  neighborhoodId: useNeighborhood ? activeNbhd.neighborhood.id : null,
  radiusKm: useNeighborhood ? radius : null,
  centerLat: useNeighborhood ? activeNbhd.neighborhood.centroidLat : null,
  centerLng: useNeighborhood ? activeNbhd.neighborhood.centroidLng : null,
);
```

Add required imports: `active_neighborhood_provider.dart`, `radius_provider.dart`.

### 5. `lib/pages/service/main/filtered_services.dart`

Identical Karrot priority change as FilteredProducts but using `serviceMainProvider.getFilteredServices(...)`.

---

## Data Flow (profile edit, new)

```
Open /profile/edit
  └─ _initializeData() → getUserInfo()
       └─ show username, phone, avatar
       └─ show location label (activeNbhd ?? user.location)

Tap location card
  └─ context.push('/change-city')
       └─ MapLocationFilterPage runs its own flow
       └─ On confirm: verifiedNeighborhoodsProvider updated, activeNeighborhoodProvider updated
  └─ On return: read activeNeighborhoodProvider for new label
       └─ setState → _pickedNeighborhoodLabel = city or name

Tap Save
  └─ updateUserInfo(username, locationId: null, profileImage)
  └─ invalidate caches
  └─ pop(true)
```

---

## Error Handling

- If `getUserInfo()` fails → show error snackbar, keep current state
- If `/change-city` picker is dismissed without picking → no state change, location card unchanged
- If `updateUserInfo` fails with null locationId → backend returns 200 updating only username/avatar (acceptable)

---

## Testing Checklist

- [ ] Profile edit opens with correct current location shown (backend district OR active neighborhood)
- [ ] Tapping location card opens map picker
- [ ] After picking, location card shows new neighborhood name
- [ ] Save updates username and avatar; succeeds without district_id
- [ ] Profile header on shaxsiy.dart reflects change after save + refresh
- [ ] Category drill-down in products tab respects active neighborhood (FilteredProducts)
- [ ] Category drill-down in services tab respects active neighborhood (FilteredServices)
- [ ] Location menu in shaxsiy.dart navigates correctly via GoRouter
