# Karrot-Style Location in Profile Edit — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the 3-level country→region→district dropdown cascade in `profile_edit.dart` with a Karrot-style map location card, fix category filtered pages to respect the active neighborhood, and unify all location-menu navigation through GoRouter.

**Architecture:** `ProfileEditScreen` is simplified to username + avatar + a tappable location card. Tapping the card pushes `/change-city` (existing `MapLocationFilterPage`), which handles the full map-pick → verify → persist flow. On return, the screen reads the updated `activeNeighborhoodProvider`. `FilteredProducts` and `FilteredServices` gain the same Karrot-priority guard already present in `ProductsList` / `ServiceMain`.

**Tech Stack:** Flutter, Riverpod, GoRouter, existing `MapLocationFilterPage` + `activeNeighborhoodProvider` + `radiusProvider`.

---

## File Map

| File | Change |
|---|---|
| `lib/providers/provider_root/profile_provider.dart` | `locationId` → `int?`; skip `district_id` in body when null |
| `lib/pages/shaxsiy/main_profile/profile_edit.dart` | Full rewrite — remove dropdown cascade, add `_LocationCard` |
| `lib/pages/shaxsiy/shaxsiy.dart` | 3-line fix — Location menu uses `context.push('/change-city')` |
| `lib/pages/products/filtered_products.dart` | Add `activeNeighborhoodProvider` priority to both load methods |
| `lib/pages/service/main/filtered_services.dart` | Same neighbourhood priority as FilteredProducts |

---

## Task 1: Make `locationId` optional in `ProfileService.updateUserInfo`

**Files:**
- Modify: `lib/providers/provider_root/profile_provider.dart:53-58` (signature + body)

- [ ] **Step 1.1 — Change the method signature**

Open `lib/providers/provider_root/profile_provider.dart`.

Replace lines 53–67 (signature + initial formDataMap build):

```dart
// BEFORE
Future<UserInfo> updateUserInfo({
  String? username,
  required int locationId,
  File? profileImage,
  String? countryCode,
}) async {
  print('[ProfileService] updateUserInfo called with district_id: $locationId, country_code: $countryCode');
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');
  print('[ProfileService] Token: ${token != null ? "present" : "missing"}');

  // Build form data conditionally - use district_id as per backend API
  final Map<String, dynamic> formDataMap = {
    'district_id': locationId,
  };

  // Add country_code if provided
  if (countryCode != null && countryCode.isNotEmpty) {
    formDataMap['country_code'] = countryCode;
  }
```

```dart
// AFTER
Future<UserInfo> updateUserInfo({
  String? username,
  int? locationId,
  File? profileImage,
  String? countryCode,
}) async {
  print('[ProfileService] updateUserInfo called with district_id: $locationId, country_code: $countryCode');
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');
  print('[ProfileService] Token: ${token != null ? "present" : "missing"}');

  final Map<String, dynamic> formDataMap = {};

  if (locationId != null) {
    formDataMap['district_id'] = locationId;
  }

  if (countryCode != null && countryCode.isNotEmpty) {
    formDataMap['country_code'] = countryCode;
  }
```

- [ ] **Step 1.2 — Guard the SharedPreferences side-effect**

Find the line inside the same method (around line 117):
```dart
await prefs.setString('userLocation', locationId.toString());
```

Replace with:
```dart
if (locationId != null) {
  await prefs.setString('userLocation', locationId.toString());
}
```

- [ ] **Step 1.3 — Verify compilation**

```bash
cd /Users/firdavsmutalipov/Desktop/Sabzi_Market/app
flutter analyze lib/providers/provider_root/profile_provider.dart
```

Expected: no errors. If the old caller in `profile_edit.dart` still passes `locationId:` as `required`, the analyzer will warn about a named arg mismatch — that's fine, Task 2 fixes the caller.

- [ ] **Step 1.4 — Commit**

```bash
git add lib/providers/provider_root/profile_provider.dart
git commit -m "refactor(profile): make locationId optional in updateUserInfo"
```

---

## Task 2: Rewrite `profile_edit.dart` with Karrot-style location card

**Files:**
- Modify: `lib/pages/shaxsiy/main_profile/profile_edit.dart` (full replacement)

