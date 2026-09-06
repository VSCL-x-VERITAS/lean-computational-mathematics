/-
SPDX-License-Identifier: MIT
-/

import Mathlib.LinearAlgebra.Matrix.Notation
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem
import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection

/-!
# One-dimensional linear acoustics

Source-independent pointwise and global solution data for the constant
coefficient pressure--velocity system, together with its two-component matrix
representation.
-/

namespace NumStability

/-- Pressure and particle velocity satisfy the one-dimensional linear
acoustics system at `(x,t)`. -/
def IsLinearAcousticsSolutionAt
    (pressure velocity : ℝ → ℝ → ℝ)
    (bulkModulus density x t : ℝ) : Prop :=
  ∃ pt px ut ux : ℝ,
    HasDerivAt (fun τ => pressure x τ) pt t ∧
      HasDerivAt (fun ξ => pressure ξ t) px x ∧
        HasDerivAt (fun τ => velocity x τ) ut t ∧
          HasDerivAt (fun ξ => velocity ξ t) ux x ∧
            pt + bulkModulus * ux = 0 ∧
              ut + density⁻¹ * px = 0

/-- A pressure--velocity field together with a global proof of the linear
acoustics equations for fixed material coefficients. -/
structure LinearAcousticsSolution (bulkModulus density : ℝ) where
  density_ne_zero : density ≠ 0
  /-- The pressure field as a function of space and time. -/
  pressure : ℝ → ℝ → ℝ
  /-- The particle-velocity field as a function of space and time. -/
  velocity : ℝ → ℝ → ℝ
  satisfies : ∀ x t,
    IsLinearAcousticsSolutionAt pressure velocity bulkModulus density x t

/-- Package pressure and velocity as the two-component acoustics state. -/
def linearAcousticsState
    (pressure velocity : ℝ → ℝ → ℝ) :
    ℝ → ℝ → (Fin 2 → ℝ) :=
  fun x t => ![pressure x t, velocity x t]

/-- The constant coefficient matrix of the one-dimensional linear acoustics
system. -/
noncomputable def linearAcousticsMatrix
    (bulkModulus density : ℝ) : Matrix (Fin 2) (Fin 2) ℝ :=
  !![(0 : ℝ), bulkModulus; density⁻¹, 0]

/-- The right-going characteristic combination of pressure and velocity. -/
def linearAcousticsRightInvariant
    (pressure velocity : ℝ → ℝ → ℝ) (density soundSpeed : ℝ) :
    ℝ → ℝ → ℝ :=
  fun x t => pressure x t + density * soundSpeed * velocity x t

/-- The left-going characteristic combination of pressure and velocity. -/
def linearAcousticsLeftInvariant
    (pressure velocity : ℝ → ℝ → ℝ) (density soundSpeed : ℝ) :
    ℝ → ℝ → ℝ :=
  fun x t => pressure x t - density * soundSpeed * velocity x t

/-- A right eigenvector of the acoustics matrix when `K = ρ c²`. -/
def linearAcousticsRightEigenvector
    (density soundSpeed : ℝ) : Fin 2 → ℝ :=
  ![density * soundSpeed, 1]

/-- A left eigenvector of the acoustics matrix when `K = ρ c²`. -/
def linearAcousticsLeftEigenvector
    (density soundSpeed : ℝ) : Fin 2 → ℝ :=
  ![-density * soundSpeed, 1]

/-- The right acoustics vector has eigenvalue `c`. -/
theorem linearAcousticsMatrix_mulVec_rightEigenvector
    (bulkModulus density soundSpeed : ℝ)
    (hdensity : density ≠ 0)
    (hmaterial : bulkModulus = density * soundSpeed ^ 2) :
    (linearAcousticsMatrix bulkModulus density).mulVec
        (linearAcousticsRightEigenvector density soundSpeed) =
      soundSpeed • linearAcousticsRightEigenvector density soundSpeed := by
  funext i
  fin_cases i <;>
    simp [linearAcousticsMatrix, linearAcousticsRightEigenvector,
      Matrix.mulVec, dotProduct, Fin.sum_univ_two, hmaterial, hdensity];
    ring

/-- The left acoustics vector has eigenvalue `-c`. -/
theorem linearAcousticsMatrix_mulVec_leftEigenvector
    (bulkModulus density soundSpeed : ℝ)
    (hdensity : density ≠ 0)
    (hmaterial : bulkModulus = density * soundSpeed ^ 2) :
    (linearAcousticsMatrix bulkModulus density).mulVec
        (linearAcousticsLeftEigenvector density soundSpeed) =
      (-soundSpeed) • linearAcousticsLeftEigenvector density soundSpeed := by
  funext i
  fin_cases i <;>
    simp [linearAcousticsMatrix, linearAcousticsLeftEigenvector,
      Matrix.mulVec, dotProduct, Fin.sum_univ_two, hmaterial, hdensity];
    ring

