import ComputationalMathematics.HDP.Scalar.IndependentSums.Chernoff

/-!
# Frozen contract signature for Exercise 2.4.4

The integer-valued threshold records the source's footnote assumption that ten
times the expected degree is an integer.  The event uses literal degree
equality, as required by the printed wording and its Poisson point-mass hint.
-/

noncomputable section

open MeasureTheory Filter
open scoped Topology

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.IndependentSums.Chernoff

def hdp_02_hex_h2_d4_d4__contract_type : Prop :=
  ∀ (p : ℕ → Set.Icc (0 : ℝ) 1) (k : ℕ → ℕ),
    (∀ n, (k n : ℝ) = 10 * ((n - 1 : ℕ) : ℝ) * (p n : ℝ)) →
    Tendsto (fun n => (k n : ℝ) / Real.log (n : ℝ)) atTop (𝓝 0) →
    ∀ᶠ n in atTop,
      (erdosRenyiModel n (p n)).graphLaw.real {G |
        ∃ v : Fin n, (erdosRenyiModel n (p n)).degree v G = k n} ≥
      (9 : ℝ) / 10

end NumStability.HDP.Contract
