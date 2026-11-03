/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.WaveSuperpositionAverageTarget

/-!
# Physical wave superposition and cell averages

The actual characteristic field supplies the Cauchy and rectangle laws.
Each translated mode contributes its signed incoming-wave average, and
specializing the finite sum gives the three-wave formula.
-/

namespace NumStability

/-- The complete wave-superposition and physical cell-average specification,
including closed horizons, full one-cell CFL, zero time and signed three waves. -/
theorem leveque04_waveSuperpositionAverage :
    Leveque04WaveSuperpositionAverageTarget := by
  constructor
  · intro m _ coefficient basis speeds heigen old origin width horizon hwidth hhorizon
    dsimp only
    obtain ⟨hinit, hpde, hchain⟩ :=
      leveque04_linearRiemannChain_exactCauchy coefficient basis speeds heigen
        old origin width horizon hwidth hhorizon.le
    refine ⟨hinit, hpde, ?_, hchain, ?_⟩
    · intro i
      exact leveque04_uniformReconstruction_cellAverage origin width hwidth old i
    · intro hCFL time htime i
      have hCFLtime : ∀ p, |speeds p * time| ≤ width := by
        intro p
        calc
          |speeds p * time| = |speeds p| * time := by
            rw [abs_mul, abs_of_nonneg htime.1]
          _ ≤ |speeds p| * horizon :=
            mul_le_mul_of_nonneg_left htime.2 (abs_nonneg _)
          _ = |speeds p * horizon| := by
            rw [abs_mul, abs_of_nonneg hhorizon.le]
          _ ≤ width := hCFL p
      constructor
      · intro p
        exact leveque04_linearUniformEvolution_modalAverageEffect_of_CFL
          coefficient basis speeds heigen origin width time hwidth htime.1
          hCFLtime old i p
      · simpa only [leveque04_linearGodunovWaveStep, leveque04_positiveFluctuation,
          leveque04_negativeFluctuation, leveque04_positiveVelocity,
          leveque04_negativeVelocity] using
          leveque04_linearUniformEvolution_cellAverage_of_CFL
            coefficient basis speeds heigen origin width time hwidth htime.1 hCFLtime old i
  · intro coefficient basis speeds heigen h0 h1 h12 old origin width time
      hwidth htime hCFL i
    have h2 : 0 < speeds 2 := lt_trans h1 h12
    have havg := leveque04_linearUniformEvolution_cellAverage_of_CFL
      coefficient basis speeds heigen origin width time hwidth htime hCFL old i
    simpa [leveque04_linearGodunovWaveStep, leveque04_positiveFluctuation,
      leveque04_negativeFluctuation, leveque04_positiveVelocity,
      leveque04_negativeVelocity, Fin.sum_univ_succ,
      max_eq_right h0.le, max_eq_left h1.le, max_eq_left h2.le,
      min_eq_left h0.le, min_eq_right h1.le, min_eq_right h2.le, add_assoc] using havg

end NumStability
