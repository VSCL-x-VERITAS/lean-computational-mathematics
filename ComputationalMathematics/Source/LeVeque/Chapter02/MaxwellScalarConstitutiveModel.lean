/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.MaxwellAmpereModel
import Mathlib.Data.Matrix.Basic

/-!
# Scalar constitutive relations for homogeneous isotropic Maxwell media

One real coefficient is fixed across space and time. The same relation applies
to `(D,E,ε)` and `(B,H,μ)`.

In a general medium a three-by-three coefficient matrix may vary with
position; the printed equations also permit this interpretation.
-/

namespace NumStability.Leveque02Tracer

/-- A field is a fixed scalar multiple of another field at every position
and time. The coefficient is the homogeneous isotropic material parameter. -/
def IsMaxwellScalarConstitutive
    (response driving : MaxwellField) (coefficient : ℝ) : Prop :=
  ∀ position time, response position time = coefficient • driving position time

/-- A spatially varying three-by-three constitutive matrix acts on a field at
each position, with the same matrix at every time at that position. -/
def IsMaxwellMatrixConstitutive
    (response driving : MaxwellField)
    (coefficient : MaxwellVector → Matrix (Fin 3) (Fin 3) ℝ) : Prop :=
  ∀ position time,
    response position time = (coefficient position).mulVec (driving position time)

end NumStability.Leveque02Tracer
