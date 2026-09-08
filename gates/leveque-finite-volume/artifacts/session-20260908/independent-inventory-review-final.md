# Independent Chapter 1 source inventory review

Date: 2026-09-08. Scope: source inventory and disposition review only. This is not a sealed statement-faithfulness audit, a Lean-target review, or a gate closure certificate.

## Evidence and independence

- Source: Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, printed publication 2002, selected PDF copyright 2004; `formalization-collaboration-v5.0.1/books/candidates/leveque-finite-volume/source/LeVeque_Finite_Volume_Methods_for_Hyperbolic_Problems_2002.pdf`.
- The actual PDF SHA-256 was checked with native `Get-FileHash`: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`.
- I viewed every render `workflow-v5.0.1-local/chapter01-source-review/page-023.png` through `page-033.png`, covering printed pages 1–11, and read the accompanying `chapter01.txt` as a navigation aid. Equations, signs, and page placement were checked on the renders.
- I read the Lean repository and collaboration-bundle `AGENTS.md`, the installed book-formalization skill, and the selected module's instructions, profile, source inventory, faithfulness, verification, and reporting policies. The module gate's allowed skip codes and skip-record requirements were inspected.
- The reviewed gate is `lean-computational-mathematics/gates/leveque-finite-volume/chapter-01.json`, schema 3, SHA-256 `58cb1a8b305034b2460ec04d496c8e932a5f0ad72edf5c1dc58ce36304cbc11e`. Its snapshot contains 54 unique source IDs. The same hash remained current immediately before this report was written.
- No `qualitative-claim-review.md`, proposed Lean candidate, or theorem-audit decision was read in forming these judgments. Gate row labels, statuses, dependency IDs, and next-action summaries were read for reconciliation. Existing closed-row classifications are reported only as gate data, never independently endorsed here.
- No source, module, profile, gate, metadata, audit-kit, Git state, or Lean file was edited. This report is the sole written output.
- The released `book_prompt.py` audit dispatch check ran through native Python 3.12 `-B workflow-v5.0.1-local/run_workflow_posix.py`, with this exact selected book, both control/collaboration roots set to `formalization-collaboration-v5.0.1`, the selected Lean repository, `--provider codex --task audit --chapter 1 --session-id independent-inventory-review-final-20260908 --check`. It exited 0 with `PASS prompt: codex/audit/leveque-finite-volume/1`. This validates dispatch, not chapter closure.
- A native PowerShell comparison of the reconciliation table against the parsed gate found 54 table rows, 54 unique table IDs, and no missing or extra gate IDs. The gate SHA-256 remained unchanged after the report was written.

The source inventory policy requires separate records for independent assertions and permits explicit handling of underspecified remarks. It does not permit excluding mathematics because the proof, framework, or a witness has not yet been built. A forward reference alone also does not justify a skip.

## Recommendations for the four unresolved rows

### NONCONSERVATION-SOURCE-TERMS — keep actionable

Locator: printed 4 / raw 26, paragraph immediately below (1.10), following the contaminant flux `f(q) = ubar q` example.

The source distinguishes transport through the endpoints from internal creation or destruction, with chemical reaction as an example. A specified reaction-rate formula is unnecessary for the necessity claim. The quantitative content is that internal production cannot be represented by the homogeneous endpoint-flux balance alone.

A precise contract is available. Let `a < b`, let `q(x,t)` have the spatial and temporal regularity needed to differentiate its interval integral and integrate its spatial derivative, and fix the constant transport velocity `u`. Write

`M(t) = integral_a^b q(x,t) dx`,

`B(t) = u*q(a,t) - u*q(b,t)`,

`P(t) = M'(t) - B(t)`.

At any time where these quantities are defined, if `P(t) != 0`, the homogeneous advection equation cannot hold throughout the interval. More precisely, for any integrable source field `s` satisfying the balance equation `q_t + u*q_x = s`, integration gives `integral_a^b s(x,t) dx = P(t) != 0`; hence `s` is not identically zero there. This is a genuine necessity result obtained from the balance calculation, without assuming the desired nonzero-source conclusion. The source field may remain arbitrary: no reaction kinetics are being attributed to Chapter 1.

