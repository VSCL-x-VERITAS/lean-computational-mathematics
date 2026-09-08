This is an additive, unexecuted proposal for a blocked-specific evidence binder. It changes no operational gate, accepted audit, released script, final-PASS binder, source, topology or ledger. The fixture suite supplies synthetic inputs only. Root must review this implementation and supply real final evidence before either operationally relevant CLI mode is used.

`blocked_gate_binding.py prepare` writes a new immutable proposal directory beneath this folder. Its only successful status is `PREPARED_UNVERIFIED`. It does not install the proposed gate or claim that the released checker derived a terminal verdict. `verify-installed` is a separate read-only check of an exact proposal independently installed by root. It executes the unchanged released checker on the actual configured gate path and records terminal success only when that checker derives BLOCKED with zero actionable rows and all required evidence verified. It never writes that gate.

The hypothetical endpoint is precisely 15 PROVED, 17 REUSED, 9 HARD_BLOCKED and 16 SKIPPED: 32/41 formalized, 9 remaining, 78.05%, not PASS. `expected-row-set.json` pins the exact identities and original accepted statuses. It is an identity restriction, not a finding that any of the nine rows is blocked. If even one row becomes accepted, has further local work, or lacks an independent material user choice, this all-nine scenario must be rejected and separately redesigned. There is no fallback classification.

The retained final-PASS binder is SHA256 `7d2a1b34d4e2450d83a17f6ea4d39f54f0a9254f28ecae70d096d23448c7c3af`; validatorV3 is `546d85ce56481fede6b4cfb4d07aa7da76ce8f7fa5fdb6d2e62db7c08434911e`. The released gate checker is `3e9cc58beb58f9f63f2736c4d50125ca6c42116104b64982f3dfc2d3f8afb104`. All are checked before use, together with the original source inventory checker, declaration-input preparer, and exact row-set file. The helper and input schema bytes are included in each preparation's observed input pins. None of these protected files is rewritten.

Input transport is specified in `input.schema.json`. All referenced input paths are regular files beneath the Lean repository, expressed as repository-relative POSIX paths; SHA256 values are lowercase hexadecimal. Symlinks, path traversal, duplicate JSON keys, non-JSON numeric constants and changed bytes are rejected. Runtime cross-document guards and the unchanged released gate APIs are authoritative in addition to this transport schema; the helper does not require a JSON Schema library or access a remote schema.

The request object contains exactly:

```text
schema_version: 1
kind: "blocked-gate-binding-request"
base_gate: {path, sha256}
proposed_rows: {path, sha256}
check_inputs: {path, sha256}
source_manifest: {path, sha256}
question_projection: {path, sha256}
route_manifest: {path, sha256}
receipts: {
  source-inventory, layout, tiers, compatibility, hygiene, audits,
  declarations, focused-build, full-build
}
```

Each receipt-set value is exactly `{exit: {path, sha256}, output: {path, sha256}}`. `base_gate` must identify a separate immutable snapshot with the exact current ACTIVE gate bytes, not the operational gate itself. `proposed_rows` identifies an object containing only `rows`, the complete 57-row array in the original order. Accepted and skipped row content, JSON value types and field ordering must remain identical. For the nine choice rows, the only permitted field changes are `status`, `blocker_kind`, `obstruction`, `attempted_routes`, `blocking_evidence`, `resume_condition`, `next_foundation`, `next_action`, `open_reason`, and `current_target`. Attribution, dependencies, source-proof fields, existing audit metadata, and all other content remain identical. The four local-action fields and `blocked_by` must be absent or empty afterward.

Every proposed choice row must have `status: "HARD_BLOCKED"`, `blocker_kind: "material-user-choice"`, and meaningful **strings** for all four blocker narrative fields. Arrays or objects are rejected. `obstruction`, `attempted_routes`, and `resume_condition` must exactly equal the corresponding reviewed route-manifest row. `blocking_evidence` must be the following literal construction, in this order, with actual request references substituted:

```text
source_manifest=<path>#sha256=<sha>; question_projection=<path>#sha256=<sha>; route_manifest=<path>#sha256=<sha>
```

The three provenance documents have these exact roles:

