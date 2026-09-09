"""Freeze this artifact-only scaffold after its actual preparation command."""
import hashlib
import json
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(r"\\?\C:\Users\qed_s\OneDrive\Documents\ChatGPT\VSCL-x-VERITAS\lean-computational-mathematics")
P = ROOT / "gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/riemann-certified-context-successor-preparation"


def ref(path):
    raw = path.read_bytes()
    return {"path": path.relative_to(ROOT).as_posix(), "sha256": hashlib.sha256(raw).hexdigest(), "bytes": len(raw)}


def load(path):
    return json.loads(path.read_text(encoding="utf-8"))


def put(name, data):
    with (P / name).open("xb") as stream:
        stream.write((json.dumps(data, indent=2, ensure_ascii=False) + "\n").encode("utf-8"))


provenance = load(P / "input-provenance.json")
for expected in provenance["verified_inputs"]:
    actual = ref(ROOT / expected["path"])
    assert actual["sha256"] == expected["sha256"], expected["path"]
actual_exit = load(P / "native-01-exit.json")
assert actual_exit["exit_code"] == 0
assert (P / "native-01-stderr.txt").read_bytes() == b""
assert "PASS_ARTIFACT_SCAFFOLD_ONLY" in (P / "native-01-output.txt").read_text(encoding="utf-8")
context = load(P / "source-context.template.json")
spec = load(P / "audit-spec.template.json")
proposal = load(P / "helper-extension-proposal.json")
assert not context["operational"] and not spec["operational"] and not proposal["operational"]
assert context["future_literal_info_receipt_ref"] is None
assert context["future_literal_question_item_id"] is None
assert spec["future_source_context_extension_ref"] is None
assert not proposal["implemented"]
assert not (P / "audit-spec.json").exists()
assert not (P / "source-context-extension.json").exists()
files = [ref(x) for x in sorted(P.iterdir()) if x.is_file() and x.name not in {"manifest.json", "receipt.json"}]
put("manifest.json", {
    "schema": 1, "kind": "immutable-nonoperational-context-scaffold",
    "operational": False, "source_acceptance": False,
    "created_at_utc": datetime.now(timezone.utc).isoformat(),
    "files": files,
})
receipt = {
    "schema": 1, "result": "FROZEN_PREPARATION_ONLY", "operational": False,
    "source_acceptance": False, "new_literal_adoption": False,
    "manifest": ref(P / "manifest.json"),
    "native_preparation_receipt": ref(P / "native-01-exit.json"),
    "native_preparation_actual_exit": actual_exit["exit_code"],
    "source_context_template": ref(P / "source-context.template.json"),
    "audit_spec_template": ref(P / "audit-spec.template.json"),
    "helper_extension_proposal": ref(P / "helper-extension-proposal.json"),
    "review": ref(P / "REVIEW.md"),
    "pending": ["Actual literal Info reply and root-reviewed receipt", "Final context/spec and narrow helper pins after that reply", "Fresh independent audit and any subsequent binding"],
    "not_executed": ["Lean build", "released preparation", "audit roles", "gate binding", "Git operation"],
}
put("receipt.json", receipt)
print(json.dumps({"receipt": ref(P / "receipt.json"), "manifest": receipt["manifest"], "files": len(files)}))
