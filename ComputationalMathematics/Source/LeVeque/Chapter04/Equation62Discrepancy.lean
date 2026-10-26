/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.RoeFlux
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring

/-!
# LeVeque Chapter 4, equation (4.62): correction-sign discrepancy

Substitution of the centered flux (4.61) into the conservative update
(4.4) gives a plus sign before the absolute-speed wave-difference term.
The printed (4.62) has a minus sign. A scalar positive-advection stencil
separates the two formulas.
-/

namespace NumStability

/-- Scalar version of the centered interface flux in (4.61). -/
noncomputable def leveque04_scalarCenteredFlux
    (speed left right : ℝ) : ℝ :=
  (1 / 2 : ℝ) * speed * (left + right) -
    (1 / 2 : ℝ) * |speed| * (right - left)

/-- The literal printed sign in (4.62), specialized to scalar advection. -/
def leveque04_equation62_printed_scalar
    (speed scale left current right : ℝ) : Prop :=
  current - scale *
      (leveque04_scalarCenteredFlux speed current right -
       leveque04_scalarCenteredFlux speed left current) =
    current - (scale / 2) * speed * (right - left) -
      (scale / 2) * |speed| * (right - 2 * current + left)

/-- With speed one, one time-step-to-width ratio, and stencil `(0,0,1)`,
the conservative update is zero while the printed right side is minus one. -/
theorem leveque04_equation62_printed_refuted :
    ¬ leveque04_equation62_printed_scalar 1 1 0 0 1 := by
  intro h
  norm_num [leveque04_equation62_printed_scalar,
    leveque04_scalarCenteredFlux] at h

/-- The corrected sign follows from direct substitution of the centered
flux into the conservative update for every scalar speed and stencil. -/
theorem leveque04_equation62_corrected_scalar
    (speed scale left current right : ℝ) :
    current - scale *
        (leveque04_scalarCenteredFlux speed current right -
         leveque04_scalarCenteredFlux speed left current) =
      current - (scale / 2) * speed * (right - left) +
        (scale / 2) * |speed| * (right - 2 * current + left) := by
  unfold leveque04_scalarCenteredFlux
  ring

/-- The centered vector flux of (4.61), with physical matrix `A` and
absolute spectral matrix `|A|`. -/
noncomputable def leveque04_centeredMatrixFlux
    {m : ℕ} (coefficient absolute : Matrix (Fin m) (Fin m) ℝ)
    (left right : Fin m → ℝ) : Fin m → ℝ :=
  (1 / 2 : ℝ) •
      (coefficient.mulVec left + coefficient.mulVec right) -
    (1 / 2 : ℝ) • absolute.mulVec (right - left)

/-- Corrected vector update from substituting (4.61) into (4.4).
The absolute-speed difference has a plus sign. -/
theorem leveque04_equation62_corrected
    {m : ℕ} (coefficient absolute : Matrix (Fin m) (Fin m) ℝ)
    (scale : ℝ) (left current right : Fin m → ℝ) :
    current - scale •
        (leveque04_centeredMatrixFlux coefficient absolute current right -
         leveque04_centeredMatrixFlux coefficient absolute left current) =
      current - (scale / 2) • coefficient.mulVec (right - left) +
        (scale / 2) • absolute.mulVec
          ((right - current) - (current - left)) := by
  simp only [leveque04_centeredMatrixFlux, Matrix.mulVec_sub]
  module

end NumStability

namespace NumStability
open scoped BigOperators

