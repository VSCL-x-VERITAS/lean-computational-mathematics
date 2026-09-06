import ComputationalMathematics.HDP.Scalar.IndependentSums.GraphDegreeLaw

/-!
# Expected vertex degree in the binomial random graph

Reusable expectation calculations for the degree observable constructed in
`GraphDegreeLaw`.  This module is separate so downstream source contracts that
need only the degree law are not invalidated by later moment additions.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators ENNReal NNReal

namespace NumStability.HDP.Scalar.IndependentSums.Chernoff

noncomputable def graphAdjIndicator {V : Type*} (v w : V) (G : SimpleGraph V) : ℝ := by
  classical
  exact if G.Adj v w then 1 else 0

/-- One off-diagonal adjacency indicator in the binomial random graph has
expectation `p`. -/
lemma binomialRandom_graphAdjIndicator_mean
    {V : Type*} [Fintype V] [Countable V] [DecidableEq (Sym2 V)]
    (p : Set.Icc (0 : ℝ) 1) {v w : V} (hvw : v ≠ w) :
    ∫ G : SimpleGraph V, graphAdjIndicator v w G
      ∂(SimpleGraph.binomialRandom V p) = (p : ℝ) := by
  classical
  let A : Set (SimpleGraph V) := {G | G.Adj v w}
  have hA : MeasurableSet A := by
    dsimp [A]
    have hAdj : Measurable (fun G : SimpleGraph V => G.Adj v w) := by fun_prop
    convert hAdj (measurableSet_singleton True) using 1
    ext G
    simp
  have hfun : graphAdjIndicator v w =
      A.indicator (fun _ => (1 : ℝ)) := by
    funext G
    by_cases h : G.Adj v w <;> simp [graphAdjIndicator, A, h]
  have hevent : A = graphStarExactEvent v {w} {w} := by
    ext G
    simp [A, graphStarExactEvent]
  rw [hfun, integral_indicator_const (1 : ℝ) hA]
  simp only [smul_eq_mul, mul_one]
  rw [hevent, measureReal_def, binomialRandom_graphStarExactEvent_probability p]
  · norm_num
  · simpa [hvw]
  · simp

/-- The expected degree of a fixed vertex in `G(n,p)` is `(n - 1) p`. -/
theorem binomialRandom_graphDegreeSum_mean
    {n : ℕ} (p : Set.Icc (0 : ℝ) 1) (v : Fin n) :
    ∫ G : SimpleGraph (Fin n), (graphDegreeSum v G : ℝ)
      ∂(SimpleGraph.binomialRandom (Fin n) p) =
        ((n - 1 : ℕ) : ℝ) * (p : ℝ) := by
  classical
  have hpoint : (fun G : SimpleGraph (Fin n) => (graphDegreeSum v G : ℝ)) =
      fun G => ∑ w : Fin n, graphAdjIndicator v w G := by
    funext G
    simp [graphDegreeSum, graphAdjIndicator]
  rw [hpoint, MeasureTheory.integral_finset_sum Finset.univ]
  · calc
      (∑ w : Fin n,
          ∫ G : SimpleGraph (Fin n), graphAdjIndicator v w G
            ∂(SimpleGraph.binomialRandom (Fin n) p)) =
          ∑ w : Fin n, if v = w then 0 else (p : ℝ) := by
            apply Finset.sum_congr rfl
            intro w _hw
            by_cases hvw : v = w
            · subst w
              simp [graphAdjIndicator]
            · rw [if_neg hvw, binomialRandom_graphAdjIndicator_mean p hvw]
      _ = (Finset.univ.erase v).sum (fun _w => (p : ℝ)) := by
        calc
          (∑ w : Fin n, if v = w then 0 else (p : ℝ)) =
              (Finset.univ.erase v).sum (fun w => if v = w then 0 else (p : ℝ)) +
                (if v = v then 0 else (p : ℝ)) :=
            (Finset.sum_erase_add _ _ (Finset.mem_univ v)).symm
          _ = (Finset.univ.erase v).sum (fun _w => (p : ℝ)) := by
            simp only [ite_true, add_zero]
            apply Finset.sum_congr rfl
            intro w hw
            have hvw : v ≠ w := Ne.symm (Finset.mem_erase.mp hw).1
            simp [hvw]
      _ = ((n - 1 : ℕ) : ℝ) * (p : ℝ) := by
        simp [Finset.card_erase_of_mem]
  · intro w _hw
    have hAdj : Measurable (fun G : SimpleGraph (Fin n) => G.Adj v w) := by fun_prop
    have hset : MeasurableSet {G : SimpleGraph (Fin n) | G.Adj v w} := by
      convert hAdj (measurableSet_singleton True) using 1
      ext G
      simp
    have hMeas : Measurable (graphAdjIndicator v w) := by
      unfold graphAdjIndicator
      exact Measurable.ite hset measurable_const measurable_const
    apply Integrable.of_bound hMeas.aestronglyMeasurable 1
    filter_upwards [] with G
    by_cases h : G.Adj v w <;> simp [graphAdjIndicator, h]

end NumStability.HDP.Scalar.IndependentSums.Chernoff
