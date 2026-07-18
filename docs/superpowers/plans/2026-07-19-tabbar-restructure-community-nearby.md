# Tab-bar Restructure — Community + Nearby Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Restructure the main tab bar to `Home · Community · Nearby · Chat · My`, adding a lightweight neighborhood Community feed (new Django app + Flutter screens) and merging Services + Real Estate into a Nearby category hub.

**Architecture:** Backend gets a new `community` Django app that mirrors the existing `services` app (models, serializers, DRF views, token auth, `notifications.services.create_notification`). Flutter gets a `community` feature (models → provider → screens) mirroring the `service`/`product` feature shape, a re-parented **Nearby** hub screen, and a remapped `tab_bar.dart`. The two repos are independent git repos; commit in each separately.

**Tech Stack:** Django + DRF (Token auth, PageNumberPagination), pytest; Flutter + Riverpod + go_router + Dio/http, `flutter_localizations`/`.arb`.

## Global Constraints

- **Two repos:** Backend = `/Users/firdavsmutalipov/Desktop/tezsell-app` (Django). Flutter = `/Users/firdavsmutalipov/Desktop/Sabzi_Market/app` (package `app`). Never mix commits across repos.
- **Backend base URL / route prefix:** app mounted at `path('community/', include('community.urls'))`; endpoints live under `community/api/...`. Full URL base is `https://api.webtezsell.com`.
- **DRF defaults (already global):** `TokenAuthentication`, `IsAuthenticated`, `PageNumberPagination` `PAGE_SIZE=10`. Responses in existing views use `APIResponse.success(data=...)` / `APIResponse.not_found(...)` helpers and `handle_exception`.
- **Community v1 categories (exactly six):** `question`, `recommend`, `free`, `lostfound`, `alert`, `general`. No others.
- **v1 comments are flat** (no nested replies). Nested replies are out of scope.
- **Gating:** `NeighborhoodGate` wraps Home, Community, and the Services sub-view of Nearby only. Real Estate stays un-gated.
- **New tab index map:** `0 Home · 1 Community · 2 Nearby · 3 Chat · 4 My`.
- **i18n:** every new user-facing string added to `lib/l10n/app_en.arb`, `app_ru.arb`, `app_uz.arb` (the three actively-maintained locales) and accessed via `AppLocalizations`. Never hardcode display strings.
- **Flutter provider style:** plain class wrapping `http`/`Dio` with `baseUrl` from `lib/constants/constants.dart`, exposed through a Riverpod `Provider`, mirroring `lib/providers/provider_root/service_provider.dart`.
- Commit after every task. Backend commits end with the repo's convention; Flutter commits with Conventional Commits.

---

## File Structure

**Backend (`/Users/firdavsmutalipov/Desktop/tezsell-app`)**
- `community/` — new app: `models.py`, `serializers.py`, `views.py`, `urls.py`, `admin.py`, `apps.py`, `tests/`.
- `myproject/settings/base.py` — add app to `INSTALLED_APPS`.
- `myproject/urls.py` — add `community/` include.

**Flutter (`/Users/firdavsmutalipov/Desktop/Sabzi_Market/app`)**
- `lib/providers/provider_models/community_post_model.dart`, `community_comment_model.dart` — data models.
- `lib/providers/provider_root/community_provider.dart` — API client + Riverpod providers.
- `lib/service/community_api_service.dart` — thin REST wrapper (create/like/comment).
- `lib/pages/community/community_main.dart`, `community_detail.dart`, `community_composer.dart` — screens.
- `lib/pages/nearby/nearby_hub.dart` — Nearby landing (category cards).
- `lib/pages/tab_bar/tab_bar.dart` — remap indices/labels/providers/gating.
- `lib/config/app_router.dart` — add `/community*` and `/nearby` routes.
- `lib/l10n/app_en.arb`, `app_ru.arb`, `app_uz.arb` — new strings.

---

## PHASE A — Backend: `community` app

### Task 1: Scaffold `community` app with all models

**Files:**
- Create: `community/__init__.py`, `community/apps.py`, `community/models.py`, `community/admin.py`, `community/tests/__init__.py`, `community/tests/test_models.py`
- Modify: `myproject/settings/base.py` (INSTALLED_APPS)

**Interfaces:**
- Produces: `CommunityPost(author, neighborhood_district, category, body, latitude, longitude, country_code, region_name, like_count, comment_count, created_at, updated_at)`; `CommunityPostImage(post, image, alt_text)`; `CommunityPostLike(post, user)`; `CommunityComment(post, user, text, created_at)`. Category choices constant `CommunityPost.CATEGORY_CHOICES`.

- [ ] **Step 1: Create the app package and config**

Create `community/__init__.py` (empty) and `community/apps.py`:

```python
from django.apps import AppConfig


class CommunityConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'community'
```

- [ ] **Step 2: Register the app**

In `myproject/settings/base.py`, add to `INSTALLED_APPS` right after the `services` line:

```python
    'services.apps.ServicesConfig',
    'community.apps.CommunityConfig',
```

- [ ] **Step 3: Write the models**

Create `community/models.py`:

```python
from django.db import models
from django.core.validators import MinLengthValidator, MinValueValidator
from accounts.models import User
from locations.models import District
from myproject.settings.storage_backends import TezSellServiceImageStorage


class CommunityPost(models.Model):
    """A neighborhood community post (Karrot 동네생활 style)."""

    CATEGORY_CHOICES = [
        ('question', 'Question'),
        ('recommend', 'Recommendation'),
        ('free', 'Free / Giveaway'),
        ('lostfound', 'Lost & Found'),
        ('alert', 'Alert / Notice'),
        ('general', 'General / Daily'),
    ]

    author = models.ForeignKey(
        User, related_name='community_posts',
        on_delete=models.CASCADE, db_index=True,
    )
    neighborhood_district = models.ForeignKey(
        District, related_name='community_posts',
        on_delete=models.SET_NULL, null=True, blank=True, db_index=True,
    )
    category = models.CharField(
        max_length=20, choices=CATEGORY_CHOICES, default='general', db_index=True,
    )
    body = models.TextField(validators=[MinLengthValidator(1)])
    latitude = models.DecimalField(max_digits=15, decimal_places=6, null=True, blank=True)
    longitude = models.DecimalField(max_digits=15, decimal_places=6, null=True, blank=True)
    country_code = models.CharField(max_length=2, null=True, blank=True, db_index=True)
    region_name = models.CharField(max_length=128, null=True, blank=True, db_index=True)
    like_count = models.IntegerField(default=0, validators=[MinValueValidator(0)])
    comment_count = models.IntegerField(default=0, validators=[MinValueValidator(0)])
    created_at = models.DateTimeField(auto_now_add=True, db_index=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['-created_at']
        indexes = [
            models.Index(fields=['neighborhood_district', '-created_at']),
            models.Index(fields=['category', '-created_at']),
        ]

    def __str__(self):
        return f'{self.get_category_display()} by {self.author.username}'


class CommunityPostImage(models.Model):
    post = models.ForeignKey(CommunityPost, related_name='images', on_delete=models.CASCADE)
    image = models.ImageField(upload_to='community/images/', storage=TezSellServiceImageStorage)
    alt_text = models.CharField(max_length=255, blank=True, null=True)

    def __str__(self):
        return f'Image for post {self.post_id}'


class CommunityPostLike(models.Model):
    post = models.ForeignKey(CommunityPost, related_name='likes', on_delete=models.CASCADE)
    user = models.ForeignKey(User, related_name='community_post_likes', on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = [['post', 'user']]


class CommunityComment(models.Model):
    post = models.ForeignKey(CommunityPost, related_name='comments', on_delete=models.CASCADE, db_index=True)
    user = models.ForeignKey(User, related_name='community_comments', on_delete=models.CASCADE, db_index=True)
    text = models.TextField(validators=[MinLengthValidator(1)])
    created_at = models.DateTimeField(auto_now_add=True, db_index=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['created_at']
        indexes = [models.Index(fields=['post', 'created_at'])]

    def __str__(self):
        return f'Comment by {self.user.username} on post {self.post_id}'
```

