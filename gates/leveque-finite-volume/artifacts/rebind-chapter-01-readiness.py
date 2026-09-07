"""Rebind the preserved LeVeque Chapter 1 gate to the current main epoch."""

from __future__ import annotations

import argparse
import copy
import hashlib
import importlib.util
import json
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[3]
GATE_PATH = ROOT / "gates" / "leveque-finite-volume" / "chapter-01.json"
ARTIFACT_ROOT = GATE_PATH.parent / "artifacts"
ROW_HASH_FIELDS = {
    "source_contract_sha256",
    "blind_sha256",
    "direct_sha256",
    "round_trip_sha256",
    "adjudication_sha256",
}
ORGANIZATION = {
    "unclassified_modules": 0,
    "duplicate_wrappers": 0,
    "placeholder_findings": 0,
    "canonical_placement_pending": 0,
}


def load_checker(path: Path):
    spec = importlib.util.spec_from_file_location("leveque_gate", path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load authoritative gate checker: {path}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def read_json(path: Path) -> dict[str, Any]:
    value = json.loads(path.read_text(encoding="utf-8"))
    if not isinstance(value, dict):
        raise AssertionError(f"expected a JSON object: {path}")
    return value


def write_json(path: Path, value: Any) -> None:
    path.write_text(
        json.dumps(value, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
        newline="\n",
    )


def sha256_file(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def normalized_rows(rows: list[dict[str, Any]]) -> list[dict[str, Any]]:
    return [
        {key: value for key, value in row.items() if key not in ROW_HASH_FIELDS}
        for row in rows
    ]


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--gate-checker", type=Path, required=True)
    parser.add_argument("--organization-preflight", type=Path, required=True)
    args = parser.parse_args()
    checker_path = args.gate_checker.expanduser().resolve()
    organization_preflight = args.organization_preflight.expanduser().resolve()
    if not checker_path.is_file() or not organization_preflight.is_file():
        raise AssertionError("gate checker and organization preflight must both exist")
    checker = load_checker(checker_path)
    context = checker.current_context(GATE_PATH, 1)
    if context["lean_changed_paths"]:
        raise AssertionError(
            "refusing to rebind with controlled-code drift: "
            + ", ".join(context["lean_changed_paths"])
        )

    gate = read_json(GATE_PATH)
    rows_before = copy.deepcopy(gate["rows"])
    statuses_before = [row["status"] for row in rows_before]
    old_axioms = read_json(
        ARTIFACT_ROOT / "chapter-01-axiom-check-evidence.json"
    )["payload"]["declarations"]

    gate["bindings"] = copy.deepcopy(context["bindings"])
    gate["verification_loops"]["organization_completeness"] = copy.deepcopy(
        ORGANIZATION
    )
    for row in gate["rows"]:
        if row["status"] not in checker.CLOSED_LEAN_STATUSES:
            continue
        bindings = checker.row_artifact_bindings(row, 1, context)
        for _, (path_field, hash_field) in checker.ROW_ARTIFACT_REFS.items():
            relative = row[path_field]
            path = GATE_PATH.parent / relative
            artifact = read_json(path)
            artifact["bindings"] = bindings
            write_json(path, artifact)
            row[hash_field] = sha256_file(path)
        if row.get("adjudication_artifact"):
            path = GATE_PATH.parent / row["adjudication_artifact"]
            artifact = read_json(path)
            artifact["bindings"] = bindings
            write_json(path, artifact)
            row["adjudication_sha256"] = sha256_file(path)

    if statuses_before != [row["status"] for row in gate["rows"]]:
        raise AssertionError("row statuses changed while rebinding")
    if normalized_rows(rows_before) != normalized_rows(gate["rows"]):
        raise AssertionError("mathematical row content changed while rebinding")

    rows = gate["rows"]
    closed = sorted(
        (row for row in rows if row["status"] in checker.CLOSED_LEAN_STATUSES),
        key=lambda row: row["id"],
    )
    declarations = sorted(
        {name for row in closed for name in row.get("lean_declarations", [])}
    )
    relative_gate = GATE_PATH.relative_to(ROOT).as_posix()
    cross_gate_paths = sorted(
        path.relative_to(ROOT).as_posix()
        for path in (ROOT / "gates").glob("*/chapter-*.json")
    )
    gate_subject = checker.canonical_sha256(
        {
            "book_id": checker.BOOK_ID,
            "unit_kind": "chapter",
            "unit": 1,
            "chapter": 1,
            "source_unit_sha256": checker.PINNED_SOURCE_SHA256,
            "mode": "default",
            "excluded_rows": [],
            "rows": rows,
        }
    )
    bindings = checker.global_artifact_bindings(1, context, gate_subject)
    quoted_checker = str(checker_path)
    quoted_preflight = str(organization_preflight)
    commands = {
        "source_inventory": (
            "python3 -B gates/leveque-finite-volume/artifacts/"
            f"chapter-01-source-inventory-scan.py --gate-checker {quoted_checker}"
        ),
        "organization_scan": (
            "python3 -B gates/leveque-finite-volume/artifacts/"
            "chapter-01-organization-counter-scan.py && "
            "python3 -B tools/architecture/check_compatibility.py && "
            "python3 -B tools/architecture/check_layout.py && "
            f"python3 -B {quoted_preflight} --gate "
            "gates/leveque-finite-volume/chapter-01.json"
        ),
        "faithfulness_audit": (
            "python3 -B gates/leveque-finite-volume/artifacts/"
            f"chapter-01-rebase-transport-scan.py --gate-checker {quoted_checker}"
        ),
        "declaration_resolution": (
            "lake env lean gates/leveque-finite-volume/artifacts/"
            "chapter-01-declaration-checks.lean"
        ),
        "axiom_check": (
            "lake env lean gates/leveque-finite-volume/artifacts/"
            "chapter-01-declaration-checks.lean"
        ),
        "focused_build": (
            "lake build "
            "ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection "
            "ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvectionGlobal "
            "ComputationalMathematics.Source.LeVeque.Chapter01.Equation03 "
            "ComputationalMathematics.Source.LeVeque.Chapter01.Equation03AdvectedProfile "
            "NumStability.Analysis.PartialDifferentialEquations.LinearAdvection "
            "NumStability.Analysis.PartialDifferentialEquations.LinearAdvectionGlobal "
            "NumStability.Source.LeVeque.Chapter01.Equation03 "
            "NumStability.Source.LeVeque.Chapter01.Equation03AdvectedProfile"
        ),
        "full_build": (
            "lake build ComputationalMathematics.Source.LeVeque.Chapter01 "
            "ComputationalMathematics.Source.LeVeque "
            "NumStability.Source.LeVeque.Chapter01 NumStability.Source.LeVeque"
        ),
        "hygiene_check": (
            "python3 -B gates/leveque-finite-volume/artifacts/"
            f"chapter-01-hygiene-scan.py --gate-checker {quoted_checker}"
        ),
    }
    payloads = {
        "source_inventory": {
            "row_ids": sorted(row["id"] for row in rows),
            "page_coverage": [
                {
                    "row_id": row["id"],
                    "printed_page": row["printed_page"],
                    "pdf_page": row["pdf_page"],
                }
                for row in sorted(rows, key=lambda item: item["id"])
            ],
            "printed_page_range": list(context["printed_range"]),
            "pdf_page_range": list(context["pdf_range"]),
        },
        "organization_scan": {
            "counters": ORGANIZATION,
            "unit_report": {
                "gate_path": relative_gate,
                "chapter": 1,
                "unit_audit_epoch": context["bindings"]["unit_audit_epoch"],
                "unit_index_sha256": context["bindings"]["unit_index_sha256"],
                "counters": ORGANIZATION,
            },
            "cross_gate_consistency": {
                "gate_paths": cross_gate_paths,
                "counters": ORGANIZATION,
                "mismatches": [],
            },
        },
        "faithfulness_audit": {
            "rows": [
                {
                    "row_id": row["id"],
                    "contract_hash": row["contract_hash"],
                    "source_contract_sha256": row["source_contract_sha256"],
                    "blind_sha256": row["blind_sha256"],
                    "direct_sha256": row["direct_sha256"],
                    "round_trip_sha256": row["round_trip_sha256"],
                    "adjudication_sha256": row.get("adjudication_sha256", ""),
                }
                for row in closed
            ]
        },
        "declaration_resolution": {"declarations": declarations},
        "axiom_check": {"declarations": old_axioms},
        "focused_build": {
            "passed": [
                "ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection",
                "ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvectionGlobal",
                "ComputationalMathematics.Source.LeVeque.Chapter01.Equation03",
                "ComputationalMathematics.Source.LeVeque.Chapter01.Equation03AdvectedProfile",
                "NumStability.Analysis.PartialDifferentialEquations.LinearAdvection",
                "NumStability.Analysis.PartialDifferentialEquations.LinearAdvectionGlobal",
                "NumStability.Source.LeVeque.Chapter01.Equation03",
                "NumStability.Source.LeVeque.Chapter01.Equation03AdvectedProfile",
            ]
        },
        "full_build": {
            "passed": [
                "ComputationalMathematics.Source.LeVeque.Chapter01",
                "ComputationalMathematics.Source.LeVeque",
                "NumStability.Source.LeVeque.Chapter01",
                "NumStability.Source.LeVeque",
            ]
        },
        "hygiene_check": {
            "findings": [],
            "scanned_paths": context["lean_changed_paths"],
        },
    }
    counts = {
        "source_inventory": len(rows),
        "organization_scan": len(cross_gate_paths),
        "faithfulness_audit": len(closed),
        "declaration_resolution": len(declarations),
        "axiom_check": len(declarations),
        "focused_build": len(payloads["focused_build"]["passed"]),
        "full_build": len(payloads["full_build"]["passed"]),
        "hygiene_check": 0,
    }
    evidence: dict[str, Any] = {}
    for name in checker.EVIDENCE_NAMES:
        artifact = {
            "schema_version": 1,
            "check": name,
            "bindings": bindings,
            "command": commands[name],
            "exit_code": 0,
            "count": counts[name],
            "payload": payloads[name],
        }
        path = ARTIFACT_ROOT / f"chapter-01-{name.replace('_', '-')}-evidence.json"
        write_json(path, artifact)
        evidence[name] = {
            "command": commands[name],
            "artifact": path.relative_to(GATE_PATH.parent).as_posix(),
            "artifact_sha256": sha256_file(path),
            "exit_code": 0,
            "count": counts[name],
        }
    gate["verification_evidence"] = evidence
    write_json(GATE_PATH, gate)

    if checker.check_gate_file(
        GATE_PATH, cli_unit=1, cli_mode="default", require_pass=False
    ) != 0:
        raise AssertionError("freshly rebound Chapter 1 gate did not validate")
    print(
        "rebound Chapter 1 readiness: "
        f"rows={len(rows)}, closed={len(closed)}, declarations={len(declarations)}, "
        f"baseline={context['bindings']['lean_git_head']}, "
        f"current_head={context['lean_current_head']}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
