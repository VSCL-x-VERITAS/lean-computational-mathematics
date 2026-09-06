import Mathlib.Probability.Independence.Integration
import Mathlib.Probability.Moments.Basic
import Mathlib.Probability.Moments.IntegrableExpMul
import Mathlib.Analysis.Complex.ExponentialBounds
import Mathlib.Tactic
import ComputationalMathematics.HDP.Scalar.SubExponential

/-!
# Bernstein's inequality for sums of independent sub-exponential variables

Reusable development of Vershynin, *High-Dimensional Probability* (first
edition, 2018), Section 2.8, printed pages 36--38.

The section's mechanism is the same moment-generating-function argument used for
Hoeffding's and Chernoff's inequalities, but the MGF bound for a sub-exponential
variable is available only on a *window* around the origin — property (e) of
Proposition 2.7.1.  Optimizing `exp (-λ t + C λ² σ²)` subject to that window
constraint is what produces the two tail regimes: the sub-gaussian regime, where
the unconstrained optimum is admissible, and the sub-exponential regime, where
the window boundary is active.

## Main definitions

* `SubExponentialLinearMGF` — property (e) of Proposition 2.7.1: a centered
  variable whose MGF obeys `E exp (λ X) ≤ exp (K² λ²)` on `|λ| ≤ 1 / K`.

## Main results

* `momentToLinearMGF` — property (b) of Proposition 2.7.1 implies property (e).
* `localMGFToTail` — the constrained optimization producing the two regimes.
* `independentSubExponentialSumMGF` — the window MGF bound tensorizes.
* `bernsteinTail` — Theorem 2.8.1.
* `bernsteinWeightedTail` — Theorem 2.8.2.
* `bernsteinAverageTail` — Corollary 2.8.3.
* `boundedCenteredMGFBound` — Exercise 2.8.5.
* `bernsteinBoundedTail` — Theorem 2.8.4, deduced as Exercise 2.8.6 directs.

As elsewhere in this lane, the source's `‖X‖_{ψ₁}` scale is represented by a
positive window/MGF parameter `K`; `momentToLinearMGF` is the bridge that
produces such a `K` from the printed sub-exponential moment growth, at the cost
of an absolute constant factor, exactly as Proposition 2.7.1 allows.

No numbered-source wrapper is imported; this is reusable mathematics.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators ENNReal NNReal

namespace NumStability.HDP.Scalar.IndependentSums.Bernstein

open NumStability.HDP.Scalar.SubExponential

/-- Property (e) of Proposition 2.7.1 (printed page 32): a centered random
variable whose moment generating function satisfies a sub-gaussian-shaped bound
on the window `|λ| ≤ 1 / K` only.

The window is essential and is what distinguishes this from the sub-gaussian
`SubGaussianLinearMGF`, where the same bound holds for every real `λ`.  Remark
2.7.9 (printed page 34) explains why the two bounds agree near the origin and
why no global bound can exist here: for `X ~ Exp 1` the MGF is infinite for
`λ ≥ 1`. -/
def SubExponentialLinearMGF {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) (K : ℝ) : Prop :=
  Measurable X ∧ 0 < K ∧ Integrable X μ ∧
    (∫ ω, X ω ∂μ) = 0 ∧
      ∀ lam : ℝ, |lam| ≤ K⁻¹ →
        Integrable (fun ω => Real.exp (lam * X ω)) μ ∧
          (∫ ω, Real.exp (lam * X ω) ∂μ) ≤ Real.exp (K ^ 2 * lam ^ 2)

/-- Proposition 2.7.1, b ⇒ e, in the scale-explicit form this section needs.

The printed proof (printed pages 32--33) produces property (e) with
`K₅ = 2e` after normalizing `K₂ = 1`; here the same content is obtained from
`momentToMGF`, whose window is `|λ| ≤ (4e K)⁻¹`, so the resulting window
parameter is `4e K`. -/
theorem momentToLinearMGF
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ} (hX : Measurable X) (hK : 0 < K)
    (hCenter : Integrable X μ ∧ (∫ ω, X ω ∂μ) = 0)
    (hLp : LpMomentGrowth μ X K) :
    SubExponentialLinearMGF μ X (4 * Real.exp 1 * K) := by
  have he : (0 : ℝ) < Real.exp 1 := Real.exp_pos 1
  have hK' : 0 < 4 * Real.exp 1 * K := by positivity
  refine ⟨hX, hK', hCenter.1, hCenter.2, ?_⟩
  intro lam hlam
  have hsmall : |lam| ≤ (4 * Real.exp 1 * K)⁻¹ := hlam
  obtain ⟨hInt, hBound⟩ := momentToMGF hK hCenter hLp lam hsmall
  refine ⟨hInt, hBound.trans ?_⟩
  apply Real.exp_le_exp.2
  have h2 : 2 * (Real.exp 1 * (lam * K)) ^ 2 = 2 * (Real.exp 1) ^ 2 * K ^ 2 * lam ^ 2 := by
    ring
  have h4 : (4 * Real.exp 1 * K) ^ 2 * lam ^ 2
      = 16 * (Real.exp 1) ^ 2 * K ^ 2 * lam ^ 2 := by ring
  rw [h2, h4]
  have hbase : 0 ≤ (Real.exp 1) ^ 2 * K ^ 2 * lam ^ 2 := by positivity
  nlinarith [hbase]

/-- The one-sided constrained optimization behind Theorem 2.8.1.

Given a window MGF bound `E exp (λ X) ≤ exp (v λ²)` valid for `|λ| ≤ 1 / M`,
minimizing `exp (-λ t + v λ²)` over that window yields the two printed regimes:
the unconstrained optimum `λ = t / (2v)` when it is admissible, and the boundary
`λ = 1 / M` otherwise. -/
private theorem localMGFOneSided
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {v M : ℝ}
    (hX : Measurable X) (hv : 0 < v) (hM : 0 < M)
    (hMGF : ∀ lam : ℝ, |lam| ≤ M⁻¹ →
      Integrable (fun ω => Real.exp (lam * X ω)) μ ∧
        (∫ ω, Real.exp (lam * X ω) ∂μ) ≤ Real.exp (v * lam ^ 2))
    {t : ℝ} (ht : 0 < t) :
    μ.real {ω | X ω ≥ t} ≤
      Real.exp (-min (t ^ 2 / (4 * v)) (t / (2 * M))) := by
  set lam : ℝ := min (t / (2 * v)) M⁻¹ with hlamdef
  have hMinv : 0 < M⁻¹ := inv_pos.mpr hM
  have hquot : 0 < t / (2 * v) := by positivity
  have hlampos : 0 < lam := lt_min hquot hMinv
  have hlamle : lam ≤ M⁻¹ := min_le_right _ _
  have hlamabs : |lam| ≤ M⁻¹ := by
    rw [abs_of_pos hlampos]; exact hlamle
  obtain ⟨hInt, hBound⟩ := hMGF lam hlamabs
  -- Markov in the exponentiated variable.
  let Y : Ω → ℝ := fun ω => Real.exp (lam * X ω)
  have hY : Measurable Y := by simpa [Y] using (hX.const_mul lam).exp
  have hmarkov :=
    NumStability.HDP.Scalar.Preliminaries.markovInequalityFinite hY
      (Filter.Eventually.of_forall (fun ω => le_of_lt (Real.exp_pos _)))
      hInt (Real.exp_pos (lam * t))
  have hsubset : {ω | X ω ≥ t} ⊆ Y ⁻¹' Set.Ici (Real.exp (lam * t)) := by
    intro ω hω
    change Real.exp (lam * t) ≤ Real.exp (lam * X ω)
    exact (Real.exp_le_exp).2 (mul_le_mul_of_nonneg_left hω hlampos.le)
  have hmono {A B : Set Ω} (hAB : A ⊆ B) : μ.real A ≤ μ.real B := by
    rw [Measure.real_def, Measure.real_def]
    exact ENNReal.toReal_mono (measure_ne_top μ B) (measure_mono hAB)
  -- The exponent inequality: the optimized value beats the printed minimum.
  have hexp : v * lam ^ 2 - lam * t ≤ -min (t ^ 2 / (4 * v)) (t / (2 * M)) := by
    rcases le_or_gt (t / (2 * v)) M⁻¹ with hcase | hcase
    · -- Unconstrained optimum admissible: the sub-gaussian regime.
      have hlameq : lam = t / (2 * v) := min_eq_left hcase
      have : v * lam ^ 2 - lam * t = -(t ^ 2 / (4 * v)) := by
        rw [hlameq]; field_simp; ring
      rw [this]
      simp
    · -- Window boundary active: the sub-exponential regime.
      have hlameq : lam = M⁻¹ := min_eq_right hcase.le
      -- The constraint being active says exactly that `2v < t M`.
      have hvlt : 2 * v < t * M := by
        have h2v : (0 : ℝ) < 2 * v := by positivity
        have h1 : M⁻¹ * (2 * v) < t := by
          calc M⁻¹ * (2 * v) < (t / (2 * v)) * (2 * v) :=
                mul_lt_mul_of_pos_right hcase h2v
            _ = t := by field_simp
        have h3 : M⁻¹ * (2 * v) * M < t * M := mul_lt_mul_of_pos_right h1 hM
        have h4 : M⁻¹ * (2 * v) * M = 2 * v := by
          field_simp
        rw [h4] at h3
        exact h3
      have hval : v * lam ^ 2 - lam * t = v / M ^ 2 - t / M := by
        rw [hlameq]
        field_simp
      have hstep : v / M ^ 2 - t / M ≤ -(t / (2 * M)) := by
        have hM2 : (0 : ℝ) < M ^ 2 := by positivity
        have key : v / M ^ 2 ≤ t / (2 * M) := by
          rw [div_le_div_iff₀ hM2 (by positivity)]
          nlinarith [mul_lt_mul_of_pos_right hvlt hM]
        have hhalf : t / M = t / (2 * M) + t / (2 * M) := by
          field_simp
          ring
        rw [hhalf]
        linarith [key]
      rw [hval]
      refine hstep.trans ?_
      simp
  calc
    μ.real {ω | X ω ≥ t} ≤ μ.real (Y ⁻¹' Set.Ici (Real.exp (lam * t))) :=
      hmono hsubset
    _ ≤ (∫ ω, Y ω ∂μ) / Real.exp (lam * t) := by
      simpa [NumStability.HDP.Scalar.Preliminaries.expectation] using hmarkov
    _ ≤ Real.exp (v * lam ^ 2) / Real.exp (lam * t) :=
      div_le_div_of_nonneg_right hBound (le_of_lt (Real.exp_pos _))
    _ = Real.exp (v * lam ^ 2 - lam * t) := by
      rw [div_eq_mul_inv, ← Real.exp_neg, ← Real.exp_add]; ring_nf
    _ ≤ Real.exp (-min (t ^ 2 / (4 * v)) (t / (2 * M))) :=
      Real.exp_le_exp.2 hexp

/-- Property (e) of Proposition 2.7.1 is monotone in its parameter: enlarging
`K` both shrinks the window and weakens the bound. -/
theorem subExponentialLinearMGF_mono
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X : Ω → ℝ} {K M : ℝ}
    (hK : SubExponentialLinearMGF μ X K) (hKM : K ≤ M) :
    SubExponentialLinearMGF μ X M := by
  obtain ⟨hX, hKpos, hIntX, hMean, hMGF⟩ := hK
  have hMpos : 0 < M := lt_of_lt_of_le hKpos hKM
  refine ⟨hX, hMpos, hIntX, hMean, ?_⟩
  intro lam hlam
  have hwin : |lam| ≤ K⁻¹ :=
    hlam.trans (by simpa [one_div] using one_div_le_one_div_of_le hKpos hKM)
  obtain ⟨hInt, hBound⟩ := hMGF lam hwin
  refine ⟨hInt, hBound.trans (Real.exp_le_exp.2 ?_)⟩
  have hsq : K ^ 2 ≤ M ^ 2 := by nlinarith
  exact mul_le_mul_of_nonneg_right hsq (sq_nonneg lam)

/-- The bridge from the source's sub-exponential norm to the window/MGF scale
this section works in: a strict `‖X‖_{ψ₁} < K` bound on a centered variable
yields property (e) of Proposition 2.7.1 with parameter `2048 e⁴ K`.

The constant is absolute — it does not depend on `X`, on `K`, or on any index —
so it may be used uniformly across a family, which is what the sums of
Section 2.8 require.  It is the composition of the constant-explicit
Proposition 2.7.1 transfer (`512 e³`, property (d) to property (b)) with
`momentToLinearMGF` (`4 e`, property (b) to property (e)). -/
theorem psiOneGaugeToLinearMGF
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ} (hX : Measurable X) (hK : 0 < K)
    (hCenter : Integrable X μ ∧ (∫ ω, X ω ∂μ) = 0)
    (hGauge : PsiOneGauge μ X < ENNReal.ofReal K) :
    SubExponentialLinearMGF μ X (2048 * (Real.exp 1) ^ 4 * K) := by
  have hPoint : SubExponentialProperty μ X .onePoint K :=
    psiOneGauge_lt_imp_onePointMGF hK hGauge
  obtain ⟨Kj, hKj, hKjbound, hMoment⟩ :=
    subExponentialPropertyTransfer .onePoint .moment hK hPoint
  obtain ⟨-, -, hLp⟩ := hMoment
  have hLinear : SubExponentialLinearMGF μ X (4 * Real.exp 1 * Kj) :=
    momentToLinearMGF hX hKj hCenter hLp
  refine subExponentialLinearMGF_mono hLinear ?_
  have hcoef : (0 : ℝ) ≤ 4 * Real.exp 1 := by positivity
  calc
    4 * Real.exp 1 * Kj ≤ 4 * Real.exp 1 * (512 * (Real.exp 1) ^ 3 * K) :=
      mul_le_mul_of_nonneg_left hKjbound hcoef
    _ = 2048 * (Real.exp 1) ^ 4 * K := by ring

/-- The non-strict companion of `psiOneGaugeToLinearMGF`.  Since the constant is
absolute and unspecified, the slack needed to turn `‖X‖_{ψ₁} ≤ K` into a strict
bound is absorbed by doubling `K`, which avoids any limiting argument at the
call sites. -/
theorem psiOneGaugeToLinearMGF_le
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ} (hX : Measurable X) (hK : 0 < K)
    (hCenter : Integrable X μ ∧ (∫ ω, X ω ∂μ) = 0)
    (hGauge : PsiOneGauge μ X ≤ ENNReal.ofReal K) :
    SubExponentialLinearMGF μ X (4096 * (Real.exp 1) ^ 4 * K) := by
  have hlt : PsiOneGauge μ X < ENNReal.ofReal (2 * K) := by
    refine lt_of_le_of_lt hGauge ?_
    exact (ENNReal.ofReal_lt_ofReal_iff (by linarith)).2 (by linarith)
  have h := psiOneGaugeToLinearMGF hX (by linarith : (0 : ℝ) < 2 * K) hCenter hlt
  refine subExponentialLinearMGF_mono h (le_of_eq ?_)
  ring

