import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Sampling.IndependentTraceMoments
import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Sampling.ImportanceUnbiasedness

/-!
# Coordinate residual moments for supplied-law entry sampling

The law is the literal iid entry sampler, and coverage of every nonzero input
entry is explicit. The exact variance is finite for each positive probability;
there is no uniform bound as that probability tends to zero, and no claim that
different residual coordinates are independent.
-/

namespace NumStability
open scoped BigOperators

/-- The residual of the literal zero-initialized, supplied-probability sketch. -/
noncomputable def entrySamplingResidual {m n s : ℕ} (A : Fin m → Fin n → ℝ)
    (P : FiniteProbability (Fin m × Fin n)) (ω : ElementwiseTrace m n s)
    (i : Fin m) (j : Fin n) : ℝ :=
  A i j - elementwiseTraceSketchWithProb s A (fun _ _ => 0)
    (fun r c => P.prob (r,c)) ω i j

private noncomputable def entryImportanceObservation {m n : ℕ}
    (A : Fin m → Fin n → ℝ) (P : FiniteProbability (Fin m × Fin n))
    (i : Fin m) (j : Fin n) (x : Fin m × Fin n) : ℝ :=
  if x.1 = i ∧ x.2 = j then A i j / P.prob (i,j) else 0

private theorem entryImportanceObservation_mean {m n : ℕ}
    (A : Fin m → Fin n → ℝ) (P : FiniteProbability (Fin m × Fin n))
    (i : Fin m) (j : Fin n) (hp : 0 < P.prob (i,j)) :
    P.expectationReal (entryImportanceObservation A P i j) = A i j := by
  classical
  simp only [FiniteProbability.expectationReal, entryImportanceObservation,
    Fintype.sum_prod_type, mul_ite, mul_zero, ite_and]
  simp only [Finset.sum_ite_irrel, Finset.sum_ite_eq', Finset.mem_univ, if_true,
    Finset.sum_const_zero]
  field_simp

private theorem entryImportanceObservation_second {m n : ℕ}
    (A : Fin m → Fin n → ℝ) (P : FiniteProbability (Fin m × Fin n))
    (i : Fin m) (j : Fin n) (hp : 0 < P.prob (i,j)) :
    P.expectationReal (fun x => entryImportanceObservation A P i j x ^ 2) =
      A i j ^ 2 / P.prob (i,j) := by
  classical
  simp only [FiniteProbability.expectationReal, entryImportanceObservation, ite_pow,
    zero_pow (by decide : 2 ≠ 0), Fintype.sum_prod_type, mul_ite, mul_zero, ite_and]
  simp only [Finset.sum_ite_irrel, Finset.sum_ite_eq', Finset.mem_univ, if_true,
    Finset.sum_const_zero]
  field_simp

private theorem entryImportanceObservation_variance {m n : ℕ}
    (A : Fin m → Fin n → ℝ) (P : FiniteProbability (Fin m × Fin n))
    (i : Fin m) (j : Fin n) (hp : 0 < P.prob (i,j)) :
    P.varianceReal (entryImportanceObservation A P i j) =
      A i j ^ 2 * (1 / P.prob (i,j) - 1) := by
  rw [FiniteProbability.varianceReal_eq_expectationReal_sq_sub_mean_sq,
    entryImportanceObservation_mean A P i j hp,
    entryImportanceObservation_second A P i j hp]
  ring

private theorem elementwiseSketch_eq_importance_average {m n s : ℕ}
    (A : Fin m → Fin n → ℝ) (P : FiniteProbability (Fin m × Fin n))
    (hs : 0 < (s : ℝ)) (i : Fin m) (j : Fin n) (hp : 0 < P.prob (i,j))
    (ω : ElementwiseTrace m n s) :
    elementwiseTraceSketchWithProb s A (fun _ _ => 0)
      (fun r c => P.prob (r,c)) ω i j =
        (∑ t : Fin s, entryImportanceObservation A P i j (ω t)) / (s : ℝ) := by
  classical
  simp only [elementwiseTraceSketchWithProb, zero_add, Finset.sum_div]
  apply Finset.sum_congr rfl
  intro t _
  unfold elementwiseTraceContributionWithProb sampleHits entryImportanceObservation
    elementwiseIncrementWithProb
  split <;> simp_all
  field_simp

