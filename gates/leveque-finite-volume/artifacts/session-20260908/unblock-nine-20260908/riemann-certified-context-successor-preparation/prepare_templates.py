"""Artifact-only preparation; never creates a runnable audit spec or adopted receipt."""
import ast
import hashlib
import json
from pathlib import Path

ROOT = Path(r"\\?\C:\Users\qed_s\OneDrive\Documents\ChatGPT\VSCL-x-VERITAS\lean-computational-mathematics")
SESSION = ROOT / "gates/leveque-finite-volume/artifacts/session-20260908"
D = SESSION / "unblock-nine-20260908"
OUT = D / "riemann-certified-context-successor-preparation"
verified = {}


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def ref(path, expected=None):
    assert path.is_file() and not path.is_symlink(), str(path)
    item = {"path": path.relative_to(ROOT).as_posix(), "sha256": digest(path)}
    if expected is not None:
        assert item["sha256"] == expected, item
    verified[item["path"]] = item
    return item


def bind(item):
    assert isinstance(item, dict) and set(item) == {"path", "sha256"}
    assert not Path(item["path"]).is_absolute() and ".." not in Path(item["path"]).parts
    return ref(ROOT / item["path"], item["sha256"])


def load(path):
    return json.loads(path.read_text(encoding="utf-8"))


def create(name, value):
    path = OUT / name
    data = value if isinstance(value, bytes) else (json.dumps(value, indent=2, ensure_ascii=False) + "\n").encode("utf-8")
    with path.open("xb") as stream:
        stream.write(data)
    return ref(path)


old_spec_path = D / "riemann-certified-audit-preparation/spec-01/audit-spec.json"
old_spec_ref = ref(old_spec_path, "67f1159ed1607bed8911cced889eb95d599b6fbd72b26b1cbebf2e91909e7493")
old_spec = load(old_spec_path)
old_context_ref = bind(old_spec["source_context_extension"])
old_context = load(ROOT / old_context_ref["path"])
bind(old_context["source"])
for image in old_context["images"]:
    bind({key: image[key] for key in ("path", "sha256")})
for item in old_context["interpretation_receipts"]:
    bind(item)

image_original = SESSION / "audits/LEV-CH01-FLUX-JACOBIAN-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/page-025.png"
image_ref = ref(image_original, "ba1b4e78f97dc8161b93e8faaf79f389e7e871756e6eb6352a6123a8b565f8f8")
image_copy = create("page-025.png", image_original.read_bytes())
render_root = ROOT.parent / "workflow-v5.0.1-local/chapter01-source-review"
render_comparisons = []
for number, expected in [(25, image_ref["sha256"])] + [(x["page"], x["sha256"]) for x in old_context["images"]]:
    path = render_root / f"page-{number:03}.png"
    assert path.is_file() and digest(path) == expected, (number, "preparer render differs")
    render_comparisons.append({"page": number, "path": str(path).removeprefix("\\\\?\\"), "sha256": expected})

inventory_ref = ref(D / "riemann-certified-production/production-files-frozen.json", "034d23abd186f3084cc06e7f11150f5cf29ad5f3e32e9c0d456fce2bce90cb41")
inventory = load(ROOT / inventory_ref["path"])
assert len(inventory["files"]) == 4
names = []
for item in inventory["files"]:
    bind({key: item[key] for key in ("path", "sha256")})
    names.extend(item["declarations"])
assert len(names) == len(set(names)) == 7
fp_ref = ref(D / "riemann-certified-fingerprints/additional-expression-fingerprints.json", "278939894dec87e922ec6946791e5cfd5289423b54082782c636f904aac18ffa")
fp = load(ROOT / fp_ref["path"])
assert fp["declaration_count"] == fp["authored_new_declaration_count"] == 7
assert {x["path"]: x["sha256"] for x in fp["files"]} == {x["path"]: x["sha256"] for x in inventory["files"]}
for value in old_spec["additional_supplement"].values():
    bind(value)
environment = load(ROOT / old_spec["additional_supplement"]["environment_config"]["path"])
for item in environment["environment_files"]:
    bind(item)
native_receipt_ref = ref(D / "riemann-certified-audit-preparation/full-02/receipt.json", "579043169ee1265554afd4e4a041d783a836bcdf67d7cf520df528ec559e1755")
native = load(ROOT / native_receipt_ref["path"])
assert native["exit_code"] == 0
for key in ("input", "input_snapshot", "output", "stderr"):
    bind(native[key])
text = (ROOT / native["output"]["path"]).read_text(encoding="utf-8")
for item in native["input_pins"]:
    bind(item)

prior_dir = SESSION / "audits" / old_spec["prior_task"]
prior_task_ref = ref(prior_dir / "audit-task.json")
prior_manifest_ref = ref(prior_dir / "faithfulness/manifest.json")
prior_task = load(ROOT / prior_task_ref["path"])
assert prior_task["source"]["locations"] == old_context["primary_locations"]
prior_config_ref = ref(SESSION / old_spec["prior_config"])
selection_ref = ref(D / "selected-interpretations.json", "cfde240a9dda9a58be99f85369b43e99003b0024c7147a33ffa8b071ca7dcf34")
completed_decision_ref = ref(SESSION / "audits/LEV-CH01-CERTIFIED-RIEMANN-ROUTINE-INTERFACE-PRODUCTION-20260908/faithfulness/decision.json", "0ac08662a5a89231c70add2f6706e855f86704a7d57206cff558d8f2addd0308")
decision = load(ROOT / completed_decision_ref["path"])
assert decision["accepted"] is False