/-- The two-sided form of the window optimization: the shape of Theorem 2.8.1's
conclusion, stated for a single variable. -/
theorem localMGFToTail
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {v M : ℝ}
    (hX : Measurable X) (hv : 0 < v) (hM : 0 < M)
    (hMGF : ∀ lam : ℝ, |lam| ≤ M⁻¹ →
      Integrable (fun ω => Real.exp (lam * X ω)) μ ∧
        (∫ ω, Real.exp (lam * X ω) ∂μ) ≤ Real.exp (v * lam ^ 2))
    {t : ℝ} (ht : 0 ≤ t) :
    μ.real {ω | |X ω| ≥ t} ≤
      2 * Real.exp (-min (t ^ 2 / (4 * v)) (t / (2 * M))) := by
  rcases eq_or_lt_of_le ht with heq | htpos
  · -- `t = 0`: the bound is the trivial probability bound.
    have ht0 : t = 0 := heq.symm
    subst ht0
    have hprob : μ.real {ω | |X ω| ≥ (0:ℝ)} ≤ 1 := by
      rw [Measure.real_def]
      exact ENNReal.toReal_mono ENNReal.one_ne_top prob_le_one
    refine hprob.trans ?_
    have hmin : min ((0:ℝ) ^ 2 / (4 * v)) ((0:ℝ) / (2 * M)) = 0 := by
      simp
    rw [hmin, neg_zero, Real.exp_zero]
    norm_num
  have hupper := localMGFOneSided hX hv hM hMGF htpos
  -- The reflected variable satisfies the same window bound.
  have hMGFneg : ∀ lam : ℝ, |lam| ≤ M⁻¹ →
      Integrable (fun ω => Real.exp (lam * (-X ω))) μ ∧
        (∫ ω, Real.exp (lam * (-X ω)) ∂μ) ≤ Real.exp (v * lam ^ 2) := by
    intro lam hlam
    have hneg : |(-lam)| ≤ M⁻¹ := by rwa [abs_neg]
    obtain ⟨hInt, hBound⟩ := hMGF (-lam) hneg
    refine ⟨by simpa [mul_comm, mul_neg, neg_mul] using hInt, ?_⟩
    have : (∫ ω, Real.exp (lam * (-X ω)) ∂μ)
        = ∫ ω, Real.exp (-lam * X ω) ∂μ := by
      refine integral_congr_ae (Filter.Eventually.of_forall fun ω => ?_)
      ring
    rw [this]
    refine hBound.trans (Real.exp_le_exp.2 ?_)
    have : (-lam) ^ 2 = lam ^ 2 := by ring
    rw [this]
  have hlower := localMGFOneSided (X := fun ω => -X ω) hX.neg hv hM hMGFneg htpos
  have hsubset : {ω | |X ω| ≥ t} ⊆ {ω | X ω ≥ t} ∪ {ω | -X ω ≥ t} := by
    intro ω hω
    change t ≤ |X ω| at hω
    change t ≤ X ω ∨ t ≤ -X ω
    by_cases h : t ≤ X ω
    · exact Or.inl h
    · right
      by_contra hnot
      exact (not_lt_of_ge hω) ((abs_lt).2 (by constructor <;> [linarith; linarith]))
  have hunion : μ.real ({ω | X ω ≥ t} ∪ {ω | -X ω ≥ t}) ≤
      μ.real {ω | X ω ≥ t} + μ.real {ω | -X ω ≥ t} := by
    rw [Measure.real_def, Measure.real_def, Measure.real_def]
    calc
      (μ ({ω | X ω ≥ t} ∪ {ω | -X ω ≥ t})).toReal ≤
          (μ {ω | X ω ≥ t} + μ {ω | -X ω ≥ t}).toReal := by
        refine ENNReal.toReal_mono ?_ (measure_union_le _ _)
        exact ENNReal.add_ne_top.mpr ⟨measure_ne_top μ _, measure_ne_top μ _⟩
      _ = (μ {ω | X ω ≥ t}).toReal + (μ {ω | -X ω ≥ t}).toReal :=
        ENNReal.toReal_add (measure_ne_top μ _) (measure_ne_top μ _)
  calc
    μ.real {ω | |X ω| ≥ t} ≤ μ.real ({ω | X ω ≥ t} ∪ {ω | -X ω ≥ t}) := by
      rw [Measure.real_def, Measure.real_def]
      exact ENNReal.toReal_mono (measure_ne_top μ _) (measure_mono hsubset)
    _ ≤ μ.real {ω | X ω ≥ t} + μ.real {ω | -X ω ≥ t} := hunion
    _ ≤ Real.exp (-min (t ^ 2 / (4 * v)) (t / (2 * M))) +
          Real.exp (-min (t ^ 2 / (4 * v)) (t / (2 * M))) :=
      add_le_add hupper hlower
    _ = 2 * Real.exp (-min (t ^ 2 / (4 * v)) (t / (2 * M))) := by ring

/-! ### Tensorization of the window bound

The MGF of a sum of independent terms factors, exactly as in `(2.6)`; the only
new feature relative to Section 2.2 is that the factorization is used inside a
window, so the admissible range for `λ` must be small enough for *every*
coordinate at once.  With weights, coordinate `i` needs `|λ a i| ≤ 1 / K i`,
which is guaranteed by `|λ| ≤ 1 / M` whenever `|a i| * K i ≤ M`. -/
theorem independentWeightedSumLocalMGF
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {K : ι → ℝ} {a : ι → ℝ} {M : ℝ}
    (hX : ∀ i, SubExponentialLinearMGF μ (X i) (K i))
    (hIndep : iIndepFun X μ)
    (hM : 0 < M)
    (hwindow : ∀ i, |a i| * K i ≤ M)
    {lam : ℝ} (hlam : |lam| ≤ M⁻¹) :
    Integrable (fun ω => Real.exp (lam * ∑ i, a i * X i ω)) μ ∧
      (∫ ω, Real.exp (lam * ∑ i, a i * X i ω) ∂μ) ≤
        Real.exp ((∑ i, (a i * K i) ^ 2) * lam ^ 2) := by
  classical
  -- Each coordinate's rescaled parameter stays inside that coordinate's window.
  have hcoord : ∀ i, |lam * a i| ≤ (K i)⁻¹ := by
    intro i
    have hKi : 0 < K i := (hX i).2.1
    have hprod : |lam| * (|a i| * K i) ≤ M⁻¹ * M :=
      mul_le_mul hlam (hwindow i)
        (mul_nonneg (abs_nonneg _) hKi.le) (inv_nonneg.mpr hM.le)
    rw [abs_mul, inv_eq_one_div, le_div_iff₀ hKi]
    calc |lam| * |a i| * K i = |lam| * (|a i| * K i) := by ring
      _ ≤ M⁻¹ * M := hprod
      _ = 1 := inv_mul_cancel₀ (ne_of_gt hM)
  -- The per-coordinate window bound, restated in the weighted scale.
  have hfac : ∀ i,
      Integrable (fun ω => Real.exp (lam * (a i * X i ω))) μ ∧
        (∫ ω, Real.exp (lam * (a i * X i ω)) ∂μ) ≤
          Real.exp ((a i * K i) ^ 2 * lam ^ 2) := by
    intro i
    obtain ⟨hInt, hB⟩ := (hX i).2.2.2.2 (lam * a i) (hcoord i)
    have hassoc : (fun ω => Real.exp (lam * a i * X i ω))
        = fun ω => Real.exp (lam * (a i * X i ω)) := by
      funext ω; rw [mul_assoc]
    rw [hassoc] at hInt hB
    refine ⟨hInt, hB.trans (Real.exp_le_exp.2 (le_of_eq ?_))⟩
    ring
  -- Independence transfers to the rescaled coordinates.
  set Y : ι → Ω → ℝ := fun i ω => a i * X i ω with hYdef
  have hYmeas : ∀ i, Measurable (Y i) := by
    intro i; exact (hX i).1.const_mul (a i)
  have hYindep : iIndepFun Y μ := by
    have hg : ∀ i : ι, Measurable (fun x : ℝ => a i * x) := by
      intro i; fun_prop
    have h := hIndep.comp (fun i => fun x : ℝ => a i * x) hg
    simpa [Y, Function.comp_def] using h
  refine ⟨?_, ?_⟩
  · have h := hYindep.integrable_exp_mul_sum (t := lam) hYmeas
      (s := Finset.univ) (fun i _ => (hfac i).1)
    simpa [Y, Finset.sum_apply] using h
  · have hFactorization :=
      NumStability.HDP.Scalar.IndependentSums.Hoeffding.mgfIndependentSum
        (μ := μ) (X := X) lam a hIndep (fun i => (hfac i).1)
    have hProd :
        (∏ i, ∫ ω, Real.exp (lam * (a i * X i ω)) ∂μ) ≤
          ∏ i, Real.exp ((a i * K i) ^ 2 * lam ^ 2) := by
      refine Finset.prod_le_prod ?_ ?_
      · intro i _; exact integral_nonneg (fun ω => Real.exp_nonneg _)
      · intro i _; exact (hfac i).2
    calc
      (∫ ω, Real.exp (lam * ∑ i, a i * X i ω) ∂μ)
          = ∏ i, ∫ ω, Real.exp (lam * (a i * X i ω)) ∂μ := hFactorization
      _ ≤ ∏ i, Real.exp ((a i * K i) ^ 2 * lam ^ 2) := hProd
      _ = Real.exp ((∑ i, (a i * K i) ^ 2) * lam ^ 2) := by
        rw [← Real.exp_sum, Finset.sum_mul]

/-! ### Theorem 2.8.2 (printed page 37)

The weighted form is proved first, because the unweighted Theorem 2.8.1 is its
`a ≡ 1` case and Corollary 2.8.3 is its `a ≡ 1/N` case, which is exactly how the
printed section organizes the three statements. -/
theorem bernsteinWeightedTail
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {K : ι → ℝ} {a : ι → ℝ} {M : ℝ}
    (hX : ∀ i, SubExponentialLinearMGF μ (X i) (K i))
    (hIndep : iIndepFun X μ)
    (hM : 0 < M)
    (hwindow : ∀ i, |a i| * K i ≤ M)
    (hEnergy : 0 < ∑ i, (a i * K i) ^ 2)
    {t : ℝ} (ht : 0 ≤ t) :
    μ.real {ω | |∑ i, a i * X i ω| ≥ t} ≤
      2 * Real.exp (-min (t ^ 2 / (4 * ∑ i, (a i * K i) ^ 2)) (t / (2 * M))) := by
  set S : Ω → ℝ := fun ω => ∑ i, a i * X i ω with hSdef
  have hSmeas : Measurable S := by
    dsimp [S]
    exact Finset.measurable_sum Finset.univ
      (fun i _ => ((hX i).1.const_mul (a i)))
  refine localMGFToTail (X := S) hSmeas hEnergy hM ?_ ht
  intro lam hlam
  obtain ⟨hInt, hB⟩ := independentWeightedSumLocalMGF hX hIndep hM hwindow hlam
  exact ⟨hInt, hB⟩

/-! ### Theorem 2.8.1 (printed page 36) -/
theorem bernsteinTail
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {K : ι → ℝ} {M : ℝ}
    (hX : ∀ i, SubExponentialLinearMGF μ (X i) (K i))
    (hIndep : iIndepFun X μ)
    (hM : 0 < M)
    (hmax : ∀ i, K i ≤ M)
    (hEnergy : 0 < ∑ i, K i ^ 2)
    {t : ℝ} (ht : 0 ≤ t) :
    μ.real {ω | |∑ i, X i ω| ≥ t} ≤
      2 * Real.exp (-min (t ^ 2 / (4 * ∑ i, K i ^ 2)) (t / (2 * M))) := by
  have hwindow : ∀ i, |(1 : ℝ)| * K i ≤ M := by
    intro i; simpa using hmax i
  have hEnergy' : 0 < ∑ i, ((1 : ℝ) * K i) ^ 2 := by simpa using hEnergy
  have h := bernsteinWeightedTail (a := fun _ => (1 : ℝ)) hX hIndep hM hwindow
    hEnergy' ht
  simpa using h

/-! ### Corollary 2.8.3 (printed page 37)

The printed corollary is the case `a i = 1 / N`.  With a common scale `K` this
reads `P{|N⁻¹ ∑ X i| ≥ t} ≤ 2 exp (-min (t²/K², t/K) N / 4)` up to the explicit
constants carried here; the statement below keeps the `1 / N` weights visible
rather than pre-simplifying them, so the correspondence with the printed
display can be checked directly. -/
theorem bernsteinAverageTail
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {K : ℝ}
    (hK : 0 < K)
    (hX : ∀ i, SubExponentialLinearMGF μ (X i) K)
    (hIndep : iIndepFun X μ)
    (hcard : 0 < Fintype.card ι)
    {t : ℝ} (ht : 0 ≤ t) :
    μ.real {ω | |∑ i, (Fintype.card ι : ℝ)⁻¹ * X i ω| ≥ t} ≤
      2 * Real.exp (-min
        (t ^ 2 / (4 * ∑ _i : ι, ((Fintype.card ι : ℝ)⁻¹ * K) ^ 2))
        (t / (2 * ((Fintype.card ι : ℝ)⁻¹ * K)))) := by
  have hN : (0 : ℝ) < (Fintype.card ι : ℝ) := by
    exact_mod_cast hcard
  set N : ℝ := (Fintype.card ι : ℝ) with hNdef
  have hNinv : (0 : ℝ) < N⁻¹ := inv_pos.mpr hN
  have hM : 0 < N⁻¹ * K := by positivity
  have hwindow : ∀ i : ι, |N⁻¹| * K ≤ N⁻¹ * K := by
    intro i; rw [abs_of_pos hNinv]
  have hne : (Finset.univ : Finset ι).Nonempty := by
    rw [← Finset.card_pos, Finset.card_univ]; exact hcard
  have hEnergy : 0 < ∑ _i : ι, (N⁻¹ * K) ^ 2 :=
    Finset.sum_pos (fun _ _ => pow_pos hM 2) hne
  exact bernsteinWeightedTail (K := fun _ => K) (a := fun _ => N⁻¹)
    hX hIndep hM hwindow hEnergy ht

/-! ### Exercise 2.8.5 and Theorem 2.8.4 (printed page 38)

Exercise 2.8.5 asks for the numeric inequality

`e^z ≤ 1 + z + (z²/2) / (1 - |z|/3)`  for `|z| < 3`,

which sharpens the crude `exp y ≤ 1 + y + (e^{|y|} - 1 - |y|)` estimate by
summing the tail of the exponential series against `(k+2)! ≥ 2 · 3^k` rather
than against the full factorial.  Theorem 2.8.4 then follows by the same
MGF-plus-Markov route, and — unlike the `ψ₁`-scale statements above — its
printed constants come out exactly, with no absolute constant left implicit. -/

/-- `2 · 3 ^ k ≤ (k + 2)!`, the factorial estimate behind Exercise 2.8.5. -/
private lemma two_mul_three_pow_le_factorial (k : ℕ) :
    2 * 3 ^ k ≤ (k + 2).factorial := by
  have h := Nat.factorial_mul_pow_le_factorial (m := 2) (n := k)
  simpa [Nat.factorial, Nat.add_comm] using h

