# Fixed-density local-flux obstruction

The independently reviewed source statement on printed page 8/raw page 30
asserts an existential possibility. The new candidate strengthens the earlier
state-only candidate by allowing a local flux to depend on both position and
the unchanged scalar state. It uses the explicit positive smooth coefficient
`1+x^2`, whose scalar matrix is hyperbolic at every position.

The representation predicate tests the actual derivative of `F(x,q(x))`
against `a(x) q_x` for every differentiable spatial profile. No derivative is
an arbitrary unconstrained certificate. Constant profiles force each
fixed-state flux slice to be independent of position; affine profiles then
force its derivative at state zero to equal both `a(0)=1` and `a(1)=2`.
Derivative uniqueness gives the contradiction. The contract rules out local
fluxes for the fixed density, without claiming to rule out a new density or
an integrating factor. It neither claims the witness is printed in the book
nor silently assumes the desired obstruction.

Current-tree searches used `Has.*Flux`, `transport.*[Ff]lux`, and
`Flux.*[Oo]bstruction` in the canonical tree and pinned Mathlib analysis tree.
The existing conservation-law linear-flux and Riemann-interface derivative
producers were considered; they do not prove this variable-coefficient
obstruction. The earlier session state-only coefficient-uniqueness candidate
was retained, but cannot cover explicitly spatial fluxes without this bridge.

Selected Mathlib producers are `is_const_of_deriv_eq_zero`,
`HasDerivAt.unique`, `HasDerivAt.comp`, affine derivative rules,
`ContDiff.add`, and `ContDiff.pow`. The source scalar-hyperbolicity wrapper
already resolves to the integrated producer and is reused unchanged here;
production placement will import that reusable producer directly. These
scoped searches are not a claim of global semantic absence.

The first elaboration passed all three calculus lemmas but lacked the
ContDiff operations import for the final smoothness proof. Its failed output
is preserved in `variable-coefficient-local-flux-first-output.txt` and is not
passed evidence. After selecting `ContDiff.Operations`, native
`lake env lean gates/leveque-finite-volume/artifacts/session-20260908/variable-coefficient-local-flux-candidate.lean`
exited 0; all four printed theorem closures contain only propext,
Classical.choice, and Quot.sound. The successful raw output is
`variable-coefficient-local-flux-output.txt`. This remains scratch mathematics;
source correspondence and applicability still need an independent audit.
