# Frontend Location Implementation Guide

This document describes how location selection is implemented in the frontend, including API endpoints, data models, and expected behavior. Backend developers should use this as a reference for implementing or updating location-related APIs.

---

## Table of Contents

1. [Overview](#overview)
2. [Location Hierarchy](#location-hierarchy)
3. [API Endpoints](#api-endpoints)
4. [Data Models](#data-models)
5. [Location Selection Flows](#location-selection-flows)
6. [Saving Location](#saving-location)
7. [Currency Support](#currency-support)
8. [Expected API Responses](#expected-api-responses)

---

## Overview

The app supports **15 ex-Soviet countries** with a hierarchical location system:
- **Country** → **Region** → **District**

Users select their location during:
1. **Registration** - Initial location setup
2. **Profile Edit** - Changing saved location
3. **Change City** - Quick location change from settings
4. **Item Creation** - Products, Services, Real Estate use user's location

---

## Location Hierarchy

```
Country (e.g., Uzbekistan, Kazakhstan, Kyrgyzstan)
  └── Region (e.g., Tashkent, Samarkand, Almaty)
       └── District (e.g., Chilanzar, Sergeli, Medeu)
```

### Supported Countries

| Code | Country | Currency |
|------|---------|----------|
| UZ | Uzbekistan | UZS |
| KZ | Kazakhstan | KZT |
| KG | Kyrgyzstan | KGS |
| TJ | Tajikistan | TJS |
| TM | Turkmenistan | TMT |
| RU | Russia | RUB |
| UA | Ukraine | UAH |
| BY | Belarus | BYN |
| MD | Moldova | MDL |
| GE | Georgia | GEL |
| AM | Armenia | AMD |
| AZ | Azerbaijan | AZN |
| EE | Estonia | EUR |
| LV | Latvia | EUR |
| LT | Lithuania | EUR |

---

## API Endpoints

### 1. Get Countries List

```
GET /accounts/countries/
```

**Expected Response:**
```json
{
  "countries": [
    {
      "id": 1,
      "code": "UZ",
      "name": "O'zbekiston",
      "name_en": "Uzbekistan",
      "name_ru": "Узбекистан",
      "phone_code": "+998",
      "flag_emoji": "🇺🇿",
      "currency": {
        "code": "UZS",
        "symbol": "so'm",
        "name": "So'm"
      }
    },
    {
      "id": 2,
      "code": "KZ",
      "name": "Qozog'iston",
      "name_en": "Kazakhstan",
      "name_ru": "Казахстан",
      "phone_code": "+7",
      "flag_emoji": "🇰🇿",
      "currency": {
        "code": "KZT",
        "symbol": "₸",
        "name": "Tenge"
      }
    }
    // ... more countries
  ]
}
```

---

### 2. Get Regions by Country

```
GET /accounts/regions/?country={country_code}
```

**Parameters:**
- `country` (required): ISO country code (e.g., `UZ`, `KZ`, `KG`)

**Example:**
```
GET /accounts/regions/?country=KZ
```

**Expected Response:**
```json
{
  "regions": [
    {
      "id": 1,
      "region": "Almaty",
      "country_code": "KZ"
    },
    {
      "id": 2,
      "region": "Nur-Sultan",
      "country_code": "KZ"
    }
    // ... more regions
  ]
}
```

**IMPORTANT:**
- The `id` field is **required** for each region
- The frontend uses `id` to fetch districts
- Without `id`, the district dropdown won't work

---

### 3. Get Districts by Region ID

```
GET /accounts/districts/{region_id}/
```

**Parameters:**
- `region_id` (required): The numeric ID of the region (not region name)

**Example:**
```
GET /accounts/districts/5/
```

**Expected Response:**
```json
{
  "districts": [
    {
      "id": 101,
      "district": "Medeu",
      "region_id": 5
    },
    {
      "id": 102,
      "district": "Bostandyk",
      "region_id": 5
    }
    // ... more districts
  ]
}
```

**IMPORTANT:**
- The `id` field is **required** for each district
- This `id` is what gets saved as the user's location (`district_id`)
- District IDs should be **globally unique** across all countries to avoid conflicts

---

### 4. Update User Location (Profile Update)

```
PUT /accounts/user-info/
```

**Request Headers:**
```
Authorization: Token {user_token}
Content-Type: multipart/form-data
```

**Request Body:**
```
district_id: 101
country_code: "KZ" (required for disambiguation)
username: "john_doe" (optional)
profile_image: <file> (optional)
```

**Expected Response:**
```json
{
  "data": {
    "id": 1,
    "username": "john_doe",
    "phone_number": "+998901234567",
    "location": {
      "id": 101,
      "country": "Kazakhstan",
      "country_code": "KZ",
      "region": "Almaty",
      "district": "Medeu"
    },
    "profile_image": {
      "image": "/media/profiles/user_1.jpg"
    }
  }
}
```

**CRITICAL:**
- The backend must accept `district_id` field
- **The backend must accept `country_code` field** to disambiguate districts with overlapping IDs across countries
- When updating user location, use BOTH `district_id` AND `country_code` to find the correct district
- If district IDs are not globally unique, filter by country first, then by district_id
- The response should include the updated location with all fields

**BUG FIX REQUIRED:**
Currently, district IDs overlap across countries (e.g., ID 62 exists in both Uzbekistan and Kyrgyzstan).
The backend should:
1. **Option A (Preferred):** Make district IDs globally unique across all countries
2. **Option B:** Use `country_code` to filter districts before looking up by `district_id`:
   ```python
   # Example fix in Django view
   def update_user_location(request):
       district_id = request.data.get('district_id')
       country_code = request.data.get('country_code')

       # Filter by country first to avoid ID collisions
       district = District.objects.filter(
           id=district_id,
           region__country__code=country_code
       ).first()
   ```

---

### 5. Registration with Location

```
POST /accounts/register/
```

**Request Body:**
```json
{
  "phone_number": "+998901234567",
  "password": "securepassword",
  "username": "john_doe",
  "district_id": 101
}
```

**Alternative (if district_id not available):**
```json
{
  "phone_number": "+998901234567",
  "password": "securepassword",
  "username": "john_doe",
  "region_id": 5
}
```

---

## Data Models

### Frontend Models

#### Location Model
```dart
class Location {
  final int id;
  final String? countryCode;
  final String country;
  final String region;
  final String district;
  final String? fullAddress;
}
```

#### Regions Model
```dart
class Regions {
  final int id;        // Required - used to fetch districts
  final String region;
  final String? countryCode;
}
```

#### Districts Model
```dart
class Districts {
  final int id;        // Required - saved as user's location
  final String district;
  final int? regionId;
}
```

---

## Location Selection Flows

### Flow 1: Registration

```
1. User opens app → Welcome Screen
2. User chooses sign-in method → Login/Register
3. After authentication → Location Setup Screen
4. User selects: Country → Region → District
5. District ID is saved to backend
6. User proceeds to main app
```

### Flow 2: Profile Edit

```
1. User goes to Profile → Edit Profile
2. Current location is pre-selected
3. User can change: Country → Region → District
4. On Save: district_id is sent to backend
5. Backend updates user's location
```

### Flow 3: Change City (Settings)

```
1. User goes to Settings → Change City
2. User selects: Country → Region → District
3. Confirmation dialog appears
4. On confirm: district_id is saved to backend
5. App refreshes with new location
```

---

## Saving Location

### What Frontend Sends

When saving location, the frontend sends the **district_id** (integer):

```dart
// Profile Update
await ref.read(profileServiceProvider).updateUserInfo(
  username: _usernameController.text.trim(),
  locationId: selectedDistrict!.id,  // This is district_id
  profileImage: selectedImage,
);
```

### Backend Should Accept

```python
# Django Serializer Example
class UserUpdateSerializer(serializers.ModelSerializer):
    district_id = serializers.IntegerField(write_only=True, required=False)

    def update(self, instance, validated_data):
        district_id = validated_data.pop('district_id', None)
        if district_id:
            district = District.objects.get(id=district_id)
            instance.location = district  # or however location is stored
        return super().update(instance, validated_data)
```

---

## Currency Support

### All Supported Currencies (Frontend)

| Code | Symbol | Name | Countries |
|------|--------|------|-----------|
| UZS | so'm | Uzbek Som | Uzbekistan |
| USD | $ | US Dollar | All (secondary) |
| EUR | € | Euro | Estonia, Latvia, Lithuania |
| RUB | ₽ | Russian Ruble | Russia |
| UAH | ₴ | Ukrainian Hryvnia | Ukraine |
| BYN | Br | Belarusian Ruble | Belarus |
| MDL | L | Moldovan Leu | Moldova |
| GEL | ₾ | Georgian Lari | Georgia |
| AMD | ֏ | Armenian Dram | Armenia |
| AZN | ₼ | Azerbaijani Manat | Azerbaijan |
| KZT | ₸ | Kazakhstani Tenge | Kazakhstan |
| TMT | m | Turkmen Manat | Turkmenistan |
| KGS | с | Kyrgyzstani Som | Kyrgyzstan |
| TJS | SM | Tajikistani Somoni | Tajikistan |

### Currency in Product/Service/Real Estate

Currently, the frontend shows **3 currencies per user**:
1. User's country default currency (e.g., KZT for Kazakhstan)
2. USD
3. EUR

The selected currency code (e.g., "UZS", "KZT") is sent to the backend.

### Backend Currency Configuration

**IMPORTANT:** The backend must support all currencies that the frontend can send.

To enable all 14 currencies, update the Django model's currency field choices:

```python
CURRENCY_CHOICES = [
    ('UZS', "So'm"),
    ('USD', 'US Dollar'),
    ('EUR', 'Euro'),
    ('RUB', 'Ruble'),
    ('UAH', 'Hryvnia'),
    ('BYN', 'Belarusian Ruble'),
    ('MDL', 'Leu'),
    ('GEL', 'Lari'),
    ('AMD', 'Dram'),
    ('AZN', 'Manat'),
    ('KZT', 'Tenge'),
    ('TMT', 'Manat'),
    ('KGS', 'Som'),
    ('TJS', 'Somoni'),
]

currency = models.CharField(max_length=3, choices=CURRENCY_CHOICES, default='UZS')
```

After updating the backend to support all currencies, the frontend can be updated to show all currencies by changing `CurrencyUtils.getCurrenciesForCountry()` to `CurrencyUtils.currencies.keys.toList()`.

---

## Expected API Responses

### Error Responses

All endpoints should return consistent error format:

```json
{
  "error": "Description of the error",
  "code": "ERROR_CODE"
}
```

Or with field-specific errors:

```json
{
  "errors": {
    "district_id": ["Invalid district ID"],
    "username": ["Username already exists"]
  }
}
```

### Status Codes

| Code | Meaning |
|------|---------|
| 200 | Success |
| 201 | Created |
| 400 | Bad Request (validation error) |
| 401 | Unauthorized |
| 404 | Not Found |
| 500 | Server Error |

---

## Known Issues & Requirements

### 1. Region IDs Required
- The frontend **requires** region IDs to fetch districts
- Some older API implementations only return region names
- **Fix:** Ensure all regions have unique IDs

### 2. District ID Uniqueness (CRITICAL BUG)
- District IDs are **NOT globally unique** across countries
- Example: ID 62 exists in both Uzbekistan (To'raqo'rg'on tumani) and Kyrgyzstan (Өзгөн)
- When user selects Uzbekistan district ID 62, backend returns Kyrgyzstan location
- **Current Workaround:** Frontend now sends `country_code` with `district_id`
- **Fix Required:** Backend must use `country_code` to filter districts OR make IDs globally unique

### 3. Country Filter for Regions
- The `/accounts/regions/` endpoint must accept `?country=XX` parameter
- Without this, regions from all countries are returned
- **Fix:** Implement country filtering

### 4. Location Update
- The `district_id` field must be processed in user update
- Currently some backends ignore this field
- **Fix:** Add `district_id` to serializer's writable fields

---

## Testing Checklist

- [ ] GET /accounts/countries/ returns all 15 countries
- [ ] GET /accounts/regions/?country=KZ returns only Kazakhstan regions
- [ ] Each region has a unique `id` field
- [ ] GET /accounts/districts/{id}/ returns districts for that region
- [ ] Each district has a unique `id` field
- [ ] PUT /accounts/user-info/ accepts `district_id` field
- [ ] PUT /accounts/user-info/ accepts `country_code` field
- [ ] User's location is updated correctly when `district_id` + `country_code` is sent
- [ ] Uzbekistan district ID 62 returns Uzbekistan location (not Kyrgyzstan)
- [ ] Location response includes country_code, region, and district

---

## Contact

For questions about the frontend implementation, refer to:
- `lib/pages/shaxsiy/main_profile/profile_edit.dart` - Profile editing
- `lib/pages/change_city/change_city.dart` - Change city flow
- `lib/pages/authentication/register.dart` - Registration flow
- `lib/providers/provider_root/profile_provider.dart` - API calls

---

*Last updated: February 2026*
