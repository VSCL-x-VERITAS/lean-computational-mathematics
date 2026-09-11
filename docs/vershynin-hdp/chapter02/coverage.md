# Vershynin HDP Chapter 2 coverage

Authoritative source: first-edition Chapter 2 PDF, SHA-256 `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`, printed pages 12-40 (29 rendered PDF pages).
Unit audit epoch: `hdp-unit-source-2026-08-26-v1`.
Book profile SHA-256: `149d6296e0b689d1302576850ec92668845ab257ab802d7b491881357d9abc50`.
Module audit epoch `hdp-module-audit-2026-09-08-workflow-v5.1.0-windows-r9-codex-only`, SHA-256 `8ec39961f05b90e014294a915f24fae4d28d7d3c26bb17f9a9ba7188b097e147`.
Preparation session: `codex-continue-2`.

The exhaustive machine-readable denominator is kept locally in the ignored
`gates/ch02.json` runtime file; tracked faithfulness outcomes are summarized in
[the September 2026 review](../../architecture/reviews/2026-09-faithfulness-outcomes.md).
This report was generated from gate SHA-256
`d99bbb7579361f8f9304b5ab582265841fd91095a753618bc06a9f6f8a747f7f` and
covers all 130 source rows under gate schema 2.

## Status legend

| Status | Meaning |
|---|---|
| `PROVED` | A Lean declaration states the printed row and has complete faithfulness evidence. |
| `REUSED` | Closed by an existing result plus a wrapper and strength/domain audit. |
| `DISCREPANCY` | The printed claim is refuted and paired with a formal witness and corrected result. |
| `READY` / `IN_PROGRESS` | Locally actionable proof, wrapper, audit, or organization work remains. |
| `HARD_BLOCKED` / `DEPENDENCY_BLOCKED` | A typed nonlocal obstruction remains; these statuses bar `PASS`. |
| `SKIPPED` | Narrative, empirical, machine-specific, or underspecified material with a fixed reason code. |
| `DEFERRED` | Work tracked to a named destination and reported outside the denominator. |

## Gate-derived progress

- Chapter verdict: **ACTIVE** (not `PASS`).
- Formalized objects: **87**.
- Remaining objects: **32**.
- Denominator: **119**. Percentage: **73.11%**.
- Reported separately and excluded from the denominator: **11** skipped, **0** deferred.
- Status counts: `HARD_BLOCKED`=3, `PROVED`=87, `READY`=29, `SKIPPED`=11.
- Semantic loop: 87 required, 87 direct, 87 blind, and 87 round-trip records; 0 unresolved adjudications.
- Organization loop: canonical_placement_pending=0, duplicate_wrappers=0, placeholder_findings=0, unclassified_modules=0.

Compilation alone does not count as coverage. A row becomes formalized only after its Lean declaration and its source-faithfulness evidence satisfy the gate.

## Formalized rows (87)

