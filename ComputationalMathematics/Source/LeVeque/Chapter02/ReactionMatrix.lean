/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.ReactionMatrixTarget
import Mathlib.LinearAlgebra.StdBasis

/-!
# Matrix form of the reacting species equations

The repeated velocity coefficient acts by scalar multiplication. Its standard
basis is a real eigenbasis, and the actual species balance is equivalent to
the matrix equation with the same kinetic source.
-/

namespace NumStability.Leveque02Tracer

/-- The reacting system has its stated matrix form and real hyperbolicity. -/
theorem reactionMatrix : reactionMatrixTarget := by
  intro m velocity
  dsimp only
  have haction (v : Fin m → ℝ) :
      (Matrix.diagonal (fun _ : Fin m => velocity)).mulVec v = velocity • v := by
    ext i
    simp only [Matrix.mulVec_diagonal, Pi.smul_apply, smul_eq_mul]
  constructor
  · exact ⟨fun _ => velocity, Pi.basisFun ℝ (Fin m), fun p => haction _⟩
  · intro q production spatialDerivative x t hspace
    constructor
    · rintro ⟨qt, fluxDerivative, htime, hflux, hbalance⟩
      have hvalue := hflux.unique (hspace.const_smul velocity)
      refine ⟨qt, htime, ?_⟩
      rw [haction]
      simpa only [hvalue] using hbalance
    · rintro ⟨qt, htime, hbalance⟩
      refine ⟨qt, velocity • spatialDerivative, htime, hspace.const_smul velocity, ?_⟩
      simpa only [haction] using hbalance

end NumStability.Leveque02Tracer
