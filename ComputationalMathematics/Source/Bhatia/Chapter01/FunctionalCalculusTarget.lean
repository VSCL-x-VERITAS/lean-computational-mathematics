/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.CStarAlgebra.Matrix
import Mathlib.Analysis.CStarAlgebra.ContinuousFunctionalCalculus.Basic
import Mathlib.Analysis.CStarAlgebra.ContinuousFunctionalCalculus.Unital
import Mathlib.Analysis.InnerProductSpace.Adjoint
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.LinearAlgebra.Matrix.ToLin
import Mathlib.LinearAlgebra.Matrix.Block
import Mathlib.LinearAlgebra.Matrix.IsDiag
import Mathlib.LinearAlgebra.Matrix.Charpoly.Basic
import Mathlib.LinearAlgebra.UnitaryGroup

/-!
# Functions of normal operators

Transparent statement contracts for Bhatia, Matrix Analysis (1997), I.2.
All matrices use the actual operator norm on complex Euclidean space.
-/

set_option autoImplicit false

noncomputable section

open scoped BigOperators Matrix Matrix.Norms.L2Operator

universe u

namespace NumStability.Bhatia.Chapter01.Targets

set_option backward.isDefEq.respectTransparency false in
local instance (n : ℕ) : CStarAlgebra (Matrix (Fin n) (Fin n) ℂ) where

attribute [local instance] IsStarNormal.instContinuousFunctionalCalculus

set_option backward.isDefEq.respectTransparency false in
/-- Actual complex functional calculus realizes the source diagonal rule and
agrees with every unitary spectral representation. No regularity assumption
is made on f: continuity on the finite spectrum is a conclusion. Coordinate
round trips and the adjoint/composition identities are conclusions as well. -/
def normalOperatorComplexFunctionalCalculus : Prop :=
  (∀ (n : ℕ) (lam : Fin n → ℂ) (f : ℂ → ℂ),
    cfc (p := IsStarNormal) f (Matrix.diagonal lam) = Matrix.diagonal (fun i => f (lam i))) ∧
  (∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (A : H →ₗ[ℂ] H),
    let n := Module.finrank ℂ H
    let E := stdOrthonormalBasis ℂ H
    let mat := LinearMap.toMatrix E.toBasis E.toBasis
    let lift := Matrix.toLin E.toBasis E.toBasis
    let M := mat A
    IsStarNormal A →
      IsStarNormal M ∧ (spectrum ℂ M).Finite ∧
      (∀ B : H →ₗ[ℂ] H,
        lift (mat B) = B ∧
        mat (LinearMap.adjoint B) = (mat B)ᴴ ∧
        (∀ i j, mat B i j = inner ℂ (E i) (B (E j))) ∧
        (∀ C : H →ₗ[ℂ] H, mat (B.comp C) = mat B * mat C)) ∧
      (∀ N : Matrix (Fin n) (Fin n) ℂ, mat (lift N) = N) ∧
      (∀ b : OrthonormalBasis (Fin n) ℂ H,
        LinearMap.toMatrix b.toBasis E.toBasis (LinearMap.id : H →ₗ[ℂ] H) ∈
          unitary (Matrix (Fin n) (Fin n) ℂ)) ∧
      (∃ (b : OrthonormalBasis (Fin n) ℂ H) (lam : Fin n → ℂ),
        LinearMap.toMatrix b.toBasis b.toBasis A = Matrix.diagonal lam) ∧
      (∀ f : ℂ → ℂ,
        ContinuousOn f (spectrum ℂ M) ∧
        (let complexNormalCFC := cfc (p := IsStarNormal) f M
         let fA := lift complexNormalCFC
         mat fA = complexNormalCFC ∧
         (∀ (Q : Matrix.unitaryGroup (Fin n) ℂ) (lam : Fin n → ℂ),
           M = (Q : Matrix (Fin n) (Fin n) ℂ) * Matrix.diagonal lam *
             (Q : Matrix (Fin n) (Fin n) ℂ)ᴴ →
           spectrum ℂ M = Set.range lam ∧
           complexNormalCFC =
             (Q : Matrix (Fin n) (Fin n) ℂ) *
               Matrix.diagonal (fun i => f (lam i)) *
               (Q : Matrix (Fin n) (Fin n) ℂ)ᴴ ∧
           fA = lift ((Q : Matrix (Fin n) (Fin n) ℂ) *
             Matrix.diagonal (fun i => f (lam i)) *
             (Q : Matrix (Fin n) (Fin n) ℂ)ᴴ)) ∧
         (∀ (b : OrthonormalBasis (Fin n) ℂ H) (lam : Fin n → ℂ),
           LinearMap.toMatrix b.toBasis b.toBasis A = Matrix.diagonal lam →
           LinearMap.toMatrix b.toBasis b.toBasis fA =
             Matrix.diagonal (fun i => f (lam i)) ∧
           (∀ i, fA (b i) = f (lam i) • b i)))))

end NumStability.Bhatia.Chapter01.Targets
