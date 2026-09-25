/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.NonlinearMaxwellDirectionalPositiveSlopeModel
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity

/-!
# Conditional full-direction nonlinear Maxwell hyperbolicity target

LeVeque's statement on printed page 46 that field-dependent constitutive
coefficients yield a nonlinear hyperbolic Maxwell system is not valid without
a constitutive slope condition. This target gives a local sufficient condition
for every spatial direction at states where the *actual three-vector*
constitutive derivatives are positive scalar multiples of the identity. The
separately named counterexample refutes the printed unqualified implication.
-/

namespace NumStability.Leveque02Tracer

/-- At a field state with positive *scalar vector-Jacobian* electric and
magnetic responses, the frozen six-state Maxwell symbol has a complete real
eigenbasis in every spatial direction. This is a conditional result for a
restrictive class of tangent states, not a claim for generic anisotropic
constitutive Jacobians. -/
def nonlinearMaxwellDirectionalPositiveSlopeTarget : Prop :=
  ∀ (permittivity permeability : ℝ → ℝ)
    (electricField magneticField : MaxwellVector)
    (electricSlope magneticSlope : ℝ),
    HasFDerivAt (maxwellNonlinearConstitutiveResponse permittivity)
      (electricSlope • ContinuousLinearMap.id ℝ MaxwellVector) electricField →
    HasFDerivAt (maxwellNonlinearConstitutiveResponse permeability)
      (magneticSlope • ContinuousLinearMap.id ℝ MaxwellVector) magneticField →
    0 < electricSlope → 0 < magneticSlope →
    ∀ (direction : MaxwellVector),
      NumStability.IsRealHyperbolicMatrix
        (frozenNonlinearMaxwellDirectionalMatrix electricSlope magneticSlope
          direction)

end NumStability.Leveque02Tracer
