/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.LinearAlgebra.FiniteDimensional.Basic
import Mathlib.LinearAlgebra.TensorProduct.Map

/-!
# The forward tensor inverse assertion

Transparent statement contract for Bhatia, Matrix Analysis (1997), I.4, printed15/PDF27.
Invertibility of each factor is represented by a supplied genuine two-sided
linear inverse. Quantifying over all such inverse witnesses preserves the full
conditional source domain: every invertible factor pair has these witnesses.
No inverse for the tensor product is assumed. Its two-sided inverse is an
existential conclusion, and every such inverse is identified with the actual
`TensorProduct.map` of the supplied factor inverses.

The same-space binary assertion is forward-only. The later tensor-power
property saying "when either inverse exists" is a distinct source obligation.
The existing literal four-relation quotient/canonical-carrier bridge remains
explicitly separate and unproved; no target definition is used as a theorem.
-/

set_option autoImplicit false
noncomputable section
universe u

namespace NumStability.Bhatia.Chapter01.Targets

/-- Genuine factor inverse hypotheses imply existence of a two-sided inverse
of the entire tensor operator and its prescribed formula. Dimension zero
remains allowed. The final universal clause identifies any two-sided inverse;
it does not add a converse from product invertibility to factor invertibility. -/
def tensorInverseTarget : Prop :=
  ∀ (H : Type u)
      [NormedAddCommGroup H] [InnerProductSpace ℂ H] [FiniteDimensional ℂ H]
      (A B Ainv Binv : H →ₗ[ℂ] H),
    A.comp Ainv = (LinearMap.id : H →ₗ[ℂ] H) →
    Ainv.comp A = (LinearMap.id : H →ₗ[ℂ] H) →
    B.comp Binv = (LinearMap.id : H →ₗ[ℂ] H) →
    Binv.comp B = (LinearMap.id : H →ₗ[ℂ] H) →
    let T := TensorProduct ℂ H H
    let tensorOperator : T →ₗ[ℂ] T := TensorProduct.map A B
    let prescribedInverse : T →ₗ[ℂ] T := TensorProduct.map Ainv Binv
    (∃ C : T →ₗ[ℂ] T,
      tensorOperator.comp C = (LinearMap.id : T →ₗ[ℂ] T) ∧
      C.comp tensorOperator = (LinearMap.id : T →ₗ[ℂ] T) ∧
      C = prescribedInverse) ∧
    (∀ C : T →ₗ[ℂ] T,
      tensorOperator.comp C = (LinearMap.id : T →ₗ[ℂ] T) →
      C.comp tensorOperator = (LinearMap.id : T →ₗ[ℂ] T) →
      C = prescribedInverse)

end NumStability.Bhatia.Chapter01.Targets
