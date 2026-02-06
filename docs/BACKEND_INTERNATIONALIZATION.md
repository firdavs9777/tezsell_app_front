# Backend Internationalization Guide

## Target Markets: 15 Former Soviet Union Countries

| # | Country | Code | Currency | Currency Code | Population |
|---|---------|------|----------|---------------|------------|
| 1 | Russia | RU | Russian Ruble | RUB | 144M |
| 2 | Ukraine | UA | Ukrainian Hryvnia | UAH | 41M |
| 3 | Belarus | BY | Belarusian Ruble | BYN | 9M |
| 4 | Moldova | MD | Moldovan Leu | MDL | 3M |
| 5 | Estonia | EE | Euro | EUR | 1.3M |
| 6 | Latvia | LV | Euro | EUR | 1.9M |
| 7 | Lithuania | LT | Euro | EUR | 2.8M |
| 8 | Georgia | GE | Georgian Lari | GEL | 4M |
| 9 | Armenia | AM | Armenian Dram | AMD | 3M |
| 10 | Azerbaijan | AZ | Azerbaijani Manat | AZN | 10M |
| 11 | Kazakhstan | KZ | Kazakhstani Tenge | KZT | 20M |
| 12 | Uzbekistan | UZ | Uzbek Som | UZS | 35M |
| 13 | Turkmenistan | TM | Turkmen Manat | TMT | 6M |
| 14 | Kyrgyzstan | KG | Kyrgyzstani Som | KGS | 7M |
| 15 | Tajikistan | TJ | Tajikistani Somoni | TJS | 10M |

**Total Addressable Market: ~298M people**

---

## 1. Database Schema Changes

### 1.1 Add Countries Table

```sql
CREATE TABLE countries (
    id SERIAL PRIMARY KEY,
    code VARCHAR(2) UNIQUE NOT NULL,  -- ISO 3166-1 alpha-2 (RU, UZ, KZ, etc.)
    name_en VARCHAR(100) NOT NULL,
    name_ru VARCHAR(100) NOT NULL,
    name_local VARCHAR(100),          -- Name in local language
    currency_code VARCHAR(3) NOT NULL, -- ISO 4217 (RUB, UZS, etc.)
    currency_symbol VARCHAR(10) NOT NULL,
    currency_name_en VARCHAR(50) NOT NULL,
    currency_name_ru VARCHAR(50) NOT NULL,
    phone_code VARCHAR(5) NOT NULL,   -- +7, +998, +380, etc.
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 1.2 Modify Regions Table

```sql
-- Add country foreign key to existing regions table
ALTER TABLE regions ADD COLUMN country_id INTEGER REFERENCES countries(id);

-- Or if creating new:
CREATE TABLE regions (
    id SERIAL PRIMARY KEY,
    country_id INTEGER REFERENCES countries(id) NOT NULL,
    name_en VARCHAR(100) NOT NULL,
    name_ru VARCHAR(100) NOT NULL,
    name_local VARCHAR(100),
    code VARCHAR(20),                 -- Region code if applicable
    is_active BOOLEAN DEFAULT TRUE
);
```

### 1.3 Modify Districts Table

```sql
-- Ensure districts reference regions (which now reference countries)
CREATE TABLE districts (
    id SERIAL PRIMARY KEY,
    region_id INTEGER REFERENCES regions(id) NOT NULL,
    name_en VARCHAR(100) NOT NULL,
    name_ru VARCHAR(100) NOT NULL,
    name_local VARCHAR(100),
    is_active BOOLEAN DEFAULT TRUE
);
```

### 1.4 Modify User/Account Table

```sql
-- Add country to user accounts
ALTER TABLE accounts ADD COLUMN country_id INTEGER REFERENCES countries(id);
```

### 1.5 Modify Products/Services/RealEstate Tables

```sql
-- Add country reference for filtering by country
ALTER TABLE products ADD COLUMN country_id INTEGER REFERENCES countries(id);
ALTER TABLE services ADD COLUMN country_id INTEGER REFERENCES countries(id);
ALTER TABLE real_estate ADD COLUMN country_id INTEGER REFERENCES countries(id);
```

---

## 2. API Endpoint Changes

### 2.1 New Endpoints

```
GET  /api/countries/                    -- List all active countries
GET  /api/countries/{code}/             -- Get country details by code
GET  /api/countries/{code}/regions/     -- Get regions for a country
GET  /api/regions/{id}/districts/       -- Get districts for a region (existing, no change)
```

### 2.2 Modified Endpoints

```
# Regions - add country filter
GET /accounts/regions/?country=UZ       -- Filter regions by country code

# Products - add country filter
GET /products/?country=UZ               -- Filter products by country
GET /products/?country=UZ&region=1      -- Filter by country and region

