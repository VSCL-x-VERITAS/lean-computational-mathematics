#!/usr/bin/env python3
"""Refresh a sealed row's artifact bindings after an unrelated Lean change.

Every row artifact embeds `lean_worktree_sha256`, which the gate recomputes live
from the whole working tree. So a commit anywhere -- including one that does not
touch the audited declarations -- makes every previously sealed row stale. Fixing
that is routine maintenance, not a new judgment, and this tool draws the line
between the two:

  * `payload` is copied byte for byte. No semantic field moves.
  * `procedure` gains a lineage line naming the prior artifact's SHA-256, so the
    chain back to the original judgment stays auditable.
  * `bindings` are recomputed by `gate.py`'s own `row_artifact_bindings` against
    the row in its final form.

Legitimacy rests on a precondition this tool cannot check for you: the audited
Lean must not have changed. Establish that first, for instance with

    git diff <seal-commit>..HEAD -- <module containing the declarations>

coming back empty, and record that evidence. Refreshing these fields without
that proof would misrepresent an unaudited statement as audited.
"""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
from pathlib import Path

CHECKS = ("source-contract", "blind", "direct", "round-trip")


def load_gate_module(module_root: Path):
    spec = importlib.util.spec_from_file_location(
        "leveque_gate", module_root / "scripts" / "gate.py"
    )
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def json_bytes(value) -> bytes:
    return (
        json.dumps(value, sort_keys=True, separators=(",", ":"), ensure_ascii=False)
        + "\n"
    ).encode("utf-8")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--gate", required=True)
    parser.add_argument("--row", required=True)
    parser.add_argument("--module-root", default=(
        r"C:\Users\qed_s\OneDrive\Documents\ChatGPT\VSCL-x-VERITAS"
        r"\formalization-collaboration-v5.0.1\books\candidates"
        r"\leveque-finite-volume\module"
    ))
    parser.add_argument("--reason", required=True,
                        help="the evidence that the audited Lean is unchanged")
    parser.add_argument("--apply", action="store_true")
    args = parser.parse_args()

    gate_path = Path(args.gate).resolve()
    repo_root = gate_path.parent.parent.parent
    gate_module = load_gate_module(Path(args.module_root))
    gate = json.loads(gate_path.read_text(encoding="utf-8"))
    row = next((r for r in gate["rows"] if r["id"] == args.row), None)
    if row is None:
        raise SystemExit(f"no row {args.row!r} in {gate_path}")

    chapter = gate["chapter"]
    bindings = gate_module.row_artifact_bindings(
        row, chapter, gate_module.current_context(gate_path, chapter)
    )
    changed = []
    for check in CHECKS:
        field = check.replace("-", "_")
        rel = row.get(f"{field}_artifact")
        if not rel:
            raise SystemExit(f"{args.row}: no {check} artifact recorded")
        path = repo_root / "gates" / "leveque-finite-volume" / rel
        artifact = json.loads(path.read_text(encoding="utf-8"))
        prior = hashlib.sha256(path.read_bytes()).hexdigest()
        if artifact["bindings"] == bindings:
            continue
        artifact["procedure"] = (
            f"Worktree context refreshed only; the prior payload is preserved "
            f"byte for byte and no semantic judgment moved. Prior artifact "
            f"SHA-256 {prior}. Evidence that the audited Lean is unchanged: "
            f"{args.reason} "
        ) + artifact["procedure"]
        artifact["bindings"] = bindings
        blob = json_bytes(artifact)
        if args.apply:
            path.write_bytes(blob)
            row[f"{field}_sha256"] = hashlib.sha256(blob).hexdigest()
        changed.append(check)

    if args.apply and changed:
        gate_path.write_text(
            json.dumps(gate, indent=1, ensure_ascii=False) + "\n", encoding="utf-8"
        )
    verb = "rebound" if args.apply else "would rebind"
    print(f"{args.row}: {verb} {len(changed)} artifact(s): {', '.join(changed) or 'none'}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
