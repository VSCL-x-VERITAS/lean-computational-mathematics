# Advection linear-flux audit scope review

The minimal remedy is a fresh, explicitly sentence-scoped locator for the existing advection row, retaining the full page as context. A combined Lean wrapper is not needed for that row. This is an informed scope review, not a new source audit or a verdict overturning the frozen rejection.

I inspected the actual pinned rendering of printed page 4/raw page 26. The paragraph after (1.10) contains two distinct relevant assertions. Its third sentence derives scalar advection from conserved contaminant mass and the exact linear flux. Its fourth sentence states that nonconserved contaminant mass requires source terms. The exact starts, ends, source hash and rendering hash are frozen in `locator-proposal.md`.

The observed inventory assigns these assertions to separate rows:

| Row | Recorded claim | Current producer |
|---|---|---|
| `LEV-CH01-ADVECTION-LINEAR-FLUX` | Conserved contaminant mass with flux `f(q) = ūq` yields advection. | `NumStability.leveque01_advectionLinearFlux_fromMassConservation`, in `ComputationalMathematics/Source/LeVeque/Chapter01/AdvectionLinearFlux.lean` |
| `LEV-CH01-NONCONSERVATION-SOURCE-TERMS` | Failure of contaminant mass conservation requires source terms. | `NumStability.leveque01_nonconservation_requires_sourceTerm`, in `ComputationalMathematics/Source/LeVeque/Chapter01/NonconservationSourceTerms.lean` |

The earlier `independent-inventory-review-final.md` also treats the two rows separately (row table lines 138 and 167, with the source-term analysis near line 21). Inventory metadata establishes the intended task organization; the two actual source sentences independently support that separation. The full observed gate bytes and the two decoded rows are retained as snapshots. No gate field was changed.

The rejected task instead used the unbounded anchor “Contaminant-mass paragraph: advection equation (1.2) with flux f(q)=ubar*q”. The source contract included the fourth sentence among its conclusions and undebatable constraints. The adjudication therefore assessed the full paragraph and rejected omission of the nonconservation case. This is a scope mismatch between the task locator and the independently inventoried advection claim. It is not an unexplained extraction error: the broad locator reasonably permitted the broader source contract. The fixed rejection remains `not-faithful-weaker`, accepted false, decision SHA-256 `82c70fc8aae81f9790650f4e5ed6410008c1bb222dd908a5f89691b4db94c329`.

The same decision recognizes the exact scalar linear flux and the homogeneous conservation-to-advection direction under explicit sufficient regularity. It does not identify an additional defect in that part. This observation is a report of the existing decision, not independent acceptance of a newly selected statement.

Scoped project and pinned-Mathlib searches were made before considering new producers. The current homogeneous wrapper already supplies the first assertion. The source-term wrapper reuses `nonconservation_requires_nonzero_source` in `ConservationLaws/BalanceLaw.lean`: under actual derivative, integrability and interchange hypotheses, a nonzero mass-rate defect after subtracting endpoint transport produces a nonzero source, its integral equals that defect, and the homogeneous residual cannot hold everywhere. `leveque01_sourceTerm_unitProduction` supplies a concrete nonvacuity example. This is a mathematical internal-production claim, not an empirical model of a particular chemical reaction. The scoped Mathlib wording search produced no match; that is not evidence of global semantic absence.

If root instead elects to audit the whole paragraph as one target, both independently quantified cases must be included. A conjunction using the existing homogeneous and source-term producers is feasible in principle. The nonconservation clause must not be placed under the same unconditional homogeneous-conservation premise, which would exclude the case it is meant to cover. That broader wrapper would be a new combined target and would not erase or automatically discharge either separately inventoried obligation. It is unnecessary for the row-aligned remedy, so no wrapper or new proof was drafted.

`input-provenance.json` records exact source/rendering, frozen audit, producer, inventory-snapshot and pinned-environment hashes, plus scoped search commands and real exits. Source facts were read only from the pinned rendered page. No native Lean check was needed because no declaration was created or changed; producer bodies were inspected, not relabeled as freshly replayed. No production, gate, sealed audit, configuration, tracker, helper, or Git state was modified.
