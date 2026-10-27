/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsStability
import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsOrderWitness
import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearSystems.EigenbasisCoordinates

/-!
# LeVeque Chapter 4: linear-system Lax–Friedrichs stability

In a real eigenbasis, the constant-coefficient system update splits into
scalar Lax–Friedrichs steps. Thus a CFL bound on every characteristic speed
preserves a uniform bound on all characteristic components at every step.
-/

namespace NumStability

/-- Formula (4.20) for a constant-coefficient linear system. -/
noncomputable def leveque04_linearLaxFriedrichsStep {m : ℕ}
    (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (ratio : ℝ) (old : ℤ → (Fin m → ℝ)) : ℤ → (Fin m → ℝ) :=
  fun i => (1 / 2 : ℝ) • (old (i - 1) + old (i + 1)) -
    (ratio / 2) •
      (coefficient.mulVec (old (i + 1)) -
        coefficient.mulVec (old (i - 1)))

/-- The system step is the finite-volume Lax–Friedrichs method (4.20)
with linear physical flux `A q`. -/
theorem leveque04_linearLaxFriedrichsStep_eq_equation20
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (timeStep cellWidth : ℝ) (htime : 0 < timeStep)
    (hwidth : 0 < cellWidth)
    (old : ℤ → (Fin m → ℝ)) (i : ℤ) (k : Fin m) :
    leveque04_finiteVolumeUpdate timeStep cellWidth old
        (leveque04_localInterfaceFlux
          (leveque04_laxFriedrichsFlux timeStep cellWidth
            coefficient.mulVec) old) i k =
      leveque04_linearLaxFriedrichsStep coefficient
        (timeStep / cellWidth) old i k := by
  rw [leveque04_equation20 timeStep cellWidth coefficient.mulVec
    old i k htime hwidth]
  simp only [leveque04_linearLaxFriedrichsStep,
    Pi.sub_apply, Pi.add_apply, Pi.smul_apply, smul_eq_mul]
  field_simp

/-- The pth characteristic coordinate evolves by the scalar formula. -/
theorem leveque04_linearLaxFriedrichs_characteristicStep
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (eigenbasis p) =
      waveSpeed p • eigenbasis p)
    (ratio : ℝ) (old : ℤ → (Fin m → ℝ)) (i : ℤ) (p : Fin m) :
    eigenbasis.equivFun
        (leveque04_linearLaxFriedrichsStep coefficient ratio old i) p =
      leveque04_scalarLaxFriedrichsStep
        (waveSpeed p * ratio)
        (fun j => eigenbasis.equivFun (old j) p) i := by
  simp only [leveque04_linearLaxFriedrichsStep,
    leveque04_scalarLaxFriedrichsStep, map_sub, map_add, map_smul,
    eigenbasis_coordinates_mulVec coefficient eigenbasis waveSpeed heigen,
    Pi.sub_apply, Pi.add_apply, Pi.smul_apply, smul_eq_mul]
  ring

/-- The characteristic-component sup bound survives every system step
when all characteristic Courant numbers satisfy CFL. -/
theorem leveque04_linearLaxFriedrichs_iterate_bound
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (eigenbasis p) =
      waveSpeed p • eigenbasis p)
    (ratio bound : ℝ) (hcfl : ∀ p, |waveSpeed p * ratio| ≤ 1)
    (initial : ℤ → (Fin m → ℝ))
    (hbound : ∀ i p, |eigenbasis.equivFun (initial i) p| ≤ bound)
    (n : ℕ) (i : ℤ) (p : Fin m) :
    |eigenbasis.equivFun
        (((leveque04_linearLaxFriedrichsStep coefficient ratio)^[n]
          initial) i) p| ≤ bound := by
  induction n generalizing i p with
  | zero => simpa using hbound i p
  | succ n ih =>
      rw [Function.iterate_succ_apply',
        leveque04_linearLaxFriedrichs_characteristicStep
          coefficient eigenbasis waveSpeed heigen]
      exact leveque04_scalarLaxFriedrichsStep_bound
        (waveSpeed p * ratio) bound (hcfl p)
        (fun j => eigenbasis.equivFun
          (((leveque04_linearLaxFriedrichsStep coefficient ratio)^[n]
            initial) j) p)
        (fun j => ih j p) i

/-- Every characteristic coordinate of an iterated linear-system update
    is the corresponding iterated scalar Lax–Friedrichs stencil. -/
