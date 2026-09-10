# Vershynin HDP Chapter 2 coverage

Authoritative source: first-edition Chapter 2 PDF, SHA-256
`ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`,
printed pages 12--40 (29 rendered PDF pages).
Book profile SHA-256:
`b366ee13ce5c1890555f7dda961eda9c2bf9ce6e8ef71de6a17c3f5585196cab`.
Module audit epoch `hdp-module-audit-2026-08-28-policy-guardrails-v3`, SHA-256
`481184f947b961d8532149c9095e679377269aec43c0132c0eb96472367f6aa9`.

The exhaustive machine-readable denominator is [`gates/ch02.json`](../../architecture/reviews/2026-09-faithfulness-outcomes.md).
It contains 130 source rows under gate schema 2.

## Status legend

| Status | Meaning |
|---|---|
| `PROVED` | A Lean declaration states the printed row and has complete faithfulness evidence. |
| `REUSED` | Closed by an existing Mathlib/repository result plus a wrapper and a strength/domain audit. |
| `DISCREPANCY` | The printed claim is wrong; closed only by a formal witness **and** a separately named corrected result. |
| `WEAKENED` | The printed claim was never proved and proof search attained strictly less; the printed form stays a standing open item. |
| `READY` / `IN_PROGRESS` | Locally actionable work remains — including missing proofs, foundations, wrappers, audits and organization. |
| `HARD_BLOCKED` / `DEPENDENCY_BLOCKED` | A typed obstruction that cannot be resolved locally. Both bar `PASS`. |
| `SKIPPED` | Genuinely narrative, empirical, machine-specific or underspecified material, with a fixed reason code. |
| `DEFERRED` | Tracked to a named destination. |

## Gate-derived progress

- Chapter verdict: **ACTIVE** (not `PASS`).
- Formalized objects: **1**.
- Remaining objects: **118**.
- Denominator: **119**. Percentage: **0.84%**.
- Reported separately and excluded from the denominator: **11** skipped, **0** deferred.
- Status counts: `PROVED`=1, `READY`=118, `SKIPPED`=11.
- No row is `UNCLASSIFIED`. Weakened rows: 0. Discrepancy rows: 0.

**Why compiling Lean alone does not count as coverage.** A row becomes a
formalized object only when it also carries per-row faithfulness evidence: a
`contract_hash` and the three independent views, with `direct_pass` = `PASS`.
Compilation proves the Lean type is inhabited; it does not prove the type matches
the printed row. Exercise 2.8.5's accepted audit was invalidated by a later
change to the shared Bernstein source file and restored only after regenerated
packets matched the original audited hashes exactly and complete validation
passed against the new file hash.

## Rows carrying Lean content (76 of 130)

These have compiling, axiom-clean declarations and are blocked only on the
semantic-equivalence loop.

