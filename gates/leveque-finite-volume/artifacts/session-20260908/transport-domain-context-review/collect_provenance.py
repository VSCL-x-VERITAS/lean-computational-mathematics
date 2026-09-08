"""Read-only input collection; writes only this new evidence directory."""
from pathlib import Path
import datetime
import hashlib
import json
import subprocess

HERE = Path(__file__).resolve().parent
SESSION = HERE.parent
REPO = SESSION.parents[3]
WORKSPACE = REPO.parent
VIEWS = WORKSPACE / "workflow-v5.0.1-local/chapter01-source-review"
AUDIT = SESSION / "audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness"
NAV = VIEWS / "full-book-navigation.txt"

def digest(path):
    data = path.read_bytes()
    return {"path": str(path), "sha256": hashlib.sha256(data).hexdigest(), "bytes": len(data)}

def write_json(name, value):
    (HERE / name).write_bytes((json.dumps(value, ensure_ascii=False, indent=2) + "\n").encode("utf-8"))

patterns = [
    ("navigation-local-integrability", ["rg", "-n", "-i", "locally integrable|locally.{0,40}integrab", str(NAV)]),
    ("navigation-bounded-measurability", ["rg", "-n", "-i", "bounded measurable|essentially bounded", str(NAV)]),
    ("navigation-smooth-profile", ["rg", "-n", "-i", "any smooth function", str(NAV)]),
    ("navigation-profile-language", ["rg", "-n", "-i", "any function|arbitrary function", str(NAV)]),
    ("library-exact-domain", ["rg", "-n", "iff.*travelingWave|travelingWave.*iff|characteristic.*constant|constant.*characteristic", str(REPO / "ComputationalMathematics/Analysis/PartialDifferentialEquations")]),
]
runs = []
for label, command in patterns:
    proc = subprocess.run(command, cwd=WORKSPACE, capture_output=True)
    stdout = HERE / (label + ".stdout.txt")
    stderr = HERE / (label + ".stderr.txt")
    stdout.write_bytes(proc.stdout)
    stderr.write_bytes(proc.stderr)
    runs.append({"label": label, "argv": command, "cwd": str(WORKSPACE), "exit_code": proc.returncode,
                 "stdout": digest(stdout), "stderr": digest(stderr), "meaning": "rg exit 1 means no matched text, not exhaustive semantic absence"})
write_json("search-runs.json", runs)

page_images = [
    ("page-023.png", 23, 1, "Chapter 1, (1.2)-(1.3), arbitrary-profile wording"),
    ("page-026.png", 26, 4, "Section 1.1.2, (1.10), smooth differential/integral relation"),
    ("page-027.png", 27, 5, "Section 1.1.2, discontinuities and Riemann data"),
    ("domain-context-037.png", 37, 15, "Chapter 2 opening, tracer mass (2.1)"),
    ("domain-context-038.png", 38, 16, "Chapter 2, flux and integral law (2.2)-(2.7)"),
    ("domain-context-039.png", 39, 17, "Smoothness before PDE (2.8)-(2.12); smooth-profile sentence begins"),
    ("domain-context-040.png", 40, 18, "Section 2.1, smooth-profile sentence, (2.13)-(2.15)"),
    ("weak-context-237.png", 237, 215, "Section 11.11, (11.30)-(11.33), Definition 11.1"),
    ("weak-context-238.png", 238, 216, "Section 11.11 continuation; Section 11.12 opening"),
]
pages = [{**digest(VIEWS / name), "raw_pdf_page_one_based": raw, "printed_page": printed,
          "locator": locator, "actually_viewed_via_view_image": True} for name, raw, printed, locator in page_images]
inputs = [
    SESSION / "source/LeVeque_Finite_Volume_Methods_for_Hyperbolic_Problems_2002.pdf",
    NAV, AUDIT / "decision.json", AUDIT / "report.md", AUDIT / "agent_outputs/adjudicator.json",
    REPO / "ComputationalMathematics/Source/LeVeque/Chapter01/Equation03TransportSolution.lean",
    REPO / "ComputationalMathematics/Analysis/PartialDifferentialEquations/Transport/Characteristics.lean",
    REPO / "ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaws/TravelingWaveCharacterization.lean",
    REPO / "ComputationalMathematics/Analysis/PartialDifferentialEquations/Transport/UniformAdvection.lean",
    REPO / "AGENTS.md", REPO / "lean-toolchain", REPO / "lake-manifest.json",
]
provenance = {"task": "Bounded contextual-domain analysis, not an audit or verdict", "generated_utc": datetime.datetime.now(datetime.timezone.utc).isoformat(),
              "source_sha256_expected": "b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5",
              "source_facts_policy": "Only actually viewed pinned-PDF renderings; navigation text is search only",
              "inputs": [digest(path) for path in inputs], "views": pages,
              "runtime": {"python": __import__("sys").version, "native_lean_executed": False, "reason": "Read-only contextual analysis; no new declarations or proofs"},
              "writes": "Only transport-domain-context-review, no production/audit/gate/Git mutations"}
assert provenance["inputs"][0]["sha256"] == provenance["source_sha256_expected"]
write_json("input-provenance.json", provenance)
print(json.dumps({"search_exit_codes": {r["label"]: r["exit_code"] for r in runs}, "source_sha256": provenance["inputs"][0]["sha256"], "provenance": digest(HERE / "input-provenance.json")}, indent=2))
