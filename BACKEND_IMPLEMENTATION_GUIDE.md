# Backend Implementation Guide for UGC Moderation

## Overview
This document outlines all backend requirements to support the user-generated content moderation features required by Apple App Store Guideline 1.2.

---

## 1. API Endpoints

### 1.1 Report Content Endpoint

**Endpoint:** `POST /api/reports/`

**Authentication:** Required (Token-based)

**Request Body:**
```json
{
  "content_type": "product" | "service" | "message" | "user",
  "content_id": 123,
  "reason": "spam" | "inappropriate" | "fraud" | "harassment" | "illegal" | "other",
  "description": "Optional additional details about the report"
}
```

**Response (Success - 201 Created):**
```json
{
  "id": 456,
  "status": "pending",
  "created_at": "2024-01-15T10:30:00Z",
  "message": "Report submitted successfully. We will review it within 24 hours."
}
```

**Response (Error - 400 Bad Request):**
```json
{
  "error": "Invalid content_type or content_id",
  "details": "content_type must be one of: product, service, message, user"
}
```

**Implementation Notes:**
- Validate that `content_id` exists for the given `content_type`
- Prevent duplicate reports from the same user for the same content
- Store reporter's user ID for tracking
- Set initial status to "pending"
- Create notification/alert for admin team

---

### 1.2 Get Reports Endpoint (Admin Only)

**Endpoint:** `GET /api/reports/`

**Authentication:** Required (Admin role)

**Query Parameters:**
- `status`: Filter by status (`pending`, `reviewed`, `resolved`, `dismissed`)
- `content_type`: Filter by content type
- `page`: Page number (default: 1)
- `page_size`: Items per page (default: 20)

**Response:**
```json
{
  "count": 150,
  "next": "https://api.webtezsell.com/api/reports/?page=2",
  "previous": null,
  "results": [
    {
      "id": 456,
      "reporter": {
        "id": 789,
        "username": "user123",
        "email": "user@example.com"
      },
      "content_type": "product",
      "content_id": 123,
      "content_title": "Product Title",
      "content_owner": {
        "id": 101,
        "username": "seller456"
      },
      "reason": "fraud",
      "description": "This product seems fraudulent",
      "status": "pending",
      "created_at": "2024-01-15T10:30:00Z",
      "reviewed_at": null,
      "reviewed_by": null,
      "resolution": null
    }
  ]
}
```

---

### 1.3 Update Report Status (Admin Only)

**Endpoint:** `PATCH /api/reports/{report_id}/`

**Authentication:** Required (Admin role)

**Request Body:**
```json
{
  "status": "reviewed" | "resolved" | "dismissed",
  "resolution": "content_removed" | "user_suspended" | "user_banned" | "no_action",
  "admin_notes": "Internal notes about the resolution"
}
```

**Response (Success - 200 OK):**
```json
{
  "id": 456,
  "status": "resolved",
  "resolution": "content_removed",
  "reviewed_at": "2024-01-15T11:00:00Z",
  "reviewed_by": {
    "id": 1,
    "username": "admin"
  },
  "admin_notes": "Content removed due to fraud"
}
```

---

### 1.4 Remove Content Endpoint (Admin Only)

**Endpoint:** `DELETE /api/products/{product_id}/` or `DELETE /api/services/{service_id}/` or `DELETE /api/messages/{message_id}/`

**Authentication:** Required (Admin role)

**Query Parameters:**
- `reason`: Reason for removal (stored for audit)
- `report_id`: Associated report ID (if removed due to report)

**Response (Success - 204 No Content):**