| Document | Required content and guards |
|---|---|
| `material-choice-source-boundaries` | `schema_version`, `kind`, immutable `source` reference, and exactly nine `rows`. Each row has `row_id`, `source_locator`, nonempty `frozen_audits`, and a meaningful `boundary` string. The PDF bytes and each locator's `source_sha256` must equal the selected source pin `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`. Every referenced locator and frozen audit is hash checked. Boundary statements remain reviewed descriptions, not new source facts. |
| `current-material-choice-projection` | `schema_version`, `kind`, `thread_id`, `as_of_utc`, `projection_review`, `provenance`, `questions`, and explicit `replies`. A question has `question_id`, `row_ids`, `exact_text`, `record`, `record_sha256`, `timestamp`, `status` (`pending` or `answered`), and `mapping_review`. A reply has `question_id`, `exact_text`, `record`, `record_sha256`, and `timestamp`. Each selected question must explicitly map to its row, remain pending, and have no reply in the projection. Exact text must occur as a complete JSON string value in the bound original record, or equal the complete plaintext record after final newline removal. `record_sha256` is the hash of those exact record-file bytes, not an unverifiable hash of an omitted original line. All timestamps use UTC `Z`; replies cannot precede their question or exceed the projection cutoff. |
| `reviewed-local-work-exhaustion` | `schema_version`, `kind`, actual current `input_commit`, exact released context `bindings`, `source_manifest_sha256`, `question_projection_sha256`, `reviewer`, `reviewed_at_utc`, and exactly nine `rows`. Review time cannot precede the question projection. Each row has `row_id`, `question_id`, literal `all_local_work_complete: true`, literal `remaining_local_actions: []`, three reviewed narrative strings, and nonempty `routes`. Each route has `kind`, meaningful `description`, literal `outcome: "completed"`, and nonempty hash-bound `evidence`. Every row must cover source-review, canonical-reuse, mathematical-alternatives, native-checks, organization, consumer-checks, and review. |

The projection must be a current, reviewed record of all relevant questions and replies from the authorized conversation. This program cannot establish that an export omitted no later message. Root must supply the latest truthful projection again at `verify-installed`; a changed hash forces a new preparation. The distinct interface-flux question can be recorded with its actual root-supplied ID, exact text and record. No old question ID or eternal pending state is hard-coded. An answer, changed mapping, or newly feasible local route is a reason to revisit the proposed row classification, not to manufacture a replacement pending question.

The helper verifies evidence bytes, explicit associations and declared completion. It cannot prove the truth of source-boundary interpretations, completeness of a conversation export, or exhaustion of feasible local mathematics from strings. Those are substantive root/reviewer findings that must exist before use. Hashing an unsupported assertion does not turn it into evidence. No semantic equality, source adoption, user decision, audit acceptance or successful local route is inferred here.

`check_inputs` must be the unchanged `prepare-closed-row-checks.py` output generated for the exact current ACTIVE snapshot, without `--inventory-only` and without `--require-all-closed`. It retains the original `source_gate_sha256`, `rows_sha256`, actual `input_commit`, bindings, sorted 32 names, count, current target-file hashes and check-file hash. The helper checks the exact row/file/declaration/task/contract correspondence. Actual native receipts must match that input commit. It records both the original and proposed row hashes as an explicit projection; it never relabels the original manifest as if it had been generated against the future row statuses. Accepted declarations and controlled mathematical inputs must be identical under the projection.

All nine actual receipt-producing commands from binderV3 remain required:

| Receipt | Required command and validation |
|---|---|
| source-inventory | Exact pinned `verify-reviewed-source-coverage.py`, no argument tail. |
| layout, tiers, compatibility, hygiene | Exact respective `tools/architecture/check_layout.py`, `check_tiers.py`, `check_compatibility.py`, `check_placeholders.py`, no argument tails; all actual exits zero. Preserve the seven exact clean-layout markers and four measured zero organization counters. |
| audits | Exact pinned `validate-closed-row-audits-v3.py` with **only `--validate`**. Output must be `released-complete-validation`, contain all 32 sorted closed records with actual zero exits, and match each current sealed decision hash. The final-PASS binder's separate `--validate --require-all-closed` behavior is untouched. Inventory-only output, omitted validation, and extra arguments are rejected. |
| declarations | Exact native argv `lake env lean <manifest.check_file>`, actual exit zero, matching native input commit and nonnegative integer elapsed time. Require one axiom report for each of the 32 names, no Lean error, and only `propext`, `Classical.choice`, `Quot.sound`. |
| focused-build | Exact native argv `lake --quiet --log-level=error build ComputationalMathematics.Source.LeVeque.Chapter01`, actual exit zero and matching input commit/duration. |
| full-build | Exact native argv `lake --quiet --log-level=error build`, actual exit zero and matching input commit/duration. `lakefile.toml` default targets must remain exactly `ComputationalMathematics`, `NumStability`. |

