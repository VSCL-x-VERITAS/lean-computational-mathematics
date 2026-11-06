/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.Adjoint
import Mathlib.Analysis.InnerProductSpace.ProdL2
import Mathlib.Algebra.Module.Submodule.Invariant
import Mathlib.LinearAlgebra.Projection

/-!
# Bhatia Chapter I: direct sums and block operators

Transparent source propositions using the actual Hilbert L2 product,
subspace inclusions, adjoints and orthogonal projections. Independent
statement audits and source theorem proofs remain separate obligations.
-/

set_option autoImplicit false
universe u v
namespace NumStability.Bhatia.Chapter01.Targets

/-- The concrete algebraic pair and its Hilbert L2 realization. The types
already carry the genuine library module and inner-product-space structures. -/
def directSum : Prop :=
  (∀ (U : Type u) (V : Type v)
      [AddCommGroup U] [Module ℂ U] [FiniteDimensional ℂ U]
      [AddCommGroup V] [Module ℂ V] [FiniteDimensional ℂ V],
    (∀ (u u' : U) (v v' : V),
      (u, v) + (u', v') = (u + u', v + v')) ∧
    (∀ (a : ℂ) (u : U) (v : V), a • (u, v) = (a • u, a • v))) ∧
  (∀ (H : Type u) (K : Type v)
      [NormedAddCommGroup H] [InnerProductSpace ℂ H] [FiniteDimensional ℂ H]
      [NormedAddCommGroup K] [InnerProductSpace ℂ K] [FiniteDimensional ℂ K],
    (∀ (x y : WithLp 2 (H × K)),
      WithLp.ofLp (x + y) =
        ((WithLp.ofLp x).1 + (WithLp.ofLp y).1,
         (WithLp.ofLp x).2 + (WithLp.ofLp y).2)) ∧
    (∀ (a : ℂ) (x : WithLp 2 (H × K)),
      WithLp.ofLp (a • x) =
        (a • (WithLp.ofLp x).1, a • (WithLp.ofLp x).2)) ∧
    (∀ (x y : WithLp 2 (H × K)),
      inner ℂ x y =
        inner ℂ (WithLp.ofLp x).1 (WithLp.ofLp y).1 +
        inner ℂ (WithLp.ofLp x).2 (WithLp.ofLp y).2))

/-- The internal identification uses actual summation, and the algebraic
case retains precisely intersection zero and sum top without orthogonality. -/
def internalSum : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (M N : Submodule ℂ H),
    (IsCompl M N ↔ M ⊓ N = ⊥ ∧ M ⊔ N = ⊤) ∧
    (N = Mᗮ →
      let L := WithLp.linearEquiv 2 ℂ (M × N)
      let S := (M.subtype.coprod N.subtype).comp L.toLinearMap
      Function.Bijective S ∧ Isometry S ∧
        (∀ p : WithLp 2 (M × N),
          S p = (WithLp.ofLp p).1.val + (WithLp.ofLp p).2.val)) ∧
    (IsCompl M N → ∀ x : H,
      ∃! p : M × N, p.1.val + p.2.val = x)

/-- Uniqueness is of the ordered pair; the algebraic case does not
assert either orthogonality or its negation. -/
def uniqueDecomposition : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (M N : Submodule ℂ H),
    (IsCompl M N → ∀ x : H,
      ∃! p : M × N, p.1.val + p.2.val = x) ∧
    (N = Mᗮ → ∀ x : H,
      (∃! p : M × N, p.1.val + p.2.val = x) ∧
      (∀ p : M × N, p.1.val + p.2.val = x →
        inner ℂ p.1.val p.2.val = 0))

