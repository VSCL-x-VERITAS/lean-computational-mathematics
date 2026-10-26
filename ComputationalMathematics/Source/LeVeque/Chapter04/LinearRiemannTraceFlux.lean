/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearRiemannFluxAverage
import ComputationalMathematics.Source.LeVeque.Chapter03.RiemannCoordinates
import ComputationalMathematics.Source.LeVeque.Chapter03.RiemannWaveStrength
import ComputationalMathematics.Source.LeVeque.Chapter04.LinearGodunovFlux
import Mathlib.Tactic.Module

/-!
# LeVeque Chapter 4: linear Riemann interface trace and flux

The existing certified linear Riemann solver chooses the left state at a
stationary characteristic. Its physical flux on ray zero is independent
of the stationary wave and equals the negative-wave representation (4.49).
-/

namespace NumStability

/-- The selected interface trace from the left includes exactly the
strictly negative-speed Riemann waves. A stationary mode takes its left
value, fixing the ambiguous pointwise representative. -/
theorem leveque04_linearRiemannLeftTrace
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ) (left right : Fin m → ℝ) :
    linearRiemannSolution eigenbasis waveSpeed left left right 0 1 =
      left + ∑ p, if waveSpeed p < 0 then
        leveque03_riemannWave eigenbasis left right p else 0 := by
  let αL := eigenbasis.equivFun left
  let αR := eigenbasis.equivFun right
  have hcoordL := leveque03_characteristicCoordinates eigenbasis left
  have hcoordR := leveque03_characteristicCoordinates eigenbasis right
  have hstrength (p : Fin m) :
      leveque03_waveStrength eigenbasis left right p = αR p - αL p := by
    simp only [leveque03_waveStrength,
      leveque03_characteristicVariables, hcoordL, hcoordR]
    rfl
  have hmode (p : Fin m) :
      riemannData (αL p) (αL p) (αR p) (-waveSpeed p) • eigenbasis p =
        αL p • eigenbasis p +
          if waveSpeed p < 0 then
            leveque03_riemannWave eigenbasis left right p else 0 := by
    by_cases hs : waveSpeed p < 0
    · have hpos : 0 < -waveSpeed p := neg_pos.mpr hs
      have hdata : riemannData (αL p) (αL p) (αR p)
          (-waveSpeed p) = αR p := by
        unfold riemannData
        have hnotlt : ¬ -waveSpeed p < 0 := not_lt.mpr hpos.le
        simp [hnotlt, hpos]
      rw [hdata]
      simp only [if_pos hs, leveque03_riemannWave, hstrength]
      module
    · have hnonneg : 0 ≤ waveSpeed p := le_of_not_gt hs
      have hdata : riemannData (αL p) (αL p) (αR p)
          (-waveSpeed p) = αL p := by
        unfold riemannData
        by_cases hlt : -waveSpeed p < 0
        · simp [hlt]
        · have hnotpos : ¬ 0 < -waveSpeed p :=
            not_lt.mpr (neg_nonpos.mpr hnonneg)
          simp [hlt, hnotpos]
      rw [hdata]
      simp [hs]
  have hleft : left = ∑ p, αL p • eigenbasis p :=
    (eigenbasis.sum_equivFun left).symm
  simp only [linearRiemannSolution, eigenmodeTravelingWave,
    travelingWave, zero_sub, mul_one]
  calc
    (∑ p, riemannData (αL p) (αL p) (αR p)
      (-waveSpeed p) • eigenbasis p) =
      ∑ p, (αL p • eigenbasis p +
        if waveSpeed p < 0 then
          leveque03_riemannWave eigenbasis left right p else 0) := by
            apply Finset.sum_congr rfl
            intro p _
            exact hmode p
    _ = left + ∑ p, if waveSpeed p < 0 then
        leveque03_riemannWave eigenbasis left right p else 0 := by
          rw [Finset.sum_add_distrib, ← hleft]

