/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.StationaryAcousticsEigenvaluesTarget
import Mathlib.LinearAlgebra.Matrix.Notation

/-!
# LeVeque Chapter 2: similarity of the wave and stationary-acoustics matrices
-/

namespace NumStability.Leveque02Tracer

/-- The first-order matrix associated with the scalar wave equation (2.77). -/
def waveFirstOrderMatrix (soundSpeed : ℝ) : Matrix (Fin 2) (Fin 2) ℝ :=
  !![0, soundSpeed ^ 2; 1, 0]

/-- The first-order wave matrix is similar to the stationary acoustic matrix
through `S = diag(1, ρ₀)` and has the same two real wave speeds. -/
def waveAcousticsSimilarityTarget : Prop :=
  ∀ (bulkModulus density : ℝ), 0 < bulkModulus → 0 < density →
    let soundSpeed := Real.sqrt (bulkModulus / density)
    let S : Matrix (Fin 2) (Fin 2) ℝ := Matrix.diagonal ![1, density]
    let SInv : Matrix (Fin 2) (Fin 2) ℝ := Matrix.diagonal ![1, density⁻¹]
    S * SInv = 1 ∧ SInv * S = 1 ∧
      waveFirstOrderMatrix soundSpeed =
        S * linearAcousticsMatrix bulkModulus density * SInv ∧
      Module.End.HasEigenvalue
        (Matrix.toLin' (waveFirstOrderMatrix soundSpeed)) (-soundSpeed) ∧
      Module.End.HasEigenvalue
        (Matrix.toLin' (waveFirstOrderMatrix soundSpeed)) soundSpeed

end NumStability.Leveque02Tracer
