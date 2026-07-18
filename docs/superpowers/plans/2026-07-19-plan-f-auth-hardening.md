# Plan F — Authentication Hardening

> **For agentic workers:** REQUIRED SUB-SKILL: superpowers:subagent-driven-development. Spec+plan combined; survey-grounded. SECURITY-CRITICAL — execute before deploy regardless of other plans' order.

**Goal:** Close the audited auth gaps: token lifetime enforcement + refresh rotation, secure client storage, the OTP unique-constraint 500, OTP log leaks, a real 401 interceptor, honest security screen, password policy, declarative admin permissions.

**Audit findings driving this plan (ranked):**
1. DRF access tokens NEVER expire server-side (client-shown 24h TTL is advisory only); refresh tokens (90d) are not rotated on use.
2. Tokens in plaintext SharedPreferences.
3. `OTPData.phone_number` is `unique=True` but views upsert on `(phone_number, otp_type)` → second OTP type for same identifier = IntegrityError 500.
4. Backend prints OTP codes to stdout (`views/verification.py`).
5. Fake Security screen (`main_security.dart`): hardcoded 2FA/biometric-off, cosmetic score, static "last changed".
6. No shared 401 handling client-side; password policy = length≥8 only; manual staff checks in `accounts/views/users.py` (vs declarative in moderation).

## Global Constraints
- Branches: backend `feat/auth-hardening-backend`, Flutter `feat/auth-hardening`.
- NO breaking change for already-logged-in users without a migration path (token migration must be seamless or force re-login ONCE with a clear message).
- i18n EN/RU/UZ for new strings.

## Tasks

### Task 1 (BE): Token expiry enforcement + refresh rotation
Files: `accounts/token_models.py`, custom authentication class, `myproject/settings/base.py`, tests.
- Custom `ExpiringTokenAuthentication` (subclass DRF TokenAuthentication): reject tokens older than 24h from creation (`token.created`) with 401 `{'detail': 'Token expired.'}`; swap into `DEFAULT_AUTHENTICATION_CLASSES`.
- `TokenRefreshView`: on successful refresh, ROTATE — issue new refresh token, revoke old (grace: old valid 60s for in-flight requests). Refresh also recreates the access token (deletes old).
- Tests: expired access 401; refresh rotates; old refresh dies after grace; login flow unaffected.

### Task 2 (BE): OTP constraint fix + log scrubbing
Files: `accounts/models.py` (+migration), `accounts/views/verification.py`, tests.
- `OTPData`: drop `unique=True` on `phone_number`, add `unique_together = [['phone_number', 'otp_type']]`. Migration handles existing rows.
- Remove EVERY `print` of OTP/identifiers in verification views (grep `print(` across `accounts/`); replace with `logger.debug` WITHOUT the code value.
- Tests: two OTP types same identifier both work; regression on verify flow.

### Task 3 (BE): Password policy + declarative admin perms
Files: `accounts/views/password.py`, `accounts/views/users.py`, tests.
- Django `validate_password` (settings validators: min 8, not-numeric, common-password list) applied on register/reset/change; friendly error strings.
- `users.py` views: replace manual staff checks with `permission_classes = [IsAuthenticated, IsAdminUser]`.

### Task 4 (FE): Secure token storage migration
Files: pubspec (`flutter_secure_storage`), `authentication_service.dart`, `social_auth_service.dart`, `token_refresh_service.dart`, every service reading `prefs.getString('token')` (grep-driven sweep), tests where pure.
- New `TokenStore` wrapper (secure storage, async, in-memory cache). One-time migration: existing SP token → secure storage → SP keys deleted. ALL reads go through `TokenStore` (single source).
- Caution: many services read the key directly — sweep with grep `getString('token'`, update each, run full analyze.

### Task 5 (FE): Shared authenticated HTTP client + 401 interceptor
Files: `lib/service/http_client_service.dart` (extend existing), sweep services to use it.
- Wrapper injecting auth header + on 401: attempt one silent refresh (`/accounts/refresh-token/`), retry original once; refresh fails → clear session, route to login with "session expired" snackbar. Applies at least to: chat, products, services, community, reviews, offers services (sweep incrementally; document coverage).

### Task 6 (FE): Honest security screen
Files: `main_security.dart`.
- Remove fake 2FA/biometric toggles + fake score. Keep real items: change password, active sessions (if `LoginHistory` endpoint exists — verify; else show login history read-only), account deletion, logout-all (BE: add `POST /accounts/logout-all/` revoking all tokens — small backend addition with test).

### Task 7: Integration verification
- Full accounts test suite green; manual: login → 24h-expired token simulation → silent refresh; two OTP flows same email; register with weak password rejected; secure-storage migration on upgrade; 401 → refresh → retry; logout-all kills other device.

## Out of scope
Real 2FA/TOTP enrollment, biometric unlock, breach-list (HIBP) checks, session-device management UI beyond list, OAuth scope changes.
