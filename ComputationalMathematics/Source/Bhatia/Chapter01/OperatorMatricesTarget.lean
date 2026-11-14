/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.Adjoint
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.LinearAlgebra.Matrix.ToLin

/-! Proof-free source targets for Bhatia, *Matrix Analysis* (1997),
Chapter I.2, printed pages 3–4 (PDF pages 15–16). Matrix representations
retain both supplied bases and the direction of each linear map. -/

set_option autoImplicit false

universe u v w

namespace NumStability.Bhatia.Chapter01.Targets

/-- Fixed bases determine a unique coordinate matrix; orthonormal bases give
the stated inner-product entry formula. -/
def operatorMatrices : Prop :=
  (∀ (V : Type u) (W : Type v)
      [AddCommGroup V] [Module ℂ V] [FiniteDimensional ℂ V]
      [AddCommGroup W] [Module ℂ W] [FiniteDimensional ℂ W]
      (n m : ℕ) (E : Module.Basis (Fin n) ℂ V)
      (F : Module.Basis (Fin m) ℂ W) (A : V →ₗ[ℂ] W),
    ∃! M : Matrix (Fin m) (Fin n) ℂ,
      ∀ x : V, (fun i => F.repr (A x) i) = M.mulVec (fun j => E.repr x j)) ∧
  (∀ (H : Type u) (K : Type v)
      [NormedAddCommGroup H] [InnerProductSpace ℂ H] [FiniteDimensional ℂ H]
      [NormedAddCommGroup K] [InnerProductSpace ℂ K] [FiniteDimensional ℂ K]
      (n m : ℕ) (E : OrthonormalBasis (Fin n) ℂ H)
      (F : OrthonormalBasis (Fin m) ℂ K) (A : H →ₗ[ℂ] K)
      (i : Fin m) (j : Fin n),
    LinearMap.toMatrix E.toBasis F.toBasis A i j = inner ℂ (F i) (A (E j)))

/-- Composition corresponds to multiplication with the same intermediate basis. -/
def operatorComposition : Prop :=
  ∀ (H : Type u) (K : Type v) (L : Type w)
      [NormedAddCommGroup H] [InnerProductSpace ℂ H] [FiniteDimensional ℂ H]
      [NormedAddCommGroup K] [InnerProductSpace ℂ K] [FiniteDimensional ℂ K]
      [NormedAddCommGroup L] [InnerProductSpace ℂ L] [FiniteDimensional ℂ L]
      (n m p : ℕ) (E : OrthonormalBasis (Fin n) ℂ H)
      (F : OrthonormalBasis (Fin m) ℂ K) (G : OrthonormalBasis (Fin p) ℂ L)
      (A : H →ₗ[ℂ] K) (B : K →ₗ[ℂ] L),
    LinearMap.toMatrix E.toBasis G.toBasis (B.comp A) =
      LinearMap.toMatrix F.toBasis G.toBasis B * LinearMap.toMatrix E.toBasis F.toBasis A

/-- The prescribed adjoint satisfies the defining pairing identity and is unique. -/
def operatorAdjoint : Prop :=
  ∀ (H : Type u) (K : Type v)
      [NormedAddCommGroup H] [InnerProductSpace ℂ H] [FiniteDimensional ℂ H]
      [NormedAddCommGroup K] [InnerProductSpace ℂ K] [FiniteDimensional ℂ K]
      (A : H →ₗ[ℂ] K),
    (∀ (x : H) (z : K), inner ℂ z (A x) = inner ℂ (LinearMap.adjoint A z) x) ∧
    (∀ B : K →ₗ[ℂ] H,
      (∀ (x : H) (z : K), inner ℂ z (A x) = inner ℂ (B z) x) →
        B = LinearMap.adjoint A)

/-- Exercise I.2.1 swaps the two orthonormal bases for the adjoint matrix. -/
def adjointMatrix : Prop :=
  ∀ (H : Type u) (K : Type v)
      [NormedAddCommGroup H] [InnerProductSpace ℂ H] [FiniteDimensional ℂ H]
      [NormedAddCommGroup K] [InnerProductSpace ℂ K] [FiniteDimensional ℂ K]
      (n m : ℕ) (E : OrthonormalBasis (Fin n) ℂ H)
      (F : OrthonormalBasis (Fin m) ℂ K) (A : H →ₗ[ℂ] K),
    LinearMap.toMatrix F.toBasis E.toBasis (LinearMap.adjoint A) =
      (LinearMap.toMatrix E.toBasis F.toBasis A).conjTranspose

end NumStability.Bhatia.Chapter01.Targets
