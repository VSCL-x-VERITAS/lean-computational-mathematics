/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsConjugateNonlinear
import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsNonlinearStability
import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearSystems.EigenbasisCoordinates

/-!
# Characteristic-coordinate stability of the periodic vector scheme

For a real-diagonalizable constant matrix, the physical equation-(4.20)
update is a scalar Lax–Friedrichs update in each characteristic coordinate.
The sum of absolute characteristic errors contracts under the CFL bound
on every, possibly distinct, characteristic speed.
-/

namespace NumStability

open scoped BigOperators

theorem leveque04_linearFlux_eq_conjugateCharacteristicFlux
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (basis p) =
      waveSpeed p • basis p) :
    coefficient.mulVec =
      leveque04_conjugateNonlinearFlux basis
        (fun p x => waveSpeed p * x) := by
  funext v
  apply basis.equivFun.injective
  rw [eigenbasis_coordinates_mulVec coefficient basis waveSpeed heigen]
  simp only [leveque04_conjugateNonlinearFlux,
    basis.equivFun.apply_symm_apply]

theorem leveque04_periodicVectorLaxFriedrichs_characteristicStep
    {m : ℕ} (n : ℕ) [NeZero n]
    (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (basis p) =
      waveSpeed p • basis p)
    (ratio : ℝ) (u : ZMod n → Fin m → ℝ)
    (i : ZMod n) (p : Fin m) :
    basis.equivFun
        (leveque04_periodicVectorLaxFriedrichsStep n
          coefficient.mulVec ratio u i) p =
      leveque04_periodicNonlinearLaxFriedrichsStep n
        (fun x => waveSpeed p * x) ratio
        (fun j => basis.equivFun (u j) p) i := by
  rw [leveque04_linearFlux_eq_conjugateCharacteristicFlux
    coefficient basis waveSpeed heigen]
  rw [leveque04_periodicConjugateNonlinearLaxFriedrichs_characteristicStep]
  exact leveque04_periodicDiagonalNonlinearLaxFriedrichs_component
    n (fun p x => waveSpeed p * x) ratio
    (fun j => basis.equivFun (u j)) i p

/-- The physical vector equation-(4.20) update contracts the adapted
sum of absolute characteristic-coordinate errors when each speed satisfies
the scalar Courant bound. -/
theorem leveque04_periodicVectorLaxFriedrichs_characteristic_l1_contract
    {m : ℕ} (n : ℕ) [NeZero n]
    (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (basis p) =
      waveSpeed p • basis p)
    (ratio : ℝ) (hratio : 0 ≤ ratio)
    (hcfl : ∀ p, |waveSpeed p * ratio| ≤ 1)
    (u v : ZMod n → Fin m → ℝ) :
    (∑ p : Fin m, ∑ i : ZMod n,
      |basis.equivFun
          (leveque04_periodicVectorLaxFriedrichsStep n
            coefficient.mulVec ratio u i) p -
        basis.equivFun
          (leveque04_periodicVectorLaxFriedrichsStep n
            coefficient.mulVec ratio v i) p|) ≤
      ∑ p : Fin m, ∑ i : ZMod n,
        |basis.equivFun (u i) p - basis.equivFun (v i) p| := by
  apply Finset.sum_le_sum
  intro p _
  have hcflp : ratio * |waveSpeed p| ≤ 1 := by
    calc
      ratio * |waveSpeed p| = |waveSpeed p * ratio| := by
        rw [abs_mul, abs_of_nonneg hratio]
        ring
      _ ≤ 1 := hcfl p
  have hflux : ∀ x y,
      |waveSpeed p * x - waveSpeed p * y| ≤
        |waveSpeed p| * |x - y| := by
    intro x y
    rw [← mul_sub, abs_mul]
  have h := leveque04_periodicNonlinearLaxFriedrichs_l1_contract
    n (fun x => waveSpeed p * x) ratio |waveSpeed p|
    hratio hcflp hflux
    (fun i => basis.equivFun (u i) p)
    (fun i => basis.equivFun (v i) p)
  convert h using 1
  apply Finset.sum_congr rfl
  intro i _
  rw [leveque04_periodicVectorLaxFriedrichs_characteristicStep
    n coefficient basis waveSpeed heigen ratio u i p,
    leveque04_periodicVectorLaxFriedrichs_characteristicStep
      n coefficient basis waveSpeed heigen ratio v i p]

end NumStability
