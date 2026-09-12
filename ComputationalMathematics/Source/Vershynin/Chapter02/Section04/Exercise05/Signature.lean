import ComputationalMathematics.HDP.Scalar.IndependentSums.VerySparseDegreeLower
import ComputationalMathematics.HDP.Scalar.IndependentSums.Chernoff

/-!
# Frozen discrepancy signatures for Exercise 2.4.5

The first proposition records the zero-edge obstruction to the printed
upper-bound-only hypothesis.  The second states the corrected result with
expected degree bounded away from zero as well as bounded above.
-/

noncomputable section

open MeasureTheory Filter
open scoped Topology

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.IndependentSums.Chernoff

def hdp_02_hex_h2_d4_d5_source_obstruction__contract_type : Prop :=
  (∀ᶠ n : ℕ in atTop,
      ((n - 1 : ℕ) : ℝ) * ((0 : Set.Icc (0 : ℝ) 1) : ℝ) ≤ 0) ∧
    ¬ ∃ c : ℝ, 0 < c ∧
      ∀ᶠ n : ℕ in atTop,
        (erdosRenyiModel n (0 : Set.Icc (0 : ℝ) 1)).graphLaw.real
            {G | ∃ v : Fin n,
              c * (Real.log (n : ℝ) / Real.log (Real.log (n : ℝ))) ≤
                (erdosRenyiModel n (0 : Set.Icc (0 : ℝ) 1)).degree v G} ≥
          (9 : ℝ) / 10

def hdp_02_hex_h2_d4_d5_corrected__contract_type : Prop :=
  ∀ (p : ℕ → Set.Icc (0 : ℝ) 1) (c C : ℝ),
    0 < c →
    (∀ᶠ n : ℕ in atTop,
      c ≤ ((n - 1 : ℕ) : ℝ) * (p n : ℝ)) →
    (∀ᶠ n : ℕ in atTop,
      ((n - 1 : ℕ) : ℝ) * (p n : ℝ) ≤ C) →
    ∀ᶠ n : ℕ in atTop,
      (erdosRenyiModel n (p n)).graphLaw.real
          {G | ∃ v : Fin n,
            (Real.log (n : ℝ) / Real.log (Real.log (n : ℝ))) / 128 ≤
              (erdosRenyiModel n (p n)).degree v G} ≥
        (9 : ℝ) / 10

end NumStability.HDP.Contract