/-- The selected interface trace from the right omits exactly the
strictly positive-speed waves. A stationary mode takes its right value;
this trace can differ from the left-selected trace at a zero-speed wave. -/
theorem leveque04_linearRiemannRightTrace
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ) (left right : Fin m → ℝ) :
    linearRiemannSolution eigenbasis waveSpeed left right right 0 1 =
      right - ∑ p, if 0 < waveSpeed p then
        leveque03_riemannWave eigenbasis left right p else 0 := by
  let αL := eigenbasis.equivFun left
  let αR := eigenbasis.equivFun right
  have hcoordL := leveque03_characteristicCoordinates eigenbasis left
  have hcoordR := leveque03_characteristicCoordinates eigenbasis right
  have hstrength (p : Fin m) :
      leveque03_waveStrength eigenbasis left right p = αR p - αL p := by
    simp only [leveque03_waveStrength,
      leveque03_characteristicVariables, hcoordL, hcoordR]
    rfl
  have hmode (p : Fin m) :
      riemannData (αL p) (αR p) (αR p) (-waveSpeed p) • eigenbasis p =
        αR p • eigenbasis p -
          if 0 < waveSpeed p then
            leveque03_riemannWave eigenbasis left right p else 0 := by
    by_cases hs : 0 < waveSpeed p
    · have hneg : -waveSpeed p < 0 := neg_neg_iff_pos.mpr hs
      have hdata : riemannData (αL p) (αR p) (αR p)
          (-waveSpeed p) = αL p := by
        simp [riemannData, hneg]
      rw [hdata]
      simp only [if_pos hs, leveque03_riemannWave, hstrength]
      module
    · have hnonpos : waveSpeed p ≤ 0 := le_of_not_gt hs
      have hdata : riemannData (αL p) (αR p) (αR p)
          (-waveSpeed p) = αR p := by
        unfold riemannData
        have hnotneg : ¬ -waveSpeed p < 0 :=
          not_lt.mpr (neg_nonneg.mpr hnonpos)
        simp [hnotneg]
      rw [hdata]
      simp [hs]
  have hright : right = ∑ p, αR p • eigenbasis p :=
    (eigenbasis.sum_equivFun right).symm
  simp only [linearRiemannSolution, eigenmodeTravelingWave,
    travelingWave, zero_sub, mul_one]
  calc
    (∑ p, riemannData (αL p) (αR p) (αR p)
      (-waveSpeed p) • eigenbasis p) =
      ∑ p, (αR p • eigenbasis p -
        if 0 < waveSpeed p then
          leveque03_riemannWave eigenbasis left right p else 0) := by
            apply Finset.sum_congr rfl
            intro p _
            exact hmode p
    _ = right - ∑ p, if 0 < waveSpeed p then
        leveque03_riemannWave eigenbasis left right p else 0 := by
          rw [Finset.sum_sub_distrib, ← hright]

/-- If every characteristic speed is zero, the interface value is the
explicitly chosen origin value of the Riemann data. -/
theorem leveque04_stationaryRayZero
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (left origin right : Fin m → ℝ) :
    linearRiemannSolution eigenbasis (fun _ => 0)
      left origin right 0 1 = origin := by
  simp only [linearRiemannSolution, eigenmodeTravelingWave,
    travelingWave, zero_mul, sub_zero, riemannData_zero]
  exact eigenbasis.sum_equivFun origin

/-- A stationary wave permits distinct left and right pointwise traces,
although the zero physical-flux matrix assigns them the same flux. -/
theorem leveque04_stationaryTraces_canDiffer :
    ∃ left right : Fin 1 → ℝ,
      linearRiemannSolution (Pi.basisFun ℝ (Fin 1)) (fun _ => 0)
          left left right 0 1 ≠
        linearRiemannSolution (Pi.basisFun ℝ (Fin 1)) (fun _ => 0)
          left right right 0 1 ∧
      (0 : Matrix (Fin 1) (Fin 1) ℝ).mulVec
          (linearRiemannSolution (Pi.basisFun ℝ (Fin 1)) (fun _ => 0)
            left left right 0 1) =
        (0 : Matrix (Fin 1) (Fin 1) ℝ).mulVec
          (linearRiemannSolution (Pi.basisFun ℝ (Fin 1)) (fun _ => 0)
            left right right 0 1) := by
  refine ⟨0, (fun _ => 1), ?_, ?_⟩
  · rw [leveque04_stationaryRayZero, leveque04_stationaryRayZero]
    intro h
    have h0 := congrArg (fun v : Fin 1 → ℝ => v 0) h
    norm_num at h0
  · simp