/-- Subtype-valued adjoints and ambient-valued orthoprojectors have
explicitly different types. Completeness is derived locally from the source
finite-dimensional hypotheses; it is not an added assumption. -/
def inclusionAdjoint : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (M N : Submodule ℂ H),
    N = Mᗮ →
    letI : IsUniformAddGroup M := M.toAddSubgroup.isUniformAddGroup
    letI : IsUniformAddGroup N := N.toAddSubgroup.isUniformAddGroup
    letI : CompleteSpace M := FiniteDimensional.complete ℂ M
    letI : CompleteSpace N := FiniteDimensional.complete ℂ N
    let iM : M →ₗ[ℂ] H := M.subtype
    let iN : N →ₗ[ℂ] H := N.subtype
    let pM : H →ₗ[ℂ] M := M.orthogonalProjection.toLinearMap
    let pN : H →ₗ[ℂ] N := N.orthogonalProjection.toLinearMap
    let P : H →ₗ[ℂ] H := M.starProjection.toLinearMap
    let Q : H →ₗ[ℂ] H := N.starProjection.toLinearMap
    let S := (iM.coprod iN).comp (WithLp.linearEquiv 2 ℂ (M × N)).toLinearMap
    (∀ u : M, iM u = u.val) ∧ (∀ v : N, iN v = v.val) ∧
    LinearMap.adjoint iM = pM ∧ LinearMap.adjoint iN = pN ∧
    iM.comp (LinearMap.adjoint iM) = P ∧
    iN.comp (LinearMap.adjoint iN) = Q ∧
    (∀ x : H, iM (LinearMap.adjoint iM x) = P x) ∧
    (∀ x : H, iN (LinearMap.adjoint iN x) = Q x) ∧
    Isometry S ∧ Function.Surjective S

/-- The prescribed row of actual inclusions, from the L2 product, is
linear by construction, isometric, and onto. -/
def sumIsometry : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (M N : Submodule ℂ H),
    N = Mᗮ →
    let S := (M.subtype.coprod N.subtype).comp
      (WithLp.linearEquiv 2 ℂ (M × N)).toLinearMap
    (∀ p : WithLp 2 (M × N),
      S p = (WithLp.ofLp p).1.val + (WithLp.ofLp p).2.val) ∧
    Isometry S ∧ Function.Surjective S

/-- Typed compression formulas and their actual transport on columns.
No basis, common dimension, or freely supplied projection is used. -/
def blocks : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (M N : Submodule ℂ H) (A : H →ₗ[ℂ] H),
    N = Mᗮ →
    let iM := M.subtype
    let iN := N.subtype
    let B : M →ₗ[ℂ] M := (LinearMap.adjoint iM).comp (A.comp iM)
    let C : N →ₗ[ℂ] M := (LinearMap.adjoint iM).comp (A.comp iN)
    let D : M →ₗ[ℂ] N := (LinearMap.adjoint iN).comp (A.comp iM)
    let E : N →ₗ[ℂ] N := (LinearMap.adjoint iN).comp (A.comp iN)
    let L := WithLp.linearEquiv 2 ℂ (M × N)
    let S := (iM.coprod iN).comp L.toLinearMap
    let R := L.symm.toLinearMap.comp
      ((LinearMap.adjoint iM).prod (LinearMap.adjoint iN))
    (∀ p : WithLp 2 (M × N),
      R (A (S p)) = WithLp.toLp 2
        (B (WithLp.ofLp p).1 + C (WithLp.ofLp p).2,
         D (WithLp.ofLp p).1 + E (WithLp.ofLp p).2)) ∧
    (∀ (u : M) (v : N),
      A (u.val + v.val) =
        iM (B u + C v) + iN (D u + E v))

