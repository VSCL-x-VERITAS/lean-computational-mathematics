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
    def transcript(self, path, thread, count, prefix):
        return b.scan_transcript_lines(self.source_lines, thread, count, prefix)
    def raw(self, path, expected=None):
        try:
            key = path.relative_to(self.root).as_posix()
        except ValueError:
            key = str(path)
        data = self.data.get(key, b"SYNTHETIC producer bytes")
        b.require(expected is None or b.digest(data) == expected, "memory raw mismatch")
        return data


def original_line(obj):
    return (json.dumps(obj, ensure_ascii=False, separators=(",", ":")) + "\n").encode()


def append_reply(q, reader, index=0, timestamp="2026-09-08T09:30:00Z"):
    question=q["questions"][index]
    line=len(reader.source_lines)+1
    answer="SYNTHETIC exact answer"
    body=json.dumps([{"questionItemId":question["question_id"],"question":question["exact_text"],"answer":answer}])
    raw=original_line({"type":"response_item","ordinal":line-1,"timestamp":timestamp,"payload":{"type":"message","role":"user","content":[{"type":"input_text","text":"<send_user_message_question_reply>"+body+"</send_user_message_question_reply>"}]}})
    reader.source_lines.append(raw)
    ref=reader.put(raw,raw=True)
    q["replies"].append({"question_id":question["question_id"],"line":line,"exact_text":answer,"record":ref,"record_sha256":ref["sha256"],"timestamp":timestamp})
    question["status"]="answered"


def provenance_fixture(mutator=lambda s, q, r, reader: None):
    reader = MemoryReader()
    reader.source_lines=[original_line({"type":"session_meta","payload":{"id":b.THREAD_ID},"fixture":"SYNTHETIC"})]
    _, proposed = base_and_proposal()
    context = {"lean_current_head": "a" * 40, "bindings": {"synthetic_context": True}}
    source = {"schema_version": 1, "kind": "material-choice-source-boundaries", "source": {"path": "fixture/SYNTHETIC-source.pdf", "sha256": b.SOURCE_SHA}, "rows": []}
    questions = {"schema_version":2,"kind":"current-material-choice-projection","thread_id":b.THREAD_ID,"source_path":b.TRANSCRIPT_PATH,"scanned_line_count":0,"snapshot_prefix_sha256":"","extracted_at_utc":"2026-09-08T10:00:00Z","chronology":"transcript-line-order","projection_review":"SYNTHETIC current projection review","provenance":{},"timestamp_regressions":[],"questions":[],"replies":[]}
    routes = {"schema_version": 1, "kind": "reviewed-local-work-exhaustion", "input_commit": context["lean_current_head"], "bindings": context["bindings"], "source_manifest_sha256": "", "question_projection_sha256": "", "reviewer": "SYNTHETIC fixture reviewer", "reviewed_at_utc": "2026-09-08T10:01:00Z", "rows": []}
    for i, row_id in enumerate(identities["choice_rows"]):
        call="SYNTHETIC-call-"+str(i)
        qid=b.question_id(call,0)
        exact="SYNTHETIC exact question "+str(i)
        line=len(reader.source_lines)+1
        raw=original_line({"type":"response_item","ordinal":line-1,"timestamp":"2026-09-08T09:00:00Z","payload":{"type":"function_call","name":"request_user_input_async","call_id":call,"arguments":json.dumps({"questions":[{"title":exact}]})}})
        reader.source_lines.append(raw)
        ref=reader.put(raw,raw=True)
        questions["questions"].append({"question_id":qid,"call_id":call,"question_index":0,"line":line,"row_ids":[row_id],"exact_text":exact,"record":ref,"record_sha256":ref["sha256"],"timestamp":"2026-09-08T09:00:00Z","status":"pending","mapping_review":"SYNTHETIC explicit mapping"})
        source["rows"].append({"row_id": row_id, "source_locator": reader.put({"source_sha256": b.SOURCE_SHA}), "frozen_audits": [reader.put({"SYNTHETIC unresolved audit": True})], "boundary": "SYNTHETIC source boundary"})
        routes["rows"].append({"row_id": row_id, "question_id": qid, "all_local_work_complete": True, "remaining_local_actions": [], "obstruction": "SYNTHETIC external choice", "attempted_routes": "SYNTHETIC completed routes", "resume_condition": "SYNTHETIC explicit decision", "routes": [{"kind": k, "description": "SYNTHETIC route " + k, "outcome": "completed", "evidence": [reader.put({"SYNTHETIC route evidence": k})]} for k in sorted(b.ROUTE_KINDS)]})
    mutator(source, questions, routes, reader)
    questions["scanned_line_count"]=len(reader.source_lines)
    questions["snapshot_prefix_sha256"]=b.digest(b"".join(reader.source_lines))
    refs={x["line"]:x["record"] for x in questions["questions"]+questions["replies"]}
    provenance={"kind":"exact-own-thread-record-extraction",**{k:questions[k] for k in ("thread_id","source_path","scanned_line_count","snapshot_prefix_sha256","extracted_at_utc")},"selected_original_records":[refs[x] for x in sorted(refs)]}
    questions["provenance"]=reader.put(provenance)
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
        self.provenance_reject(lambda s,q,r,m:q["questions"][0].update(status="answered"), "status disagrees")
    def test_new_answer_record_rejected(self):
        self.provenance_reject(lambda s,q,r,m:append_reply(q,m), "already answered")
    def test_missing_interface_mapping_rejected(self):
        self.provenance_reject(lambda s,q,r,m:q["questions"][0].update(row_ids=[]), "pending exact")
    def test_question_text_mismatch_rejected(self):
        self.provenance_reject(lambda s,q,r,m:q["questions"][0].update(exact_text="other text"), "question line/ID/text")
    def test_question_record_hash_rejected(self):
        self.provenance_reject(lambda s,q,r,m:q["questions"][0].update(record_sha256="0"*64), "record hash mismatch")
    def test_stale_route_context_rejected(self):
        self.provenance_reject(lambda s,q,r,m:r.update(input_commit="b"*40), "stale route context")
    def test_source_hash_changed_rejected(self):
        self.provenance_reject(lambda s,q,r,m:s['source'].update(sha256='0'*64), 'wrong selected source')
    def test_reply_before_question_rejected(self):
        def change(s,q,r,m):
            append_reply(q,m);q["replies"][0]["line"]=1
        self.provenance_reject(change,"reply line")
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
        for name in b.PINS:
            self.assertEqual(b.sha(b.PINS[name][0]),b.PINS[name][1])



