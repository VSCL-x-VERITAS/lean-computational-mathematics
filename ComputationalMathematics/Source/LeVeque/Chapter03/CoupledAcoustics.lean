/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAcoustics

/-!
# Coupled acoustics and passive-tracer advection

Equation (3.33), printed page 57/raw PDF page 79. The three-component
coefficient matrix combines convected acoustics with a passive tracer.
Its block structure is proved equivalent to the two established pointwise
solution predicates.
-/

namespace NumStability

/-- The coefficient matrix of equation (3.33). -/
noncomputable def leveque03_coupledAcousticsMatrix
    (bulkModulus density backgroundVelocity : ℝ) :
    Matrix (Fin 3) (Fin 3) ℝ :=
  !![backgroundVelocity, bulkModulus, 0;
     density⁻¹, backgroundVelocity, 0;
     0, 0, backgroundVelocity]

/-- Package pressure, velocity, and tracer in the source's component order. -/
def leveque03_coupledAcousticsState
    (pressure velocity tracer : ℝ → ℝ → ℝ) :
    ℝ → ℝ → (Fin 3 → ℝ) :=
  fun x t => ![pressure x t, velocity x t, tracer x t]

/-- Matrix multiplication exposes the two acoustic rows and one tracer row. -/
theorem leveque03_coupledAcousticsMatrix_mulVec
    (bulkModulus density backgroundVelocity p u φ : ℝ) :
    (leveque03_coupledAcousticsMatrix bulkModulus density backgroundVelocity).mulVec
      ![p, u, φ] =
      ![backgroundVelocity * p + bulkModulus * u,
        density⁻¹ * p + backgroundVelocity * u,
        backgroundVelocity * φ] := by
  funext i
  fin_cases i <;>
    simp [leveque03_coupledAcousticsMatrix, Matrix.mulVec, dotProduct,
      Fin.sum_univ_succ]

/-- The coupled matrix PDE is equivalent pointwise to convected acoustics
and independent tracer advection. -/
theorem leveque03_coupledAcoustics_decouples
    (pressure velocity tracer : ℝ → ℝ → ℝ)
    (bulkModulus density backgroundVelocity x t : ℝ)
    (hdensity : density ≠ 0) :
    IsConstantCoefficientLinearSystemSolutionAt
      (leveque03_coupledAcousticsState pressure velocity tracer)
      (leveque03_coupledAcousticsMatrix bulkModulus density backgroundVelocity) x t ↔
    IsConvectedLinearAcousticsSolutionAt pressure velocity
      bulkModulus density backgroundVelocity x t ∧
    IsLinearAdvectionSolutionAt tracer backgroundVelocity x t := by
  constructor
  · rintro ⟨qt, qx, ht, hx, hresidual⟩
    constructor
    · refine ⟨qt 0, qx 0, qt 1, qx 1, ?_, ?_, ?_, ?_, ?_, ?_⟩
      · simpa [leveque03_coupledAcousticsState] using (hasDerivAt_pi.mp ht 0)
      · simpa [leveque03_coupledAcousticsState] using (hasDerivAt_pi.mp hx 0)
      · simpa [leveque03_coupledAcousticsState] using (hasDerivAt_pi.mp ht 1)
      · simpa [leveque03_coupledAcousticsState] using (hasDerivAt_pi.mp hx 1)
      · have h := congrFun hresidual (0 : Fin 3)
        simp [leveque03_coupledAcousticsMatrix, dotProduct,
          Fin.sum_univ_succ] at h
        linear_combination h
      · have h := congrFun hresidual (1 : Fin 3)
        simp [leveque03_coupledAcousticsMatrix, dotProduct,
          Fin.sum_univ_succ] at h
        field_simp [hdensity] at h ⊢
        linear_combination h
    · refine ⟨qt 2, qx 2, ?_, ?_, ?_⟩
      · simpa [leveque03_coupledAcousticsState] using (hasDerivAt_pi.mp ht 2)
      · simpa [leveque03_coupledAcousticsState] using (hasDerivAt_pi.mp hx 2)
      · have h := congrFun hresidual (2 : Fin 3)
        simpa [leveque03_coupledAcousticsMatrix, dotProduct,
          Fin.sum_univ_succ, smul_eq_mul] using h
  · rintro ⟨⟨pt, px, ut, ux, hpt, hpx, hut, hux, hpressure, hvelocity⟩,
      ⟨φt, φx, hφt, hφx, htracer⟩⟩
    refine ⟨![pt, ut, φt], ![px, ux, φx], ?_, ?_, ?_⟩
    · rw [hasDerivAt_pi]
      intro i
      fin_cases i
      · simpa [leveque03_coupledAcousticsState] using hpt
      · simpa [leveque03_coupledAcousticsState] using hut
      · simpa [leveque03_coupledAcousticsState] using hφt
    · rw [hasDerivAt_pi]
      intro i
      fin_cases i
      · simpa [leveque03_coupledAcousticsState] using hpx
      · simpa [leveque03_coupledAcousticsState] using hux
      · simpa [leveque03_coupledAcousticsState] using hφx
    · funext i
      fin_cases i
      · simp [leveque03_coupledAcousticsMatrix]
        linear_combination hpressure
      · simp [leveque03_coupledAcousticsMatrix]
        field_simp [hdensity] at hvelocity ⊢
        linear_combination hvelocity
      · simpa [leveque03_coupledAcousticsMatrix, Fin.sum_univ_succ,
          smul_eq_mul, mul_comm] using htracer

end NumStability
