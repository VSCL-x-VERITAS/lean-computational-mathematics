/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.MatrixAlgebra
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Examples.MovingRiemannJump
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Examples.StationaryJump
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.LocalLinearAdvection
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.LocalRectangleReference
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.VariableCoefficient
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLinearEquiv
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLipschitzTrace
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageNeighborTaylor
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.EigenmodeCellAverage
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearRiemannSolution
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.TravelingJumpAverage
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FirstOrderEquation
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.MaterialDerivative
import ComputationalMathematics.Analysis.PartialDifferentialEquations.VariableLinearFlux
import ComputationalMathematics.Source.LeVeque.Chapter01.ScalarHyperbolicity
import ComputationalMathematics.Source.LeVeque.Chapter04.AcousticEigenbasis
import ComputationalMathematics.Source.LeVeque.Chapter04.LinearRiemannWaveJump
import ComputationalMathematics.Source.LeVeque.Chapter04.NonconservativeWaveScope
import ComputationalMathematics.Source.LeVeque.Chapter04.SpectralFluctuations
import Mathlib.Algebra.BigOperators.Ring.Finset
import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Algebra.Order.Ring.Abs
import Mathlib.Analysis.Calculus.ContDiff.Operations
import Mathlib.Analysis.Calculus.Deriv.Pow
import Mathlib.Analysis.Calculus.Deriv.Prod
import Mathlib.Analysis.Calculus.MeanValue
import Mathlib.Analysis.Normed.Module.FiniteDimension
import Mathlib.Analysis.ODE.Gronwall
import Mathlib.Analysis.SpecialFunctions.ExpDeriv
import Mathlib.Analysis.SpecialFunctions.Log.Deriv
import Mathlib.Data.Matrix.Mul
import Mathlib.Data.Real.Basic
import Mathlib.MeasureTheory.Function.JacobianOneDim
import Mathlib.MeasureTheory.Integral.IntervalIntegral.AbsolutelyContinuousFun
import Mathlib.MeasureTheory.Measure.Lebesgue.EqHaar
import Mathlib.MeasureTheory.Measure.OpenPos
import Mathlib.Tactic.Abel
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.FunProp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring
import Mathlib.Topology.MetricSpace.Lipschitz
import Mathlib.Topology.Order.Compact

/-!
# NonconservativeMaterialRiemann

Source correspondence and separately qualified corrections for LeVeque Chapter 4, printed page 76 (raw PDF page 98).
-/

namespace NumStability

open Set Filter MeasureTheory Topology
open scoped BigOperators Topology NNReal