- [ ] **Step 4: Register admin**

Create `community/admin.py`:

```python
from django.contrib import admin
from .models import CommunityPost, CommunityPostImage, CommunityPostLike, CommunityComment


@admin.register(CommunityPost)
class CommunityPostAdmin(admin.ModelAdmin):
    list_display = ('id', 'category', 'author', 'neighborhood_district', 'like_count', 'comment_count', 'created_at')
    list_filter = ('category', 'created_at')
    search_fields = ('body',)


admin.site.register(CommunityPostImage)
admin.site.register(CommunityPostLike)
admin.site.register(CommunityComment)
```

- [ ] **Step 5: Write the failing model test**

Create `community/tests/__init__.py` (empty) and `community/tests/test_models.py`:

```python
import pytest
from django.contrib.auth import get_user_model
from community.models import CommunityPost, CommunityComment, CommunityPostLike

User = get_user_model()


@pytest.mark.django_db
def test_create_post_defaults_to_general():
    user = User.objects.create(username='amir', email='amir@test.com')
    post = CommunityPost.objects.create(author=user, body='Hello neighbors')
    assert post.category == 'general'
    assert post.like_count == 0
    assert post.comment_count == 0
    assert str(post).startswith('General')


@pytest.mark.django_db
def test_like_is_unique_per_user():
    user = User.objects.create(username='b', email='b@test.com')
    post = CommunityPost.objects.create(author=user, body='x', category='question')
    CommunityPostLike.objects.create(post=post, user=user)
    with pytest.raises(Exception):
        CommunityPostLike.objects.create(post=post, user=user)


@pytest.mark.django_db
def test_comment_orders_oldest_first():
    user = User.objects.create(username='c', email='c@test.com')
    post = CommunityPost.objects.create(author=user, body='x')
    c1 = CommunityComment.objects.create(post=post, user=user, text='first')
    c2 = CommunityComment.objects.create(post=post, user=user, text='second')
    assert list(post.comments.all()) == [c1, c2]
```

- [ ] **Step 6: Make migrations and run tests to verify they fail then pass**

Run: `cd /Users/firdavsmutalipov/Desktop/tezsell-app && python manage.py makemigrations community`
Expected: creates `community/migrations/0001_initial.py`.

Run: `python -m pytest community/tests/test_models.py -v`
Expected: PASS (3 tests). If `User.objects.create` requires more fields, check `accounts/models.py` `UserManager` and adjust the test's user creation to match existing test fixtures in `conftest.py`.

- [ ] **Step 7: Commit**

```bash
git add community myproject/settings/base.py
git commit -m "feat(community): add community app models and migration"
```

---

### Task 2: Serializers

**Files:**
- Create: `community/serializers.py`
- Test: `community/tests/test_serializers.py`

**Interfaces:**
- Produces: `CommunityPostSerializer` (read fields: `id, category, body, author, neighborhood_district, region_name, images, like_count, comment_count, is_liked, created_at`; write fields: `category, body`). `CommunityCommentSerializer` (`id, text, user, created_at`). `is_liked` computed from `self.context['request'].user`.

- [ ] **Step 1: Write the failing serializer test**

Create `community/tests/test_serializers.py`:

```python
import pytest
from django.contrib.auth import get_user_model
from rest_framework.test import APIRequestFactory
from community.models import CommunityPost, CommunityPostLike
from community.serializers import CommunityPostSerializer

User = get_user_model()


@pytest.mark.django_db
def test_post_serializer_reports_is_liked():
    author = User.objects.create(username='a', email='a@test.com')
    viewer = User.objects.create(username='v', email='v@test.com')
    post = CommunityPost.objects.create(author=author, body='hi', category='free')
    CommunityPostLike.objects.create(post=post, user=viewer)

    request = APIRequestFactory().get('/')
    request.user = viewer
    data = CommunityPostSerializer(post, context={'request': request}).data
    assert data['is_liked'] is True
    assert data['category'] == 'free'
    assert data['author']['username'] == 'a'
```

- [ ] **Step 2: Run test to verify it fails**

Run: `python -m pytest community/tests/test_serializers.py -v`
Expected: FAIL (`ModuleNotFoundError: community.serializers`).

- [ ] **Step 3: Write the serializers**

Create `community/serializers.py`:

```python
from rest_framework import serializers
from .models import CommunityPost, CommunityPostImage, CommunityComment


class CommunityAuthorSerializer(serializers.Serializer):
    id = serializers.IntegerField()
    username = serializers.CharField()


class CommunityPostImageSerializer(serializers.ModelSerializer):
    class Meta:
        model = CommunityPostImage
        fields = ['id', 'image', 'alt_text']


class CommunityCommentSerializer(serializers.ModelSerializer):
    user = CommunityAuthorSerializer(read_only=True)

    class Meta:
        model = CommunityComment
        fields = ['id', 'text', 'user', 'created_at']
        read_only_fields = ['id', 'user', 'created_at']


class CommunityPostSerializer(serializers.ModelSerializer):
    author = CommunityAuthorSerializer(read_only=True)
    images = CommunityPostImageSerializer(many=True, read_only=True)
    is_liked = serializers.SerializerMethodField()

    class Meta:
        model = CommunityPost
        fields = [
            'id', 'category', 'body', 'author', 'neighborhood_district',
            'region_name', 'images', 'like_count', 'comment_count',
            'is_liked', 'created_at',
        ]
        read_only_fields = [
            'id', 'author', 'images', 'like_count', 'comment_count',
            'is_liked', 'created_at',
        ]

    def get_is_liked(self, obj):
        request = self.context.get('request')
        if not request or not request.user.is_authenticated:
            return False
        return obj.likes.filter(user=request.user).exists()
```

- [ ] **Step 4: Run test to verify it passes**

Run: `python -m pytest community/tests/test_serializers.py -v`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add community/serializers.py community/tests/test_serializers.py
git commit -m "feat(community): add post and comment serializers"
```

---

### Task 3: Feed list + create endpoint

**Files:**
- Create: `community/views.py`, `community/urls.py`
- Modify: `myproject/urls.py`
- Test: `community/tests/test_feed_api.py`

**Interfaces:**
- Consumes: `CommunityPostSerializer`, `CommunityPost`.
- Produces: `GET/POST community/api/posts/`. GET query params: `district_id` (int, exact neighborhood filter), `category` (one of the six), standard `page`. Response is DRF-paginated (`count`, `next`, `previous`, `results`). POST body: `category`, `body`, optional `images[]` multipart, plus `district_id`, `latitude`, `longitude`, `country_code`, `region_name`; sets `author=request.user`.

- [ ] **Step 1: Write the failing feed test**

Create `community/tests/test_feed_api.py`:

```python
import pytest
from django.contrib.auth import get_user_model
from rest_framework.test import APIClient
from community.models import CommunityPost

User = get_user_model()


@pytest.fixture
def auth_client():
    user = User.objects.create(username='poster', email='p@test.com')
    client = APIClient()
    client.force_authenticate(user=user)
    return client, user


