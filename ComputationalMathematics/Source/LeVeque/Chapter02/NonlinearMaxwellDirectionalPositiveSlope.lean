/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.NonlinearMaxwellDirectionalPositiveSlopeTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.MaxwellDirectionalHyperbolicity

/-!
# Conditional all-direction hyperbolicity at scalar-tangent states

The Fréchet derivative hypotheses in the target identify the local scalar
tangent factors of the actual field-strength constitutive laws. Positivity
then allows reuse of the six-state constant-coefficient directional theorem.
-/

namespace NumStability.Leveque02Tracer

theorem nonlinearMaxwellDirectionalPositiveSlope :
    nonlinearMaxwellDirectionalPositiveSlopeTarget := by
  intro permittivity permeability electricField magneticField
    electricSlope magneticSlope _ _ helectric hmagnetic direction
  exact (maxwellDirectionalHyperbolicity electricSlope magneticSlope
    helectric hmagnetic direction).1

end NumStability.Leveque02Tracer
