import Mathlib.Analysis.Calculus.Taylor
import Mathlib.Probability.Moments.MGFAnalytic

/-!
# Local Taylor expansions for moment-generating functions

This module supplies source-neutral analytic facts used by numbered HDP
contracts.  In particular, a bounded real random variable has an everywhere
finite moment-generating function, whose quadratic Taylor polynomial is given
by its first two moments.
-/

noncomputable section

open Filter MeasureTheory ProbabilityTheory Set TopologicalSpace
open scoped Topology

namespace NumStability.HDP

/-- A bounded measurable real random variable has the expected quadratic MGF
Taylor expansion at the origin. -/
theorem bounded_mgf_local_taylor
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : Ω → ℝ) (hX : Measurable X)
    (hBound : ∃ C : ℝ, ∀ ω, |X ω| ≤ C) :
    (fun lam : ℝ =>
      (∫ ω, Real.exp (lam * X ω) ∂μ) - 1 -
        lam * (∫ ω, X ω ∂μ) -
        lam ^ 2 / 2 * (∫ ω, (X ω) ^ 2 ∂μ)) =o[𝓝 (0 : ℝ)]
      (fun lam : ℝ => lam ^ 2) := by
  obtain ⟨C, hC⟩ := hBound
  have h_integrable (t : ℝ) :
      Integrable (fun ω => Real.exp (t * X ω)) μ := by
    apply Integrable.of_bound
        ((measurable_const.mul hX).exp.aestronglyMeasurable)
        (Real.exp (|t| * |C|))
    filter_upwards [] with ω
    rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _)]
    apply Real.exp_le_exp.mpr
    calc
      t * X ω ≤ |t * X ω| := le_abs_self _
      _ = |t| * |X ω| := abs_mul _ _
      _ ≤ |t| * |C| := mul_le_mul_of_nonneg_left
        (le_trans (hC ω) (le_abs_self C)) (abs_nonneg t)
  have h_set : integrableExpSet X μ = Set.univ :=
    Set.eq_univ_of_forall h_integrable
  have h_zero : (0 : ℝ) ∈ interior (integrableExpSet X μ) := by
    simp [h_set]
  have h_contdiff : ContDiffOn ℝ 2 (mgf X μ) Set.univ := by
    have h_analytic := analyticOn_mgf (X := X) (μ := μ)
    rw [h_set] at h_analytic
    simpa using h_analytic.contDiffOn
  have h_taylor := taylor_isLittleO (f := mgf X μ) (n := 2)
    (s := Set.univ) convex_univ (mem_univ (0 : ℝ)) h_contdiff
  rw [nhdsWithin_univ] at h_taylor
  have h_mgf_one : deriv (mgf X μ) 0 = ∫ ω, X ω ∂μ := by
    rw [← iteratedDeriv_one, iteratedDeriv_mgf_zero h_zero]
    simp
  have h_mgf_two : iteratedDeriv 2 (mgf X μ) 0 = ∫ ω, (X ω) ^ 2 ∂μ := by
    rw [iteratedDeriv_mgf_zero h_zero]
    rfl
  convert h_taylor using 1
  · funext lam
    simp [mgf, taylorWithinEval, taylorWithin, taylorCoeffWithin,
      Finset.sum_range_succ, h_mgf_one, h_mgf_two,
      div_eq_mul_inv, mul_comm, mul_assoc]
    ring
  · simp

/-- The quadratic exponential comparison used after the local MGF expansion:
`exp (λ² / 2)` differs from `1 + λ² / 2` by `o(λ²)`. -/
theorem exp_sq_half_local_taylor :
    (fun lam : ℝ => Real.exp (lam ^ 2 / 2) - (1 + lam ^ 2 / 2))
      =o[𝓝 (0 : ℝ)] (fun lam : ℝ => lam ^ 2) := by
  have h_exp := (Real.hasDerivAt_exp (0 : ℝ)).isLittleO
  have h_inner : Tendsto (fun lam : ℝ => lam ^ 2 / 2)
      (𝓝 (0 : ℝ)) (𝓝 (0 : ℝ)) := by
    have h_cont : ContinuousAt (fun lam : ℝ => lam ^ 2 / 2) 0 :=
      (continuousAt_id.pow 2).div_const (2 : ℝ)
    simpa using h_cont.tendsto
  have h_comp := h_exp.comp_tendsto h_inner
  have h_scaled :
      (fun lam : ℝ => Real.exp (lam ^ 2 / 2) - (1 + lam ^ 2 / 2))
        =o[𝓝 (0 : ℝ)] (fun lam : ℝ => (1 / 2 : ℝ) * lam ^ 2) := by
    convert h_comp using 1 <;> funext lam <;> simp <;> ring
  exact h_scaled.of_const_mul_right

end NumStability.HDP