/-- The outgoing waves use the eigenvector of the material into which each
wave propagates. The shared middle state matches both physical components.
The source context is Section9.9, printed177–178, equations9.54–9.58. -/
theorem nonconservative_material_riemann_waves
    (densityLeft densityRight speedLeft speedRight : ℝ)
    (hρL : 0 < densityLeft) (hρR : 0 < densityRight)
    (hcL : 0 < speedLeft) (hcR : 0 < speedRight)
    (left right : Fin 2 → ℝ) :
    let ZL := acousticImpedance densityLeft speedLeft
    let ZR := acousticImpedance densityRight speedRight
    let αL := (-(right 0-left 0)+ZR*(right 1-left 1))/(ZL+ZR)
    let αR := ((right 0-left 0)+ZL*(right 1-left 1))/(ZL+ZR)
    let WL := αL • linearAcousticsLeftEigenvector densityLeft speedLeft
    let WR := αR • linearAcousticsRightEigenvector densityRight speedRight
    WL + WR = right-left ∧
      (linearAcousticsMatrix (densityLeft*speedLeft^2) densityLeft).mulVec WL =
        (-speedLeft) • WL ∧
      (linearAcousticsMatrix (densityRight*speedRight^2) densityRight).mulVec WR =
        speedRight • WR ∧
      ∃ middle : Fin 2 → ℝ, middle-left = WL ∧ right-middle = WR := by
  dsimp only
  let ZL := acousticImpedance densityLeft speedLeft
  let ZR := acousticImpedance densityRight speedRight
  let αL := (-(right 0-left 0)+ZR*(right 1-left 1))/(ZL+ZR)
  let αR := ((right 0-left 0)+ZL*(right 1-left 1))/(ZL+ZR)
  let WL := αL • linearAcousticsLeftEigenvector densityLeft speedLeft
  let WR := αR • linearAcousticsRightEigenvector densityRight speedRight
  have hZL : 0 < ZL := mul_pos hρL hcL
  have hZR : 0 < ZR := mul_pos hρR hcR
  have hZ : ZL+ZR ≠ 0 := ne_of_gt (add_pos hZL hZR)
  have hsum : WL+WR = right-left := by
    funext p
    fin_cases p
    · change αL*(-densityLeft*speedLeft)+αR*(densityRight*speedRight) = right 0-left 0
      dsimp only [αL,αR,ZL,ZR,acousticImpedance] at hZ ⊢
      field_simp [hZ]
      ring
    · change αL*1+αR*1 = right 1-left 1
      dsimp only [αL,αR,ZL,ZR,acousticImpedance] at hZ ⊢
      field_simp [hZ]
      ring
  refine ⟨hsum,?_,?_,left+WL,?_,?_⟩
  · rw [Matrix.mulVec_smul,linearAcousticsMatrix_mulVec_leftEigenvector
      _ _ _ hρL.ne' rfl]
    simp only [smul_smul]
    rw [mul_comm]
  · rw [Matrix.mulVec_smul,linearAcousticsMatrix_mulVec_rightEigenvector
      _ _ _ hρR.ne' rfl]
    simp only [smul_smul]
    rw [mul_comm]
  · abel
  · change right-(left+WL) = WR
    have hr : right = left+(WL+WR) := by rw [hsum]; abel
    rw [hr]
    abel

/-- Outgoing physical material waves have exact regional PDE certificates,
the prescribed initial data and a common interface state for positive time.
No single conservative flux for the heterogeneous system is assumed. -/
theorem nonconservative_material_riemann_certificate
    (ρL ρR cL cR : ℝ) (hρL : 0 < ρL) (hρR : 0 < ρR)
    (hcL : 0 < cL) (hcR : 0 < cR) (left right : Fin 2 → ℝ) :
    ∃ (αL αR : ℝ) (middle : Fin 2 → ℝ),
      middle-left = αL • linearAcousticsLeftEigenvector ρL cL ∧
      right-middle = αR • linearAcousticsRightEigenvector ρR cR ∧
      IsRectangleConservationLawSolution
        (fun x t => left+eigenmodeTravelingWave (riemannData 0 αL αL)
          (-cL) (linearAcousticsLeftEigenvector ρL cL) x t)
        (linearAcousticsMatrix (ρL*cL^2) ρL).mulVec ∧
      IsRectangleConservationLawSolution
        (fun x t => middle+eigenmodeTravelingWave (riemannData 0 0 αR)
          cR (linearAcousticsRightEigenvector ρR cR) x t)
        (linearAcousticsMatrix (ρR*cR^2) ρR).mulVec ∧
      (∀ t, 0 < t →
        left+eigenmodeTravelingWave (riemannData 0 αL αL)
          (-cL) (linearAcousticsLeftEigenvector ρL cL) 0 t = middle ∧
        middle+eigenmodeTravelingWave (riemannData 0 0 αR)
          cR (linearAcousticsRightEigenvector ρR cR) 0 t = middle) ∧
      (∀ x, x < 0 → left+eigenmodeTravelingWave (riemannData 0 αL αL)
        (-cL) (linearAcousticsLeftEigenvector ρL cL) x 0 = left) ∧
      (∀ x, 0 < x → middle+eigenmodeTravelingWave (riemannData 0 0 αR)
        cR (linearAcousticsRightEigenvector ρR cR) x 0 = right) := by
  let ZL := acousticImpedance ρL cL
  let ZR := acousticImpedance ρR cR
  let αL := (-(right 0-left 0)+ZR*(right 1-left 1))/(ZL+ZR)
  let αR := ((right 0-left 0)+ZL*(right 1-left 1))/(ZL+ZR)
  have h := nonconservative_material_riemann_waves ρL ρR cL cR hρL hρR hcL hcR left right
  obtain ⟨middle,hmL,hmR⟩ := h.2.2.2
  refine ⟨αL,αR,middle,hmL,hmR,?_,?_,?_,?_,?_⟩
  · exact constant_add_eigenmode_rectangle _ _
      (riemannData_intervalIntegrable 0 αL αL) (-cL) _ left
      (linearAcousticsMatrix_mulVec_leftEigenvector _ _ _ hρL.ne' rfl)
  · exact constant_add_eigenmode_rectangle _ _
      (riemannData_intervalIntegrable 0 0 αR) cR _ middle
      (linearAcousticsMatrix_mulVec_rightEigenvector _ _ _ hρR.ne' rfl)
  · intro t ht
    have hpos : 0 < 0-(-cL)*t := by simpa using mul_pos hcL ht
    have hneg : 0-cR*t < 0 := sub_neg.mpr (mul_pos hcR ht)
    constructor
    · simp only [eigenmodeTravelingWave,travelingWave]
      rw [(riemannData_isRiemannData 0 αL αL).2 _ hpos]
      have heq : left+αL • linearAcousticsLeftEigenvector ρL cL = middle := by
        rw [← hmL]; abel
      exact heq
    · simp only [eigenmodeTravelingWave,travelingWave]
      rw [(riemannData_isRiemannData 0 0 αR).1 _ hneg]
      simp
  · intro x hx
    simp only [eigenmodeTravelingWave,travelingWave,mul_zero,sub_zero]
    rw [(riemannData_isRiemannData 0 αL αL).1 _ hx]
    simp
  · intro x hx
    simp only [eigenmodeTravelingWave,travelingWave,mul_zero,sub_zero]
    rw [(riemannData_isRiemannData 0 0 αR).2 _ hx]
    rw [← hmR]
    abel

/-- Actual regional cell means of the physical outgoing waves give the signed
wave fluctuation update on each side of the material interface. -/
theorem material_outgoing_wave_averages
    (left middle right vL vR : Fin 2 → ℝ) (αL αR cL cR width time : ℝ)
    (hw : 0 < width) (hcL : 0 < cL) (hcR : 0 < cR) (ht : 0 ≤ time)
    (htravelL : cL*time ≤ width) (htravelR : cR*time ≤ width)
    (hmR : right-middle = αR • vR) :
    IsOneDimensionalCellAverage
      (fun x => left+eigenmodeTravelingWave (riemannData 0 αL αL) (-cL) vL x time)
      (-width) 0 (left-(time/width) • ((-cL) • (αL • vL))) ∧
    IsOneDimensionalCellAverage
      (fun x => middle+eigenmodeTravelingWave (riemannData 0 0 αR) cR vR x time)
      0 width (right-(time/width) • (cR • (αR • vR))) := by
  have hL := constant_add_eigenmode_average left vL 0 αL αL (-cL) time (-width) 0
    (neg_neg_of_pos hw) (by linarith) (by nlinarith)
  have hR := constant_add_eigenmode_average middle vR 0 0 αR cR time 0 width
    hw (mul_nonneg hcR.le ht) htravelR
  have haL : oneDimensionalCellAverage
      (fun x => left+eigenmodeTravelingWave (riemannData 0 αL αL) (-cL) vL x time)
      (-width) 0 = left-(time/width) • ((-cL) • (αL • vL)) := by
    rw [hL.2]
    simp only [neg_neg,zero_smul,smul_zero,zero_add,neg_mul,
      smul_smul,sub_eq_add_neg,← neg_smul]
    congr 1
    congr 1
    simp only [div_eq_mul_inv]
    ring
  have haR : oneDimensionalCellAverage
      (fun x => middle+eigenmodeTravelingWave (riemannData 0 0 αR) cR vR x time)
      0 width = right-(time/width) • (cR • (αR • vR)) := by
    rw [hR.2]
    simp only [sub_zero,zero_smul,smul_zero,zero_add]
    have hr : right = middle+αR • vR := by rw [← hmR]; abel
    rw [hr]
    have hs : width⁻¹*(width-cR*time) = 1-(time/width)*cR := by
      field_simp [hw.ne']
    rw [smul_smul,hs,sub_smul,one_smul]
    simp only [smul_smul,mul_assoc,sub_eq_add_neg,add_assoc]
  constructor
  · rw [← haL]
    exact oneDimensionalCellAverage_isCellAverage _ (by linarith) hL.1
  · rw [← haR]
    exact oneDimensionalCellAverage_isCellAverage _ hw hR.1

/-- A physical material Riemann construction together with its actual
regional averaged wave update; all solution and average predicates are
existing canonical APIs. -/
theorem nonconservative_material_method
    (ρL ρR cL cR width time : ℝ)
    (hρL : 0 < ρL) (hρR : 0 < ρR) (hcL : 0 < cL) (hcR : 0 < cR)
    (hw : 0 < width) (ht : 0 ≤ time)
    (htravelL : cL*time ≤ width) (htravelR : cR*time ≤ width)
    (left right : Fin 2 → ℝ) :
    ∃ (αL αR : ℝ) (middle : Fin 2 → ℝ),
      middle-left = αL • linearAcousticsLeftEigenvector ρL cL ∧
      right-middle = αR • linearAcousticsRightEigenvector ρR cR ∧
      IsRectangleConservationLawSolution
        (fun x t => left+eigenmodeTravelingWave (riemannData 0 αL αL)
          (-cL) (linearAcousticsLeftEigenvector ρL cL) x t)
        (linearAcousticsMatrix (ρL*cL^2) ρL).mulVec ∧
      IsRectangleConservationLawSolution
        (fun x t => middle+eigenmodeTravelingWave (riemannData 0 0 αR)
          cR (linearAcousticsRightEigenvector ρR cR) x t)
        (linearAcousticsMatrix (ρR*cR^2) ρR).mulVec ∧
      (∀ t, 0 < t →
        left+eigenmodeTravelingWave (riemannData 0 αL αL)
          (-cL) (linearAcousticsLeftEigenvector ρL cL) 0 t = middle ∧
        middle+eigenmodeTravelingWave (riemannData 0 0 αR)
          cR (linearAcousticsRightEigenvector ρR cR) 0 t = middle) ∧
      IsOneDimensionalCellAverage
        (fun x => left+eigenmodeTravelingWave (riemannData 0 αL αL)
          (-cL) (linearAcousticsLeftEigenvector ρL cL) x time)
        (-width) 0 (left-(time/width) • ((-cL) •
          (αL • linearAcousticsLeftEigenvector ρL cL))) ∧
      IsOneDimensionalCellAverage
        (fun x => middle+eigenmodeTravelingWave (riemannData 0 0 αR)
          cR (linearAcousticsRightEigenvector ρR cR) x time)
        0 width (right-(time/width) • (cR •
          (αR • linearAcousticsRightEigenvector ρR cR))) := by
  obtain ⟨αL,αR,middle,hmL,hmR,hL,hR,hmatch,_hiL,_hiR⟩ :=
    nonconservative_material_riemann_certificate ρL ρR cL cR hρL hρR hcL hcR left right
  have ha := material_outgoing_wave_averages left middle right
    (linearAcousticsLeftEigenvector ρL cL) (linearAcousticsRightEigenvector ρR cR)
    αL αR cL cR width time hw hcL hcR ht htravelL htravelR hmR
  exact ⟨αL,αR,middle,hmL,hmR,hL,hR,hmatch,ha.1,ha.2⟩

end NumStability
