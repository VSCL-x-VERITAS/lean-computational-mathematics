# Vershynin HDP Chapter 1 coverage

Authoritative source: first-edition Chapter 1 PDF, SHA-256
`855fdaf6870f664f1e470d47641b6d72758afdb9b87649a6494b027cecc02b17`.
Book profile SHA-256:
`b366ee13ce5c1890555f7dda961eda9c2bf9ce6e8ef71de6a17c3f5585196cab`.

The exhaustive machine-readable denominator is [`gates/ch01.json`](../../architecture/reviews/2026-09-faithfulness-outcomes.md).
It contains 49 source rows under gate schema 2:

- 33 `PROVED`: the moment generating function, `L^p` norm, `L^p` space,
  `L^p` Banach-space assertion, the `0 < p < 1` triangle counterexample, and
  Equations (1.1) and (1.2), the standard-deviation identity, and the convexity
  definition, plus the Section 1.2 Cauchy--Schwarz and Hölder inequalities,
  Equation (1.4), uniqueness of a real law from its CDF, the CDF definition,
  the strict-tail/CDF identity, Lemma 1.2.1's layer-cake identity and its
  pointwise, indicator-expectation, and Tonelli/Fubini proof layers, plus the
  pointwise decomposition used in Markov's inequality, and Exercise 1.2.3's
  p-moment tail formula, the finite independent-sum variance identity,
  Equation (1.5)'s sample-mean variance identity, the corresponding
  variance-to-zero limit, Corollary 1.2.5's Chebyshev bound, Exercise 1.2.6's
  explicit squaring/Markov derivation, Equation (1.6)'s standard-normal
  density, Theorem 1.3.1's strong law, and the normalized-sum construction
  and two-form identity used in Theorem 1.3.2, plus Equation (1.8)'s exact
  Poisson singleton-mass formula and the standalone Bernoulli- and
  binomial-law definitions.
- 1 `REUSED`: Proposition 1.2.4, Markov's inequality.
- 3 `DISCREPANCY`: the unrestricted positive-real raw-moment definition,
  Equation (1.3)'s undefined zero endpoint, and Exercise 1.2.2's unrestricted
  signed-tail formula each have verified evidence and a separately named
  corrected result.
- 6 `READY`: each row records attempted routes and its smallest next foundation.
- 2 `HARD_BLOCKED`: expectation/variance and Jensen exceptional-domain
  semantics need typed material policy choices.
- 1 `DEFERRED`: Remark 1.2.7, tracked to Chapter 2 Proposition 2.5.2.
- 3 `SKIPPED`: the chapter introduction, Remark 1.1.1's unquantified
  qualitative interpretation, and bibliographic/historical notes.

No row remains `UNCLASSIFIED`. The chapter verdict is `ACTIVE`, not `PASS`.
Gate-derived progress is 37 formalized objects and 8 remaining objects out of a
denominator of 45, or 82.22%; the three skipped and one deferred
rows are reported separately and excluded from that denominator.

## Accepted Bernoulli-law increment

`NumStability.HDP.Contract.hdp_01_hdef_hbernoulli` exposes the canonical
Bernoulli law for the printed domain `0 < p < 1`: mass `p` at `1`, mass
`1-p` at `0`, zero mass elsewhere, mean `p`, and centered second moment
`p(1-p)`.

- source contract SHA-256:
  `c0d0b5e0045f6caf586a6a8c57a02097ec816530741347a7b2268da51cf7952a`;
- decision SHA-256:
  `356b3f138ec910aaa0e42340cd8c38e2fb7abb98c9c445a7649872a2436ac9c0`;
- classification: `faithful-equivalent`;
- implications: Lean→source `yes`, source→Lean `yes`;
- adjudication: not required.

The first audit epoch exposed an endpoint-domain mismatch in the source-facing
wrapper. The wrapper was tightened and rebuilt before a fresh audit epoch;
both final judges accepted the strict parameter bounds, the shared Boolean
origin of the natural and real pushforwards, and the separation of the
one-variable law from the surrounding iid-sequence context.

## Accepted binomial-law increment

`NumStability.HDP.Contract.hdp_01_hdef_hbinomial` states that, for
`0 < p < 1` and positive `N`, the success-count pushforward of the canonical
`Fin N → Bool` Bernoulli product PMF is exactly the natural-valued
`Binom(N,p)` PMF.

- source contract SHA-256:
  `0cb9623c3ffa7a2ba0947a9c3b934c41e1cf503b408b3b240255ac5db55ff335`;
- decision SHA-256:
  `c0cd8ed438cfdff7af7540b271c04bd62707285b1974c103bbbdc17f83a5e8dc`;
- classification: `faithful-equivalent`;
- implications: Lean→source `yes`, source→Lean `yes`;
- adjudication: not required.