Do not replace the premise by `M'(t) != 0`. Mass inside an interval may change through its boundary even for a homogeneous conservation law. Do not silently change the transported quantity or add a particular kinetic law. A net-production version is the minimal contract; a local PDE version needs the explicit calculus bridge just described. Recommended disposition: `READY`, with the balance-defect/integral-source bridge as the next foundation.

### SHOCKS-AND-NONLINEARITY — underspecified remark as written

Locator: printed 7 / raw 29, first paragraph of section 1.4. This is a statement about small-amplitude physical waves and the origin of shocks, in a chapter that has already allowed prescribed discontinuities for linear Riemann problems and now discusses discontinuous media.

Chapter 1 does not fix the quantifiers required to make the slogan a single theorem:

- whether “appear” means formation from initially smooth data or the presence of a discontinuity supplied in the data, boundary, or medium;
- whether “shock” means any jump, a compressive/Lax shock, an entropy-admissible discontinuity, or a physical nonlinear shock;
- the allowed coefficient class and its regularity (constant coefficients, smooth variable coefficients, or discontinuous material coefficients);
- the initial/boundary data class, solution concept, time interval, and regularity or no-jump conclusion.

These omissions change the truth conditions. The blanket replacement “every solution of a linear hyperbolic equation is continuous” conflicts with the linear Riemann data already discussed on printed 5. A theorem that initially smooth profiles remain smooth under a constant-coefficient eigenbasis evolution is precise and useful: each coordinate translates by its eigenvalue, and finite linear recombination preserves regularity. However, that is a specified subcase of the surrounding discussion, not by itself a resolution of the unrestricted physical slogan.

Recommended disposition: `SKIPPED`, reason code `underspecified`, explicitly recording the missing formation/shock/coefficient/solution quantifiers above. This is not a claim that smoothness preservation is difficult or unprovable. If later source material resolves the intended shock class, reopen the row or track an explicitly narrower theorem separately; do not report that narrower theorem as covering every reading of this sentence.

### TYPICAL-SECOND-ORDER-ACCURACY — underspecified remark

Locator: printed 7 / raw 29, second paragraph of section 1.4.

The source qualifies both the method class and the accuracy claim. It does not give an exact numerical update here, or specify:

- which methods, limiters, reconstructions, time integrators, or meshes are quantified over;
- whether the order is spatial, temporal, local truncation, or global solution error;
- the error norm, problem/data regularity, boundaries, final time, or relation between time step and mesh width;
- how “typically” is quantified, or whether the conclusion concerns a generic problem, every problem, or existence of a problem preventing higher order;
- the constants, mesh threshold, and lower-bound/non-improvability statement needed for “at best.”

In particular, an `O(h^2)` error upper bound does not establish that the order is at most two. Nor would proving the order of one chosen scheme establish the unspecified qualified method-class assertion.

Recommended disposition: `SKIPPED`, reason code `underspecified`, with the above missing quantifiers and error notion recorded. Preserve the source's computational motivation; do not invent a universal second-order barrier theorem.

### VARIABLE-COEFFICIENT-NONCONSERVATION — keep actionable

Locator: printed 8 / raw 30, start of the second paragraph. The claim is existential: variable coefficients do not guarantee conservation form. An existential claim does not need a named witness in the printed text.

A precise source-compatible contract is available using the density `q` and conservation form already introduced in (1.8). Choose the smooth real scalar coefficient `a(x) = 1 + x^2`. The scalar equation `q_t + a(x)*q_x = 0` is pointwise hyperbolic. There is no differentiable state-only flux `f(q)` whose spatial flux derivative equals `a(x)*q_x` for every smooth test field. Indeed, test affine profiles having value zero and derivative one at `x = 0` and `x = 1`: the alleged identity forces both `f'(0) = 1` and `f'(0) = 2`.

