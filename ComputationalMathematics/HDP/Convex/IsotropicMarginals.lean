import ComputationalMathematics.HDP.Convex.IsotropicBody
import ComputationalMathematics.HDP.Scalar.SubExponentialTailGauge
import ComputationalMathematics.HDP.Vector.LinearMarginals
import ComputationalMathematics.HDP.Vector.MarginalVariance
import Mathlib.Analysis.Convex.Measure

/-!
# Marginals of isotropic convex bodies

This module connects the normalized-volume model of a convex body to the
general finite-vector marginal API.  In particular, boundedness supplies the
coordinate integrability needed to use the centered-isotropy identities.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped ENNReal

namespace NumStability.HDP.Convex

/-- Every coordinate belongs to every finite `Lᵖ` space under normalized
volume on a convex body. -/
theorem coordinate_memLp_of_isConvexBody {n : ℕ} {K : Set (Fin n → ℝ)}
    (hK : IsConvexBody K) (i : Fin n) (p : ℝ≥0∞) :
    MemLp (fun x : Fin n → ℝ => x i) p (uniformConvexBodyMeasure K) := by
  letI : IsProbabilityMeasure (uniformConvexBodyMeasure K) :=
    uniformConvexBodyMeasure_isProbabilityMeasure hK
  rcases hK.2.1.exists_norm_le with ⟨C, hC⟩
  apply MemLp.of_bound (continuous_apply i).aestronglyMeasurable C
  unfold uniformConvexBodyMeasure
  filter_upwards [ProbabilityTheory.ae_cond_mem₀ (hK.1.nullMeasurableSet volume)] with x hx
  exact (norm_le_pi_norm x i).trans (hC x hx)

/-- A linear marginal of normalized volume on a convex body is square
integrable. -/
theorem linearMarginal_memLp_of_isConvexBody {n : ℕ}
    {K : Set (Fin n → ℝ)} (hK : IsConvexBody K) (u : Fin n → ℝ) :
    MemLp
      (NumStability.HDP.Vector.linearMarginal (fun i x => x i) u)
      2 (uniformConvexBodyMeasure K) := by
  apply NumStability.HDP.Vector.Isotropy.marginal_memLp
  exact fun i => coordinate_memLp_of_isConvexBody hK i 2

/-- Every linear marginal of an isotropic convex body is centered. -/
theorem linearMarginal_integral_eq_zero_of_isIsotropicConvexBody {n : ℕ}
    {K : Set (Fin n → ℝ)} (hK : IsIsotropicConvexBody K)
    (u : Fin n → ℝ) :
    ∫ x, NumStability.HDP.Vector.linearMarginal (fun i x => x i) u x
        ∂uniformConvexBodyMeasure K = 0 := by
  letI : IsProbabilityMeasure (uniformConvexBodyMeasure K) :=
    uniformConvexBodyMeasure_isProbabilityMeasure hK.1
  simpa [NumStability.HDP.Vector.linearMarginal] using
    (NumStability.HDP.Vector.Isotropy.integral_marginal_eq_zero
      (fun i => coordinate_memLp_of_isConvexBody hK.1 i 2) hK.2.1 u)

/-- The second moment of every linear marginal of an isotropic convex body is
the squared Euclidean norm of its direction. -/
theorem marginalSecondMoment_eq_normSq_of_isIsotropicConvexBody {n : ℕ}
    {K : Set (Fin n → ℝ)} (hK : IsIsotropicConvexBody K)
    (u : Fin n → ℝ) :
    NumStability.HDP.Vector.Isotropy.marginalSecondMoment
        (uniformConvexBodyMeasure K) (fun i x => x i) u =
      ∑ i, (u i) ^ 2 := by
  apply (NumStability.HDP.Vector.Isotropy.isIsotropic_iff_marginalSecondMoment
    (uniformConvexBodyMeasure K) (fun i x => x i) ?_).1 hK.2.2 u
  intro i j
  exact (coordinate_memLp_of_isConvexBody hK.1 i 2).integrable_mul
    (coordinate_memLp_of_isConvexBody hK.1 j 2)

