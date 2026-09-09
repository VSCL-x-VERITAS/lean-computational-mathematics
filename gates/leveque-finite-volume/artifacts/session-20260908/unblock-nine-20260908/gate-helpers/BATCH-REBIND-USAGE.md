# Atomic rebind of an unchanged accepted set

`rebind-accepted-row-batch.py` is an additive coordinator helper. It does not close a row, change source semantics, reinterpret source text, run model roles, or certify terminal acceptance. Its default prepares immutable proposed artifacts and runs actual released complete validation on **every currently accepted row**. `--apply` also installs that validated proposal with byte/context/staged-source guards. No operational invocation occurred while preparing these helpers.

The initial supported gate has 38 accepted rows (the protected 32 and six qualified rows), 16 unchanged skips and three open rows. Counts 39–41 are supported only when the additional rows already have accepted bindings under the same pinned qualification protocol. There is no status transition. A new qualification protocol, source-context extension or changed contract requires an explicit additive helper successor; this version fails closed instead of dropping those qualifications.

## Input schema

Supply one hash-pinned JSON object with exactly these keys:

```json
{
  "schema": 1,
  "expected_gate_sha256": "<actual current gate SHA-256>",
  "expected_closed_row_ids": ["<all current PROVED/REUSED row IDs, sorted>"],
  "current_bindings": {"<all exact bindings keys from the current released checker>": "<actual values>"},
  "current_native": {
    "proof_manifest": {"path": "<repository-relative path>", "sha256": "<actual SHA-256>"},
    "check": {"path": "<repository-relative .lean path>", "sha256": "<actual SHA-256>"},
    "receipt": {"path": "<repository-relative path>", "sha256": "<actual SHA-256>"},
    "output": {"path": "<repository-relative path>", "sha256": "<actual SHA-256>"}
  },
  "runtime_pins": {
    "path": "gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/gate-helpers/batch-rebind-runtime-pins.json",
    "sha256": "f3f79bcbb30b2ba2865ca2a674a764767e8c23e326717efa21a9dc14f7c792ca"
  }
}
```

The placeholders above are documentation, not an operational request. Root must supply actual final frozen native evidence and observed gate/context values. `current_bindings` may differ from the existing binding only at `lean_worktree_sha256`; source profile, unit/index/epoch, gate policy and integrated-baseline pins must remain exact. A baseline transition is outside this helper.

The current native manifest uses the existing full-41 schema: `files` entries with `path`, `sha256`, `declarations`; `declarations` containing exactly 41 distinct primary targets; `check_file`, `check_file_sha256`; and `rows` mapping each covered row ID to its exact `{path,declaration}` target. The native receipt must record actual exit zero, `argv=["lake","env","lean",check_file]`, the matching command, and output SHA. All 41 declarations must have one `#check` and one `#print axioms` command and matching allowed-axiom output. This reuses the old native-evidence validator and its currently sufficient report format; unsupported formats fail closed. The old accepted qualified requests keep their **original** native evidence unchanged. The new complete current check is separate rebind provenance.

## Root execution sequence

1. Freeze the final code batch, aggregate/tier exposure and genuine native proof/check evidence. Explicitly stage every current target and accepted local source dependency. Do not change accepted targets or dependency bytes.
2. Observe the current released checker bindings and current gate SHA. Write the exact input above. The gate must already be `ACTIVE` with all eight global evidence records open.
3. Through the unchanged native-Python → POSIX launcher, from the Lean root, run:

   `python3 -B <H>/rebind-accepted-row-batch.py --input <input.json> --input-sha256 <SHA> --label <fresh-label>`

   Here `<H>` is the repository-relative `gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/gate-helpers` path. Default mode creates only a fresh `accepted-row-rebind-runs/<label>` evidence tree and leaves the gate unchanged. It actually runs the complete validator for the proposed acceptance set. A nonzero validator exit is retained and prevents installation.
4. Review the proposal, exact preserved payloads, request copies, native pins and actual validation receipt. For installation invoke the same helper with another fresh label and `--apply`; all checks and complete validations run afresh. The helper does not reuse a preview as authority. Root may also use `--apply` for the initially reviewed explicit input if that action is already authorized.
5. Continue the normal fresh global/checkpoint workflow. This helper leaves all eight global evidence records, verification-loop fields, statuses and all nonbinding gate data unchanged. Its success is not a terminal gate certificate.

## Preservation and validation details

- The original protected baseline and old 32-row payload baseline remain pinned. Every old semantic/audit/native field and every skip object is checked unchanged.
- All accepted row objects are copied. Only the eight artifact path/hash fields may change, plus `qualified_binding_request` for a qualified row. All other fields, including stronger applicability/nonvacuity and source-context fields, must be equal.
- Fresh qualified requests are copied from exact accepted request bytes as JSON values with only `current_bindings` replaced. Task, decision, manifest, interpretation, refinement and original native input references remain identical. Historical requests remain untouched.
- Artifact payload JSON **byte spans** are copied unchanged. Only envelope bindings/procedure differ. Old analysis text may intentionally refer to its old request hash: it remains historical semantic evidence; the row separately points to the new current-context request.
- `validate-closed-row-audits-rebind.py` is derived from the frozen v5 validator by three recorded replacements: paired proposal path/hash arguments, choosing that exact gate input, and reporting/rechecking its hash. It still resolves current context using the real canonical gate path and executes every existing complete/native/stronger/qualification check. There is no stale-context bypass.
- The installed sealed validator's scripts and schemas are pinned as an exact 21-file set; the previously pinned validator entry point is unchanged. Each audit retains its exact manifest-bound configuration, source and environment checks. No released file was edited.
- Current proof sources, accepted target/dependency files, audit/native/config/helper inputs, newly written artifacts and current context are checked again before writing and immediately before atomic replacement. A gate byte guard surrounds these checks. Atomic replacement is within the gate's directory. This is a guarded single-writer protocol, not an operating-system compare-and-swap against arbitrary adversarial concurrent writers.

The synthetic test packet exercises preservation, request copying, classification/count/output bindings, actual-exit typing, payload bytes, path/hash/concurrent-input guards and exact validator derivation. It does not claim that operational audits or the current proposed gate were validated.