If the chosen contract allows a local flux `F(x,q)`, retain the same fixed density. Constant test profiles force `F_x(x,c) = 0` for every `x,c`; thus `F` is independent of `x`, reducing to the preceding contradiction. State the differentiability and global/local interval assumptions needed for this implication. This stronger version can eliminate an avoidable ambiguity about space-dependent fluxes.

The product rule also gives `d_x(a*q) = a*q_x + a'*q`. This demonstrates why the naive flux `a*q` fails, but failure of this particular flux alone is not a proof that no flux exists. Preserve that distinction in the final target.

Do not assert that the PDE admits no conservative reformulation after changing the density or multiplying the equation by an integrating factor. The source claim concerns whether the displayed equation is in conservation form; for nonvanishing `a`, changing to `q/a` is a different density. Recommended disposition: `READY`, with the fixed-density local-flux obstruction as the next foundation.

## Missing general scalar-wave decoupling object

Locator: printed 3 / raw 25, first paragraph, between the acoustic example and the eigenvalue speed assertion.

Add `LEV-CH01-HYPERBOLIC-SYSTEM-SCALAR-DECOUPLING` (suggested stable ID). The current vector-decomposition and eigenvalue-speed rows do not, under their recorded scopes, cover the separate differential-equation assertion.

The required normalized contract is: for a constant real matrix `A` with a real eigenbasis `r^p` and eigenvalues `lambda^p`, write `R` for the eigenbasis map. For an arbitrary field `q` with the required partial derivatives, set `w = R^{-1} q`. Then

`q_t + A*q_x = 0` if and only if, for every component `p`,

`w_t^p + lambda^p*w_x^p = 0`,

with reconstruction `q = sum_p w^p*r^p`.

Do not require distinct eigenvalues: the printed hyperbolicity definition requires a complete eigenbasis, and permits repeated eigenvalues. Require only the regularity needed for the partial derivatives and commutation with constant linear maps. The coordinate identity/equivalence concerns arbitrary admissible fields, not merely one preconstructed family of translated solutions.

`EIGENBASIS-UNIQUE-DECOMPOSITION` supplies algebraic coordinates at a point. `EIGENVALUES-WAVE-SPEEDS`, whose next action constructs speed-indexed eigenmode profiles, explains propagation for those modes. Neither recorded scope states that every solution of the coupled system decouples, or the converse reconstruction. They are dependencies of the new row, not replacements for it. The acoustic two-wave row is the distinct two-component example.

## Existing skip and scope issues

