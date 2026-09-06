import ComputationalMathematics.HDP.Scalar.AsymptoticComparisons

/-!
# Frozen contract signature for the Section 2.1 asymptotic-notation footnote

The source explicitly permits the positive-constant inequalities either at
every index or at every sufficiently large index.  The signature records both
readings for the two-sided and one-sided relations.
-/

noncomputable section

open Filter

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.AsymptoticComparisons

def hdp_02_hnotation_h2_d1_hasymptotic__contract_type : Prop :=
  ∀ f g : ℕ → ℝ,
    (IsComparableEverywhere f g ↔
      ∃ c C : ℝ, 0 < c ∧ 0 < C ∧
        ∀ n, c * f n ≤ g n ∧ g n ≤ C * f n) ∧
    (IsComparableEventually f g ↔
      ∃ c C : ℝ, 0 < c ∧ 0 < C ∧
        ∀ᶠ n in Filter.atTop, c * f n ≤ g n ∧ g n ≤ C * f n) ∧
    (IsLessSimEverywhere f g ↔
      ∃ C : ℝ, 0 < C ∧ ∀ n, f n ≤ C * g n) ∧
    (IsLessSimEventually f g ↔
      ∃ C : ℝ, 0 < C ∧ ∀ᶠ n in Filter.atTop, f n ≤ C * g n) ∧
    (IsGreaterSimEverywhere f g ↔
      ∃ c : ℝ, 0 < c ∧ ∀ n, g n ≤ c * f n) ∧
    (IsGreaterSimEventually f g ↔
      ∃ c : ℝ, 0 < c ∧ ∀ᶠ n in Filter.atTop, g n ≤ c * f n)

end NumStability.HDP.Contract
