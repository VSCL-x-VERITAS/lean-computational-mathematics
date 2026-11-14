/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.SingularValues.Basic
import Mathlib.Analysis.InnerProductSpace.Adjoint
import Mathlib.Analysis.InnerProductSpace.Positive
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.Analysis.Matrix.Order
import Mathlib.Analysis.SpecialFunctions.ContinuousFunctionalCalculus.Rpow.Basic
import Mathlib.LinearAlgebra.Matrix.ToLin
import Mathlib.Algebra.Star.Unitary
import Mathlib.Algebra.Star.SelfAdjoint

/-!
# Singular values and polar decomposition

Transparent statement contracts for Bhatia, Matrix Analysis (1997), I.2.
All operators are endomorphisms of finite-dimensional complex Hilbert spaces.
`Fin n` index i represents the source index i.val + 1.
-/

set_option autoImplicit false

noncomputable section

open scoped ComplexOrder MatrixOrder Matrix

universe u

namespace NumStability.Bhatia.Chapter01.Targets

/-- Coordinate correspondences are independent conclusions. No source statement
assumes a coordinate transport, adjoint identity or positivity equivalence. -/
def svdPolarCoordinateCorrespondence : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H],
    let n := Module.finrank ℂ H
    let e := stdOrthonormalBasis ℂ H
    let mat := LinearMap.toMatrix e.toBasis e.toBasis
    let lift := Matrix.toLin e.toBasis e.toBasis
    (∀ A : H →ₗ[ℂ] H,
      lift (mat A) = A ∧
      mat (LinearMap.adjoint A) = (mat A)ᴴ ∧
      (∀ i j, mat A i j = inner ℂ (e i) (A (e j))) ∧
      (∀ B : H →ₗ[ℂ] H, mat (A.comp B) = mat A * mat B) ∧
      (A.IsPositive ↔ Matrix.PosSemidef (mat A)) ∧
      (A ∈ unitary (H →ₗ[ℂ] H) ↔ mat A ∈ unitary (Matrix (Fin n) (Fin n) ℂ)) ∧
      (IsStarNormal A ↔ IsStarNormal (mat A)) ∧
      (IsUnit A ↔ IsUnit (mat A))) ∧
    (∀ M : Matrix (Fin n) (Fin n) ℂ, mat (lift M) = M) ∧
    (∀ b : OrthonormalBasis (Fin n) ℂ H,
      LinearMap.toMatrix b.toBasis e.toBasis (LinearMap.id : H →ₗ[ℂ] H) ∈
        unitary (Matrix (Fin n) (Fin n) ℂ)) ∧
    (∀ (A : H →ₗ[ℂ] H) (w q : OrthonormalBasis (Fin n) ℂ H),
      let W := LinearMap.toMatrix w.toBasis e.toBasis (LinearMap.id : H →ₗ[ℂ] H)
      let Q := LinearMap.toMatrix q.toBasis e.toBasis (LinearMap.id : H →ₗ[ℂ] H)
      Wᴴ * mat A * Q = LinearMap.toMatrix q.toBasis w.toBasis A)

set_option backward.isDefEq.respectTransparency false in
/-- The prescribed absolute operator is the actual CFC square root in an
actual orthonormal basis, transported to H. Positivity, squaring and uniqueness
are conclusions, including positivity of the Gram operator. -/
def absoluteValuePositiveSquareRoot : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (A : H →ₗ[ℂ] H),
    let e := stdOrthonormalBasis ℂ H
    let M := LinearMap.toMatrix e.toBasis e.toBasis A
    let absA := Matrix.toLin e.toBasis e.toBasis (CFC.sqrt (Mᴴ * M))
    ((LinearMap.adjoint A).comp A).IsPositive ∧
    absA.IsPositive ∧
    absA.comp absA = (LinearMap.adjoint A).comp A ∧
    (∀ P : H →ₗ[ℂ] H, P.IsPositive →
      P.comp P = (LinearMap.adjoint A).comp A → P = absA)

set_option backward.isDefEq.respectTransparency false in
/-- The fixed existing singular-value producer gives the complete decreasing
ONB eigenvalue tuple of the actual absolute operator, with zeros and repetitions. -/
def singularValuesAbsoluteEigenvalueTuple : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (A : H →ₗ[ℂ] H),
    let n := Module.finrank ℂ H
    let e := stdOrthonormalBasis ℂ H
    let M := LinearMap.toMatrix e.toBasis e.toBasis A
    let absA := Matrix.toLin e.toBasis e.toBasis (CFC.sqrt (Mᴴ * M))
    let s : Fin n → ℝ := NumStability.complexMatrixSingularValue M
    Antitone s ∧ (∀ i, 0 ≤ s i) ∧
    ∃ q : OrthonormalBasis (Fin n) ℂ H,
      ∀ i, absA (q i) = (s i : ℂ) • q i

