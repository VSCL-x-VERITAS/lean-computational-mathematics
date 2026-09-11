#!/usr/bin/env python3
"""Refresh the chapter gate's worktree binding without losing its rows.

`gate.py check` recomputes `bindings.lean_worktree_sha256` live from the whole
working tree, so any Lean commit makes the persisted value stale and every row
artifact that copied it stale with it. `gate.py init --force` recomputes the
binding correctly but writes a fresh template, discarding the rows.

This does the obvious safe thing: save the document, let `init --force`
recompute the header, then put the saved rows and verification state back and
keep only the freshly computed `bindings`. Nothing semantic moves; the row
artifacts still have to be rebound separately, which is what
`rebind_row_artifacts.py` is for.

Refusing conditions, because getting this wrong silently corrupts evidence:

  * the regenerated document must carry the same `chapter`, `unit` and
    `book_id`, or the template is for a different unit;
  * the row list must be non-empty before the refresh, so an already-empty gate
    cannot be quietly blessed;
  * a backup is always written first.
"""

from __future__ import annotations

import argparse
import json
import shutil
import subprocess
import sys
from pathlib import Path

CARRIED = (
    "rows",
    "chapter_gate",
    "plan_epoch",
    "excluded_rows",
    "verification_loops",
    "verification_evidence",
)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--gate", required=True)
    ap.add_argument("--unit", required=True)
    ap.add_argument("--module-root", required=True)
    ap.add_argument("--backup", required=True)
    ap.add_argument("--apply", action="store_true")
    args = ap.parse_args()

    gate_path = Path(args.gate)
    before = json.loads(gate_path.read_text(encoding="utf-8"))
    if not before.get("rows"):
        raise SystemExit("refusing: the gate has no rows to carry across")
    shutil.copy2(gate_path, args.backup)
    print(f"backed up {gate_path} -> {args.backup}")

    if not args.apply:
        print("dry run; pass --apply to rewrite the gate")
        return 0

    proc = subprocess.run(
        [
            sys.executable, "-X", "utf8",
            str(Path(args.module_root) / "scripts" / "gate.py"),
            "init", str(gate_path), "--unit", str(args.unit), "--force",
        ],
        capture_output=True, text=True, encoding="utf-8", errors="replace",
    )
    if proc.returncode != 0:
        shutil.copy2(args.backup, gate_path)
        raise SystemExit(f"gate.py init failed, gate restored:\n{proc.stdout}{proc.stderr}")

    after = json.loads(gate_path.read_text(encoding="utf-8"))
    for key in ("book_id", "chapter", "unit"):
        if after.get(key) != before.get(key):
            shutil.copy2(args.backup, gate_path)
            raise SystemExit(
                f"refusing: regenerated gate has {key}={after.get(key)!r} but the "
                f"saved one had {before.get(key)!r}; gate restored"
            )

    fresh = after["bindings"]["lean_worktree_sha256"]
    stale = before["bindings"]["lean_worktree_sha256"]
    for key in CARRIED:
        if key in before:
            after[key] = before[key]
    gate_path.write_text(
        json.dumps(after, indent=1, ensure_ascii=False) + "\n", encoding="utf-8"
    )
    print(f"lean_worktree_sha256 {stale[:16]}... -> {fresh[:16]}...")
    print(f"carried {len(before['rows'])} rows and the verification state")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
