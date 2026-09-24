import ComputationalMathematics.Analysis.MatrixAlgebra
import ComputationalMathematics.HDP.Scalar.IndependentSums.Bernstein.Basic
import ComputationalMathematics.HDP.Scalar.SubExponentialCentering
import ComputationalMathematics.HDP.Vector.Moments

/-!
# Euclidean-norm concentration foundations

Reusable scalar reductions used to study the Euclidean norm of a random
vector with sub-Gaussian coordinates.
-/

noncomputable section

open MeasureTheory
open scoped ENNReal

namespace NumStability.HDP.Vector.NormConcentration

open NumStability.HDP.Scalar

/-- The elementary square-deviation implication used to pass from a bound on
`z²` to a bound on a nonnegative `z`. -/
theorem max_le_abs_sq_sub_one_of_le_abs_sub_one
    {z δ : ℝ} (hz : 0 ≤ z) (hδ : 0 ≤ δ) (hdev : δ ≤ |z - 1|) :
    max δ (δ ^ 2) ≤ |z ^ 2 - 1| := by
  by_cases hzOne : 1 ≤ z
  · rw [abs_of_nonneg (sub_nonneg.mpr hzOne)] at hdev
    rw [abs_of_nonneg (by nlinarith : 0 ≤ z ^ 2 - 1)]
    apply max_le
    · nlinarith [sq_nonneg (z - 1)]
    · nlinarith [sq_nonneg (z - 1)]
  · have hzLe : z ≤ 1 := le_of_not_ge hzOne
    rw [abs_of_nonpos (sub_nonpos.mpr hzLe)] at hdev
    rw [abs_of_nonpos (by nlinarith : z ^ 2 - 1 ≤ 0)]
    apply max_le
    · nlinarith [sq_nonneg (z - 1)]
    · have hδOne : δ ≤ 1 := by linarith
      have hδSq : δ ^ 2 ≤ δ := by nlinarith
      nlinarith [sq_nonneg (z - 1)]

/-- The average of the centered coordinate squares is the normalized squared
Euclidean norm minus one. -/
theorem centeredSquareAverage_eq_normSq_div_sub_one
    {n : ℕ} (hn : 0 < n) (x : Fin n → ℝ) :
    (∑ i, (n : ℝ)⁻¹ * (x i ^ 2 - 1)) =
      NumStability.vecNorm2 x ^ 2 / (n : ℝ) - 1 := by
  rw [NumStability.vecNorm2_sq]
  unfold NumStability.vecNorm2Sq
  rw [← Finset.mul_sum]
  simp only [mul_sub, mul_one, Finset.sum_sub_distrib,
    Finset.sum_const, Finset.card_univ, Fintype.card_fin, nsmul_eq_mul]
  have hnR : (n : ℝ) ≠ 0 := by exact_mod_cast (Nat.ne_of_gt hn)
  field_simp

/-- A deviation of the normalized Euclidean norm forces the corresponding
centered-square average to deviate by `max δ δ²`. -/
theorem max_le_abs_centeredSquareAverage_of_norm_deviation
    {n : ℕ} (hn : 0 < n) (x : Fin n → ℝ) {δ : ℝ} (hδ : 0 ≤ δ)
    (hdev : δ ≤
      |NumStability.vecNorm2 x / Real.sqrt (n : ℝ) - 1|) :
    max δ (δ ^ 2) ≤
      |∑ i, (n : ℝ)⁻¹ * (x i ^ 2 - 1)| := by
  have hnNonneg : (0 : ℝ) ≤ n := by positivity
  have hzNonneg :
      0 ≤ NumStability.vecNorm2 x / Real.sqrt (n : ℝ) :=
    div_nonneg (NumStability.vecNorm2_nonneg x) (Real.sqrt_nonneg _)
  calc
    max δ (δ ^ 2) ≤
        |(NumStability.vecNorm2 x / Real.sqrt (n : ℝ)) ^ 2 - 1| :=
      max_le_abs_sq_sub_one_of_le_abs_sub_one hzNonneg hδ hdev
    _ = |NumStability.vecNorm2 x ^ 2 / (n : ℝ) - 1| := by
      rw [div_pow, Real.sq_sqrt hnNonneg]
    _ = |∑ i, (n : ℝ)⁻¹ * (x i ^ 2 - 1)| := by
      rw [centeredSquareAverage_eq_normSq_div_sub_one hn]

/-- Event-level form of the deterministic square reduction. -/
theorem measureReal_normDeviation_le_centeredSquareAverage
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    [IsFiniteMeasure μ] {n : ℕ} (hn : 0 < n)
    (X : Fin n → Ω → ℝ) {δ : ℝ} (hδ : 0 ≤ δ) :
    μ.real {ω |
        |NumStability.vecNorm2 (fun i => X i ω) /
          Real.sqrt (n : ℝ) - 1| ≥ δ} ≤
      μ.real {ω |
        |∑ i, (n : ℝ)⁻¹ * (X i ω ^ 2 - 1)| ≥ max δ (δ ^ 2)} := by
  rw [Measure.real_def, Measure.real_def]
  apply ENNReal.toReal_mono (by finiteness)
  apply measure_mono
  intro ω hω
  exact max_le_abs_centeredSquareAverage_of_norm_deviation hn
    (fun i => X i ω) hδ hω

