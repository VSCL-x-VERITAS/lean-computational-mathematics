import ComputationalMathematics.HDP.Graph.StochasticBlock
import Mathlib.MeasureTheory.Integral.Pi
import Mathlib.Probability.ProbabilityMassFunction.Integrals

/-!
# Vershynin Chapter 4, stochastic-block expected adjacency decomposition
-/

namespace NumStability.HDP.Contract

open MeasureTheory

private abbrev SBMVertex (k : ℕ) :=
  NumStability.HDP.Graph.StochasticBlock.Vertex k

private abbrev SBMEdge (k : ℕ) :=
  NumStability.HDP.Graph.StochasticBlock.Edge k

/-- The canonical unordered edge associated to two distinct vertices. -/
private def sbmEdgeOfNe {k : ℕ} (i j : SBMVertex k) (hij : i ≠ j) : SBMEdge k :=
  if h : toLex i < toLex j then
    ⟨(i, j), h⟩
  else
    ⟨(j, i), by
      have hle : toLex j ≤ toLex i := le_of_not_gt h
      have hne : toLex j ≠ toLex i := by
        intro hEq
        apply hij
        exact toLex.injective hEq.symm
      exact lt_of_le_of_ne hle hne⟩

private theorem sbmEdgeOfNe_sameCommunity {k : ℕ}
    (i j : SBMVertex k) (hij : i ≠ j) :
    (sbmEdgeOfNe i j hij).1.1.1 = (sbmEdgeOfNe i j hij).1.2.1 ↔
      i.1 = j.1 := by
  simp only [sbmEdgeOfNe]
  split <;> simp [eq_comm]

private theorem sbmEdgeOfNe_swap {k : ℕ}
    (i j : SBMVertex k) (hij : i ≠ j) (hji : j ≠ i) :
    sbmEdgeOfNe i j hij = sbmEdgeOfNe j i hji := by
  apply Subtype.ext
  simp only [sbmEdgeOfNe]
  by_cases hlt : toLex i < toLex j
  · have hnlt : ¬ toLex j < toLex i := not_lt_of_ge hlt.le
    simp [hlt, hnlt]
  · have hne : toLex j ≠ toLex i := by
      intro hEq
      apply hij
      exact toLex.injective hEq.symm
    have hgt : toLex j < toLex i := lt_of_le_of_ne (le_of_not_gt hlt) hne
    simp [hlt, hgt]

/-- The loopless random adjacency matrix imported by Section 4.5.2 from
Definition 3.6.2. Off-diagonal entries are the sampled Bernoulli edge
indicators and every diagonal entry is zero. -/
def stochasticBlockAdjacency {k : ℕ}
    (ω : SBMEdge k → Bool) : Matrix (SBMVertex k) (SBMVertex k) ℝ :=
  fun i j ↦ if hij : i = j then 0 else
    cond (ω (sbmEdgeOfNe i j hij)) 1 0

/-- The actual entrywise expectation of the loopless stochastic-block
adjacency matrix. It differs on the diagonal from the `p`-filled matrix printed
in Section 4.5.2. -/
def looplessExpectedAdjacency (k : ℕ) (p q : ℝ) :
    Matrix (SBMVertex k) (SBMVertex k) ℝ :=
  fun i j ↦ if i = j then 0 else if i.1 = j.1 then p else q

/-- Residual from the actual loopless expectation. -/
def looplessResidual {k : ℕ} (A : Matrix (SBMVertex k) (SBMVertex k) ℝ)
    (p q : ℝ) : Matrix (SBMVertex k) (SBMVertex k) ℝ :=
  A - looplessExpectedAdjacency k p q

private theorem stochasticBlockAdjacency_symmetric {k : ℕ}
    (ω : SBMEdge k → Bool) (i j : SBMVertex k) :
    stochasticBlockAdjacency ω i j = stochasticBlockAdjacency ω j i := by
  by_cases hij : i = j
  · subst j
    rfl
  · have hji : j ≠ i := Ne.symm hij
    simp only [stochasticBlockAdjacency, hij, hji, dite_false]
    rw [sbmEdgeOfNe_swap i j hij hji]

