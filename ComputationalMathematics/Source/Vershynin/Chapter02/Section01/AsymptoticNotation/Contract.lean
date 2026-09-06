import ComputationalMathematics.Source.Vershynin.Chapter02.Section01.AsymptoticNotation.Signature

/-! Source-facing contract for the Section 2.1 asymptotic-notation footnote. -/

noncomputable section

open Filter

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.AsymptoticComparisons

/-- Printed page 14, footnote 1: two-sided and one-sided comparison up to
positive constant factors, either everywhere or eventually at infinity. -/
theorem hdp_02_hnotation_h2_d1_hasymptotic :
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
        ∃ c : ℝ, 0 < c ∧ ∀ᶠ n in Filter.atTop, g n ≤ c * f n) := by
  intro f g
  simp [IsComparableEverywhere, IsComparableEventually,
    IsLessSimEverywhere, IsLessSimEventually, IsGreaterSimEverywhere,
    IsGreaterSimEventually]

/-- The implementation inhabits the frozen source-facing signature. -/
theorem hdp_02_hnotation_h2_d1_hasymptotic__contract :
    hdp_02_hnotation_h2_d1_hasymptotic__contract_type :=
  hdp_02_hnotation_h2_d1_hasymptotic

end NumStability.HDP.Contract
