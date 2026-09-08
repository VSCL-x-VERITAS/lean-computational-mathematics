"""Prepare immutable proposed BLOCKED evidence; never write the operational gate.

Run CLI through the prepared POSIX launcher. `verify-installed` is read-only
against an independently installed exact proposal and runs the released checker.
Preparation is not terminal verification, source adoption or proof of exhaustion.
"""
from pathlib import Path, PurePosixPath
import argparse
import collections
import datetime
import hashlib
import importlib.util
import json
import os
import re
import subprocess
import sys
import tomllib

sys.dont_write_bytecode = True
HERE = Path(__file__).resolve().parent
SESSION = HERE.parent
ROOT = SESSION.parents[3]
GATE = ROOT / "gates/leveque-finite-volume/chapter-01.json"
CHECKER = ROOT.parent / "formalization-collaboration-v5.0.1/books/candidates/leveque-finite-volume/module/scripts/gate.py"
PINS = {
    "binder": (SESSION / "bind-final-gate-evidence-v3.py", "7d2a1b34d4e2450d83a17f6ea4d39f54f0a9254f28ecae70d096d23448c7c3af"),
    "validator": (SESSION / "validate-closed-row-audits-v3.py", "546d85ce56481fede6b4cfb4d07aa7da76ce8f7fa5fdb6d2e62db7c08434911e"),
    "checker": (CHECKER, "3e9cc58beb58f9f63f2736c4d50125ca6c42116104b64982f3dfc2d3f8afb104"),
    "inventory": (SESSION / "verify-reviewed-source-coverage.py", "0a88aa0e862d118bea66b78c14fd7a5116b1a5f45649ba439119728e2a44db99"),
    "preparer": (SESSION / "prepare-closed-row-checks.py", "f78e12df39d5a2dc4650d6e0069ab28dca6589c834ab8498c99a2e7d6dbbfcac"),
    "row_set": (HERE / "expected-row-set.json", "7fedbcfae8631fb6dfae29ba25789e868f83fb8e170b414ac99f0f2f6ac93d1d"),
}
SOURCE_SHA = "b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5"
SUFFIXES = ("source-inventory", "layout", "tiers", "compatibility", "hygiene", "audits", "declarations", "focused-build", "full-build")
ROUTE_KINDS = {"source-review", "canonical-reuse", "mathematical-alternatives", "native-checks", "organization", "consumer-checks", "review"}
DETAILS = ("obstruction", "attempted_routes", "blocking_evidence", "resume_condition")
CHANGES = {"status", "blocker_kind", *DETAILS, "next_foundation", "next_action", "open_reason", "current_target"}


def require(value, message):
    if not value:
        raise ValueError(message)


def digest(data):
    return hashlib.sha256(data).hexdigest()


def sha(path):
    return digest(path.read_bytes())


def encode(value):
    return (json.dumps(value, indent=2, ensure_ascii=False) + "\n").encode("utf-8")


def canonical(value):
    return digest(json.dumps(value, sort_keys=True, separators=(",", ":"), ensure_ascii=False).encode())


def closed(value, keys, name):
    require(type(value) is dict and set(value) == set(keys), f"{name}: wrong object fields")


def parse(data):
    def pairs(items):
        result = {}
        for key, value in items:
            require(key not in result, f"duplicate JSON key: {key}")
            result[key] = value
        return result
    def invalid_constant(value):
        raise ValueError("non-JSON numeric constant: " + value)
    return json.loads(data.decode("utf-8-sig"), object_pairs_hook=pairs,
                      parse_constant=invalid_constant)


def date(value):
    require(isinstance(value, str) and
            re.fullmatch(r"\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(?:\.\d+)?Z", value),
            "timestamp must be a complete UTC date-time ending in Z")
    return datetime.datetime.fromisoformat(value.replace("Z", "+00:00"))


def regular(path):
    require(path.is_absolute(), "absolute resolved path required")
    for ancestor in (path, *path.parents):
        require(not ancestor.is_symlink(), f"symlink input: {path}")
    require(path.is_file(), f"missing regular input: {path}")
    return path


