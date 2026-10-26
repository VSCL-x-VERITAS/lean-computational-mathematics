/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Logic.Function.Iterate
import Mathlib.Data.Int.Cast.Basic
import Mathlib.Order.Interval.Set.Basic
import Mathlib.Data.Real.Basic
import Mathlib.Tactic

/-!
# Dependence of centered stencil evolution

Time-dependent radius-r updates read at most the initial radius-nr window.
Physically local initialization adds the complete support of each initial cell.
The data and numerical state types may differ.
-/

open Set
namespace NumStability

def centeredStencilEvolution {E : Type*}
    (update : ℕ → (ℤ → E) → ℤ → E) (initial : ℤ → E) : ℕ → ℤ → E
  | 0 => initial
  | k+1 => update k (centeredStencilEvolution update initial k)

theorem centeredStencilEvolution_locality {E : Type*}
    (update : ℕ → (ℤ → E) → ℤ → E) (radius : ℕ)
    (hlocal : ∀ k (left right : ℤ → E) (i : ℤ),
      (∀ j ∈ Icc (i-(radius : ℤ)) (i+(radius : ℤ)), left j = right j) →
        update k left i = update k right i)
    (left right : ℤ → E) (steps : ℕ) (i : ℤ)
    (hagree : ∀ j ∈ Icc (i-(steps : ℤ)*radius) (i+(steps : ℤ)*radius), left j = right j) :
    centeredStencilEvolution update left steps i =
      centeredStencilEvolution update right steps i := by
  induction steps generalizing i with
  | zero => simpa using hagree i (by simp)
  | succ steps ih =>
    simp only [centeredStencilEvolution]
    apply hlocal
    intro k hk
    apply ih
    intro j hj
    apply hagree j
    simp only [mem_Icc,Nat.cast_add,Nat.cast_one,add_mul,one_mul] at hk hj ⊢
    omega

theorem centeredStencilEvolution_localInitialization
    {E F : Type*} (update : ℕ → (ℤ → E) → ℤ → E) (radius : ℕ)
    (initialData : (ℝ → F) → ℤ → E) (center width : ℝ) (hwidth : 0 ≤ width)
    (hlocal : ∀ k (left right : ℤ → E) (i : ℤ),
      (∀ j ∈ Icc (i-(radius : ℤ)) (i+(radius : ℤ)), left j = right j) →
        update k left i = update k right i)
    (left right : ℝ → F) (steps : ℕ) (i : ℤ)
    (hinitial : ∀ j : ℤ,
      EqOn left right (Icc (center+(j : ℝ)*width-width/2)
        (center+(j : ℝ)*width+width/2)) → initialData left j = initialData right j)
    (hagree : EqOn left right (Icc
      (center+(i : ℝ)*width-(steps : ℝ)*radius*width-width/2)
      (center+(i : ℝ)*width+(steps : ℝ)*radius*width+width/2))) :
    centeredStencilEvolution update (initialData left) steps i =
      centeredStencilEvolution update (initialData right) steps i := by
  apply centeredStencilEvolution_locality update radius hlocal
  intro j hj
  apply hinitial
  intro x hx
  have hjl : (i : ℝ)-(steps : ℝ)*radius ≤ (j : ℝ) := by exact_mod_cast hj.1
  have hjr : (j : ℝ) ≤ (i : ℝ)+(steps : ℝ)*radius := by exact_mod_cast hj.2
  have hl := mul_le_mul_of_nonneg_right hjl hwidth
  have hr := mul_le_mul_of_nonneg_right hjr hwidth
  apply hagree
  constructor <;> linarith [hx.1,hx.2]

/-- A constant update sequence agrees with ordinary function iteration. -/
theorem centeredStencilEvolution_const {E : Type*}
    (update : (ℤ → E) → ℤ → E) (initial : ℤ → E) (steps : ℕ) :
    centeredStencilEvolution (fun _ => update) initial steps = update^[steps] initial := by
  induction steps with
  | zero => rfl
  | succ steps ih => simp only [centeredStencilEvolution, ih, Function.iterate_succ_apply']

/-- Autonomous centered-stencil locality is a specialization of time-dependent locality. -/
theorem iterate_eq_of_centeredStencil_locality {E : Type*}
    (update : (ℤ → E) → ℤ → E) (radius : ℕ)
    (hlocal : ∀ (left right : ℤ → E) (i : ℤ),
      (∀ j ∈ Icc (i-(radius : ℤ)) (i+(radius : ℤ)), left j = right j) →
        update left i = update right i)
    (left right : ℤ → E) (steps : ℕ) (i : ℤ)
    (hagree : ∀ j ∈ Icc (i-(steps : ℤ)*radius) (i+(steps : ℤ)*radius), left j = right j) :
    (update^[steps] left) i = (update^[steps] right) i := by
  simpa only [centeredStencilEvolution_const] using
    centeredStencilEvolution_locality (fun _ => update) radius (fun _ => hlocal) left right steps i hagree



/-- Time-indexed three-point callbacks determine each output from the
closed integer window with one site of growth per step. -/
theorem centeredStencilEvolution_threePoint_locality {E : Type*}
    (F : ℕ → ℤ → E → E → E → E)
    (left right : ℤ → E) (steps : ℕ) (i : ℤ)
    (hagree : ∀ j ∈ Set.Icc (i-(steps : ℤ)) (i+(steps : ℤ)),
      left j = right j) :
    centeredStencilEvolution
      (fun k u j => F k j (u (j - 1)) (u j) (u (j + 1))) left steps i =
    centeredStencilEvolution
      (fun k u j => F k j (u (j - 1)) (u j) (u (j + 1))) right steps i := by
  apply centeredStencilEvolution_locality
    (fun k u j => F k j (u (j - 1)) (u j) (u (j + 1))) 1
  · intro k a b j h
    change F k j (a (j - 1)) (a j) (a (j + 1)) =
      F k j (b (j - 1)) (b j) (b (j + 1))
    rw [h (j - 1) (by constructor <;> omega),
      h j (by constructor <;> omega),
      h (j + 1) (by constructor <;> omega)]
  · intro j hj
    apply hagree
    simpa using hj

end NumStability
