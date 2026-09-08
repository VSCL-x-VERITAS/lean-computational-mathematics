from pathlib import Path
import hashlib
import json

here = Path(__file__).resolve().parent
def digest(path):
    data = path.read_bytes()
    return {"path": str(path), "sha256": hashlib.sha256(data).hexdigest(), "bytes": len(data)}

provenance = json.loads((here / "input-provenance.json").read_text(encoding="utf-8"))
for item in provenance["inputs"] + provenance["views"]:
    assert digest(Path(item["path"]))["sha256"] == item["sha256"], item["path"]
collector_exit = json.loads((here / "collect-provenance.exit.json").read_text(encoding="utf-8-sig"))
assert collector_exit["exit_code"] == 0
searches = json.loads((here / "search-runs.json").read_text(encoding="utf-8"))
assert all(item["exit_code"] in (0, 1) for item in searches)
excluded = {"final-receipt.json", "freeze.stdout.txt", "freeze.exit.json"}
receipt = {
    "kind": "additive-contextual-analysis-evidence",
    "scope": "Read-only source/library analysis; no audit verdict",
    "protected_inputs_rehashed_unchanged": True,
    "collector_actual_exit_code": collector_exit["exit_code"],
    "search_actual_exit_codes": {item["label"]: item["exit_code"] for item in searches},
    "lean_executed": False,
    "artifacts": [digest(path) for path in sorted(here.iterdir()) if path.is_file() and path.name not in excluded],
    "receipt_self_hash_and_terminal_exit": "Printed by freeze_evidence.py and recorded separately by the native PowerShell invocation",
}
(here / "final-receipt.json").write_bytes((json.dumps(receipt, ensure_ascii=False, indent=2) + "\n").encode("utf-8"))
print(json.dumps({"report": digest(here / "context-review.md"), "provenance": digest(here / "input-provenance.json"), "receipt": digest(here / "final-receipt.json"), "all_inputs_unchanged": True}, indent=2))
