import Mathlib.Probability.Distributions.Gaussian.Real
import Mathlib.Analysis.Complex.Exponential
import Mathlib.Algebra.Order.Field.Basic
import Mathlib.Algebra.Order.BigOperators.Ring.Finset
import Mathlib.Algebra.BigOperators.Ring.Finset
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Ring
import Mathlib.Tactic.Linarith


/-!
# Finite Gaussian likelihood comparison

The likelihoods of opposite coordinate means are ordered by their weighted
linear score. Coordinate variances may differ and must be nonzero. Means may
have either sign, the finite index type may be empty, and comparison is weak.
-/

set_option autoImplicit false

open MeasureTheory ProbabilityTheory
open scoped BigOperators ENNReal NNReal ProbabilityTheory

universe u
namespace NumStability.HDP.Probability

/-- Product of real Gaussian coordinate densities with the supplied variances. -/
noncomputable def vectorGaussianLikelihood {ι : Type*} [Fintype ι]
    (m : ι → ℝ) (v : ι → ℝ≥0) (x : ι → ℝ) : ℝ :=
  ∏ j, gaussianPDFReal (m j) (v j) (x j)

/-- Linear score weighted by coordinate variances, rather than standard deviations. -/
noncomputable def weightedGaussianScore {ι : Type*} [Fintype ι]
    (r : ι → ℝ) (v : ι → ℝ≥0) (x : ι → ℝ) : ℝ :=
  ∑ j, r j * x j / (v j : ℝ)

