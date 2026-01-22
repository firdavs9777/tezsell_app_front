# Reporting Endpoint Setup Guide

## Current Issue

The app is getting a **403 Forbidden** error when trying to submit reports. This means the backend endpoint `/api/reports/` is not yet implemented.

## Quick Fix Options

### Option 1: Implement the Backend Endpoint (Recommended)

The backend needs to implement `POST /api/reports/` endpoint. See `BACKEND_IMPLEMENTATION_GUIDE.md` for full details.

**Minimum Implementation:**
```python
# Django example
@api_view(['POST'])
@permission_classes([IsAuthenticated])
def create_report(request):
    serializer = ReportSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save(reporter=request.user)
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
```

### Option 2: Temporary Workaround - Disable Reporting UI

If you want to disable the reporting feature until the backend is ready:

1. Comment out the report menu items in:
   - `lib/pages/products/product_detail.dart`
   - `lib/pages/service/details/service_detail.dart`
   - `lib/pages/chat/widgets/message_options_sheet.dart`

2. Or add a feature flag to conditionally show/hide reporting.

### Option 3: Mock the Endpoint (For Testing)

For testing purposes, you can temporarily return a success response:

```python
# Temporary mock endpoint
@api_view(['POST'])
@permission_classes([IsAuthenticated])
def create_report(request):
    # Just return success for now
    return Response({
        'id': 1,
        'status': 'pending',
        'message': 'Report submitted successfully'
    }, status=status.HTTP_201_CREATED)
```

## Error Handling

The app now:
- ✅ Logs detailed error information (status code and response body)
- ✅ Shows user-friendly error messages
- ✅ Handles 403 errors specifically

## Next Steps

1. **Implement the backend endpoint** following `BACKEND_IMPLEMENTATION_GUIDE.md`
2. **Test the endpoint** with a tool like Postman or curl
3. **Verify authentication** - ensure the token is being sent correctly
4. **Check permissions** - ensure authenticated users can POST to `/api/reports/`

## Testing the Endpoint

Once implemented, test with:

```bash
curl -X POST https://api.webtezsell.com/api/reports/ \
  -H "Authorization: Token YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "content_type": "service",
    "content_id": 123,
    "reason": "spam",
    "description": "Test report"
  }'
```

Expected response:
```json
{
  "id": 1,
  "status": "pending",
  "created_at": "2024-01-15T10:30:00Z"
}
```

## Current Status

- ✅ Frontend implementation complete
- ❌ Backend endpoint not implemented (causing 403 error)
- ✅ Error handling improved
- ✅ User-friendly error messages added

Once the backend endpoint is implemented, the reporting feature will work end-to-end.

