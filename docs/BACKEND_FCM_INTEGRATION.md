# Backend FCM Push Notifications Integration Guide

## Overview

This document outlines the changes needed in the backend to send Firebase Cloud Messaging (FCM) push notifications to mobile devices. Currently, the backend only sends WebSocket notifications, which work when the app is open. FCM push notifications are needed for when the app is closed or in the background.

## ⚠️ IMPORTANT: Current Status

**The backend is currently NOT sending FCM push notifications for real events.** 

- ✅ WebSocket notifications work (when app is open)
- ❌ FCM push notifications are NOT being sent for real events (likes, comments, etc.)
- ✅ Firebase Console test notifications work (proves FCM is configured correctly)

**To fix this:** The backend must implement FCM push notifications for all notification types (service_like, product_like, service_comment, etc.) as documented in this guide.

---

## Prerequisites

1. **Firebase Admin SDK** installed in your Django backend
2. **Firebase Service Account Key** (JSON file) downloaded from Firebase Console
3. **DeviceToken model** already created (for storing FCM tokens)

---

## Step 1: Install Firebase Admin SDK

```bash
pip install firebase-admin
```

---

## Step 2: Initialize Firebase Admin SDK

Create or update `settings.py`:

```python
import firebase_admin
from firebase_admin import credentials
import os

# Initialize Firebase Admin SDK
FIREBASE_CREDENTIALS_PATH = os.path.join(BASE_DIR, 'path/to/serviceAccountKey.json')

if os.path.exists(FIREBASE_CREDENTIALS_PATH):
    cred = credentials.Certificate(FIREBASE_CREDENTIALS_PATH)
    firebase_admin.initialize_app(cred)
    print('✅ Firebase Admin SDK initialized')
else:
    print('⚠️ Firebase credentials not found. Push notifications will not work.')
```

**Note:** Download the service account key from:
- Firebase Console → Project Settings → Service Accounts → Generate New Private Key

---

## Step 3: Create FCM Notification Service

Create `notifications/fcm_service.py`:

```python
from firebase_admin import messaging
from django.conf import settings
from accounts.models import DeviceToken
import logging

logger = logging.getLogger(__name__)

class FCMNotificationService:
    """Service for sending FCM push notifications"""
    
    @staticmethod
    def send_notification_to_user(user, title, body, data=None):
        """
        Send FCM notification to all active devices of a user
        
        Args:
            user: User instance
            title: Notification title
            body: Notification body
            data: Optional dict with additional data (e.g., {'type': 'chat', 'object_id': '75'})
        
        Returns:
            dict with success count and failure count
        """
        try:
            # Get all active FCM tokens for the user
            device_tokens = DeviceToken.objects.filter(
                user=user,
                is_active=True
            ).values_list('token', flat=True)
            
            if not device_tokens:
                logger.warning(f'No FCM tokens found for user {user.id}')
                return {'success': 0, 'failure': 0}
            
            tokens_list = list(device_tokens)
            
            # Prepare notification payload
            notification = messaging.Notification(
                title=title,
                body=body,
            )
            
            # Prepare data payload (optional)
            data_payload = data or {}
            # Convert all values to strings (FCM requirement)
            data_payload = {k: str(v) for k, v in data_payload.items()}
            
            # Create message
            message = messaging.MulticastMessage(
                notification=notification,
                data=data_payload,
                tokens=tokens_list,
                apns=messaging.APNSConfig(
                    payload=messaging.APNSPayload(
                        aps=messaging.Aps(
                            sound='default',
                            badge=1,
                        )
                    )
                ),
                android=messaging.AndroidConfig(
                    priority='high',
                    notification=messaging.AndroidNotification(
                        sound='default',
                        channel_id='general_notifications',
                    )
                ),
            )
            
            # Send notification
            response = messaging.send_multicast(message)
            
            logger.info(
                f'FCM notification sent to user {user.id}: '
                f'{response.success_count} successful, {response.failure_count} failed'
            )
            
            # Handle failed tokens (remove invalid tokens)
            if response.failure_count > 0:
                failed_tokens = []
                for idx, result in enumerate(response.responses):
                    if not result.success:
                        failed_tokens.append(tokens_list[idx])
                        logger.error(f'Failed to send to token: {result.exception}')
                
                # Deactivate invalid tokens
                if failed_tokens:
                    DeviceToken.objects.filter(
                        token__in=failed_tokens
                    ).update(is_active=False)
            
            return {
                'success': response.success_count,
                'failure': response.failure_count,
            }
            
        except Exception as e:
            logger.error(f'Error sending FCM notification: {e}')
            return {'success': 0, 'failure': 1}
    
    @staticmethod
    def send_notification_to_multiple_users(users, title, body, data=None):
        """
        Send FCM notification to multiple users
        
        Args:
            users: QuerySet or list of User instances
            title: Notification title
            body: Notification body
            data: Optional dict with additional data
        
        Returns:
            dict with total success and failure counts
        """
        total_success = 0
        total_failure = 0
        
        for user in users:
            result = FCMNotificationService.send_notification_to_user(
                user, title, body, data
            )
            total_success += result['success']
            total_failure += result['failure']
        
        return {
            'success': total_success,
            'failure': total_failure,
        }
```