/-- Both singular frames are full orthonormal bases, existentially constructed.
In particular the left frame on the zero block is not a normalized zero vector. -/
def fullOrthonormalSingularValueDecomposition : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (A : H →ₗ[ℂ] H),
    let n := Module.finrank ℂ H
    let e := stdOrthonormalBasis ℂ H
    let M := LinearMap.toMatrix e.toBasis e.toBasis A
    let s : Fin n → ℝ := NumStability.complexMatrixSingularValue M
    ∃ w q : OrthonormalBasis (Fin n) ℂ H,
      let W := LinearMap.toMatrix w.toBasis e.toBasis (LinearMap.id : H →ₗ[ℂ] H)
      let Q := LinearMap.toMatrix q.toBasis e.toBasis (LinearMap.id : H →ₗ[ℂ] H)
      W ∈ unitary (Matrix (Fin n) (Fin n) ℂ) ∧
      Q ∈ unitary (Matrix (Fin n) (Fin n) ℂ) ∧
      Wᴴ * M * Q = Matrix.diagonal (fun i => (s i : ℂ))

/-- Every supplied valid ordered SVD gives the correctly oriented unit right
and left eigenvectors, including at zero singular values. -/
def singularVectorsFromOrderedDecomposition : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (A : H →ₗ[ℂ] H),
    let n := Module.finrank ℂ H
    let e := stdOrthonormalBasis ℂ H
    let M := LinearMap.toMatrix e.toBasis e.toBasis A
    let s : Fin n → ℝ := NumStability.complexMatrixSingularValue M
    ∀ w q : OrthonormalBasis (Fin n) ℂ H,
      let W := LinearMap.toMatrix w.toBasis e.toBasis (LinearMap.id : H →ₗ[ℂ] H)
      let Q := LinearMap.toMatrix q.toBasis e.toBasis (LinearMap.id : H →ₗ[ℂ] H)
      Wᴴ * M * Q = Matrix.diagonal (fun i => (s i : ℂ)) →
      ∀ i : Fin n,
        (q i ≠ 0 ∧ ‖q i‖ = 1 ∧
          (LinearMap.adjoint A) (A (q i)) = ((s i ^ 2 : ℝ) : ℂ) • q i) ∧
        (w i ≠ 0 ∧ ‖w i‖ = 1 ∧
          A ((LinearMap.adjoint A) (w i)) = ((s i ^ 2 : ℝ) : ℂ) • w i)

/-- Every operator has a full unitary-times-positive factorization. No partial
isometry or invertibility premise replaces the full unitary extension. -/
def fullUnitaryPositivePolarExistence : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (A : H →ₗ[ℂ] H),
    ∃ U P : H →ₗ[ℂ] H,
      U ∈ unitary (H →ₗ[ℂ] H) ∧ P.IsPositive ∧ A = U.comp P

set_option backward.isDefEq.respectTransparency false in
/-- Every positive polar factor equals the prescribed absolute operator.
Invertibility is sufficient for equality of any two unitary polar factors. -/
def positivePolarFactorAndInvertibleUnitaryUniqueness : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (A : H →ₗ[ℂ] H),
    let e := stdOrthonormalBasis ℂ H
    let M := LinearMap.toMatrix e.toBasis e.toBasis A
    let absA := Matrix.toLin e.toBasis e.toBasis (CFC.sqrt (Mᴴ * M))
    (∀ U P : H →ₗ[ℂ] H,
      U ∈ unitary (H →ₗ[ℂ] H) → P.IsPositive → A = U.comp P → P = absA) ∧
    (IsUnit A → ∀ U P U' P' : H →ₗ[ℂ] H,
      U ∈ unitary (H →ₗ[ℂ] H) → P.IsPositive → A = U.comp P →
      U' ∈ unitary (H →ₗ[ℂ] H) → P'.IsPositive → A = U'.comp P' → U = U')

/-- Normality iff the supplied valid polar factors commute, for every actual
factorization, including singular operators and nonunique unitary extensions. -/
def polarNormalityCommutationCharacterization : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (A U P : H →ₗ[ℂ] H),
    U ∈ unitary (H →ₗ[ℂ] H) → P.IsPositive → A = U.comp P →
      (IsStarNormal A ↔ U.comp P = P.comp U)

/-- A supplied actual polar factorization produces an ordered eigenbasis q
of its positive factor and the full left basis w_i = U(q_i), yielding the SVD. -/
def orderedSingularDecompositionFromPolarData : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (A U P : H →ₗ[ℂ] H),
    let n := Module.finrank ℂ H
    let e := stdOrthonormalBasis ℂ H
    let M := LinearMap.toMatrix e.toBasis e.toBasis A
    let s : Fin n → ℝ := NumStability.complexMatrixSingularValue M
    U ∈ unitary (H →ₗ[ℂ] H) → P.IsPositive → A = U.comp P →
    ∃ q w : OrthonormalBasis (Fin n) ℂ H,
      (∀ i, P (q i) = (s i : ℂ) • q i) ∧
      (∀ i, w i = U (q i)) ∧
      (let W := LinearMap.toMatrix w.toBasis e.toBasis (LinearMap.id : H →ₗ[ℂ] H)
       let Q := LinearMap.toMatrix q.toBasis e.toBasis (LinearMap.id : H →ₗ[ℂ] H)
       W ∈ unitary (Matrix (Fin n) (Fin n) ℂ) ∧
       Q ∈ unitary (Matrix (Fin n) (Fin n) ℂ) ∧
       Wᴴ * M * Q = Matrix.diagonal (fun i => (s i : ℂ)))

end NumStability.Bhatia.Chapter01.Targets