# Services - add country filter
GET /services/?country=UZ

# Real Estate - add country filter
GET /real_estate/?country=UZ

# Search - add country parameter
GET /search/?q=iphone&country=UZ

# User registration - accept country
POST /accounts/register/
{
    "email": "...",
    "country": "UZ",      // NEW: country code
    "region": 1,
    "district": 5
}
```

### 2.3 Response Format Changes

#### Countries List Response
```json
GET /api/countries/

{
    "count": 15,
    "results": [
        {
            "id": 1,
            "code": "UZ",
            "name": "Uzbekistan",        // Based on Accept-Language header
            "name_en": "Uzbekistan",
            "name_ru": "Узбекистан",
            "currency": {
                "code": "UZS",
                "symbol": "so'm",
                "name": "Uzbek Som"
            },
            "phone_code": "+998",
            "flag_emoji": "🇺🇿"
        },
        {
            "id": 2,
            "code": "KZ",
            "name": "Kazakhstan",
            "name_en": "Kazakhstan",
            "name_ru": "Казахстан",
            "currency": {
                "code": "KZT",
                "symbol": "₸",
                "name": "Kazakhstani Tenge"
            },
            "phone_code": "+7",
            "flag_emoji": "🇰🇿"
        }
        // ... more countries
    ]
}
```

#### Regions Response (Modified)
```json
GET /accounts/regions/?country=UZ

{
    "count": 14,
    "country": {
        "code": "UZ",
        "name": "Uzbekistan"
    },
    "results": [
        {
            "id": 1,
            "name": "Tashkent",
            "name_en": "Tashkent",
            "name_ru": "Ташкент"
        }
        // ...
    ]
}
```

---

## 3. Countries & Regions Data

### 3.1 Countries Seed Data

```json
[
    {"code": "RU", "name_en": "Russia", "name_ru": "Россия", "currency_code": "RUB", "currency_symbol": "₽", "phone_code": "+7"},
    {"code": "UA", "name_en": "Ukraine", "name_ru": "Украина", "currency_code": "UAH", "currency_symbol": "₴", "phone_code": "+380"},
    {"code": "BY", "name_en": "Belarus", "name_ru": "Беларусь", "currency_code": "BYN", "currency_symbol": "Br", "phone_code": "+375"},
    {"code": "MD", "name_en": "Moldova", "name_ru": "Молдова", "currency_code": "MDL", "currency_symbol": "L", "phone_code": "+373"},
    {"code": "EE", "name_en": "Estonia", "name_ru": "Эстония", "currency_code": "EUR", "currency_symbol": "€", "phone_code": "+372"},
    {"code": "LV", "name_en": "Latvia", "name_ru": "Латвия", "currency_code": "EUR", "currency_symbol": "€", "phone_code": "+371"},
    {"code": "LT", "name_en": "Lithuania", "name_ru": "Литва", "currency_code": "EUR", "currency_symbol": "€", "phone_code": "+370"},
    {"code": "GE", "name_en": "Georgia", "name_ru": "Грузия", "currency_code": "GEL", "currency_symbol": "₾", "phone_code": "+995"},
    {"code": "AM", "name_en": "Armenia", "name_ru": "Армения", "currency_code": "AMD", "currency_symbol": "֏", "phone_code": "+374"},
    {"code": "AZ", "name_en": "Azerbaijan", "name_ru": "Азербайджан", "currency_code": "AZN", "currency_symbol": "₼", "phone_code": "+994"},
    {"code": "KZ", "name_en": "Kazakhstan", "name_ru": "Казахстан", "currency_code": "KZT", "currency_symbol": "₸", "phone_code": "+7"},
    {"code": "UZ", "name_en": "Uzbekistan", "name_ru": "Узбекистан", "currency_code": "UZS", "currency_symbol": "so'm", "phone_code": "+998"},
    {"code": "TM", "name_en": "Turkmenistan", "name_ru": "Туркменистан", "currency_code": "TMT", "currency_symbol": "m", "phone_code": "+993"},
    {"code": "KG", "name_en": "Kyrgyzstan", "name_ru": "Кыргызстан", "currency_code": "KGS", "currency_symbol": "с", "phone_code": "+996"},
    {"code": "TJ", "name_en": "Tajikistan", "name_ru": "Таджикистан", "currency_code": "TJS", "currency_symbol": "ЅМ", "phone_code": "+992"}
]
```

### 3.2 Regions Data Sources

You'll need to populate regions for each country. Here are the administrative divisions:

| Country | Admin Level 1 | Count | Admin Level 2 |
|---------|---------------|-------|---------------|
| Russia | Oblast/Krai/Republic | 85 | Raion |
| Ukraine | Oblast | 24 | Raion |
| Belarus | Voblast | 6 | Raion |
| Moldova | Raion | 32 | - |
| Estonia | County (Maakond) | 15 | Municipality |
| Latvia | Region | 5 | Municipality |
| Lithuania | County | 10 | Municipality |
| Georgia | Region | 9 | Municipality |
| Armenia | Marz | 10 | Community |
| Azerbaijan | Rayon | 66 | - |
| Kazakhstan | Oblast | 17 | Raion |
| Uzbekistan | Viloyat | 12 | Tuman |
| Turkmenistan | Welayat | 5 | Etrap |
| Kyrgyzstan | Oblast | 7 | Raion |
| Tajikistan | Viloyat | 4 | Nohiya |

**Data Sources for Regions:**
- GeoNames: https://www.geonames.org/
- OpenStreetMap Admin Boundaries
- Wikipedia lists for each country

---

## 4. Django Implementation Example

### 4.1 Models (models.py)

```python
from django.db import models

