# Information-only Riemann execution and optional finite-step comparison

This scratch alternative is implemented and checked. It removes returned-field and all-real trace-integrability obligations from the **routine interface**. It does not adopt the pending full-field interpretation (`call_gBZtG6Mn328LLCQ5DfzmFZtV` as reported by the parent), the distinct finite-volume accuracy convention/question 7, or a source-faithfulness verdict. Existing production, frozen drafts, audits, gate, ledgers and Git state were not changed.

## Pure execution

`NumStability.InformationOnlyRiemannDraft.Method law Result Information` carries only an explicit problem domain, a dependent result family, `solve`, extraction from that result, a numerical-flux map, constant-state admissibility and constant-state consistency. It carries no space-time field, exact initial-data property, conservation certificate, optional local trace or integrability premise. A consistent routine is **not** thereby called a solved physical problem or an accurate approximation.

`selectedResult` evaluates `solve` on the actual `adjacentCellRiemannProblem law old j`, with its supplied admission proof. `interface_execution` displays the ordered input `old (j-1), old j` and binds extraction to that very selected result. `interfaceFlux_constant` specializes this actual execution to constant data; it works with the supplied admission proofs by Lean proof irrelevance. The routine is not forced to admit every nonconstant Riemann problem. The array interface requires admission at each interface of the particular given array, not totality on all input pairs or other arrays.

The domain/type context retains the canonical finite-vector differentiable hyperbolic conservation-law object. It does not introduce a new class of governing PDEs. A chosen method may depend on caller parameters; the theorem holds for that supplied method. The numerical current array is arbitrary and is not identified with exact cell averages by definition.

## Existing field-method embedding

`Method.ofField` has exactly the original `Result` and `Information` types and copies the original domain, solve function, extractor, numerical-flux function, constant admission and consistency. `ofField_solve`, `ofField_extract`, `ofField_numericalFlux` and `ofField_interfaceFlux` prove the preservation identities by `rfl`. No fresh result or substitute field is created. The separate `ofField_finite_trace_integrable` recovers only the trace property requested on the supplied finite interval from the original method's stronger certificate. That property is not added to the new core.

## Conditional local-trace comparison

`Method.interface_error_le` receives an **optional** flux trace as a function of the dependent result type of this exact ordered problem. It evaluates that function on `selectedResult method old hdomain j`. Its integrability requirement concerns only that selected trace on the actual finite step `s < t`; the physical reference trace is independently required to be integrable on the same interval. The numerical-to-local and local-to-physical bounds are explicit hypotheses on `Set.uIoc s t`.

The theorem invokes canonical `norm_sub_oneDimensionalCellAverage_le_of_trace`. The conclusion compares the actual extracted numerical flux with `timeAveragedPhysicalFaceFlux` at `grid.cellLeft j`. No returned field, initial trace, or local PDE solution is required. No property is imposed on the real-parameter trace extension outside the selected interval. The function type is a convenient ambient extension for the existing interval-integral API; its outside values are unconstrained and play no part in any bound.

`Method.update_error_le` additionally takes an independent rectangle-conservative physical reference and an old cell-average error bound. It requires optional trace integrability and the two error bounds **only at faces `i` and `i+1`**. Existing `riemannFiniteVolumeUpdate_error_le` gives

`newError ≤ oldBound + (t-s)/cellVolume i * ((aLeft+bLeft)+(aRight+bRight))`.

The old numerical values remain independent of the exact physical averages. No tolerance, smallness requirement, convergence rate, CFL condition, entropy assertion or generic nonlinear solver availability is concluded. The physical-reference rectangle law is an explicit conditional premise; it is not silently asserted to exhaust the source's solution concept. The frozen full-field source contract and its rejected historical audit remain unchanged.

## Concrete instances

`Witness.OrderedResult problem` stores two state vectors plus their equalities to the problem's left and right states. There is no field or time variable in this result. `Witness.method` returns this actual pair, extracts that pair, and chooses the physical flux of its first component. It is constant-consistent for the supplied law; no generic physical accuracy is inferred. `selected_pair` and `selected_flux` identify its output at the actual adjacent interface.

`concrete_information_only` chooses the existing one-component unit-speed transport law and the nonconstant ordered input `(0,1)`. It proves the actual extracted pair and the selected flux zero. Separate optional evidence takes the flux trace of the stored left component. For unit-speed transport, `localTrace_eq_transport_reference` reuses the existing exact translating reference and proves the positive-time trace agreement. `selected_flux_eq_reference_average` applies the same generic trace estimate with both errors zero, proving equality to that reference's average on every step `[0,dt]`, `dt > 0`. The reference is external mathematical evidence, not a hidden field returned by the information-only routine.

`existing_field_embedding` independently embeds the canonical stationary returned-field method. Its selected result is unchanged and its known failure of rectangle conservation for a nonconstant problem is retained. This establishes compatibility with existing field methods without erasing their actual result semantics or claiming they return exact solutions.

## Reuse and checks

The named project search found the existing field interface, selected-result extraction and finite-volume estimate owners. The Mathlib search for `RiemannSolver|numericalFlux|Riemann.*FluxMethod` returned no match; that is only the recorded term search, not a global semantic absence claim. The generic norm/interval machinery is reused through `CellAverageTraceEstimate` and `FluxUpdateErrorBounds`; no integral estimate or weighted-update norm proof was duplicated. Raw searches, actual exits, selected/rejected candidates and input hashes are in `reuse.json`.

There are 24 new checked declarations across three semantic fragments: core/adaptation, conditional accuracy, and examples. Five exact producer checks give 29 axiom reports. Final native `native-02` exited **0** with no errors, warnings or `sorryAx`; all reports use only `propext`, `Classical.choice`, `Quot.sound`. `Candidate.lean` is byte-identical to the successfully checked full input. `contracts.proof-free.md` contains exact native type/definition output, including the transparent method/result structures and selection/flux definitions, but no theorem proof bodies.

`native-01` exited 1 because an optional example rewrite left its explicit time argument unresolved. The only Lean change was to supply `result` and `τ` to that rewrite; the statements did not change. The entire failed input/output/receipt is retained, including the historical diagnostic `sorryAx` for that unsuccessful theorem. The first runner also encountered a Windows console `UnicodeEncodeError` while echoing the already saved failed output; the exact raw Lean output and actual Lean-exit receipt had already been written. `run-01.py` is retained; subsequent failure echo uses raw bytes. No failed evidence is relabeled as successful.

The final freeze verifies exact input assembly, every declared axiom request, source/dependency hashes and actual exits. The canonical import closure and compiled module bytes are recorded before execution and checked unchanged afterward. The pinned toolchain, selected Mathlib source files, actual native version output and immutable PDF SHA `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5` are bound. Source facts are not expanded beyond the existing frozen page/context evidence. This is local mathematical completion of an unselected representation alternative, not source adoption or acceptance.
