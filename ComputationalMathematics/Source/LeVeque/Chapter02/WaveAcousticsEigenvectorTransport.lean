/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.WaveAcousticsEigenvectorTransportTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.WaveAcousticsSimilarity

/-!
# LeVeque Chapter 2: WaveAcousticsEigenvectorTransport

Transport of eigenvectors between wave and acoustic variables.
-/

namespace NumStability.Leveque02Tracer

theorem waveAcousticsEigenvectorTransport :
    waveAcousticsEigenvectorTransportTarget := by
  intro bulkModulus density hbulk hdensity
  obtain ⟨hS, hSinv, hwave, _, _⟩ :=
    waveAcousticsSimilarity bulkModulus density hbulk hdensity
  let S : Matrix (Fin 2) (Fin 2) ℝ := Matrix.diagonal ![1, density]
  let SInv : Matrix (Fin 2) (Fin 2) ℝ := Matrix.diagonal ![1, density⁻¹]
  let acoustic := linearAcousticsMatrix bulkModulus density
  let wave := waveFirstOrderMatrix (Real.sqrt (bulkModulus / density))
  refine ⟨hS, hSinv, hwave, ?_⟩
  intro eigenvalue v hv
  constructor
  · have hback : (Matrix.diagonal ![1, density⁻¹]).mulVec
        ((Matrix.diagonal ![1, density]).mulVec v) = v := by
      rw [Matrix.mulVec_mulVec, hSinv, Matrix.one_mulVec]
    calc
      wave.mulVec (S.mulVec v)
          = (S * acoustic * SInv).mulVec (S.mulVec v) := by
            dsimp [wave, S, acoustic, SInv]
            rw [hwave]
      _ = S.mulVec (acoustic.mulVec (SInv.mulVec (S.mulVec v))) := by
        simp only [Matrix.mulVec_mulVec, Matrix.mul_assoc]
      _ = eigenvalue • S.mulVec v := by rw [hback, hv, Matrix.mulVec_smul]
  · intro hvne hzero
    have hback : SInv.mulVec (S.mulVec v) = SInv.mulVec 0 :=
      congrArg (fun w : Fin 2 → ℝ => SInv.mulVec w) hzero
    change (Matrix.diagonal ![1, density⁻¹]).mulVec
        ((Matrix.diagonal ![1, density]).mulVec v) =
        (Matrix.diagonal ![1, density⁻¹]).mulVec 0 at hback
    rw [Matrix.mulVec_mulVec, hSinv, Matrix.one_mulVec, Matrix.mulVec_zero] at hback
    exact hvne hback

end NumStability.Leveque02Tracer
