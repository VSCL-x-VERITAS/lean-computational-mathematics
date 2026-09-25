/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.MaxwellPlaneWaveModel

/-!
# Proof-free target for LeVeque equation (2.121)

The material parameters depend on the first spatial coordinate but not time.
The derivative of `B³/μ` is kept as a derivative of the complete quotient.
-/

namespace NumStability.Leveque02Tracer

/-- The charge-free Maxwell evolution residuals for a layered transverse
medium reduce exactly to the two displayed scalar equations. -/
def maxwellLayeredEvolutionTarget : Prop :=
  ∀ (permittivity permeability : ℝ → ℝ)
    (electricAmplitude magneticAmplitude : ℝ → ℝ → ℝ)
    (position : MaxwellVector) (time : ℝ),
    permeability (position 0) ≠ 0 →
    HasDerivAt (fun τ => electricAmplitude (position 0) τ)
      (deriv (fun τ => electricAmplitude (position 0) τ) time) time →
    HasDerivAt (fun τ => magneticAmplitude (position 0) τ)
      (deriv (fun τ => magneticAmplitude (position 0) τ) time) time →
    HasDerivAt (fun s => magneticAmplitude s time / permeability s)
      (deriv (fun s => magneticAmplitude s time / permeability s) (position 0))
      (position 0) →
    HasDerivAt (fun s => electricAmplitude s time)
      (deriv (fun s => electricAmplitude s time) (position 0)) (position 0) →
    (let electricDisplacement : MaxwellField :=
        maxwellPlaneElectric (fun s τ => permittivity s * electricAmplitude s τ)
      let electricField : MaxwellField := maxwellPlaneElectric electricAmplitude
      let magneticInduction : MaxwellField := maxwellPlaneMagnetic magneticAmplitude
      let magneticField : MaxwellField :=
        maxwellPlaneMagnetic (fun s τ => magneticAmplitude s τ / permeability s)
      ((∀ component,
          maxwellTimePartial electricDisplacement component position time -
            maxwellCurl magneticField position time component = 0) ∧
        (∀ component,
          maxwellTimePartial magneticInduction component position time +
            maxwellCurl electricField position time component = 0)) ↔
      ((permittivity (position 0) *
            deriv (fun τ => electricAmplitude (position 0) τ) time +
          deriv (fun s => magneticAmplitude s time / permeability s) (position 0) = 0) ∧
        (deriv (fun τ => magneticAmplitude (position 0) τ) time +
          deriv (fun s => electricAmplitude s time) (position 0) = 0)))

end NumStability.Leveque02Tracer