1. **FLUX-JACOBIAN-HYPERBOLICITY:** reopen for a source-contract decision. The word “suggests” alone does not make the displayed pointwise Jacobian criterion pure narrative. A definition/criterion on the admissible state domain is available from (1.9) and the preceding matrix definition: real eigenvalues and a complete real eigenbasis for the flux Jacobian at the relevant states. Resolve whether the contract is pointwise or on a stated state domain, and avoid upgrading it to well-posedness or strict hyperbolicity. The current narrative rationale does not establish a sound exclusion.
2. **NONLINEAR-SHOCK-FORMATION:** reopen as actionable, or explicitly defer to a tracked source-defined nonlinear-solution foundation. The sentence on printed 4–5 asserts the possibility of discontinuity formation from smooth data. Not naming a flux, datum, or time is not a sufficient skip reason for an existential assertion. A candidate contract must provide a nonlinear conservation law, smooth initial data, a positive finite time, and an actual jump/discontinuity in an admissible continuation. Merely proving gradient blow-up of a classical solution is insufficient. The solution/integral-law convention still needs source-grounded treatment, but acquiring it is foundation work; a missing witness is not an omitted quantifier.
3. **DISCONTINUITY-INTEGRAL-LAW:** do not regard the present skip as settled. The source makes the exact contrast with its own equations (1.8) and (1.10); absence of an implemented weak/trace framework is not itself a reason to omit it. Separate classical failure at a spatial jump from the integral-balance assertion. Resolve how (1.10) is interpreted when a moving jump meets an interval endpoint (pointwise time derivative, almost-everywhere statement, or time-integrated balance). If the literal statement cannot be reconciled, record the specific source discrepancy/ambiguity and its adjudication rather than silently replacing (1.10). This is an actionable source-contract issue, not a completed theorem claim.
4. **MATERIAL-INTERFACE-RIEMANN:** split the precise data construction from the unspecified reflection/transmission assertion. Printed 8 explicitly extends the initial configuration to a medium jump at `x = 0` as well as a state jump. Suggested added ID: `LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA`. Its left/right material-state pairs can be specified using arbitrary material and state spaces, with the value at zero left unspecified as in (1.11). This construction does not require choosing governing heterogeneous equations or a reflection coefficient. Keep the existing reflection/transmission claim `SKIPPED/underspecified` unless those governing equations, interface conditions, and wave/solver data are resolved. Do not let the unresolved wave dynamics hide the data definition.
5. **EQ-1.11-RIEMANN-DATA:** make its scope explicitly include the definition of the Riemann problem as a hyperbolic equation plus the specified two-state initial data, or add/link a definition row. The present next action only defines a piecewise function. The source definition is not limited to a constant matrix, despite the current dependency on the constant-matrix definition. Preserve the unspecified initial value at zero and do not infer that the two states must differ in every later use.
6. **Notation skips:** editorial treatment is reasonable for typography, but the reason “Lean already represents this” is not source evidence and was not independently checked here. Record coverage links for mathematical content: system dimension to (1.1), cell/time indexing to cell-average/update definitions, and eigenpair indexing to the eigenbasis definition. The separately present one-step-method row correctly captures the mathematical dependence statement from printed 10.

The other existing underspecified skips are defensible only for the actual unresolved claims recorded in their rows: the qualified general Riemann-wave description; nonlinear Riemann construction without a specified system/domain/admissibility/approximation contract; qualitative shock tracking/capturing behavior; multidimensional normal-flux methods without their governing multidimensional problem; and the wave-propagation/flux-differencing correspondence without operators or applicability hypotheses. A missing implementation or a later-chapter citation must not be the operative reason.

## Reconciliation of all 54 current IDs

In this table, the common prefix is written in full for unambiguous machine retrieval. “Keep actionable” endorses inventory inclusion, not any unread Lean target. “Closed in gate” reports a stored status only. Page is printed/raw. Cross-page source spans are noted even where the gate stores only the first page.

