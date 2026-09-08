# Closed-row rebind preparation

This package was prepared without executing a gate mutation. The positive
read-only preflight covered 23 closed rows, including the new advection closure.
Fourteen negative checks passed, with identical gate bytes before and after.

Run from the Lean repository with the required Windows-to-POSIX launcher:

```powershell
& 'C:/Users/qed_s/AppData/Local/Programs/Python/Python312-arm64/python.exe' -B 'C:/Users/qed_s/OneDrive/Documents/ChatGPT/VSCL-x-VERITAS/workflow-v5.0.1-local/run_workflow_posix.py' 'gates/leveque-finite-volume/artifacts/session-20260908/one-step-rebind-preparation/rebind-closed-rows.py' --label 'one-step-intro-rebind' --gate-checker '/c/Users/qed_s/OneDrive/Documents/ChatGPT/VSCL-x-VERITAS/formalization-collaboration-v5.0.1/books/candidates/leveque-finite-volume/module/scripts/gate.py' --execute
```

Omit `--execute` and use a different label for a gate-read-only preflight.
Labels are exclusive: an existing run directory is never overwritten or resumed.
Do not run the mutation driver concurrently with gate or production writers.

The driver discovers closed rows when invoked. All 23 previously reviewed rows
must retain their task, target, decision, source extraction, classification,
status, contract, and special evidence. Additional ordinary equivalent rows
can be included only when their complete source contract is unchanged and an
exact frozen native proof record covers the declaration. Unknown scoped,
interpreted, stronger, and discrepancy outcomes fail closed.

Adapter dispatch preserves:

- Eq1.2 and Eq1.3: the existing interpreted adapter, exact user receipt and
  manifest-bound config, with `--rebind`.
- Discontinuity: its dedicated interpreted adapter and exact separate receipt,
  with `--rebind`.
- SMOOTH: the pinned stronger adapter with the exact strengthening evidence and
  `--rebind`, retaining `faithful-stronger` and the `yes/no` implication pair.
- SecondOrder: the additive `rebind-second-order-scoped-row.py`, derived from
  the reviewed v2 adapter. It requires `--rebind`, the same already-PROVED
  task/declaration/decision, the classification-only contract, the independently
  closed Eq1.7 derivation row, and every scope/material-domain note.
- Other equivalent rows: the existing REUSED or PROVED rebind adapter, after
  checking that projection of the complete source extraction preserves the
  exact current source contract.

The native proof catalog binds four existing checked input/output/exit groups:
current producers, interpreted transport, algebraic right mode, and general
propagation/discontinuity. The driver checks each selected target hash,
declaration/check-file binding, actual zero exit, exact command, raw output,
and declaration-specific permitted axioms. It selects each audit's unique
manifest-bound config. No native check or semantic role is represented as new.

Execution writes an immutable plan, exact prior gate snapshot, per-adapter raw
stdout/stderr and actual exit receipts, and a final summary in the selected
label directory. Adapters run sequentially. After each success, all closed-row
semantic fields and source contracts must match the invocation snapshot, and
open/skipped rows must be untouched. Final checks require current row artifact
bindings. A failure stops the batch, preserves evidence, and never rolls back
or proceeds to another adapter.

Global verification remains OPEN after rebinding. Root must perform the normal
authoritative evidence refresh and checkpoint separately. This package does
not perform gate acceptance, canonical changes, ledger updates, staging,
commits, or semantic auditing during preparation.

`reviewed-inputs.json` pins all original adapter and evidence bytes.
`second-order-derivation.json` records the exact additive derivation.
`preflight-review-01/plan.json` contains all 23 concrete commands/configs.
`negative-checks.json` records the read-only rejection checks.
