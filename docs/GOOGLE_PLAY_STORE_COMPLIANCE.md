# Reporting and Blocking Functionalities - Google Play Store Compliance

## Overview
This document outlines the User-Generated Content (UGC) moderation features implemented in the Sabzi Market application to comply with Google Play Store guidelines, specifically **Guideline 1.2 - Safety - User-Generated Content**.

---

## ✅ Implemented Features

### 1. **Terms of Service Agreement**
- **Location**: Registration flow (`password_set.dart`)
- **Requirement**: Users must accept Terms and Conditions before creating an account
- **Implementation**: 
  - Checkbox validation during registration
  - Terms explicitly state zero tolerance for objectionable content
  - Users cannot proceed without acceptance

### 2. **Content Reporting System**
Users can report objectionable content through multiple entry points:

#### **Reportable Content Types:**
- ✅ **Products** - Report inappropriate product listings
- ✅ **Services** - Report inappropriate service listings  
- ✅ **Messages** - Report inappropriate chat messages
- ✅ **Users** - Report abusive or fraudulent users

#### **Report Reasons Available:**
1. **Spam** - Unwanted or repetitive content
2. **Inappropriate Content** - Content that violates community standards
3. **Fraud or Scam** - Deceptive or fraudulent listings
4. **Harassment** - Bullying, threats, or abusive behavior
5. **Illegal Activity** - Content promoting illegal activities
6. **Other** - Additional concerns with optional description

#### **How Users Report:**
- **Product/Service Pages**: Menu option (⋮) → "Report" → Select reason → Submit
- **Chat Messages**: Long-press message → "Report Message" → Select reason → Submit
- **User Profiles**: Report option available in user context menus

#### **Reporting Features:**
- ✅ Reason selection (required)
- ✅ Optional additional details/description
- ✅ Duplicate report detection (prevents spam reporting)
- ✅ Success confirmation with 24-hour review commitment message
- ✅ Error handling with user-friendly messages
- ✅ Multi-language support (English, Russian, Uzbek)

### 3. **Content Filtering**
- **Location**: `lib/utils/content_filter.dart`
- **Functionality**: 
  - Keyword-based filtering for titles and descriptions
  - Prevents submission of content containing prohibited keywords
  - Validates content before posting

### 4. **Terms of Service - Zero Tolerance Policy**
- **Location**: `lib/pages/shaxsiy/profile-terms/terms_and_conditions.dart`
- **Section**: "5. USER-GENERATED CONTENT & ZERO TOLERANCE POLICY"
- **Key Points**:
  - Explicit zero tolerance for objectionable content
  - 24-hour review commitment for all reports
  - Enforcement actions clearly stated (content removal, user suspension/ban)
  - Available in all supported languages

---

## 🔄 Backend Requirements (For Compliance)

### **API Endpoint:**
- **URL**: `/api/reports/`
- **Method**: POST
- **Authentication**: Token-based
- **Payload**:
  ```json
  {
    "content_type": "product|service|message|user",
    "content_id": <integer>,
    "reason": "spam|inappropriate|fraud|harassment|illegal|other",
    "description": "<optional text>"
  }
  ```

### **Backend Responsibilities:**
1. ✅ **Report Storage** - Store all reports in database
2. ✅ **Duplicate Detection** - Prevent duplicate reports from same user
3. ✅ **24-Hour Review** - Process reports within 24 hours
4. ✅ **Content Moderation** - Review and take action on reported content
5. ✅ **User Actions** - Suspend or ban users who violate policies
6. ✅ **Content Removal** - Remove objectionable content promptly

### **Admin Dashboard Requirements:**
- View all reports
- Filter by status (pending, reviewed, resolved)
- Take action on reports (remove content, warn user, ban user)
- Track review times to ensure 24-hour commitment

---

## 📋 Google Play Store Compliance Checklist

### ✅ **Guideline 1.2 Requirements Met:**

