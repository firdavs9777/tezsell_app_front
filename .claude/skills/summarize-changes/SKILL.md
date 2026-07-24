---
description: Summarizes uncommitted changes in this Flutter project and flags anything risky. Use when the user asks what changed, wants a commit message, or asks to review their diff.
---

## Current branch

!`git rev-parse --abbrev-ref HEAD`

## Files changed

!`git status --short`

## Diff

!`git diff HEAD`

## Instructions

Summarize the changes above in two or three bullet points grouped by area (e.g. `lib/pages/chat`, `lib/l10n`, `android/`). Then list any risks you notice, such as:

- Missing or inconsistent translations across `app_en.arb`, `app_ru.arb`, `app_uz.arb`
- Hardcoded strings that should be localized via `AppLocalizations`
- Hardcoded colors or styles that bypass `app_colors.dart`
- Provider state changes without matching `notifyListeners()` or disposal
- Route changes in `app_router.dart` not reflected in callers
- Committed secrets or environment files (e.g. `google-services.json`, `.env`)
- Tests or golden files that likely need updating

If the diff is empty, say there are no uncommitted changes. Keep the whole response under ~15 lines.
