# TezSell New Features Implementation Plan

## Current Status Overview

| Feature | Backend Ready | Frontend Status | Priority |
|---------|--------------|-----------------|----------|
| Social Auth (Google/Apple) | YES | Not Started | HIGH |
| Favorites & Collections | YES | Partial (60%) | HIGH |
| Trust Score (Manner Temp) | YES | Not Started | HIGH |
| Reviews System | YES | Partial (50%) | MEDIUM |
| Search Alerts | YES | Not Started | MEDIUM |
| Security Features | YES | Not Started | LOW |

---

## 1. Social Authentication (Google & Apple)

### Required Packages
```yaml
# Add to pubspec.yaml
google_sign_in: ^6.2.1
sign_in_with_apple: ^6.1.1
```

### Files to Create
```
lib/
  services/
    social_auth_service.dart        # API calls for social auth
  providers/
    social_auth_provider.dart       # Riverpod state management
  pages/
    authentication/
      social_login_buttons.dart     # Reusable social login buttons widget
```

### Files to Modify
- `lib/pages/authentication/login.dart` - Add social login buttons
- `lib/pages/authentication/register.dart` - Add social signup option
- `lib/pages/shaxsiy/shaxsiy.dart` - Add linked accounts section
- `lib/service/authentication_service.dart` - Add social auth methods

### API Endpoints to Implement
```dart
// POST /api/accounts/auth/google/
Future<AuthResponse> loginWithGoogle(String idToken);

// POST /api/accounts/auth/apple/
Future<AuthResponse> loginWithApple(String idToken, String? email, String? name);

// GET /api/accounts/social-accounts/
Future<List<SocialAccount>> getLinkedAccounts();

// DELETE /api/accounts/social-accounts/
Future<void> unlinkSocialAccount(String provider);
```

### UI Components
- [ ] Google Sign-In button (Material Design)
- [ ] Apple Sign-In button (follows Apple HIG)
- [ ] Linked accounts list in settings
- [ ] Unlink account confirmation dialog

---

## 2. Enhanced Favorites System

### Files to Create
```
lib/
  providers/
    provider_models/
      favorite_model.dart           # New model with price tracking
      collection_model.dart         # Collections model
    provider_root/
      favorites_provider.dart       # Enhanced favorites provider
  pages/
    favorites/
      favorites_page.dart           # Main favorites page with tabs
      collections_page.dart         # Collections management
      collection_detail.dart        # Single collection view
  widgets/
    favorite_button.dart            # Animated favorite heart button
    price_drop_badge.dart           # Price drop indicator
```

### Files to Modify
- `lib/pages/products/product_detail.dart` - Enhanced favorite button
- `lib/pages/service/details/service_detail.dart` - Enhanced favorite button
- `lib/pages/shaxsiy/favorite_items/` - Update existing pages

### New Features
- [ ] Toggle favorite with note and price tracking
- [ ] Price drop notifications
- [ ] Collections (create, manage, add items)
- [ ] Favorites count by type
- [ ] Check if item is favorited (fast lookup)

### Data Model
```dart
class FavoriteItem {
  final int id;
  final String itemType; // product, service, property
  final int itemId;
  final String itemTitle;
  final String itemPrice;
  final String? itemImage;
  final String? note;
  final String priceAtFavorite;
  final String? currentPrice;
  final bool priceDropped;
  final bool notifyPriceDrop;
  final DateTime createdAt;
}

class FavoriteCollection {
  final int id;
  final String name;
  final String? description;
  final bool isPublic;
  final int itemsCount;
  final List<FavoriteItem> items;
}
```

---

## 3. Trust Score System (Manner Temperature)

### Files to Create
```
lib/
  providers/
    provider_models/
      trust_score_model.dart        # Trust score data model
      transaction_model.dart        # Transaction model
      review_model.dart             # Review with tags model
      badge_model.dart              # User badges model
    provider_root/
      trust_score_provider.dart     # Trust score state
      transaction_provider.dart     # Transaction management
      reviews_provider.dart         # Reviews management
  pages/
    reviews/
      reviews_list_page.dart        # User's reviews page
      submit_review_page.dart       # Review submission form
      transaction_list_page.dart    # User's transactions
  widgets/
    trust_badge.dart                # Temperature display widget
    star_rating.dart                # Star rating input
    review_tags.dart                # Tag selector widget
    user_badges.dart                # Badge display row
```

### Files to Modify
- `lib/pages/profile/user_profile_screen.dart` - Add trust score display
- `lib/pages/products/product_detail.dart` - Show seller trust score
- `lib/pages/chat/chat_room.dart` - Add "Complete Transaction" action

### Trust Score Widget
```dart
class TrustScoreWidget extends StatelessWidget {
  final double temperature;
  final String level; // cold, cool, normal, warm, hot, fire
  final String emoji;
  final List<Badge> badges;

  // Display: "42.5°C 😊" with color gradient
}
```

