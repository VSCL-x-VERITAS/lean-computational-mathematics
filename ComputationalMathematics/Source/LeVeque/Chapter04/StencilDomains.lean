/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.CourantNumbers
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

/-!
# LeVeque Chapter 4: centered numerical dependence cones

A centered three-point explicit stencil reaches one cell in either
direction per step; a centered five-point stencil reaches two. At a
fixed mesh ratio the one-cell radius after `n` steps is `T/r`.
-/

namespace NumStability

open scoped BigOperators

/-- The closed physical interval covered by a centered stencil after
`steps` steps, when each step reaches `radius` cell widths. -/
def leveque04_centeredStencilCone
    (center : ℝ) (steps radius : ℕ) (cellWidth : ℝ) : Set ℝ :=
  Set.Icc (center - (steps : ℝ) * radius * cellWidth)
    (center + (steps : ℝ) * radius * cellWidth)

/-- Each step of a centered stencil can move by at most its integer
radius in either direction. -/
def IsLeveque04CenteredStencilPath
    {steps : ℕ} (radius : ℕ) (offset : Fin steps → ℤ) : Prop :=
  ∀ k, -(radius : ℤ) ≤ offset k ∧ offset k ≤ radius

/-- Every path of permitted stencil steps stays inside the expected
integer cone, and both endpoint offsets are attained by constant paths. -/
theorem leveque04_centeredStencilPath_bounds
    (steps radius : ℕ) (offset : Fin steps → ℤ)
    (hpath : IsLeveque04CenteredStencilPath radius offset) :
    -((steps : ℤ) * radius) ≤ ∑ k, offset k ∧
      (∑ k, offset k) ≤ (steps : ℤ) * radius := by
  have hl : (∑ _ : Fin steps, -(radius : ℤ)) ≤ ∑ k, offset k :=
    Finset.sum_le_sum (fun k _ => (hpath k).1)
  have hr : (∑ k, offset k) ≤ ∑ _ : Fin steps, (radius : ℤ) :=
    Finset.sum_le_sum (fun k _ => (hpath k).2)
  constructor
  · simpa using hl
  · simpa using hr

theorem leveque04_centeredStencilPath_endpoints (steps radius : ℕ) :
    (∑ _ : Fin steps, -(radius : ℤ)) = -((steps : ℤ) * radius) ∧
      (∑ _ : Fin steps, (radius : ℤ)) = (steps : ℤ) * radius := by
  constructor <;> simp

/-- Mapping the discrete path offsets to physical grid positions
places every reachable point inside the centered numerical cone. -/
theorem leveque04_centeredStencilPath_memCone
    (center cellWidth : ℝ) (steps radius : ℕ)
    (hwidth : 0 ≤ cellWidth)
    (offset : Fin steps → ℤ)
    (hpath : IsLeveque04CenteredStencilPath radius offset) :
    center + (∑ k, offset k : ℤ) * cellWidth ∈
      leveque04_centeredStencilCone center steps radius cellWidth := by
  have hb := leveque04_centeredStencilPath_bounds steps radius offset hpath
  have hl : -((steps : ℝ) * radius) ≤ (∑ k, offset k : ℤ) := by
    exact_mod_cast hb.1
  have hr : (∑ k, offset k : ℤ) ≤ (steps : ℝ) * radius := by
    exact_mod_cast hb.2
  have hlmul := mul_le_mul_of_nonneg_right hl hwidth
  have hrmul := mul_le_mul_of_nonneg_right hr hwidth
  simp only [leveque04_centeredStencilCone, Set.mem_Icc]
  constructor <;> nlinarith

/-- For a fixed ratio `r=dt/dx`, the three-point stencil's cone after
`n` steps has endpoints `X ± T/r`, with `T=n*dt`. -/
theorem leveque04_threePointDomain
    (center timeStep cellWidth ratio : ℝ) (steps : ℕ)
    (htime : 0 < timeStep) (hwidth : 0 < cellWidth)
    (hratio : ratio = timeStep / cellWidth) :
    leveque04_centeredStencilCone center steps 1 cellWidth =
      Set.Icc (center - ((steps : ℝ) * timeStep) / ratio)
        (center + ((steps : ℝ) * timeStep) / ratio) := by
  have htime_ne : timeStep ≠ 0 := ne_of_gt htime
  have hwidth_ne : cellWidth ≠ 0 := ne_of_gt hwidth
  have hratio_ne : ratio ≠ 0 := by
    rw [hratio]
    exact div_ne_zero htime_ne hwidth_ne
  have hscale : ((steps : ℝ) * timeStep) / ratio =
      (steps : ℝ) * cellWidth := by
    rw [hratio]
    field_simp
  simp only [leveque04_centeredStencilCone, Nat.cast_one, mul_one,
    hscale]

