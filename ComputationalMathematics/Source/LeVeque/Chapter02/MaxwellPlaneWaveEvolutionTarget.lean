/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.MaxwellConstantMediumTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.MaxwellPlaneWaveModel

/-!
# Proof-free target for LeVeque equation (2.117)

This specializes the constant-medium vector system to the selected transverse
plane-wave fields. The four scalar derivatives are required to be actual
derivatives, not merely values of Lean's totalized `deriv`.
-/

namespace NumStability.Leveque02Tracer

/-- The three-dimensional reduced Maxwell evolution equations agree exactly
with the two scalar equations for the selected plane-wave amplitudes. -/
def maxwellPlaneWaveEvolutionTarget : Prop :=
  ∀ (permittivity permeability : ℝ)
    (electricAmplitude magneticAmplitude : ℝ → ℝ → ℝ)
    (position : MaxwellVector) (time : ℝ),
    permittivity ≠ 0 → permeability ≠ 0 →
    HasDerivAt (fun τ => electricAmplitude (position 0) τ)
      (deriv (fun τ => electricAmplitude (position 0) τ) time) time →
    HasDerivAt (fun τ => magneticAmplitude (position 0) τ)
      (deriv (fun τ => magneticAmplitude (position 0) τ) time) time →
    HasDerivAt (fun s => electricAmplitude s time)
      (deriv (fun s => electricAmplitude s time) (position 0)) (position 0) →
    HasDerivAt (fun s => magneticAmplitude s time)
      (deriv (fun s => magneticAmplitude s time) (position 0)) (position 0) →
    (((∀ component,
        maxwellTimePartial (maxwellPlaneElectric electricAmplitude) component position time -
          (1 / (permittivity * permeability)) *
            maxwellCurl (maxwellPlaneMagnetic magneticAmplitude) position time component = 0) ∧
      (∀ component,
        maxwellTimePartial (maxwellPlaneMagnetic magneticAmplitude) component position time +
          maxwellCurl (maxwellPlaneElectric electricAmplitude) position time component = 0)) ↔
    ((deriv (fun τ => electricAmplitude (position 0) τ) time +
        (1 / (permittivity * permeability)) *
          deriv (fun s => magneticAmplitude s time) (position 0) = 0) ∧
      (deriv (fun τ => magneticAmplitude (position 0) τ) time +
        deriv (fun s => electricAmplitude s time) (position 0) = 0)))

end NumStability.Leveque02Tracer
