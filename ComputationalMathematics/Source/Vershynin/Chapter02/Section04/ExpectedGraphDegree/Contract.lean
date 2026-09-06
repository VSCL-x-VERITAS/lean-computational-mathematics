import ComputationalMathematics.Source.Vershynin.Chapter02.ErdosRenyiModel.Contract
import ComputationalMathematics.HDP.Scalar.IndependentSums.GraphDegreeMean

/-!
# Contract: HDP Section 2.4 expected vertex degree

Source-facing wrapper for the body claim on printed page 21 that every vertex
of `G(n,p)` has expected degree `(n - 1) p`.
-/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Contract

/-- Every vertex in the Erdős--Rényi model `G(n,p)` has expected degree
`(n - 1) p`. -/
theorem hdp_02_hbody_h2_d4_hexpected_hdegree
    (n : ℕ) (p : Set.Icc (0 : ℝ) 1) (v : Fin n) :
    ∫ G : SimpleGraph (Fin n),
        ((hdp_02_hdef_herdos_hrenyi n p).degree v G : ℝ)
      ∂(hdp_02_hdef_herdos_hrenyi n p).graphLaw =
        ((n - 1 : ℕ) : ℝ) * (p : ℝ) := by
  have h :=
    NumStability.HDP.Scalar.IndependentSums.Chernoff.binomialRandom_graphDegreeSum_mean
      p v
  rw [show (hdp_02_hdef_herdos_hrenyi n p).graphLaw =
      SimpleGraph.binomialRandom (Fin n) p by
        exact (hdp_02_hdef_herdos_hrenyi_spec n p).1]
  convert h using 1
  apply integral_congr_ae
  filter_upwards [] with G
  exact_mod_cast
    NumStability.HDP.Scalar.IndependentSums.Chernoff.erdosRenyiModel_degree_eq_graphDegreeSum
      n p v G

end NumStability.HDP.Contract
