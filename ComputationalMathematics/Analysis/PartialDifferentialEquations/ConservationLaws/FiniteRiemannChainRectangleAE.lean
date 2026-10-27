/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.FiniteRiemannChain
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.LocalRectangleReference

open MeasureTheory
open NumStability.LocalConservationLaw
/-!
# Almost-everywhere face flux conservation of a finite Riemann chain

Local nonlinear conservation of an actual finite chain from individual local references and physical flux identity almost everywhere in time at each face.
-/

namespace NumStability
variable {m : ℕ}
local notation "State" => Fin m → ℝ

private theorem reference_space_integrable
    (q : ℝ → ℝ → State) (flux : State → State) (left right horizon : ℝ)
    (hq : RectangleReferenceOn q flux left right horizon)
    (a b time : ℝ) (ha : a ∈ Set.Icc left right) (hb : b ∈ Set.Icc left right)
    (ht : time ∈ Set.Icc 0 horizon) :
    IntervalIntegrable (fun x => q x time) volume a b := by
  exact (hq.1 time ht).mono_set
    (Set.uIcc_subset_uIcc (Set.Icc_subset_uIcc ha) (Set.Icc_subset_uIcc hb))

private theorem reference_flux_integrable
    (q : ℝ → ℝ → State) (flux : State → State) (left right horizon : ℝ)
    (hq : RectangleReferenceOn q flux left right horizon)
    (x s t : ℝ) (hx : x ∈ Set.Icc left right)
    (hs : s ∈ Set.Icc 0 horizon) (ht : t ∈ Set.Icc 0 horizon) :
    IntervalIntegrable (fun τ => flux (q x τ)) volume s t := by
  exact (hq.2.1 x hx).mono_set
    (Set.uIcc_subset_uIcc (Set.Icc_subset_uIcc hs) (Set.Icc_subset_uIcc ht))

