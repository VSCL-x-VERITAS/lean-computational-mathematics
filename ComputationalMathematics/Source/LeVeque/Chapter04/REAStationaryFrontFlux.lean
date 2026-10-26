/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.REAFrontTimeTrace

/-!
# Physical-flux traces at stationary REA fan endpoints

A moving front crosses a fixed face only at a null set of times. A
stationary front can remain at that face; for such a front it suffices
to check equality of the physical flux at the face. This separates
the geometric time-null argument from stationary-wave flux selection.
-/

open MeasureTheory

namespace NumStability

/-- Off-front agreement implies rectangle conservation even when fan
endpoints are stationary, provided physical flux agrees at faces
coinciding with each stationary endpoint. -/
theorem leveque04_variableTwoFanEvolution_rectangleSolution_of_stationaryFlux
    {m : ℕ}
    (law : OneDimensionalHyperbolicConservationLaw (Fin m))
    (interface : ℤ → ℝ) (i : ℤ)
    (leftSpeed rightSpeed : ℤ → ℝ)
    (background leftProfile rightProfile : ℝ → ℝ → (Fin m → ℝ))
    (q : ℝ → ℝ → (Fin m → ℝ))
    (hq : IsRectangleConservationLawSolution q law.physicalFlux)
    (hoff : ∀ τ x, x ∉ leveque04_variableTwoFanFronts interface i
      leftSpeed rightSpeed τ →
        q x τ = leveque04_variableTwoFanEvolution interface i
          leftSpeed rightSpeed background leftProfile rightProfile x τ)
    (hstationary : ∀ x τ,
      ((leftSpeed (i - 1) = 0 ∧ x = interface (i - 1)) ∨
       (rightSpeed (i - 1) = 0 ∧ x = interface (i - 1)) ∨
       (leftSpeed i = 0 ∧ x = interface i) ∨
       (rightSpeed i = 0 ∧ x = interface i)) →
      law.physicalFlux (q x τ) =
        law.physicalFlux (leveque04_variableTwoFanEvolution interface i
          leftSpeed rightSpeed background leftProfile rightProfile x τ)) :
    IsRectangleConservationLawSolution
      (fun x τ => leveque04_variableTwoFanEvolution interface i
        leftSpeed rightSpeed background leftProfile rightProfile x τ)
      law.physicalFlux := by
  apply leveque04_variableTwoFanEvolution_rectangleSolution_of_ae
    law interface i leftSpeed rightSpeed background leftProfile rightProfile
    q hq hoff
  intro x
  have h₁ := affineMovingFront_ae_ne_or_stationary
    (interface (i - 1)) (-leftSpeed (i - 1)) x
  have h₂ := affineMovingFront_ae_ne_or_stationary
    (interface (i - 1)) (rightSpeed (i - 1)) x
  have h₃ := affineMovingFront_ae_ne_or_stationary
    (interface i) (-leftSpeed i) x
  have h₄ := affineMovingFront_ae_ne_or_stationary
    (interface i) (rightSpeed i) x
  filter_upwards [h₁, h₂, h₃, h₄] with τ h₁ h₂ h₃ h₄
  by_cases hs :
      (leftSpeed (i - 1) = 0 ∧ x = interface (i - 1)) ∨
      (rightSpeed (i - 1) = 0 ∧ x = interface (i - 1)) ∨
      (leftSpeed i = 0 ∧ x = interface i) ∨
      (rightSpeed i = 0 ∧ x = interface i)
  · exact hstationary x τ hs
  · have hn₁ : x ≠ interface (i - 1) - leftSpeed (i - 1) * τ := by
      rcases h₁ with h | h
      · simpa only [neg_mul, sub_eq_add_neg] using h
      · exfalso
        apply hs
        exact Or.inl ⟨neg_eq_zero.mp h.1, h.2⟩
    have hn₂ : x ≠ interface (i - 1) + rightSpeed (i - 1) * τ := by
      rcases h₂ with h | h
      · exact h
      · exfalso
        apply hs
        exact Or.inr (Or.inl h)
    have hn₃ : x ≠ interface i - leftSpeed i * τ := by
      rcases h₃ with h | h
      · simpa only [neg_mul, sub_eq_add_neg] using h
      · exfalso
        apply hs
        exact Or.inr (Or.inr (Or.inl ⟨neg_eq_zero.mp h.1, h.2⟩))
    have hn₄ : x ≠ interface i + rightSpeed i * τ := by
      rcases h₄ with h | h
      · exact h
      · exfalso
        apply hs
        exact Or.inr (Or.inr (Or.inr h))
    have hnot : x ∉ leveque04_variableTwoFanFronts interface i
        leftSpeed rightSpeed τ := by
      simp only [leveque04_variableTwoFanFronts, Finset.mem_coe,
        Finset.mem_insert, Finset.mem_singleton, not_or]
      exact ⟨hn₁, hn₂, hn₃, hn₄⟩
    rw [hoff τ x hnot]

end NumStability
