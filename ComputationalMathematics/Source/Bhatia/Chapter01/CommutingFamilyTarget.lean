/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.Adjoint
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.LinearAlgebra.Matrix.ToLin
import Mathlib.LinearAlgebra.Matrix.Block
import Mathlib.LinearAlgebra.Matrix.IsDiag

/-!
# Bhatia Exercise I.2.3: common bases for commuting families

The family has an arbitrary index type. One orthonormal basis is chosen before
all family members, and no finiteness or nonemptiness of the family is assumed.
-/

set_option autoImplicit false
universe u v

namespace NumStability.Bhatia.Chapter01.Targets

/-- A commuting family admits one common Schur basis. -/
def commonSchurBasis : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (I : Type v) (A : I → H →ₗ[ℂ] H),
    (∀ a b : I, (A a).comp (A b) = (A b).comp (A a)) →
    ∃ E : OrthonormalBasis (Fin (Module.finrank ℂ H)) ℂ H,
      ∀ a : I,
        Matrix.BlockTriangular (LinearMap.toMatrix E.toBasis E.toBasis (A a))
          (fun i : Fin (Module.finrank ℂ H) => i)

/-- A commuting family of normal operators admits one common eigenbasis. -/
def commonDiagonalBasis : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (I : Type v) (A : I → H →ₗ[ℂ] H),
    (∀ a b : I, (A a).comp (A b) = (A b).comp (A a)) →
    (∀ a : I, IsStarNormal (A a)) →
    ∃ E : OrthonormalBasis (Fin (Module.finrank ℂ H)) ℂ H,
      ∀ a : I, (LinearMap.toMatrix E.toBasis E.toBasis (A a)).IsDiag

end NumStability.Bhatia.Chapter01.Targets
