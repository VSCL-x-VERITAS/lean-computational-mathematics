import ComputationalMathematics.HDP.Scalar.LimitTheorems

/-!
Cross-split stable API for `HDP-01-DEF-STANDARD-NORMAL`.

The semantic producer owns the canonical Gaussian law and the random-variable
predicate; this leaf owns only the stable source-facing law name.
-/

namespace NumStability.HDP.Contract

open MeasureTheory

/-- The standard normal probability law from Chapter 1, equation (1.6). -/
noncomputable def hdp_01_hdef_hstandard_hnormal : Measure ℝ :=
  NumStability.HDP.Scalar.LimitTheorems.standardNormalLaw

end NumStability.HDP.Contract
