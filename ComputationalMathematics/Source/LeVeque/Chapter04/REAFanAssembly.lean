/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.REAFanCFL
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearRiemannSolution
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage

import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Tactic.Abel
import Mathlib.Tactic.Linarith

/-!
# LeVeque Chapter 4: assembly of noninteracting Riemann fans

When riemann fan interiors are disjoint and each riemann Riemann profile
agrees with a background state off its fan, the sum of riemann changes
equals that profile inside its fan and the background elsewhere.
Equation (4.36) supplies the geometric disjointness for neighboring
acoustic fans. PDE validity of the assembled field is separate.
-/

namespace NumStability

open scoped BigOperators
open MeasureTheory
open Classical

/-- The open spatial region influenced by a fan expanding from an
interface with speed magnitude `soundSpeed` for one time step. -/
def leveque04_acousticFanInterior
    (interface soundSpeed timeStep : ℝ) : Set ℝ :=
  Set.Ioo (interface - soundSpeed * timeStep)
    (interface + soundSpeed * timeStep)

/-- Equation (4.36)'s noninteraction inequality separates the open
interiors of fans from the two faces of a cell. -/
theorem leveque04_acousticFans_disjoint
    (interface : ℤ → ℝ) (i : ℤ) (soundSpeed timeStep : ℝ)
    (hnoninteract : IsLeveque04REAFanNoninteracting
      interface i soundSpeed timeStep) :
    Disjoint
      (leveque04_acousticFanInterior (interface (i - 1)) soundSpeed timeStep)
      (leveque04_acousticFanInterior (interface i) soundSpeed timeStep) := by
  apply Set.disjoint_left.mpr
  intro x hxleft hxright
  dsimp [leveque04_acousticFanInterior] at hxleft hxright
  have hleft := hxleft.2
  have hright := hxright.1
  unfold IsLeveque04REAFanNoninteracting at hnoninteract
  linarith

/-- Assemble finitely many riemann Riemann profiles by summing their
deviations from a shared background. -/
def leveque04_assembleFans
    {ι V : Type*} [AddCommGroup V] (indices : Finset ι)
    (background : ℝ → V) (riemann : ι → ℝ → V) (x : ℝ) : V :=
  background x + ∑ i ∈ indices, (riemann i x - background x)

/-- At a point in one fan, all other deviations vanish because the
fan interiors are disjoint. The assembly is exactly that Riemann
profile there. -/
theorem leveque04_assembleFans_eq_local
    {ι V : Type*} [AddCommGroup V] (indices : Finset ι)
    (fan : ι → Set ℝ) (background : ℝ → V) (riemann : ι → ℝ → V)
    (hdisjoint : ∀ i ∈ indices, ∀ j ∈ indices,
      i ≠ j → Disjoint (fan i) (fan j))
    (houtside : ∀ i ∈ indices, ∀ x ∉ fan i,
      riemann i x = background x)
    (j : ι) (hj : j ∈ indices) (x : ℝ) (hx : x ∈ fan j) :
    leveque04_assembleFans indices background riemann x = riemann j x := by
  have hother : ∀ i ∈ indices, i ≠ j → riemann i x = background x := by
    intro i hi hij
    apply houtside i hi x
    intro hxi
    exact (Set.disjoint_left.mp (hdisjoint i hi j hj hij) hxi hx).elim
  have hsum : (∑ i ∈ indices, (riemann i x - background x)) =
      riemann j x - background x := by
    exact Finset.sum_eq_single j
      (fun i hi hij => by rw [hother i hi hij]; exact sub_self _)
      (fun hnot => (hnot hj).elim)
  unfold leveque04_assembleFans
  rw [hsum]
  abel

/-- Outside every fan, each riemann change vanishes and the assembly
returns the background state. -/
theorem leveque04_assembleFans_eq_background
    {ι V : Type*} [AddCommGroup V] (indices : Finset ι)
    (fan : ι → Set ℝ) (background : ℝ → V) (riemann : ι → ℝ → V)
    (houtside : ∀ i ∈ indices, ∀ x ∉ fan i,
      riemann i x = background x)
    (x : ℝ) (hx : ∀ i ∈ indices, x ∉ fan i) :
    leveque04_assembleFans indices background riemann x = background x := by
  simp only [leveque04_assembleFans]
  have hzero : ∀ i ∈ indices, riemann i x - background x = 0 := by
    intro i hi
    rw [houtside i hi x (hx i hi)]
    exact sub_self _
  simp [Finset.sum_eq_zero hzero]

/-- In a constant-coefficient linear system, an assembled background and
finitely many Riemann corrections retain the rectangle conservation law
whenever each constituent does. The geometric noninteraction condition is
used separately to identify the sum with each local fan. -/
theorem leveque04_assembleFans_isRectangleSolution
    {ι κ : Type*} [Fintype κ] (indices : Finset ι)
    (coefficient : Matrix κ κ ℝ)
    (background : ℝ → ℝ → (κ → ℝ))
    (riemann : ι → ℝ → ℝ → (κ → ℝ))
    (hbackground : IsRectangleConservationLawSolution background coefficient.mulVec)
    (hcorrection : ∀ i ∈ indices,
      IsRectangleConservationLawSolution
        (fun x t => riemann i x t - background x t) coefficient.mulVec) :
    IsRectangleConservationLawSolution
      (fun x t => leveque04_assembleFans indices
        (fun y => background y t) (fun i y => riemann i y t) x)
      coefficient.mulVec := by
  classical
  let q : Option (↑indices) → ℝ → ℝ → (κ → ℝ)
    | none => background
    | some i => fun x t => riemann i.1 x t - background x t
  have hq : ∀ p, IsRectangleConservationLawSolution (q p) coefficient.mulVec := by
    intro p
    cases p with
    | none => exact hbackground
    | some i => exact hcorrection i.1 i.2
  convert finite_sum_isRectangleSolution coefficient q hq using 1
  ext x t k
  simp only [q, leveque04_assembleFans, Fintype.sum_option, Finset.sum_sub_distrib,
    Pi.add_apply, Pi.sub_apply]
  simp
  exact (Finset.sum_attach indices (fun i => riemann i x t k)).symm

/-- Difference of two rectangle solutions for the same linear flux. -/
theorem leveque04_rectangleSolution_sub
    {κ : Type*} [Fintype κ] (coefficient : Matrix κ κ ℝ)
    (u v : ℝ → ℝ → (κ → ℝ))
    (hu : IsRectangleConservationLawSolution u coefficient.mulVec)
    (hv : IsRectangleConservationLawSolution v coefficient.mulVec) :
    IsRectangleConservationLawSolution
      (fun x t => u x t - v x t) coefficient.mulVec := by
  refine ⟨?_, ?_, ?_⟩
  · intro a b t
    exact (hu.1 a b t).sub (hv.1 a b t)
  · intro x s t
    simpa only [Matrix.mulVec_sub] using
      (hu.2.1 x s t).sub (hv.2.1 x s t)
  · intro a b s t
    simp only [intervalIntegral.integral_sub (hu.1 a b t) (hv.1 a b t),
      intervalIntegral.integral_sub (hu.1 a b s) (hv.1 a b s),
      Matrix.mulVec_sub]
    rw [sub_sub_sub_comm, hu.2.2 a b s t, hv.2.2 a b s t]
    rw [← intervalIntegral.integral_sub
      ((hu.2.1 a s t).sub (hu.2.1 b s t))
      ((hv.2.1 a s t).sub (hv.2.1 b s t))]
    congr 1
    funext τ
    abel