Both judges verified that the coordinatewise product weights encode identical
Bernoulli marginals and independence, that counting `true` coordinates is the
sum of the corresponding zero-one trials, and that the strict parameter and
positive-trial-count hypotheses match the printed source exactly. The wrapper
remains in the canonical bundled Bernoulli/binomial contract leaf; the
reusable PMF construction and proof remain in the scalar producer.

## Accepted Equation (1.8) increment

`NumStability.HDP.Contract.hdp_01_heq_h1_d8` exposes the canonical Poisson
law's singleton mass as `exp (-λ) * λ^k / k!` for every `λ : ℝ≥0` and
`k : ℕ`.

- source contract SHA-256:
  `e8c5220c774d3fb565bef6384658ed5e08012fce88b81d5623d380185b2d4646`;
- decision SHA-256:
  `f8615684677f6e56f3ff0d23639d37933cd3604ad60e1f0c16709c1ed0034144`;
- classification: `faithful-equivalent`;
- implications: Lean→source `yes`, source→Lean `yes`;
- adjudication: not required.

The audit confirmed that `ℝ≥0` captures the source's implicit finite
nonnegative parameter domain without losing `λ = 0`, `ℕ` is the exact support,
and `ENNReal.ofReal` preserves the nonnegative mass expression.

## Accepted normalized-sum increment

`NumStability.HDP.Contract.hdp_01_hdef_hzn` records the centered sum scaled by
`1 / (σ * sqrt N)`, while
`NumStability.HDP.Contract.hdp_01_hdef_hzn_eq_source_normalization` proves its
pointwise equality with `(S_N - E S_N) / sqrt (Var S_N)` from the exact
aggregate moment identities and explicit `N > 0`, `σ > 0` premises.

- source contract SHA-256:
  `19928dfa9e55eb230678bb6fe4882deb0bcf3ce147e1286899a4cd2113c67b19`;
- decision SHA-256:
  `f7bc5eff71c3702f953d94cb20ea37dd661acbb990580525b72e2b0a516087f7`;
- classification: `faithful-stronger`;
- implications: Lean→source `yes`, source→Lean `no`;
- adjudication: not required.

Both judges accepted zero-based `Finset.range N` as a harmless reindexing of
the source's first `N` variables. The declaration is stronger because it needs
only the two aggregate moment equations, rather than i.i.d. structure, and it
makes the source's implicit nondegeneracy conventions explicit.

## Accepted Equation (1.6) increment

`NumStability.HDP.Contract.hdp_01_heq_h1_d6` identifies the standard-normal
law `gaussianReal 0 1` with real volume weighted by its Gaussian density and
states the exact real formula on all of `ℝ`. Both independent judges accepted
the conjunction as the formal measure-theoretic expansion of “has density”:

- source contract SHA-256:
  `83b31e49ae56af77ec1710872f359c463b7e18a3f3937bf3069bb0a339cb4fcb`;
- decision SHA-256:
  `ebc00bdce77f8568a4d87eabc7fc223c81b853a59383f3a6c509ca26fc299cd3`;
- classification: `faithful-equivalent`;
- implications: Lean→source `yes`, source→Lean `yes`;
- adjudication: not required.

The audit checked that Mathlib's second Gaussian parameter is variance, not
standard deviation, and preserved mean `0`, variance `1`, denominator
`sqrt (2*pi)`, and exponent `-x^2/2`.

## Accepted Chebyshev and derivation increment

`NumStability.HDP.Contract.hdp_01_hcor_h1_d2_d5` states Corollary 1.2.5's
inclusive two-sided Chebyshev bound. The separate
`NumStability.HDP.Contract.hdp_01_hex_h1_d2_d6_derivation` packages all four
steps demanded by Exercise 1.2.6: the squared-event identity, Markov's bound
for the squared centered variable at threshold `t²`, the centered-second-
moment identity, and the final Chebyshev inequality.

Both audits are complete and adjudicated:

- corollary source contract / decision:
  `c06d06127a7807754d9190023606de0a5925c7d87570ab9d2943206775e4cc67` /
  `fe682d13f238788e29a2c688492f604dedaf6c79803137f8625d7f6e21b8d0f1`;
- exercise source contract / decision:
  `ce8dfd1a52b783be0459198710cabfcc811aea25a4c5d3985ecc753bdd8e71a0` /
  `37e64b8e84315818b5045f15082682ef11ef4ad784b03deff2dab76c66a2ebeb`;
- classification: `faithful-stronger` for each;
- implications: Lean→source `yes`, source→Lean `no` for each.

The adjudicators resolved the blind roles' opaque view of Mathlib's Bochner
integral and verified that the producers establish finite event measure before
`Measure.real` conversion. Probability-measure specialization is exact, while
finite non-normalized measures provide genuine nonvacuous extra cases.

## Accepted strong-law increment

`NumStability.HDP.Contract.hdp_01_hthm_h1_d3_d1` forwards the exact first-`n`
average and almost-sure limit to Mathlib's real strong law. Audit
`HDP-01-THM-1.3.1` is complete and adjudicated:

- source contract SHA-256:
  `52f6f50bdf3c861857f53470c9c39784282a3715470472803658cfae5e4fbbcb`;
- decision SHA-256:
  `17db01a5623903a455e6925ab80d1a5923b5666930931210d2843c02bc70e76d`;
- classification: `faithful-stronger`;
- implications: Lean→source `yes`, source→Lean `no`.

Pinned `strong_law_ae_real` explicitly implements Etemadi's pairwise-
independent strengthening. Its arbitrary-measure surface is probability-
normalized in every non-a.e.-zero case and otherwise closes the trivial branch;
zero-based indexing and the defined `n = 0` quotient do not affect `atTop`.

## Accepted sample-mean variance-limit increment

`NumStability.HDP.Contract.hdp_01_hclaim_hsample_hmean_hvariance_hlimit`
states that the variances of the first-`N+1` iid sample averages tend to zero.
Audit `HDP-01-CLAIM-SAMPLE-MEAN-VARIANCE-LIMIT` is complete and adjudicated:

- source contract SHA-256:
  `f244f080200b5e382d3c290b17bea58a84601b2c07c649dde14cb8bf3ee6c09f`;
- decision SHA-256:
  `194f94620d4bf81002021a9e0556c5056b7317cb2f2b3d9172f261ccec270307`;
- classification: `faithful-stronger`;
- implications: Lean→source `yes`, source→Lean `no`.

The adjudicator resolved Mathlib's variance and independence operators and
confirmed that pairwise-independent but not jointly independent identically
distributed `L²` sequences provide genuine extra applicability.

## Accepted independent-variance-sum increment

`NumStability.HDP.Contract.hdp_01_hlem_hindependent_hvariance_hsum` states the
exact variance additivity identity for a finite pairwise-independent `L²`
family. Both judges accepted it without adjudication:

- source contract SHA-256:
  `950f58419430cb53ec28c8320b025e0d53475d0776c2c7fabbebc895f7e29bf2`;
- decision SHA-256:
  `4142e2c8e9bd746e4cbe4b2ec9bb628fd240a608a17f6d000c4f4c6e0f8d2990`;
- classification: `faithful-stronger`;
- implications: Lean→source `yes`, source→Lean `no`.

The arbitrary finite index type adds the valid empty-family case, pairwise
independence genuinely weakens the source's joint-independence hypothesis, and
the explicit `L²` assumptions make the source's finite-variance convention
precise.

## Accepted Equation (1.5) increment

`NumStability.HDP.Contract.hdp_01_heq_h1_d5` states the exact variance of an
`N`-sample average. Audit `HDP-01-EQ-1.5` is complete and adjudicated:

- source contract SHA-256:
  `8d08a949424ba89680828e2a8ddc21b66f613bdf794602423efdec64064b4a99`;
- decision SHA-256:
  `a4b873e44553cb292d75e02cef7d37a1bae2cb16cfeb48cf3a09c0026f5494a8`;
- classification: `faithful-stronger`;
- implications: Lean→source `yes`, source→Lean `no`.

The adjudicator confirmed from pinned Mathlib definitions that all nontrivial
finite-measure cases with at least two variables are probability-normalized or
zero-measure, while the one-variable case is tautological. Pairwise
independence is sufficient for the variance identity and supplies genuine iid
examples outside mutual independence.

## Accepted Exercise 1.2.3 increment

`NumStability.HDP.Contract.hdp_01_hex_h1_d2_d3` states the p-moment tail
identity unconditionally in `ENNReal` and adds its finite `toReal`
specialization. The source states only the finite-right-hand-side case. Both
independent judges therefore accepted the Lean theorem as a genuine
strengthening:

- source contract SHA-256:
  `47fc6aa3c848746b67aa5f0e6bd2fac628ed36273b8748245939eb9e8c811ff3`;
- decision SHA-256:
  `322604674ab7497a93aea5593c1ea88e211ce47ef5954bd0af945dbae70c4c2d`;
- classification: `faithful-stronger`;
- implications: Lean→source `yes`, source→Lean `no`;
- adjudication: not required.

The audit also confirmed the factor `p t^(p-1)`, strict-tail convention, and
the open positive integration domain; omitting the zero endpoint is
Lebesgue-null and avoids the singular point when `0 < p < 1`.

## Accepted Exercise 1.2.2 discrepancy increment

`HDP-01-EXERCISE-1.2.2` is closed as `DISCREPANCY`. The literal
any-random-variable assertion permits a standard Cauchy law for which both
one-sided tail integrals are infinite. The separately named correction assumes
measurability and integrability and states the finite real signed-tail identity.

- obstruction source contract / decision:
  `0dedd8c8fdf46b0d85248120405ca3c9827f5bb746a230e0f5969d315881e272` /
  `428cfbcf9f719f410e5cc024c92b99d0492f04513a41bac64b89266f38c3a408`;
