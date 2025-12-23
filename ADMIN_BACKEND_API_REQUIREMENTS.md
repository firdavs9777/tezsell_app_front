# Admin Backend API Requirements

This document outlines all the backend API endpoints required for the Admin Panel functionality in the Flutter app.

## Authentication

All admin endpoints require authentication via Token-based authentication:
- **Header**: `Authorization: Token <access_token>`
- **Content-Type**: `application/json`
- **Accept**: `application/json`

All endpoints should return `403 Forbidden` if the user doesn't have admin privileges.

---

## 1. Admin Dashboard

### 1.1 Get Dashboard Statistics
**Endpoint**: `GET /real_estate/admin/dashboard/`

**Response Format**:
```json
{
  "success": true,
  "data": {
    "overview": {
      "total_properties": 1250,
      "total_agents": 45,
      "total_users": 5430,
      "featured_properties": 125
    },
    "property_stats": {
      "avg_sale_price": 85000,
      "total_property_value": 106250000,
      "avg_price_per_sqm": 850,
      "property_types": [
        {
          "property_type": "apartment",
          "count": 565
        },
        {
          "property_type": "house",
          "count": 356
        }
      ],
      "by_city": [
        {
          "city": "Tashkent",
          "count": 450
        },
        {
          "city": "Samarkand",
          "count": 320
        }
      ]
    },
    "user_activity": {
      "total_views": 125000
    },
    "engagement": {
      "avg_views_per_property": 100
    },
    "agent_stats": {
      "verification_rate": 85.5
    },
    "inquiries": {
      "response_rate": 92.3,
      "by_type": [
        {
          "inquiry_type": "viewing",
          "count": 45
        },
        {
          "inquiry_type": "info",
          "count": 30
        }
      ]
    },
    "system_health": {
      "properties_without_images": 12,
      "properties_missing_location": 8,
      "agents_pending_verification": 5
    }
  },
  "generated_at": "2024-01-15T10:30:00Z"
}
```

**Status Codes**:
- `200 OK`: Success
- `403 Forbidden`: User doesn't have admin privileges

---

## 2. Admin Reports

### 2.1 Get Reports List
**Endpoint**: `GET /api/admin/reports/`

**Query Parameters**:
- `page` (int, optional): Page number (default: 1)
- `page_size` (int, optional): Items per page (default: 20)
- `status` (string, optional): Filter by status (`pending`, `reviewed`, `resolved`, `dismissed`)
- `content_type` (string, optional): Filter by content type (`product`, `service`, `property`, `message`, `user`)

**Response Format**:
```json
{
  "count": 150,
  "next": "http://api.example.com/api/admin/reports/?page=2",
  "previous": null,
  "results": [
    {
      "id": 1,
      "reporter": {
        "id": 10,
        "username": "user123",
        "email": "user@example.com"
      },
      "reported_content": {
        "id": 5,
        "type": "property",
        "title": "Property Title"
      },
      "reported_user": {
        "id": 7,
        "username": "reported_user",
        "email": "reported@example.com"
      },
      "reason": "Inappropriate content",
      "description": "Detailed description of the issue",
      "status": "pending",
      "created_at": "2024-01-15T10:30:00Z",
      "updated_at": "2024-01-15T10:30:00Z",
      "resolved_by": null,
      "resolution_notes": null
    }
  ]
}
```

**Status Codes**:
- `200 OK`: Success
- `403 Forbidden`: User doesn't have admin privileges

### 2.2 Update Report Status
**Endpoint**: `PATCH /api/admin/reports/{id}/update/`

**Path Parameters**:
- `id` (int): Report ID

**Request Body**:
```json
{
  "status": "resolved",
  "action": "removed_content",
  "reason": "Content violated community guidelines"
}
```

**Request Fields**:
- `status` (string, required): New status (`pending`, `reviewed`, `resolved`, `dismissed`)
- `action` (string, optional): Action taken (`removed_content`, `warned_user`, `banned_user`, `no_action`)
- `reason` (string, optional): Reason for the action

**Response Format**:
```json
{
  "id": 1,
  "status": "resolved",
  "action": "removed_content",
  "reason": "Content violated community guidelines",
  "updated_at": "2024-01-15T11:00:00Z",
  "resolved_by": {
    "id": 1,
    "username": "admin"
  }
}
```

**Status Codes**:
- `200 OK`: Success
- `400 Bad Request`: Invalid status or missing required fields
- `403 Forbidden`: User doesn't have admin privileges
- `404 Not Found`: Report not found

---

## 3. Admin Users

### 3.1 Get Users List
**Endpoint**: `GET /api/admin/users/`

