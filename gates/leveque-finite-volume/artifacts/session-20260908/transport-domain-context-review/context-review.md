# Contextual profile-domain review

This is an informed, bounded contextual analysis, not a blind role, source audit, or acceptance decision. The new Chapter 2 passage settles the presence of a classical regularity qualification. It does **not**, by itself, settle the exhaustive nonsmooth profile class behind Chapter 1's phrase “for any function”.

## Source and actual views

Source: Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems* (2002), pinned PDF SHA-256 `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`. Raw pages below are one-based. Every listed PNG was actually viewed. Full absolute paths, individual hashes, and byte sizes are in `input-provenance.json`.

| Printed / raw | Exact locator | Viewed image | Relevant evidence |
|---|---|---|---|
| 1 / 23 | Chapter 1, equations (1.2)–(1.3), paragraph following (1.3) | `page-023.png` | Translated profile for any function; unchanged shape and constant propagation speed. |
| 4–5 / 26–27 | Section 1.1.2, (1.10), smoothness and discontinuities; (1.11) | `page-026.png`, `page-027.png` | The differential derivation requires sufficient smoothness; discontinuities are also relevant and require integral conservation. |
| 15–16 / 37–38 | Chapter 2 opening, tracer mass (2.1), flux and integral law (2.2)–(2.7) | `domain-context-037.png`, `domain-context-038.png` | Spatial integrals represent mass. These pages provide physical and integral context, without a complete analytic profile class. |
| 17 / 39 | Before (2.8), through (2.12), last paragraph | `domain-context-039.png` | Explicit sufficient-smoothness assumption for transforming the integral equation into a PDE; advection discussion starts “Any smooth function of the”. |
| 18 / 40 | Section 2.1, sentence continuing across page break, (2.13)–(2.15) | `domain-context-040.png` | The translated smooth function satisfies (2.12); a converse is stated. Characteristic constancy follows using the classical chain rule (2.14). Whole-line initial data determine the translated field for later times. |
| 215–216 / 237–238 | Section 11.11, (11.30)–(11.33), Definition 11.1, following rectangle discussion | `weak-context-237.png`, `weak-context-238.png` | Test-function weak formulation and claimed relation to integral conservation. No complete admissible initial-profile class is specified in these viewed passages. |

The existing renderings were supplied by the coordinator and inspected directly; this task did not rerender the PDF or independently reproduce their renderer command. It recomputed the PDF and image hashes. Navigation text supplied search locations only.

## What the new context resolves

The smoothness qualification spans printed pages 17–18: neither page should be supplied alone. It concerns the same translated formula and constant-speed scalar PDE as (1.3). It gives direct source support for distinguishing an unconditional geometric translation identity from a classical PDE conclusion with actual derivatives. The source also derives characteristic constancy through a chain rule. Our arbitrary-profile characteristic derivative is mathematically valid because that particular composition is constant; it does not assert partial derivatives at a jump.

The passage does not say that every Chapter 1 profile is smooth, and the discontinuous solutions on pages 4–5 prevent that from being a justified blanket reading. Nor does it identify all nonsmooth admissible data as locally Lebesgue-integrable, specify the temporal sense of the mass law at every time, or equate the finite-rectangle predicate with the entire intended weak solution class. Its classical converse therefore cannot silently resolve the residual nonsmooth question. The prose word “smooth” also is not an explicit definition of either Lean `Differentiable` or `ContDiff` here.

The frozen fresh-context audit remains `undetermined`, accepted false. Its measure, operator, nonvacuity, geometry and derivative distinctions were resolved; its remaining issue was completeness of the intended admissible analytic domain. The present observation addresses the classical part more directly but supplies no new exhaustive nonsmooth class. No new verdict follows from this report.

## Concrete minimal route

First, retain the original (1.3) anchor and all unconditional geometry. Add printed 17–18/raw 39–40 as explicit classical context to a future packet. Do not substitute (2.13) as a narrower replacement anchor for the whole original claim.

Second, a separate clarified contract can replace its two sufficient-domain implications by the existing equivalences:

* `NumStability.travelingWave_isLinearAdvectionSolution_iff`: the translated field satisfies the chosen global classical predicate **iff** its profile is differentiable everywhere.
* `NumStability.travelingWave_isRectangleConservationLawSolution_iff`: the translated field satisfies the full rectangle predicate, including integrability, **iff** the profile is interval-integrable on every bounded interval with respect to `volume`.

These producers already exist under `Transport/Characteristics.lean` and `ConservationLaws/TravelingWaveCharacterization.lean`. They were read, not recompiled in this read-only task. The current source wrapper only uses their sufficient directions. Exposing both directions is a substantive strengthening: the chosen analytic domains become necessary and sufficient, rather than possibly arbitrary sufficient restrictions. It preserves the arbitrary-profile geometry and existing conclusion coverage. It still proves completeness for the **selected Lean predicates**, not that the source intended exactly those predicates. No duplicated calculus proof is needed. `isUniformAdvection_iff_eq_travelingWave` separately characterizes the geometric notion, but cannot establish this missing analytic interpretation either.

If source-equivalent closure of the combined original row still depends on an exhaustive nonsmooth reading, the material choice is:

> Should the project explicitly adopt the convention that (1.3)'s arbitrary-profile claim is geometric for every real profile, classical on the exact differentiability domain, and an integral conservation statement on the exact local Lebesgue-integrability domain using the finite-rectangle notion; or should the original analytic-scope equivalence remain unresolved while those precise statements are separately recorded?

That is an interpretation decision with provenance, not permission to relabel a theorem or manufacture acceptance. Adopting the convention would make the chosen reading explicit; declining it would leave an honest unresolved source question. This task neither asks the user directly nor changes that choice.

## Search and execution limits

`search-runs.json` records exact native `rg` argument vectors, working directory, raw stdout/stderr and actual exits. Searches for `any smooth function` and `any function|arbitrary function` returned the identified passage and several unrelated navigation candidates. Exact searches for local-integrability and bounded-measurability phrases returned exit 1. These lexical misses are not exhaustive semantic absence; unviewed hits elsewhere are not used as source facts. A scoped library search found the three existing characterizations above. No new proof prerequisite or Mathlib implementation was needed.

The collector exited 0 and verified the pinned PDF hash. No Lean command, new theorem, audit role, production edit, existing evidence edit, gate operation or Git mutation was performed. `final-receipt.json` binds this report and all additive evidence. This bounded analysis does not claim a full-book admissibility search or a general classical/weak equivalence theorem.
