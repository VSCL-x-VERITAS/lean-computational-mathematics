/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFiniteActionPotentialRegularity
import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFiniteGridREA
import Mathlib.MeasureTheory.Integral.IntervalIntegral.AbsolutelyContinuousFun

/-!
# The actual finite initial datum and its primitive

The initial datum is the supplied left state plus its consecutive jumps, with
the right value at every mesh face. It agrees pointwise with the existing finite
grid reconstruction at time zero. The same initial action primitive has this
datum as derivative away from the finite faces and hence almost everywhere.
Spatial FTC derives the actual initial masses on arbitrary finite intervals.
-/

noncomputable section
open Set MeasureTheory Filter
open scoped BigOperators Topology Interval

namespace NumStability

def leveque04_burgersFiniteActionInitialData {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x : ℝ) : ℝ :=
  leveque04_burgersActionState old 0 +
    ∑ j ∈ Finset.range (N + 1),
      (leveque04_burgersActionState old (j + 1) - leveque04_burgersActionState old j) *
        (if x < leveque04_burgersActionFace origin width j then 0 else 1)

theorem leveque04_burgersFiniteActionInitialData_measurable {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width : ℝ) :
    Measurable (leveque04_burgersFiniteActionInitialData old origin width) := by
  unfold leveque04_burgersFiniteActionInitialData
  apply Measurable.add measurable_const
  apply Finset.measurable_sum
  intro j _
  exact measurable_const.mul (Measurable.ite
    (measurableSet_lt measurable_id measurable_const) measurable_const measurable_const)

theorem leveque04_burgersFiniteActionInitialData_abs_le {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x : ℝ) :
    |leveque04_burgersFiniteActionInitialData old origin width x| ≤
      leveque04_burgersPrimitiveBound old := by
  let q := leveque04_burgersActionState old
  have hterm (j : ℕ) :
      |(q (j + 1) - q j) * (if x < leveque04_burgersActionFace origin width j then 0 else 1)| ≤
        |q (j + 1) - q j| := by
    split_ifs <;> simp
  unfold leveque04_burgersFiniteActionInitialData leveque04_burgersPrimitiveBound
  exact (abs_add_le _ _).trans (add_le_add le_rfl
    ((Finset.abs_sum_le_sum_abs _ _).trans (Finset.sum_le_sum (fun j _ => hterm j))))

/-- The right-represented scalar datum is exactly the existing finite grid
reconstruction at its initial time, including both supplied exterior states. -/
theorem leveque04_burgersFiniteActionInitialData_eq_finiteGridREA {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x : ℝ) :
    (fun _ : Fin 1 => leveque04_burgersFiniteActionInitialData old origin width x) =
      leveque04_burgersFiniteGridREA old origin width x 0 := by
  funext component
  change leveque04_burgersFiniteActionInitialData old origin width x =
    leveque04_burgersFiniteChain (leveque04_burgersActionState old) (N + 1)
      width (x - origin) 0 component
  rw [leveque04_burgersFiniteChain_initial]
  simp only [finiteRiemannChainAssembly, Pi.add_apply, Finset.sum_apply, Pi.sub_apply]
  unfold leveque04_burgersFiniteActionInitialData
  congr 1
  apply Finset.sum_congr rfl
  intro j _
  have hface : x - origin - (j : ℝ) * width = x - leveque04_burgersActionFace origin width j := by
    rw [leveque04_burgersActionFace_eq]
    ring
  rw [hface]
  by_cases hx : x < leveque04_burgersActionFace origin width j
  · simp [riemannData, sub_neg, hx]
  · simp [riemannData, sub_neg, hx]

private theorem hinge_hasDerivAt_away (face x : ℝ) (hx : x ≠ face) :
    HasDerivAt (fun y => max (y - face) 0) (if x < face then 0 else 1) x := by
  by_cases hlt : x < face
  · rw [if_pos hlt]
    apply (hasDerivAt_const x (0 : ℝ)).congr_of_eventuallyEq
    filter_upwards [eventually_lt_nhds hlt] with y hy
    exact max_eq_right (sub_nonpos.mpr hy.le)
  · have hgt : face < x := lt_of_le_of_ne (le_of_not_gt hlt) hx.symm
    rw [if_neg hlt]
    apply ((hasDerivAt_id x).sub_const face).congr_of_eventuallyEq
    filter_upwards [eventually_gt_nhds hgt] with y hy
    exact max_eq_left (sub_nonneg.mpr hy.le)

