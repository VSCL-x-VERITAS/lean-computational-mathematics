/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter03.CharacteristicCoordinates

/-!
# Eigenvector reconstruction and wave superposition in LeVeque Chapter 3

Equation (3.6) and the algebraic reconstruction underlying (3.5), printed
page 48/raw PDF page 70.
-/

namespace NumStability

/-- Multiplying the characteristic coordinates by their eigenvector-column
matrix reconstructs the original state. -/
theorem leveque03_reconstructState
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (q : Fin m → ℝ) :
    let R := (Pi.basisFun ℝ (Fin m)).toMatrix eigenbasis
    R.mulVec (leveque03_characteristicVariables eigenbasis q) = q := by
  change ((Pi.basisFun ℝ (Fin m)).toMatrix eigenbasis).mulVec
      (leveque03_characteristicVariables eigenbasis q) = q
  rw [show leveque03_characteristicVariables eigenbasis q =
      eigenbasis.equivFun q from
    leveque03_characteristicCoordinates eigenbasis q]
  simpa only [Module.Basis.equivFun_apply, Pi.basisFun_repr] using
    (Module.Basis.toMatrix_mulVec_repr eigenbasis
      (Pi.basisFun ℝ (Fin m)) q)

/-- Coordinates of a state assembled with the eigenvector-column matrix are
the original wave strengths. -/
theorem leveque03_coordinatesOfReconstructed
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (w : Fin m → ℝ) :
    eigenbasis.equivFun
      (((Pi.basisFun ℝ (Fin m)).toMatrix eigenbasis).mulVec w) = w := by
  let R : Matrix (Fin m) (Fin m) ℝ :=
    (Pi.basisFun ℝ (Fin m)).toMatrix eigenbasis
  have h := Module.Basis.toMatrix_mulVec_repr eigenbasis
    (Pi.basisFun ℝ (Fin m)) (eigenbasis.equivFun.symm w)
  have heq : R.mulVec w = eigenbasis.equivFun.symm w := by
    simpa only [R, ← Module.Basis.equivFun_apply,
      LinearEquiv.apply_symm_apply, Pi.basisFun_repr] using h
  rw [← show R = (Pi.basisFun ℝ (Fin m)).toMatrix eigenbasis from rfl, heq]
  exact eigenbasis.equivFun.apply_symm_apply w

/-- Reassembling scalar characteristic solutions gives a solution of the
original constant-coefficient system. -/
theorem leveque03_reconstructedSystem
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (eigenvalues : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (eigenbasis p) =
      eigenvalues p • eigenbasis p)
    (w : ℝ → ℝ → (Fin m → ℝ))
    (hw : ∀ p x t, IsLinearAdvectionSolutionAt
      (fun ξ τ => w ξ τ p) (eigenvalues p) x t)
    (x t : ℝ) :
    let R := (Pi.basisFun ℝ (Fin m)).toMatrix eigenbasis
    IsConstantCoefficientLinearSystemSolutionAt
      (fun ξ τ => R.mulVec (w ξ τ)) coefficient x t := by
  apply (constantCoefficientSystem_iff_eigenbasisAdvection
    coefficient eigenbasis eigenvalues heigen
    (fun ξ τ => ((Pi.basisFun ℝ (Fin m)).toMatrix eigenbasis).mulVec (w ξ τ))
    x t).2
  intro p
  simpa only [leveque03_coordinatesOfReconstructed] using hw p x t

/-- If the initial characteristic variables are `R⁻¹ q°`, the reconstructed
state has initial trace `q°`. -/
theorem leveque03_reconstructedInitial
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (initialState : ℝ → (Fin m → ℝ))
    (w : ℝ → ℝ → (Fin m → ℝ))
    (hinit : ∀ x, w x 0 =
      leveque03_initialCharacteristicVariables eigenbasis initialState x)
    (x : ℝ) :
    let R := (Pi.basisFun ℝ (Fin m)).toMatrix eigenbasis
    R.mulVec (w x 0) = initialState x := by
  change ((Pi.basisFun ℝ (Fin m)).toMatrix eigenbasis).mulVec (w x 0) =
    initialState x
  rw [hinit x]
  exact leveque03_reconstructState eigenbasis (initialState x)

/-- Equation (3.5) as an initial-value construction: component advection
solutions assembled by `R` solve the original system and recover its data. -/
theorem leveque03_reconstructedCauchySolution
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (eigenvalues : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (eigenbasis p) =
      eigenvalues p • eigenbasis p)
    (initialState : ℝ → (Fin m → ℝ))
    (w : ℝ → ℝ → (Fin m → ℝ))
    (hw : ∀ p x t, IsLinearAdvectionSolutionAt
      (fun ξ τ => w ξ τ p) (eigenvalues p) x t)
    (hinit : ∀ x, w x 0 =
      leveque03_initialCharacteristicVariables eigenbasis initialState x) :
    let R := (Pi.basisFun ℝ (Fin m)).toMatrix eigenbasis
    (∀ x t, IsConstantCoefficientLinearSystemSolutionAt
      (fun ξ τ => R.mulVec (w ξ τ)) coefficient x t) ∧
      ∀ x, R.mulVec (w x 0) = initialState x := by
  constructor
  · intro x t
    exact leveque03_reconstructedSystem coefficient eigenbasis eigenvalues
      heigen w hw x t
  · intro x
    exact leveque03_reconstructedInitial eigenbasis initialState w hinit x

/-- Equation (3.6): every state is the sum of its characteristic wave
strengths times the corresponding right eigenvectors. -/
theorem leveque03_eigenvectorSuperposition
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (q : ℝ → ℝ → (Fin m → ℝ)) (x t : ℝ) :
    q x t =
      ∑ p, (leveque03_characteristicVariables eigenbasis (q x t) p) •
        eigenbasis p := by
  have hcoord := leveque03_characteristicCoordinates eigenbasis (q x t)
  simpa only [leveque03_characteristicVariables, hcoord] using
    (eigenbasis.sum_equivFun (q x t)).symm

/-- A chosen complete right-eigenvector family gives each state exactly one
set of wave strengths, namely its characteristic coordinates. -/
theorem leveque03_uniqueEigenvectorExpansion
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (q : Fin m → ℝ) :
    ∃! amplitudes : Fin m → ℝ,
      ∑ p, amplitudes p • eigenbasis p = q := by
  refine ⟨leveque03_characteristicVariables eigenbasis q, ?_, ?_⟩
  · simpa using
      (leveque03_eigenvectorSuperposition eigenbasis (fun _ _ => q) 0 0).symm
  · intro amplitudes hamplitudes
    have hrepr : eigenbasis.equivFun.symm amplitudes = q := by
      simpa only [eigenbasis.equivFun_symm_apply] using hamplitudes
    have h := congrArg eigenbasis.equivFun hrepr
    have heq : amplitudes = eigenbasis.equivFun q := by
      simpa only [eigenbasis.equivFun.apply_symm_apply] using h
    simpa only [show leveque03_characteristicVariables eigenbasis q =
      eigenbasis.equivFun q from
        leveque03_characteristicCoordinates eigenbasis q] using heq

end NumStability
