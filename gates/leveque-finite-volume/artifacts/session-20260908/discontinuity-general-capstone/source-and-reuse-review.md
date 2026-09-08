# General discontinuity comparison: scope and reuse

This scratch draft is a mathematical comparison on explicit domains, not an audit, a production declaration, or a source-faithfulness verdict. The existing frozen discontinuity audit remains unchanged. No interpretation adopted for equations (1.2)–(1.3) is extended to equation (1.10).

## Source read

The selected source is LeVeque, *Finite Volume Methods for Hyperbolic Problems* (2002), SHA-256 `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`. I actually viewed `page-026.png` and `page-027.png`: printed pages 4–5, raw PDF pages 26–27, one-based. The first page supplies vector states, nonlinear fluxes, the displayed mass derivative (1.10), and the sufficient-smoothness proviso. The second states that at a discontinuity the PDE does not hold classically while the integral conservation law continues to hold. Existing supplied image bytes and the pinned PDF are independently hashed in `input-provenance.json`; rendering was not repeated.

Those pages do not specify an almost-everywhere temporal convention or the exact rectangle predicate. The previously frozen audit identifies both the generality missing from its scalar example and the unresolved temporal interpretation. This draft addresses the former mathematically. It does not decide the latter.

## Exact checked domain and conclusions

`rectangleSolution_discontinuity_comparison` quantifies over any finite index type, vector field `q : ℝ → ℝ → ι → ℝ`, and flux `(ι → ℝ) → ι → ℝ`. It assumes the existing full rectangle solution predicate, including spatial integrability at every time and boundary-flux integrability, and actual noncontinuity of the spatial state section at the specified point. It concludes:

* For every fixed spatial interval, the classical mass derivative equals the flux difference almost everywhere in time.
* No spatial state derivative exists at that discontinuity; the state section is not differentiable there.
* No quasilinear classical solution predicate can hold there, for any proposed continuous-linear-map-valued flux derivative.

The time null set may depend on the interval. No interchange to a single null set for every real interval, everywhere-in-time mass derivative, distributional equivalence, or entropy assertion is made. No linearity, differentiability, or global continuity restriction is placed on the flux; the rectangle premise supplies the needed integrability of its compositions. The jump premise is actual noncontinuity, rather than an informal assertion that derivatives might fail. For an empty index type that premise cannot be met; the explicit `Fin 1` witness establishes nonvacuity in a genuine state space.

`not_conservationLawSolutionAt_of_flux_not_continuousAt` separately excludes the conservative residual only when the composed flux is noncontinuous. This matters: `IsConservationLawSolutionAt` requires derivatives of time-state and spatial-flux, not of spatial-state. The checked stationary constant-flux construction has a genuine discontinuity and rectangle conservation, yet satisfies that conservative residual at every point. Thus a blanket rejection of that residual from state discontinuity would be false. A conventional classical solution definition requiring a differentiable state, or the existing quasilinear predicate, avoids that overclaim.

The vector Riemann witness family has arbitrary distinct left/right states, arbitrary jump representative, and arbitrary speed. Its field is genuinely noncontinuous at `x = speed * t` at every time; conservation is produced from interval-integrable Riemann data, not assumed as a desired balance. `exists_discontinuous_rectangle_field` instantiates `Fin 1`, states zero/one, speed one, and time one. These witnesses instantiate a linear flux; the general comparison is independently quantified over arbitrary fluxes. No claim that every discontinuous field is conserved is made.

## Reuse decisions

Scoped project and pinned-Mathlib searches preceded the new proof steps; native search commands, stdout/stderr and exits are retained. Selected producers are:

| Existing producer | Use |
|---|---|
| `IsRectangleConservationLawSolution.hasDerivAt_mass_ae` | Entire arbitrary-flux finite-vector mass-rate conclusion; no duplicate LDT proof. |
| `HasDerivAt.continuousAt`, `DifferentiableAt.continuousAt` | Contrapositive state and flux regularity obstructions. |
| `ContinuousAt.comp` | Pull a translated jump's hypothetical continuity back to its initial profile. |
| `IsRiemannData.not_continuousAt_zero`, `riemannData_isRiemannData` | Actual unequal-trace discontinuity, independent of jump representative. |
| `riemannData_intervalIntegrable`, `travelingWave_isRectangleConservationLawSolution` | Construct vector jump conservation. |
| `hasDerivAt_const` | Stationary constant-flux residual counterexample. |
| `MovingStep.timeShiftedStep_no_classical_mass_derivative` | Checked existing diagnostic for failure of the everywhere mass-rate reading; not repackaged as a new general theorem. |

The existing fixed scalar MovingStep source target was rejected as the general capstone producer because of its restricted signature. The existing conservative residual was rejected as a universal state-discontinuity obstruction because its definition does not impose spatial-state differentiability. No search miss is treated as global absence. The first interactive project search also included an unsupported Windows path glob and reported an error; subsequent directory-scoped recorded searches corrected that path issue.

## Remaining interpretation choice

The concrete remaining temporal choice, for root to surface if necessary, is whether the Chapter 1 continuation of (1.10) at discontinuities is to be represented by full finite-rectangle conservation and its mass-rate identity almost everywhere for each fixed interval, with no assertion at every time, or whether a different temporal/trace convention must first be specified. The source statement's classical failure must also be tied to actual state regularity, not silently equated with the weaker existing conservative residual. A project convention would require explicit provenance; this report does not adopt one or ask the user on root's behalf.

## Verification record

Native Lake/Lean runs use the named `lean-computational-mathematics` checkout and pinned Lean `4.29.0-rc3`, runtime commit `5d86aa4032284a5242470e95fbe25f1ff506763d`; Mathlib revision `e8ea1afc32790ce1d4e1a4e45cc412ba9388716b`. Exact input/source/Mathlib hashes and the root's promoted temporal-derivative receipt are retained.

`failed-candidate-v1.lean` and `first-elaboration.*` retain the failed attempt: an inferred composition function and a partially applied traveling-wave simplification needed explicit arguments. `checked-candidate-v2-with-warnings.lean` and `second-elaboration.*` retain its exit-zero repair. The final draft removes an unnecessary finite-type assumption from the topological lemma and an unused stationary-time binder. `declaration-checks.lean` begins with the exact final candidate and appends seven authored declaration checks plus five existing-producer checks, each with an axiom query. Final exits, checked axiom sets and artifact hashes are recorded by `final-receipt.json`; no failed attempt is presented as successful.
