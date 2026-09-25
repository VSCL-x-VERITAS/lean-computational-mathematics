/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.ClassicalCharacteristics
import Mathlib.Analysis.Calculus.MeanValue

/-!
# Local classical transport along a positive-speed pipe characteristic
-/

open Set

namespace NumStability

/-- A classical solution of constant-speed advection is constant on every
backward characteristic segment from an interior point to the initial line or
the left boundary. Continuity reaches the segment endpoint on the boundary. -/
theorem positivePipeCharacteristicOfPDE
    (field : ℝ → ℝ → ℝ) (left right speed initialTime x time s : ℝ)
    (hspeed : 0 < speed) (hxright : x < right)
    (hsinitial : initialTime ≤ s) (hst : s ≤ time)
    (hsource : left ≤ x - speed * (time - s))
    (hcont : ContinuousOn (Function.uncurry field)
      (Set.prod (Icc left right) (Ici initialTime)))
    (hdiff : DifferentiableOn ℝ (Function.uncurry field)
      (Set.prod (Ioo left right) (Ioi initialTime)))
    (hpde : ∀ y r, left < y → y < right → initialTime < r →
      IsLinearAdvectionSolutionAt field speed y r) :
    field x time = field (x - speed * (time - s)) s := by
  by_cases heq : s = time
  · simp [heq]
  have hslt : s < time := lt_of_le_of_ne hst heq
  let origin := x - speed * time
  let f : ℝ → ℝ := fun r => field (origin + speed * r) r
  have hstart : left ≤ origin + speed * s := by
    dsimp [origin]
    nlinarith [hsource]
  have hend : origin + speed * time = x := by dsimp [origin]; ring
  have hcurve : Continuous (fun r : ℝ => (origin + speed * r, r)) := by fun_prop
  have hmap : Set.MapsTo (fun r : ℝ => (origin + speed * r, r))
      (Icc s time) (Set.prod (Icc left right) (Ici initialTime)) := by
    intro r hr
    have hnonneg : 0 ≤ speed * (r - s) :=
      mul_nonneg (le_of_lt hspeed) (sub_nonneg.mpr hr.1)
    have hnonneg' : 0 ≤ speed * (time - r) :=
      mul_nonneg (le_of_lt hspeed) (sub_nonneg.mpr hr.2)
    constructor
    · constructor
      · nlinarith [hstart]
      · nlinarith [hend, hxright]
    · exact le_trans hsinitial hr.1
  have hfcont : ContinuousOn f (Icc s time) :=
    hcont.comp hcurve.continuousOn hmap
  have hfderiv (r : ℝ) (hr : r ∈ Ioo s time) : HasDerivAt f 0 r := by
    have hpositive : 0 < speed * (r - s) :=
      mul_pos hspeed (sub_pos.mpr hr.1)
    have hpositive' : 0 < speed * (time - r) :=
      mul_pos hspeed (sub_pos.mpr hr.2)
    have hy_left : left < origin + speed * r := by nlinarith [hstart]
    have hy_right : origin + speed * r < right := by
      nlinarith [hend, hxright]
    have hrtime : initialTime < r := lt_of_le_of_lt hsinitial hr.1
    have hmem : (origin + speed * r, r) ∈
        Set.prod (Ioo left right) (Ioi initialTime) :=
      ⟨⟨hy_left, hy_right⟩, hrtime⟩
    have hopen : IsOpen (Set.prod (Ioo left right) (Ioi initialTime)) :=
      isOpen_Ioo.prod isOpen_Ioi
    have hjoint : DifferentiableAt ℝ (Function.uncurry field)
        (origin + speed * r, r) :=
      (hdiff _ hmem).differentiableAt (hopen.mem_nhds hmem)
    exact linearAdvection_hasDerivAt_characteristic hjoint
      (hpde _ _ hy_left hy_right hrtime)
  obtain ⟨c, hc⟩ := isOpen_Ioo.exists_is_const_of_deriv_eq_zero isPreconnected_Ioo
    (fun r hr => (hfderiv r hr).differentiableAt.differentiableWithinAt)
    (fun r hr => (hfderiv r hr).deriv)
  have hext : EqOn f (fun _ => c) (Icc s time) :=
    (show EqOn f (fun _ => c) (Ioo s time) from hc).of_subset_closure
      hfcont continuousOn_const Ioo_subset_Icc_self
      (by rw [closure_Ioo (ne_of_lt hslt)])
  have hvalue := (hext (right_mem_Icc.mpr hst)).trans
    (hext (left_mem_Icc.mpr hst)).symm
  change field (origin + speed * time) time = field (origin + speed * s) s at hvalue
  rw [hend] at hvalue
  convert hvalue using 1
  congr 1
  dsimp [origin]
  ring

end NumStability
