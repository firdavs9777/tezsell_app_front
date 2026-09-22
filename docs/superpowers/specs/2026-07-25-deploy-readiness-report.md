# Tezsell — Deploy-Readiness Report (Plan G Audit Gate)

**Date:** 2026-07-25
**Repos:** Flutter `feat/predeploy-audit` (base `b1c98a2`) · Django `feat/predeploy-audit-backend` (base `d7f858e`)
**Verdict:** 🟢 **DEPLOYABLE** — no 🔴 blockers remain in code. Two 🔴→🟢 items were code-fixed; the rest of the residual risk is **deploy-time configuration** (runbook below) and 🟡 polish/follow-ups. **Deploy is gated on completing the runbook's environment checks**, not on further code.

Scope covered plans A–G (chat, community, products/home, profile/trust, auth hardening) merged to `main` before this gate.

---

## Per-area verdict

| Area | Verdict | Notes |
|---|---|---|
| Security | 🟢 | Fail-open settings fixed (was 🔴); uploads validated; no secrets in git. |
| Correctness | 🟢 | Backend 561 pass / 0 fail; Flutter 189 pass / 0 analyze errors; no migration drift; real iOS release build compiles. |
| Performance | 🟢 | Avatar & chat N+1s fixed; image caching in scroll lists; pagination caps. Residual 🟡 items are non-blocking. |
| i18n | 🟢 | en/ru/uz key sets identical (1558 each); 33 target-market strings translated. |
| Store / platform | 🟡 | iOS version de-hardcoded (ships 1.9.5+41). Blank splash + ATS/version bump are pre-submission polish. |
| Backend deploy config | 🟡 | Prod settings correct; **gated on host env vars** (`DJANGO_ENV`/`SECRET_KEY`/`REDIS_URL`) + daphne+Redis process — see runbook. |

---

## 🔴→🟢 Fixed this gate (were deploy-blockers)

1. **Settings fail-*open* to development** (`myproject/settings/__init__.py`, commit `f93af42`). A prod host with a missing `SECRET_KEY` silently ran development settings on a public host: `DEBUG=True`, `ALLOWED_HOSTS=['*']`, `CORS_ALLOW_ALL_ORIGINS=True`, an in-memory channel layer (breaks multi-worker WS fan-out), and the committed dev `SECRET_KEY` (session/token forgery). **Now fails closed** — raises `ImproperlyConfigured` at boot. Stale duplicate `myproject/settings.py` removed.
2. **Unvalidated uploads** — chat image/voice (`a090143`) and community images (`3d893ca`) were saved with no type/size/magic-byte check to a public-read CDN. Now routed through the existing `validate_image_file`/`validate_audio_file` validators.

## Correctness fixes

- **Broken `conftest` location fixtures** (`27777b5`) — referenced the retired `accounts.UserLocation`, erroring ~28 tests at setup. Rebuilt as `locations.Country→Region→District`; removed the dead `TestUserLocationModel`; fixed the real_estate auto-populate test. **Backend suite 508→561 passed.**
- **iOS version hardcode** (`b39ee2d`) — `project.pbxproj` hardcoded 1.9.9/42 across all 3 configs, overriding pubspec. Removed; build now inherits pubspec `1.9.5+41` (verified via a real release build).

## Performance fixes

- Avatar N+1 — `select_related('…__profile_image')` on product/review/profile lists (`1d272d1`).
- `ChatListView` paginated + `unread_count` batched via subquery (`e63b466`); default `page_size` raised to 100 so the no-load-more Flutter client isn't truncated (`68bb666`).
- `PendingReviewsView` paginated + `UserReviewsView` `page_size` capped (`bd4566c`); Transaction GenericFK item title/image batched (`b4e3ece`).
- Flutter: raw `Image.network` → `CachedNetworkImageWidget` in 6 scroll-list sites (`d87df84`); `communityFeed`/`communityCounts` providers `.autoDispose` (`6498452`).

## Security hardening (lower severity)

- Chat link-preview only launches `http`/`https` schemes (`e72bf41`).
- FCM-token `print()`s gated behind `kDebugMode` (`7f16b0b`).

## Verified SAFE (no action)

- **No secrets in git history** (both repos); `firebase-service-account-key.json` + `.env` gitignored and never committed.
- `production.py`: `DEBUG=False`, ALLOWED_HOSTS allowlist, `CORS_ALLOW_ALL_ORIGINS=False` + scoped origins, full `SECURE_*`/HSTS/secure-cookies, `SECRET_KEY` from env with hard-fail, `CHANNEL_LAYERS`=Redis.
- Global DRF throttles (`Anon 100/min`, `User 3000/hr`) + `IsAuthenticated` defaults on every endpoint; auth endpoints scoped-throttled.
- Authz/IDOR: reviews, chat, community, products (chat-buyers, listing-state PATCH, ownership-spoof fix), profile `include_inactive` — all owner/participant-gated.
- Plan F wiring landed: `ExpiringTokenAuthentication`, WS token-expiry enforcement, refresh rotation, password validators, secure `TokenStore`.
- Community feed is reference-quality (batched `is_liked`/poll-votes, denormalized counts, paginated).
- All push-notification target routes resolve to real `go_router` routes.

