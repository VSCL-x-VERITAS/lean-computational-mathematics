"""Synthetic guard/receipt/payload tests only. Never invoke prepare or verify-installed.

No operational gate, native build, audit, Git command or terminal result is used.
The only released execution is importing gate.py and calling its pure evidence API
against temporary explicitly synthetic files under this preparation directory.
"""
from pathlib import Path
import copy
import importlib.util
import json
import tempfile
import unittest
from unittest.mock import patch
import sys

sys.dont_write_bytecode = True
HERE = Path(__file__).resolve().parent
spec = importlib.util.spec_from_file_location("blocked_proposal_under_test", HERE / "blocked_gate_binding.py")
b = importlib.util.module_from_spec(spec)
spec.loader.exec_module(b)
assert b.sha(b.CHECKER) == b.PINS["checker"][1]
spec = importlib.util.spec_from_file_location("unchanged_released_gate_for_synthetic_payloads", b.CHECKER)
gate = importlib.util.module_from_spec(spec)
spec.loader.exec_module(gate)
identities = b.parse((HERE / "expected-row-set.json").read_bytes())


def base_and_proposal():
    rows = []
    for row_id, status in identities["closed_rows"].items():
        rows.append({"id": row_id, "status": status, "source_label": "SYNTHETIC fixture", "printed_page": 1, "pdf_page": 23, "depends_on": [], "lean_declarations": ["Synthetic.D" + str(len(rows))], "faithfulness_decision": "fixture/decision-" + str(len(rows)) + ".json"})
    rows += [{"id": x, "status": "SKIPPED", "printed_page": 1, "pdf_page": 23} for x in identities["skipped_rows"]]
    rows += [{"id": x, "status": "READY", "printed_page": 1, "pdf_page": 23, "next_foundation": "SYNTHETIC remaining route"} for x in identities["choice_rows"]]
    proposed = copy.deepcopy(rows)
    for row in proposed:
        if row["status"] == "READY":
            row.pop("next_foundation")
            row.update(status="HARD_BLOCKED", blocker_kind="material-user-choice",
                       obstruction="SYNTHETIC external choice", attempted_routes="SYNTHETIC completed routes",
                       blocking_evidence="SYNTHETIC bound evidence", resume_condition="SYNTHETIC explicit decision")
    return {"rows": rows}, proposed


class MemoryReader:
    """Trusted input seam for pure guards; Reader hash/path checks are tested separately.
    Only the source-PDF sentinel has the real pin and synthetic bytes. No result
    from this seam is a native or source-verification receipt.
    """
    root = b.ROOT
    def __init__(self):
        self.data = {}
        self.counter = 0
    def put(self, value, path=None, raw=False):
        self.counter += 1
        path = path or ("fixture/input-" + str(self.counter) + ".json")
        data = value if raw else b.encode(value)
        self.data[path] = data
        return {"path": path, "sha256": b.digest(data)}
    def bound(self, ref, as_json=True):
        if ref["path"] == "fixture/SYNTHETIC-source.pdf":
            return b"SYNTHETIC PDF sentinel, not source evidence"
        data = self.data[ref["path"]]
        b.require(b.digest(data) == ref["sha256"], "memory fixture reference mismatch")
        return b.parse(data) if as_json else data
    def path(self, path):
        return self.root / path
    def raw(self, path, expected=None):
        try:
            key = path.relative_to(self.root).as_posix()
        except ValueError:
            key = str(path)
        data = self.data.get(key, b"SYNTHETIC producer bytes")
        b.require(expected is None or b.digest(data) == expected, "memory raw mismatch")
        return data


