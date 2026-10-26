/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.RiemannChainUniformWindow
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.FiniteRiemannChainAffineEntropy

/-!
# Entropy of an actual bilateral Riemann chain

An actual compatible-window field inherits constituent entropy inequalities
through finite-chain affine-front geometry. Exterior cone bounds construct
a single window uniformly on each closed forward rectangle.
-/

open MeasureTheory
namespace NumStability
theorem bilateralRiemannChain_entropy_rectangle_of_affine_fronts
    {E : Type*} [AddCommGroup E] (states : ℤ → E) (fields : ℤ → ℝ → ℝ → E)
    (leftSpeed rightSpeed : ℤ → ℝ) (origin width bound horizon : ℝ)
    (hwidth : 0 < width) (hbound : 0 ≤ bound)
    (hfinite : ∀ x time, time ∈ Set.Icc 0 horizon →
      ∃ radius, IsRiemannChainWindow states (fun j => fields j x time) radius)
    (hspeeds : ∀ j, -bound ≤ leftSpeed j ∧ leftSpeed j ≤ rightSpeed j ∧ rightSpeed j ≤ bound)
    (hinteraction : ∀ j : ℤ,
      origin + (j : ℝ) * width + rightSpeed j * horizon ≤
        origin + ((j + 1 : ℤ) : ℝ) * width + leftSpeed (j + 1) * horizon)
    (hleft : ∀ (j : ℤ) (x time : ℝ), time ∈ Set.Icc 0 horizon →
      x < origin + (j : ℝ) * width + leftSpeed j * time → fields j x time = states j)
    (hright : ∀ (j : ℤ) (x time : ℝ), time ∈ Set.Icc 0 horizon →
      origin + (j : ℝ) * width + rightSpeed j * time < x → fields j x time = states (j + 1))
    (entropy entropyFlux : E → ℝ) (a b s t : ℝ)
    (hab : a ≤ b) (hst : s ≤ t) (hs : 0 ≤ s) (ht : t ≤ horizon)
    (hspace : ∀ j, ∀ τ ∈ ({s, t} : Set ℝ),
      IntervalIntegrable (fun x => entropy (fields j x τ)) volume a b)
    (hflux : ∀ j, ∀ x ∈ ({a, b} : Set ℝ),
      IntervalIntegrable (fun τ => entropyFlux (fields j x τ)) volume s t)
    (hlocal : ∀ j,
      (∫ x in a..b, entropy (fields j x t)) - (∫ x in a..b, entropy (fields j x s)) ≤
        ∫ τ in s..t, entropyFlux (fields j a τ) - entropyFlux (fields j b τ)) :
    (∫ x in a..b, entropy (bilateralRiemannChainEvolution states fields horizon hfinite x t)) -
      (∫ x in a..b, entropy (bilateralRiemannChainEvolution states fields horizon hfinite x s)) ≤
        ∫ τ in s..t,
          entropyFlux (bilateralRiemannChainEvolution states fields horizon hfinite a τ) -
          entropyFlux (bilateralRiemannChainEvolution states fields horizon hfinite b τ) := by
  have hhorizon : 0 ≤ horizon := hs.trans (hst.trans ht)
  have hcones := riemannChain_uniform_cones_of_affine_fronts states fields leftSpeed rightSpeed
    origin width bound horizon (fun j => ⟨(hspeeds j).1, (hspeeds j).2.2⟩) hleft hright
  obtain ⟨radius, hradius⟩ := riemannChainWindow_exists_uniform_cones states fields
    origin width bound horizon a b hwidth hbound hhorizon hcones.1 hcones.2
  have hp := finiteRiemannChain_entropy_rectangle_of_affine_fronts
    (fun j : ℕ => states ((j : ℤ) - radius))
    (fun j : ℕ => fields ((j : ℤ) - radius))
    (fun j : ℕ => origin + (((j : ℤ) - radius : ℤ) : ℝ) * width)
    (fun j : ℕ => leftSpeed ((j : ℤ) - radius))
    (fun j : ℕ => rightSpeed ((j : ℤ) - radius))
    (2 * radius) entropy entropyFlux a b s t horizon hab hst hs ht
    (by
      intro i j hij hj
      have hij' : (i : ℝ) < (j : ℝ) := by exact_mod_cast hij
      simp only [Int.cast_sub, Int.cast_natCast]
      nlinarith)
    (fun j hj => (hspeeds _).2.1)
    (by
      intro j hj
      simpa only [Nat.cast_add, Nat.cast_one, Int.cast_add, Int.cast_one,
        sub_add_eq_add_sub] using hinteraction ((j : ℤ) - radius))
    (fun j hj x time ht hx => hleft _ x time ht hx)
    (by
      intro j hj x time ht hx
      simpa only [Nat.cast_add, Nat.cast_one, sub_add_eq_add_sub] using
        hright ((j : ℤ) - radius) x time ht hx)
    (fun j hj => hspace _) (fun j hj => hflux _) (fun j hj => hlocal _)
  have heq (x time : ℝ) (hx : x ∈ Set.Icc a b) (htime : time ∈ Set.Icc 0 horizon) :
      bilateralRiemannChainEvolution states fields horizon hfinite x time =
        finiteRiemannChainAssembly (fun j : ℕ => states ((j : ℤ) - radius))
          (fun j : ℕ => fields ((j : ℤ) - radius) x time) (2 * radius) :=
    bilateralRiemannChainEvolution_eq_window states fields horizon hfinite x time htime radius
      (hradius x hx time htime)
  have hspaceeq (time : ℝ) (htime : time ∈ Set.Icc 0 horizon) :
      (∫ x in a..b, entropy (bilateralRiemannChainEvolution states fields horizon hfinite x time)) =
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
  have ht'' : time ∈ Set.Icc 0 horizon := ⟨hs.trans ht'.1, ht'.2.trans ht⟩
  change entropyFlux (bilateralRiemannChainEvolution states fields horizon hfinite a time) -
      entropyFlux (bilateralRiemannChainEvolution states fields horizon hfinite b time) = _
  rw [heq a time ⟨le_refl _, hab⟩ ht'', heq b time ⟨hab, le_refl _⟩ ht'']

end NumStability