**Query Parameters**:
- `page` (int, optional): Page number (default: 1)
- `page_size` (int, optional): Items per page (default: 20)
- `search` (string, optional): Search by username, email, or name
- `is_active` (boolean, optional): Filter by active status

**Response Format**:
```json
{
  "count": 5430,
  "next": "http://api.example.com/api/admin/users/?page=2",
  "previous": null,
  "results": [
    {
      "id": 1,
      "username": "user123",
      "email": "user@example.com",
      "first_name": "John",
      "last_name": "Doe",
      "phone_number": "+998901234567",
      "is_active": true,
      "is_staff": false,
      "is_superuser": false,
      "date_joined": "2024-01-01T10:00:00Z",
      "last_login": "2024-01-15T09:30:00Z",
      "profile": {
        "avatar": "http://example.com/avatar.jpg",
        "bio": "User bio"
      },
      "stats": {
        "total_listings": 15,
        "total_views": 1250,
        "reports_received": 0,
        "reports_made": 2
      }
    }
  ]
}
```

**Status Codes**:
- `200 OK`: Success
- `403 Forbidden`: User doesn't have admin privileges

### 3.2 Suspend User
**Endpoint**: `POST /api/admin/users/{id}/suspend/`

**Path Parameters**:
- `id` (int): User ID

**Request Body**:
```json
{
  "reason": "Violation of terms of service",
  "duration_days": 7
}
```

**Request Fields**:
- `reason` (string, required): Reason for suspension
- `duration_days` (int, optional): Suspension duration in days. If not provided, suspension is permanent

**Response Format**:
```json
{
  "id": 1,
  "username": "user123",
  "is_active": false,
  "suspended": true,
  "suspension_reason": "Violation of terms of service",
  "suspension_until": "2024-01-22T10:00:00Z",
  "suspended_by": {
    "id": 1,
    "username": "admin"
  },
  "suspended_at": "2024-01-15T10:00:00Z"
}
```

**Status Codes**:
- `200 OK` or `201 Created`: Success
- `400 Bad Request`: Missing required fields
- `403 Forbidden`: User doesn't have admin privileges
- `404 Not Found`: User not found

### 3.3 Ban User
**Endpoint**: `POST /api/admin/users/{id}/ban/`

**Path Parameters**:
- `id` (int): User ID

**Request Body**:
```json
{
  "reason": "Repeated violations of community guidelines"
}
```

**Request Fields**:
- `reason` (string, required): Reason for ban

**Response Format**:
```json
{
  "id": 1,
  "username": "user123",
  "is_active": false,
  "banned": true,
  "ban_reason": "Repeated violations of community guidelines",
  "banned_by": {
    "id": 1,
    "username": "admin"
  },
  "banned_at": "2024-01-15T10:00:00Z"
}
```

**Status Codes**:
- `200 OK` or `201 Created`: Success
- `400 Bad Request`: Missing required fields
- `403 Forbidden`: User doesn't have admin privileges
- `404 Not Found`: User not found

---

## 4. Admin Content Management

### 4.1 Get Content List
**Endpoint**: `GET /api/admin/content/`

**Query Parameters**:
- `page` (int, optional): Page number (default: 1)
- `page_size` (int, optional): Items per page (default: 20)
- `content_type` (string, optional): Filter by type (`product`, `service`, `property`)
- `search` (string, optional): Search in title or description
- `is_active` (boolean, optional): Filter by active status

**Response Format**:
```json
{
  "count": 2500,
  "next": "http://api.example.com/api/admin/content/?page=2",
  "previous": null,
  "results": [
    {
      "id": 1,
      "title": "Fresh Organic Tomatoes",
      "content_type": "product",
      "is_active": true,
      "owner": {
        "id": 10,
        "username": "farmer_john",
        "email": "farmer@example.com"
      },
      "created_at": "2024-01-10T10:00:00Z",
      "updated_at": "2024-01-12T15:30:00Z",
      "views": 245,
      "price": "15000",
      "description": "Fresh organic tomatoes from local farm",
      "images": [
        "http://example.com/image1.jpg"
      ],
      "location": {
        "city": "Tashkent",
        "district": "Yunusabad"
      }
    }
  ]
}
```

**Status Codes**:
- `200 OK`: Success
- `403 Forbidden`: User doesn't have admin privileges

### 4.2 Remove Content
**Endpoint**: `POST /api/admin/content/{id}/remove/`

**Path Parameters**:
- `id` (int): Content ID

**Request Body**:
```json
{
  "content_type": "product",
  "reason": "Violates community guidelines"
}
```