theorem leveque04_linearLaxFriedrichs_characteristicIterate
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (eigenbasis p) =
      waveSpeed p • eigenbasis p)
    (ratio : ℝ) (initial : ℤ → (Fin m → ℝ))
    (n : ℕ) (i : ℤ) (p : Fin m) :
    eigenbasis.equivFun
        (((leveque04_linearLaxFriedrichsStep coefficient ratio)^[n]
          initial) i) p =
      ((leveque04_scalarLaxFriedrichsStep (waveSpeed p * ratio))^[n]
        (fun j => eigenbasis.equivFun (initial j) p)) i := by
  induction n generalizing i with
  | zero => rfl
  | succ n ih =>
      rw [Function.iterate_succ_apply',
        leveque04_linearLaxFriedrichs_characteristicStep
          coefficient eigenbasis waveSpeed heigen]
      dsimp only [leveque04_scalarLaxFriedrichsStep]
      rw [ih (i - 1), ih (i + 1)]
      rw [Function.iterate_succ_apply']
      rfl

/-- Uniform local error in every characteristic coordinate accumulates
    at most linearly for a real-diagonalizable constant-coefficient system. -/
theorem leveque04_linearLaxFriedrichs_iterate_error
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (eigenbasis p) =
      waveSpeed p • eigenbasis p)
    (ratio initialError localError : ℝ)
    (initial : ℤ → (Fin m → ℝ))
    (exactState : ℕ → ℤ → (Fin m → ℝ))
    (hcfl : ∀ p, |waveSpeed p * ratio| ≤ 1)
    (hinitial : ∀ i p,
      |eigenbasis.equivFun (initial i) p -
        eigenbasis.equivFun (exactState 0 i) p| ≤ initialError)
    (hlocal : ∀ k i p,
      |eigenbasis.equivFun
          (leveque04_linearLaxFriedrichsStep coefficient ratio
            (exactState k) i) p -
        eigenbasis.equivFun (exactState (k + 1) i) p| ≤ localError)
    (n : ℕ) (i : ℤ) (p : Fin m) :
    |eigenbasis.equivFun
        (((leveque04_linearLaxFriedrichsStep coefficient ratio)^[n]
          initial) i) p -
      eigenbasis.equivFun (exactState n i) p| ≤
      initialError + (n : ℝ) * localError := by
  rw [leveque04_linearLaxFriedrichs_characteristicIterate
    coefficient eigenbasis waveSpeed heigen]
  exact leveque04_laxFriedrichs_iterate_error
    (waveSpeed p * ratio) initialError localError
    (fun j => eigenbasis.equivFun (initial j) p)
    (fun k j => eigenbasis.equivFun (exactState k j) p)
    n (hcfl p) (fun j => hinitial j p)
    (by
      intro k j
      rw [← leveque04_linearLaxFriedrichs_characteristicStep
        coefficient eigenbasis waveSpeed heigen]
      exact hlocal k j p) i

/-- Exact translated cell averages of smooth characteristic profiles have
    first-order fixed-time error under each characteristic CFL bound. -/
theorem leveque04_linearLaxFriedrichs_smoothCharacteristic_globalError
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (eigenbasis p) =
      waveSpeed p • eigenbasis p)
    (profile profile' : Fin m → ℕ → ℝ → ℝ)
    (ratio width K horizon : ℝ) (n : ℕ) (i : ℤ) (p : Fin m)
    (hratio : 0 < ratio) (hwidth : 0 < width) (hK : 0 ≤ K)
    (hcfl : ∀ p, |waveSpeed p * ratio| ≤ 1)
    (hprofile : ∀ p k x,
      HasDerivAt (profile p k) (profile' p k x) x)
    (hLip : ∀ p k x y,
      |profile' p k x - profile' p k y| ≤ K * |x - y|)
    (hevolution : ∀ p k x,
      profile p (k + 1) x =
        profile p k (x - waveSpeed p * ratio * width))
    (hhorizon : (n : ℝ) * ratio * width ≤ horizon) :
    let exactState := fun k (j : ℤ) =>
      eigenbasis.equivFun.symm (fun p =>
        oneDimensionalCellAverage (profile p k)
          ((j : ℝ) * width - width / 2)
          ((j : ℝ) * width + width / 2))
    |eigenbasis.equivFun
        (((leveque04_linearLaxFriedrichsStep coefficient ratio)^[n]
          (exactState 0)) i) p -
      eigenbasis.equivFun (exactState n i) p| ≤
      (2 * K * horizon / ratio) * width := by
  dsimp only
  rw [leveque04_linearLaxFriedrichs_characteristicIterate
    coefficient eigenbasis waveSpeed heigen]
  simp only [LinearEquiv.apply_symm_apply]
  exact leveque04_laxFriedrichs_smoothProfile_globalError
    (profile p) (profile' p) (waveSpeed p) ratio width K horizon n i
    hratio hwidth hK (hcfl p) (hprofile p) (hLip p)
    (hevolution p) hhorizon

end NumStability