/-- Spatial translation preserves rectangle conservation for a fixed
linear flux. -/
theorem leveque04_rectangleSolution_spatialShift
    {κ : Type*} [Fintype κ] (coefficient : Matrix κ κ ℝ)
    (q : ℝ → ℝ → (κ → ℝ))
    (hq : IsRectangleConservationLawSolution q coefficient.mulVec)
    (origin : ℝ) :
    IsRectangleConservationLawSolution
      (fun x t => q (x - origin) t) coefficient.mulVec := by
  refine ⟨?_, ?_, ?_⟩
  · intro a b t
    simpa only [sub_add_cancel] using
      (hq.1 (a - origin) (b - origin) t).comp_sub_right origin
  · intro x s t
    exact hq.2.1 (x - origin) s t
  · intro a b s t
    change (∫ x in a..b, q (x - origin) t) -
        (∫ x in a..b, q (x - origin) s) =
      ∫ τ in s..t, (coefficient.mulVec (q (a - origin) τ) -
        coefficient.mulVec (q (b - origin) τ))
    rw [intervalIntegral.integral_comp_sub_right (f := fun y => q y t) (d := origin),
      intervalIntegral.integral_comp_sub_right (f := fun y => q y s) (d := origin)]
    exact hq.2.2 (a - origin) (b - origin) s t

/-- Linear Riemann profiles and a background solution give a conserved
finite fan assembly. -/
theorem leveque04_assembleFans_isRectangleSolution_of_local
    {ι κ : Type*} [Fintype κ] (indices : Finset ι)
    (coefficient : Matrix κ κ ℝ)
    (background : ℝ → ℝ → (κ → ℝ))
    (riemann : ι → ℝ → ℝ → (κ → ℝ))
    (hbackground : IsRectangleConservationLawSolution background coefficient.mulVec)
    (hriemann : ∀ i ∈ indices,
      IsRectangleConservationLawSolution (riemann i) coefficient.mulVec) :
    IsRectangleConservationLawSolution
      (fun x t => leveque04_assembleFans indices
        (fun y => background y t) (fun i y => riemann i y t) x)
      coefficient.mulVec := by
  apply leveque04_assembleFans_isRectangleSolution indices coefficient background
    riemann hbackground
  intro i hi
  exact leveque04_rectangleSolution_sub coefficient (riemann i) background
    (hriemann i hi) hbackground

/-- An assembly of translated real-hyperbolic linear Riemann profiles
conserves on every rectangle, provided the chosen background does. -/
theorem leveque04_assembleLinearRiemannFans_isRectangleSolution
    {ι κ : Type*} [Fintype κ] (indices : Finset ι)
    (coefficient : Matrix κ κ ℝ)
    (eigenbasis : Module.Basis κ ℝ (κ → ℝ)) (eigenvalues : κ → ℝ)
    (heigen : ∀ p, coefficient.mulVec (eigenbasis p) = eigenvalues p • eigenbasis p)
    (interface : ι → ℝ)
    (leftState originState rightState : ι → (κ → ℝ))
    (background : ℝ → ℝ → (κ → ℝ))
    (hbackground : IsRectangleConservationLawSolution background coefficient.mulVec) :
    IsRectangleConservationLawSolution
      (fun x t => leveque04_assembleFans indices
        (fun y => background y t)
        (fun i y => linearRiemannSolution eigenbasis eigenvalues
          (leftState i) (originState i) (rightState i) (y - interface i) t) x)
      coefficient.mulVec := by
  apply leveque04_assembleFans_isRectangleSolution_of_local indices coefficient
    background _ hbackground
  intro i _
  exact leveque04_rectangleSolution_spatialShift coefficient
    (linearRiemannSolution eigenbasis eigenvalues
      (leftState i) (originState i) (rightState i))
    (linearRiemannSolution_isRectangleSolution coefficient eigenbasis eigenvalues
      heigen (leftState i) (originState i) (rightState i)) (interface i)

/-- The assembled linear solution starts from the corresponding sum of
translated piecewise-constant Riemann data. -/
theorem leveque04_assembleLinearRiemannFans_initial
    {ι κ : Type*} [Fintype κ] (indices : Finset ι)
    (eigenbasis : Module.Basis κ ℝ (κ → ℝ)) (eigenvalues : κ → ℝ)
    (interface : ι → ℝ)
    (leftState originState rightState : ι → (κ → ℝ))
    (background : ℝ → ℝ → (κ → ℝ)) (x : ℝ) :
    leveque04_assembleFans indices (fun y => background y 0)
      (fun i y => linearRiemannSolution eigenbasis eigenvalues
        (leftState i) (originState i) (rightState i) (y - interface i) 0) x =
    leveque04_assembleFans indices (fun y => background y 0)
      (fun i y => riemannData (leftState i) (originState i) (rightState i)
        (y - interface i)) x := by
  unfold leveque04_assembleFans
  congr 1
  apply Finset.sum_congr rfl
  intro i _
  exact congrArg (fun z => z - background x 0)
    (linearRiemannSolution_initial eigenbasis eigenvalues
      (leftState i) (originState i) (rightState i) (x - interface i))

/-- A constant background conserves under any constant linear flux. -/
theorem leveque04_constant_isRectangleSolution
    {κ : Type*} [Fintype κ] (coefficient : Matrix κ κ ℝ) (state : κ → ℝ) :
    IsRectangleConservationLawSolution (fun _ _ => state) coefficient.mulVec := by
  refine ⟨?_, ?_, ?_⟩
  · intro a b t
    exact intervalIntegrable_const
  · intro x s t
    exact intervalIntegrable_const
  · intro a b s t
    simp

/-- A finite-jump linear evolution has a constant left background and
one translated zero-left-state Riemann solution per interface. -/
noncomputable def leveque04_linearJumpEvolution
    {ι κ : Type*} [Fintype κ] (indices : Finset ι)
    (eigenbasis : Module.Basis κ ℝ (κ → ℝ)) (eigenvalues : κ → ℝ)
    (interface : ι → ℝ) (leftBackground : κ → ℝ)
    (jump originState : ι → (κ → ℝ)) (x t : ℝ) : κ → ℝ :=
  leftBackground + ∑ i ∈ indices,
    linearRiemannSolution eigenbasis eigenvalues
      0 (originState i) (jump i) (x - interface i) t

