/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.FiniteRiemannChain

/-!
# Compatible finite windows of a Riemann chain

Removing remote profiles that have already reached their endpoint states
does not alter the assembled value. These identities use the sole finite
assembly and provide compatibility for constructions through local windows.
-/

namespace NumStability
open scoped BigOperators

/-- Removing profiles already in their right states shifts the same assembly. -/
theorem finiteRiemannChainAssembly_eq_shifted
    {E : Type*} [AddCommGroup E] (states profiles : ℕ → E) (start count : ℕ)
    (hbefore : ∀ j < start, profiles j = states (j + 1)) :
    finiteRiemannChainAssembly states profiles (start + count) =
      finiteRiemannChainAssembly (fun j => states (start + j))
        (fun j => profiles (start + j)) count := by
  have hprefix := finiteRiemannChainAssembly_eq_state states profiles start start
    (le_refl _) hbefore (by intro j hge hlt; omega)
  calc
    finiteRiemannChainAssembly states profiles (start + count) =
        finiteRiemannChainAssembly states profiles start +
          ∑ j ∈ Finset.range count, (profiles (start + j) - states (start + j)) := by
      simp only [finiteRiemannChainAssembly, Finset.sum_range_add]
      abel
    _ = states start + ∑ j ∈ Finset.range count,
        (profiles (start + j) - states (start + j)) := by rw [hprefix]
    _ = _ := by simp [finiteRiemannChainAssembly]

/-- Removing profiles still in their left states leaves the same assembly. -/
theorem finiteRiemannChainAssembly_eq_prefix
    {E : Type*} [AddCommGroup E] (states profiles : ℕ → E) (count total : ℕ)
    (hcount : count ≤ total)
    (hafter : ∀ j, count ≤ j → j < total → profiles j = states j) :
    finiteRiemannChainAssembly states profiles total =
      finiteRiemannChainAssembly states profiles count := by
  obtain ⟨extra, rfl⟩ := Nat.exists_eq_add_of_le hcount
  have htail : (∑ j ∈ Finset.range extra,
      (profiles (count + j) - states (count + j))) = 0 := by
    apply Finset.sum_eq_zero
    intro j hj
    rw [hafter (count + j) (by omega) (by have := Finset.mem_range.mp hj; omega), sub_self]
  simp only [finiteRiemannChainAssembly, Finset.sum_range_add]
  rw [htail, add_zero]

/-- Any consecutive window containing every nonconstant profile gives
exactly the same value through the sole finite-chain assembly. -/
theorem finiteRiemannChainAssembly_eq_window
    {E : Type*} [AddCommGroup E] (states profiles : ℕ → E)
    (start count total : ℕ) (hcount : start + count ≤ total)
    (hbefore : ∀ j < start, profiles j = states (j + 1))
    (hafter : ∀ j, start + count ≤ j → j < total → profiles j = states j) :
    finiteRiemannChainAssembly states profiles total =
      finiteRiemannChainAssembly (fun j => states (start + j))
        (fun j => profiles (start + j)) count := by
  rw [finiteRiemannChainAssembly_eq_prefix states profiles (start + count) total hcount hafter]
  exact finiteRiemannChainAssembly_eq_shifted states profiles start count hbefore

end NumStability
