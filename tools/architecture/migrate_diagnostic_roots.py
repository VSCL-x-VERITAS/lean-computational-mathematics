#!/usr/bin/env python3
"""Translate current diagnostic paths using the reviewed production-module map.

Dry-run by default. This operation preserves every non-path field, including
captured environment provenance, source/message hashes, dispositions and ceilings.
It does not capture or accept new diagnostics.
"""
from __future__ import annotations

import argparse
import copy
import hashlib
import json
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[2]
DEFAULT_MAP = ROOT / "docs/migrations/lean-computational-mathematics/module-map.json"
BASELINES = {"warnings": "docs/architecture/warnings.json", "lint": "docs/architecture/lint.json"}


def module_for_path(path: str) -> str:
    if not path.endswith(".lean") or "\\" in path or any(part in ("", ".", "..") for part in path.split("/")):
        raise ValueError(f"invalid Lean source path: {path!r}")
    return path[:-5].replace("/", ".")


def path_mapping(manifest: dict[str, Any]) -> dict[str, str]:
    if manifest.get("schema_version") != 1 or manifest.get("old_root") != "NumStability" or manifest.get("canonical_root") != "ComputationalMathematics":
        raise ValueError("expected the reviewed NumStability to ComputationalMathematics module map")
    rows = manifest.get("implementation_modules")
    if not isinstance(rows, list) or not rows:
        raise ValueError("module map needs a nonempty implementation_modules list")
    paths: dict[str, str] = {}
    destinations: set[str] = set()
    for row in rows:
        old, new = row["old_path"], row["new_path"]
        if row["old_module"] != module_for_path(old) or row["new_module"] != module_for_path(new):
            raise ValueError(f"incoherent path/module map: {old}")
        if not (old == "NumStability.lean" or old.startswith("NumStability/")) or not (new == "ComputationalMathematics.lean" or new.startswith("ComputationalMathematics/")):
            raise ValueError(f"map leaves the approved roots: {old} -> {new}")
        if old in paths or new in destinations:
            raise ValueError(f"non-injective module map: {old} -> {new}")
        paths[old] = new
        destinations.add(new)
    return paths


def translate(document: dict[str, Any], kind: str, paths: dict[str, str]) -> tuple[dict[str, Any], int]:
    """Change only diagnostic locations, their census keys, and suppression paths."""
    if document.get("schema_version") != 1 or kind not in BASELINES:
        raise ValueError("unsupported diagnostic baseline schema or kind")
    result = copy.deepcopy(document)
    destinations = set(paths.values())
    changed = 0
    prior_paths: set[str] = set()
    migrated_paths: set[str] = set()

    def mapped(path: str) -> str:
        nonlocal changed
        module_for_path(path)
        if path in paths:
            prior_paths.add(path)
            changed += 1
            return paths[path]
        if path in destinations:
            migrated_paths.add(path)
            return path
        if path == "NumStabilityTest.lean" or path.startswith("NumStabilityTest/"):
            return path
        raise ValueError(f"diagnostic path has no exact approved mapping: {path}")

    rows = result["diagnostics" if kind == "warnings" else "findings"]
    for row in rows:
        if row["module"] != module_for_path(row["path"]):
            raise ValueError(f"diagnostic path/module mismatch: {row['path']}")
        row["path"] = mapped(row["path"])
        row["module"] = module_for_path(row["path"])
    by_file: dict[str, int] = {}
    for old, ceiling in result["ceilings"]["by_file"].items():
        new = mapped(old)
        if new in by_file:
            raise ValueError(f"diagnostic ceiling paths collide at {new}")
        by_file[new] = ceiling
    result["ceilings"]["by_file"] = dict(sorted(by_file.items()))
    if kind == "warnings":
        for row in result["suppressions"]:
            row["path"] = mapped(row["path"])
    if prior_paths and migrated_paths:
        raise ValueError("baseline mixes historical and canonical production paths; refusing a partial migration")
    return result, changed


def assert_inverse(original: dict[str, Any], translated: dict[str, Any], kind: str, paths: dict[str, str]) -> None:
    restored, _ = translate(translated, kind, {new: old for old, new in paths.items()})
    if restored != original:
        raise ValueError("inverse path translation did not reproduce the complete original baseline")


