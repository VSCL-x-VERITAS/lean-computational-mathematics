/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter03.LeftEigenvectors
import ComputationalMathematics.Source.LeVeque.Chapter03.WaveSuperposition
import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearSystems.CharacteristicPropagation

/-!
# The Cauchy solution in left and right eigenvectors

Equation (3.8), printed page 49/raw PDF page 71. This source wrapper uses the
existing characteristic propagation theorem for a classical solution.
-/

namespace NumStability

/-- Assemble the translated initial characteristic components with the fixed
right-eigenvector matrix. This expression also makes sense for nonsmooth data. -/
noncomputable def leveque03_initialDataSolution
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (eigenvalues : Fin m → ℝ)
    (initialState : ℝ → (Fin m → ℝ)) (x t : ℝ) : Fin m → ℝ :=
  let R := (Pi.basisFun ℝ (Fin m)).toMatrix eigenbasis
  R.mulVec (fun p =>
    leveque03_initialCharacteristicVariables eigenbasis initialState
      (x - eigenvalues p * t) p)

/-- Equation (3.8): a differentiable solution of the constant-coefficient
system is the sum of its translated initial left-eigenvector components. -/
theorem leveque03_cauchySolution
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (eigenvalues : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (eigenbasis p) =
      eigenvalues p • eigenbasis p)
    (initialState : ℝ → (Fin m → ℝ))
    (q : ℝ → ℝ → (Fin m → ℝ))
    (hq : Differentiable ℝ (Function.uncurry q))
    (hpde : ∀ x t, IsConstantCoefficientLinearSystemSolutionAt q coefficient x t)
    (hinit : ∀ x, q x 0 = initialState x)
    (x t : ℝ) :
    q x t =
      ∑ p, ((leveque03_leftEigenvector eigenbasis p) ⬝ᵥ
        initialState (x - eigenvalues p * t)) • eigenbasis p := by
  have hprop :=
    (constantCoefficientSystem_characteristicPropagation coefficient
      eigenbasis eigenvalues heigen q hq hpde).2 x t
  rw [hprop]
  apply Finset.sum_congr rfl
  intro p _
  rw [hinit]
  congr 1
  have hcoord := leveque03_characteristicCoordinates eigenbasis
    (initialState (x - eigenvalues p * t))
  exact (congrFun hcoord p).symm

/-- Equation (3.8) for the constructed initial-value solution, with no
regularity condition on the initial profile. -/
theorem leveque03_initialDataSolution_formula
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (eigenvalues : Fin m → ℝ)
    (initialState : ℝ → (Fin m → ℝ)) (x t : ℝ) :
    leveque03_initialDataSolution eigenbasis eigenvalues initialState x t =
      ∑ p, ((leveque03_leftEigenvector eigenbasis p) ⬝ᵥ
        initialState (x - eigenvalues p * t)) • eigenbasis p := by
  let w : Fin m → ℝ := fun p =>
    leveque03_initialCharacteristicVariables eigenbasis initialState
      (x - eigenvalues p * t) p
  change ((Pi.basisFun ℝ (Fin m)).toMatrix eigenbasis).mulVec w = _
  calc
    ((Pi.basisFun ℝ (Fin m)).toMatrix eigenbasis).mulVec w =
        ∑ p, w p • eigenbasis p := by
      rw [← eigenbasis.sum_equivFun
        (((Pi.basisFun ℝ (Fin m)).toMatrix eigenbasis).mulVec w)]
      simp only [leveque03_coordinatesOfReconstructed]
    _ = ∑ p, ((leveque03_leftEigenvector eigenbasis p) ⬝ᵥ
          initialState (x - eigenvalues p * t)) • eigenbasis p := by
      apply Finset.sum_congr rfl
      intro p _
      congr 1

end NumStability
