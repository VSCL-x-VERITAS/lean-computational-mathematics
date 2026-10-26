/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.Calculus.LocalDerivativeVariation
import ComputationalMathematics.Analysis.Calculus.LocalFirstOrderTaylor
import ComputationalMathematics.Analysis.Calculus.LocalSecondOrderTaylor
import ComputationalMathematics.Analysis.Calculus.LocalSymmetricTaylor
import ComputationalMathematics.Analysis.Calculus.LocalVectorSecant
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.C2RectangleReference
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.ClosedTimePartialRegularity
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageEstimates
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLinearEquiv
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLipschitzTrace
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalEndpointMeanQuadrature
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalRectangleCellAverage
import ComputationalMathematics.Source.LeVeque.Chapter04.MidpointAverage
import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerVectorCenteredSecant
import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerVectorFaceDerivativeBudget
import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerVectorPhysicalFluxAverageDerivative
import Mathlib.Analysis.Calculus.BumpFunction.FiniteDimension
import Mathlib.Analysis.Calculus.ContDiff.Bounds
import Mathlib.Analysis.Calculus.ContDiff.Operations
import Mathlib.Analysis.Calculus.FDeriv.Symmetric
import Mathlib.Analysis.Calculus.MeanValue
import Mathlib.Tactic

/-!
# RichtmyerLocalFluxGradient

Source correspondence for LeVeque section4.7, printed72/PDF94. Smooth formal local accuracy is separate from accumulated global accuracy and behavior at discontinuities.
-/

namespace NumStability
open Set Metric Filter MeasureTheory
open scoped Topology

theorem leveque04_richtmyer_local_vector_fluxGradient_error
    {m : ℕ} (profile physicalSlope physicalSecond : ℝ → Fin m → ℝ)
    (jacobian : (Fin m → ℝ) → (Fin m → ℝ) →L[ℝ] (Fin m → ℝ))
    (leftAverage rightAverage leftSlope rightSlope : Fin m → ℝ)
    (face width L A B M N G : ℝ)
    (hwidth : 0 < width) (hL : 0 ≤ L) (hA : 0 ≤ A) (hN : 0 ≤ N) (hG : 0 ≤ G)
    (hleftState : ‖leftAverage - profile (face - width / 2)‖ ≤ A * width ^ 2)
    (hrightState : ‖rightAverage - profile (face + width / 2)‖ ≤ A * width ^ 2)
    (hleftSlope : ‖leftSlope - deriv profile (face - width / 2)‖ ≤ B * width ^ 2)
    (hrightSlope : ‖rightSlope - deriv profile (face + width / 2)‖ ≤ B * width ^ 2)
    (hleftBound : ‖leftSlope‖ ≤ M) (hrightBound : ‖rightSlope‖ ≤ M)
    (hleftJ : ‖jacobian (profile (face - width / 2))‖ ≤ N)
    (hrightJ : ‖jacobian (profile (face + width / 2))‖ ≤ N)
    (hleftLip : ‖jacobian leftAverage - jacobian (profile (face - width / 2))‖ ≤
      L * ‖leftAverage - profile (face - width / 2)‖)
    (hrightLip : ‖jacobian rightAverage - jacobian (profile (face + width / 2))‖ ≤
      L * ‖rightAverage - profile (face + width / 2)‖)
    (hphysicalLeft : physicalSlope (face - width / 2) =
      jacobian (profile (face - width / 2)) (deriv profile (face - width / 2)))
    (hphysicalRight : physicalSlope (face + width / 2) =
      jacobian (profile (face + width / 2)) (deriv profile (face + width / 2)))
    (hderiv : ∀ x ∈ Set.Icc (face - width / 2) (face + width / 2),
      HasDerivAt physicalSlope (physicalSecond x) x)
    (hvariation : ∀ x ∈ Set.Icc (face - width / 2) (face + width / 2),
      ‖physicalSecond x - physicalSecond face‖ ≤ G * |x - face|) :
    ‖width⁻¹ • (jacobian rightAverage rightSlope - jacobian leftAverage leftSlope) -
      physicalSecond face‖ ≤ (2 * (L * A * M + N * B) + G / 2) * width := by
  have hl := leveque04_richtmyer_vectorFaceDerivative_errorBudget jacobian
    leftAverage leftSlope (profile (face - width / 2)) (deriv profile (face - width / 2))
    (physicalSlope (face - width / 2)) width L A B M N 0 hL hA hN
    hleftState hleftSlope hleftBound hleftJ hleftLip (by rw [hphysicalLeft]; simp)
  have hr := leveque04_richtmyer_vectorFaceDerivative_errorBudget jacobian
    rightAverage rightSlope (profile (face + width / 2)) (deriv profile (face + width / 2))
    (physicalSlope (face + width / 2)) width L A B M N 0 hL hA hN
    hrightState hrightSlope hrightBound hrightJ hrightLip (by rw [hphysicalRight]; simp)
  have hs := local_vector_firstOrder_secant physicalSlope physicalSecond G
    face width hG hwidth hderiv hvariation
  exact leveque04_richtmyer_vectorCenteredSecant_endpointError physicalSlope physicalSecond
    (jacobian leftAverage leftSlope) (jacobian rightAverage rightSlope)
    face width G (L * A * M + N * B) hwidth
    (by simpa only [add_zero] using hl) (by simpa only [add_zero] using hr) hs

end NumStability
