# Generic finite-volume placement review

This is a reusable-mathematics extraction of the two frozen finite-volume drafts. It introduces five new flat leaves under `Analysis/PartialDifferentialEquations/FiniteVolume`, with 13 public declarations and two private proof helpers. It does not introduce a source wrapper, choose a quantitative reading of LeVeque, or revise either frozen source audit.

## Boundaries and reuse

- `CellAverageEstimates.lean` owns the general Banach-space bound for differences of interval averages. Its only project import is `CellAverage`; it does not import conservation laws, solvers, or the source layer.
- `PhysicalFluxAverage.lean` owns the time average at an actual grid face, its positive-duration certificate, and the exact cell-mass change derived from rectangle conservation. It imports the existing rectangle predicate and grid/cell-average owner.
- `FluxUpdateError.lean` owns the weighted local error identity and finite contiguous block identity. It reuses the existing numerical update, cell-total multiplication theorem, and conservative-difference telescoping theorem. The full-array/time-parameter specialization of the old cell-total theorem stays private.
- `FluxUpdateErrorBounds.lean` owns conditional local-error and total-block-mass estimates. Its generic norm calculation stays private because it only supports these estimates.
- `LinearRiemannFluxAverage.lean` ties the actual selected linear solver to its physical positive-time trace and time average, then combines a separate trace-error premise with the general estimates. It uses the existing rectangle interface method, adjacent-cell data, extraction, flux, and update APIs directly.

The retained declaration map, line/declaration counts, direct imports, exact file hashes, and eliminated draft aliases are in `placement-manifest.json`. The five filenames have no declaration-bearing sibling-directory collision. Existing finite-volume owners remain byte-identical to their initial hashes in `placement-initial.json`. No aggregate, tier manifest, gate, ledger, audit input, released helper, or Git index was modified by this extraction.

## Search decisions

Before placement, scoped current-project searches found no conflicting filenames or declarations matching the proposed flux-average/error APIs. `search-provenance.json` retains a replay excluding the five new leaves, with exact argv, actual exits, output hashes, source hashes, and runtime pins. A miss is limited to the listed search paths and terms; it is not a global absence claim.

The existing `oneDimensionalCellAverage_isCellAverage` and `cellWidth_smul_oneDimensionalCellAverage` provide normalization; `finiteVolumeCellAverageOn_spec` already certifies spatial averages. Therefore the draft's redundant `exactCellAverage_spec` is not promoted. The existing `riemannFiniteVolumeUpdate` already accepts any face-flux array, so the draft's `numericalUpdate` wrapper is expanded into that operation. Likewise, `selectedLinearSolve`, `selectedLinearFlux`, and `linearRule` are expanded into the actual existing method operations; their `linearRule_eq_rectangleRiemannInterfaceFlux` bridge is unnecessary once the statements directly use that function.

Pinned Mathlib's interval-integral norm bound, integral subtraction, and almost-everywhere integral congruence are reused. The selected linear method's `information` theorem supplies its actual positive-time ray trace. No derivative proof, new Riemann solver, copied rectangle predicate, or new telescoping proof is introduced.

## Scope retained

The general identities use arbitrary finite-vector fields and fluxes satisfying the existing rectangle predicate, including its spatial and temporal interval-integrability requirements. Numerical current data are independent of exact cell averages. The numerical face rule may depend on the entire current array and both times. Cell widths and the time duration are positive; the integer grid supplies both real faces, including block exterior faces. The block estimate concerns the norm of total mass error, so cancellation is possible; it is not a weighted sum of absolute new cell errors.

The bounds are conditional on explicit old-error and numerical-minus-physical averaged face-error bounds. They do not assert convergence, stability, a CFL condition, or a chosen tolerance. For `Fin m → ℝ`, the inherited norm is the standard finite-function norm. The interval-average estimate itself works in any complete real normed space.

The linear solver equality concerns its own actual selected solution for every ordered state pair and positive time. Comparison with an independent global conserved field requires the stated physical trace-error bound. Nothing derives that premise merely from two unrelated solution certificates. The solver comparisons use the relative window `0 .. dt`; the general estimates use arbitrary `s < t`.

## Checks and preserved failure

`build-v1` compiled all five initial leaves successfully. Two leaves then received line-wrapping changes only; `build-final` compiled those final bytes successfully. Both actual native exits and raw outputs are retained with input snapshots.

The first declaration/type check is preserved as `declarations-v1`: it passed through 13 exact comparisons, then rejected the last solver-estimate type because transparent definitional equality does not normalize real `dt - 0` to `dt`. This was a deliberately stricter checker than mathematical statement preservation, not a failed production proof. The revised scratch check explicitly proves the original full solver-estimate statement from the canonical theorem using `sub_zero`. The other 14 retained declaration types are compared by Lean definitional equality; the two private helpers are resolved from the imported environment rather than guessed. All 15 canonical declarations receive actual `#check`, `#print axioms`, and an enforced allowed-axiom check. The separate normalization bridge also receives `#print axioms`.

The final receipt records the actual revised check outcome, every frozen source input, canonical source snapshot, and output hash. The old draft directories and their reviews/receipts remain unchanged. No independent statement-faithfulness verdict is claimed. Source interpretation, aggregate/tier placement, full-library integration, and any future source wrapper remain the coordinator's work.