/-- Every block here is a fixed library-defined compression. The local
`block` expression is an abbreviation, never a quantified callback. -/
def blockOperations : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (M N : Submodule ℂ H)
      (A A' : H →ₗ[ℂ] H) (a : ℂ),
    N = Mᗮ →
    let block := fun (X Y : Submodule ℂ H) (T : H →ₗ[ℂ] H) =>
      (LinearMap.adjoint X.subtype).comp (T.comp Y.subtype)
    let B := block M M A
    let C := block M N A
    let D := block N M A
    let E := block N N A
    let B' := block M M A'
    let C' := block M N A'
    let D' := block N M A'
    let E' := block N N A'
    block M M (A + A') = B + B' ∧
    block M N (A + A') = C + C' ∧
    block N M (A + A') = D + D' ∧
    block N N (A + A') = E + E' ∧
    block M M (a • A) = a • B ∧
    block M N (a • A) = a • C ∧
    block N M (a • A) = a • D ∧
    block N N (a • A) = a • E ∧
    block M M (0 : H →ₗ[ℂ] H) = 0 ∧
    block M N (0 : H →ₗ[ℂ] H) = 0 ∧
    block N M (0 : H →ₗ[ℂ] H) = 0 ∧
    block N N (0 : H →ₗ[ℂ] H) = 0 ∧
    block M M (LinearMap.id : H →ₗ[ℂ] H) = (LinearMap.id : M →ₗ[ℂ] M) ∧
    block M N (LinearMap.id : H →ₗ[ℂ] H) = 0 ∧
    block N M (LinearMap.id : H →ₗ[ℂ] H) = 0 ∧
    block N N (LinearMap.id : H →ₗ[ℂ] H) = (LinearMap.id : N →ₗ[ℂ] N) ∧
    block M M (A.comp A') = B.comp B' + C.comp D' ∧
    block M N (A.comp A') = B.comp C' + C.comp E' ∧
    block N M (A.comp A') = D.comp B' + E.comp D' ∧
    block N N (A.comp A') = D.comp C' + E.comp E' ∧
    block M M (LinearMap.adjoint A) = LinearMap.adjoint B ∧
    block M N (LinearMap.adjoint A) = LinearMap.adjoint D ∧
    block N M (LinearMap.adjoint A) = LinearMap.adjoint C ∧
    block N N (LinearMap.adjoint A) = LinearMap.adjoint E

/-- Invariance uses the actual invariant-submodule lattice. Reduction is
exactly invariance of M and its orthogonal complement. The direct-sum identity
is an equality after the prescribed sum identification. -/
def invariantReducing : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (M : Submodule ℂ H) (A : H →ₗ[ℂ] H),
    let N := Mᗮ
    let B : M →ₗ[ℂ] M := (LinearMap.adjoint M.subtype).comp (A.comp M.subtype)
    let C : N →ₗ[ℂ] M := (LinearMap.adjoint M.subtype).comp (A.comp N.subtype)
    let D : M →ₗ[ℂ] N := (LinearMap.adjoint N.subtype).comp (A.comp M.subtype)
    let E : N →ₗ[ℂ] N := (LinearMap.adjoint N.subtype).comp (A.comp N.subtype)
    let reduces : Prop := M ∈ (Module.End.invtSubmodule A) ∧ N ∈ (Module.End.invtSubmodule A)
    let L := WithLp.linearEquiv 2 ℂ (M × N)
    let S := (M.subtype.coprod N.subtype).comp L.toLinearMap
    let diagonal := L.symm.toLinearMap.comp ((B.prodMap E).comp L.toLinearMap)
    (M ∈ (Module.End.invtSubmodule A) ↔ ∀ x : H, x ∈ M → A x ∈ M) ∧
    (reduces ↔
      (∀ x : H, x ∈ M → A x ∈ M) ∧
      (∀ x : H, x ∈ N → A x ∈ N)) ∧
    (reduces → C = 0 ∧ D = 0 ∧ A.comp S = S.comp diagonal)

/-- D is the lower-left compression. The second biconditional combines
the printed invariance iff with its symmetric instance for the complement;
the source directly states the forward reducing guarantee. -/
def blockInvariance : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (M : Submodule ℂ H) (A : H →ₗ[ℂ] H),
    let N := Mᗮ
    let B : M →ₗ[ℂ] M := (LinearMap.adjoint M.subtype).comp (A.comp M.subtype)
    let C : N →ₗ[ℂ] M := (LinearMap.adjoint M.subtype).comp (A.comp N.subtype)
    let D : M →ₗ[ℂ] N := (LinearMap.adjoint N.subtype).comp (A.comp M.subtype)
    let E : N →ₗ[ℂ] N := (LinearMap.adjoint N.subtype).comp (A.comp N.subtype)
    ((∀ x : H, x ∈ M → A x ∈ M) ↔ D = 0) ∧
    (((∀ x : H, x ∈ M → A x ∈ M) ∧
      (∀ x : H, x ∈ N → A x ∈ N)) ↔ C = 0 ∧ D = 0) ∧
    (C = 0 ∧ D = 0 → ∀ (u : M) (v : N),
      A (u.val + v.val) = M.subtype (B u) + N.subtype (E v))

end NumStability.Bhatia.Chapter01.Targets
