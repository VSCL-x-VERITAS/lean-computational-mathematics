# Explicit Huber-flux shock: implementation and source scope

The selected source is LeVeque's pinned PDF, SHA-256 `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`, printed pages 4–5 / raw PDF pages 26–27. Those pages assert that discontinuities can develop from smooth initial data in nonlinear conservation laws. This scratch file constructs an example; the Huber flux and the initial profile below are not attributed to a displayed example in Chapter 1.

Workflow release: `formalization-workflow-v5.0.1`, commit `7d9cbf158607ace1c94d9ce13e26106c43e12a23`; stage `leveque-chapter01-codex-20260908`. The earlier `shock-foundation` directory is frozen and was not modified by this continuation. All writes here are confined to `shock-continuation`. No production module, gate, audit metadata, lifecycle, Git state, or remote was changed.

The selected module profile was rehashed as `b140898932e6b43e2340459f2d7b4cfee42fddc18ef1ae307ed1c11e55b2d9ea`, and the pinned Mathlib checkout resolves to `e8ea1afc32790ce1d4e1a4e45cc412ba9388716b`.

## Construction

The scalar characteristic speed is the clipped identity `min 1 (max (-1) q)`. The flux is defined by integrating this continuous slope from zero to `q`, and its exact Huber formula is proved: `q²/2` on `|q|≤1`, and `|q|-1/2` outside. Defining the primitive first allows direct reuse of FTC to prove a genuine derivative at both clipping points. The flux is C1 and nonlinear. Convexity is obtained from the monotonicity of its actual derivative.

The state is `-x/(1-t)` in the central region `t<1-|x|`. Outside that region it is `t-x` for `x<0`, and `-t-x` for `x≥0`. Its initial value on the entire real line is exactly `-x`, an infinitely smooth profile. Before time one the central interval has positive width and the two interfaces have matching state values. At and after time one the central interval disappears and a stationary jump connects the left trace `t` to the right trace `-t`.

The interface value is the right trace `-t`. This choice is relevant: for a rectangle whose spatial edge is exactly the stationary shock, the boundary flux is integrated along that edge for a nonzero time interval. Either actual trace gives the same physical flux `t-1/2`; an unrelated representative such as zero would not. No invariance under arbitrary modifications along a stationary shock is asserted.

The potential is `(-x²/2)/(1-t)` in the central region and `-x²/2-t|x|+t/2-t²/2` outside. Its pieces match on the interface. It is continuous as a function of either variable separately. Its right spatial derivative equals the constructed state, and its right temporal derivative equals minus the actual composed Huber flux, including the chosen values at collapse and at the stationary interface. These identities are proved by calculus of the displayed functions, not by placing the desired balance in a structure or theorem premise.

Local integrability is established independently. In space, the state is a measurable piecewise combination of affine functions. In time, the central branch is extended continuously as `-x / max (1-t) |x|` before applying a measurable piecewise-integrability lemma. This extension agrees with the actual central branch where that branch is selected; it is only an integrability proof device. For `x=0` it is the zero function; for `x≠0` its denominator stays bounded away from zero by `|x|`.

The checked full conservation theorem uses Mathlib's FTC for right derivatives twice: the spatial integral of the state is a potential difference, and the temporal integral of the flux is the negative potential difference. Subtracting those two identities gives the complete oriented rectangle balance for arbitrary real spatial endpoints and real time endpoints. No positivity of the interval lengths or of the elapsed time is hidden in the statement.

## Admissibility and effective-domain limits

The construction uses a convex C1 flux, with characteristic speeds `+1` and `-1` on the two shock traces and stationary shock speed zero. The flux traces agree. The separate Oleinik inequality states that the flux graph between the traces lies below the horizontal shock chord. These are explicit local admissibility facts. The file does not claim a formal theorem equating them with a complete spacetime Kružkov test-function entropy inequality, nor a global entropy-solution uniqueness result.

The flux is not C2 at `q=±1`; the statement does not claim a C∞ flux. The initial state `-x` is smooth and locally integrable on the whole real line, but unbounded and not globally integrable. The source passage itself imposes no boundedness or compact-support requirement; whether this witness matches the intended source claim must nevertheless be checked independently. The state can have derivative jumps at the moving interfaces before collapse; its proved pre-collapse property is spatial continuity, not global C1 regularity for positive times.

