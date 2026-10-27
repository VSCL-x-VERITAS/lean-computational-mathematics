/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.RiemannChainNoninteractionWindow
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.LocalRectangleCongruence
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.FiniteRiemannChainAffineFronts
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.FiniteRiemannChainAffineEntropy

/-!
# Bilateral conservation and entropy strictly before interaction

The actual compatible-window field inherits constituent physical conservation
and entropy inequalities on every compact step strictly before a comparison
noninteraction horizon. Propagation speeds need no global bound.
-/

open MeasureTheory
namespace NumStability

theorem riemannChain_pointwise_finite_of_noninteraction
    {E : Type*} (states : ℤ → E) (fields : ℤ → ℝ → ℝ → E)
    (leftSpeed rightSpeed : ℤ → ℝ) (origin width horizon step : ℝ)
    (hwidth : 0 < width) (hstep : 0 ≤ step) (hbefore : step < horizon)
    (hspeeds : ∀ j, leftSpeed j ≤ rightSpeed j)
    (hinteraction : ∀ j : ℤ,
      origin + (j : ℝ) * width + rightSpeed j * horizon ≤
        origin + ((j + 1 : ℤ) : ℝ) * width + leftSpeed (j + 1) * horizon)
    (hleft : ∀ (j : ℤ) (x time : ℝ), time ∈ Set.Icc 0 horizon →
      x < origin + (j : ℝ) * width + leftSpeed j * time → fields j x time = states j)
    (hright : ∀ (j : ℤ) (x time : ℝ), time ∈ Set.Icc 0 horizon →
      origin + (j : ℝ) * width + rightSpeed j * time < x → fields j x time = states (j + 1)) :
    ∀ x time, time ∈ Set.Icc 0 step →
      ∃ radius, IsRiemannChainWindow states (fun j => fields j x time) radius := by
  intro x time ht
  obtain ⟨radius, hradius⟩ := riemannChainWindow_exists_of_noninteraction states fields leftSpeed rightSpeed
    origin width horizon step x x hwidth hstep hbefore hspeeds hinteraction hleft hright
  exact ⟨radius, hradius x ⟨le_refl _, le_refl _⟩ time ht⟩

theorem bilateralRiemannChain_rectangleReferenceOn_of_noninteraction
    {m : ℕ} (states : ℤ → Fin m → ℝ) (fields : ℤ → ℝ → ℝ → Fin m → ℝ)
    (leftSpeed rightSpeed : ℤ → ℝ) (origin width horizon step left right : ℝ)
    (flux : (Fin m → ℝ) → Fin m → ℝ)
    (hwidth : 0 < width) (hstep : 0 ≤ step) (hbefore : step < horizon) (hbox : left ≤ right)
    (hfinite : ∀ x time, time ∈ Set.Icc 0 step →
      ∃ radius, IsRiemannChainWindow states (fun j => fields j x time) radius)
    (hspeeds : ∀ j, leftSpeed j ≤ rightSpeed j)
    (hinteraction : ∀ j : ℤ,
      origin + (j : ℝ) * width + rightSpeed j * horizon ≤
        origin + ((j + 1 : ℤ) : ℝ) * width + leftSpeed (j + 1) * horizon)
    (hfields : ∀ j, LocalConservationLaw.RectangleReferenceOn (fields j) flux left right step)
    (hleft : ∀ (j : ℤ) (x time : ℝ), time ∈ Set.Icc 0 horizon →
      x < origin + (j : ℝ) * width + leftSpeed j * time → fields j x time = states j)
    (hright : ∀ (j : ℤ) (x time : ℝ), time ∈ Set.Icc 0 horizon →
      origin + (j : ℝ) * width + rightSpeed j * time < x → fields j x time = states (j + 1)) :
    LocalConservationLaw.RectangleReferenceOn
      (bilateralRiemannChainEvolution states fields step hfinite) flux left right step := by
  obtain ⟨radius, hradius⟩ := riemannChainWindow_exists_of_noninteraction states fields leftSpeed rightSpeed
    origin width horizon step left right hwidth hstep hbefore hspeeds hinteraction hleft hright
  have hstepInteraction := integer_affine_fronts_noninteraction_before_horizon leftSpeed rightSpeed
    origin width horizon step hwidth ⟨hstep, hbefore⟩ hinteraction
  have hlocal := finiteRiemannChain_rectangleReferenceOn_of_affine_fronts
    (fun j : ℕ => states ((j : ℤ) - radius))
    (fun j : ℕ => fields ((j : ℤ) - radius))
    (fun j : ℕ => origin + (((j : ℤ) - radius : ℤ) : ℝ) * width)
    (fun j : ℕ => leftSpeed ((j : ℤ) - radius))
    (fun j : ℕ => rightSpeed ((j : ℤ) - radius))
    (2 * radius) flux left right step hstep
    (by
      intro i j hij hj
      have hij' : (i : ℝ) < (j : ℝ) := by exact_mod_cast hij
      simp only [Int.cast_sub, Int.cast_natCast]
      nlinarith)
    (fun j hj => hspeeds _)
    (by
      intro j hj
      simpa only [Nat.cast_add, Nat.cast_one, Int.cast_add, Int.cast_one,
        sub_add_eq_add_sub] using (hstepInteraction ((j : ℤ) - radius)).le)
    (fun j hj => hfields _)
    (fun j hj x hx time ht hxl => hleft _ x time ⟨ht.1, ht.2.trans hbefore.le⟩ hxl)
    (by
      intro j hj x hx time ht hxr
      simpa only [Nat.cast_add, Nat.cast_one, sub_add_eq_add_sub] using
        hright ((j : ℤ) - radius) x time ⟨ht.1, ht.2.trans hbefore.le⟩ hxr)
  apply LocalConservationLaw.rectangleReferenceOn_congr _ _ flux left right step hbox hstep hlocal
  intro x hx time ht
  exact (bilateralRiemannChainEvolution_eq_window states fields step hfinite x time ht
    radius (hradius x hx time ht)).symm