| Row | Printed label | Kind | Status | Primary Lean declaration |
|---|---|---|---|---|
| `HDP-02-DEF-2.2.1` | Definition 2.2.1 | definition | `READY` | `NumStability.HDP.Contract.hdp_02_hdef_h2_d2_d1` |
| `HDP-02-BODY-2.2-BERNOULLI-SHIFT` | Section 2.2 body: X ~ Ber(1/2) iff Z = 2X - 1 is symmetric Bernoulli | equation | `READY` | `NumStability.HDP.Scalar.IndependentSums.Hoeffding.affineBernoulliIsRademacherIff` |
| `HDP-02-THM-2.2.2` | Theorem 2.2.2 | theorem | `READY` | `NumStability.HDP.Contract.hdp_02_hthm_h2_d2_d2` |
| `HDP-02-EQ-2.5` | (2.5) | equation | `READY` | `NumStability.HDP.Contract.hdp_02_hlem_hexponential_hmarkov` |
| `HDP-02-EQ-2.6` | (2.6) | equation | `READY` | `NumStability.HDP.Contract.hdp_02_hlem_hmgf_hindependent_hsum` |
| `HDP-02-BODY-2.2-COSH-MGF` | Section 2.2 body: E exp(lam a_i X_i) = cosh(lam a_i) | equation | `READY` | `NumStability.HDP.Scalar.IndependentSums.Hoeffding.rademacherWeightedMGFLe` |
| `HDP-02-EX-2.2.3` | Exercise 2.2.3 | exercise | `READY` | `NumStability.HDP.Contract.hdp_02_hex_h2_d2_d3` |
| `HDP-02-BODY-2.2-COIN-BOUND` | Section 2.2 body: P{at least (3/4)N heads} <= exp(-N/8) | equation | `READY` | `NumStability.HDP.Contract.hdp_02_hex_hfair_hcoin_hhoeffding` |
| `HDP-02-THM-2.2.5` | Theorem 2.2.5 | theorem | `READY` | `NumStability.HDP.Contract.hdp_02_hthm_h2_d2_d5` |
| `HDP-02-THM-2.2.6` | Theorem 2.2.6 | theorem | `READY` | `NumStability.HDP.Contract.hdp_02_hthm_h2_d2_d6` |
| `HDP-02-EX-2.2.7` | Exercise 2.2.7 | exercise | `READY` | `NumStability.HDP.Contract.hdp_02_hex_h2_d2_d7` |
| `HDP-02-EX-2.2.8` | Exercise 2.2.8 | exercise | `READY` | `NumStability.HDP.Contract.hdp_02_hex_h2_d2_d8` |
| `HDP-02-EX-2.2.10A` | Exercise 2.2.10(a) | exercise | `READY` | `NumStability.HDP.Contract.hdp_02_hex_h2_d2_d10a` |
| `HDP-02-EX-2.2.10B` | Exercise 2.2.10(b) | exercise | `READY` | `NumStability.HDP.Contract.hdp_02_hex_h2_d2_d10b` |
| `HDP-02-THM-2.3.1` | Theorem 2.3.1 | theorem | `READY` | `NumStability.HDP.Contract.hdp_02_hthm_h2_d3_d1` |
| `HDP-02-EQ-2.7` | (2.7) | equation | `READY` | `NumStability.HDP.Scalar.IndependentSums.Chernoff.poissonBinomialMgfBound` |
| `HDP-02-BODY-2.3-BERNOULLI-MGF` | Section 2.3 body: Bernoulli MGF bound | equation | `READY` | `NumStability.HDP.Contract.hdp_02_hlem_hbernoulli_hmgf_hbound` |
| `HDP-02-BODY-2.3-ONE-PLUS-X` | Section 2.3 body: 1 + x <= e^x | equation | `READY` | `Real.add_one_le_exp` |
| `HDP-02-EX-2.3.2` | Exercise 2.3.2 | exercise | `READY` | `NumStability.HDP.Contract.hdp_02_hex_h2_d3_d2` |
| `HDP-02-REM-2.3.4` | Remark 2.3.4 | remark | `READY` | `NumStability.HDP.Contract.hdp_02_hrem_h2_d3_d4` |
| `HDP-02-EX-2.3.5` | Exercise 2.3.5 | exercise | `READY` | `NumStability.HDP.Contract.hdp_02_hex_h2_d3_d5` |
| `HDP-02-DEF-2.4-ERDOS-RENYI` | Section 2.4 body definition: Erdos-Renyi model G(n,p) | definition | `READY` | `NumStability.HDP.Contract.hdp_02_hdef_herdos_hrenyi` |
| `HDP-02-BODY-2.4-EXPECTED-DEGREE` | Section 2.4 body: expected degree (n-1)p =: d | equation | `READY` | `NumStability.HDP.Contract.hdp_02_hlem_her_hdegree_hlaw` |
| `HDP-02-PROP-2.4.1` | Proposition 2.4.1 | proposition | `READY` | `NumStability.HDP.Contract.hdp_02_hprop_h2_d4_d1` |
| `HDP-02-BODY-2.4-DEGREE-CHERNOFF` | Proposition 2.4.1 proof body: P{|d_i - d| >= 0.1 d} <= 2 e^{-c d} | equation | `READY` | `NumStability.HDP.Scalar.IndependentSums.Chernoff.erdosRenyiDegreeDeviationBound` |
| `HDP-02-EX-2.4.2` | Exercise 2.4.2 | exercise | `READY` | `NumStability.HDP.Contract.hdp_02_hex_h2_d4_d2` |
| `HDP-02-EX-2.4.3` | Exercise 2.4.3 | exercise | `READY` | `NumStability.HDP.Contract.hdp_02_hex_h2_d4_d3` |
| `HDP-02-EX-2.5.1` | Exercise 2.5.1 | exercise | `READY` | `NumStability.HDP.Contract.hdp_02_hex_h2_d5_d1` |
| `HDP-02-EQ-2.11` | (2.11) | equation | `READY` | `NumStability.HDP.Scalar.SubGaussian.standardNormalLpNormGrowth` |
| `HDP-02-EQ-2.12` | (2.12) | equation | `READY` | `NumStability.HDP.Contract.hdp_02_heq_h2_d12` |
| `HDP-02-PROP-2.5.2` | Proposition 2.5.2 | proposition | `READY` | `NumStability.HDP.Contract.hdp_02_hprop_h2_d5_d2` |
| `HDP-02-REM-2.5.3` | Remark 2.5.3 | remark | `READY` | `NumStability.HDP.Contract.hdp_02_hrem_h2_d5_d3` |
| `HDP-02-EX-2.5.4` | Exercise 2.5.4 | exercise | `READY` | `NumStability.HDP.Scalar.SubGaussian.mgfBoundForcesMeanZero` |
| `HDP-02-EX-2.5.5A` | Exercise 2.5.5(a) | exercise | `READY` | `NumStability.HDP.Contract.hdp_02_hex_h2_d5_d5a` |
| `HDP-02-EX-2.5.5B` | Exercise 2.5.5(b) | exercise | `READY` | `NumStability.HDP.Scalar.SubGaussian.squareMGFGlobalTailZero` |
| `HDP-02-DEF-2.5.6` | Definition 2.5.6 | definition | `READY` | `NumStability.HDP.Contract.hdp_02_hdef_h2_d5_d6` |
| `HDP-02-EQ-2.13` | (2.13) | equation | `READY` | `NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge` |
| `HDP-02-EX-2.5.7` | Exercise 2.5.7 | exercise | `READY` | `NumStability.HDP.Contract.hdp_02_hex_h2_d5_d7` |
| `HDP-02-EQ-2.14` | (2.14) | equation | `READY` | `NumStability.HDP.Scalar.SubGaussian.psiTwoGaugeCharacterizations` |
| `HDP-02-EQ-2.15` | (2.15) | equation | `READY` | `NumStability.HDP.Scalar.SubGaussian.psiTwoGaugeCharacterizations` |
| `HDP-02-BODY-2.5-PSI2-SQUARE-POINT` | Section 2.5 body display: E exp(X^2/||X||_{psi_2}^2) <= 2 | equation | `READY` | `NumStability.HDP.Scalar.SubGaussian.psiTwoGauge_finite_iff` |
| `HDP-02-EQ-2.16` | (2.16) | equation | `READY` | `NumStability.HDP.Scalar.SubGaussian.squareMGFToMGF` |
| `HDP-02-EXAMPLE-2.5.8A` | Example 2.5.8(a) | example | `READY` | `NumStability.HDP.Contract.hdp_02_hexample_h2_d5_d8a` |
| `HDP-02-EXAMPLE-2.5.8B` | Example 2.5.8(b) | example | `READY` | `NumStability.HDP.Contract.hdp_02_hexample_h2_d5_d8b` |
| `HDP-02-EXAMPLE-2.5.8C` | Example 2.5.8(c) | example | `READY` | `NumStability.HDP.Contract.hdp_02_hexample_h2_d5_d8c` |
| `HDP-02-EQ-2.17` | (2.17) | equation | `READY` | `NumStability.HDP.Scalar.SubGaussian.essentiallyBoundedPsiTwoGauge` |
| `HDP-02-EQ-2.18` | (2.18) | equation | `READY` | `NumStability.HDP.Contract.hdp_02_heq_h2_d18` |
| `HDP-02-PROP-2.6.1` | Proposition 2.6.1 | proposition | `READY` | `NumStability.HDP.Contract.hdp_02_hprop_h2_d6_d1` |
| `HDP-02-THM-2.6.2` | Theorem 2.6.2 | theorem | `READY` | `NumStability.HDP.Contract.hdp_02_hthm_h2_d6_d2` |
| `HDP-02-THM-2.6.3` | Theorem 2.6.3 | theorem | `READY` | `NumStability.HDP.Contract.hdp_02_hthm_h2_d6_d3` |
| `HDP-02-LEM-2.6.8` | Lemma 2.6.8 | lemma | `READY` | `NumStability.HDP.Contract.hdp_02_hlem_h2_d6_d8` |
| `HDP-02-EQ-2.20` | (2.20) | equation | `READY` | `NumStability.HDP.Scalar.SubGaussian.psiTwoGauge_add_le` |
| `HDP-02-BODY-2.6-CONSTANT-PSI2` | Lemma 2.6.8 proof body: ||a||_{psi_2} <~ |a| for constant a | equation | `READY` | `NumStability.HDP.Scalar.SubGaussian.essentiallyBoundedPsiTwoGauge` |
| `HDP-02-EX-2.6.9` | Exercise 2.6.9 | exercise | `READY` | `NumStability.HDP.Contract.hdp_02_hex_h2_d6_d9` |
| `HDP-02-PROP-2.7.1` | Proposition 2.7.1 | proposition | `READY` | `NumStability.HDP.Contract.hdp_02_hex_h2_d7_d2` |
| `HDP-02-EX-2.7.2` | Exercise 2.7.2 | exercise | `READY` | `NumStability.HDP.Contract.hdp_02_hex_h2_d7_d2` |
| `HDP-02-EX-2.7.3` | Exercise 2.7.3 | exercise | `READY` | `NumStability.HDP.Contract.hdp_02_hex_h2_d7_d3` |
| `HDP-02-DEF-2.7.5` | Definition 2.7.5 | definition | `READY` | `NumStability.HDP.Contract.hdp_02_hdef_h2_d7_d5` |
| `HDP-02-EQ-2.21` | (2.21) | equation | `READY` | `NumStability.HDP.Contract.hdp_02_heq_h2_d21` |
| `HDP-02-LEM-2.7.6` | Lemma 2.7.6 | lemma | `READY` | `NumStability.HDP.Contract.hdp_02_hlem_h2_d7_d6` |
| `HDP-02-LEM-2.7.7` | Lemma 2.7.7 | lemma | `READY` | `NumStability.HDP.Contract.hdp_02_hlem_h2_d7_d7` |
| `HDP-02-BODY-2.7-YOUNG` | Lemma 2.7.7 proof body: Young's inequality | equation | `READY` | `Real.add_sq_le_sq_add_sq` |
| `HDP-02-REM-2.7.9` | Remark 2.7.9 | remark | `READY` | `NumStability.HDP.Contract.hdp_02_hrem_h2_d7_d9` |
| `HDP-02-DEF-2.7-ORLICZ-FUNCTION` | Section 2.7.1 body definition: Orlicz function | definition | `READY` | `NumStability.HDP.Contract.hdp_02_hdef_horlicz_hfunction` |
| `HDP-02-DEF-2.7-ORLICZ-NORM-SPACE` | Section 2.7.1 body definition: Orlicz norm and Orlicz space | definition | `READY` | `NumStability.HDP.Contract.hdp_02_hdef_horlicz_hnorm_hspace` |
| `HDP-02-EX-2.7.11` | Exercise 2.7.11 | exercise | `READY` | `NumStability.HDP.Contract.hdp_02_hdef_horlicz_hnorm_hspace` |
| `HDP-02-EXAMPLE-2.7.12` | Example 2.7.12 | example | `READY` | `NumStability.HDP.Contract.hdp_02_hexample_h2_d7_d12` |
| `HDP-02-EXAMPLE-2.7.13` | Example 2.7.13 | example | `READY` | `NumStability.HDP.Contract.hdp_02_hexample_h2_d7_d13` |
| `HDP-02-THM-2.8.1` | Theorem 2.8.1 | theorem | `READY` | `NumStability.HDP.Contract.hdp_02_hthm_h2_d8_d1_hpsi1` |
| `HDP-02-EQ-2.23` | (2.23) | equation | `READY` | `NumStability.HDP.Scalar.IndependentSums.Bernstein.independentWeightedSumLocalMGF` |
| `HDP-02-EQ-2.24` | (2.24) | equation | `READY` | `NumStability.HDP.Scalar.IndependentSums.Bernstein.SubExponentialLinearMGF` |
| `HDP-02-THM-2.8.2` | Theorem 2.8.2 | theorem | `READY` | `NumStability.HDP.Contract.hdp_02_hthm_h2_d8_d2_hpsi1` |
| `HDP-02-COR-2.8.3` | Corollary 2.8.3 | corollary | `READY` | `NumStability.HDP.Contract.hdp_02_hcor_h2_d8_d3_hpsi1` |
| `HDP-02-THM-2.8.4` | Theorem 2.8.4 | theorem | `READY` | `NumStability.HDP.Contract.hdp_02_hthm_h2_d8_d4` |
| `HDP-02-EX-2.8.5` | Exercise 2.8.5 | exercise | `PROVED` | `NumStability.HDP.Contract.hdp_02_hex_h2_d8_d5` |
| `HDP-02-EX-2.8.6` | Exercise 2.8.6 | exercise | `READY` | `NumStability.HDP.Contract.hdp_02_hex_h2_d8_d6` |