- corrected source contract / decision:
  `d8256518f0caa2397bf383825cb1a13659c534207d2a894cf6de35dfc8149823` /
  `fc9c01a09779e4502bae59a9d83b0c54e8c6a6042805565c8c65cb76c577d181`;
- both configured audit roles: `faithful-equivalent`, implication pairs
  `yes/yes`, no adjudication required.

## Accepted increment

`NumStability.HDP.Contract.hdp_01_hdef_hmgf_spec` exposes the displayed
`M_X(t) = E exp(tX)` formula as the extended nonnegative Lebesgue integral.
The source alias now lives in its canonical contract leaf rather than in the
reusable scalar producer. Audit `HDP-01-DEF-MGF` is complete and accepted:

- source contract SHA-256:
  `01b98406c9a6dcb10aeb58e0bd0afa0f4b17f91f633dba60fe72eeb2d143f8f3`;
- decision SHA-256:
  `442a53de747f5e5bb0941dbc4d8af59f28a5e0d0c65ded9f91ddffa8d12ef621`;
- final adjudicated classification: `faithful-equivalent`;
- implications: Lean→source `yes`, source→Lean `yes`.

The adjudicator resolved the codomain question because `exp(tX)` is
nonnegative, the source ranges over all real `t` without a finiteness
hypothesis, and `ENNReal` preserves finite values while representing
divergence by `+∞`.

## Accepted discrepancy increment

`HDP-01-DEF-MOMENTS` is closed as `DISCREPANCY`, not as a faithful rendering
of the printed definitions. The source permits a shared arbitrary real
`p > 0` in `E X^p`, including `p = 1/2`, while a real-valued random variable
may take negative values.

The two required artifacts compile and were audited independently:

- witness `NumStability.HDP.Contract.hdp_01_hdef_hmoments_source_obstruction`;
- corrected result `NumStability.HDP.Contract.hdp_01_hdef_hmoments_corrected`.

Audit `HDP-01-DEF-MOMENTS-OBSTRUCTION` accepted the witness as
`faithful-stronger` in its designated source-obstruction role:

- source contract SHA-256:
  `bf45d8d8bb9ee8d76f1f424e25205fed6a28144ec12eed24ce5738a520bc2a87`;
- decision SHA-256:
  `da13824d7e20b304b0a3860f07a0d456919925db1ed829602e56c5b1cf7d0dff`;
- implications: Lean→obstruction `yes`, source→exact Lean theorem `no`.

Audit `HDP-01-DEF-MOMENTS-CORRECTED` rejected the corrected interface as
`not-faithful-different`:

- source contract SHA-256:
  `8ed1875beac5b189e2633bcd29f05d142d97d537a394cd75a629fe72bf1e4fa4`;
- decision SHA-256:
  `8871673bc9095b4119c114243622600092d69a78150cb44363536e1f1e847c3b`;
- implications: Lean→source `no`, source→Lean `no`.

The correction deliberately uses natural exponents for raw moments and a
separate positive-real exponent for absolute moments, broadens the ambient
measure/function domain, and selects totalized real versus extended
nonnegative integral conventions absent from the printed pair.

## Accepted Equation (1.3) discrepancy increment

`HDP-01-EQ-1.3` is closed as `DISCREPANCY`. The book prints
`0 ≤ p ≤ q ≤ ∞`, but defines finite `L^p` only for `p > 0` and explains the
claim with `q/p`. The canonical leaf now separates three facts:

- `NumStability.HDP.Contract.hdp_01_heq_h1_d3_source_obstruction` proves that
  zero has no real reciprocal;
- `NumStability.HDP.Contract.hdp_01_heq_h1_d3_zero_model` records Mathlib's
  totalized `eLpNorm X 0 μ = 0` without attributing it to the source;
- `NumStability.HDP.Contract.hdp_01_heq_h1_d3_corrected` proves monotonicity
  for nonzero `p ≤ q`, including `q = ∞`.

Audit `HDP-01-EQ-1.3-OBSTRUCTION` classified the reciprocal lemma as relevant
diagnostic evidence but `not-faithful-different` from the full equation:

- source contract SHA-256:
  `806f640808caa3424debe4342f5fe07f96b541d1438945d0ae59860978b670c8`;
- decision SHA-256:
  `aeea98aa95cbe50a5aef34f34e5c34d3e80aee4c3e5617255909a0803ec51430`;
- implications: Lean→source `no`, source→Lean `no`.

Audit `HDP-01-EQ-1.3-CORRECTED` accepted the coherent corrected claim:

- source contract SHA-256:
  `597be3809dd2fded6ffa010bb0b1d2312f7a05c3cc6d801baaa434fb94dec028`;
- decision SHA-256:
  `d00886c513d7352fd1a4d1acf0685ac7ea54641b63718863086c7dc2148e1fc5`;
- final classification: `faithful-equivalent`;
- implications: Lean→source `yes`, source→Lean `yes`.