/-- Zero entries have zero residual on every totalized trace. In particular,
covered zero-probability entries are zero almost surely under the actual law. -/
theorem entrySamplingResidual_eq_zero_of_entry_zero {m n s : ℕ}
    (A : Fin m → Fin n → ℝ) (P : FiniteProbability (Fin m × Fin n))
    (i : Fin m) (j : Fin n) (hA : A i j = 0) (ω : ElementwiseTrace m n s) :
    entrySamplingResidual A P ω i j = 0 := by
  simp [entrySamplingResidual, elementwiseTraceSketchWithProb,
    elementwiseTraceContributionWithProb, elementwiseIncrementWithProb, hA]

/-- Covered-support entry residuals have mean zero under the actual iid law. -/
theorem iid_entrySamplingResidual_expectation_eq_zero {m n s : ℕ}
    (A : Fin m → Fin n → ℝ) (P : FiniteProbability (Fin m × Fin n)) (hs : 0 < s)
    (hcover : ∀ i j, P.prob (i,j) = 0 → A i j = 0) (i : Fin m) (j : Fin n) :
    (P.iid s).expectationReal (fun ω => entrySamplingResidual A P ω i j) = 0 := by
  unfold entrySamplingResidual
  rw [FiniteProbability.expectationReal_sub, FiniteProbability.expectationReal_const,
    iid_elementwiseTraceSketchWithProb_expectation_entry A P hs hcover]
  ring

/-- Exact coordinate variance of the residual for a positive sampling atom. -/
theorem iid_entrySamplingResidual_variance_eq {m n s : ℕ}
    (A : Fin m → Fin n → ℝ) (P : FiniteProbability (Fin m × Fin n)) (hs : 0 < s)
    (hcover : ∀ i j, P.prob (i,j) = 0 → A i j = 0)
    (i : Fin m) (j : Fin n) (hp : 0 < P.prob (i,j)) :
    (P.iid s).varianceReal (fun ω => entrySamplingResidual A P ω i j) =
      A i j ^ 2 * (1 / P.prob (i,j) - 1) / (s : ℝ) := by
  have hsR : 0 < (s : ℝ) := by exact_mod_cast hs
  rw [FiniteProbability.varianceReal_eq_expectationReal_sq_of_mean_zero _ _
    (iid_entrySamplingResidual_expectation_eq_zero A P hs hcover i j)]
  have hpoint (ω : ElementwiseTrace m n s) :
      entrySamplingResidual A P ω i j ^ 2 =
      ((∑ t : Fin s, entryImportanceObservation A P i j (ω t)) / (s : ℝ) -
        P.expectationReal (entryImportanceObservation A P i j)) ^ 2 := by
    rw [entryImportanceObservation_mean A P i j hp]
    unfold entrySamplingResidual
    rw [elementwiseSketch_eq_importance_average A P hsR i j hp]
    ring
  simp_rw [hpoint]
  rw [P.iid_expectationReal_sampleAverage_sub_mean_sq hsR,
    entryImportanceObservation_variance A P i j hp]

/-- Covered zero-probability coordinates have zero residual almost surely. -/
theorem iid_entrySamplingResidual_zero_prob_event_eq_one {m n s : ℕ}
    (A : Fin m → Fin n → ℝ) (P : FiniteProbability (Fin m × Fin n))
    (hcover : ∀ i j, P.prob (i,j) = 0 → A i j = 0)
    (i : Fin m) (j : Fin n) (hp : P.prob (i,j) = 0) :
    (P.iid s).eventProb {ω | entrySamplingResidual A P ω i j = 0} = 1 := by
  apply FiniteProbability.eventProb_eq_one_of_forall
  intro ω
  exact entrySamplingResidual_eq_zero_of_entry_zero A P i j (hcover i j hp) ω