/-- Coordinatewise squaring and centering preserve mutual independence. -/
theorem iIndepFun_centeredSquares
    {ι Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    {X : ι → Ω → ℝ} (hIndep : ProbabilityTheory.iIndepFun X μ) :
    ProbabilityTheory.iIndepFun (fun i ω => X i ω ^ 2 - 1) μ := by
  have hComp := hIndep.comp (fun _i : ι => fun x : ℝ => x ^ 2 - 1)
    (fun _i => by fun_prop)
  simpa [Function.comp_def] using hComp

/-- The largest exact `ψ₁` gauge among the centered coordinate squares of a
nonempty finite family. -/
noncomputable def centeredSquarePsiOneMax
    {ι Ω : Type*} [Fintype ι] [Nonempty ι] [MeasurableSpace Ω]
    (μ : Measure Ω) (X : ι → Ω → ℝ) : ℝ :=
  Finset.univ.sup' Finset.univ_nonempty
    (fun i => (SubExponential.PsiOneGauge μ
      (fun ω => X i ω ^ 2 - 1)).toReal)

/-- Squaring a sub-Gaussian random variable and subtracting its unit second
moment produces a sub-exponential random variable whose exact `ψ₁` gauge is
bounded by one universal multiple of the square of the exact `ψ₂` gauge. -/
theorem centeredSquare_psiOneGauge_le :
    ∃ C : ℝ, 1 ≤ C ∧
      ∀ {Ω : Type*} [MeasurableSpace Ω]
        {μ : Measure Ω} [IsProbabilityMeasure μ]
        {X : Ω → ℝ},
        Measurable X →
          SubGaussian.PsiTwoGauge μ X < ∞ →
            (∫ ω, X ω ^ 2 ∂μ) = 1 →
              SubExponential.PsiOneGauge μ (fun ω => X ω ^ 2 - 1) ≤
                ENNReal.ofReal C * SubGaussian.PsiTwoGauge μ X ^ 2 := by
  rcases SubExponential.centeredSubExponentialPsiOneNorm_uniform with
    ⟨C, hC, hCenter⟩
  refine ⟨C, hC, ?_⟩
  intro Ω _ μ _ X hX hFinite hSecond
  have hSquareMeas : Measurable (fun ω => X ω ^ 2) := by fun_prop
  have hSquareFinite :
      SubExponential.PsiOneGauge μ (fun ω => X ω ^ 2) < ∞ :=
    (SubExponential.psiOneGauge_sq_lt_top_iff hX).2 hFinite
  have hBound := hCenter hSquareMeas hSquareFinite
  rw [hSecond, SubExponential.psiOneGauge_sq_eq_psiTwoGauge_sq hX] at hBound
  exact hBound

/-- The maximum centered-square `ψ₁` gauge is controlled by the square of the
maximum coordinate `ψ₂` gauge with one universal real coefficient. -/
theorem centeredSquarePsiOneMax_le :
    ∃ C : ℝ, 1 ≤ C ∧
      ∀ {ι Ω : Type*} [Fintype ι] [Nonempty ι] [MeasurableSpace Ω]
        {μ : Measure Ω} [IsProbabilityMeasure μ]
        (X : ι → Ω → ℝ),
        (∀ i, Measurable (X i)) →
          (∀ i, SubGaussian.PsiTwoGauge μ (X i) < ∞) →
            (∀ i, (∫ ω, X i ω ^ 2 ∂μ) = 1) →
              centeredSquarePsiOneMax μ X ≤
                C * (SubGaussian.psiTwoNormMax μ X) ^ 2 := by
  rcases centeredSquare_psiOneGauge_le with ⟨C, hC, hBound⟩
  refine ⟨C, hC, ?_⟩
  intro ι Ω _ _ _ μ _ X hMeas hFinite hSecond
  unfold centeredSquarePsiOneMax
  apply Finset.sup'_le Finset.univ_nonempty
  intro i _hi
  have hi := hBound (hMeas i) (hFinite i) (hSecond i)
  have hRhsTop :
      ENNReal.ofReal C * SubGaussian.PsiTwoGauge μ (X i) ^ 2 ≠ ∞ :=
    ENNReal.mul_ne_top ENNReal.ofReal_ne_top
      (ENNReal.pow_ne_top (ne_of_lt (hFinite i)))
  have hiReal := ENNReal.toReal_mono hRhsTop hi
  rw [ENNReal.toReal_mul, ENNReal.toReal_ofReal (by linarith),
    ENNReal.toReal_pow] at hiReal
  have hCoordMax :
      (SubGaussian.PsiTwoGauge μ (X i)).toReal ≤
        SubGaussian.psiTwoNormMax μ X :=
    SubGaussian.psiTwoNorm_toReal_le_max i
  have hCoordNonneg : 0 ≤ (SubGaussian.PsiTwoGauge μ (X i)).toReal :=
    ENNReal.toReal_nonneg
  have hMaxNonneg : 0 ≤ SubGaussian.psiTwoNormMax μ X :=
    SubGaussian.psiTwoNormMax_nonneg
  have hSquareLe :
      (SubGaussian.PsiTwoGauge μ (X i)).toReal ^ 2 ≤
        (SubGaussian.psiTwoNormMax μ X) ^ 2 := by
    nlinarith
  exact hiReal.trans (mul_le_mul_of_nonneg_left hSquareLe (by linarith))

/-- Unit coordinate second moments force a universal positive lower scale for
the maximum exact coordinate `ψ₂` gauge.  This replaces the book proof's
informal normalization `K ≥ 1` while keeping all constants explicit. -/
theorem one_le_scaled_psiTwoNormMax_sq
    {ι Ω : Type*} [Fintype ι] [Nonempty ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (X : ι → Ω → ℝ)
    (hMeas : ∀ i, Measurable (X i))
    (hFinite : ∀ i, SubGaussian.PsiTwoGauge μ (X i) < ∞)
    (hSecond : ∀ i, (∫ ω, X i ω ^ 2 ∂μ) = 1) :
    1 ≤ (16 * Real.exp 1 * Real.sqrt 2 *
      SubGaussian.psiTwoNormMax μ X) ^ 2 := by
  let i : ι := Classical.choice inferInstance
  have hGrowth :=
    SubGaussian.psiTwoGaugeToLpMomentGrowth (hMeas i) (hFinite i)
  have hTwo := hGrowth.2 2 (by norm_num : (1 : ℝ) ≤ 2)
  have hMomentEq : (∫ ω, |X i ω| ^ (2 : ℝ) ∂μ) = 1 := by
    rw [← hSecond i]
    congr 1
    funext ω
    rw [Real.rpow_two, sq_abs]
  have hCoordinateLower :
      1 ≤ (16 * Real.exp 1 *
        (SubGaussian.PsiTwoGauge μ (X i)).toReal * Real.sqrt 2) ^ 2 := by
    rw [hMomentEq] at hTwo
    simpa [Real.rpow_two] using hTwo.2
  have hCoordMax :
      (SubGaussian.PsiTwoGauge μ (X i)).toReal ≤
        SubGaussian.psiTwoNormMax μ X :=
    SubGaussian.psiTwoNorm_toReal_le_max i
  have hScaled :
      16 * Real.exp 1 * Real.sqrt 2 *
          (SubGaussian.PsiTwoGauge μ (X i)).toReal ≤
        16 * Real.exp 1 * Real.sqrt 2 *
          SubGaussian.psiTwoNormMax μ X := by
    exact mul_le_mul_of_nonneg_left hCoordMax (by positivity)
  have hScaledNonneg :
      0 ≤ 16 * Real.exp 1 * Real.sqrt 2 *
        (SubGaussian.PsiTwoGauge μ (X i)).toReal := by positivity
  have hMaxScaledNonneg :
      0 ≤ 16 * Real.exp 1 * Real.sqrt 2 *
        SubGaussian.psiTwoNormMax μ X := by
    exact mul_nonneg (by positivity) SubGaussian.psiTwoNormMax_nonneg
  have hSquareLe :=
    (sq_le_sq₀ hScaledNonneg hMaxScaledNonneg).2 hScaled
  apply hCoordinateLower.trans
  convert hSquareLe using 1; ring

/-- Bernstein's average-tail inequality specialized to independent centered
coordinate squares.  The scale is kept as their exact maximum `ψ₁` gauge;
bounding it by the squared maximum coordinate `ψ₂` gauge is a separate
reusable reduction. -/
theorem centeredSquares_bernsteinAverageTailPsiOne :
    ∃ c : ℝ, 0 < c ∧
      ∀ {ι Ω : Type*} [Fintype ι] [Nonempty ι] [MeasurableSpace Ω]
        {μ : Measure Ω} [IsProbabilityMeasure μ]
        (X : ι → Ω → ℝ),
        (∀ i, Measurable (X i)) →
          (∀ i, SubGaussian.PsiTwoGauge μ (X i) < ∞) →
            (∀ i, (∫ ω, X i ω ^ 2 ∂μ) = 1) →
              ProbabilityTheory.iIndepFun X μ →
                ∀ {t : ℝ}, 0 ≤ t →
                  μ.real {ω |
                      |∑ i, (Fintype.card ι : ℝ)⁻¹ *
                        (X i ω ^ 2 - 1)| ≥ t} ≤
                    2 * Real.exp (-(c *
                      min (t ^ 2 / (centeredSquarePsiOneMax μ X) ^ 2)
                        (t / centeredSquarePsiOneMax μ X) *
                          (Fintype.card ι : ℝ))) := by
  rcases Scalar.IndependentSums.Bernstein.bernsteinAverageTailPsiOne with
    ⟨c, hc, hBernstein⟩
  refine ⟨c, hc, ?_⟩
  intro ι Ω _ _ _ μ _ X hMeas hFinite hSecond hIndep t ht
  let Y : ι → Ω → ℝ := fun i ω => X i ω ^ 2 - 1
  have hYMeas : ∀ i, Measurable (Y i) := by
    intro i
    dsimp [Y]
    fun_prop
  have hYFinite : ∀ i, SubExponential.PsiOneGauge μ (Y i) < ∞ := by
    intro i
    have hSquareFinite :
        SubExponential.PsiOneGauge μ (fun ω => X i ω ^ 2) < ∞ :=
      (SubExponential.psiOneGauge_sq_lt_top_iff (hMeas i)).2 (hFinite i)
    have hCentered :=
      (SubExponential.centeredSubExponentialPsiOneNorm
        (by fun_prop : Measurable (fun ω => X i ω ^ 2)) hSquareFinite).1
    simpa [Y, hSecond i] using hCentered
  have hYCenter : ∀ i, Integrable (Y i) μ ∧ (∫ ω, Y i ω ∂μ) = 0 := by
    intro i
    have hAbsInt :=
      (SubExponential.psiOneGaugeToMomentOne (hYMeas i) (hYFinite i)).1
    have hYInt : Integrable (Y i) μ := by
      apply (integrable_norm_iff (hYMeas i).aestronglyMeasurable).1
      simpa [Real.norm_eq_abs] using hAbsInt
    refine ⟨hYInt, ?_⟩
    have hSquareInt : Integrable (fun ω => X i ω ^ 2) μ := by
      have hAdd := hYInt.add (integrable_const (1 : ℝ))
      have hEq : (fun ω => X i ω ^ 2) =
          (fun ω => Y i ω + 1) := by
        funext ω
        dsimp [Y]
        ring
      rw [hEq]
      exact hAdd
    rw [show (∫ ω, Y i ω ∂μ) =
        (∫ ω, X i ω ^ 2 ∂μ) - (∫ _ω : Ω, (1 : ℝ) ∂μ) by
          simpa [Y] using integral_sub hSquareInt (integrable_const (1 : ℝ))]
    simp [hSecond i]
  have hYIndep : ProbabilityTheory.iIndepFun Y μ := by
    simpa [Y] using iIndepFun_centeredSquares hIndep
  have hTail := hBernstein Finset.univ_nonempty hYMeas hYCenter hYFinite
    hYIndep ht
  simpa [Y, centeredSquarePsiOneMax] using hTail

/-- The centered-square Bernstein bound at the source's intrinsic coordinate
scale `K = maxᵢ ‖Xᵢ‖_{ψ₂}`. -/
theorem centeredSquares_bernsteinAverageTailPsiTwo :
    ∃ c : ℝ, 0 < c ∧
      ∀ {ι Ω : Type*} [Fintype ι] [Nonempty ι] [MeasurableSpace Ω]
        {μ : Measure Ω} [IsProbabilityMeasure μ]
        (X : ι → Ω → ℝ),
        (∀ i, Measurable (X i)) →
          (∀ i, SubGaussian.PsiTwoGauge μ (X i) < ∞) →
            (∀ i, (∫ ω, X i ω ^ 2 ∂μ) = 1) →
              ProbabilityTheory.iIndepFun X μ →
                ∀ {t : ℝ}, 0 ≤ t →
                  μ.real {ω |
                      |∑ i, (Fintype.card ι : ℝ)⁻¹ *
                        (X i ω ^ 2 - 1)| ≥ t} ≤
                    2 * Real.exp (-(c *
                      min
                        (t ^ 2 / (SubGaussian.psiTwoNormMax μ X) ^ 4)
                        (t / (SubGaussian.psiTwoNormMax μ X) ^ 2) *
                          (Fintype.card ι : ℝ))) := by
  rcases centeredSquare_psiOneGauge_le with ⟨C, hC, hCenteredGauge⟩
  let A : ℝ := 4096 * (Real.exp 1) ^ 4 * C
  let c : ℝ := (4 * A ^ 2)⁻¹
  have hA : 1 ≤ A := by
    dsimp [A]
    have hExp : 1 ≤ (Real.exp 1) ^ 4 := by
      have : 1 ≤ Real.exp 1 := Real.one_le_exp (by norm_num)
      nlinarith [sq_nonneg ((Real.exp 1) ^ 2 - 1)]
    nlinarith
  have hApos : 0 < A := lt_of_lt_of_le zero_lt_one hA
  have hc : 0 < c := by dsimp [c]; positivity
  refine ⟨c, hc, ?_⟩
  intro ι Ω _ _ _ μ _ X hMeas hFinite hSecond hIndep t ht
  let K : ℝ := SubGaussian.psiTwoNormMax μ X
  let Y : ι → Ω → ℝ := fun i ω => X i ω ^ 2 - 1
  have hKnonneg : 0 ≤ K := by
    dsimp [K]
    exact SubGaussian.psiTwoNormMax_nonneg
  have hKpos : 0 < K := by
    have hLower := one_le_scaled_psiTwoNormMax_sq X hMeas hFinite hSecond
    by_contra hNot
    have hKzero : K = 0 := le_antisymm (le_of_not_gt hNot) hKnonneg
    rw [show SubGaussian.psiTwoNormMax μ X = K by rfl, hKzero] at hLower
    norm_num at hLower
  have hYMeas : ∀ i, Measurable (Y i) := by
    intro i
    dsimp [Y]
    fun_prop
  have hYCenter : ∀ i, Integrable (Y i) μ ∧ (∫ ω, Y i ω ∂μ) = 0 := by
    intro i
    have hSquareFinite :
        SubExponential.PsiOneGauge μ (fun ω => X i ω ^ 2) < ∞ :=
      (SubExponential.psiOneGauge_sq_lt_top_iff (hMeas i)).2 (hFinite i)
    have hYFinite : SubExponential.PsiOneGauge μ (Y i) < ∞ := by
      have hCentered :=
        (SubExponential.centeredSubExponentialPsiOneNorm
          (by fun_prop : Measurable (fun ω => X i ω ^ 2)) hSquareFinite).1
      simpa [Y, hSecond i] using hCentered
    have hAbsInt :=
      (SubExponential.psiOneGaugeToMomentOne (hYMeas i) hYFinite).1
    have hYInt : Integrable (Y i) μ := by
      apply (integrable_norm_iff (hYMeas i).aestronglyMeasurable).1
      simpa [Real.norm_eq_abs] using hAbsInt
    refine ⟨hYInt, ?_⟩
    have hSquareInt : Integrable (fun ω => X i ω ^ 2) μ := by
      have hAdd := hYInt.add (integrable_const (1 : ℝ))
      have hEq : (fun ω => X i ω ^ 2) = (fun ω => Y i ω + 1) := by
        funext ω
        dsimp [Y]
        ring
      rw [hEq]
      exact hAdd
    rw [show (∫ ω, Y i ω ∂μ) =
        (∫ ω, X i ω ^ 2 ∂μ) - (∫ _ω : Ω, (1 : ℝ) ∂μ) by
          simpa [Y] using integral_sub hSquareInt (integrable_const (1 : ℝ))]
    simp [hSecond i]
  have hYGauge : ∀ i,
      SubExponential.PsiOneGauge μ (Y i) ≤ ENNReal.ofReal (C * K ^ 2) := by
    intro i
    have hBase := hCenteredGauge (hMeas i) (hFinite i) (hSecond i)
    have hCoord :
        (SubGaussian.PsiTwoGauge μ (X i)).toReal ≤ K := by
      exact SubGaussian.psiTwoNorm_toReal_le_max i
    have hCoordENN :
        SubGaussian.PsiTwoGauge μ (X i) ≤ ENNReal.ofReal K := by
      rw [← ENNReal.ofReal_toReal (ne_of_lt (hFinite i))]
      exact ENNReal.ofReal_le_ofReal hCoord
    calc
      SubExponential.PsiOneGauge μ (Y i) ≤
          ENNReal.ofReal C * SubGaussian.PsiTwoGauge μ (X i) ^ 2 := by
        simpa [Y] using hBase
      _ ≤ ENNReal.ofReal C * (ENNReal.ofReal K) ^ 2 := by gcongr
      _ = ENNReal.ofReal (C * K ^ 2) := by
        rw [ENNReal.ofReal_mul (by linarith : 0 ≤ C),
          ENNReal.ofReal_pow hKnonneg]
  have hScalePos : 0 < C * K ^ 2 := mul_pos (lt_of_lt_of_le zero_lt_one hC)
    (sq_pos_of_pos hKpos)
  have hYLinear : ∀ i,
      Scalar.IndependentSums.Bernstein.SubExponentialLinearMGF μ (Y i)
        (A * K ^ 2) := by
    intro i
    have hi := Scalar.IndependentSums.Bernstein.psiOneGaugeToLinearMGF_le
      (hYMeas i) hScalePos (hYCenter i) (hYGauge i)
    simpa [A, mul_assoc] using hi
  have hYIndep : ProbabilityTheory.iIndepFun Y μ := by
    simpa [Y] using iIndepFun_centeredSquares hIndep
  have hCard : 0 < Fintype.card ι := by
    rw [← Finset.card_univ]
    exact Finset.card_pos.2 Finset.univ_nonempty
  have hRaw := Scalar.IndependentSums.Bernstein.bernsteinAverageTail
    (K := A * K ^ 2) (mul_pos hApos (sq_pos_of_pos hKpos)) hYLinear
      hYIndep hCard ht
  have hN : (0 : ℝ) < (Fintype.card ι : ℝ) := by exact_mod_cast hCard
  have hSum :
      (∑ _i : ι, ((Fintype.card ι : ℝ)⁻¹ * (A * K ^ 2)) ^ 2) =
        (Fintype.card ι : ℝ)⁻¹ * (A * K ^ 2) ^ 2 := by
    rw [Finset.sum_const, Finset.card_univ, nsmul_eq_mul]
    field_simp
  rw [hSum] at hRaw
  refine hRaw.trans ?_
  apply mul_le_mul_of_nonneg_left (Real.exp_le_exp.mpr ?_) (by norm_num)
  apply neg_le_neg
  rw [le_min_iff]
  constructor
  · calc
      c * min (t ^ 2 / K ^ 4) (t / K ^ 2) * (Fintype.card ι : ℝ) ≤
          c * (t ^ 2 / K ^ 4) * (Fintype.card ι : ℝ) := by
        gcongr
        exact min_le_left _ _
      _ = t ^ 2 /
          (4 * ((Fintype.card ι : ℝ)⁻¹ * (A * K ^ 2) ^ 2)) := by
        dsimp [c]
        field_simp
  · calc
      c * min (t ^ 2 / K ^ 4) (t / K ^ 2) * (Fintype.card ι : ℝ) ≤
          c * (t / K ^ 2) * (Fintype.card ι : ℝ) := by
        gcongr
        exact min_le_right _ _
      _ ≤ t / (2 * ((Fintype.card ι : ℝ)⁻¹ * (A * K ^ 2))) := by
        dsimp [c]
        have hCoeff : 2 * A ≤ 4 * A ^ 2 := by
          nlinarith [sq_nonneg (A - 1)]
        have hDenom : 2 * A * K ^ 2 ≤ 4 * A ^ 2 * K ^ 2 :=
          mul_le_mul_of_nonneg_right hCoeff (sq_nonneg K)
        calc
          (4 * A ^ 2)⁻¹ * (t / K ^ 2) * (Fintype.card ι : ℝ) =
              (t * (Fintype.card ι : ℝ)) / (4 * A ^ 2 * K ^ 2) := by
            field_simp
          _ ≤ (t * (Fintype.card ι : ℝ)) / (2 * A * K ^ 2) :=
            div_le_div_of_nonneg_left (mul_nonneg ht hN.le) (by positivity)
              hDenom
          _ = t / (2 * ((Fintype.card ι : ℝ)⁻¹ * (A * K ^ 2))) := by
            field_simp

/-- Bernstein tail bound for the normalized squared Euclidean norm, with the
two intrinsic centered-square scales combined under the source's common
`K⁴` denominator. -/
theorem normalizedSquaredEuclideanNorm_tail :
    ∃ c : ℝ, 0 < c ∧
      ∀ {n : ℕ} [Nonempty (Fin n)]
        {Ω : Type*} [MeasurableSpace Ω]
        {μ : Measure Ω} [IsProbabilityMeasure μ]
        (X : Fin n → Ω → ℝ),
        (∀ i, Measurable (X i)) →
          (∀ i, SubGaussian.PsiTwoGauge μ (X i) < ∞) →
            (∀ i, (∫ ω, X i ω ^ 2 ∂μ) = 1) →
              ProbabilityTheory.iIndepFun X μ →
                ∀ {u : ℝ}, 0 ≤ u →
                  μ.real {ω |
                      |NumStability.vecNorm2 (fun i => X i ω) ^ 2 /
                        (n : ℝ) - 1| ≥ u} ≤
                    2 * Real.exp (-(c * min (u ^ 2) u /
                      (SubGaussian.psiTwoNormMax μ X) ^ 4 * (n : ℝ))) := by
  rcases centeredSquares_bernsteinAverageTailPsiTwo with
    ⟨c₀, hc₀, hSquareTail⟩
  let B : ℝ := (16 * Real.exp 1 * Real.sqrt 2) ^ 2
  let c : ℝ := c₀ / B
  have hB : 1 ≤ B := by
    dsimp [B]
    have hExp : 1 ≤ Real.exp 1 := Real.one_le_exp (by norm_num)
    have hSqrt : 1 ≤ Real.sqrt 2 := (Real.one_le_sqrt).2 (by norm_num)
    nlinarith [sq_nonneg (16 * Real.exp 1 * Real.sqrt 2 - 1)]
  have hBpos : 0 < B := lt_of_lt_of_le zero_lt_one hB
  have hc : 0 < c := div_pos hc₀ hBpos
  refine ⟨c, hc, ?_⟩
  intro n _ Ω _ μ _ X hMeas hFinite hSecond hIndep u hu
  have hn : 0 < n := Fin.pos_iff_nonempty.mpr inferInstance
  let K : ℝ := SubGaussian.psiTwoNormMax μ X
  have hKnonneg : 0 ≤ K := by
    dsimp [K]
    exact SubGaussian.psiTwoNormMax_nonneg
  have hKpos : 0 < K := by
    have hLower := one_le_scaled_psiTwoNormMax_sq X hMeas hFinite hSecond
    by_contra hNot
    have hKzero : K = 0 := le_antisymm (le_of_not_gt hNot) hKnonneg
    rw [show SubGaussian.psiTwoNormMax μ X = K by rfl, hKzero] at hLower
    norm_num at hLower
  have hBK : 1 ≤ B * K ^ 2 := by
    have hLower := one_le_scaled_psiTwoNormMax_sq X hMeas hFinite hSecond
    change 1 ≤ (16 * Real.exp 1 * Real.sqrt 2 * K) ^ 2 at hLower
    dsimp [B]
    nlinarith
  have hTail := hSquareTail X hMeas hFinite hSecond hIndep hu
  simp only [Fintype.card_fin,
    centeredSquareAverage_eq_normSq_div_sub_one hn] at hTail
  refine hTail.trans ?_
  apply mul_le_mul_of_nonneg_left (Real.exp_le_exp.mpr ?_) (by norm_num)
  apply neg_le_neg
  have hKSqPos : 0 < K ^ 2 := sq_pos_of_pos hKpos
  have hKFourPos : 0 < K ^ 4 := pow_pos hKpos 4
  have hBKFourPos : 0 < B * K ^ 4 := mul_pos hBpos hKFourPos
  have hMinNonneg : 0 ≤ min (u ^ 2) u :=
    le_min (sq_nonneg u) hu
  have hFirst : min (u ^ 2) u / (B * K ^ 4) ≤ u ^ 2 / K ^ 4 := by
    calc
      min (u ^ 2) u / (B * K ^ 4) ≤ u ^ 2 / (B * K ^ 4) := by
        exact div_le_div_of_nonneg_right (min_le_left _ _) hBKFourPos.le
      _ ≤ u ^ 2 / K ^ 4 := by
        apply div_le_div_of_nonneg_left (sq_nonneg u) hKFourPos
        simpa only [one_mul] using
          mul_le_mul_of_nonneg_right hB hKFourPos.le
  have hSecond : min (u ^ 2) u / (B * K ^ 4) ≤ u / K ^ 2 := by
    calc
      min (u ^ 2) u / (B * K ^ 4) ≤ u / (B * K ^ 4) := by
        exact div_le_div_of_nonneg_right (min_le_right _ _) hBKFourPos.le
      _ ≤ u / K ^ 2 := by
        apply div_le_div_of_nonneg_left hu hKSqPos
        have hDenom := mul_le_mul_of_nonneg_right hBK (sq_nonneg K)
        nlinarith
  have hCore : c * min (u ^ 2) u / K ^ 4 ≤
      c₀ * min (u ^ 2 / K ^ 4) (u / K ^ 2) := by
    calc
      c * min (u ^ 2) u / K ^ 4 =
          c₀ * (min (u ^ 2) u / (B * K ^ 4)) := by
        dsimp [c]
        field_simp
      _ ≤ c₀ * min (u ^ 2 / K ^ 4) (u / K ^ 2) := by
        apply mul_le_mul_of_nonneg_left _ (le_of_lt hc₀)
        exact le_min hFirst hSecond
  exact mul_le_mul_of_nonneg_right hCore (by positivity : (0 : ℝ) ≤ n)

/-- Sub-Gaussian tail for the normalized Euclidean norm.  This is the
probability form of Theorem 3.1.1 before rescaling from `δ` to an absolute
deviation `t`. -/
theorem normalizedEuclideanNorm_tail :
    ∃ c : ℝ, 0 < c ∧
      ∀ {n : ℕ} [Nonempty (Fin n)]
        {Ω : Type*} [MeasurableSpace Ω]
        {μ : Measure Ω} [IsProbabilityMeasure μ]
        (X : Fin n → Ω → ℝ),
        (∀ i, Measurable (X i)) →
          (∀ i, SubGaussian.PsiTwoGauge μ (X i) < ∞) →
            (∀ i, (∫ ω, X i ω ^ 2 ∂μ) = 1) →
              ProbabilityTheory.iIndepFun X μ →
                ∀ {δ : ℝ}, 0 ≤ δ →
                  μ.real {ω |
                      |NumStability.vecNorm2 (fun i => X i ω) /
                        Real.sqrt (n : ℝ) - 1| ≥ δ} ≤
                    2 * Real.exp (-(c * δ ^ 2 /
                      (SubGaussian.psiTwoNormMax μ X) ^ 4 * (n : ℝ))) := by
  rcases centeredSquares_bernsteinAverageTailPsiTwo with ⟨c₀, hc₀, hSquareTail⟩
  let B : ℝ := (16 * Real.exp 1 * Real.sqrt 2) ^ 2
  let c : ℝ := c₀ / B
  have hB : 1 ≤ B := by
    dsimp [B]
    have hExp : 1 ≤ Real.exp 1 := Real.one_le_exp (by norm_num)
    have hSqrt : 1 ≤ Real.sqrt 2 := (Real.one_le_sqrt).2 (by norm_num)
    nlinarith [sq_nonneg (16 * Real.exp 1 * Real.sqrt 2 - 1)]
  have hBpos : 0 < B := lt_of_lt_of_le zero_lt_one hB
  have hc : 0 < c := div_pos hc₀ hBpos
  refine ⟨c, hc, ?_⟩
  intro n _ Ω _ μ _ X hMeas hFinite hSecond hIndep δ hδ
  have hn : 0 < n := Fin.pos_iff_nonempty.mpr inferInstance
  let K : ℝ := SubGaussian.psiTwoNormMax μ X
  let u : ℝ := max δ (δ ^ 2)
  have hKnonneg : 0 ≤ K := by
    dsimp [K]
    exact SubGaussian.psiTwoNormMax_nonneg
  have hKpos : 0 < K := by
    have hLower := one_le_scaled_psiTwoNormMax_sq X hMeas hFinite hSecond
    by_contra hNot
    have hKzero : K = 0 := le_antisymm (le_of_not_gt hNot) hKnonneg
    rw [show SubGaussian.psiTwoNormMax μ X = K by rfl, hKzero] at hLower
    norm_num at hLower
  have hBK : 1 ≤ B * K ^ 2 := by
    have hLower := one_le_scaled_psiTwoNormMax_sq X hMeas hFinite hSecond
    change 1 ≤ (16 * Real.exp 1 * Real.sqrt 2 * K) ^ 2 at hLower
    dsimp [B]
    nlinarith
  have hu : 0 ≤ u := le_trans hδ (le_max_left _ _)
  have hMeasure := measureReal_normDeviation_le_centeredSquareAverage
    (μ := μ) hn X hδ
  have hTail := hSquareTail X hMeas hFinite hSecond hIndep hu
  simp only [Fintype.card_fin] at hTail
  refine hMeasure.trans (hTail.trans ?_)
  apply mul_le_mul_of_nonneg_left (Real.exp_le_exp.mpr ?_) (by norm_num)
  apply neg_le_neg
  have hδSqNonneg : 0 ≤ δ ^ 2 := sq_nonneg δ
  have hKSqPos : 0 < K ^ 2 := sq_pos_of_pos hKpos
  have hKFourPos : 0 < K ^ 4 := pow_pos hKpos 4
  have hFirst : δ ^ 2 / (B * K ^ 4) ≤ u ^ 2 / K ^ 4 := by
    calc
      δ ^ 2 / (B * K ^ 4) ≤ δ ^ 2 / K ^ 4 := by
        apply div_le_div_of_nonneg_left hδSqNonneg hKFourPos
        simpa only [one_mul] using
          mul_le_mul_of_nonneg_right hB (le_of_lt hKFourPos)
      _ ≤ u ^ 2 / K ^ 4 := by
        apply div_le_div_of_nonneg_right _ (le_of_lt hKFourPos)
        have hδu : δ ≤ u := le_max_left _ _
        nlinarith
  have hSecondBranch : δ ^ 2 / (B * K ^ 4) ≤ u / K ^ 2 := by
    calc
      δ ^ 2 / (B * K ^ 4) ≤ δ ^ 2 / K ^ 2 := by
        apply div_le_div_of_nonneg_left hδSqNonneg hKSqPos
        have hDenom : K ^ 2 ≤ B * K ^ 4 := by
          have := mul_le_mul_of_nonneg_right hBK (sq_nonneg K)
          nlinarith
        exact hDenom
      _ ≤ u / K ^ 2 := by
        apply div_le_div_of_nonneg_right _ (le_of_lt hKSqPos)
        exact le_max_right _ _
  have hCore : c * δ ^ 2 / K ^ 4 ≤
      c₀ * min (u ^ 2 / K ^ 4) (u / K ^ 2) := by
    calc
      c * δ ^ 2 / K ^ 4 = c₀ * (δ ^ 2 / (B * K ^ 4)) := by
        dsimp [c]
        field_simp
      _ ≤ c₀ * min (u ^ 2 / K ^ 4) (u / K ^ 2) := by
        apply mul_le_mul_of_nonneg_left _ (le_of_lt hc₀)
        exact le_min hFirst hSecondBranch
  exact mul_le_mul_of_nonneg_right hCore (by positivity : (0 : ℝ) ≤ n)

/-- Sub-Gaussian tail for the absolute Euclidean-norm deviation.  This is the
rescaled probability form of Theorem 3.1.1. -/
theorem euclideanNormDeviation_tail :
    ∃ c : ℝ, 0 < c ∧
      ∀ {n : ℕ} [Nonempty (Fin n)]
        {Ω : Type*} [MeasurableSpace Ω]
        {μ : Measure Ω} [IsProbabilityMeasure μ]
        (X : Fin n → Ω → ℝ),
        (∀ i, Measurable (X i)) →
          (∀ i, SubGaussian.PsiTwoGauge μ (X i) < ∞) →
            (∀ i, (∫ ω, X i ω ^ 2 ∂μ) = 1) →
              ProbabilityTheory.iIndepFun X μ →
                ∀ {t : ℝ}, 0 ≤ t →
                  μ.real {ω |
                      |NumStability.vecNorm2 (fun i => X i ω) -
                        Real.sqrt (n : ℝ)| ≥ t} ≤
                    2 * Real.exp (-(c * t ^ 2 /
                      (SubGaussian.psiTwoNormMax μ X) ^ 4)) := by
  rcases normalizedEuclideanNorm_tail with ⟨c, hc, hNormalized⟩
  refine ⟨c, hc, ?_⟩
  intro n _ Ω _ μ _ X hMeas hFinite hSecond hIndep t ht
  have hn : 0 < n := Fin.pos_iff_nonempty.mpr inferInstance
  have hnR : (0 : ℝ) < n := by exact_mod_cast hn
  have hsqrt : 0 < Real.sqrt (n : ℝ) := Real.sqrt_pos.2 hnR
  have hEvent :
      {ω |
          |NumStability.vecNorm2 (fun i => X i ω) -
            Real.sqrt (n : ℝ)| ≥ t} =
        {ω |
          |NumStability.vecNorm2 (fun i => X i ω) /
            Real.sqrt (n : ℝ) - 1| ≥ t / Real.sqrt (n : ℝ)} := by
    ext ω
    simp only [Set.mem_setOf_eq]
    rw [show NumStability.vecNorm2 (fun i => X i ω) /
          Real.sqrt (n : ℝ) - 1 =
        (NumStability.vecNorm2 (fun i => X i ω) -
          Real.sqrt (n : ℝ)) / Real.sqrt (n : ℝ) by field_simp]
    rw [abs_div, abs_of_pos hsqrt]
    exact (div_le_div_iff_of_pos_right hsqrt).symm
  rw [hEvent]
  have hTail := hNormalized X hMeas hFinite hSecond hIndep
    (div_nonneg ht hsqrt.le)
  convert hTail using 1
  congr 3
  rw [div_pow, Real.sq_sqrt hnR.le]
  field_simp

/-- A quantified shell form of Euclidean-norm concentration, together with
the exact mean of the squared norm.  The shell width is independent of the
dimension and scales only with the squared maximum coordinate `ψ₂` gauge. -/
theorem shellProbability_and_squaredNormMean :
    ∃ C : ℝ, 0 < C ∧
      ∀ {n : ℕ} [Nonempty (Fin n)]
        {Ω : Type*} [MeasurableSpace Ω]
        {μ : Measure Ω} [IsProbabilityMeasure μ]
        (X : Fin n → Ω → ℝ),
        (∀ i, Measurable (X i)) →
          (∀ i, SubGaussian.PsiTwoGauge μ (X i) < ∞) →
            (∀ i, (∫ ω, X i ω ^ 2 ∂μ) = 1) →
              ProbabilityTheory.iIndepFun X μ →
                (μ.real {ω |
                    |NumStability.vecNorm2 (fun i => X i ω) -
                      Real.sqrt (n : ℝ)| ≥
                        C * (SubGaussian.psiTwoNormMax μ X) ^ 2} ≤
                      (1 / 100 : ℝ)) ∧
                  (∫ ω, NumStability.vecNorm2Sq (fun i => X i ω) ∂μ) = n := by
  rcases euclideanNormDeviation_tail with ⟨c, hc, hTail⟩
  let C : ℝ := Real.sqrt (Real.log 200 / c)
  have hlog : 0 < Real.log 200 := Real.log_pos (by norm_num)
  have hquot : 0 < Real.log 200 / c := div_pos hlog hc
  have hC : 0 < C := Real.sqrt_pos.2 hquot
  refine ⟨C, hC, ?_⟩
  intro n _ Ω _ μ _ X hMeas hFinite hSecond hIndep
  let K : ℝ := SubGaussian.psiTwoNormMax μ X
  have hKnonneg : 0 ≤ K := by
    dsimp [K]
    exact SubGaussian.psiTwoNormMax_nonneg
  have hKpos : 0 < K := by
    have hLower := one_le_scaled_psiTwoNormMax_sq X hMeas hFinite hSecond
    by_contra hNot
    have hKzero : K = 0 := le_antisymm (le_of_not_gt hNot) hKnonneg
    rw [show SubGaussian.psiTwoNormMax μ X = K by rfl, hKzero] at hLower
    norm_num at hLower
  constructor
  · have hBound := hTail X hMeas hFinite hSecond hIndep
        (mul_nonneg hC.le (sq_nonneg K))
    calc
      μ.real {ω |
          |NumStability.vecNorm2 (fun i => X i ω) -
            Real.sqrt (n : ℝ)| ≥ C * K ^ 2} ≤
          2 * Real.exp (-(c * (C * K ^ 2) ^ 2 / K ^ 4)) := hBound
      _ = (1 / 100 : ℝ) := by
        have hCsq : C ^ 2 = Real.log 200 / c := by
          dsimp [C]
          rw [Real.sq_sqrt hquot.le]
        rw [mul_pow, hCsq]
        field_simp [ne_of_gt hc, ne_of_gt hKpos]
        rw [Real.exp_neg, Real.exp_log (by norm_num : (0 : ℝ) < 200)]
        norm_num
  · apply NumStability.HDP.Vector.Moments.expectation_vecNorm2Sq_eq_card μ X
    · intro i
      rcases (SubGaussian.psiTwoGauge_finite_iff (μ := μ) (X := X i)).1
          (hFinite i) with ⟨Ki, hKi, hPoint⟩
      have hMajor : Integrable
          (fun ω => Ki ^ 2 * Real.exp ((X i ω) ^ 2 / Ki ^ 2)) μ :=
        hPoint.2.2.1.const_mul _
      refine Integrable.mono' hMajor (by fun_prop) ?_
      filter_upwards [] with ω
      rw [Real.norm_eq_abs, abs_of_nonneg (sq_nonneg (X i ω))]
      have hexp : (X i ω) ^ 2 / Ki ^ 2 ≤
          Real.exp ((X i ω) ^ 2 / Ki ^ 2) := by
        calc
          (X i ω) ^ 2 / Ki ^ 2 ≤ (X i ω) ^ 2 / Ki ^ 2 + 1 := by linarith
          _ ≤ Real.exp ((X i ω) ^ 2 / Ki ^ 2) := Real.add_one_le_exp _
      have hKiSq : 0 < Ki ^ 2 := sq_pos_of_pos hKi
      calc
        (X i ω) ^ 2 = Ki ^ 2 * ((X i ω) ^ 2 / Ki ^ 2) := by
          field_simp [ne_of_gt hKi]
        _ ≤ Ki ^ 2 * Real.exp ((X i ω) ^ 2 / Ki ^ 2) :=
          mul_le_mul_of_nonneg_left hexp hKiSq.le
    · exact hSecond

/-- The Euclidean-norm deviation in Theorem 3.1.1 has exact `ψ₂` gauge at
most one universal multiple of the squared maximum coordinate gauge. -/
theorem euclideanNormDeviation_psiTwoGauge :
    ∃ C : ℝ, 1 ≤ C ∧
      ∀ {n : ℕ} [Nonempty (Fin n)]
        {Ω : Type*} [MeasurableSpace Ω]
        {μ : Measure Ω} [IsProbabilityMeasure μ]
        (X : Fin n → Ω → ℝ),
        (∀ i, Measurable (X i)) →
          (∀ i, SubGaussian.PsiTwoGauge μ (X i) < ∞) →
            (∀ i, (∫ ω, X i ω ^ 2 ∂μ) = 1) →
              ProbabilityTheory.iIndepFun X μ →
                SubGaussian.PsiTwoGauge μ
                    (fun ω => NumStability.vecNorm2 (fun i => X i ω) -
                      Real.sqrt (n : ℝ)) ≤
                  ENNReal.ofReal
                    (C * (SubGaussian.psiTwoNormMax μ X) ^ 2) := by
  rcases euclideanNormDeviation_tail with ⟨c, hc, hTail⟩
  let A : ℝ := 4096 * Real.exp 1
  let C : ℝ := 1 + A / Real.sqrt c
  have hA : 0 < A := by dsimp [A]; positivity
  have hsqrt : 0 < Real.sqrt c := Real.sqrt_pos.2 hc
  have hC : 1 ≤ C := by
    dsimp [C]
    exact le_add_of_nonneg_right (div_nonneg hA.le hsqrt.le)
  refine ⟨C, hC, ?_⟩
  intro n _ Ω _ μ _ X hMeas hFinite hSecond hIndep
  let K : ℝ := SubGaussian.psiTwoNormMax μ X
  let L : ℝ := K ^ 2 / Real.sqrt c
  let Z : Ω → ℝ := fun ω =>
    NumStability.vecNorm2 (fun i => X i ω) - Real.sqrt (n : ℝ)
  have hKnonneg : 0 ≤ K := by
    dsimp [K]
    exact SubGaussian.psiTwoNormMax_nonneg
  have hKpos : 0 < K := by
    have hLower := one_le_scaled_psiTwoNormMax_sq X hMeas hFinite hSecond
    by_contra hNot
    have hKzero : K = 0 := le_antisymm (le_of_not_gt hNot) hKnonneg
    rw [show SubGaussian.psiTwoNormMax μ X = K by rfl, hKzero] at hLower
    norm_num at hLower
  have hL : 0 < L := div_pos (sq_pos_of_pos hKpos) hsqrt
  have hZMeas : Measurable Z := by
    dsimp [Z, NumStability.vecNorm2, NumStability.vecNorm2Sq]
    fun_prop
  have hProp : SubGaussian.SubGaussianProperty μ Z .tail L := by
    change SubGaussian.SubGaussianTailBound μ Z L
    refine ⟨hZMeas, hL, ?_⟩
    intro t ht
    have hBound := hTail X hMeas hFinite hSecond hIndep ht
    simpa only [Z, K, L] using hBound.trans_eq (by
      congr 3
      rw [div_pow, Real.sq_sqrt hc.le]
      field_simp)
  have hGauge := SubGaussian.psiTwoGauge_le_of_property .tail hL hProp
  refine hGauge.trans (ENNReal.ofReal_mono ?_)
  change A * L ≤ C * K ^ 2
  dsimp [C, L]
  have hKSq : 0 ≤ K ^ 2 := sq_nonneg K
  calc
    A * (K ^ 2 / Real.sqrt c) = (A / Real.sqrt c) * K ^ 2 := by ring
    _ ≤ (1 + A / Real.sqrt c) * K ^ 2 := by
      gcongr
      linarith

/-- The expected Euclidean norm in Theorem 3.1.1 differs from `√n` by at
most one universal multiple of the squared maximum coordinate `ψ₂` gauge. -/
theorem expectationEuclideanNorm_abs_sub_sqrt_le :
    ∃ C : ℝ, 1 ≤ C ∧
      ∀ {n : ℕ} [Nonempty (Fin n)]
        {Ω : Type*} [MeasurableSpace Ω]
        {μ : Measure Ω} [IsProbabilityMeasure μ]
        (X : Fin n → Ω → ℝ),
        (∀ i, Measurable (X i)) →
          (∀ i, SubGaussian.PsiTwoGauge μ (X i) < ∞) →
            (∀ i, (∫ ω, X i ω ^ 2 ∂μ) = 1) →
              ProbabilityTheory.iIndepFun X μ →
                |(∫ ω, NumStability.vecNorm2 (fun i ↦ X i ω) ∂μ) -
                    Real.sqrt (n : ℝ)| ≤
                  C * (SubGaussian.psiTwoNormMax μ X) ^ 2 := by
  rcases euclideanNormDeviation_psiTwoGauge with ⟨A, hA, hGauge⟩
  let C : ℝ := 1 + 16 * Real.exp 1 * A
  have hC : 1 ≤ C := by
    dsimp [C]
    have hA0 : 0 ≤ A := le_trans (by norm_num) hA
    have hExp0 : 0 ≤ Real.exp 1 := (Real.exp_pos 1).le
    nlinarith [mul_nonneg (mul_nonneg (by norm_num : (0 : ℝ) ≤ 16) hExp0) hA0]
  refine ⟨C, hC, ?_⟩
  intro n _ Ω _ μ _ X hMeas hFinite hSecond hIndep
  let K : ℝ := SubGaussian.psiTwoNormMax μ X
  let Z : Ω → ℝ := fun ω =>
    NumStability.vecNorm2 (fun i => X i ω) - Real.sqrt (n : ℝ)
  have hKnonneg : 0 ≤ K := by
    dsimp [K]
    exact SubGaussian.psiTwoNormMax_nonneg
  have hZMeas : Measurable Z := by
    dsimp [Z, NumStability.vecNorm2, NumStability.vecNorm2Sq]
    fun_prop
  have hGaugeBound :
      SubGaussian.PsiTwoGauge μ Z ≤ ENNReal.ofReal (A * K ^ 2) := by
    simpa only [Z, K] using hGauge X hMeas hFinite hSecond hIndep
  have hZFinite : SubGaussian.PsiTwoGauge μ Z < ∞ :=
    hGaugeBound.trans_lt ENNReal.ofReal_lt_top
  have hGaugeRealBound :
      (SubGaussian.PsiTwoGauge μ Z).toReal ≤ A * K ^ 2 := by
    exact ENNReal.toReal_le_of_le_ofReal
      (mul_nonneg (le_trans zero_le_one hA) (sq_nonneg K)) hGaugeBound
  have hGrowth := SubGaussian.psiTwoGaugeToLpMomentGrowth hZMeas hZFinite
  have hMomentOne := hGrowth.2 1 (by norm_num : (1 : ℝ) ≤ 1)
  have hAbsInt : Integrable (fun ω => |Z ω|) μ := by
    simpa using hMomentOne.1
  have hZInt : Integrable Z μ := by
    apply (MeasureTheory.integrable_norm_iff hZMeas.aestronglyMeasurable).mp
    simpa [Real.norm_eq_abs] using hAbsInt
  have hNormInt : Integrable
      (fun ω => NumStability.vecNorm2 (fun i => X i ω)) μ := by
    have hAdd : Integrable (fun ω => Z ω + Real.sqrt (n : ℝ)) μ :=
      hZInt.add (integrable_const _)
    simpa [Z] using hAdd
  have hIntegralZ :
      (∫ ω, Z ω ∂μ) =
        (∫ ω, NumStability.vecNorm2 (fun i => X i ω) ∂μ) -
          Real.sqrt (n : ℝ) := by
    dsimp [Z]
    rw [integral_sub hNormInt (integrable_const _)]
    simp
  have hAbsMoment :
      (∫ ω, |Z ω| ∂μ) ≤
        16 * Real.exp 1 * (SubGaussian.PsiTwoGauge μ Z).toReal := by
    simpa using hMomentOne.2
  calc
    |(∫ ω, NumStability.vecNorm2 (fun i => X i ω) ∂μ) -
          Real.sqrt (n : ℝ)| = |(∫ ω, Z ω ∂μ)| := by rw [hIntegralZ]
    _ ≤ ∫ ω, |Z ω| ∂μ := abs_integral_le_integral_abs
    _ ≤ 16 * Real.exp 1 * (SubGaussian.PsiTwoGauge μ Z).toReal := hAbsMoment
    _ ≤ 16 * Real.exp 1 * (A * K ^ 2) := by
      gcongr
    _ ≤ C * K ^ 2 := by
      dsimp [C]
      nlinarith [sq_nonneg K]

end NumStability.HDP.Vector.NormConcentration