The adjudicator verified probability normalization, both finite and infinite
`eLpNorm` branches, and invariance under almost-everywhere replacement. This
acceptance is explicitly for the corrected `0 < p ≤ q ≤ ∞` claim, not for an
unstated `L^0` convention.

## Accepted Lp-norm increment

`NumStability.HDP.Contract.hdp_01_hdef_hlp_hnorm_spec` packages both printed
norm clauses: the finite positive-exponent formula and the `p = ∞` essential
supremum endpoint. Audit `HDP-01-DEF-LP-NORM` is complete and accepted:

- source contract SHA-256:
  `0e3dd657b14881b9de8a6bb68b69a3d2ed92a49af605150094f23c8205bdf33c`;
- decision SHA-256:
  `00794ea9cdaa796f44267499a4e526e08f8da3617752a127ca9348357a10c60a`;
- classification: `faithful-stronger`;
- implications: Lean→source `yes`, source→Lean `no`.

Finite `ENNReal` exponents excluding `0` and `⊤` encode exactly
`p ∈ (0,∞)`, and the top endpoint unfolds to the measure-essential supremum
of the pointwise absolute value. Lean is strictly stronger because the formulas
hold for every real-valued function, not only measurable random variables.

## Accepted Lp-space increment

`NumStability.HDP.Contract.hdp_01_hdef_hlp_hspace_spec` states that an
a.e.-strongly measurable representative belongs to `L^p` exactly when its
extended `L^p` norm is finite. Audit `HDP-01-DEF-LP-SPACE` is complete and
accepted:

- source contract SHA-256:
  `e058cbc83c249a4990c35603287db9202f343551e9cfefb18be88991f3bee2cf`;
- decision SHA-256:
  `205925fedc51f90e3184bb3d73fc814879ec0fc7acf38e0ed7dec6577fcd8163`;
- classification: `faithful-equivalent`;
- implications: Lean→source `yes`, source→Lean `yes`.

An initial audited shape also asserted equality with Mathlib's a.e.-quotient
space. Both judges found that quotient convention standard but not explicit in
the selected set-builder. The final audited theorem therefore states only the
printed representative membership criterion; quotient data remains reusable
and uncredited to this row.

## Accepted Lp-Banach increment

`NumStability.HDP.Contract.hdp_01_hthm_hlp_hbanach_spec` exposes the canonical
real normed-space structure, the exact `Lp.norm_def` formula, and completeness
of the whole `L^p` space for every `p ∈ [1,∞]`. Audit
`HDP-01-THM-LP-BANACH` is complete and accepted:

- source contract SHA-256:
  `c7abae16437468482c029d542bd7c45371181c85240ecb7b6df85194c1bea8da`;
- decision SHA-256:
  `7d5708ad79f3f4dc14da8871551f4a940a94e7f3e30a552c2ac4d54b3070a9fc`;
- final adjudicated classification: `faithful-equivalent`;
- implications: Lean→source `yes`, source→Lean `yes`.

The adjudicator expanded both `eLpNorm` branches: finite exponents use the
moment-root formula and `p = ∞` uses essential supremum. The exact norm formula
and `IsComplete univ` then jointly represent the printed norm and Banach claims.

## Accepted subunit-Lp increment

`NumStability.HDP.Contract.hdp_01_hclaim_hlp_hquasinorm_spec` proves that for
every `0 < p < 1`, the uniform two-point probability space has two real
singleton indicators violating the ordinary `eLpNorm` triangle inequality.
Audit `HDP-01-CLAIM-LP-QUASINORM` is complete and accepted:

- source contract SHA-256:
  `4c154040cd9eefaad4965fbce96bee7ae263d3f19008e5467dfcf3c343b8c72a`;
- decision SHA-256:
  `5ff029fe210407ceced5908568fadc0663e820acf204466791e655dfa32ad3e3`;
- final adjudicated classification: `faithful-stronger`;
- implications: Lean→source `yes`, source→Lean `no`.

The adjudicator rejected a false universal reading over every fixed probability
space (a singleton space reduces the functional to absolute value). The printed
idiom states non-validity in general; Lean strengthens it by locating an exact
`Fin 2` countermodel. A witnessed triangle violation also entails the printed
non-norm conclusion.

## Accepted Equation (1.1) increment

`NumStability.HDP.Contract.hdp_01_heq_h1_d1_spec` states both numbered
`L²` identities on real `MemLp` representatives: the inner product is
`E(XY)`, and the norm is the square root of `E|X|²`. Audit
`HDP-01-EQ-1.1` is complete and accepted:

- source contract SHA-256:
  `48d5ca964700b23ae540c7d5f8f7cb7ddac9e491537b2005627f613cf9d1f782`;
- decision SHA-256:
  `93e71f301d5ce3f6abb784b4bc793aefe9f61fc0737e0ede7608aed0148b2ef6`;
- classification: `faithful-equivalent`;
- implications: Lean→source `yes`, source→Lean `yes`.

