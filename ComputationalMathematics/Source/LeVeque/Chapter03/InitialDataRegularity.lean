/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter03.CauchySolution
import Mathlib.Analysis.Calculus.ContDiff.Operations
import Mathlib.Analysis.Calculus.ContDiff.Comp

/-!
# Regularity of the constructed initial-data solution

Printed page 52/raw PDF page 74. The solution is smooth near an observation
point when the initial profile is smooth near every backward characteristic
foot. The order-indexed result also identifies which initial regularity is
needed for a corresponding order of solution regularity.
-/

namespace NumStability

/-- Regularity at every backward characteristic foot passes through the
translated characteristic coordinates and fixed eigenvector reconstruction. -/
theorem leveque03_initialDataSolution_contDiffAt
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ) (initialState : ℝ → (Fin m → ℝ))
    (X T : ℝ) (n : WithTop ℕ∞)
    (hfeet : ∀ p, ContDiffAt ℝ n initialState (X - speeds p * T)) :
    ContDiffAt ℝ n
      (fun z : ℝ × ℝ => leveque03_initialDataSolution eigenbasis speeds initialState z.1 z.2)
      (X, T) := by
  let e := eigenbasis.equivFun.toContinuousLinearEquiv
  have hcoordEq : (fun y => leveque03_initialCharacteristicVariables eigenbasis initialState y) =
      (e ∘ initialState) := by
    funext y
    exact leveque03_characteristicCoordinates eigenbasis (initialState y)
  have hcoordinate (p : Fin m) : ContDiffAt ℝ n
      (fun y => leveque03_initialCharacteristicVariables eigenbasis initialState y p)
      (X - speeds p * T) := by
    have hvec : ContDiffAt ℝ n
        (fun y => leveque03_initialCharacteristicVariables eigenbasis initialState y)
        (X - speeds p * T) := by
      rw [hcoordEq]
      exact (e.comp_contDiffAt_iff).2 (hfeet p)
    exact (contDiffAt_pi.mp hvec) p
  have hfoot (p : Fin m) : ContDiffAt ℝ n
      (fun z : ℝ × ℝ => z.1 - speeds p * z.2) (X, T) := by
    fun_prop
  have htranslated (p : Fin m) : ContDiffAt ℝ n
      (fun z : ℝ × ℝ => leveque03_initialCharacteristicVariables eigenbasis initialState
        (z.1 - speeds p * z.2) p) (X, T) := by
    have hcomp : ContDiffAt ℝ n
        ((fun y : ℝ => leveque03_initialCharacteristicVariables eigenbasis initialState y p) ∘
          (fun z : ℝ × ℝ => z.1 - speeds p * z.2)) (X, T) :=
      (hcoordinate p).comp (X, T) (hfoot p)
    simpa only [Function.comp_def] using hcomp
  have hvector : ContDiffAt ℝ n
      (fun z : ℝ × ℝ => fun p => leveque03_initialCharacteristicVariables
        eigenbasis initialState (z.1 - speeds p * z.2) p) (X, T) :=
    contDiffAt_pi.mpr htranslated
  let R := (Pi.basisFun ℝ (Fin m)).toMatrix eigenbasis
  change ContDiffAt ℝ n (fun z : ℝ × ℝ => R.mulVec
    (fun p => leveque03_initialCharacteristicVariables eigenbasis initialState
      (z.1 - speeds p * z.2) p)) (X, T)
  simpa only [Matrix.mulVecLin_apply] using
    hvector.continuousLinearMap_comp R.mulVecLin.toContinuousLinearMap

/-- Smooth initial data near every backward foot give a smooth constructed
solution near the observation point. -/
theorem leveque03_initialDataSolution_smoothAt
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ) (initialState : ℝ → (Fin m → ℝ))
    (X T : ℝ)
    (hfeet : ∀ p, ContDiffAt ℝ (⊤ : WithTop ℕ∞) initialState (X - speeds p * T)) :
    ContDiffAt ℝ (⊤ : WithTop ℕ∞)
      (fun z : ℝ × ℝ => leveque03_initialDataSolution eigenbasis speeds initialState z.1 z.2)
      (X, T) :=
  leveque03_initialDataSolution_contDiffAt eigenbasis speeds initialState X T ⊤ hfeet

end NumStability