| Source ID | Page | Current status | Independent source reconciliation |
|---|---:|---|---|
| LEV-CH01-EQ-1.1-CONSTANT-LINEAR-SYSTEM | 1/23 | READY | Keep actionable: real constant system, dimension and field domain are part of the definition. |
| LEV-CH01-SCALAR-HYPERBOLICITY | 1/23 | REUSED | Closed in gate; distinct scalar specialization is present in source. |
| LEV-CH01-EQ-1.2-ADVECTION | 1/23 | READY | Keep actionable: constant scalar transport equation/model. |
| LEV-CH01-EQ-1.3-ADVECTED-PROFILE | 1/23 | PROVED | Closed in gate; translation and unchanged profile are present. Classical/weak regularity remains an audit concern, not reviewed here. |
| LEV-CH01-EQ-1.4-ONE-WAY-WAVE | 2/24 | READY | Keep actionable; positive `c` gives the right-going interpretation. |
| LEV-CH01-ADVECTION-WAVE-IDENTITY | 2/24 | READY | Keep actionable; equation renaming is explicitly asserted. |
| LEV-CH01-EQ-1.5-LINEAR-ACOUSTICS | 2/24 | READY | Keep actionable; the two equations form one system. |
| LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX | 2/24 | READY | Keep actionable; state/matrix representation and component equivalence. |
| LEV-CH01-ACOUSTICS-RIGHT-MODE | 2/24 | READY | Keep actionable; preserve `p + rho*c*u`, speed sign and material assumptions. |
| LEV-CH01-ACOUSTICS-LEFT-MODE | 2/24 | READY | Keep actionable; preserve minus sign. Printed `q^2` versus preceding `w^2` requires explicit notation adjudication. |
| LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION | 3/25 | READY | Keep actionable; reconstruction/invertibility is additional to the two one-way implications. |
| LEV-CH01-HYPERBOLIC-MATRIX-DEFINITION | 3/25 | REUSED | Closed in gate; real spectrum plus complete real eigenbasis, not necessarily distinct eigenvalues. |
| LEV-CH01-EIGENBASIS-UNIQUE-DECOMPOSITION | 3/25 | REUSED | Closed in gate; algebraic uniqueness is present and distinct from PDE decoupling. |
| LEV-CH01-EIGENVALUES-WAVE-SPEEDS | 3/25 | READY | Keep actionable; speed identification does not by itself cover arbitrary-solution decoupling. |
| LEV-CH01-ACOUSTICS-EIGENVALUES | 3/25 | READY | Keep actionable; the exact `-c,+c` acoustic instance is present. |
| LEV-CH01-EQ-1.7-WAVE-EQUATION | 3/25 | READY | Keep actionable; differentiated acoustic system gives `p_tt = c^2 p_xx`. |
| LEV-CH01-EQ-1.8-CONSERVATION-LAW | 3/25 | READY | Keep actionable; derivative is of the composed flux `f(q)`. |
| LEV-CH01-EQ-1.9-QUASILINEAR-FORM | 3/25 | READY | Keep actionable; chain-rule rewriting, with explicit regularity. |
| LEV-CH01-FLUX-JACOBIAN-HYPERBOLICITY | 3/25 | SKIPPED | Reopen source-contract decision; “suggests” does not alone justify narrative exclusion. |
| LEV-CH01-LINEAR-FLUX-SPECIALIZATION | 3–4/25–26 | READY | Keep actionable; statement starts on printed 3 and completes on 4. |
| LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION | 4/26 | READY | Keep actionable; arbitrary endpoints and incoming-minus-outgoing sign. |
| LEV-CH01-ADVECTION-LINEAR-FLUX | 4/26 | READY | Keep actionable; explicit `ubar*q` specialization and balance interpretation. |
| LEV-CH01-ACOUSTICS-CONSERVATION-CAVEAT | 4/26 | SKIPPED | Keep empirical qualification separate from exact conservation-form row. |
| LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH | 4/26 | READY | Keep actionable; source explicitly supplies the smoothness qualification. |
| LEV-CH01-NONLINEAR-SHOCK-FORMATION | 4–5/26–27 | SKIPPED | Reopen; existential possibility is not underspecified merely because witnesses are unnamed. |
| LEV-CH01-DISCONTINUITY-INTEGRAL-LAW | 5/27 | SKIPPED | Reopen source/trace interpretation; distinguish failure of classical PDE from integral validity. |
| LEV-CH01-FINITE-VOLUME-CELL-AVERAGE | 5/27 | READY | Keep actionable; cell integral divided by volume is a precise definition. |
| LEV-CH01-FINITE-VOLUME-FLUX-UPDATE | 5/27 | READY | Keep actionable; generic conservative update is supported. Do not attribute a specific flux solver/order to this passage. |
| LEV-CH01-EQ-1.11-RIEMANN-DATA | 5/27 | READY | Keep actionable; expand coverage to PDE-plus-data definition or link a separate definition row. |
| LEV-CH01-RIEMANN-INTERFACE-FLUX | 5/27 | READY | Keep actionable; adjacent averages as left/right states, with correct indexing. |
| LEV-CH01-RIEMANN-SIMILARITY-WAVES | 5/27 | SKIPPED | Qualified general claim may remain underspecified; do not silently impose a universal nonlinear wave theorem. |
| LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION | 5–6/27–28 | READY | Keep actionable; specific linear eigendata construction must cover jump data, not only smooth eigenmodes. |
| LEV-CH01-NONLINEAR-RIEMANN-CONSTRUCTION | 6/28 | SKIPPED | Broad exact/approximate nonlinear claim lacks system/domain/solution/error contract; not skipped merely because proof is later. |
| LEV-CH01-SHOCK-TRACKING | 6/28 | SKIPPED | Method-family description; no specified front update or mathematical guarantee. |
| LEV-CH01-SHOCK-CAPTURING | 6/28 | SKIPPED | Qualitative smearing/oscillation goals, not a quantified scheme guarantee. |
| LEV-CH01-MULTIDIMENSIONAL-NORMAL-RIEMANN-FLUX | 6/28 | SKIPPED | Pattern lacks a governing multidimensional flux/mesh/normal problem contract. |
| LEV-CH01-DIMENSIONAL-SPLITTING | 6–7/28–29 | READY | Keep actionable as composition of coordinate solves; no fixed integrator, sweep ordering, or accuracy theorem is printed. |
| LEV-CH01-HETEROGENEOUS-CELL-AVERAGING | 8/30 | READY | Keep actionable as parameter-volume averaging; avoid asserting a unique physical homogenization rule. |
| LEV-CH01-MATERIAL-INTERFACE-RIEMANN | 8/30 | SKIPPED | Split off explicit two-sided medium/state data; wave/reflection/transmission claim remains underspecified. |
| LEV-CH01-WAVE-PROPAGATION-FRAMEWORK | 8/30 | SKIPPED | Correspondence lacks update/fluctuation operators and applicability hypotheses. |
| LEV-CH01-NOTATION-SOLUTION-VELOCITY | 10/32 | SKIPPED | Editorial role convention; no independent dynamics theorem. |
| LEV-CH01-NOTATION-NUMERICAL-APPROXIMATION | 10/32 | SKIPPED | Editorial indices; link mathematical data shape to finite-volume objects. |
| LEV-CH01-NOTATION-VECTOR-COMPONENTS | 11/33 | SKIPPED | Editorial projection notation; explicitly link dimension content to system/cell-average definitions. |
| LEV-CH01-NOTATION-EIGENPAIR-INDEX | 11/33 | SKIPPED | Editorial indexing; link real finite eigenfamily meaning to hyperbolicity object. |
| LEV-CH01-NOTATION-INITIAL-DATA | 11/33 | SKIPPED | Circle accent is editorial. |
| LEV-CH01-NOTATION-OVERLOADED-SYMBOLS | 11/33 | SKIPPED | Editorial warning, no independent mathematical claim. |
| LEV-CH01-RIEMANN-RAY-ZERO-VALUE | 11/33 | READY | Keep actionable; value of selected similarity solution at ray zero, with any trace choice explicit. |
| LEV-CH01-ACOUSTICS-CONSERVATION-FORM | 4/26 | READY | Keep actionable; exact algebraic statement properly separated from physical caveat. |
| LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY | 3/25 | READY | Keep actionable; second-order principal-part classification is separately asserted. |
| LEV-CH01-ONE-STEP-METHOD-DEFINITION | 10/32 | READY | Keep actionable; current-state-to-next-state dependence is separate from notation. |
| LEV-CH01-NONCONSERVATION-SOURCE-TERMS | 4/26 | UNCLASSIFIED | Recommend READY; net internal-production necessity contract above. |
| LEV-CH01-SHOCKS-AND-NONLINEARITY | 7/29 | UNCLASSIFIED | Recommend SKIPPED/underspecified; formation, shock, coefficient and solution quantifiers unresolved. |
| LEV-CH01-TYPICAL-SECOND-ORDER-ACCURACY | 7/29 | UNCLASSIFIED | Recommend SKIPPED/underspecified; class/order/norm/typical quantifiers unresolved. |
| LEV-CH01-VARIABLE-COEFFICIENT-NONCONSERVATION | 8/30 | UNCLASSIFIED | Recommend READY; existential fixed-density flux obstruction above. |

