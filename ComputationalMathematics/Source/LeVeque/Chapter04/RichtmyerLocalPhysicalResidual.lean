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
import ComputationalMathematics.Source.LeVeque.Chapter04.MidpointAverage
import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerLocalPhysicalFaceError
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
# RichtmyerLocalPhysicalResidual

Source correspondence for LeVeque section4.7, printed72/PDF94. Smooth formal local accuracy is separate from accumulated global accuracy and behavior at discontinuities.
-/

namespace NumStability
open Set Metric Filter MeasureTheory
open scoped Topology

theorem leveque04_richtmyer_uniform_original_localFlux_actualRichtmyer_residual
    {m : ℕ} (q : ℝ → ℝ → Fin m → ℝ)
    (flux : (Fin m → ℝ) → Fin m → ℝ) (domain : Set (Fin m → ℝ))
    (L R finish anchor : ℝ) (hfinish : 0 < finish) (hanchor : anchor ∈ Ioo L R)
    (hq : ContDiffOn ℝ 3 (Function.uncurry q) (Ioo L R ×ˢ Icc 0 finish))
    (hopen : IsOpen domain) (hstate : q anchor 0 ∈ domain)
    (hflux : ContDiffOn ℝ 3 flux domain)
    (hpde : ∀ x ∈ Ioo L R,
      derivWithin (q x) (Icc 0 finish) 0 + deriv (fun z => flux (q z 0)) x = 0)
    (hreference : LocalConservationLaw.RectangleReferenceOn q flux L R finish) :
    ∃ δ C : ℝ, 0 < δ ∧ δ ≤ finish ∧ δ ≤ 1 ∧ 0 ≤ C ∧
      ∀ face dt width : ℝ, |face-anchor| ≤ δ → 0 < dt → dt ≤ δ →
        0 < width → width ≤ δ →
      let numerical := fun x => leveque04_richtmyerFlux dt width flux
        (oneDimensionalCellAverage (fun z => q z 0) (x-width) x)
        (oneDimensionalCellAverage (fun z => q z 0) x (x+width))
      let old := oneDimensionalCellAverage (fun z => q z 0) face (face+width)
      let exactNext := oneDimensionalCellAverage (fun z => q z dt) face (face+width)
      ‖dt⁻¹ • (finiteVolumeCellAverageUpdate dt width old
        (numerical (face+width)-numerical face)-exactNext)‖ ≤ C*(width^2+dt^2) := by
  obtain ⟨threshold,C,hthreshold,htFinish,htOne,hC,hdivergence⟩ :=
    leveque04_richtmyer_uniform_original_localFlux_actualFaceError_divergence
      q flux domain L R finish anchor hfinish hanchor hq hopen hstate hflux hpde
  let δ := min threshold (min ((anchor-L)/4) ((R-anchor)/4))
  have hδ : 0 < δ := lt_min hthreshold (lt_min (by linarith [hanchor.1]) (by linarith [hanchor.2]))
  have hδt : δ ≤ threshold := min_le_left _ _
  have hδl : δ ≤ (anchor-L)/4 := (min_le_right _ _).trans (min_le_left _ _)
  have hδr : δ ≤ (R-anchor)/4 := (min_le_right _ _).trans (min_le_right _ _)
  refine ⟨δ,C,hδ,hδt.trans htFinish,hδt.trans htOne,hC,?_⟩
  intro face dt width hface hdt hdtSmall hw hwSmall numerical old exactNext
  let physical := fun x => oneDimensionalCellAverage (fun τ => flux (q x τ)) 0 dt
  have hfaceBox : face ∈ Icc L R := by
    have hf := abs_le.mp hface
    constructor <;> linarith [hf.1,hf.2,hanchor.1,hanchor.2]
  have hrightBox : face+width ∈ Icc L R := by
    have hf := abs_le.mp hface
    constructor <;> linarith [hf.1,hf.2,hanchor.1,hanchor.2]
  have hbalance := rectangleReferenceOn_cellAverage_mass_balance
    q flux L R finish face (face+width) 0 dt hreference hfaceBox hrightBox
    ⟨le_rfl,hfinish.le⟩ ⟨hdt.le,hdtSmall.trans (hδt.trans htFinish)⟩
    (by linarith) hdt
  rw [add_sub_cancel_left,sub_zero] at hbalance
  have hscaled := congrArg (fun v => width⁻¹ • v) hbalance
  simp only [smul_smul,inv_mul_cancel₀ hw.ne',one_smul] at hscaled
  have hcoef : width⁻¹*dt = dt/width := by ring
  rw [hcoef] at hscaled
  have hexact : exactNext = old-(dt/width) • (physical (face+width)-physical face) := by
    calc
      _ = (dt/width) • (physical face-physical (face+width))+old :=
        sub_eq_iff_eq_add.mp hscaled
      _ = _ := by module
  have herr : finiteVolumeCellAverageUpdate dt width old
      (numerical (face+width)-numerical face)-exactNext =
      -((dt/width) • ((numerical (face+width)-physical (face+width))-
        (numerical face-physical face))) := by
    rw [hexact]
    unfold finiteVolumeCellAverageUpdate
    module
  have hcancel : dt⁻¹*(dt/width) = width⁻¹ := by field_simp
  rw [herr,smul_neg,smul_smul,hcancel,norm_neg]
  exact hdivergence face dt width (hface.trans hδt) hdt (hdtSmall.trans hδt)
    hw (hwSmall.trans hδt)

end NumStability
