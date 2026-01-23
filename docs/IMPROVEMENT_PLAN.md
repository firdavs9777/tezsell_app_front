# TezSell App Improvement Plan
## Category Search + Carrot Korea-Inspired UX Enhancements

---

## Phase 1: Category Search Functionality (Priority: High)

### 1.1 Add Search Bar to Categories List

**File to modify:** `lib/pages/products/product_category.dart`

**Implementation:**
```dart
// Add these state variables:
final TextEditingController _searchController = TextEditingController();
List<CategoryModel> _filteredCategories = [];

// Add search filter method:
void _filterCategories(String query) {
  setState(() {
    if (query.isEmpty) {
      _filteredCategories = availableCategories;
    } else {
      _filteredCategories = availableCategories.where((category) {
        final name = getCategoryName(category).toLowerCase();
        return name.contains(query.toLowerCase());
      }).toList();
    }
  });
}
```

**UI Changes:**
- Add search TextField below AppBar (sticky)
- Real-time filtering as user types
- Clear button when text is present
- Empty state when no matches found
- Highlight matching text in results

### 1.2 Apply Same Pattern to Service Categories

**File:** `lib/pages/service/main/service-filter.dart`

---

## Phase 2: Carrot Korea-Inspired UX Improvements

### 2.1 Home Screen Enhancements

| Feature | Description | Priority |
|---------|-------------|----------|
| **Nearby Listings** | Show items within X km radius first | High |
| **Quick Category Chips** | Horizontal scrollable category pills at top | High |
| **Pull-to-Refresh** | Swipe down to refresh feed | Medium |
| **Price Drop Alerts** | Badge on items with reduced prices | Medium |

### 2.2 Trust & Safety Features (Critical for Marketplace)

| Feature | Description | Priority |
|---------|-------------|----------|
| **User Verification Badge** | Verified phone/email indicator | High |
| **Transaction Count** | "32 successful trades" on profile | High |
| **Response Rate** | "Usually responds within 1 hour" | Medium |
| **Member Since** | Show account age for trust | Low |

### 2.3 Listing Detail Improvements

| Feature | Description | Priority |
|---------|-------------|----------|
| **Similar Items** | "You might also like" section | High |
| **Price Comparison** | "Fair price" / "Great deal" indicator | Medium |
| **Views Counter** | "142 people viewed this" | Medium |
| **Share Button** | Deep link sharing | Medium |
| **Report Listing** | Flag inappropriate content | High |

### 2.4 Chat/Negotiation Features

| Feature | Description | Priority |
|---------|-------------|----------|
| **Quick Replies** | "Is this available?", "What's lowest price?" | High |
| **Price Offer** | Built-in offer system (not just text) | Medium |
| **Meeting Scheduler** | Suggest safe meeting spots | Low |
| **Read Receipts** | Show when message is read | Medium |

### 2.5 Location Features (Carrot Korea's Core)

| Feature | Description | Priority |
|---------|-------------|----------|
| **GPS Auto-detect** | Set location automatically | High |
| **Distance Display** | "2.3 km away" on each listing | High |
| **Map View Toggle** | Switch between list and map view | Medium |
| **Neighborhood Boundaries** | Show items in "your neighborhood" | Medium |

### 2.6 Search & Discovery Improvements

| Feature | Description | Priority |
|---------|-------------|----------|
| **Recent Searches** | Save and show search history | High |
| **Search Suggestions** | Auto-complete as user types | Medium |
| **Saved Searches** | Get notified when new items match | Medium |
| **Voice Search** | Speech-to-text for search | Low |

### 2.7 Performance Optimizations

| Feature | Description | Priority |
|---------|-------------|----------|
| **Image Lazy Loading** | Load images as user scrolls | High |
| **Skeleton Loaders** | Show placeholders while loading | High |
| **Offline Mode** | Cache recent listings | Medium |
| **Compression** | Compress images before upload | Medium |

---

## Phase 3: Monetization Features (Future)

| Feature | Description |
|---------|-------------|
| **Promoted Listings** | Pay to appear at top |
| **Featured Seller** | Premium seller badge |
| **Bump Listing** | Refresh listing timestamp |

---

## Implementation Order (Recommended)