**Request Fields**:
- `content_type` (string, required): Type of content (`product`, `service`, `property`)
- `reason` (string, required): Reason for removal

**Response Format**:
```json
{
  "id": 1,
  "title": "Fresh Organic Tomatoes",
  "content_type": "product",
  "removed": true,
  "removal_reason": "Violates community guidelines",
  "removed_by": {
    "id": 1,
    "username": "admin"
  },
  "removed_at": "2024-01-15T10:00:00Z"
}
```

**Status Codes**:
- `200 OK` or `201 Created`: Success
- `400 Bad Request`: Missing required fields or invalid content type
- `403 Forbidden`: User doesn't have admin privileges
- `404 Not Found`: Content not found

---

## 5. Admin Agent Management

### 5.1 Get Pending Agent Applications
**Endpoint**: `GET /real_estate/api/admin/agents/pending/`

**Query Parameters**:
- `page` (int, optional): Page number (default: 1)
- `page_size` (int, optional): Items per page (default: 20)
- `status` (string, optional): Filter by status
- `search` (string, optional): Search by username or email

**Response Format**:
```json
{
  "count": 15,
  "next": null,
  "previous": null,
  "results": [
    {
      "id": 1,
      "user": {
        "id": 10,
        "username": "agent_applicant",
        "email": "agent@example.com",
        "first_name": "John",
        "last_name": "Doe"
      },
      "status": "pending",
      "application_date": "2024-01-10T10:00:00Z",
      "documents": [
        {
          "type": "license",
          "url": "http://example.com/license.pdf"
        }
      ],
      "notes": "Experienced real estate agent"
    }
  ]
}
```

**Status Codes**:
- `200 OK`: Success
- `403 Forbidden`: User doesn't have admin privileges

### 5.2 Verify/Reject Agent
**Endpoint**: `POST /real_estate/api/admin/agents/{id}/verify/`

**Path Parameters**:
- `id` (int): Agent application ID

**Request Body**:
```json
{
  "action": "approve",
  "reason": "All documents verified and approved"
}
```

**Request Fields**:
- `action` (string, required): Action to take (`approve` or `reject`)
- `reason` (string, optional): Reason for the action

**Response Format**:
```json
{
  "id": 1,
  "user": {
    "id": 10,
    "username": "agent_applicant"
  },
  "status": "approved",
  "verified_by": {
    "id": 1,
    "username": "admin"
  },
  "verified_at": "2024-01-15T10:00:00Z",
  "reason": "All documents verified and approved"
}
```

**Status Codes**:
- `200 OK` or `201 Created`: Success
- `400 Bad Request`: Invalid action or missing required fields
- `403 Forbidden`: User doesn't have admin privileges
- `404 Not Found`: Agent application not found

---

## 6. Admin Dashboard Charts (Optional)

### 6.1 Get Dashboard Charts Data
**Endpoint**: `GET /real_estate/admin/dashboard/charts/`

**Response Format**:
```json
{
  "success": true,
  "data": {
    "property_listings_over_time": [
      {
        "date": "2024-01-01",
        "count": 10
      },
      {
        "date": "2024-01-02",
        "count": 15
      }
    ],
    "user_registrations_over_time": [
      {
        "date": "2024-01-01",
        "count": 5
      }
    ],
    "revenue_over_time": [
      {
        "date": "2024-01-01",
        "amount": 100000
      }
    ]
  }
}
```

**Status Codes**:
- `200 OK`: Success
- `403 Forbidden`: User doesn't have admin privileges

---

## Error Response Format

All endpoints should return errors in the following format:

```json
{
  "success": false,
  "error": "Error message here",
  "details": {
    "field_name": ["Error message for this field"]
  }
}
```

**Common Status Codes**:
- `400 Bad Request`: Invalid request data
- `401 Unauthorized`: Authentication required
- `403 Forbidden`: Insufficient permissions
- `404 Not Found`: Resource not found
- `500 Internal Server Error`: Server error

---

## Pagination

All list endpoints should support pagination using the following query parameters:
- `page`: Page number (1-indexed)
- `page_size`: Number of items per page

Response should include:
- `count`: Total number of items
- `next`: URL to next page (null if last page)
- `previous`: URL to previous page (null if first page)
- `results`: Array of items for current page

---

## Notes

1. All timestamps should be in ISO 8601 format (e.g., `2024-01-15T10:30:00Z`)
2. All monetary values should be strings to avoid precision issues
3. Image URLs should be absolute URLs
4. Admin endpoints should check user permissions before processing requests
5. All admin actions should be logged for audit purposes
6. Consider implementing rate limiting for admin endpoints