def replace_original(q, reader, index, change):
    item=q["questions"][index]
    obj=b.parse(reader.source_lines[item["line"]-1]);change(obj)
    raw=original_line(obj);reader.source_lines[item["line"]-1]=raw
    ref=reader.put(raw,raw=True);item.update(record=ref,record_sha256=ref["sha256"],timestamp=obj["timestamp"])


def add_regression(q, reader):
    replace_original(q,reader,0,lambda obj:obj.update(timestamp="2026-09-08T15:00:00Z"))
    q["timestamp_regressions"]=[{"earlier_line":2,"later_line":3,"earlier_timestamp":"2026-09-08T15:00:00Z","later_timestamp":"2026-09-08T09:00:00Z"}]


class TranscriptOrderTests(unittest.TestCase):
    def fixture(self, change=lambda s,q,r,m:None):
        args=provenance_fixture(change)
        return args[3].bound(args[0]["question_projection"]),args[3]
    def check(self,q,reader):
        return b.check_question_projection(q,reader,gate,identities)
    def reject(self,change,message):
        q,m=self.fixture();change(q,m)
        with self.assertRaisesRegex(ValueError,message):self.check(q,m)
    def test_clock_regression_with_exact_order_accepted(self):
        args=provenance_fixture(lambda s,q,r,m:add_regression(q,m))
        b.check_provenance(*args[:3],args[3],gate,identities)
    def test_earlier_literal_reply_time_with_later_line_accepted(self):
        def change(s,q,r,m):
            append_reply(q,m,timestamp="2026-09-08T08:00:00Z")
            q["timestamp_regressions"]=[{"earlier_line":10,"later_line":11,"earlier_timestamp":"2026-09-08T09:00:00Z","later_timestamp":"2026-09-08T08:00:00Z"}]
        q,m=self.fixture(change);_,answered,_=self.check(q,m)
        self.assertEqual(answered,{q["questions"][0]["question_id"]})
    def test_missing_regression_disclosure_rejected(self):
        q,m=self.fixture(lambda s,q,r,m:add_regression(q,m));q["timestamp_regressions"]=[]
        with self.assertRaisesRegex(ValueError,"regression disclosure"):self.check(q,m)
    def test_wrong_regression_line_rejected(self):
        q,m=self.fixture(lambda s,q,r,m:add_regression(q,m));q["timestamp_regressions"][0]["later_line"]=4
        with self.assertRaisesRegex(ValueError,"regression disclosure"):self.check(q,m)
    def test_regression_boolean_line_rejected(self):
        q,m=self.fixture(lambda s,q,r,m:add_regression(q,m));q["timestamp_regressions"][0]["later_line"]=True
        with self.assertRaisesRegex(ValueError,"positions must be integers"):self.check(q,m)
    def test_wrong_question_line_rejected(self):
        self.reject(lambda q,m:q["questions"][0].update(line=3),"question line/ID/text")
    def test_wrong_question_call_rejected(self):
        self.reject(lambda q,m:q["questions"][0].update(call_id="SYNTHETIC-other-call"),"question line/ID/text")
    def test_wrong_question_index_rejected(self):
        self.reject(lambda q,m:q["questions"][0].update(question_index=1),"question line/ID/text")
    def test_wrong_canonical_question_id_rejected(self):
        self.reject(lambda q,m:q["questions"][0].update(question_id="SYNTHETIC-other-ID"),"complete original question coverage")
    def test_original_question_record_different_bytes_rejected(self):
        def change(q,m):
            x=q["questions"][0];raw=m.bound(x["record"],as_json=False)+b"\n"
            ref=m.put(raw,raw=True);x.update(record=ref,record_sha256=ref["sha256"])
        self.reject(change,"record differs from original")
    def test_original_record_ref_hash_rejected(self):
        self.reject(lambda q,m:q["questions"][0]["record"].update(sha256="0"*64),"reference mismatch")
    def test_original_prefix_mutation_rejected(self):
        self.reject(lambda q,m:m.source_lines.__setitem__(0,m.source_lines[0].replace(b"SYNTHETIC",b"MUTATED")),"prefix hash mismatch")
    def test_original_prefix_truncation_rejected(self):
        self.reject(lambda q,m:m.source_lines.pop(),"snapshot truncated")
    def test_other_source_path_rejected(self):
        self.reject(lambda q,m:q.update(source_path="/tmp/SYNTHETIC-alternate.jsonl"),"wrong original transcript/thread")
    def test_other_projected_thread_rejected(self):
        self.reject(lambda q,m:q.update(thread_id="SYNTHETIC-other-thread"),"wrong original transcript/thread")
    def test_other_original_thread_rejected(self):
        self.reject(lambda q,m:m.source_lines.__setitem__(0,original_line({"type":"session_meta","payload":{"id":"SYNTHETIC-other-thread"}})),"wrong transcript thread")
    def test_ordinal_line_disagreement_rejected(self):
        def change(q,m):
            obj=b.parse(m.source_lines[1]);obj["ordinal"]=100;m.source_lines[1]=original_line(obj)
        self.reject(change,"ordinal/line mismatch")
    def test_missing_projected_question_rejected(self):
        self.reject(lambda q,m:q["questions"].pop(),"complete original question coverage")
    def test_missing_projected_reply_rejected(self):
        q,m=self.fixture(lambda s,q,r,m:append_reply(q,m));q["replies"].clear()
        with self.assertRaisesRegex(ValueError,"complete original reply coverage"):self.check(q,m)
    def test_wrong_projected_reply_question_rejected(self):
        q,m=self.fixture(lambda s,q,r,m:append_reply(q,m));q["replies"][0]["question_id"]=q["questions"][1]["question_id"]
        with self.assertRaisesRegex(ValueError,"reply line or question association"):self.check(q,m)
    def test_wrong_original_reply_association_rejected(self):
        def change(s,q,r,m):
            append_reply(q,m)
            obj=b.parse(m.source_lines[-1]);text=obj["payload"]["content"][0]["text"]
            obj["payload"]["content"][0]["text"]=text.replace("SYNTHETIC-call-0","SYNTHETIC-absent-call")
            m.source_lines[-1]=original_line(obj)
        q,m=self.fixture(change)
        with self.assertRaisesRegex(ValueError,"association absent or not earlier"):self.check(q,m)
    def test_reply_physically_before_question_rejected(self):
        def change(s,q,r,m):
            append_reply(q,m)
            m.source_lines.insert(1,m.source_lines.pop())
            bycall={item["call_id"]:item for item in q["questions"]}
            for number,raw in enumerate(m.source_lines[1:],2):
                obj=b.parse(raw);obj["ordinal"]=number-1
                raw=original_line(obj);m.source_lines[number-1]=raw
                if obj["payload"]["type"]=="function_call":
                    item=bycall[obj["payload"]["call_id"]]
                else:
                    item=q["replies"][0]
                ref=m.put(raw,raw=True);item.update(line=number,record=ref,record_sha256=ref["sha256"])
            q["timestamp_regressions"]=[{"earlier_line":2,"later_line":3,"earlier_timestamp":"2026-09-08T09:30:00Z","later_timestamp":"2026-09-08T09:00:00Z"}]
        q,m=self.fixture(change)
        with self.assertRaisesRegex(ValueError,"association absent or not earlier"):self.check(q,m)
    def test_wrong_original_reply_title_rejected(self):
        def change(s,q,r,m):
            append_reply(q,m);m.source_lines[-1]=m.source_lines[-1].replace(b"SYNTHETIC exact question 0",b"SYNTHETIC wrong title")
        q,m=self.fixture(change)
        with self.assertRaisesRegex(ValueError,"wrong original reply question/sequence"):self.check(q,m)
    def test_later_question_rejected(self):
        q,m=self.fixture();obj=b.parse(m.source_lines[1]);obj["ordinal"]=len(m.source_lines);m.source_lines.append(original_line(obj))
        with self.assertRaisesRegex(ValueError,"later relevant transcript record"):self.check(q,m)
    def test_later_reply_rejected(self):
        q,m=self.fixture();append_reply(q,m)
        with self.assertRaisesRegex(ValueError,"later relevant transcript record"):self.check(q,m)
    def test_later_unrelated_record_permitted(self):
        q,m=self.fixture();m.source_lines.append(original_line({"type":"response_item","payload":{"type":"message","role":"assistant","content":[{"type":"output_text","text":"SYNTHETIC unrelated later commentary"}]}}))
        self.check(q,m)
    def test_later_ordinary_user_message_requires_review(self):
        q,m=self.fixture();m.source_lines.append(original_line({"type":"response_item","payload":{"type":"message","role":"user","content":[{"type":"input_text","text":"SYNTHETIC ordinary answer or scope change"}]}}))
        with self.assertRaisesRegex(ValueError,"later user message requires a fresh projection review"):self.check(q,m)
    def test_prior_ordinary_user_message_unexported(self):
        def change(s,q,r,m):
            m.source_lines.append(original_line({"type":"response_item","payload":{"type":"message","role":"user","content":[{"type":"input_text","text":"SYNTHETIC already reviewed unrelated user message"}]}}))
        q,m=self.fixture(change);qs,_,_=self.check(q,m)
        self.assertEqual(len(qs),9);self.assertEqual(q["replies"],[])
    def test_later_tool_output_permitted(self):
        q,m=self.fixture();m.source_lines.append(original_line({"type":"response_item","payload":{"type":"function_call_output","call_id":"SYNTHETIC-output","output":"SYNTHETIC unrelated later output"}}))
        self.check(q,m)
    def test_extraction_metadata_disagreement_rejected(self):
        def change(q,m):
            value=m.bound(q["provenance"]);value["scanned_line_count"]+=1;q["provenance"]=m.put(value)
        self.reject(change,"extraction provenance differs")
    def test_selected_record_coverage_rejected(self):
        def change(q,m):
            value=m.bound(q["provenance"]);value["selected_original_records"].pop();q["provenance"]=m.put(value)
        self.reject(change,"selected-record coverage mismatch")
    def test_host_review_before_host_extraction_rejected(self):
        args=provenance_fixture(lambda s,q,r,m:r.update(reviewed_at_utc="2026-09-08T09:59:00Z"))
        with self.assertRaisesRegex(ValueError,"current reviewed projection"):b.check_provenance(*args[:3],args[3],gate,identities)
    def test_answered_unmapped_and_pending_unmapped_supported(self):
        def change(s,q,r,m):
            q["questions"][0]["row_ids"]=[];q["questions"][1]["row_ids"]=[]
            q["questions"][2]["row_ids"]=identities["choice_rows"][:2]
            append_reply(q,m)
        q,m=self.fixture(change);qs,answered,_=self.check(q,m)
        self.assertEqual(len(qs),9);self.assertEqual(len(answered),1)
        self.assertEqual(q["questions"][1]["status"],"pending")
    def test_original_v1_nonchronology_functions_unchanged(self):
        import ast
        def bodies(path):
            tree=ast.parse(path.read_text(encoding="utf-8"))
            return {n.name:ast.dump(n,include_attributes=False) for n in tree.body if isinstance(n,ast.FunctionDef)}
        old,new=bodies(b.PINS["v1_helper"][0]),bodies(HERE/"blocked_gate_binding.py")
        for name in ("check_transition","check_header","consume_receipts","payloads_for","validate_proposed","terminal_output_ok","prepare","load_checker"):
            self.assertEqual(old[name],new[name],name)
    def test_v1_nonprojection_schemas_unchanged(self):
        old=b.parse(b.PINS["v1_schema"][0].read_bytes());new=b.parse((HERE/"input.schema.json").read_bytes())
        for name in old["$defs"]:
            if name not in {"question","reply","questionProjection"}:
                self.assertEqual(old["$defs"][name],new["$defs"][name],name)