class Reader:
    def __init__(self, root):
        self.root = root.resolve()
        self.observed = {}

    def raw(self, path, expected=None):
        path = regular(path.absolute())
        data = path.read_bytes()
        actual = digest(data)
        require(expected is None or actual == expected, f"input hash mismatch: {path}")
        require(path not in self.observed or self.observed[path] == actual, f"input changed: {path}")
        self.observed[path] = actual
        return data

    def path(self, value):
        require(isinstance(value, str) and value and "\\" not in value, "POSIX relative path required")
        p = PurePosixPath(value)
        require(not p.is_absolute() and not any(x in {"", ".", ".."} for x in value.split("/"))
                and ":" not in value, "unsafe relative path")
        path = self.root / value
        require(path.resolve().is_relative_to(self.root), "path escapes repository")
        return path

    def bound(self, ref, *, as_json=True):
        closed(ref, {"path", "sha256"}, "file reference")
        require(isinstance(ref["sha256"], str) and re.fullmatch(r"[0-9a-f]{64}", ref["sha256"]), "invalid SHA256")
        data = self.raw(self.path(ref["path"]), ref["sha256"])
        return parse(data) if as_json else data

    def unchanged(self):
        for path, expected in self.observed.items():
            require(sha(regular(path)) == expected, f"concurrent input change: {path}")


def keyed(rows, field="id"):
    require(type(rows) is list and all(type(x) is dict and field in x for x in rows), "invalid row list")
    result = {x[field]: x for x in rows}
    require(len(result) == len(rows), "duplicate row identity")
    return result


def exact_record(reader, record, record_sha256, text):
    data = reader.bound(record, as_json=False)
    require(record_sha256 == digest(data), "exact record hash mismatch")
    def contains(value):
        if isinstance(value, str):
            return value == text
        if isinstance(value, list):
            return any(contains(x) for x in value)
        if isinstance(value, dict):
            return any(contains(x) for x in value.values())
        return False
    try:
        value = parse(data)
    except (ValueError, UnicodeDecodeError):
        value = data.decode("utf-8-sig").rstrip("\r\n")
    require(contains(value), "exact question/reply text absent from bound record")


def check_transition(base, proposed_rows, identities, checker):
    old, new = keyed(base["rows"]), keyed(proposed_rows)
    expected = set(identities["closed_rows"]) | set(identities["skipped_rows"]) | set(identities["choice_rows"])
    require(set(old) == set(new) == expected and len(expected) == 57, "exact 57-row set required")
    require([x["id"] for x in base["rows"]] == [x["id"] for x in proposed_rows], "row order changed")
    for row_id in identities["closed_rows"]:
        require(old[row_id]["status"] == identities["closed_rows"][row_id]
                and encode(new[row_id]) == encode(old[row_id]), "accepted row changed")
    for row_id in identities["skipped_rows"]:
        require(old[row_id]["status"] == "SKIPPED"
                and encode(new[row_id]) == encode(old[row_id]), "skipped row changed")
    for row_id in identities["choice_rows"]:
        before, after = old[row_id], new[row_id]
        require(before["status"] in {"READY", "IN_PROGRESS"}, "choice row was not actionable at base")
        require(after["status"] == "HARD_BLOCKED" and after.get("blocker_kind") == "material-user-choice", "exact typed material choice required")
        require(encode({k: v for k, v in before.items() if k not in CHANGES}) ==
                encode({k: v for k, v in after.items() if k not in CHANGES}), "unapproved choice-row change")
        require(all(checker.meaningful(after, x) for x in DETAILS), "meaningful blocker strings required")
        require(not any(after.get(x) for x in ("next_foundation", "next_action", "open_reason", "current_target", "blocked_by")), "remaining local-action field")
    require(collections.Counter(x["status"] for x in proposed_rows) ==
            {"PROVED": 15, "REUSED": 17, "HARD_BLOCKED": 9, "SKIPPED": 16}, "exact 32/9/16 statuses required")


def check_header(g, context, checker):
    require(type(g.get("gate_schema_version")) is int and
            g["gate_schema_version"] == checker.GATE_SCHEMA_VERSION, "gate schema mismatch")
    require(g.get("book_id") == checker.BOOK_ID and g.get("unit_kind") == "chapter"
            and type(g.get("unit")) is int and g["unit"] == 1
            and type(g.get("chapter")) is int and g["chapter"] == 1, "gate unit mismatch")
    require(g.get("source_unit_sha256") == checker.PINNED_SOURCE_SHA256, "gate source mismatch")
    require(g.get("bindings") == context["bindings"] and
            set(g["bindings"]) == checker.BINDING_FIELDS, "gate context mismatch")
    require(g.get("mode") == "default" and g.get("excluded_rows") == [], "gate scope mismatch")
    require("nonvacuity_reason" not in g or checker.meaningful(g, "nonvacuity_reason"),
            "invalid nonvacuity reason")


