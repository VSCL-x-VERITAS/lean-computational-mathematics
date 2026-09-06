import ComputationalMathematics.HDP.Scalar.IndependentSums.Hoeffding

/-!
Cross-split stable API for `HDP-02-DEF-2.2.1`.

The semantic producer owns the canonical fair Bernoulli coupling, its
Rademacher pushforward law, and the defining moment facts.  This leaf exports
only the stable book-facing definition family.
-/

noncomputable section

namespace NumStability.HDP.Contract

open scoped NNReal

/-- Stable source-facing Rademacher law and defining facts. -/
noncomputable def hdp_02_hdef_h2_d2_d1 :
    NumStability.HDP.Scalar.IndependentSums.Hoeffding.RademacherModelData :=
  NumStability.HDP.Scalar.IndependentSums.Hoeffding.rademacherModel

/-- Proposition-valued source interface for Definition 2.2.1 and its
immediately following affine Bernoulli characterization. -/
theorem hdp_02_hdef_h2_d2_d1_spec :
    hdp_02_hdef_h2_d2_d1.law (-1) = 1 / 2 ∧
      hdp_02_hdef_h2_d2_d1.law 1 = 1 / 2 ∧
      ∀ {p : ℝ≥0} (hp : p ≤ 1),
        PMF.map
            NumStability.HDP.Scalar.IndependentSums.Hoeffding.rademacherValue
            (PMF.bernoulli p hp) = hdp_02_hdef_h2_d2_d1.law ↔
          p = (1 / 2 : ℝ≥0) := by
  exact
    ⟨hdp_02_hdef_h2_d2_d1.mass_neg_one,
      hdp_02_hdef_h2_d2_d1.mass_one,
      hdp_02_hdef_h2_d2_d1.affine_bernoulli_iff⟩

end NumStability.HDP.Contract
