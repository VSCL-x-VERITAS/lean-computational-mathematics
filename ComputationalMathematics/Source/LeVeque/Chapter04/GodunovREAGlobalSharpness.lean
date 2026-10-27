/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.GodunovREAConnection
import ComputationalMathematics.Source.LeVeque.Chapter04.GodunovGlobalSharpness

/-!
# Sharp first-order error for repeated exact linear REA steps

The concrete uniform-grid exact characteristic REA stage equals the selected
linear Godunov step under the half-cell CFL condition. A positive
characteristic coordinate therefore inherits the sharp quadratic-data
fixed-horizon error of the actual repeated upwind method.
-/

namespace NumStability

/-- One actual exact characteristic REA stage followed by averaging on
the uniform grid, with the stage rebuilt from each new cell array. -/
noncomputable def leveque04_linearUniformREAStep
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (hcoefficient : IsRealHyperbolicMatrix coefficient)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (basis p) = speeds p • basis p)
    (origin width ratio : ℝ) (hwidth : 0 < width)
    (old : ℤ → Fin m → ℝ) (i : ℤ) : Fin m → ℝ :=
  (leveque04_linearUniformStage coefficient hcoefficient basis speeds heigen
    origin width hwidth old).nextAverage (ratio * width) i

/-- A positive characteristic of the constructed REA stage is exactly
the selected positive-speed Godunov/upwind step. -/
theorem leveque04_linearUniformREA_positiveCharacteristicStep
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (hcoefficient : IsRealHyperbolicMatrix coefficient)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (basis p) = speeds p • basis p)
    (origin width ratio bound : ℝ)
    (hwidth : 0 < width) (hratio : 0 < ratio) (hbound : 0 ≤ bound)
    (hspeeds : ∀ p, -bound ≤ speeds p ∧ speeds p ≤ bound)
    (hCFL : 2 * bound * (ratio * width) ≤ width)
    (p : Fin m) (hp : 0 < speeds p)
    (old : ℤ → Fin m → ℝ) (i : ℤ) :
    basis.equivFun
      (leveque04_linearUniformREAStep coefficient hcoefficient basis speeds heigen
        origin width ratio hwidth old i) p =
      leveque04_positiveUpwindStep (ratio * width) width (speeds p)
        (fun j => basis.equivFun (old j) p) i := by
  unfold leveque04_linearUniformREAStep
  rw [leveque04_linearUniformREA_eq_godunovWaveStep coefficient hcoefficient
    basis speeds heigen origin width ratio bound hwidth hratio hbound
    hspeeds hCFL old i]
  rw [leveque04_linearGodunovWaveStep_characteristic]
  simp only [leveque04_positiveVelocity, leveque04_negativeVelocity,
    max_eq_left hp.le, min_eq_right hp.le, zero_mul, add_zero]
  rw [leveque04_equation25 (ratio * width) width (speeds p)
    (fun j => basis.equivFun (old j) p) i hp]
  have hwne : width ≠ 0 := ne_of_gt hwidth
  field_simp