- [ ] **Step 2.1 — Replace the entire file**

Replace the full contents of `lib/pages/shaxsiy/main_profile/profile_edit.dart` with:

```dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/pages/shaxsiy/main_profile/widgets/profile_edit_avatar.dart';
import 'package:app/providers/provider_models/user_model.dart';
import 'package:app/providers/provider_root/active_neighborhood_provider.dart';
import 'package:app/providers/provider_root/profile_provider.dart';
import 'package:app/providers/provider_root/product_provider.dart';
import 'package:app/providers/provider_root/service_provider.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _picker = ImagePicker();

  UserInfo? currentUser;
  File? selectedImage;
  String? _pickedNeighborhoodLabel;
  bool isLoading = false;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

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

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (image != null) setState(() => selectedImage = File(image.path));
    } catch (e) {
      _showError('Failed to pick image: $e');
    }
  }

  Future<void> _navigateToPickLocation() async {
    await context.push('/change-city');
    if (!mounted) return;
    final activeNbhd = ref.read(activeNeighborhoodProvider);
    if (activeNbhd != null) {
      final n = activeNbhd.neighborhood;
      final parts = [n.city, n.region].where((s) => s.isNotEmpty).toList();
      setState(() {
        _pickedNeighborhoodLabel = parts.isNotEmpty ? parts.join(', ') : n.name;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate() || currentUser == null) return;
    setState(() => isSaving = true);
    try {
      await ref.read(profileServiceProvider).updateUserInfo(
            username: _usernameController.text.trim(),
            locationId: null,
            profileImage: selectedImage,
          );
      ref.read(productsServiceProvider).clearCache();
      ref.invalidate(servicesProvider);
      ref.invalidate(myProfileProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Profile updated successfully!'),
            backgroundColor: Theme.of(context).colorScheme.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      _showError('Failed to update profile: $e');
    } finally {
      setState(() => isSaving = false);
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  String _resolveLocationLabel() {
    if (_pickedNeighborhoodLabel != null) return _pickedNeighborhoodLabel!;
    final activeNbhd = ref.read(activeNeighborhoodProvider);
    if (activeNbhd != null) {
      final n = activeNbhd.neighborhood;
      final parts = [n.city, n.region].where((s) => s.isNotEmpty).toList();
      return parts.isNotEmpty ? parts.join(', ') : n.name;
    }
    if (currentUser != null) {
      final parts = [currentUser!.location.district, currentUser!.location.region]
          .where((s) => s.isNotEmpty)
          .toList();
      if (parts.isNotEmpty) return parts.join(', ');
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(localizations?.editProfileModalTitle ?? 'Edit Profile'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(localizations?.editProfileModalTitle ?? 'Edit Profile'),
        ),
        body: Center(
          child: Text(localizations?.errorMessage ?? 'Failed to load profile data'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations?.editProfileModalTitle ?? 'Edit Profile'),
        actions: [
          TextButton(
            onPressed: isSaving ? null : _saveProfile,
            child: isSaving
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(colorScheme.onPrimary),
                    ),
                  )
                : Text(
                    localizations?.saveLabel ?? 'Save',
                    style: TextStyle(
                      color: colorScheme.secondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ProfileEditAvatar(
                user: currentUser,
                selectedImage: selectedImage,
                onTap: _pickImage,
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: localizations?.username ?? 'Username',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return localizations?.username_required ??
                        'Username is required';
                  }
                  if (value.trim().length < 2) {
                    return localizations?.username_min_length ??
                        'Username must be at least 2 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: currentUser!.phoneNumber,
                decoration: InputDecoration(
                  labelText: localizations?.phoneNumber,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.phone),
                  fillColor: colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.3),
                  filled: true,
                ),
                enabled: false,
              ),
              const SizedBox(height: 20),
              _LocationCard(
                locationLabel: _resolveLocationLabel(),
                onTap: _navigateToPickLocation,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  const _LocationCard({
    required this.locationLabel,
    required this.onTap,
  });

  final String locationLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localizations = AppLocalizations.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: localizations?.location_settings ?? 'My Neighborhood',
          border: const OutlineInputBorder(),
          prefixIcon: const Icon(Icons.location_on),
          suffixIcon: Icon(Icons.map_outlined, color: colorScheme.primary),
        ),
        child: Text(
          locationLabel.isNotEmpty
              ? locationLabel
              : (localizations?.selectRegion ?? 'Tap to set your area'),
          style: theme.textTheme.bodyLarge?.copyWith(
            color: locationLabel.isNotEmpty
                ? colorScheme.onSurface
                : colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 2.2 — Verify compilation**

```bash
flutter analyze lib/pages/shaxsiy/main_profile/profile_edit.dart
```

Expected: no errors or warnings. Common issues to check:
- `location_settings` key missing in `AppLocalizations` → falls back to `'My Neighborhood'`, fine
- `username_required` / `username_min_length` already exist from original — should resolve fine

- [ ] **Step 2.3 — Manual smoke test: open profile edit**

Run the app, navigate to the Profile tab → "Edit Profile".

Verify:
- ✅ No dropdown cascade visible (country / region / district gone)
- ✅ Location card shows the current district/region from the backend profile (e.g. "Andijon, Andijon viloyati")  
- ✅ If an active neighborhood was previously set, card shows the neighborhood city instead
- ✅ Tapping the location card opens the map picker (`/change-city`)
- ✅ After picking on the map and confirming, the card updates to show the new location
- ✅ Tapping Save completes without crash; profile refreshes on the shaxsiy page

- [ ] **Step 2.4 — Commit**

```bash
git add lib/pages/shaxsiy/main_profile/profile_edit.dart
git commit -m "feat(profile): replace location dropdowns with Karrot-style map card"
```

---

## Task 3: Fix Location menu nav in `shaxsiy.dart`

**Files:**
- Modify: `lib/pages/shaxsiy/shaxsiy.dart` (~line 279)

- [ ] **Step 3.1 — Replace Navigator.push with context.push**

Find this block in `shaxsiy.dart` (the Location `ProfileMenuCard` `onTap`):

```dart
                  ProfileMenuCard(
                    icon: Icons.my_location_rounded,
                    title: localizations?.location_settings ?? 'Location',
                    subtitle: 'Default area and location services',
                    iconColor: const Color(0xFF4CAF50),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MapLocationFilterPage()),
                    ),
                  ),
