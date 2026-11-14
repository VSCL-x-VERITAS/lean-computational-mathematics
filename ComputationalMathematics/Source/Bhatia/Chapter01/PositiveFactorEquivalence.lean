/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Source.Bhatia.Chapter01.PositiveFactorTarget
import ComputationalMathematics.Analysis.InnerProductSpace.LinearMap.PositiveSquareRoot
import ComputationalMathematics.Analysis.InnerProductSpace.QR.GramFactor

/-!
# Bhatia's positive-factor equivalences

A positive operator has a Gram factor in every supplied orthonormal basis.
Unconditional completed Gram–Schmidt gives normalized upper-triangular factors,
including singular and zero-dimensional cases. All reverse implications are
retained; no uniqueness conclusion is added here.
-/

set_option autoImplicit false
open scoped Matrix ComplexOrder
universe u

namespace NumStability.Bhatia.Chapter01

/-- The four positive-factor conditions are equivalent in the given basis. -/
theorem positiveFactorEquivalence : Targets.positiveFactorEquivalence.{u} := by
  classical
  intro H _ _ _ n E A
  let M := LinearMap.toMatrix E.toBasis E.toBasis A
  let gram := fun B : Matrix (Fin n) (Fin n) ℂ => M = Bᴴ * B
  let upper := fun T : Matrix (Fin n) (Fin n) ℂ => T.BlockTriangular id ∧ gram T
  let normalized := fun T : Matrix (Fin n) (Fin n) ℂ =>
    T.BlockTriangular id ∧ (∀ i, ∃ d : ℝ, 0 ≤ d ∧ T i i = (d : ℂ)) ∧ gram T
  change (A.IsPositive ↔ ∃ B, gram B) ∧
    ((∃ B, gram B) ↔ ∃ T, upper T) ∧
    ((∃ T, upper T) ↔ ∃ T, normalized T)
  refine ⟨?_, ?_, ?_⟩
  · constructor
    · intro hA
      let P := NumStability.positiveSquareRoot A hA
      have hP : P.IsPositive := NumStability.positiveSquareRoot_isPositive A hA
      have hsq : P.comp P = A := NumStability.positiveSquareRoot_comp_self A hA
      have hadj : LinearMap.adjoint P = P :=
        LinearMap.isSelfAdjoint_iff'.mp
          ((LinearMap.isSymmetric_iff_isSelfAdjoint P).mp hP.isSymmetric)
      let B := LinearMap.toMatrix E.toBasis E.toBasis P
      have hB : Bᴴ = B := by
        dsimp only [B]
        rw [← LinearMap.toMatrix_adjoint E E P, hadj]
      refine ⟨B, ?_⟩
      change M = Bᴴ * B
      calc
        M = LinearMap.toMatrix E.toBasis E.toBasis (P.comp P) :=
          congrArg (LinearMap.toMatrix E.toBasis E.toBasis) hsq.symm
        _ = B * B := LinearMap.toMatrix_comp E.toBasis E.toBasis E.toBasis P P
        _ = Bᴴ * B := by rw [hB]
    · rintro ⟨B, hB⟩
      apply (LinearMap.posSemidef_toMatrix_iff E).mp
      change M.PosSemidef
      change M = Bᴴ * B at hB
      rw [hB]
      exact Matrix.posSemidef_conjTranspose_mul_self B
  · constructor
    · rintro ⟨B, hB⟩
      obtain ⟨R, hR, hdiag, hGram⟩ := NumStability.exists_upperTriangular_gram_factor B
      exact ⟨R, hR, hB.trans hGram.symm⟩
    · rintro ⟨T, hT⟩
      exact ⟨T, hT.2⟩
  · constructor
    · rintro ⟨T, hT⟩
      obtain ⟨R, hR, hdiag, hGram⟩ := NumStability.exists_upperTriangular_gram_factor T
      exact ⟨R, hR, hdiag, hT.2.trans hGram.symm⟩
    · rintro ⟨T, hT⟩
      exact ⟨T, hT.1, hT.2.2⟩

end NumStability.Bhatia.Chapter01
