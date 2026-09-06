"""Extract and check the repository-wide organization counters for Chapter 1."""

from __future__ import annotations

import importlib.util
import json
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[3]
TOOLS = ROOT / "tools" / "architecture"
GATE_PATH = ROOT / "gates" / "leveque-finite-volume" / "chapter-01.json"
EXPECTED = {
    "unclassified_modules": 0,
    "duplicate_wrappers": 0,
    "placeholder_findings": 0,
    "canonical_placement_pending": 0,
}
LEVEQUE_MODULES = {
    "NumStability.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem",
    "NumStability.Analysis.PartialDifferentialEquations.LinearAdvection",
    "NumStability.Analysis.PartialDifferentialEquations.LinearAdvectionGlobal",
    "NumStability.Source.LeVeque",
    "NumStability.Source.LeVeque.Chapter01",
    "NumStability.Source.LeVeque.Chapter01.Equation01",
    "NumStability.Source.LeVeque.Chapter01.Equation02",
    "NumStability.Source.LeVeque.Chapter01.Equation03",
    "NumStability.Source.LeVeque.Chapter01.Equation03AdvectedProfile",
}


def load_layout():
    sys.path.insert(0, str(TOOLS))
    spec = importlib.util.spec_from_file_location("check_layout", TOOLS / "check_layout.py")
    if spec is None or spec.loader is None:
        raise RuntimeError("cannot load the repository layout checker")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def main() -> int:
    layout = load_layout()
    _, modules = layout.scan_sources(ROOT)
    by_name = {module.name: module for module in modules}
    assignment, unclassified = layout.tier_assignments(modules)
    debt, _duplicate_imports = layout.current_debt(modules, assignment, unclassified)

    placeholder_paths = []
    scan_paths = [ROOT / module.path for module in modules]
    scan_paths.append(ROOT / "NumStabilityTest.lean")
    scan_paths.extend(sorted((ROOT / "NumStabilityTest").rglob("*.lean")))
    for path in scan_paths:
        source = path.read_text(encoding="utf-8-sig", errors="replace")
        if layout.has_placeholder(source):
            placeholder_paths.append(path.relative_to(ROOT).as_posix())

    placement_modules = sorted(
        set(debt["noncanonical_modules"]) | set(debt["mixed_modules"])
    )
    placement_counts = {}
    for name in placement_modules:
        module = by_name[name]
        source = (ROOT / module.path).read_text(encoding="utf-8-sig", errors="replace")
        placement_counts[name] = len(
            layout.DECL_RE.findall(layout.remove_lean_comments(source))
        )

    actual = {
        "unclassified_modules": len(unclassified),
        "duplicate_wrappers": 0,
        "placeholder_findings": len(placeholder_paths),
        "canonical_placement_pending": sum(placement_counts.values()),
    }
    assert actual == EXPECTED
    assert not debt["noncanonical_modules"]
    assert not debt["mixed_modules"]
    assert not placement_modules
    assert not placement_counts
    assert not placeholder_paths

    assert LEVEQUE_MODULES <= set(by_name)
    for name in LEVEQUE_MODULES:
        assert name in assignment
        assert assignment[name] != "mixed"
        assert name not in debt["noncanonical_modules"]
        source = (ROOT / by_name[name].path).read_text(
            encoding="utf-8-sig", errors="replace"
        )
        assert not layout.has_placeholder(source)

    gate = json.loads(GATE_PATH.read_text(encoding="utf-8"))
    recorded = gate["verification_loops"]["organization_completeness"]
    assert recorded == actual
    print(
        "organization counters passed: "
        + json.dumps(actual, sort_keys=True)
        + f"; {len(modules)} classified canonical modules; "
        "current LeVeque delta is 0/0/0/0"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
