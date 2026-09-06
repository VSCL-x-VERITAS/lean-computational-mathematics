import ComputationalMathematics.HDP.Scalar.LimitTheorems
import Mathlib.Analysis.SpecialFunctions.Pow.Asymptotics

/-!
# Contract: HDP Chapter 1, Exercise 1.3.3

The expected absolute error of an iid sample mean with finite variance is
`O(1 / √N)`.  The source starts at positive sample sizes; the formal sequence
uses `N + 1` so that every natural index denotes a nonempty sample.
-/

noncomputable section

open MeasureTheory Filter ProbabilityTheory Asymptotics
open scoped BigOperators Function

namespace NumStability.HDP.Contract

/-- Exercise 1.3.3: the iid sample-mean absolute error is `O(1 / √N)`. -/
theorem hdp_01_hex_h1_d3_d3
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ℕ → Ω → ℝ}
    (hX : ∀ i, MemLp (X i) 2 μ)
    (hIndep : ∀ ⦃i j : ℕ⦄, i ≠ j → IndepFun (X i) (X j) μ)
    (hIdent : ∀ i, IdentDistrib (X i) (X 0) μ μ) :
    (fun N : ℕ =>
      ∫ ω, |(((N + 1 : ℕ) : ℝ)⁻¹ * ∑ i : Fin (N + 1), X i ω) -
        ∫ ω, X 0 ω ∂μ| ∂μ) =O[atTop]
      (fun N : ℕ => 1 / Real.sqrt ((N + 1 : ℕ) : ℝ)) := by
  refine IsBigO.of_bound (Real.sqrt Var[X 0; μ])
    (Filter.Eventually.of_forall fun N => ?_)
  have hfinite :=
    NumStability.HDP.Scalar.LimitTheorems.iidSampleMeanExpectedAbsDeviation
      (N + 1) (Nat.succ_pos N)
      (X := fun i : Fin (N + 1) => X i)
      (fun i => hX i)
      (by
        intro i j hij
        exact hIndep (by
          intro h
          apply hij
          exact Fin.ext h))
      (fun i => by simpa using hIdent i)
  have hleft_nonneg :
      0 ≤ ∫ ω, |(((N + 1 : ℕ) : ℝ)⁻¹ *
          ∑ i : Fin (N + 1), X i ω) - ∫ ω, X 0 ω ∂μ| ∂μ :=
    integral_nonneg fun _ => abs_nonneg _
  have hden_nonneg :
      0 ≤ 1 / Real.sqrt ((N + 1 : ℕ) : ℝ) := by positivity
  rw [Real.norm_eq_abs, abs_of_nonneg hleft_nonneg, Real.norm_eq_abs,
    abs_of_nonneg hden_nonneg]
  calc
    (∫ ω, |(((N + 1 : ℕ) : ℝ)⁻¹ * ∑ i : Fin (N + 1), X i ω) -
        ∫ ω, X 0 ω ∂μ| ∂μ) ≤
        Real.sqrt (((N + 1 : ℕ) : ℝ)⁻¹ * Var[X 0; μ]) := hfinite
    _ = Real.sqrt Var[X 0; μ] *
        (1 / Real.sqrt ((N + 1 : ℕ) : ℝ)) := by
      rw [Real.sqrt_mul (by positivity), Real.sqrt_inv]
      ring

end NumStability.HDP.Contract
