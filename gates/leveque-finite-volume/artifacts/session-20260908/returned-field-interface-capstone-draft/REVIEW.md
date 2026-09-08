# Prospective returned-field interface capstone

This is a compiled, **unselected** source-facing assembly using the four frozen generic returned-field leaves. It neither changes the rejected audit nor asserts source acceptance. No canonical source, source wrapper, aggregate, tier, gate, ledger, audit, topology or Git state was edited.

## Actual primary-source review

The immutable package PDF has SHA256 `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`. Raw pages 26, 27 and 28 (printed pages 4, 5 and 6) were freshly extracted and rendered from that file with the installed Poppler tools; all three images were viewed. `preparation.json` binds the exact PDF, page text, renderings, commands, selected old task/decision/report and current question provenance. The initial unavailable-PyMuPDF attempt is retained as `prepare01`; `prepare02` succeeded with Poppler. No external copy of a page rendering supplied source evidence.

Printed page 5 connects neighboring cell averages, in left/right order, to a Riemann problem, the information obtained from solving it, a numerical flux and the time update. Its preceding finite-volume paragraph calls for physical flux approximation using numerical cell-average data. The continuation at the top of printed page 6 explicitly permits approximate Riemann solvers when exact nonlinear solutions are expensive. These passages do not give a quantitative accuracy metric/tolerance/order or a specification of the data representation that every approximate solver must return. The similarity/wave-structure discussion, shock-capturing properties and multidimensional discussion are adjacent context, not new conclusions of this capstone.

## Completed contract

All seven declarations are in the scratch namespace `NumStability.ReturnedFieldInterfaceDraft`.

1. `PureInterfaceContract` binds the ordered problem to `old (j - 1), old j` and the result **directly** to `method.solve problem (hdomain j)` by a let binding. Existential returned-field/information values must equal the field and extractor of that very result. It preserves strict initial half-lines, the free origin value, the supplied all-real temporal trace-integrability property and the actual computed interface flux. It does not require an exact returned solution or an error bound.
2. `pure_interface_execution` supplies this contract on each admitted interface independently of a grid, physical reference, time step or accuracy hypotheses.
3. `normalized_interface_execution` separately connects exact normalized initial cell averages to the actual adjacent cells and their shared face. The later comparison theorem still permits approximate old numerical values.
4. `constant_interface_consistency` specializes the actual solve/extract/interface execution to constant numerical data, obtaining the physical constant-state flux.
5. `exact_adapter_contract` preserves the exact method's selected result, returned field, initial data, rectangle certificate and existing interface flux. Exact conservation belongs to this special case and is not imposed on other returned methods.
6. `returned_field_comparison_contract` combines pure execution and constant consistency with the physical face-flux and next-cell-average error estimates. Its independent reference `q` is explicitly rectangle-conservative. It assumes old-average error bounds, numerical-versus-returned physical-trace bounds, and returned-versus-reference physical-trace bounds. Local coordinate zero is compared to `q (grid.cellLeft j) τ`, not to an unlocated auxiliary field. It concludes the sum of the two face errors and the existing update estimate, with `dt / grid.cellVolume i` multiplying the errors at faces `i` and `i+1`. The step is positive; no tolerance, rate, CFL or convergence assertion is supplied.
7. `nonexact_method_with_reference` reuses the existing one-component stationary transport witness. The selected returned field has the ordered initial data but fails rectangle conservation; the translated reference has the same initial data and does conserve. Their positive-time interface physical fluxes agree. This is a nonconstant, substantive instance of the inexact method class, not a new proof of generic nonlinear solver availability or a global small-error certificate.

`contracts.proof-free.md` contains the exact pure predicate body and theorem signatures. `Candidate.lean` is the full compiled assembly. No new average, integral estimate, numerical method, update, physical reference or hyperbolicity foundation was defined or reproved.

## Reuse and prior findings

