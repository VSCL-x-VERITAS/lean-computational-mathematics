# Exact staged role transport — root review only

`guard.py` is an additive native wrapper. It does not copy the semantic prompt builder, modify generated helpers, select a model/effort, invoke the collector, or infer an audit verdict. Its `prepare` mode evaluates the exact generated `r.py` AST only through `message = b''.join(parts)`, with file writes, directory creation, and subprocesses denied. All six prepared source images must already exist. It repeats construction and verifies identical message bytes, input records, and read-file hashes, then freezes the message and plan outside the audit directory. No role is launched in this mode.

The explicit `execute` mode requires the plan SHA, unchanged prepared helpers and inputs, an unused output stem, and a fresh prepared audit. It executes the unchanged `r.py` through `runpy`; its temporary subprocess hook checks the **actual** CLI stdin against the frozen message and the 1,048,576 UTF-8 byte cap immediately before delegating to the original subprocess implementation. The CLI command, source images, output paths, model selection, role prompt/schema, and neutral cwd are left to the unchanged `r.py`. The unchanged `c.py` must subsequently inspect real events/session metadata, enforce no tool use, copy exact output bytes, record actual model/effort, and run released validation.

Nine focused tests passed in `tests-01`: exact byte boundary, one-byte excess, multibyte UTF-8 excess, exact/repeated AST construction, blocked file write, blocked directory creation, blocked subprocess, unexpected message expression, and changed input hash. Tests never invoke a model. Actual source/blind measurements remain pending successful official preparation; direct/roundtrip/adjudicator measurements necessarily depend on actual earlier role outputs.

## Exact staged commands

Use native Python `C:/Users/qed_s/AppData/Local/Programs/Python/Python312-arm64/python.exe`, with `-X utf8 -B`. Let `G` be this folder's `guard.py`, `P` the fresh task's `faithfulness/orchestration`, and `TID` be `LEV-CH01-PHYSICAL-HIGH-RESOLUTION-COORDINATE-SWEEP-PRODUCTION-20260908`.

Prepare the first two plans without launching a role:

```text
PY -X utf8 -B G prepare source-contract s 25,26,27,28,125,126 --name source-01
PY -X utf8 -B G prepare blind-translation b "" --name blind-01
```

Use a structured subprocess argv list for the blind command so its empty pages argument is preserved. For example its final arguments are `['prepare', 'blind-translation', 'b', '', '--name', 'blind-01']`.

Review each measured plan and execute it only with its actual hash:

```text
PY -X utf8 -B G execute PLAN_JSON --plan-sha256 ACTUAL_PLAN_SHA
PY -X utf8 -B P/c.py TID s source-contract source_contract.json
PY -X utf8 -B P/c.py TID b blind-translation blind_translation.json
```

After actual validated source/blind outputs exist, prepare and review `direct-judge d 25,26,27,28,125,126 --name direct-01` and `roundtrip-judge r 25,26,27,28,125,126 --name roundtrip-01`, execute each exact plan, then call `c.py TID d direct-judge direct_judge.json` and `c.py TID r roundtrip-judge roundtrip_judge.json`.

Run released `finalize_audit.py TID --check-adjudication` through the unchanged POSIX launcher with the **fresh task config**. Preserve its actual stdout/exit (0 or 3). If required, write those exact stdout bytes once to `P/adjudication_triggers.json`, then prepare/review `adjudicator a 25,26,27,28,125,126 --name adjudicator-01`, execute, and collect `c.py TID a adjudicator adjudicator.json`. Do not manufacture triggers or predict adjudicator size before both judgments exist.

All released calls use `FAITHFULNESS_AUDIT_CONFIG=/c/Users/qed_s/OneDrive/Documents/ChatGPT/VSCL-x-VERITAS/lean-computational-mathematics/gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/LEV-CH01-PHYSICAL-HIGH-RESOLUTION-COORDINATE-SWEEP-PRODUCTION-20260908.config.json`, cwd at the repository, and `workflow-v5.0.1-local/run_workflow_posix.py`. Run prepared validation before launching stages; the wrapper also checks the original successful preparation receipt and current prepared manifest.

## Honest final aggregate

Do not invoke `q.py` simply to make a receipt: it automatically launches unmeasured later roles. The reviewed `prepare-source-context-binding-request-v2.py` reads only `role-run-receipt.json.exit_code == 0` and its exact `decision_sha256` before separately requiring real accepted/faithful-equivalent/both-yes decision contents.

The smallest additive finalizer should accept exact SHA-bound lists of actual guard execution receipts and captured collector receipts, verify all required role outputs/agent runs with the released validator, check the actual adjudication trigger/result, then run released `finalize_audit.py` and `validate_audit.py --phase complete`. Capture every actual command, stdout, stderr, timestamps, and exit. Only if all required steps actually succeed, create `T/role-run-receipt.json` **once** with:

- `format: staged-existing-r-c-audit-run-1` and `q_py_invoked: false`;
- `command`: the actual additive finalizer argv, with actual start/end timestamps;
- `role_steps`: exact plans, guarded native execution receipts, collector commands/receipts and runtime/agent-run pins;
- exact prepared transport, adjudication-check output, finalize and complete-validator receipts;
- `exit_code: 0`, exact `decision_sha256`, manifest/report hashes, and actual aggregate stdout/stderr hashes.

If finalization fails, preserve an attempt receipt elsewhere and leave the canonical aggregate absent. A successfully completed undetermined or negative audit may still have execution exit 0; record the actual decision without promoting it. The binding consumer independently rejects nonacceptance. An old failed `role-run-receipt.json`, if one exists, must remain immutable and requires an explicit additive binding successor instead of overwrite. No finalizer has been run or receipt invented here.

## Comparison with prior runtime-cap recoveries

The original DIM `d_stderr.txt` reports `max_chars=1048576`, `actual_chars=1442614`, before a semantic turn began. This wrapper uses the stricter UTF-8 **byte** cap and records both byte and character counts. Images remain separately hash-bound CLI attachments.

`direct-transport-recovery-v1/transport.py` kept the canonical direct packet verbatim while replacing duplicated JSON strings with exact references and checking reconstruction. `adjudicator-plaintext-dictionary-v1/recovery.py` additionally required independent reconstruction from its visible dictionary grammar. Those recovery programs are pinned to old task IDs, failures, role hashes, and lineage; they cannot be reused unchanged for this fresh task. If a new plan is oversized, this wrapper refuses launch and preserves the full bytes. Any lossless representation would need its own fresh task-bound, independently reviewed plan and reconstruction guards. Never truncate/summarize or silently change a blind packet.

This is transport preparation only. No source acceptance, new interpretation, or gate result follows from these checks.
