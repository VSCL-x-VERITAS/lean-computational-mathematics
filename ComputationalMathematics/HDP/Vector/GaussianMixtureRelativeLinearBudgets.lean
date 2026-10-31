import ComputationalMathematics.HDP.Vector.GaussianMixtureProjectionBudgets

/-!
# Explicit scalar relative-error thresholds for the linear projection-energy budget.

Ordinary finite/model-specific prerequisites with explicit hypotheses.
No printed sample commitment or author convention is selected.
-/

noncomputable section
open Matrix MeasureTheory ProbabilityTheory Set
open scoped ENNReal BigOperators

namespace NumStability.HDP.Vector.GaussianMixture

/-- A small relative covariance error suffices for the linear projection-energy
budget and strict positivity of the clipped empirical signal amplitude. -/
theorem linear_projection_budget_and_small_error_of_relative_error_le
    (r ε q : ℝ) (hr : 1 ≤ r) (hε : 0 < ε) (hεone : ε ≤ 1)
    (hq : 0 ≤ q) (hsmall : q ≤ Real.sqrt ε * r ^ 2 / 16) :
    (8 * q ^ 2 / r ^ 2) * (1 + r ^ 2 + q) ≤ ε / 2 * (r ^ 2 / 2) ^ 2 ∧
      q < r ^ 2 := by
  have hrpos : 0 < r := by linarith
  have hr2 : 1 ≤ r ^ 2 := by nlinarith
  have hroot : Real.sqrt ε ≤ 1 := Real.sqrt_le_one.mpr hεone
  have hqone : q ≤ r ^ 2 / 16 := by
    calc
      q ≤ Real.sqrt ε * r ^ 2 / 16 := hsmall
      _ ≤ r ^ 2 / 16 := by
        exact div_le_div_of_nonneg_right
          (by simpa only [one_mul] using
            mul_le_mul_of_nonneg_right hroot (sq_nonneg r)) (by norm_num)
  have hqsmall : q < r ^ 2 := by nlinarith
  have hqsq : q ^ 2 ≤ ε * (r ^ 2) ^ 2 / 256 := by
    calc
      q ^ 2 ≤ (Real.sqrt ε * r ^ 2 / 16) ^ 2 :=
        (sq_le_sq₀ hq (by positivity)).mpr hsmall
      _ = _ := by
        rw [div_pow, mul_pow, Real.sq_sqrt hε.le]
        ring
  have hcoefficient : 1 + r ^ 2 + q ≤ 3 * r ^ 2 := by nlinarith
  have hfirst : 8 * q ^ 2 / r ^ 2 ≤ 8 * (ε * (r ^ 2) ^ 2 / 256) / r ^ 2 :=
    div_le_div_of_nonneg_right
      (mul_le_mul_of_nonneg_left hqsq (by norm_num)) (sq_nonneg r)
  refine ⟨?_, hqsmall⟩
  calc
    _ ≤ (8 * (ε * (r ^ 2) ^ 2 / 256) / r ^ 2) * (3 * r ^ 2) :=
      mul_le_mul hfirst hcoefficient (by positivity) (by positivity)
    _ = 3 * ε * (r ^ 2) ^ 2 / 32 := by
      field_simp [hrpos.ne']
      ring
    _ ≤ _ := by nlinarith [mul_nonneg hε.le (sq_nonneg (r ^ 2))]

/-- Explicit small noise-covariance and signed-average parameters imply the
relative error budget required by the linear projection transfer. -/
theorem relative_covariance_budget_of_delta_and_average
    (r ε δ a : ℝ) (hr : 1 ≤ r) (hε : 0 < ε) (hεone : ε ≤ 1)
    (hδ : 0 ≤ δ)
    (hδsmall : δ ≤ Real.sqrt ε * r / 128)
    (hasmall : a ≤ Real.sqrt ε * r / 64) :
    4 * max δ (δ ^ 2) + 2 * r * a ≤ Real.sqrt ε * r ^ 2 / 16 := by
  have hr0 : 0 ≤ r := by linarith
  have hrr : r ≤ r ^ 2 := by nlinarith
  have hroot : Real.sqrt ε ≤ 1 := Real.sqrt_le_one.mpr hεone
  have hεroot : ε ≤ Real.sqrt ε := by
    nlinarith [Real.sq_sqrt hε.le, Real.sqrt_nonneg ε]
  have hδfirst : δ ≤ Real.sqrt ε * r ^ 2 / 128 := by
    calc
      δ ≤ Real.sqrt ε * r / 128 := hδsmall
      _ ≤ _ := div_le_div_of_nonneg_right
        (mul_le_mul_of_nonneg_left hrr (Real.sqrt_nonneg ε)) (by norm_num)
  have hδsq : δ ^ 2 ≤ ε * r ^ 2 / 16384 := by
    calc
      δ ^ 2 ≤ (Real.sqrt ε * r / 128) ^ 2 :=
        (sq_le_sq₀ hδ (by positivity)).mpr hδsmall
      _ = _ := by rw [div_pow, mul_pow, Real.sq_sqrt hε.le]; ring
  have hδsecond : δ ^ 2 ≤ Real.sqrt ε * r ^ 2 / 128 := by
    calc
      δ ^ 2 ≤ ε * r ^ 2 / 16384 := hδsq
      _ ≤ Real.sqrt ε * r ^ 2 / 16384 := div_le_div_of_nonneg_right
        (mul_le_mul_of_nonneg_right hεroot (sq_nonneg r)) (by norm_num)
      _ ≤ _ := by nlinarith [mul_nonneg (Real.sqrt_nonneg ε) (sq_nonneg r)]
  have hmax : max δ (δ ^ 2) ≤ Real.sqrt ε * r ^ 2 / 128 :=
    max_le hδfirst hδsecond
  have hcross : 2 * r * a ≤ 2 * r * (Real.sqrt ε * r / 64) :=
    mul_le_mul_of_nonneg_left hasmall (by positivity)
  nlinarith

end NumStability.HDP.Vector.GaussianMixture