def check_provenance(request, proposed_rows, context, reader, checker, identities):
    source = reader.bound(request["source_manifest"])
    questions = reader.bound(request["question_projection"])
    routes = reader.bound(request["route_manifest"])
    closed(source, {"schema_version", "kind", "source", "rows"}, "source manifest")
    require(type(source["schema_version"]) is int and source["schema_version"] == 1 and source["kind"] == "material-choice-source-boundaries", "source schema")
    require(source["source"]["sha256"] == SOURCE_SHA, "wrong selected source")
    reader.bound(source["source"], as_json=False)
    closed(questions, {"schema_version", "kind", "thread_id", "as_of_utc", "projection_review", "provenance", "questions", "replies"}, "question projection")
    require(type(questions["schema_version"]) is int and questions["schema_version"] == 1 and questions["kind"] == "current-material-choice-projection", "question schema")
    require(checker.meaningful(questions, "thread_id") and checker.meaningful(questions, "projection_review"), "current projection review required")
    as_of = date(questions["as_of_utc"])
    reader.bound(questions["provenance"], as_json=False)
    qs = keyed(questions["questions"], "question_id")
    for question in qs.values():
        closed(question, {"question_id", "row_ids", "exact_text", "record", "record_sha256", "timestamp", "status", "mapping_review"}, "question")
        require(checker.meaningful(question, "question_id") and question["status"] in {"pending", "answered"}
                and checker.meaningful(question, "exact_text") and checker.meaningful(question, "mapping_review")
                and date(question["timestamp"]) <= as_of, "invalid reviewed question")
        require(type(question["row_ids"]) is list and len(set(question["row_ids"])) == len(question["row_ids"])
                and set(question["row_ids"]) <= set(identities["choice_rows"]), "invalid question scope")
        exact_record(reader, question["record"], question["record_sha256"], question["exact_text"])
    require(type(questions["replies"]) is list, "replies must be explicit list")
    answered = set()
    for reply in questions["replies"]:
        closed(reply, {"question_id", "exact_text", "record", "record_sha256", "timestamp"}, "reply")
        require(reply["question_id"] in qs and checker.meaningful(reply, "exact_text") and
                date(qs[reply["question_id"]]["timestamp"]) <= date(reply["timestamp"]) <= as_of, "invalid reply")
        exact_record(reader, reply["record"], reply["record_sha256"], reply["exact_text"])
        answered.add(reply["question_id"])
    closed(routes, {"schema_version", "kind", "input_commit", "bindings", "source_manifest_sha256", "question_projection_sha256", "reviewer", "reviewed_at_utc", "rows"}, "route manifest")
    require(type(routes["schema_version"]) is int and routes["schema_version"] == 1 and routes["kind"] == "reviewed-local-work-exhaustion", "route schema")
    require(routes["input_commit"] == context["lean_current_head"] and routes["bindings"] == context["bindings"], "stale route context")
    require(routes["source_manifest_sha256"] == request["source_manifest"]["sha256"] and
            routes["question_projection_sha256"] == request["question_projection"]["sha256"], "route provenance hash mismatch")
    require(checker.meaningful(routes, "reviewer") and date(routes["reviewed_at_utc"]) >= as_of, "current reviewed projection required")
    sr, rr, pr = keyed(source["rows"], "row_id"), keyed(routes["rows"], "row_id"), keyed(proposed_rows)
    require(set(sr) == set(rr) == set(identities["choice_rows"]), "nine exact provenance rows required")
    expected_evidence = "; ".join(k + "=" + request[k]["path"] + "#sha256=" + request[k]["sha256"]
                                  for k in ("source_manifest", "question_projection", "route_manifest"))
    for row_id, route in rr.items():
        boundary = sr[row_id]
        closed(boundary, {"row_id", "source_locator", "frozen_audits", "boundary"}, "source boundary")
        locator = reader.bound(boundary["source_locator"])
        require(locator.get("source_sha256") == SOURCE_SHA and checker.meaningful(boundary, "boundary"), "source locator boundary required")
        require(type(boundary["frozen_audits"]) is list and boundary["frozen_audits"], "frozen audit references required")
        for ref in boundary["frozen_audits"]:
            reader.bound(ref, as_json=False)
        closed(route, {"row_id", "question_id", "all_local_work_complete", "remaining_local_actions", "obstruction", "attempted_routes", "resume_condition", "routes"}, "route row")
        require(route["all_local_work_complete"] is True and route["remaining_local_actions"] == [], "local work remains")
        require(route["question_id"] in qs and route["question_id"] not in answered, "choice already answered or unrecorded")
        question = qs[route["question_id"]]
        closed(question, {"question_id", "row_ids", "exact_text", "record", "record_sha256", "timestamp", "status", "mapping_review"}, "question")
        require(question["status"] == "pending" and row_id in question["row_ids"] and
                checker.meaningful(question, "exact_text") and checker.meaningful(question, "mapping_review")
                and date(question["timestamp"]) <= as_of, "pending exact row-choice mapping required")
        require(type(question["row_ids"]) is list and len(set(question["row_ids"])) == len(question["row_ids"])
                and set(question["row_ids"]) <= set(identities["choice_rows"]), "invalid question scope")
        exact_record(reader, question["record"], question["record_sha256"], question["exact_text"])
        require(all(pr[row_id][x] == route[x] and checker.meaningful(route, x)
                    for x in ("obstruction", "attempted_routes", "resume_condition")), "blocker narrative differs from reviewed routes")
        require(pr[row_id]["blocking_evidence"] == expected_evidence, "blocker must bind exact provenance manifests")
        require(type(route["routes"]) is list and route["routes"], "attempted routes absent")
        kinds = set()
        for item in route["routes"]:
            closed(item, {"kind", "description", "outcome", "evidence"}, "attempted route")
            require(item["kind"] in ROUTE_KINDS and item["outcome"] == "completed" and checker.meaningful(item, "description"), "incomplete/unreviewed route")
            require(type(item["evidence"]) is list and item["evidence"], "route evidence absent")
            for ref in item["evidence"]:
                reader.bound(ref, as_json=False)
            kinds.add(item["kind"])
        require(kinds == ROUTE_KINDS, "route coverage incomplete")