theorem bilateralRiemannChain_entropy_rectangle_of_noninteraction
    {E : Type*} [AddCommGroup E] (states : ℤ → E) (fields : ℤ → ℝ → ℝ → E)
    (leftSpeed rightSpeed : ℤ → ℝ) (origin width horizon step : ℝ)
    (hwidth : 0 < width) (hstep : 0 ≤ step) (hbefore : step < horizon)
    (hfinite : ∀ x time, time ∈ Set.Icc 0 step →
      ∃ radius, IsRiemannChainWindow states (fun j => fields j x time) radius)
    (hspeeds : ∀ j, leftSpeed j ≤ rightSpeed j)
    (hinteraction : ∀ j : ℤ,
      origin + (j : ℝ) * width + rightSpeed j * horizon ≤
        origin + ((j + 1 : ℤ) : ℝ) * width + leftSpeed (j + 1) * horizon)
    (hleft : ∀ (j : ℤ) (x time : ℝ), time ∈ Set.Icc 0 horizon →
      x < origin + (j : ℝ) * width + leftSpeed j * time → fields j x time = states j)
    (hright : ∀ (j : ℤ) (x time : ℝ), time ∈ Set.Icc 0 horizon →
      origin + (j : ℝ) * width + rightSpeed j * time < x → fields j x time = states (j + 1))
    (entropy entropyFlux : E → ℝ) (a b s t : ℝ)
    (hab : a ≤ b) (hst : s ≤ t) (hs : 0 ≤ s) (ht : t ≤ step)
    (hspace : ∀ j, ∀ τ ∈ ({s, t} : Set ℝ),
      IntervalIntegrable (fun x => entropy (fields j x τ)) volume a b)
    (hflux : ∀ j, ∀ x ∈ ({a, b} : Set ℝ),
      IntervalIntegrable (fun τ => entropyFlux (fields j x τ)) volume s t)
    (hlocal : ∀ j,
      (∫ x in a..b, entropy (fields j x t)) - (∫ x in a..b, entropy (fields j x s)) ≤
        ∫ τ in s..t, entropyFlux (fields j a τ) - entropyFlux (fields j b τ)) :
    (∫ x in a..b, entropy (bilateralRiemannChainEvolution states fields step hfinite x t)) -
      (∫ x in a..b, entropy (bilateralRiemannChainEvolution states fields step hfinite x s)) ≤
        ∫ τ in s..t,
          entropyFlux (bilateralRiemannChainEvolution states fields step hfinite a τ) -
          entropyFlux (bilateralRiemannChainEvolution states fields step hfinite b τ) := by
  obtain ⟨radius, hradius⟩ := riemannChainWindow_exists_of_noninteraction states fields leftSpeed rightSpeed
    origin width horizon step a b hwidth hstep hbefore hspeeds hinteraction hleft hright
  have hstepInteraction := integer_affine_fronts_noninteraction_before_horizon leftSpeed rightSpeed
    origin width horizon step hwidth ⟨hstep, hbefore⟩ hinteraction
  have hp := finiteRiemannChain_entropy_rectangle_of_affine_fronts
    (fun j : ℕ => states ((j : ℤ) - radius))
    (fun j : ℕ => fields ((j : ℤ) - radius))
    (fun j : ℕ => origin + (((j : ℤ) - radius : ℤ) : ℝ) * width)
    (fun j : ℕ => leftSpeed ((j : ℤ) - radius))
    (fun j : ℕ => rightSpeed ((j : ℤ) - radius))
    (2 * radius) entropy entropyFlux a b s t step hab hst hs ht
    (by
      intro i j hij hj
      have hij' : (i : ℝ) < (j : ℝ) := by exact_mod_cast hij
      simp only [Int.cast_sub, Int.cast_natCast]
      nlinarith)
    (fun j hj => hspeeds _)
    (by
      intro j hj
      simpa only [Nat.cast_add, Nat.cast_one, Int.cast_add, Int.cast_one,
        sub_add_eq_add_sub] using (hstepInteraction ((j : ℤ) - radius)).le)
    (fun j hj x time ht hx => hleft _ x time ⟨ht.1, ht.2.trans hbefore.le⟩ hx)
    (by
      intro j hj x time ht hx
      simpa only [Nat.cast_add, Nat.cast_one, sub_add_eq_add_sub] using
        hright ((j : ℤ) - radius) x time ⟨ht.1, ht.2.trans hbefore.le⟩ hx)
    (fun j hj => hspace _) (fun j hj => hflux _) (fun j hj => hlocal _)
  have heq (x time : ℝ) (hx : x ∈ Set.Icc a b) (htime : time ∈ Set.Icc 0 step) :
      bilateralRiemannChainEvolution states fields step hfinite x time =
        finiteRiemannChainAssembly (fun j : ℕ => states ((j : ℤ) - radius))
          (fun j : ℕ => fields ((j : ℤ) - radius) x time) (2 * radius) :=
    bilateralRiemannChainEvolution_eq_window states fields step hfinite x time htime radius
      (hradius x hx time htime)
  have hspaceeq (time : ℝ) (htime : time ∈ Set.Icc 0 step) :
      (∫ x in a..b, entropy (bilateralRiemannChainEvolution states fields step hfinite x time)) =
        ∫ x in a..b, entropy (finiteRiemannChainAssembly
          (fun j : ℕ => states ((j : ℤ) - radius))
          (fun j : ℕ => fields ((j : ℤ) - radius) x time) (2 * radius)) := by
    apply intervalIntegral.integral_congr
    intro x hx
    have hx' : x ∈ Set.Icc a b := by simpa only [Set.uIcc_of_le hab] using hx
    exact congrArg entropy (heq x time hx' htime)
  rw [hspaceeq t ⟨hs.trans hst, ht⟩, hspaceeq s ⟨hs, hst.trans ht⟩]
  convert hp using 1
  apply intervalIntegral.integral_congr
  intro time htime
  have ht' : time ∈ Set.Icc s t := by simpa only [Set.uIcc_of_le hst] using htime
  have ht'' : time ∈ Set.Icc 0 step := ⟨hs.trans ht'.1, ht'.2.trans ht⟩
  change entropyFlux (bilateralRiemannChainEvolution states fields step hfinite a time) -
      entropyFlux (bilateralRiemannChainEvolution states fields step hfinite b time) = _
  rw [heq a time ⟨le_refl _, hab⟩ ht'', heq b time ⟨hab, le_refl _⟩ ht'']

end NumStability