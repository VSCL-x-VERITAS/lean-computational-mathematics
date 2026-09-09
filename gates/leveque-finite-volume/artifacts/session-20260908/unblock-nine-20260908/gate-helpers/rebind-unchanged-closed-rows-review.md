# Unchanged closed-row rebinding preparation

This additive helper prepares current-context evidence for exactly the 32 rows pinned in `unchanged-closed-row-inputs.json`. It makes no new source interpretation or audit judgment. The initial gate bytes are preserved in `unchanged-closed-row-prior-gate.json` (SHA256 `49e8e4674b23a37fa0139969237805ebeec35cb0f0b03e70f66b6b4e213a78f1`). Existing interpretation, stronger-result, applicability, reuse, and adjudication qualifications remain in their original row fields and payloads.

For each selected row, only the four artifact paths and four associated SHA256 fields may change. The new artifacts preserve the complete original JSON payload value byte-for-byte, including structured source contract and audit analysis. Their bindings come from the exact pinned released `row_artifact_bindings`; procedure text records the actual existing-audit and native-check receipts and retains the previous procedure. The helper checks old artifacts against their original bindings and new artifacts with the unmodified released `row_artifact_defects`.

All other selected-row fields, every unselected row, inventory order, gate status, counters, and all eight global evidence records are preserved. Gate-level bindings are refreshed to the current released context. The gate must be ACTIVE and its eight global evidence records must already be OPEN. This helper cannot turn those records into successful checks.

## Actual evidence used

- The unchanged v3 audit validator actually exited zero with exactly `--validate`, covering the pinned 32 accepted audits. Its output SHA256 is `3b98f9655a511e572f01d06b5d1e685ae8912d4577d8f2148868f806878739b3`. Both output and outer receipt are fixed in `unchanged-closed-row-audit-validation-inputs.json`; inventory-only output is rejected.
- The current full-41 native declaration/axiom command actually exited zero. Output SHA256 is `692db312acc36607726fad1121d7811397ca4a49a992f38908bea81bb92c63a8`. The helper checks every exact declaration name, binder/universe rendering, one axiom report per declaration, and only `propext`, `Classical.choice`, `Quot.sound`. It verifies the exact manifest, check file, command, receipt, output and current producer file hashes.
- Every selected task, completed manifest, decision and manifest file reference is hash checked. The accepted target must equal the current native manifest target. Exact row/declaration/classification/implication identities must match the captured actual validator records and sealed decisions. The helper copies existing qualifications rather than deriving payloads again from source extracts.
- At operational preflight, all 76 selected target/local-project-import source paths must have index bytes exactly equal to the pinned current file bytes. This uses POSIX `git show :path`; it stages nothing. The check is repeated before installation. The complete set appears in the fixture receipt and operational plan.

## Interface and operational handoff

The helper is POSIX-only. Invoke it through the existing prepared launcher, with the Lean repository as the working directory:

```powershell
& 'C:/Users/qed_s/AppData/Local/Programs/Python/Python312-arm64/python.exe' -X utf8 -B 'C:/Users/qed_s/OneDrive/Documents/ChatGPT/VSCL-x-VERITAS/workflow-v5.0.1-local/run_workflow_posix.py' 'C:/Users/qed_s/OneDrive/Documents/ChatGPT/VSCL-x-VERITAS/lean-computational-mathematics/gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/gate-helpers/rebind-unchanged-closed-rows.py' --label ROOT-FRESH-PREFLIGHT-LABEL --expected-gate-sha256 ROOT-EXACT-CURRENT-GATE-SHA256
```

The two uppercase argument values are coordinator-supplied values, not literal arguments. The label must be fresh, 1–80 ASCII letters/digits/hyphens, beginning with a letter or digit. The expected gate hash must be the exact current 64-digit lowercase SHA256. The helper accepts no replacement audit receipt or alternate baseline from the command line.

Default mode performs the full preflight, then writes a new immutable proposal under `unblock-nine-20260908/unchanged-closed-row-rebind-runs/<label>/` containing `prior-gate.json`, 128 artifacts, `candidate-gate.json`, `plan.json`, and `receipt.json`. It leaves the operational gate unchanged. The plan records exact original/candidate hashes, old/new artifact hashes, preserved payload hashes, actual audit identities, allowed axioms, staged-source evidence, and current bindings.

For coordinator execution, use another fresh label and add `--execute`. This repeats the complete preflight, checks that every observed input is unchanged, checks the released context again, repeats staged-source equality, and compares the operational gate with the explicit prior byte guard before atomically installing the checked candidate. It creates immutable evidence only outside that final gate replacement. It never stages, commits, changes row semantics or closes global obligations. A failed attempt may leave an incomplete new proposal directory; it has no successful receipt and must not be reused as a successful run.

## Preparation checks and limits

The fixture script ran through the prepared POSIX launcher and actually exited zero: 25 acceptance/rejection checks passed. It checked 2,250 sealed file references, 884 distinct observed inputs, all 32 original released row-artifact checks, all 41 native reports, and preservation of all 128 qualified payload byte spans. Synthetic new artifacts are confined to `unchanged-closed-row-fixtures/` and explicitly identify themselves as fixtures. Tests reject changed qualifications/status/implications, unselected-row changes, invented global success, invalid paths, duplicate keys, stale hashes/receipts, wrong validator mode, boolean success, unexpected axioms and duplicate/missing type reports. The exact released checker accepted the synthetic rebind and rejected corrupted variants.

The first two fixture attempts failed on overly narrow native-output formatting recognition (explicit binders, then universe parameters); both failures preceded fixture artifact creation. The parser was corrected to accept Lean's actual printed forms while retaining exact declaration identity. The final passing fixture receipt pins the final helper bytes.

No operational helper preflight, `--execute`, Git command, audit rerun, Lean rerun, gate write, or sealed evidence mutation was performed during preparation. Current staged-source equality, dynamic released context checks, and operational candidate installation remain coordinator work. This packet establishes helper behavior and exact existing inputs; it is not a final gate PASS or a new faithfulness verdict.
