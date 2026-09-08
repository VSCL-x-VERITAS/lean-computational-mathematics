# General one-step domain foundation

The checked draft characterizes dependence on current data for arbitrary admissible histories. It does not prescribe a numerical state type, force histories to be all finite sequences, or extend an update to unattainable current data. It is a broader mathematical representation for a future audit, not a new source-faithfulness decision.

## Exact source and prior decision

I viewed the full pinned `page-032.png`, printed page 10/raw PDF page 32, Section 1.7, final notation paragraph. The source says that the next-time solution is determined entirely by current-time data. The surrounding text identifies numerical quantities, spatial subscripts and temporal superscripts. It does not enumerate a complete current-data object or specify an admissible-history domain. No unrelated bibliography on the page is used as mathematical evidence.

The source SHA is `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`; exact rendering, task, locator, decision and report hashes are in `input-provenance.json`. The previous audit remains undetermined: decision `407f81e19b77273538f53bce5cb3894398d0615ca932a6e87ca02f37071b80d7`, report `976369574b1dc976e7e2bd0113ce9526751096eea1eccf9bce74db1369914bb7`. That audit had already resolved indexing, quantity roles, factorization correctness and nonvacuity; its residual issue was the correspondence of the total numerical-field-history model to unspecified complete data and admissibility.

## Checked statements

The core theorem, `NumStability.OneStepDomainDraft.factorsThrough_iff_rangeFactorization`, has arbitrary `History : Sort*`, `CurrentData : Type*`, `NextData : Sort*`, `current : History → CurrentData` and `advance : History → NextData`. It proves:

```text
Function.FactorsThrough advance current
  ↔ ∃ step : Set.range current → NextData,
      advance = step ∘ Set.rangeFactorization current.
```

`currentData_dependence_iff_range_update` spells the left side out as equality of advances whenever two histories have equal current data. Neither statement has a `Nonempty` codomain assumption. A representative of each attainable current datum is obtained from the existing surjective range map; constancy on fibers makes its advance well-defined. The reverse implication follows by applying the same step to equal range elements.

`admissibleFiniteHistory_iff_range_update` specializes to any subset of finite histories, with `current = last`. `originalOneStep_iff_range_update` is a thin bridge to the unchanged source abbreviation and its original numerical-vector-field history type. The latter bridge does not claim that the original choice exhausts the source's meaning. Both are specializations of the same general proof.

`emptyDomain_range_update_without_total_extension` provides a concrete boundary case: with empty history and next-data types but current-data type `Unit`, the range update exists, while any function on all current data is impossible. Thus the missing nonemptiness assumption is substantively avoided rather than inferred silently. `nonempty_currentData_update_example` separately supplies a nonempty example: histories are `ℕ × Bool`, current data are the first coordinate, and the update is its successor, independent of the varying earlier-information coordinate. The empty case is not the sole example.

## Reuse search and decisions

Project and Mathlib searches preceded implementation; their scoped replay and exact commands/exits are retained. Terms included `FactorsThrough`, `rangeFactorization`, `oneStep`, surjective factorization, and surjective lifts.

* `Mathlib.Logic.Function.Basic.Function.FactorsThrough` (definition at line 680) is reused directly; no duplicate dependence predicate was introduced.
* `Function.factorsThrough_iff` (line 729) was inspected and rejected as an exact producer for the desired range statement: it requires `[Nonempty NextData]` and creates an update on the full intermediate type. The native declaration check exposes that premise.
* `Set.rangeFactorization` and `Set.rangeFactorization_surjective` in `Mathlib/Data/Set/Operations.lean` supply the actual range and its surjective map.
* `Function.Surjective.hasRightInverse` in `Mathlib/Logic/Function/Basic.lean` supplies representatives without a nonempty-type assumption. The core proof composes these existing producers; it does not reimplement choice or surjectivity.
* The existing source theorem is reused only as an inspected/checked specialization boundary. Its canonical bytes remain unchanged.

The scoped searches found no exact existing range-factorization equivalence among the matched candidates. This is not a claim of global semantic absence. Algebra-specific surjective lift APIs do not improve this unstructured function theorem.

## Limits and interpretation

`History` can be an admissible-history subtype, a state-machine domain, or another complete transition domain. Independently varying auxiliary current information can be included in `CurrentData`; the theorem imposes no exclusion. It does not prove that a particular modeler-selected extractor actually contains all intended current data. `advance` is total on the selected admissible `History`, so partial numerical updates can be represented by restricting that domain; no values outside it are requested. The statement models deterministic updates. Its factor map is obtained with classical choice, with no claim of a computable implementation, efficiency, locality, autonomy, or a particular physical scheme.

This removes the previous fixed-type/full-history/total-extension commitments from the general representation. A future source target still must identify `current` with the intended current-time data and `History` with its intended admissible transitions. No source convention or acceptance follows merely from checking this generic theorem.

## Native evidence

The repaired candidate and the declaration/axiom check both exited 0, without warnings. Six new declarations and four selected existing producers were checked; all axioms are subsets of `propext`, `Classical.choice`, `Quot.sound`, with some declarations axiom-free. The general core uses only `Classical.choice` and `Quot.sound`. Native version and direct import provenance are retained.

The first attempt's original source, raw Lean output and actual Lean exit 1 remain preserved. Its only Lean issue was an untyped history lambda in the original-model bridge. After saving that output and exit, the first capture helper also encountered a Windows console encoding error while echoing the error text; this did not lose or alter the raw Lean output or its receipt. The task-local helper was fixed to echo raw bytes and its original version retained. No canonical file, gate, ledger, audit output, released helper or model role was changed or invoked.