Both judges passed every semantic check without adjudication. They classified
the book's preceding Hilbert-space sentence as context rather than a third
conjunct of Equation (1.1), and the representative-level statement as
compatible with the source's explicit function notation and implicit
almost-everywhere quotient convention. The `MemLp` hypotheses also make
Mathlib's totalized-integral fallback irrelevant.

## Accepted standard-deviation increment

`NumStability.HDP.Contract.hdp_01_hclaim_hstdev_spec` preserves the complete
chain `‖X-E X‖₂ = √Var(X) = σ(X)` as two adjacent equalities for a real
`L²` random variable on a probability space. Audit `HDP-01-CLAIM-STDEV` is
complete and accepted:

- source contract SHA-256:
  `0a61c3222b6aa227e5477848165765cb884ab10f116ae24e1cb84bdf04e944fa`;
- decision SHA-256:
  `8695df6bf03cbe07bd52e5f60d4dc8fcb5fefe028f93786d50ab9d4b19aa6eb7`;
- classification: `faithful-equivalent`;
- implications: Lean→source `yes`, source→Lean `yes`.

Both judges passed all twelve checks without adjudication. The explicit
`MemLp X 2 μ` hypothesis records the source's inherited `L²` domain, and the
fact that both Lean equalities unfold definitionally matches the explanatory
role of the printed identity rather than making it vacuous.

## Accepted Equation (1.2) increment

`NumStability.HDP.Contract.hdp_01_heq_h1_d2_spec` states both links of the
printed chain: covariance is the expected product of the separately centered
variables, and that expectation is their `L²` inner product. Audit
`HDP-01-EQ-1.2` is complete and accepted:

- source contract SHA-256:
  `674d614a0cc0900bfcc78fcc8a6e7dd4d583a2219e2039cba5d147cc9dd69cda`;
- decision SHA-256:
  `dc2bf3acdf0ba242f1f75405bde9fae3b8441ddea48cc6c4f78fe927cb0d5bef`;
- classification: `faithful-equivalent`;
- implications: Lean→source `yes`, source→Lean `yes`.

Both independent judges passed all twelve checks without adjudication. The
probability and `MemLp` hypotheses preserve the inherited square-integrable
domain, so Mathlib's globally totalized integral has no exceptional-case effect;
the representative-level scalar identities are invariant under almost-everywhere
replacement.

## Accepted convexity-definition increment

`NumStability.HDP.Contract.hdp_01_hdef_hconvex_hfunction_spec` proves that
Mathlib's `ConvexOn ℝ Set.univ` interface is equivalent to the exact
one-parameter inequality printed in footnote 3. Audit `HDP-01-DEF-CONVEX` is
complete and accepted:

- source contract SHA-256:
  `33525a7d0cab1d333ed740f39453d8a082fc497f5ebf1020af3562213c883503`;
- decision SHA-256:
  `7bde968be4fd53f216dbc771af29e12e73cdd6a8cde1fabbbd48cce4f9948fbd`;
- classification: `faithful-equivalent`;
- implications: Lean→source `yes`, source→Lean `yes`.

Both judges passed every semantic check without adjudication. They classified
the formula's `λ` versus the following prose's `t` as an evident bound-variable
typo; the Lean contract consistently binds one real parameter in the closed
unit interval and preserves the endpoint cases and non-strict inequality.

## Accepted Cauchy--Schwarz increment

`NumStability.HDP.Contract.hdp_01_hthm_hcauchy_hschwarz` states the real
`L²` product bound using `MemLp` hypotheses, the absolute value of the product
integral, and finite real values of the two extended norms. Audit
`HDP-01-THM-CAUCHY-SCHWARZ` is complete and accepted:

- source contract SHA-256:
  `40de136bdd0a303a6adf560b11aef94c73fcefeca075bef2e6ffba6943e5d7d2`;
- decision SHA-256:
  `21cc86dd2955c8cf8bd35773cc4dbaecd2a82d38b753c0f0f8ac77e6750ce3b5`;
- classification: `faithful-stronger`;
- implications: Lean→source `yes`, source→Lean `no`.

Both judges found that `MemLp` prevents `ENNReal.toReal` from collapsing an
infinite norm and implies integrability of the product, so Mathlib's totalized
integral is not reached. The only substantive difference is genuine strength:
the Lean theorem holds for arbitrary measures, while the selected source
inherits a probability-space context.

## Accepted Equation (1.4) increment

`NumStability.HDP.Contract.hdp_01_heq_h1_d4_spec` states the `L^p` triangle
inequality for every `p ∈ [1,∞]` on a common probability space, using `MemLp`
hypotheses for the two real random variables. Audit `HDP-01-EQ-1.4` is complete
and accepted:

- source contract SHA-256:
  `f07e8dce7d8fcdfcc50786dbc98a1403b1ec7a500772ce4c84e44f1f94cd1c7b`;