## Open rows with no Lean content yet (43)

| Row | Printed label | Kind | Next foundation (abridged) |
|---|---|---|---|
| `HDP-02-BODY-2.1-SN-MOMENTS` | Section 2.1 body display: E S_N = N/2, Var(S_N) = N/4 | equation | Prove `E S_N = N/2` and `Var S_N = N/4` for `S_N` a sum of `N` independent fair Bernoulli indicators, reusing `NumStability.HDP.Scalar.LimitTheorems.independentVarianceSum` and Mathlib's `PMF.binomial |
| `HDP-02-EQ-2.1` | (2.1) | equation | Instantiate `hdp_01_hcor_h1_d2_d5` at `S_N` with `E S_N = N/2`, `Var S_N = N/4` and threshold `N/4`, then chain the inclusion `{S_N >= 3N/4} subset {\|S_N - N/2\| >= N/4}`; needs HDP-02-BODY-2.1-SN-MO |
| `HDP-02-BODY-2.1-ZN-IDENTITY` | Section 2.1 body: normalization identity inside (2.2) | equation | Prove the set identity `{S_N >= 3N/4} = {Z_N >= sqrt(N/4)}` for `Z_N = (S_N - N/2)/sqrt(N/4)`; pure algebra once HDP-02-BODY-2.1-SN-MOMENTS fixes the normalization. |
| `HDP-02-PROP-2.1.2` | Proposition 2.1.2 | proposition | Prove the two-sided Gaussian tail estimate by the source's own route: the upper bound by the substitution `x = t + y` and `exp(-y^2/2) <= 1`, the lower bound from the identity `integral over (t, inf)  |
| `HDP-02-EQ-2.3` | (2.3) | equation | Specialize the upper half of Proposition 2.1.2 to `t >= 1`, where `1/t <= 1`. |
| `HDP-02-THM-2.1.3` | Theorem 2.1.3 | theorem | Either port a Berry-Esseen proof (a substantial independent development: Esseen's smoothing inequality plus a characteristic-function estimate) or record the row as an accepted external citation under |
| `HDP-02-BODY-2.1-BINOM-CENTRAL` | Section 2.1 body: P{S_N = N/2} = 2^{-N} binom(N, N/2) ~ 1/sqrt(N) | equation | Prove `P{S_N = N/2} = 2^{-N} * Nat.choose N (N/2)` from `PMF.binomial`, then its `~ 1/sqrt N` asymptotic via `Mathlib.Analysis.SpecialFunctions.Stirling`, mirroring `poissonPointMass_isEquivalent_stir |
| `HDP-02-BODY-2.1-GAUSSIAN-ATOM` | Section 2.1 body: P{g = 0} = 0 | equation | Prove `gaussianReal 0 1 {0} = 0` from `Mathlib.Probability.Distributions.Gaussian.Real` (the law has a density, hence no atoms); a short argument via `MeasureTheory.Measure.withDensity` and `Real.volu |
| `HDP-02-NOTATION-2.1-ASYMPTOTIC` | Section 2.1 footnote 1 | definition | Define the footnote's relations as abbreviations over `Asymptotics.IsTheta` and `Asymptotics.IsBigO` on `Filter.atTop`, and record that the footnote allows both the all-x and the eventually-x reading. |
| `HDP-02-EX-2.1.4` | Exercise 2.1.4 | exercise | Prove `E[g^2 * indicator (g > t)] = t * phi(t) + P{g > t}` by integration by parts on `Set.Ioi t` (the hint's route), then bound by `(t + 1/t) phi(t)` using Proposition 2.1.2; needs HDP-02-PROP-2.1.2  |
| `HDP-02-BODY-2.2-WLOG-NORM` | Theorem 2.2.2 proof body: WLOG ||a||_2 = 1 | equation | State and prove the reduction itself: the general case of Theorem 2.2.2 follows from the unit-energy case by rescaling `a` and `t`, i.e. `P{sum a_i X_i >= t} = P{sum (a_i/\|\|a\|\|_2) X_i >= t/\|\|a\| |
| `HDP-02-BODY-2.2-TWO-SIDED-SPLIT` | Section 2.2 body: P{|S| >= t} = P{S >= t} + P{-S >= t} | equation | Extract one reusable lemma `mu.real {\|S\| >= t} = mu.real {S >= t} + mu.real {-S >= t}` for `t > 0` (the events are disjoint at positive `t`), then rewrite the four inlined copies to use it. This als |
| `HDP-02-EX-2.2.9A` | Exercise 2.2.9(a) | exercise | Chain `iidSampleMeanVariance` with Chebyshev (`hdp_01_hcor_h1_d2_d5`) to get `P{\|mean - mu\| > eps} <= sigma^2/(N eps^2)`, then exhibit the absolute constant `C = 4` making `N >= C sigma^2/eps^2` suf |
| `HDP-02-EX-2.2.9B` | Exercise 2.2.9(b) | exercise | Define the median of `2k+1` independent weak estimators, prove the boosting step (if more than half the weak estimators are eps-accurate then the median is), then apply Exercise 2.2.8's majority bound |
| `HDP-02-EX-2.3.3` | Exercise 2.3.3 | exercise | Either take the hint's route, which needs HDP Theorem 1.3.4 (Poisson limit theorem) with quantitative control good enough to transfer a tail bound, or prove the Poisson tail directly by the same MGF a |
| `HDP-02-EQ-2.8` | (2.8) | equation | Closes together with HDP-02-EX-2.3.3; needs the Poisson moment generating function. |
| `HDP-02-EX-2.3.6` | Exercise 2.3.6 | exercise | Transfer `poissonBinomialTwoSidedQuadraticBound` to the Poisson law. Needs the same foundation as HDP-02-EX-2.3.3: either HDP Theorem 1.3.4 with quantitative control, or a direct Poisson MGF argument. |
| `HDP-02-EX-2.3.8` | Exercise 2.3.8 | exercise | Needs a central limit theorem for i.i.d. square-integrable variables. The hint's route is: write `Pois(lambda)` for integer `lambda` as a sum of `lambda` i.i.d. `Pois(1)` variables via `poissonAddLaw` |
| `HDP-02-BODY-2.4-UNION-BOUND` | Proposition 2.4.1 proof body: union bound over vertices | equation | Extract the printed display as a lemma: `mu.real {exists i, \|d i - d\| >= r} <= sum_i mu.real {\|d i - d\| >= r}`, i.e. a finite `measure_biUnion_finset_le` specialization, then rewrite `erdosRenyiAl |
| `HDP-02-EX-2.4.4` | Exercise 2.4.4 | exercise | The hint's route needs a second-moment/independence trick: replace the dependent degrees `d_i` by independent `d'_i` built from a vertex subset, then apply the Poisson approximation (2.9). The smalles |
| `HDP-02-EX-2.4.5` | Exercise 2.4.5 | exercise | Needs HDP-02-EX-2.4.4's decoupling lemma, then the `log n / log log n` calculation matching `erdosRenyiVerySparseMaxDegreeLogLogBound` from below. |
| `HDP-02-EQ-2.10` | (2.10) | equation | Deduce from HDP-02-PROP-2.1.2 by symmetry of the standard Gaussian; needs HDP-02-PROP-2.1.2 and `gaussianReal` symmetry under negation. |
| `HDP-02-BODY-2.5-PSI2-MINIMALITY` | Section 2.5 body: psi_2 norm is the smallest such number | equation | Prove the four reverse comparisons: from each of the four displayed bounds with parameter `K`, derive `c * gauge <= K` for an absolute `c`. The smallest missing foundation is a lower bound on the gaug |
| `HDP-02-EX-2.5.9` | Exercise 2.5.9 | exercise | For each of Poisson, exponential, Pareto and Cauchy, show `PsiTwoGauge mu X = infinity`, i.e. `integral (exp (X^2/t^2)) = infinity` for every `t > 0`. The smallest missing foundation is a divergence c |
| `HDP-02-EX-2.5.10A` | Exercise 2.5.10 (first claim) | exercise | Follow the hint: normalize `Y_i = X_i/(C K sqrt(1 + log i))`, use the sub-gaussian tail (2.14) with a union bound to get `P{exists i, \|Y_i\| >= t} <~ exp(-t^2)` for `t >= 1`, then integrate the tail  |
| `HDP-02-EX-2.5.10B` | Exercise 2.5.10 (second claim) | exercise | Specialize HDP-02-EX-2.5.10A to `i <= N` and absorb `sqrt(1 + log N)` into `C sqrt(log N)` for `N >= 2`. |
| `HDP-02-EX-2.5.11` | Exercise 2.5.11 | exercise | Prove `E max_{i <= N} g_i >= c sqrt(log N)` for i.i.d. standard Gaussians. The standard route needs a Gaussian tail LOWER bound (the left half of Proposition 2.1.2) plus independence: `P{max < t} = P{ |
| `HDP-02-EX-2.6.4` | Exercise 2.6.4 | exercise | Give the deduction the exercise asks for: from a bounded variable `X_i` in `[m_i, M_i]`, produce a psi-2/linear-MGF parameter proportional to `M_i - m_i` (via `essentiallyBoundedPsiTwoGauge` after cen |
| `HDP-02-EX-2.6.5` | Exercise 2.6.5 | exercise | Prove both halves for `p in [2, infinity)`: the lower bound `(sum a_i^2)^{1/2} <= \|\|sum a_i X_i\|\|_{L^p}` from `\|\|.\|\|_{L^2} <= \|\|.\|\|_{L^p}` plus the unit-variance independence identity `E ( |
| `HDP-02-EX-2.6.6` | Exercise 2.6.6 | exercise | Apply `lpExtrapolation` to `Z = sum a_i X_i` and feed it the `p = 3` Khintchine upper bound from HDP-02-EX-2.6.5; the upper half `\|\|Z\|\|_{L^1} <= (sum a_i^2)^{1/2}` follows from `\|\|.\|\|_{L^1} <= |
| `HDP-02-EX-2.6.7` | Exercise 2.6.7 | exercise | State the `p in (0,2)` two-sided form with a `c(K, p)` lower constant and prove it by modifying the extrapolation exponents; needs HDP-02-EX-2.6.5 first. Record the chosen statement as a formalizer-su |
| `HDP-02-EQ-2.19` | (2.19) | equation | State and prove `eLpNorm (X - E X) 2 mu <= eLpNorm X 2 mu`, i.e. `Var X <= E X^2`, from `MeasureTheory.variance_le_expectation_sq` or directly by expanding; a short proof, but it is a distinct printed |
| `HDP-02-BODY-2.7-GAUSSIAN-SQUARE-TAIL` | Section 2.7 body: tails of g_i^2 are exponential | equation | Prove `P{g^2 > t} = P{\|g\| > sqrt t}` (immediate) and combine with HDP-02-PROP-2.1.2 to get two-sided `exp(-t/2)` behaviour; needs HDP-02-PROP-2.1.2 including its lower bound to justify 'strictly hea |
| `HDP-02-EX-2.7.4` | Exercise 2.7.4 | exercise | Exhibit a witness: for `X ~ Exp(1)` with `\|\|X\|\|_{psi_1}`-scale parameter `K_3 = 1`, `E exp(lambda \|X\|)` is infinite at `lambda = 1`, so the bound fails at the endpoint of the widened range. `Sub |
| `HDP-02-BODY-2.7-SG-IMPLIES-SE` | Section 2.7 body: any sub-gaussian distribution is sub-exponential | equation | Prove `SubGaussianSquarePoint mu X K -> SubExponentialOnePointMGF mu X (C*K)` for an absolute `C`, using `\|x\| <= (x^2 + 1)/2` inside the exponential; a short argument once the two predicates are pla |
| `HDP-02-EQ-2.22` | (2.22) | equation | Closes with HDP-02-LEM-2.7.7; it is that proof's `E exp(X^2) <= 2 and E exp(Y^2) <= 2` normalization step. |
| `HDP-02-EXAMPLE-2.7.8` | Example 2.7.8 | example | Needs HDP-02-DEF-2.7.5 for the psi-1 half. The mean and variance halves are available from `Mathlib.Probability.Distributions.Exponential` and can be closed independently; the row should therefore be  |
| `HDP-02-EX-2.7.10` | Exercise 2.7.10 | exercise | Needs HDP-02-DEF-2.7.5. Then transcribe the psi-2 proof `SubGaussian.centeredSubGaussian`: triangle inequality for the gauge, plus `\|\|E X\|\|_{psi_1} <~ \|E X\| <= E\|X\| <~ \|\|X\|\|_{psi_1}` using |
| `HDP-02-BODY-2.7-ORLICZ-BANACH` | Section 2.7.1 body: L_psi is complete, hence a Banach space | equation | Prove that the Orlicz gauge quotient is complete. The smallest missing foundation is a Fatou-type lower semicontinuity lemma for the Orlicz gauge under a.e. convergence, from which completeness follow |
| `HDP-02-REM-2.7.14` | Remark 2.7.14 | remark | State the two inclusions as set inclusions between the corresponding membership predicates and discharge them from `essentiallyBoundedPsiTwoGauge` and the psi-2 moment bound (2.15) at each finite `p`. |
| `HDP-02-BODY-2.8-NORMALIZED-REGIMES` | Section 2.8 body: normalized two-regime bound | equation | Specialize `bernsteinWeightedTail` at `a_i = 1/sqrt N` and split on `t <= C sqrt N` versus `t >= C sqrt N` to recover the printed piecewise form. Note the source's footnote 9 explicitly lets `c`, `C`  |
| `HDP-02-THM-2.9.1` | Theorem 2.9.1 | theorem | Prove it by the martingale/Doob route the Notes describe ('by the same general method as Hoeffding's inequality, namely by bounding the moment generating function'). The smallest missing foundation is |
| `HDP-02-THM-2.9.2` | Theorem 2.9.2 | theorem | Prove it by the same MGF route as Theorem 2.3.1, using the exact bounded-variable MGF bound `E exp(lambda X) <= exp(sigma^2 (e^{lambda K} - 1 - lambda K)/K^2)` and then optimizing to produce `h(u) = ( |

## Skipped rows (11)

| Row | Printed label | Reason code | Reason |
|---|---|---|---|
| `HDP-02-QUESTION-2.1.1` | Question 2.1.1 | `narrative` | Question 2.1.1 poses the motivating coin-tossing question (printed p. 12); it asserts nothing. Its quantitative content is carried by the separate rows HDP-02-BODY-2.1-SN-MOMENTS and HDP-02-EQ-2.1. |
| `HDP-02-EQ-2.2` | (2.2) | `underspecified` | The operative content of display (2.2) on printed p. 13 is the central-limit approximation sign in P{Z_N >= sqrt(N/4)} ~~ P{g >= sqrt(N/4)}, which carries no quantitative meaning at fixed N; the text itself says on p. 14 |
| `HDP-02-EQ-2.4` | (2.4) | `narrative` | Display (2.4) on printed p. 14 states what 'we should expect' the coin-tossing probability to be smaller than, and the surrounding text immediately explains that it does not follow rigorously. It is an expectation, not a |
| `HDP-02-REM-2.2.4` | Remark 2.2.4 | `narrative` | Remark 2.2.4 on printed p. 17 contrasts the non-asymptotic character of Hoeffding's inequality with classical limit theorems and comments on its attractiveness in data science. It states no mathematical proposition beyon |
| `HDP-02-EQ-2.9` | (2.9) | `underspecified` | Display (2.9) on printed p. 19 is a Stirling-based approximation written with '~~' for the Poisson probability mass function, with no stated error control. The sharpness discussion it supports is HDP-02-REM-2.3.4, whose  |
| `HDP-02-REM-2.3.7` | Remark 2.3.7 | `narrative` | Remark 2.3.7 on printed p. 20 describes, in words and by reference to Figure 2.1, the two tail regimes of the Poisson distribution. The two quantitative statements it summarizes are Exercises 2.3.3 and 2.3.6, which are s |
| `HDP-02-FIG-2.1` | Figure 2.1 | `narrative` | Figure 2.1 on printed p. 20 is a plot of the Pois(10) probability mass function with an explanatory caption; it contains no proposition. |
| `HDP-02-FIG-2.2` | Figure 2.2 | `narrative` | Figure 2.2 on printed p. 21 depicts one sample from G(200, 1/40) with an explanatory caption; it contains no proposition. |
| `HDP-02-FIG-2.3` | Figure 2.3 | `narrative` | Figure 2.3 on printed p. 38 is a schematic of the two tail regimes in Bernstein's inequality with an explanatory caption; the quantitative content is Theorem 2.8.1 and HDP-02-BODY-2.8-NORMALIZED-REGIMES. |
| `HDP-02-BODY-2.9-BENNETT-REGIMES` | Section 2.9 body: asymptotics of Bennett's bound | `underspecified` | The commentary after Theorem 2.9.2 on printed p. 39 is asymptotic: it uses '~~' for h(u) ~~ u^2 and '<<' / '>>' regime markers with no stated thresholds, and its large-deviation condition is printed as 'u >> K t / sigma^ |
| `HDP-02-NOTES-2.9-BIBLIOGRAPHY` | Section 2.9 Notes bibliography | `narrative` | The Notes bibliography on printed pp. 39-40 attributes results to the literature and points to further reading; it states no mathematics of its own. |

## Standing open items

No row in this chapter is `WEAKENED` or `DISCREPANCY`, so there is no printed claim
recorded as unattained or refuted. The source-variance ledger is
[`source-variance.md`](source-variance.md).

## Verification commands and observed results

```
lake build NumStability.HDP                      -> Build completed successfully (3626 jobs)
grep -rnE '\bsorry\b|\badmit\b|^ *axiom |native_decide' NumStability/HDP/  -> no matches
#print axioms (all new declarations)             -> propext, Classical.choice, Quot.sound only
hdp_gate.py check gates/ch02.json --require-pass -> exit 1 (ACTIVE; work remains)
gate_regression.py                              -> 309 correct, 0 wrong
issue_tracker.py ... check                      -> PASS
git diff --check                                -> clean
```
