/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.Calculus.LocalDerivativeVariation
import ComputationalMathematics.Analysis.Calculus.LocalFirstOrderTaylor
import ComputationalMathematics.Analysis.Calculus.LocalSecondOrderTaylor
import ComputationalMathematics.Analysis.Calculus.LocalSymmetricTaylor
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.C2RectangleReference
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.ClosedTimePartialRegularity
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageEstimates
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLinearEquiv
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLipschitzTrace
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalEndpointMeanQuadrature
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalRectangleCellAverage
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.MovingCellAverageDerivative
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
# RichtmyerExactAverageFaceDerivative

Source correspondence for LeVeque section4.7, printed72/PDF94. Smooth formal local accuracy is separate from accumulated global accuracy and behavior at discontinuities.
-/

namespace NumStability
open Set Metric Filter MeasureTheory
open scoped Topology

theorem leveque04_richtmyer_local_exactAverageFace_hasDerivAt
    {m : ℕ} (profile : ℝ → Fin m → ℝ) (flux : (Fin m → ℝ) → Fin m → ℝ)
    (L R face dt h : ℝ) (hh : 0 < h) (hc : ContinuousOn profile (Ioo L R))
    (hface : face ∈ Ioo L R) (hl : face-h ∈ Ioo L R) (hr : face+h ∈ Ioo L R)
    (hfluxLeft : HasFDerivAt flux (fderiv ℝ flux
      (oneDimensionalCellAverage profile (face-h) face))
      (oneDimensionalCellAverage profile (face-h) face))
    (hfluxRight : HasFDerivAt flux (fderiv ℝ flux
      (oneDimensionalCellAverage profile face (face+h)))
      (oneDimensionalCellAverage profile face (face+h)))
    (hfluxPred : HasFDerivAt flux (fderiv ℝ flux
      (leveque04_richtmyerPredictor dt h flux
        (oneDimensionalCellAverage profile (face-h) face)
        (oneDimensionalCellAverage profile face (face+h))))
      (leveque04_richtmyerPredictor dt h flux
        (oneDimensionalCellAverage profile (face-h) face)
        (oneDimensionalCellAverage profile face (face+h)))) :
    let left := fun x => oneDimensionalCellAverage profile (x-h) x
    let right := fun x => oneDimensionalCellAverage profile x (x+h)
    let leftSlope := h⁻¹ • (profile face-profile (face-h))
    let rightSlope := h⁻¹ • (profile (face+h)-profile face)
    HasDerivAt (fun x => leveque04_richtmyerFlux dt h flux (left x) (right x))
      (fderiv ℝ flux (leveque04_richtmyerPredictor dt h flux (left face) (right face))
        ((1/2 : ℝ) • (leftSlope+rightSlope) -
          (dt/(2*h)) • (fderiv ℝ flux (right face) rightSlope -
            fderiv ℝ flux (left face) leftSlope))) face := by
  intro left right leftSlope rightSlope
  have hleft : HasDerivAt left leftSlope face := by
    simpa only [← sub_eq_add_neg,add_zero,sub_neg_eq_add,zero_add] using
      moving_intervalAverage_hasDerivAt_of_local_continuity profile L R (-h) 0 face
        (by linarith) hc (by simpa only [← sub_eq_add_neg] using hl) (by simpa only [add_zero] using hface)
  have hright : HasDerivAt right rightSlope face := by
    simpa only [add_zero,sub_zero] using
      moving_intervalAverage_hasDerivAt_of_local_continuity profile L R 0 h face
        hh hc (by simpa only [add_zero] using hface) hr
  have hp := leveque04_richtmyerVectorPredictor_hasDerivAt
    flux (fderiv ℝ flux) left right (fun _ => leftSlope) (fun _ => rightSlope)
    dt h face hleft hright hfluxLeft hfluxRight
  simpa only [leveque04_richtmyerFlux] using hfluxPred.comp_hasDerivAt face hp

end NumStability
