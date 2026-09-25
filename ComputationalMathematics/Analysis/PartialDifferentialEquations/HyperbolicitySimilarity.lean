/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity
import Mathlib.Analysis.Matrix.Spectrum
import Mathlib.LinearAlgebra.Matrix.ToLin

/-!
# Real hyperbolicity under invertible similarity
-/

namespace NumStability

/-- A real symmetric matrix on any finite state index has a complete real
eigenbasis. -/
theorem IsRealHyperbolicMatrix.of_symm
    {ι : Type*} [Fintype ι] [DecidableEq ι]
    {A : Matrix ι ι ℝ} (hA : A.IsSymm) : IsRealHyperbolicMatrix A := by
  have hhermitian : A.IsHermitian := by
    change A.conjTranspose = A
    simpa only [Matrix.conjTranspose_eq_transpose_of_trivial] using hA.eq
  let b : Module.Basis ι ℝ (ι → ℝ) :=
    hhermitian.eigenvectorBasis.toBasis.map
      (EuclideanSpace.equiv ι ℝ).toLinearEquiv
  refine ⟨hhermitian.eigenvalues, b, ?_⟩
  intro p
  simpa only [b, Module.Basis.map_apply] using
    hhermitian.mulVec_eigenvectorBasis p

/-- An invertible real change of state transports a complete real eigenbasis.
This applies to constant-coefficient directional symbols. -/
theorem IsRealHyperbolicMatrix.of_similar
    {ι : Type*} [Fintype ι] [DecidableEq ι]
    {A B T U : Matrix ι ι ℝ}
    (hTU : T * U = 1) (hUT : U * T = 1)
    (hA : A = U * B * T)
    (hB : IsRealHyperbolicMatrix B) : IsRealHyperbolicMatrix A := by
  rcases hB with ⟨eigenvalues, eigenbasis, heigen⟩
  let stateEquiv : (ι → ℝ) ≃ₗ[ℝ] (ι → ℝ) :=
    Matrix.toLin'OfInv hTU hUT
  let transported : Module.Basis ι ℝ (ι → ℝ) :=
    eigenbasis.map stateEquiv
  refine ⟨eigenvalues, transported, ?_⟩
  intro p
  have htransport : transported p = U.mulVec (eigenbasis p) := by
    rfl
  rw [htransport, hA]
  calc
    (U * B * T).mulVec (U.mulVec (eigenbasis p)) =
        (U * B * T * U).mulVec (eigenbasis p) := by
      rw [Matrix.mulVec_mulVec]
    _ = (U * B).mulVec (eigenbasis p) := by
      rw [Matrix.mul_assoc (U * B) T U, hTU, Matrix.mul_one]
    _ = U.mulVec (B.mulVec (eigenbasis p)) := by
      rw [Matrix.mulVec_mulVec]
    _ = eigenvalues p • U.mulVec (eigenbasis p) := by
      rw [heigen p, Matrix.mulVec_smul]

end NumStability
