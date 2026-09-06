import ComputationalMathematics.HDP.Scalar.LimitTheorems

/-!
Cross-split stable API for `HDP-01-DEF-BERNOULLI-BINOMIAL`.

This is a real forwarding definition.  The semantic producer owns the
canonical laws and their proofs; this leaf owns only the stable contract name
used by Chapters 2 and 3.
-/

namespace NumStability.HDP.Contract

open scoped NNReal

/-- Stable source-facing bundle of the Bernoulli and binomial laws. -/
noncomputable def hdp_01_hdef_hbernoulli_hbinomial
    (p : ℝ≥0) (hp : p ≤ 1) (N : ℕ) :
    NumStability.HDP.Scalar.LimitTheorems.BernoulliBinomialModelData p hp N :=
  NumStability.HDP.Scalar.LimitTheorems.bernoulliBinomialModel p hp N

end NumStability.HDP.Contract
