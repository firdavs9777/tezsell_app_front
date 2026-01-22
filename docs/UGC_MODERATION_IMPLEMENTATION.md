# User-Generated Content Moderation Implementation

## Overview
This document describes the implementation of Apple App Store Guideline 1.2 requirements for user-generated content moderation.

## ✅ Implemented Features

### 1. Terms of Service Acceptance
- **Location**: `lib/pages/authentication/password_set.dart`
- **Implementation**: 
  - Added mandatory checkbox for Terms and Conditions acceptance during registration
  - Users must explicitly agree to terms before completing registration
  - Terms acceptance is stored in SharedPreferences with timestamp
  - Link to view full Terms and Conditions

### 2. Updated Terms and Conditions
- **Location**: `lib/pages/shaxsiy/profile-terms/terms_and_conditions.dart`
- **Changes**:
  - Added new Section 5: "USER-GENERATED CONTENT & ZERO TOLERANCE POLICY"
  - Explicitly states zero tolerance for objectionable content
  - Details content moderation process
  - Explains reporting mechanism and 24-hour review commitment
  - Lists prohibited content types
  - Describes enforcement actions (content removal, account suspension/ban)

### 3. Content Reporting System
- **Service**: `lib/service/content_report_service.dart`
  - API service for reporting products, services, messages, and users
  - Supports multiple report reasons (spam, inappropriate, fraud, harassment, illegal, other)
  - Optional description field for additional details
  
- **UI Component**: `lib/widgets/report_content_dialog.dart`
  - User-friendly dialog for submitting reports
  - Reason selection with radio buttons
  - Optional description field
  - Success/error feedback

### 4. Report Functionality Integration
- **Products**: 
  - Added report option in product detail page (`lib/pages/products/product_detail.dart`)
  - Accessible via three-dot menu in AppBar
  
- **Services**:
  - Added report option in service detail page (`lib/pages/service/details/service_detail.dart`)
  - Accessible via three-dot menu in AppBar
  
- **Messages**:
  - Added report option in message options sheet (`lib/pages/chat/widgets/message_options_sheet.dart`)
  - Accessible via long-press on messages from other users

### 5. Content Filtering
- **Utility**: `lib/utils/content_filter.dart`
  - Basic keyword-based content filtering
  - Validates titles and descriptions before submission
  - Integrated into product and service creation flows
  - Note: Currently uses basic keyword list - can be enhanced with professional moderation service

### 6. User Blocking (Already Existed)
- User blocking functionality was already implemented
- Users can block abusive users through chat interface
- Blocked users are filtered from chat lists

### 7. Localization
- Added localization keys in English, Russian, and Uzbek:
  - Terms acceptance messages
  - Report dialog labels
  - Report success messages
  - All UI text for reporting features

## API Endpoints

The reporting system expects the following API endpoint:

```
POST /api/reports/
```

**Request Body:**
```json
{
  "content_type": "product" | "service" | "message" | "user",
  "content_id": <integer>,
  "reason": "spam" | "inappropriate" | "fraud" | "harassment" | "illegal" | "other",
  "description": "<optional additional details>"
}
```

**Response:**
- `200` or `201`: Report submitted successfully
- Other status codes: Error occurred

## Backend Requirements

To fully comply with Apple's requirements, the backend must:

1. **Store Reports**: Save all reports in a database with timestamps
2. **24-Hour Review**: Implement a system to review reports within 24 hours
3. **Content Removal**: Provide API endpoints to remove reported content
4. **User Ejection**: Provide API endpoints to suspend/ban users
5. **Admin Dashboard**: (Recommended) Create an admin interface to manage reports

## Testing Checklist

- [ ] Terms acceptance is required during registration
- [ ] Terms acceptance is stored correctly
- [ ] Report dialog appears for products, services, and messages
- [ ] Reports can be submitted with all reason types
- [ ] Content filtering prevents prohibited keywords
- [ ] Localization works in all three languages
- [ ] User blocking functionality works
- [ ] API endpoints are properly configured

## Next Steps (Optional Enhancements)

1. **Enhanced Content Filtering**:
   - Integrate with professional content moderation API (e.g., Google Cloud Vision, AWS Rekognition)
   - Image content analysis
   - Machine learning-based text analysis

2. **Admin Dashboard**:
   - Web interface for reviewing reports
   - Bulk actions for content removal
   - User management interface

3. **Automated Moderation**:
   - Pre-upload content scanning
   - Automatic flagging of suspicious content
   - Pattern detection for spam/fraud

4. **Analytics**:
   - Track report types and frequency
   - Monitor content removal rates
   - User behavior analysis

## Compliance Status

✅ **Requirement 1**: Users must agree to Terms (EULA) with zero tolerance statement
✅ **Requirement 2**: Method for filtering objectionable content (basic implementation)
✅ **Requirement 3**: Mechanism for users to flag objectionable content
✅ **Requirement 4**: Mechanism for users to block abusive users (already existed)
⚠️ **Requirement 5**: Developer action within 24 hours (requires backend implementation)

## Notes

- The content filtering is basic and should be enhanced for production
- The reporting API endpoint needs to be implemented on the backend
- Admin tools for reviewing reports should be created
- Consider implementing automated content moderation for better coverage