def provenance_fixture(mutator=lambda s, q, r, reader: None):
    reader = MemoryReader()
    _, proposed = base_and_proposal()
    context = {"lean_current_head": "a" * 40, "bindings": {"synthetic_context": True}}
    source = {"schema_version": 1, "kind": "material-choice-source-boundaries", "source": {"path": "fixture/SYNTHETIC-source.pdf", "sha256": b.SOURCE_SHA}, "rows": []}
    questions = {"schema_version": 1, "kind": "current-material-choice-projection", "thread_id": "SYNTHETIC thread", "as_of_utc": "2026-09-08T10:00:00Z", "projection_review": "SYNTHETIC current projection review", "provenance": reader.put({"synthetic": True}), "questions": [], "replies": []}
    routes = {"schema_version": 1, "kind": "reviewed-local-work-exhaustion", "input_commit": context["lean_current_head"], "bindings": context["bindings"], "source_manifest_sha256": "", "question_projection_sha256": "", "reviewer": "SYNTHETIC fixture reviewer", "reviewed_at_utc": "2026-09-08T10:01:00Z", "rows": []}
    for i, row_id in enumerate(identities["choice_rows"]):
        question_id = "SYNTHETIC-question-" + str(i)
        exact = "SYNTHETIC exact question " + str(i)
        ref = reader.put({"exact_text": exact, "question_id": question_id})
        questions["questions"].append({"question_id": question_id, "row_ids": [row_id], "exact_text": exact, "record": ref, "record_sha256": ref["sha256"], "timestamp": "2026-09-08T09:00:00Z", "status": "pending", "mapping_review": "SYNTHETIC explicit mapping"})
        source["rows"].append({"row_id": row_id, "source_locator": reader.put({"source_sha256": b.SOURCE_SHA}), "frozen_audits": [reader.put({"SYNTHETIC unresolved audit": True})], "boundary": "SYNTHETIC source boundary"})
        routes["rows"].append({"row_id": row_id, "question_id": question_id, "all_local_work_complete": True, "remaining_local_actions": [], "obstruction": "SYNTHETIC external choice", "attempted_routes": "SYNTHETIC completed routes", "resume_condition": "SYNTHETIC explicit decision", "routes": [{"kind": k, "description": "SYNTHETIC route " + k, "outcome": "completed", "evidence": [reader.put({"SYNTHETIC route evidence": k})]} for k in sorted(b.ROUTE_KINDS)]})
    mutator(source, questions, routes, reader)
    source_ref, question_ref = reader.put(source), reader.put(questions)
    routes["source_manifest_sha256"], routes["question_projection_sha256"] = source_ref["sha256"], question_ref["sha256"]
    request = {"source_manifest": source_ref, "question_projection": question_ref, "route_manifest": reader.put(routes)}
    evidence = "; ".join(k + "=" + request[k]["path"] + "#sha256=" + request[k]["sha256"] for k in ("source_manifest", "question_projection", "route_manifest"))
    for row in proposed:
        if row["status"] == "HARD_BLOCKED":
            row["blocking_evidence"] = evidence
    return request, proposed, context, reader


def receipts_fixture(mutator=lambda receipts, outputs, m, reader: None):
    reader = MemoryReader()
    base, _ = base_and_proposal()
    rows = sorted([r for r in base["rows"] if r["status"] in {"PROVED", "REUSED"}], key=lambda r: r["id"])
    names = sorted(n for r in rows for n in r["lean_declarations"])
    m = {"input_commit": "a" * 40, "check_file": "fixture/SYNTHETIC-checks.lean"}
    outputs = {s: "SYNTHETIC successful output" for s in b.SUFFIXES}
    outputs["layout"] = "\n".join(["SYNTHETIC FIXTURE", "unclassified modules: 0", "mixed modules: 0", "modules missing module docs: 0", "legacy naming exceptions: 0", "declaration-bearing umbrellas: 0", "unsorted aggregate imports: 0", "Layout contract satisfied"])
    outputs["declarations"] = "SYNTHETIC FIXTURE\n" + "\n".join("'" + n + "' depends on axioms: [propext, Classical.choice, Quot.sound]" for n in names)
    records = []
    for row in rows:
        ref = reader.put({"SYNTHETIC decision": row["id"]}, row["faithfulness_decision"])
        records.append({"row": row["id"], "exit_code": 0, "decision_sha256": ref["sha256"]})
    outputs["audits"] = json.dumps({"mode": "released-complete-validation", "closed_rows": 32, "records": records})
    producers = {"source-inventory": b.SESSION / "verify-reviewed-source-coverage.py", "audits": b.SESSION / "validate-closed-row-audits-v3.py", **{k: b.ROOT / "tools/architecture" / v for k, v in {"layout": "check_layout.py", "tiers": "check_tiers.py", "compatibility": "check_compatibility.py", "hygiene": "check_placeholders.py"}.items()}}
    receipts = {}
    for suffix in b.SUFFIXES:
        value = {"exit_code": 0, "output_sha256": "", "command": "SYNTHETIC native command", "input_commit": m["input_commit"], "elapsed_ms": 1}
        if suffix in producers:
            value["command"] = ["/usr/bin/python3", str(producers[suffix]), *(["--validate"] if suffix == "audits" else [])]
        elif suffix == "declarations":
            value["argv"] = ["lake", "env", "lean", m["check_file"]]
        elif suffix == "focused-build":
            value["argv"] = ["lake", "--quiet", "--log-level=error", "build", "ComputationalMathematics.Source.LeVeque.Chapter01"]
        else:
            value["argv"] = ["lake", "--quiet", "--log-level=error", "build"]
        receipts[suffix] = value
    reader.put(b'defaultTargets = ["ComputationalMathematics", "NumStability"]\n', "lakefile.toml", raw=True)
    mutator(receipts, outputs, m, reader)
    request = {"receipts": {}}
    for suffix in b.SUFFIXES:
        data = outputs[suffix].encode()
        receipts[suffix]["output_sha256"] = b.digest(data)
        request["receipts"][suffix] = {"exit": reader.put(receipts[suffix]), "output": reader.put(data, raw=True)}
    return request, reader, m, names, rows


