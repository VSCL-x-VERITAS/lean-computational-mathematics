/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Source.Bhatia.Chapter01.MatrixGroupsTarget

/-!
# Bhatia Chapter I: the general linear and unitary groups

Exercise I.2.7, printed page 7: the invertible and the unitary complex matrices
are groups under matrix multiplication, namely `GL(n)` and `U(n)`.
-/

set_option autoImplicit false

namespace NumStability.Bhatia.Chapter01

open Matrix

/-- Unitary matrices are invertible, with inverse equal to the conjugate transpose. -/
private lemma inv_eq_conjTranspose_of_unitary {n : ℕ} {A : Matrix (Fin n) (Fin n) ℂ}
    (h : A.conjTranspose * A = 1) : A⁻¹ = A.conjTranspose :=
  Matrix.inv_eq_left_inv h

/-- Exercise I.2.7: `GL(n)` and `U(n)` are groups under matrix multiplication. -/
theorem matrixGroupsUnderMultiplication : Targets.matrixGroupsUnderMultiplication := by
  intro n
  refine ⟨?_, ?_⟩
  · refine ⟨isUnit_one, fun A hA B hB => hA.mul hB, fun A _ B _ C _ => Matrix.mul_assoc A B C,
      fun A hA => ?_, ?_⟩
    · have hd : IsUnit A.det := (Matrix.isUnit_iff_isUnit_det A).1 hA
      exact ⟨(Matrix.isUnit_nonsing_inv_iff).2 hA, Matrix.nonsing_inv_mul A hd,
        Matrix.mul_nonsing_inv A hd⟩
    · ext A
      simp only [Set.mem_range, Set.mem_setOf_eq]
      constructor
      · rintro ⟨g, rfl⟩
        exact Units.isUnit g
      · rintro ⟨g, rfl⟩
        exact ⟨g, rfl⟩
  · refine ⟨⟨by simp, by simp⟩, fun A hA B hB => ⟨?_, ?_⟩,
      fun A _ B _ C _ => Matrix.mul_assoc A B C, fun A hA => ?_, ?_⟩
    · rw [Matrix.conjTranspose_mul, Matrix.mul_assoc, ← Matrix.mul_assoc B, hB.1,
        Matrix.one_mul, hA.1]
    · rw [Matrix.conjTranspose_mul, Matrix.mul_assoc, ← Matrix.mul_assoc A.conjTranspose, hA.2,
        Matrix.one_mul, hB.2]
    · rw [inv_eq_conjTranspose_of_unitary hA.2]
      refine ⟨?_, hA.2, hA.1⟩
      show Aᴴ * Aᴴᴴ = 1 ∧ Aᴴᴴ * Aᴴ = 1
      rw [Matrix.conjTranspose_conjTranspose]
      exact ⟨hA.2, hA.1⟩
    · ext A
      simp only [SetLike.mem_coe, Matrix.mem_unitaryGroup_iff,
        Set.mem_setOf_eq, Matrix.star_eq_conjTranspose]
      constructor
      · intro h
        exact ⟨h, (Matrix.mem_unitaryGroup_iff' (A := A)).1
          ((Matrix.mem_unitaryGroup_iff (A := A)).2 h)⟩
      · exact fun h => h.1

end NumStability.Bhatia.Chapter01
