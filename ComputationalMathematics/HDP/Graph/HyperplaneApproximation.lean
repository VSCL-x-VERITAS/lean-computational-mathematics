import ComputationalMathematics.HDP.Graph.ArccosBound
import ComputationalMathematics.HDP.Graph.MaxCutSigns
import ComputationalMathematics.HDP.Graph.MaxCutSemidefinite
import ComputationalMathematics.HDP.Optimization.GrothendieckRelaxationGuarantee

/-!
# The deterministic arccos value behind hyperplane rounding

Grothendieck's identity identifies the expectation of a rounded cut with the
finite arccos sum defined here.  This module proves the deterministic numerical
comparison with the semidefinite objective, independently of that probabilistic
identity.
-/

namespace NumStability.HDP.Graph

open scoped BigOperators InnerProductSpace
open Set

noncomputable section

/-- The finite arccos sum which equals the expected value of Gaussian
hyperplane rounding once Grothendieck's identity is supplied. -/
def arccosRoundingValue {n : ℕ} (A : Matrix (Fin n) (Fin n) ℝ)
    (X : NumStability.HDP.Optimization.UnitVectorFamily n) : ℝ :=
  (1 / 4 : ℝ) * ∑ i, ∑ j,
    A i j * (2 / Real.pi *
      Real.arccos ⟪(X i : EuclideanSpace ℝ (Fin n)), X j⟫_ℝ)

/-- The explicit `0.878` factor compares the semidefinite value of every
unit-vector family with its arccos rounding value for nonnegative weights. -/
theorem goemansWilliamson_mul_maxCutSemidefiniteValue_le_arccosRoundingValue
    {n : ℕ} (A : Matrix (Fin n) (Fin n) ℝ)
    (hA : ∀ i j, 0 ≤ A i j)
    (X : NumStability.HDP.Optimization.UnitVectorFamily n) :
    (439 / 500 : ℝ) * maxCutSemidefiniteValue A X ≤
      arccosRoundingValue A X := by
  have hterm : ∀ i j,
      (439 / 500 : ℝ) *
          (A i j * (1 - ⟪(X i : EuclideanSpace ℝ (Fin n)), X j⟫_ℝ)) ≤
        A i j * (2 / Real.pi *
          Real.arccos ⟪(X i : EuclideanSpace ℝ (Fin n)), X j⟫_ℝ) := by
    intro i j
    have hXi : ‖(X i : EuclideanSpace ℝ (Fin n))‖ = 1 := by
      simpa [Metric.mem_sphere] using (X i).property
    have hXj : ‖(X j : EuclideanSpace ℝ (Fin n))‖ = 1 := by
      simpa [Metric.mem_sphere] using (X j).property
    have hinter :
        ⟪(X i : EuclideanSpace ℝ (Fin n)), X j⟫_ℝ ∈ Icc (-1 : ℝ) 1 :=
      ⟨neg_one_le_real_inner_of_norm_eq_one hXi hXj,
        real_inner_le_one_of_norm_eq_one hXi hXj⟩
    have hgw := goemansWilliamson_arccos_bound hinter
    calc
      (439 / 500 : ℝ) *
          (A i j * (1 - ⟪(X i : EuclideanSpace ℝ (Fin n)), X j⟫_ℝ)) =
        A i j * ((439 / 500 : ℝ) *
          (1 - ⟪(X i : EuclideanSpace ℝ (Fin n)), X j⟫_ℝ)) := by ring
      _ ≤ A i j * (2 / Real.pi *
          Real.arccos ⟪(X i : EuclideanSpace ℝ (Fin n)), X j⟫_ℝ) :=
        mul_le_mul_of_nonneg_left hgw (hA i j)
  unfold maxCutSemidefiniteValue arccosRoundingValue
  calc
    (439 / 500 : ℝ) *
          ((1 / 4 : ℝ) * ∑ i, ∑ j,
            A i j * (1 - ⟪(X i : EuclideanSpace ℝ (Fin n)), X j⟫_ℝ)) =
        (1 / 4 : ℝ) * ∑ i, ∑ j,
          (439 / 500 : ℝ) *
            (A i j * (1 - ⟪(X i : EuclideanSpace ℝ (Fin n)), X j⟫_ℝ)) := by
      simp only [Finset.mul_sum]
      ring
    _ ≤ (1 / 4 : ℝ) * ∑ i, ∑ j,
          A i j * (2 / Real.pi *
            Real.arccos ⟪(X i : EuclideanSpace ℝ (Fin n)), X j⟫_ℝ) := by
      apply mul_le_mul_of_nonneg_left _ (by norm_num)
      apply Finset.sum_le_sum
      intro i _hi
      apply Finset.sum_le_sum
      intro j _hj
      exact hterm i j