/-- A translated linear Riemann profile agrees with its original jump data
    strictly outside its characteristic cone. At the cone boundary, the
    selected value at the jump can matter, so the inequalities are strict. -/
theorem leveque04_linearRiemann_eq_jumpData_outsideCone
    {κ : Type*} [Fintype κ]
    (eigenbasis : Module.Basis κ ℝ (κ → ℝ))
    (eigenvalues : κ → ℝ) (originState jump : κ → ℝ)
    (interface speedBound x t : ℝ)
    (hspeed : ∀ p, |eigenvalues p| ≤ speedBound)
    (hbound : 0 ≤ speedBound) (ht : 0 ≤ t)
    (hx : x < interface - speedBound * t ∨
      interface + speedBound * t < x) :
    linearRiemannSolution eigenbasis eigenvalues 0 originState jump
        (x - interface) t =
      riemannData 0 originState jump (x - interface) := by
  rcases hx with hleft | hright
  · have hsub : x - interface < -speedBound * t := by linarith
    have hzero : x - interface < 0 := by
      nlinarith [mul_nonneg hbound ht]
    rw [linearRiemannSolution_farLeft eigenbasis eigenvalues
      0 originState jump speedBound (x - interface) t hspeed ht hsub]
    simp [riemannData, hzero]
  · have hsub : speedBound * t < x - interface := by linarith
    have hzero : 0 < x - interface := by
      nlinarith [mul_nonneg hbound ht]
    rw [linearRiemannSolution_farRight eigenbasis eigenvalues
      0 originState jump speedBound (x - interface) t hspeed ht hsub]
    simp [riemannData, hzero, not_lt_of_ge hzero.le]

/-- Away from every finite characteristic cone, the evolved finite-jump
    field still equals its original piecewise-constant reconstruction. -/
theorem leveque04_linearJumpEvolution_eq_initialOutsideCones
    {ι κ : Type*} [Fintype κ] (indices : Finset ι)
    (eigenbasis : Module.Basis κ ℝ (κ → ℝ))
    (eigenvalues : κ → ℝ) (interface : ι → ℝ)
    (leftBackground : κ → ℝ) (jump originState : ι → (κ → ℝ))
    (speedBound x t : ℝ)
    (hspeed : ∀ p, |eigenvalues p| ≤ speedBound)
    (hbound : 0 ≤ speedBound) (ht : 0 ≤ t)
    (houtside : ∀ i ∈ indices,
      x < interface i - speedBound * t ∨
        interface i + speedBound * t < x) :
    leveque04_linearJumpEvolution indices eigenbasis eigenvalues
        interface leftBackground jump originState x t =
      leftBackground + ∑ i ∈ indices,
        riemannData 0 (originState i) (jump i) (x - interface i) := by
  unfold leveque04_linearJumpEvolution
  congr 1
  apply Finset.sum_congr rfl
  intro i hi
  exact leveque04_linearRiemann_eq_jumpData_outsideCone
    eigenbasis eigenvalues (originState i) (jump i)
    (interface i) speedBound x t hspeed hbound ht (houtside i hi)

/-- Inside one closed cone, disjointness makes the finite-jump evolution
    equal its initial reconstruction with only that fan's Riemann correction.
    Closed cones require strict separation to be disjoint; the touching-front
    CFL endpoint is an almost-everywhere boundary case. -/
theorem leveque04_linearJumpEvolution_eq_localFan
    {ι κ : Type*} [Fintype κ] (indices : Finset ι)
    (eigenbasis : Module.Basis κ ℝ (κ → ℝ))
    (eigenvalues : κ → ℝ) (interface : ι → ℝ)
    (leftBackground : κ → ℝ) (jump originState : ι → (κ → ℝ))
    (speedBound x t : ℝ)
    (hspeed : ∀ p, |eigenvalues p| ≤ speedBound)
    (hbound : 0 ≤ speedBound) (ht : 0 ≤ t)
    (hdisjoint : ∀ i ∈ indices, ∀ j ∈ indices,
      i ≠ j → Disjoint
        (Set.Icc (interface i - speedBound * t)
          (interface i + speedBound * t))
        (Set.Icc (interface j - speedBound * t)
          (interface j + speedBound * t)))
    (j : ι) (hj : j ∈ indices)
    (hx : x ∈ Set.Icc (interface j - speedBound * t)
      (interface j + speedBound * t)) :
    leveque04_linearJumpEvolution indices eigenbasis eigenvalues
        interface leftBackground jump originState x t =
      (leftBackground + ∑ i ∈ indices,
        riemannData 0 (originState i) (jump i) (x - interface i)) +
      (linearRiemannSolution eigenbasis eigenvalues 0
        (originState j) (jump j) (x - interface j) t -
       riemannData 0 (originState j) (jump j) (x - interface j)) := by
  let fan := fun i => Set.Icc (interface i - speedBound * t)
    (interface i + speedBound * t)
  let background := fun y => leftBackground + ∑ i ∈ indices,
    riemannData 0 (originState i) (jump i) (y - interface i)
  let localProfile := fun i y => background y +
    (linearRiemannSolution eigenbasis eigenvalues 0
      (originState i) (jump i) (y - interface i) t -
     riemannData 0 (originState i) (jump i) (y - interface i))
  have houtside : ∀ i ∈ indices, ∀ y ∉ fan i,
      localProfile i y = background y := by
    intro i hi y hy
    have hcone : y < interface i - speedBound * t ∨
        interface i + speedBound * t < y := by
      simp only [fan, Set.mem_Icc] at hy
      rcases not_and_or.mp hy with hleft | hright
      · exact Or.inl (lt_of_not_ge hleft)
      · exact Or.inr (lt_of_not_ge hright)
    have hfield := leveque04_linearRiemann_eq_jumpData_outsideCone
      eigenbasis eigenvalues (originState i) (jump i)
      (interface i) speedBound y t hspeed hbound ht hcone
    simp [localProfile, hfield]
  have hassemble :
      leveque04_linearJumpEvolution indices eigenbasis eigenvalues
          interface leftBackground jump originState x t =
        leveque04_assembleFans indices background localProfile x := by
    simp only [leveque04_linearJumpEvolution, leveque04_assembleFans,
      background, localProfile]
    simp only [add_sub_cancel_left, Finset.sum_sub_distrib]
    abel
  rw [hassemble]
  have hlocal := leveque04_assembleFans_eq_local
    indices fan background localProfile (by simpa only [fan] using hdisjoint)
    houtside j hj x (by simpa only [fan] using hx)
  simpa only [localProfile, background] using hlocal

/-- The same local-fan identification holds for noninteracting open cones,
    including the half-CFL touching case, away from their front points. -/