---

## Step 4: Integrate FCM Notifications into Existing Event Handlers

### 4.1 Chat Messages

Update your chat message handler (e.g., in `chat/views.py` or `chat/signals.py`):

```python
from notifications.fcm_service import FCMNotificationService

def send_chat_message(sender, recipient, message_text, chat_room_id):
    # ... existing code to save message and send WebSocket notification ...
    
    # Send FCM push notification
    FCMNotificationService.send_notification_to_user(
        user=recipient,
        title='New message',
        body=f'{sender.username}: {message_text}',
        data={
            'type': 'chat',
            'object_id': str(chat_room_id),
        }
    )
```

### 4.2 Product Likes

Update your product like handler:

```python
from notifications.fcm_service import FCMNotificationService

def like_product(user, product):
    # ... existing code to save like and send WebSocket notification ...
    
    # Send FCM push notification to product owner
    if product.user != user:  # Don't notify if user liked their own product
        FCMNotificationService.send_notification_to_user(
            user=product.user,
            title='Your product was liked',
            body=f'{user.username} liked your product "{product.title}"',
            data={
                'type': 'product_like',
                'object_id': str(product.id),
            }
        )
```

### 4.3 Service Likes

Update your service like handler:

```python
from notifications.fcm_service import FCMNotificationService

def like_service(user, service):
    # ... existing code to save like and send WebSocket notification ...
    
    # Send FCM push notification to service owner
    if service.user != user:
        FCMNotificationService.send_notification_to_user(
            user=service.user,
            title='Your service was liked',
            body=f'{user.username} liked your service "{service.title}"',
            data={
                'type': 'service_like',
                'object_id': str(service.id),
            }
        )
```

### 4.4 Service Comments

Update your comment handler:

```python
from notifications.fcm_service import FCMNotificationService

def create_comment(user, service, comment_text):
    # ... existing code to save comment and send WebSocket notification ...
    
    # Send FCM push notification to service owner
    if service.user != user:
        FCMNotificationService.send_notification_to_user(
            user=service.user,
            title='New comment on your service',
            body=f'{user.username} commented on your service "{service.title}"',
            data={
                'type': 'service_comment',
                'object_id': str(service.id),
            }
        )
```

### 4.5 Recommended Products/Services

Update your recommendation handler:

```python
from notifications.fcm_service import FCMNotificationService

def recommend_product_to_user(user, product):
    # ... existing code ...
    
    FCMNotificationService.send_notification_to_user(
        user=user,
        title='Recommended for you',
        body=f'Check out this product: {product.title}',
        data={
            'type': 'recommended_product',
            'object_id': str(product.id),
        }
    )
```

---

## Step 5: Update Notification Model (Optional)

If you want to track FCM notification sends, update your `Notification` model:

```python
class Notification(models.Model):
    # ... existing fields ...
    
    fcm_sent = models.BooleanField(default=False)
    fcm_sent_at = models.DateTimeField(null=True, blank=True)
    
    def send_fcm_notification(self):
        """Send FCM notification for this notification instance"""
        from notifications.fcm_service import FCMNotificationService
        
        result = FCMNotificationService.send_notification_to_user(
            user=self.recipient,
            title=self.title,
            body=self.body,
            data={
                'type': self.type,
                'object_id': str(self.object_id) if self.object_id else '',
            }
        )
        
        if result['success'] > 0:
            self.fcm_sent = True
            self.fcm_sent_at = timezone.now()
            self.save(update_fields=['fcm_sent', 'fcm_sent_at'])
        
        return result
```

---

## Step 6: Using Django Signals (Recommended)

Create `notifications/signals.py`:

```python
from django.db.models.signals import post_save
from django.dispatch import receiver
from notifications.models import Notification
from notifications.fcm_service import FCMNotificationService

@receiver(post_save, sender=Notification)
def send_fcm_on_notification_create(sender, instance, created, **kwargs):
    """Automatically send FCM notification when a Notification is created"""
    if created and not instance.is_read:
        FCMNotificationService.send_notification_to_user(
            user=instance.recipient,
            title=instance.title,
            body=instance.body,
            data={
                'type': instance.type,
                'object_id': str(instance.object_id) if instance.object_id else '',
            }
        )
```

Don't forget to connect the signal in `notifications/apps.py`:

```python
from django.apps import AppConfig

class NotificationsConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'notifications'
    
    def ready(self):
        import notifications.signals  # noqa
```

---

## Step 7: Error Handling and Logging

Add proper error handling:

