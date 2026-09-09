"""Copy exact proposal bytes and capture isolation inputs. No repository mutations."""
import ast
import hashlib
import json
import re
from pathlib import Path

ROOT = Path(r"\\?\C:\Users\qed_s\OneDrive\Documents\ChatGPT\VSCL-x-VERITAS\lean-computational-mathematics")
D = ROOT / "gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908"
P = D / "dim-five-owner-overlay"
O = P / "overlay"
pins = {}


def ref(path, expected=None):
    data = path.read_bytes()
    value = {"path": path.relative_to(ROOT).as_posix(), "sha256": hashlib.sha256(data).hexdigest(), "bytes": len(data)}
    if expected is not None:
        assert value["sha256"] == expected, value
    pins[value["path"]] = value
    return value


def read(path):
    return json.loads(path.read_text(encoding="utf-8"))


def create(path, data):
    path.parent.mkdir(parents=True, exist_ok=True)
    if not isinstance(data, bytes):
        data = (json.dumps(data, indent=2, ensure_ascii=False) + "\n").encode("utf-8")
    with path.open("xb") as stream:
        stream.write(data)
    return ref(path)


def imports(data):
    result = []
    text = data.decode("utf-8")
    for found in re.finditer(r"(?m)^\s*(?:(?:public|private)\s+)?import\s+([^\n]+)", text):
        result.extend(re.findall(r"\b(?:ComputationalMathematics|Mathlib|Lean|Std|Init|Batteries|Aesop|Qq|Plausible|ImportGraph|ProofWidgets)(?:\.[A-Za-z_0-9]+)*", found[1].split("--")[0]))
    return list(dict.fromkeys(result))


proposal_ref = ref(D / "dim-blind-evidence-repair/five-owner-proposal.json", "7326cc0da682528a8e79630ed1d527a8f5079a640b06a444639549e4254bba8b")
review_ref = ref(D / "dim-blind-evidence-repair/ROOT-REVIEW.md", "06ba04c7496fc54e3ea24c85f0682f00e26795ca982bcf42b9403340734bf934")
inventory_ref = ref(D / "directional-high-resolution-production/production-files-frozen.json", "cb7623870ad874124148177f971a30c9e18e6b0172d2e21e59c6ae135f9c4538")
proposal = read(ROOT / proposal_ref["path"])
inventory = read(ROOT / inventory_ref["path"])
changed = {item["target_path"]: item for item in proposal["files"]}
assert len(changed) == 5 and len(inventory["files"]) == 16
owners = {}
copies = []
for item in inventory["files"]:
    target = item["path"]
    original = ref(ROOT / target, item["sha256"])
    selected = original
    if target in changed:
        entry = changed[target]
        ref(ROOT / entry["current"]["path"], entry["current"]["sha256"])
        selected = ref(ROOT / entry["proposal"]["path"], entry["proposal"]["sha256"])
    copied = create(O / target, (ROOT / selected["path"]).read_bytes())
    assert copied["sha256"] == selected["sha256"]
    row = {"module": item["module"], "original": original, "selected": selected,
           "overlay_source": copied, "changed": target in changed,
           "declarations": item["declarations"], "imports": imports((O / target).read_bytes())}
    owners[item["module"]] = row
    copies.append(row)

affected = {name for name, row in owners.items() if row["changed"]}
while True:
    more = {name for name, row in owners.items() if any(dep in affected for dep in row["imports"])}
    if more <= affected:
        break
    affected |= more
assert len(affected) == 9, sorted(affected)
order = []
pending = set(affected)
while pending:
    ready = sorted(name for name in pending if not (set(owners[name]["imports"]) & pending))
    assert ready, "owner dependency cycle"
    order.extend(ready)
    pending -= set(ready)

# Trace all project imports used by the selected family. A stale project .olean
# outside the selected nine must not indirectly depend on an affected owner.
project = {}


def visit(name):
    if not name.startswith("ComputationalMathematics") or name in project:
        return
    path = ROOT / (name.replace(".", "/") + ".lean")
    source = ref(path)
    data = (O / source["path"]).read_bytes() if name in owners else path.read_bytes()
    deps = imports(data)
    project[name] = {"source": source, "imports": deps}
    base = ROOT / ".lake/build/lib/lean" / name.replace(".", "/")
    compiled = []
    for suffix in (".olean", ".olean.private", ".olean.server", ".ilean"):
        candidate = Path(str(base) + suffix)
        if candidate.is_file():
            compiled.append(ref(candidate))
    assert any(x["path"].endswith(".olean") for x in compiled), (name, "missing original olean")
    project[name]["compiled_before"] = compiled
    for dep in deps:
        visit(dep)


for name in owners:
    visit(name)
reverse = set(affected)
while True:
    more = {name for name, row in project.items() if set(row["imports"]) & reverse}
    if more <= reverse:
        break
    reverse |= more
assert reverse == affected, {"unexpected_affected_project_imports": sorted(reverse - affected)}

