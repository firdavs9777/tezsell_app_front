#!/usr/bin/env python3
"""
Audits localization key coverage across app_en.arb / app_ru.arb / app_uz.arb.

Exits non-zero when any locale is missing keys that EN has, or carries
orphan keys EN does not. Run from the repo root:

    python3 scripts/check_l10n.py

Or with --fix to remove orphans automatically (does not invent translations
for missing keys; that requires human input).
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

ARB_DIR = Path("lib/l10n")
LOCALES = ["en", "ru", "uz"]
BASE = "en"


def load(locale: str) -> dict:
    path = ARB_DIR / f"app_{locale}.arb"
    if not path.exists():
        print(f"error: {path} not found", file=sys.stderr)
        sys.exit(2)
    with path.open() as f:
        return json.load(f)


def keys(data: dict) -> set[str]:
    return {k for k in data if not k.startswith("@")}


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--fix",
        action="store_true",
        help="remove orphan keys from non-base locales (preserves order in base)",
    )
    args = parser.parse_args()

    base_data = load(BASE)
    base_keys = keys(base_data)

    issues = 0
    for locale in LOCALES:
        if locale == BASE:
            continue
        data = load(locale)
        loc_keys = keys(data)

        missing = sorted(base_keys - loc_keys)
        orphan = sorted(loc_keys - base_keys)

        if missing:
            issues += len(missing)
            print(f"\n[{locale}] missing {len(missing)} key(s) present in {BASE}:")
            for k in missing:
                print(f"  - {k}")

        if orphan:
            issues += len(orphan)
            print(f"\n[{locale}] orphan {len(orphan)} key(s) not in {BASE}:")
            for k in orphan:
                print(f"  - {k}")

            if args.fix:
                for k in orphan:
                    data.pop(k, None)
                    data.pop(f"@{k}", None)
                path = ARB_DIR / f"app_{locale}.arb"
                with path.open("w") as f:
                    json.dump(data, f, ensure_ascii=False, indent=2)
                    f.write("\n")
                print(f"  -> removed {len(orphan)} orphan(s) from {path}")

    if issues == 0:
        print(f"OK: all {len(LOCALES)} locales aligned ({len(base_keys)} keys)")
        return 0

    print(f"\nFAIL: {issues} key issue(s) across locales", file=sys.stderr)
    return 1


if __name__ == "__main__":
    sys.exit(main())