### Sprint 1: Core UX (1-2 weeks)
1. Category search functionality
2. Quick category chips on home
3. Distance display on listings
4. Pull-to-refresh

### Sprint 2: Trust Features (1-2 weeks)
1. User verification badges
2. Transaction count display
3. Report listing functionality
4. Views counter

### Sprint 3: Search Enhancement (1 week)
1. Recent searches
2. Search suggestions
3. Saved searches with notifications

### Sprint 4: Chat Improvements (1 week)
1. Quick reply buttons
2. Read receipts
3. Price offer system

### Sprint 5: Polish (1 week)
1. Skeleton loaders
2. Image optimization
3. Offline caching

---

## Database/API Requirements

### New API Endpoints Needed:
```
GET  /api/listings/nearby?lat=X&lng=Y&radius=Z
GET  /api/users/:id/stats (transaction count, response rate)
POST /api/listings/:id/report
GET  /api/listings/:id/similar
POST /api/search/save
GET  /api/search/history
GET  /api/listings/:id/views
```

### New Database Fields:
```
User:
  - is_verified: boolean
  - transaction_count: int
  - response_rate: float
  - last_seen: datetime

Listing:
  - view_count: int
  - is_promoted: boolean
  - coordinates: {lat, lng}
```

---

## Files to Create/Modify

### New Files:
- `lib/widgets/category_search_bar.dart`
- `lib/widgets/quick_category_chips.dart`
- `lib/widgets/skeleton_loader.dart`
- `lib/widgets/trust_badge.dart`
- `lib/widgets/distance_badge.dart`
- `lib/pages/search/search_history.dart`
- `lib/services/location_service.dart`

### Modify:
- `lib/pages/products/product_category.dart` (add search)
- `lib/pages/service/main/service-filter.dart` (add search)
- `lib/pages/home/home_page.dart` (quick chips, nearby)
- `lib/pages/products/product_detail.dart` (views, similar, report)
- `lib/pages/chat/chat_room.dart` (quick replies, offers)
- `lib/providers/provider_models/product_model.dart` (new fields)

---

## Localization Keys to Add

```dart
// app_localizations.dart
String get searchCategories => 'Search categories';
String get noMatchingCategories => 'No matching categories';
String get nearYou => 'Near you';
String get kmAway => 'km away';
String get verifiedSeller => 'Verified seller';
String get transactions => 'transactions';
String get responseRate => 'Response rate';
String get isThisAvailable => 'Is this available?';
String get makeOffer => 'Make an offer';
String get reportListing => 'Report listing';
String get similarItems => 'Similar items';
String get priceDropped => 'Price dropped';
String get greatDeal => 'Great deal';
String get fairPrice => 'Fair price';
```

---

## Summary

The most impactful improvements that will make TezSell competitive with Carrot Korea:

1. **Category Search** - Immediate usability win
2. **Location-based listings** - Core marketplace feature
3. **Trust indicators** - Critical for buyer confidence
4. **Quick chat replies** - Reduces friction in negotiations
5. **Skeleton loaders** - Perceived performance improvement

Start with Phase 1 (Category Search) as it's the requested feature, then proceed with location and trust features for maximum user impact.

---

## Additional Recommended Features

### High Impact Features

| Feature | Description | Carrot Korea Has It |
|---------|-------------|---------------------|
| **Story/Post Feature** | Users can share daily deals, neighborhood tips | Yes |
| **Live Chat Support** | In-app customer support chat | Yes |
| **Video in Listings** | Allow 15-30 sec product videos | Yes |
| **Barcode Scanner** | Scan product barcodes for quick listing | Partial |
| **AI Price Suggestion** | Suggest fair price based on similar items | Yes |
| **Bump/Promote** | Pay to boost listing visibility | Yes |
| **Scheduled Meetup** | Calendar integration for meeting buyer/seller | Yes |
| **Safe Meeting Spots** | Suggest police stations, public places | Yes |

### Engagement Features

| Feature | Description |
|---------|-------------|
| **Achievement System** | Gamification badges for milestones |
| **Referral Program** | Invite friends, earn rewards |
| **Daily Check-in** | Bonus points for opening app daily |
| **Flash Sales** | Time-limited deals section |
| **Trending Items** | Show what's popular in your area |
| **Price History** | Show price changes over time for items |
| **Comparison Tool** | Compare similar listings side by side |