fixtures = []
for name, frozen_name, expected in [
    ("SourceJoint.lean", "sourcejoint01-SourceJoint.lean", "a4441d447568f45b6f5cd12a87cd278cf19c2760d9802fdf308f81428ac0e1f4"),
    ("CanonicalChecks.lean", "canonical01-CanonicalChecks.lean", "23719902d0c5b79f2b0e7f728ae1b0f9134ae26809186ff9fb743ef708586f67"),
]:
    src = D / "directional-high-resolution-production" / frozen_name
    frozen = ref(src, expected)
    current = ref(src.parent / name, expected)
    copied = create(O / name, src.read_bytes())
    fixtures.append({"name": name, "frozen": frozen, "current": current, "overlay": copied,
                     "axiom_commands": len(re.findall(r"(?m)^#print axioms\s", src.read_text(encoding="utf-8")))})

mathlib = []
for name, expected in [
    ("Defs", "793a1ca70881ed469c78feeb0724766b6a2d933e51a8fad5b9c87e67228c5711"),
    ("FTaylorSeries", "a507aab3122399fda58585255b66e44094ce06494ecec66dd279a7769e9740aa"),
]:
    mathlib.append(ref(ROOT / f".lake/packages/mathlib/Mathlib/Analysis/Calculus/ContDiff/{name}.lean", expected))
    mathlib.append(ref(ROOT / f".lake/packages/mathlib/.lake/build/lib/lean/Mathlib/Analysis/Calculus/ContDiff/{name}.olean"))
for name in ("lean-toolchain", "lake-manifest.json"):
    ref(ROOT / name)

probe = """import Lean
import ComputationalMathematics.Source.LeVeque.Chapter01.CoordinateHighResolutionMethods
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.HighResolutionAdvectionLine

open MeasureTheory NumStability.LocalConservationLaw NumStability.DirectionalLine
namespace OverlayIsolation
theorem smooth_definition {m : ℕ} (q : ℝ → ℝ → Fin m → ℝ)
    (flux : (Fin m → ℝ) → Fin m → ℝ) (states : Set (Fin m → ℝ)) (a b T : ℝ) :
    SmoothReferenceOn q flux states a b T ↔
      ContDiffOn ℝ ((⊤ : ℕ∞) : WithTop ℕ∞) (Function.uncurry q)
        (Set.Icc a b ×ˢ Set.Icc 0 T) ∧ RectangleReferenceOn q flux a b T ∧
        ∀ x ∈ Set.Icc a b, ∀ t ∈ Set.Icc 0 T, q x t ∈ states := Iff.rfl
theorem spatial_smooth_definition {m : ℕ} (q : ℝ → ℝ → Fin m → ℝ)
    (flux : ℝ → (Fin m → ℝ) → Fin m → ℝ) (states : Set (Fin m → ℝ)) (a b T : ℝ) :
    SpatialSmoothReferenceOn q flux states a b T ↔
      ContDiffOn ℝ ((⊤ : ℕ∞) : WithTop ℕ∞) (Function.uncurry q)
        (Set.Icc a b ×ˢ Set.Icc 0 T) ∧ SpatialRectangleReferenceOn q flux a b T ∧
        ∀ x ∈ Set.Icc a b, ∀ t ∈ Set.Icc 0 T, q x t ∈ states := Iff.rfl
theorem chosen_rate_unchanged {m : ℕ} (family : LineFamily m)
    (quality : family.HasControlledHighResolution) :
    family.stabilityRate quality = Classical.choose quality.stability := rfl
end OverlayIsolation
#check OverlayIsolation.smooth_definition
#print axioms OverlayIsolation.smooth_definition
#check OverlayIsolation.spatial_smooth_definition
#print axioms OverlayIsolation.spatial_smooth_definition
#check OverlayIsolation.chosen_rate_unchanged
#print axioms OverlayIsolation.chosen_rate_unchanged
#print NumStability.LocalConservationLaw.SmoothReferenceOn
#print NumStability.DirectionalLine.LineFamily.stabilityRate
"""
for name in sorted(owners):
    probe += f'#eval do IO.println ("RESOLVED {name} " ++ (← Lean.findOLean `{name}).toString)\n'
probe_ref = create(O / "IsolationProbe.lean", probe.encode("utf-8"))

create(P / "plan.json", {
    "schema": 1, "source_acceptance": False, "overlay_only": True,
    "proposal": proposal_ref, "root_review": review_ref, "production_inventory": inventory_ref,
    "owners": copies, "affected_modules_topological": order,
    "unchanged_modules": sorted(set(owners) - affected),
    "project_import_closure": project, "fixtures": fixtures, "isolation_probe": probe_ref,
    "mathlib_regularity_pins": mathlib,
    "all_read_inputs": sorted(pins.values(), key=lambda item: item["path"]),
})
print(json.dumps({"copied_owners": len(owners), "affected_order": order, "project_closure": len(project), "fixture_axiom_commands": {x["name"]: x["axiom_commands"] for x in fixtures}}))
