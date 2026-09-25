/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.CharacteristicCurvePropagationTarget

/-!
# Characteristic curves and traveling eigenvector waves
-/

namespace NumStability.Leveque02Tracer

/-- The characteristic coordinates propagate along the lines with their
eigenvalue speeds, and their initial values reconstruct the full state. -/
theorem characteristicCurvePropagation : characteristicCurvePropagationTarget := by
  intro m coefficient eigenvalues eigenbasis heigen
  let R : Matrix (Fin m) (Fin m) ℝ :=
    (Pi.basisFun ℝ (Fin m)).toMatrix eigenbasis
  let S : Matrix (Fin m) (Fin m) ℝ :=
    eigenbasis.toMatrix (Pi.basisFun ℝ (Fin m))
  have hSR : S * R = 1 := by
    simp [S, R]
  have hInv : R⁻¹ = S := Matrix.inv_eq_left_inv hSR
  have hcoord (v : Fin m → ℝ) : (R⁻¹).mulVec v = eigenbasis.equivFun v := by
    have hrepr : R.mulVec (eigenbasis.equivFun v) = v := by
      simpa only [R, Module.Basis.equivFun_apply, Pi.basisFun_repr] using
        (Module.Basis.toMatrix_mulVec_repr eigenbasis
          (Pi.basisFun ℝ (Fin m)) v)
    have h := congrArg (fun z => (R⁻¹).mulVec z) hrepr
    simpa only [Matrix.mulVec_mulVec, hInv, hSR, Matrix.one_mulVec] using h.symm
  change ∀ (q : ℝ → ℝ → (Fin m → ℝ)),
    Differentiable ℝ (Function.uncurry q) →
    (∀ x t, NumStability.IsConstantCoefficientLinearSystemSolutionAt
      q coefficient x t) →
    (∀ p x₀ t,
      (R⁻¹).mulVec (q (x₀ + eigenvalues p * t) t) p =
        (R⁻¹).mulVec (q x₀ 0) p) ∧
      ∀ x t, q x t =
        ∑ p, ((R⁻¹).mulVec
          (q (x - eigenvalues p * t) 0) p) • eigenbasis p
  intro q hdiff hpde
  obtain ⟨hprop, hsum⟩ := NumStability.constantCoefficientSystem_characteristicPropagation
    coefficient eigenbasis eigenvalues heigen q hdiff hpde
  constructor
  · intro p x₀ t
    rw [hcoord, hcoord]
    simpa only [add_sub_cancel_right] using
      (hprop p (x₀ + eigenvalues p * t) t)
  · intro x t
    simpa only [hcoord] using hsum x t

end NumStability.Leveque02Tracer
