/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.RealEigenbasisDiagonalization
import ComputationalMathematics.Source.LeVeque.Chapter04.Equation62Discrepancy
import ComputationalMathematics.Source.LeVeque.Chapter04.GodunovStability
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearCharacteristicCoordinates

/-!
# Characteristic perturbation bounds for the linear Roe flux step

The conservative update uses the actual centered matrix flux with its absolute
spectral correction. Its equality with the Godunov wave step is derived from
the complete eigenbasis, rather than assumed. The scalar upwind error estimate
then gives a uniform bound for every pair of integer-grid data sets under
mode-wise CFL. Physical-vector bounds retain the fixed basis condition factor.
-/

namespace NumStability

/-- The conservative step formed from the centered Roe flux and its actual
absolute spectral matrix. The face indexed by `j` lies between cells `j-1`
and `j`. -/
noncomputable def leveque04_linearRoeStep
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ) (ratio : ℝ)
    (old : ℤ → (Fin m → ℝ)) (i : ℤ) : Fin m → ℝ :=
  conservativeFluxDifferenceUpdateInt ratio old
    (fun j => leveque04_centeredMatrixFlux coefficient
      (leveque04_absoluteCoefficient basis waveSpeed) (old (j - 1)) (old j)) i

/-- For every complete real eigenbasis, the actual Roe flux step equals the
linear Godunov wave step, without any CFL restriction on this identity. -/
theorem leveque04_linearRoeStep_eq_waveStep
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (basis p) = waveSpeed p • basis p)
    (ratio : ℝ) (old : ℤ → (Fin m → ℝ)) (i : ℤ) :
    leveque04_linearRoeStep coefficient basis waveSpeed ratio old i =
      leveque04_linearGodunovWaveStep basis waveSpeed ratio old i := by
  have hdiag := (Leveque02Tracer.realEigenbasisDiagonalization
    coefficient waveSpeed basis heigen).2
  have hcenter (left right : Fin m → ℝ) :
      leveque04_linearGodunovFlux coefficient basis waveSpeed left right =
        leveque04_centeredMatrixFlux coefficient
          (leveque04_absoluteCoefficient basis waveSpeed) left right := by
    exact leveque04_equation61_from49 coefficient basis waveSpeed hdiag left right
      (leveque04_linearGodunovFlux coefficient basis waveSpeed left right)
      (leveque04_equation49 coefficient basis waveSpeed left right)
  have h49 (j : ℤ) :
      leveque04_centeredMatrixFlux coefficient
          (leveque04_absoluteCoefficient basis waveSpeed) (old (j - 1)) (old j) =
        coefficient.mulVec (old (j - 1)) +
          leveque04_negativeFluctuation waveSpeed
            (leveque03_riemannWave basis (old (j - 1)) (old j)) := by
    rw [← hcenter]
    simpa only [leveque04_negativeFluctuation] using
      leveque04_equation49 coefficient basis waveSpeed (old (j - 1)) (old j)
  exact leveque04_equation51_from49 coefficient basis waveSpeed hdiag old
    (fun j => leveque04_centeredMatrixFlux coefficient
      (leveque04_absoluteCoefficient basis waveSpeed) (old (j - 1)) (old j))
    h49 ratio i

/-- Each characteristic coordinate of every actual Roe iterate is the
corresponding normalized scalar upwind iterate. -/
theorem leveque04_linearRoe_characteristicIterate
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (basis p) = waveSpeed p • basis p)
    (ratio : ℝ) (initial : ℤ → (Fin m → ℝ)) (n : ℕ) (i : ℤ) (p : Fin m) :
    basis.equivFun
        (((leveque04_linearRoeStep coefficient basis waveSpeed ratio)^[n] initial) i) p =
      ((leveque04_signedUpwindStep ratio 1 (waveSpeed p))^[n]
        (fun j => basis.equivFun (initial j) p)) i := by
  have hstep : leveque04_linearRoeStep coefficient basis waveSpeed ratio =
      leveque04_linearGodunovWaveStep basis waveSpeed ratio := by
    funext old j
    exact leveque04_linearRoeStep_eq_waveStep coefficient basis waveSpeed heigen ratio old j
  rw [hstep]
  simpa only [mul_one] using leveque04_linearGodunov_characteristicIterate
    basis waveSpeed ratio 1 initial n i p (by norm_num)

