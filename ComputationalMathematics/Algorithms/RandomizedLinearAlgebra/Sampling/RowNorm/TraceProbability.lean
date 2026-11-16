import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Sampling.RowNorm.Core
import ComputationalMathematics.Analysis.FiniteProbability

/-!
# Independent norm-squared row-trace probability

The reusable product sampler, its normalization, support and expectation laws.
The extracted declarations retain their historical names and proofs.
-/

namespace NumStability
open scoped BigOperators

/-- Norm-squared row probabilities sum to one for a nonzero matrix. -/
theorem rowSqNormProb_sum_eq_one {m n : ℕ}
    (A : Fin m → Fin n → ℝ) (hden : rowSqNormProbDen A ≠ 0) :
    ∑ i : Fin m, rowSqNormProb A i = 1 := by
  unfold rowSqNormProb rowSqNormProbDen
  simp_rw [div_eq_mul_inv]
  rw [← Finset.sum_mul]
  change frobNormSqRect A * (frobNormSqRect A)⁻¹ = 1
  exact mul_inv_cancel₀ hden

-- ============================================================
-- Exact and floating-point row-sampling updates
-- ============================================================

namespace ComputedRowScaleDen

variable {fp : FPModel} {m : ℕ} {s : ℕ} {p : Fin m → ℝ}

end ComputedRowScaleDen

-- ============================================================
-- Random row traces for the literal Algorithm 2 sampler
-- ============================================================

theorem rowSqNormTraceProbMass_sum_eq_one {m n steps : ℕ}
    (A : Fin m → Fin n → ℝ) (hden : rowSqNormProbDen A ≠ 0) :
    (∑ samples : RowTrace m steps,
      rowSqNormTraceProbMass A samples) = 1 := by
  classical
  have hprod :=
    Finset.prod_univ_sum
      (t := fun _ : Fin steps => (Finset.univ : Finset (RowSample m)))
      (f := fun _ x => rowSqNormProb A x)
  have hleft :
      (∏ _ : Fin steps,
        ∑ x ∈ (Finset.univ : Finset (RowSample m)),
          rowSqNormProb A x) = 1 := by
    simp [rowSqNormProb_sum_eq_one A hden]
  have hright :
      (∑ x ∈ Fintype.piFinset
        (fun _ : Fin steps => (Finset.univ : Finset (RowSample m))),
        ∏ i, rowSqNormProb A (x i))
        = ∑ samples : RowTrace m steps,
          rowSqNormTraceProbMass A samples := by
    simp [rowSqNormTraceProbMass, RowTrace]
  rw [← hright, ← hprod]
  exact hleft

/-- The canonical finite probability space for Algorithm 2 row traces with
    independent norm-squared row samples at every step. -/
noncomputable def rowSqNormTraceProbability {m n steps : ℕ}
    (A : Fin m → Fin n → ℝ) (hden : 0 < rowSqNormProbDen A) :
    FiniteProbability (RowTrace m steps) where
  prob := rowSqNormTraceProbMass A
  prob_nonneg := rowSqNormTraceProbMass_nonneg A hden
  prob_sum := rowSqNormTraceProbMass_sum_eq_one A hden.ne'

/-- The independent Algorithm 2 row sampler assigns probability one to traces
    whose sampled rows all have positive row-sampling probability. -/