@pytest.mark.django_db
def test_create_and_list_post(auth_client):
    client, user = auth_client
    resp = client.post('/community/api/posts/', {'category': 'question', 'body': 'Best bakery?'})
    assert resp.status_code in (200, 201)

    resp = client.get('/community/api/posts/')
    assert resp.status_code == 200
    assert resp.data['count'] == 1
    assert resp.data['results'][0]['body'] == 'Best bakery?'


@pytest.mark.django_db
def test_filter_by_category(auth_client):
    client, user = auth_client
    CommunityPost.objects.create(author=user, body='q', category='question')
    CommunityPost.objects.create(author=user, body='f', category='free')

    resp = client.get('/community/api/posts/?category=free')
    assert resp.data['count'] == 1
    assert resp.data['results'][0]['category'] == 'free'
```

- [ ] **Step 2: Run test to verify it fails**

Run: `python -m pytest community/tests/test_feed_api.py -v`
Expected: FAIL (404 / no URL resolved).

- [ ] **Step 3: Write the views**

Create `community/views.py`:

```python
from rest_framework import generics, permissions
from rest_framework.pagination import PageNumberPagination
from locations.models import District
from .models import CommunityPost, CommunityPostImage
from .serializers import CommunityPostSerializer


class CommunityFeedPagination(PageNumberPagination):
    page_size = 10


class CommunityFeedView(generics.ListCreateAPIView):
    """GET: paginated neighborhood feed. POST: create a post."""
    serializer_class = CommunityPostSerializer
    permission_classes = [permissions.IsAuthenticated]
    pagination_class = CommunityFeedPagination

    def get_queryset(self):
        qs = CommunityPost.objects.select_related('author', 'neighborhood_district').prefetch_related('images')
        district_id = self.request.query_params.get('district_id')
        category = self.request.query_params.get('category')
        if district_id:
            qs = qs.filter(neighborhood_district_id=district_id)
        if category:
            qs = qs.filter(category=category)
        return qs

    def get_serializer_context(self):
        ctx = super().get_serializer_context()
        ctx['request'] = self.request
        return ctx

    def perform_create(self, serializer):
        district_id = self.request.data.get('district_id')
        district = District.objects.filter(id=district_id).first() if district_id else None
        post = serializer.save(
            author=self.request.user,
            neighborhood_district=district,
            latitude=self.request.data.get('latitude') or None,
            longitude=self.request.data.get('longitude') or None,
            country_code=self.request.data.get('country_code') or None,
            region_name=self.request.data.get('region_name') or None,
        )
        for image in self.request.FILES.getlist('images'):
            CommunityPostImage.objects.create(post=post, image=image)
```

- [ ] **Step 4: Wire the URLs**

Create `community/urls.py`:

```python
from django.urls import path
from .views import CommunityFeedView

urlpatterns = [
    path('api/posts/', CommunityFeedView.as_view(), name='community_feed'),
]
```

In `myproject/urls.py`, add after the `services` include:

```python
    path('services/', include('services.urls')),
    path('community/', include('community.urls')),
```

- [ ] **Step 5: Run tests to verify they pass**

Run: `python -m pytest community/tests/test_feed_api.py -v`
Expected: PASS (2 tests).

- [ ] **Step 6: Commit**

```bash
git add community/views.py community/urls.py myproject/urls.py community/tests/test_feed_api.py
git commit -m "feat(community): add feed list/create endpoint"
```

---

### Task 4: Post detail, like/unlike, comments + notifications

**Files:**
- Modify: `community/views.py`, `community/urls.py`
- Test: `community/tests/test_interactions_api.py`

**Interfaces:**
- Consumes: `CommunityFeedView` context pattern, `notifications.services.create_notification`.
- Produces: `GET community/api/posts/<id>/` (detail), `POST community/api/posts/<id>/like/` (toggle, returns `{"liked": bool, "like_count": int}`), `GET/POST community/api/posts/<id>/comments/` (list/create; create returns the created comment). Like and comment on someone else's post fire `create_notification` with types `community_like` / `community_comment`.

- [ ] **Step 1: Write the failing interactions test**

Create `community/tests/test_interactions_api.py`:

```python
import pytest
from django.contrib.auth import get_user_model
from rest_framework.test import APIClient
from community.models import CommunityPost

User = get_user_model()


@pytest.mark.django_db
def test_like_toggles_and_counts():
    author = User.objects.create(username='a', email='a@test.com')
    viewer = User.objects.create(username='v', email='v@test.com')
    post = CommunityPost.objects.create(author=author, body='x')
    client = APIClient()
    client.force_authenticate(user=viewer)

    r1 = client.post(f'/community/api/posts/{post.id}/like/')
    assert r1.data == {'liked': True, 'like_count': 1}
    r2 = client.post(f'/community/api/posts/{post.id}/like/')
    assert r2.data == {'liked': False, 'like_count': 0}


@pytest.mark.django_db
def test_comment_create_increments_count():
    author = User.objects.create(username='a2', email='a2@test.com')
    post = CommunityPost.objects.create(author=author, body='x')
    client = APIClient()
    client.force_authenticate(user=author)

    resp = client.post(f'/community/api/posts/{post.id}/comments/', {'text': 'nice'})
    assert resp.status_code in (200, 201)
    post.refresh_from_db()
    assert post.comment_count == 1

    resp = client.get(f'/community/api/posts/{post.id}/comments/')
    assert len(resp.data) == 1
    assert resp.data[0]['text'] == 'nice'
```

- [ ] **Step 2: Run test to verify it fails**

Run: `python -m pytest community/tests/test_interactions_api.py -v`
Expected: FAIL (404).

- [ ] **Step 3: Add detail/like/comment views**

Append to `community/views.py`:

```python
from django.db.models import F
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .models import CommunityPostLike, CommunityComment
from .serializers import CommunityCommentSerializer


def _notify(recipient, sender, ntype, title, body, object_id):
    if recipient and recipient != sender:
        try:
            from notifications.services import create_notification
            create_notification(
                recipient=recipient, sender=sender, type=ntype,
                title=title, body=body, object_id=str(object_id),
            )
        except Exception:
            pass


class CommunityPostDetailView(generics.RetrieveAPIView):
    queryset = CommunityPost.objects.select_related('author', 'neighborhood_district').prefetch_related('images')
    serializer_class = CommunityPostSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_serializer_context(self):
        ctx = super().get_serializer_context()
        ctx['request'] = self.request
        return ctx


class CommunityPostLikeView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def post(self, request, pk):
        post = CommunityPost.objects.filter(pk=pk).first()
        if not post:
            return Response({'detail': 'Not found'}, status=status.HTTP_404_NOT_FOUND)
        like = CommunityPostLike.objects.filter(post=post, user=request.user).first()
        if like:
            like.delete()
            CommunityPost.objects.filter(pk=pk).update(like_count=F('like_count') - 1)
            liked = False
        else:
            CommunityPostLike.objects.create(post=post, user=request.user)
            CommunityPost.objects.filter(pk=pk).update(like_count=F('like_count') + 1)
            liked = True
            _notify(post.author, request.user, 'community_like',
                    'New like on your post',
                    f'{request.user.username} liked your post', post.id)
        post.refresh_from_db()
        return Response({'liked': liked, 'like_count': post.like_count})