theorem leveque04_linearJumpEvolution_eq_localFan_offFronts
    {ι κ : Type*} [Fintype κ] (indices : Finset ι)
    (eigenbasis : Module.Basis κ ℝ (κ → ℝ))
    (eigenvalues : κ → ℝ) (interface : ι → ℝ)
    (leftBackground : κ → ℝ) (jump originState : ι → (κ → ℝ))
    (speedBound x t : ℝ)
    (hspeed : ∀ p, |eigenvalues p| ≤ speedBound)
    (hbound : 0 ≤ speedBound) (ht : 0 ≤ t)
    (hdisjoint : ∀ i ∈ indices, ∀ j ∈ indices,
      i ≠ j → Disjoint
        (leveque04_acousticFanInterior (interface i) speedBound t)
        (leveque04_acousticFanInterior (interface j) speedBound t))
    (hfronts : ∀ i ∈ indices,
      x ≠ interface i - speedBound * t ∧
      x ≠ interface i + speedBound * t)
    (j : ι) (hj : j ∈ indices)
    (hx : x ∈ leveque04_acousticFanInterior (interface j) speedBound t) :
    leveque04_linearJumpEvolution indices eigenbasis eigenvalues
        interface leftBackground jump originState x t =
      (leftBackground + ∑ i ∈ indices,
        riemannData 0 (originState i) (jump i) (x - interface i)) +
      (linearRiemannSolution eigenbasis eigenvalues 0
        (originState j) (jump j) (x - interface j) t -
       riemannData 0 (originState j) (jump j) (x - interface j)) := by
  have hother : ∀ i ∈ indices, i ≠ j →
      linearRiemannSolution eigenbasis eigenvalues 0
          (originState i) (jump i) (x - interface i) t =
        riemannData 0 (originState i) (jump i) (x - interface i) := by
    intro i hi hij
    have hnot : x ∉ leveque04_acousticFanInterior (interface i) speedBound t := by
      intro hxi
      exact (Set.disjoint_left.mp (hdisjoint i hi j hj hij) hxi hx).elim
    have hcone : x < interface i - speedBound * t ∨
        interface i + speedBound * t < x := by
      simp only [leveque04_acousticFanInterior, Set.mem_Ioo] at hnot
      rcases not_and_or.mp hnot with hleft | hright
      · exact Or.inl (lt_of_le_of_ne (le_of_not_gt hleft) (hfronts i hi).1)
      · exact Or.inr (lt_of_le_of_ne (le_of_not_gt hright) (hfronts i hi).2.symm)
    exact leveque04_linearRiemann_eq_jumpData_outsideCone
      eigenbasis eigenvalues (originState i) (jump i)
      (interface i) speedBound x t hspeed hbound ht hcone
  have hsumCorrection :
      (∑ i ∈ indices,
        (linearRiemannSolution eigenbasis eigenvalues 0
            (originState i) (jump i) (x - interface i) t -
          riemannData 0 (originState i) (jump i) (x - interface i))) =
        linearRiemannSolution eigenbasis eigenvalues 0
          (originState j) (jump j) (x - interface j) t -
        riemannData 0 (originState j) (jump j) (x - interface j) := by
    exact Finset.sum_eq_single j
      (fun i hi hij => by rw [hother i hi hij]; exact sub_self _)
      (fun hnot => (hnot hj).elim)
  have hdecomp :
      (∑ i ∈ indices, linearRiemannSolution eigenbasis eigenvalues 0
          (originState i) (jump i) (x - interface i) t) =
        (∑ i ∈ indices,
          riemannData 0 (originState i) (jump i) (x - interface i)) +
        (∑ i ∈ indices,
          (linearRiemannSolution eigenbasis eigenvalues 0
              (originState i) (jump i) (x - interface i) t -
            riemannData 0 (originState i) (jump i) (x - interface i))) := by
    rw [← Finset.sum_add_distrib]
    apply Finset.sum_congr rfl
    intro i _
    abel
  unfold leveque04_linearJumpEvolution
  rw [hdecomp, hsumCorrection]
  abel

/-- The two characteristic front positions of each selected Riemann problem. -/
noncomputable def leveque04_linearFanFronts
    {ι : Type*} (indices : Finset ι) (interface : ι → ℝ)
    (speedBound t : ℝ) : Set ℝ := by
  classical
  exact ↑(indices.image (fun i => interface i - speedBound * t) ∪
    indices.image (fun i => interface i + speedBound * t))

/-- A finite collection of characteristic fronts is Lebesgue-null. -/
theorem leveque04_linearFanFronts_measure_zero
    {ι : Type*} (indices : Finset ι) (interface : ι → ℝ)
    (speedBound t : ℝ) :
    volume (leveque04_linearFanFronts indices interface speedBound t) = 0 := by
  classical
  unfold leveque04_linearFanFronts
  exact (Finset.finite_toSet _).measure_zero volume

/-- Membership outside the finite front set supplies every front inequality. -/
theorem leveque04_linearFanFronts_outside
    {ι : Type*} (indices : Finset ι) (interface : ι → ℝ)
    (speedBound t x : ℝ)
    (hx : x ∉ leveque04_linearFanFronts indices interface speedBound t) :
    ∀ i ∈ indices,
      x ≠ interface i - speedBound * t ∧
      x ≠ interface i + speedBound * t := by
  classical
  intro i hi
  constructor
  · intro h
    apply hx
    rw [h]
    change interface i - speedBound * t ∈
      (↑(indices.image (fun i => interface i - speedBound * t) ∪
        indices.image (fun i => interface i + speedBound * t)) : Set ℝ)
    exact Finset.mem_union.mpr
      (Or.inl (Finset.mem_image.mpr ⟨i, hi, rfl⟩))
  · intro h
    apply hx
    rw [h]
    change interface i + speedBound * t ∈
      (↑(indices.image (fun i => interface i - speedBound * t) ∪
        indices.image (fun i => interface i + speedBound * t)) : Set ℝ)
    exact Finset.mem_union.mpr
      (Or.inr (Finset.mem_image.mpr ⟨i, hi, rfl⟩))

/-- At the touching-front CFL endpoint, the finite-jump linear field is
    assembled from the selected local Riemann solution almost everywhere.
    The only excluded positions are finitely many characteristic fronts. -/