def consume_receipts(request, reader, manifest, names, closed_rows, checker):
    closed(request["receipts"], SUFFIXES, "receipt set")
    receipts, outputs = {}, {}
    for suffix in SUFFIXES:
        pair = request["receipts"][suffix]
        closed(pair, {"exit", "output"}, "receipt pair")
        receipt = reader.bound(pair["exit"])
        data = reader.bound(pair["output"], as_json=False)
        require(type(receipt.get("exit_code")) is int and receipt["exit_code"] == 0, "nonzero/noninteger receipt exit")
        require(receipt.get("raw_output_sha256", receipt.get("output_sha256")) == digest(data), "receipt output hash mismatch")
        receipts[suffix], outputs[suffix] = receipt, data.decode("utf-8-sig")
    commands = {"source-inventory": SESSION / "verify-reviewed-source-coverage.py",
                "audits": SESSION / "validate-closed-row-audits-v3.py",
                **{k: ROOT / "tools/architecture" / v for k, v in
                   {"layout": "check_layout.py", "tiers": "check_tiers.py", "compatibility": "check_compatibility.py", "hygiene": "check_placeholders.py"}.items()}}
    for suffix, path in commands.items():
        command = receipts[suffix].get("command")
        require(type(command) is list and len(command) >= 2 and isinstance(command[0], str)
                and (command[0].endswith("python3") or command[0].endswith("python.exe")), "wrong Python command")
        require((reader.root / command[1]).resolve() == path.resolve(), "wrong Python producer")
        require(command[2:] == (["--validate"] if suffix == "audits" else []), "wrong Python argument tail")
        reader.raw(path)
    require(receipts["declarations"].get("argv") == ["lake", "env", "lean", manifest["check_file"]], "wrong declaration argv")
    require(receipts["focused-build"].get("argv") == ["lake", "--quiet", "--log-level=error", "build", "ComputationalMathematics.Source.LeVeque.Chapter01"], "wrong focused build")
    require(receipts["full-build"].get("argv") == ["lake", "--quiet", "--log-level=error", "build"], "wrong full build")
    lake = tomllib.loads(reader.raw(reader.root / "lakefile.toml").decode())
    require(lake["defaultTargets"] == ["ComputationalMathematics", "NumStability"], "default build targets changed")
    for suffix in ("declarations", "focused-build", "full-build"):
        receipt = receipts[suffix]
        require(receipt.get("input_commit") == manifest["input_commit"] and type(receipt.get("elapsed_ms")) is int and receipt["elapsed_ms"] >= 0, "native receipt context/duration mismatch")
    for marker in ("unclassified modules: 0", "mixed modules: 0", "modules missing module docs: 0", "legacy naming exceptions: 0", "declaration-bearing umbrellas: 0", "unsorted aggregate imports: 0", "Layout contract satisfied"):
        require(marker in outputs["layout"], "clean layout marker missing: " + marker)
    audit = parse(outputs["audits"].encode())
    require(audit.get("mode") == "released-complete-validation" and type(audit.get("closed_rows")) is int
            and audit["closed_rows"] == len(closed_rows), "complete audit validation missing")
    require([x["row"] for x in audit["records"]] == [x["id"] for x in closed_rows], "closed audit coverage mismatch")
    for record, row in zip(audit["records"], closed_rows, strict=True):
        require(type(record.get("exit_code")) is int and record["exit_code"] == 0
                and record["decision_sha256"] == digest(reader.raw(reader.path(row["faithfulness_decision"]))), "audit result changed")
    axioms = []
    for name in names:
        matches = re.findall(re.escape("'" + name + "' depends on axioms:") + r"\s*\[([^\]]*)\]", outputs["declarations"])
        require(len(matches) == 1, "missing/duplicate axiom report: " + name)
        found = sorted({x.strip() for x in matches[0].split(",") if x.strip()})
        require(set(found) <= set(checker.ALLOWED_AXIOMS), "unexpected axiom")
        axioms.append({"name": name, "axioms": found})
    require(not re.search(r"(?m)^.*\.lean:\d+:\d+: error:", outputs["declarations"]), "declaration error")
    return receipts, axioms


