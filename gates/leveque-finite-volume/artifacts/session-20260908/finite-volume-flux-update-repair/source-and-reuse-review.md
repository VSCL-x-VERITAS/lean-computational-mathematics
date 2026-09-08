# Finite-volume flux update: scratch repair

This is a checked mathematical foundation and a separately identified source-wrapper proposal. It is not a source-faithfulness verdict or a row closure. All additions are confined to `finite-volume-flux-update-repair`; the canonical source, gate, ledgers, and sealed audit remain unchanged.

## Selected source and preserved rejection

The sole source is the selected LeVeque PDF, *Finite Volume Methods for Hyperbolic Problems*, first printed 2002 (PDF copyright 2004), SHA-256 `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`. Full rendered pages were actually inspected:

- Printed 4 / raw 26, Section 1.1.1 and Eq. (1.10): mass changes through both spatial endpoints, with left flux minus right flux and time-dependent state.
- Printed 5 / raw 27, Section 1.2, first paragraph: numerical cell quantities approximate integrals or cell averages and are changed using edge fluxes computed from the available approximate cell averages. This is the exact frozen task locator. The paragraph does not state a quantitative approximation bound, a common binary stencil, or a discrete time-quadrature formula.
- Printed 9 / raw 31: references and software context; it adds no mathematical flux-update formula.
- Printed 10 / raw 32, Section 1.7: `q` denotes the PDE solution, while numerical `Q_i^n` approximates it and carries cell/time indices. The current time level may be suppressed for one-step methods.

Task `LEV-CH01-FINITE-VOLUME-FLUX-UPDATE-CANONICAL-20260908` selected `NumStability.leveque01_finiteVolumeFluxUpdate_sourceContract` in `Source/LeVeque/Chapter01/FiniteVolumeFluxUpdate.lean`. Its full decision and report were read. Decision SHA-256 `8660b099909f6f75de955b1ef62d176191887521f1e1c261f6dc645743074375` records `not-faithful-weaker`, accepted false. The complete frozen audit tree is hash-bound and rechecked unchanged by the receipt.

The rejection identified: numerical inputs equated with exact averages of the same static field; incomplete physical exterior-edge coverage and static reference flux; a common binary rule; an assumed approximation inequality repeated in the conclusion; and uncertainty about generalized incomplete codomains. This draft addresses the first four mathematically and uses real finite vectors throughout, avoiding an incomplete-space generalization.

## Mathematical representation and result

The reusable draft is `candidate.lean`, namespace `NumStability.FVFluxUpdateDraft`. It has two definitions and seven theorems. It imports existing reusable owners only, not any Chapter 1 source wrapper.

- Exact state: arbitrary `q : ℝ → ℝ → (Fin m → ℝ)` with the existing `IsRectangleConservationLawSolution q flux`. This predicate supplies both spatial and temporal boundary-flux integrability and the actual rectangle balance. It is a governing-law assumption, not an assumed accuracy identity.
- Geometry: the existing integer-indexed `OneDimensionalFiniteVolumeGrid`, with strictly positive widths and exact adjacency. Face `j` is `grid.cellLeft j`, and `grid.cellLeft (i+1) = grid.cellRight i` is proved from adjacency before using the physical law. Finite blocks include exterior faces `start` and `start+count`.
- Exact cell average: existing `finiteVolumeCellAverageOn grid (fun x => q x τ)`. Its integrability/normalization certificate is derived from the rectangle predicate for every cell and time.
- Numerical input: an independent arbitrary array `old`. No equality or bound relating it to exact averages is assumed.
- Numerical flux: arbitrary `rule : ℝ → ℝ → (ℤ → (Fin m → ℝ)) → ℤ → (Fin m → ℝ)`. Both time endpoints, the complete current array, and the face are explicit inputs. Fixed grid, constitutive parameters, or boundary procedures may be captured when this function is supplied. No binary stencil, common face rule independent of index, Riemann solve, or quality property is required by the algebra.
- Physical face reference: `physicalFaceAverage` reuses `oneDimensionalCellAverage` in the time variable. For `s<t`, it is `(t-s)⁻¹ • ∫ τ in s..t, flux(q(face,τ))`. Its genuine interval-average certificate follows from the rectangle predicate. It is not a static point evaluation.
- Numerical update: `numericalUpdate` reuses `riemannFiniteVolumeUpdate` as the existing raw nonuniform flux-difference operation. That definition itself requires no Riemann solver certificate, and none is asserted here.

Writing `w_i` for positive cell width, `dt=t-s`, `A_i(τ)` for the exact cell average, `N_j` for the supplied numerical face flux, and `P_j` for the physical time-average, Lean derives

`w_i • (Qnew_i - A_i(t)) = w_i • (Qold_i - A_i(s)) + dt • ((N_i-P_i) - (N_(i+1)-P_(i+1)))`.

The proof first derives the exact weighted cell-average change from the rectangle law using temporal `integral_sub`, then subtracts it from the existing weighted numerical update. The block theorem telescopes this identity over any finite contiguous block, including nonuniform cells, by reusing `sum_conservativeFluxDifferenceUpdate` on weighted errors. Only the two physical exterior face errors remain. There is no duplicated telescoping induction.

## Separate source-wrapper proposal

`source-wrapper-fragment.lean` is a thin proposed source contract. It returns positive duration, exact cell-average and physical-time-average certificates, an actual computed next array, the update formula, the local error identity, and the finite-block error identity. Its independently compiled standalone file is `source-wrapper-check.lean`, formed by prepending the exact candidate bytes. The fragment is not a standalone canonical module; after approved extraction it would import the chosen generic owner.