/-- The actual constructed chain conserves the physical flux when its
range has the telescoping physical-flux identity almost everywhere in time
at each face of the forward box. -/
theorem finiteRiemannChain_rectangleReferenceOn_of_flux_eq_ae_time
    (states : ℕ → State) (fields : ℕ → ℝ → ℝ → State) (count : ℕ)
    (flux : State → State) (left right horizon : ℝ) (horizon_nonneg : 0 ≤ horizon)
    (hfields : ∀ j < count, RectangleReferenceOn (fields j) flux left right horizon)
    (hflux : ∀ x ∈ Set.Icc left right, ∀ᵐ t ∂volume, t ∈ Set.Icc 0 horizon →
      flux (finiteRiemannChainAssembly states (fun j => fields j x t) count) =
        finiteRiemannChainAssembly (fun j => flux (states j))
          (fun j => flux (fields j x t)) count) :
    RectangleReferenceOn
      (fun x t => finiteRiemannChainAssembly states (fun j => fields j x t) count)
      flux left right horizon := by
  refine ⟨?_, ?_, ?_⟩
  · intro time ht
    simpa only [finiteRiemannChainAssembly, Finset.sum_fn] using
      (intervalIntegrable_const (c := states 0)).add (IntervalIntegrable.sum (Finset.range count)
        (fun j hj => ((hfields j (Finset.mem_range.mp hj)).1 time ht).sub
          (intervalIntegrable_const (c := states j))))
  · intro x hx
    have h : IntervalIntegrable (fun τ => finiteRiemannChainAssembly
        (fun j => flux (states j)) (fun j => flux (fields j x τ)) count) volume 0 horizon := by
      simpa only [finiteRiemannChainAssembly, Finset.sum_fn] using
        (intervalIntegrable_const (c := flux (states 0))).add (IntervalIntegrable.sum (Finset.range count)
          (fun j hj => ((hfields j (Finset.mem_range.mp hj)).2.1 x hx).sub
            (intervalIntegrable_const (c := flux (states j)))))
    apply h.congr_ae
    filter_upwards [ae_restrict_of_ae (hflux x hx), ae_restrict_mem measurableSet_uIoc] with t ht hmem
    have ht' : t ∈ Set.Icc 0 horizon := by
      simpa only [Set.uIcc_of_le horizon_nonneg] using Set.uIoc_subset_uIcc hmem
    exact (ht ht').symm
  · intro a ha b hb s hs t ht
    have hspace (j : ℕ) (hj : j ∈ Finset.range count) (τ : ℝ) (hτ : τ ∈ Set.Icc 0 horizon) :=
      reference_space_integrable (fields j) flux left right horizon
        (hfields j (Finset.mem_range.mp hj)) a b τ ha hb hτ
    have htime (j : ℕ) (hj : j ∈ Finset.range count) (x : ℝ) (hx : x ∈ Set.Icc left right) :=
      reference_flux_integrable (fields j) flux left right horizon
        (hfields j (Finset.mem_range.mp hj)) x s t hx hs ht
    have hmass (τ : ℝ) (hτ : τ ∈ Set.Icc 0 horizon) :
        (∫ x in a..b, finiteRiemannChainAssembly states (fun j => fields j x τ) count) =
          (b - a) • states 0 + ∑ j ∈ Finset.range count,
            ((∫ x in a..b, fields j x τ) - (b - a) • states j) := by
      dsimp only [finiteRiemannChainAssembly]
      have hsum : IntervalIntegrable (fun x => ∑ j ∈ Finset.range count,
          (fields j x τ - states j)) volume a b := by
        simpa only [Finset.sum_fn] using IntervalIntegrable.sum (Finset.range count)
          (fun j hj => (hspace j hj τ hτ).sub (intervalIntegrable_const (c := states j)))
      rw [intervalIntegral.integral_add intervalIntegrable_const hsum,
        intervalIntegral.integral_const,
        intervalIntegral.integral_finset_sum (fun j hj => (hspace j hj τ hτ).sub intervalIntegrable_const)]
      congr 1
      apply Finset.sum_congr rfl
      intro j hj
      rw [intervalIntegral.integral_sub (hspace j hj τ hτ) intervalIntegrable_const,
        intervalIntegral.integral_const]
    have hface : ∀ᵐ τ ∂volume, τ ∈ Set.uIoc s t →
        flux (finiteRiemannChainAssembly states (fun j => fields j a τ) count) -
          flux (finiteRiemannChainAssembly states (fun j => fields j b τ) count) =
            ∑ j ∈ Finset.range count, (flux (fields j a τ) - flux (fields j b τ)) := by
      filter_upwards [hflux a ha, hflux b hb] with τ hfluxa hfluxb hτ
      have hτ' : τ ∈ Set.Icc 0 horizon := by
        have hsub := Set.uIcc_subset_uIcc (Set.Icc_subset_uIcc hs) (Set.Icc_subset_uIcc ht)
        simpa only [Set.uIcc_of_le horizon_nonneg] using hsub (Set.uIoc_subset_uIcc hτ)
      rw [hfluxa hτ', hfluxb hτ']
      dsimp only [finiteRiemannChainAssembly]
      rw [add_sub_add_left_eq_sub, ← Finset.sum_sub_distrib]
      apply Finset.sum_congr rfl
      intro j _
      abel
    calc
      _ = ∑ j ∈ Finset.range count,
          ((∫ x in a..b, fields j x t) - (∫ x in a..b, fields j x s)) := by
        rw [hmass t ht, hmass s hs, add_sub_add_left_eq_sub, ← Finset.sum_sub_distrib]
        apply Finset.sum_congr rfl
        intro j _
        abel
      _ = ∑ j ∈ Finset.range count,
          (∫ τ in s..t, flux (fields j a τ) - flux (fields j b τ)) :=
        Finset.sum_congr rfl (fun j hj =>
          (hfields j (Finset.mem_range.mp hj)).2.2 a ha b hb s hs t ht)
      _ = ∫ τ in s..t, ∑ j ∈ Finset.range count,
          (flux (fields j a τ) - flux (fields j b τ)) :=
        (intervalIntegral.integral_finset_sum
          (fun j hj => (htime j hj a ha).sub (htime j hj b hb))).symm
      _ = _ := by
        apply intervalIntegral.integral_congr_ae
        filter_upwards [hface] with τ hτ hmem
        exact (hτ hmem).symm


end NumStability