```

Replace `onTap` only:

```dart
                  ProfileMenuCard(
                    icon: Icons.my_location_rounded,
                    title: localizations?.location_settings ?? 'Location',
                    subtitle: 'Default area and location services',
                    iconColor: const Color(0xFF4CAF50),
                    onTap: () => context.push('/change-city'),
                  ),
```

- [ ] **Step 3.2 — Remove the now-unused MapLocationFilterPage import**

At the top of `shaxsiy.dart`, remove this line:

```dart
import 'package:app/pages/change_city/map_location_filter.dart';
```

Verify nothing else in the file references `MapLocationFilterPage` before deleting the import.

- [ ] **Step 3.3 — Verify compilation**

```bash
flutter analyze lib/pages/shaxsiy/shaxsiy.dart
```

Expected: no errors.

- [ ] **Step 3.4 — Commit**

```bash
git add lib/pages/shaxsiy/shaxsiy.dart
git commit -m "fix(profile): use GoRouter for Location menu navigation"
```

---

## Task 4: Neighbourhood priority in `FilteredProducts`

**Files:**
- Modify: `lib/pages/products/filtered_products.dart`

- [ ] **Step 4.1 — Add imports**

At the top of `lib/pages/products/filtered_products.dart`, add after the existing imports:

```dart
import 'package:app/providers/provider_root/active_neighborhood_provider.dart';
import 'package:app/providers/provider_root/radius_provider.dart';
```

- [ ] **Step 4.2 — Add neighborhood priority to `_loadInitialProducts`**

Find the current `_loadInitialProducts` call to `getFilteredProducts` (around line 72):

```dart
      final products =
          await ref.read(productsServiceProvider).getFilteredProducts(
                currentPage: 1,
                pageSize: 12,
                categoryName: widget.categoryName,
                regionName: widget.regionName,
                districtName: widget.districtName,
                districtId: widget.districtId,
              );
