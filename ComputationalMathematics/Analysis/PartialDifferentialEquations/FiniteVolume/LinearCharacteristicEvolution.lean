/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearRiemannSolution

/-!
# Characteristic evolution for a constant-coefficient linear system

Expand each modal component of the initial state in an eigenbasis and translate it
at that mode's characteristic speed. The explicit Riemann solution is this
evolution applied to its initial Riemann data.
-/

namespace NumStability

open scoped BigOperators
open MeasureTheory

/-- Modal characteristic evolution of arbitrary initial vector data. -/
noncomputable def linearCharacteristicEvolution
    {κ : Type*} [Fintype κ]
    (basis : Module.Basis κ ℝ (κ → ℝ)) (speeds : κ → ℝ)
    (initial : ℝ → κ → ℝ) (x t : ℝ) : κ → ℝ :=
  ∑ p, (basis.equivFun (initial (x - speeds p * t)) p) • basis p

theorem linearCharacteristicEvolution_initial
    {κ : Type*} [Fintype κ]
    (basis : Module.Basis κ ℝ (κ → ℝ)) (speeds : κ → ℝ)
    (initial : ℝ → κ → ℝ) (x : ℝ) :
    linearCharacteristicEvolution basis speeds initial x 0 = initial x := by
  classical
  simpa only [linearCharacteristicEvolution, mul_zero, sub_zero]
    using basis.sum_repr (initial x)

theorem linearRiemannSolution_eq_characteristicEvolution
    {κ : Type*} [Fintype κ]
    (basis : Module.Basis κ ℝ (κ → ℝ)) (speeds : κ → ℝ)
    (left atOrigin right : κ → ℝ) (x t : ℝ) :
    linearRiemannSolution basis speeds left atOrigin right x t =
      linearCharacteristicEvolution basis speeds
        (riemannData left atOrigin right) x t := by
  classical
  simp only [linearCharacteristicEvolution, linearRiemannSolution,
    eigenmodeTravelingWave, travelingWave, riemannData]
  apply Finset.sum_congr rfl
  intro p _
  split_ifs <;> rfl

/-- Characteristic evolution solves rectangle conservation whenever each modal
initial profile is integrable on bounded spatial intervals. This permits jumps. -/
theorem linearCharacteristicEvolution_isRectangleSolution
    {κ : Type*} [Fintype κ] (coefficient : Matrix κ κ ℝ)
    (basis : Module.Basis κ ℝ (κ → ℝ)) (speeds : κ → ℝ)
    (heigen : ∀ p, coefficient.mulVec (basis p) = speeds p • basis p)
    (initial : ℝ → κ → ℝ)
    (hintegrable : ∀ p a b,
      IntervalIntegrable (fun x => basis.equivFun (initial x) p) volume a b) :
    IsRectangleConservationLawSolution
      (linearCharacteristicEvolution basis speeds initial) coefficient.mulVec := by
  have h := finite_sum_isRectangleSolution coefficient
    (fun p => eigenmodeTravelingWave
      (fun x => basis.equivFun (initial x) p) (speeds p) (basis p))
    (fun p => eigenmodeTravelingWave_isRectangleSolution coefficient _
      (hintegrable p) _ _ (heigen p))
  simpa only [linearCharacteristicEvolution, eigenmodeTravelingWave,
    travelingWave] using h

/-- If every characteristic sample at a face lies in the appropriate
constant state, the global characteristic evolution has the selected local
Riemann trace there. A stationary mode uses the supplied origin value. -/
theorem linearCharacteristicEvolution_face_eq_riemannRayZero
    {κ : Type*} [Fintype κ]
    (basis : Module.Basis κ ℝ (κ → ℝ)) (speeds : κ → ℝ)
    (initial : ℝ → κ → ℝ) (left atOrigin right : κ → ℝ)
    (face time : ℝ) (htime : 0 < time)
    (hleft : ∀ p, 0 < speeds p →
      initial (face - speeds p * time) = left)
    (hstationary : ∀ p, speeds p = 0 → initial face = atOrigin)
    (hright : ∀ p, speeds p < 0 →
      initial (face - speeds p * time) = right) :
    linearCharacteristicEvolution basis speeds initial face time =
      linearRiemannSolution basis speeds left atOrigin right 0 time := by
  classical
  simp only [linearCharacteristicEvolution, linearRiemannSolution,
    eigenmodeTravelingWave, travelingWave, zero_sub]
  apply Finset.sum_congr rfl
  intro p _
  rcases lt_trichotomy (speeds p) 0 with hs | hs | hs
  · have harg : 0 < -(speeds p * time) := by nlinarith
    rw [hright p hs]
    simp [riemannData, harg, not_lt_of_ge harg.le]
  · rw [hs]
    simp [hstationary p hs, riemannData_zero]
  · have harg : -(speeds p * time) < 0 := by nlinarith
    rw [hleft p hs]
    simp [riemannData, harg]

end NumStability