---

## ⚠️ DEPLOY RUNBOOK (must complete before/at deploy)

**Ordering hazard (from Plan F):** ship the **app update (F4/F5 token interceptor) to users BEFORE/WITH deploying the backend**, else existing users on the old app with >24h tokens get stuck on 401 until manual re-login.

**Backend (in order):**
1. **Set host env vars** (the single biggest risk): `DJANGO_ENV=production`, `SECRET_KEY`, `REDIS_URL`, `DATABASE_*`, `DO_SPACES_KEY/SECRET`, `GOOGLE_TRANSLATE_API_KEY`, `MAILGUN_*`, `TWILIO_*`, `ESKIZ_*`, `GOOGLE_*`/`APPLE_*` (social), `FIREBASE_CREDENTIALS_PATH`. Verify with `python manage.py diffsettings | grep -E "DEBUG|ALLOWED_HOSTS|CORS_ALLOW_ALL"` (DEBUG=False expected). *The settings now fail closed, so a missing SECRET_KEY aborts boot instead of running dev.*
2. **Provision Redis** and confirm reachable at `REDIS_URL` (needed for the channel layer — chat/typing/notifications/transaction WS fan-out — and cache/Celery).
3. **Run the ASGI server**: `daphne … myproject.asgi:application` (NOT `gunicorn wsgi` — that silently breaks all WebSockets). If running multiple workers, the Redis channel layer (already configured in `production.py`) is required — do not use in-memory. *No Procfile/systemd is committed; add one.*
4. `pip install -r requirements.txt` on the host — `firebase-admin` was missing from the audit venv (push notifications silently disabled without it).
5. `python manage.py migrate` (no drift; the one data migration is fresh-DB-safe). `python manage.py collectstatic` (WhiteNoise). Confirm `GET /health/`, `/health/db/`, `/health/redis/` green.
6. **Deploy the firebase service-account key** out-of-band to the host (gitignored by design).

**Mobile (pre-submission):**
7. Bump `pubspec.yaml` `version:` once (single source of truth now that the iOS override is gone).
8. iOS: confirm `aps-environment` resolves to `production` when archiving with a distribution profile.
9. Android: `flutter build appbundle` reads version from pubspec (local `local.properties` is stale/local-only).

**Rollback:** both repos fast-forward-merged to `main`; roll back by resetting `main` to the pre-merge SHA (Flutter `b1c98a2`, backend `d7f858e`) and redeploying. Migrations this gate added: **none**.

---

## 🟡 Accepted risks / post-deploy follow-ups (non-blocking)

