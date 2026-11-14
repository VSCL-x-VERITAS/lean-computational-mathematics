/-
SPDX-License-Identifier: MIT
Bhatia, Matrix Analysis (1997), I.5, printed 18–19 / PDF 30–31.
-/
import Mathlib.Analysis.Complex.Basic
import Mathlib.Analysis.InnerProductSpace.Defs
import Mathlib.LinearAlgebra.FiniteDimensional.Defs
import Mathlib.LinearAlgebra.PiTensorProduct

/-!
The source operator is algebraic: its carrier is the actual k-fold tensor
quotient, its elementary tensors are tprod, and each summand is the actual
factorwise linear extension map. There is no supplied tensor callback.
The ambient input remains every finite-dimensional complex Hilbert space.
No Hilbert structure on the tensor quotient, adjoint, derivative, spectrum,
or correspondence with the separate iterated Hilbert model is asserted here.
-/

set_option autoImplicit false
universe u
open scoped BigOperators

namespace NumStability.Bhatia.Chapter01.Targets

/-- The actual tensor operator having A in slot j and identities elsewhere.
Only positive degree is exposed by this source-facing definition. -/
def singleSlotTensorOperator {H : Type u} [NormedAddCommGroup H]
    [InnerProductSpace ℂ H] [FiniteDimensional ℂ H]
    (k : ℕ) (_hk : 0 < k) (A : H →ₗ[ℂ] H) (j : Fin k) :
    PiTensorProduct ℂ (fun _ : Fin k => H) →ₗ[ℂ]
      PiTensorProduct ℂ (fun _ : Fin k => H) :=
  PiTensorProduct.map
    (fun i : Fin k => if i = j then A else (LinearMap.id : H →ₗ[ℂ] H))

/-- Exactly k single-slot insertions of the same A, each with k factors. -/
def additiveTensorOperator {H : Type u} [NormedAddCommGroup H]
    [InnerProductSpace ℂ H] [FiniteDimensional ℂ H]
    (k : ℕ) (hk : 0 < k) (A : H →ₗ[ℂ] H) :
    PiTensorProduct ℂ (fun _ : Fin k => H) →ₗ[ℂ]
      PiTensorProduct ℂ (fun _ : Fin k => H) :=
  ∑ j : Fin k, singleSlotTensorOperator k hk A j

/-- Full source-domain characterization of the prescribed definition.
The pure-tensor clauses explicitly expose the inherited Section I.4 action;
they are the semantic characterization of this construction, not hypotheses. -/
def additiveOperatorDefinitionTarget : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
    [FiniteDimensional ℂ H] (k : ℕ) (hk : 0 < k) (A : H →ₗ[ℂ] H),
    additiveTensorOperator k hk A =
      ∑ j : Fin k,
        (PiTensorProduct.map
          (fun i : Fin k => if i = j then A else (LinearMap.id : H →ₗ[ℂ] H)) :
          PiTensorProduct ℂ (fun _ : Fin k => H) →ₗ[ℂ]
            PiTensorProduct ℂ (fun _ : Fin k => H)) ∧
    (∀ (j : Fin k) (x : Fin k → H),
      singleSlotTensorOperator k hk A j (PiTensorProduct.tprod ℂ x) =
        PiTensorProduct.tprod ℂ
          (fun i : Fin k => if i = j then A (x i) else x i)) ∧
    (∀ x : Fin k → H,
      additiveTensorOperator k hk A (PiTensorProduct.tprod ℂ x) =
        ∑ j : Fin k,
          PiTensorProduct.tprod ℂ
            (fun i : Fin k => if i = j then A (x i) else x i))

end NumStability.Bhatia.Chapter01.Targets