private theorem stochasticBlockEdgeExpectation {k : ℕ}
    (θ : NumStability.HDP.Graph.StochasticBlock.Parameters) (e : SBMEdge k) :
    ∫ ω, cond (ω e) (1 : ℝ) 0
        ∂NumStability.HDP.Graph.StochasticBlock.graphMeasure k θ =
      (NumStability.HDP.Graph.StochasticBlock.edgeProbability θ e).toReal := by
  unfold NumStability.HDP.Graph.StochasticBlock.graphMeasure
  calc
    ∫ ω, cond (ω e) (1 : ℝ) 0 ∂Measure.pi (fun e : SBMEdge k ↦
        (PMF.bernoulli
          (NumStability.HDP.Graph.StochasticBlock.edgeProbability θ e)
          (NumStability.HDP.Graph.StochasticBlock.edgeProbability_le_one θ e)).toMeasure) =
      ∫ b, cond b (1 : ℝ) 0 ∂(PMF.bernoulli
        (NumStability.HDP.Graph.StochasticBlock.edgeProbability θ e)
        (NumStability.HDP.Graph.StochasticBlock.edgeProbability_le_one θ e)).toMeasure :=
          integral_comp_eval
            (μ := fun e : SBMEdge k ↦
              (PMF.bernoulli
                (NumStability.HDP.Graph.StochasticBlock.edgeProbability θ e)
                (NumStability.HDP.Graph.StochasticBlock.edgeProbability_le_one θ e)).toMeasure)
            (i := e) (f := fun b : Bool ↦ cond b (1 : ℝ) 0)
            (measurable_of_finite _).aestronglyMeasurable
    _ = (NumStability.HDP.Graph.StochasticBlock.edgeProbability θ e).toReal :=
      PMF.bernoulli_expectation
        (NumStability.HDP.Graph.StochasticBlock.edgeProbability_le_one θ e)

private theorem stochasticBlockAdjacency_expectation {k : ℕ}
    (θ : NumStability.HDP.Graph.StochasticBlock.Parameters) (i j : SBMVertex k) :
    ∫ ω, stochasticBlockAdjacency ω i j
        ∂NumStability.HDP.Graph.StochasticBlock.graphMeasure k θ =
      looplessExpectedAdjacency k θ.p θ.q i j := by
  by_cases hij : i = j
  · subst j
    simp [stochasticBlockAdjacency, looplessExpectedAdjacency,
      NumStability.HDP.Graph.StochasticBlock.graphMeasure]
  · rw [show (∫ ω, stochasticBlockAdjacency ω i j
          ∂NumStability.HDP.Graph.StochasticBlock.graphMeasure k θ) =
        ∫ ω, cond (ω (sbmEdgeOfNe i j hij)) (1 : ℝ) 0
          ∂NumStability.HDP.Graph.StochasticBlock.graphMeasure k θ by
        simp [stochasticBlockAdjacency, hij]]
    rw [stochasticBlockEdgeExpectation]
    by_cases hcomm : i.1 = j.1 <;>
      simp [NumStability.HDP.Graph.StochasticBlock.edgeProbability,
        sbmEdgeOfNe_sameCommunity, looplessExpectedAdjacency, hij, hcomm]

/-- Source-discrepancy witness for Vershynin, Section 4.5.2. Definition 3.6.2
and its following discussion make the adjacency matrix loopless, so its true
expectation has zero diagonal. The displayed Chapter 4 matrix instead has
diagonal `p`. In the section's regime `p > q ≥ 0`, these matrices are unequal.
The exact signal-plus-residual decomposition remains valid for the true
loopless expectation. -/
theorem hdp_04_expected_adjacency_decomposition {k : ℕ} (hk : 0 < k)
    (θ : NumStability.HDP.Graph.StochasticBlock.Parameters) (hpq : θ.q < θ.p) :
    (∀ i j,
      looplessExpectedAdjacency k θ.p θ.q i j =
        if i = j then 0 else if i.1 = j.1 then (θ.p : ℝ) else θ.q) ∧
      (∀ i j,
        ∫ ω, stochasticBlockAdjacency ω i j
            ∂NumStability.HDP.Graph.StochasticBlock.graphMeasure k θ =
          looplessExpectedAdjacency k θ.p θ.q i j) ∧
      (∀ (ω : SBMEdge k → Bool) (i j : SBMVertex k),
        stochasticBlockAdjacency ω i j =
        stochasticBlockAdjacency ω j i) ∧
      (∀ i,
        looplessExpectedAdjacency k θ.p θ.q i i = 0 ∧
          NumStability.HDP.Graph.StochasticBlock.expectedAdjacency
            k θ.p θ.q i i = θ.p) ∧
      (∀ i,
        looplessExpectedAdjacency k θ.p θ.q i i ≠
          NumStability.HDP.Graph.StochasticBlock.expectedAdjacency
            k θ.p θ.q i i) ∧
      (∀ ω : SBMEdge k → Bool,
        looplessExpectedAdjacency k θ.p θ.q +
          looplessResidual
            (stochasticBlockAdjacency ω) θ.p θ.q =
        stochasticBlockAdjacency ω) := by
  have _ := hk
  have hpNN : 0 < θ.p := lt_of_le_of_lt (zero_le θ.q) hpq
  have hpR : (0 : ℝ) < (θ.p : ℝ) := by exact_mod_cast hpNN
  exact ⟨fun _ _ ↦ rfl, stochasticBlockAdjacency_expectation θ,
    stochasticBlockAdjacency_symmetric, fun i ↦ by
      simp [looplessExpectedAdjacency,
        NumStability.HDP.Graph.StochasticBlock.expectedAdjacency],
    fun i ↦ by
      simp [looplessExpectedAdjacency,
        NumStability.HDP.Graph.StochasticBlock.expectedAdjacency, hpR.ne],
    fun ω ↦ by
      ext i j
      simp [looplessResidual]⟩

end NumStability.HDP.Contract