**Backend/deploy:**
- Commit a Procfile/systemd unit + add Redis to any prod compose; `docker-compose.yml` currently runs `runserver` (dev) with no Redis.
- Add a `/health/channels/` check (current health suite doesn't exercise the channel layer).
- Refresh `docs/ENV_EXAMPLE.md` (stale vs required vars); prune orphaned `TELEGRAM_BOT_TOKEN`.
- Rotate the committed dev `SECRET_KEY` literal (`development.py`) — now unreachable in prod, but it's in history.

**Performance (deferred):**
- Chat list client-side load-more (so `ChatListView` page_size can be lowered from 100).
- Remaining raw `Image.network` in single-item/detail screens; recently-viewed optimistic update; `chat_room` `ref.watch` → `.select`; a few missing `ValueKey`s on list items.
- `/pending/` + per-row follow-list trust temp N-calls (batch a `temperature` field into the serializers).

**i18n / store polish:**
- 12 non-primary locales (ar/de/es/…) still fall back to English (~214 keys each) — established pattern, out of target-market scope.
- Add `flutter_native_splash` (splash is currently blank white).
- Remove redundant `NSAllowsArbitraryLoads` (keep the scoped ATS exception) and re-evaluate the "Always" location strings — both are App-Store review-risk, not blockers.
- Hardcoded English in `review_tags.dart` section headers, `VacationModeToggle`, `NeighborhoodGate`; non-predefined review tags lose ru/uz; `DateFormat` not locale-aware.

**Trust/profile feature gaps (deferred from Plan E):**
- Public per-user vacation badge needs a backend field (own-profile toggle works; not surfaced on others' profiles).
- Public reviews list not auto-refreshed after submitting a review (trust dial + nudge do refresh).

**Out of scope (per plan):** load testing, pen-testing, CI/CD pipeline, observability stack — recommend adding Sentry as a 🟡 follow-up.

---

## Test evidence

- Backend: `pytest` → **561 passed, 0 failed**; `manage.py check` clean; `makemigrations --check` → no drift; `check --deploy` clean under production settings.
- Flutter: `flutter analyze lib/` → **0 errors**; `flutter test` → **189 passed**; `flutter build ios --release` → **✓ built, version 1.9.5+41**.

---

# Addendum — 2026-09-21 follow-up sweep

Everything above describes the state at the 2026-07-25 gate. This records
what changed since, so the runbook is not followed from a stale copy.

**Verdict unchanged: 🟢 deployable, still gated on the runbook's environment
checks** — but three of those checks no longer need improvising, and one
previously-unknown blocker was found and fixed.

## Newly found (not in the original audit)

- **The Docker image could not build.** `Dockerfile` was pinned to
  `python:3.9`; Django 5.1.5 (requirements.txt) requires 3.10+, so
  `pip install -r requirements.txt` fails. Now `python:3.11-slim`. Anyone who
  deployed via compose rather than a host venv would have hit this.
- **`ChatListView.catchError` type bug** and three sibling null-guard bugs on
  the Flutter side — see the Flutter repo's `1dba631`.

## Runbook items now satisfied in-repo

| Was | Now |
|---|---|
| No Procfile/systemd unit committed | `Procfile` — daphne + a release phase running migrate/collectstatic |
| `docker-compose.yml` ran `runserver`, no Redis | Redis service added, daphne via the image CMD, healthchecks and env wired |
| No channel-layer health check | `GET /health/channels/` round-trips through the layer and reports the backend, flagging `InMemoryChannelLayer` as not multi-worker safe |
| `ENV_EXAMPLE.md` documented 16 of 31 vars | Regenerated from the actual `os.getenv` calls; split required vs per-feature. The 15 missing included `DO_SPACES_*`, `GOOGLE_TRANSLATE_API_KEY`, all social-auth IDs and all Mailgun config |
| `TELEGRAM_BOT_TOKEN` orphan | Already gone; nothing references it |

**Runbook steps 1–6 still apply as written** — setting host env vars,
provisioning Redis, running daphne, `pip install -r requirements.txt`,
migrate/collectstatic, and deploying the firebase key out of band. Step 3's
"no Procfile is committed; add one" no longer applies.

**The ordering hazard still applies**, and now has a second instance:
1. Token interceptor (original) — ship the app update before/with the backend.
2. `ChatListView` page_size stays at **100**, deliberately. The updated client
   sends `page_size=30` explicitly, but the default governs older builds that
   read page 1 only. Lowering it before that build leaves circulation would
   truncate those users' chat lists.

## Follow-ups closed since the gate

- Chat-list client-side load-more — **done** (so the page_size note above).
- Public per-user vacation badge — **done**, backend field + Flutter badge.
- Public reviews list not refreshing after submit — **done**.
- All remaining raw `Image.network` — **done**, zero left in `lib/`.
- `flutter_native_splash` — **added**.
- `NSAllowsArbitraryLoads` — **removed**, scoped exception kept.
- Hardcoded English in `review_tags.dart` / `NeighborhoodGate`; `DateFormat`
  not locale-aware — **done**, plus the whole offers flow and the route error
  pages. `initializeDateFormatting()` was also missing, without which
  locale-aware `DateFormat` throws.
- Sentry — **added**, opt-in via `--dart-define=SENTRY_DSN`, inert without it.
- Map widget tests hit the live network (Plan G Task 2) — **done**, tiles now
  served from memory.

## Closed in the 2026-09-22 pass

- Dev `SECRET_KEY` literal — removed; generated per process when unset.
- `/pending/` + follow-list trust-temp N-calls — batched. A second N+1 was
  found alongside it: `is_following` ran an EXISTS query per row.
- All 12 non-primary locales — complete; all 15 now at 1616/1616.
- `chat_room` `ref.watch` → `.select`; recently-viewed optimistic update.
- `constants.dart` → `AppConfig` — migrated (301 references) and deleted.
- Auto-translate preference — **built**, opt-in per user, default off.

## Still open

- **Flutter:** a few missing `ValueKey`s on list items.
- **The 12 new locales need a native-speaker pass.** They were written by
  the model, not reviewed by native speakers. Placeholders are verified
  programmatically, but register and marketplace conventions are exactly
  where a non-native translation slips. Arabic is also RTL and that layout
  has not been exercised on-device.
- **Test instrumentation:** `CaptureQueriesContext` intermittently reports
  zero captured queries (~1 run in 20) for requests that demonstrably hit
  the DB. Root cause unknown; `conftest.capture_queries` retries around it
  rather than fixing it. Worth revisiting if it spreads.


## Test evidence

- Backend: `pytest` → **561 passed, 0 failed**; `manage.py check` clean; `makemigrations --check` → no drift; `check --deploy` clean under production settings.
- Flutter: `flutter analyze lib/` → **0 errors**; `flutter test` → **189 passed**; `flutter build ios --release` → **✓ built, version 1.9.5+41**.

---

# Addendum — 2026-09-21 follow-up sweep

Everything above describes the state at the 2026-07-25 gate. This records
what changed since, so the runbook is not followed from a stale copy.

**Verdict unchanged: 🟢 deployable, still gated on the runbook's environment
checks** — but three of those checks no longer need improvising, and one
previously-unknown blocker was found and fixed.

## Newly found (not in the original audit)

- **The Docker image could not build.** `Dockerfile` was pinned to
  `python:3.9`; Django 5.1.5 (requirements.txt) requires 3.10+, so
  `pip install -r requirements.txt` fails. Now `python:3.11-slim`. Anyone who
  deployed via compose rather than a host venv would have hit this.
- **`ChatListView.catchError` type bug** and three sibling null-guard bugs on
  the Flutter side — see the Flutter repo's `1dba631`.

## Runbook items now satisfied in-repo

| Was | Now |
|---|---|
| No Procfile/systemd unit committed | `Procfile` — daphne + a release phase running migrate/collectstatic |
| `docker-compose.yml` ran `runserver`, no Redis | Redis service added, daphne via the image CMD, healthchecks and env wired |
| No channel-layer health check | `GET /health/channels/` round-trips through the layer and reports the backend, flagging `InMemoryChannelLayer` as not multi-worker safe |
| `ENV_EXAMPLE.md` documented 16 of 31 vars | Regenerated from the actual `os.getenv` calls; split required vs per-feature. The 15 missing included `DO_SPACES_*`, `GOOGLE_TRANSLATE_API_KEY`, all social-auth IDs and all Mailgun config |
| `TELEGRAM_BOT_TOKEN` orphan | Already gone; nothing references it |

**Runbook steps 1–6 still apply as written** — setting host env vars,
provisioning Redis, running daphne, `pip install -r requirements.txt`,
migrate/collectstatic, and deploying the firebase key out of band. Step 3's
"no Procfile is committed; add one" no longer applies.

**The ordering hazard still applies**, and now has a second instance:
1. Token interceptor (original) — ship the app update before/with the backend.
2. `ChatListView` page_size stays at **100**, deliberately. The updated client
   sends `page_size=30` explicitly, but the default governs older builds that
   read page 1 only. Lowering it before that build leaves circulation would
   truncate those users' chat lists.

## Follow-ups closed since the gate

- Chat-list client-side load-more — **done** (so the page_size note above).
- Public per-user vacation badge — **done**, backend field + Flutter badge.
- Public reviews list not refreshing after submit — **done**.
- All remaining raw `Image.network` — **done**, zero left in `lib/`.
- `flutter_native_splash` — **added**.
- `NSAllowsArbitraryLoads` — **removed**, scoped exception kept.
- Hardcoded English in `review_tags.dart` / `NeighborhoodGate`; `DateFormat`
  not locale-aware — **done**, plus the whole offers flow and the route error
  pages. `initializeDateFormatting()` was also missing, without which
  locale-aware `DateFormat` throws.
- Sentry — **added**, opt-in via `--dart-define=SENTRY_DSN`, inert without it.
- Map widget tests hit the live network (Plan G Task 2) — **done**, tiles now
  served from memory.

## Still open

- **Backend:** rotate the committed dev `SECRET_KEY` literal (unreachable in
  prod, but in history). `/pending/` + follow-list trust-temp N-calls.
- **Flutter:** 12 non-primary locales still fall back to English — 266 keys
  each (they sit at 1345 while en/ru/uz have grown to 1611). `chat_room` `ref.watch` →
  `.select`; a few missing `ValueKey`s; recently-viewed optimistic update.
  `constants.dart` → `AppConfig` migration (~80 call sites) — the largest
  remaining debt in that repo.
- **Dropped, needs a decision:** the June chat plan's Task 17
  "auto-translate to my language" preference was never built and Plan A
  respecified translation as manual-only. Either build it or strike it.

## Test evidence (2026-09-21)

- Backend: `pytest` → **569 passed, 0 failed**; `manage.py check` clean;
  `makemigrations --check` → no drift.
- Flutter: `flutter analyze` → **No issues found** (0 errors, 0 warnings,
  0 lints, across `lib/` and `test/`); `flutter test` → **219 passed**;
  `flutter build apk --debug` and `flutter build ios --release` both ✓,
  version **1.9.6+42**.