def self_test() -> None:
    paths = {"NumStability/Leaf.lean": "ComputationalMathematics/Leaf.lean"}
    for kind in BASELINES:
        field = "diagnostics" if kind == "warnings" else "findings"
        baseline = {
            "schema_version": 1, "normalization_version": 2,
            "capture": {"platform": "x86_64-unknown-linux-gnu", "command": "lake lint", "commit": "frozen"},
            "ceilings": {"by_file": {"NumStability/Leaf.lean": 1}, "global": 1},
            field: [{"path": "NumStability/Leaf.lean", "module": "NumStability.Leaf",
                     "declaration": "NumStability.retained", "message": "unchanged", "anchor_sha256": "original",
                     "disposition": "reviewed_deferred_migration", "evidence": {"line": 10}}],
        }
        if kind == "warnings":
            baseline["suppressions"] = [{"path": "NumStability/Leaf.lean", "anchor_sha256": "original"}]
        migrated, changed = translate(baseline, kind, paths)
        assert changed > 0
        assert_inverse(baseline, migrated, kind, paths)
        assert translate(migrated, kind, paths) == (migrated, 0)
        assert migrated["capture"] == baseline["capture"]
        assert migrated[field][0]["declaration"] == "NumStability.retained"
        for mutation in ("unmapped", "collision", "module"):
            bad = copy.deepcopy(baseline)
            if mutation == "unmapped":
                bad["ceilings"]["by_file"] = {"NumStability/Missing.lean": 1}
            elif mutation == "collision":
                bad["ceilings"]["by_file"]["ComputationalMathematics/Leaf.lean"] = 1
            else:
                bad[field][0]["module"] = "NumStability.Other"
            try:
                translate(bad, kind, paths)
            except ValueError:
                pass
            else:
                raise AssertionError(f"{kind}: accepted {mutation}")
    row = {"old_path": "NumStability/Leaf.lean", "new_path": "ComputationalMathematics/Leaf.lean",
           "old_module": "NumStability.Leaf", "new_module": "ComputationalMathematics.Leaf"}
    manifest = {"schema_version": 1, "old_root": "NumStability", "canonical_root": "ComputationalMathematics",
                "implementation_modules": [row, row]}
    try:
        path_mapping(manifest)
    except ValueError:
        pass
    else:
        raise AssertionError("accepted a duplicate implementation mapping")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--module-map", type=Path, default=DEFAULT_MAP)
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--self-test", action="store_true")
    args = parser.parse_args()
    if args.self_test:
        self_test()
        print("diagnostic root migration self-test passed: exact inverse, idempotence, preserved fields and rejected drift")
        return 0
    raw_map = args.module_map.read_bytes()
    paths = path_mapping(json.loads(raw_map))
    prepared: list[tuple[Path, bytes, bytes, dict[str, Any]]] = []
    for kind, relative in BASELINES.items():
        path = ROOT / relative
        before = path.read_bytes()
        original = json.loads(before)
        translated, changes = translate(original, kind, paths)
        if changes:
            assert_inverse(original, translated, kind, paths)
        after = (json.dumps(translated, ensure_ascii=False, indent=2, sort_keys=True) + "\n").encode("utf-8") if changes else before
        record = {
            "baseline": relative, "path_references_changed": changes,
            "records": len(original["diagnostics" if kind == "warnings" else "findings"]),
            "before_sha256": hashlib.sha256(before).hexdigest(), "after_sha256": hashlib.sha256(after).hexdigest(),
        }
        prepared.append((path, before, after, record))
    # Prepare and validate both documents before writing either one.
    if args.write:
        for path, before, _, _ in prepared:
            if path.read_bytes() != before:
                raise ValueError(f"baseline changed during preparation: {path}")
        for path, _, after, _ in prepared:
            path.write_bytes(after)
    print(json.dumps({"write": args.write, "module_map_sha256": hashlib.sha256(raw_map).hexdigest(),
                      "baselines": [record for _, _, _, record in prepared]}, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