/-- The corrected system equation uses the actual characteristic waves and
the split physical linear flux. It retains the spectral identification. -/
theorem leveque04_equation62_corrected_spectralWaves
    {m : ℕ} (A : Matrix (Fin m) (Fin m) ℝ)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ)) (speed : Fin m → ℝ)
    (hdiag : A = let R := (Pi.basisFun ℝ (Fin m)).toMatrix basis
      R * Matrix.diagonal speed * R⁻¹)
    (scale : ℝ) (left current right : Fin m → ℝ) :
    current - scale •
      (((leveque04_positiveCoefficientPart basis speed).mulVec current +
          (leveque04_negativeCoefficientPart basis speed).mulVec right) -
        ((leveque04_positiveCoefficientPart basis speed).mulVec left +
          (leveque04_negativeCoefficientPart basis speed).mulVec current)) =
      current - (scale/2) • A.mulVec (right-left) + (scale/2) •
        (∑ p, |speed p| • (leveque03_riemannWave basis current right p -
          leveque03_riemannWave basis left current p)) := by
  have h := leveque04_equation62_corrected A
    (leveque04_absoluteCoefficient basis speed) scale left current right
  have hr := leveque04_spectralWaveAction basis (fun p => |speed p|) current right
  have hl := leveque04_spectralWaveAction basis (fun p => |speed p|) left current
  change (leveque04_absoluteCoefficient basis speed).mulVec (right-current) = _ at hr
  change (leveque04_absoluteCoefficient basis speed).mulVec (current-left) = _ at hl
  rw [Matrix.mulVec_sub (leveque04_absoluteCoefficient basis speed)
    (right-current) (current-left),hr,hl,←Finset.sum_sub_distrib] at h
  simp only [leveque04_centeredMatrixFlux] at h
  rw [←leveque04_splitFlux_eq_centered A basis speed hdiag current right,
    ←leveque04_splitFlux_eq_centered A basis speed hdiag left current] at h
  simpa only [smul_sub] using h


/-- Literal printed minus sign, with actual spectral matrix and waves. -/
noncomputable def leveque04_equation62_printed_systemWaves
    {m : ℕ} (A : Matrix (Fin m) (Fin m) ℝ)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ)) (speed : Fin m → ℝ)
    (scale : ℝ) (left current right : Fin m → ℝ) : Prop :=
    current - scale •
      (leveque04_centeredMatrixFlux A (leveque04_absoluteCoefficient basis speed) current right -
        leveque04_centeredMatrixFlux A (leveque04_absoluteCoefficient basis speed) left current) =
      current - (scale/2) • A.mulVec (right-left) - (scale/2) •
        (∑ p, |speed p| • (leveque03_riemannWave basis current right p -
          leveque03_riemannWave basis left current p))

/-- A positive-dimensional, diagonalized linear-system witness refutes the
literal printed sign. The width and time can both be one (scale one). -/
theorem leveque04_equation62_printed_system_refuted :
    ((1 : Matrix (Fin 1) (Fin 1) ℝ) =
      let R := (Pi.basisFun ℝ (Fin 1)).toMatrix (Pi.basisFun ℝ (Fin 1))
      R * Matrix.diagonal (fun _ => (1:ℝ)) * R⁻¹) ∧
    ¬ leveque04_equation62_printed_systemWaves (1 : Matrix (Fin 1) (Fin 1) ℝ)
      (Pi.basisFun ℝ (Fin 1)) (fun _ => 1) 1 0 0 (fun _ => 1) := by
  have hd : (1 : Matrix (Fin 1) (Fin 1) ℝ) =
      let R := (Pi.basisFun ℝ (Fin 1)).toMatrix (Pi.basisFun ℝ (Fin 1))
      R * Matrix.diagonal (fun _ => (1:ℝ)) * R⁻¹ := by
    simp [Module.Basis.toMatrix_self, ←Matrix.diagonal_one]
  refine ⟨hd,?_⟩
  intro h
  have hsum := leveque04_spectralWaveAction (Pi.basisFun ℝ (Fin 1))
    (fun _ => (1:ℝ)) (0 : Fin 1 → ℝ) (fun _ => 1)
  have hsum0 := leveque04_spectralWaveAction (Pi.basisFun ℝ (Fin 1))
    (fun _ => (1:ℝ)) (0 : Fin 1 → ℝ) 0
  have ha : leveque04_absoluteCoefficient (Pi.basisFun ℝ (Fin 1)) (fun _ => (1:ℝ)) = 1 := by
    simp [leveque04_absoluteCoefficient,leveque04_absoluteEigenvalueDiagonal,
      Module.Basis.toMatrix_self, ←Matrix.diagonal_one]
  simp [Module.Basis.toMatrix_self, ←Matrix.diagonal_one] at hsum hsum0
  unfold leveque04_equation62_printed_systemWaves at h
  simp only [abs_one,one_smul,sub_zero,smul_sub,Finset.sum_sub_distrib,
    ha,leveque04_centeredMatrixFlux,Matrix.one_mulVec] at h
  simp only [Fin.sum_univ_one,←hsum,←hsum0] at h
  have hh := congrFun h (0 : Fin 1)
  norm_num [Pi.add_apply,Pi.sub_apply,Pi.smul_apply] at hh

end NumStability
