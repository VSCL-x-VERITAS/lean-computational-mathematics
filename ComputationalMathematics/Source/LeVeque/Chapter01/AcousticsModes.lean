/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter01.Equation04
import ComputationalMathematics.Source.LeVeque.Chapter01.Equation05

/-!
# LeVeque Chapter 1, acoustic characteristic modes

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,
printed pages 2--3 (raw PDF pages 24--25).
-/

namespace NumStability

private theorem leveque01_acousticMaterialIdentity
    {bulkModulus density : ℝ}
    (hbulkModulus : 0 < bulkModulus) (hdensity : 0 < density) :
    bulkModulus =
      density * (Real.sqrt (bulkModulus / density)) ^ 2 := by
  have hratio : 0 ≤ bulkModulus / density :=
    div_nonneg hbulkModulus.le hdensity.le
  rw [Real.sq_sqrt hratio]
  field_simp [ne_of_gt hdensity]

/-- The characteristic variable `w₁ = p + ρ c u`, with
`c = sqrt (K / ρ)`, satisfies the right-going one-way wave equation. -/
theorem leveque01_acousticsRightMode
    {bulkModulus density : ℝ}
    (system : LinearAcousticsSolution bulkModulus density)
    (hbulkModulus : 0 < bulkModulus) (hdensity : 0 < density) :
    0 < Real.sqrt (bulkModulus / density) ∧
      ∀ x t,
        leveque01_equation04_oneWayWaveAt
          (linearAcousticsRightInvariant system.pressure system.velocity
            density (Real.sqrt (bulkModulus / density)))
          (Real.sqrt (bulkModulus / density)) x t := by
  have hratio : 0 < bulkModulus / density :=
    div_pos hbulkModulus hdensity
  constructor
  · exact Real.sqrt_pos.2 hratio
  · intro x t
    exact linearAcousticsRightInvariant_isLinearAdvectionSolutionAt
      system.pressure system.velocity bulkModulus density
      (Real.sqrt (bulkModulus / density)) x t system.density_ne_zero
      (leveque01_acousticMaterialIdentity hbulkModulus hdensity)
      (system.satisfies x t)

/-- The characteristic variable `w₂ = p - ρ c u`, with
`c = sqrt (K / ρ)`, satisfies the left-going equation with speed `-c`.
Translated profiles for that speed have the printed form `q̃(x + c t)`;
the book's `q₂` at this point is read as the previously named `w₂`. -/
theorem leveque01_acousticsLeftMode
    {bulkModulus density : ℝ}
    (system : LinearAcousticsSolution bulkModulus density)
    (hbulkModulus : 0 < bulkModulus) (hdensity : 0 < density) :
    0 < Real.sqrt (bulkModulus / density) ∧
      (∀ x t,
        leveque01_equation04_oneWayWaveAt
          (linearAcousticsLeftInvariant system.pressure system.velocity
            density (Real.sqrt (bulkModulus / density)))
          (-Real.sqrt (bulkModulus / density)) x t) ∧
      ∀ {profile : ℝ → ℝ} {profile' : ℝ} x t,
        HasDerivAt profile profile'
          (x + Real.sqrt (bulkModulus / density) * t) →
        leveque01_equation04_oneWayWaveAt
            (travelingWave profile (-Real.sqrt (bulkModulus / density)))
            (-Real.sqrt (bulkModulus / density)) x t ∧
          travelingWave profile (-Real.sqrt (bulkModulus / density)) x t =
            profile (x + Real.sqrt (bulkModulus / density) * t) := by
  have hratio : 0 < bulkModulus / density :=
    div_pos hbulkModulus hdensity
  refine ⟨Real.sqrt_pos.2 hratio, ?_, ?_⟩
  · intro x t
    exact linearAcousticsLeftInvariant_isLinearAdvectionSolutionAt
      system.pressure system.velocity bulkModulus density
      (Real.sqrt (bulkModulus / density)) x t system.density_ne_zero
      (leveque01_acousticMaterialIdentity hbulkModulus hdensity)
      (system.satisfies x t)
  · intro profile profile' x t hprofile
    constructor
    · exact travelingWave_isLinearAdvectionSolutionAt
        (-Real.sqrt (bulkModulus / density)) x t (by
          simpa [neg_mul] using hprofile)
    · simp [travelingWave]

/-- The two acoustic characteristic variables satisfy scalar one-way wave
equations with the opposite speeds `+c` and `-c`. -/
theorem leveque01_acousticsTwoWaveDecomposition
    {bulkModulus density : ℝ}
    (system : LinearAcousticsSolution bulkModulus density)
    (hbulkModulus : 0 < bulkModulus) (hdensity : 0 < density) :
    ∀ x t,
      leveque01_equation04_oneWayWaveAt
          (linearAcousticsRightInvariant system.pressure system.velocity
            density (Real.sqrt (bulkModulus / density)))
          (Real.sqrt (bulkModulus / density)) x t ∧
        leveque01_equation04_oneWayWaveAt
          (linearAcousticsLeftInvariant system.pressure system.velocity
            density (Real.sqrt (bulkModulus / density)))
          (-Real.sqrt (bulkModulus / density)) x t := by
  intro x t
  exact ⟨(leveque01_acousticsRightMode system hbulkModulus hdensity).2 x t,
    (leveque01_acousticsLeftMode system hbulkModulus hdensity).2.1 x t⟩

end NumStability