## Complete-page sweep and omitted-exposition judgments

| Printed/raw page | Current rows located there | Other content and coverage finding |
|---|---:|---|
| 1/23 | 4 | Opening applications/advective-transport motivation and physical wave description introduce no additional quantitative model beyond the inventoried equations. No exercise, figure, or table. |
| 2/24 | 6 | Physical material interpretation and speed-of-sound narrative are attached to acoustic equations/modes; no separate material-motion error bound is stated. |
| 3/25 | 10 | General scalar-wave decoupling is missing and must be added. Gas advection/acoustic coupling leading to nonlinearity is physical motivation without a specified equation of state or coupled system; record that judgment here rather than inventing one. |
| 4/26 | 8 | Internal source necessity is retained above. Euler mass/momentum/energy and historical discussion refer to future derivations without writing an Euler system; no extra Chapter 1 Euler formula is inferred. |
| 5/27 | 7 | Nonlinear shock sentence continues from 4. Finite-difference breakdown/effectiveness comparisons and mentions of alternative methods are qualitative; no error or stability estimate is given. Riemann problem definition must be fully represented. |
| 6/28 | 5 | Linear Riemann sentence continues from 5. Exact-solver cost, complicated fronts, and relative implementation performance are qualitative. PDE validity away from jumps links to the smooth integral-to-differential row; do not count the repeated principle again. |
| 7/29 | 2 | Splitting paragraph continues from 6. Sinusoidal acoustic/optical approximations, the Maxwell example, large-domain cost, and material-interface examples are modeling/empirical exposition; the page gives neither a Maxwell system for classification nor quantified spectral/error/cost results. Two unresolved quantitative-looking remarks are assessed above. |
| 8/30 | 4 | Add precise joint medium/state Riemann data coverage. The remaining chapter-reading guidance and CLAWPACK introduction are organizational/software exposition. |
| 9/31 | 0 | CLAWPACK paths/download instructions and references only. No mathematical construction, numerical data, exercise, figure, or table requiring a new denominator object. |
| 10/32 | 3 | Bibliographical commentary plus notation. One-step dependence already has its own row. |
| 11/33 | 5 | Notation and ray-zero Riemann value; no additional unnumbered theorem or exercise. |