/-- The tail of the exponential series, summed geometrically.  This is the
numeric inequality Exercise 2.8.5's hint asks to check. -/
lemma expRemainder_le_geometric {x : ℝ} (hx : 0 ≤ x) (hx3 : x < 3) :
    Real.exp x - 1 - x ≤ (x ^ 2 / 2) / (1 - x / 3) := by
  have hr0 : 0 ≤ x / 3 := by positivity
  have hr1 : x / 3 < 1 := by linarith
  have hden : 0 < 1 - x / 3 := by linarith
  set f : ℕ → ℝ := fun n => x ^ n / (n.factorial : ℝ) with hf
  have hsum : Summable f := by
    dsimp [f]
    exact NormedSpace.expSeries_div_summable x
  have hexp : (∑' n : ℕ, f n) = Real.exp x := by
    dsimp [f]
    rw [Real.exp_eq_exp_ℝ]
    exact (NormedSpace.expSeries_div_hasSum_exp x).tsum_eq
  -- Split off the first two terms of the series.
  have hsplit := hsum.sum_add_tsum_nat_add 2
  have hsplit' : f 0 + f 1 + ∑' n : ℕ, f (n + 2) = Real.exp x := by
    simpa [Finset.sum_range_succ, f, Nat.factorial] using hsplit.trans hexp
  have htail : Real.exp x - 1 - x = ∑' n : ℕ, x ^ (n + 2) / ((n + 2).factorial : ℝ) := by
    have h0 : f 0 = 1 := by simp [f]
    have h1 : f 1 = x := by simp [f, Nat.factorial]
    rw [h0, h1] at hsplit'
    dsimp [f] at hsplit' ⊢
    linarith
  -- Termwise geometric domination.
  have hterm : ∀ n : ℕ,
      x ^ (n + 2) / ((n + 2).factorial : ℝ) ≤ (x ^ 2 / 2) * (x / 3) ^ n := by
    intro n
    have hfac : (2 : ℝ) * 3 ^ n ≤ ((n + 2).factorial : ℝ) := by
      have h := two_mul_three_pow_le_factorial n
      exact_mod_cast h
    have hfacpos : (0 : ℝ) < ((n + 2).factorial : ℝ) := by
      exact_mod_cast Nat.factorial_pos (n + 2)
    have hgeom : (0 : ℝ) < 2 * 3 ^ n := by positivity
    have hxpow : (0 : ℝ) ≤ x ^ (n + 2) := by positivity
    have hrw : (x ^ 2 / 2) * (x / 3) ^ n = x ^ (n + 2) / (2 * 3 ^ n) := by
      rw [div_pow]
      field_simp
      ring
    rw [hrw]
    exact div_le_div_of_nonneg_left hxpow hgeom hfac
  -- Both series converge, so the termwise bound integrates.
  have hsumL : Summable (fun n : ℕ => x ^ (n + 2) / ((n + 2).factorial : ℝ)) := by
    have hinj : Function.Injective (fun n : ℕ => n + 2) := fun a b hab =>
      Nat.add_right_cancel hab
    simpa [f] using hsum.comp_injective hinj
  have hsumR : Summable (fun n : ℕ => (x ^ 2 / 2) * (x / 3) ^ n) :=
    (summable_geometric_of_lt_one hr0 hr1).mul_left _
  calc
    Real.exp x - 1 - x = ∑' n : ℕ, x ^ (n + 2) / ((n + 2).factorial : ℝ) := htail
    _ ≤ ∑' n : ℕ, (x ^ 2 / 2) * (x / 3) ^ n :=
      hsumL.tsum_le_tsum hterm hsumR
    _ = (x ^ 2 / 2) * (1 - x / 3)⁻¹ := by
      rw [tsum_mul_left, tsum_geometric_of_lt_one hr0 hr1]
    _ = (x ^ 2 / 2) / (1 - x / 3) := by ring

/-- Exercise 2.8.5's numeric inequality, in the two-sided form the exercise
states: `e^z ≤ 1 + z + (z²/2)/(1 - |z|/3)` for `|z| < 3`. -/
lemma exp_le_one_add_add_geometric {z : ℝ} (hz : |z| < 3) :
    Real.exp z ≤ 1 + z + (z ^ 2 / 2) / (1 - |z| / 3) := by
  have hbase := NumStability.HDP.Scalar.SubExponential.exp_le_centered_remainder z
  have habs : Real.exp |z| - 1 - |z| ≤ (|z| ^ 2 / 2) / (1 - |z| / 3) :=
    expRemainder_le_geometric (abs_nonneg z) hz
  have hsq : |z| ^ 2 = z ^ 2 := sq_abs z
  rw [hsq] at habs
  linarith

/-- Exercise 2.8.5 (printed page 38): the variance-sensitive MGF bound for a
centered bounded variable. -/
theorem boundedCenteredMGFBound
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ} (hK : 0 < K) (hX : Measurable X)
    (hCenter : Integrable X μ ∧ (∫ ω, X ω ∂μ) = 0)
    (hBound : ∀ᵐ ω ∂μ, |X ω| ≤ K)
    {lam : ℝ} (hlam : |lam| * K < 3) :
    Integrable (fun ω => Real.exp (lam * X ω)) μ ∧
      (∫ ω, Real.exp (lam * X ω) ∂μ) ≤
        Real.exp (((lam ^ 2 / 2) / (1 - |lam| * K / 3)) * (∫ ω, X ω ^ 2 ∂μ)) := by
  set g : ℝ := (lam ^ 2 / 2) / (1 - |lam| * K / 3) with hgdef
  have hden : 0 < 1 - |lam| * K / 3 := by linarith
  have hg0 : 0 ≤ g := by
    rw [hgdef]; positivity
  -- `X` is a.e. bounded, so every exponential moment exists.
  have hExpInt : Integrable (fun ω => Real.exp (lam * X ω)) μ := by
    have hmeas : AEStronglyMeasurable (fun ω => Real.exp (lam * X ω)) μ :=
      ((hX.const_mul lam).exp).aestronglyMeasurable
    refine Integrable.mono' (g := fun _ => Real.exp (|lam| * K))
      (integrable_const _) hmeas ?_
    filter_upwards [hBound] with ω hω
    rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _)]
    refine Real.exp_le_exp.2 ?_
    calc lam * X ω ≤ |lam * X ω| := le_abs_self _
      _ = |lam| * |X ω| := abs_mul lam (X ω)
      _ ≤ |lam| * K := mul_le_mul_of_nonneg_left hω (abs_nonneg lam)
  have hSqInt : Integrable (fun ω => X ω ^ 2) μ := by
    have hmeas : AEStronglyMeasurable (fun ω => X ω ^ 2) μ :=
      (hX.pow_const 2).aestronglyMeasurable
    refine Integrable.mono' (g := fun _ => K ^ 2) (integrable_const _) hmeas ?_
    filter_upwards [hBound] with ω hω
    rw [Real.norm_eq_abs, abs_of_nonneg (sq_nonneg _), ← sq_abs]
    nlinarith [abs_nonneg (X ω), hω]
  refine ⟨hExpInt, ?_⟩
  -- The pointwise estimate, with the state-independent denominator.
  have hpt : ∀ᵐ ω ∂μ,
      Real.exp (lam * X ω) ≤ 1 + lam * X ω + g * X ω ^ 2 := by
    filter_upwards [hBound] with ω hω
    have habs : |lam * X ω| ≤ |lam| * K := by
      rw [abs_mul]
      exact mul_le_mul_of_nonneg_left hω (abs_nonneg lam)
    have hlt : |lam * X ω| < 3 := lt_of_le_of_lt habs hlam
    have hstep := exp_le_one_add_add_geometric hlt
    refine hstep.trans ?_
    have hmono : ((lam * X ω) ^ 2 / 2) / (1 - |lam * X ω| / 3)
        ≤ g * X ω ^ 2 := by
      have hden' : 0 < 1 - |lam * X ω| / 3 := by linarith
      have hdle : 1 - |lam| * K / 3 ≤ 1 - |lam * X ω| / 3 := by linarith
      have hnum : (0 : ℝ) ≤ (lam * X ω) ^ 2 / 2 := by positivity
      have hkey : ((lam * X ω) ^ 2 / 2) / (1 - |lam * X ω| / 3)
          ≤ ((lam * X ω) ^ 2 / 2) / (1 - |lam| * K / 3) :=
        div_le_div_of_nonneg_left hnum hden hdle
      refine hkey.trans (le_of_eq ?_)
      rw [hgdef]
      field_simp
    linarith
  -- Integrate, using the mean-zero hypothesis to kill the linear term.
  have hRHSInt : Integrable (fun ω => 1 + lam * X ω + g * X ω ^ 2) μ :=
    ((integrable_const (1 : ℝ)).add (hCenter.1.const_mul lam)).add
      (hSqInt.const_mul g)
  have hmono := integral_mono_ae hExpInt hRHSInt hpt
  have hrhs : (∫ ω, (1 + lam * X ω + g * X ω ^ 2) ∂μ)
      = 1 + g * ∫ ω, X ω ^ 2 ∂μ := by
    have h1 : Integrable (fun ω => (1 : ℝ) + lam * X ω) μ :=
      (integrable_const (1 : ℝ)).add (hCenter.1.const_mul lam)
    have h2 : Integrable (fun ω => g * X ω ^ 2) μ := hSqInt.const_mul g
    rw [integral_add h1 h2,
      integral_add (integrable_const (1 : ℝ)) (hCenter.1.const_mul lam),
      integral_const_mul, integral_const_mul, hCenter.2, integral_const]
    simp
  rw [hrhs] at hmono
  refine hmono.trans ?_
  have hfin : (0 : ℝ) ≤ g * ∫ ω, X ω ^ 2 ∂μ := by
    refine mul_nonneg hg0 (integral_nonneg fun ω => sq_nonneg _)
  have := Real.add_one_le_exp (g * ∫ ω, X ω ^ 2 ∂μ)
  linarith

/-- The per-coordinate MGF bound of Exercise 2.8.5, stated as a hypothesis that
quantifies over every centered variable bounded by `K`.

Exercise 2.8.6 asks to *deduce* Theorem 2.8.4 "from the bound in Exercise
2.8.5", so the deduction is recorded as a theorem taking exactly that bound as
its hypothesis.  Since the printed proof applies the bound to both `X i` and
`-X i`, the hypothesis has to be available for every admissible variable, not
just for the given family — which is what makes this a faithful rendering of the
exercise rather than a restatement of Theorem 2.8.4. -/
def BoundedCenteredMGFHypothesis {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (K : ℝ) : Prop :=
  ∀ Y : Ω → ℝ, Measurable Y → Integrable Y μ → (∫ ω, Y ω ∂μ) = 0 →
    (∀ᵐ ω ∂μ, |Y ω| ≤ K) → ∀ lam : ℝ, |lam| * K < 3 →
      Integrable (fun ω => Real.exp (lam * Y ω)) μ ∧
        (∫ ω, Real.exp (lam * Y ω) ∂μ) ≤
          Real.exp (((lam ^ 2 / 2) / (1 - |lam| * K / 3)) * ∫ ω, Y ω ^ 2 ∂μ)

/-- Exercise 2.8.5 establishes `BoundedCenteredMGFHypothesis`. -/
theorem boundedCenteredMGFHypothesis_holds
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] {K : ℝ} (hK : 0 < K) :
    BoundedCenteredMGFHypothesis μ K := by
  intro Y hY hInt hMean hBound lam hlam
  exact boundedCenteredMGFBound hK hY ⟨hInt, hMean⟩ hBound hlam

/-- The bounded-variable MGF bound tensorizes over independent coordinates.
This is the `(2.6)`/`(2.23)` factorization applied to Exercise 2.8.5's estimate,
and it is where the variances add. -/
private theorem boundedSumMGF
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {K : ℝ}
    (hX : ∀ i, Measurable (X i))
    (hIndep : iIndepFun X μ)
    {lam : ℝ}
    (hcoord : ∀ i,
      Integrable (fun ω => Real.exp (lam * X i ω)) μ ∧
        (∫ ω, Real.exp (lam * X i ω) ∂μ) ≤
          Real.exp (((lam ^ 2 / 2) / (1 - lam * K / 3)) * ∫ ω, X i ω ^ 2 ∂μ)) :
    Integrable (fun ω => Real.exp (lam * ∑ i, X i ω)) μ ∧
      (∫ ω, Real.exp (lam * ∑ i, X i ω) ∂μ) ≤
        Real.exp (((lam ^ 2 / 2) / (1 - lam * K / 3)) *
          ∑ i, ∫ ω, X i ω ^ 2 ∂μ) := by
  refine ⟨?_, ?_⟩
  · have h := hIndep.integrable_exp_mul_sum (t := lam) hX
      (s := Finset.univ) (fun i _ => (hcoord i).1)
    simpa [Finset.sum_apply] using h
  · have hFactorization :=
      NumStability.HDP.Scalar.IndependentSums.Hoeffding.mgfIndependentSum
        (μ := μ) (X := X) lam (fun _ => (1 : ℝ)) hIndep
        (fun i => by simpa using (hcoord i).1)
    have hProd :
        (∏ i, ∫ ω, Real.exp (lam * (1 * X i ω)) ∂μ) ≤
          ∏ i, Real.exp (((lam ^ 2 / 2) / (1 - lam * K / 3)) *
            ∫ ω, X i ω ^ 2 ∂μ) := by
      refine Finset.prod_le_prod ?_ ?_
      · intro i _; exact integral_nonneg (fun ω => Real.exp_nonneg _)
      · intro i _; simpa using (hcoord i).2
    calc
      (∫ ω, Real.exp (lam * ∑ i, X i ω) ∂μ)
          = ∏ i, ∫ ω, Real.exp (lam * (1 * X i ω)) ∂μ := by
            simpa using hFactorization
      _ ≤ ∏ i, Real.exp (((lam ^ 2 / 2) / (1 - lam * K / 3)) *
            ∫ ω, X i ω ^ 2 ∂μ) := hProd
      _ = Real.exp (((lam ^ 2 / 2) / (1 - lam * K / 3)) *
            ∑ i, ∫ ω, X i ω ^ 2 ∂μ) := by
        rw [← Real.exp_sum, Finset.mul_sum]

