import ComputationalMathematics.HDP.Scalar.IndependentSums.Chernoff

/-!
# Chapter 2 Erdős--Rényi model contract

Source-facing wrapper for the Erdős--Rényi random graph `G(n, p)` and its
vertex-degree interface, as introduced in the body of Vershynin,
*High-Dimensional Probability* (first edition, 2018), Section 2.4, printed
page 21.  The mathematics lives in
`ComputationalMathematics.HDP.Scalar.IndependentSums.Chernoff`; this module exposes
the stable source-facing name.
-/

namespace NumStability.HDP.Contract

open MeasureTheory ProbabilityTheory
open scoped ENNReal NNReal

/-- Chapter 2's Erdős--Rényi random graph and degree interface. -/
noncomputable def hdp_02_hdef_herdos_hrenyi
    (n : ℕ) (p : Set.Icc (0 : ℝ) 1) :
    NumStability.HDP.Scalar.IndependentSums.Chernoff.ErdosRenyiModelData n p :=
  NumStability.HDP.Scalar.IndependentSums.Chernoff.erdosRenyiModel n p

/-- The model uses Mathlib's independent Bernoulli edge law and its canonical
vertex-degree observable. -/
theorem hdp_02_hdef_herdos_hrenyi_spec
    (n : ℕ) (p : Set.Icc (0 : ℝ) 1) :
    (hdp_02_hdef_herdos_hrenyi n p).graphLaw =
        SimpleGraph.binomialRandom (Fin n) p ∧
      ∀ (v : Fin n) (G : SimpleGraph (Fin n)),
        (hdp_02_hdef_herdos_hrenyi n p).degree v G =
          @SimpleGraph.degree (Fin n) G v
            (Fintype.ofFinite (G.neighborSet v)) := by
  simp [hdp_02_hdef_herdos_hrenyi,
    NumStability.HDP.Scalar.IndependentSums.Chernoff.erdosRenyiModel]

/-- Every prescribed finite pattern of distinct edges has the Bernoulli
product probability.  This is the finite-dimensional form of the statement
that all distinct vertex pairs are connected independently with probability
`p`. -/
theorem hdp_02_hdef_herdos_hrenyi_edge_pattern_probability
    (n : ℕ) (p : Set.Icc (0 : ℝ) 1)
    (E T : Finset (Sym2 (Fin n)))
    (hE : (E : Set (Sym2 (Fin n))) ⊆ Sym2.diagSetᶜ) (hT : T ⊆ E) :
    (hdp_02_hdef_herdos_hrenyi n p).graphLaw
        (NumStability.HDP.Scalar.IndependentSums.Chernoff.graphEdgesExactFinsetEvent E T) =
      (unitInterval.toNNReal p : ℝ≥0∞) ^ T.card *
        (unitInterval.toNNReal (unitInterval.symm p) : ℝ≥0∞) ^
          (E.card - T.card) := by
  classical
  change SimpleGraph.binomialRandom (Fin n) p
      (NumStability.HDP.Scalar.IndependentSums.Chernoff.graphEdgesExactFinsetEvent E T) = _
  rw [SimpleGraph.binomialRandom_eq_map]
  rw [Measure.map_apply SimpleGraph.measurable_fromEdgeSet]
  · have hpre :
        SimpleGraph.fromEdgeSet ⁻¹'
            NumStability.HDP.Scalar.IndependentSums.Chernoff.graphEdgesExactFinsetEvent E T =
          NumStability.HDP.Scalar.IndependentSums.Chernoff.setBernoulliFinsetExactEvent E T := by
      ext s
      simp only [Set.mem_preimage,
        NumStability.HDP.Scalar.IndependentSums.Chernoff.graphEdgesExactFinsetEvent,
        NumStability.HDP.Scalar.IndependentSums.Chernoff.setBernoulliFinsetExactEvent,
        Set.mem_setOf_eq]
      constructor
      · intro hs e heE
        have hnotdiag : e ∈ Sym2.diagSetᶜ := hE (by simpa using heE)
        have hnotdiag' : ¬ e.IsDiag := by simpa [Sym2.mem_diagSet] using hnotdiag
        rw [SimpleGraph.edgeSet_fromEdgeSet] at hs
        simpa [hnotdiag'] using hs e heE
      · intro hs e heE
        have hnotdiag : e ∈ Sym2.diagSetᶜ := hE (by simpa using heE)
        have hnotdiag' : ¬ e.IsDiag := by simpa [Sym2.mem_diagSet] using hnotdiag
        rw [SimpleGraph.edgeSet_fromEdgeSet]
        simpa [hnotdiag'] using hs e heE
    rw [hpre]
    exact
      NumStability.HDP.Scalar.IndependentSums.Chernoff.setBernoulliFinsetExactEvent_probability
        Sym2.diagSetᶜ p E T hE hT
  · exact
      NumStability.HDP.Scalar.IndependentSums.Chernoff.measurableSet_graphEdgesExactFinsetEvent E T

end NumStability.HDP.Contract