/-- Under every characteristic CFL bound, the actual Roe step preserves
a uniform characteristic difference bound for arbitrary pairs and all steps. -/
-- Preserve the source hypotheses and the existing public interface.
@[nolint unusedArguments]
theorem leveque04_linearRoe_iterate_characteristic_difference_bound
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (basis p) = waveSpeed p • basis p)
    (ratio B : ℝ) (hratio : 0 < ratio) (_hB : 0 ≤ B)
    (hcfl : ∀ p, |waveSpeed p * ratio| ≤ 1)
    (P Q : ℤ → (Fin m → ℝ))
    (hbound : ∀ j p, |basis.equivFun (P j - Q j) p| ≤ B)
    (n : ℕ) (i : ℤ) (p : Fin m) :
    |basis.equivFun
      ((((leveque04_linearRoeStep coefficient basis waveSpeed ratio)^[n] P) i) -
        (((leveque04_linearRoeStep coefficient basis waveSpeed ratio)^[n] Q) i)) p| ≤ B := by
  simp only [map_sub, Pi.sub_apply]
  rw [leveque04_linearRoe_characteristicIterate
      coefficient basis waveSpeed heigen ratio P n i p,
    leveque04_linearRoe_characteristicIterate
      coefficient basis waveSpeed heigen ratio Q n i p]
  have hinitial (j : ℤ) :
      |basis.equivFun (P j) p - basis.equivFun (Q j) p| ≤ B := by
    simpa only [map_sub, Pi.sub_apply] using hbound j p
  have hlocal (k : ℕ) (j : ℤ) :
      |leveque04_signedUpwindStep (ratio * 1) 1 (waveSpeed p)
          ((leveque04_signedUpwindStep ratio 1 (waveSpeed p))^[k]
            (fun l => basis.equivFun (Q l) p)) j -
        ((leveque04_signedUpwindStep ratio 1 (waveSpeed p))^[k + 1]
          (fun l => basis.equivFun (Q l) p)) j| ≤ 0 := by
    simp [Function.iterate_succ_apply']
  have h := leveque04_signedUpwindStep_iterate_error (waveSpeed p) ratio 1 B 0
    (fun j => basis.equivFun (P j) p)
    (fun k => (leveque04_signedUpwindStep ratio 1 (waveSpeed p))^[k]
      (fun j => basis.equivFun (Q j) p))
    n hratio (by norm_num) (hcfl p) hinitial hlocal i
  simpa only [mul_one, mul_zero, add_zero] using h

/-- Physical finite-product norms have a uniform all-step difference bound
with the actual fixed eigenbasis condition factor. -/
theorem leveque04_linearRoe_iterate_physical_difference_bound
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (basis p) = waveSpeed p • basis p)
    (ratio B : ℝ) (hratio : 0 < ratio) (hB : 0 ≤ B)
    (hcfl : ∀ p, |waveSpeed p * ratio| ≤ 1)
    (P Q : ℤ → (Fin m → ℝ))
    (hbound : ∀ j, ‖P j - Q j‖ ≤ B) (n : ℕ) (i : ℤ) :
    ‖(((leveque04_linearRoeStep coefficient basis waveSpeed ratio)^[n] P) i) -
      (((leveque04_linearRoeStep coefficient basis waveSpeed ratio)^[n] Q) i)‖ ≤
      (‖basis.equivFun.toContinuousLinearEquiv.symm.toContinuousLinearMap‖ *
        ‖basis.equivFun.toContinuousLinearEquiv.toContinuousLinearMap‖) * B := by
  let C := basis.equivFun.toContinuousLinearEquiv
  let forward := C.toContinuousLinearMap
  let backward := C.symm.toContinuousLinearMap
  have hCB : 0 ≤ ‖forward‖ * B := mul_nonneg (norm_nonneg _) hB
  have hinitial (j : ℤ) (p : Fin m) :
      |basis.equivFun (P j - Q j) p| ≤ ‖forward‖ * B := by
    calc
      _ ≤ ‖forward‖ * ‖P j - Q j‖ := basis_coordinate_abs_le_opNorm basis _ p
      _ ≤ ‖forward‖ * B := mul_le_mul_of_nonneg_left (hbound j) (norm_nonneg _)
  let error :=
    (((leveque04_linearRoeStep coefficient basis waveSpeed ratio)^[n] P) i) -
      (((leveque04_linearRoeStep coefficient basis waveSpeed ratio)^[n] Q) i)
  have hcoordinate (p : Fin m) : |basis.equivFun error p| ≤ ‖forward‖ * B :=
    leveque04_linearRoe_iterate_characteristic_difference_bound
      coefficient basis waveSpeed heigen ratio (‖forward‖ * B) hratio hCB hcfl
      P Q hinitial n i p
  have hcoordinates : ‖C error‖ ≤ ‖forward‖ * B := by
    apply (pi_norm_le_iff_of_nonneg hCB).2
    intro p
    simpa only [Real.norm_eq_abs] using hcoordinate p
  change ‖error‖ ≤ (‖backward‖ * ‖forward‖) * B
  calc
    ‖error‖ = ‖C.symm (C error)‖ := by
      rw [ContinuousLinearEquiv.symm_apply_apply]
    _ ≤ ‖backward‖ * ‖C error‖ := backward.le_opNorm _
    _ ≤ ‖backward‖ * (‖forward‖ * B) :=
      mul_le_mul_of_nonneg_left hcoordinates (norm_nonneg _)
    _ = (‖backward‖ * ‖forward‖) * B := (mul_assoc _ _ _).symm

end NumStability