theorem rowSqNormTraceProbability_eventProb_rowTracePositiveProb
    {m n steps : ℕ} (A : Fin m → Fin n → ℝ)
    (hden : 0 < rowSqNormProbDen A) :
    (rowSqNormTraceProbability (steps := steps) A hden).eventProb
      {samples | rowTracePositiveProb A samples} = 1 := by
  classical
  let P := rowSqNormTraceProbability (steps := steps) A hden
  let Good : Set (RowTrace m steps) := {samples | rowTracePositiveProb A samples}
  have hcompl_zero : P.eventProb Goodᶜ = 0 := by
    unfold FiniteProbability.eventProb
    apply Finset.sum_eq_zero
    intro samples _
    by_cases hbad : samples ∈ Goodᶜ
    · have hnot_good : samples ∉ Good := by simpa using hbad
      have hexists : ∃ t : Fin steps, rowSqNormProb A (samples t) = 0 := by
        by_contra hno
        have hgood : samples ∈ Good := by
          intro t
          have hne : rowSqNormProb A (samples t) ≠ 0 := by
            intro hzero
            exact hno ⟨t, hzero⟩
          exact lt_of_le_of_ne
            (rowSqNormProb_nonneg A hden (samples t)) (Ne.symm hne)
        exact hnot_good hgood
      have hmass :=
        rowSqNormTraceProbMass_eq_zero_of_exists_prob_zero A samples hexists
      simp [P, Good, rowSqNormTraceProbability, hbad, hmass]
    · simp [hbad]
  have hsplit := P.eventProb_add_eventProb_compl Good
  rw [hcompl_zero] at hsplit
  linarith

/-- Under the independent product row-trace law, a function of one sampled row
    has expectation equal to its one-step row expectation. -/
theorem rowSqNormTraceProbMass_marginal_one {m n steps : ℕ}
    (A : Fin m → Fin n → ℝ) (hden : rowSqNormProbDen A ≠ 0)
    (t0 : Fin steps) (f : Fin m → ℝ) :
    (∑ samples : RowTrace m steps,
      rowSqNormTraceProbMass A samples * f (samples t0)) =
      ∑ i : Fin m, rowSqNormProb A i * f i := by
  classical
  have hprod :=
    Finset.prod_univ_sum
      (t := fun _ : Fin steps => (Finset.univ : Finset (RowSample m)))
      (f := fun t x =>
        if t = t0 then rowSqNormProb A x * f x else rowSqNormProb A x)
  have hleft :
      (∏ t : Fin steps,
        ∑ x ∈ (Finset.univ : Finset (RowSample m)),
          (if t = t0 then rowSqNormProb A x * f x else rowSqNormProb A x)) =
        ∑ i : Fin m, rowSqNormProb A i * f i := by
    simp [rowSqNormProb_sum_eq_one A hden]
  have hright :
      (∑ x ∈ Fintype.piFinset
        (fun _ : Fin steps => (Finset.univ : Finset (RowSample m))),
        ∏ i, (if i = t0 then rowSqNormProb A (x i) * f (x i)
          else rowSqNormProb A (x i)))
        = ∑ samples : RowTrace m steps,
          rowSqNormTraceProbMass A samples * f (samples t0) := by
    simp [rowSqNormTraceProbMass, RowTrace]
    apply Finset.sum_congr rfl
    intro x _
    have h1 := Finset.prod_eq_mul_prod_diff_singleton
      (s := (Finset.univ : Finset (Fin steps))) t0
      (fun i : Fin steps =>
        if i = t0 then rowSqNormProb A (x i) * f (x i)
        else rowSqNormProb A (x i))
      (by intro h; simp at h)
    have h2 := Finset.prod_eq_mul_prod_diff_singleton
      (s := (Finset.univ : Finset (Fin steps))) t0
      (fun i : Fin steps => rowSqNormProb A (x i))
      (by intro h; simp at h)
    simp at h1 h2
    rw [h1, h2]
    have herase :
        (∏ x_1 ∈ Finset.univ \ {t0},
          (if x_1 = t0 then rowSqNormProb A (x x_1) * f (x x_1)
          else rowSqNormProb A (x x_1))) =
        ∏ x_1 ∈ Finset.univ \ {t0}, rowSqNormProb A (x x_1) := by
      apply Finset.prod_congr rfl
      intro i hi
      have hi_ne : i ≠ t0 := by
        simp at hi
        exact hi
      simp [hi_ne]
    rw [herase]
    ring
  rw [← hright, ← hprod]
  exact hleft

-- ============================================================
-- Unbiasedness of the sampled Gram matrix
-- ============================================================

end NumStability
