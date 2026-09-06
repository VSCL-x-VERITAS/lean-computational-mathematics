import ComputationalMathematics.HDP.Scalar.IndependentSums.Chernoff

/-!
# Chapter 2 Erdős--Rényi model contract

Stable source-facing aliases for the finite binomial random-graph model and its
degree observable.
-/

namespace NumStability.HDP.Contract

open MeasureTheory

/-- Chapter 2's Erdős--Rényi random graph and degree interface. -/
noncomputable def hdp_02_hdef_herdos_hrenyi
    (n : ℕ) (p : Set.Icc (0 : ℝ) 1) :
    NumStability.HDP.Scalar.IndependentSums.Chernoff.ErdosRenyiModelData n p :=
  NumStability.HDP.Scalar.IndependentSums.Chernoff.erdosRenyiModel n p

end NumStability.HDP.Contract
