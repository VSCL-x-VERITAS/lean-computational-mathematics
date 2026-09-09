# Qualified-row refinement successor

These additive local helpers preserve `qualified_row_support.py`, `bind-qualified-row.py`, and `validate-closed-row-audits-v4.py`. They have not been invoked operationally. The tests do not certify an audit, close a row, or authorize terminal acceptance.

Use `qualified_row_support_v2.py`, `bind-qualified-row-v2.py`, and `validate-closed-row-audits-v5.py` together. The existing request schema and CLI remain unchanged. Root supplies an actual complete accepted audit and a current-context request; native declarations, current target bytes, pinned toolchain inputs, actual exit, allowed axioms, and genuine stronger-statement support remain independently mandatory.

The two optional addenda are exact pins, not a general mechanism for arbitrary new interpretation claims:

| Row | Original choice | Exact addendum SHA-256 |
| --- | --- | --- |
| `LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION` | Q9 | `8e24fcad8fc5b8462b243ead716a46b2613360966bbf4d03451056d8731d6f21` |
| `LEV-CH01-NONCONSERVATION-SOURCE-TERMS` | Q6 | `8658feb83ed55f4c7a4a5c64a95c45313814c44b62573372ea716b5c791e97f3` |

Both retain original selection SHA-256 `cfde240a9dda9a58be99f85369b43e99003b0024c7147a33ffa8b071ca7dcf34`. They are coordinator selections under the recorded broad user goal, not literal detailed user replies or additional printed-source assertions.

The already bound `interpretation_packet` in a normal request must contain either neither refinement field or both:

```json
{
  "interpretation_refinement_ref": {"path": "exact repository-relative addendum path", "sha256": "exact pinned hash"},
  "interpretation_refinement": "the complete decoded JSON object at that exact reference"
}
```

The latter value must be an object, not the illustrative string above. The addendum must occur exactly once in the sealed configuration's `lean.environment_files` and exactly once with its exact hash in the manifest's `lean_environment`. The other row's addendum cannot be configured there. A configured known addendum with both packet fields omitted is rejected. The pointer and complete embedded JSON must match; row, choice, original receipt, attribution, preserved limitations, exact source locator/bytes, unchanged target/declaration/bytes, mathematical model clauses and source ambiguities are checked. Historical prior-task/decision references are rehashed solely as provenance; no earlier verdict determines the fresh result.

The addendum JSON is separately audited environment input, not a Lean proof input. It need not be present in the native Lean snapshot. A JSON addendum substituted for the Lean check, a nonnative receipt kind, a nonzero exit, or a wrong native command is rejected. This is an unchanged-target refinement; it does not fabricate a fresh native run.

For refined rows the binder writes `interpretation_refinement_ref` matching the audited packet. The source contract retains all original text, hypotheses, context and quantifiers, then appends the exact refinement ID/hash, each `selected_model` key and full clause, and every `source_ambiguities_preserved` entry. Unrefined contract serialization is byte-identical to v1. A stale refinement reference on an unrefined row is rejected. Refined addendum, packet and original selection bytes also enter the final write-boundary rehash set.

Qualification may be explicit in a finding category, as v1 already allowed. It may instead be expressed by an `interpretation-qualified` rationale naming the exact choice and both implication reasonings beginning `Under the recorded coordinator-selected interpretation`. This alternative is a textual guard; it does not substitute for the actual complete accepted sealed decision. The completed material-topology decision `0074ffd53e7c86cf4400a53038e97e8430b90297860c831a1fe7ecbd73753425` exercises the latter route. No frozen audit output was edited.

Root's execution order remains: prepare/freeze the fresh audit and exact current request; review hashes; run the binder preview through the existing POSIX launcher; only then explicitly run the same binder with `--apply` if authorized. Use `--rebind` only for the same already closed status/task/target and unchanged contract. All original gate guards, complete sealed validator invocation, exact staged target check, integrated-baseline reuse check, preservation of unselected rows, and global-evidence invalidation remain in place.

The binder arguments are `--gate-checker PATH --gate PATH --request PATH --request-sha256 SHA`, optionally `--rebind` and `--apply`. Operational scripts require POSIX. Do not execute them through native Windows Git. These notes do not provide operational argument values or assert readiness of a current gate.

The final closed-row command is:

```text
python -B gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/gate-helpers/validate-closed-row-audits-v5.py --validate --require-all-closed
```

Invoke that command only through the existing approved POSIX launcher. Output shape remains `{mode, closed_rows, records}`; `mode` is `released-complete-validation` only in validation mode. A refined record additionally includes the exact `interpretation_refinement_ref`. All other existing record fields remain unchanged. Root must capture the actual command/output/exit externally. A helper hash, inventory-only run, or passing local tests cannot replace that receipt.

`qualified-refinement-tests-01` retains the actual failed native test attempt and all input snapshots. Its only failure was an unprefixed Windows long-path read during actual unrefined contract comparison; no operational helper failed. The test-only path fix uses the Windows extended-length spelling. `qualified-refinement-tests-02` exited zero: 84 successor checks plus 28 original checks, with empty stderr. The two actual already-closed unrefined contracts (left acoustic mode and eigenvalue wave speeds) matched both the old serialized bytes and their existing contract hashes. Gate bytes were observed unchanged within each test; the root legitimately changed them between attempts. No tests invoke Git, an operational binder/validator, a gate checker, or an audit role.

The initial derivation receipt records the initial generated drafts. Subsequent local additions are captured by the final diff: final-boundary refinement rehashes, the independently requested qualification guard and its regression tests. Use `qualified-refinement-v2-final-manifest.json` and the final receipt for authoritative current hashes; historical derivation hashes and failed-run snapshots remain intact.

Limits: this helper supports only the two pinned refinements. It does not decide source faithfulness, interpret arbitrary qualification prose, fix unknown native receipt schemas, certify source exhaustion, or make final closure claims. The inherited axiom parser still rejects universe suffixes on individual axiom names rather than silently normalizing unrecognized forms. That existing conservative limitation does not affect the checked target outputs. Concurrent operational gate writes remain prohibited by the original single-writer workflow and guarded byte/context checks.