/-- The variance of every linear marginal of an isotropic convex body is the
squared Euclidean norm of its direction. -/
theorem linearMarginal_variance_eq_normSq_of_isIsotropicConvexBody {n : ℕ}
    {K : Set (Fin n → ℝ)} (hK : IsIsotropicConvexBody K)
    (u : Fin n → ℝ) :
    variance
        (NumStability.HDP.Vector.linearMarginal (fun i x => x i) u)
        (uniformConvexBodyMeasure K) = ∑ i, (u i) ^ 2 := by
  letI : IsProbabilityMeasure (uniformConvexBodyMeasure K) :=
    uniformConvexBodyMeasure_isProbabilityMeasure hK.1
  have hVariance :=
    (NumStability.HDP.Vector.Isotropy.isIsotropic_iff_marginalVariance
      (fun (i : Fin n) (x : Fin n → ℝ) => x i)
      (fun i => coordinate_memLp_of_isConvexBody hK.1 i 2) hK.2.1).1 hK.2.2 u
  simpa [NumStability.HDP.Vector.linearMarginal] using hVariance

/-- In a unit direction, an isotropic convex-body marginal has variance one. -/
theorem linearMarginal_variance_eq_one_of_isIsotropicConvexBody {n : ℕ}
    {K : Set (Fin n → ℝ)} (hK : IsIsotropicConvexBody K)
    (u : Fin n → ℝ) (hu : ∑ i, (u i) ^ 2 = 1) :
    variance
        (NumStability.HDP.Vector.linearMarginal (fun i x => x i) u)
        (uniformConvexBodyMeasure K) = 1 := by
  rw [linearMarginal_variance_eq_normSq_of_isIsotropicConvexBody hK u, hu]

/-- Every linear marginal of normalized volume on a convex body has finite
exact `ψ₁` gauge.  The bound obtained from bounded support may depend on the
body and direction; the dimension-free Borell estimate is strictly stronger. -/
theorem linearMarginal_psiOneGauge_lt_top_of_isConvexBody {n : ℕ}
    {K : Set (Fin n → ℝ)} (hK : IsConvexBody K) (u : Fin n → ℝ) :
    NumStability.HDP.Scalar.SubExponential.PsiOneGauge
        (uniformConvexBodyMeasure K)
        (NumStability.HDP.Vector.linearMarginal
          (fun (i : Fin n) (x : Fin n → ℝ) => x i) u) < ∞ := by
  letI : IsProbabilityMeasure (uniformConvexBodyMeasure K) :=
    uniformConvexBodyMeasure_isProbabilityMeasure hK
  rcases hK.2.1.exists_norm_le with ⟨C, hC⟩
  let B : ℝ := ∑ i : Fin n, |C| * |u i| + 1
  have hB : 0 < B := by
    dsimp [B]
    positivity
  have hMeas : Measurable
      (NumStability.HDP.Vector.linearMarginal
        (fun (i : Fin n) (x : Fin n → ℝ) => x i) u) := by
    unfold NumStability.HDP.Vector.linearMarginal
    fun_prop
  apply NumStability.HDP.Scalar.SubExponential.psiOneGauge_lt_top_of_ae_abs_le_const
    hMeas hB
  unfold uniformConvexBodyMeasure
  filter_upwards [ProbabilityTheory.ae_cond_mem₀
    (hK.1.nullMeasurableSet volume)] with x hx
  have hterm (i : Fin n) : |x i * u i| ≤ |C| * |u i| := by
    rw [abs_mul]
    apply mul_le_mul_of_nonneg_right _ (abs_nonneg (u i))
    simpa [Real.norm_eq_abs] using
      (norm_le_pi_norm x i).trans ((hC x hx).trans (le_abs_self C))
  calc
    |NumStability.HDP.Vector.linearMarginal
        (fun (i : Fin n) (x : Fin n → ℝ) => x i) u x| =
        |∑ i : Fin n, x i * u i| := rfl
    _ ≤ ∑ i : Fin n, |x i * u i| := Finset.abs_sum_le_sum_abs _ _
    _ ≤ ∑ i : Fin n, |C| * |u i| := Finset.sum_le_sum (fun i _ => hterm i)
    _ ≤ B := by dsimp [B]; linarith

end NumStability.HDP.Convex
