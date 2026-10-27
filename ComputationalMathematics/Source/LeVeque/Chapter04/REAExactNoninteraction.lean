/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.REAAcousticCauchyIdentification
import ComputationalMathematics.Source.LeVeque.Chapter04.REAAcousticHalfCFL
import ComputationalMathematics.Source.LeVeque.Chapter04.REALinearCauchyWindow

/-!
# The noninteracting linear REA construction

The actual Riemann assembly is identified with the independent characteristic
Cauchy field, and averaging preserves that identity. The source-facing domain
orders every pair of active fronts, including fronts separated by inactive
interfaces. The acoustic half-cell condition includes endpoint contact.
-/

open MeasureTheory
namespace NumStability

/-- The Chapter4 linear reconstruct-evolve-average construction on its
noninteraction domain, together with the printed acoustic half-cell condition. -/
theorem leveque04_rea_noninteractingLinearConstruction :
  (∀ {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ)) (speeds : Fin m → ℝ)
    (_heigen : ∀ p, coefficient.mulVec (basis p) = speeds p • basis p)
    (states : ℤ → Fin m → ℝ) (origin width horizon : ℝ)
    (hwidth : 0 < width) (hhorizon : 0 ≤ horizon)
    (_hnoninteraction : ∀ (j k : ℤ) (_hjk : j < k) (p q : Fin m),
      basis.equivFun (states j) p ≠ basis.equivFun (states (j + 1)) p →
      basis.equivFun (states k) q ≠ basis.equivFun (states (k + 1)) q →
      origin + (j : ℝ) * width + speeds p * horizon ≤
        origin + (k : ℝ) * width + speeds q * horizon),
    let initial := leveque04_uniformReconstruction origin width states
    let exact := linearCharacteristicEvolution basis speeds initial
    (∀ x, exact x 0 = initial x) ∧
      IsRectangleConservationLawSolution exact coefficient.mulVec ∧
      (∀ time ∈ Set.Icc 0 horizon, ∀ x,
        linearRiemannChainEvolution basis speeds states origin width horizon
          hwidth hhorizon x time = exact x time) ∧
      ∀ cell : ℤ,
        oneDimensionalCellAverage
          (fun x => linearRiemannChainEvolution basis speeds states origin width horizon
            hwidth hhorizon x horizon)
          (origin + (cell : ℝ) * width) (origin + ((cell + 1 : ℤ) : ℝ) * width) =
        oneDimensionalCellAverage (fun x => exact x horizon)
          (origin + (cell : ℝ) * width) (origin + ((cell + 1 : ℤ) : ℝ) * width)) ∧
  (∀ (density soundSpeed : ℝ)
    (hdensity : 0 < density) (hsound : 0 < soundSpeed)
    (states : ℤ → Fin 2 → ℝ) (origin width step : ℝ)
    (hwidth : 0 < width) (hstep : 0 < step),
    let himpedance : acousticImpedance density soundSpeed ≠ 0 :=
      ne_of_gt (show 0 < acousticImpedance density soundSpeed from mul_pos hdensity hsound)
    (soundSpeed * step / width ≤ 1 / 2 ↔
      ∀ j : ℤ,
        origin + (j : ℝ) * width + leveque04_acousticSpeeds 0 soundSpeed 1 * step ≤
          origin + ((j + 1 : ℤ) : ℝ) * width +
            leveque04_acousticSpeeds 0 soundSpeed 0 * step) ∧
    ∀ hcfl : soundSpeed * step / width ≤ 1 / 2, ∀ time ∈ Set.Icc 0 step,
      (fun x => leveque04_acousticREAClosedEvolution density soundSpeed himpedance
        states origin width step hwidth hsound.le hstep.le hcfl x time) =ᵐ[volume]
      (fun x => linearCharacteristicEvolution
        (leveque04_acousticEigenbasis density soundSpeed himpedance)
        (leveque04_acousticSpeeds 0 soundSpeed)
        (leveque04_uniformReconstruction origin width states) x time)) := by
  constructor
  · intro m coefficient basis speeds heigen states origin width horizon hwidth hhorizon
      _hnoninteraction
    dsimp only
    have h := leveque04_linearRiemannChain_exactCauchy coefficient basis speeds heigen
      states origin width horizon hwidth hhorizon
    dsimp only at h
    refine ⟨h.1, h.2.1, h.2.2, ?_⟩
    intro cell
    congr 1
    funext x
    exact h.2.2 horizon ⟨hhorizon, le_rfl⟩ x
  · intro density soundSpeed hdensity hsound states origin width step hwidth hstep
    dsimp only
    refine ⟨leveque04_acousticHalfCFL_iff_adjacentFrontsOrdered
      soundSpeed width step origin hsound.le hwidth hstep.le, ?_⟩
    intro hcfl time htime
    exact leveque04_acousticREA_eq_characteristicCauchy_ae density soundSpeed
      (ne_of_gt (show 0 < acousticImpedance density soundSpeed from mul_pos hdensity hsound))
      states origin width step hwidth hsound.le hstep.le hcfl time htime

end NumStability