def payloads_for(g, context, names, axioms, checker, reader=None):
    organization = g["verification_loops"]["organization_completeness"]
    paths, mismatches = checker.cross_gate_state(ROOT, organization)
    require(not mismatches, "cross-gate organization mismatch")
    if reader is not None:
        for path in paths:
            reader.raw(reader.path(path))
        require(checker.cross_gate_state(ROOT, organization) == (paths, mismatches), "cross-gate state changed")
    rows = sorted(g["rows"], key=lambda r: r["id"])
    accepted = [r for r in rows if r["status"] in checker.CLOSED_LEAN_STATUSES]
    payloads = {
        "source_inventory": {"row_ids": [r["id"] for r in rows], "page_coverage": [{k: r[k] for k in ("printed_page", "pdf_page")} | {"row_id": r["id"]} for r in rows], "printed_page_range": list(context["printed_range"]), "pdf_page_range": list(context["pdf_range"])},
        "organization_scan": {"counters": organization, "unit_report": {"gate_path": GATE.relative_to(ROOT).as_posix(), "chapter": 1, "unit_audit_epoch": context["bindings"]["unit_audit_epoch"], "unit_index_sha256": context["bindings"]["unit_index_sha256"], "counters": organization}, "cross_gate_consistency": {"gate_paths": paths, "counters": organization, "mismatches": []}},
        "faithfulness_audit": {"rows": [{"row_id": r["id"], **{k: checker.text(r, k) for k in ("contract_hash", "source_contract_sha256", "blind_sha256", "direct_sha256", "round_trip_sha256", "adjudication_sha256")}} for r in accepted]},
        "declaration_resolution": {"declarations": names}, "axiom_check": {"declarations": axioms},
        "hygiene_check": {"findings": [], "scanned_paths": context["lean_changed_paths"]},
        "focused_build": {"passed": ["ComputationalMathematics.Source.LeVeque.Chapter01"]},
        "full_build": {"passed": ["ComputationalMathematics", "NumStability"]},
    }
    counts = {"source_inventory": len(rows), "organization_scan": len(paths), "faithfulness_audit": len(accepted), "declaration_resolution": len(names), "axiom_check": len(names), "hygiene_check": 0, "focused_build": 1, "full_build": 2}
    return payloads, counts