- decision SHA-256:
  `f1eee6e0a7b081beb276b93594bab15ed33e14fe7741018c5bb0a1e0e563dbdc`;
- final adjudicated classification: `faithful-equivalent`;
- implications: Lean→source `yes`, source→Lean `yes`.

The adjudicator expanded the previously opaque probability and `eLpNorm`
definitions: finite exponents use the integral-root norm, `p = ∞` uses the
essential supremum, and almost-everywhere representatives preserve the
inequality. The contract therefore covers exactly the printed endpoint range
without adding a separate exceptional convention.

## Accepted Hölder increment

`NumStability.HDP.Contract.hdp_01_hthm_hholder_spec` packages the finite
conjugate-exponent inequality and both endpoint orientations on the inherited
probability space. Audit `HDP-01-THM-HOLDER` is complete and accepted:

- source contract SHA-256:
  `0ca80f1e49aa54a9030ac5294a51d04e09da6920d7bc351b270c6eb556c5f206`;
- decision SHA-256:
  `97ea851815112dcf8837923515987f922e18794f7e8ef3c9ffcb6769321ccd60`;
- final adjudicated classification: `faithful-equivalent`;
- implications: Lean→source `yes`, source→Lean `yes`.

The adjudicator expanded `Real.HolderConjugate` from primary Mathlib evidence:
it is exactly the source domain `p,q > 1` with reciprocal sum one, so
`ENNReal.ofReal` introduces no truncation and `p=q=2` proves nonvacuity. The
extra `(∞,1)` branch follows from the printed `(1,∞)` branch by swapping the
two variables.

## Accepted distribution-determination increment

`NumStability.HDP.Contract.hdp_01_hclaim_hdistribution_hdetermined_spec`
states that two Borel probability laws on the real line agree exactly when
their masses agree on every inclusive lower half-line. Audit
`HDP-01-CLAIM-DISTRIBUTION-DETERMINED` is complete and accepted:

- source contract SHA-256:
  `84acb8f640f87412708f8975ddcdba2d7d0a82e1feabd5f0d774080dc6df8c31`;
- decision SHA-256:
  `72b4543e465d408e4838a7ec882fd78eb316eea0f355981a77d4fb4dff9955d3`;
- classification: `faithful-equivalent`;
- implications: Lean→source `yes`, source→Lean `yes`.

Both judges verified that Borel probability measures are exactly the possible
laws of real random variables: every such measure is realized by the identity
random variable on its own probability space. The reverse direction of the
Lean `↔` is automatic from equality of measures and does not add strength.

## Accepted CDF and tail increments

`NumStability.HDP.Contract.hdp_01_hdef_hcdf_spec` exposes the inclusive CDF
formula and was accepted as `faithful-stronger` because its `AEMeasurable`
domain includes nonmeasurable representatives beyond the source convention:

- source contract SHA-256:
  `838a4ecf5dcaa6388d1c27981973b8874db44158388a80f675721a7fcf8cef65`;
- decision SHA-256:
  `84a9d573127867fff196373092544df475e8a8da36fee307c6501776bfbb07fa`;
- implications: Lean→source `yes`, source→Lean `no`.

`NumStability.HDP.Contract.hdp_01_heq_htail_hcdf_spec` states the complementary
strict-tail identity. Audit `HDP-01-EQ-TAIL-CDF` accepted it as
`faithful-equivalent` after adjudication:

- source contract SHA-256:
  `4ca602d9a157177fd75db2c4e1313aba1b10bd6cca5c77323a3e6d6337dbaa20`;
- decision SHA-256:
  `bbe2f5bd9af6b1e05ca4fdf654ca9323adfdaad85b20436c633cbf648a85b631`;
- implications: Lean→source `yes`, source→Lean `yes`.

Unlike the preimage-valued CDF specification, the tail identity depends only
on the mapped probability law. Applying the source identity to the measurable
identity random variable on that law proves every `AEMeasurable` instance.

## Accepted layer-cake increment

`NumStability.HDP.Contract.hdp_01_hlem_h1_d2_d1_spec` states the unconditional
extended nonnegative identity together with its integrable real-valued
specialization. Audit `HDP-01-LEM-1.2.1` accepted it as
`faithful-equivalent`:

- source contract SHA-256:
  `534a00d2a6db14f7a01ab8b4a3ad64abee5d72d70034baba055d91b4a5c1de78`;
- decision SHA-256:
  `f525447461f8a5db38bbfe8a70f0649ad6b2f973957dcb7ad96370139c4ce057`;
- implications: Lean→source `yes`, source→Lean `yes`.

The adjudicator verified that equality in `ENNReal` includes the jointly
infinite case, the real conjunct is a redundant finite specialization, and
excluding the singleton threshold `0` does not change the Lebesgue integral.
The source's unlabelled pointwise-versus-almost-sure nonnegativity convention
is semantically harmless here: replacing `X` by `max(X,0)` preserves the
expectation and every strict positive-threshold tail.

## Reused increment

