import ComputationalMathematics.Source.Vershynin.Chapter01.JensenInequality.Signature
import ComputationalMathematics.HDP.Scalar.Preliminaries.Basic

/-!
Stable Chapter 1 forwarding module for Jensen's inequality.

Section 1.2 prints the inequality for a convex function `φ` as

  `φ(E X) ≤ E φ(X)`,

with no exceptional-value convention for the two ordinary expectations it
displays.  Following the module-owned finite-Lebesgue-integral definability
convention in `module/instructions.md`, this contract carries exactly the two
premises that make those displayed expectations well-defined real numbers,
`Integrable X μ` and `Integrable (fun ω => φ (X ω)) μ`.  They are the declared
meaning conditions of the printed statement, not proof conveniences, and no
hypothesis beyond them is imposed: convexity is taken on all of `ℝ`, as printed.
-/

namespace NumStability.HDP.Contract

open MeasureTheory
open NumStability.HDP.Scalar.Preliminaries

/-- Chapter 1 source-facing Jensen inequality, stated on the declared
finite-integral definability domain. -/
theorem hdp_01_hthm_hjensen
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {φ : ℝ → ℝ}
    (hφ : ConvexOn ℝ Set.univ φ)
    (hX : Integrable X μ)
    (hφX : Integrable (fun ω => φ (X ω)) μ) :
    φ (expectation μ X) ≤ expectation μ (fun ω => φ (X ω)) :=
  jensenIntegral hφ hX hφX

/-- The frozen proof-free Jensen signature, discharged by the source-facing
wrapper above. -/
theorem hdp_01_hthm_hjensen__contract
    : hdp_01_hthm_hjensen__contract_type := by
  intro Ω instΩ μ instμ X φ hφ hX hφX
  exact hdp_01_hthm_hjensen hφ hX hφX

end NumStability.HDP.Contract