class Country(models.Model):
    code = models.CharField(max_length=2, unique=True)  # ISO 3166-1 alpha-2
    name_en = models.CharField(max_length=100)
    name_ru = models.CharField(max_length=100)
    name_local = models.CharField(max_length=100, blank=True)
    currency_code = models.CharField(max_length=3)  # ISO 4217
    currency_symbol = models.CharField(max_length=10)
    currency_name_en = models.CharField(max_length=50)
    currency_name_ru = models.CharField(max_length=50)
    phone_code = models.CharField(max_length=5)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        verbose_name_plural = "countries"
        ordering = ['name_en']

    def __str__(self):
        return f"{self.name_en} ({self.code})"


class Region(models.Model):
    country = models.ForeignKey(Country, on_delete=models.CASCADE, related_name='regions')
    name_en = models.CharField(max_length=100)
    name_ru = models.CharField(max_length=100)
    name_local = models.CharField(max_length=100, blank=True)
    code = models.CharField(max_length=20, blank=True)
    is_active = models.BooleanField(default=True)

    class Meta:
        ordering = ['name_en']

    def __str__(self):
        return f"{self.name_en}, {self.country.code}"


class District(models.Model):
    region = models.ForeignKey(Region, on_delete=models.CASCADE, related_name='districts')
    name_en = models.CharField(max_length=100)
    name_ru = models.CharField(max_length=100)
    name_local = models.CharField(max_length=100, blank=True)
    is_active = models.BooleanField(default=True)

    class Meta:
        ordering = ['name_en']

    def __str__(self):
        return f"{self.name_en}, {self.region.name_en}"
```

### 4.2 Serializers (serializers.py)

```python
from rest_framework import serializers
from .models import Country, Region, District

class CurrencySerializer(serializers.Serializer):
    code = serializers.CharField(source='currency_code')
    symbol = serializers.CharField(source='currency_symbol')
    name = serializers.SerializerMethodField()

    def get_name(self, obj):
        request = self.context.get('request')
        lang = getattr(request, 'LANGUAGE_CODE', 'en')
        if lang == 'ru':
            return obj.currency_name_ru
        return obj.currency_name_en


class CountrySerializer(serializers.ModelSerializer):
    currency = CurrencySerializer(source='*')
    name = serializers.SerializerMethodField()
    flag_emoji = serializers.SerializerMethodField()

    class Meta:
        model = Country
        fields = ['id', 'code', 'name', 'name_en', 'name_ru', 'currency', 'phone_code', 'flag_emoji']

    def get_name(self, obj):
        request = self.context.get('request')
        lang = getattr(request, 'LANGUAGE_CODE', 'en')
        if lang == 'ru':
            return obj.name_ru
        return obj.name_en

    def get_flag_emoji(self, obj):
        # Convert country code to flag emoji
        return ''.join(chr(ord(c) + 127397) for c in obj.code.upper())


class RegionSerializer(serializers.ModelSerializer):
    name = serializers.SerializerMethodField()

    class Meta:
        model = Region
        fields = ['id', 'name', 'name_en', 'name_ru', 'code']

    def get_name(self, obj):
        request = self.context.get('request')
        lang = getattr(request, 'LANGUAGE_CODE', 'en')
        if lang == 'ru':
            return obj.name_ru
        return obj.name_en


class DistrictSerializer(serializers.ModelSerializer):
    name = serializers.SerializerMethodField()

    class Meta:
        model = District
        fields = ['id', 'name', 'name_en', 'name_ru']

    def get_name(self, obj):
        request = self.context.get('request')
        lang = getattr(request, 'LANGUAGE_CODE', 'en')
        if lang == 'ru':
            return obj.name_ru
        return obj.name_en