theorem leveque04_linearJumpEvolution_eq_localFan_ae
    {ι κ : Type*} [Fintype κ] (indices : Finset ι)
    (eigenbasis : Module.Basis κ ℝ (κ → ℝ))
    (eigenvalues : κ → ℝ) (interface : ι → ℝ)
    (leftBackground : κ → ℝ) (jump originState : ι → (κ → ℝ))
    (speedBound t : ℝ)
    (hspeed : ∀ p, |eigenvalues p| ≤ speedBound)
    (hbound : 0 ≤ speedBound) (ht : 0 ≤ t)
    (hdisjoint : ∀ i ∈ indices, ∀ j ∈ indices,
      i ≠ j → Disjoint
        (leveque04_acousticFanInterior (interface i) speedBound t)
        (leveque04_acousticFanInterior (interface j) speedBound t)) :
    ∀ᵐ x ∂volume, ∀ j ∈ indices,
      x ∈ leveque04_acousticFanInterior (interface j) speedBound t →
        leveque04_linearJumpEvolution indices eigenbasis eigenvalues
            interface leftBackground jump originState x t =
          (leftBackground + ∑ i ∈ indices,
            riemannData 0 (originState i) (jump i) (x - interface i)) +
          (linearRiemannSolution eigenbasis eigenvalues 0
            (originState j) (jump j) (x - interface j) t -
           riemannData 0 (originState j) (jump j) (x - interface j)) := by
  have hgood : ∀ᵐ x ∂volume,
      x ∉ leveque04_linearFanFronts indices interface speedBound t := by
    rw [ae_iff]
    simpa only [not_not] using
      leveque04_linearFanFronts_measure_zero indices interface speedBound t
  filter_upwards [hgood] with x hx
  intro j hj hxj
  exact leveque04_linearJumpEvolution_eq_localFan_offFronts
    indices eigenbasis eigenvalues interface leftBackground jump originState
    speedBound x t hspeed hbound ht hdisjoint
    (leveque04_linearFanFronts_outside indices interface speedBound t x hx)
    j hj hxj

/-- Almost-everywhere agreement on a fan transfers to the normalized
    average of any ordered cell contained in that fan. -/
theorem leveque04_cellAverage_eq_of_ae_on_fan
    {V : Type*} [NormedAddCommGroup V] [NormedSpace ℝ V]
    (field patch : ℝ → V) (fan : Set ℝ)
    (left right : ℝ) (hcell : left ≤ right)
    (hcontained : Set.Ioc left right ⊆ fan)
    (hagrees : ∀ᵐ x ∂volume, x ∈ fan → field x = patch x) :
    oneDimensionalCellAverage field left right =
      oneDimensionalCellAverage patch left right := by
  unfold oneDimensionalCellAverage
  congr 1
  apply intervalIntegral.integral_congr_ae
  filter_upwards [hagrees] with x hx hinterval
  exact hx (hcontained (by simpa only [Set.uIoc_of_le hcell] using hinterval))

/-- A cell contained in a selected open fan has the exact average of the
    corresponding local Riemann correction, including at touching-front CFL. -/
theorem leveque04_linearJumpEvolution_localFan_cellAverage
    {ι κ : Type*} [Fintype κ] (indices : Finset ι)
    (eigenbasis : Module.Basis κ ℝ (κ → ℝ))
    (eigenvalues : κ → ℝ) (interface : ι → ℝ)
    (leftBackground : κ → ℝ) (jump originState : ι → (κ → ℝ))
    (speedBound t left right : ℝ)
    (hspeed : ∀ p, |eigenvalues p| ≤ speedBound)
    (hbound : 0 ≤ speedBound) (ht : 0 ≤ t)
    (hdisjoint : ∀ i ∈ indices, ∀ j ∈ indices,
      i ≠ j → Disjoint
        (leveque04_acousticFanInterior (interface i) speedBound t)
        (leveque04_acousticFanInterior (interface j) speedBound t))
    (j : ι) (hj : j ∈ indices) (hcell : left ≤ right)
    (hcontained : Set.Ioc left right ⊆
      leveque04_acousticFanInterior (interface j) speedBound t) :
    oneDimensionalCellAverage
        (fun x => leveque04_linearJumpEvolution indices eigenbasis eigenvalues
          interface leftBackground jump originState x t) left right =
      oneDimensionalCellAverage
        (fun x =>
          (leftBackground + ∑ i ∈ indices,
            riemannData 0 (originState i) (jump i) (x - interface i)) +
          (linearRiemannSolution eigenbasis eigenvalues 0
            (originState j) (jump j) (x - interface j) t -
           riemannData 0 (originState j) (jump j) (x - interface j)))
        left right := by
  have hagrees : ∀ᵐ x ∂volume,
      x ∈ leveque04_acousticFanInterior (interface j) speedBound t →
        leveque04_linearJumpEvolution indices eigenbasis eigenvalues
            interface leftBackground jump originState x t =
          (leftBackground + ∑ i ∈ indices,
            riemannData 0 (originState i) (jump i) (x - interface i)) +
          (linearRiemannSolution eigenbasis eigenvalues 0
            (originState j) (jump j) (x - interface j) t -
           riemannData 0 (originState j) (jump j) (x - interface j)) := by
    filter_upwards [leveque04_linearJumpEvolution_eq_localFan_ae
      indices eigenbasis eigenvalues interface leftBackground jump originState
      speedBound t hspeed hbound ht hdisjoint] with x hx hxj
    exact hx j hj hxj
  exact leveque04_cellAverage_eq_of_ae_on_fan
    (fun x => leveque04_linearJumpEvolution indices eigenbasis eigenvalues
      interface leftBackground jump originState x t)
    (fun x =>
      (leftBackground + ∑ i ∈ indices,
        riemannData 0 (originState i) (jump i) (x - interface i)) +
      (linearRiemannSolution eigenbasis eigenvalues 0
        (originState j) (jump j) (x - interface j) t -
       riemannData 0 (originState j) (jump j) (x - interface j)))
    (leveque04_acousticFanInterior (interface j) speedBound t)
    left right hcell hcontained hagrees

/-- Off the finite front set, the complete linear evolution is the
initial reconstruction plus the corrections selected by all fan interiors.
This formula applies to an entire cell, including one crossed by several
fan boundaries. -/
theorem leveque04_linearJumpEvolution_eq_fanPartition_offFronts
    {ι κ : Type*} [Fintype κ] (indices : Finset ι)
    (eigenbasis : Module.Basis κ ℝ (κ → ℝ))
    (eigenvalues : κ → ℝ) (interface : ι → ℝ)
    (leftBackground : κ → ℝ) (jump originState : ι → (κ → ℝ))
    (speedBound x t : ℝ)
    (hspeed : ∀ p, |eigenvalues p| ≤ speedBound)
    (hbound : 0 ≤ speedBound) (ht : 0 ≤ t)
    (hfronts : x ∉ leveque04_linearFanFronts indices interface speedBound t) :
    leveque04_linearJumpEvolution indices eigenbasis eigenvalues
        interface leftBackground jump originState x t =
      (leftBackground + ∑ i ∈ indices,
        riemannData 0 (originState i) (jump i) (x - interface i)) +
      ∑ i ∈ indices,
        if x ∈ leveque04_acousticFanInterior (interface i) speedBound t then
          linearRiemannSolution eigenbasis eigenvalues 0
            (originState i) (jump i) (x - interface i) t -
          riemannData 0 (originState i) (jump i) (x - interface i)
        else 0 := by
  classical
  have hneq := leveque04_linearFanFronts_outside
    indices interface speedBound t x hfronts
  have hterm : ∀ i ∈ indices,
      linearRiemannSolution eigenbasis eigenvalues 0
          (originState i) (jump i) (x - interface i) t =
        riemannData 0 (originState i) (jump i) (x - interface i) +
        (if x ∈ leveque04_acousticFanInterior (interface i) speedBound t then
          linearRiemannSolution eigenbasis eigenvalues 0
            (originState i) (jump i) (x - interface i) t -
          riemannData 0 (originState i) (jump i) (x - interface i)
         else 0) := by
    intro i hi
    by_cases hfan : x ∈ leveque04_acousticFanInterior (interface i) speedBound t
    · simp only [if_pos hfan]
      abel
    · have hcone : x < interface i - speedBound * t ∨
          interface i + speedBound * t < x := by
        simp only [leveque04_acousticFanInterior, Set.mem_Ioo] at hfan
        rcases not_and_or.mp hfan with hleft | hright
        · exact Or.inl (lt_of_le_of_ne (le_of_not_gt hleft) (hneq i hi).1)
        · exact Or.inr (lt_of_le_of_ne (le_of_not_gt hright) (hneq i hi).2.symm)
      rw [leveque04_linearRiemann_eq_jumpData_outsideCone
        eigenbasis eigenvalues (originState i) (jump i)
        (interface i) speedBound x t hspeed hbound ht hcone]
      simp only [if_neg hfan, add_zero]
  unfold leveque04_linearJumpEvolution
  have hsum := Finset.sum_congr (rfl : indices = indices) hterm
  rw [hsum, Finset.sum_add_distrib]
  abel