def validate_proposed(g, context, checker, reader=None):
    check_header(g, context, checker)
    errors = []
    used = set()
    for i, row in enumerate(g["rows"]):
        loc = f"rows[{i}]"
        if reader is not None and row["status"] in checker.CLOSED_LEAN_STATUSES:
            for path_field, hash_field in checker.ROW_ARTIFACT_REFS.values():
                relative = (GATE.parent.relative_to(ROOT) / row[path_field]).as_posix()
                reader.raw(reader.path(relative), row[hash_field])
        errors.extend(checker.row_defects(row, 1, context["printed_range"], context["pdf_range"], location=loc)[0])
        errors.extend(checker.row_artifact_defects(row, 1, context, GATE.parent, used, location=loc))
    errors.extend(checker.depends_on_defects(keyed(g["rows"])))
    errors.extend(checker.dependency_defects(keyed(g["rows"]), []))
    loop_errors, loops, readings = checker.loop_defects(g["verification_loops"], 32)
    errors.extend(loop_errors)
    errors.extend(checker.mode_defects(g, 1, context["printed_range"], context["pdf_range"])[0])
    defects, complete = checker.evidence_defects(g["verification_evidence"], gate_path=GATE, chapter=1, context=context, rows=g["rows"], organization=readings.get("organization_completeness", {}), used_artifacts=used)
    errors.extend(defects)
    require(not errors and all(complete.values()) and loops["organization_completeness"] and loops["semantic_equivalence"], "released proposed-record checks failed: " + repr(errors))
    require(g["bindings"] == context["bindings"] and g["chapter_gate"] == "BLOCKED", "proposal binding/verdict mismatch")
    return complete


def load_checker(reader):
    require(sys.flags.optimize == 0, "optimized Python is not permitted for released checks")
    reader.raw(HERE / "blocked_gate_binding.py")
    reader.raw(HERE / "input.schema.json")
    for path, expected in PINS.values():
        reader.raw(path, expected)
    spec = importlib.util.spec_from_file_location("released_blocked_preparation_gate", CHECKER)
    checker = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(checker)
    reader.raw(checker.MODULE_ROOT.parent / "source" /
               "LeVeque_Finite_Volume_Methods_for_Hyperbolic_Problems_2002.pdf", SOURCE_SHA)
    return checker


def make_ref(path):
    return {"path": path.relative_to(ROOT).as_posix(), "sha256": sha(path)}


