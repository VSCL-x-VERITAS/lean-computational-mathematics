/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearCharacteristicEvolution
import ComputationalMathematics.Source.LeVeque.Chapter04.PiecewiseConstantReconstruction
import ComputationalMathematics.Source.LeVeque.Chapter04.REAFanAssembly
import ComputationalMathematics.Source.LeVeque.Chapter04.REAFanCFL

/-!
# Characteristic interpretation of linear Riemann fan assembly

For a constant-coefficient linear system with a real eigenbasis, the finite
assembly of shifted Riemann jumps equals characteristic evolution of its
time-zero profile. This supplies an exact integral conservation-law evolution
for that restricted class.
-/

namespace NumStability

open scoped BigOperators

theorem leveque04_linearJumpEvolution_eq_characteristicEvolution
    {ι κ : Type*} [Fintype κ] (indices : Finset ι)
    (basis : Module.Basis κ ℝ (κ → ℝ)) (speeds : κ → ℝ)
    (interface : ι → ℝ) (background : κ → ℝ)
    (jump originState : ι → (κ → ℝ)) (x t : ℝ) :
    leveque04_linearJumpEvolution indices basis speeds
      interface background jump originState x t =
      linearCharacteristicEvolution basis speeds
        (fun y => leveque04_linearJumpEvolution indices basis speeds
          interface background jump originState y 0) x t := by
  classical
  simp_rw [leveque04_linearJumpEvolution_initial]
  simp only [linearCharacteristicEvolution, map_add, map_sum, Pi.add_apply,
    Finset.sum_apply, add_smul]
  rw [Finset.sum_add_distrib]
  simp_rw [Finset.sum_smul]
  have hbackground : (∑ p, (basis.equivFun background p) • basis p) = background := by
    exact basis.sum_repr background
  rw [hbackground]
  simp only [leveque04_linearJumpEvolution,
    linearRiemannSolution_eq_characteristicEvolution,
    linearCharacteristicEvolution]
  congr 1
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro i _
  apply Finset.sum_congr rfl
  intro p _
  congr 2
  ring_nf

theorem leveque04_characteristicEvolution_finiteJumps_rectangle
    {ι κ : Type*} [Fintype κ] (indices : Finset ι)
    (coefficient : Matrix κ κ ℝ)
    (basis : Module.Basis κ ℝ (κ → ℝ)) (speeds : κ → ℝ)
    (heigen : ∀ p, coefficient.mulVec (basis p) = speeds p • basis p)
    (interface : ι → ℝ) (background : κ → ℝ)
    (jump originState : ι → (κ → ℝ)) :
    IsRectangleConservationLawSolution
      (linearCharacteristicEvolution basis speeds
        (fun y => leveque04_linearJumpEvolution indices basis speeds
          interface background jump originState y 0)) coefficient.mulVec := by
  have h := leveque04_linearJumpEvolution_isRectangleSolution
    indices coefficient basis speeds heigen interface background jump originState
  convert h using 1
  funext x t
  exact (leveque04_linearJumpEvolution_eq_characteristicEvolution
    indices basis speeds interface background jump originState x t).symm

/-- At a face, a piecewise-constant reconstruction selects the adjacent
Riemann trace whenever each characteristic sample stays in its adjacent cell.
The origin value uses the left representative of the face. -/
theorem leveque04_linearCharacteristic_face_eq_localRiemann
    {κ : Type*} [Fintype κ]
    (basis : Module.Basis κ ℝ (κ → ℝ)) (speeds : κ → ℝ)
    (interface : ℤ → ℝ) (states : ℤ → κ → ℝ)
    (initial : ℝ → κ → ℝ)
    (hreconstruct : ∀ i x, x ∈ leveque04_cell interface i → initial x = states i)
    (hface : ∀ i, initial (interface i) = states i)
    (j : ℤ) (time : ℝ) (htime : 0 < time)
    (hleft : ∀ p, 0 < speeds p →
      interface (j - 1) < interface j - speeds p * time)
    (hright : ∀ p, speeds p < 0 →
      interface j - speeds p * time < interface (j + 1)) :
    linearCharacteristicEvolution basis speeds initial (interface j) time =
      linearRiemannSolution basis speeds
        (states j) (states j) (states (j + 1)) 0 time := by
  apply linearCharacteristicEvolution_face_eq_riemannRayZero
    basis speeds initial (states j) (states j) (states (j + 1))
    (interface j) time htime
  · intro p hp
    apply hreconstruct j _
    exact ⟨hleft p hp, by nlinarith [mul_pos hp htime]⟩
  · intro p _
    exact hface j
  · intro p hp
    apply hreconstruct (j + 1) _
    have hmem : interface j < interface j - speeds p * time ∧
        interface j - speeds p * time < interface (j + 1) :=
      ⟨by nlinarith [mul_neg_of_neg_of_pos hp htime], hright p hp⟩
    simpa [leveque04_cell] using hmem

/-- The half-width fan bound keeps every positive-time characteristic sample
inside one of the two cells adjacent to a face. Thus the global evolution's
face trace is exactly the selected local Riemann trace. -/
theorem leveque04_linearCharacteristic_face_eq_localRiemann_of_halfCFL
    {κ : Type*} [Fintype κ]
    (basis : Module.Basis κ ℝ (κ → ℝ)) (speeds : κ → ℝ)
    (interface : ℤ → ℝ) (states : ℤ → κ → ℝ)
    (initial : ℝ → κ → ℝ)
    (hreconstruct : ∀ i x, x ∈ leveque04_cell interface i → initial x = states i)
    (hface : ∀ i, initial (interface i) = states i)
    (bound step : ℝ) (hbound : 0 ≤ bound) (hstep : 0 < step)
    (hspeeds : ∀ p, -bound ≤ speeds p ∧ speeds p ≤ bound)
    (hwidth : ∀ i, 0 < leveque04_cellWidth interface i)
    (hCFL : ∀ i, 2 * bound * step ≤ leveque04_cellWidth interface i)
    (j : ℤ) (time : ℝ) (htime : 0 < time ∧ time ≤ step) :
    linearCharacteristicEvolution basis speeds initial (interface j) time =
      linearRiemannSolution basis speeds
        (states j) (states j) (states (j + 1)) 0 time := by
  apply leveque04_linearCharacteristic_face_eq_localRiemann
    basis speeds interface states initial hreconstruct hface j time htime.1
  · intro p hp
    have hspeed : speeds p * time ≤ bound * time :=
      mul_le_mul_of_nonneg_right (hspeeds p).2 htime.1.le
    have htravel : bound * time ≤ bound * step :=
      mul_le_mul_of_nonneg_left htime.2 hbound
    have hnonneg : 0 ≤ bound * step := mul_nonneg hbound hstep.le
    have hcfl := hCFL j
    have hw := hwidth j
    unfold leveque04_cellWidth at hcfl hw
    nlinarith
  · intro p hp
    have hspeed : -bound * time ≤ speeds p * time :=
      mul_le_mul_of_nonneg_right (hspeeds p).1 htime.1.le
    have htravel : bound * time ≤ bound * step :=
      mul_le_mul_of_nonneg_left htime.2 hbound
    have hnonneg : 0 ≤ bound * step := mul_nonneg hbound hstep.le
    have hcfl := hCFL (j + 1)
    have hw := hwidth (j + 1)
    unfold leveque04_cellWidth at hcfl hw
    simp only [add_sub_cancel_right] at hcfl hw
    nlinarith

end NumStability