/-- The flux of the explicit linear Riemann solution on the interface
ray is the left physical flux plus its negative-speed wave sum. -/
theorem leveque04_linearRiemannTraceFlux
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (eigenbasis p) =
      waveSpeed p • eigenbasis p)
    (left right : Fin m → ℝ) :
    coefficient.mulVec
        (linearRiemannSolution eigenbasis waveSpeed left left right 0 1) =
      coefficient.mulVec left +
        ∑ p, leveque04_negativeVelocity (waveSpeed p) •
          leveque03_riemannWave eigenbasis left right p := by
  let αL := eigenbasis.equivFun left
  let αR := eigenbasis.equivFun right
  have hmode (p : Fin m) :
      coefficient.mulVec
          ((riemannData (αL p) (αL p) (αR p) (-waveSpeed p)) •
            eigenbasis p) =
        coefficient.mulVec (αL p • eigenbasis p) +
          leveque04_negativeVelocity (waveSpeed p) •
            leveque03_riemannWave eigenbasis left right p := by
    have hcoordL := leveque03_characteristicCoordinates eigenbasis left
    have hcoordR := leveque03_characteristicCoordinates eigenbasis right
    have hstrength : leveque03_waveStrength eigenbasis left right p =
        αR p - αL p := by
      simp only [leveque03_waveStrength,
        leveque03_characteristicVariables, hcoordL, hcoordR]
      rfl
    by_cases hs : waveSpeed p < 0
    · have hpos : 0 < -waveSpeed p := neg_pos.mpr hs
      have hdata : riemannData (αL p) (αL p) (αR p)
          (-waveSpeed p) = αR p := by
        unfold riemannData
        have hnotlt : ¬ -waveSpeed p < 0 := not_lt.mpr hpos.le
        simp [hnotlt, hpos]
      rw [hdata]
      simp only [Matrix.mulVec_smul, heigen,
        leveque03_riemannWave, hstrength]
      simp only [leveque04_negativeVelocity, min_eq_left hs.le,
        smul_smul]
      ext j
      simp only [Pi.add_apply, Pi.smul_apply, smul_eq_mul]
      ring
    · have hnonneg : 0 ≤ waveSpeed p := le_of_not_gt hs
      have hdata : riemannData (αL p) (αL p) (αR p)
          (-waveSpeed p) = αL p := by
        unfold riemannData
        by_cases hlt : -waveSpeed p < 0
        · simp [hlt]
        · have hnotpos : ¬ 0 < -waveSpeed p :=
            not_lt.mpr (neg_nonpos.mpr hnonneg)
          simp [hlt, hnotpos]
      rw [hdata]
      simp only [leveque04_negativeVelocity, min_eq_right hnonneg,
        zero_smul, add_zero]
  have hleft : left = ∑ p, αL p • eigenbasis p :=
    (eigenbasis.sum_equivFun left).symm
  simp only [linearRiemannSolution, eigenmodeTravelingWave,
    travelingWave, zero_sub, mul_one]
  rw [Matrix.mulVec_sum]
  calc
    (∑ p, coefficient.mulVec
        (riemannData (αL p) (αL p) (αR p) (-waveSpeed p) •
          eigenbasis p)) =
      ∑ p, (coefficient.mulVec (αL p • eigenbasis p) +
        leveque04_negativeVelocity (waveSpeed p) •
          leveque03_riemannWave eigenbasis left right p) := by
            apply Finset.sum_congr rfl
            intro p _
            exact hmode p
    _ = coefficient.mulVec left +
        ∑ p, leveque04_negativeVelocity (waveSpeed p) •
          leveque03_riemannWave eigenbasis left right p := by
            rw [Finset.sum_add_distrib, ← Matrix.mulVec_sum, ← hleft]

/-- Equation (4.49) for the actual selected flux of the certified
linear Riemann solver. Its physical time-average equals this flux by
`linearRectangleRiemannInterfaceFluxMethod_flux_eq_timeAverage`. -/
theorem leveque04_equation49_selected
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (hcoefficient : IsRealHyperbolicMatrix coefficient)
    (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (eigenbasis p) =
      waveSpeed p • eigenbasis p)
    (left right : Fin m → ℝ) :
    let method := linearRectangleRiemannInterfaceFluxMethod coefficient
      hcoefficient eigenbasis waveSpeed heigen
    let problem : HyperbolicRiemannProblem
        (linearHyperbolicConservationLaw coefficient hcoefficient) :=
      ⟨left, right⟩
    method.numericalFluxFromInformation
        (method.extractInformation (method.solve problem trivial)) =
      coefficient.mulVec left +
        ∑ p, leveque04_negativeVelocity (waveSpeed p) •
          leveque03_riemannWave eigenbasis left right p := by
  change coefficient.mulVec
      (linearRiemannSolution eigenbasis waveSpeed left left right 0 1) = _
  exact leveque04_linearRiemannTraceFlux coefficient eigenbasis
    waveSpeed heigen left right

