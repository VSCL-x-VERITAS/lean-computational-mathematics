import ComputationalMathematics.HDP.Scalar.Preliminaries.Basic

/-! Stable Chapter 1 contract for the pointwise decomposition in Markov's proof. -/

namespace NumStability.HDP.Contract

/-- The indicator lower bound used in the source proof of Markov's inequality. -/
theorem hdp_01_hlem_hmarkov_hindicator_hbound {x t : ℝ}
    (hx : 0 ≤ x) (ht : 0 < t) :
    t * Set.indicator (Set.Ici t) (fun _ => (1 : ℝ)) x ≤ x :=
  NumStability.HDP.Scalar.Preliminaries.markovIndicatorBound hx ht

/-- A real number splits across the complementary events `x ≥ t` and `x < t`. -/
theorem hdp_01_hprop_h1_d2_d4_hdecomposition_spec (x t : ℝ) :
    x = x * (if t ≤ x then 1 else 0) +
      x * (if x < t then 1 else 0) := by
  by_cases h : t ≤ x
  · simp [h, not_lt_of_ge h]
  · have h' : x < t := lt_of_not_ge h
    simp [h, h']

end NumStability.HDP.Contract