```

Replace with:

```dart
      final activeNbhd = ref.read(activeNeighborhoodProvider);
      final radius = ref.read(radiusProvider);
      final useNeighborhood = activeNbhd != null;
      final products =
          await ref.read(productsServiceProvider).getFilteredProducts(
                currentPage: 1,
                pageSize: 12,
                categoryName: widget.categoryName,
                regionName: useNeighborhood ? '' : widget.regionName,
                districtName: useNeighborhood ? '' : widget.districtName,
                districtId: useNeighborhood ? null : widget.districtId,
                neighborhoodId:
                    useNeighborhood ? activeNbhd.neighborhood.id : null,
                radiusKm: useNeighborhood ? radius : null,
                centerLat: useNeighborhood
                    ? activeNbhd.neighborhood.centroidLat
                    : null,
                centerLng: useNeighborhood
                    ? activeNbhd.neighborhood.centroidLng
                    : null,
              );
```

- [ ] **Step 4.3 — Add neighborhood priority to `_loadMoreProducts`**

Find the current `_loadMoreProducts` call to `getFilteredProducts` (around line 113):

```dart
      final newProducts =
          await ref.read(productsServiceProvider).getFilteredProducts(
                currentPage: nextPage,
                pageSize: 12,
                categoryName: widget.categoryName,
                regionName: widget.regionName,
                districtName: widget.districtName,
                districtId: widget.districtId,
              );
```

Replace with:

```dart
      final activeNbhd = ref.read(activeNeighborhoodProvider);
      final radius = ref.read(radiusProvider);
      final useNeighborhood = activeNbhd != null;
      final newProducts =
          await ref.read(productsServiceProvider).getFilteredProducts(
                currentPage: nextPage,
                pageSize: 12,
                categoryName: widget.categoryName,
                regionName: useNeighborhood ? '' : widget.regionName,
                districtName: useNeighborhood ? '' : widget.districtName,
                districtId: useNeighborhood ? null : widget.districtId,
                neighborhoodId:
                    useNeighborhood ? activeNbhd.neighborhood.id : null,
                radiusKm: useNeighborhood ? radius : null,
                centerLat: useNeighborhood
                    ? activeNbhd.neighborhood.centroidLat
                    : null,
                centerLng: useNeighborhood
                    ? activeNbhd.neighborhood.centroidLng
                    : null,
              );
```

- [ ] **Step 4.4 — Verify compilation**

```bash
flutter analyze lib/pages/products/filtered_products.dart
```

Expected: no errors.

- [ ] **Step 4.5 — Manual smoke test**

Run the app, verify your neighborhood, tap a category chip on the Products tab.

Verify:
- ✅ Filtered products page shows only products from your neighbourhood (same as the main list)
- ✅ Without an active neighbourhood, filtered products page shows the full city/district results as before

- [ ] **Step 4.6 — Commit**

```bash
git add lib/pages/products/filtered_products.dart
git commit -m "feat(products): apply active neighbourhood filter to category drill-down"
```

---

## Task 5: Neighbourhood priority in `FilteredServices`

**Files:**
- Modify: `lib/pages/service/main/filtered_services.dart`

- [ ] **Step 5.1 — Add imports**

At the top of `lib/pages/service/main/filtered_services.dart`, add after the existing imports:

```dart
import 'package:app/providers/provider_root/active_neighborhood_provider.dart';
import 'package:app/providers/provider_root/radius_provider.dart';
```

- [ ] **Step 5.2 — Add neighborhood priority to `_loadInitialServices`**

Find the current `_loadInitialServices` call to `getFilteredServices` (around line 70):

```dart
      final services = await ref.read(serviceMainProvider).getFilteredServices(
            currentPage: 1,
            pageSize: 12,
            categoryName: widget.categoryName,
            regionName: widget.regionName,
            districtName: widget.districtName,
            districtId: widget.districtId,
          );