/-- Equation (4.49) also holds for the time-average of the physical
interface flux of the certified Riemann solve, the Godunov interpretation. -/
theorem leveque04_equation49_timeAverage
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (hcoefficient : IsRealHyperbolicMatrix coefficient)
    (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (eigenbasis p) =
      waveSpeed p • eigenbasis p)
    (left right : Fin m → ℝ) (timeStep : ℝ)
    (htime : 0 < timeStep) :
    let method := linearRectangleRiemannInterfaceFluxMethod coefficient
      hcoefficient eigenbasis waveSpeed heigen
    let problem : HyperbolicRiemannProblem
        (linearHyperbolicConservationLaw coefficient hcoefficient) :=
      ⟨left, right⟩
    oneDimensionalCellAverage
        (fun τ => coefficient.mulVec
          ((method.solve problem trivial).solution 0 τ))
        0 timeStep =
      coefficient.mulVec left +
        ∑ p, leveque04_negativeVelocity (waveSpeed p) •
          leveque03_riemannWave eigenbasis left right p := by
  have havg := linearRectangleRiemannInterfaceFluxMethod_flux_eq_timeAverage
    coefficient hcoefficient eigenbasis waveSpeed heigen
    (⟨left, right⟩ : HyperbolicRiemannProblem
      (linearHyperbolicConservationLaw coefficient hcoefficient)) htime
  exact havg.symm.trans
    (leveque04_equation49_selected coefficient hcoefficient eigenbasis
      waveSpeed heigen left right)

/-- The physical flux of the right-selected Riemann trace is the right
physical flux minus the positive-speed wave sum. -/
theorem leveque04_linearRiemannRightTraceFlux
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (eigenbasis p) =
      waveSpeed p • eigenbasis p)
    (left right : Fin m → ℝ) :
    coefficient.mulVec
        (linearRiemannSolution eigenbasis waveSpeed left right right 0 1) =
      coefficient.mulVec right -
        ∑ p, leveque04_positiveVelocity (waveSpeed p) •
          leveque03_riemannWave eigenbasis left right p := by
  have hwave (p : Fin m) :
      coefficient.mulVec (leveque03_riemannWave eigenbasis left right p) =
        waveSpeed p • leveque03_riemannWave eigenbasis left right p := by
    calc
      _ = leveque03_waveStrength eigenbasis left right p •
          (waveSpeed p • eigenbasis p) := by
            rw [leveque03_riemannWave, Matrix.mulVec_smul, heigen]
      _ = waveSpeed p •
          (leveque03_waveStrength eigenbasis left right p • eigenbasis p) :=
            smul_comm _ _ _
      _ = _ := rfl
  rw [leveque04_linearRiemannRightTrace,
    Matrix.mulVec_sub, Matrix.mulVec_sum]
  congr 1
  apply Finset.sum_congr rfl
  intro p _
  by_cases hs : 0 < waveSpeed p
  · simp only [if_pos hs, hwave, leveque04_positiveVelocity,
      max_eq_left hs.le]
  · have hn : waveSpeed p ≤ 0 := le_of_not_gt hs
    simp only [if_neg hs, Matrix.mulVec_zero, leveque04_positiveVelocity,
      max_eq_right hn, zero_smul]

/-- Left and right pointwise representatives of a stationary Riemann
wave give the same physical interface flux, even if the states differ. -/
theorem leveque04_linearRiemannTraceFlux_agree
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (eigenbasis p) =
      waveSpeed p • eigenbasis p)
    (left right : Fin m → ℝ) :
    coefficient.mulVec
        (linearRiemannSolution eigenbasis waveSpeed left left right 0 1) =
      coefficient.mulVec
        (linearRiemannSolution eigenbasis waveSpeed left right right 0 1) := by
  have hdiag := (Leveque02Tracer.realEigenbasisDiagonalization
    coefficient waveSpeed eigenbasis heigen).2
  rw [leveque04_linearRiemannTraceFlux coefficient eigenbasis
    waveSpeed heigen left right,
    leveque04_linearRiemannRightTraceFlux coefficient eigenbasis
      waveSpeed heigen left right]
  have hsum := leveque04_equation46 coefficient eigenbasis waveSpeed hdiag
  have h := LinearFluxSplitting.left_eq_right coefficient
    (leveque04_positiveCoefficientPart eigenbasis waveSpeed)
    (leveque04_negativeCoefficientPart eigenbasis waveSpeed)
    hsum left right
  rw [leveque04_equation48, leveque04_equation47] at h
  simpa only [leveque04_negativeFluctuation,
    leveque04_positiveFluctuation] using h

end NumStability