/-- The characteristic equality persists through repeated reconstruction,
exact evolution, and averaging of the newly computed cell arrays. -/
theorem leveque04_linearUniformREA_positiveCharacteristic_iterate
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (hcoefficient : IsRealHyperbolicMatrix coefficient)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (basis p) = speeds p • basis p)
    (origin width ratio bound : ℝ)
    (hwidth : 0 < width) (hratio : 0 < ratio) (hbound : 0 ≤ bound)
    (hspeeds : ∀ p, -bound ≤ speeds p ∧ speeds p ≤ bound)
    (hCFL : 2 * bound * (ratio * width) ≤ width)
    (p : Fin m) (hp : 0 < speeds p)
    (old : ℤ → Fin m → ℝ) (steps : ℕ) (i : ℤ) :
    basis.equivFun
      (((leveque04_linearUniformREAStep coefficient hcoefficient basis speeds heigen
        origin width ratio hwidth)^[steps] old) i) p =
      (((leveque04_positiveUpwindStep (ratio * width) width (speeds p))^[steps]
        (fun j => basis.equivFun (old j) p)) i) := by
  induction steps generalizing i with
  | zero => simp
  | succ steps ih =>
      rw [Function.iterate_succ_apply']
      rw [leveque04_linearUniformREA_positiveCharacteristicStep coefficient
        hcoefficient basis speeds heigen origin width ratio bound
        hwidth hratio hbound hspeeds hCFL p hp]
      have hstate :
          (fun j : ℤ => basis.equivFun
            (((leveque04_linearUniformREAStep coefficient hcoefficient basis speeds
              heigen origin width ratio hwidth)^[steps] old) j) p) =
          ((leveque04_positiveUpwindStep (ratio * width) width (speeds p))^[steps]
            (fun j => basis.equivFun (old j) p)) := by
        funext j
        exact ih j
      rw [hstate]
      simp only [Function.iterate_succ_apply']

/-- On the centered uniform grid, repeated exact REA stages have the
same explicit accumulated error on quadratic characteristic data as the
positive-speed Godunov method. -/
theorem leveque04_linearUniformREA_positiveQuadratic_globalError
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (hcoefficient : IsRealHyperbolicMatrix coefficient)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (basis p) = speeds p • basis p)
    (width ratio bound : ℝ)
    (hwidth : 0 < width) (hratio : 0 < ratio) (hbound : 0 ≤ bound)
    (hspeeds : ∀ p, -bound ≤ speeds p ∧ speeds p ≤ bound)
    (hCFL : 2 * bound * (ratio * width) ≤ width)
    (p : Fin m) (hp : 0 < speeds p)
    (steps : ℕ) (i : ℤ) :
    let old : ℤ → Fin m → ℝ := fun j => basis.equivFun.symm
      (fun _ => leveque04_quadraticCellAverage width j)
    basis.equivFun
      (((leveque04_linearUniformREAStep coefficient hcoefficient basis speeds heigen
        (width / 2) width ratio hwidth)^[steps] old) i) p -
      oneDimensionalCellAverage
        (fun x : ℝ => (x - speeds p * (steps : ℝ) * (ratio * width)) ^ 2)
        ((i : ℝ) * width - width / 2)
        ((i : ℝ) * width + width / 2) =
      (steps : ℝ) * (speeds p * ratio) *
        (1 - speeds p * ratio) * width ^ 2 := by
  dsimp only
  rw [leveque04_linearUniformREA_positiveCharacteristic_iterate coefficient
    hcoefficient basis speeds heigen (width / 2) width ratio bound
    hwidth hratio hbound hspeeds hCFL p hp]
  have hinit :
      (fun j : ℤ => basis.equivFun
        ((fun k : ℤ => basis.equivFun.symm
          (fun _ => leveque04_quadraticCellAverage width k)) j) p) =
      leveque04_quadraticCellAverage width := by
    funext j
    simp only [LinearEquiv.apply_symm_apply]
  rw [hinit]
  exact leveque04_positiveGodunov_quadratic_globalExactAverageError
    (speeds p) ratio width steps i hp hwidth

/-- The selected characteristic REA error at a fixed physical horizon
is proportional to the mesh width on quadratic data. -/
theorem leveque04_linearUniformREA_positiveQuadratic_fixedHorizonError
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (hcoefficient : IsRealHyperbolicMatrix coefficient)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (basis p) = speeds p • basis p)
    (width ratio bound horizon : ℝ)
    (hwidth : 0 < width) (hratio : 0 < ratio) (hbound : 0 ≤ bound)
    (hspeeds : ∀ p, -bound ≤ speeds p ∧ speeds p ≤ bound)
    (hCFL : 2 * bound * (ratio * width) ≤ width)
    (p : Fin m) (hp : 0 < speeds p)
    (steps : ℕ) (i : ℤ)
    (htime : (steps : ℝ) * (ratio * width) = horizon) :
    let old : ℤ → Fin m → ℝ := fun j => basis.equivFun.symm
      (fun _ => leveque04_quadraticCellAverage width j)
    basis.equivFun
      (((leveque04_linearUniformREAStep coefficient hcoefficient basis speeds heigen
        (width / 2) width ratio hwidth)^[steps] old) i) p -
      oneDimensionalCellAverage
        (fun x : ℝ => (x - speeds p * horizon) ^ 2)
        ((i : ℝ) * width - width / 2)
        ((i : ℝ) * width + width / 2) =
      (horizon * speeds p * (1 - speeds p * ratio)) * width := by
  dsimp only
  rw [leveque04_linearUniformREA_positiveCharacteristic_iterate coefficient
    hcoefficient basis speeds heigen (width / 2) width ratio bound
    hwidth hratio hbound hspeeds hCFL p hp]
  have hinit :
      (fun j : ℤ => basis.equivFun
        ((fun k : ℤ => basis.equivFun.symm
          (fun _ => leveque04_quadraticCellAverage width k)) j) p) =
      leveque04_quadraticCellAverage width := by
    funext j
    simp only [LinearEquiv.apply_symm_apply]
  rw [hinit]
  exact leveque04_positiveGodunov_quadratic_fixedHorizonError
    (speeds p) ratio width horizon steps i hp hwidth htime

