/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Tactic.Abel

/-!
# Ordered finite Riemann-chain identities

When all profiles before one active piece equal their right endpoints and
all later profiles equal their left endpoints, a sum of increments selects
that piece. Applying an arbitrary nonlinear map gives the same telescoping
identity for physical or entropy fluxes without global additivity.
-/

namespace NumStability

/-- Assemble a finite consecutive chain by increments from its left states. -/
def finiteRiemannChainAssembly {E : Type*} [AddCommGroup E]
    (states profiles : ℕ → E) (count : ℕ) : E :=
  states 0 + ∑ j ∈ Finset.range count, (profiles j - states j)

/-- In a gap between ordered profiles, the chain selects the background state. -/
theorem finiteRiemannChainAssembly_eq_state
    {E : Type*} [AddCommGroup E] (states profiles : ℕ → E) (count k : ℕ)
    (hk : k ≤ count)
    (hbefore : ∀ j < k, profiles j = states (j + 1))
    (hafter : ∀ j, k ≤ j → j < count → profiles j = states j) :
    finiteRiemannChainAssembly states profiles count = states k := by
  induction count generalizing k with
  | zero =>
      have hk0 : k = 0 := by omega
      subst k
      simp [finiteRiemannChainAssembly]
  | succ count ih =>
      by_cases hkc : k ≤ count
      · have htail := hafter count hkc (Nat.lt_succ_self _)
        have hp := ih k hkc hbefore (fun j hj hcount => hafter j hj (by omega))
        simp only [finiteRiemannChainAssembly, Finset.sum_range_succ] at ⊢ hp
        rw [htail, sub_self, add_zero]
        exact hp
      · have hkeq : k = count + 1 := by omega
        subst k
        have hsum : (∑ j ∈ Finset.range (count + 1), (profiles j - states j)) =
            states (count + 1) - states 0 := by
          calc
            _ = ∑ j ∈ Finset.range (count + 1), (states (j + 1) - states j) :=
              Finset.sum_congr rfl (fun j hj => by rw [hbefore j (Finset.mem_range.mp hj)])
            _ = _ := Finset.sum_range_sub states (count + 1)
        rw [finiteRiemannChainAssembly, hsum]
        abel

/-- Inside one active profile, the same finite chain selects its actual value. -/
theorem finiteRiemannChainAssembly_eq_profile
    {E : Type*} [AddCommGroup E] (states profiles : ℕ → E) (count k : ℕ)
    (hk : k < count)
    (hbefore : ∀ j < k, profiles j = states (j + 1))
    (hafter : ∀ j, k < j → j < count → profiles j = states j) :
    finiteRiemannChainAssembly states profiles count = profiles k := by
  induction count generalizing k with
  | zero => omega
  | succ count ih =>
      by_cases hkc : k < count
      · have htail := hafter count hkc (Nat.lt_succ_self _)
        have hp := ih k hkc hbefore (fun j hj hcount => hafter j hj (by omega))
        simp only [finiteRiemannChainAssembly, Finset.sum_range_succ] at ⊢ hp
        rw [htail, sub_self, add_zero]
        exact hp
      · have hkeq : k = count := by omega
        subst k
        have hsum : (∑ j ∈ Finset.range count, (profiles j - states j)) =
            states count - states 0 := by
          calc
            _ = ∑ j ∈ Finset.range count, (states (j + 1) - states j) :=
              Finset.sum_congr rfl (fun j hj => by rw [hbefore j (Finset.mem_range.mp hj)])
            _ = _ := Finset.sum_range_sub states count
        simp only [finiteRiemannChainAssembly, Finset.sum_range_succ]
        rw [hsum]
        abel

/-- Any nonlinear map commutes with the assembled chain on an active-piece
pattern. This identity is along the actual range, not global additivity. -/
theorem finiteRiemannChainAssembly_map_eq_of_profile
    {E F : Type*} [AddCommGroup E] [AddCommGroup F]
    (map : E → F) (states profiles : ℕ → E) (count k : ℕ)
    (hk : k < count)
    (hbefore : ∀ j < k, profiles j = states (j + 1))
    (hafter : ∀ j, k < j → j < count → profiles j = states j) :
    map (finiteRiemannChainAssembly states profiles count) =
      finiteRiemannChainAssembly (fun j => map (states j)) (fun j => map (profiles j)) count := by
  rw [finiteRiemannChainAssembly_eq_profile states profiles count k hk hbefore hafter,
    finiteRiemannChainAssembly_eq_profile (fun j => map (states j)) (fun j => map (profiles j))
      count k hk (fun j hj => congrArg map (hbefore j hj))
      (fun j hj hcount => congrArg map (hafter j hj hcount))]

/-- The same nonlinear-map identity holds on a background gap pattern. -/
theorem finiteRiemannChainAssembly_map_eq_of_state
    {E F : Type*} [AddCommGroup E] [AddCommGroup F]
    (map : E → F) (states profiles : ℕ → E) (count k : ℕ)
    (hk : k ≤ count)
    (hbefore : ∀ j < k, profiles j = states (j + 1))
    (hafter : ∀ j, k ≤ j → j < count → profiles j = states j) :
    map (finiteRiemannChainAssembly states profiles count) =
      finiteRiemannChainAssembly (fun j => map (states j)) (fun j => map (profiles j)) count := by
  rw [finiteRiemannChainAssembly_eq_state states profiles count k hk hbefore hafter,
    finiteRiemannChainAssembly_eq_state (fun j => map (states j)) (fun j => map (profiles j))
      count k hk (fun j hj => congrArg map (hbefore j hj))
      (fun j hj hcount => congrArg map (hafter j hj hcount))]

end NumStability
