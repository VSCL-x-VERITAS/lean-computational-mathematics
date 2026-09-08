"""Bind this scratch result to source, unanswered questions, canonical inputs and native captures."""
from pathlib import Path
import datetime
import hashlib
import json
import re
import subprocess

from pypdf import PdfReader

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[4]
SESSION = HERE.parent
PDF = SESSION / "source/LeVeque_Finite_Volume_Methods_for_Hyperbolic_Problems_2002.pdf"
PDF_SHA = "b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5"
FINAL = ["capstones-final-03", "measure-final-02"]
AUDITS = [
    "LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908",
    "LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908",
    "LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908",
]


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def record(path):
    return {"path": str(path.relative_to(REPO)) if path.is_relative_to(REPO) else str(path),
            "sha256": sha(path), "bytes": path.stat().st_size}


def git(*args, cwd=REPO):
    return subprocess.run(["git", "-c", "core.longpaths=true", *args], cwd=cwd,
                          capture_output=True, check=True).stdout


def main():
    outputs = [HERE / "evidence-manifest.json", HERE / "source-selected-pages.txt",
               HERE / "contracts.proof-free.md"]
    if any(p.exists() for p in outputs):
        raise SystemExit("evidence outputs already exist; this capture is append-only")
    if sha(PDF) != PDF_SHA:
        raise SystemExit("immutable selected source hash mismatch")
    receipts = []
    for label in FINAL:
        path = HERE / f"{label}.receipt.json"
        r = json.loads(path.read_text(encoding="utf-8"))
        if r["exit_code"] != 0 or not r["source_unchanged"] or r["contains_sorryAx"]:
            raise SystemExit("final native receipt is not a successful stable check")
        for filename, expected in [(r["source"], r["source_sha256_after"]),
                                   (r["output"], r["output_sha256"]),
                                   (r["compiled"], r["compiled_sha256"])]:
            if not filename or sha(HERE / filename) != expected:
                raise SystemExit(f"final native capture changed: {filename}")
        if any(set(a["axioms"]) - {"propext", "Classical.choice", "Quot.sound"}
               for a in r["axiom_reports"]):
            raise SystemExit("unreviewed axiom in final output")
        receipts.append(record(path))
    source_text = []
    reader = PdfReader(PDF)
    for page in (26, 27, 30):
        source_text.append(f"RAW PDF PAGE {page}; PRINTED CHAPTER 1 PAGE {page - 22}\n")
        source_text.append(reader.pages[page - 1].extract_text() + "\n\n")
    source_body = "".join(source_text)
    native = (HERE / "capstones-final-03.native.txt").read_text(encoding="utf-8")
    contracts_body = (
        "# Prospective proof-free native contracts\n\n"
        "Exact native output from capstones-final-03, bound by its receipt. `#check` prints theorem "
        "types; `#print` is used only on structures/definitions. The output includes no theorem proof "
        "bodies. Axiom reports are retained. These are prospective alternatives; no source interpretation "
        "or semantic audit outcome is adopted.\n\n```text\n" + native + "```\n")
    queue = re.findall(r"^import (ComputationalMathematics\.[\w.]+)$",
                       (HERE / "Capstones.lean").read_text(encoding="utf-8"), re.M)
    modules = {}
    while queue:
        module = queue.pop()
        if module in modules:
            continue
        path = REPO / (module.replace(".", "/") + ".lean")
        text = path.read_text(encoding="utf-8")
        item = record(path)
        blob = git("show", "HEAD:" + path.relative_to(REPO).as_posix())
        item["source_matches_observed_head_modulo_crlf"] = (
            blob.replace(b"\r\n", b"\n") == path.read_bytes().replace(b"\r\n", b"\n"))
        if not item["source_matches_observed_head_modulo_crlf"]:
            raise SystemExit(f"canonical source differs from current HEAD: {module}")
        olean = REPO / ".lake/build/lib/lean" / (module.replace(".", "/") + ".olean")
        item["observed_built_olean"] = record(olean)
        modules[module] = item
        queue.extend(re.findall(r"^import (ComputationalMathematics\.[\w.]+)$", text, re.M))
    frozen = []
    for task in AUDITS:
        base = SESSION / "audits" / task / "faithfulness"
        decision = base / "decision.json"
        data = json.loads(decision.read_text(encoding="utf-8"))
        frozen.append({"task_id": task, "decision": record(decision),
                       "source_locator": record(base / "inputs/source_locator.json"),
                       "frozen_classification": data["classification"],
                       "frozen_accepted": data["accepted"], "changed_by_this_task": False})
    question_path = SESSION / "current-thread-clarification-provenance-batch8.json"
    questions = json.loads(question_path.read_text(encoding="utf-8"))
    wanted = {"call_Jsn9xP52SK6H0Gt06HXTTauK", "call_uHJOZR8JifMR8TsqhW2IOTRX",
              "call_owBbdcnANNrlxzRviSsTqHNo"}
    selected = [q for q in questions["clarification_calls"] if q["call_id"] in wanted]
    if len(selected) != 3:
        raise SystemExit("precise source question set not found")
    images = [REPO.parent / "workflow-v5.0.1-local/chapter01-source-review" / f"page-{p:03d}.png"
              for p in (26, 27, 30)]
    mathlib = REPO / ".lake/packages/mathlib"
    measure_sources = [mathlib / "Mathlib/MeasureTheory/Measure" / p for p in
                       ["Lebesgue/Basic.lean", "Haar/InnerProductSpace.lean", "Haar/OfBasis.lean"]]
    for path in images + measure_sources:
        if not path.is_file():
            raise SystemExit(f"evidence input missing: {path}")
    outputs[1].write_text(source_body, encoding="utf-8", newline="\n")
    outputs[2].write_text(contracts_body, encoding="utf-8", newline="\n")
    manifest = {
        "artifact_kind": "prospective-scratch-capstone-evidence",
        "captured_utc": datetime.datetime.now(datetime.timezone.utc).isoformat(),
        "scope": "ordinary-density, material alternatives, positive-dimensional first-order Riemann data",
        "source_interpretations": "unanswered; preserved; no semantic judgment or source adoption",
        "observed_repo_head": git("rev-parse", "HEAD").decode().strip(),
        "mathlib_head": git("rev-parse", "HEAD", cwd=mathlib).decode().strip(),
        "immutable_source": record(PDF), "visually_reviewed_source_renders": [record(p) for p in images],
        "selected_locator_anchors_remain_the_source_scope": True,
        "selected_page_extraction": record(outputs[1]),
        "frozen_audits": frozen, "question_provenance": record(question_path),
        "precise_unanswered_questions": selected,
        "canonical_import_closure": [dict(module=k, **v) for k, v in sorted(modules.items())],
        "selected_measure_sources": [record(p) for p in measure_sources],
        "native_final_receipts": receipts,
        "canonical_owner_build_observed": {
            "command": "lake build " + " ".join(re.findall(r"^import (ComputationalMathematics\.[\w.]+)$", (HERE / "Capstones.lean").read_text(encoding="utf-8"), re.M)),
            "exit_code": 0, "output": "Build completed successfully (2689 jobs).",
            "evidence_kind": "agent observation of native exec result, preceding final native captures"
        },
        "scratch_artifacts": [record(p) for p in sorted(HERE.iterdir()) if p.is_file()
                              and p.name != "evidence-manifest.json"],
        "operational_mutations": [],
        "limits": ["No gate, production source, audit, topology, ledger, candidate or operator-receipt edits.",
                   "Frozen audit classifications are contextual inputs and remain unchanged.",
                   "Mathematical compilation is not source faithfulness, interpretation adoption or gate acceptance."]
    }
    outputs[0].write_text(json.dumps(manifest, indent=2, ensure_ascii=False) + "\n", encoding="utf-8", newline="\n")
    print(json.dumps({"manifest": str(outputs[0]), "sha256": sha(outputs[0]),
                      "canonical_modules": len(modules), "final_native_receipts": len(receipts)}))


if __name__ == "__main__":
    main()
