/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.WaveAcousticsSimilarityTarget

/-!
# Proof-free target: Exercise 2.3

The exercise asks for the eigenpairs of the first-order wave matrix (2.77)
and its similarity to the stationary acoustics matrix (2.51). The claim is
about matrices at positive reference density and bulk modulus; it does not
identify the wave derivative state directly with the acoustics field state.
-/

namespace NumStability.Leveque02Tracer

/-- The two explicit eigenpairs of (2.77), together with an invertible
diagonal similarity to the stationary acoustics matrix (2.51). -/
def exercise23Target : Prop :=
  ∀ (bulkModulus density : ℝ), 0 < bulkModulus → 0 < density →
    let speed := Real.sqrt (bulkModulus / density)
    let wave := waveFirstOrderMatrix speed
    let left : Fin 2 → ℝ := ![-speed, 1]
    let right : Fin 2 → ℝ := ![speed, 1]
    let S : Matrix (Fin 2) (Fin 2) ℝ := Matrix.diagonal ![1, density]
    let SInv : Matrix (Fin 2) (Fin 2) ℝ := Matrix.diagonal ![1, density⁻¹]
    0 < speed ∧
      wave.mulVec left = (-speed) • left ∧ left ≠ 0 ∧
      wave.mulVec right = speed • right ∧ right ≠ 0 ∧
      S * SInv = 1 ∧ SInv * S = 1 ∧
      wave = S * linearAcousticsMatrix bulkModulus density * SInv

end NumStability.Leveque02Tracer