The displayed equations (1.1)–(1.11) are all represented. The unnumbered right/left acoustic transformations are represented. There are no exercises, figures, or numerical tables anywhere in this Chapter 1 range. No duplicate source ID was found. The apparent overlapping rows for generic versus acoustic decompositions, generic versus scalar fluxes, and notation versus one-step dependence express separate instances or claims; their audits should use explicit reuse links rather than count a repeated mathematical producer as newly proved twice.

## Quantitative status and limits

For the exact reviewed gate bytes: `54 = 1 PROVED + 3 REUSED + 29 READY + 4 UNCLASSIFIED + 17 SKIPPED`. Thus the stored formalized numerator is 4, actionable remaining is 33, skipped is 17, deferred is 0, and hard/dependency blocked is 0; `4/54 * 100 = 7.407407...%`. These are a direct projection of the snapshot rows, not an independent validation of proofs/audit receipts. The declared gate verdict is `ACTIVE`.

This report does not certify `PASS`, and it does not certify inventory closure: at least the general decoupling object and explicit material/state interface-data construction need separate coverage, while three existing skips require reopening or adjudication as detailed above. Adding the two proposed objects would make 56 source records before any separately chosen split of the Riemann-problem definition; do not change the denominator until the coordinator records those decisions. No modified-gate percentage is asserted here.

Next concrete work: classify the two necessity/obstruction rows as actionable; record the exact two underspecified remarks; add the general decoupling row; split material-interface data from dynamics; resolve the three flagged existing skips and the Riemann-problem-definition scope; then run source-coverage and gate verification on the resulting exact inventory. No classification in this report certifies an unread Lean theorem as faithful.