`NumStability.HDP.Contract.hdp_01_hprop_h1_d2_d4` is a stable wrapper around
`NumStability.HDP.Scalar.Preliminaries.markovInequalityExtended`. The wrapper
uses a probability measure, a measurable almost-everywhere nonnegative real
random variable, a positive threshold, the inclusive event `X ≥ t`, and an
`ENNReal` lower integral. It has no finite-expectation hypothesis.

Audit `HDP-01-PROP-1.2.4-EXTENDED` is complete and accepted:

- source contract SHA-256:
  `464f30523a82d2c5c87e99b5992acd543b8b0722d3f7a37bcc0eea415c61b1ac`;
- decision SHA-256:
  `f92171ff36b06314ca0acbd44b6af2eaa36746fca3e1891b1a65ec110044300b`;
- direct classification: `faithful-equivalent`;
- blind round trip: `undetermined` because foundational external-frontier
  definitions were opaque in the blind packet;
- final adjudicated classification: `faithful-equivalent`;
- implications: Lean→source `yes`, source→Lean `yes`.

The adjudicator resolved pointwise versus almost-everywhere nonnegativity by
applying the source theorem to `max(X,0)`, which preserves the positive
threshold event and produces the target lower integral.

## Resolved source-policy choice and reopened work

`HDP-01-DEF-EXPECTATION-VARIANCE` has two complete rejected audits: one for
the finite-moment interface and one for the literal measurable-variable
formula. The latest decision SHA-256 is
`680fc2e2c0d3b8afa8fcc2948a0f30f478641585947b27c0ca375c5f20eb5286`.
Unlike the MGF integrand, a general real random variable is signed, so the
source's silence did not itself select a finite, extended/partial, or
Mathlib-totalized expectation convention. On 2026-08-28 the operator selected
the module-owned finite-Lebesgue-integral convention: ordinary real-valued
expectation requires integrability, and variance uses the square-integrable
domain. The former `material-user-choice` blocker is therefore resolved. The
row is `READY`, not formalized, until the finite-domain contract receives a
fresh policy-bound audit.

`HDP-01-THM-JENSEN` shared the same missing analytic convention. The compiling declaration
`NumStability.HDP.Contract.hdp_01_hthm_hjensen_spec` states the correct formula
for finite real expectations, but requires both `Integrable X μ` and
`Integrable (φ ∘ X) μ`. Audit `HDP-01-THM-JENSEN` rejected this as
`not-faithful-weaker`:

- source contract SHA-256:
  `03a40db76475306cfedf9b6da9dc946cf7607897d35fb1378a42137fdd251f45`;
- decision SHA-256:
  `4d827116f81cb626dd465cd4beaf760d0318b3a2af05f2605c7594c8bb961a1c`;
- implications: Lean→source `no`, source→Lean `yes`.

The adjudicator confirmed that these hypotheses make both Bochner integrals
ordinary finite expectations but reduce applicability under the former literal
unrestricted reading. The selected module policy now treats those exact
hypotheses as the definability domain of the displayed ordinary expectations.
The row is reopened as `READY`: the old verdict is retained as history but
cannot be reused, and a fresh audit must decide the policy-bound contract.

## Audited narrative skip

Remark 1.1.1 is now `SKIPPED` as qualitative narrative, after auditing the
existing alias rather than silently accepting or discarding it. Audit
`HDP-01-REM-1.1.1` classified the alias's quantitative bound
`|cov(X,Y)| ≤ σ(X)σ(Y)` as `not-faithful-different` from the remark's signed,
unquantified alignment interpretation:

- source contract SHA-256:
  `40ba35554a56aae3f077b0c03f40aac87edf2e21d5991898a9f7b553ed90866f`;
- decision SHA-256:
  `e0dd61b2bb1c41545bef50194d69f9a2d13c38e22b3321ca4f706dd8041c7b51`;
- implications: Lean→source `no`, source→Lean `no`.

The exact covariance/inner-product identity referenced by the remark is already
credited under Equation (1.2). The absolute bound is a specialization of the
separately inventoried Cauchy–Schwarz theorem printed later in Section 1.2, so
it remains reusable but is not attributed to this remark.

## Principal open foundations

- Most of the 24 actionable rows have compiling or partial Chapter 1 candidates
  that still require statement-scoped faithfulness audits and, for embedded
  `hdp_01_*` aliases, canonical contract placement.
- The iid central limit theorem is absent from the repository and pinned
  Mathlib; it blocks Theorem 1.3.2, its tail formulation, and equation (1.7).
- A rare-event Bernoulli/Poisson approximation theorem is absent; it blocks
  Theorem 1.3.4.
- Exercise 1.3.3 needs the finite bound
  `E|sampleMean-μ| ≤ sqrt(Var(X₁)/N)` and an `IsBigO` lift.
- One further source discrepancy candidate is recorded in the Chapter 1 issue
  ledger and requires independent witness/correction audits.
