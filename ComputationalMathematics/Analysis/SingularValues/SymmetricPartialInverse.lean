import Mathlib.LinearAlgebra.Matrix.PosDef
import Mathlib.Tactic.NoncommRing

/-!
# Symmetric partial inverses and complementary projections

Pure algebra of the four real Penrose equations. Construction of a
pseudoinverse is deliberately separate from this module.
-/

namespace NumStability

private theorem symmetric_absorption {n : ℕ} (P Q : Matrix (Fin n) (Fin n) ℝ)
    (hP : P.transpose = P) (hQ : Q.transpose = Q)
    (hPQ : P * Q = P) (hQP : Q * P = Q) : P = Q := by
  calc
    P = P * Q := hPQ.symm
    _ = (Q * P).transpose := by rw [Matrix.transpose_mul, hP, hQ]
    _ = Q.transpose := congrArg Matrix.transpose hQP
    _ = Q := hQ

/-- Uniqueness follows from the four literal Penrose equations, including for
rectangular matrices and empty index types. -/
theorem penrose_inverse_unique {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) (B C : Matrix (Fin n) (Fin m) ℝ)
    (hABA : (A * B) * A = A) (hBAB : (B * A) * B = B)
    (hAB : (A * B).transpose = A * B) (hBA : (B * A).transpose = B * A)
    (hACA : (A * C) * A = A) (hCAC : (C * A) * C = C)
    (hAC : (A * C).transpose = A * C) (hCA : (C * A).transpose = C * A) :
    B = C := by
  have hRange : A * B = A * C := by
    have h₁ : (A * B) * (A * C) = A * C := by
      rw [← Matrix.mul_assoc, hABA]
    have h₂ : (A * C) * (A * B) = A * B := by
      rw [← Matrix.mul_assoc, hACA]
    have h₃ := congrArg Matrix.transpose h₁
    simpa only [Matrix.transpose_mul, hAB, hAC, h₂] using h₃
  have hDomain : B * A = C * A := by
    apply symmetric_absorption _ _ hBA hCA
    · rw [Matrix.mul_assoc, ← Matrix.mul_assoc A C A, hACA]
    · rw [Matrix.mul_assoc, ← Matrix.mul_assoc A B A, hABA]
  calc
    B = (B * A) * B := hBAB.symm
    _ = B * (A * B) := Matrix.mul_assoc _ _ _
    _ = B * (A * C) := by rw [hRange]
    _ = (B * A) * C := (Matrix.mul_assoc _ _ _).symm
    _ = (C * A) * C := by rw [hDomain]
    _ = C := hCAC

/-- Exact algebraic data for an ambient symmetric partial inverse and its range
and complementary projections. No positivity or invertibility is required. -/
structure SymmetricPartialInverseData {n : ℕ}
    (S T P Q : Matrix (Fin n) (Fin n) ℝ) : Prop where
  inverse_symmetric : T.transpose = T
  range_symmetric : P.transpose = P
  complement_symmetric : Q.transpose = Q
  mul_inverse : S * T = P
  inverse_mul : T * S = P
  range_idempotent : P * P = P
  complement_eq : Q = 1 - P
  complement_idempotent : Q * Q = Q
  range_mul : P * S = S
  mul_range : S * P = S
  mul_complement : S * Q = 0
  complement_mul : Q * S = 0
  inverse_covariance : T * (S * S) * T.transpose = P
  covariance_completion : P + Q * Q.transpose = 1

/-- The Penrose inverse of a symmetric real matrix is symmetric and supplies
the exact complementary projection identities, with no rank restriction. -/
theorem symmetricPartialInverseData_of_penrose {n : ℕ}
    (S T : Matrix (Fin n) (Fin n) ℝ) (hS : S.transpose = S)
    (hSTS : (S * T) * S = S) (hTST : (T * S) * T = T)
    (hST : (S * T).transpose = S * T) (hTS : (T * S).transpose = T * S) :
    SymmetricPartialInverseData S T (S * T) (1 - S * T) := by
  have hT : T.transpose = T := by
    apply penrose_inverse_unique S T.transpose T
    · simpa only [Matrix.transpose_mul, hS, Matrix.mul_assoc] using
        congrArg Matrix.transpose hSTS
    · simpa only [Matrix.transpose_mul, hS, Matrix.mul_assoc] using
        congrArg Matrix.transpose hTST
    · simpa only [Matrix.transpose_mul, Matrix.transpose_transpose, hS] using hTS.symm
    · simpa only [Matrix.transpose_mul, Matrix.transpose_transpose, hS] using hST.symm
    · exact hSTS
    · exact hTST
    · exact hST
    · exact hTS
  have hcomm : T * S = S * T := by
    simpa only [Matrix.transpose_mul, hS, hT] using hST
  have hPP : (S * T) * (S * T) = S * T := by
    rw [← Matrix.mul_assoc, hSTS]
  have hSP : S * (S * T) = S := by
    rw [← hcomm, ← Matrix.mul_assoc, hSTS]
  have hQQ : (1 - S * T) * (1 - S * T) = 1 - S * T := by
    noncomm_ring [hPP]
  have hQ : (1 - S * T).transpose = 1 - S * T := by
    rw [Matrix.transpose_sub, Matrix.transpose_one, hST]
  refine ⟨hT, hST, hQ, rfl, hcomm, hPP, rfl, hQQ, hSTS, hSP, ?_, ?_, ?_, ?_⟩
  · rw [mul_sub, mul_one, hSP, sub_self]
  · rw [sub_mul, one_mul, hSTS, sub_self]
  · rw [hT]
    calc
      T * (S * S) * T = (T * S) * (S * T) := by simp only [Matrix.mul_assoc]
      _ = S * T := by rw [hcomm, hPP]
  · rw [hQ, hQQ]
    abel

end NumStability