The whole field is defined for all real times. In particular, its initial condition at zero is an actual equality, not merely an assumed trace or a certificate field. At time two the one-sided spatial limits are explicitly `+2` and `-2`, with a strict gap. Thus the asserted discontinuity is a jump across the interface and cannot be attributed solely to the selected value at one point. This is an actual discontinuous conserved field, distinct from the earlier no-classical-continuation prerequisite.

The conservation statement uses oriented rectangle balance. It does not silently assert that the literal classical time derivative in printed equation (1.10) exists at every endpoint-crossing/collapse time. The coordinator's source interpretation/adjudication for that issue remains separate.

## Reuse and rejected routes

`reuse-searches.txt` records the exact scoped searches and their exit codes. Searches for Huber/shock/Rankine–Hugoniot names found no matching existing mathematical implementation in the production roots or the searched Mathlib mathematics directories. Incidental author-name hits are not mathematical matches. This is scoped search evidence, not a theorem of global absence.

The direct reused mathematical producers include:

- `intervalIntegral.integral_hasDerivAt_right`, `integral_add_adjacent_intervals`, and `integral_id`, for the actual C1 Huber primitive and its explicit formulas;
- `contDiff_one_iff_deriv`, for C1 regularity from differentiability and a continuous derivative;
- `Monotone.convexOn_univ_of_deriv`, for convexity from the monotone clipped derivative;
- `ConvexOn.le_max_of_mem_Icc`, for the Oleinik chord inequality;
- `HasDerivWithinAt.union` and congruence lemmas, to glue derivatives with matching values and derivatives;
- `continuous_if_le`, `Continuous.if`, and `frontier_lt_subset_eq`, for continuity of the glued functions;
- `Integrable.piecewise`, for measurable piecewise integrability on finite intervals;
- `intervalIntegral.integral_eq_sub_of_hasDeriv_right`, for the actual state and flux integrals.

The generic right-threshold derivative, matching-derivative gluing, and piecewise interval-integrability helpers wrap these producers rather than re-prove calculus or integration foundations. New names were searched before drafting those helpers. Any production integration should place reusable helpers with an appropriate mathematical owner and retain only thin source wrappers.

The nonentropy three-jump Burgers bubble remains rejected, as recorded in the frozen earlier continuation review. The bounded inverse-branch profile was also not used: this Huber construction avoids an inverse-function foundation while retaining smooth whole-line initial data and a compressive stationary shock. No result about breakdown alone is used as a substitute for weak-shock existence.

## Verification and closure status

The first two checked increments are preserved as `flux-stage.lean` with `flux-second-elaboration.txt`, and `state-stage.lean` with `state-second-elaboration.txt`; both native Lean runs exited zero and printed only allowed axioms. Failed intermediate outputs remain separate and are not accepted verification evidence.

The complete `candidate.lean` passed the native command `lake env lean gates/leveque-finite-volume/artifacts/session-20260908/shock-continuation/candidate.lean` with exit code zero. `balance-fourth-elaboration.txt` records the successful output, and `balance-fourth-exit.json` records the actual native exit. All 47 public theorems resolve and print axiom dependencies limited to `propext`, `Classical.choice`, and `Quot.sound`; no warning, error, or `sorryAx` appears in that accepted output. The final conjunction `smooth_data_shock_example` includes the flux, initial data, pre-collapse spatial continuity, all finite-interval integrability requirements, the actual rectangle identity, and distinct one-sided traces at time two.

`freeze-verification.py` checks the native exit sidecar, exact theorem list, complete printed axiom output, and source hygiene, and writes the content hashes to `final-verification.json`. The earlier failed elaborations and scratch fragments remain separate diagnostic artifacts and are not accepted proof evidence. In particular, generic predicate-decider coercion failures were resolved by a set-based wrapper directly around `Integrable.piecewise`; the independent `piecewise-probe.lean` also checked that wrapper before its final use.

No source-faithfulness audit, production build, gate closure, or entropy uniqueness theorem is certified by this report. The coordinator must integrate the final candidate into the production hierarchy, rerun its required checks, and obtain the independent source audit before counting the Chapter 1 row.