/-- The preceding comparison specialized to an optimal semidefinite family. -/
theorem goemansWilliamson_mul_maxCutSemidefiniteOptimalValue_le_arccosRoundingValue
    {n : ℕ} (A : Matrix (Fin n) (Fin n) ℝ)
    (hA : ∀ i j, 0 ≤ A i j) :
    (439 / 500 : ℝ) * maxCutSemidefiniteOptimalValue A ≤
      arccosRoundingValue A (maxCutSemidefiniteOptimizer A) := by
  exact goemansWilliamson_mul_maxCutSemidefiniteValue_le_arccosRoundingValue
    A hA (maxCutSemidefiniteOptimizer A)

/-- Adjacency matrices have the nonnegative weights required by the numerical
hyperplane-rounding comparison. -/
theorem goemansWilliamson_graph_semidefinite_le_arccosRoundingValue
    {n : ℕ} (G : SimpleGraph (Fin n)) [DecidableRel G.Adj] :
    (439 / 500 : ℝ) *
        maxCutSemidefiniteOptimalValue (G.adjMatrix ℝ) ≤
      arccosRoundingValue (G.adjMatrix ℝ)
        (maxCutSemidefiniteOptimizer (G.adjMatrix ℝ)) := by
  apply goemansWilliamson_mul_maxCutSemidefiniteOptimalValue_le_arccosRoundingValue
  intro i j
  by_cases hij : G.Adj i j <;> simp [hij]

/-- A sign cut has exactly the same value after embedding its labels as unit
vectors in one Euclidean coordinate. -/
theorem maxCutSemidefiniteValue_signUnitVectorFamily
    {n : ℕ} [Nonempty (Fin n)] (G : SimpleGraph (Fin n))
    [DecidableRel G.Adj]
    (x : NumStability.HDP.Optimization.SignVector n) :
    maxCutSemidefiniteValue (G.adjMatrix ℝ)
        (NumStability.HDP.Optimization.signUnitVectorFamily x) =
      signCutValue G x := by
  rw [maxCutSemidefiniteValue_eq,
    NumStability.HDP.Optimization.vectorQuadraticValue_signUnitVectorFamily]
  unfold maxCutSemidefiniteConstant maxCutSemidefiniteMatrix signCutValue
    NumStability.HDP.Optimization.signQuadraticValue
  simp only [Matrix.smul_apply, smul_eq_mul]
  ring_nf
  simp_rw [Finset.sum_sub_distrib]
  simp_rw [← Finset.sum_mul]
  ring

/-- The maximum-cut semidefinite relaxation dominates the true maximum-cut
value. -/
theorem maxCut_le_maxCutSemidefiniteOptimalValue
    {n : ℕ} [Nonempty (Fin n)] (G : SimpleGraph (Fin n))
    [DecidableRel G.Adj] :
    (maxCut G : ℝ) ≤ maxCutSemidefiniteOptimalValue (G.adjMatrix ℝ) := by
  obtain ⟨x, hx⟩ := exists_signCutValue_eq_maxCut G
  calc
    (maxCut G : ℝ) = signCutValue G x := hx.symm
    _ = maxCutSemidefiniteValue (G.adjMatrix ℝ)
        (NumStability.HDP.Optimization.signUnitVectorFamily x) :=
      (maxCutSemidefiniteValue_signUnitVectorFamily G x).symm
    _ ≤ maxCutSemidefiniteOptimalValue (G.adjMatrix ℝ) :=
      maxCutSemidefiniteValue_le_optimalValue _ _

/-- The deterministic portion of the approximation chain in Theorem 3.6.5.
The remaining identification of `arccosRoundingValue` with the Gaussian
rounding expectation is precisely the content supplied by Grothendieck's
identity. -/
theorem goemansWilliamson_deterministic_approximation_chain
    {n : ℕ} [Nonempty (Fin n)] (G : SimpleGraph (Fin n))
    [DecidableRel G.Adj] :
    (439 / 500 : ℝ) * (maxCut G : ℝ) ≤
        (439 / 500 : ℝ) *
          maxCutSemidefiniteOptimalValue (G.adjMatrix ℝ) ∧
      (439 / 500 : ℝ) *
          maxCutSemidefiniteOptimalValue (G.adjMatrix ℝ) ≤
        arccosRoundingValue (G.adjMatrix ℝ)
          (maxCutSemidefiniteOptimizer (G.adjMatrix ℝ)) := by
  constructor
  · exact mul_le_mul_of_nonneg_left
      (maxCut_le_maxCutSemidefiniteOptimalValue G) (by norm_num)
  · exact goemansWilliamson_graph_semidefinite_le_arccosRoundingValue G

end

end NumStability.HDP.Graph
