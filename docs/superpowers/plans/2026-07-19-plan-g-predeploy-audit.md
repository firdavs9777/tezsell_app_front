# Plan G — Pre-Deploy Audit Gate

> **For agentic workers:** REQUIRED SUB-SKILL: superpowers:subagent-driven-development (audit tasks fan out well). FINAL gate — execute after all other plans merge. Fix-forward: findings become fix commits, Critical blocks deploy.

**Goal:** One systematic pass proving the app is deployable: security, correctness, performance, i18n, store readiness, backend deploy config.

## Tasks

### Task 1: Security review
- Run the `security-review` skill on both repos' pending state; plus targeted checks: no secrets in git (`git log -p` grep for keys), `firebase-service-account-key.json` NOT in repo history going to prod (backend repo has it at root — verify gitignore/rotation!), DEBUG off, ALLOWED_HOSTS/CORS allowlists, throttle coverage on new endpoints (chat transaction, community v2, translate), media upload validation (size/type on images+voice), Plan F items verified landed.

### Task 2: Correctness sweep
- Backend: full pytest both repos; `manage.py makemigrations --check` (no drift); `manage.py check --deploy`.
- Flutter: `flutter analyze` zero warnings on lib/; `flutter test`; fix the known map-widget network-flaky tests (mock tiles) or tag-skip with reason.
- Cross-repo contract check: script-diff every Flutter endpoint path/WS event against Django urls/consumers (extend Task-21 method from Plan A to all features).

### Task 3: Performance pass
- Flutter: `flutter build apk --profile` startup trace; list jank check on low-end emulator for the four heavy screens (home feed, chat room, community feed, map browse); image caching audit (`cached_network_image_widget.dart` used everywhere network images render — grep raw `Image.network` and replace).
- Backend: `is_liked`-style N+1 sweep (the known community one via `Exists` + shotgun check with `django-silk` or `assertNumQueries` on hot endpoints: product list, chat list, community feed).

### Task 4: i18n completeness
- Script: parse all three arbs, diff key sets (must be identical), grep lib/ for hardcoded user-facing string literals in Text() widgets outside l10n (known: `NeighborhoodGate` copy), fix stragglers. Verify RU/UZ render on-device (no overflow on long strings in nav/chips).

### Task 5: Store & platform readiness
- iOS: permissions strings (mic — Plan A voice, location, camera, photos) present + honest; push entitlements; version/build bump.
- Android: RECORD_AUDIO etc. in manifest; targetSdk current; `google-services.json` prod variant; app icons/splash (new logo assets landed in WIP — verify wired).
- Deep links: `/tabs` remap regression re-check + push-notification `targetRoute` audit (`push_notification_service.dart`).

### Task 6: Backend deploy config
- Migrations applied cleanly on a fresh DB + on a copy of prod schema; env var inventory documented (`GOOGLE_TRANSLATE_API_KEY`, FCM creds, SECRET_KEY, DB, Spaces/S3); daphne/channels layer config for the WS features (channel layer backend — in-memory won't survive multi-worker: document single-worker constraint or add Redis channel layer NOW); static/media storage sanity; health endpoint green; rollback note.

### Task 7: Final report
- Write `docs/superpowers/specs/2026-XX-XX-deploy-readiness-report.md`: per-area verdict (🟢/🟡/🔴), every fix commit, remaining accepted risks, deploy runbook (ordered commands). DEPLOY BLOCKS on any 🔴.

## Out of scope
Load testing, pen-testing, CI/CD pipeline setup, monitoring/observability stack (recommend Sentry as a 🟡 note).