/-- The one-sided half of Theorem 2.8.4.  The choice
`λ = t / (σ² + K t / 3)` makes the exponent exactly `-(t²/2) / (σ² + K t / 3)`,
so no absolute constant is lost here. -/
private theorem bernsteinBoundedOneSided
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {K : ℝ} (hK : 0 < K)
    (hX : ∀ i, Measurable (X i))
    (hCenter : ∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0)
    (hBound : ∀ i, ∀ᵐ ω ∂μ, |X i ω| ≤ K)
    (hIndep : iIndepFun X μ)
    (hEx : BoundedCenteredMGFHypothesis μ K)
    (hVar : 0 < ∑ i, ∫ ω, X i ω ^ 2 ∂μ)
    {t : ℝ} (ht : 0 < t) :
    μ.real {ω | ∑ i, X i ω ≥ t} ≤
      Real.exp (-((t ^ 2 / 2) / ((∑ i, ∫ ω, X i ω ^ 2 ∂μ) + K * t / 3))) := by
  set sig : ℝ := ∑ i, ∫ ω, X i ω ^ 2 ∂μ with hsigdef
  set D : ℝ := sig + K * t / 3 with hDdef
  have hD : 0 < D := by
    rw [hDdef]; have : 0 < K * t / 3 := by positivity
    linarith
  set lam : ℝ := t / D with hlamdef
  have hlam0 : 0 ≤ lam := by rw [hlamdef]; positivity
  have hlam3 : lam * K < 3 := by
    rw [hlamdef, div_mul_eq_mul_div, div_lt_iff₀ hD]
    rw [hDdef]
    nlinarith [hVar, hK, ht]
  have hden : 0 < 1 - lam * K / 3 := by linarith
  have habs : |lam| * K < 3 := by rwa [abs_of_nonneg hlam0]
  have hgeq : (lam ^ 2 / 2) / (1 - |lam| * K / 3)
      = (lam ^ 2 / 2) / (1 - lam * K / 3) := by rw [abs_of_nonneg hlam0]
  -- Exercise 2.8.5, applied coordinatewise at the optimizing `λ`.
  have hcoord : ∀ i,
      Integrable (fun ω => Real.exp (lam * X i ω)) μ ∧
        (∫ ω, Real.exp (lam * X i ω) ∂μ) ≤
          Real.exp (((lam ^ 2 / 2) / (1 - lam * K / 3)) *
            ∫ ω, X i ω ^ 2 ∂μ) := by
    intro i
    obtain ⟨hI, hB⟩ := hEx (X i) (hX i) (hCenter i).1 (hCenter i).2
      (hBound i) lam habs
    rw [hgeq] at hB
    exact ⟨hI, hB⟩
  obtain ⟨hInt, hB⟩ := boundedSumMGF hX hIndep hcoord
  -- The exponent identity: the denominator collapses to `σ² / D`.
  have hdenom : 1 - lam * K / 3 = sig / D := by
    rw [hlamdef, hDdef]
    field_simp
    ring
  have hexp : ((lam ^ 2 / 2) / (1 - lam * K / 3)) * sig - lam * t
      = -((t ^ 2 / 2) / D) := by
    rw [hdenom, hlamdef]
    field_simp
    ring
  set S : Ω → ℝ := fun ω => ∑ i, X i ω with hSdef
  have hSmeas : Measurable S := by
    rw [hSdef]; exact Finset.measurable_sum Finset.univ (fun i _ => hX i)
  have hlampos : 0 < lam := by rw [hlamdef]; positivity
  let Y : Ω → ℝ := fun ω => Real.exp (lam * S ω)
  have hY : Measurable Y := by simpa [Y, hSdef] using (hSmeas.const_mul lam).exp
  have hmarkov :=
    NumStability.HDP.Scalar.Preliminaries.markovInequalityFinite hY
      (Filter.Eventually.of_forall (fun ω => le_of_lt (Real.exp_pos _)))
      (by simpa [Y, hSdef] using hInt) (Real.exp_pos (lam * t))
  have hsubset : {ω | S ω ≥ t} ⊆ Y ⁻¹' Set.Ici (Real.exp (lam * t)) := by
    intro ω hω
    change Real.exp (lam * t) ≤ Real.exp (lam * S ω)
    exact (Real.exp_le_exp).2 (mul_le_mul_of_nonneg_left hω hlampos.le)
  have hmono {A B : Set Ω} (hAB : A ⊆ B) : μ.real A ≤ μ.real B := by
    rw [Measure.real_def, Measure.real_def]
    exact ENNReal.toReal_mono (measure_ne_top μ B) (measure_mono hAB)
  calc
    μ.real {ω | S ω ≥ t} ≤ μ.real (Y ⁻¹' Set.Ici (Real.exp (lam * t))) :=
      hmono hsubset
    _ ≤ (∫ ω, Y ω ∂μ) / Real.exp (lam * t) := by
      simpa [NumStability.HDP.Scalar.Preliminaries.expectation] using hmarkov
    _ ≤ Real.exp (((lam ^ 2 / 2) / (1 - lam * K / 3)) * sig)
          / Real.exp (lam * t) := by
      refine div_le_div_of_nonneg_right ?_ (le_of_lt (Real.exp_pos _))
      simpa [Y, hSdef, hsigdef] using hB
    _ = Real.exp (((lam ^ 2 / 2) / (1 - lam * K / 3)) * sig - lam * t) := by
      rw [div_eq_mul_inv, ← Real.exp_neg, ← Real.exp_add]; ring_nf
    _ = Real.exp (-((t ^ 2 / 2) / D)) := by rw [hexp]

/-- **Exercise 2.8.6** (printed page 38): Theorem 2.8.4 deduced from the bound
of Exercise 2.8.5, which enters as the hypothesis `hEx`. -/
theorem bernsteinBoundedTailOfMGFBound
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {K : ℝ} (hK : 0 < K)
    (hX : ∀ i, Measurable (X i))
    (hCenter : ∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0)
    (hBound : ∀ i, ∀ᵐ ω ∂μ, |X i ω| ≤ K)
    (hIndep : iIndepFun X μ)
    (hEx : BoundedCenteredMGFHypothesis μ K)
    {t : ℝ} (ht : 0 ≤ t) :
    μ.real {ω | |∑ i, X i ω| ≥ t} ≤
      2 * Real.exp (-((t ^ 2 / 2) /
        ((∑ i, ∫ ω, X i ω ^ 2 ∂μ) + K * t / 3))) := by
  rcases eq_or_lt_of_le ht with heq | htpos
  · have ht0 : t = 0 := heq.symm
    subst ht0
    have hprob : μ.real {ω | |∑ i, X i ω| ≥ (0 : ℝ)} ≤ 1 := by
      rw [Measure.real_def]
      exact ENNReal.toReal_mono ENNReal.one_ne_top prob_le_one
    refine hprob.trans ?_
    have hzero : ((0 : ℝ) ^ 2 / 2)
        / ((∑ i, ∫ ω, X i ω ^ 2 ∂μ) + K * 0 / 3) = 0 := by simp
    rw [hzero, neg_zero, Real.exp_zero]
    norm_num
  have hSigNonneg : 0 ≤ ∑ i, ∫ ω, X i ω ^ 2 ∂μ :=
    Finset.sum_nonneg fun i _ => integral_nonneg fun ω => sq_nonneg (X i ω)
  by_cases hVar : 0 < ∑ i, ∫ ω, X i ω ^ 2 ∂μ
  swap
  · have hSigZero : (∑ i, ∫ ω, X i ω ^ 2 ∂μ) = 0 :=
      le_antisymm (le_of_not_gt hVar) hSigNonneg
    have hEachZero : ∀ i, (∫ ω, X i ω ^ 2 ∂μ) = 0 := by
      have hall := (Finset.sum_eq_zero_iff_of_nonneg
        (fun i _ => integral_nonneg fun ω => sq_nonneg (X i ω))).1 hSigZero
      intro i
      exact hall i (Finset.mem_univ i)
    have hSqInt : ∀ i, Integrable (fun ω => X i ω ^ 2) μ := by
      intro i
      have hmeas : AEStronglyMeasurable (fun ω => X i ω ^ 2) μ :=
        ((hX i).pow_const 2).aestronglyMeasurable
      refine Integrable.mono' (g := fun _ => K ^ 2) (integrable_const _) hmeas ?_
      filter_upwards [hBound i] with ω hω
      rw [Real.norm_eq_abs, abs_of_nonneg (sq_nonneg _), ← sq_abs]
      nlinarith [abs_nonneg (X i ω), hω]
    have hSqZero : ∀ i, (fun ω => X i ω ^ 2) =ᵐ[μ] 0 := by
      intro i
      exact (integral_eq_zero_iff_of_nonneg
        (fun ω => sq_nonneg (X i ω)) (hSqInt i)).1 (hEachZero i)
    have hXZero : ∀ i, X i =ᵐ[μ] 0 := by
      intro i
      filter_upwards [hSqZero i] with ω hω
      simp only [Pi.zero_apply] at hω ⊢
      nlinarith [sq_nonneg (X i ω)]
    have hAllZero : ∀ᵐ ω ∂μ, ∀ i ∈ (Finset.univ : Finset ι), X i ω = 0 := by
      rw [Filter.eventually_all_finset]
      intro i _
      exact hXZero i
    have hSumZero : ∀ᵐ ω ∂μ, (∑ i, X i ω) = 0 := by
      filter_upwards [hAllZero] with ω hω
      simp [hω]
    have hEventNull : μ {ω | |∑ i, X i ω| ≥ t} = 0 := by
      have hEventAE : {ω | |∑ i, X i ω| ≥ t} =ᵐ[μ] (∅ : Set Ω) := by
        filter_upwards [hSumZero] with ω hω
        apply propext
        change (t ≤ |∑ i, X i ω|) ↔ False
        rw [hω, abs_zero]
        exact iff_false_intro (not_le_of_gt htpos)
      simpa using measure_congr hEventAE
    rw [Measure.real_def, hEventNull, ENNReal.toReal_zero]
    positivity
  have hupper := bernsteinBoundedOneSided hK hX hCenter hBound hIndep hEx hVar
    htpos
  -- The reflected family satisfies the same hypotheses with the same variances.
  set Z : ι → Ω → ℝ := fun i ω => -X i ω with hZdef
  have hZmeas : ∀ i, Measurable (Z i) := fun i => (hX i).neg
  have hZcenter : ∀ i, Integrable (Z i) μ ∧ (∫ ω, Z i ω ∂μ) = 0 := by
    intro i
    refine ⟨(hCenter i).1.neg, ?_⟩
    rw [hZdef]
    simp [integral_neg, (hCenter i).2]
  have hZbound : ∀ i, ∀ᵐ ω ∂μ, |Z i ω| ≤ K := by
    intro i
    filter_upwards [hBound i] with ω hω
    rw [hZdef]; simpa [abs_neg] using hω
  have hZindep : iIndepFun Z μ := by
    have hg : ∀ i : ι, Measurable (fun x : ℝ => -x) := by intro i; fun_prop
    have h := hIndep.comp (fun _ => fun x : ℝ => -x) hg
    simpa [Z, Function.comp_def] using h
  have hZvar : ∀ i, (∫ ω, Z i ω ^ 2 ∂μ) = ∫ ω, X i ω ^ 2 ∂μ := by
    intro i
    refine integral_congr_ae (Filter.Eventually.of_forall fun ω => ?_)
    rw [hZdef]; ring
  have hZsum : (∑ i, ∫ ω, Z i ω ^ 2 ∂μ) = ∑ i, ∫ ω, X i ω ^ 2 ∂μ :=
    Finset.sum_congr rfl (fun i _ => hZvar i)
  have hZvarpos : 0 < ∑ i, ∫ ω, Z i ω ^ 2 ∂μ := by rw [hZsum]; exact hVar
  have hlower' := bernsteinBoundedOneSided hK hZmeas hZcenter hZbound hZindep
    hEx hZvarpos htpos
  rw [hZsum] at hlower'
  have hlower : μ.real {ω | -∑ i, X i ω ≥ t} ≤
      Real.exp (-((t ^ 2 / 2) / ((∑ i, ∫ ω, X i ω ^ 2 ∂μ) + K * t / 3))) := by
    have hset : {ω | ∑ i, Z i ω ≥ t} = {ω | -∑ i, X i ω ≥ t} := by
      ext ω
      simp [Z, Finset.sum_neg_distrib]
    rwa [hset] at hlower'
  have hsubset : {ω | |∑ i, X i ω| ≥ t} ⊆
      {ω | ∑ i, X i ω ≥ t} ∪ {ω | -∑ i, X i ω ≥ t} := by
    intro ω hω
    change t ≤ |∑ i, X i ω| at hω
    change t ≤ ∑ i, X i ω ∨ t ≤ -∑ i, X i ω
    by_cases h : t ≤ ∑ i, X i ω
    · exact Or.inl h
    · right
      by_contra hnot
      exact (not_lt_of_ge hω) ((abs_lt).2 (by constructor <;> [linarith; linarith]))
  have hunion : μ.real ({ω | ∑ i, X i ω ≥ t} ∪ {ω | -∑ i, X i ω ≥ t}) ≤
      μ.real {ω | ∑ i, X i ω ≥ t} + μ.real {ω | -∑ i, X i ω ≥ t} := by
    rw [Measure.real_def, Measure.real_def, Measure.real_def]
    calc
      (μ ({ω | ∑ i, X i ω ≥ t} ∪ {ω | -∑ i, X i ω ≥ t})).toReal ≤
          (μ {ω | ∑ i, X i ω ≥ t} + μ {ω | -∑ i, X i ω ≥ t}).toReal := by
        refine ENNReal.toReal_mono ?_ (measure_union_le _ _)
        exact ENNReal.add_ne_top.mpr ⟨measure_ne_top μ _, measure_ne_top μ _⟩
      _ = (μ {ω | ∑ i, X i ω ≥ t}).toReal + (μ {ω | -∑ i, X i ω ≥ t}).toReal :=
        ENNReal.toReal_add (measure_ne_top μ _) (measure_ne_top μ _)
  calc
    μ.real {ω | |∑ i, X i ω| ≥ t} ≤
        μ.real ({ω | ∑ i, X i ω ≥ t} ∪ {ω | -∑ i, X i ω ≥ t}) := by
      rw [Measure.real_def, Measure.real_def]
      exact ENNReal.toReal_mono (measure_ne_top μ _) (measure_mono hsubset)
    _ ≤ μ.real {ω | ∑ i, X i ω ≥ t} + μ.real {ω | -∑ i, X i ω ≥ t} := hunion
    _ ≤ _ := by
      have := add_le_add hupper hlower
      linarith

/-- **Theorem 2.8.4** (printed page 38): Bernstein's inequality for bounded
distributions, obtained by feeding Exercise 2.8.5 into the Exercise 2.8.6
deduction.  The printed constants `t²/2` and `σ² + K t / 3` are exact. -/
theorem bernsteinBoundedTail
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {K : ℝ} (hK : 0 < K)
    (hX : ∀ i, Measurable (X i))
    (hCenter : ∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0)
    (hBound : ∀ i, ∀ᵐ ω ∂μ, |X i ω| ≤ K)
    (hIndep : iIndepFun X μ)
    {t : ℝ} (ht : 0 ≤ t) :
    μ.real {ω | |∑ i, X i ω| ≥ t} ≤
      2 * Real.exp (-((t ^ 2 / 2) /
        ((∑ i, ∫ ω, X i ω ^ 2 ∂μ) + K * t / 3))) :=
  bernsteinBoundedTailOfMGFBound hK hX hCenter hBound hIndep
    (boundedCenteredMGFHypothesis_holds hK) ht

/-! ### The printed `ψ₁` form of Theorem 2.8.1

The results above are stated in the window/MGF scale, which is the scale the
proof works in.  The printed theorem is stated in the sub-exponential norm
`‖X‖_{ψ₁}` of Definition 2.7.5.  `psiOneGaugeToLinearMGF_le` converts one into
the other at the cost of an absolute constant factor, and `bernsteinTailPsiOne`
below is the printed statement itself, over the exact per-index gauges
`‖X_i‖_{ψ₁}` and their exact maximum.

`PsiOneGauge` is an infimum, so in the positive-energy case the conversion is
applied at the inflated scale `‖X_i‖_{ψ₁} + ε` and the printed denominators are
recovered by letting `ε → 0⁺`.  When every gauge vanishes, Lean's totalized
division makes the quadratic branch zero, so the displayed right-hand side is
`2` and the conclusion follows from the probability bound `≤ 1`. -/

/-- The absolute constant produced by the `ψ₁`-to-window conversion. -/
private noncomputable def psiOneScale : ℝ := 4096 * (Real.exp 1) ^ 4

private lemma one_le_psiOneScale : (1 : ℝ) ≤ psiOneScale := by
  have he : (1 : ℝ) ≤ Real.exp 1 := Real.one_le_exp (by norm_num)
  have h4 : (1 : ℝ) ≤ (Real.exp 1) ^ 4 := by
    rw [← Real.exp_nat_mul]
    exact Real.one_le_exp (by norm_num)
  unfold psiOneScale
  nlinarith [he, h4]

private lemma psiOneScale_pos : 0 < psiOneScale :=
  lt_of_lt_of_le zero_lt_one one_le_psiOneScale

/-- Theorem 2.8.1 (Bernstein's inequality) in the printed sub-exponential norm.

`X i` are independent, mean zero and sub-exponential; writing
`κ i = ‖X i‖_{ψ₁}`, the tail of `∑ X i` obeys the two-regime bound with
denominators `∑ i, κ i ^ 2` and `max i, κ i`, exactly as printed on page 36. -/
theorem bernsteinTailPsiOne
    : ∃ c : ℝ, 0 < c ∧
      ∀ {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
        {μ : Measure Ω} [IsProbabilityMeasure μ]
        {X : ι → Ω → ℝ} (hne : (Finset.univ : Finset ι).Nonempty),
        (∀ i, Measurable (X i)) →
        (∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0) →
        (∀ i, PsiOneGauge μ (X i) < ∞) →
        iIndepFun X μ →
        ∀ {t : ℝ}, 0 ≤ t →
          μ.real {ω | |∑ i, X i ω| ≥ t} ≤
            2 * Real.exp (-(c *
              min (t ^ 2 / ∑ i, ((PsiOneGauge μ (X i)).toReal) ^ 2)
                  (t / Finset.univ.sup' hne
                    (fun i => (PsiOneGauge μ (X i)).toReal)))) := by
  classical
  have hC : 0 < psiOneScale := psiOneScale_pos
  have hC1 : (1 : ℝ) ≤ psiOneScale := one_le_psiOneScale
  refine ⟨(4 * psiOneScale ^ 2)⁻¹, by positivity, ?_⟩
  intro ι Ω _ _ μ _ X hne hmeas hCenter hSubExp hIndep t ht
  set κ : ι → ℝ := fun i => (PsiOneGauge μ (X i)).toReal with hκ
  have hκnonneg : ∀ i, 0 ≤ κ i := fun i => ENNReal.toReal_nonneg
  set S : ℝ := ∑ i, κ i ^ 2 with hS
  set m : ℝ := Finset.univ.sup' hne κ with hm
  have hSnonneg : 0 ≤ S := by
    rw [hS]
    exact Finset.sum_nonneg fun i _ => sq_nonneg (κ i)
  by_cases hEnergy : 0 < S
  swap
  · have hSzero : S = 0 := le_antisymm (le_of_not_gt hEnergy) hSnonneg
    have hmnonneg : 0 ≤ m :=
      le_trans (hκnonneg hne.choose)
        (Finset.le_sup' κ (Finset.mem_univ hne.choose))
    have hmin : min (t ^ 2 / S) (t / m) = 0 := by
      rw [hSzero, div_zero, min_eq_left]
      exact div_nonneg ht hmnonneg
    have hprob : μ.real {ω | |∑ i, X i ω| ≥ t} ≤ 1 := by
      rw [Measure.real_def]
      exact ENNReal.toReal_mono ENNReal.one_ne_top prob_le_one
    refine hprob.trans ?_
    rw [hmin, mul_zero, neg_zero, Real.exp_zero]
    norm_num
  have hSpos : 0 < S := hEnergy
  -- the maximum is positive, else every gauge would vanish
  have hmpos : 0 < m := by
    rcases lt_or_ge 0 m with h | h
    · exact h
    · exfalso
      have hzero : ∀ i, κ i = 0 := by
        intro i
        have hle : κ i ≤ m := Finset.le_sup' κ (Finset.mem_univ i)
        have := le_trans hle h
        exact le_antisymm this (hκnonneg i)
      have : S = 0 := by
        rw [hS]
        exact Finset.sum_eq_zero (fun i _ => by rw [hzero i]; ring)
      exact absurd this hSpos.ne'
  -- for every positive inflation `e` the window form applies
  have hstep : ∀ e : ℝ, 0 < e →
      μ.real {ω | |∑ i, X i ω| ≥ t} ≤
        2 * Real.exp (-min (t ^ 2 / (4 * ∑ i, (psiOneScale * (κ i + e)) ^ 2))
          (t / (2 * (psiOneScale * (m + e))))) := by
    intro e he
    have hKpos : ∀ i, 0 < κ i + e := fun i => by
      have := hκnonneg i; linarith
    have hX : ∀ i, SubExponentialLinearMGF μ (X i) (psiOneScale * (κ i + e)) := by
      intro i
      have hgauge : PsiOneGauge μ (X i) ≤ ENNReal.ofReal (κ i + e) := by
        have hEq : PsiOneGauge μ (X i) = ENNReal.ofReal (κ i) := by
          rw [hκ]
          exact (ENNReal.ofReal_toReal (hSubExp i).ne).symm
        rw [hEq]
        exact ENNReal.ofReal_le_ofReal (by linarith)
      exact psiOneGaugeToLinearMGF_le (hmeas i) (hKpos i) (hCenter i) hgauge
    have hmax : ∀ i, psiOneScale * (κ i + e) ≤ psiOneScale * (m + e) := by
      intro i
      have hle : κ i ≤ m := Finset.le_sup' κ (Finset.mem_univ i)
      exact mul_le_mul_of_nonneg_left (by linarith) hC.le
    have hMpos : 0 < psiOneScale * (m + e) := by positivity
    have hEnergy' : 0 < ∑ i, (psiOneScale * (κ i + e)) ^ 2 := by
      obtain ⟨i, -⟩ := hne
      refine Finset.sum_pos' (fun j _ => by positivity) ⟨i, Finset.mem_univ i, ?_⟩
      have := hKpos i
      positivity
    exact bernsteinTail hX hIndep hMpos hmax hEnergy' ht
  -- the inflated bound is continuous at `e = 0`
  set F : ℝ → ℝ := fun e => ∑ i, (κ i + e) ^ 2 with hF
  have hFzero : F 0 = S := by
    rw [hF, hS]; simp
  have hsum_eq : ∀ e : ℝ,
      (∑ i, (psiOneScale * (κ i + e)) ^ 2) = psiOneScale ^ 2 * F e := by
    intro e
    rw [hF, Finset.mul_sum]
    exact Finset.sum_congr rfl (fun i _ => by ring)
  set g : ℝ → ℝ := fun e =>
    2 * Real.exp (-min (t ^ 2 / (4 * (psiOneScale ^ 2 * F e)))
      (t / (2 * (psiOneScale * (m + e))))) with hg
  have hFcont : Continuous F := by
    rw [hF]; fun_prop
  have hden1 : 4 * (psiOneScale ^ 2 * F 0) ≠ 0 := by
    rw [hFzero]; positivity
  have hden2 : 2 * (psiOneScale * (m + 0)) ≠ 0 := by
    simp only [add_zero]; positivity
  have hgcont : ContinuousAt g 0 := by
    rw [hg]
    have h1 : ContinuousAt (fun e : ℝ => t ^ 2 / (4 * (psiOneScale ^ 2 * F e))) 0 :=
      ContinuousAt.div continuousAt_const
        ((continuous_const.mul (continuous_const.mul hFcont)).continuousAt) hden1
    have h2 : ContinuousAt
        (fun e : ℝ => t / (2 * (psiOneScale * (m + e)))) 0 :=
      ContinuousAt.div continuousAt_const (by fun_prop) hden2
    exact continuousAt_const.mul
      ((Real.continuous_exp.continuousAt).comp ((h1.min h2).neg))
  have hlim : Filter.Tendsto g (nhdsWithin 0 (Set.Ioi 0)) (nhds (g 0)) :=
    hgcont.tendsto.mono_left nhdsWithin_le_nhds
  have hev : ∀ᶠ e in nhdsWithin (0 : ℝ) (Set.Ioi 0),
      μ.real {ω | |∑ i, X i ω| ≥ t} ≤ g e := by
    refine Filter.eventually_iff_exists_mem.2 ⟨Set.Ioi 0, ?_, ?_⟩
    · exact self_mem_nhdsWithin
    · intro e he
      have := hstep e he
      rw [hg]
      rw [hsum_eq e] at this
      exact this
  have hle0 : μ.real {ω | |∑ i, X i ω| ≥ t} ≤ g 0 :=
    ge_of_tendsto hlim hev
  -- compare the explicit window constants with the printed ones
  refine hle0.trans ?_
  rw [hg]
  simp only [hFzero, add_zero]
  apply mul_le_mul_of_nonneg_left _ (by norm_num : (0:ℝ) ≤ 2)
  apply Real.exp_le_exp.2
  have hkey : (4 * psiOneScale ^ 2)⁻¹ * min (t ^ 2 / S) (t / m) ≤
      min (t ^ 2 / (4 * (psiOneScale ^ 2 * S))) (t / (2 * (psiOneScale * m))) := by
    rw [le_min_iff]
    constructor
    · have h1 : (4 * psiOneScale ^ 2)⁻¹ * min (t ^ 2 / S) (t / m) ≤
          (4 * psiOneScale ^ 2)⁻¹ * (t ^ 2 / S) := by
        apply mul_le_mul_of_nonneg_left (min_le_left _ _) (by positivity)
      refine h1.trans (le_of_eq ?_)
      field_simp
    · have h2 : (4 * psiOneScale ^ 2)⁻¹ * min (t ^ 2 / S) (t / m) ≤
          (4 * psiOneScale ^ 2)⁻¹ * (t / m) := by
        apply mul_le_mul_of_nonneg_left (min_le_right _ _) (by positivity)
      refine h2.trans ?_
      have heq : (4 * psiOneScale ^ 2)⁻¹ * (t / m) =
          t / (4 * psiOneScale ^ 2 * m) := by
        field_simp
      rw [heq]
      have hscale : 2 * (psiOneScale * m) ≤ 4 * psiOneScale ^ 2 * m := by
        have hfac : 0 ≤ 2 * psiOneScale * m * (2 * psiOneScale - 1) := by
          have h1 : 0 ≤ 2 * psiOneScale * m :=
            mul_nonneg (by linarith) hmpos.le
          have h2 : 0 ≤ 2 * psiOneScale - 1 := by linarith
          exact mul_nonneg h1 h2
        nlinarith [hfac]
      exact div_le_div_of_nonneg_left ht (by positivity) hscale
  linarith [hkey]

/-- Theorem 2.8.2 (Bernstein's inequality, weighted) in the printed
sub-exponential norm.  With `K = max_i ‖X i‖_{ψ₁}`, `‖a‖₂² = ∑ i, a i ^ 2` and
`‖a‖_∞ = max_i |a i|`, the printed denominators `K² ‖a‖₂²` and `K ‖a‖_∞` appear
literally.

The zero-gauge and zero-weight cases use Lean's totalized real division and the
trivial probability bound; no nondegeneracy premise is added to the printed
statement. -/
theorem bernsteinWeightedTailPsiOne :
    ∃ c : ℝ, 0 < c ∧
      ∀ {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
        {μ : Measure Ω} [IsProbabilityMeasure μ]
        {X : ι → Ω → ℝ} {a : ι → ℝ} (hne : (Finset.univ : Finset ι).Nonempty),
        (∀ i, Measurable (X i)) →
        (∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0) →
        (∀ i, PsiOneGauge μ (X i) < ∞) →
        iIndepFun X μ →
        ∀ {t : ℝ}, 0 ≤ t →
          μ.real {ω | |∑ i, a i * X i ω| ≥ t} ≤
            2 * Real.exp (-(c *
              min (t ^ 2 /
                    ((Finset.univ.sup' hne
                        (fun i => (PsiOneGauge μ (X i)).toReal)) ^ 2 *
                      ∑ i, a i ^ 2))
                  (t / ((Finset.univ.sup' hne
                        (fun i => (PsiOneGauge μ (X i)).toReal)) *
                      Finset.univ.sup' hne (fun i => |a i|))))) := by
  classical
  have hC : 0 < psiOneScale := psiOneScale_pos
  have hC1 : (1 : ℝ) ≤ psiOneScale := one_le_psiOneScale
  refine ⟨(4 * psiOneScale ^ 2)⁻¹, by positivity, ?_⟩
  intro ι Ω _ _ μ _ X a hne hmeas hCenter hSubExp hIndep t ht
  set κ : ι → ℝ := fun i => (PsiOneGauge μ (X i)).toReal with hκ
  set m : ℝ := Finset.univ.sup' hne κ with hm
  set A2 : ℝ := ∑ i, a i ^ 2 with hA2def
  set Ainf : ℝ := Finset.univ.sup' hne (fun i => |a i|) with hAinf
  have hκnonneg : ∀ i, 0 ≤ κ i := fun i => ENNReal.toReal_nonneg
  have hmnonneg : 0 ≤ m :=
    le_trans (hκnonneg hne.choose)
      (Finset.le_sup' κ (Finset.mem_univ hne.choose))
  have hA2nonneg : 0 ≤ A2 := by
    rw [hA2def]
    exact Finset.sum_nonneg fun i _ => sq_nonneg (a i)
  have hAinfnonneg : 0 ≤ Ainf :=
    le_trans (abs_nonneg (a hne.choose))
      (Finset.le_sup' (fun i => |a i|) (Finset.mem_univ hne.choose))
  by_cases hmpos : 0 < m
  swap
  · have hmzero : m = 0 := le_antisymm (le_of_not_gt hmpos) hmnonneg
    have hmin : min (t ^ 2 / (m ^ 2 * A2)) (t / (m * Ainf)) = 0 := by
      rw [hmzero]
      norm_num
    have hprob : μ.real {ω | |∑ i, a i * X i ω| ≥ t} ≤ 1 := by
      rw [Measure.real_def]
      exact ENNReal.toReal_mono ENNReal.one_ne_top prob_le_one
    refine hprob.trans ?_
    rw [hmin, mul_zero, neg_zero, Real.exp_zero]
    norm_num
  by_cases hA2pos : 0 < A2
  swap
  · have hA2zero : A2 = 0 := le_antisymm (le_of_not_gt hA2pos) hA2nonneg
    have hmin : min (t ^ 2 / (m ^ 2 * A2)) (t / (m * Ainf)) = 0 := by
      rw [hA2zero, mul_zero, div_zero, min_eq_left]
      exact div_nonneg ht (mul_nonneg hmpos.le hAinfnonneg)
    have hprob : μ.real {ω | |∑ i, a i * X i ω| ≥ t} ≤ 1 := by
      rw [Measure.real_def]
      exact ENNReal.toReal_mono ENNReal.one_ne_top prob_le_one
    refine hprob.trans ?_
    rw [hmin, mul_zero, neg_zero, Real.exp_zero]
    norm_num
  have hAinfpos : 0 < Ainf := by
    by_contra hcon
    push_neg at hcon
    have hzero : ∀ i, a i = 0 := by
      intro i
      have hle : |a i| ≤ Ainf := Finset.le_sup' (fun i => |a i|) (Finset.mem_univ i)
      have : |a i| ≤ 0 := le_trans hle hcon
      exact abs_eq_zero.1 (le_antisymm this (abs_nonneg _))
    have : A2 = 0 := by
      rw [hA2def]
      exact Finset.sum_eq_zero (fun i _ => by rw [hzero i]; ring)
    exact absurd this hA2pos.ne'
  -- window form at the inflated uniform scale `psiOneScale * (m + e)`
  have hstep : ∀ e : ℝ, 0 < e →
      μ.real {ω | |∑ i, a i * X i ω| ≥ t} ≤
        2 * Real.exp (-min
          (t ^ 2 / (4 * (psiOneScale ^ 2 * (m + e) ^ 2 * A2)))
          (t / (2 * (psiOneScale * (m + e) * Ainf)))) := by
    intro e he
    have hme : 0 < m + e := by linarith
    have hKpos : 0 < psiOneScale * (m + e) := by positivity
    have hX : ∀ i, SubExponentialLinearMGF μ (X i) (psiOneScale * (m + e)) := by
      intro i
      have hgauge : PsiOneGauge μ (X i) ≤ ENNReal.ofReal (m + e) := by
        have hEq : PsiOneGauge μ (X i) = ENNReal.ofReal (κ i) := by
          rw [hκ]; exact (ENNReal.ofReal_toReal (hSubExp i).ne).symm
        have hle : κ i ≤ m := Finset.le_sup' κ (Finset.mem_univ i)
        rw [hEq]
        exact ENNReal.ofReal_le_ofReal (by linarith)
      exact psiOneGaugeToLinearMGF_le (hmeas i) hme (hCenter i) hgauge
    have hwindow : ∀ i, |a i| * (psiOneScale * (m + e)) ≤
        psiOneScale * (m + e) * Ainf := by
      intro i
      have hle : |a i| ≤ Ainf := Finset.le_sup' (fun i => |a i|) (Finset.mem_univ i)
      calc
        |a i| * (psiOneScale * (m + e)) ≤ Ainf * (psiOneScale * (m + e)) :=
          mul_le_mul_of_nonneg_right hle hKpos.le
        _ = psiOneScale * (m + e) * Ainf := by ring
    have hMpos : 0 < psiOneScale * (m + e) * Ainf := by positivity
    have hEnergy' : 0 < ∑ i, (a i * (psiOneScale * (m + e))) ^ 2 := by
      have heq : (∑ i, (a i * (psiOneScale * (m + e))) ^ 2) =
          (psiOneScale * (m + e)) ^ 2 * A2 := by
        rw [hA2def, Finset.mul_sum]
        exact Finset.sum_congr rfl (fun i _ => by ring)
      rw [heq]; positivity
    have h := bernsteinWeightedTail hX hIndep hMpos hwindow hEnergy' ht
    have heq : (∑ i, (a i * (psiOneScale * (m + e))) ^ 2) =
        psiOneScale ^ 2 * (m + e) ^ 2 * A2 := by
      rw [hA2def, Finset.mul_sum]
      exact Finset.sum_congr rfl (fun i _ => by ring)
    rw [heq] at h
    exact h
  -- continuity in the inflation parameter
  set g : ℝ → ℝ := fun e =>
    2 * Real.exp (-min (t ^ 2 / (4 * (psiOneScale ^ 2 * (m + e) ^ 2 * A2)))
      (t / (2 * (psiOneScale * (m + e) * Ainf)))) with hg
  have hden1 : 4 * (psiOneScale ^ 2 * (m + 0) ^ 2 * A2) ≠ 0 := by
    simp only [add_zero]; positivity
  have hden2 : 2 * (psiOneScale * (m + 0) * Ainf) ≠ 0 := by
    simp only [add_zero]; positivity
  have hgcont : ContinuousAt g 0 := by
    rw [hg]
    have h1 : ContinuousAt
        (fun e : ℝ => t ^ 2 / (4 * (psiOneScale ^ 2 * (m + e) ^ 2 * A2))) 0 :=
      ContinuousAt.div continuousAt_const (by fun_prop) hden1
    have h2 : ContinuousAt
        (fun e : ℝ => t / (2 * (psiOneScale * (m + e) * Ainf))) 0 :=
      ContinuousAt.div continuousAt_const (by fun_prop) hden2
    exact continuousAt_const.mul
      ((Real.continuous_exp.continuousAt).comp ((h1.min h2).neg))
  have hlim : Filter.Tendsto g (nhdsWithin 0 (Set.Ioi 0)) (nhds (g 0)) :=
    hgcont.tendsto.mono_left nhdsWithin_le_nhds
  have hev : ∀ᶠ e in nhdsWithin (0 : ℝ) (Set.Ioi 0),
      μ.real {ω | |∑ i, a i * X i ω| ≥ t} ≤ g e :=
    Filter.eventually_iff_exists_mem.2
      ⟨Set.Ioi 0, self_mem_nhdsWithin, fun e he => by rw [hg]; exact hstep e he⟩
  have hle0 : μ.real {ω | |∑ i, a i * X i ω| ≥ t} ≤ g 0 := ge_of_tendsto hlim hev
  refine hle0.trans ?_
  rw [hg]
  simp only [add_zero]
  apply mul_le_mul_of_nonneg_left _ (by norm_num : (0:ℝ) ≤ 2)
  apply Real.exp_le_exp.2
  have hkey : (4 * psiOneScale ^ 2)⁻¹ * min (t ^ 2 / (m ^ 2 * A2)) (t / (m * Ainf)) ≤
      min (t ^ 2 / (4 * (psiOneScale ^ 2 * m ^ 2 * A2)))
        (t / (2 * (psiOneScale * m * Ainf))) := by
    rw [le_min_iff]
    constructor
    · have h1 : (4 * psiOneScale ^ 2)⁻¹ *
          min (t ^ 2 / (m ^ 2 * A2)) (t / (m * Ainf)) ≤
          (4 * psiOneScale ^ 2)⁻¹ * (t ^ 2 / (m ^ 2 * A2)) :=
        mul_le_mul_of_nonneg_left (min_le_left _ _) (by positivity)
      refine h1.trans (le_of_eq ?_)
      field_simp
    · have h2 : (4 * psiOneScale ^ 2)⁻¹ *
          min (t ^ 2 / (m ^ 2 * A2)) (t / (m * Ainf)) ≤
          (4 * psiOneScale ^ 2)⁻¹ * (t / (m * Ainf)) :=
        mul_le_mul_of_nonneg_left (min_le_right _ _) (by positivity)
      refine h2.trans ?_
      have heq : (4 * psiOneScale ^ 2)⁻¹ * (t / (m * Ainf)) =
          t / (4 * psiOneScale ^ 2 * (m * Ainf)) := by field_simp
      rw [heq]
      have hscale : 2 * (psiOneScale * m * Ainf) ≤
          4 * psiOneScale ^ 2 * (m * Ainf) := by
        have hfac : 0 ≤ 2 * psiOneScale * (m * Ainf) * (2 * psiOneScale - 1) := by
          have h1 : 0 ≤ 2 * psiOneScale * (m * Ainf) :=
            mul_nonneg (by linarith) (by positivity)
          have h2 : 0 ≤ 2 * psiOneScale - 1 := by linarith
          exact mul_nonneg h1 h2
        nlinarith [hfac]
      exact div_le_div_of_nonneg_left ht (by positivity) hscale
  linarith [hkey]

/-- Corollary 2.8.3 (Bernstein's inequality for averages) in the printed
sub-exponential norm.  With `K = max_i ‖X i‖_{ψ₁}` and `N = card ι`, the printed
right-hand side `2 exp(-c min(t²/K², t/K) N)` appears literally. -/
theorem bernsteinAverageTailPsiOne
    : ∃ c : ℝ, 0 < c ∧
      ∀ {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
        {μ : Measure Ω} [IsProbabilityMeasure μ]
        {X : ι → Ω → ℝ} (hne : (Finset.univ : Finset ι).Nonempty),
        (∀ i, Measurable (X i)) →
        (∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0) →
        (∀ i, PsiOneGauge μ (X i) < ∞) →
        iIndepFun X μ →
        ∀ {t : ℝ}, 0 ≤ t →
          μ.real {ω | |∑ i, (Fintype.card ι : ℝ)⁻¹ * X i ω| ≥ t} ≤
            2 * Real.exp (-(c *
              min (t ^ 2 / (Finset.univ.sup' hne
                    (fun i => (PsiOneGauge μ (X i)).toReal)) ^ 2)
                  (t / Finset.univ.sup' hne
                    (fun i => (PsiOneGauge μ (X i)).toReal)) *
                (Fintype.card ι : ℝ))) := by
  classical
  have hC : 0 < psiOneScale := psiOneScale_pos
  have hC1 : (1 : ℝ) ≤ psiOneScale := one_le_psiOneScale
  refine ⟨(4 * psiOneScale ^ 2)⁻¹, by positivity, ?_⟩
  intro ι Ω _ _ μ _ X hne hmeas hCenter hSubExp hIndep t ht
  set κ : ι → ℝ := fun i => (PsiOneGauge μ (X i)).toReal with hκ
  set m : ℝ := Finset.univ.sup' hne κ with hm
  have hκnonneg : ∀ i, 0 ≤ κ i := fun i => ENNReal.toReal_nonneg
  have hmnonneg : 0 ≤ m :=
    le_trans (hκnonneg hne.choose)
      (Finset.le_sup' κ (Finset.mem_univ hne.choose))
  have hcard : 0 < Fintype.card ι := by
    rw [← Finset.card_univ]
    exact Finset.card_pos.2 hne
  have hN : (0 : ℝ) < (Fintype.card ι : ℝ) := by exact_mod_cast hcard
  by_cases hmpos : 0 < m
  swap
  · have hmzero : m = 0 := le_antisymm (le_of_not_gt hmpos) hmnonneg
    have hprob : μ.real {ω | |∑ i, (Fintype.card ι : ℝ)⁻¹ * X i ω| ≥ t} ≤ 1 := by
      rw [Measure.real_def]
      exact ENNReal.toReal_mono ENNReal.one_ne_top prob_le_one
    refine hprob.trans ?_
    rw [hmzero]
    norm_num
  have hstep : ∀ e : ℝ, 0 < e →
      μ.real {ω | |∑ i, (Fintype.card ι : ℝ)⁻¹ * X i ω| ≥ t} ≤
        2 * Real.exp (-min
          (t ^ 2 / (4 * ((Fintype.card ι : ℝ)⁻¹ *
            (psiOneScale * (m + e)) ^ 2)))
          (t / (2 * ((Fintype.card ι : ℝ)⁻¹ * (psiOneScale * (m + e)))))) := by
    intro e he
    have hme : 0 < m + e := by linarith
    have hKpos : 0 < psiOneScale * (m + e) := by positivity
    have hX : ∀ i, SubExponentialLinearMGF μ (X i) (psiOneScale * (m + e)) := by
      intro i
      have hgauge : PsiOneGauge μ (X i) ≤ ENNReal.ofReal (m + e) := by
        have hEq : PsiOneGauge μ (X i) = ENNReal.ofReal (κ i) := by
          rw [hκ]; exact (ENNReal.ofReal_toReal (hSubExp i).ne).symm
        have hle : κ i ≤ m := Finset.le_sup' κ (Finset.mem_univ i)
        rw [hEq]
        exact ENNReal.ofReal_le_ofReal (by linarith)
      exact psiOneGaugeToLinearMGF_le (hmeas i) hme (hCenter i) hgauge
    have h := bernsteinAverageTail hKpos hX hIndep hcard ht
    have hsum : (∑ _i : ι, ((Fintype.card ι : ℝ)⁻¹ *
        (psiOneScale * (m + e))) ^ 2) =
        (Fintype.card ι : ℝ)⁻¹ * (psiOneScale * (m + e)) ^ 2 := by
      rw [Finset.sum_const, Finset.card_univ, nsmul_eq_mul]
      field_simp
    rw [hsum] at h
    exact h
  set g : ℝ → ℝ := fun e =>
    2 * Real.exp (-min
      (t ^ 2 / (4 * ((Fintype.card ι : ℝ)⁻¹ * (psiOneScale * (m + e)) ^ 2)))
      (t / (2 * ((Fintype.card ι : ℝ)⁻¹ * (psiOneScale * (m + e)))))) with hg
  have hden1 : 4 * ((Fintype.card ι : ℝ)⁻¹ *
      (psiOneScale * (m + 0)) ^ 2) ≠ 0 := by
    simp only [add_zero]; positivity
  have hden2 : 2 * ((Fintype.card ι : ℝ)⁻¹ *
      (psiOneScale * (m + 0))) ≠ 0 := by
    simp only [add_zero]; positivity
  have hgcont : ContinuousAt g 0 := by
    rw [hg]
    have h1 : ContinuousAt (fun e : ℝ => t ^ 2 /
        (4 * ((Fintype.card ι : ℝ)⁻¹ * (psiOneScale * (m + e)) ^ 2))) 0 :=
      ContinuousAt.div continuousAt_const (by fun_prop) hden1
    have h2 : ContinuousAt (fun e : ℝ => t /
        (2 * ((Fintype.card ι : ℝ)⁻¹ * (psiOneScale * (m + e))))) 0 :=
      ContinuousAt.div continuousAt_const (by fun_prop) hden2
    exact continuousAt_const.mul
      ((Real.continuous_exp.continuousAt).comp ((h1.min h2).neg))
  have hlim : Filter.Tendsto g (nhdsWithin 0 (Set.Ioi 0)) (nhds (g 0)) :=
    hgcont.tendsto.mono_left nhdsWithin_le_nhds
  have hev : ∀ᶠ e in nhdsWithin (0 : ℝ) (Set.Ioi 0),
      μ.real {ω | |∑ i, (Fintype.card ι : ℝ)⁻¹ * X i ω| ≥ t} ≤ g e :=
    Filter.eventually_iff_exists_mem.2
      ⟨Set.Ioi 0, self_mem_nhdsWithin, fun e he => by rw [hg]; exact hstep e he⟩
  have hle0 : μ.real {ω | |∑ i, (Fintype.card ι : ℝ)⁻¹ * X i ω| ≥ t} ≤ g 0 :=
    ge_of_tendsto hlim hev
  refine hle0.trans ?_
  rw [hg]
  simp only [add_zero]
  apply mul_le_mul_of_nonneg_left _ (by norm_num : (0:ℝ) ≤ 2)
  apply Real.exp_le_exp.2
  have hkey : (4 * psiOneScale ^ 2)⁻¹ * min (t ^ 2 / m ^ 2) (t / m) *
      (Fintype.card ι : ℝ) ≤
      min (t ^ 2 / (4 * ((Fintype.card ι : ℝ)⁻¹ * (psiOneScale * m) ^ 2)))
        (t / (2 * ((Fintype.card ι : ℝ)⁻¹ * (psiOneScale * m)))) := by
    rw [le_min_iff]
    constructor
    · have h1 : (4 * psiOneScale ^ 2)⁻¹ * min (t ^ 2 / m ^ 2) (t / m) *
          (Fintype.card ι : ℝ) ≤
          (4 * psiOneScale ^ 2)⁻¹ * (t ^ 2 / m ^ 2) * (Fintype.card ι : ℝ) := by
        have hin := mul_le_mul_of_nonneg_left
          (min_le_left (t ^ 2 / m ^ 2) (t / m))
          (by positivity : (0:ℝ) ≤ (4 * psiOneScale ^ 2)⁻¹)
        exact mul_le_mul_of_nonneg_right hin hN.le
      refine h1.trans (le_of_eq ?_)
      field_simp
    · have h2 : (4 * psiOneScale ^ 2)⁻¹ * min (t ^ 2 / m ^ 2) (t / m) *
          (Fintype.card ι : ℝ) ≤
          (4 * psiOneScale ^ 2)⁻¹ * (t / m) * (Fintype.card ι : ℝ) := by
        have hin := mul_le_mul_of_nonneg_left
          (min_le_right (t ^ 2 / m ^ 2) (t / m))
          (by positivity : (0:ℝ) ≤ (4 * psiOneScale ^ 2)⁻¹)
        exact mul_le_mul_of_nonneg_right hin hN.le
      refine h2.trans ?_
      have heqL : (4 * psiOneScale ^ 2)⁻¹ * (t / m) * (Fintype.card ι : ℝ) =
          t * (Fintype.card ι : ℝ) / (4 * psiOneScale ^ 2 * m) := by
        field_simp
      have heqR : t / (2 * ((Fintype.card ι : ℝ)⁻¹ * (psiOneScale * m))) =
          t * (Fintype.card ι : ℝ) / (2 * (psiOneScale * m)) := by
        rw [div_eq_div_iff (by positivity) (by positivity)]
        field_simp
      rw [heqL, heqR]
      have hscale : 2 * (psiOneScale * m) ≤ 4 * psiOneScale ^ 2 * m := by
        have hfac : 0 ≤ 2 * psiOneScale * m * (2 * psiOneScale - 1) := by
          have ha : 0 ≤ 2 * psiOneScale * m := mul_nonneg (by linarith) hmpos.le
          have hb : 0 ≤ 2 * psiOneScale - 1 := by linarith
          exact mul_nonneg ha hb
        nlinarith [hfac]
      exact div_le_div_of_nonneg_left (by positivity) (by positivity) hscale
  linarith [hkey]

/-- The central-limit normalization of Bernstein's inequality in the printed
`ψ₁` gauge.  This is the exact `min` estimate underlying the two-regime display
after Corollary 2.8.3: with `N = card ι` and
`K = max_i ‖X i‖_{ψ₁}`, the rate is
`min (t² / K²) (t * sqrt N / K)`.

The all-zero-gauge case retains Lean's totalized real-division convention, as in
the three preceding printed-form wrappers. -/
theorem bernsteinNormalizedTailPsiOne :
    ∃ c : ℝ, 0 < c ∧
      ∀ {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
        {μ : Measure Ω} [IsProbabilityMeasure μ]
        {X : ι → Ω → ℝ} (hne : (Finset.univ : Finset ι).Nonempty),
        (∀ i, Measurable (X i)) →
        (∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0) →
        (∀ i, PsiOneGauge μ (X i) < ∞) →
        iIndepFun X μ →
        ∀ {t : ℝ}, 0 ≤ t →
          μ.real {ω | |∑ i,
              (Real.sqrt (Fintype.card ι : ℝ))⁻¹ * X i ω| ≥ t} ≤
            2 * Real.exp (-(c *
              min (t ^ 2 / (Finset.univ.sup' hne
                    (fun i => (PsiOneGauge μ (X i)).toReal)) ^ 2)
                  (t * Real.sqrt (Fintype.card ι : ℝ) /
                    Finset.univ.sup' hne
                      (fun i => (PsiOneGauge μ (X i)).toReal)))) := by
  classical
  rcases bernsteinWeightedTailPsiOne with ⟨c, hc, htail⟩
  refine ⟨c, hc, ?_⟩
  intro ι Ω _ _ μ _ X hne hmeas hCenter hSubExp hIndep t ht
  have hcard : 0 < Fintype.card ι := by
    rw [← Finset.card_univ]
    exact Finset.card_pos.2 hne
  have hN : (0 : ℝ) < (Fintype.card ι : ℝ) := by exact_mod_cast hcard
  have hsqrt : 0 < Real.sqrt (Fintype.card ι : ℝ) := Real.sqrt_pos.2 hN
  have hsum : (∑ _i : ι, (Real.sqrt (Fintype.card ι : ℝ))⁻¹ ^ 2) = 1 := by
    rw [Finset.sum_const, Finset.card_univ, nsmul_eq_mul]
    rw [inv_pow]
    field_simp [Real.sq_sqrt hN.le]
    exact (Real.sq_sqrt hN.le).symm
  have hsup : Finset.univ.sup' hne
      (fun _i : ι => |(Real.sqrt (Fintype.card ι : ℝ))⁻¹|) =
      (Real.sqrt (Fintype.card ι : ℝ))⁻¹ := by
    simp [abs_of_pos (inv_pos.mpr hsqrt)]
  have h := htail (X := X)
    (a := fun _ => (Real.sqrt (Fintype.card ι : ℝ))⁻¹)
    hne hmeas hCenter hSubExp hIndep ht
  rw [hsum, hsup, mul_one] at h
  have hlinear : t /
      ((Finset.univ.sup' hne fun i => (PsiOneGauge μ (X i)).toReal) *
        (Real.sqrt (Fintype.card ι : ℝ))⁻¹) =
      t * Real.sqrt (Fintype.card ι : ℝ) /
        Finset.univ.sup' hne (fun i => (PsiOneGauge μ (X i)).toReal) := by
    by_cases hm : Finset.univ.sup' hne
        (fun i => (PsiOneGauge μ (X i)).toReal) = 0
    · simp [hm]
    · field_simp [hm, hsqrt.ne']
  rw [hlinear] at h
  simpa using h

/-- A corrected two-regime consequence of `bernsteinNormalizedTailPsiOne` on
the nondegenerate domain `K > 0`.  Both exponential regimes carry a positive
coefficient depending only on the maximal `ψ₁` gauge `K` (and the universal
Bernstein constant).  The book's displayed large-deviation branch omits this
coefficient; that literal branch is not asserted here. -/
theorem bernsteinNormalizedTwoRegimePsiOne_corrected
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} (hne : (Finset.univ : Finset ι).Nonempty)
    (hmeas : ∀ i, Measurable (X i))
    (hCenter : ∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0)
    (hSubExp : ∀ i, PsiOneGauge μ (X i) < ∞)
    (hIndep : iIndepFun X μ)
    (hK : 0 < Finset.univ.sup' hne
      (fun i => (PsiOneGauge μ (X i)).toReal)) :
    ∃ c C : ℝ, 0 < c ∧ 0 < C ∧
      (∀ {t : ℝ}, 0 ≤ t → t ≤ C * Real.sqrt (Fintype.card ι : ℝ) →
        μ.real {ω | |∑ i,
            (Real.sqrt (Fintype.card ι : ℝ))⁻¹ * X i ω| ≥ t} ≤
          2 * Real.exp (-(c * t ^ 2))) ∧
      (∀ {t : ℝ}, 0 ≤ t → C * Real.sqrt (Fintype.card ι : ℝ) ≤ t →
        μ.real {ω | |∑ i,
            (Real.sqrt (Fintype.card ι : ℝ))⁻¹ * X i ω| ≥ t} ≤
          2 * Real.exp (-(c * t * Real.sqrt (Fintype.card ι : ℝ)))) := by
  classical
  rcases bernsteinNormalizedTailPsiOne with ⟨c₀, hc₀, htail⟩
  set K : ℝ := Finset.univ.sup' hne
    (fun i => (PsiOneGauge μ (X i)).toReal) with hKdef
  set R : ℝ := Real.sqrt (Fintype.card ι : ℝ) with hRdef
  have hcard : 0 < Fintype.card ι := by
    rw [← Finset.card_univ]
    exact Finset.card_pos.2 hne
  have hN : (0 : ℝ) < (Fintype.card ι : ℝ) := by exact_mod_cast hcard
  have hR : 0 < R := by rw [hRdef]; exact Real.sqrt_pos.2 hN
  have hK' : 0 < K := by rwa [hKdef]
  set c : ℝ := min (c₀ / K ^ 2) (c₀ / K) with hcdef
  have hc : 0 < c := by
    rw [hcdef, lt_min_iff]
    exact ⟨div_pos hc₀ (sq_pos_of_pos hK'), div_pos hc₀ hK'⟩
  refine ⟨c, K, hc, hK', ?_, ?_⟩
  · intro t ht htSmall
    have hbase := htail hne hmeas hCenter hSubExp hIndep ht
    rw [← hKdef, ← hRdef] at hbase
    have hquad : t ^ 2 / K ^ 2 ≤ t * R / K := by
      rw [div_le_div_iff₀ (sq_pos_of_pos hK') hK']
      have hfac : 0 ≤ t * K * (K * R - t) :=
        mul_nonneg (mul_nonneg ht hK'.le) (sub_nonneg.mpr htSmall)
      nlinarith
    rw [min_eq_left hquad] at hbase
    have hrate : c * t ^ 2 ≤ c₀ * (t ^ 2 / K ^ 2) := by
      have hc_le : c ≤ c₀ / K ^ 2 := by rw [hcdef]; exact min_le_left _ _
      calc
        c * t ^ 2 ≤ (c₀ / K ^ 2) * t ^ 2 :=
          mul_le_mul_of_nonneg_right hc_le (sq_nonneg t)
        _ = c₀ * (t ^ 2 / K ^ 2) := by ring
    refine hbase.trans ?_
    gcongr
  · intro t ht htLarge
    have hbase := htail hne hmeas hCenter hSubExp hIndep ht
    rw [← hKdef, ← hRdef] at hbase
    have hlinear : t * R / K ≤ t ^ 2 / K ^ 2 := by
      rw [div_le_div_iff₀ hK' (sq_pos_of_pos hK')]
      have hfac : 0 ≤ t * K * (t - K * R) :=
        mul_nonneg (mul_nonneg ht hK'.le) (sub_nonneg.mpr htLarge)
      nlinarith
    rw [min_eq_right hlinear] at hbase
    have hrate : c * t * R ≤ c₀ * (t * R / K) := by
      have hc_le : c ≤ c₀ / K := by rw [hcdef]; exact min_le_right _ _
      calc
        c * t * R ≤ (c₀ / K) * t * R := by
          exact mul_le_mul_of_nonneg_right
            (mul_le_mul_of_nonneg_right hc_le ht) hR.le
        _ = c₀ * (t * R / K) := by ring
    refine hbase.trans ?_
    gcongr

end NumStability.HDP.Scalar.IndependentSums.Bernstein

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.IndependentSums.Bernstein

/-! ## Stable Chapter 2 source-facing aliases for Section 2.8

Theorems 2.8.1--2.8.3 are printed with an unquantified absolute constant `c`,
so the faithful Lean shape puts `∃ c > 0` *outside* the family of random
variables: a declaration that pinned `c = 1/4` would be an explicit instance of
the printed claim, not the printed claim itself.  The explicit-constant results
are the reusable `bernsteinTail`, `bernsteinWeightedTail` and
`bernsteinAverageTail`; the aliases below are the printed existential forms and
are what the corresponding gate rows close on.

Theorem 2.8.4 carries no implicit constant, so its alias is a direct forwarding
declaration. -/

/-- **Theorem 2.8.1** (printed page 36), in its printed form: the existential
absolute constant `c` stands outside the family, and the linear branch of the
minimum carries the *maximum* `max_i K i` exactly as printed, not merely some
uniform upper bound.  The positive-energy hypothesis forces `ι` to be nonempty,
so the maximum exists. -/
theorem hdp_02_hthm_h2_d8_d1 :
    ∃ c : ℝ, 0 < c ∧
      ∀ {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
        {μ : Measure Ω} [IsProbabilityMeasure μ]
        {X : ι → Ω → ℝ} {K : ι → ℝ}
        (hne : (Finset.univ : Finset ι).Nonempty),
        (∀ i, SubExponentialLinearMGF μ (X i) (K i)) →
        ProbabilityTheory.iIndepFun X μ →
        0 < ∑ i, K i ^ 2 →
        ∀ {t : ℝ}, 0 ≤ t →
          μ.real {ω | |∑ i, X i ω| ≥ t} ≤
            2 * Real.exp (-(c * min (t ^ 2 / ∑ i, K i ^ 2)
              (t / Finset.univ.sup' hne K))) := by
  refine ⟨1 / 4, by norm_num, ?_⟩
  intro ι Ω _ _ μ _ X K hne hX hIndep hEnergy t ht
  set M : ℝ := Finset.univ.sup' hne K with hMdef
  have hmax : ∀ i, K i ≤ M := fun i =>
    Finset.le_sup' (f := K) (Finset.mem_univ i)
  have hM : 0 < M := lt_of_lt_of_le (hX hne.choose).2.1 (hmax hne.choose)
  refine (bernsteinTail hX hIndep hM hmax hEnergy ht).trans ?_
  have hE : 0 < ∑ i, K i ^ 2 := hEnergy
  refine mul_le_mul_of_nonneg_left (Real.exp_le_exp.2 ?_) (by norm_num)
  -- `min (a/4) (b/2) ≥ (1/4) * min a b`, so the pinned bound implies the
  -- printed one with `c = 1/4`.
  have hkey : (1 / 4 : ℝ) * min (t ^ 2 / ∑ i, K i ^ 2) (t / M)
      ≤ min (t ^ 2 / (4 * ∑ i, K i ^ 2)) (t / (2 * M)) := by
    have h1 : (1 / 4 : ℝ) * min (t ^ 2 / ∑ i, K i ^ 2) (t / M)
        ≤ t ^ 2 / (4 * ∑ i, K i ^ 2) := by
      have := min_le_left (t ^ 2 / ∑ i, K i ^ 2) (t / M)
      have heq : t ^ 2 / (4 * ∑ i, K i ^ 2)
          = (1 / 4 : ℝ) * (t ^ 2 / ∑ i, K i ^ 2) := by
        field_simp
      rw [heq]
      exact mul_le_mul_of_nonneg_left this (by norm_num)
    have h2 : (1 / 4 : ℝ) * min (t ^ 2 / ∑ i, K i ^ 2) (t / M)
        ≤ t / (2 * M) := by
      have hmin := min_le_right (t ^ 2 / ∑ i, K i ^ 2) (t / M)
      have hnn : 0 ≤ t / M := by positivity
      have heq : t / (2 * M) = (1 / 2 : ℝ) * (t / M) := by field_simp
      rw [heq]
      have : (1 / 4 : ℝ) * min (t ^ 2 / ∑ i, K i ^ 2) (t / M)
          ≤ (1 / 4 : ℝ) * (t / M) :=
        mul_le_mul_of_nonneg_left hmin (by norm_num)
      nlinarith [this, hnn]
    exact le_min h1 h2
  linarith [hkey]

/-- **Theorem 2.8.2** (printed page 37), in its printed existential-constant
form.  `M` plays the role of the printed `K ‖a‖_∞`. -/
theorem hdp_02_hthm_h2_d8_d2 :
    ∃ c : ℝ, 0 < c ∧
      ∀ {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
        {μ : Measure Ω} [IsProbabilityMeasure μ]
        {X : ι → Ω → ℝ} {K : ι → ℝ} {a : ι → ℝ}
        (hne : (Finset.univ : Finset ι).Nonempty),
        (∀ i, SubExponentialLinearMGF μ (X i) (K i)) →
        ProbabilityTheory.iIndepFun X μ →
        0 < ∑ i, (a i * K i) ^ 2 →
        ∀ {t : ℝ}, 0 ≤ t →
          μ.real {ω | |∑ i, a i * X i ω| ≥ t} ≤
            2 * Real.exp (-(c * min (t ^ 2 / ∑ i, (a i * K i) ^ 2)
              (t / Finset.univ.sup' hne (fun i => |a i| * K i)))) := by
  refine ⟨1 / 4, by norm_num, ?_⟩
  intro ι Ω _ _ μ _ X K a hne hX hIndep hEnergy t ht
  set M : ℝ := Finset.univ.sup' hne (fun i => |a i| * K i) with hMdef
  have hwindow : ∀ i, |a i| * K i ≤ M := fun i =>
    Finset.le_sup' (f := fun i => |a i| * K i) (Finset.mem_univ i)
  have hM : 0 < M := by
    by_contra hcon
    push_neg at hcon
    have hall : ∀ i, (a i * K i) ^ 2 = 0 := by
      intro i
      have h1 : |a i| * K i ≤ 0 := le_trans (hwindow i) hcon
      have h2 : 0 ≤ |a i| * K i :=
        mul_nonneg (abs_nonneg _) (hX i).2.1.le
      have h3 : |a i| * K i = 0 := le_antisymm h1 h2
      have h4 : |a i| = 0 := by
        rcases mul_eq_zero.mp h3 with h | h
        · exact h
        · exact absurd h (ne_of_gt (hX i).2.1)
      have h5 : a i = 0 := abs_eq_zero.mp h4
      rw [h5]; ring
    have : (∑ i, (a i * K i) ^ 2) = 0 := Finset.sum_eq_zero (fun i _ => hall i)
    rw [this] at hEnergy
    exact absurd hEnergy (lt_irrefl 0)
  refine (bernsteinWeightedTail hX hIndep hM hwindow hEnergy ht).trans ?_
  refine mul_le_mul_of_nonneg_left (Real.exp_le_exp.2 ?_) (by norm_num)
  have hkey : (1 / 4 : ℝ) * min (t ^ 2 / ∑ i, (a i * K i) ^ 2) (t / M)
      ≤ min (t ^ 2 / (4 * ∑ i, (a i * K i) ^ 2)) (t / (2 * M)) := by
    have h1 : (1 / 4 : ℝ) * min (t ^ 2 / ∑ i, (a i * K i) ^ 2) (t / M)
        ≤ t ^ 2 / (4 * ∑ i, (a i * K i) ^ 2) := by
      have hmin := min_le_left (t ^ 2 / ∑ i, (a i * K i) ^ 2) (t / M)
      have heq : t ^ 2 / (4 * ∑ i, (a i * K i) ^ 2)
          = (1 / 4 : ℝ) * (t ^ 2 / ∑ i, (a i * K i) ^ 2) := by field_simp
      rw [heq]
      exact mul_le_mul_of_nonneg_left hmin (by norm_num)
    have h2 : (1 / 4 : ℝ) * min (t ^ 2 / ∑ i, (a i * K i) ^ 2) (t / M)
        ≤ t / (2 * M) := by
      have hmin := min_le_right (t ^ 2 / ∑ i, (a i * K i) ^ 2) (t / M)
      have hnn : 0 ≤ t / M := by positivity
      have heq : t / (2 * M) = (1 / 2 : ℝ) * (t / M) := by field_simp
      rw [heq]
      have : (1 / 4 : ℝ) * min (t ^ 2 / ∑ i, (a i * K i) ^ 2) (t / M)
          ≤ (1 / 4 : ℝ) * (t / M) :=
        mul_le_mul_of_nonneg_left hmin (by norm_num)
      nlinarith [this, hnn]
    exact le_min h1 h2
  linarith [hkey]

/-- **Corollary 2.8.3** (printed page 37): Bernstein's inequality for averages,
with the `1 / N` weights left visible. -/
theorem hdp_02_hcor_h2_d8_d3
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {K : ℝ}
    (hK : 0 < K)
    (hX : ∀ i, SubExponentialLinearMGF μ (X i) K)
    (hIndep : ProbabilityTheory.iIndepFun X μ)
    (hcard : 0 < Fintype.card ι)
    {t : ℝ} (ht : 0 ≤ t) :
    μ.real {ω | |∑ i, (Fintype.card ι : ℝ)⁻¹ * X i ω| ≥ t} ≤
      2 * Real.exp (-min
        (t ^ 2 / (4 * ∑ _i : ι, ((Fintype.card ι : ℝ)⁻¹ * K) ^ 2))
        (t / (2 * ((Fintype.card ι : ℝ)⁻¹ * K)))) :=
  bernsteinAverageTail hK hX hIndep hcard ht

/-- **Theorem 2.8.4** (printed page 38): the variance-sensitive Bernstein
inequality for bounded summands.  The printed constants are exact. -/
theorem hdp_02_hthm_h2_d8_d4
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {K : ℝ} (hK : 0 < K)
    (hX : ∀ i, Measurable (X i))
    (hCenter : ∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0)
    (hBound : ∀ i, ∀ᵐ ω ∂μ, |X i ω| ≤ K)
    (hIndep : ProbabilityTheory.iIndepFun X μ)
    {t : ℝ} (ht : 0 ≤ t) :
    μ.real {ω | |∑ i, X i ω| ≥ t} ≤
      2 * Real.exp (-((t ^ 2 / 2) /
        ((∑ i, ∫ ω, X i ω ^ 2 ∂μ) + K * t / 3))) :=
  bernsteinBoundedTail hK hX hCenter hBound hIndep ht

/-- **Exercise 2.8.5** (printed page 38): the MGF bound for a centered bounded
variable, with the printed `g (λ) = (λ²/2) / (1 - |λ| K / 3)`. -/
theorem hdp_02_hex_h2_d8_d5
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ} (hK : 0 < K) (hX : Measurable X)
    (hCenter : Integrable X μ ∧ (∫ ω, X ω ∂μ) = 0)
    (hBound : ∀ᵐ ω ∂μ, |X ω| ≤ K)
    {lam : ℝ} (hlam : |lam| * K < 3) :
    Integrable (fun ω => Real.exp (lam * X ω)) μ ∧
      (∫ ω, Real.exp (lam * X ω) ∂μ) ≤
        Real.exp (((lam ^ 2 / 2) / (1 - |lam| * K / 3)) * (∫ ω, X ω ^ 2 ∂μ)) :=
  boundedCenteredMGFBound hK hX hCenter hBound hlam

/-- **Exercise 2.8.6** (printed page 38): "Deduce Theorem 2.8.4 from the bound
in Exercise 2.8.5."  The bound of Exercise 2.8.5 is the hypothesis `hEx`, so
this declaration records the *deduction* the exercise asks for rather than
restating Theorem 2.8.4; the printed proof needs the bound for both `X i` and
`-X i`, which is why `hEx` quantifies over admissible variables. -/
theorem hdp_02_hex_h2_d8_d6
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {K : ℝ} (hK : 0 < K)
    (hX : ∀ i, Measurable (X i))
    (hCenter : ∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0)
    (hBound : ∀ i, ∀ᵐ ω ∂μ, |X i ω| ≤ K)
    (hIndep : ProbabilityTheory.iIndepFun X μ)
    (hEx : BoundedCenteredMGFHypothesis μ K)
    {t : ℝ} (ht : 0 ≤ t) :
    μ.real {ω | |∑ i, X i ω| ≥ t} ≤
      2 * Real.exp (-((t ^ 2 / 2) /
        ((∑ i, ∫ ω, X i ω ^ 2 ∂μ) + K * t / 3))) :=
  bernsteinBoundedTailOfMGFBound hK hX hCenter hBound hIndep hEx ht

/-- **Proposition 2.7.1, property (e)** (printed page 32), exposed as the
window MGF bound that Section 2.8 consumes, together with the printed
`b ⇒ e` implication. -/
theorem hdp_02_hprop_h2_d7_d1_he
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ} (hX : Measurable X) (hK : 0 < K)
    (hCenter : Integrable X μ ∧ (∫ ω, X ω ∂μ) = 0)
    (hLp : NumStability.HDP.Scalar.SubExponential.LpMomentGrowth μ X K) :
    SubExponentialLinearMGF μ X (4 * Real.exp 1 * K) :=
  momentToLinearMGF hX hK hCenter hLp

/-! ### The printed `ψ₁` renderings of Section 2.8

The three aliases above state Theorems 2.8.1, 2.8.2 and Corollary 2.8.3 in the
window/MGF scale the proof works in, which quantifies over per-index parameters
rather than naming the printed objects.  The three aliases below are the printed
statements themselves, over the sub-exponential norm `‖·‖_{ψ₁}` of Definition
2.7.5: the exact per-index gauges and their exact maximum, with the printed
denominators.  Both families are kept, separately named, because they are
different propositions: the window forms are strictly sharper (their
denominators are pointwise no larger), while these are what the book prints. -/

/-- **Theorem 2.8.1** (printed page 36) in the printed sub-exponential norm.
The absolute constant is quantified before the finite family and its ambient
probability space. -/
theorem hdp_02_hthm_h2_d8_d1_hpsi1 :
    ∃ c : ℝ, 0 < c ∧
      ∀ {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
        {μ : Measure Ω} [IsProbabilityMeasure μ]
        {X : ι → Ω → ℝ} (hne : (Finset.univ : Finset ι).Nonempty),
        (∀ i, Measurable (X i)) →
        (∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0) →
        (∀ i, NumStability.HDP.Scalar.SubExponential.PsiOneGauge μ (X i) < ∞) →
        ProbabilityTheory.iIndepFun X μ →
        ∀ {t : ℝ}, 0 ≤ t →
          μ.real {ω | |∑ i, X i ω| ≥ t} ≤
            2 * Real.exp (-(c *
              min (t ^ 2 / ∑ i,
                    ((NumStability.HDP.Scalar.SubExponential.PsiOneGauge
                      μ (X i)).toReal) ^ 2)
                  (t / Finset.univ.sup' hne
                    (fun i => (NumStability.HDP.Scalar.SubExponential.PsiOneGauge
                      μ (X i)).toReal)))) :=
  bernsteinTailPsiOne

/-- **Theorem 2.8.2** (printed page 37) in the printed sub-exponential norm,
with the printed denominators `K² ‖a‖₂²` and `K ‖a‖_∞`.  The absolute
constant is quantified before the ambient probability space, and arbitrary
weights include the source's degenerate zero vector. -/
theorem hdp_02_hthm_h2_d8_d2_hpsi1 :
    ∃ c : ℝ, 0 < c ∧
      ∀ {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
        {μ : Measure Ω} [IsProbabilityMeasure μ]
        {X : ι → Ω → ℝ} {a : ι → ℝ} (hne : (Finset.univ : Finset ι).Nonempty),
        (∀ i, Measurable (X i)) →
        (∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0) →
        (∀ i, NumStability.HDP.Scalar.SubExponential.PsiOneGauge μ (X i) < ∞) →
        ProbabilityTheory.iIndepFun X μ →
        ∀ {t : ℝ}, 0 ≤ t →
          μ.real {ω | |∑ i, a i * X i ω| ≥ t} ≤
            2 * Real.exp (-(c *
              min (t ^ 2 /
                    ((Finset.univ.sup' hne
                        (fun i => (NumStability.HDP.Scalar.SubExponential.PsiOneGauge
                          μ (X i)).toReal)) ^ 2 * ∑ i, a i ^ 2))
                  (t / ((Finset.univ.sup' hne
                        (fun i => (NumStability.HDP.Scalar.SubExponential.PsiOneGauge
                          μ (X i)).toReal)) *
                      Finset.univ.sup' hne (fun i => |a i|))))) :=
  bernsteinWeightedTailPsiOne

/-- **Corollary 2.8.3** (printed page 37) in the printed sub-exponential norm,
with the printed right-hand side `2 exp(-c min(t²/K², t/K) N)`.  The absolute
constant precedes the ambient probability space, and zero-gauge families remain
in the source's universal domain. -/
theorem hdp_02_hcor_h2_d8_d3_hpsi1 :
    ∃ c : ℝ, 0 < c ∧
      ∀ {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
        {μ : Measure Ω} [IsProbabilityMeasure μ]
        {X : ι → Ω → ℝ} (hne : (Finset.univ : Finset ι).Nonempty),
        (∀ i, Measurable (X i)) →
        (∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0) →
        (∀ i, NumStability.HDP.Scalar.SubExponential.PsiOneGauge μ (X i) < ∞) →
        ProbabilityTheory.iIndepFun X μ →
        ∀ {t : ℝ}, 0 ≤ t →
          μ.real {ω | |∑ i, (Fintype.card ι : ℝ)⁻¹ * X i ω| ≥ t} ≤
            2 * Real.exp (-(c *
              min (t ^ 2 / (Finset.univ.sup' hne
                    (fun i => (NumStability.HDP.Scalar.SubExponential.PsiOneGauge
                      μ (X i)).toReal)) ^ 2)
                  (t / Finset.univ.sup' hne
                    (fun i => (NumStability.HDP.Scalar.SubExponential.PsiOneGauge
                      μ (X i)).toReal)) *
                (Fintype.card ι : ℝ))) :=
  bernsteinAverageTailPsiOne

/-- Corrected source-facing companion to the unnumbered two-regime display
after Corollary 2.8.3.  Unlike the printed large-deviation branch, this statement
retains the necessary positive coefficient in front of `t * sqrt N`; it is not
an alias claiming that the literal source display is valid as written. -/
theorem hdp_02_body_h2_d8_hnormalized_hregimes_corrected
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} (hne : (Finset.univ : Finset ι).Nonempty)
    (hmeas : ∀ i, Measurable (X i))
    (hCenter : ∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0)
    (hSubExp : ∀ i,
      NumStability.HDP.Scalar.SubExponential.PsiOneGauge μ (X i) < ∞)
    (hIndep : ProbabilityTheory.iIndepFun X μ)
    (hK : 0 < Finset.univ.sup' hne
      (fun i => (NumStability.HDP.Scalar.SubExponential.PsiOneGauge
        μ (X i)).toReal)) :
    ∃ c C : ℝ, 0 < c ∧ 0 < C ∧
      (∀ {t : ℝ}, 0 ≤ t → t ≤ C * Real.sqrt (Fintype.card ι : ℝ) →
        μ.real {ω | |∑ i,
            (Real.sqrt (Fintype.card ι : ℝ))⁻¹ * X i ω| ≥ t} ≤
          2 * Real.exp (-(c * t ^ 2))) ∧
      (∀ {t : ℝ}, 0 ≤ t → C * Real.sqrt (Fintype.card ι : ℝ) ≤ t →
        μ.real {ω | |∑ i,
            (Real.sqrt (Fintype.card ι : ℝ))⁻¹ * X i ω| ≥ t} ≤
          2 * Real.exp (-(c * t * Real.sqrt (Fintype.card ι : ℝ)))) :=
  bernsteinNormalizedTwoRegimePsiOne_corrected hne hmeas hCenter hSubExp hIndep hK

end NumStability.HDP.Contract
