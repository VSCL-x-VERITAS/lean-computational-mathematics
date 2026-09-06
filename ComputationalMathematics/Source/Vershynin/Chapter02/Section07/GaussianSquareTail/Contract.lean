import ComputationalMathematics.Source.Vershynin.Chapter02.Section07.GaussianSquareTail.Signature
import ComputationalMathematics.HDP.Scalar.GaussianSquareTail

/-! Stable Chapter 2 source contract for the Gaussian-square tail display. -/

noncomputable section

open MeasureTheory ProbabilityTheory Set
open scoped ENNReal NNReal

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.LimitTheorems
open NumStability.HDP.Scalar.GaussianSquareTail

/-! Section 2.7: `g²` has exponential-scale rather than Gaussian-scale tails.
The exact Mills prefactor makes the source's suppressed comparison precise. -/
theorem hdp_02_hbody_h2_d7_hgaussian_hsquare_htail
    (t : ℝ) (ht : 0 < t) :
    standardNormalLaw.real {x : ℝ | x ^ 2 > t} =
        standardNormalLaw.real {x : ℝ | |x| > Real.sqrt t} ∧
      2 * (Real.sqrt (2 * Real.pi))⁻¹ *
            ((1 / Real.sqrt t - 1 / (Real.sqrt t) ^ 3) *
              Real.exp (-t / 2)) ≤
          standardNormalLaw.real {x : ℝ | x ^ 2 > t} ∧
        standardNormalLaw.real {x : ℝ | x ^ 2 > t} ≤
          2 * (Real.sqrt (2 * Real.pi))⁻¹ *
            ((1 / Real.sqrt t) * Real.exp (-t / 2)) := by
  constructor
  · apply congrArg standardNormalLaw.real
    ext x
    simp only [mem_setOf_eq]
    exact sq_gt_iff_abs_gt_sqrt x t ht.le
  · exact standardNormal_squareTail_bounds t ht

theorem hdp_02_hbody_h2_d7_hgaussian_hsquare_htail__contract :
    hdp_02_hbody_h2_d7_hgaussian_hsquare_htail__contract_type := by
  intro t ht
  exact hdp_02_hbody_h2_d7_hgaussian_hsquare_htail t ht

end NumStability.HDP.Contract
