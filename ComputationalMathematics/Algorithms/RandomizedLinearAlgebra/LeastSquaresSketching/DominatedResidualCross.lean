import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.LeastSquaresSketching.UniformResidualCross
import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.LeastSquaresSketching.DominatedResidualCrossMoments
import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Concentration.TraceMGF.DominatedLeverage

/-!
# Least squares under leverage-dominated row sampling

The supplied finite row law is sampled independently with replacement. Lower
Gram concentration and a derived residual cross-moment bound give the objective
estimate for actual exact sketched minimizers under explicit sample budgets.
-/

namespace NumStability
open scoped BigOperators

/-- Common supplied-probability denominators produce the importance-weighted
outer product, including zero-probability rows under Lean's total division. -/
theorem probability_scaled_entry_product {m s : ℕ}
    (P : FiniteProbability (Fin m)) (hs : 0 < (s : ℝ))
    (i : Fin m) (a b : ℝ) :
    a / rowSampleScaleDenWithProb s P.prob i *
      (b / rowSampleScaleDenWithProb s P.prob i) =
        (a * b / P.prob i) / (s : ℝ) := by
  by_cases hp : P.prob i = 0
  · simp [rowSampleScaleDenWithProb, hp]
  · have hpPos : 0 < P.prob i := lt_of_le_of_ne (P.prob_nonneg i) (Ne.symm hp)
    have hd := rowSampleScaleDenWithProb_ne_zero s P.prob i hs hpPos
    have hscale : rowSampleScaleDenWithProb s P.prob i *
        rowSampleScaleDenWithProb s P.prob i = (s : ℝ) * P.prob i :=
      Real.mul_self_sqrt (mul_nonneg hs.le (P.prob_nonneg i))
    field_simp [hd, hs.ne', hp]
    rw [sq, hscale]
    ring

/-- The literal supplied-law sketch has exactly the established uniform Gram. -/
theorem rowSketchGram_dominated_prob_eq {m d s : ℕ}
    (U : Fin m → Fin d → ℝ) (P : FiniteProbability (Fin m)) (hs : 0 < (s : ℝ))
    (samples : RowTrace m s) :
    rowSketchGram (rowSampleSketchWithProb s U P.prob samples) =
      dominatedLeverageSampleGram U P samples := by
  ext j k
  unfold rowSketchGram dominatedLeverageSampleGram dominatedLeverageOuterGram
  rw [Finset.sum_div]
  apply Finset.sum_congr rfl
  intro t _
  exact probability_scaled_entry_product P hs (samples t) _ _

/-- The supplied-law cross estimator is exactly the cross term of the literal sketch. -/
theorem dominated_prob_residual_cross_eq {m d s : ℕ}
    (U : Fin m → Fin d → ℝ) (r : Fin m → ℝ)
    (P : FiniteProbability (Fin m)) (hs : 0 < (s : ℝ)) (samples : RowTrace m s) :
    (fun a => ∑ t : Fin s,
      rowSampleSketchWithProb s U P.prob samples t a *
        rowSampleVectorWithProb P.prob r samples t) =
      dominatedResidualCross U P r samples := by
  ext a
  unfold dominatedResidualCross
  rw [Finset.sum_div]
  apply Finset.sum_congr rfl
  intro t _
  exact probability_scaled_entry_product P hs (samples t) _ _

/-- Supplied-law common row sampling specializes the deterministic LS endgame. -/
theorem lsObjective_le_min_add_dominated_cross
    {m n d s : ℕ} (A : Fin m → Fin n → ℝ) (b : Fin m → ℝ)
    (U : Fin m → Fin d → ℝ) (hU : HasOrthonormalColumns U)
    (C : Fin n → Fin d → ℝ)
    (hA : ∀ i j, A i j = ∑ a : Fin d, U i a * C j a)
    (P : FiniteProbability (Fin m)) (hs : 0 < (s : ℝ)) (samples : RowTrace m s)
    (xHat xOpt : Fin n → ℝ) (hopt : IsLeastSquaresMinimizer A b xOpt)
    (hhat : IsLeastSquaresMinimizer
      (rowSampleSketchWithProb s A P.prob samples)
      (rowSampleVectorWithProb P.prob b samples) xHat)
    (hGram : finiteLoewnerLe
      (fun j k : Fin d => -(dominatedLeverageSampleGram U P samples j k - finiteIdMatrix j k))
      (fun j k : Fin d => (1 / 2 : ℝ) * finiteIdMatrix j k)) :
    lsObjective A b xHat ≤ lsObjective A b xOpt +
      4 * vecNorm2Sq (dominatedResidualCross U P (lsResidual A b xOpt) samples) := by
  let SA := rowSampleSketchWithProb s A P.prob samples
  let Sb := rowSampleVectorWithProb P.prob b samples
  let V := rowSampleSketchWithProb s U P.prob samples
  let w := rowSampleVectorWithProb P.prob (lsResidual A b xOpt) samples
  have hSA : ∀ t j, SA t j = ∑ a : Fin d, V t a * C j a := by
    intro t j
    dsimp [SA, V, rowSampleSketchWithProb, rowSampleIncrementWithProb]
    rw [hA, Finset.sum_div]
    apply Finset.sum_congr rfl
    intro a _
    ring
  have hw : ∀ t, lsResidual SA Sb xOpt t = w t := by
    intro t
    dsimp [lsResidual, rectMatMulVec, SA, Sb, w, rowSampleVectorWithProb,
      rowSampleSketchWithProb, rowSampleIncrementWithProb]
    rw [sub_div, Finset.sum_div]
    congr 1
    apply Finset.sum_congr rfl
    intro j _
    ring
  have hlower : ∀ z : Fin d → ℝ,
      (1 / 2 : ℝ) * vecNorm2Sq z ≤ vecNorm2Sq (rectMatMulVec V z) := by
    intro z
    have hg := hGram z
    rw [finiteQuadraticForm_smul_finiteIdMatrix, finiteQuadraticForm_neg,
      finiteQuadraticForm_sub, finiteQuadraticForm_finiteIdMatrix] at hg
    have hquad := vecNorm2Sq_rowSketch_linearCombination_eq_quadratic_rowSketchGram V z
    change vecNorm2Sq (rectMatMulVec V z) = _ at hquad
    rw [show rowSketchGram V = dominatedLeverageSampleGram U P samples from
      rowSketchGram_dominated_prob_eq U P hs samples] at hquad
    change vecNorm2Sq (rectMatMulVec V z) = finiteQuadraticForm (dominatedLeverageSampleGram U P samples) z at hquad
    rw [hquad]
    rw [finiteVecNorm2Sq_fin] at hg
    linarith
  have hdet := lsObjective_le_min_add_cross_of_factored_sketch A b U hU C hA
    SA Sb V w hSA xHat xOpt hopt hhat hw hlower
  rw [show (fun a => ∑ t : Fin s, V t a * w t) =
    dominatedResidualCross U P (lsResidual A b xOpt) samples from
    dominated_prob_residual_cross_eq U (lsResidual A b xOpt) P hs samples] at hdet
  exact hdet

/-- Importance sampled least squares for any supplied law dominating leverage.
The accuracy term is reciprocal, with no assumption of the final cross estimate. -/
theorem dominatedLeverageTraceProbability_eventProb_lsObjective_le_one_add_eta
    {m n d s : ℕ} (A : Fin m → Fin n → ℝ) (b : Fin m → ℝ)
    (U : Fin m → Fin d → ℝ) (hU : HasOrthonormalColumns U)
    (C : Fin n → Fin d → ℝ) (Q : Fin d → Fin n → ℝ)
    (hA : ∀ i j, A i j = ∑ a : Fin d, U i a * C j a)
    (hQ : ∀ i a, U i a = rectMatMulVec A (Q a) i)
    (P : FiniteProbability (Fin m)) (hd : 0 < d) (hs : 0 < (s : ℝ))
    (xHat : RowTrace m s → Fin n → ℝ) (xOpt : Fin n → ℝ)
    (hopt : IsLeastSquaresMinimizer A b xOpt)
    (hhat : ∀ samples, IsLeastSquaresMinimizer
      (rowSampleSketchWithProb s A P.prob samples)
      (rowSampleVectorWithProb P.prob b samples) (xHat samples))
    {β η δ : ℝ} (hβ : 0 < β) (hβone : β ≤ 1) (hη : 0 < η) (hδ : 0 < δ) (hδone : δ < 1)
    (hdom : ∀ i, β * rowNormSq U i / (d : ℝ) ≤ P.prob i)
    (hbudgetEmbedding : 10 * ((d : ℝ) / β) * Real.log ((2 * (d : ℝ)) / δ) ≤ (s : ℝ))
    (hbudgetCross : 8 * ((d : ℝ) / β) / (η * δ) ≤ (s : ℝ)) :
    1 - δ ≤ (P.iid s).eventProb
      {samples | lsObjective A b (xHat samples) ≤ (1 + η) * lsObjective A b xOpt} := by
  classical
  let R := P.iid s
  let EGram : Set (RowTrace m s) := {samples | finiteLoewnerLe
    (fun j k : Fin d => -(dominatedLeverageSampleGram U P samples j k - finiteIdMatrix j k))
    (fun j k : Fin d => (1 / 2 : ℝ) * finiteIdMatrix j k)}
  let ECross : Set (RowTrace m s) := {samples |
    vecNorm2Sq (dominatedResidualCross U P (lsResidual A b xOpt) samples) ≤
      η / 4 * lsObjective A b xOpt}
  have hGram : 1 - δ / 2 ≤ R.eventProb EGram :=
    dominatedLeverageSampleGram_lower_half_eventProb_ge U hU P hd hβ hβone hs
      hdom hδ hδone hbudgetEmbedding
  have hCross : 1 - 4 * ((d : ℝ) / β) / ((s : ℝ) * η) ≤ R.eventProb ECross := by
    exact dominatedResidualCross_eventProb_ge_one_sub U P (lsResidual A b xOpt)
      hs (dominatedLeverage_cap U P hd hβ hdom)
      (lsResidual_orthogonal_of_basis_columns_in_range A b U Q hQ xOpt hopt) η hη
  have hinter := R.eventProb_inter_ge_one_sub_add EGram ECross (δ / 2)
    (4 * ((d : ℝ) / β) / ((s : ℝ) * η)) hGram hCross
  have hfail : δ / 2 + 4 * ((d : ℝ) / β) / ((s : ℝ) * η) ≤ δ := by
    have hb := (div_le_iff₀ (mul_pos hη hδ)).mp hbudgetCross
    have hc : 4 * ((d : ℝ) / β) / ((s : ℝ) * η) ≤ δ / 2 := by
      apply (div_le_iff₀ (mul_pos hs hη)).mpr
      nlinarith
    linarith
  have hsub : EGram ∩ ECross ⊆
      {samples | lsObjective A b (xHat samples) ≤ (1 + η) * lsObjective A b xOpt} := by
    intro samples hgood
    have hdeter := lsObjective_le_min_add_dominated_cross A b U hU C hA
      P hs samples (xHat samples) xOpt hopt (hhat samples) hgood.1
    have hc := hgood.2
    change vecNorm2Sq (dominatedResidualCross U P (lsResidual A b xOpt) samples) ≤
      η / 4 * lsObjective A b xOpt at hc
    change lsObjective A b (xHat samples) ≤ (1 + η) * lsObjective A b xOpt
    nlinarith
  exact (sub_le_sub_left hfail 1).trans (hinter.trans (R.eventProb_mono hsub))


end NumStability
