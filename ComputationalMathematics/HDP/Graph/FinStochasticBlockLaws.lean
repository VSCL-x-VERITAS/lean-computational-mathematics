import ComputationalMathematics.HDP.Graph.FinStochasticBlock

/-!
# Finite configuration laws for the loopless stochastic-block measure

These laws apply to the existing product measure on all upper coordinates,
including deterministic diagonal coordinates, for every dimension and community
map. They require only the admissible probabilities in `Parameters`.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators NNReal ENNReal

namespace NumStability.HDP.Graph.FinStochasticBlock

/-- The existing stochastic-block measure has total mass one, also in dimension
zero. -/
theorem measure_univ_eq_one {n : ℕ} (community : Fin n → Fin 2)
    (θ : StochasticBlock.Parameters) : measure community θ Set.univ = 1 :=
  measure_univ

/-- Exact probability of every finite Boolean upper-coordinate configuration.
The empty configuration has mass one; a true diagonal coordinate has mass zero.
-/
theorem measure_finite_configuration {n : ℕ} (community : Fin n → Fin 2)
    (θ : StochasticBlock.Parameters) (S : Finset (UpperPair n))
    (v : UpperPair n → Bool) :
    measure community θ {x | ∀ e ∈ S, x e = v e} =
      ∏ e ∈ S, if v e then (upperProbability community θ e : ℝ≥0∞)
        else ((1 - upperProbability community θ e : ℝ≥0) : ℝ≥0∞) := by
  classical
  have hset : {x : UpperPair n → Bool | ∀ e ∈ S, x e = v e} =
      Set.pi Set.univ (fun e ↦ if e ∈ S then {v e} else Set.univ) := by
    ext x
    constructor
    · intro hx e _
      by_cases he : e ∈ S
      · simpa only [if_pos he, Set.mem_singleton_iff] using hx e he
      · simp only [if_neg he, Set.mem_univ]
    · intro hx e he
      have h := hx e (Set.mem_univ e)
      simpa only [if_pos he, Set.mem_singleton_iff] using h
  have hmass (e : UpperPair n) :
      (PMF.bernoulli (upperProbability community θ e)
        (upperProbability_le_one community θ e)).toMeasure {v e} =
        if v e then (upperProbability community θ e : ℝ≥0∞)
          else ((1 - upperProbability community θ e : ℝ≥0) : ℝ≥0∞) := by
    rw [PMF.toMeasure_apply_singleton _ _ (measurableSet_singleton _)]
    cases v e <;> simp [PMF.bernoulli_apply]
  unfold measure
  rw [hset, Measure.pi_pi]
  simpa only [apply_ite, hmass, measure_univ] using
    (Finset.prod_ite_mem_eq S fun e ↦
      if v e then (upperProbability community θ e : ℝ≥0∞)
        else ((1 - upperProbability community θ e : ℝ≥0) : ℝ≥0∞))

/-- A true diagonal coordinate is a null event under the existing law. -/
theorem measure_true_diagonal_eq_zero {n : ℕ} (community : Fin n → Fin 2)
    (θ : StochasticBlock.Parameters) (i : Fin n) :
    measure community θ {x | x ⟨(i, i), le_rfl⟩ = true} = 0 := by
  classical
  have h := measure_finite_configuration community θ
    {⟨(i, i), le_rfl⟩} (fun _ ↦ true)
  simpa [upperProbability] using h

end NumStability.HDP.Graph.FinStochasticBlock