/-- The fan-partition representation gives the exact average over any
ordered cell, even when that cell crosses finite fan fronts. Front values
do not affect the integral. -/
theorem leveque04_linearJumpEvolution_fanPartition_cellAverage
    {ι κ : Type*} [Fintype κ] (indices : Finset ι)
    (eigenbasis : Module.Basis κ ℝ (κ → ℝ))
    (eigenvalues : κ → ℝ) (interface : ι → ℝ)
    (leftBackground : κ → ℝ) (jump originState : ι → (κ → ℝ))
    (speedBound t left right : ℝ)
    (hspeed : ∀ p, |eigenvalues p| ≤ speedBound)
    (hbound : 0 ≤ speedBound) (ht : 0 ≤ t)
    (hcell : left ≤ right) :
    oneDimensionalCellAverage
        (fun x => leveque04_linearJumpEvolution indices eigenbasis eigenvalues
          interface leftBackground jump originState x t) left right =
      oneDimensionalCellAverage
        (fun x =>
          (leftBackground + ∑ i ∈ indices,
            riemannData 0 (originState i) (jump i) (x - interface i)) +
          ∑ i ∈ indices,
            if x ∈ leveque04_acousticFanInterior (interface i) speedBound t then
              linearRiemannSolution eigenbasis eigenvalues 0
                (originState i) (jump i) (x - interface i) t -
              riemannData 0 (originState i) (jump i) (x - interface i)
            else 0) left right := by
  have hgood : ∀ᵐ x ∂volume,
      x ∉ leveque04_linearFanFronts indices interface speedBound t := by
    rw [ae_iff]
    simpa only [not_not] using
      leveque04_linearFanFronts_measure_zero indices interface speedBound t
  apply leveque04_cellAverage_eq_of_ae_on_fan
    (fan := Set.univ) (hcell := hcell)
  · intro x _
    trivial
  · filter_upwards [hgood] with x hx _
    exact leveque04_linearJumpEvolution_eq_fanPartition_offFronts
      indices eigenbasis eigenvalues interface leftBackground jump originState
      speedBound x t hspeed hbound ht hx

/-- The finite-jump field is a rectangle solution of every constant
linear system for which the selected basis is an eigenbasis. -/
theorem leveque04_linearJumpEvolution_isRectangleSolution
    {ι κ : Type*} [Fintype κ] (indices : Finset ι)
    (coefficient : Matrix κ κ ℝ)
    (eigenbasis : Module.Basis κ ℝ (κ → ℝ)) (eigenvalues : κ → ℝ)
    (heigen : ∀ p, coefficient.mulVec (eigenbasis p) = eigenvalues p • eigenbasis p)
    (interface : ι → ℝ) (leftBackground : κ → ℝ)
    (jump originState : ι → (κ → ℝ)) :
    IsRectangleConservationLawSolution
      (leveque04_linearJumpEvolution indices eigenbasis eigenvalues
        interface leftBackground jump originState) coefficient.mulVec := by
  classical
  let q : Option (↑indices) → ℝ → ℝ → (κ → ℝ)
    | none => fun _ _ => leftBackground
    | some i => fun x t => linearRiemannSolution eigenbasis eigenvalues
        0 (originState i.1) (jump i.1) (x - interface i.1) t
  have hq : ∀ p, IsRectangleConservationLawSolution (q p) coefficient.mulVec := by
    intro p
    cases p with
    | none => exact leveque04_constant_isRectangleSolution coefficient leftBackground
    | some i =>
      exact leveque04_rectangleSolution_spatialShift coefficient
        (linearRiemannSolution eigenbasis eigenvalues 0
          (originState i.1) (jump i.1))
        (linearRiemannSolution_isRectangleSolution coefficient eigenbasis eigenvalues
          heigen 0 (originState i.1) (jump i.1)) (interface i.1)
  convert finite_sum_isRectangleSolution coefficient q hq using 1
  ext x t k
  simp [q, leveque04_linearJumpEvolution, Fintype.sum_option]
  exact (Finset.sum_attach indices (fun i =>
    linearRiemannSolution eigenbasis eigenvalues 0 (originState i) (jump i)
      (x - interface i) t k)).symm

/-- At time zero the finite-jump solution is exactly the assembled
piecewise-constant Riemann jump data, including its selected values at
the interface points. -/
theorem leveque04_linearJumpEvolution_initial
    {ι κ : Type*} [Fintype κ] (indices : Finset ι)
    (eigenbasis : Module.Basis κ ℝ (κ → ℝ)) (eigenvalues : κ → ℝ)
    (interface : ι → ℝ) (leftBackground : κ → ℝ)
    (jump originState : ι → (κ → ℝ)) (x : ℝ) :
    leveque04_linearJumpEvolution indices eigenbasis eigenvalues
      interface leftBackground jump originState x 0 =
    leftBackground + ∑ i ∈ indices,
      riemannData 0 (originState i) (jump i) (x - interface i) := by
  unfold leveque04_linearJumpEvolution
  congr 1
  apply Finset.sum_congr rfl
  intro i _
  exact linearRiemannSolution_initial eigenbasis eigenvalues 0
    (originState i) (jump i) (x - interface i)

/-- Away from an interface, zero-left-state Riemann data contribute
exactly one right-hand jump. -/
theorem leveque04_riemannJump_offInterface
    {κ : Type*} [Fintype κ] (jump originState : κ → ℝ)
    (interface x : ℝ) (hx : x ≠ interface) :
    riemannData (0 : κ → ℝ) originState jump (x - interface) =
      if interface < x then jump else 0 := by
  by_cases hright : interface < x
  · have hpos : 0 < x - interface := sub_pos.mpr hright
    simp [riemannData, hright, hpos, not_lt_of_ge hpos.le]
  · have hleft : x < interface := by
      have hle : x ≤ interface := le_of_not_gt hright
      exact lt_of_le_of_ne hle hx
    have hneg : x - interface < 0 := sub_neg.mpr hleft
    simp [riemannData, hright, hneg]