def prepare(request_path, request_sha, label):
    require(os.name != "nt", "use the prepared POSIX launcher")
    require(re.fullmatch(r"[a-z0-9][a-z0-9-]*", label), "unsafe output label")
    reader = Reader(ROOT)
    checker = load_checker(reader)
    identities = parse(reader.raw(PINS["row_set"][0]))
    request = parse(reader.raw(regular(request_path.absolute()), request_sha))
    closed(request, {"schema_version", "kind", "base_gate", "proposed_rows", "check_inputs", "source_manifest", "question_projection", "route_manifest", "receipts"}, "request")
    require(type(request["schema_version"]) is int and request["schema_version"] == 1 and request["kind"] == "blocked-gate-binding-request", "request schema")
    base = reader.bound(request["base_gate"])
    require(reader.path(request["base_gate"]["path"]).resolve() != GATE.resolve(),
            "base_gate must be a separate immutable snapshot")
    original = reader.raw(GATE)
    require(digest(original) == request["base_gate"]["sha256"], "operational gate differs from pinned base snapshot")
    require(base.get("chapter_gate") == "ACTIVE", "base must be ACTIVE")
    context = checker.current_context(GATE, 1)
    check_header(base, context, checker)
    require(base["bindings"] == context["bindings"], "base context stale")
    proposed = reader.bound(request["proposed_rows"])
    closed(proposed, {"rows"}, "proposed rows")
    check_transition(base, proposed["rows"], identities, checker)
    check_provenance(request, proposed["rows"], context, reader, checker, identities)
    m = reader.bound(request["check_inputs"])
    require(m["bindings"] == context["bindings"] and m["input_commit"] == context["lean_current_head"]
            and m["rows_sha256"] == checker.canonical_sha256(base["rows"])
            and m["source_gate_sha256"] == digest(original), "native input manifest not bound to exact ACTIVE base")
    accepted = sorted([r for r in proposed["rows"] if r["status"] in checker.CLOSED_LEAN_STATUSES], key=lambda r: r["id"])
    names = sorted({n for row in accepted for n in row["lean_declarations"]})
    require(names == m["declarations"] and type(m["count"]) is int and len(names) == m["count"] == 32, "declaration set mismatch")
    require([x["row"] for x in m["files"]] == [x["id"] for x in accepted], "native file manifest coverage/order mismatch")
    for item, row in zip(m["files"], accepted, strict=True):
        require(item["declarations"] == row["lean_declarations"] and item["contract_hash"] == row["contract_hash"]
                and item["audit_task"] == row["faithfulness_task"], "native manifest row metadata mismatch")
    for item in m["files"]:
        reader.raw(reader.path(item["path"]), item["sha256"])
    reader.raw(reader.path(m["check_file"]), m["check_file_sha256"])
    receipts, axioms = consume_receipts(request, reader, m, names, accepted, checker)
    g = parse(encode(base))
    g["rows"], g["chapter_gate"] = proposed["rows"], "BLOCKED"
    require(all(type(v) is int and v == 0 for v in g["verification_loops"]["organization_completeness"].values()), "organization debt")
    payloads, counts = payloads_for(g, context, names, axioms, checker, reader)
    subject = checker.canonical_sha256({"book_id": checker.BOOK_ID, "unit_kind": "chapter", "unit": 1, "chapter": 1, "source_unit_sha256": checker.PINNED_SOURCE_SHA256, "mode": "default", "excluded_rows": [], "rows": g["rows"]})
    bindings = checker.global_artifact_bindings(1, context, subject)
    output = HERE / "runs" / label
    require(not output.exists(), "output already exists")
    require(output.resolve().is_relative_to(HERE.resolve()), "unsafe output path")
    primary = {"source_inventory": "source-inventory", "organization_scan": "layout", "faithfulness_audit": "audits", "declaration_resolution": "declarations", "axiom_check": "declarations", "hygiene_check": "hygiene", "focused_build": "focused-build", "full_build": "full-build"}
    reader.unchanged()
    output.mkdir(parents=True)
    for name in checker.EVIDENCE_NAMES:
        command = receipts[primary[name]]["command"]
        command = command if isinstance(command, str) else json.dumps(command)
        artifact = {"schema_version": 1, "check": name, "bindings": bindings, "command": command, "exit_code": 0, "count": counts[name], "payload": payloads[name]}
        path = output / (name + ".json")
        path.write_bytes(encode(artifact))
        reader.raw(path, digest(encode(artifact)))
        g["verification_evidence"][name] = {"command": command, "artifact": path.relative_to(GATE.parent).as_posix(), "artifact_sha256": sha(path), "exit_code": 0, "count": counts[name]}
    complete = validate_proposed(g, context, checker, reader)
    require(checker.current_context(GATE, 1) == context, "controlled context changed during preparation")
    require(checker.cross_gate_state(ROOT, g["verification_loops"]["organization_completeness"]) ==
            (payloads["organization_scan"]["cross_gate_consistency"]["gate_paths"], []), "cross-gate set changed during preparation")
    reader.unchanged()
    require(GATE.read_bytes() == original, "operational gate changed during preparation")
    (output / "proposed-gate.json").write_bytes(encode(g))
    reader.raw(output / "proposed-gate.json", digest(encode(g)))
    report = {"schema_version": 1, "kind": "prepared-blocked-gate-proposal", "status": "PREPARED_UNVERIFIED", "request": {"path": str(request_path.absolute()), "sha256": request_sha}, "question_projection": request["question_projection"], "base_gate_sha256": digest(original), "proposed_gate": make_ref(output / "proposed-gate.json"), "gate_subject_sha256": subject, "input_commit": context["lean_current_head"], "bindings": context["bindings"], "closed_declarations": names, "complete_proposed_evidence_checks": complete, "audit_argument_tail": ["--validate"], "native_input_projection": {"original_manifest": request["check_inputs"], "base_rows_sha256": m["rows_sha256"], "proposed_rows_sha256": checker.canonical_sha256(g["rows"]), "justification": "All accepted/skipped row objects and all closed declaration/native inputs remain identical; only the nine reviewed statuses/details and global evidence/verdict are projected."}, "input_files": [{"path": str(p), "sha256": h} for p, h in sorted(reader.observed.items())], "artifacts": [make_ref(output / (name + ".json")) for name in checker.EVIDENCE_NAMES], "terminal_verification": "NOT_RUN: root must independently install the exact reviewed proposed bytes, then run verify-installed. No operational gate was written."}
    reader.unchanged()
    (output / "preparation.json").write_bytes(encode(report))
    return {"status": report["status"], "preparation": make_ref(output / "preparation.json")}


