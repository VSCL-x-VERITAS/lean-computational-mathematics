/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Rectangle
import Mathlib.Analysis.Calculus.MeanValue
import Mathlib.Analysis.Calculus.Deriv.Pi
import Mathlib.Topology.Order.IntermediateValue

/-!
# Spatially constant conservation-law solutions

Spatially constant reference solutions are constant in time on a closed
interval, using either an interior classical conservation law with endpoint
continuity or the corresponding rectangle integral balance.
-/

open MeasureTheory

namespace NumStability

/-- A spatially constant classical conservation-law solution is constant on a
closed time interval when the PDE holds in its interior and its reference
trace is continuous up to the endpoints. -/
theorem spatially_constant_conservation_solution_time_constant_on_Icc
    {m : ℕ} (q : ℝ → ℝ → (Fin m → ℝ))
    (physicalFlux : (Fin m → ℝ) → (Fin m → ℝ))
    (a b : ℝ) (hab : a ≤ b)
    (hspatial : ∀ x y t, t ∈ Set.Icc a b → q x t = q y t)
    (hpde : ∀ x t, t ∈ Set.Ioo a b →
      IsConservationLawSolutionAt q physicalFlux x t)
    (hcontinuous : ContinuousOn (fun t => q 0 t) (Set.Icc a b)) :
    ∀ x t, t ∈ Set.Icc a b → q x t = q 0 a := by
  intro x t ht
  by_cases hab' : a = b
  · subst b
    have hta : t = a := by simpa [Set.mem_Icc] using ht
    subst t
    exact hspatial x 0 a ⟨le_rfl, le_rfl⟩
  have hablt : a < b := lt_of_le_of_ne hab hab'
  have href : q 0 a = q 0 t := by
    apply funext
    intro i
    let f : ℝ → ℝ := fun τ => q 0 τ i
    have hfcont : ContinuousOn f (Set.Icc a b) := by
      exact (continuous_apply i).comp_continuousOn hcontinuous
    have hcoord : ∀ τ ∈ Set.Ioo a b, HasDerivAt f 0 τ := by
      intro τ hτ
      obtain ⟨qt, fluxx, hqt, hfluxx, hres⟩ := hpde 0 τ hτ
      have hflux_const : HasDerivAt (fun ξ => physicalFlux (q ξ τ)) 0 0 := by
        convert hasDerivAt_const (0 : ℝ) (physicalFlux (q 0 τ)) using 1
        funext ξ
        exact congrArg physicalFlux (hspatial ξ 0 τ ⟨hτ.1.le, hτ.2.le⟩)
      have hfluxx_zero : fluxx = 0 := hfluxx.unique hflux_const
      have hqt_zero : qt = 0 := by
        have h := hres
        simp [hfluxx_zero] at h
        exact h
      have hpi := (hasDerivAt_pi.mp hqt) i
      simpa [f, hqt_zero] using hpi
    have hderiv_zero : ∀ τ ∈ Set.Ioo a b, deriv f τ = 0 := by
      intro τ hτ
      exact (hcoord τ hτ).deriv
    have hdiff : DifferentiableOn ℝ f (Set.Ioo a b) := by
      intro τ hτ
      exact (hcoord τ hτ).differentiableAt.differentiableWithinAt
    have hmid : (a + b) / 2 ∈ Set.Ioo a b := by
      simp only [Set.mem_Ioo]
      constructor <;> linarith
    have hconst : ∀ u ∈ Set.Ioo a b, ∀ v ∈ Set.Ioo a b, f u = f v := by
      intro u hu v hv
      exact isOpen_Ioo.is_const_of_deriv_eq_zero isPreconnected_Ioo hdiff
        (fun z hz => hderiv_zero z hz) hu hv
    have hclosure : Set.Icc a b ⊆ closure (Set.Ioo a b) := by
      rw [closure_Ioo hab']
    have hendpoint (y : ℝ) (hy : y ∈ Set.Icc a b) :
        f y = f ((a + b) / 2) := by
      have hnear := (hfcont y hy).mono Set.Ioo_subset_Icc_self
      have hEq : Set.EqOn f (fun _ => f ((a + b) / 2)) (Set.Ioo a b) := by
        intro z hz
        exact hconst z hz ((a + b) / 2) hmid
      exact ContinuousWithinAt.eq_const_of_mem_closure hnear (hclosure hy) hEq
    exact (hendpoint a ⟨le_rfl, hab⟩).trans (hendpoint t ht).symm
  have hx0t : q x t = q 0 t := hspatial x 0 t ht
  exact hx0t.trans (funext fun i => (congrFun href i).symm)

/-- Pointwise spatial constancy and integrated conservation on one positive-width
cell force temporal constancy on the selected closed time interval. -/
theorem spatially_constant_integral_balance_time_constant_on_Icc
    {m : ℕ} (q : ℝ → ℝ → (Fin m → ℝ))
    (physicalFlux : (Fin m → ℝ) → (Fin m → ℝ))
    (left right a b : ℝ) (hcell : left < right) (hab : a ≤ b)
    (hspatial : ∀ x t, x ∈ Set.Icc left right → t ∈ Set.Icc a b →
      q x t = q left t)
    (hbalance : ∀ t, t ∈ Set.Icc a b →
      (∫ x in left..right, q x t) - (∫ x in left..right, q x a) =
        ∫ τ in a..t, (physicalFlux (q left τ) - physicalFlux (q right τ))) :
    ∀ x t, x ∈ Set.Icc left right → t ∈ Set.Icc a b →
      q x t = q left a := by
  have hspace (t : ℝ) (ht : t ∈ Set.Icc a b) :
      (∫ x in left..right, q x t) = (right - left) • q left t := by
    calc
      (∫ x in left..right, q x t) = ∫ _ in left..right, q left t := by
        apply intervalIntegral.integral_congr
        intro x hx
        have hx' : x ∈ Set.Icc left right := by
          simpa only [Set.uIcc_of_le hcell.le] using hx
        exact hspatial x t hx' ht
      _ = (right - left) • q left t := by rw [intervalIntegral.integral_const]
  intro x t hx ht
  have hfluxzero :
      (∫ τ in a..t, (physicalFlux (q left τ) - physicalFlux (q right τ))) = 0 := by
    calc
      (∫ τ in a..t, (physicalFlux (q left τ) - physicalFlux (q right τ))) =
          ∫ _ in a..t, (0 : Fin m → ℝ) := by
        apply intervalIntegral.integral_congr
        intro τ hτ
        have hτ' : τ ∈ Set.Icc a b :=
          Set.ordConnected_Icc.uIcc_subset (show a ∈ Set.Icc a b from ⟨le_rfl, hab⟩) ht hτ
        have hright := hspatial right τ ((show right ∈ Set.Icc left right from ⟨hcell.le, le_rfl⟩)) hτ'
        change physicalFlux (q left τ) - physicalFlux (q right τ) = 0
        rw [hright]
        exact sub_self _
      _ = 0 := by simp
  have hbal := hbalance t ht
  rw [hspace t ht, hspace a ((show a ∈ Set.Icc a b from ⟨le_rfl, hab⟩)), hfluxzero] at hbal
  have hleft : q left t = q left a := by
    ext i
    have hi := congrFun hbal i
    simp only [Pi.sub_apply, Pi.smul_apply, smul_eq_mul] at hi
    change (right - left) * q left t i - (right - left) * q left a i = 0 at hi
    have hmul : (right - left) * q left t i = (right - left) * q left a i :=
      sub_eq_zero.mp hi
    exact mul_left_cancel₀ (ne_of_gt (sub_pos.mpr hcell)) hmul
  rw [hspatial x t hx ht, hleft]

end NumStability