All raw output hashes and integer exit codes are checked. The audit validator's complete accepted-decision, stronger-result applicability and nonvacuity validation remains unchanged; this binder consumes its actual completed output and does not substitute a weaker independent audit. Raw checks may be reused only when their original conditions and current input bindings actually hold. Fresh final runs are the straightforward evidence path.

The eight generated artifacts use the same released payloads and `global_artifact_bindings`: source inventory covers all 57 rows; organization covers the actual cross-gate path set and equal zero counters; faithfulness covers the 32 accepted rows only; declaration and axiom checks cover the exact 32 names; hygiene covers the full released changed-path set; focused/full builds name the exact one/two targets. All artifact schemas, row-artifact checks, dependency checks, mode checks, and semantic/organization loop checks remain required. The unchanged released `evidence_defects` must return no defects and all eight complete. No successful audit entry is generated for a blocked row.

Preparation preserves every base top-level field except the nine permitted row transitions, eight global evidence records, and proposed `chapter_gate: "BLOCKED"`. The full proposed row array has a new gate-subject hash. The base remains ACTIVE on disk. All consumed file bytes, accepted row artifacts, cross-gate paths, source/question/route evidence, controlled context and current head are rechecked for concurrent changes. A changed controlled source, policy or build context rejects preparation or installed verification. A later gate/ledger-only commit may change the current Git head while retaining the exact controlled bindings; the original native input commit stays recorded truthfully. No claim about integration or reconciliation follows.

From the workspace root, future reviewed CLI use is:

```powershell
python workflow-v5.0.1-local/run_workflow_posix.py lean-computational-mathematics/gates/leveque-finite-volume/artifacts/session-20260908/blocked-gate-binding-preparation/blocked_gate_binding.py prepare --input <absolute-request-file> --sha256 <reviewed-request-sha256> --label <new-lowercase-label>
```

`runs/<label>/` must not exist. Successful preparation contains eight evidence JSON files, `proposed-gate.json`, and `preparation.json`. The latter records `PREPARED_UNVERIFIED`, request/question pins, base and proposed gate hashes, full subject/bindings/current input commit, closed declarations, completed proposed-evidence checks, exact audit tail, native-input projection, all observed input-file hashes, and artifact references. It explicitly records terminal verification as not run. Failure may leave a partial newly created directory; never treat it as a completed proposal or overwrite it. Choose a new label after resolving the defect.

Root can then separately review all proposed bytes, capture current base/context/question pins, and install the exact proposal with independently reviewed atomic byte guards. This helper provides no installation mode. Only after independent installation may root run:

```powershell
python workflow-v5.0.1-local/run_workflow_posix.py lean-computational-mathematics/gates/leveque-finite-volume/artifacts/session-20260908/blocked-gate-binding-preparation/blocked_gate_binding.py verify-installed --input <absolute-preparation-file> --sha256 <reviewed-preparation-sha256> --label <new-verification-label> --current-question-projection <absolute-current-projection-file> --current-question-sha256 <current-projection-sha256>
```

Verification requires actual gate bytes to equal the pinned proposal, all frozen input/artifact hashes to remain identical (except the intentionally installed operational gate), current controlled bindings to match, and the supplied latest question projection to match preparation. It invokes the pinned checker with `check <actual-gate> --unit 1 --mode default`; **no `--require-pass`**. The actual output must derive BLOCKED, report exact 32/9/16 counts and 32/41 progress, omit actionable/defect lines, show nine blockers, close organization and semantic loops, and verify all eight evidence records. Zero exit alone is insufficient. A successful scratch terminal record contains the exact argv, actual exit/output/gate/preparation hashes, `derived_verdict: "BLOCKED"`, `actionable_rows: 0`, and `operational_writes: []`. It explicitly does not assert integration.

Remaining real inputs are the final reviewed row-specific exhaustion and source-boundary findings; exact current question/reply exports including the new interface question; a frozen, refreshed ACTIVE gate whose 32 accepted row artifacts are current; the final declaration-input manifest; all nine successful final command receipts; and root's independently reviewed installation/concurrency procedure. Campaign, organization and reconciliation stopping requirements remain separate. Neither CLI mode has been run against the operational gate during this preparation task.

Run the synthetic suite through the prepared POSIX launcher using `test_blocked_gate_binding.py` as the script. It imports the unchanged released checker and exercises pure evidence validation only against temporary fixtures under this folder. Synthetic receipt strings and parser output are plainly labeled and are not native build, source-audit, exhaustion or terminal receipts. The suite does not exercise an operational installation or a full real `prepare`/`verify-installed` run. Real stronger-result audit behavior is protected by the exact validator hash and required actual `--validate` receipt, not re-proved by synthetic tests.