The proposed contract makes the rectangle temporal convention explicit. It does not itself settle the printed Eq. (1.10) temporal interpretation or assert that Chapter 1 uniquely specifies a time-averaged numerical-flux convention. Time-averaged **physical** flux is an exact reference derived under the stated governing law, not a claim about the numerical quadrature procedure. Root owns the interpretation and any future semantic audit.

The source calls for sufficiently useful approximations without quantifying quality. The draft records the exact consequence of whatever numerical flux is supplied. It does not prove that an arbitrary rule approximates well, converges, is stable, or is an adequate scheme. Any claim of source exhaustiveness still requires review; successful algebra does not turn every supplied rule into a good method. No arbitrary tolerance predicate or assumed accuracy conclusion is introduced.

## Nonstationary, distinct-role witness

`witness-fragment.lean` is verification evidence, not proposed reusable production mathematics. Its standalone check prepends the candidate and imports Mathlib's standard scalar integral formula.

The actual unit grid has cells `[i,i+1]`. The exact state is `q(x,t)=(x-t)•1` in `Fin 1 → ℝ`, with identity flux. Its rectangle law is obtained from `travelingWave_isRectangleConservationLawSolution` and continuity of the linear profile. The numerical old array is zero. The numerical rule uses `data(j+2)+(t-s)•1`, so its definition permits dependence beyond the two cells adjacent to a face and explicitly depends on time.

Lean computes the exact average in cell 0 at time 0 as `1/2`, and the physical flux averaged over time `[0,1]` at face 0 as `-1/2`. It proves that the old numerical value differs from the exact average, that the physical time-average differs from the initial static flux 0, and that the numerical flux is nonzero. The general local error identity is instantiated with this conserved field, grid, rule, and numerical data. This is nonvacuity and role-separation evidence, not an assertion that the chosen rule is accurate.

## Reuse searches and decisions

Interactive searches preceded each foundation/witness prerequisite; their exact scoped replay, commands, outputs and exits are recorded in `input-provenance.json`. No documented miss is treated as exhaustive semantic absence.

| Search / producer | Decision |
| --- | --- |
| Project `weighted.*error`, `error.*flux`, `flux.*error`, `sum.*Flux`, `telescop`, `cellAverage`, `finiteVolumeUpdate` | Existing cell-total and telescoping APIs found. No selected producer connected independent numerical data to time-dependent exact rectangle conservation. |
| Project `average.*balance`, `balance.*average`, `timeAveraged`, `timeAverage.*Flux`, `physical.*Edge` | Existing compatibility source API stores abstract physical edge values but does not derive them from time integrals. It is not the required physical reference producer. |
| `ConservationLaws.Rectangle` | Reused the exact rectangle predicate and its integrability fields; witness reuses the translated-profile solution theorem. |
| `FiniteVolume.CellAverage` | Reused both spatial and temporal normalized interval averages, their certificate, and width-times-average integral identity. No duplicate integral normalization or Lebesgue measure definition. |
| `FiniteVolume.RiemannInterface` | Reused actual interval grid, positive volume, normalized grid averages, and raw nonuniform update. The semantic name of the raw update does not assert a solver has been used. |
| `FiniteVolume.LocalFluxBalance` | Reused `cellVolume_smul_finiteVolumeCellAverageUpdate` for the cell-total formula. The general interface-incidence mesh is not used for physical boundary coverage because ordered endpoints provide exact complete face orientation directly. |
| `FiniteVolume.FluxDifference` | Reused `sum_conservativeFluxDifferenceUpdate` on the finite block's weighted error sequence. Existing theorem has one scalar scale; weighting by each cell's actual width first leaves the common `dt`, so no uniform-grid assumption is introduced. |
| Mathlib telescoping search `sum_range_sub`, `sum_Ico_sub`, `sum_Icc_sub` | Found interval-sum related APIs; the existing project flux-difference producer matches this need more directly. |
| Mathlib `intervalIntegral.integral_sub` | Reused to separate left/right time-integrated fluxes, with integrability taken from the rectangle predicate. |
| Mathlib `integral_smul_const`, `integral_id` | Reused for explicit vector witness integrals. No duplicate integration proof. |

## Limits and verification

The exact state codomain is finite-dimensional and complete; `m=0` is allowed as a degenerate general case, while the explicit witness uses `m=1`. No incomplete Banach-space fallback is used. The predicate controls the actual supplied pointwise boundary fluxes; the draft does not independently construct distributional normal traces or choose physical representatives at stationary discontinuities.

The existing grid covers its modeled cells, and the theorem treats every finite contiguous block with both exterior endpoints. No assertion of a globally exhaustive partition of all of `ℝ`, boundary conditions, or a finite-domain ghost-cell policy is added. The full-array rule is arbitrary and can capture supplied boundary data; this is an update/error theorem, not an admissible-state or full solver framework.

The candidate and source wrapper passed their first native checks. The first explicit witness check failed only in partial-function simplification and scalar contradiction elaboration; `failed-witness-v1.lean`, `failed-witness-fragment-v1.lean`, and the raw output/actual exit 1 are retained. Explicit function equalities and a typed scalar contradiction repaired the witness; the second native witness check passed. An initial interactive PowerShell search used unsupported brace-list syntax and returned parser exit 1 before any search ran; explicit path/directory searches immediately replaced it. No production edit resulted.

The final exact declaration/axiom check covers 19 new declarations across the foundation, wrapper, and witness plus 13 reused declarations. The receipt validates exact concatenation of candidate/fragments into checked files, all actual exits and raw hashes, only the allowed axioms `propext`, `Classical.choice`, and `Quot.sound`, source/runtime/Mathlib provenance, direct import oleans, and unchanged original audit inputs. Root handles canonical placement and final source judgment.
