/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.MaxwellPlaneWaveSpeedTarget

/-!
# Proof-free target: the unqualified light-speed comparison

The printed formulas (2.119) and (2.120) determine speeds from products of
positive scalar material coefficients. The subsequent assertion that every
other medium is slower than vacuum has no product inequality hypothesis.
-/

namespace NumStability.Leveque02Tracer

/-- A distinct medium with positive material parameters can have a strictly
larger speed than the displayed vacuum reference. -/
def lightMediumComparisonCounterexampleTarget : Prop :=
  ∀ (vacuumPermittivity vacuumPermeability : ℝ),
    0 < vacuumPermittivity → 0 < vacuumPermeability →
      let mediumPermittivity : ℝ := vacuumPermittivity / 4
      let mediumPermeability : ℝ := vacuumPermeability
      let vacuumSpeed : ℝ :=
        1 / Real.sqrt (vacuumPermittivity * vacuumPermeability)
      let mediumSpeed : ℝ :=
        1 / Real.sqrt (mediumPermittivity * mediumPermeability)
      0 < mediumPermittivity ∧ 0 < mediumPermeability ∧
      (mediumPermittivity, mediumPermeability) ≠
        (vacuumPermittivity, vacuumPermeability) ∧
      vacuumSpeed < mediumSpeed ∧ ¬ mediumSpeed < vacuumSpeed

/-- The displayed speed formulas support exactly a comparison of the two
positive material-parameter products. -/
def lightMediumComparisonCorrectedTarget : Prop :=
  ∀ (permittivity permeability vacuumPermittivity vacuumPermeability : ℝ),
    0 < permittivity * permeability →
    0 < vacuumPermittivity * vacuumPermeability →
      (1 / Real.sqrt (permittivity * permeability) <
        1 / Real.sqrt (vacuumPermittivity * vacuumPermeability) ↔
          vacuumPermittivity * vacuumPermeability <
            permittivity * permeability)

end NumStability.Leveque02Tracer
