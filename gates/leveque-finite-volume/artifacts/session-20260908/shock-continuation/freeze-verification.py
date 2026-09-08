"""Freeze the finished native check; never treat failed intermediate output as evidence."""
import argparse
import hashlib
import json
from pathlib import Path
import re

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[4]
ALLOWED = {"propext", "Classical.choice", "Quot.sound"}


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


parser = argparse.ArgumentParser()
parser.add_argument("--output", required=True)
parser.add_argument("--exit-record", required=True)
args = parser.parse_args()
source = HERE / "candidate.lean"
output = HERE / args.output
assert output.resolve().parent == HERE
exit_path = HERE / args.exit_record
assert exit_path.resolve().parent == HERE
exit_record = json.loads(exit_path.read_text(encoding="utf-8-sig"))
expected_command = "lake env lean " + source.relative_to(REPO).as_posix()
assert exit_record["exit_code"] == 0
assert exit_record["command"] == expected_command
assert exit_record["output"] == output.name
text = output.read_text(encoding="utf-8-sig")
assert not re.search(r"\b(error|warning|sorryAx)\b", text)
source_text = source.read_text(encoding="utf-8-sig")
names = re.findall(r"^theorem ([A-Za-z0-9_]+)", source_text, re.MULTILINE)
assert names == json.loads((HERE / "final-declarations.json").read_text(encoding="utf-8-sig"))
assert len(names) == len(set(names))
prefix = "NumStability.ShockContinuation."
rows = re.findall(r"'([^']+)' depends on axioms: \[([^\]]*)\]", text)
assert {n for n, _ in rows} == {prefix + n for n in names}
assert len(rows) == len(names)
axioms = {n: [a.strip() for a in body.split(",") if a.strip()] for n, body in rows}
assert all(set(v) <= ALLOWED for v in axioms.values())
# These reviewed candidate comments have no nested block comments or quoted strings.
code = re.sub(r"/-.*?-/", "", source_text, flags=re.DOTALL)
code = re.sub(r"--[^\n]*", "", code)
assert not re.search(r"\b(sorry|admit|axiom)\b", code)
assert not re.search(r"set_option\s+(?:linter|debug|compiler)", code)
receipt = {
    "schema": "leveque-ch01-scratch-verification-1",
    "source_pdf_sha256": "b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5",
    "source": source.name,
    "source_sha256": digest(source),
    "command": expected_command,
    "working_directory": str(REPO),
    "observed_native_exit_code": exit_record["exit_code"],
    "exit_code_provenance": "Native PowerShell wrapper saved the actual LASTEXITCODE immediately after the compiler pipeline; raw compiler output independently parsed here.",
    "exit_record": exit_path.name,
    "exit_record_sha256": digest(exit_path),
    "output": output.name,
    "output_sha256": digest(output),
    "resolved_public_theorem_count": len(names),
    "axioms": axioms,
    "report_sha256": digest(HERE / "reuse-and-scope.md"),
    "reuse_searches_sha256": digest(HERE / "reuse-searches.txt"),
    "declarations_list_sha256": digest(HERE / "final-declarations.json"),
    "verifier_sha256": digest(Path(__file__)),
    "lean_toolchain": (REPO / "lean-toolchain").read_text(encoding="utf-8").strip(),
    "lake_manifest_sha256": digest(REPO / "lake-manifest.json"),
    "source_faithfulness_audit": False,
    "production_integration": False,
    "gate_row_closure": False,
    "full_spacetime_entropy_test_function_inequality": False,
}
target = HERE / "final-verification.json"
target.write_text(json.dumps(receipt, ensure_ascii=False, indent=2, sort_keys=True) + "\n", encoding="utf-8")
print(json.dumps({"status": "PASS", "receipt": str(target), "sha256": digest(target),
                  "public_theorems": len(names)}, indent=2))