helper_names = [
    "gate-helpers/qualified_row_support_v4.py",
    "gate-helpers/bind-qualified-row-v4.py",
    "gate-helpers/validate-closed-row-audits-v7.py",
    "prepare-successor-audit-with-source-context-long-paths.py",
]
helpers = [ref(D / name) for name in helper_names]
for item in helpers:
    ast.parse((ROOT / item["path"]).read_text(encoding="utf-8"))
assert helpers[-1]["sha256"] == "fc1afd7578e69927edca25788423334f3947b8d58e348b176ae0a1cd3d64318e"
for name in [
    "ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/LocalRiemannInformation.lean",
    "ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaws/Hyperbolicity.lean",
]:
    ref(ROOT / name)

context = json.loads(json.dumps(old_context))
context["inherited_locations"].append({
    "location": "raw PDF page 25; printed Chapter 1 page 3",
    "anchor": "Inherited first-paragraph definition of a hyperbolic constant-coefficient system by real eigenvalues and a complete independent real eigenvector family; Section 1.1, equations (1.8)-(1.9), and the immediately following sentence applying those matrix conditions to the flux Jacobian. This is governing-law context for the original interface workflow."
})
context["pages"] = [25, 26, 27, 28]
context["images"] = [{"page": 25, **image_copy}] + old_context["images"]
context_template = {
    "format": "nonoperational-info-context-template-1",
    "status": "AWAITING_ACTUAL_LITERAL_INFO_REPLY_AND_ROOT_REVIEW",
    "operational": False,
    "historical_context": old_context_ref,
    "context_with_existing_authority_only": context,
    "future_literal_info_receipt_ref": None,
    "future_literal_question_item_id": None,
    "completion_rule": "Only after an actual answer, root authors and freezes the exact literal receipt, reviews its scope, and creates a NEW context whose interpretation_receipts are the existing Eq1.10 receipt followed by that exact Info receipt. Never feed this template or a null/placeholder receipt to preparation."
}
context_template_ref = create("source-context.template.json", context_template)
task_id = "LEV-CH01-CERTIFIED-RIEMANN-INTERFACE-SCOPED-REFERENCE-PRODUCTION-20260908"
spec = json.loads(json.dumps(old_spec))
spec.update({"key": "certified-riemann-interface-scoped-reference", "task_id": task_id, "pages": "25,26,27,28"})
del spec["source_context_extension"]
spec_template = {
    "format": "nonoperational-info-audit-spec-template-1",
    "status": "AWAITING_ACTUAL_LITERAL_INFO_REPLY_AND_FINAL_CONTEXT",
    "operational": False,
    "proposed_task_id": task_id,
    "retained_spec": old_spec_ref,
    "spec_fields_except_final_context": spec,
    "future_source_context_extension_ref": None,
    "context_template": context_template_ref,
    "rule": "Root must create a NEW complete spec after actual scoped adoption and helper review. The completed predecessor decision is historical review evidence only; no old judgment may enter the role inputs."
}
create("audit-spec.template.json", spec_template)
assert context["primary_locations"] == old_context["primary_locations"]
assert context["inherited_locations"][:-1] == old_context["inherited_locations"]
assert context["interpretation_receipts"] == old_context["interpretation_receipts"]
assert spec["target"] == old_spec["target"] and spec["additional_supplement"] == old_spec["additional_supplement"]
assert spec["choice_id"] == old_spec["choice_id"] == "Q7"
assert set(context_template) != set(context) and "source_context_extension" not in spec_template

create("input-provenance.json", {
    "schema": 1, "source_acceptance": False, "operational": False,
    "source": old_context["source"], "original_spec": old_spec_ref,
    "original_context": old_context_ref, "page25_original": image_ref,
    "page25_copy": image_copy, "render_root_byte_comparisons": render_comparisons,
    "original_locator_predecessor": {"task": prior_task_ref, "manifest": prior_manifest_ref, "config": prior_config_ref},
    "historical_review_only_not_role_input": {"immediate_predecessor_decision": completed_decision_ref},
    "coordinator_selection": selection_ref,
    "unchanged_production": inventory_ref, "unchanged_fingerprints": fp_ref,
    "unchanged_native_supplement": old_spec["additional_supplement"],
    "retained_native_receipt": native_receipt_ref,
    "helpers_reviewed_not_modified": helpers,
    "verified_inputs": sorted(verified.values(), key=lambda item: item["path"]),
})
create("checks.json", {
    "schema": 1, "result": "PASS_ARTIFACT_SCAFFOLD_ONLY",
    "new_lean_checks": 0, "released_preparations": 0, "audit_roles": 0,
    "retained_native_actual_exit": native["exit_code"],
    "retained_probe_characters": len(text), "retained_probe_bytes": len(text.encode("utf-8")),
    "unchanged_owner_count": 4, "unchanged_authored_declarations": names,
    "unchanged_authored_count": 7, "unchanged_fingerprint_count": 7,
    "native_environment_refs_checked": len(environment["environment_files"]),
    "native_input_refs_checked": len(native["input_pins"]),
    "helper_syntax_checked": len(helpers),
    "checks": ["Original primary locator exact", "Old inherited locator retained verbatim", "Old Eq1.10 receipt retained alone", "Page 25 exact PNG and existing rendering match", "Pages 26-28 and source PDF unchanged", "Q7 selection and target/native supplement unchanged", "Four production owner bytes and seven fingerprints agree", "Original locator predecessor matches primary locations", "Template envelopes fail the existing exact context schema", "No operational spec or invented literal receipt exists"],
})
print(json.dumps({"result": "PASS_ARTIFACT_SCAFFOLD_ONLY", "verified_paths": len(verified), "owners": 4, "declarations": 7, "pending_literal_reply": True}))
