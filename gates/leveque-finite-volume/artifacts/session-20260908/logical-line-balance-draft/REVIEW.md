# Supplied-volume coordinate-line balance draft

This scratch draft extends the mathematics of the frozen Cartesian tensor-line draft without selecting a meaning of logical rectangularity. It introduces coordinate indexing and explicit conservative operations with supplied volumes and shared-face flux values. It does not introduce a source wrapper, claim source acceptance, or alter the old dimensional-splitting audit.

## Concrete mathematics

Cell indices are functions `D → ℤ`, for any direction type with decidable equality. No finiteness of the direction type is needed for one finite line or a finite scheduled sweep. The supplied volume function assigns a positive real number to every cell; it need not factor as a product of coordinate widths and may vary along and across lines.

A shared face is indexed by its direction and its right cell. Its rule receives that face index, the duration, and the actual numerical state restricted to the coordinate line through the face. Its output is treated as an oriented, area-integrated numerical normal flux. Thus it has the units of a cell-total transfer rate; no separate face-area multiplication is omitted from an asserted physical-density formula. The right face of cell `i` is the left face of its coordinate successor. Both cell updates evaluate exactly the same rule, face index, duration, and old line data there. This indexing makes the shared value an executed operation, rather than an assumed cancellation conclusion.

The update directly uses the existing `finiteVolumeCellAverageUpdate` with the supplied volume and right-minus-left shared flux. The cell-mass theorem applies `cellVolume_smul_finiteVolumeCellAverageUpdate` unchanged. The finite-line theorem applies the existing `sum_conservativeFluxDifferenceUpdate` to the volume-weighted masses and the single face-flux table. It retains both exterior face terms for every integer start and natural count, including the empty line. A boundary-equality corollary preserves weighted mass, and the adjacent-two-cell theorem explicitly displays cancellation of their common face. The numerical averages are arbitrary supplied data, not equated to exact averages of a continuous field.

The line-locality theorem proves that changing values outside the line cannot affect any updated value on that line. A sweep uses the existing `orderedOperatorSweep`; its recursive equation and two-stage equation feed each actual output into the next directional operation. The two-stage mass formula evaluates the second normal flux on the first updated state. Stage directions and durations are arbitrary; the algebra also covers positive physical durations without requiring them as unnecessary hypotheses. No commutation of different directions is claimed. General per-stage line balance follows by applying the line theorem at the current state exposed by `sweep_cons`.

A concrete scalar two-cell example supplies volumes 1 and 2, zero initial data, and a nonzero interior face flux. Its updated averages are -1 and 1/2, and the weighted mass sum is zero. This checks that the specialization genuinely permits unequal volumes and nonzero updates; it does not certify a particular physical constitutive flux or Riemann solve.

## Reuse and rejected alternatives

Eight retained read-only searches cover the listed current-project and pinned Mathlib paths; exact commands, actual exits, raw stdout/stderr and input hashes are in `reuse-provenance.json`. The scoped coordinate-line search found only the existing linear-interface estimate, not an equivalent supplied-volume directional operation. This is not an exhaustive library absence claim.

`LocalFluxBalance.lean` already contains the generic cell-total multiplication theorem and a finite-interface-mesh boundary theorem. The latter requires an actual measured/topological cell partition and a finite interface type. Fabricating such geometric data solely to use that theorem would add assumptions unrelated to this algebraic subtask. Instead, the coordinate finite-line result reuses the existing scalar-coefficient telescoper on weighted masses. No new generic telescoping proof is introduced.

The newer `FluxUpdateError` family additionally links numerical updates to a conserved exact field on an actual one-dimensional interval grid. That stronger interface is unnecessary here: supplied multidimensional volumes are not falsely identified with one-dimensional interval widths, and no exact PDE field is available. The draft therefore imports the lower existing `LocalFluxBalance`, `FluxDifference`, and `OperatorSplitting` owners directly.

The frozen tensor draft's line restriction is simply `state (Function.update base d j)`. That elementary expression is used inline, avoiding a second public line abstraction or a dependency on the large frozen tensor/solver fragment. Mathlib's `Function.update_self` and `Function.update_idem` supply the coordinate identities. The prior exact-interface solver and tensor-box volume proofs remain unchanged and can supply additional interpretations later.

The prior `CoordinateHighResolutionMethod` wrapper requires constant-state preservation. Arbitrary supplied normal fluxes and metric data need not satisfy the additional geometric cancellation needed for that property. This draft therefore uses the existing general ordered-operator executor directly and does not attach an unproved high-resolution or constant-state property.

## Scope and future placement

The result is an algebraic conservation foundation. Positive real volumes and oriented integrated normal fluxes are supplied inputs. No theorem identifies those numbers with a measure of physical cells, constructs a normal vector or area from a chart, proves metric identities, or certifies that the numerical flux approximates a physical normal conservation-law flux. Those missing geometric and solver links remain explicit obligations for any future full physical/logical-grid contract. The user geometry interpretation remains pending.

No normalized reference average, entropy, truncation-error order, stability, CFL condition, convergence, or exhaustive high-resolution algorithm class is asserted. A full multidimensional boundary theorem over arbitrary cell regions and a cumulative sweep error estimate are also outside this bounded line-balance task.

If separately authorized for placement, the generic coordinate operation and balance statements fit one new flat `FiniteVolume/CoordinateLineBalance.lean` leaf, retaining authored `NumStability` names and importing the existing low-level owners. The concrete witness belongs in a separate examples/evidence leaf. Reuse the existing generic mass/telescoping producers rather than promote their specializations as replacements. There is no source-layer placement proposal until the interpretation is resolved.

## Verification

Every native attempt keeps its exact input, raw output and actual exit. The first attempt used the nonexistent name `Function.update_same`; the pinned source showed the correct producer `Function.update_self`. That attempt also exposed an overly shallow congruence proof and a final concrete cancellation. The revised line-locality proof uses equality of the actual restricted functions. The general balance and sweep theorems compiled before the witness cleanup. Failed declaration checks explicitly rejected the elaborator's `sorryAx` from the incomplete witness; they are not successful evidence.

The final manifest records the successful candidate/declaration input hashes, actual zero exit and allowed-axiom checks. It also rehashes the frozen tensor draft, its review/evidence, and all current direct dependencies. Only this fresh scratch directory is written; no production, gate, ledger, audit, topology, released helper, or Git change is made.