def terminal_fixture():
    return "\n".join(["SYNTHETIC PARSER FIXTURE ONLY", "LeVeque chapter gate: BLOCKED; derived: BLOCKED; chapter: 1; mode: default; rows: 57", "  status_counts: HARD_BLOCKED=9, PROVED=15, REUSED=17, SKIPPED=16", "  progress: formalized_objects=32; remaining_objects=9; formalization_denominator=41; formalization_percentage=78.05%; skipped=16; deferred=0", "  loop organization_completeness: closed", "  loop semantic_equivalence: closed", "  blocked: 9 -> SYNTHETIC ROWS", *["  evidence " + n + ": verified" for n in gate.EVIDENCE_NAMES]])


def header_fixture():
    bindings = {k: "SYNTHETIC" for k in gate.BINDING_FIELDS}
    return {"gate_schema_version": gate.GATE_SCHEMA_VERSION, "book_id": gate.BOOK_ID,
            "unit_kind": "chapter", "unit": 1, "chapter": 1,
            "source_unit_sha256": gate.PINNED_SOURCE_SHA256,
            "bindings": bindings, "mode": "default", "excluded_rows": []}, {"bindings": bindings.copy()}


class GuardTests(unittest.TestCase):
    def test_positive_header(self):
        g,c=header_fixture();b.check_header(g,c,gate)
    def test_changed_source_header_rejected(self):
        g,c=header_fixture();g['source_unit_sha256']='0'*64
        with self.assertRaisesRegex(ValueError,'source mismatch'):b.check_header(g,c,gate)
    def test_changed_header_context_rejected(self):
        g,c=header_fixture();g['bindings']['lean_worktree_sha256']='0'*64
        with self.assertRaisesRegex(ValueError,'context mismatch'):b.check_header(g,c,gate)
    def test_changed_mode_rejected(self):
        g,c=header_fixture();g['mode']='scope-reduction'
        with self.assertRaisesRegex(ValueError,'scope mismatch'):b.check_header(g,c,gate)
    def test_positive_exact_transition(self):
        base, rows = base_and_proposal(); b.check_transition(base, rows, identities, gate)
    def test_actionable_row_rejected(self):
        base, rows = base_and_proposal(); rows[-1]["status"] = "READY"
        with self.assertRaisesRegex(ValueError, "typed material"): b.check_transition(base, rows, identities, gate)
    def test_accepted_content_change_rejected(self):
        base, rows = base_and_proposal(); rows[0]["source_label"] = "changed"
        with self.assertRaisesRegex(ValueError, "accepted row changed"): b.check_transition(base, rows, identities, gate)
    def test_skip_change_rejected(self):
        base, rows = base_and_proposal(); rows[32]["status"] = "HARD_BLOCKED"
        with self.assertRaisesRegex(ValueError, "skipped row changed"): b.check_transition(base, rows, identities, gate)
    def test_row_removal_rejected(self):
        base, rows = base_and_proposal(); rows.pop()
        with self.assertRaisesRegex(ValueError, "57-row"): b.check_transition(base, rows, identities, gate)
    def test_unapproved_attribution_change_rejected(self):
        base, rows = base_and_proposal(); rows[-1]["printed_page"] = 2
        with self.assertRaisesRegex(ValueError, "unapproved"): b.check_transition(base, rows, identities, gate)
    def test_blocker_array_rejected(self):
        base, rows = base_and_proposal(); rows[-1]["attempted_routes"] = ["completed"]
        with self.assertRaisesRegex(ValueError, "strings"): b.check_transition(base, rows, identities, gate)
    def test_wrong_kind_rejected(self):
        base, rows = base_and_proposal(); rows[-1]["blocker_kind"] = "missing-proof"
        with self.assertRaisesRegex(ValueError, "typed"): b.check_transition(base, rows, identities, gate)
    def test_unfinished_next_action_rejected(self):
        base, rows = base_and_proposal(); rows[-1]["next_action"] = "still prove"
        with self.assertRaisesRegex(ValueError, "remaining local-action"): b.check_transition(base, rows, identities, gate)
    def test_positive_current_provenance(self):
        args = provenance_fixture(); b.check_provenance(*args[:3], args[3], gate, identities)
    def provenance_reject(self, change, message):
        args = provenance_fixture(change)
        with self.assertRaisesRegex(ValueError, message): b.check_provenance(*args[:3], args[3], gate, identities)
    def test_local_work_false_rejected(self):
        self.provenance_reject(lambda s,q,r,m:r["rows"][0].update(all_local_work_complete=False), "local work remains")
    def test_local_action_list_rejected(self):
        self.provenance_reject(lambda s,q,r,m:r["rows"][0].update(remaining_local_actions=["prove"]), "local work remains")
    def test_route_category_missing_rejected(self):
        self.provenance_reject(lambda s,q,r,m:r["rows"][0]["routes"].pop(), "coverage incomplete")
    def test_route_incomplete_rejected(self):
        self.provenance_reject(lambda s,q,r,m:r["rows"][0]["routes"][0].update(outcome="pending"), "incomplete/unreviewed")
    def test_question_answered_status_rejected(self):
        self.provenance_reject(lambda s,q,r,m:q["questions"][0].update(status="answered"), "pending exact")
    def test_new_answer_record_rejected(self):
        def change(s,q,r,m):
            ref=m.put({"exact_text":"SYNTHETIC answer"})
            q["replies"].append({"question_id":q["questions"][0]["question_id"],"exact_text":"SYNTHETIC answer","record":ref,"record_sha256":ref["sha256"],"timestamp":"2026-09-08T09:30:00Z"})
        self.provenance_reject(change, "already answered")
    def test_missing_interface_mapping_rejected(self):
        self.provenance_reject(lambda s,q,r,m:q["questions"][0].update(row_ids=[]), "pending exact")
    def test_question_text_mismatch_rejected(self):
        self.provenance_reject(lambda s,q,r,m:q["questions"][0].update(exact_text="other text"), "text absent")
    def test_question_record_hash_rejected(self):
        self.provenance_reject(lambda s,q,r,m:q["questions"][0].update(record_sha256="0"*64), "record hash mismatch")
    def test_stale_route_context_rejected(self):
        self.provenance_reject(lambda s,q,r,m:r.update(input_commit="b"*40), "stale route context")
    def test_source_hash_changed_rejected(self):
        self.provenance_reject(lambda s,q,r,m:s['source'].update(sha256='0'*64), 'wrong selected source')
    def test_reply_before_question_rejected(self):
        def change(s,q,r,m):
            ref=m.put({'exact_text':'SYNTHETIC impossible earlier reply'})
            q['replies'].append({'question_id':q['questions'][0]['question_id'],'exact_text':'SYNTHETIC impossible earlier reply','record':ref,'record_sha256':ref['sha256'],'timestamp':'2026-09-08T08:00:00Z'})
        self.provenance_reject(change,'invalid reply')
    def test_positive_receipt_contract(self):
        args=receipts_fixture(); receipts,axioms=b.consume_receipts(*args,gate)
        self.assertEqual(len(receipts),9); self.assertEqual(len(axioms),32)
    def receipts_reject(self, change, message):
        args=receipts_fixture(change)
        with self.assertRaisesRegex(ValueError,message):b.consume_receipts(*args,gate)
    def test_inventory_only_audit_rejected(self):
        self.receipts_reject(lambda r,o,m,d:o.update(audits=o["audits"].replace("released-complete-validation","inventory-only-not-validation")),"complete audit")
    def test_validate_omitted_rejected(self):
        self.receipts_reject(lambda r,o,m,d:r["audits"]["command"].pop(),"argument tail")
    def test_require_all_closed_variant_rejected(self):
        self.receipts_reject(lambda r,o,m,d:r["audits"]["command"].append("--require-all-closed"),"argument tail")
    def test_nonzero_native_exit_rejected(self):
        self.receipts_reject(lambda r,o,m,d:r["full-build"].update(exit_code=1),"receipt exit")
    def test_boolean_native_exit_rejected(self):
        self.receipts_reject(lambda r,o,m,d:r["full-build"].update(exit_code=False),"receipt exit")
    def test_wrong_build_target_rejected(self):
        self.receipts_reject(lambda r,o,m,d:r["full-build"]["argv"].append("OnlyOneLeaf"),"full build")
    def test_changed_native_commit_rejected(self):
        self.receipts_reject(lambda r,o,m,d:r["declarations"].update(input_commit="b"*40),"context/duration")
    def test_nonzero_layout_debt_rejected(self):
        self.receipts_reject(lambda r,o,m,d:o.update(layout=o["layout"].replace("mixed modules: 0","mixed modules: 1")),"layout marker")
    def test_unexpected_axiom_rejected(self):
        self.receipts_reject(lambda r,o,m,d:o.update(declarations=o["declarations"].replace("Quot.sound","sorryAx")),"unexpected axiom")
    def test_missing_accepted_audit_rejected(self):
        def change(r,o,m,d):
            value=json.loads(o["audits"]);value["records"].pop();o["audits"]=json.dumps(value)
        self.receipts_reject(change,"coverage mismatch")
    def test_changed_accepted_decision_hash_rejected(self):
        def change(r,o,m,d):
            value=json.loads(o['audits']);value['records'][0]['decision_sha256']='0'*64;o['audits']=json.dumps(value)
        self.receipts_reject(change,'audit result changed')
    def test_receipt_output_hash_rejected(self):
        args=receipts_fixture();request,reader,*_=args
        ref=request['receipts']['audits']['output']
        reader.data[ref['path']]+=b'changed'
        with self.assertRaisesRegex(ValueError,'reference mismatch'):b.consume_receipts(*args,gate)
    def test_positive_terminal_parser_only(self): b.terminal_output_ok(terminal_fixture(),0)
    def test_active_zero_exit_is_not_terminal(self):
        with self.assertRaisesRegex(ValueError,"exact BLOCKED"):b.terminal_output_ok(terminal_fixture().replace("derived: BLOCKED","derived: ACTIVE"),0)
    def test_terminal_actionable_rejected(self):
        with self.assertRaisesRegex(ValueError,"actionable"):b.terminal_output_ok(terminal_fixture()+"\n  actionable: 1 -> SYNTHETIC",0)
    def test_missing_global_terminal_evidence_rejected(self):
        with self.assertRaisesRegex(ValueError,"global evidence"):b.terminal_output_ok(terminal_fixture().replace("  evidence full_build: verified","  evidence full_build: OPEN"),0)
    def test_duplicate_json_key_rejected(self):
        with self.assertRaisesRegex(ValueError,"duplicate JSON"):b.parse(b'{"a":1,"a":2}')
    def test_non_json_numeric_constant_rejected(self):
        with self.assertRaisesRegex(ValueError,'non-JSON'):b.parse(b'{"bad":NaN}')
    def test_incomplete_timestamp_rejected(self):
        with self.assertRaisesRegex(ValueError,'complete UTC'):b.date('2026-09-08Z')
    def test_accepted_numeric_type_change_rejected(self):
        base,rows=base_and_proposal();rows[0]['printed_page']=True
        with self.assertRaisesRegex(ValueError,'accepted row changed'):b.check_transition(base,rows,identities,gate)