/-- A backtraced characteristic point is inside a one-step centered
stencil cone exactly when its displacement is within the stencil radius. -/
theorem leveque04_backtrace_mem_cone_iff
    (center timeStep cellWidth speed : ℝ) (radius : ℕ) :
    center - speed * timeStep ∈
        leveque04_centeredStencilCone center 1 radius cellWidth ↔
      |speed * timeStep| ≤ radius * cellWidth := by
  simp only [leveque04_centeredStencilCone, Nat.cast_one, one_mul,
    Set.mem_Icc, abs_le]
  constructor
  · rintro ⟨hleft, hright⟩
    constructor <;> linarith
  · rintro ⟨hleft, hright⟩
    constructor <;> linarith

/-- A centered five-point stencil has the necessary scalar CFL bound
two for constant-speed advection. -/
theorem leveque04_fivePointCFL
    (center timeStep cellWidth speed : ℝ)
    (_htime : 0 < timeStep) (hwidth : 0 < cellWidth) :
    center - speed * timeStep ∈
        leveque04_centeredStencilCone center 1 2 cellWidth ↔
      leveque04_scalarCourantNumber timeStep cellWidth speed ≤ 2 := by
  rw [leveque04_backtrace_mem_cone_iff]
  simp only [leveque04_scalarCourantNumber, abs_div, abs_of_pos hwidth,
    Nat.cast_ofNat]
  rw [div_le_iff₀ hwidth]

/-- The system Courant bound for a centered stencil of arbitrary
integer radius. Every characteristic backtrace must fit its cone. -/
theorem leveque04_systemCenteredStencilCFL
    {m : ℕ} [NeZero m]
    (center timeStep cellWidth : ℝ) (radius : ℕ) (speed : Fin m → ℝ)
    (htime : 0 < timeStep) (hwidth : 0 < cellWidth) :
    (∀ p, center - speed p * timeStep ∈
      leveque04_centeredStencilCone center 1 radius cellWidth) ↔
        leveque04_systemCourantNumber timeStep cellWidth speed ≤ radius := by
  have hpoint (p : Fin m) :
      (center - speed p * timeStep ∈
        leveque04_centeredStencilCone center 1 radius cellWidth) ↔
          |speed p| * timeStep ≤ radius * cellWidth := by
    rw [leveque04_backtrace_mem_cone_iff]
    simp only [abs_mul, abs_of_pos htime]
  have hmax :
      leveque04_maxCharacteristicSpeed speed ≤
          radius * cellWidth / timeStep ↔
        ∀ p, |speed p| ≤ radius * cellWidth / timeStep := by
    simp only [leveque04_maxCharacteristicSpeed,
      Finset.sup'_le_iff, Finset.mem_univ, forall_const]
  have hsys :
      leveque04_systemCourantNumber timeStep cellWidth speed ≤ radius ↔
        leveque04_maxCharacteristicSpeed speed * timeStep ≤
          radius * cellWidth := by
    simp only [leveque04_systemCourantNumber]
    rw [show timeStep / cellWidth *
        leveque04_maxCharacteristicSpeed speed =
          (leveque04_maxCharacteristicSpeed speed * timeStep) / cellWidth by ring,
      div_le_iff₀ hwidth]
  constructor
  · intro h
    apply hsys.mpr
    apply (le_div_iff₀ htime).mp
    apply hmax.mpr
    intro p
    apply (le_div_iff₀ htime).mpr
    exact (hpoint p).mp (h p)
  · intro h p
    apply (hpoint p).mpr
    have hbound : |speed p| ≤ leveque04_maxCharacteristicSpeed speed :=
      leveque04_characteristicSpeed_le_max speed p
    exact (mul_le_mul_of_nonneg_right hbound htime.le).trans (hsys.mp h)

/-- A three-point hyperbolic-system stencil requires system Courant
number at most one. -/
theorem leveque04_systemThreePointCFL
    {m : ℕ} [NeZero m]
    (center timeStep cellWidth : ℝ) (speed : Fin m → ℝ)
    (htime : 0 < timeStep) (hwidth : 0 < cellWidth) :
    (∀ p, center - speed p * timeStep ∈
      leveque04_centeredStencilCone center 1 1 cellWidth) ↔
        leveque04_systemCourantNumber timeStep cellWidth speed ≤ 1 := by
  simpa only [Nat.cast_one] using
    leveque04_systemCenteredStencilCFL center timeStep cellWidth 1
      speed htime hwidth

/-- A five-point hyperbolic-system stencil requires system Courant
number at most two. -/
theorem leveque04_systemFivePointCFL
    {m : ℕ} [NeZero m]
    (center timeStep cellWidth : ℝ) (speed : Fin m → ℝ)
    (htime : 0 < timeStep) (hwidth : 0 < cellWidth) :
    (∀ p, center - speed p * timeStep ∈
      leveque04_centeredStencilCone center 1 2 cellWidth) ↔
        leveque04_systemCourantNumber timeStep cellWidth speed ≤ 2 := by
  simpa only [Nat.cast_ofNat] using
    leveque04_systemCenteredStencilCFL center timeStep cellWidth 2
      speed htime hwidth

end NumStability
