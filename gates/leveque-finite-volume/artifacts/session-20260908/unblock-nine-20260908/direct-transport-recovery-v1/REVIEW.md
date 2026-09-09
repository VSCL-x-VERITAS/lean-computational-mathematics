# Direct transport recovery preparation

This is a transport-only proposal for `LEV-CH01-COORDINATE-HIGH-RESOLUTION-METHODS-PRODUCTION-20260908`. No role was launched, no canonical audit output was written, and no production, gate, ledger, or Git state was changed. The original audit wrapper remains exit **1**.

The failure is actual and unstarted: `d_events.jsonl` has exactly one `thread.started` (01a082ae-9998-7bc2-9805-6eed05fa4c01), no turn; native stderr reports `input_too_large`, maximum 1,048,576 characters, actual 1,442,614. Original input SHA256 is `75b4f0d1728d1f55a608088eb421f3a5fab3f1e0b3555b7acf6940c0817cd53a`, 1,466,535 UTF-8 bytes. There is no original direct final. The source and blind canonical outputs and their two runtime records exist. The completed native roundtrip attempt is pinned but uncollected; its semantic outcome is not used to construct the direct input.

The sealed v1 router returned version 1.1.0 and verified all 42 kit checksums. `route-exit.json` records actual exit 0. The unchanged adjudicator V3 precedent is pinned to `a2dddf4c3d7ca324f44fe9034b76964514d4c1e4eee96ea72bb5e48f90ff9887`; only its mechanical hashing, file creation, unstarted-failure guard and completed-manifest transition are reused. Its adjudicator input builder is never used.

## Exact representation

The prepared input is **1,030,376 characters**, 1,049,763 UTF-8 bytes, with 18,200 characters of headroom. The measured native limit is in characters. It is not a byte-limit claim.

1. Every JSON document first loses only whitespace outside strings. Duplicate keys and nonfinite constants are rejected. Every string escape, number and other nonformatting byte is preserved.
2. In `dependency_inventory.json` only, 175 long string tokens are represented by exact UTF-8 ranges of the **unchanged, fully verbatim direct review packet** in the same prompt. Each marker explicitly denotes a JSON string, never a missing value or new object. The exact original ASCII/non-ASCII quoting mode is checked against the original token. No semantic comparison is performed.
3. Only the large inventory and native-environment JSON representations use the raw-byte dictionary: 443 verbatim canonical blocks and 1,712 duplicate-range references. Their common substrings need not be whole declarations. References mean exact concatenation, including when they occur within a JSON token or expression. Block markers are transport syntax. These blocks contain no packet-string references and no nested dictionary references. The canonical direct packet, role instructions, source contract, methodology, interpretations, checks and document headers are excluded from this raw-byte dictionary.
4. The independent reverse path restores each raw-byte block reference, each exact JSON token, and each original JSON file's pinned formatting, then proves equality with **every byte of the original complete direct input**. JSON parsed values are separately equal. The entire canonical direct packet is separately checked as a unique unchanged contiguous byte span. All five source image paths/order/hashes remain exact.

The representation adds only explanatory transport syntax. It adds no evidence, summaries, blind translation, other judgment, target proof, requested conclusion, or source interpretation. The direct role keeps the original isolation rules and remains a fresh, one-turn, tool-free Codex invocation. Numerous mechanical references are a practical reading burden; no improved judgment or acceptance is claimed.

## Guarded execution after root review

The immutable plan is `gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/direct-transport-recovery-v1/dim-d2-01/plan.json`, SHA256 `b9a42594413e08fe497b5e3c25e032b8d2f668f046007f471bc1fa8b19cdc99a`. The runner is `gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/direct-transport-recovery-v1/recovery.py`, SHA256 `f08b9863594b4121f6b30eb3789f64f07a62901b34b9172075329e90e360323c`. The plan pins all existing orchestration files, source/direct inputs, original wrapper receipt/output/stderr, collector and runner, native executable, released kit files, config, source PDF and images, plus snapshots of prepared manifest and two runtime records. Preparation and execution both reject changed inputs, an existing d2 attempt, a started/finished original direct attempt, a completed decision, or unexpected canonical role state.

After explicit root review, run from the repository root with native Python:

```text
C:/Users/qed_s/AppData/Local/Programs/Python/Python312-arm64/python.exe -X utf8 -B gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/direct-transport-recovery-v1/recovery.py execute gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/direct-transport-recovery-v1/dim-d2-01/plan.json --plan-sha256 b9a42594413e08fe497b5e3c25e032b8d2f668f046007f471bc1fa8b19cdc99a
```

Execution validates the prepared audit through the unchanged released POSIX launcher, then uses the original native command with only the output attempt stem changed to d2 and the lossless input supplied. It records separate start/completed transport records, exact input, events, stderr and actual exit. A successful role must expose one new unique thread, one started/completed turn, no failed/tool events. The unchanged collector independently checks the real session metadata, final output, schema, hashes and tool-free history; it appends the direct runtime rather than rewriting either earlier runtime.

The same unchanged collector then collects the already completed original roundtrip attempt; its prior input/output/transport/events bytes stay exact. The runner checks precisely one appended runtime for each role and retains the prepared manifest. It calls the unchanged released `finalize_audit.py TASK --check-adjudication` with actual stdout/stderr/exit recorded.

If adjudication is required, the runner returns a specifically named successful **transport/collection** state, with `audit_completed=false`; it does not create canonical adjudication triggers, launch an adjudicator, or write a decision. Root can subsequently run unchanged q with all four canonical outputs available, or separately review an additive adjudicator transport if a genuine new capacity failure occurs. If adjudication is not required, the runner invokes unchanged released finalization and complete validation, permitting only the released manifest completion fields to change. It reports the actual decision verbatim, without requiring or inferring acceptance.

Every failure keeps actual outputs and its real exit in a new execution receipt. The original wrapper receipt remains exit 1 in every branch. Invalid model JSON is not repaired or continued by this helper.

## Actual validation and preserved preparation history

`tests-exit.json`, `prepare-exit.json`, and `route-exit.json` are actual subprocess exit-0 receipts with complete stdout/stderr hashes. The 37 synthetic tests include complete reconstruction and persisted-map equality; token quoting/Unicode; changed/missing/reference/hash/range/JSON input failures; extra other-role input; stale pins; existing attempt; reused runtime ID; wrong role; missing turn; tool events; nonzero native status; modified prior runtime; and a failure that actually started a turn.

The earlier `candidate-input.txt`/`candidate-map.json` and exploratory scripts are retained as clearly unused measurements; their oversized transport is not the selected plan. Only `dim-d2-01/input.txt` and its pinned mapping are executable. No active audit file was modified during these measurements, tests, preparation or freeze.
