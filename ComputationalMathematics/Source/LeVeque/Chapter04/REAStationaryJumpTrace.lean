/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.REAStationaryFrontFlux

/-!
# Stationary jump traces for two-fan REA assembly

At a stationary front, the zero-speed Rankine–Hugoniot relation says
the two traces have equal physical flux. The assembled field and an
exact solution may choose either trace there without changing the
face flux used by rectangle conservation.
-/

namespace NumStability

/-- Two values selected from the traces of a stationary
Rankine–Hugoniot jump have the same physical flux. -/
theorem leveque04_stationaryJump_selectedTraces_flux_eq
    {m : ℕ} (law : OneDimensionalHyperbolicConservationLaw (Fin m))
    (left right a b : Fin m → ℝ)
    (hRH : law.physicalFlux right - law.physicalFlux left =
      (0 : ℝ) • (right - left))
    (ha : a = left ∨ a = right)
    (hb : b = left ∨ b = right) :
    law.physicalFlux a = law.physicalFlux b := by
  have hflux : law.physicalFlux right = law.physicalFlux left := by
    apply sub_eq_zero.mp
    simpa only [zero_smul] using hRH
  rcases ha with rfl | rfl <;> rcases hb with rfl | rfl <;> simp [hflux]

/-- Off-front agreement and stationary Rankine–Hugoniot trace
selection imply rectangle conservation of the assembled two-fan
evolution, including faces that coincide with stationary endpoints. -/
theorem leveque04_variableTwoFanEvolution_rectangleSolution_of_stationaryTraces
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
    (htraces : ∀ x τ,
      ((leftSpeed (i - 1) = 0 ∧ x = interface (i - 1)) ∨
       (rightSpeed (i - 1) = 0 ∧ x = interface (i - 1)) ∨
       (leftSpeed i = 0 ∧ x = interface i) ∨
       (rightSpeed i = 0 ∧ x = interface i)) →
      ∃ left right : Fin m → ℝ,
        (q x τ = left ∨ q x τ = right) ∧
        (leveque04_variableTwoFanEvolution interface i
          leftSpeed rightSpeed background leftProfile rightProfile x τ = left ∨
         leveque04_variableTwoFanEvolution interface i
          leftSpeed rightSpeed background leftProfile rightProfile x τ = right) ∧
        law.physicalFlux right - law.physicalFlux left =
          (0 : ℝ) • (right - left)) :
    IsRectangleConservationLawSolution
      (fun x τ => leveque04_variableTwoFanEvolution interface i
        leftSpeed rightSpeed background leftProfile rightProfile x τ)
      law.physicalFlux := by
  apply leveque04_variableTwoFanEvolution_rectangleSolution_of_stationaryFlux
    law interface i leftSpeed rightSpeed background leftProfile rightProfile
    q hq hoff
  intro x τ hs
  obtain ⟨left, right, hqtrace, hgtrace, hRH⟩ := htraces x τ hs
  exact leveque04_stationaryJump_selectedTraces_flux_eq
    law left right (q x τ)
    (leveque04_variableTwoFanEvolution interface i
      leftSpeed rightSpeed background leftProfile rightProfile x τ)
    hRH hqtrace hgtrace

end NumStability