theorem leveque04_burgersInitialPrimitive_hasDerivAt_initialData {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x : ℝ)
    (hfaces : ∀ j : Fin (N + 1), x ≠ leveque04_burgersActionFace origin width j.val) :
    HasDerivAt (leveque04_burgersInitialPrimitive old origin width)
      (leveque04_burgersFiniteActionInitialData old origin width x) x := by
  have hterm (j : ℕ) (hj : j ∈ Finset.range (N + 1)) :=
    (hinge_hasDerivAt_away (leveque04_burgersActionFace origin width j) x
      (hfaces ⟨j, Finset.mem_range.mp hj⟩)).const_mul
        (leveque04_burgersActionState old (j + 1) - leveque04_burgersActionState old j)
  have hsum := HasDerivAt.sum hterm
  have hbase := ((hasDerivAt_id x).sub_const origin).const_mul (leveque04_burgersActionState old 0)
  change HasDerivAt (fun y : ℝ => leveque04_burgersActionState old 0 * (y - origin))
    (leveque04_burgersActionState old 0 * 1) x at hbase
  have hfun : ((fun y : ℝ => leveque04_burgersActionState old 0 * (y - origin)) +
      ∑ j ∈ Finset.range (N + 1), fun y : ℝ =>
        (leveque04_burgersActionState old (j + 1) - leveque04_burgersActionState old j) *
          max (y - leveque04_burgersActionFace origin width j) 0) =
      leveque04_burgersInitialPrimitive old origin width := by
    funext y
    simp only [Pi.add_apply, Finset.sum_apply, leveque04_burgersInitialPrimitive]
  have hproof := hbase.add hsum
  rw [hfun] at hproof
  simpa only [leveque04_burgersFiniteActionInitialData, mul_one] using hproof

theorem leveque04_burgersInitialPrimitive_ae_hasDerivAt_initialData {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width : ℝ) :
    ∀ᵐ x : ℝ, HasDerivAt (leveque04_burgersInitialPrimitive old origin width)
      (leveque04_burgersFiniteActionInitialData old origin width x) x := by
  have hfaces : ∀ᵐ x : ℝ, ∀ j : Fin (N + 1),
      x ≠ leveque04_burgersActionFace origin width j.val :=
    ae_all_iff.mpr (fun j => volume.ae_ne _)
  exact hfaces.mono (fun x hx =>
    leveque04_burgersInitialPrimitive_hasDerivAt_initialData old origin width x hx)

theorem leveque04_burgersFiniteActionInitialData_spatial_integral {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width left right : ℝ) :
    IntervalIntegrable (leveque04_burgersFiniteActionInitialData old origin width) volume left right ∧
      (∫ x in left..right, leveque04_burgersFiniteActionInitialData old origin width x) =
        leveque04_burgersInitialPrimitive old origin width right -
          leveque04_burgersInitialPrimitive old origin width left := by
  have hlip : LipschitzWith ⟨leveque04_burgersPrimitiveBound old,
      leveque04_burgersPrimitiveBound_nonneg old⟩ (leveque04_burgersInitialPrimitive old origin width) := by
    apply LipschitzWith.of_dist_le_mul
    intro x y
    simpa only [Real.dist_eq, NNReal.coe_mk] using
      leveque04_burgersInitialPrimitive_abs_sub_le old origin width x y
  have hac := hlip.lipschitzOnWith (s := uIcc left right) |>.absolutelyContinuousOnInterval
  have heq : deriv (leveque04_burgersInitialPrimitive old origin width) =ᵐ[volume]
      leveque04_burgersFiniteActionInitialData old origin width := by
    filter_upwards [leveque04_burgersInitialPrimitive_ae_hasDerivAt_initialData old origin width] with x hx
    exact hx.deriv
  refine ⟨hac.intervalIntegrable_deriv.congr_ae (ae_restrict_of_ae heq), ?_⟩
  calc
    _ = ∫ x in left..right, deriv (leveque04_burgersInitialPrimitive old origin width) x :=
      (intervalIntegral.integral_congr_ae (heq.mono (fun _ h _ => h))).symm
    _ = _ := hac.integral_deriv_eq_sub

end NumStability