/-- Covered zero-probability coordinates have variance zero. -/
theorem iid_entrySamplingResidual_variance_eq_zero_of_prob_zero {m n s : ℕ}
    (A : Fin m → Fin n → ℝ) (P : FiniteProbability (Fin m × Fin n))
    (hcover : ∀ i j, P.prob (i,j) = 0 → A i j = 0)
    (i : Fin m) (j : Fin n) (hp : P.prob (i,j) = 0) :
    (P.iid s).varianceReal (fun ω => entrySamplingResidual A P ω i j) = 0 := by
  simp only [FiniteProbability.varianceReal,
    entrySamplingResidual_eq_zero_of_entry_zero A P i j (hcover i j hp),
    FiniteProbability.expectationReal_const, sub_self, zero_pow (by decide : 2 ≠ 0)]

/-- A sufficient finite coordinate bound on every trace when the selected
coordinate's probability is positive. No dimension-free bound is claimed. -/
theorem entrySamplingResidual_abs_le {m n s : ℕ}
    (A : Fin m → Fin n → ℝ) (P : FiniteProbability (Fin m × Fin n)) (hs : 0 < s)
    (i : Fin m) (j : Fin n) (hp : 0 < P.prob (i,j)) (ω : ElementwiseTrace m n s) :
    |entrySamplingResidual A P ω i j| ≤ |A i j| * (1 + 1 / P.prob (i,j)) := by
  have hsR : 0 < (s : ℝ) := by exact_mod_cast hs
  have hden : 0 < (s : ℝ) * P.prob (i,j) := mul_pos hsR hp
  have hterm (t : Fin s) :
      |elementwiseTraceContributionWithProb s A (fun r c => P.prob (r,c)) ω t i j| ≤
        |A i j| / ((s : ℝ) * P.prob (i,j)) := by
    unfold elementwiseTraceContributionWithProb elementwiseIncrementWithProb
    split
    · simp [abs_div, abs_of_pos hden]
    · simp only [abs_zero]
      exact div_nonneg (abs_nonneg _) hden.le
  have hsketch :
      |elementwiseTraceSketchWithProb s A (fun _ _ => 0) (fun r c => P.prob (r,c)) ω i j| ≤
        |A i j| / P.prob (i,j) := by
    simp only [elementwiseTraceSketchWithProb, zero_add]
    calc
      |∑ t : Fin s, elementwiseTraceContributionWithProb s A (fun r c => P.prob (r,c)) ω t i j|
          ≤ ∑ t : Fin s, |elementwiseTraceContributionWithProb s A
              (fun r c => P.prob (r,c)) ω t i j| := Finset.abs_sum_le_sum_abs _ _
      _ ≤ ∑ _t : Fin s, |A i j| / ((s : ℝ) * P.prob (i,j)) :=
        Finset.sum_le_sum (fun t _ => hterm t)
      _ = |A i j| / P.prob (i,j) := by
        simp only [Finset.sum_const, Finset.card_univ, Fintype.card_fin, nsmul_eq_mul]
        field_simp
  unfold entrySamplingResidual
  calc
    |A i j - elementwiseTraceSketchWithProb s A (fun _ _ => 0)
        (fun r c => P.prob (r,c)) ω i j| ≤
      |A i j| + |elementwiseTraceSketchWithProb s A (fun _ _ => 0)
        (fun r c => P.prob (r,c)) ω i j| := abs_sub _ _
    _ ≤ |A i j| + |A i j| / P.prob (i,j) := add_le_add le_rfl hsketch
    _ = |A i j| * (1 + 1 / P.prob (i,j)) := by ring

end NumStability
