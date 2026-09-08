# Huber shock production extraction

This bounded extraction uses the selected LeVeque PDF, SHA-256 `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`, printed pages 4–5 / raw PDF pages 26–27. Workflow release `formalization-workflow-v5.0.1`, commit `7d9cbf158607ace1c94d9ce13e26106c43e12a23`, stage `leveque-chapter01-codex-20260908`. The profile SHA is `b140898932e6b43e2340459f2d7b4cfee42fddc18ef1ae307ed1c11e55b2d9ea`; Mathlib is pinned to `e8ea1afc32790ce1d4e1a4e45cc412ba9388716b`.

The frozen scratch source and receipt remain unchanged: `shock-continuation/candidate.lean`, SHA `ba18e8fc4caadc0d6e46128bb09d1e4a34cf873d59e25676241f4b5389854027`, and `shock-continuation/final-verification.json`, SHA `75b99985a415ab7b9e5cb15c319a1e138a856a2258ff41062611ae88ef7f1a57`. Their earlier review records the construction, all initial searches and failed routes. No failed elaboration is accepted as proof evidence here.

## Mathematical ownership

Ten new canonical modules have substantive declarations, with no umbrella-only modules. `Analysis/SpecialFunctions/Huber.lean` owns the normalized Huber function, its clipped slope, its actual derivatives, C1 regularity, explicit formulas, convexity and failure of affine linearity. Generic gluing and right-derivative facts live in `Analysis/Calculus/Piecewise.lean` and `Analysis/Calculus/Deriv/Abs.lean`. The finite-interval piecewise-integrability wrapper lives in `MeasureTheory/Integral/IntervalIntegral/Piecewise.lean` and directly uses Mathlib's `Integrable.piecewise`.

The mathematical example is split into `ConservationLaw/Examples/HuberShock/Basic.lean`, `Potential.lean`, `Regularity.lean`, `Jump.lean`, and `Conservation.lean`. These separate definitions and initial data, potential calculus, spatial regularity, traces/local admissibility, and integral conservation. All authored declarations retain the `NumStability` root; example-specific declarations use `NumStability.HuberShock`. Reusable modules do not import Source. `files-before-check.json` records exact measured file lengths and hashes; each file is below 150 lines in this extraction.

`HuberShock.shockState_isRectangleConservationLawSolution` uses the existing shared `NumStability.IsRectangleConservationLawSolution` from `Analysis.PartialDifferentialEquations.ConservationLaw.Rectangle`. There is no copied conservation predicate or Riemann prelude. The predicate's integrability fields are inhabited by independently proved spatial and temporal integrability. Its balance field comes from FTC applied to the explicit continuous potential and its actual right derivatives.

`Source/LeVeque/Chapter01/NonlinearShockFormation.lean` exposes `NumStability.leveque01_nonlinear_shock_formation`. The source theorem existentially quantifies the flux, field, positive formation time, interface and two strictly ordered traces. It requires a C1 flux that is not affine, the shared rectangle law, C∞ initial data, and spatial continuity for every nonnegative time before formation. It does not expose the chosen initial profile, formation time or interface coordinates. Its proof uses the concrete field at the first jump time, T=1, so the asserted continuity persists up to that time. Distinct one-sided limits describe an actual jump independent of its point representative.

The scratch's large final conjunction is not duplicated in production. Its ingredients are directly composed by the source existential. `candidate-producer-map.json` maps every scratch declaration to its semantic producer or, for that final conjunction, to the replacement existential wrapper. The new no-affine theorem strengthens the scratch no-homogeneous-linear theorem by evaluating a hypothetical affine representation at zero; this avoids calling a merely affine flux nonlinear.

## Reuse review

`reuse-searches.json` records fresh current-tree searches over both project roots and the pinned Mathlib calculus, analysis and measure-theory trees. The Huber/shock names and all five proposed helper names had no matches in those scopes before the extraction. This is scoped evidence, not a global absence assertion. `piecewise-producer-search.json` resolves the integrability producer to `Mathlib/MeasureTheory/Integral/IntegrableOn.lean:180`.

The extraction retains direct reuse of `intervalIntegral.integral_hasDerivAt_right`, `contDiff_one_iff_deriv`, `Monotone.convexOn_univ_of_deriv`, `ConvexOn.le_max_of_mem_Icc`, `HasDerivWithinAt.union`, `continuous_if_le`, `Integrable.piecewise`, and `intervalIntegral.integral_eq_sub_of_hasDeriv_right`. Generic helpers specialize and compose these library producers. The parent-owned shared rectangle predicate was read and reused without changing its owner. No same-book source wrapper is imported into reusable mathematics.

Rejected routes remain explicit: a no-C1 continuation theorem alone does not establish shock existence; the Burgers three-jump nonentropy bubble remains rejected; the bounded inverse-branch construction was unnecessary for this C1-flux example. No implementation claims those routes were proved or used as accepted source evidence.

## Scope and admissibility limits

The explicit flux is C1 and convex; its formula has second-derivative transitions at ±1, so no C2/C∞ flux is claimed. The smooth initial field is −x on the whole real line: unbounded and not globally integrable, with all finite-interval integrability proved. The selected source passage imposes no boundedness or compact-support requirement, but the source-faithfulness judgment remains independent work. The pre-collapse property proved for the state is spatial continuity, not global C1 regularity across its moving interfaces.

At and after collapse the actual right trace is chosen at the stationary interface. Both actual traces have equal physical flux; an arbitrary replacement value would not automatically preserve flux on a rectangle edge lying along that interface. No such representative invariance is assumed. Equal fluxes, inward characteristic speeds and the Oleinik chord inequality remain separately proved local facts in `Jump.lean`. Neither the source statement nor the mathematical API claims a full spacetime Kružkov entropy inequality, equivalence to an entropy-solution definition, or uniqueness.

The time-integrated rectangle law is used explicitly. It is not silently identified with the literal classical derivative of cell mass at every corner/collapse time in printed equation (1.10). The coordinator owns that source-interpretation adjudication.

## Verification and integration boundary

Verification is pending while this report is drafted. Final native focused-build, ten per-file elaboration, exact declaration/axiom outputs and actual exit sidecars will be bound by `final-verification.json` after they pass. All failed outputs will remain separately named.

The extraction script completed all ten writes and mapping metadata, then its initial console-only size summary failed because a default Windows cp1252 read encountered Unicode Lean text. The summary reader was corrected to explicit UTF-8; production content was inspected, and subsequent preparation enumerated all ten files successfully. No Lean result was inferred from that script's first exit status.

This subtask does not certify source-faithfulness auditing, Chapter 1 counts or gate closure, full-library/compatibility builds, umbrella/tier integration, lifecycle/topology state, or Git integration. Those belong to the coordinator. Writes are confined to the ten authorized new production paths and `session-20260908/shock-production` evidence; existing owners and the frozen scratch directory are unchanged.
