import ComputationalMathematics.HDP.Metric.Entropy

/-!
# Vershynin Chapter 4, coding-complexity definition
-/

open Set
open scoped ENNReal NNReal

namespace NumStability.HDP.Contract

/-- Vershynin, Section 4.3.1: coding complexity is the least bit length of an
encoding for which points sharing a codeword are within the requested metric
accuracy. -/
theorem hdp_04_coding_complexity_definition
    {T : Type*} [PseudoEMetricSpace T] (K : Set T) (ε : ℝ≥0) :
    NumStability.HDP.Metric.codingComplexity K ε =
      ⨅ (N : ℕ) (_ : ∃ encode : K → Fin (2 ^ N),
        ∀ x y : K, encode x = encode y → edist (x : T) y ≤ ε),
        (N : ℕ∞) :=
  NumStability.HDP.Metric.codingComplexity_eq_iInf K ε

end NumStability.HDP.Contract