class CommunityCommentView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request, pk):
        post = CommunityPost.objects.filter(pk=pk).first()
        if not post:
            return Response({'detail': 'Not found'}, status=status.HTTP_404_NOT_FOUND)
        comments = post.comments.select_related('user').all()
        return Response(CommunityCommentSerializer(comments, many=True).data)

    def post(self, request, pk):
        post = CommunityPost.objects.filter(pk=pk).first()
        if not post:
            return Response({'detail': 'Not found'}, status=status.HTTP_404_NOT_FOUND)
        serializer = CommunityCommentSerializer(data=request.data)
        if serializer.is_valid():
            comment = serializer.save(user=request.user, post=post)
            CommunityPost.objects.filter(pk=pk).update(comment_count=F('comment_count') + 1)
            _notify(post.author, request.user, 'community_comment',
                    'New comment on your post',
                    f'{request.user.username} commented on your post', post.id)
            return Response(CommunityCommentSerializer(comment).data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
```

- [ ] **Step 4: Add the URLs**

Update `community/urls.py`:

```python
from django.urls import path
from .views import (
    CommunityFeedView, CommunityPostDetailView,
    CommunityPostLikeView, CommunityCommentView,
)

urlpatterns = [
    path('api/posts/', CommunityFeedView.as_view(), name='community_feed'),
    path('api/posts/<int:pk>/', CommunityPostDetailView.as_view(), name='community_post_detail'),
    path('api/posts/<int:pk>/like/', CommunityPostLikeView.as_view(), name='community_post_like'),
    path('api/posts/<int:pk>/comments/', CommunityCommentView.as_view(), name='community_post_comments'),
]
```

- [ ] **Step 5: Run tests to verify they pass**

Run: `python -m pytest community/tests/ -v`
Expected: PASS (all community tests). If `create_notification`'s signature differs, confirm against `notifications/services.py` and adjust `_notify` kwargs.

- [ ] **Step 6: Commit**

```bash
git add community/views.py community/urls.py community/tests/test_interactions_api.py
git commit -m "feat(community): add detail, like toggle, comments, notifications"
```

---

## PHASE B — Flutter: community feature

### Task 5: Community models + API provider

**Files:**
- Create: `lib/providers/provider_models/community_post_model.dart`, `lib/providers/provider_models/community_comment_model.dart`, `lib/providers/provider_root/community_provider.dart`
- Modify: `lib/constants/constants.dart` (add `COMMUNITY_URL`)
- Test: `test/community_model_test.dart`

**Interfaces:**
- Produces: `CommunityPost.fromJson`, `CommunityComment.fromJson`; `CommunityProvider` with `Future<List<CommunityPost>> getFeed({int? districtId, String? category, int page})`, `Future<CommunityPost> createPost({required String category, required String body, int? districtId, double? lat, double? lng, String? countryCode, String? regionName, List<File> images})`, `Future<Map<String,dynamic>> toggleLike(int postId)`, `Future<List<CommunityComment>> getComments(int postId)`, `Future<CommunityComment> addComment(int postId, String text)`. Riverpod: `communityProvider` (Provider<CommunityProvider>), `communityFeedProvider` (FutureProvider.family over `({int? districtId, String? category})`).

- [ ] **Step 1: Add the URL constant**

In `lib/constants/constants.dart`, after `SERVICES_URL`:

```dart
const String COMMUNITY_URL = '/community/api/posts';
```

- [ ] **Step 2: Write the failing model test**

Create `test/community_model_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:app/providers/provider_models/community_post_model.dart';

void main() {
  test('CommunityPost.fromJson parses core fields', () {
    final json = {
      'id': 7,
      'category': 'question',
      'body': 'Any dentist open Sundays?',
      'author': {'id': 3, 'username': 'aziza'},
      'region_name': 'Tashkent',
      'images': [],
      'like_count': 2,
      'comment_count': 5,
      'is_liked': true,
      'created_at': '2026-07-19T10:00:00Z',
    };
    final post = CommunityPost.fromJson(json);
    expect(post.id, 7);
    expect(post.category, 'question');
    expect(post.authorName, 'aziza');
    expect(post.likeCount, 2);
    expect(post.isLiked, true);
  });
}
```

- [ ] **Step 3: Run test to verify it fails**

Run: `cd /Users/firdavsmutalipov/Desktop/Sabzi_Market/app && flutter test test/community_model_test.dart`
Expected: FAIL (target file does not exist).

- [ ] **Step 4: Write the models**

Create `lib/providers/provider_models/community_post_model.dart`:

```dart
class CommunityPost {
  final int id;
  final String category;
  final String body;
  final int authorId;
  final String authorName;
  final String? regionName;
  final List<String> imageUrls;
  final int likeCount;
  final int commentCount;
  final bool isLiked;
  final DateTime createdAt;

  CommunityPost({
    required this.id,
    required this.category,
    required this.body,
    required this.authorId,
    required this.authorName,
    required this.regionName,
    required this.imageUrls,
    required this.likeCount,
    required this.commentCount,
    required this.isLiked,
    required this.createdAt,
  });

  factory CommunityPost.fromJson(Map<String, dynamic> json) {
    final author = json['author'] as Map<String, dynamic>? ?? const {};
    final images = (json['images'] as List?) ?? const [];
    return CommunityPost(
      id: json['id'] as int,
      category: json['category'] as String? ?? 'general',
      body: json['body'] as String? ?? '',
      authorId: author['id'] as int? ?? 0,
      authorName: author['username'] as String? ?? '',
      regionName: json['region_name'] as String?,
      imageUrls: images
          .map((e) => (e as Map<String, dynamic>)['image'] as String?)
          .whereType<String>()
          .toList(),
      likeCount: json['like_count'] as int? ?? 0,
      commentCount: json['comment_count'] as int? ?? 0,
      isLiked: json['is_liked'] as bool? ?? false,
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  CommunityPost copyWith({int? likeCount, bool? isLiked, int? commentCount}) {
    return CommunityPost(
      id: id,
      category: category,
      body: body,
      authorId: authorId,
      authorName: authorName,
      regionName: regionName,
      imageUrls: imageUrls,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      isLiked: isLiked ?? this.isLiked,
      createdAt: createdAt,
    );
  }
}
```

Create `lib/providers/provider_models/community_comment_model.dart`:

```dart
class CommunityComment {
  final int id;
  final String text;
  final String userName;
  final DateTime createdAt;

  CommunityComment({
    required this.id,
    required this.text,
    required this.userName,
    required this.createdAt,
  });

  factory CommunityComment.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>? ?? const {};
    return CommunityComment(
      id: json['id'] as int,
      text: json['text'] as String? ?? '',
      userName: user['username'] as String? ?? '',
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}
```

- [ ] **Step 5: Run test to verify it passes**

Run: `flutter test test/community_model_test.dart`
Expected: PASS.

- [ ] **Step 6: Write the API provider**

Create `lib/providers/provider_root/community_provider.dart`:

```dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/constants/constants.dart';
import 'package:app/providers/provider_models/community_post_model.dart';
import 'package:app/providers/provider_models/community_comment_model.dart';

class CommunityProvider {
  Future<Map<String, String>> _authHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? prefs.getString('token');
    return {if (token != null) 'Authorization': 'Token $token'};
  }

  Future<List<CommunityPost>> getFeed({int? districtId, String? category, int page = 1}) async {
    final qp = <String, String>{'page': '$page'};
    if (districtId != null) qp['district_id'] = '$districtId';
    if (category != null && category != 'all') qp['category'] = category;
    final uri = Uri.parse('$baseUrl$COMMUNITY_URL/').replace(queryParameters: qp);
    final resp = await http.get(uri, headers: await _authHeaders());
    if (resp.statusCode == 200) {
      final data = json.decode(resp.body);
      final results = (data['results'] as List?) ?? const [];
      return results.map((e) => CommunityPost.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Failed to load community feed (${resp.statusCode})');
  }

  Future<CommunityPost> createPost({
    required String category,
    required String body,
    int? districtId,
    double? lat,
    double? lng,
    String? countryCode,
    String? regionName,
    List<File> images = const [],
  }) async {
    final uri = Uri.parse('$baseUrl$COMMUNITY_URL/');
    final req = http.MultipartRequest('POST', uri)
      ..headers.addAll(await _authHeaders())
      ..fields['category'] = category
      ..fields['body'] = body;
    if (districtId != null) req.fields['district_id'] = '$districtId';
    if (lat != null) req.fields['latitude'] = '$lat';
    if (lng != null) req.fields['longitude'] = '$lng';
    if (countryCode != null) req.fields['country_code'] = countryCode;
    if (regionName != null) req.fields['region_name'] = regionName;
    for (final img in images) {
      req.files.add(await http.MultipartFile.fromPath('images', img.path));
    }
    final streamed = await req.send();
    final resp = await http.Response.fromStream(streamed);
    if (resp.statusCode == 200 || resp.statusCode == 201) {
      return CommunityPost.fromJson(json.decode(resp.body) as Map<String, dynamic>);
    }
    throw Exception('Failed to create post (${resp.statusCode})');
  }

  Future<Map<String, dynamic>> toggleLike(int postId) async {
    final uri = Uri.parse('$baseUrl$COMMUNITY_URL/$postId/like/');
    final resp = await http.post(uri, headers: await _authHeaders());
    if (resp.statusCode == 200) {
      return json.decode(resp.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to toggle like (${resp.statusCode})');
  }

  Future<List<CommunityComment>> getComments(int postId) async {
    final uri = Uri.parse('$baseUrl$COMMUNITY_URL/$postId/comments/');
    final resp = await http.get(uri, headers: await _authHeaders());
    if (resp.statusCode == 200) {
      final list = (json.decode(resp.body) as List?) ?? const [];
      return list.map((e) => CommunityComment.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Failed to load comments (${resp.statusCode})');
  }

  Future<CommunityComment> addComment(int postId, String text) async {
    final uri = Uri.parse('$baseUrl$COMMUNITY_URL/$postId/comments/');
    final resp = await http.post(uri, headers: await _authHeaders(), body: {'text': text});
    if (resp.statusCode == 200 || resp.statusCode == 201) {
      return CommunityComment.fromJson(json.decode(resp.body) as Map<String, dynamic>);
    }
    throw Exception('Failed to add comment (${resp.statusCode})');
  }
}

final communityProvider = Provider<CommunityProvider>((ref) => CommunityProvider());

typedef CommunityFeedArgs = ({int? districtId, String? category});

final communityFeedProvider =
    FutureProvider.family<List<CommunityPost>, CommunityFeedArgs>((ref, args) {
  return ref.read(communityProvider).getFeed(
        districtId: args.districtId,
        category: args.category,
      );
});
```

Note: confirm the token SharedPreferences key against `lib/service/http_client_service.dart` (search for `getString('` around auth). If the app stores the token under a different key, use that key in `_authHeaders`.

- [ ] **Step 7: Run analyzer and commit**

Run: `flutter analyze lib/providers/provider_root/community_provider.dart lib/providers/provider_models/community_post_model.dart lib/providers/provider_models/community_comment_model.dart`
Expected: No issues.

```bash
git add lib/providers/provider_models/community_post_model.dart lib/providers/provider_models/community_comment_model.dart lib/providers/provider_root/community_provider.dart lib/constants/constants.dart test/community_model_test.dart
git commit -m "feat(community): add models and API provider"
```

---

### Task 6: Community feed screen

**Files:**
- Create: `lib/pages/community/community_main.dart`

**Interfaces:**
- Consumes: `communityFeedProvider`, `CommunityPost`, `AppLocalizations`, `activeNeighborhoodProvider`/`districtId` passed in.
- Produces: `CommunityMain({required int? districtId})` widget — the rich-card feed with category filter chips and a "Write" FAB routing to `/community/new`. Cards route to `/community/:id`.

- [ ] **Step 1: Write the feed screen**

Create `lib/pages/community/community_main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/providers/provider_models/community_post_model.dart';
import 'package:app/providers/provider_root/community_provider.dart';

const communityCategories = <String>[
  'all', 'question', 'recommend', 'free', 'lostfound', 'alert', 'general',
];

class CommunityMain extends ConsumerStatefulWidget {
  const CommunityMain({super.key, required this.districtId});
  final int? districtId;

  @override
  ConsumerState<CommunityMain> createState() => _CommunityMainState();
}

class _CommunityMainState extends ConsumerState<CommunityMain> {
  String _category = 'all';

  String _label(AppLocalizations? l, String key) {
    switch (key) {
      case 'all': return l?.communityAll ?? 'All';
      case 'question': return l?.communityQuestion ?? 'Question';
      case 'recommend': return l?.communityRecommend ?? 'Tips';
      case 'free': return l?.communityFree ?? 'Free';
      case 'lostfound': return l?.communityLostFound ?? 'Lost & Found';
      case 'alert': return l?.communityAlert ?? 'Alert';
      default: return l?.communityGeneral ?? 'General';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final args = (districtId: widget.districtId, category: _category);
    final feed = ref.watch(communityFeedProvider(args));

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/community/new'),
        icon: const Icon(Icons.edit),
        label: Text(l?.communityWrite ?? 'Write'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: communityCategories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 6),
              itemBuilder: (context, i) {
                final key = communityCategories[i];
                final selected = key == _category;
                return ChoiceChip(
                  label: Text(_label(l, key)),
                  selected: selected,
                  onSelected: (_) => setState(() => _category = key),
                );
              },
            ),
          ),
          Expanded(
            child: feed.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(l?.errorGeneric ?? 'Something went wrong')),
              data: (posts) => posts.isEmpty
                  ? Center(child: Text(l?.communityEmpty ?? 'No posts yet. Be the first!'))
                  : RefreshIndicator(
                      onRefresh: () async => ref.invalidate(communityFeedProvider(args)),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: posts.length,
                        itemBuilder: (context, i) => _PostCard(
                          post: posts[i],
                          categoryLabel: _label(l, posts[i].category),
                          onTap: () => context.push('/community/${posts[i].id}'),
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({required this.post, required this.categoryLabel, required this.onTap});
  final CommunityPost post;
  final String categoryLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(radius: 12, child: Text(
                    post.authorName.isNotEmpty ? post.authorName[0].toUpperCase() : '?',
                    style: const TextStyle(fontSize: 11),
                  )),
                  const SizedBox(width: 8),
                  Text(post.authorName, style: theme.textTheme.labelMedium),
                  const Spacer(),
                  Chip(
                    label: Text(categoryLabel),
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(post.body, maxLines: 3, overflow: TextOverflow.ellipsis),
              if (post.imageUrls.isNotEmpty) ...[
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(post.imageUrls.first, height: 140, width: double.infinity, fit: BoxFit.cover),
                ),
              ],
              const SizedBox(height: 8),
              Row(children: [
                Icon(post.isLiked ? Icons.favorite : Icons.favorite_border, size: 15, color: theme.colorScheme.primary),
                const SizedBox(width: 4),
                Text('${post.likeCount}', style: theme.textTheme.bodySmall),
                const SizedBox(width: 14),
                Icon(Icons.chat_bubble_outline, size: 15, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 4),
                Text('${post.commentCount}', style: theme.textTheme.bodySmall),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Verify it analyzes clean**

Run: `flutter analyze lib/pages/community/community_main.dart`
Expected: No issues (the l10n getters land in Task 9; until then the `??` fallbacks compile only after Task 9 adds the getters — so run this step's analyze after Task 9, or temporarily replace `l?.communityX` with the literal strings and restore in Task 9). To avoid churn, **implement Task 9 (i18n) before running analyze on this file.**

- [ ] **Step 3: Commit**

```bash
git add lib/pages/community/community_main.dart
git commit -m "feat(community): add feed screen with category chips"
```

---

### Task 7: Post detail + comments screen

**Files:**
- Create: `lib/pages/community/community_detail.dart`

**Interfaces:**
- Consumes: `communityProvider`, `CommunityPost`, `CommunityComment`.
- Produces: `CommunityDetail({required int postId})` — loads the post + comments, supports like toggle and adding a comment.

- [ ] **Step 1: Write the detail screen**

Create `lib/pages/community/community_detail.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/providers/provider_models/community_comment_model.dart';
import 'package:app/providers/provider_root/community_provider.dart';

class CommunityDetail extends ConsumerStatefulWidget {
  const CommunityDetail({super.key, required this.postId});
  final int postId;

  @override
  ConsumerState<CommunityDetail> createState() => _CommunityDetailState();
}

class _CommunityDetailState extends ConsumerState<CommunityDetail> {
  final _controller = TextEditingController();
  late Future<List<CommunityComment>> _comments;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _comments = ref.read(communityProvider).getComments(widget.postId);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _sending) return;
    setState(() => _sending = true);
    try {
      await ref.read(communityProvider).addComment(widget.postId, text);
      _controller.clear();
      setState(() => _comments = ref.read(communityProvider).getComments(widget.postId));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l?.communityPostTitle ?? 'Post')),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<CommunityComment>>(
              future: _comments,
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final comments = snap.data!;
                if (comments.isEmpty) {
                  return Center(child: Text(l?.communityNoComments ?? 'No comments yet'));
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: comments.length,
                  itemBuilder: (context, i) => ListTile(
                    leading: CircleAvatar(child: Text(
                      comments[i].userName.isNotEmpty ? comments[i].userName[0].toUpperCase() : '?')),
                    title: Text(comments[i].userName),
                    subtitle: Text(comments[i].text),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: l?.communityAddComment ?? 'Add a comment…',
                        border: const OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _sending ? null : _send,
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: Analyze (after Task 9 adds l10n) and commit**

Run: `flutter analyze lib/pages/community/community_detail.dart`
Expected: No issues (after Task 9).

```bash
git add lib/pages/community/community_detail.dart
git commit -m "feat(community): add post detail and comments screen"
```

---

### Task 8: Composer screen

**Files:**
- Create: `lib/pages/community/community_composer.dart`

**Interfaces:**
- Consumes: `communityProvider`, `activeNeighborhoodProvider` (for districtId/lat/lng), `communityFeedProvider` (invalidate on success).
- Produces: `CommunityComposer()` — category dropdown + body field + submit; on success pops and invalidates the feed.

- [ ] **Step 1: Write the composer**

Create `lib/pages/community/community_composer.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/providers/provider_root/community_provider.dart';
import 'package:app/pages/community/community_main.dart' show communityCategories;

class CommunityComposer extends ConsumerStatefulWidget {
  const CommunityComposer({super.key, this.districtId});
  final int? districtId;

  @override
  ConsumerState<CommunityComposer> createState() => _CommunityComposerState();
}

class _CommunityComposerState extends ConsumerState<CommunityComposer> {
  String _category = 'general';
  final _body = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _body.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final body = _body.text.trim();
    if (body.isEmpty || _submitting) return;
    setState(() => _submitting = true);
    try {
      await ref.read(communityProvider).createPost(
            category: _category,
            body: body,
            districtId: widget.districtId,
          );
      ref.invalidate(communityFeedProvider);
      if (mounted) Navigator.of(context).pop(true);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)?.communityPostFailed ?? 'Failed to post')),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    // Reuse the same category labels as the feed, minus "all".
    final categories = communityCategories.where((c) => c != 'all').toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(l?.communityNewPost ?? 'New post'),
        actions: [
          TextButton(
            onPressed: _submitting ? null : _submit,
            child: Text(l?.communityPublish ?? 'Post'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              value: _category,
              isExpanded: true,
              items: categories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => setState(() => _category = v ?? 'general'),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TextField(
                controller: _body,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: l?.communityBodyHint ?? "Share something with your neighborhood…",
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Analyze (after Task 9) and commit**

Run: `flutter analyze lib/pages/community/community_composer.dart`
Expected: No issues (after Task 9).

```bash
git add lib/pages/community/community_composer.dart
git commit -m "feat(community): add post composer screen"
```

---

### Task 9: Localization strings (EN/RU/UZ)

**Files:**
- Modify: `lib/l10n/app_en.arb`, `lib/l10n/app_ru.arb`, `lib/l10n/app_uz.arb`

**Interfaces:**
- Produces: `AppLocalizations` getters used by Tasks 6–8 and 11–12: `communityAll, communityQuestion, communityRecommend, communityFree, communityLostFound, communityAlert, communityGeneral, communityWrite, communityEmpty, communityPostTitle, communityNoComments, communityAddComment, communityNewPost, communityPublish, communityBodyHint, communityPostFailed, errorGeneric, tabHome, tabCommunity, tabNearby, tabMy, nearbyServices, nearbyRealEstate, nearbyJobs, nearbyShops, nearbyComingSoon`.

- [ ] **Step 1: Add keys to `app_en.arb`**

Add these entries (before the closing `}`) to `lib/l10n/app_en.arb`:

```json
  "communityAll": "All",
  "communityQuestion": "Question",
  "communityRecommend": "Tips",
  "communityFree": "Free",
  "communityLostFound": "Lost & Found",
  "communityAlert": "Alert",
  "communityGeneral": "General",
  "communityWrite": "Write",
  "communityEmpty": "No posts yet. Be the first!",
  "communityPostTitle": "Post",
  "communityNoComments": "No comments yet",
  "communityAddComment": "Add a comment…",
  "communityNewPost": "New post",
  "communityPublish": "Post",
  "communityBodyHint": "Share something with your neighborhood…",
  "communityPostFailed": "Failed to post",
  "errorGeneric": "Something went wrong",
  "tabHome": "Home",
  "tabCommunity": "Community",
  "tabNearby": "Nearby",
  "tabMy": "My",
  "nearbyServices": "Services",
  "nearbyRealEstate": "Real Estate",
  "nearbyJobs": "Jobs",
  "nearbyShops": "Local shops",
  "nearbyComingSoon": "Coming soon"
```

(If the ARB uses `@key` metadata blocks, add a matching `"@communityAll": {"description": "..."}` for each per the file's existing convention. Follow whatever pattern the surrounding keys use.)

- [ ] **Step 2: Add the same keys to `app_ru.arb`**

```json
  "communityAll": "Все",
  "communityQuestion": "Вопрос",
  "communityRecommend": "Советы",
  "communityFree": "Даром",
  "communityLostFound": "Бюро находок",
  "communityAlert": "Важное",
  "communityGeneral": "Общее",
  "communityWrite": "Написать",
  "communityEmpty": "Пока нет постов. Будьте первым!",
  "communityPostTitle": "Пост",
  "communityNoComments": "Пока нет комментариев",
  "communityAddComment": "Добавить комментарий…",
  "communityNewPost": "Новый пост",
  "communityPublish": "Опубликовать",
  "communityBodyHint": "Поделитесь чем-нибудь с соседями…",
  "communityPostFailed": "Не удалось опубликовать",
  "errorGeneric": "Что-то пошло не так",
  "tabHome": "Главная",
  "tabCommunity": "Сообщество",
  "tabNearby": "Рядом",
  "tabMy": "Профиль",
  "nearbyServices": "Услуги",
  "nearbyRealEstate": "Недвижимость",
  "nearbyJobs": "Работа",
  "nearbyShops": "Магазины",
  "nearbyComingSoon": "Скоро"
```

- [ ] **Step 3: Add the same keys to `app_uz.arb`**

```json
  "communityAll": "Hammasi",
  "communityQuestion": "Savol",
  "communityRecommend": "Maslahat",
  "communityFree": "Bepul",
  "communityLostFound": "Yo‘qolgan buyumlar",
  "communityAlert": "Ogohlantirish",
  "communityGeneral": "Umumiy",
  "communityWrite": "Yozish",
  "communityEmpty": "Hali post yo‘q. Birinchi bo‘ling!",
  "communityPostTitle": "Post",
  "communityNoComments": "Hali izoh yo‘q",
  "communityAddComment": "Izoh qo‘shing…",
  "communityNewPost": "Yangi post",
  "communityPublish": "Joylash",
  "communityBodyHint": "Mahallangiz bilan nimadir ulashing…",
  "communityPostFailed": "Joylashda xatolik",
  "errorGeneric": "Nimadir xato ketdi",
  "tabHome": "Bosh sahifa",
  "tabCommunity": "Hamjamiyat",
  "tabNearby": "Yaqin atrof",
  "tabMy": "Profil",
  "nearbyServices": "Xizmatlar",
  "nearbyRealEstate": "Ko‘chmas mulk",
  "nearbyJobs": "Ish",
  "nearbyShops": "Do‘konlar",
  "nearbyComingSoon": "Tez orada"
```

- [ ] **Step 4: Regenerate localizations and verify**

Run: `flutter gen-l10n` (or `flutter pub get` if the project generates on build — check `l10n.yaml`).
Then: `flutter analyze lib/pages/community/`
Expected: No issues — all `l?.communityX` getters now resolve.

- [ ] **Step 5: Commit**

```bash
git add lib/l10n/app_en.arb lib/l10n/app_ru.arb lib/l10n/app_uz.arb
git commit -m "feat(i18n): add community and tab-bar strings (en/ru/uz)"
```

---

### Task 10: Community routes

**Files:**
- Modify: `lib/config/app_router.dart`

**Interfaces:**
- Consumes: `CommunityDetail`, `CommunityComposer`.
- Produces: routes `/community/new` → `CommunityComposer`, `/community/:id` → `CommunityDetail`. (The feed itself renders inside the tab bar, not as a standalone route.)

- [ ] **Step 1: Add the routes**

In `lib/config/app_router.dart`, add imports at the top with the other page imports:

```dart
import 'package:app/pages/community/community_detail.dart';
import 'package:app/pages/community/community_composer.dart';
```

Add these `GoRoute`s inside the `routes: [...]` list (near the service routes):

```dart
      GoRoute(
        path: '/community/new',
        name: 'community-new',
        builder: (context, state) => const CommunityComposer(),
      ),
      GoRoute(
        path: '/community/:id',
        name: 'community-detail',
        builder: (context, state) => CommunityDetail(
          postId: int.parse(state.pathParameters['id']!),
        ),
      ),
```

- [ ] **Step 2: Verify and commit**

Run: `flutter analyze lib/config/app_router.dart`
Expected: No issues.

```bash
git add lib/config/app_router.dart
git commit -m "feat(community): wire community routes"
```

---

## PHASE C — Flutter: Nearby hub + tab bar

### Task 11: Nearby hub screen

**Files:**
- Create: `lib/pages/nearby/nearby_hub.dart`

**Interfaces:**
- Consumes: `ServiceMain`, `RealEstateMain` (existing), `NeighborhoodGate` (from `tab_bar.dart` — import it), `AppLocalizations`.
- Produces: `NearbyHub({required String regionName, required String districtName, required int? districtId})` — a category-card landing screen. Tapping **Services** pushes a `NeighborhoodGate`-wrapped `ServiceMain`; **Real Estate** pushes `RealEstateMain` un-gated; Jobs/Shops are disabled "coming soon" cards.

- [ ] **Step 1: Write the hub**

Create `lib/pages/nearby/nearby_hub.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/pages/service/main/main_service.dart';
import 'package:app/pages/real_estate/real_estate_main.dart';
import 'package:app/pages/tab_bar/tab_bar.dart' show NeighborhoodGate;

class NearbyHub extends StatelessWidget {
  const NearbyHub({
    super.key,
    required this.regionName,
    required this.districtName,
    required this.districtId,
  });

  final String regionName;
  final String districtName;
  final int? districtId;

  void _open(BuildContext context, Widget page, String title) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => Scaffold(appBar: AppBar(title: Text(title)), body: page),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final services = _NearbyCard(
      icon: Icons.handyman,
      color: const Color(0xFFE8F5EC),
      title: l?.nearbyServices ?? 'Services',
      subtitle: l?.servicesTitle ?? 'Plumbers, tutors, cleaning…',
      onTap: () => _open(
        context,
        NeighborhoodGate(
          child: ServiceMain(
            regionName: regionName,
            districtName: districtName,
            districtId: districtId,
          ),
        ),
        l?.nearbyServices ?? 'Services',
      ),
    );

    final realEstate = _NearbyCard(
      icon: Icons.apartment,
      color: const Color(0xFFE9F0FB),
      title: l?.nearbyRealEstate ?? 'Real Estate',
      subtitle: l?.realEstate ?? 'Rentals & sales near you',
      onTap: () => _open(
        context,
        RealEstateMain(
          regionName: regionName,
          districtName: districtName,
          districtId: districtId,
        ),
        l?.nearbyRealEstate ?? 'Real Estate',
      ),
    );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        services,
        const SizedBox(height: 12),
        realEstate,
        const SizedBox(height: 12),
        _NearbyCard(
          icon: Icons.work_outline,
          color: const Color(0xFFF3EEFB),
          title: l?.nearbyJobs ?? 'Jobs',
          subtitle: l?.nearbyComingSoon ?? 'Coming soon',
          onTap: null,
        ),
        const SizedBox(height: 12),
        _NearbyCard(
          icon: Icons.storefront,
          color: const Color(0xFFFDF0E8),
          title: l?.nearbyShops ?? 'Local shops',
          subtitle: l?.nearbyComingSoon ?? 'Coming soon',
          onTap: null,
        ),
      ],
    );
  }
}

class _NearbyCard extends StatelessWidget {
  const _NearbyCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final enabled = onTap != null;
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: Card(
        child: ListTile(
          onTap: onTap,
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: Colors.black87),
          ),
          title: Text(title, style: theme.textTheme.titleMedium),
          subtitle: Text(subtitle),
          trailing: enabled ? const Icon(Icons.chevron_right) : null,
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Verify and commit**

Run: `flutter analyze lib/pages/nearby/nearby_hub.dart`
Expected: No issues. (`NeighborhoodGate` is `public` in `tab_bar.dart` — confirm it is not private; it is declared `class NeighborhoodGate extends ConsumerWidget`, so the import works.)

```bash
git add lib/pages/nearby/nearby_hub.dart
git commit -m "feat(nearby): add category hub screen (services + real estate)"
```

---

### Task 12: Remap the tab bar

**Files:**
- Modify: `lib/pages/tab_bar/tab_bar.dart`

**Interfaces:**
- Consumes: `CommunityMain`, `NearbyHub`, `communityNotificationProvider`? — **v1 uses the combined services+realestate provider for the Nearby bell and no bell for Community** to avoid a new provider; see steps. (Community notification provider is deferred to the Community deep-spec.)
- Produces: five-tab bar `Home · Community · Nearby · Chat · My` with correct indices, labels, gating, search FAB, and notification bells.

- [ ] **Step 1: Add imports**

In `lib/pages/tab_bar/tab_bar.dart`, add:

```dart
import 'package:app/pages/community/community_main.dart';
import 'package:app/pages/nearby/nearby_hub.dart';
```

Remove now-unused direct imports only if they become unused (keep `main_service.dart` and `real_estate_main.dart` imports — `NearbyHub` references them transitively, but `tab_bar.dart` no longer does; the analyzer will flag unused imports — delete `import '.../main_service.dart';` and `import '.../real_estate_main.dart';` and `import '.../products_list.dart';` only if the analyzer reports them unused after Step 2–4).

- [ ] **Step 2: Rewrite `_getPageInfo` for the new order**

Replace the whole `_getPageInfo` method body's `switch` with:

```dart
    switch (index) {
      case 0:
        return PageInfo(
          title: localizations?.tabHome ?? 'Home',
          widget: NeighborhoodGate(
            child: ProductsList(
              regionName: regionName,
              districtName: districtName,
              districtId: districtId,
            ),
          ),
        );
      case 1:
        return PageInfo(
          title: localizations?.tabCommunity ?? 'Community',
          widget: NeighborhoodGate(
            child: CommunityMain(districtId: districtId),
          ),
        );
      case 2:
        return PageInfo(
          title: localizations?.tabNearby ?? 'Nearby',
          widget: NearbyHub(
            regionName: regionName,
            districtName: districtName,
            districtId: districtId,
          ),
        );
      case 3:
        return PageInfo(
          title: localizations?.message ?? 'Chat',
          widget: const MessagesList(),
        );
      case 4:
        return PageInfo(
          title: localizations?.tabMy ?? 'My',
          widget: const ShaxsiyPage(),
        );
      default:
        return PageInfo(
          title: localizations?.tabHome ?? 'Home',
          widget: NeighborhoodGate(
            child: ProductsList(
              regionName: regionName,
              districtName: districtName,
              districtId: districtId,
            ),
          ),
        );
    }
```

- [ ] **Step 3: Update `_ModernBottomNav.items`**

Replace the `items` list in `_ModernBottomNav.build` with:

```dart
    final items = [
      _NavItemData(Icons.storefront_outlined, Icons.storefront, l?.tabHome ?? 'Home'),
      _NavItemData(Icons.groups_outlined, Icons.groups, l?.tabCommunity ?? 'Community'),
      _NavItemData(Icons.explore_outlined, Icons.explore, l?.tabNearby ?? 'Nearby'),
      _NavItemData(Icons.chat_bubble_outline_rounded, Icons.chat_bubble_rounded, l?.chat ?? 'Chat'),
      _NavItemData(Icons.person_outline_rounded, Icons.person_rounded, l?.tabMy ?? 'My'),
    ];
```

The chat badge stays on index 3 now — change `final badgeCount = i == 2 ? unreadChatCount : 0;` to `final badgeCount = i == 3 ? unreadChatCount : 0;`.

- [ ] **Step 4: Update `_selectPage`, search FAB, and notification bell for new indices**

In `_selectPage`, replace the `switch`:

```dart
    setState(() {
      switch (index) {
        case 0:
          ref.invalidate(productsProvider);
          break;
        case 2:
          ref.invalidate(servicesProvider);
          break;
      }
      _selectedPageIndex = index;
    });
```

Replace `_shouldShowSearchFAB`:

```dart
  bool _shouldShowSearchFAB() {
    // Home searches products; Nearby routes search from inside its sub-views.
    return _selectedPageIndex == 0;
  }
```

Replace `_navigateToSearch`:

```dart
  void _navigateToSearch(String regionName, String districtName) {
    if (_selectedPageIndex == 0) {
      context.push('/product/search?region=$regionName&district=$districtName');
    }
  }
```

Replace `_shouldShowNotification`:

```dart
  bool _shouldShowNotification() {
    // Home + Nearby show a bell; Community bell is deferred to the deep-spec.
    return _selectedPageIndex == 0 || _selectedPageIndex == 2;
  }
```

Replace `_getNotificationProvider`:

```dart
  StateNotifierProvider<NotificationNotifier, NotificationState>?
  _getNotificationProvider() {
    switch (_selectedPageIndex) {
      case 0:
        return productNotificationProvider;
      case 2:
        // Nearby: reuse the services notification stream in v1.
        return serviceNotificationProvider;
      default:
        return null;
    }
  }
```

- [ ] **Step 5: Audit `initialIndex` / deep-link callers**

Run: `grep -rn "TabsScreen(" lib && grep -rn "initialIndex" lib && grep -rn "context.go('/tabs" lib && grep -rn "goNamed('tabs'" lib`
For every caller that passes an index meaning "services" (old `1`), "real estate" (old `3`), or "profile" (old `4`), update to the new map (`services`→open Nearby `2`, `real estate`→`2`, `profile`→`4`, `chat`→`3`). Fix each hit. If none exist, note "no index callers" and continue.

- [ ] **Step 6: Analyze the whole app**

Run: `flutter analyze`
Expected: No issues. Remove any imports the analyzer now reports as unused in `tab_bar.dart`.

- [ ] **Step 7: Manual smoke test**

Run: `flutter run` (or the project's launch config). Verify:
- Bottom bar shows Home · Community · Nearby · Chat · My with correct active pill.
- Home still shows products behind the neighborhood gate.
- Community shows the feed (empty state is fine), "Write" opens the composer, posting returns to a refreshed feed, tapping a card opens detail + comments.
- Nearby shows four cards; Services opens gated, Real Estate opens un-gated; Jobs/Shops are greyed.
- Chat and My unchanged; chat unread badge shows on the Chat tab (index 3).

- [ ] **Step 8: Commit**

```bash
git add lib/pages/tab_bar/tab_bar.dart
git commit -m "feat(tabbar): restructure to Home/Community/Nearby/Chat/My"
```

---

## Self-Review Notes (coverage map)

- Spec §2.1 Home → Task 12 case 0 (unchanged, gated). ✅
- Spec §2.2 Community (models/app) → Tasks 1–4; (Flutter feed/detail/composer) → Tasks 5–8, 10; six categories enforced in Task 1 `CATEGORY_CHOICES` + Task 6 `communityCategories`. ✅
- Spec §2.3 Nearby hub + per-category gating → Task 11 (Services gated, Real Estate not). ✅
- Spec §2.4 Chat/My unchanged → Task 12 cases 3–4. ✅
- Spec §3 compose model → Home (existing), Community "Write" (Task 6→8), Nearby sub-views (Task 11). ✅
- Spec §4 index remap, search FAB, notification bell, gate, deep-link audit → Task 12 steps 2–5. ✅
- Spec §4 i18n EN/RU/UZ → Task 9. ✅
- Spec §5 out-of-scope (nested replies, jobs/shops, community bell) → deferred: flat comments (Task 4), greyed cards (Task 11), no community bell (Task 12 step 4). ✅

**Known deviation from spec §4:** the spec proposed a *combined* Services+RealEstate notification bell and a *new* Community notification provider. To keep v1 lean and avoid a half-built provider, this plan uses the existing `serviceNotificationProvider` for the Nearby bell and **no** Community bell. Both are honest simplifications called out here; upgrade in the Community deep-spec.