```

### 4.3 Views (views.py)

```python
from rest_framework import viewsets, generics
from rest_framework.response import Response
from django_filters import rest_framework as filters
from .models import Country, Region, District
from .serializers import CountrySerializer, RegionSerializer, DistrictSerializer


class CountryViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Country.objects.filter(is_active=True)
    serializer_class = CountrySerializer
    lookup_field = 'code'


class RegionListView(generics.ListAPIView):
    serializer_class = RegionSerializer

    def get_queryset(self):
        queryset = Region.objects.filter(is_active=True)
        country_code = self.request.query_params.get('country')
        if country_code:
            queryset = queryset.filter(country__code=country_code.upper())
        return queryset


class DistrictListView(generics.ListAPIView):
    serializer_class = DistrictSerializer

    def get_queryset(self):
        region_id = self.kwargs.get('region_id')
        return District.objects.filter(region_id=region_id, is_active=True)
```

### 4.4 URLs (urls.py)

```python
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import CountryViewSet, RegionListView, DistrictListView

router = DefaultRouter()
router.register(r'countries', CountryViewSet)

urlpatterns = [
    path('', include(router.urls)),
    path('regions/', RegionListView.as_view(), name='region-list'),
    path('regions/<int:region_id>/districts/', DistrictListView.as_view(), name='district-list'),
]
```

---

## 5. Migration Strategy

### Phase 1: Database Setup
1. Create `countries` table and seed with 15 countries
2. Add `country_id` column to `regions` table
3. Set all existing Uzbekistan regions to `country_id = UZ`
4. Add `country_id` to user accounts (default to UZ for existing users)

### Phase 2: API Updates
1. Deploy new `/api/countries/` endpoint
2. Add `?country=` filter to existing regions endpoint
3. Update product/service/real_estate filters to support country

### Phase 3: Data Population
1. Add regions for Kazakhstan (17 oblasts)
2. Add regions for Kyrgyzstan (7 oblasts)
3. Add regions for Tajikistan (4 viloyats)
4. Add regions for Turkmenistan (5 welayats)
5. Continue with other countries as needed

### Phase 4: Product Updates
1. Add `country_id` to products, services, real_estate tables
2. Backfill existing listings with `country_id = UZ`
3. Update listing creation to require country

---

## 6. Phone Number Validation

```python
# Phone formats by country
PHONE_FORMATS = {
    'RU': {'code': '+7', 'length': 10, 'pattern': r'^[0-9]{10}$'},
    'UA': {'code': '+380', 'length': 9, 'pattern': r'^[0-9]{9}$'},
    'BY': {'code': '+375', 'length': 9, 'pattern': r'^[0-9]{9}$'},
    'MD': {'code': '+373', 'length': 8, 'pattern': r'^[0-9]{8}$'},
    'EE': {'code': '+372', 'length': 7, 'pattern': r'^[0-9]{7,8}$'},
    'LV': {'code': '+371', 'length': 8, 'pattern': r'^[0-9]{8}$'},
    'LT': {'code': '+370', 'length': 8, 'pattern': r'^[0-9]{8}$'},
    'GE': {'code': '+995', 'length': 9, 'pattern': r'^[0-9]{9}$'},
    'AM': {'code': '+374', 'length': 8, 'pattern': r'^[0-9]{8}$'},
    'AZ': {'code': '+994', 'length': 9, 'pattern': r'^[0-9]{9}$'},
    'KZ': {'code': '+7', 'length': 10, 'pattern': r'^[0-9]{10}$'},
    'UZ': {'code': '+998', 'length': 9, 'pattern': r'^[0-9]{9}$'},
    'TM': {'code': '+993', 'length': 8, 'pattern': r'^[0-9]{8}$'},
    'KG': {'code': '+996', 'length': 9, 'pattern': r'^[0-9]{9}$'},
    'TJ': {'code': '+992', 'length': 9, 'pattern': r'^[0-9]{9}$'},
}
```

---

## 7. Checklist

- [ ] Create `countries` table
- [ ] Seed 15 countries data
- [ ] Add `country_id` to `regions` table
- [ ] Add `country_id` to `accounts` table
- [ ] Add `country_id` to `products` table
- [ ] Add `country_id` to `services` table
- [ ] Add `country_id` to `real_estate` table
- [ ] Create `/api/countries/` endpoint
- [ ] Update `/accounts/regions/` to filter by country
- [ ] Update product/service/real_estate list endpoints with country filter
- [ ] Update user registration to accept country
- [ ] Add regions data for Central Asian countries (priority)
- [ ] Add regions data for other countries (later)
- [ ] Update admin panel to manage countries/regions
- [ ] Test all endpoints with different country codes
