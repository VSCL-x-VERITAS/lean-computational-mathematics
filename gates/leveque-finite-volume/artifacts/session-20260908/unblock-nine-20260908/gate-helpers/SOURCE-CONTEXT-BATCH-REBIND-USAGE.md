# Source-context-aware batch refresh

This is an additive successor to the frozen batch-38 helper. It refreshes current worktree bindings for an already accepted set of 38–41 rows. It cannot close a row, change a target or dependency, revise a source contract, or authorize an interpretation. The protected 32 accepted rows and all 16 skips retain the original guards. The existing helper and every earlier receipt remain unchanged.

`rebind-accepted-row-batch-v2.py` differs by seven recorded substitutions: three pinned dependency entries, the support-module loader, the dependency-sidecar read, the actual validator command, and an explicit validation-result comparison for the three source-context references. `validate-closed-row-audits-rebind-v2.py` is the frozen ordinary v6 validator with precisely the same three proposal-input additions used by its predecessor. It resolves current context from the actual canonical gate and validates the separately supplied proposed gate against that context.

## Exact input and execution

The input schema and operational prerequisites are unchanged from `BATCH-REBIND-USAGE.md`: exactly `schema`, `expected_gate_sha256`, `expected_closed_row_ids`, `current_bindings`, `current_native`, and `runtime_pins`. Schema is 1; the row list is the sorted actual accepted set; the current native manifest covers all 41 primary targets. `current_native` contains the four exact file references `proof_manifest`, `check`, `receipt`, and `output`. The runtime reference remains `batch-rebind-runtime-pins.json`, SHA-256 `f3f79bcbb30b2ba2865ca2a674a764767e8c23e326717efa21a9dc14f7c792ca`. Only the worktree fingerprint may change among current bindings. The gate must be ACTIVE with all eight global evidence entries open; all checked source files must be exactly staged.

Root must supply the actual final native receipt/output, current fingerprint, prior gate SHA and row list. No example here represents completed evidence. From the Lean root, through the unchanged native-Python → POSIX launcher:

```text
python3 -B <H>/rebind-accepted-row-batch-v2.py --input <actual-input.json> --input-sha256 <actual-SHA> --label <fresh-label>
```

`<H>` is `gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/gate-helpers`. Default mode prepares a fresh proposal and actually runs complete validation for every accepted row, without replacing the gate. `--apply` also performs the existing guarded atomic replacement. Every invocation requires a fresh label under `accepted-row-rebind-runs`. At 41 rows the actual proposal-validator command includes `--require-all-closed`.

After an operational refresh, root must separately capture the ordinary `validate-closed-row-audits-v6.py --validate --require-all-closed` command for the final global binder. A proposed-gate validator receipt is not a substitute for the ordinary final validation receipt. This preparation ran neither command.

## Source-context preservation

Qualified requests are deep-copied with only `current_bindings` changed. The references `source_context_extension`, `inherited_source_interpretation_packet`, and `source_context_lineage` remain exact in both the request and row. The structured source contract and all other semantic fields remain unchanged. Complete-validator records must contain each of these fields if and only if the corresponding row does, with identical values. Missing, altered, or extra context references fail closed.

The frozen `qualified_row_support_v3.py` independently checks the paired context protocol, original and appended locators, selected coordinator choice, separately inherited literal scoped receipt, exact known preparer lineage, and optional exact reviewed partial-recovery record. The existing source-context dependency sidecar is pinned and all its file references are observed again before installation. This successor adds no source interpretation or admissibility rule.

The original audit task, decision, source/dependency bytes, native inputs and artifact payload byte spans remain unchanged. Only the previously permitted artifact envelopes and current-context request reference change. Current sources, audit/context/runtime files, gate bytes, staged bytes and the worktree context are rechecked at the existing write boundaries. This remains a guarded single-writer protocol, not an operating-system compare-and-swap against adversarial writers.

## Checks and limits

The test script reuses all ten original synthetic guard tests against the successor and adds five tests covering source-context request copying, row preservation, exact record bindings, unextended compatibility, and exact derivation. Operational helper entry points, audit checks, gate checker and subprocess calls are forbidden during these tests. The final receipt reports the actual test exit and exact inputs. No gate, source, audit, Git, released helper or production file is changed by preparation, and no source acceptance or terminal certification is asserted.
