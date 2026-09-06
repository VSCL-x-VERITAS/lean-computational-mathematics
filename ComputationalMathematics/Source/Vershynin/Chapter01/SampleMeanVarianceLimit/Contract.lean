import ComputationalMathematics.HDP.Scalar.LimitTheorems
/-!
# Chapter 1 sample-mean variance limit contract

Source-facing consequence of Equation (1.5): for an infinite iid real family
with finite second moment, the variances of the nonempty sample means converge
to zero.
-/

noncomputable section

open Filter MeasureTheory ProbabilityTheory
open scoped BigOperators ENNReal NNReal Topology

namespace NumStability.HDP.Contract

/-- The variance of the mean of the first `N + 1` iid samples tends to zero. -/
theorem hdp_01_hclaim_hsample_hmean_hvariance_hlimit
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsFiniteMeasure μ]
    {X : ℕ → Ω → ℝ}
    (hX : ∀ i, MemLp (X i) 2 μ)
    (hIndep : ∀ ⦃i j : ℕ⦄, i ≠ j → IndepFun (X i) (X j) μ)
    (hIdent : ∀ i, IdentDistrib (X i) (X 0) μ μ) :
    Tendsto
      (fun N : ℕ =>
        Var[fun ω => ((N + 1 : ℕ) : ℝ)⁻¹ * ∑ i : Fin (N + 1), X i ω; μ])
      atTop (𝓝 0) := by
  have hvariance : ∀ N : ℕ,
      Var[fun ω => ((N + 1 : ℕ) : ℝ)⁻¹ * ∑ i : Fin (N + 1), X i ω; μ] =
        ((N + 1 : ℕ) : ℝ)⁻¹ * Var[X 0; μ] := by
    intro N
    simpa using
      (NumStability.HDP.Scalar.LimitTheorems.iidSampleMeanVariance
        (N + 1) (Nat.succ_pos N)
        (X := fun i : Fin (N + 1) => X i)
        (fun i => hX i)
        (by
          intro i j hij
          exact hIndep (by
            intro h
            apply hij
            exact Fin.ext h))
        (fun i => by simpa using hIdent i))
  have hden : Tendsto (fun N : ℕ => ((N + 1 : ℕ) : ℝ)) atTop atTop := by
    simpa [Nat.cast_add, Nat.cast_one] using
      ((tendsto_natCast_atTop_atTop :
        Tendsto (fun N : ℕ => (N : ℝ)) atTop atTop).atTop_add tendsto_const_nhds)
  have hlimit : Tendsto
      (fun N : ℕ => Var[X 0; μ] / ((N + 1 : ℕ) : ℝ)) atTop (𝓝 0) :=
    tendsto_const_nhds.div_atTop hden
  refine hlimit.congr' (Filter.Eventually.of_forall fun N => ?_)
  ·
    symm
    change
      Var[fun ω => ((N + 1 : ℕ) : ℝ)⁻¹ * ∑ i : Fin (N + 1), X i ω; μ] = _
    rw [hvariance N]
    simp only [div_eq_mul_inv]
    ring

end NumStability.HDP.Contract