| Row | Printed label | Kind | Status | Primary Lean declaration |
|---|---|---|---|---|
| `HDP-02-BODY-2.1-SN-MOMENTS` | Section 2.1 body display: E S_N = N/2, Var(S_N) = N/4 | equation | `PROVED` | `NumStability.HDP.Contract.hdp_02_hbody_h2_d1_hsn_hmoments` |
| `HDP-02-EQ-2.1` | (2.1) | equation | `PROVED` | `NumStability.HDP.Contract.hdp_02_heq_h2_d1` |
| `HDP-02-BODY-2.1-ZN-IDENTITY` | Section 2.1 body: normalization identity inside (2.2) | equation | `PROVED` | `NumStability.HDP.Contract.hdp_02_hbody_h2_d1_hzn_hidentity` |
| `HDP-02-PROP-2.1.2` | Proposition 2.1.2 | proposition | `PROVED` | `NumStability.HDP.Contract.hdp_02_hprop_h2_d1_d2` |
| `HDP-02-EQ-2.3` | (2.3) | equation | `PROVED` | `NumStability.HDP.Contract.hdp_02_heq_h2_d3` |
| `HDP-02-BODY-2.1-BINOM-CENTRAL` | Section 2.1 body: P{S_N = N/2} = 2^{-N} binom(N, N/2) ~ 1/sqrt(N) | equation | `PROVED` | `NumStability.HDP.Contract.hdp_02_hbody_h2_d1_hbinom_hcentral` |
| `HDP-02-BODY-2.1-GAUSSIAN-ATOM` | Section 2.1 body: P{g = 0} = 0 | equation | `PROVED` | `NumStability.HDP.Contract.hdp_02_hbody_h2_d1_hgaussian_hatom` |
| `HDP-02-NOTATION-2.1-ASYMPTOTIC` | Section 2.1 footnote 1 | definition | `PROVED` | `NumStability.HDP.Contract.hdp_02_hnotation_h2_d1_hasymptotic` |
| `HDP-02-EX-2.1.4` | Exercise 2.1.4 | exercise | `PROVED` | `NumStability.HDP.Scalar.GaussianTails.integral_Ioi_sq_mul_exp_neg_sq_div_two` |
| `HDP-02-DEF-2.2.1` | Definition 2.2.1 | definition | `PROVED` | `NumStability.HDP.Contract.hdp_02_hdef_h2_d2_d1` |
| `HDP-02-BODY-2.2-BERNOULLI-SHIFT` | Section 2.2 body: X ~ Ber(1/2) iff Z = 2X - 1 is symmetric Bernoulli | equation | `PROVED` | `NumStability.HDP.Scalar.IndependentSums.Hoeffding.affineBernoulliIsRademacherIff` |
| `HDP-02-THM-2.2.2` | Theorem 2.2.2 | theorem | `PROVED` | `NumStability.HDP.Contract.hdp_02_hthm_h2_d2_d2` |
| `HDP-02-BODY-2.2-WLOG-NORM` | Theorem 2.2.2 proof body: WLOG \|\|a\|\|_2 = 1 | equation | `PROVED` | `NumStability.HDP.Contract.hdp_02_hbody_h2_d2_hwlog_hnorm` |
| `HDP-02-EQ-2.5` | (2.5) | equation | `PROVED` | `NumStability.HDP.Contract.hdp_02_heq_h2_d5` |
| `HDP-02-EQ-2.6` | (2.6) | equation | `PROVED` | `NumStability.HDP.Contract.hdp_02_hlem_hmgf_hindependent_hsum` |
| `HDP-02-BODY-2.2-COSH-MGF` | Section 2.2 body: E exp(lam a_i X_i) = cosh(lam a_i) | equation | `PROVED` | `NumStability.HDP.Contract.hdp_02_hbody_h2_d2_hcosh_hmgf` |
| `HDP-02-EX-2.2.3` | Exercise 2.2.3 | exercise | `PROVED` | `NumStability.HDP.Contract.hdp_02_hex_h2_d2_d3` |
| `HDP-02-BODY-2.2-COIN-BOUND` | Section 2.2 body: P{at least (3/4)N heads} <= exp(-N/8) | equation | `PROVED` | `NumStability.HDP.Contract.hdp_02_hbody_h2_d2_hcoin_hbound` |
| `HDP-02-BODY-2.2-TWO-SIDED-SPLIT` | Section 2.2 body: P{\|S\| >= t} = P{S >= t} + P{-S >= t} | equation | `PROVED` | `NumStability.HDP.Contract.hdp_02_hbody_h2_d2_htwo_hsided_hsplit` |
| `HDP-02-THM-2.2.5` | Theorem 2.2.5 | theorem | `PROVED` | `NumStability.HDP.Contract.hdp_02_hthm_h2_d2_d5_source` |
| `HDP-02-THM-2.2.6` | Theorem 2.2.6 | theorem | `PROVED` | `NumStability.HDP.Contract.hdp_02_hthm_h2_d2_d6_source` |
| `HDP-02-EX-2.2.7` | Exercise 2.2.7 | exercise | `PROVED` | `NumStability.HDP.Contract.hdp_02_hex_h2_d2_d7_source` |
| `HDP-02-EX-2.2.8` | Exercise 2.2.8 | exercise | `PROVED` | `NumStability.HDP.Contract.hdp_02_hex_h2_d2_d8` |
| `HDP-02-EX-2.2.9A` | Exercise 2.2.9(a) | exercise | `PROVED` | `NumStability.HDP.Contract.hdp_02_hex_h2_d2_d9a` |
| `HDP-02-EX-2.2.9B` | Exercise 2.2.9(b) | exercise | `PROVED` | `NumStability.HDP.Contract.hdp_02_hex_h2_d2_d9b` |
| `HDP-02-EX-2.2.10A` | Exercise 2.2.10(a) | exercise | `PROVED` | `NumStability.HDP.Contract.hdp_02_hex_h2_d2_d10a` |
| `HDP-02-EX-2.2.10B` | Exercise 2.2.10(b) | exercise | `PROVED` | `NumStability.HDP.Contract.hdp_02_hex_h2_d2_d10b` |
| `HDP-02-THM-2.3.1` | Theorem 2.3.1 | theorem | `PROVED` | `NumStability.HDP.Contract.hdp_02_hthm_h2_d3_d1_source` |
| `HDP-02-EQ-2.7` | (2.7) | equation | `PROVED` | `NumStability.HDP.Contract.hdp_02_heq_h2_d7` |
| `HDP-02-BODY-2.3-BERNOULLI-MGF` | Section 2.3 body: Bernoulli MGF bound | equation | `PROVED` | `NumStability.HDP.Contract.hdp_02_hlem_hbernoulli_hmgf_hbound_scalar` |
| `HDP-02-BODY-2.3-ONE-PLUS-X` | Section 2.3 body: 1 + x <= e^x | equation | `PROVED` | `NumStability.HDP.Contract.hdp_02_hbody_h2_d3_hone_hplus_hx` |
| `HDP-02-EX-2.3.3` | Exercise 2.3.3 | exercise | `PROVED` | `NumStability.HDP.Contract.hdp_02_hex_h2_d3_d3` |
| `HDP-02-EQ-2.8` | (2.8) | equation | `PROVED` | `NumStability.HDP.Contract.hdp_02_heq_h2_d8` |
| `HDP-02-REM-2.3.4` | Remark 2.3.4 | remark | `PROVED` | `NumStability.HDP.Contract.hdp_02_hrem_h2_d3_d4` |
| `HDP-02-EX-2.3.5` | Exercise 2.3.5 | exercise | `PROVED` | `NumStability.HDP.Contract.hdp_02_hex_h2_d3_d5` |
| `HDP-02-EX-2.3.6` | Exercise 2.3.6 | exercise | `PROVED` | `NumStability.HDP.Contract.hdp_02_hex_h2_d3_d6` |
| `HDP-02-DEF-2.4-ERDOS-RENYI` | Section 2.4 body definition: Erdos-Renyi model G(n,p) | definition | `PROVED` | `NumStability.HDP.Contract.hdp_02_hdef_herdos_hrenyi` |
| `HDP-02-BODY-2.4-EXPECTED-DEGREE` | Section 2.4 body: expected degree (n-1)p =: d | equation | `PROVED` | `NumStability.HDP.Contract.hdp_02_hbody_h2_d4_hexpected_hdegree` |
| `HDP-02-PROP-2.4.1` | Proposition 2.4.1 | proposition | `PROVED` | `NumStability.HDP.Contract.hdp_02_hprop_h2_d4_d1` |
| `HDP-02-BODY-2.4-DEGREE-CHERNOFF` | Proposition 2.4.1 proof body: P{\|d_i - d\| >= 0.1 d} <= 2 e^{-c d} | equation | `PROVED` | `NumStability.HDP.Contract.hdp_02_hbody_h2_d4_hdegree_hchernoff` |
| `HDP-02-BODY-2.4-UNION-BOUND` | Proposition 2.4.1 proof body: union bound over vertices | equation | `PROVED` | `NumStability.HDP.Contract.hdp_02_hbody_h2_d4_hunion_hbound` |
| `HDP-02-EX-2.4.2` | Exercise 2.4.2 | exercise | `PROVED` | `NumStability.HDP.Contract.hdp_02_hex_h2_d4_d2` |
| `HDP-02-EX-2.4.3` | Exercise 2.4.3 | exercise | `PROVED` | `NumStability.HDP.Contract.hdp_02_hex_h2_d4_d3` |
| `HDP-02-EQ-2.10` | (2.10) | equation | `PROVED` | `NumStability.HDP.Contract.hdp_02_heq_h2_d10` |
| `HDP-02-EX-2.5.1` | Exercise 2.5.1 | exercise | `PROVED` | `NumStability.HDP.Contract.hdp_02_hex_h2_d5_d1` |
| `HDP-02-EQ-2.11` | (2.11) | equation | `PROVED` | `NumStability.HDP.Scalar.SubGaussian.standardNormalLpNormGrowth` |
| `HDP-02-EQ-2.12` | (2.12) | equation | `PROVED` | `NumStability.HDP.Contract.hdp_02_heq_h2_d12` |
| `HDP-02-PROP-2.5.2` | Proposition 2.5.2 | proposition | `PROVED` | `NumStability.HDP.Contract.hdp_02_hprop_h2_d5_d2` |
| `HDP-02-REM-2.5.3` | Remark 2.5.3 | remark | `PROVED` | `NumStability.HDP.Contract.hdp_02_hrem_h2_d5_d3` |
| `HDP-02-EX-2.5.4` | Exercise 2.5.4 | exercise | `PROVED` | `NumStability.HDP.Scalar.SubGaussian.mgfBoundForcesMeanZero` |
| `HDP-02-EX-2.5.5A` | Exercise 2.5.5(a) | exercise | `PROVED` | `NumStability.HDP.Contract.hdp_02_hex_h2_d5_d5a` |
| `HDP-02-EX-2.5.5B` | Exercise 2.5.5(b) | exercise | `PROVED` | `NumStability.HDP.Scalar.SubGaussian.squareMGFGlobalTailZero` |
| `HDP-02-DEF-2.5.6` | Definition 2.5.6 | definition | `PROVED` | `NumStability.HDP.Contract.hdp_02_hdef_h2_d5_d6` |
| `HDP-02-EQ-2.13` | (2.13) | equation | `PROVED` | `NumStability.HDP.Scalar.SubGaussian.psiTwoNorm_eq_sInf` |
| `HDP-02-EX-2.5.7` | Exercise 2.5.7 | exercise | `PROVED` | `NumStability.HDP.Contract.hdp_02_hex_h2_d5_d7` |
| `HDP-02-EQ-2.14` | (2.14) | equation | `PROVED` | `NumStability.HDP.Scalar.SubGaussian.psiTwoGaugeToTail` |
| `HDP-02-EQ-2.15` | (2.15) | equation | `PROVED` | `NumStability.HDP.Scalar.SubGaussian.psiTwoGaugeToLpMomentGrowth` |
| `HDP-02-EQ-2.16` | (2.16) | equation | `PROVED` | `NumStability.HDP.Scalar.SubGaussian.psiTwoGaugeToMGF` |
| `HDP-02-EXAMPLE-2.5.8A` | Example 2.5.8(a) | example | `PROVED` | `NumStability.HDP.Contract.hdp_02_hexample_h2_d5_d8a` |
| `HDP-02-EXAMPLE-2.5.8B` | Example 2.5.8(b) | example | `PROVED` | `NumStability.HDP.Contract.hdp_02_hexample_h2_d5_d8b` |
| `HDP-02-EXAMPLE-2.5.8C` | Example 2.5.8(c) | example | `PROVED` | `NumStability.HDP.Contract.hdp_02_hexample_h2_d5_d8c` |
| `HDP-02-EQ-2.17` | (2.17) | equation | `PROVED` | `NumStability.HDP.Scalar.SubGaussian.essentiallyBoundedPsiTwoGauge` |
| `HDP-02-EX-2.5.9` | Exercise 2.5.9 | exercise | `PROVED` | `NumStability.HDP.Contract.hdp_02_hex_h2_d5_d9` |
| `HDP-02-EQ-2.18` | (2.18) | equation | `PROVED` | `NumStability.HDP.Contract.hdp_02_heq_h2_d18` |
| `HDP-02-PROP-2.6.1` | Proposition 2.6.1 | proposition | `PROVED` | `NumStability.HDP.Contract.hdp_02_hprop_h2_d6_d1` |
| `HDP-02-THM-2.6.2` | Theorem 2.6.2 | theorem | `PROVED` | `NumStability.HDP.Contract.hdp_02_hthm_h2_d6_d2` |
| `HDP-02-THM-2.6.3` | Theorem 2.6.3 | theorem | `PROVED` | `NumStability.HDP.Contract.hdp_02_hthm_h2_d6_d3` |
| `HDP-02-EQ-2.19` | (2.19) | equation | `PROVED` | `NumStability.HDP.Contract.hdp_02_heq_h2_d19` |
| `HDP-02-LEM-2.6.8` | Lemma 2.6.8 | lemma | `PROVED` | `NumStability.HDP.Contract.hdp_02_hlem_h2_d6_d8_exact` |
| `HDP-02-EQ-2.20` | (2.20) | equation | `PROVED` | `NumStability.HDP.Contract.hdp_02_heq_h2_d20` |
| `HDP-02-BODY-2.6-CONSTANT-PSI2` | Lemma 2.6.8 proof body: \|\|a\|\|_{psi_2} <~ \|a\| for constant a | equation | `PROVED` | `NumStability.HDP.Contract.hdp_02_hbody_h2_d6_hconstant_hpsi2` |
| `HDP-02-EX-2.6.9` | Exercise 2.6.9 | exercise | `PROVED` | `NumStability.HDP.Contract.hdp_02_hex_h2_d6_d9_exact` |
| `HDP-02-BODY-2.7-GAUSSIAN-SQUARE-TAIL` | Section 2.7 body: tails of g_i^2 are exponential | equation | `PROVED` | `NumStability.HDP.Contract.hdp_02_hbody_h2_d7_hgaussian_hsquare_htail` |
| `HDP-02-PROP-2.7.1` | Proposition 2.7.1 | proposition | `PROVED` | `NumStability.HDP.Contract.hdp_02_hprop_h2_d7_d1_exact` |
| `HDP-02-EX-2.7.2` | Exercise 2.7.2 | exercise | `PROVED` | `NumStability.HDP.Contract.hdp_02_hex_h2_d7_d2_exact` |
| `HDP-02-EX-2.7.3` | Exercise 2.7.3 | exercise | `PROVED` | `NumStability.HDP.Contract.hdp_02_hex_h2_d7_d3_exact` |
| `HDP-02-EX-2.7.4` | Exercise 2.7.4 | exercise | `PROVED` | `NumStability.HDP.Contract.hdp_02_hex_h2_d7_d4_exact` |
| `HDP-02-DEF-2.7.5` | Definition 2.7.5 | definition | `PROVED` | `NumStability.HDP.Contract.hdp_02_hdef_h2_d7_d5_exact` |
| `HDP-02-EQ-2.21` | (2.21) | equation | `PROVED` | `NumStability.HDP.Contract.hdp_02_heq_h2_d21_exact` |
| `HDP-02-BODY-2.7-SG-IMPLIES-SE` | Section 2.7 body: any sub-gaussian distribution is sub-exponential | equation | `PROVED` | `NumStability.HDP.Contract.hdp_02_hbody_h2_d7_hsg_himplies_hse_exact` |
| `HDP-02-LEM-2.7.6` | Lemma 2.7.6 | lemma | `PROVED` | `NumStability.HDP.Contract.hdp_02_hlem_h2_d7_d6_exact` |
| `HDP-02-LEM-2.7.7` | Lemma 2.7.7 | lemma | `PROVED` | `NumStability.HDP.Contract.hdp_02_hlem_h2_d7_d7_exact` |
| `HDP-02-EQ-2.22` | (2.22) | equation | `PROVED` | `NumStability.HDP.Contract.hdp_02_heq_h2_d22_exact` |
| `HDP-02-BODY-2.7-YOUNG` | Lemma 2.7.7 proof body: Young's inequality | equation | `PROVED` | `NumStability.HDP.Contract.hdp_02_hbody_h2_d7_hyoung_exact` |
| `HDP-02-REM-2.7.14` | Remark 2.7.14 | remark | `PROVED` | `NumStability.HDP.Contract.hdp_02_hrem_h2_d7_d14_exact` |
| `HDP-02-EQ-2.23` | (2.23) | equation | `PROVED` | `NumStability.HDP.Contract.hdp_02_heq_h2_d23` |
| `HDP-02-EX-2.8.5` | Exercise 2.8.5 | exercise | `PROVED` | `NumStability.HDP.Contract.hdp_02_hex_h2_d8_d5` |

