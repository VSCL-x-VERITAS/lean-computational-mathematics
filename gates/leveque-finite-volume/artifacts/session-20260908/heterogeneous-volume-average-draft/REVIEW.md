# Normalized-volume assignment alternative

This is scratch mathematics under a concrete normalized-volume convention. The pending source-interpretation question `call_1JnoPOtxdApI1F5hUmt5F9Q7` remains unanswered. No source wrapper, audit, interpretation receipt, gate, ledger, aggregate, tier manifest, or canonical module was changed.

## Result

`cellVolumeAssignment_contract` assigns the existing `cellVolumeAverage` of every integrable field to every supplied finite positive measured cell. It proves the existing `IsCellVolumeAverage` predicate, exact locality and constant preservation. `existsUnique_cellVolumeAssignment` proves uniqueness. Neither theorem assumes or concludes different cell averages. The field need not be heterogeneous to be assigned.

The cell partition is the existing `FiniteVolumeCellPartition`. Its cell index type is unrestricted; the finite-volume hypotheses concern each cell measure, not the number of cells. Only cellwise integrability is required; no global integrability, classical derivatives, geometry condition, or material rate law is introduced. The general target space is a normed real vector space. Constant preservation and the combined contract require completeness, so real scalars and finite real vectors are included. Uniqueness and locality do not require completeness.

The actual field `x ↦ x²` on two disjoint adjacent real cells `(-1,0]` and `(0,1]` varies inside each cell, yet both normalized averages equal `1/3`. Both cells have Lebesgue volume one. `heterogeneous_equal_average_nonvacuity` records integrability, the genuine average predicate, variation in each cell, and the failure of any unequal-average pair. The field `x ↦ x` on the same cells gives `-1/2` and `1/2`, showing that different averages are also admitted.

## Reuse and rejected routes

The recorded project search found the canonical operator and predicate in `ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/CellAverage.lean`, also used by `FiniteVolume/LocalFluxBalance.lean` and the source flux-update wrapper. This draft uses the existing operator rather than introducing a second average definition.

The bridge `cellVolumeAverage_eq_setAverage` is proved from Mathlib `MeasureTheory.setAverage_eq`. Locality uses `average_congr` and `setAverage_congr_fun`; constants use `setAverage_const`. The interval bridge reuses `Real.volume_Ioc`, `ENNReal.toReal_ofReal`, and `intervalIntegral.integral_of_le`. Integrability and the example integrals use `Continuous.intervalIntegrable`, `intervalIntegrable_iff_integrableOn_Ioc_of_le`, `integral_pow` and `integral_id`. No integral basics are reproved.

The old `CellMaterialAveragingRule` was rejected as the semantics for this alternative: its local/constant laws do not fix normalized-volume averaging. The old `hdifferentCellAverages` premise was removed entirely, not moved into another premise or definition. `CellAveragedMaterialProperty` is unnecessary for the generic assignment theorem; it would merely wrap the actual assigned value. Harmonic averaging, model-specific effective media and reflection/transmission remain outside this task.

## Source boundary

The actual pinned raw page 30 / printed page 8 was viewed. Its selected sentence calls for appropriate averaging of material parameters over cell volume. This draft does not decide which material averaging rule is appropriate. The frozen old decision `6ee86257e622a3577b5e722e2def8d439ff3844d859c25ae6aea3831c9ed808e` and its report remain unchanged. The current normalized-volume alternative addresses the explicitly assigned mathematical preparation, and is not a new source-faithfulness judgment.

## Validation and preservation

`Checks.lean` begins with the exact bytes of `Candidate.lean`, then checks all 15 declarations and prints their actual axioms. `final-checks-exit.json` records the actual native exit, command, pinned toolchain and Mathlib manifests, source hashes and output hash. `final-receipt.json` checks the exact prefix, every declaration's allowed-axiom output and absence of warnings/errors, and binds the artifacts and selected compiled owners. `verify.py` is read-only and rechecks those bindings.

The first failed attempt and its source snapshot are retained. Its errors were elaboration annotations, explicit endpoint arguments, and final reflexive simplification; the second attempt passed with one style warning. The final check removes that warning and adds the different-average witness. No failed output was overwritten.

Reproduce the final native checks from the repository with a fresh label:

```powershell
& 'C:/Users/qed_s/AppData/Local/Programs/Python/Python312-arm64/python.exe' -B 'gates/leveque-finite-volume/artifacts/session-20260908/heterogeneous-volume-average-draft/run.py' review01 Checks.lean
```

All writes performed for this task are inside `session-20260908/heterogeneous-volume-average-draft`. No process remains at handoff. Any future canonical placement should separate general average laws from the real-interval examples; source exposure requires the still-pending interpretation and a fresh independent audit.
