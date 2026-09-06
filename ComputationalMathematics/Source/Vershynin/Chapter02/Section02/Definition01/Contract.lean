import ComputationalMathematics.HDP.Scalar.IndependentSums.Hoeffding

/-!
Cross-split stable API for `HDP-02-DEF-2.2.1`.

The semantic producer owns the canonical fair Bernoulli coupling, its
Rademacher pushforward law, and the defining moment facts.  This leaf exports
only the stable book-facing definition family.
-/

noncomputable section

namespace NumStability.HDP.Contract

/-- Stable source-facing Rademacher law and defining facts. -/
noncomputable def hdp_02_hdef_h2_d2_d1 :
    NumStability.HDP.Scalar.IndependentSums.Hoeffding.RademacherModelData :=
  NumStability.HDP.Scalar.IndependentSums.Hoeffding.rademacherModel

end NumStability.HDP.Contract
