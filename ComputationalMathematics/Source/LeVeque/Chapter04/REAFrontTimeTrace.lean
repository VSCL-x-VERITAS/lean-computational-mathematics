/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.REAConservationTransfer
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.MovingFrontTimeNull

/-!
# Time traces of nonstationary REA fronts

At a fixed face, each constant-speed moving fan endpoint has at most
one exceptional time when its front value matters. The rectangle
conservation transfer therefore needs no separate face-flux premise
when all four endpoint speeds are nonzero.
-/

open MeasureTheory

namespace NumStability

/-- A fixed face lies away from all four nonstationary fan endpoints
at almost every time. -/
theorem leveque04_variableTwoFanFronts_ae_not_mem_time
    (interface : ℤ → ℝ) (i : ℤ)
    (leftSpeed rightSpeed : ℤ → ℝ)
    (hll : leftSpeed (i - 1) ≠ 0)
    (hlr : rightSpeed (i - 1) ≠ 0)
    (hrl : leftSpeed i ≠ 0)
    (hrr : rightSpeed i ≠ 0)
    (x : ℝ) :
    ∀ᵐ τ : ℝ ∂volume,
      x ∉ leveque04_variableTwoFanFronts interface i
        leftSpeed rightSpeed τ := by
  have h₁ := affineMovingFront_ae_ne
    (interface (i - 1)) (-leftSpeed (i - 1)) x (neg_ne_zero.mpr hll)
  have h₂ := affineMovingFront_ae_ne
    (interface (i - 1)) (rightSpeed (i - 1)) x hlr
  have h₃ := affineMovingFront_ae_ne
    (interface i) (-leftSpeed i) x (neg_ne_zero.mpr hrl)
  have h₄ := affineMovingFront_ae_ne
    (interface i) (rightSpeed i) x hrr
  filter_upwards [h₁, h₂, h₃, h₄] with τ h₁ h₂ h₃ h₄
  simp only [leveque04_variableTwoFanFronts, Finset.mem_coe,
    Finset.mem_insert, Finset.mem_singleton, not_or]
  constructor
  · simpa only [neg_mul, sub_eq_add_neg] using h₁
  constructor
  · exact h₂
  constructor
  · simpa only [neg_mul, sub_eq_add_neg] using h₃
  · exact h₄

/-- Under nonzero endpoint speeds, off-front agreement with a certified
solution suffices for the glued evolution to satisfy the rectangle law. -/
theorem leveque04_variableTwoFanEvolution_rectangleSolution_of_offFronts
    {m : ℕ}
    (law : OneDimensionalHyperbolicConservationLaw (Fin m))
    (interface : ℤ → ℝ) (i : ℤ)
    (leftSpeed rightSpeed : ℤ → ℝ)
    (background leftProfile rightProfile : ℝ → ℝ → (Fin m → ℝ))
    (q : ℝ → ℝ → (Fin m → ℝ))
    (hll : leftSpeed (i - 1) ≠ 0)
    (hlr : rightSpeed (i - 1) ≠ 0)
    (hrl : leftSpeed i ≠ 0)
    (hrr : rightSpeed i ≠ 0)
    (hq : IsRectangleConservationLawSolution q law.physicalFlux)
    (hoff : ∀ τ x, x ∉ leveque04_variableTwoFanFronts interface i
      leftSpeed rightSpeed τ →
        q x τ = leveque04_variableTwoFanEvolution interface i
          leftSpeed rightSpeed background leftProfile rightProfile x τ) :
    IsRectangleConservationLawSolution
      (fun x τ => leveque04_variableTwoFanEvolution interface i
        leftSpeed rightSpeed background leftProfile rightProfile x τ)
      law.physicalFlux := by
  apply leveque04_variableTwoFanEvolution_rectangleSolution_of_ae
    law interface i leftSpeed rightSpeed background leftProfile rightProfile
    q hq hoff
  intro x
  filter_upwards [leveque04_variableTwoFanFronts_ae_not_mem_time
    interface i leftSpeed rightSpeed hll hlr hrl hrr x] with τ hτ
  rw [hoff τ x hτ]

end NumStability
