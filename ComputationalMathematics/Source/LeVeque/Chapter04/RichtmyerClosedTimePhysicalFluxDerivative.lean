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
# RichtmyerClosedTimePhysicalFluxDerivative

Source correspondence for LeVeque section4.7, printed72/PDF94. Smooth formal local accuracy is separate from accumulated global accuracy and behavior at discontinuities.
-/

namespace NumStability
open Set Metric Filter MeasureTheory
open scoped Topology

theorem leveque04_richtmyer_closedTime_physicalFluxTimeAverage_hasDerivAt
    {m : ℕ} (q : ℝ → ℝ → Fin m → ℝ) (flux : (Fin m → ℝ) → Fin m → ℝ)
    (L R finish face : ℝ) (hfinish : 0 < finish) (hface : face ∈ Ioo L R)
    (hq : ContDiffOn ℝ 3 (Function.uncurry q) (Ioo L R ×ˢ Icc 0 finish))
    (hflux : ContDiff ℝ 3 flux) :
    ∀ dt : ℝ, 0 < dt → dt ≤ finish → HasDerivAt
      (fun x => oneDimensionalCellAverage (fun τ => flux (q x τ)) 0 dt)
      (oneDimensionalCellAverage (fun τ => deriv (fun x => flux (q x τ)) face) 0 dt) face := by
  let rs := min ((face-L)/2) ((R-face)/2)
  have hrs : 0 < rs := lt_min (by linarith [hface.1]) (by linarith [hface.2])
  have hspace : Icc (face-rs) (face+rs) ⊆ Ioo L R := by
    intro x hx
    have hl : rs ≤ (face-L)/2 := min_le_left _ _
    have hr : rs ≤ (R-face)/2 := min_le_right _ _
    constructor <;> linarith [hx.1,hx.2,hface.1,hface.2]
  let physical : ℝ → ℝ → Fin m → ℝ := fun x τ => flux (q x τ)
  have hphysical : ContDiffOn ℝ 3 (Function.uncurry physical) (Ioo L R ×ˢ Icc 0 finish) :=
    hflux.comp_contDiffOn hq
  have hSlope := contDiffOn_closedTimeStrip_spatial_derivative 2 physical L R 0 finish hfinish hphysical
  intro dt hdt hdmax
  apply leveque04_richtmyer_vectorPhysicalFluxTimeAverage_hasDerivAt
    q flux (fun x τ => deriv (fun z => flux (q z τ)) x) (face-rs) (face+rs) face dt hdt
  · constructor <;> linarith
  · exact hphysical.continuousOn.mono (prod_mono hspace (Icc_subset_Icc le_rfl hdmax))
  · exact hSlope.continuousOn.mono (prod_mono hspace (Icc_subset_Icc le_rfl hdmax))
  · intro x hx τ hτ
    have hxo := hspace ⟨hx.1.le,hx.2.le⟩
    have hslice : ContDiffOn ℝ 3 (fun z => physical z τ) (Ioo L R) :=
      hphysical.comp (contDiffOn_id.prodMk contDiffOn_const)
        (fun z hz => ⟨hz,hτ.1,hτ.2.trans hdmax⟩)
    exact ((hslice x hxo).contDiffAt (isOpen_Ioo.mem_nhds hxo)).differentiableAt
      (by decide) |>.hasDerivAt

end NumStability
