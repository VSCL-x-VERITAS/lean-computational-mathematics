/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.Calculus.LocalDerivativeVariation
import ComputationalMathematics.Analysis.Calculus.LocalFirstOrderTaylor
import ComputationalMathematics.Analysis.Calculus.LocalSecondOrderTaylor
import ComputationalMathematics.Analysis.Calculus.LocalSymmetricTaylor
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.C2RectangleReference
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.ClosedTimeInitialConservationPDE
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.ClosedTimePartialRegularity
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageEstimates
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLinearEquiv
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLipschitzTrace
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalEndpointMeanQuadrature
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalRectangleCellAverage
import ComputationalMathematics.Source.LeVeque.Chapter04.MidpointAverage
import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerLocalPhysicalResidual
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
# RichtmyerSmoothLocalAccuracy

Source correspondence for LeVeque section4.7, printed72/PDF94. Smooth formal local accuracy is separate from accumulated global accuracy and behavior at discontinuities.
-/

namespace NumStability
open Set Metric Filter MeasureTheory
open scoped Topology

theorem leveque04_richtmyer_uniform_physical_localFlux_actualRichtmyer_residual
    {m : ℕ} (q : ℝ → ℝ → Fin m → ℝ)
    (flux : (Fin m → ℝ) → Fin m → ℝ) (domain : Set (Fin m → ℝ))
    (L R finish anchor : ℝ) (hfinish : 0 < finish) (hanchor : anchor ∈ Ioo L R)
    (hq : ContDiffOn ℝ 3 (Function.uncurry q) (Icc L R ×ˢ Icc 0 finish))
    (hopen : IsOpen domain) (hflux : ContDiffOn ℝ 3 flux domain)
    (hrange : ∀ x ∈ Icc L R, ∀ τ ∈ Icc 0 finish, q x τ ∈ domain)
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
  have hphysical : ContDiffOn ℝ 3 (Function.uncurry (fun x τ => flux (q x τ)))
      (Icc L R ×ˢ Icc 0 finish) :=
    hflux.comp hq (fun p hp => hrange p.1 hp.1 p.2 hp.2)
  have hpde := rectangleReference_closedTime_initial_pde q flux L R finish
    hfinish hreference (hq.of_le (by norm_num)) (hphysical.of_le (by norm_num))
  exact leveque04_richtmyer_uniform_original_localFlux_actualRichtmyer_residual
    q flux domain L R finish anchor hfinish hanchor
    (hq.mono (prod_mono Ioo_subset_Icc_self (Subset.refl _))) hopen
    (hrange anchor ⟨hanchor.1.le,hanchor.2.le⟩ 0 ⟨le_rfl,hfinish.le⟩)
    hflux hpde hreference

