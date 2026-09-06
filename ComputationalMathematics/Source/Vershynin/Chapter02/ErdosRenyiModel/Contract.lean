import ComputationalMathematics.HDP.Scalar.IndependentSums.Chernoff
/-!
# Contract: HDP Section 2.4 Erdős--Rényi model

Source-facing wrapper for the Erdős--Rényi random graph `G(n, p)` and its
vertex-degree interface, as introduced in the body of Vershynin,
*High-Dimensional Probability* (first edition, 2018), Section 2.4, printed
page 21.  The mathematics lives in
`NumStability.HDP.Scalar.IndependentSums.Chernoff`; this module only exposes
the stable source-facing name.
-/

namespace NumStability.HDP.Contract

open MeasureTheory

/-- Chapter 2's Erdős--Rényi random graph and degree interface. -/
noncomputable def hdp_02_hdef_herdos_hrenyi
    (n : ℕ) (p : Set.Icc (0 : ℝ) 1) :
    NumStability.HDP.Scalar.IndependentSums.Chernoff.ErdosRenyiModelData n p :=
  NumStability.HDP.Scalar.IndependentSums.Chernoff.erdosRenyiModel n p

end NumStability.HDP.Contract
