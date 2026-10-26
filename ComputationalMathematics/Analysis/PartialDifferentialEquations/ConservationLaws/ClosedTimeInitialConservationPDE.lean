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
import Mathlib.Analysis.Calculus.BumpFunction.FiniteDimension
import Mathlib.Analysis.Calculus.ContDiff.Bounds
import Mathlib.Analysis.Calculus.ContDiff.Operations
import Mathlib.Analysis.Calculus.FDeriv.Symmetric
import Mathlib.Analysis.Calculus.MeanValue
import Mathlib.Tactic

/-!
# ClosedTimeInitialConservationPDE

Source-independent local calculus and actual physical cell-average mathematics. Closed forward-time endpoints and explicit quantitative domains are preserved.
-/

namespace NumStability
open Set Metric Filter MeasureTheory
open scoped Topology

theorem rectangleReference_closedTime_initial_pde
    {m : ℕ} (q : ℝ → ℝ → Fin m → ℝ)
    (flux : (Fin m → ℝ) → Fin m → ℝ) (L R finish : ℝ)
    (hfinish : 0 < finish)
    (hreference : LocalConservationLaw.RectangleReferenceOn q flux L R finish)
    (hq : ContDiffOn ℝ 2 (Function.uncurry q) (Icc L R ×ˢ Icc 0 finish))
    (hphysical : ContDiffOn ℝ 2 (Function.uncurry (fun x τ => flux (q x τ)))
      (Icc L R ×ˢ Icc 0 finish)) :
    ∀ x ∈ Ioo L R,
      derivWithin (q x) (Icc 0 finish) 0 + deriv (fun z => flux (q z 0)) x = 0 := by
  let physical := fun x τ => flux (q x τ)
  have hqs := hq.mono (prod_mono Ioo_subset_Icc_self (Subset.refl _))
  have hps := hphysical.mono (prod_mono Ioo_subset_Icc_self (Subset.refl _))
  have htime := contDiffOn_closedTimeStrip_temporal_derivativeWithin 1 q L R 0 finish hfinish hqs
  have hspace := contDiffOn_closedTimeStrip_spatial_derivative 1 physical L R 0 finish hfinish hps
  intro x hx
  let defect := fun τ => derivWithin (q x) (Icc 0 finish) τ +
    deriv (fun z => flux (q z τ)) x
  have hc : ContinuousOn defect (Icc 0 finish) :=
    (htime.continuousOn.comp (continuousOn_const.prodMk continuousOn_id)
      (fun τ hτ => ⟨hx,hτ⟩)).add
    (hspace.continuousOn.comp (continuousOn_const.prodMk continuousOn_id)
      (fun τ hτ => ⟨hx,hτ⟩))
  have hz : EqOn defect (fun _ => 0) (Ioo 0 finish) := by
    intro τ hτ
    have hpde := LocalConservationLaw.rectangleReference_contDiffOn_two_interior_classical
      hreference hq hphysical hx hτ
    have hdi (field : ℝ → ℝ → Fin m → ℝ)
        (hf : ContDiffOn ℝ 2 (Function.uncurry field) (Icc L R ×ˢ Icc 0 finish)) :
        DifferentiableAt ℝ (Function.uncurry field) (x,τ) :=
      (((hf.of_le (m:=1) (by norm_num)).mono
        (prod_mono Ioo_subset_Icc_self Ioo_subset_Icc_self)).differentiableOn_one
        (x,τ) ⟨hx,hτ⟩).differentiableAt ((isOpen_Ioo.prod isOpen_Ioo).mem_nhds ⟨hx,hτ⟩)
    have htEq := (LocalLinearAdvection.partial_time (hdi q hq)).hasDerivWithinAt.derivWithin
      (uniqueDiffOn_Icc hfinish τ ⟨hτ.1.le,hτ.2.le⟩)
    have hxEq := (LocalLinearAdvection.partial_space (hdi physical hphysical)).deriv
    change derivWithin (q x) (Icc 0 finish) τ + deriv (fun z => physical z τ) x = 0
    rw [htEq,hxEq]
    exact hpde
  have hclosure : 0 ∈ closure (Ioo (0 : ℝ) finish) := by
    rw [closure_Ioo hfinish.ne];exact ⟨le_rfl,hfinish.le⟩
  change defect 0 = 0
  exact ContinuousWithinAt.eq_const_of_mem_closure
    ((hc 0 ⟨le_rfl,hfinish.le⟩).mono Ioo_subset_Icc_self) hclosure hz

end NumStability