**Implementation Notes:**
- Soft delete (mark as deleted, don't actually delete)
- Store deletion reason and timestamp
- Notify content owner via email/push notification
- Remove from public listings immediately

---

### 1.5 Suspend/Ban User Endpoint (Admin Only)

**Endpoint:** `POST /api/admin/users/{user_id}/suspend/` or `/api/admin/users/{user_id}/ban/`

**Authentication:** Required (Admin role)

**Request Body:**
```json
{
  "reason": "Multiple reports of fraudulent activity",
  "duration_days": 30,  // null for permanent ban
  "report_id": 456,  // Associated report
  "notify_user": true
}
```

**Response (Success - 200 OK):**
```json
{
  "user_id": 101,
  "action": "suspended",
  "duration_days": 30,
  "expires_at": "2024-02-15T10:00:00Z",
  "reason": "Multiple reports of fraudulent activity"
}
```

**Implementation Notes:**
- Mark user account as suspended/banned
- Prevent login during suspension
- Hide user's content from public listings
- Send notification to user
- Store suspension/ban record for audit

---

### 1.6 Get User Reports (Admin - User History)

**Endpoint:** `GET /api/admin/users/{user_id}/reports/`

**Authentication:** Required (Admin role)

**Response:**
```json
{
  "user_id": 101,
  "username": "seller456",
  "reports_received": [
    {
      "id": 456,
      "content_type": "product",
      "reason": "fraud",
      "status": "resolved",
      "created_at": "2024-01-15T10:30:00Z"
    }
  ],
  "reports_made": [
    {
      "id": 789,
      "content_type": "product",
      "reason": "spam",
      "status": "pending",
      "created_at": "2024-01-16T08:00:00Z"
    }
  ],
  "total_reports_received": 5,
  "total_reports_made": 2
}
```

---

## 2. Database Schema

### 2.1 Reports Table

```sql
CREATE TABLE reports (
    id SERIAL PRIMARY KEY,
    reporter_id INTEGER NOT NULL REFERENCES users(id),
    content_type VARCHAR(20) NOT NULL CHECK (content_type IN ('product', 'service', 'message', 'user')),
    content_id INTEGER NOT NULL,
    reason VARCHAR(50) NOT NULL CHECK (reason IN ('spam', 'inappropriate', 'fraud', 'harassment', 'illegal', 'other')),
    description TEXT,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'reviewed', 'resolved', 'dismissed')),
    resolution VARCHAR(50) CHECK (resolution IN ('content_removed', 'user_suspended', 'user_banned', 'no_action')),
    reviewed_by INTEGER REFERENCES users(id),
    reviewed_at TIMESTAMP,
    admin_notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Prevent duplicate reports
    UNIQUE(reporter_id, content_type, content_id)
);

CREATE INDEX idx_reports_status ON reports(status);
CREATE INDEX idx_reports_content ON reports(content_type, content_id);
CREATE INDEX idx_reports_created ON reports(created_at);
```

### 2.2 Content Deletions Table (Audit Log)

```sql
CREATE TABLE content_deletions (
    id SERIAL PRIMARY KEY,
    content_type VARCHAR(20) NOT NULL,
    content_id INTEGER NOT NULL,
    deleted_by INTEGER NOT NULL REFERENCES users(id),
    reason TEXT NOT NULL,
    report_id INTEGER REFERENCES reports(id),
    deleted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    original_data JSONB  -- Store snapshot of deleted content
);

CREATE INDEX idx_deletions_content ON content_deletions(content_type, content_id);
```

### 2.3 User Suspensions/Bans Table

```sql
CREATE TABLE user_suspensions (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id),
    action_type VARCHAR(20) NOT NULL CHECK (action_type IN ('suspended', 'banned')),
    reason TEXT NOT NULL,
    duration_days INTEGER,  -- NULL for permanent ban
    expires_at TIMESTAMP,
    suspended_by INTEGER NOT NULL REFERENCES users(id),
    report_id INTEGER REFERENCES reports(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

CREATE INDEX idx_suspensions_user ON user_suspensions(user_id);
CREATE INDEX idx_suspensions_active ON user_suspensions(is_active, expires_at);
```

### 2.4 Users Table Modifications

Add columns to existing `users` table:
```sql
ALTER TABLE users ADD COLUMN is_suspended BOOLEAN DEFAULT FALSE;
ALTER TABLE users ADD COLUMN is_banned BOOLEAN DEFAULT FALSE;
ALTER TABLE users ADD COLUMN suspension_expires_at TIMESTAMP;
ALTER TABLE users ADD COLUMN report_count INTEGER DEFAULT 0;
```

---

## 3. Admin Dashboard Requirements

### 3.1 Report Review Interface

**Features Needed:**
1. **Report List View:**
   - Show all pending reports (sorted by creation date)
   - Filter by content type, reason, status
   - Search by reporter username, content ID
   - Pagination

2. **Report Detail View:**
   - Show full report details
   - Display the reported content (product/service/message)
   - Show reporter information
   - Show content owner information
   - Show report history for the same content
   - Action buttons:
     - Remove Content
     - Suspend User
     - Ban User
     - Dismiss Report
     - Mark as Reviewed

3. **Bulk Actions:**
   - Select multiple reports
   - Bulk approve/dismiss
   - Export reports to CSV

### 3.2 Content Management

**Features:**
- View all content (products, services, messages)
- Search and filter content
- View content details
- Remove content with reason
- Restore deleted content (if soft delete)

### 3.3 User Management

**Features:**
- View user profiles
- View user's content
- View user's report history
- Suspend/Ban users
- View suspension/ban history
- Unban users

### 3.4 Analytics Dashboard

**Metrics to Track:**
- Total reports received (daily/weekly/monthly)
- Reports by type (product/service/message/user)
- Reports by reason (spam/inappropriate/fraud/etc.)
- Average time to review reports
- Content removal rate
- User suspension/ban rate
- Most reported users
- Most reported content types

---

## 4. Automated Processes

### 4.1 24-Hour Review Alert System

**Implementation:**
```python
# Pseudo-code for scheduled task
def check_pending_reports():
    # Find reports older than 24 hours that are still pending
    old_reports = Report.objects.filter(
        status='pending',
        created_at__lt=timezone.now() - timedelta(hours=24)
    )
    
    # Send alert to admin team
    for report in old_reports:
        send_admin_alert(f"Report {report.id} is pending for over 24 hours")
        # Optionally escalate to higher priority queue
```

**Options:**
- Use Celery/cron jobs to run every hour
- Send email/Slack notifications to admin team
- Create high-priority queue for old reports
- Auto-assign to available admins

### 4.2 Auto-Moderation (Optional Enhancement)

**Basic Auto-Moderation:**
```python
def auto_moderate_content(content_text):
    # Check against keyword blacklist
    prohibited_keywords = load_prohibited_keywords()
    
    for keyword in prohibited_keywords:
        if keyword.lower() in content_text.lower():
            return {
                'flagged': True,
                'reason': 'Contains prohibited keyword',
                'keyword': keyword
            }
    
    return {'flagged': False}
```

**Advanced Options:**
- Integrate with Google Cloud Vision API for image analysis
- Use AWS Rekognition for content moderation
- Implement machine learning models for spam detection
- Use sentiment analysis for harassment detection

---

## 5. Notification System

### 5.1 Notify Reporter

**When:**
- Report is submitted (confirmation)
- Report is reviewed (status update)
- Action is taken on reported content

**Channels:**
- In-app notification
- Email notification
- Push notification (if available)

### 5.2 Notify Content Owner

**When:**
- Their content is reported
- Their content is removed
- Their account is suspended/banned

**Message Template:**
```
Your [product/service/message] has been reported for [reason].
After review, we have [action taken].
If you believe this is an error, please contact support.
```

### 5.3 Notify Admins

**When:**
- New report is submitted
- Report is pending for > 24 hours
- High-priority reports (fraud, illegal activity)

---

## 6. API Rate Limiting

**Implement rate limiting to prevent abuse:**
- Max 10 reports per user per day
- Max 5 reports for the same content per day
- Cooldown period: 1 hour between reports for the same content

---

## 7. Security Considerations

1. **Authentication:**
   - All admin endpoints require admin role
   - Use JWT tokens with role-based access control
   - Implement IP whitelisting for admin endpoints (optional)

2. **Audit Logging:**
   - Log all admin actions (who, what, when)
   - Store all content deletions with snapshots
   - Track all user suspensions/bans

3. **Data Privacy:**
   - Anonymize reporter information when sharing with content owner
   - Comply with GDPR/data protection regulations
   - Allow users to request their report history

---

## 8. Testing Requirements

### 8.1 Unit Tests
- Report creation
- Report status updates
- Content removal
- User suspension/ban
- Duplicate report prevention

### 8.2 Integration Tests
- Full report workflow (submit → review → action)
- 24-hour alert system
- Notification delivery
- Rate limiting

### 8.3 Manual Testing Checklist
- [ ] Submit report via API
- [ ] View reports in admin dashboard
- [ ] Update report status
- [ ] Remove content
- [ ] Suspend user
- [ ] Ban user
- [ ] Verify notifications are sent
- [ ] Test rate limiting
- [ ] Test duplicate report prevention

---

## 9. Implementation Priority

### Phase 1 (Critical - Required for App Store)
1. ✅ Report submission endpoint (`POST /api/reports/`)
2. ✅ Basic report storage in database
3. ✅ Admin endpoint to view reports (`GET /api/reports/`)
4. ✅ Admin endpoint to update report status
5. ✅ Content removal endpoint
6. ✅ User suspension endpoint
7. ✅ 24-hour alert system

### Phase 2 (Important - Better UX)
1. Admin dashboard UI
2. Notification system
3. Analytics dashboard
4. Bulk actions

### Phase 3 (Enhancements)
1. Auto-moderation
2. Machine learning spam detection
3. Advanced analytics
4. Mobile admin app

---

## 10. Example Implementation (Django/Python)

### 10.1 Models

```python
# models.py
from django.db import models
from django.contrib.auth.models import User

class Report(models.Model):
    CONTENT_TYPES = [
        ('product', 'Product'),
        ('service', 'Service'),
        ('message', 'Message'),
        ('user', 'User'),
    ]
    
    REASONS = [
        ('spam', 'Spam'),
        ('inappropriate', 'Inappropriate Content'),
        ('fraud', 'Fraud or Scam'),
        ('harassment', 'Harassment'),
        ('illegal', 'Illegal Activity'),
        ('other', 'Other'),
    ]
    
    STATUS_CHOICES = [
        ('pending', 'Pending'),
        ('reviewed', 'Reviewed'),
        ('resolved', 'Resolved'),
        ('dismissed', 'Dismissed'),
    ]
    
    reporter = models.ForeignKey(User, on_delete=models.CASCADE, related_name='reports_made')
    content_type = models.CharField(max_length=20, choices=CONTENT_TYPES)
    content_id = models.IntegerField()
    reason = models.CharField(max_length=50, choices=REASONS)
    description = models.TextField(blank=True)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='pending')
    reviewed_by = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, blank=True, related_name='reports_reviewed')
    reviewed_at = models.DateTimeField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        unique_together = ['reporter', 'content_type', 'content_id']
        indexes = [
            models.Index(fields=['status', 'created_at']),
            models.Index(fields=['content_type', 'content_id']),
        ]
```

### 10.2 Views/Serializers

```python
# serializers.py
from rest_framework import serializers
from .models import Report

class ReportSerializer(serializers.ModelSerializer):
    class Meta:
        model = Report
        fields = ['id', 'content_type', 'content_id', 'reason', 'description', 'status', 'created_at']
        read_only_fields = ['id', 'status', 'created_at']
    
    def validate(self, data):
        # Validate content exists
        content_type = data['content_type']
        content_id = data['content_id']
        # Add validation logic here
        return data

# views.py
from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated, IsAdminUser
from .models import Report
from .serializers import ReportSerializer

class ReportViewSet(viewsets.ModelViewSet):
    queryset = Report.objects.all()
    serializer_class = ReportSerializer
    
    def get_permissions(self):
        if self.action == 'create':
            return [IsAuthenticated()]
        return [IsAdminUser()]
    
    def create(self, request):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        serializer.save(reporter=request.user)
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    
    @action(detail=True, methods=['patch'])
    def update_status(self, request, pk=None):
        report = self.get_object()
        new_status = request.data.get('status')
        # Add validation and update logic
        return Response({'status': 'updated'})
```

---

## 11. Documentation for Admin Team

Create documentation covering:
- How to access admin dashboard
- How to review reports
- When to remove content vs. suspend user
- Escalation procedures
- Response time expectations (24-hour SLA)
- Common scenarios and resolutions

---

## Summary

**Minimum Required for App Store Approval:**
1. ✅ Report submission API
2. ✅ Report storage and retrieval
3. ✅ Admin interface to review reports
4. ✅ Content removal capability
5. ✅ User suspension/ban capability
6. ✅ 24-hour review process (automated alerts)

**Recommended for Production:**
- Admin dashboard UI
- Notification system
- Analytics
- Auto-moderation
- Audit logging

This implementation ensures compliance with Apple App Store Guideline 1.2 while providing a scalable foundation for content moderation.