/-- The constructed exact REA method fails every uniform second-order
fixed-horizon error bound on arbitrarily fine centered meshes whenever
one positive characteristic has an interior Courant number. -/
theorem leveque04_linearUniformREA_positiveQuadratic_fine_not_secondOrder
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (hcoefficient : IsRealHyperbolicMatrix coefficient)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (basis p) = speeds p • basis p)
    (ratio bound horizon : ℝ)
    (hratio : 0 < ratio) (hbound : 0 ≤ bound)
    (hspeeds : ∀ p, -bound ≤ speeds p ∧ speeds p ≤ bound)
    (hCFL : 2 * bound * ratio ≤ 1)
    (p : Fin m) (hp : 0 < speeds p)
    (hhorizon : 0 < horizon) (hinterior : speeds p * ratio < 1) :
    ∀ C ε : ℝ, 0 ≤ C → 0 < ε →
      ∃ steps : ℕ, ∃ width : ℝ, ∃ hwidth : 0 < width,
        width < ε ∧ (steps : ℝ) * (ratio * width) = horizon ∧
          ∀ i : ℤ,
            let old : ℤ → Fin m → ℝ := fun j => basis.equivFun.symm
              (fun _ => leveque04_quadraticCellAverage width j)
            C * width ^ 2 <
              basis.equivFun
                (((leveque04_linearUniformREAStep coefficient hcoefficient basis
                  speeds heigen (width / 2) width ratio hwidth)^[steps] old) i) p -
                oneDimensionalCellAverage
                  (fun x : ℝ => (x - speeds p * horizon) ^ 2)
                  ((i : ℝ) * width - width / 2)
                  ((i : ℝ) * width + width / 2) := by
  intro C ε hC hε
  obtain ⟨steps, width, hwidth, hsmall, htime, herror⟩ :=
    leveque04_positiveGodunov_fixedHorizon_arbitrarilyFine_not_secondOrder
      (speeds p) ratio horizon hp hratio hhorizon hinterior C ε hC hε
  have hCFLwidth : 2 * bound * (ratio * width) ≤ width := by
    have := mul_le_mul_of_nonneg_right hCFL hwidth.le
    nlinarith
  refine ⟨steps, width, hwidth, hsmall, htime, ?_⟩
  intro i
  dsimp only
  rw [leveque04_linearUniformREA_positiveQuadratic_fixedHorizonError
    coefficient hcoefficient basis speeds heigen width ratio bound horizon
    hwidth hratio hbound hspeeds hCFLwidth p hp steps i htime]
  have hi := herror i
  rw [leveque04_positiveGodunov_quadratic_fixedHorizonError
    (speeds p) ratio width horizon steps i hp hwidth htime] at hi
  exact hi

end NumStability
