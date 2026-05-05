# Products & Services Optimization — Design Spec

**Date:** 2026-05-06
**Status:** Phase 0 + Phase 1 (partial) executed autonomously overnight; remainder deferred.
**Author:** Claude (autonomous run while user was asleep)

## Goal

Reduce file size of the largest pages, audit and lint localization, lay groundwork for the
Carrot-Korea-style feature backlog. The user requested the full sweep (A+B+C+D + Carrot
features); the realistic shape is a multi-phase program.

## Scope decomposition

| Phase | Scope | Effort | Risk | Status |
|---|---|---|---|---|
| 0a | Localization audit script (CI lint) | XS | None | **Done overnight** |
| 0b | Remove `replyingTo` orphan from RU/UZ ARBs | XS | Low | **Deferred** — user has heavy ARB WIP |
| 0c | Extract ~10 hardcoded strings to l10n | S | Low | **Deferred** — touches WIP files |
| 1a | Refactor `product_new.dart` (827 L) into widgets | M | Low | **Done overnight** |
| 1b | Refactor `product_detail.dart` (880 L) | M | Med | **Deferred** — small WIP overlap, stateful coupling |
| 1c | Refactor `products_list.dart`, `product_category.dart` | M | High | **Deferred** — heavy WIP |
| 2 | Refactor services pages (`main_service.dart`, `service-filter.dart`) | M | Low-Med | **Deferred** |
| 3 | Function audit + bug sweep across products/services | M-L | Low | **Deferred** |
| 4 | Carrot-Korea features (distance, recent searches in UI, similar items, verification badges, quick-category chips) | L | Med | **Deferred** — separate brainstorm per feature |

## Why this shape

### Empirical findings that changed the plan

1. **Localization is structurally healthy.** EN/RU/UZ all have 1298–1299 keys; the
   85-line drift between ARBs is whitespace, not missing translations. The original
   request was framed around "localizations need work," but the data shows otherwise.
2. **Big files are widget-builder pages, not god-files.** `product_detail.dart` is a
   sequence of `_buildSellerSection`, `_buildProductInfo`, `_buildDescription`, etc.
   The right fix is extracting each into its own file, not rewriting.
3. **Heavy uncommitted WIP overlaps the refactor target.** `git status` shows the
   user is actively modifying `filtered_products.dart` (+132 lines), `products_list.dart`
   (+83), `filtered_services.dart` (+140), `main_service.dart` (+53), and all three ARBs.
   Refactoring those files now would create unmergeable conflicts. The overnight scope
   was narrowed to files with zero/tiny WIP overlap.

### Files safe to touch overnight

- `product_new.dart` — not modified at all, biggest size reduction win.
- `product_detail.dart` — only +9/−5 of WIP (localization extraction); manageable but
  deferred for stateful-coupling reasons.

### Files NOT to touch overnight

- All three `app_*.arb` files — user is adding keys.
- `filtered_products.dart`, `filtered_services.dart`, `products_list.dart`,
  `main_service.dart`, `service-filter.dart` — heavy WIP.

## Architecture for refactored pages

### Pattern: page-level state stays, widgets become props-only consumers

`product_new.dart` becomes:

```
lib/pages/products/
  product_new.dart                         # ConsumerStatefulWidget; orchestrates state
  widgets/
    product_new_image_picker.dart          # Image grid + add/remove
    product_new_form_fields.dart           # Title, description, price form
    product_new_category_picker.dart       # Category dropdown
    product_new_currency_selector.dart     # Currency dropdown
    product_new_submit_button.dart         # Submit + loading state
```

Each widget receives:
- The data it needs (via constructor)
- Callbacks for actions it triggers (`onCategorySelected`, `onImageRemoved`, etc.)

State (controllers, `_selectedImages`, `_selectedCategory`, etc.) stays in the parent
`State` class. Children are dumb.

**Why this pattern:** Riverpod `ConsumerStatefulWidget` plays well with extracted widgets
when the children are stateless. Keeps the state in one place, makes children testable in
isolation, and shrinks the parent file dramatically.

### Pattern NOT used: lifting state up to providers

Tempting but out of scope. The forms use local controllers and one-time submit logic;
adding a provider for transient form state is over-engineering.

## Localization audit script

`scripts/check_l10n.sh` — diffs key sets across `app_en.arb`, `app_ru.arb`, `app_uz.arb`,
prints missing and orphan keys per locale, exits non-zero on any drift. Wire into CI
later (not required for the script itself to be useful).

Script is pure-shell + Python (already used in this codebase) — no new dependencies.

## Testing strategy

- **Static check after each refactor:** `flutter analyze` must pass with no new errors.
- **Manual smoke test deferred to user** — overnight run cannot launch a simulator.
- **No new unit tests in this phase.** The existing widgets have no tests; adding tests
  is its own scope (Phase 3 territory).

## Error handling

Refactor preserves existing error handling. No new try/catches. No new logging beyond
what already exists.

## What's deferred and why

- **Phase 0b/0c:** Touches ARBs and pages with WIP. Cleaner to do after the user merges
  their current work.
- **Phase 1b (product_detail.dart):** State coupling is denser; safer to do interactively.
- **Phase 1c, 2:** Pure WIP-conflict reasons.
- **Phase 3:** Bug sweep is open-ended and benefits from interactive review.
- **Phase 4:** Each Carrot feature deserves its own brainstorm. The IMPROVEMENT_PLAN.md
  backlog already enumerates them; they need prioritization not specification.

## Rollback

Each phase is its own commit. To revert the overnight work:

```
git log --oneline -5
git revert <commit-sha>          # individual phase
git revert <oldest>..<newest>    # range
```

## Next session

1. Review overnight commits.
2. Merge or rebase user's WIP first (it conflicts only via line numbers, not semantically).
3. Decide whether to continue with Phase 1b (product_detail.dart) or jump to Phase 4
   (Carrot features) — likely the latter since refactor work has diminishing user-visible value.
