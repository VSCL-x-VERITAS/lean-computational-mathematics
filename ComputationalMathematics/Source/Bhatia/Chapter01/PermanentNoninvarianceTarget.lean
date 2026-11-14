/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Data.Complex.Basic
import Mathlib.LinearAlgebra.Matrix.Permanent

/-!
# Bhatia Chapter I: permanent and similarity

Proof-free target for the failure of similarity invariance on printed page 17
(PDF page 29). A unit of the square matrix ring supplies an actual two-sided
inverse for the same change of coordinates on the two sides of the operator.
-/

set_option autoImplicit false

namespace NumStability.Bhatia.Chapter01.Targets

/-- Some similar complex square matrices have different permanents. -/
def permanentNoninvariance : Prop :=
  ∃ n : ℕ, ∃ A : Matrix (Fin n) (Fin n) ℂ,
    ∃ S : (Matrix (Fin n) (Fin n) ℂ)ˣ,
      Matrix.permanent
        ((S : Matrix (Fin n) (Fin n) ℂ) * A *
          (↑(S⁻¹) : Matrix (Fin n) (Fin n) ℂ)) ≠
        Matrix.permanent A

end NumStability.Bhatia.Chapter01.Targets
