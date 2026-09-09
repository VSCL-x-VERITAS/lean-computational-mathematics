"""Freeze preparation evidence only; no role execution or audit mutation."""
from pathlib import Path
from datetime import datetime,timezone
import json,hashlib
import recovery as r
import transport
D=r.D;E=D/'dim-d2-01';plan=r.read(E/'plan.json');mapping=r.read(E/'mapping.json')
for pin in plan['static_inputs']:r.verify(pin)
for key in ('input','mapping','manifest_before','runs_before'):r.verify(plan[key])
original,tr,manifest,runs,failed_uid,ruid=r.original_state();r.absent_attempt(r.P,'d2')
assert transport.reconstruct(r.verify(plan['input']).read_bytes(),mapping)==original
assert r.sha(r.O/'manifest.json')==plan['manifest_before']['sha256']
assert r.sha(r.O/'agent_outputs/agent_runs.json')==plan['runs_before']['sha256']
assert all(r.read(D/(x+'-exit.json'))['exit_code']==0 for x in ('tests','route','prepare'))
tests=r.read(D/'tests-final-01/guard-test-results.json');assert tests['count']==37
root='gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/direct-transport-recovery-v1'
review=f'''# Direct transport recovery preparation

This is a transport-only proposal for `{r.TID}`. No role was launched, no canonical audit output was written, and no production, gate, ledger, or Git state was changed. The original audit wrapper remains exit **1**.

The failure is actual and unstarted: `d_events.jsonl` has exactly one `thread.started` ({failed_uid}), no turn; native stderr reports `input_too_large`, maximum 1,048,576 characters, actual 1,442,614. Original input SHA256 is `{r.digest(original)}`, 1,466,535 UTF-8 bytes. There is no original direct final. The source and blind canonical outputs and their two runtime records exist. The completed native roundtrip attempt is pinned but uncollected; its semantic outcome is not used to construct the direct input.

The sealed v1 router returned version 1.1.0 and verified all 42 kit checksums. `route-exit.json` records actual exit 0. The unchanged adjudicator V3 precedent is pinned to `a2dddf4c3d7ca324f44fe9034b76964514d4c1e4eee96ea72bb5e48f90ff9887`; only its mechanical hashing, file creation, unstarted-failure guard and completed-manifest transition are reused. Its adjudicator input builder is never used.

## Exact representation

The prepared input is **{plan['compact_characters']:,} characters**, {len(r.verify(plan['input']).read_bytes()):,} UTF-8 bytes, with {r.LIMIT-plan['compact_characters']:,} characters of headroom. The measured native limit is in characters. It is not a byte-limit claim.

1. Every JSON document first loses only whitespace outside strings. Duplicate keys and nonfinite constants are rejected. Every string escape, number and other nonformatting byte is preserved.
2. In `dependency_inventory.json` only, 175 long string tokens are represented by exact UTF-8 ranges of the **unchanged, fully verbatim direct review packet** in the same prompt. Each marker explicitly denotes a JSON string, never a missing value or new object. The exact original ASCII/non-ASCII quoting mode is checked against the original token. No semantic comparison is performed.
3. Only the large inventory and native-environment JSON representations use the raw-byte dictionary: 443 verbatim canonical blocks and 1,712 duplicate-range references. Their common substrings need not be whole declarations. References mean exact concatenation, including when they occur within a JSON token or expression. Block markers are transport syntax. These blocks contain no packet-string references and no nested dictionary references. The canonical direct packet, role instructions, source contract, methodology, interpretations, checks and document headers are excluded from this raw-byte dictionary.
4. The independent reverse path restores each raw-byte block reference, each exact JSON token, and each original JSON file's pinned formatting, then proves equality with **every byte of the original complete direct input**. JSON parsed values are separately equal. The entire canonical direct packet is separately checked as a unique unchanged contiguous byte span. All five source image paths/order/hashes remain exact.

The representation adds only explanatory transport syntax. It adds no evidence, summaries, blind translation, other judgment, target proof, requested conclusion, or source interpretation. The direct role keeps the original isolation rules and remains a fresh, one-turn, tool-free Codex invocation. Numerous mechanical references are a practical reading burden; no improved judgment or acceptance is claimed.

## Guarded execution after root review

The immutable plan is `{root}/dim-d2-01/plan.json`, SHA256 `{r.sha(E/'plan.json')}`. The runner is `{root}/recovery.py`, SHA256 `{r.sha(D/'recovery.py')}`. The plan pins all existing orchestration files, source/direct inputs, original wrapper receipt/output/stderr, collector and runner, native executable, released kit files, config, source PDF and images, plus snapshots of prepared manifest and two runtime records. Preparation and execution both reject changed inputs, an existing d2 attempt, a started/finished original direct attempt, a completed decision, or unexpected canonical role state.

After explicit root review, run from the repository root with native Python:

```text
C:/Users/qed_s/AppData/Local/Programs/Python/Python312-arm64/python.exe -X utf8 -B {root}/recovery.py execute {root}/dim-d2-01/plan.json --plan-sha256 {r.sha(E/'plan.json')}
```

Execution validates the prepared audit through the unchanged released POSIX launcher, then uses the original native command with only the output attempt stem changed to d2 and the lossless input supplied. It records separate start/completed transport records, exact input, events, stderr and actual exit. A successful role must expose one new unique thread, one started/completed turn, no failed/tool events. The unchanged collector independently checks the real session metadata, final output, schema, hashes and tool-free history; it appends the direct runtime rather than rewriting either earlier runtime.

The same unchanged collector then collects the already completed original roundtrip attempt; its prior input/output/transport/events bytes stay exact. The runner checks precisely one appended runtime for each role and retains the prepared manifest. It calls the unchanged released `finalize_audit.py TASK --check-adjudication` with actual stdout/stderr/exit recorded.

If adjudication is required, the runner returns a specifically named successful **transport/collection** state, with `audit_completed=false`; it does not create canonical adjudication triggers, launch an adjudicator, or write a decision. Root can subsequently run unchanged q with all four canonical outputs available, or separately review an additive adjudicator transport if a genuine new capacity failure occurs. If adjudication is not required, the runner invokes unchanged released finalization and complete validation, permitting only the released manifest completion fields to change. It reports the actual decision verbatim, without requiring or inferring acceptance.

Every failure keeps actual outputs and its real exit in a new execution receipt. The original wrapper receipt remains exit 1 in every branch. Invalid model JSON is not repaired or continued by this helper.

## Actual validation and preserved preparation history

`tests-exit.json`, `prepare-exit.json`, and `route-exit.json` are actual subprocess exit-0 receipts with complete stdout/stderr hashes. The 37 synthetic tests include complete reconstruction and persisted-map equality; token quoting/Unicode; changed/missing/reference/hash/range/JSON input failures; extra other-role input; stale pins; existing attempt; reused runtime ID; wrong role; missing turn; tool events; nonzero native status; modified prior runtime; and a failure that actually started a turn.

The earlier `candidate-input.txt`/`candidate-map.json` and exploratory scripts are retained as clearly unused measurements; their oversized transport is not the selected plan. Only `dim-d2-01/input.txt` and its pinned mapping are executable. No active audit file was modified during these measurements, tests, preparation or freeze.
'''
r.create(D/'REVIEW.md',review.encode())
selected=[D/x for x in ['recovery.py','transport.py','compact.py','test_guards.py','capture.py','freeze.py','REVIEW.md',
 'tests-exit.json','tests-output.txt','tests-stderr.txt','route-exit.json','route-output.txt','route-stderr.txt',
 'prepare-exit.json','prepare-output.txt','prepare-stderr.txt','tests-final-01/guard-test-results.json',
 'dim-d2-01/plan.json','dim-d2-01/input.txt','dim-d2-01/mapping.json','dim-d2-01/manifest-before.json','dim-d2-01/agent-runs-before.json']]