class TranscriptDiskTests(unittest.TestCase):
    setUp = DiskAndReleasedPayloadTests.setUp
    tearDown = DiskAndReleasedPayloadTests.tearDown
    def test_live_transcript_suffix_and_recheck(self):
        args=provenance_fixture();q=args[3].bound(args[0]["question_projection"])
        path=self.root/"SYNTHETIC-original.jsonl";path.write_bytes(b"".join(args[3].source_lines))
        reader=b.Reader(self.root);watch=(str(path),b.THREAD_ID,q["scanned_line_count"],q["snapshot_prefix_sha256"])
        reader.transcript(*watch);reader.transcript_watches.append(watch)
        self.assertNotIn(path,reader.observed)
        with path.open("ab") as f:f.write(original_line({"type":"response_item","payload":{"type":"message","role":"assistant","content":[]}}))
        reader.unchanged()
        obj=b.parse(args[3].source_lines[1]);obj["ordinal"]=q["scanned_line_count"]+1
        with path.open("ab") as f:f.write(original_line(obj))
        with self.assertRaisesRegex(ValueError,"later relevant transcript record"):reader.unchanged()
    def test_live_transcript_prefix_change_rejected(self):
        args=provenance_fixture();q=args[3].bound(args[0]["question_projection"])
        path=self.root/"SYNTHETIC-original.jsonl";raw=b"".join(args[3].source_lines);path.write_bytes(raw)
        reader=b.Reader(self.root);watch=(str(path),b.THREAD_ID,q["scanned_line_count"],q["snapshot_prefix_sha256"])
        reader.transcript(*watch);reader.transcript_watches.append(watch)
        path.write_bytes(raw.replace(b"SYNTHETIC exact",b"SYNTHETIC other"))
        with self.assertRaisesRegex(ValueError,"prefix hash mismatch"):reader.unchanged()


if __name__ == '__main__':
    print('SYNTHETIC FIXTURE SUITE: no operational prepare/install/verification is executed.',flush=True)
    unittest.main(verbosity=2)
