/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.FiniteRiemannChainRectangle

/-!
# Finite Riemann-chain entropy with free fronts

Spatial and temporal almost-everywhere profile patterns transport individual entropy inequalities to the actual assembled finite field.
-/

open MeasureTheory
namespace NumStability

/-- Almost-everywhere spatial and temporal profile patterns suffice to
transport entropy inequalities to the actual assembled field. -/
theorem finiteRiemannChain_entropy_rectangle_of_ae_ordered_profiles
    {E : Type*} [AddCommGroup E]
    (states : ℕ → E) (fields : ℕ → ℝ → ℝ → E) (count : ℕ)
    (entropy entropyFlux : E → ℝ) (a b s t : ℝ) (hab : a ≤ b) (hst : s ≤ t)
    (hspacepattern : ∀ τ ∈ ({s, t} : Set ℝ), ∀ᵐ x ∂volume,
      x ∈ Set.Icc a b → IsOrderedFiniteRiemannChain states (fun j => fields j x τ) count)
    (htimepattern : ∀ x ∈ ({a, b} : Set ℝ), ∀ᵐ τ ∂volume,
      τ ∈ Set.Icc s t → IsOrderedFiniteRiemannChain states (fun j => fields j x τ) count)
    (hspace : ∀ j < count, ∀ τ ∈ ({s, t} : Set ℝ),
      IntervalIntegrable (fun x => entropy (fields j x τ)) volume a b)
    (hflux : ∀ j < count, ∀ x ∈ ({a, b} : Set ℝ),
      IntervalIntegrable (fun τ => entropyFlux (fields j x τ)) volume s t)
    (hlocal : ∀ j < count,
      (∫ x in a..b, entropy (fields j x t)) -
        (∫ x in a..b, entropy (fields j x s)) ≤
          ∫ τ in s..t, entropyFlux (fields j a τ) - entropyFlux (fields j b τ)) :
    (∫ x in a..b, entropy (finiteRiemannChainAssembly states (fun j => fields j x t) count)) -
      (∫ x in a..b, entropy (finiteRiemannChainAssembly states (fun j => fields j x s) count)) ≤
        ∫ τ in s..t,
          entropyFlux (finiteRiemannChainAssembly states (fun j => fields j a τ) count) -
          entropyFlux (finiteRiemannChainAssembly states (fun j => fields j b τ) count) := by
  have hmap (f : E → ℝ) (x τ : ℝ)
      (hp : IsOrderedFiniteRiemannChain states (fun j => fields j x τ) count) :
      f (finiteRiemannChainAssembly states (fun j => fields j x τ) count) =
        finiteRiemannChainAssembly (fun j => f (states j)) (fun j => f (fields j x τ)) count := by
    rcases hp with ⟨k, hk, hbefore, hafter⟩ | ⟨k, hk, hbefore, hafter⟩
    · exact finiteRiemannChainAssembly_map_eq_of_state f states (fun j => fields j x τ)
        count k hk hbefore hafter
    · exact finiteRiemannChainAssembly_map_eq_of_profile f states (fun j => fields j x τ)
        count k hk hbefore hafter
  have hmass (τ : ℝ) (hτ : τ ∈ ({s, t} : Set ℝ)) (hτ' : τ ∈ Set.Icc s t) :
      (∫ x in a..b, entropy (finiteRiemannChainAssembly states (fun j => fields j x τ) count)) =
        (b - a) * entropy (states 0) + ∑ j ∈ Finset.range count,
          ((∫ x in a..b, entropy (fields j x τ)) - (b - a) * entropy (states j)) := by
    have heq : ∀ᵐ x ∂volume, x ∈ Set.uIoc a b →
        entropy (finiteRiemannChainAssembly states (fun j => fields j x τ) count) =
        finiteRiemannChainAssembly (fun j => entropy (states j))
          (fun j => entropy (fields j x τ)) count := by
      filter_upwards [hspacepattern τ hτ] with x hp hx
      exact hmap entropy x τ (hp (by
        simpa only [Set.uIcc_of_le hab] using Set.uIoc_subset_uIcc hx))
    rw [intervalIntegral.integral_congr_ae heq]
    dsimp only [finiteRiemannChainAssembly]
    have hint (j : ℕ) (hj : j ∈ Finset.range count) := hspace j (Finset.mem_range.mp hj) τ hτ
    have hsum : IntervalIntegrable (fun x => ∑ j ∈ Finset.range count,
        (entropy (fields j x τ) - entropy (states j))) volume a b := by
      simpa only [Finset.sum_fn] using IntervalIntegrable.sum (Finset.range count)
        (fun j hj => (hint j hj).sub (intervalIntegrable_const (c := entropy (states j))))
    rw [intervalIntegral.integral_add intervalIntegrable_const hsum,
      intervalIntegral.integral_const,
      intervalIntegral.integral_finset_sum (fun j hj => (hint j hj).sub intervalIntegrable_const)]
    simp only [smul_eq_mul]
    congr 1
    apply Finset.sum_congr rfl
    intro j hj
    rw [intervalIntegral.integral_sub (hint j hj) intervalIntegrable_const,
      intervalIntegral.integral_const, smul_eq_mul]
  have hface : ∀ᵐ τ ∂volume, τ ∈ Set.uIcc s t →
      entropyFlux (finiteRiemannChainAssembly states (fun j => fields j a τ) count) -
        entropyFlux (finiteRiemannChainAssembly states (fun j => fields j b τ) count) =
          ∑ j ∈ Finset.range count, (entropyFlux (fields j a τ) - entropyFlux (fields j b τ)) := by
    filter_upwards [htimepattern a (by simp), htimepattern b (by simp)] with τ hpa hpb hτ
    have hτ' : τ ∈ Set.Icc s t := by simpa only [Set.uIcc_of_le hst] using hτ
    rw [hmap entropyFlux a τ (hpa hτ'), hmap entropyFlux b τ (hpb hτ')]
    dsimp only [finiteRiemannChainAssembly]
    rw [add_sub_add_left_eq_sub, ← Finset.sum_sub_distrib]
    apply Finset.sum_congr rfl
    intro j _
    abel
  calc
    _ = ∑ j ∈ Finset.range count,
        ((∫ x in a..b, entropy (fields j x t)) - (∫ x in a..b, entropy (fields j x s))) := by
      rw [hmass t (by simp) ⟨hst, le_rfl⟩, hmass s (by simp) ⟨le_rfl, hst⟩,
        add_sub_add_left_eq_sub, ← Finset.sum_sub_distrib]
      apply Finset.sum_congr rfl
      intro j _
      abel
    _ ≤ ∑ j ∈ Finset.range count,
        (∫ τ in s..t, entropyFlux (fields j a τ) - entropyFlux (fields j b τ)) :=
      Finset.sum_le_sum (fun j hj => hlocal j (Finset.mem_range.mp hj))
    _ = ∫ τ in s..t, ∑ j ∈ Finset.range count,
        (entropyFlux (fields j a τ) - entropyFlux (fields j b τ)) :=
      (intervalIntegral.integral_finset_sum (fun j hj =>
        (hflux j (Finset.mem_range.mp hj) a (by simp)).sub
          (hflux j (Finset.mem_range.mp hj) b (by simp)))).symm
    _ = _ := by
      apply intervalIntegral.integral_congr_ae
      filter_upwards [hface] with τ hp hτ
      exact (hp (Set.uIoc_subset_uIcc hτ)).symm


end NumStability
