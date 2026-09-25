/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.MaxwellDirectionalHyperbolicityModel
import Mathlib.Analysis.Calculus.FDeriv.Basic

/-!
# A full directional symbol with scalar positive tangent responses

The constitutive maps act on three-component fields, with coefficients that
depend on squared field strength. At a state where both actual Fréchet
derivatives are positive scalar multiples of the identity, their frozen
`(E,B)` directional symbol has the constant-medium form with the two tangent
factors. This is a restrictive local condition; a generic field-dependent
isotropic law has anisotropic radial and transverse derivatives.
-/

namespace NumStability.Leveque02Tracer

/-- Squared Euclidean field strength. -/
def maxwellFieldStrengthSquared (field : MaxwellVector) : ℝ :=
  ∑ component : Fin 3, field component ^ 2

/-- Three-vector electric or magnetic constitutive response with a
field-strength-dependent scalar coefficient. -/
def maxwellNonlinearConstitutiveResponse
    (coefficient : ℝ → ℝ) (field : MaxwellVector) : MaxwellVector :=
  fun component => coefficient (maxwellFieldStrengthSquared field) * field component

/-- Full six-state frozen symbol when the *actual vector constitutive
Jacobians* at the selected state are the scalar matrices `electricSlope I`
and `magneticSlope I`. -/
noncomputable def frozenNonlinearMaxwellDirectionalMatrix
    (electricSlope magneticSlope : ℝ) (direction : MaxwellVector) :
    Matrix MaxwellStateIndex MaxwellStateIndex ℝ :=
  maxwellDirectionalMatrix electricSlope magneticSlope direction

end NumStability.Leveque02Tracer