```python
import logging
from firebase_admin.exceptions import FirebaseError

logger = logging.getLogger(__name__)

try:
    result = FCMNotificationService.send_notification_to_user(...)
except FirebaseError as e:
    logger.error(f'Firebase error: {e}')
except Exception as e:
    logger.error(f'Unexpected error sending FCM: {e}')
```

---

## Step 8: Testing

### Test FCM Notification Sending

Create a management command `notifications/management/commands/test_fcm.py`:

```python
from django.core.management.base import BaseCommand
from django.contrib.auth import get_user_model
from notifications.fcm_service import FCMNotificationService

User = get_user_model()

class Command(BaseCommand):
    help = 'Test FCM notification sending'
    
    def add_arguments(self, parser):
        parser.add_argument('user_id', type=int, help='User ID to send test notification to')
    
    def handle(self, *args, **options):
        user_id = options['user_id']
        user = User.objects.get(id=user_id)
        
        result = FCMNotificationService.send_notification_to_user(
            user=user,
            title='Test Notification',
            body='This is a test notification from the backend',
            data={'type': 'test', 'object_id': '0'}
        )
        
        self.stdout.write(
            self.style.SUCCESS(
                f'Notification sent: {result["success"]} successful, {result["failure"]} failed'
            )
        )
```

Run test:
```bash
python manage.py test_fcm <user_id>
```

---

## Important Notes

### 1. Notification Payload Format

FCM requires:
- **Notification payload**: For system tray display (title, body)
- **Data payload**: For app processing (type, object_id, etc.)
- **Data values must be strings**: Convert all data values to strings

### 2. Token Management

- **Invalid tokens**: Automatically deactivated when FCM returns errors
- **Token refresh**: Handled by Flutter app, backend receives updated tokens
- **Multiple devices**: One user can have multiple active tokens

### 3. Notification Types

Match the types used in Flutter app:
- `chat`
- `product_like`
- `service_like`
- `service_comment`
- `recommended_product`
- `recommended_service`
- `real_estate`

### 4. Performance Considerations

- **Batch sending**: Use `send_multicast` for multiple tokens
- **Async tasks**: Consider using Celery for async notification sending
- **Rate limiting**: Be mindful of FCM rate limits

### 5. iOS vs Android

- **iOS**: Requires APNs authentication key (already configured in Firebase)
- **Android**: Uses FCM directly
- **Both**: Handled automatically by Firebase Admin SDK

---

## Example: Complete Integration

Here's a complete example for a chat message:

```python
# In your chat view or signal handler

from notifications.fcm_service import FCMNotificationService
from notifications.models import Notification

def handle_new_chat_message(sender, recipient, message_text, chat_room_id):
    # 1. Save message (existing code)
    message = ChatMessage.objects.create(...)
    
    # 2. Create notification record (existing code)
    notification = Notification.objects.create(
        recipient=recipient,
        sender=sender,
        type='chat',
        title='New message',
        body=f'{sender.username}: {message_text}',
        object_id=str(chat_room_id),
    )
    
    # 3. Send WebSocket notification (existing code)
    # ... your WebSocket code ...
    
    # 4. Send FCM push notification (NEW)
    FCMNotificationService.send_notification_to_user(
        user=recipient,
        title='New message',
        body=f'{sender.username}: {message_text}',
        data={
            'type': 'chat',
            'object_id': str(chat_room_id),
        }
    )
```

---

## Troubleshooting

### Issue: Notifications not received

1. **Check FCM tokens**: Verify tokens are stored in `DeviceToken` model
2. **Check Firebase logs**: Firebase Console → Cloud Messaging → Reports
3. **Check backend logs**: Look for FCM send errors
4. **Test with Firebase Console**: Verify tokens work with test messages

### Issue: Invalid token errors

- Tokens are automatically deactivated when invalid
- Users need to re-register tokens (handled by Flutter app)

### Issue: Notifications received but not displayed

- Check notification payload format
- Verify `notification` and `data` fields are both present
- Check Flutter app logs for parsing errors

---

## Summary

**What needs to be done:**

1. ✅ Install `firebase-admin` package
2. ✅ Initialize Firebase Admin SDK in `settings.py`
3. ✅ Create `FCMNotificationService` class
4. ✅ Integrate FCM sending into existing event handlers:
   - Chat messages
   - Product likes
   - Service likes
   - Service comments
   - Recommended items
5. ✅ Test with management command
6. ✅ Monitor logs and errors

**Current Status:**
- ✅ WebSocket notifications: Working
- ❌ FCM push notifications: Not implemented (needs backend changes)

**After Implementation:**
- ✅ WebSocket notifications: Working (in-app)
- ✅ FCM push notifications: Working (background/closed app)

---

## Questions?

If you need help with:
- Firebase Admin SDK setup
- Integration into specific views/signals
- Error handling
- Performance optimization

Refer to this guide or check Firebase Admin SDK documentation.