Predeclaration name searches found no existing `ReturnedFieldInterfaceDraft`, `pure_interface_execution` or `returned_field_comparison_contract`. Searches of current finite-volume owners identified the frozen `RiemannFieldFluxMethod` execution/exact adapter, both `RiemannFieldFluxError` estimates, `finiteVolumeCellAverageOn_spec`, grid adjacency and the `StationaryRiemannField` witness. The placement's existing Mathlib/local estimate review remains bound through its receipt. This assembly uses those exact producers rather than copying their proofs.

The historical decision remains `not-faithful-weaker` (decision SHA256 `44dfd5c682eb5fdcd9fabd7b747df0ccbabc280d31482e26861c714a7b56c1a4`). The new mathematical assembly addresses actual selected execution and adds explicit physical comparison estimates. It does **not** retroactively resolve that judgment, prove availability of arbitrary nonlinear solvers, or turn an assumed conditional error bound into the source's undefined standard of good approximation. The pure contract remains a structural consequence of a supplied method; its conditional status is made explicit rather than presented as independent source strength.

## Remaining material scope

Question 7 is still unanswered: `call_1UY4fVuKrjpIIQfhLdeuFoRH` asks whether the qualitative finite-volume accuracy statement should be interpreted using old cell-average and time-averaged face-flux error bounds. The present comparison supplies a sufficient decomposition of those face bounds into extraction and returned/reference trace bounds. It chooses neither smallness nor a convergence order. An answer to question 7 has not been inferred.

There is an additional **representation and temporal-domain boundary** if this capstone is proposed as a characterization of the whole source workflow. The frozen `RiemannFieldFluxMethod` requires a full field with exact ordered initial data and integrable physical interface trace on every finite interval of **all real times**. The source continuation permits approximate solvers, but does not require that every such solver expose a full field, rather than only interface information/waves, nor does it specify negative-time extensions or this exact trace-integrability domain. Constant consistency and an arbitrary extraction rule also do not, by themselves, establish that the method is a good approximation of the physical problem.

A concrete reviewable scope for this completed contract is: **for admitted conservation-law Riemann routines represented by the stated full-field method class, the actual solve/extract/flux execution has the pure contract; relative to an independently supplied rectangle-conservative reference, explicit old and trace errors imply the stated face and cell update bounds. Exact certified routines embed, and a nonexact routine inhabits the class.** This is the exact theorem, not an adopted interpretation or assertion that it exhausts all approximate Riemann solvers.

The alternatives for root's scope review are to retain this explicitly scoped method-class application, or to pursue a broader information/trace-only interface contract with time-domain hypotheses limited to the required step. The latter is additional local mathematics if wanted, not work claimed complete here. No requirement to ask another user question is inferred merely from this review. The pure per-interface contract needs no convention about which weak equation all returned fields solve. The comparison's rectangle premise is explicit; presenting it as the book's unqualified physical solution concept must retain the already recorded discontinuity convention within its actual scope, not silently extend it or reinterpret prior audits.

## Native evidence and reproduction

`native01` exited 0 with seven exact declaration and axiom checks. All reported axioms are among `propext`, `Classical.choice` and `Quot.sound`, with no warnings or `sorryAx`. The native input is a byte-exact copy of `Candidate.lean` followed by inspection commands. Imported compiled modules, canonical source files, selected context and runtime configuration are hashed before execution and checked unchanged afterward.

From the repository root, use Windows Python `C:/Users/qed_s/AppData/Local/Programs/Python/Python312-arm64/python.exe -B` with:

```text
gates/leveque-finite-volume/artifacts/session-20260908/returned-field-interface-capstone-draft/run.py <fresh-label>
gates/leveque-finite-volume/artifacts/session-20260908/returned-field-interface-capstone-draft/verify.py
```

The runner invokes `C:/Users/qed_s/.elan/bin/lake.exe env lean <retained-input>` against pinned Lean 4.29.0-rc3 and Mathlib e8ea1afc32790ce1d4e1a4e45cc412ba9388716b. Existing attempt labels are protected. `manifest.json` and `final-receipt.json` freeze all authored artifacts, native evidence and exact dependencies. Root owns any later selection, independent audit, exposure and checkpoint.
