# Information-returning Riemann routines: canonical placement

This increment places the 24 approved declarations from the frozen information-only draft into four new canonical leaves. It changes ownership and names without adding hypotheses or a source interpretation. The old draft, prior field API, source wrappers, audits and gate artifacts remain unchanged. Root owns aggregate exposure, tiers, full builds, organization and later source contracts.

| New leaf under `Analysis/PartialDifferentialEquations/FiniteVolume` | Lines | Declarations | Boundary |
| --- | ---: | ---: | --- |
| `RiemannInformationFluxMethod.lean` | 65 | 5 | Dependent result and admitted execution; only existing `RiemannInterface` imported |
| `RiemannFieldFluxMethodInformation.lean` | 61 | 6 | Forgetful field-method adapter and optional finite-interval trace |
| `RiemannInformationFluxError.lean` | 67 | 2 | Conditional selected-result trace and update estimates |
| `Examples/LeftStateInformationFlux.lean` | 130 | 11 | Ordered-state example, unit-speed reference linkage and old field embedding |

`placement-map.json` gives all 24 exact draft-to-canonical declaration names, imports and source hashes. The authored namespace remains `NumStability`. The example namespace is `NumStability.LeftStateInformationFlux`; arbitrary-law left-state selection is not described as upwind. All four files have LF bytes and no declaration-bearing parent collision.

## Contract and reuse

The six-field `RiemannInformationFluxMethod` carries an explicit problem domain, a dependent `Result`, the selected solve function, extraction, numerical flux, and constant admissibility/consistency. It imposes no returned space-time field or physical-solution certificate. `interface_execution` binds the ordered adjacent pair `(old (j-1), old j)` and extracted information to that very result. The API requires admission for the supplied full array of interfaces; it does not infer admission for a later updated array. Constant consistency alone is not a statement of physical accuracy.

The field adapter copies the original six fields and leaves its result type unchanged. The stronger existing field method separately supplies an integrable trace on any requested finite interval. No such obligation is added to the information-only core.

The optional trace in `interface_error_le` depends on the actual selected result. Its integrability is required only on the actual interval `s..t`, with `s<t`. Numerical-to-trace and trace-to-independent-physical-reference bounds yield the face-average bound through the existing `norm_sub_oneDimensionalCellAverage_le_of_trace`. The update theorem reuses `riemannFiniteVolumeUpdate_error_le`; old numerical cell data remain separate from the conserved reference `q`. Only the two used face traces require comparison/integrability assumptions. The reference rectangle predicate supplies physical-flux integrability. No tolerance, convergence rate, admissibility rule or source accuracy convention is chosen.

The concrete result contains two vectors and their two ordering facts. It supplies a nonconstant `Fin 1` problem with the actual pair `(0,1)`. A separate unit-speed transport proof identifies its optional trace with an independently conserved reference at positive times and proves equality with the finite-step reference average. The existing nonexact field-method witness embeds with its original result and remains nonexact. These distinguish execution, optional physical comparison and actual field nonexactness.

Recorded searches precede placement. `search-01.txt` is the scoped exact proposed-name search in current `ComputationalMathematics`, with exit 1 and no matches. This is not an exhaustive claim about other spellings or libraries. `search-02.txt` records reuse of the field method and existing trace/update estimates. `search-03.txt` records the established nominal-placement comparison helper. No new derivative, integral or norm estimate is re-proved here. The frozen draft's project/Mathlib search and source provenance remain bound through its final receipt; `dependency-provenance.json` additionally records 26 current local source/olean modules, 16 direct Mathlib source/olean imports, package revision and actual native runtime output. It is not a full transitive Mathlib file census.

## Preservation checks

The old `Method` and `OrderedResult` structures and their canonical successors are nominally distinct. `Comparisons.lean.fragment` gives explicit maps of all six method fields and all four result fields in both directions, both round trips for each structure, and structural equivalences. Full dependent extractors are compared, including the implicit problem index. Selected results, extraction, interface flux, field adapters, optional traces and the concrete example commute under those maps. The example maps both the result and method types.

Seven complete theorem statements are transported through the explicit maps and then checked against the exact frozen theorem type. Ten unaffected concrete contracts have direct type-compatible theorem equalities. The latter use Lean's proof irrelevance only after elaboration has checked their proposition types. There is no claimed equality or definitional equality between the nominal structure types. The 52 comparison declarations and their exact list are recorded in `comparison-plan.json`; its original fragment hash is preserved by `comparisons-01.fragment`, while `comparison-repair-02.json` binds the final fragment.

The native focused build passed, followed by all 24 canonical declaration/axiom checks. `comparisons-01` failed because two scratch six-field headers left the extractor's implicit problem unsolved; its complete source, raw output, actual exit 1 and original fragment remain preserved. `comparisons-02` passed after making those entire dependent functions explicit, with no production change. A final combined check repeats the 24 canonical reports, 29 frozen-draft/reuse reports and 52 comparison reports while binding all recorded local dependency and direct Mathlib source/olean bytes before and after execution. `axiom-verification.json` and `final-receipt.json` record the actual results; allowed axioms are only `propext`, `Classical.choice` and `Quot.sound`.

The frozen input draft has two historical mutable-path resolutions already retained there: native-01's example fragment is `native-01-Examples.lean.fragment`, and its original runner is `run-01.py`. Their exact hashes and the unchanged final draft receipt are recorded in `manifest.json`. This placement does not alter or reinterpret those historical receipts. Evidence capture uses native Python with `-B`, excludes generated `__pycache__`, and invokes the pinned native Lake/Lean. No released workflow helper or semantic model process is run.

## Limits

This is reusable mathematical placement, not a faithfulness decision, adoption of a quantitative accuracy convention, or assertion that every consistent information routine solves a physical Riemann problem. The pending source-accuracy question remains separate. The broader core removes a compulsory full-field representation from execution; optional local traces still take real time as an argument but have no required behavior or integrability outside the stated step. Repository-wide exposure and validation remain root's work.
