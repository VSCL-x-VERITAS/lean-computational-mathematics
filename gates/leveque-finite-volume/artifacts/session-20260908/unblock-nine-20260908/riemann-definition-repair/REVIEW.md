# Q9 and Q6 additive interpretation refinements

Both completed audits identify a comparison-domain question. Their disputed Lean definitions have supplied, definite meanings. Neither finding is resolved by pretending that a native declaration supplement supplies a missing source convention. The recommended remedy is a new task with the unchanged target, original source, original selection receipt, and the relevant separately identified refinement. This review does not accept either source row or change a prior judgment.

The original receipt remains `selected-interpretations.json`, SHA256 `cfde240a9dda9a58be99f85369b43e99003b0024c7147a33ffa8b071ca7dcf34`. Its authority is the coordinator's selections under the user's goal to unblock all nine rows. The detailed addenda are coordinator selections, not literal detailed answers from the user and not assertions printed in the book.

## Q9: declared first-order governing-law data

The prior final decision `c8d7f8191a30ba12edc3bc15b74e73a62df4cb6e3880ee9690d229fb75078930` is undetermined. Its remaining issue is the relation of the declared state set, global coefficient domain, and permitted forcing to the selected equation class. The principal matrix, actual residual, hyperbolicity and initial-data predicates are visible in the dossier. Capturing their definitions again would not answer that comparison question.

The new addendum `interpretation-refinement.json` has SHA256 `8e24fcad8fc5b8462b243ead716a46b2613360966bbf4d03451056d8731d6f21`. It makes the selected law the triple `(Omega, A, b)`, on one real spatial and one real temporal coordinate, in a positive finite dimension. Omega is part of the law's identity. Hyperbolicity is imposed at every real x,t and each state in Omega. The stored coefficient and forcing functions are total; arbitrary forcing is permitted. The selected family does not assert that the source explicitly enumerates this entire equation class.

| Model clause | Actual target dependency |
| --- | --- |
| Declared state domain and the two coefficient functions are governing data | `FirstOrderEquation` and its `admissibleStates`, `principal`, `forcing` projections; dossier D002-D004, D013 and D018 |
| The principal matrix is the one in the actual equation | `FirstOrderEquation.residual`; D005 is `qt + A.mulVec qx - forcing`; the wrapper displays its zero-residual equivalence |
| Global spectral test on the declared state domain | `FirstOrderEquation.IsHyperbolic`, D001; quantifiers range over every real x,t and every state in Omega |
| Positive finite real state dimension | Wrapper parameter `Fin (m + 1)` |
| Governing law plus independently supplied initial function | `FirstOrderInitialValueProblem`, D006 |
| Hyperbolicity, admissible side states and two strict half-lines | `IsRiemannWithStates`, D009; `IsRiemann`, D008; `IsRiemannData`, D016 |
| Free origin and equal/distinct side-state branches | `riemannData`, D017; `fromStates` and its constructor theorems; `IsJumpRiemann`, D007 |

The canonical definition owners are `Analysis/PartialDifferentialEquations/FirstOrderEquation.lean` and `Analysis/PartialDifferentialEquations/InitialValue/FirstOrderRiemann.lean` under `ComputationalMathematics`. The unchanged source target is `NumStability.leveque01_riemannProblemDataClassification` in `ComputationalMathematics/Source/LeVeque/Chapter01/RiemannProblemDataClassification.lean`, SHA256 `1c9647b69667c8b60e21165121352a5096e680d2cf6bb8a1b4fcdcb6b77a577c`.

The state-domain comparison is addressed by identifying different declared Omega values as different governing-law data, even when the stored A,b functions agree. Empty Omega is allowed as candidate data but cannot classify a Riemann problem because both side states must be members. The origin is deliberately unconstrained, including membership in Omega; the definition tests only strict half-lines. The total residual identity is algebraic and is not an assertion of solutionhood outside Omega. No existence, classical/weak framework, regularity, entropy, self-similarity or approximation theorem is added.

This precisely states the intended model instead of claiming a universal correspondence for every possible hyperbolic equation. The source's incomplete specification of equation class, domain and forcing, and the equal-state ambiguity, remain listed in the addendum. A fresh independent audit may still find a mismatch. No target change or new proof is recommended before that audit.

## Q6: fixed representatives and exact iterated balance domain

The prior final decision `ba8a6782c2a7871123d788343252b34821a3d60a3f6621bc5705657b7779fd7a` is undetermined. The mathematical mass-defect identity and its conditional consequences are not refuted. The phrase locally integrable densities did not specify the exact representative-sensitive domain already required by the target.

