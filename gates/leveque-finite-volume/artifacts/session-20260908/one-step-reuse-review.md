# One-step definition candidate

Source: printed 10/raw PDF 32, definition of dependence on data at the current
time level. The candidate is currently a scratch artifact; no production
declaration or gate closure is claimed.

Actual current-tree searches used `OneStepMethod`, `oneStepMethod`,
`dependsOnlyOn`, `DependsOnlyOn`, `currentState`, `historyUpdate`, and
`HistoryUpdate` over canonical project and pinned Mathlib source. No matches
resolved the selected numerical-method definition. Follow-up searches for
`FactorsThrough`, `factorsThrough`, and factorization through a function found
Mathlib's exact general mathematical predicate and equivalence:

- `Function.FactorsThrough`, Mathlib/Logic/Function/Basic.lean:680;
- `Function.factorsThrough_iff`, the same file:729;
- `DependsOn` and `dependsOn_iff_factorsThrough`,
  Mathlib/Logic/Function/DependsOn.lean:63 and :67.

The selected producer is `Function.factorsThrough_iff`. Its hypothesis means
equal current data give equal next data, and its conclusion constructs a map
from current data to next data. The required nonempty codomain is supplied by
the zero numerical field; it adds no restriction to real vector-valued arrays.
`DependsOn` is an alternative using restriction to a singleton set of time
indices, but introduces an unnecessary subtype representation.

The scratch wrapper allows arbitrary spatial index type and real component
dimension. The finite history contains levels zero through n and current data
are read at `Fin.last n`; the conclusion is at the next level. For each fixed n
the transition map may differ, so this does not impose autonomy or fixed time
steps. No past-to-current dynamical equation or consistency certificate is a
premise. The source-correspondence audit must still inspect those choices,
including empty spatial/component types and unrestricted supplied histories.
The existing factorization theorem is reused directly; no duplicate proof is
introduced.