def terminal_output_ok(output, exit_code):
    require(type(exit_code) is int and exit_code == 0, "released checker failed")
    require("LeVeque chapter gate: BLOCKED; derived: BLOCKED; chapter: 1; mode: default; rows: 57" in output, "released checker did not derive exact BLOCKED")
    require("status_counts: HARD_BLOCKED=9, PROVED=15, REUSED=17, SKIPPED=16" in output, "terminal status counts differ")
    require("formalized_objects=32; remaining_objects=9; formalization_denominator=41; formalization_percentage=78.05%; skipped=16; deferred=0" in output, "terminal denominator changed")
    require("  DEFECT " not in output and "  actionable:" not in output and "  blocked: 9 -> " in output, "terminal defect/actionable work")
    for loop in ("organization_completeness", "semantic_equivalence"):
        require("  loop " + loop + ": closed" in output, "terminal process debt")
    for name in ("source_inventory", "organization_scan", "faithfulness_audit", "declaration_resolution", "axiom_check", "focused_build", "full_build", "hygiene_check"):
        require("  evidence " + name + ": verified" in output, "terminal global evidence missing")


def verify_installed(preparation_path, preparation_sha, label, question_path, question_sha):
    require(os.name != "nt", "use the prepared POSIX launcher")
    require(re.fullmatch(r"[a-z0-9][a-z0-9-]*", label), "unsafe verification label")
    reader = Reader(ROOT)
    checker = load_checker(reader)
    prep = parse(reader.raw(preparation_path.absolute(), preparation_sha))
    require(prep.get("kind") == "prepared-blocked-gate-proposal" and prep.get("status") == "PREPARED_UNVERIFIED", "not a preparation record")
    require(question_sha == prep["question_projection"]["sha256"], "current question projection changed; reprepare")
    reader.raw(question_path.absolute(), question_sha)
    proposed = reader.bound(prep["proposed_gate"], as_json=False)
    require(reader.raw(GATE) == proposed, "operational gate is not the exact independently installed proposal")
    for item in prep["input_files"]:
        path = Path(item["path"])
        if path.resolve() != GATE.resolve():
            reader.raw(path, item["sha256"])
    for ref in prep["artifacts"]:
        reader.bound(ref)
    context = checker.current_context(GATE, 1)
    require(context["bindings"] == prep["bindings"], "installed controlled context changed")
    g = parse(proposed)
    validate_proposed(g, context, checker, reader)
    cross_gate_before = checker.cross_gate_state(ROOT, g["verification_loops"]["organization_completeness"])
    directory = preparation_path.absolute().parent
    require(directory.resolve().is_relative_to((HERE / "runs").resolve()), "verification output outside prepared runs")
    target = directory / (label + "-terminal.json")
    log_path = directory / (label + "-checker-output.txt")
    require(not target.exists() and not log_path.exists(), "verification output exists")
    command = [sys.executable, "-B", str(CHECKER), "check", str(GATE), "--unit", "1", "--mode", "default"]
    run = subprocess.run(command, cwd=ROOT, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    reader.unchanged()
    require(checker.current_context(GATE, 1)["bindings"] == context["bindings"], "context changed during released check")
    require(checker.cross_gate_state(ROOT, g["verification_loops"]["organization_completeness"]) ==
            cross_gate_before, "cross-gate set changed during released check")
    log_path.write_bytes(run.stdout)
    terminal_output_ok(run.stdout.decode("utf-8-sig"), run.returncode)
    result = {"kind": "released-blocked-gate-verification", "command": command, "exit_code": run.returncode, "output_sha256": digest(run.stdout), "gate_sha256": digest(proposed), "preparation_sha256": preparation_sha, "derived_verdict": "BLOCKED", "actionable_rows": 0, "integration_status": "not asserted", "operational_writes": []}
    target.write_bytes(encode(result))
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest="mode", required=True)
    for mode in ("prepare", "verify-installed"):
        sub = commands.add_parser(mode)
        sub.add_argument("--input", required=True, type=Path)
        sub.add_argument("--sha256", required=True)
        sub.add_argument("--label", required=True)
        if mode == "verify-installed":
            sub.add_argument("--current-question-projection", type=Path, required=True)
            sub.add_argument("--current-question-sha256", required=True)
    args = parser.parse_args()
    require(re.fullmatch(r"[0-9a-f]{64}", args.sha256), "invalid input digest")
    if args.mode == "prepare":
        result = prepare(args.input, args.sha256, args.label)
    else:
        result = verify_installed(args.input, args.sha256, args.label,
                                  args.current_question_projection, args.current_question_sha256)
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    try:
        main()
    except (ValueError, KeyError, TypeError, OSError) as exc:
        raise SystemExit("REJECTED: " + str(exc)) from exc
