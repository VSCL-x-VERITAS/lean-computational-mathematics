# Qualified closure helpers for the nine selected rows

These are additive local adapters derived from `bind-equation10-interpreted-proved-row.py` and `validate-closed-row-audits-v3.py`. They do not change the released gate or sealed v1 audit kit, run model roles, decide faithfulness, or supply an audit verdict. No binder or operational validation was run during preparation.

The receipt `selected-interpretations.json` is pinned at `cfde240a9dda9a58be99f85369b43e99003b0024c7147a33ffa8b071ca7dcf34`. Its eight choices cover exactly nine rows. The user delegated unblocking all nine; the detailed conventions were coordinator-selected. Projected contracts say this explicitly and preserve the source-only account and original ambiguities. They do not claim detailed literal user answers.

## Input request

Write a fresh immutable JSON file inside the repository after an audit actually completes. All `File` values below are `{ "path": "repository/relative/path", "sha256": "64 lowercase hex digits" }`. A request is evidence, not acceptance authority; it must point to actual frozen files. `request.schema.json` documents the shape.

Required fields:

- `schema`: integer `1`.
- `row`: one of the nine row IDs in the pinned selection receipt.
- `status`: `PROVED` or `REUSED`. `REUSED` additionally requires the target file to be byte-identical at the integrated baseline reported by the released checker. The binder does not infer reuse from an existing filename.
- `task`, `manifest`, `decision`: `File` bindings to the exact new task and its completed sealed outputs.
- `interpretation_packet`: `File` binding to that task's `user-interpretation-packet.json`. Both this packet and the overall selection receipt must be exact configured, manifest-bound audit environment inputs.
- `current_bindings`: the actual `bindings` object from the released checker's current context, including the current code fingerprint. This must be obtained after source changes are frozen; do not copy a stale operational gate's bindings.
- `native`: the object described below.
- `strengthening_evidence`: required `File` only when the actual decision is `faithful-stronger`.

`native` contains `receipt_kind`, `check`, `output`, `receipt`, `proof_manifest`, and `declarations`. The four file fields are `File` values. `declarations` is a nonempty distinct list including the exact target. The input must contain literal `#check NAME` and `#print axioms NAME` lines for each selected declaration; the actual output must resolve each name and report allowed axioms, including the supported empty/universe-displayed forms. Diagnostics and `sorryAx` are rejected.

Two existing native receipt formats are supported:

1. `snapshots`: actual native `command` list `[...lake.exe, "env", "lean", CHECK]`, `cwd`, `output`, `output_sha256`, integer zero `exit_code`, `inputs_unchanged: true`, and `inputs` with `path`, `snapshot`, and equal `sha256_before`, `sha256_after`, `snapshot_sha256`. The check, target, toolchain and Lake package manifest must appear; every recorded source/snapshot is rehashed. Native Windows paths are mapped to the same files under POSIX replay. This directly supports the frozen material-review `checks-final/receipt.json`.
2. `argv`: actual receipt with `argv: ["lake", "env", "lean", CHECK]`, matching joined `command`, native `native_lake`, actual `input_commit`, `output_sha256` and integer zero `exit_code`. Its proof manifest must bind `check_file_sha256`.

For either format the proof manifest needs `files` entries with actual target `path`, `sha256` and a declaration list. Other metadata is allowed. Unsupported formats fail closed; do not invent a normalized receipt that purports to be an actual execution.

## Stronger evidence

An accepted stronger decision must have precisely `lean_implies_source=yes` and `source_implies_lean=no`. The supporting JSON contains integer `schema: 1`, `row`, `task_id`, exact `decision` and `manifest` File bindings, and:

- `applicability_audit`: verbatim reasoning from that decision's Lean-to-source implication.
- `genuine_strengthening`: verbatim reasoning from its reverse implication.
- `remaining_source_uncertainties`: exactly the decision's array.
- `native`: another native object checking both the exact target and a distinct actual witness.
- `formal_nonvacuity_declaration` and `formal_nonvacuity_scope`: the witness and its actual coverage.
- `witness_review`: a File binding to an existing target-specific review identifying the target and witness.
- `target_application_review`: an exact excerpt from that review discussing actual target application and every premise; it cannot be unsupported free prose.

The adapter checks these bindings and the native witness; it does not itself judge whether arbitrary prose proves nonvacuity. The root must independently review actual witness applicability before authoring the request. A complete sealed accepted decision remains mandatory. Any adjudication is recorded only if it actually occurred. A stronger result is never converted to equivalent, and its row carries meaningful applicability/nonvacuity fields plus the exact strengthening evidence hash.

## Execution sequence (root only)

Use native Python to invoke the existing `workflow-v5.0.1-local/run_workflow_posix.py`, passing the script below and its arguments. The adapters reject native Windows operational execution so that their Git reads and released-validator calls run in POSIX. No direct native Git is used.

1. Freeze target/dependencies, complete native checks, obtain a genuine complete accepted audit, prepare and review the immutable request, and stage the exact target bytes. Complete acceptance must explicitly carry an `interpretation-qualified` finding category.
2. Invoke `bind-qualified-row.py --gate-checker PATH --gate PATH --request PATH --request-sha256 SHA` for a read-only validated preview. It runs only the unchanged sealed complete validator and read-only Git/context checks; it creates no row artifacts or gate files.
3. Invoke the same arguments with `--apply` to write the one row and its derived immutable gate artifacts. `--rebind` is only for the same already-closed status/task/declaration and unchanged interpreted contract, with refreshed current bindings in a newly reviewed request.
4. Continue the existing organization, current-context rebinding and gate-validation workflow. Applying a row clears global verification evidence; it never declares terminal completion.
5. Invoke `validate-closed-row-audits-v4.py` for inventory-only checking, or `--validate` for all actual sealed complete validations and current-context checks on the nine new bindings. Add `--require-all-closed` only when all remaining rows are actually closed/skipped.

Existing final verification helpers pinned to v3 need an explicitly reviewed additive successor that names v4; do not silently replace a pinned helper.

## Preservation and concurrency

The binder compares every unselected row object before/after, preserving the earlier 32 accepted rows and 16 lawful skips. `protected-baseline.json` additionally pins those historical meanings/audit bindings. The successor validator permits only ordinary artifact-reference refreshes for those 32 rows by the separate existing rebind workflow; every skip stays exact. It retains v3's original four stronger-case checks unchanged.

The binder rechecks request, audit outputs, native inputs, gate bytes and current context before applying, snapshots the prior gate, creates immutable artifacts and replaces the gate atomically. A final byte check follows the last context read. It assumes one operational gate writer, as the existing workflow does; filesystem replacement is not a cross-process compare-and-swap or a lock against an uncooperative concurrent writer. Root must serialize gate writers. A failed apply can leave truthful immutable candidate artifacts or a prior snapshot, while the gate remains unchanged; it cannot overwrite conflicting evidence.

Only syntax, pure rejection/preservation tests and reads of already frozen native evidence were run during preparation. Synthetic objects in `selftest.py` test guards and are not audit receipts, candidate acceptance or new source judgments.