/-- At every point away from the jump interfaces, the time-zero field
is the usual cumulative piecewise-constant grid data. -/
theorem leveque04_linearJumpEvolution_initial_offInterfaces
    {ι κ : Type*} [Fintype κ] (indices : Finset ι)
    (eigenbasis : Module.Basis κ ℝ (κ → ℝ)) (eigenvalues : κ → ℝ)
    (interface : ι → ℝ) (leftBackground : κ → ℝ)
    (jump originState : ι → (κ → ℝ)) (x : ℝ)
    (hx : ∀ i ∈ indices, x ≠ interface i) :
    leveque04_linearJumpEvolution indices eigenbasis eigenvalues
      interface leftBackground jump originState x 0 =
    leftBackground + ∑ i ∈ indices, if interface i < x then jump i else 0 := by
  rw [leveque04_linearJumpEvolution_initial]
  congr 1
  apply Finset.sum_congr rfl
  intro i hi
  exact leveque04_riemannJump_offInterface (jump i) (originState i)
    (interface i) x (hx i hi)

/-- Neighboring Riemann fan interiors remain disjoint when their two
inward travel distances fit inside the intervening cell. The two fans
may have different left and right speed bounds. -/
theorem leveque04_variableRiemannFans_disjoint
    (interface : ℤ → ℝ) (i : ℤ)
    (leftSpeed rightSpeed : ℤ → ℝ) (timeStep : ℝ)
    (hnoninteract :
      (rightSpeed (i - 1) + leftSpeed i) * timeStep ≤
        leveque04_cellWidth interface i) :
    Disjoint
      (Set.Ioo
        (interface (i - 1) - leftSpeed (i - 1) * timeStep)
        (interface (i - 1) + rightSpeed (i - 1) * timeStep))
      (Set.Ioo
        (interface i - leftSpeed i * timeStep)
        (interface i + rightSpeed i * timeStep)) := by
  apply Set.disjoint_left.mpr
  intro x hxleft hxright
  have hleft := hxleft.2
  have hright := hxright.1
  unfold leveque04_cellWidth at hnoninteract
  nlinarith

/-- Pointwise gluing of two fan profiles and a background state; this
construction works for a nonlinear state space without adding solutions. -/
noncomputable def leveque04_twoFanGluing {V : Type*}
    (leftFan rightFan : Set ℝ)
    (background leftProfile rightProfile : ℝ → V) (x : ℝ) : V :=
  if x ∈ leftFan then leftProfile x
  else if x ∈ rightFan then rightProfile x
  else background x

/-- The gluing agrees with the left Riemann profile in its open fan. -/
theorem leveque04_twoFanGluing_eq_left
    {V : Type*} (leftFan rightFan : Set ℝ)
    (background leftProfile rightProfile : ℝ → V)
    (x : ℝ) (hx : x ∈ leftFan) :
    leveque04_twoFanGluing leftFan rightFan
      background leftProfile rightProfile x = leftProfile x := by
  simp [leveque04_twoFanGluing, hx]

/-- When the fan interiors do not overlap, gluing agrees with the
right Riemann profile throughout its open fan. -/
theorem leveque04_twoFanGluing_eq_right
    {V : Type*} (leftFan rightFan : Set ℝ)
    (background leftProfile rightProfile : ℝ → V)
    (hdisjoint : Disjoint leftFan rightFan)
    (x : ℝ) (hx : x ∈ rightFan) :
    leveque04_twoFanGluing leftFan rightFan
      background leftProfile rightProfile x = rightProfile x := by
  have hnot : x ∉ leftFan := by
    intro hleft
    exact (Set.disjoint_left.mp hdisjoint hleft hx).elim
  simp [leveque04_twoFanGluing, hnot, hx]

/-- Outside both open fans, gluing returns the background state. -/
theorem leveque04_twoFanGluing_eq_background
    {V : Type*} (leftFan rightFan : Set ℝ)
    (background leftProfile rightProfile : ℝ → V)
    (x : ℝ) (hleft : x ∉ leftFan) (hright : x ∉ rightFan) :
    leveque04_twoFanGluing leftFan rightFan
      background leftProfile rightProfile x = background x := by
  simp [leveque04_twoFanGluing, hleft, hright]

/-- The variable-speed noninteraction inequality at the end of a step
separates neighboring open fan interiors throughout the entire step. -/
theorem leveque04_variableRiemannFans_disjoint_throughStep
    (interface : ℤ → ℝ) (i : ℤ)
    (leftSpeed rightSpeed : ℤ → ℝ) (timeStep : ℝ)
    (hspeeds : 0 ≤ rightSpeed (i - 1) + leftSpeed i)
    (hnoninteract :
      (rightSpeed (i - 1) + leftSpeed i) * timeStep ≤
        leveque04_cellWidth interface i) :
    ∀ τ ∈ Set.Icc (0 : ℝ) timeStep,
      Disjoint
        (Set.Ioo
          (interface (i - 1) - leftSpeed (i - 1) * τ)
          (interface (i - 1) + rightSpeed (i - 1) * τ))
        (Set.Ioo
          (interface i - leftSpeed i * τ)
          (interface i + rightSpeed i * τ)) := by
  intro τ hτ
  apply leveque04_variableRiemannFans_disjoint interface i
    leftSpeed rightSpeed τ
  exact (mul_le_mul_of_nonneg_left hτ.2 hspeeds).trans hnoninteract

/-- A time-dependent, nonadditive gluing of neighboring variable-speed
Riemann fan profiles with a background state. -/
noncomputable def leveque04_variableTwoFanEvolution {V : Type*}
    (interface : ℤ → ℝ) (i : ℤ)
    (leftSpeed rightSpeed : ℤ → ℝ)
    (background leftProfile rightProfile : ℝ → ℝ → V)
    (x τ : ℝ) : V :=
  leveque04_twoFanGluing
    (Set.Ioo
      (interface (i - 1) - leftSpeed (i - 1) * τ)
      (interface (i - 1) + rightSpeed (i - 1) * τ))
    (Set.Ioo
      (interface i - leftSpeed i * τ)
      (interface i + rightSpeed i * τ))
    (fun y => background y τ)
    (fun y => leftProfile y τ)
    (fun y => rightProfile y τ) x

