/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.MaxwellConstraintPropagationModel

/-!
# Proof-free target: Maxwell divergence constraints persist

The charge/current-free evolution equations act globally in space; regularity
is assumed on the connected time interval from zero to the selected end time.
The time derivative of divergence is explicitly the divergence of the time
partials, and mixed spatial partials commute as required by divergence of
curl. Neither constitutive constants nor positivity are involved.
-/

namespace NumStability.Leveque02Tracer

/-- Initial divergence-free data stay divergence-free under both Maxwell
evolution equations, for classical fields with the stated mixed derivatives. -/
def maxwellConstraintPropagationTarget : Prop :=
  ∀ (electricDisplacement magneticInduction electricField magneticField : MaxwellField)
    (endTime : ℝ),
    0 ≤ endTime →
    (∀ position time,
      IsMaxwellAmpereAt electricDisplacement magneticField position time) →
    (∀ position time,
      IsMaxwellFaradayAt magneticInduction electricField position time) →
    (∀ position time, time ∈ Set.Icc 0 endTime →
      HasMaxwellMixedSpatialPartialsAt magneticField position time ∧
      HasMaxwellMixedSpatialPartialsAt electricField position time) →
    (∀ position time, time ∈ Set.Icc 0 endTime →
      HasDerivAt
        (fun τ => maxwellDivergence electricDisplacement position τ)
        (maxwellDivergence
          (maxwellTimeDerivativeField electricDisplacement) position time) time ∧
      HasDerivAt
        (fun τ => maxwellDivergence magneticInduction position τ)
        (maxwellDivergence
          (maxwellTimeDerivativeField magneticInduction) position time) time) →
    (∀ position time, time ∈ Set.Icc 0 endTime →
      (∀ component,
        HasDerivAt
          (fun s => electricDisplacement
            (Function.update position component s) time component)
          (maxwellSpatialPartial electricDisplacement component component
            position time) (position component)) ∧
      (∀ component,
        HasDerivAt
          (fun s => magneticInduction
            (Function.update position component s) time component)
          (maxwellSpatialPartial magneticInduction component component
            position time) (position component))) →
    (∀ position,
      IsMaxwellDivergenceFreeAt electricDisplacement position 0 ∧
      IsMaxwellDivergenceFreeAt magneticInduction position 0) →
    ∀ position time, time ∈ Set.Icc 0 endTime →
      IsMaxwellDivergenceFreeAt electricDisplacement position time ∧
      IsMaxwellDivergenceFreeAt magneticInduction position time

end NumStability.Leveque02Tracer
