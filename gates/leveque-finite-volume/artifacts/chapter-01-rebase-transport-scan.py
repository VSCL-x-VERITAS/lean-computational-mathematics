"""Verify that the Chapter 1 gate was transported without semantic drift."""

from __future__ import annotations

import argparse
import importlib.util
import json
import subprocess
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[3]
GATE_PATH = ROOT / "gates" / "leveque-finite-volume" / "chapter-01.json"
CLOSED_ROW_ID = "LEV-CH01-EQ-1.3-ADVECTED-PROFILE"
AUDIT_DIRECTORY = (
    "gates/leveque-finite-volume/artifacts/"
    "LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL"
)
ROW_ARTIFACT_HASH_FIELDS = {
    "source_contract_sha256",
    "blind_sha256",
    "direct_sha256",
    "round_trip_sha256",
    "adjudication_sha256",
}


def load_checker(path: Path):
    spec = importlib.util.spec_from_file_location("leveque_gate", path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load authoritative gate checker: {path}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def git(*arguments: str, binary: bool = False):
    result = subprocess.run(
        ["git", *arguments],
        cwd=ROOT,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=not binary,
        check=False,
    )
    if result.returncode:
        detail = result.stderr if not binary else result.stderr.decode("utf-8", errors="replace")
        raise AssertionError(f"git {' '.join(arguments)} failed: {detail.strip()}")
    return result.stdout


def baseline_bytes(commit: str, relative: str) -> bytes:
    return git("show", f"{commit}:{relative}", binary=True)


def normalized_row(row: dict[str, Any]) -> dict[str, Any]:
    return {key: value for key, value in row.items() if key not in ROW_ARTIFACT_HASH_FIELDS}


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--gate-checker", type=Path, required=True)
    args = parser.parse_args()
    checker = load_checker(args.gate_checker.expanduser().resolve())
    context = checker.current_context(GATE_PATH, 1)
    baseline = context["bindings"]["lean_git_head"]
    if context["lean_changed_paths"]:
        raise AssertionError(
            "controlled code differs from the validated baseline: "
            + ", ".join(context["lean_changed_paths"])
        )

    current = json.loads(GATE_PATH.read_text(encoding="utf-8"))
    original = json.loads(
        baseline_bytes(baseline, GATE_PATH.relative_to(ROOT).as_posix()).decode("utf-8")
    )
    allowed_top_level = {
        "bindings",
        "verification_loops",
        "verification_evidence",
        "rows",
    }
    current_fixed = {key: value for key, value in current.items() if key not in allowed_top_level}
    original_fixed = {key: value for key, value in original.items() if key not in allowed_top_level}
    if current_fixed != original_fixed:
        raise AssertionError("non-derived Chapter 1 gate metadata changed during transport")
    current_loops = dict(current["verification_loops"])
    original_loops = dict(original["verification_loops"])
    current_organization = current_loops.pop("organization_completeness", None)
    original_loops.pop("organization_completeness", None)
    if current_loops != original_loops:
        raise AssertionError("non-organization verification loops changed during transport")
    if current_organization != {
        "unclassified_modules": 0,
        "duplicate_wrappers": 0,
        "placeholder_findings": 0,
        "canonical_placement_pending": 0,
    }:
        raise AssertionError("current organization counters are not the measured zero state")
    if len(current["rows"]) != len(original["rows"]):
        raise AssertionError("Chapter 1 row count changed during transport")
    for now, before in zip(current["rows"], original["rows"], strict=True):
        if normalized_row(now) != normalized_row(before):
            raise AssertionError(f"mathematical row changed during transport: {before.get('id')}")

    closed = [
        row for row in current["rows"]
        if row.get("status") in checker.CLOSED_LEAN_STATUSES
    ]
    if [row.get("id") for row in closed] != [CLOSED_ROW_ID]:
        raise AssertionError("the preserved closed-row set is not the audited Chapter 1 set")
    row = closed[0]
    for _, (path_field, _) in checker.ROW_ARTIFACT_REFS.items():
        relative = f"gates/leveque-finite-volume/{row[path_field]}"
        now = json.loads((ROOT / relative).read_text(encoding="utf-8"))
        before = json.loads(baseline_bytes(baseline, relative).decode("utf-8"))
        now.pop("bindings", None)
        before.pop("bindings", None)
        if now != before:
            raise AssertionError(f"prior semantic wrapper changed beyond bindings: {relative}")

    listed = git("ls-tree", "-r", "--name-only", baseline, "--", AUDIT_DIRECTORY)
    preserved = 0
    for relative in listed.splitlines():
        if Path(relative).name.startswith("gate-"):
            continue
        path = ROOT / relative
        if not path.is_file() or path.read_bytes() != baseline_bytes(baseline, relative):
            raise AssertionError(f"prior raw audit evidence changed: {relative}")
        preserved += 1
    if preserved == 0:
        raise AssertionError("no prior raw audit evidence was found at the baseline")

    canonical = ROOT / "ComputationalMathematics" / "Source" / "LeVeque" / "Chapter01.lean"
    compatibility = ROOT / "NumStability" / "Source" / "LeVeque" / "Chapter01.lean"
    if not canonical.is_file():
        raise AssertionError("canonical ComputationalMathematics Chapter 1 entry point is missing")
    compatibility_text = compatibility.read_text(encoding="utf-8")
    if "import ComputationalMathematics.Source.LeVeque.Chapter01" not in compatibility_text:
        raise AssertionError("NumStability Chapter 1 compatibility forwarder is broken")

    statuses: dict[str, int] = {}
    for item in current["rows"]:
        status = item["status"]
        statuses[status] = statuses.get(status, 0) + 1
    print(
        "Chapter 1 transport passed: "
        f"{len(current['rows'])} mathematical rows preserved; "
        f"statuses={json.dumps(statuses, sort_keys=True)}; "
        f"{preserved} raw audit artifacts byte-identical; "
        f"baseline={baseline}; current_head={context['lean_current_head']}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