| Requirement | Status | Implementation |
|------------|--------|---------------|
| **Terms Agreement** | ✅ Complete | Required during registration with explicit zero tolerance policy |
| **Content Filtering** | ✅ Complete | Keyword-based filtering for titles and descriptions |
| **Report Mechanism** | ✅ Complete | Available for products, services, messages, and users with 6 report reasons |
| **User Blocking** | ⚠️ Backend Required | Frontend ready, requires backend API implementation |
| **24-Hour Review** | ⚠️ Backend Required | Policy documented, requires backend moderation system |

---

## 📱 User Experience Flow

### **Reporting Flow:**
1. User identifies objectionable content
2. User taps "Report" option (menu or context menu)
3. Dialog opens with:
   - Content title/identifier
   - 6 report reason options (radio buttons)
   - Optional description field
   - Submit button
4. User selects reason and optionally adds details
5. User submits report
6. Success message: *"Thank you for your report. We will review it within 24 hours."*
7. If duplicate: *"You have already reported this content. We are reviewing your previous report."*

### **Error Handling:**
- Network errors: Clear message with retry option
- Authentication errors: Prompt to login
- Duplicate reports: Informative message
- Server errors: Generic error with support contact

---

## 🌍 Localization

All reporting features are fully localized in:
- **English (en-US)**
- **Russian (ru)**
- **Uzbek (uz)**

Includes:
- Report dialog text
- Report reasons
- Success/error messages
- Terms of Service

---

## 🔒 Privacy & Security

- Reports are authenticated (require user login)
- Report data is sent securely via HTTPS
- User information is not exposed in error messages
- Reports are stored securely on backend

---

## 📊 Reporting Statistics (For Admin)

The backend should track:
- Total reports received
- Reports by type (product/service/message/user)
- Reports by reason (spam/inappropriate/fraud/etc.)
- Average review time
- Actions taken (content removed, users banned, etc.)

---

## 🚀 Next Steps for Full Compliance

### **Immediate (Required):**
1. ✅ Frontend reporting UI - **COMPLETE**
2. ✅ Terms of Service with zero tolerance - **COMPLETE**
3. ✅ Content filtering - **COMPLETE**
4. ⚠️ Backend report endpoint - **REQUIRED**
5. ⚠️ Backend moderation system - **REQUIRED**
6. ⚠️ User blocking API - **REQUIRED**

### **Recommended:**
- Admin dashboard for report management
- Automated content scanning
- User reputation system
- Appeal process for banned users

---

## 📝 App Store Listing Text

### **For Google Play Store Description:**

> **Safety & Moderation**
> 
> Sabzi Market is committed to maintaining a safe and respectful marketplace. We have implemented comprehensive content moderation features:
> 
> - **Zero Tolerance Policy**: We have zero tolerance for objectionable content, spam, fraud, harassment, or illegal activity
> - **Easy Reporting**: Report any inappropriate content or users directly from the app
> - **24-Hour Review**: All reports are reviewed within 24 hours
> - **Content Filtering**: Automatic filtering prevents prohibited content from being posted
> - **User Protection**: Block and report users who violate our community guidelines
> 
> Users must accept our Terms of Service, which clearly outline our moderation policies and enforcement actions.

### **For Privacy Policy Section:**

> **User-Generated Content & Reporting**
> 
> Users can report objectionable content including products, services, messages, and other users. Reports are reviewed within 24 hours, and appropriate action is taken including content removal and user suspension/banning when necessary. All reports are stored securely and handled according to our moderation policies.

---

## ✅ Compliance Status

**Frontend Implementation**: ✅ **100% Complete**
- All UI components implemented
- All user flows functional
- Multi-language support
- Error handling complete

**Backend Requirements**: ⚠️ **Implementation Required**
- Report API endpoint needed
- Moderation system needed
- User blocking API needed
- Admin dashboard recommended

**Documentation**: ✅ **Complete**
- Terms of Service updated
- Implementation guides created
- API specifications documented

---

## 📞 Support

For questions about moderation or to report issues with the reporting system:
- In-app: Customer Center
- Email: [Your support email]
- Response time: Within 24 hours

---

**Last Updated**: 2024
**Version**: 1.0.0+22
**Compliance**: Google Play Store Guideline 1.2 - Safety - User-Generated Content


