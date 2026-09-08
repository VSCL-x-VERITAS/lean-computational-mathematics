/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter01.Equation04Model
import ComputationalMathematics.Source.LeVeque.Chapter01.AcousticsModes

/-!
# LeVeque Chapter 1, Equation (1.4): acoustic one-way-wave model

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,
printed page 2 (raw PDF page 24), the right-going sound-wave paragraph,
equation (1.4), and its explicit pressure--velocity connection following (1.6).

The scalar transport, positive direction and profile properties are retained
for every positive speed. For every given classical linear acoustic system,
the second part constructs the acoustic variable from its actual pressure and
particle velocity, with sound speed determined by the material parameters.
Positive bulk modulus and density make the square root and division explicit.
The statement concerns this mathematical linear acoustic model; it gives no
empirical approximation bound or nonlinear physical derivation.
-/

namespace NumStability

/-- The complete positive-speed scalar contract, together with the acoustic
realization `w = p + ρ c u`, `c = sqrt (K / ρ)`, for every given classical
pressure--velocity solution with positive material parameters. The profile
derivative hypothesis applies only to the constructed-profile clause; the
given-system clause uses the actual partial derivatives in its certificate. -/
theorem leveque01_equation04_acousticOneWayModel :
    (∀ (c : ℝ), 0 < c →
      leveque01IsHyperbolicMatrix (constantCoefficientScalarMatrix c) ∧
        (∀ x t₁ t₂ : ℝ, t₁ < t₂ → x + c * t₁ < x + c * t₂) ∧
        ∀ {profile : ℝ → ℝ} {profile' : ℝ} (x t : ℝ),
          HasDerivAt profile profile' (x - c * t) →
            leveque01_equation04_oneWayWaveAt
                (travelingWave profile c) c x t ∧
              travelingWave profile c (x + c * t) t = profile x) ∧
      ∀ {bulkModulus density : ℝ}
        (system : LinearAcousticsSolution bulkModulus density),
        0 < bulkModulus → 0 < density →
        ∃ (c : ℝ), c = Real.sqrt (bulkModulus / density) ∧ 0 < c ∧
          ∃ w : ℝ → ℝ → ℝ,
            (∀ x t, w x t = system.pressure x t + density * c * system.velocity x t) ∧
            ∀ x t, leveque01_equation04_oneWayWaveAt w c x t := by
  refine ⟨fun c hc => leveque01_equation04_scalarHyperbolicOneWayModel c hc, ?_⟩
  intro bulkModulus density system hbulkModulus hdensity
  have hacoustic := leveque01_acousticsRightMode system hbulkModulus hdensity
  exact ⟨Real.sqrt (bulkModulus / density), rfl, hacoustic.1,
    linearAcousticsRightInvariant system.pressure system.velocity density
      (Real.sqrt (bulkModulus / density)), fun _ _ => rfl, hacoustic.2⟩

end NumStability
