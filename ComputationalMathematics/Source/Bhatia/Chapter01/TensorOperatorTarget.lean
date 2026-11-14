/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.LinearAlgebra.FiniteDimensional.Basic
import Mathlib.LinearAlgebra.Finsupp.LinearCombination
import Mathlib.LinearAlgebra.TensorProduct.Map

/-!
# Tensor operator action and consistent total linear extension

Transparent statement contract for Bhatia, Matrix Analysis (1997), I.4, printed14–15/PDF26–27.
The operator is the actual bundled `TensorProduct.map` on the canonical algebraic
tensor product. The full presentation map and its transformed version are fixed
linear combinations, not supplied callbacks. Consistency, complete finite-sum
action and uniqueness are conclusions.

The source's literal four-relation quotient correspondence remains the separate
existing `Targets.literalTensorCanonicalBridge` obligation in
`LiteralTensorQuotientTarget`. That obligation is neither assumed nor proved
by this contract. It must be discharged before transporting the canonical-carrier
statement to the literal source quotient. No unaudited target is used as a fact.
-/

set_option autoImplicit false
noncomputable section
universe u v

namespace NumStability.Bhatia.Chapter01.Targets

/-- For all factor spaces and their endomorphisms, the prescribed elementary
action defines the entire linear operator. The source explicitly allows
different factor Hilbert spaces; no equal-dimension or nonzero restriction is
added. The uniqueness premise specifies every generator, rather than assuming
the source target itself. -/
def tensorOperatorTarget : Prop :=
  ∀ (H : Type u) (K : Type v)
      [NormedAddCommGroup H] [InnerProductSpace ℂ H] [FiniteDimensional ℂ H]
      [NormedAddCommGroup K] [InnerProductSpace ℂ K] [FiniteDimensional ℂ K]
      (A : H →ₗ[ℂ] H) (B : K →ₗ[ℂ] K),
    let F := (H × K) →₀ ℂ
    let T := TensorProduct ℂ H K
    let presentation : F →ₗ[ℂ] T :=
      Finsupp.linearCombination ℂ
        (fun p : H × K => TensorProduct.tmul ℂ p.1 p.2)
    let transformed : F →ₗ[ℂ] T :=
      Finsupp.linearCombination ℂ
        (fun p : H × K => TensorProduct.tmul ℂ (A p.1) (B p.2))
    let tensorOperator : T →ₗ[ℂ] T := TensorProduct.map A B
    Function.Surjective presentation ∧
    (∀ (x : H) (y : K),
      tensorOperator (TensorProduct.tmul ℂ x y) =
        TensorProduct.tmul ℂ (A x) (B y)) ∧
    (∀ E : F, tensorOperator (presentation E) = transformed E) ∧
    (∀ E E' : F,
      presentation E = presentation E' → transformed E = transformed E') ∧
    (∀ L : T →ₗ[ℂ] T,
      (∀ (x : H) (y : K),
        L (TensorProduct.tmul ℂ x y) = TensorProduct.tmul ℂ (A x) (B y)) →
      L = tensorOperator)

end NumStability.Bhatia.Chapter01.Targets
