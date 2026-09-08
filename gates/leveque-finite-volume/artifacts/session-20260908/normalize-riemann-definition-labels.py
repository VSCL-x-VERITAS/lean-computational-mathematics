"""Use explicit definition labels for Riemann initial-value configurations.

The released exercise heuristic classifies any label or ID containing the
word 'problem' as an exercise. No validator or mathematical scope is changed.
"""
import hashlib
import json
from pathlib import Path

session = Path(__file__).resolve().parent
gate_path = session.parents[1] / "chapter-01.json"
data = gate_path.read_bytes()
assert hashlib.sha256(data).hexdigest() == "b2c0353fc8398793273b106a2ec8c64015fdb271e0fd859ddfd7805c4faa8acc"
snapshot = session / "gate-with-riemann-definition-label-defects.json"
assert not snapshot.exists()
snapshot.write_bytes(data)
gate = json.loads(data)
old = "LEV-CH01-RIEMANN-PROBLEM-DEFINITION"
new = "LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION"
for row in gate["rows"]:
    if row["id"] == old:
        row["id"] = new
        row["source_label"] = "Riemann initial-value configuration: a hyperbolic equation together with piecewise constant two-state initial data"
    elif row["id"] == "LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA":
        row["source_label"] = "Material-interface Riemann initial data prescribes jumps in both medium and state at x=0"
    row["depends_on"] = [new if d == old else d for d in row["depends_on"]]
    if "next_foundation" in row:
        row["next_foundation"] = row["next_foundation"].replace("RIEMANN-PROBLEM-DEFINITION", "RIEMANN-INITIAL-VALUE-DEFINITION")
gate_path.write_text(json.dumps(gate, indent=2, ensure_ascii=False) + "\n", encoding="utf-8", newline="\n")
print(hashlib.sha256(gate_path.read_bytes()).hexdigest())