/-- The right characteristic combination satisfies scalar advection at the
positive acoustic speed whenever `K = ρ c²`. -/
theorem linearAcousticsRightInvariant_isLinearAdvectionSolutionAt
    (pressure velocity : ℝ → ℝ → ℝ)
    (bulkModulus density soundSpeed x t : ℝ)
    (hdensity : density ≠ 0)
    (hmaterial : bulkModulus = density * soundSpeed ^ 2)
    (hsystem : IsLinearAcousticsSolutionAt
      pressure velocity bulkModulus density x t) :
    IsLinearAdvectionSolutionAt
      (linearAcousticsRightInvariant pressure velocity density soundSpeed)
      soundSpeed x t := by
  rcases hsystem with
    ⟨pt, px, ut, ux, hpt, hpx, hut, hux, hpressure, hvelocity⟩
  refine ⟨pt + density * soundSpeed * ut,
    px + density * soundSpeed * ux, ?_, ?_, ?_⟩
  · simpa [linearAcousticsRightInvariant, mul_assoc] using
      hpt.add (hut.const_mul (density * soundSpeed))
  · simpa [linearAcousticsRightInvariant, mul_assoc] using
      hpx.add (hux.const_mul (density * soundSpeed))
  · rw [hmaterial] at hpressure
    field_simp [hdensity] at hvelocity
    dsimp
    calc
      pt + density * soundSpeed * ut +
          soundSpeed * (px + density * soundSpeed * ux) =
        (pt + density * soundSpeed ^ 2 * ux) +
          soundSpeed * (ut * density + px) := by ring
      _ = 0 := by rw [hpressure, hvelocity]; ring

/-- The left characteristic combination satisfies scalar advection at speed
`-c` whenever `K = ρ c²`. -/
theorem linearAcousticsLeftInvariant_isLinearAdvectionSolutionAt
    (pressure velocity : ℝ → ℝ → ℝ)
    (bulkModulus density soundSpeed x t : ℝ)
    (hdensity : density ≠ 0)
    (hmaterial : bulkModulus = density * soundSpeed ^ 2)
    (hsystem : IsLinearAcousticsSolutionAt
      pressure velocity bulkModulus density x t) :
    IsLinearAdvectionSolutionAt
      (linearAcousticsLeftInvariant pressure velocity density soundSpeed)
      (-soundSpeed) x t := by
  rcases hsystem with
    ⟨pt, px, ut, ux, hpt, hpx, hut, hux, hpressure, hvelocity⟩
  refine ⟨pt - density * soundSpeed * ut,
    px - density * soundSpeed * ux, ?_, ?_, ?_⟩
  · simpa [linearAcousticsLeftInvariant, mul_assoc] using
      hpt.sub (hut.const_mul (density * soundSpeed))
  · simpa [linearAcousticsLeftInvariant, mul_assoc] using
      hpx.sub (hux.const_mul (density * soundSpeed))
  · rw [hmaterial] at hpressure
    field_simp [hdensity] at hvelocity
    dsimp
    calc
      pt - density * soundSpeed * ut +
          -soundSpeed * (px - density * soundSpeed * ux) =
        (pt + density * soundSpeed ^ 2 * ux) -
          soundSpeed * (ut * density + px) := by ring
      _ = 0 := by rw [hpressure, hvelocity]; ring

/-- The two scalar acoustics equations are exactly their two-component
constant-matrix system representation. -/
theorem linearAcoustics_matrixForm_iff
    (pressure velocity : ℝ → ℝ → ℝ)
    (bulkModulus density x t : ℝ) :
    IsConstantCoefficientLinearSystemSolutionAt
        (linearAcousticsState pressure velocity)
        (linearAcousticsMatrix bulkModulus density) x t ↔
      IsLinearAcousticsSolutionAt
        pressure velocity bulkModulus density x t := by
  constructor
  · rintro ⟨qt, qx, ht, hx, hresidual⟩
    refine ⟨qt 0, qx 0, qt 1, qx 1, ?_, ?_, ?_, ?_, ?_, ?_⟩
    · simpa [linearAcousticsState] using (hasDerivAt_pi.mp ht 0)
    · simpa [linearAcousticsState] using (hasDerivAt_pi.mp hx 0)
    · simpa [linearAcousticsState] using (hasDerivAt_pi.mp ht 1)
    · simpa [linearAcousticsState] using (hasDerivAt_pi.mp hx 1)
    · have hcomponent := congrFun hresidual (0 : Fin 2)
      simpa [linearAcousticsMatrix, Matrix.mulVec, dotProduct,
        Fin.sum_univ_two] using hcomponent
    · have hcomponent := congrFun hresidual (1 : Fin 2)
      simpa [linearAcousticsMatrix, Matrix.mulVec, dotProduct,
        Fin.sum_univ_two] using hcomponent
  · rintro ⟨pt, px, ut, ux, hpt, hpx, hut, hux, hpressure, hvelocity⟩
    refine ⟨![pt, ut], ![px, ux], ?_, ?_, ?_⟩
    · rw [hasDerivAt_pi]
      intro i
      fin_cases i
      · simpa [linearAcousticsState] using hpt
      · simpa [linearAcousticsState] using hut
    · rw [hasDerivAt_pi]
      intro i
      fin_cases i
      · simpa [linearAcousticsState] using hpx
      · simpa [linearAcousticsState] using hux
    · funext i
      fin_cases i
      · simpa [linearAcousticsMatrix, Matrix.mulVec, dotProduct,
          Fin.sum_univ_two, mul_comm] using hpressure
      · simpa [linearAcousticsMatrix, Matrix.mulVec, dotProduct,
          Fin.sum_univ_two, mul_comm] using hvelocity

end NumStability
