/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerVectorPDEHalfTimeTaylor
import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerAdjacentAverage
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLinearEquiv

/-!
# Centered exact vector cell averages at a Richtmyer face

The two neighboring vector cell averages have a quadratic centered
state error when each component has uniformly bounded curvature.
-/

namespace NumStability

open MeasureTheory Set

theorem leveque04_richtmyer_vectorAdjacentExactAverages_midpointError
    {m : ℕ} (profile : ℝ → Fin m → ℝ)
    (face width bound : ℝ)
    (hwidth : 0 < width) (hbound : 0 ≤ bound)
    (hcontinuous : Continuous profile)
    (hsmooth : ∀ p, ContDiffOn ℝ 2 (fun x => profile x p)
      (Icc (face - width) (face + width)))
    (hsecond : ∀ p x,
      |iteratedDerivWithin 2 (fun y => profile y p)
        (Icc (face - width) (face + width)) x| ≤ bound) :
    ‖(1 / 2 : ℝ) •
        (oneDimensionalCellAverage profile (face - width) face +
          oneDimensionalCellAverage profile face (face + width)) -
        profile face‖ ≤ (bound / 2) * width ^ 2 := by
  have hnonneg : 0 ≤ (bound / 2) * width ^ 2 := by positivity
  apply (pi_norm_le_iff_of_nonneg hnonneg).2
  intro p
  have hleft := oneDimensionalCellAverage_apply profile (face - width) face
    (hcontinuous.intervalIntegrable (μ := volume) _ _) p
  have hright := oneDimensionalCellAverage_apply profile face (face + width)
    (hcontinuous.intervalIntegrable (μ := volume) _ _) p
  have hscalar := leveque04_richtmyer_adjacentExactAverages_midpointError
    (fun x => profile x p) face width bound hwidth
    (((continuous_apply p).comp hcontinuous).intervalIntegrable
      (μ := volume) _ _)
    (((continuous_apply p).comp hcontinuous).intervalIntegrable
      (μ := volume) _ _)
    (hsmooth p) (hsecond p)
  simp only [Pi.sub_apply, Pi.smul_apply, Pi.add_apply,
    smul_eq_mul, Real.norm_eq_abs, hleft, hright]
  convert hscalar using 1 <;> ring_nf

end NumStability
