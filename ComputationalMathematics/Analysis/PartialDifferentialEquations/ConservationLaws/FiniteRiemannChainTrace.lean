/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.FiniteRiemannChainGeometry

/-!
# Initial cell mass and interface trace of a finite Riemann chain

Consecutive initial profiles reconstruct the cell state off its endpoints.
The null endpoints do not alter its mass. Nonstrict cone CFL identifies the
actual field with the local profile at every mesh interface during the step.
-/

open MeasureTheory
namespace NumStability

/-- At a mesh interface the actual chain is exactly its local profile
throughout the noninteracting step, including touching-cone CFL equality. -/
theorem finiteRiemannChainAssembly_eq_interface_profile
    {E : Type*} [AddCommGroup E]
    (states : ℕ → E) (fields : ℕ → ℝ → ℝ → E) (count active : ℕ)
    (width bound horizon time : ℝ)
    (hactive : active < count) (hwidth : 0 < width) (hbound : 0 ≤ bound)
    (htime : time ∈ Set.Icc 0 horizon) (hcfl : 2 * bound * horizon ≤ width)
    (hleft : ∀ j < count, ∀ x, x < (j : ℝ) * width - bound * time → fields j x time = states j)
    (hright : ∀ j < count, ∀ x, (j : ℝ) * width + bound * time < x →
      fields j x time = states (j + 1)) :
    finiteRiemannChainAssembly states (fun j => fields j ((active : ℝ) * width) time) count =
      fields active ((active : ℝ) * width) time := by
  apply finiteRiemannChainAssembly_eq_profile states _ count active hactive
  · intro i hi
    have hcast : (i : ℝ) + 1 ≤ (active : ℝ) := by exact_mod_cast (Nat.succ_le_iff.mpr hi)
    have hgap := mul_le_mul_of_nonneg_right hcast hwidth.le
    have hbt := mul_le_mul_of_nonneg_left htime.2 hbound
    exact hright i (by omega) _ (by nlinarith)
  · intro i hi hicount
    have hcast : (active : ℝ) + 1 ≤ (i : ℝ) := by exact_mod_cast (Nat.succ_le_iff.mpr hi)
    have hgap := mul_le_mul_of_nonneg_right hcast hwidth.le
    have hbt := mul_le_mul_of_nonneg_left htime.2 hbound
    exact hleft i hicount _ (by nlinarith)

/-- Consecutive initial Riemann profiles reconstruct the cell state
throughout the open cell, independently of the free interface values. -/
theorem finiteRiemannChainAssembly_initial_eq_cell_state
    {E : Type*} [AddCommGroup E]
    (states profiles : ℕ → E) (count cell : ℕ) (width x : ℝ)
    (hcell : cell < count) (hwidth : 0 < width)
    (hx : x ∈ Set.Ioo ((cell : ℝ) * width) ((cell + 1 : ℕ) * width))
    (hleft : ∀ j < count, x < (j : ℝ) * width → profiles j = states j)
    (hright : ∀ j < count, (j : ℝ) * width < x → profiles j = states (j + 1)) :
    finiteRiemannChainAssembly states profiles count = states (cell + 1) := by
  apply finiteRiemannChainAssembly_eq_state states profiles count (cell + 1) (by omega)
  · intro j hj
    have hcast : (j : ℝ) ≤ (cell : ℝ) := by exact_mod_cast (show j ≤ cell by omega)
    exact hright j (by omega) ((mul_le_mul_of_nonneg_right hcast hwidth.le).trans_lt hx.1)
  · intro j hj hjcount
    have hcast : (cell + 1 : ℕ) ≤ j := hj
    have hcast' : ((cell + 1 : ℕ) : ℝ) ≤ (j : ℝ) := by exact_mod_cast hcast
    exact hleft j hjcount (hx.2.trans_le (mul_le_mul_of_nonneg_right hcast' hwidth.le))

/-- Free initial interface values do not affect the reconstructed cell mass. -/
theorem finiteRiemannChainAssembly_initial_cell_integral
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]
    (states : ℕ → E) (profiles : ℕ → ℝ → E) (count cell : ℕ) (width : ℝ)
    (hcell : cell < count) (hwidth : 0 < width)
    (hleft : ∀ j < count, ∀ x, x < (j : ℝ) * width → profiles j x = states j)
    (hright : ∀ j < count, ∀ x, (j : ℝ) * width < x → profiles j x = states (j + 1)) :
    (∫ x in ((cell : ℝ) * width)..((cell + 1 : ℕ) * width),
      finiteRiemannChainAssembly states (fun j => profiles j x) count) =
        width • states (cell + 1) := by
  have horder : (cell : ℝ) * width < (cell + 1 : ℕ) * width := by
    push_cast
    nlinarith
  have heq : (∫ x in ((cell : ℝ) * width)..((cell + 1 : ℕ) * width),
      finiteRiemannChainAssembly states (fun j => profiles j x) count) =
      ∫ _ in ((cell : ℝ) * width)..((cell + 1 : ℕ) * width), states (cell + 1) := by
    apply intervalIntegral.integral_congr_ae
    filter_upwards [volume.ae_ne ((cell + 1 : ℕ) * width)] with x hne hx
    have hx' : x ∈ Set.Ioc ((cell : ℝ) * width) ((cell + 1 : ℕ) * width) := by
      simpa only [Set.uIoc_of_le horder.le] using hx
    exact finiteRiemannChainAssembly_initial_eq_cell_state states (fun j => profiles j x)
      count cell width x hcell hwidth ⟨hx'.1, lt_of_le_of_ne hx'.2 hne⟩
      (fun j hj => hleft j hj x) (fun j hj => hright j hj x)
  rw [heq, intervalIntegral.integral_const]
  congr 1
  push_cast
  ring

end NumStability
