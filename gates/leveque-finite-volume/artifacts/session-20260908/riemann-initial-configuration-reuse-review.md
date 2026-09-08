# Riemann initial configurations and paired material/state data

The new inventory definitions are on printed page 5/raw page 27 and printed
page 8/raw page 30. Searches used `Riemann.*(Problem|InitialValue)`,
`riemannData.*prod`, and `IsRiemannData.*prod` in the canonical library and
pinned Mathlib. The existing `IsRiemannData`, `riemannData`, and
`isRiemannData_iff_exists_valueAtOrigin` are selected unchanged. Existing
`HyperbolicRiemannProblem` and `IsHyperbolicRiemannSolution` were inspected:
the former packages a global differentiable conservation law and ordered
states, while the latter additionally fixes the classical interval-mass
solution convention implicated by the moving-step counterexample. They do
not provide a general equation-plus-data definition independent of that
classical convention. No product-profile lemma was selected from the searches;
this is not a claim of global semantic absence.

The candidate's general `IsRiemannInitialValueSolution` takes an independently
supplied evolution equation as a predicate on spacetime fields, retains that
predicate unchanged, and conjoins the exact two-state initial-data condition.
Its iff exposes all parts, and a second iff exposes the free value at zero.
The generic definition applies to any equation; a source wrapper and audit
must explicitly identify its intended hyperbolic-equation application and
judge this generality. No hyperbolicity theorem, solver existence, or opaque
solution certificate is inferred from the definition itself.

The paired material/state theorem separately proves that a joint Riemann
profile is equivalent to simultaneous left/right profiles for both component
fields. Its constructive identity preserves both free origin values. It
asserts no reflected/transmitted-wave dynamics, interface solver, or physical
homogenization rule. Product equality, component projections, and the existing
piecewise data producer give the proof.

Native `lake env lean gates/leveque-finite-volume/artifacts/session-20260908/riemann-initial-configuration-candidate.lean`
exited 0 with no warnings/errors. All four printed axiom closures contain only
propext, Classical.choice, and Quot.sound; the exact successful output is
`riemann-initial-configuration-output.txt`. The candidate remains scratch and
has no independent source-audit classification yet.
