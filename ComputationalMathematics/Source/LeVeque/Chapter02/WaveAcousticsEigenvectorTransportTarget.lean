/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.WaveAcousticsSimilarityTarget

/-! The first-order wave matrix is similar to stationary acoustics, with matching eigenpairs. -/

namespace NumStability.Leveque02Tracer

/-- The similarity from (2.51) to (2.77) preserves eigenvalues and maps each
acoustic eigenvector through the change of variables. -/
def waveAcousticsEigenvectorTransportTarget : Prop :=
  ∀ (bulkModulus density : ℝ), 0 < bulkModulus → 0 < density →
    let speed := Real.sqrt (bulkModulus / density)
    let wave := waveFirstOrderMatrix speed
    let acoustic := linearAcousticsMatrix bulkModulus density
    let S : Matrix (Fin 2) (Fin 2) ℝ := Matrix.diagonal ![1, density]
    let SInv : Matrix (Fin 2) (Fin 2) ℝ := Matrix.diagonal ![1, density⁻¹]
    S * SInv = 1 ∧ SInv * S = 1 ∧ wave = S * acoustic * SInv ∧
      ∀ (eigenvalue : ℝ) (v : Fin 2 → ℝ),
        acoustic.mulVec v = eigenvalue • v →
        wave.mulVec (S.mulVec v) = eigenvalue • (S.mulVec v) ∧
          (v ≠ 0 → S.mulVec v ≠ 0)

end NumStability.Leveque02Tracer
