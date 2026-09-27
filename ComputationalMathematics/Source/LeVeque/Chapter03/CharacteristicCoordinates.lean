/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.CharacteristicVariables

/-!
# Characteristic coordinates in LeVeque Chapter 3

The characteristic coordinates on printed page 47 use the same right-eigenvector
matrix and orientation as the Chapter 2 diagonalization.
-/

namespace NumStability

/-- The characteristic variables `w = R⁻¹ q` from printed page 47. -/
noncomputable def leveque03_characteristicVariables
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (q : Fin m → ℝ) : Fin m → ℝ :=
  let R := (Pi.basisFun ℝ (Fin m)).toMatrix eigenbasis
  (R⁻¹).mulVec q

/-- The initial characteristic profile is the coordinate transform of the
initial state, as on printed page 48. -/
noncomputable def leveque03_initialCharacteristicVariables
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (initialState : ℝ → (Fin m → ℝ)) (x : ℝ) : Fin m → ℝ :=
  leveque03_characteristicVariables eigenbasis (initialState x)

/-- The coefficients of a state in a fixed real eigenbasis are the entries of
`R⁻¹ q`, where the columns of `R` are the basis vectors. -/
theorem leveque03_characteristicCoordinates
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (q : Fin m → ℝ) :
    let R := (Pi.basisFun ℝ (Fin m)).toMatrix eigenbasis
    (R⁻¹).mulVec q = eigenbasis.equivFun q := by
  let R : Matrix (Fin m) (Fin m) ℝ :=
    (Pi.basisFun ℝ (Fin m)).toMatrix eigenbasis
  let S : Matrix (Fin m) (Fin m) ℝ :=
    eigenbasis.toMatrix (Pi.basisFun ℝ (Fin m))
  change (R⁻¹).mulVec q = eigenbasis.equivFun q
  have hSR : S * R = 1 := by simp [S, R]
  have hInv : R⁻¹ = S := Matrix.inv_eq_left_inv hSR
  have hrepr : R.mulVec (eigenbasis.equivFun q) = q := by
    simpa only [R, Module.Basis.equivFun_apply, Pi.basisFun_repr] using
      (Module.Basis.toMatrix_mulVec_repr eigenbasis
        (Pi.basisFun ℝ (Fin m)) q)
  have h := congrArg (fun z => (R⁻¹).mulVec z) hrepr
  simpa only [Matrix.mulVec_mulVec, hInv, hSR, Matrix.one_mulVec] using h.symm

end NumStability