/-- Bounded-ratio positive meshes specialize the existing actual local
physical residual producer with fixed constants before every mesh. -/
theorem leveque04_richtmyer_uniform_physical_localFlux_Richtmyer_boundedRatio_residual
    {m : ℕ} (q : ℝ → ℝ → Fin m → ℝ)
    (flux : (Fin m → ℝ) → Fin m → ℝ) (domain : Set (Fin m → ℝ))
    (L R horizon anchor ratioBound : ℝ) (hhorizon : 0<horizon)
    (hanchor : anchor ∈ Set.Ioo L R) (hR : 0<ratioBound)
    (hq : ContDiffOn ℝ 3 (Function.uncurry q) (Set.Icc L R ×ˢ Set.Icc 0 horizon))
    (hopen : IsOpen domain) (hflux : ContDiffOn ℝ 3 flux domain)
    (hrange : ∀ x ∈ Set.Icc L R, ∀ τ ∈ Set.Icc 0 horizon, q x τ ∈ domain)
    (hreference : LocalConservationLaw.RectangleReferenceOn q flux L R horizon) :
    ∃ h0 C : ℝ, 0<h0 ∧ h0≤horizon ∧ h0≤1 ∧ 0≤C ∧
      ∀ face dt width : ℝ, |face-anchor|≤h0 → 0<width → width≤h0 →
        0<dt → dt≤ratioBound*width →
      let numerical := fun x => leveque04_richtmyerFlux dt width flux
        (oneDimensionalCellAverage (fun z => q z 0) (x-width) x)
        (oneDimensionalCellAverage (fun z => q z 0) x (x+width))
      let old := oneDimensionalCellAverage (fun z => q z 0) face (face+width)
      let exactNext := oneDimensionalCellAverage (fun z => q z dt) face (face+width)
      ‖dt⁻¹ • (finiteVolumeCellAverageUpdate dt width old
        (numerical (face+width)-numerical face)-exactNext)‖≤C*width^2 := by
  obtain ⟨δ,C,hδ,hδT,hδ1,hC,hestimate⟩ :=
    leveque04_richtmyer_uniform_physical_localFlux_actualRichtmyer_residual
      q flux domain L R horizon anchor hhorizon hanchor hq hopen hflux hrange hreference
  let h0 := min δ (δ/ratioBound)
  have h0pos : 0<h0 := lt_min hδ (div_pos hδ hR)
  have h0δ : h0≤δ := min_le_left _ _
  refine ⟨h0,C*(1+ratioBound^2),h0pos,h0δ.trans hδT,h0δ.trans hδ1,by positivity,?_⟩
  intro face dt width hface hwidth hsmall hdt hmesh
  have htime : dt≤δ := by
    have hwcap : width≤δ/ratioBound := hsmall.trans (min_le_right _ _)
    have hcap := (le_div_iff₀ hR).mp hwcap
    nlinarith
  have hbase := hestimate face dt width (hface.trans h0δ) hdt htime hwidth (hsmall.trans h0δ)
  have hsquare : dt^2≤ratioBound^2*width^2 := by
    have hsq := mul_self_le_mul_self hdt.le hmesh
    nlinarith
  exact hbase.trans (by nlinarith [mul_le_mul_of_nonneg_left hsquare hC])

/-- Formal smooth local second-order accuracy: fixed physical data, positive bounded-ratio meshes, and constants chosen before every mesh. Global accumulated error is separate. -/
def RichtmyerFormalLocalAccuracy : Prop :=
  ∀ {m : ℕ} (q : ℝ → ℝ → Fin m → ℝ) (flux : (Fin m → ℝ) → Fin m → ℝ) (domain : Set (Fin m → ℝ))
  (L R horizon anchor ratioBound : ℝ),
  0 < horizon →
    anchor ∈ Ioo L R →
      0 < ratioBound →
        ContDiffOn ℝ 3 (Function.uncurry q) (Icc L R ×ˢ Icc 0 horizon) →
          IsOpen domain →
            ContDiffOn ℝ 3 flux domain →
              (∀ x ∈ Icc L R, ∀ τ ∈ Icc 0 horizon, q x τ ∈ domain) →
                NumStability.LocalConservationLaw.RectangleReferenceOn q flux L R horizon →
                  ∃ h0 C,
                    0 < h0 ∧
                      h0 ≤ horizon ∧
                        h0 ≤ 1 ∧
                          0 ≤ C ∧
                            ∀ (face dt width : ℝ),
                              |face - anchor| ≤ h0 →
                                0 < width →
                                  width ≤ h0 →
                                    0 < dt →
                                      dt ≤ ratioBound * width →
                                        have numerical := fun x =>
                                          NumStability.leveque04_richtmyerFlux dt width flux
                                            (NumStability.oneDimensionalCellAverage (fun z => q z 0) (x - width) x)
                                            (NumStability.oneDimensionalCellAverage (fun z => q z 0) x (x + width));
                                        have old :=
                                          NumStability.oneDimensionalCellAverage (fun z => q z 0) face (face + width);
                                        have exactNext :=
                                          NumStability.oneDimensionalCellAverage (fun z => q z dt) face (face + width);
                                        ‖dt⁻¹ •
                                              (NumStability.finiteVolumeCellAverageUpdate dt width old
                                                  (numerical (face + width) - numerical face) -
                                                exactNext)‖ ≤
                                          C * width ^ 2

/-- LeVeque section4.7: smooth second-order formal local accuracy.
The actual physical residual has mesh-independent constants. -/
theorem leveque04_richtmyer_formalLocalAccuracy :
    RichtmyerFormalLocalAccuracy := by
  exact leveque04_richtmyer_uniform_physical_localFlux_Richtmyer_boundedRatio_residual

end NumStability
