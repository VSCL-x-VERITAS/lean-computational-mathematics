/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.RiemannChainUniformWindow
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.LocalRectangleCongruence
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.FiniteRiemannChainAffineFronts

/-!
# Local conservation for an actual bilateral Riemann chain

Compatible finite windows construct the bilateral field. Uniformly bounded asymmetric speeds and adjacent-wave noninteraction transfer constituent physical conservation through the existing finite-chain producer.
-/

namespace NumStability

theorem bilateralRiemannChain_rectangleReferenceOn_of_affine_fronts
    {m : ℕ} (states : ℤ → Fin m → ℝ) (fields : ℤ → ℝ → ℝ → Fin m → ℝ)
    (leftSpeed rightSpeed : ℤ → ℝ)
    (origin width bound horizon left right : ℝ)
    (flux : (Fin m → ℝ) → Fin m → ℝ)
    (hwidth : 0 < width) (hbound : 0 ≤ bound) (hhorizon : 0 ≤ horizon)
    (hbox : left ≤ right)
    (hfinite : ∀ x time, time ∈ Set.Icc 0 horizon →
      ∃ radius, IsRiemannChainWindow states (fun j => fields j x time) radius)
    (hspeeds : ∀ j, -bound ≤ leftSpeed j ∧ leftSpeed j ≤ rightSpeed j ∧ rightSpeed j ≤ bound)
    (hinteraction : ∀ j : ℤ,
      origin + (j : ℝ) * width + rightSpeed j * horizon ≤
        origin + ((j + 1 : ℤ) : ℝ) * width + leftSpeed (j + 1) * horizon)
    (hfields : ∀ j, LocalConservationLaw.RectangleReferenceOn (fields j) flux left right horizon)
    (hleft : ∀ (j : ℤ) (x time : ℝ), time ∈ Set.Icc 0 horizon →
      x < origin + (j : ℝ) * width + leftSpeed j * time → fields j x time = states j)
    (hright : ∀ (j : ℤ) (x time : ℝ), time ∈ Set.Icc 0 horizon →
      origin + (j : ℝ) * width + rightSpeed j * time < x → fields j x time = states (j + 1)) :
    LocalConservationLaw.RectangleReferenceOn
      (bilateralRiemannChainEvolution states fields horizon hfinite) flux left right horizon := by
  have hcones := riemannChain_uniform_cones_of_affine_fronts states fields leftSpeed rightSpeed
    origin width bound horizon (fun j => ⟨(hspeeds j).1, (hspeeds j).2.2⟩) hleft hright
  obtain ⟨radius, hradius⟩ := riemannChainWindow_exists_uniform_cones states fields
    origin width bound horizon left right hwidth hbound hhorizon hcones.1 hcones.2
  have hlocal := finiteRiemannChain_rectangleReferenceOn_of_affine_fronts
    (fun j : ℕ => states ((j : ℤ) - radius))
    (fun j : ℕ => fields ((j : ℤ) - radius))
    (fun j : ℕ => origin + (((j : ℤ) - radius : ℤ) : ℝ) * width)
    (fun j : ℕ => leftSpeed ((j : ℤ) - radius))
    (fun j : ℕ => rightSpeed ((j : ℤ) - radius))
    (2 * radius) flux left right horizon hhorizon
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
    (fun j hj => hfields _)
    (fun j hj x hx time ht hxl => hleft _ x time ht hxl)
    (by
      intro j hj x hx time ht hxr
      simpa only [Nat.cast_add, Nat.cast_one, sub_add_eq_add_sub] using
        hright ((j : ℤ) - radius) x time ht hxr)
  apply LocalConservationLaw.rectangleReferenceOn_congr _ _ flux left right horizon hbox hhorizon hlocal
  intro x hx time ht
  exact (bilateralRiemannChainEvolution_eq_window states fields horizon hfinite x time ht
    radius (hradius x hx time ht)).symm

end NumStability