### Temperature Levels (from API docs)
| Range | Level | Emoji | Color |
|-------|-------|-------|-------|
| 0-20°C | cold | 🥶 | #2196F3 (Blue) |
| 20-30°C | cool | 😐 | #90CAF9 (Light Blue) |
| 30-36.5°C | normal | 🙂 | #FFC107 (Amber) |
| 36.5-45°C | warm | 😊 | #FF9800 (Orange) |
| 45-60°C | hot | 😄 | #FF5722 (Deep Orange) |
| 60+°C | fire | 🔥 | #F44336 (Red) |

---

## 4. Reviews System

### Review Flow
1. User completes transaction in chat
2. Both buyer and seller can leave review
3. Select 1-5 star rating
4. Select quick tags (positive/negative)
5. Optional: Write detailed review text
6. Submit updates trust score

### Tag Categories
**Positive Tags:**
- ⚡ Fast Response
- ✨ Good Condition
- 🤝 Friendly
- 📦 Well Packaged
- ⏰ On Time

**Negative Tags:**
- 🐢 Late Response
- 😕 Not as Described
- 🚫 No Show
- 💢 Rude

### UI Components
- [ ] Star rating input (1-5 stars, half-star support)
- [ ] Tag selector (multi-select, max 5)
- [ ] Review text input with character limit
- [ ] Review card display
- [ ] Rating summary with distribution chart

---

## 5. Search Alerts

### Files to Create
```
lib/
  providers/
    provider_models/
      search_alert_model.dart       # Alert model
    provider_root/
      search_alerts_provider.dart   # Alerts state management
  pages/
    alerts/
      search_alerts_page.dart       # List of alerts
      create_alert_page.dart        # Create new alert
  widgets/
    alert_card.dart                 # Alert display card
```

### Features
- [ ] Create alert with keyword, filters, price range
- [ ] Toggle alerts on/off
- [ ] View matches count
- [ ] Push notification when new listing matches
- [ ] Max 10 active alerts per user

### Alert Model
```dart
class SearchAlert {
  final int id;
  final String keyword;
  final String itemType; // product, service, property, all
  final String? region;
  final String? district;
  final String? minPrice;
  final String? maxPrice;
  final bool isActive;
  final bool notifyPush;
  final bool notifyEmail;
  final int matchesFound;
  final DateTime? lastNotified;
}
```

---

## 6. Security Features

### Files to Create
```
lib/
  pages/
    security/
      login_history_page.dart       # View login history
      active_sessions_page.dart     # Manage sessions
```

### Features
- [ ] View login history (device, IP, time, method)
- [ ] Logout from other devices
- [ ] Account lockout warning display

---

## Implementation Priority Order

### Phase 1: Trust & Reviews (Carrot Korea Core Feature)
1. Trust score model and provider
2. Trust score widget (temperature display)
3. User profile integration
4. Transaction flow in chat
5. Review submission page
6. Review tags selector

### Phase 2: Enhanced Favorites
1. New favorite model with price tracking
2. Enhanced favorite button with animation
3. Price drop badge
4. Collections system
5. Favorites page redesign

### Phase 3: Social Authentication
1. Add packages to pubspec
2. Google Sign-In integration
3. Apple Sign-In integration
4. Linked accounts in settings

### Phase 4: Search Alerts
1. Alert model and provider
2. Create alert page
3. Alerts list page
4. Push notification integration

### Phase 5: Security
1. Login history page
2. Active sessions management

---

## Localization Keys to Add

```dart
// Trust Score
String get trustScore => 'Trust Score';
String get mannerTemperature => 'Manner Temperature';
String get transactions => 'Transactions';
String get completedDeals => 'Completed Deals';

// Reviews
String get leaveReview => 'Leave a Review';
String get selectRating => 'Select Rating';
String get selectTags => 'Select Tags';
String get writeReview => 'Write a Review (Optional)';
String get reviewSubmitted => 'Review Submitted';

// Favorites
String get addedToFavorites => 'Added to Favorites';
String get removedFromFavorites => 'Removed from Favorites';
String get priceDropped => 'Price Dropped!';
String get collections => 'Collections';
String get createCollection => 'Create Collection';

// Search Alerts
String get searchAlerts => 'Search Alerts';
String get createAlert => 'Create Alert';
String get alertCreated => 'Alert Created';
String get newMatchFound => 'New Match Found';

// Social Auth
String get continueWithGoogle => 'Continue with Google';
String get continueWithApple => 'Continue with Apple';
String get linkedAccounts => 'Linked Accounts';
String get unlinkAccount => 'Unlink Account';
```

---

## Estimated Timeline

| Phase | Features | Complexity |
|-------|----------|------------|
| Phase 1 | Trust Score & Reviews | High |
| Phase 2 | Enhanced Favorites | Medium |
| Phase 3 | Social Auth | Medium |
| Phase 4 | Search Alerts | Medium |
| Phase 5 | Security | Low |

---

## Questions for Backend Team

1. WebSocket events for real-time trust score updates?
2. Image upload for review photos?
3. Report review functionality?
4. Block user from reviewing?
5. Appeal system for unfair reviews?