class DiskAndReleasedPayloadTests(unittest.TestCase):
    def setUp(self):
        work=HERE/'fixture-work';work.mkdir(exist_ok=True)
        assert work.resolve().is_relative_to(HERE.resolve())
        self.tmp=tempfile.TemporaryDirectory(prefix='synthetic-',dir=work)
        self.root=Path(self.tmp.name)
    def tearDown(self):
        assert self.root.resolve().is_relative_to((HERE/'fixture-work').resolve())
        self.tmp.cleanup()
    def test_reader_hash_and_concurrency(self):
        f=self.root/'input.json';f.write_bytes(b'{"SYNTHETIC":true}')
        reader=b.Reader(self.root);reader.bound({'path':'input.json','sha256':b.sha(f)})
        f.write_bytes(b'{"SYNTHETIC":"changed"}')
        with self.assertRaisesRegex(ValueError,'concurrent'):reader.unchanged()
    def test_reader_bad_hash(self):
        f=self.root/'input.json';f.write_bytes(b'{}')
        with self.assertRaisesRegex(ValueError,'hash mismatch'):b.Reader(self.root).bound({'path':'input.json','sha256':'0'*64})
    def test_reader_escape(self):
        with self.assertRaisesRegex(ValueError,'unsafe'):b.Reader(self.root).path('../outside')
    def evidence_fixture(self):
        _,rows=base_and_proposal();names=sorted(n for r in rows if r['status'] in {'PROVED','REUSED'} for n in r['lean_declarations'])
        path=self.root/'gates/leveque-finite-volume/chapter-01.json';path.parent.mkdir(parents=True)
        organization={k:0 for k in gate.ORGANIZATION_COUNTERS}
        g={'rows':rows,'verification_loops':{'organization_completeness':organization},'verification_evidence':{}}
        path.write_bytes(b.encode(g))
        context={'lean_root':self.root,'bindings':{k:'SYNTHETIC' for k in gate.BINDING_FIELDS},'printed_range':(1,11),'pdf_range':(23,33),'lean_changed_paths':['Synthetic.lean']}
        with patch.object(b,'ROOT',self.root),patch.object(b,'GATE',path):
            payloads,counts=b.payloads_for(g,context,names,[{'name':n,'axioms':['Classical.choice','Quot.sound','propext']} for n in names],gate)
        subject=gate.canonical_sha256({'book_id':gate.BOOK_ID,'unit_kind':'chapter','unit':1,'chapter':1,'source_unit_sha256':gate.PINNED_SOURCE_SHA256,'mode':'default','excluded_rows':[],'rows':rows})
        for name in gate.EVIDENCE_NAMES:
            artifact={'schema_version':1,'check':name,'bindings':gate.global_artifact_bindings(1,context,subject),'command':'SYNTHETIC fixture only','exit_code':0,'count':counts[name],'payload':payloads[name]}
            f=path.parent/(name+'.json');f.write_bytes(b.encode(artifact))
            g['verification_evidence'][name]={'command':artifact['command'],'artifact':f.name,'artifact_sha256':b.sha(f),'exit_code':0,'count':counts[name]}
        return g,context,path
    def test_all_eight_released_payloads_synthetic(self):
        g,c,p=self.evidence_fixture();errors,complete=gate.evidence_defects(g['verification_evidence'],gate_path=p,chapter=1,context=c,rows=g['rows'],organization=g['verification_loops']['organization_completeness'],used_artifacts=set())
        self.assertEqual(errors,[]);self.assertTrue(all(complete.values()))
    def test_released_rejects_stale_subject(self):
        g,c,p=self.evidence_fixture();f=p.parent/'source_inventory.json';v=b.parse(f.read_bytes());v['bindings']['gate_subject_sha256']='0'*64;f.write_bytes(b.encode(v));g['verification_evidence']['source_inventory']['artifact_sha256']=b.sha(f)
        errors,complete=gate.evidence_defects(g['verification_evidence'],gate_path=p,chapter=1,context=c,rows=g['rows'],organization=g['verification_loops']['organization_completeness'],used_artifacts=set())
        self.assertTrue(any('stale' in x for x in errors));self.assertFalse(complete['source_inventory'])
    def test_final_pass_and_validator_pins_unchanged(self):
        for name in ('binder','validator','checker','inventory','preparer','row_set'):
            self.assertEqual(b.sha(b.PINS[name][0]),b.PINS[name][1])


if __name__ == '__main__':
    print('SYNTHETIC FIXTURE SUITE: no operational prepare/install/verification is executed.',flush=True)
    unittest.main(verbosity=2)