/-- Throughout a noninteracting step, the time-dependent gluing equals
the right Riemann profile at every point strictly inside its fan. -/
theorem leveque04_variableTwoFanEvolution_eq_right
    {V : Type*} (interface : ℤ → ℝ) (i : ℤ)
    (leftSpeed rightSpeed : ℤ → ℝ)
    (background leftProfile rightProfile : ℝ → ℝ → V)
    (timeStep τ x : ℝ)
    (hspeeds : 0 ≤ rightSpeed (i - 1) + leftSpeed i)
    (hnoninteract :
      (rightSpeed (i - 1) + leftSpeed i) * timeStep ≤
        leveque04_cellWidth interface i)
    (hτ : τ ∈ Set.Icc (0 : ℝ) timeStep)
    (hx : x ∈ Set.Ioo
      (interface i - leftSpeed i * τ)
      (interface i + rightSpeed i * τ)) :
    leveque04_variableTwoFanEvolution interface i leftSpeed rightSpeed
      background leftProfile rightProfile x τ = rightProfile x τ := by
  unfold leveque04_variableTwoFanEvolution
  exact leveque04_twoFanGluing_eq_right _ _ _ _ _
    (leveque04_variableRiemannFans_disjoint_throughStep
      interface i leftSpeed rightSpeed timeStep
      hspeeds hnoninteract τ hτ) x hx

/-- Inside the left open fan, the time-dependent gluing equals its
left Riemann profile. -/
theorem leveque04_variableTwoFanEvolution_eq_left
    {V : Type*} (interface : ℤ → ℝ) (i : ℤ)
    (leftSpeed rightSpeed : ℤ → ℝ)
    (background leftProfile rightProfile : ℝ → ℝ → V)
    (τ x : ℝ)
    (hx : x ∈ Set.Ioo
      (interface (i - 1) - leftSpeed (i - 1) * τ)
      (interface (i - 1) + rightSpeed (i - 1) * τ)) :
    leveque04_variableTwoFanEvolution interface i leftSpeed rightSpeed
      background leftProfile rightProfile x τ = leftProfile x τ := by
  unfold leveque04_variableTwoFanEvolution
  exact leveque04_twoFanGluing_eq_left _ _ _ _ _ x hx

/-- Outside both open fans, the time-dependent gluing equals the
background state. Front-point values remain governed by the definition. -/
theorem leveque04_variableTwoFanEvolution_eq_background
    {V : Type*} (interface : ℤ → ℝ) (i : ℤ)
    (leftSpeed rightSpeed : ℤ → ℝ)
    (background leftProfile rightProfile : ℝ → ℝ → V)
    (τ x : ℝ)
    (hleft : x ∉ Set.Ioo
      (interface (i - 1) - leftSpeed (i - 1) * τ)
      (interface (i - 1) + rightSpeed (i - 1) * τ))
    (hright : x ∉ Set.Ioo
      (interface i - leftSpeed i * τ)
      (interface i + rightSpeed i * τ)) :
    leveque04_variableTwoFanEvolution interface i leftSpeed rightSpeed
      background leftProfile rightProfile x τ = background x τ := by
  unfold leveque04_variableTwoFanEvolution
  exact leveque04_twoFanGluing_eq_background _ _ _ _ _ x hleft hright

/-- The four moving endpoints of two neighboring variable-speed open
Riemann fans at one time. -/
noncomputable def leveque04_variableTwoFanFronts
    (interface : ℤ → ℝ) (i : ℤ)
    (leftSpeed rightSpeed : ℤ → ℝ) (τ : ℝ) : Set ℝ := by
  classical
  exact ↑({interface (i - 1) - leftSpeed (i - 1) * τ,
    interface (i - 1) + rightSpeed (i - 1) * τ,
    interface i - leftSpeed i * τ,
    interface i + rightSpeed i * τ} : Finset ℝ)

/-- The moving endpoints of two variable-speed fans form a
Lebesgue-null spatial set at every fixed time. -/
theorem leveque04_variableTwoFanFronts_measure_zero
    (interface : ℤ → ℝ) (i : ℤ)
    (leftSpeed rightSpeed : ℤ → ℝ) (τ : ℝ) :
    volume (leveque04_variableTwoFanFronts interface i
      leftSpeed rightSpeed τ) = 0 := by
  classical
  unfold leveque04_variableTwoFanFronts
  exact (Finset.finite_toSet _).measure_zero volume

/-- If a candidate nonlinear field agrees with the glued fan profiles
away from their four moving endpoints, it agrees almost everywhere in
space at that time. -/
theorem leveque04_variableTwoFanEvolution_eq_ae_of_offFronts
    {V : Type*} (interface : ℤ → ℝ) (i : ℤ)
    (leftSpeed rightSpeed : ℤ → ℝ)
    (background leftProfile rightProfile : ℝ → ℝ → V)
    (candidate : ℝ → V) (τ : ℝ)
    (hoff : ∀ x, x ∉ leveque04_variableTwoFanFronts interface i
      leftSpeed rightSpeed τ →
        candidate x = leveque04_variableTwoFanEvolution interface i
          leftSpeed rightSpeed background leftProfile rightProfile x τ) :
    ∀ᵐ x ∂volume,
      candidate x = leveque04_variableTwoFanEvolution interface i
        leftSpeed rightSpeed background leftProfile rightProfile x τ := by
  have hgood : ∀ᵐ x ∂volume,
      x ∉ leveque04_variableTwoFanFronts interface i
        leftSpeed rightSpeed τ := by
    rw [ae_iff]
    simpa only [not_not] using
      leveque04_variableTwoFanFronts_measure_zero
        interface i leftSpeed rightSpeed τ
  filter_upwards [hgood] with x hx
  exact hoff x hx

/-- Changing the four moving front-point values does not change any
ordered cell average of the time-dependent two-fan evolution. -/
theorem leveque04_variableTwoFanEvolution_cellAverage_eq_of_offFronts
    {V : Type*} [NormedAddCommGroup V] [NormedSpace ℝ V]
    (interface : ℤ → ℝ) (i : ℤ)
    (leftSpeed rightSpeed : ℤ → ℝ)
    (background leftProfile rightProfile : ℝ → ℝ → V)
    (candidate : ℝ → V) (τ a b : ℝ) (hab : a ≤ b)
    (hoff : ∀ x, x ∉ leveque04_variableTwoFanFronts interface i
      leftSpeed rightSpeed τ →
        candidate x = leveque04_variableTwoFanEvolution interface i
          leftSpeed rightSpeed background leftProfile rightProfile x τ) :
    oneDimensionalCellAverage candidate a b =
      oneDimensionalCellAverage
        (fun x => leveque04_variableTwoFanEvolution interface i
          leftSpeed rightSpeed background leftProfile rightProfile x τ)
        a b := by
  apply leveque04_cellAverage_eq_of_ae_on_fan
    candidate
    (fun x => leveque04_variableTwoFanEvolution interface i
      leftSpeed rightSpeed background leftProfile rightProfile x τ)
    Set.univ a b hab (by intro x _; trivial)
  filter_upwards [leveque04_variableTwoFanEvolution_eq_ae_of_offFronts
    interface i leftSpeed rightSpeed background leftProfile rightProfile
    candidate τ hoff] with x hx _
  exact hx

end NumStability
