/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter03.CauchySolution
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.UniformAdvection

/-!
# Simple waves in LeVeque Chapter 3

Printed page 49/raw PDF page 71. A single characteristic family may vary
while the other initial characteristic components remain constant. The
constructed solution then propagates as one translated vector profile.
-/

namespace NumStability

/-- Initial data for an `i`-simple wave have constant characteristic
coordinates in every family other than `i`. -/
def IsLeveque03SimpleWaveInitialData
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (i : Fin m) (initialState : ℝ → (Fin m → ℝ)) : Prop :=
  ∃ constants : Fin m → ℝ,
    ∀ p, p ≠ i → ∀ x,
      leveque03_initialCharacteristicVariables eigenbasis initialState x p =
        constants p

/-- The second equality of (3.9): an `i`-simple wave is the initial vector
profile translated at the `i`th characteristic speed. -/
theorem leveque03_simpleWave_translatedInitialState
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (eigenvalues : Fin m → ℝ)
    (initialState : ℝ → (Fin m → ℝ)) (i : Fin m)
    (hsimple : IsLeveque03SimpleWaveInitialData eigenbasis i initialState)
    (x t : ℝ) :
    leveque03_initialDataSolution eigenbasis eigenvalues initialState x t =
      initialState (x - eigenvalues i * t) := by
  obtain ⟨constants, hconstant⟩ := hsimple
  have hcoord :
      (fun p => leveque03_initialCharacteristicVariables eigenbasis initialState
        (x - eigenvalues p * t) p) =
      leveque03_initialCharacteristicVariables eigenbasis initialState
        (x - eigenvalues i * t) := by
    funext p
    by_cases hpi : p = i
    · subst p
      rfl
    · rw [hconstant p hpi (x - eigenvalues p * t),
          hconstant p hpi (x - eigenvalues i * t)]
  change ((Pi.basisFun ℝ (Fin m)).toMatrix eigenbasis).mulVec
    (fun p => leveque03_initialCharacteristicVariables eigenbasis initialState
      (x - eigenvalues p * t) p) = _
  rw [hcoord]
  exact leveque03_reconstructState eigenbasis
    (initialState (x - eigenvalues i * t))

/-- The first equality of (3.9): one transported component and constant
components in all other eigenvector directions. -/
theorem leveque03_simpleWave_superposition
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (eigenvalues : Fin m → ℝ)
    (initialState : ℝ → (Fin m → ℝ)) (i : Fin m)
    (constants : Fin m → ℝ)
    (hconstant : ∀ p, p ≠ i → ∀ x,
      leveque03_initialCharacteristicVariables eigenbasis initialState x p =
        constants p)
    (x t : ℝ) :
    leveque03_initialDataSolution eigenbasis eigenvalues initialState x t =
      (leveque03_initialCharacteristicVariables eigenbasis initialState
        (x - eigenvalues i * t) i) • eigenbasis i +
      ∑ p ∈ Finset.univ.erase i, constants p • eigenbasis p := by
  rw [leveque03_simpleWave_translatedInitialState eigenbasis eigenvalues
    initialState i ⟨constants, hconstant⟩ x t]
  have hsum := leveque03_eigenvectorSuperposition eigenbasis
    (fun _ _ => initialState (x - eigenvalues i * t)) 0 0
  change initialState (x - eigenvalues i * t) =
    ∑ p, (leveque03_initialCharacteristicVariables eigenbasis initialState
      (x - eigenvalues i * t) p) • eigenbasis p at hsum
  rw [hsum, ← Finset.add_sum_erase Finset.univ
    (fun p => (leveque03_initialCharacteristicVariables eigenbasis initialState
      (x - eigenvalues i * t) p) • eigenbasis p) (Finset.mem_univ i)]
  congr 1
  apply Finset.sum_congr rfl
  intro p hp
  rw [hconstant p (Finset.ne_of_mem_erase hp)
    (x - eigenvalues i * t)]

/-- The simple-wave construction is uniformly transported even when its
initial data are nonsmooth. -/
theorem leveque03_simpleWave_uniformAdvection
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (eigenvalues : Fin m → ℝ)
    (initialState : ℝ → (Fin m → ℝ)) (i : Fin m)
    (hsimple : IsLeveque03SimpleWaveInitialData eigenbasis i initialState) :
    IsUniformAdvection
      (leveque03_initialDataSolution eigenbasis eigenvalues initialState)
      (eigenvalues i) := by
  intro x t
  rw [leveque03_simpleWave_translatedInitialState eigenbasis eigenvalues
    initialState i hsimple (x + eigenvalues i * t) t,
    leveque03_simpleWave_translatedInitialState eigenbasis eigenvalues
      initialState i hsimple x 0]
  simp

/-- With differentiable initial data, the simple-wave construction satisfies
the vector advection equation `qₜ + λⁱqₓ = 0`. -/
theorem leveque03_simpleWave_classicalAdvection
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (eigenvalues : Fin m → ℝ)
    (initialState : ℝ → (Fin m → ℝ)) (i : Fin m)
    (hsimple : IsLeveque03SimpleWaveInitialData eigenbasis i initialState)
    (hdiff : Differentiable ℝ initialState) :
    IsLinearAdvectionSolution
      (leveque03_initialDataSolution eigenbasis eigenvalues initialState)
      (eigenvalues i) := by
  have hu := leveque03_simpleWave_uniformAdvection
    eigenbasis eigenvalues initialState i hsimple
  apply hu.isLinearAdvectionSolution
  have hzero :
      (fun x => leveque03_initialDataSolution eigenbasis eigenvalues
        initialState x 0) = initialState := by
    funext x
    simpa using leveque03_simpleWave_translatedInitialState
      eigenbasis eigenvalues initialState i hsimple x 0
  rw [hzero]
  exact hdiff

end NumStability
