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
import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerOriginalFluxTransfer
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
# RichtmyerOriginalFluxDerivativeBudget

Source correspondence for LeVeque section4.7, printed72/PDF94. Smooth formal local accuracy is separate from accumulated global accuracy and behavior at discontinuities.
-/

namespace NumStability
open Set Metric Filter MeasureTheory
open scoped Topology

theorem leveque04_richtmyer_uniform_original_localFlux_faceDerivative_chainBudget
    {m : ℕ} (q : ℝ → ℝ → Fin m → ℝ)
    (flux : (Fin m → ℝ) → Fin m → ℝ) (domain : Set (Fin m → ℝ))
    (L R finish anchor : ℝ) (hfinish : 0 < finish) (hanchor : anchor ∈ Ioo L R)
    (hq : ContDiffOn ℝ 3 (Function.uncurry q) (Ioo L R ×ˢ Icc 0 finish))
    (hopen : IsOpen domain) (hstate : q anchor 0 ∈ domain)
    (hflux : ContDiffOn ℝ 3 flux domain)
    (hpde : ∀ x ∈ Ioo L R,
      derivWithin (q x) (Icc 0 finish) 0 + deriv (fun z => flux (q z 0)) x = 0) :
    ∃ δ C : ℝ, 0 < δ ∧ δ ≤ finish ∧ δ ≤ 1 ∧ 0 ≤ C ∧
      ∀ face dt width : ℝ, |face-anchor| ≤ δ → 0 < dt → dt ≤ δ →
        0 < width → width ≤ δ →
      let profile := fun x => q x 0
      let leftAverage := oneDimensionalCellAverage profile (face-width) face
      let rightAverage := oneDimensionalCellAverage profile face (face+width)
      let leftSlope := width⁻¹ • (profile face-profile (face-width))
      let rightSlope := width⁻¹ • (profile (face+width)-profile face)
      let predicted := (1/2 : ℝ) • (leftAverage+rightAverage) -
        (dt/2) • (width⁻¹ • (flux rightAverage-flux leftAverage))
      let predictedSlope := (1/2 : ℝ) • (leftSlope+rightSlope) -
        (dt/2) • (width⁻¹ •
          (fderiv ℝ flux rightAverage rightSlope-fderiv ℝ flux leftAverage leftSlope))
      ‖fderiv ℝ flux predicted predictedSlope -
        oneDimensionalCellAverage (fun τ => deriv (fun z => flux (q z τ)) face) 0 dt‖ ≤
        C*(width^2+dt^2) := by
  obtain ⟨radius,rs,T,hradius,hrs,hT,hmax,hspace,extension,hext,hcompact,
      hagree,hjac,hstates,hqsmall,hphysical,hPDE⟩ :=
    leveque04_richtmyer_local_flux_physical_halfRectangle_transfer
      q flux domain L R finish anchor hfinish hanchor hq hopen hstate hflux hpde
  have hanchorSmall : anchor ∈ Ioo (anchor-rs) (anchor+rs) := by
    constructor <;> linarith
  have hhalfSpace : Icc (anchor-rs/2) (anchor+rs/2) ⊆ Ioo (anchor-rs) (anchor+rs) := by
    intro x hx
    constructor <;> linarith [hx.1,hx.2]
  have hhalfStates : ∀ x ∈ Icc (anchor-rs/2) (anchor+rs/2),
      ∀ τ ∈ Icc 0 T, q x τ ∈ ball (q anchor 0) (radius/2) := by
    intro x hx τ hτ
    apply hstates x _ τ hτ
    constructor <;> linarith [hx.1,hx.2]
  obtain ⟨δ,C,hδ,hδT,hδOne,hC,hbudget⟩ :=
    leveque04_richtmyer_uniform_auxiliary_to_original_faceDerivative_budget
      q extension flux (anchor-rs) (anchor+rs) T anchor (rs/2) radius
      hT hanchorSmall (half_pos hrs) hradius hhalfSpace hqsmall hext hcompact
      hPDE hhalfStates hagree hjac hphysical
  exact ⟨δ,C,hδ,hδT.trans hmax,hδOne,hC,hbudget⟩

end NumStability