## Locally actionable rows (29)

| Row | Printed label | Kind | Next foundation (abridged) |
|---|---|---|---|
| `HDP-02-THM-2.1.3` | Theorem 2.1.3 | theorem | The deleted-center one-sided limits are now exactly `-1` and `1`, and every plain off-diagonal two-increment variation bound has coefficient at least two. The smallest remaining foundation is a signed two-law estimate that retains cancellation between the off-diagonal kernel expectation difference and its midpoint-CDF… |
| `HDP-02-EX-2.3.8` | Exercise 2.3.8 | exercise | Needs a central limit theorem for i.i.d. square-integrable variables. The hint's route is: write `Pois(lambda)` for integer `lambda` as a sum of `lambda` i.i.d. `Pois(1)` variables via `poissonAddLaw`, then apply the CLT and extend to real `lambda` by monotonicity. The smallest missing foundation is the i.i.d. CLT its… |
| `HDP-02-EX-2.4.4` | Exercise 2.4.4 | exercise | The hint's route needs a second-moment/independence trick: replace the dependent degrees `d_i` by independent `d'_i` built from a vertex subset, then apply the Poisson approximation (2.9). The smallest missing foundation is a formal statement of that decoupling, i.e. that the degrees restricted to a set of `n/2` verti… |
| `HDP-02-EX-2.4.5` | Exercise 2.4.5 | exercise | Needs HDP-02-EX-2.4.4's decoupling lemma, then the `log n / log log n` calculation matching `erdosRenyiVerySparseMaxDegreeLogLogBound` from below. |
| `HDP-02-EX-2.5.10A` | Exercise 2.5.10 (first claim) | exercise | Follow the hint: normalize `Y_i = X_i/(C K sqrt(1 + log i))`, use the sub-gaussian tail (2.14) with a union bound to get `P{exists i, \|Y_i\| >= t} <~ exp(-t^2)` for `t >= 1`, then integrate the tail via the layer-cake formula `NumStability.HDP.Scalar.Preliminaries.momentTailFormula`, splitting the integral over [0,1]… |
| `HDP-02-EX-2.5.10B` | Exercise 2.5.10 (second claim) | exercise | Specialize HDP-02-EX-2.5.10A to `i <= N` and absorb `sqrt(1 + log N)` into `C sqrt(log N)` for `N >= 2`. |
| `HDP-02-EX-2.5.11` | Exercise 2.5.11 | exercise | Prove `E max_{i <= N} g_i >= c sqrt(log N)` for i.i.d. standard Gaussians. The standard route needs a Gaussian tail LOWER bound (the left half of Proposition 2.1.2) plus independence: `P{max < t} = P{g < t}^N`. The smallest missing foundation is HDP-02-PROP-2.1.2's lower bound. |
| `HDP-02-EX-2.6.4` | Exercise 2.6.4 | exercise | Give the deduction the exercise asks for: from a bounded variable `X_i` in `[m_i, M_i]`, produce a psi-2/linear-MGF parameter proportional to `M_i - m_i` (via `essentiallyBoundedPsiTwoGauge` after centering), then apply `independentWeightedCenteredSubGaussianTail`. The smallest missing foundation is a quantitative `bo… |
| `HDP-02-EX-2.6.5` | Exercise 2.6.5 | exercise | Prove both halves for `p in [2, infinity)`: the lower bound `(sum a_i^2)^{1/2} <= \|\|sum a_i X_i\|\|_{L^p}` from `\|\|.\|\|_{L^2} <= \|\|.\|\|_{L^p}` plus the unit-variance independence identity `E (sum a_i X_i)^2 = sum a_i^2`; the upper bound from the psi-2 moment comparison (2.15) applied to the sum, using `indepen… |
| `HDP-02-EX-2.6.6` | Exercise 2.6.6 | exercise | Apply `lpExtrapolation` to `Z = sum a_i X_i` and feed it the `p = 3` Khintchine upper bound from HDP-02-EX-2.6.5; the upper half `\|\|Z\|\|_{L^1} <= (sum a_i^2)^{1/2}` follows from `\|\|.\|\|_{L^1} <= \|\|.\|\|_{L^2}` and the variance identity. |
| `HDP-02-EX-2.6.7` | Exercise 2.6.7 | exercise | State the `p in (0,2)` two-sided form with a `c(K, p)` lower constant and prove it by modifying the extrapolation exponents; needs HDP-02-EX-2.6.5 first. Record the chosen statement as a formalizer-supplied target, since the source does not print one. |
| `HDP-02-EXAMPLE-2.7.8` | Example 2.7.8 | example | Needs HDP-02-DEF-2.7.5 for the psi-1 half. The mean and variance halves are available from `Mathlib.Probability.Distributions.Exponential` and can be closed independently; the row should therefore be split into a moments part (ready now) and a psi-1 part (blocked on the gauge). |
| `HDP-02-REM-2.7.9` | Remark 2.7.9 | remark | Preserve the `current-v5` prepared audit as immutable checkpoint evidence. On the topology-selected current lane, create a newly named exact-task config and task bound to that lane and the current source package, then re-prepare it. Reuse the checkpoint source-contract and blind-translation outputs only if the kit pro… |
| `HDP-02-EX-2.7.10` | Exercise 2.7.10 | exercise | Needs HDP-02-DEF-2.7.5. Then transcribe the psi-2 proof `SubGaussian.centeredSubGaussian`: triangle inequality for the gauge, plus `\|\|E X\|\|_{psi_1} <~ \|E X\| <= E\|X\| <~ \|\|X\|\|_{psi_1}` using the property-(b) moment bound at `p = 1`. |
| `HDP-02-DEF-2.7-ORLICZ-FUNCTION` | Section 2.7.1 body definition: Orlicz function | definition | Create `audits/vershynin-hdp/chapter02/<row-id>/audit-task.json` bound to the printed locator, add the row to a source group, then run the kit's batch schedule (batch source contract, blind translator, direct judge, round-trip judge) and record the four results plus `contract_hash` on this row. |
| `HDP-02-DEF-2.7-ORLICZ-NORM-SPACE` | Section 2.7.1 body definition: Orlicz norm and Orlicz space | definition | Create `audits/vershynin-hdp/chapter02/<row-id>/audit-task.json` bound to the printed locator, add the row to a source group, then run the kit's batch schedule (batch source contract, blind translator, direct judge, round-trip judge) and record the four results plus `contract_hash` on this row. |
| `HDP-02-EX-2.7.11` | Exercise 2.7.11 | exercise | Create `audits/vershynin-hdp/chapter02/<row-id>/audit-task.json` bound to the printed locator, add the row to a source group, then run the kit's batch schedule (batch source contract, blind translator, direct judge, round-trip judge) and record the four results plus `contract_hash` on this row. |
| `HDP-02-BODY-2.7-ORLICZ-BANACH` | Section 2.7.1 body: L_psi is complete, hence a Banach space | equation | Prove that the Orlicz gauge quotient is complete. The smallest missing foundation is a Fatou-type lower semicontinuity lemma for the Orlicz gauge under a.e. convergence, from which completeness follows by the standard absolutely-convergent-series criterion (`Mathlib.Analysis.Normed.Group.Completeness`). |
| `HDP-02-EXAMPLE-2.7.12` | Example 2.7.12 | example | Create `audits/vershynin-hdp/chapter02/<row-id>/audit-task.json` bound to the printed locator, add the row to a source group, then run the kit's batch schedule (batch source contract, blind translator, direct judge, round-trip judge) and record the four results plus `contract_hash` on this row. |
| `HDP-02-EXAMPLE-2.7.13` | Example 2.7.13 | example | Create `audits/vershynin-hdp/chapter02/<row-id>/audit-task.json` bound to the printed locator, add the row to a source group, then run the kit's batch schedule (batch source contract, blind translator, direct judge, round-trip judge) and record the four results plus `contract_hash` on this row. |
| `HDP-02-THM-2.8.1` | Theorem 2.8.1 | theorem | The proof repair and complete audit are finished. The smallest remaining foundation is a module-level source policy or a separately audited nondegenerate/corrected contract for the printed all-zero denominator boundary. Do not reintroduce the source-absent positive-energy premise into the printed alias; keep this row… |
| `HDP-02-EQ-2.24` | (2.24) | equation | The quantitative wrapper, full build, and complete audit are finished. Keep the row READY until a certified module policy resolves whether the immutable source's undefined `c / 0` excludes the all-zero family or denotes an unbounded lambda window; do not silently choose either convention. |
| `HDP-02-THM-2.8.2` | Theorem 2.8.2 | theorem | The proof repair and complete semantic audit are finished. The smallest remaining foundation is a module-level source policy, or a separately audited corrected/nondegenerate contract, for source statements whose displayed real quotients have zero denominators; do not reintroduce source-absent positivity premises into… |
| `HDP-02-COR-2.8.3` | Corollary 2.8.3 | corollary | The proof repair and complete semantic audit are finished. The smallest remaining foundation is a module-level source policy, or a separately audited corrected/nondegenerate contract, for source statements whose displayed real quotients have zero denominators; do not reintroduce a source-absent `K > 0` premise into th… |
| `HDP-02-BODY-2.8-NORMALIZED-REGIMES` | Section 2.8 body: normalized two-regime bound | equation | The exact normalized `min` bound and the mathematically valid two-regime correction now compile. The smallest remaining foundation is a hash-bound discrepancy/adjudication contract for the literal printed large-deviation branch `2 exp(-t sqrt N)`, which omits the necessary K-dependent positive coefficient; do not alia… |
| `HDP-02-THM-2.8.4` | Theorem 2.8.4 | theorem | The proof and complete audit are finished. The smallest remaining foundation is a module-level source policy or separately audited corrected/nondegenerate contract for the printed `0/0` boundary at `t = 0` and zero total second moment. Keep this row READY until that source ambiguity is resolved under certified policy. |
| `HDP-02-EX-2.8.6` | Exercise 2.8.6 | exercise | The proof and complete audit are finished. The smallest remaining foundation is a module-level source policy or separately audited corrected/nondegenerate contract for the printed `0/0` boundary at `t = 0` and zero total second moment. Do not reintroduce the source-absent positive-variance premise into the printed ali… |
| `HDP-02-THM-2.9.1` | Theorem 2.9.1 | theorem | Prove it by the martingale/Doob route the Notes describe ('by the same general method as Hoeffding's inequality, namely by bounding the moment generating function'). The smallest missing foundation is a Doob martingale construction for a function of independent coordinates together with Azuma-Hoeffding for bounded inc… |
| `HDP-02-THM-2.9.2` | Theorem 2.9.2 | theorem | Prove it by the same MGF route as Theorem 2.3.1, using the exact bounded-variable MGF bound `E exp(lambda X) <= exp(sigma^2 (e^{lambda K} - 1 - lambda K)/K^2)` and then optimizing to produce `h(u) = (1+u) log(1+u) - u`. The smallest missing foundation is that per-term MGF bound; `boundedCenteredMGFBound` proves a weak… |

## Typed blocked rows (3)

| Row | Printed label | Blocker kind | Obstruction (abridged) | Resume condition (abridged) |
|---|---|---|---|---|
| `HDP-02-EX-2.3.2` | Exercise 2.3.2 | `material-user-choice` | The immutable first-edition exercise quantifies only `t < mu`, but its displayed real quotient and real power have no source-stated meaning for negative `t`; selecting a totalized or corrected domain is a module-level source-policy choice, not a theorem proof. | An operator-approved module policy must either interpret Exercise 2.3.2 on the standard domain `0 < t < mu`, specify semantics for the printed negative-base real power, or authorize a distinct correction/discrepancy treatment for this exercise. |
| `HDP-02-BODY-2.5-PSI2-SQUARE-POINT` | Section 2.5 body display: E exp(X^2/\|\|X\|\|_{psi_2}^2) <= 2 | `material-user-choice` | The immutable source universally displays `E exp(X^2 / \|\|X\|\|_{psi_2}^2) <= 2`, yet the zero random variable has gauge zero and the book specifies no meaning for its `0/0` quotient. Lean's total real division gives the constant-one integrand, but selecting that convention as the book policy is not a theorem proof. | An operator-approved module policy must either accept Lean's total-real-division interpretation at zero gauge, restrict this display to positive gauge while separately treating the zero random variable, or authorize a distinct corrected/discrepancy contract. |
| `HDP-02-BODY-2.5-PSI2-MINIMALITY` | Section 2.5 body: psi_2 norm is the smallest such number | `material-user-choice` | The source's minimality sentence incorporates quotient-bearing displays at `\|\|X\|\|_{psi_2} = 0` without defining their `0/0` meaning. The Lean wrapper admits zero gauge and totalizes real division, so certifying the global Lean-to-source implication requires an authoritative convention that cannot be proved locally. | An operator-approved module policy must accept Lean's total-real-division interpretation at zero gauge, restrict the quotient displays and minimality wrapper to positive gauge while separately handling the zero variable, or authorize a distinct corrected/discrepancy contract. |

## Skipped rows (11)

| Row | Printed label | Reason code | Reason |
|---|---|---|---|
| `HDP-02-QUESTION-2.1.1` | Question 2.1.1 | `narrative` | Question 2.1.1 poses the motivating coin-tossing question (printed p. 12); it asserts nothing. Its quantitative content is carried by the separate rows HDP-02-BODY-2.1-SN-MOMENTS and HDP-02-EQ-2.1. |
| `HDP-02-EQ-2.2` | (2.2) | `underspecified` | The operative content of display (2.2) on printed p. 13 is the central-limit approximation sign in P{Z_N >= sqrt(N/4)} ~~ P{g >= sqrt(N/4)}, which carries no quantitative meaning at fixed N; the text itself says on p. 14 that '(2.4) does not follow rigorously from the central limit theorem'. The exact half of the disp… |
| `HDP-02-EQ-2.4` | (2.4) | `narrative` | Display (2.4) on printed p. 14 states what 'we should expect' the coin-tossing probability to be smaller than, and the surrounding text immediately explains that it does not follow rigorously. It is an expectation, not a claim; the proved bound is HDP-02-BODY-2.2-COIN-BOUND. |
| `HDP-02-REM-2.2.4` | Remark 2.2.4 | `narrative` | Remark 2.2.4 on printed p. 17 contrasts the non-asymptotic character of Hoeffding's inequality with classical limit theorems and comments on its attractiveness in data science. It states no mathematical proposition beyond Theorem 2.2.2, which already quantifies over all fixed N. |
| `HDP-02-EQ-2.9` | (2.9) | `underspecified` | Display (2.9) on printed p. 19 is a Stirling-based approximation written with '~~' for the Poisson probability mass function, with no stated error control. The sharpness discussion it supports is HDP-02-REM-2.3.4, whose formalizable content (asymptotic equivalence of the Poisson point mass to the Stirling expression)… |
| `HDP-02-REM-2.3.7` | Remark 2.3.7 | `narrative` | Remark 2.3.7 on printed p. 20 describes, in words and by reference to Figure 2.1, the two tail regimes of the Poisson distribution. The two quantitative statements it summarizes are Exercises 2.3.3 and 2.3.6, which are separate rows. |
| `HDP-02-FIG-2.1` | Figure 2.1 | `narrative` | Figure 2.1 on printed p. 20 is a plot of the Pois(10) probability mass function with an explanatory caption; it contains no proposition. |
| `HDP-02-FIG-2.2` | Figure 2.2 | `narrative` | Figure 2.2 on printed p. 21 depicts one sample from G(200, 1/40) with an explanatory caption; it contains no proposition. |
| `HDP-02-FIG-2.3` | Figure 2.3 | `narrative` | Figure 2.3 on printed p. 38 is a schematic of the two tail regimes in Bernstein's inequality with an explanatory caption; the quantitative content is Theorem 2.8.1 and HDP-02-BODY-2.8-NORMALIZED-REGIMES. |
| `HDP-02-BODY-2.9-BENNETT-REGIMES` | Section 2.9 body: asymptotics of Bennett's bound | `underspecified` | The commentary after Theorem 2.9.2 on printed p. 39 is asymptotic: it uses '~~' for h(u) ~~ u^2 and '<<' / '>>' regime markers with no stated thresholds, and its large-deviation condition is printed as 'u >> K t / sigma^2 >= 2' although u is defined as K t / sigma^2 (recorded as VHDP-C02-N004). No quantitative claim i… |
| `HDP-02-NOTES-2.9-BIBLIOGRAPHY` | Section 2.9 Notes bibliography | `narrative` | The Notes bibliography on printed pp. 39-40 attributes results to the literature and points to further reading; it states no mathematics of its own. |

## Standing open items

No row is `WEAKENED` or `DISCREPANCY`; no printed claim is currently recorded as unattained or refuted. See [`source-variance.md`](source-variance.md).

## Verification contract

```console
python3 .../module/scripts/hdp_gate.py check gates/ch02.json
python3 .../skills/book-formalization/scripts/issue_tracker.py ... check
git diff --check
```

The first command must report `ACTIVE` with 87 formalized, 32 remaining, denominator 119, 73.11%, 11 skipped, and 0 deferred. `--require-pass` is intentionally not used during continuation because formalization remains incomplete.