r.write(D/'manifest.json',{'format':'direct-transport-recovery-preparation-files-1','files':[r.ref(p) for p in selected]})
receipt={'format':'direct-transport-recovery-preparation-receipt-1','created_at_utc':r.now(),
 'task_id':r.TID,'manifest':r.ref(D/'manifest.json'),'review':r.ref(D/'REVIEW.md'),
 'runner':r.ref(D/'recovery.py'),'plan':r.ref(E/'plan.json'),'input':r.ref(E/'input.txt'),'mapping':r.ref(E/'mapping.json'),
 'original_input':r.ref(r.P/'d_input.txt'),'original_wrapper':r.ref(r.T/'role-run-receipt.json'),
 'original_wrapper_exit_code':1,'native_character_limit':r.LIMIT,'original_characters':plan['original_characters'],
 'compact_characters':plan['compact_characters'],'compact_bytes':(E/'input.txt').stat().st_size,
 'tests_actual_exit_code':0,'tests_count':37,'route_actual_exit_code':0,'prepare_actual_exit_code':0,
 'complete_original_reconstruction_verified':True,'full_direct_packet_verbatim':True,
 'five_original_images_unchanged':True,'all_original_static_pins_unchanged':True,
 'roles_invoked':False,'audit_completed':False,'operational_task_mutated':False}
r.write(D/'receipt.json',receipt)
print(json.dumps({'receipt':r.ref(D/'receipt.json'),'manifest':r.ref(D/'manifest.json'),'runner':receipt['runner'],'plan':receipt['plan'],'input':receipt['input'],'mapping':receipt['mapping'],'review':receipt['review']},indent=2))