The separate addendum `q6-interpretation-refinement.json` has SHA256 `8658feb83ed55f4c7a4a5c64a95c45313814c44b62573372ea716b5c791e97f3`. It selects pointwise q and production in one real spatial and temporal coordinate, with scalar values represented by `Fin 1 -> Real`, constant supplied advective speed, ordinary one-dimensional Lebesgue volume and oriented finite interval integrals.

The selected analytic domain is exactly D001, `NumStability.IsRectangleBalanceLawSolution`, in `ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaws/RectangleBalance.lean`:

1. For every a,b,t, the spatial mass slice `x -> q x t` is interval integrable.
2. For every x,s,t, the actual boundary-flux trace `tau -> speed * q x tau` is interval integrable.
3. For every a,b,t, the spatial production slice `x -> production x t` is interval integrable, including exceptional times.
4. For every a,b,s,t, the signed spatial aggregate `tau -> integral(a..b, production x tau)` is interval integrable in time.
5. For every a,b,s,t, the actual mass difference is boundary exchange plus that iterated production integral.

The fourth condition does not replace its signed spatial aggregate by the spatial integral of the absolute production density. The four conditions are not silently replaced by joint spacetime local integrability, or by equivalence classes modulo spacetime-null sets. They use the actual supplied representatives. A production representative can agree spacetime-almost-everywhere with zero and still fail the every-time spatial condition; this is an effective-domain distinction, not a counterexample to the conditional target identities. The addendum makes no theorem-strengthening or equivalence claim between these domains.

| Target conclusion | Existing producer |
| --- | --- |
| Integrated production equals mass difference minus boundary exchange | `IsRectangleBalanceLawSolution.integrated_source_eq_mass_defect` |
| Homogeneous rectangle conservation iff all integrated production rectangles vanish | `IsRectangleBalanceLawSolution.conservation_iff_source_integrals_zero` |
| Failure of homogeneous conservation iff some integrated production rectangle is nonzero | `IsRectangleBalanceLawSolution.not_conservation_iff_exists_nonzero_source_integral` |
| For each fixed a,b, mass-rate identity for almost every t | `IsRectangleBalanceLawSolution.hasDerivAt_mass_ae` in `RectangleBalanceTemporalDerivative.lean` |

The unchanged target is `NumStability.leveque01_sourceTermsRectangleBalance` in `ComputationalMathematics/Source/LeVeque/Chapter01/SourceTermsRectangleBalance.lean`, SHA256 `abe9b14705618401012fe913719eaee6e8c2d09b9db3cbd2ded4ad1b1101e1ac`. It explicitly assumes the sourced rectangle balance. It does not produce a source for every arbitrary nonconserving field. Nonzero production means a nonzero rectangle integral after boundary exchange, not an isolated nonzero point. The a.e. exceptional set can depend on the spatial interval. Singular production measures, spatial differentiability requirements, positivity and global integrability remain outside the selected contract.

The original printed contaminant discussion, raw page 26/printed page 4, supplies the source-term motivation. It does not state these analytic details. The additive convention must remain explicitly distinguished from that source. The existing actual measure evidence can continue to supply native meanings; no new measure or topology capture is recommended for this interpretation issue.

## Fresh-audit integration and verification boundary

Root owns additive preparation/binding changes. The intended fresh interpretation packet has `interpretation_refinement_ref = {path, sha256}` and `interpretation_refinement = <exact addendum JSON>`, with the addendum also hash-bound in the fresh configured environment. An accepted structured contract must retain original selection, relevant refinement hash, selected_model clauses and preserved source ambiguities. The two addenda are separate and do not alter the other original choices or earlier explicitly adopted receipts.

Source extraction sees the selected source only. Blind translation sees the exact new masked target packet only. Judging receives the separately labeled interpretation through the sealed role protocol. Old task and decision references in the addenda are provenance only; do not inline old judgments or prescribe an outcome. Interpretation text must not be disguised as a `proof-free-lean-environment-evidence-1` native dependency packet.

`verify-refinements.py` checks both packet schemas, exact original choices, every path/hash binding in the packets and minimal receipts, the unchanged source/targets and added canonical evidence owners. It freezes a read-only evidence manifest and final receipt. These are integrity checks, not semantic-role validation. No new Lean check was run because neither target nor mathematical definition was changed. All writes for this task are confined to this new repair directory; no production, audit, gate, ledger, Git or runtime mutation is authorized or performed here.