```

Replace with:

```dart
      final activeNbhd = ref.read(activeNeighborhoodProvider);
      final radius = ref.read(radiusProvider);
      final useNeighborhood = activeNbhd != null;
      final services = await ref.read(serviceMainProvider).getFilteredServices(
            currentPage: 1,
            pageSize: 12,
            categoryName: widget.categoryName,
            regionName: useNeighborhood ? '' : widget.regionName,
            districtName: useNeighborhood ? '' : widget.districtName,
            districtId: useNeighborhood ? null : widget.districtId,
            neighborhoodId:
                useNeighborhood ? activeNbhd.neighborhood.id : null,
            radiusKm: useNeighborhood ? radius : null,
            centerLat: useNeighborhood
                ? activeNbhd.neighborhood.centroidLat
                : null,
            centerLng: useNeighborhood
                ? activeNbhd.neighborhood.centroidLng
                : null,
          );
```

- [ ] **Step 5.3 — Add neighborhood priority to `_loadMoreServices`**

Find the current `_loadMoreServices` call to `getFilteredServices` (around line 110):

```dart
      final newServices =
          await ref.read(serviceMainProvider).getFilteredServices(
                currentPage: nextPage,
                pageSize: 12,
                categoryName: widget.categoryName,
                regionName: widget.regionName,
                districtName: widget.districtName,
                districtId: widget.districtId,
              );
```

Replace with:

```dart
      final activeNbhd = ref.read(activeNeighborhoodProvider);
      final radius = ref.read(radiusProvider);
      final useNeighborhood = activeNbhd != null;
      final newServices =
          await ref.read(serviceMainProvider).getFilteredServices(
                currentPage: nextPage,
                pageSize: 12,
                categoryName: widget.categoryName,
                regionName: useNeighborhood ? '' : widget.regionName,
                districtName: useNeighborhood ? '' : widget.districtName,
                districtId: useNeighborhood ? null : widget.districtId,
                neighborhoodId:
                    useNeighborhood ? activeNbhd.neighborhood.id : null,
                radiusKm: useNeighborhood ? radius : null,
                centerLat: useNeighborhood
                    ? activeNbhd.neighborhood.centroidLat
                    : null,
                centerLng: useNeighborhood
                    ? activeNbhd.neighborhood.centroidLng
                    : null,
              );
```

- [ ] **Step 5.4 — Verify compilation**

```bash
flutter analyze lib/pages/service/main/filtered_services.dart
```

Expected: no errors.

- [ ] **Step 5.5 — Full project analysis**

```bash
flutter analyze lib/
```

Expected: zero new errors introduced by this work.

- [ ] **Step 5.6 — Manual smoke test**

Run the app, verify your neighbourhood, tap a category chip on the Services tab.

Verify:
- ✅ Filtered services page shows only services from your neighbourhood
- ✅ Without an active neighbourhood, shows full city/district results

- [ ] **Step 5.7 — Commit**

```bash
git add lib/pages/service/main/filtered_services.dart
git commit -m "feat(services): apply active neighbourhood filter to category drill-down"
```

---

## Self-Review

**Spec coverage:**
- ✅ `locationId` optional in `updateUserInfo` → Task 1
- ✅ 3 dropdowns replaced with map location card → Task 2
- ✅ Location card shows activeNbhd / user.location with correct priority → Task 2 (`_resolveLocationLabel`)
- ✅ Tapping card pushes `/change-city` → Task 2 (`_navigateToPickLocation`)
- ✅ After returning, card reflects new pick → Task 2 (reads `activeNeighborhoodProvider` on return)
- ✅ Save doesn't require district FK → Task 2 (`locationId: null`)
- ✅ `shaxsiy.dart` Location menu uses GoRouter → Task 3
- ✅ `FilteredProducts` respects `activeNeighborhoodProvider` → Task 4
- ✅ `FilteredServices` respects `activeNeighborhoodProvider` → Task 5

**Placeholder scan:** None found. All code blocks are complete and runnable.

**Type consistency:**
- `activeNeighborhoodProvider` returns `VerifiedNeighborhood?` → used as `activeNbhd` throughout all tasks consistently
- `radiusProvider` returns `double` → used as `radius` consistently
- `updateUserInfo(locationId: null)` — Task 1 makes it `int?`, Task 2 passes `null` ✅
- `_LocationCard` defined in Task 2, used in Task 2 ✅
- `_resolveLocationLabel()` defined and called in Task 2 ✅
