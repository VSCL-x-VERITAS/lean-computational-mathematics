import ComputationalMathematics.HDP.Vector.Moments
import Mathlib.Probability.Moments.Variance

/-!
# Euclidean-norm variance from coordinate fourth moments

Reusable finite-dimensional variance bounds for random vectors with independent
coordinates and controlled fourth moments.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators ENNReal

namespace NumStability.HDP.Vector.NormFourthMoment

/-- Independent coordinates with unit second moments and fourth moments at most
`K⁴` have Euclidean-norm variance at most `K⁴`. -/
theorem varianceEuclideanNorm_le_fourthMoment
    {n : ℕ} [Nonempty (Fin n)]
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (X : Fin n → Ω → ℝ) (K : ℝ)
    (hMeas : ∀ i, Measurable (X i))
    (hFourthInt : ∀ i, Integrable (fun ω => X i ω ^ 4) μ)
    (hSecond : ∀ i, (∫ ω, X i ω ^ 2 ∂μ) = 1)
    (hFourth : ∀ i, (∫ ω, X i ω ^ 4 ∂μ) ≤ K ^ 4)
    (hIndep : iIndepFun X μ) :
    variance (fun ω => NumStability.vecNorm2 (fun i => X i ω)) μ ≤ K ^ 4 := by
  let S : Ω → ℝ := fun ω => NumStability.vecNorm2Sq (fun i => X i ω)
  let R : Ω → ℝ := fun ω => NumStability.vecNorm2 (fun i => X i ω)
  let s : ℝ := Real.sqrt (n : ℝ)
  let Z : Ω → ℝ := fun ω => R ω - s
  have hn : 0 < n := Fin.pos_iff_nonempty.mpr inferInstance
  have hnR : (0 : ℝ) < n := by exact_mod_cast hn
  have hs0 : 0 ≤ s := Real.sqrt_nonneg _
  have hsSq : s ^ 2 = (n : ℝ) := by
    dsimp [s]
    rw [Real.sq_sqrt hnR.le]
  have hSMeas : Measurable S := by
    dsimp [S, NumStability.vecNorm2Sq]
    fun_prop
  have hRMeas : Measurable R := by
    dsimp [R, NumStability.vecNorm2, NumStability.vecNorm2Sq]
    fun_prop
  have hZMeas : Measurable Z := by
    dsimp [Z]
    fun_prop
  have hLpSq : ∀ i, MemLp (fun ω => X i ω ^ 2) 2 μ := by
    intro i
    apply (memLp_two_iff_integrable_sq (by fun_prop)).2
    exact (hFourthInt i).congr (Filter.Eventually.of_forall fun ω => by ring)
  have hIndepSq : iIndepFun (fun i ω => X i ω ^ 2) μ := by
    simpa [Function.comp_def] using
      hIndep.comp (fun (_ : Fin n) (x : ℝ) => x ^ 2) (fun _ => by fun_prop)
  have hVarSum :
      variance S μ = ∑ i : Fin n, variance (fun ω => X i ω ^ 2) μ := by
    rw [show S = ∑ i : Fin n, (fun ω => X i ω ^ 2) by
      funext ω
      simp [S, NumStability.vecNorm2Sq]]
    exact ProbabilityTheory.IndepFun.variance_sum
      (μ := μ) (s := Finset.univ) (X := fun i ω => X i ω ^ 2)
      (fun i _hi => hLpSq i)
      (by
        intro i _hi j _hj hij
        exact hIndepSq.indepFun hij)
  have hVarEach : ∀ i, variance (fun ω => X i ω ^ 2) μ ≤ K ^ 4 := by
    intro i
    have hVariance : variance (fun ω => X i ω ^ 2) μ ≤
        ∫ ω, (X i ω ^ 2) ^ 2 ∂μ := by
      simpa only [Pi.pow_apply] using
        (variance_le_expectation_sq
          (μ := μ) (X := fun ω => X i ω ^ 2) (by fun_prop))
    refine hVariance.trans ?_
    simpa only [show ∀ x : ℝ, (x ^ 2) ^ 2 = x ^ 4 by intro x; ring] using hFourth i
  have hVarSBound : variance S μ ≤ (n : ℝ) * K ^ 4 := by
    rw [hVarSum]
    calc
      (∑ i : Fin n, variance (fun ω => X i ω ^ 2) μ) ≤
          ∑ _i : Fin n, K ^ 4 := Finset.sum_le_sum (fun i _hi => hVarEach i)
      _ = (n : ℝ) * K ^ 4 := by simp
  have hMeanS : (∫ ω, S ω ∂μ) = n := by
    simpa only [S] using
      NumStability.HDP.Vector.Moments.expectation_vecNorm2Sq_eq_card μ X
        (fun i => (hLpSq i).integrable (by norm_num)) hSecond
  have hLpS : MemLp S 2 μ := by
    simpa [S, NumStability.vecNorm2Sq] using
      (memLp_finset_sum (μ := μ) Finset.univ (fun i _hi => hLpSq i))
  have hSSubSqInt : Integrable (fun ω => (S ω - (n : ℝ)) ^ 2) μ := by
    have hSub : MemLp (fun ω => S ω - (n : ℝ)) 2 μ := by
      simpa only [Pi.sub_apply] using hLpS.sub (memLp_const (n : ℝ))
    exact hSub.integrable_sq
  have hPoint : ∀ ω, Z ω ^ 2 ≤ (S ω - (n : ℝ)) ^ 2 / (n : ℝ) := by
    intro ω
    have hR0 : 0 ≤ R ω := by
      dsimp [R, NumStability.vecNorm2]
      exact Real.sqrt_nonneg _
    have hRSq : R ω ^ 2 = S ω := by
      simpa only [R, S] using
        (NumStability.vecNorm2_sq (fun i => X i ω))
    apply (le_div_iff₀ hnR).2
    dsimp [Z]
    calc
      (R ω - s) ^ 2 * (n : ℝ) = (R ω - s) ^ 2 * s ^ 2 := by rw [hsSq]
      _ ≤ (R ω - s) ^ 2 * (R ω + s) ^ 2 := by
        gcongr
        nlinarith
      _ = (S ω - (n : ℝ)) ^ 2 := by rw [← hRSq, ← hsSq]; ring
  have hQuotInt : Integrable (fun ω => (S ω - (n : ℝ)) ^ 2 / (n : ℝ)) μ := by
    simpa [div_eq_mul_inv, mul_comm] using hSSubSqInt.const_mul ((n : ℝ)⁻¹)
  have hZSqInt : Integrable (fun ω => Z ω ^ 2) μ := by
    apply hQuotInt.mono (by fun_prop)
    filter_upwards [] with ω
    rw [Real.norm_eq_abs, Real.norm_eq_abs, abs_of_nonneg (sq_nonneg _)]
    rw [abs_of_nonneg (div_nonneg (sq_nonneg _) hnR.le)]
    exact hPoint ω
  have hZSqBound : (∫ ω, Z ω ^ 2 ∂μ) ≤ K ^ 4 := by
    calc
      (∫ ω, Z ω ^ 2 ∂μ) ≤
          ∫ ω, (S ω - (n : ℝ)) ^ 2 / (n : ℝ) ∂μ :=
        integral_mono hZSqInt hQuotInt hPoint
      _ = variance S μ / (n : ℝ) := by
        rw [integral_div]
        rw [variance_eq_integral hSMeas.aemeasurable, hMeanS]
      _ ≤ K ^ 4 := (div_le_iff₀ hnR).2 (by simpa [mul_comm] using hVarSBound)
  rw [← variance_sub_const hRMeas.aestronglyMeasurable s]
  have hVariance : variance Z μ ≤ ∫ ω, Z ω ^ 2 ∂μ := by
    simpa only [Z, Pi.pow_apply] using
      (variance_le_expectation_sq hZMeas.aestronglyMeasurable)
  exact hVariance.trans hZSqBound

end NumStability.HDP.Vector.NormFourthMoment