/-- Opposite finite Gaussian likelihoods compare by the sign of their weighted score. -/
theorem vectorGaussianLikelihood_neg_le_iff_score_nonneg {ι : Type u} [Fintype ι]
    (r : ι → ℝ) (v : ι → ℝ≥0) (hv : ∀ j, v j ≠ 0) (x : ι → ℝ) :
    vectorGaussianLikelihood (fun j ↦ -(r j)) v x ≤ vectorGaussianLikelihood r v x ↔
      0 ≤ weightedGaussianScore r v x := by
  classical
  let C : ℝ := ∏ j, (Real.sqrt (2 * Real.pi * (v j : ℝ)))⁻¹
  let E : (ι → ℝ) → ℝ := fun m ↦
    ∑ j, -(x j - m j) ^ 2 / (2 * (v j : ℝ))
  have hC : 0 < C := by
    apply Finset.prod_pos
    intro j _
    simpa [gaussianPDFReal] using gaussianPDFReal_pos 0 (v j) 0 (hv j)
  have hfactor (m : ι → ℝ) :
      vectorGaussianLikelihood m v x = C * Real.exp (E m) := by
    simp only [vectorGaussianLikelihood, gaussianPDFReal, C, E]
    rw [Finset.prod_mul_distrib, Real.exp_sum]
  have hdiff :
      E r - E (fun j ↦ -(r j)) = 2 * weightedGaussianScore r v x := by
    dsimp [E, weightedGaussianScore]
    rw [← Finset.sum_sub_distrib, Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro j _
    have hvj : (v j : ℝ) ≠ 0 := NNReal.coe_ne_zero.mpr (hv j)
    field_simp [hvj] <;> ring
  rw [hfactor (fun j ↦ -(r j)), hfactor r,
    mul_le_mul_iff_right₀ hC, Real.exp_le_exp]
  constructor
  · intro h
    linarith [hdiff]
  · intro h
    linarith [hdiff]

/-- Positive-component likelihood divided by the sum of opposite likelihoods. -/
noncomputable def vectorGaussianLikelihoodRatio {ι : Type*} [Fintype ι]
    (r : ι → ℝ) (v : ι → ℝ≥0) (x : ι → ℝ) : ℝ :=
  vectorGaussianLikelihood r v x /
    (vectorGaussianLikelihood (fun j ↦ -(r j)) v x + vectorGaussianLikelihood r v x)

/-- Weak likelihood mode, choosing true when the weighted score is zero. -/
noncomputable def weightedGaussianWeakMode {ι : Type*} [Fintype ι]
    (r : ι → ℝ) (v : ι → ℝ≥0) (x : ι → ℝ) : Bool :=
  if 0 ≤ weightedGaussianScore r v x then true else false

/-- The normalized positive-component likelihood lies in `(0, 1)` and the
weak score mode selects a likelihood at least as large as its opposite. -/
theorem vectorGaussianLikelihoodRatio_range_and_weakMode {ι : Type u} [Fintype ι]
    (r : ι → ℝ) (v : ι → ℝ≥0) (hv : ∀ j, v j ≠ 0) (x : ι → ℝ) :
    0 < vectorGaussianLikelihoodRatio r v x ∧ vectorGaussianLikelihoodRatio r v x < 1 ∧
      (if weightedGaussianWeakMode r v x then
        1 - vectorGaussianLikelihoodRatio r v x ≤ vectorGaussianLikelihoodRatio r v x
      else vectorGaussianLikelihoodRatio r v x ≤ 1 - vectorGaussianLikelihoodRatio r v x) := by
  classical
  have hplus : 0 < vectorGaussianLikelihood r v x := by
    unfold vectorGaussianLikelihood
    exact Finset.prod_pos fun j _ ↦ gaussianPDFReal_pos (r j) (v j) (x j) (hv j)
  have hminus : 0 < vectorGaussianLikelihood (fun j ↦ -(r j)) v x := by
    unfold vectorGaussianLikelihood
    exact Finset.prod_pos fun j _ ↦ gaussianPDFReal_pos (-(r j)) (v j) (x j) (hv j)
  have hD : 0 < vectorGaussianLikelihood (fun j ↦ -(r j)) v x +
      vectorGaussianLikelihood r v x := add_pos hminus hplus
  have hqpos : 0 < vectorGaussianLikelihoodRatio r v x := by
    exact div_pos hplus hD
  have hqlt : vectorGaussianLikelihoodRatio r v x < 1 := by
    apply (div_lt_one hD).mpr
    linarith
  have hcomplement :
      1 - vectorGaussianLikelihoodRatio r v x =
        vectorGaussianLikelihood (fun j ↦ -(r j)) v x /
          (vectorGaussianLikelihood (fun j ↦ -(r j)) v x +
            vectorGaussianLikelihood r v x) := by
    unfold vectorGaussianLikelihoodRatio
    field_simp [ne_of_gt hD] <;> ring
  have hcompare :
      vectorGaussianLikelihood (fun j ↦ -(r j)) v x ≤
        vectorGaussianLikelihood r v x ↔ 0 ≤ weightedGaussianScore r v x :=
    vectorGaussianLikelihood_neg_le_iff_score_nonneg r v hv x
  refine ⟨hqpos, hqlt, ?_⟩
  by_cases hx : 0 ≤ weightedGaussianScore r v x
  · have hweak : 1 - vectorGaussianLikelihoodRatio r v x ≤ vectorGaussianLikelihoodRatio r v x := by
      rw [hcomplement]
      exact (div_le_div_iff_of_pos_right hD).mpr (hcompare.mpr hx)
    simpa [weightedGaussianWeakMode, hx] using hweak
  · have hnot :
        ¬ vectorGaussianLikelihood (fun j ↦ -(r j)) v x ≤
          vectorGaussianLikelihood r v x := by
      intro h
      exact hx (hcompare.mp h)
    have hreverse :
        vectorGaussianLikelihood r v x ≤
          vectorGaussianLikelihood (fun j ↦ -(r j)) v x :=
      (lt_of_not_ge hnot).le
    have hweak : vectorGaussianLikelihoodRatio r v x ≤ 1 - vectorGaussianLikelihoodRatio r v x := by
      rw [hcomplement]
      exact (div_le_div_iff_of_pos_right hD).mpr hreverse
    simpa [weightedGaussianWeakMode, hx] using hweak

/-- The weak Gaussian score mode is measurable, including at zero variances. -/
theorem measurable_weightedGaussianWeakMode {ι : Type u} [Fintype ι]
    (r : ι → ℝ) (v : ι → ℝ≥0) : Measurable (weightedGaussianWeakMode r v) := by
  classical
  change Measurable (weightedGaussianWeakMode r v)
  have hscore : Measurable (weightedGaussianScore r v) := by
    unfold weightedGaussianScore
    exact Finset.measurable_sum Finset.univ fun j _ ↦
      ((measurable_pi_apply j : Measurable (fun x : ι → ℝ ↦ x j)).const_mul
        (r j)).div_const (v j : ℝ)
  have hthreshold : MeasurableSet
      {x : ι → ℝ | 0 ≤ weightedGaussianScore r v x} :=
    measurableSet_le measurable_const hscore
  have hpreimage :
      weightedGaussianWeakMode r v ⁻¹' ({true} : Set Bool) =
        {x : ι → ℝ | 0 ≤ weightedGaussianScore r v x} := by
    ext x
    by_cases hx : 0 ≤ weightedGaussianScore r v x
    · simp [weightedGaussianWeakMode, hx]
    · simp [weightedGaussianWeakMode, hx]
  apply measurable_to_bool
  rw [hpreimage]
  exact hthreshold

end NumStability.HDP.Probability