### Safety Features

| Feature | Description |
|---------|-------------|
| **ID Verification** | Verify identity with national ID |
| **Phone Verification** | Verify phone number (already exists) |
| **Escrow Payments** | Hold payment until buyer confirms receipt |
| **Insurance Option** | Optional shipping insurance |
| **Scam Detection AI** | Flag suspicious listings |
| **Emergency Button** | Quick access to report during meetup |

### Communication Features

| Feature | Description |
|---------|-------------|
| **Voice Messages** | Send voice notes in chat |
| **Image Annotation** | Draw/mark on images when chatting |
| **Quick Offers** | Predefined offer buttons (10%, 20% off) |
| **Translation** | Auto-translate messages (UZ/RU/EN) |
| **Read Receipts** | Show when message is read |
| **Typing Indicator** | Show when other person is typing |

### Discovery Features

| Feature | Description |
|---------|-------------|
| **Nearby Map View** | See listings on a map around you |
| **AR Preview** | See furniture in your room (future) |
| **Image Search** | Search by uploading a photo |
| **Voice Search** | Speak to search |
| **Recent Views** | History of viewed items |
| **Similar Items** | "You might also like" section |

### Seller Tools

| Feature | Description |
|---------|-------------|
| **Analytics Dashboard** | Views, clicks, conversion rate |
| **Bulk Upload** | Upload multiple items at once |
| **Inventory Management** | Track your listed items |
| **Auto-Relist** | Automatically relist expired items |
| **QR Code** | Generate QR code for your shop |
| **Shop Page** | Dedicated seller storefront |

### Monetization Features

| Feature | Description |
|---------|-------------|
| **Premium Listings** | Pay for top placement |
| **Featured Seller** | Monthly subscription for visibility |
| **Coins/Credits** | In-app currency for purchases |
| **Subscription Tiers** | Basic, Pro, Business plans |
| **Ads** | Non-intrusive banner ads |

---

## Priority Implementation Order (Updated)

### Phase 1: Core Trust & Safety (DONE)
- [x] Category search
- [x] Quick category chips
- [x] Skeleton loaders
- [x] Bug fixes

### Phase 2: Trust Score & Reviews (DONE - Models, Services, Providers, Widgets)
- [x] Trust Score (Manner Temperature) - `trust_score_model.dart`, `trust_score_widget.dart`
- [x] User badges system - `BadgeTypes` in trust_score_model.dart
- [x] Star rating reviews - `star_rating.dart` widget
- [x] Review tags - `review_tags.dart`, `review_model.dart`
- [x] Transaction tracking - `transaction_model.dart`, `reviews_service.dart`

### Phase 3: Enhanced Favorites (DONE - Models, Services, Providers, Widgets)
- [x] Price drop notifications - `enhanced_favorite_model.dart`
- [x] Collections - `FavoriteCollection` model, `favorites_service.dart`
- [x] Favorite notes - `FavoriteItem.note` field
- [x] Favorite button widget - `favorite_button.dart`

### Phase 4: Social Features (DONE - Models, Services, Providers)
- [x] Google Sign-In - `social_auth_model.dart`, `social_auth_service.dart`
- [x] Apple Sign-In - `social_auth_service.dart`
- [x] Linked accounts management - `social_auth_provider.dart`
- [x] Login history - `LoginHistoryEntry` model

### Phase 5: Discovery & Engagement (DONE - Models, Services, Providers)
- [x] Search Alerts - `search_alert_model.dart`, `search_alerts_service.dart`
- [x] Recently Viewed - `recently_viewed_model.dart`, `recently_viewed_service.dart`
- [x] Saved Searches - `saved_search_model.dart`, `saved_searches_service.dart`
- [ ] Similar items - Requires backend endpoint
- [ ] Trending section - Requires backend endpoint

### Phase 6: Vacation Mode (DONE)
- [x] Vacation status - `vacation_mode_model.dart`
- [x] Toggle vacation mode - `vacation_mode_service.dart`
- [x] Vacation badge widget - `vacation_mode_widget.dart`

### Phase 7: Communication Enhancements
- [ ] Quick chat replies
- [ ] Voice messages
- [ ] Read receipts

### Phase 8: Monetization
- [ ] Promoted listings
- [ ] Premium features
