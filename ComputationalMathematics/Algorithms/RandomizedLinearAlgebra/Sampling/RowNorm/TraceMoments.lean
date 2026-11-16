import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Sampling.RowNorm.TraceProbability

/-!
# Independent norm-squared row-trace moments

Product-law marginals and centered second moments for the reusable row-trace
sampler. The extracted declarations retain their historical names and proofs.
-/

namespace NumStability
open scoped BigOperators

/-- Product-law pointwise factorization for two distinct trace coordinates. -/
private theorem rowSqNormTraceProbMass_two_point_factor
    {m n steps : ℕ} (A : Fin m → Fin n → ℝ)
    (t u : Fin steps) (htu : t ≠ u) (f g : Fin m → ℝ)
    (x : RowTrace m steps) :
    (∏ r : Fin steps,
      if r = t then rowSqNormProb A (x r) * f (x r)
      else if r = u then rowSqNormProb A (x r) * g (x r)
      else rowSqNormProb A (x r)) =
    (∏ r : Fin steps, rowSqNormProb A (x r)) * f (x t) * g (x u) := by
  classical
  have hfactor : ∀ r : Fin steps,
      (if r = t then rowSqNormProb A (x r) * f (x r)
      else if r = u then rowSqNormProb A (x r) * g (x r)
      else rowSqNormProb A (x r)) =
      rowSqNormProb A (x r) *
        (if r = t then f (x r) else if r = u then g (x r) else 1) := by
    intro r
    by_cases hrt : r = t
    · simp [hrt]
    · by_cases hru : r = u
      · simp [hru]
      · simp [hru]
  simp_rw [hfactor]
  rw [Finset.prod_mul_distrib]
  have hprod_t := Finset.prod_eq_mul_prod_diff_singleton
    (s := (Finset.univ : Finset (Fin steps))) t
    (fun r : Fin steps =>
      if r = t then f (x r) else if r = u then g (x r) else 1)
    (by intro h; simp at h)
  simp at hprod_t
  have hfac :
      (∏ x_1 : Fin steps,
        if x_1 = t then f (x x_1) else if x_1 = u then g (x x_1) else 1)
      = f (x t) * g (x u) := by
    rw [hprod_t]
    have herase :
        (∏ x_1 ∈ Finset.univ \ {t},
          if x_1 = t then f (x x_1) else if x_1 = u then g (x x_1)
          else 1) = g (x u) := by
      have hprod_u := Finset.prod_eq_mul_prod_diff_singleton
        (s := ((Finset.univ : Finset (Fin steps)).erase t)) u
        (fun r : Fin steps =>
          if r = t then f (x r) else if r = u then g (x r) else 1)
        (by
          intro hu_notin
          have : u ∈ (Finset.univ : Finset (Fin steps)).erase t := by
            simp [htu.symm]
          exact False.elim (hu_notin this))
      simp [htu.symm] at hprod_u
      rw [Finset.sdiff_singleton_eq_erase]
      rw [hprod_u]
      have hrest :
          (∏ x_1 ∈ (Finset.univ : Finset (Fin steps)).erase t \ {u},
            if x_1 = t then f (x x_1) else if x_1 = u then g (x x_1)
            else 1) = 1 := by
        apply Finset.prod_eq_one
        intro r hr
        have hrt : r ≠ t := by
          simp at hr
          exact hr.1
        have hru : r ≠ u := by
          simp at hr
          exact hr.2
        simp [hrt, hru]
      rw [hrest]
      ring
    rw [herase]
  rw [hfac]
  ring

/-- Two distinct coordinates of the independent trace have product
    expectation equal to the product of their one-step expectations. -/
theorem rowSqNormTraceProbMass_marginal_two_ne {m n steps : ℕ}
    (A : Fin m → Fin n → ℝ) (hden : rowSqNormProbDen A ≠ 0)
    (t u : Fin steps) (htu : t ≠ u) (f g : Fin m → ℝ) :
    (∑ samples : RowTrace m steps,
      rowSqNormTraceProbMass A samples *
        (f (samples t) * g (samples u))) =
      (∑ i : Fin m, rowSqNormProb A i * f i) *
      (∑ i : Fin m, rowSqNormProb A i * g i) := by
  classical
  have hprod :=
    Finset.prod_univ_sum
      (t := fun _ : Fin steps => (Finset.univ : Finset (RowSample m)))
      (f := fun r x =>
        if r = t then rowSqNormProb A x * f x
        else if r = u then rowSqNormProb A x * g x
        else rowSqNormProb A x)
  have hleft :
      (∏ r : Fin steps,
        ∑ x ∈ (Finset.univ : Finset (RowSample m)),
          (if r = t then rowSqNormProb A x * f x
          else if r = u then rowSqNormProb A x * g x
          else rowSqNormProb A x)) =
      (∑ i : Fin m, rowSqNormProb A i * f i) *
      (∑ i : Fin m, rowSqNormProb A i * g i) := by
    simp [rowSqNormProb_sum_eq_one A hden]
    have hprod_t := Finset.prod_eq_mul_prod_diff_singleton
      (s := (Finset.univ : Finset (Fin steps))) t
      (fun r : Fin steps =>
        if r = t then ∑ x : RowSample m, rowSqNormProb A x * f x
        else if r = u then ∑ x : RowSample m, rowSqNormProb A x * g x
        else 1)
      (by intro h; simp at h)
    simp at hprod_t
    rw [hprod_t]
    have herase :
        (∏ x_1 ∈ Finset.univ \ {t},
          if x_1 = t then ∑ x : RowSample m, rowSqNormProb A x * f x
          else if x_1 = u then ∑ x : RowSample m, rowSqNormProb A x * g x
          else 1) = ∑ x : RowSample m, rowSqNormProb A x * g x := by
      rw [Finset.sdiff_singleton_eq_erase]
      have hprod_u := Finset.prod_eq_mul_prod_diff_singleton
        (s := ((Finset.univ : Finset (Fin steps)).erase t)) u
        (fun r : Fin steps =>
          if r = t then ∑ x : RowSample m, rowSqNormProb A x * f x
          else if r = u then ∑ x : RowSample m, rowSqNormProb A x * g x
          else 1)
        (by
          intro hu_notin
          have : u ∈ (Finset.univ : Finset (Fin steps)).erase t := by
            simp [htu.symm]
          exact False.elim (hu_notin this))
      simp [htu.symm] at hprod_u
      rw [hprod_u]
      have hrest :
          (∏ x_1 ∈ (Finset.univ : Finset (Fin steps)).erase t \ {u},
            if x_1 = t then ∑ x : RowSample m, rowSqNormProb A x * f x
            else if x_1 = u then ∑ x : RowSample m, rowSqNormProb A x * g x
            else 1) = 1 := by
        apply Finset.prod_eq_one
        intro r hr
        have hrt : r ≠ t := by
          simp at hr
          exact hr.1
        have hru : r ≠ u := by
          simp at hr
          exact hr.2
        simp [hrt, hru]
      rw [hrest]
      ring
    rw [herase]
  have hright :
      (∑ x ∈ Fintype.piFinset
        (fun _ : Fin steps => (Finset.univ : Finset (RowSample m))),
        ∏ r, (if r = t then rowSqNormProb A (x r) * f (x r)
          else if r = u then rowSqNormProb A (x r) * g (x r)
          else rowSqNormProb A (x r)))
        = ∑ samples : RowTrace m steps,
          rowSqNormTraceProbMass A samples *
            (f (samples t) * g (samples u)) := by
    simp [rowSqNormTraceProbMass, RowTrace]
    apply Finset.sum_congr rfl
    intro x _
    simpa [mul_assoc] using
      rowSqNormTraceProbMass_two_point_factor A t u htu f g x
  rw [← hright, ← hprod]
  exact hleft

-- ============================================================
-- Unbiasedness of the sampled Gram matrix
-- ============================================================

-- ============================================================
-- Scalar second-moment kernel for independent row traces
-- ============================================================

/-- For any scalar quantity attached to a sampled row, the centered sum over an
    independent row trace has second moment `s` times the one-step centered
    second moment. This is the finite iid variance calculation used in the
    proof of the Algorithm 2 Frobenius estimate. -/
theorem rowSqNormTraceProbability_expectationReal_centered_sum_sq
    {m n s : ℕ} (A : Fin m → Fin n → ℝ)
    (hden : 0 < rowSqNormProbDen A) (f : Fin m → ℝ) :
    let μ : ℝ := ∑ i : Fin m, rowSqNormProb A i * f i
    (rowSqNormTraceProbability (steps := s) A hden).expectationReal
      (fun samples => (∑ t : Fin s, (f (samples t) - μ)) ^ 2) =
      (s : ℝ) * ∑ i : Fin m, rowSqNormProb A i * (f i - μ) ^ 2 := by
  classical
  let μ : ℝ := ∑ i : Fin m, rowSqNormProb A i * f i
  have hcenter : ∑ i : Fin m, rowSqNormProb A i * (f i - μ) = 0 := by
    unfold μ
    simp_rw [mul_sub]
    rw [Finset.sum_sub_distrib, ← Finset.sum_mul]
    rw [rowSqNormProb_sum_eq_one A hden.ne']
    ring
  have hsame : ∀ t : Fin s,
      (rowSqNormTraceProbability (steps := s) A hden).expectationReal
        (fun samples => (f (samples t) - μ) * (f (samples t) - μ)) =
        ∑ i : Fin m, rowSqNormProb A i * (f i - μ) ^ 2 := by
    intro t
    unfold FiniteProbability.expectationReal rowSqNormTraceProbability
    calc
      ∑ samples : RowTrace m s,
          rowSqNormTraceProbMass A samples *
            ((f (samples t) - μ) * (f (samples t) - μ))
          = ∑ i : Fin m, rowSqNormProb A i *
              ((f i - μ) * (f i - μ)) :=
            rowSqNormTraceProbMass_marginal_one A hden.ne' t
              (fun i => (f i - μ) * (f i - μ))
      _ = ∑ i : Fin m, rowSqNormProb A i * (f i - μ) ^ 2 := by
            apply Finset.sum_congr rfl
            intro i _
            ring
  have hdiff : ∀ t u : Fin s, t ≠ u →
      (rowSqNormTraceProbability (steps := s) A hden).expectationReal
        (fun samples => (f (samples t) - μ) * (f (samples u) - μ)) = 0 := by
    intro t u htu
    unfold FiniteProbability.expectationReal rowSqNormTraceProbability
    calc
      ∑ samples : RowTrace m s,
          rowSqNormTraceProbMass A samples *
            ((f (samples t) - μ) * (f (samples u) - μ))
          = (∑ i : Fin m, rowSqNormProb A i * (f i - μ)) *
            (∑ i : Fin m, rowSqNormProb A i * (f i - μ)) :=
            rowSqNormTraceProbMass_marginal_two_ne A hden.ne' t u htu
              (fun i => f i - μ) (fun i => f i - μ)
      _ = 0 := by rw [hcenter]; ring
  have hsquare : ∀ samples : RowTrace m s,
      (∑ t : Fin s, (f (samples t) - μ)) ^ 2 =
        ∑ t : Fin s, ∑ u : Fin s,
          (f (samples t) - μ) * (f (samples u) - μ) := by
    intro samples
    rw [sq, Finset.sum_mul]
    simp_rw [Finset.mul_sum]
  calc
    (rowSqNormTraceProbability (steps := s) A hden).expectationReal
      (fun samples => (∑ t : Fin s, (f (samples t) - μ)) ^ 2)
        = (rowSqNormTraceProbability (steps := s) A hden).expectationReal
            (fun samples => ∑ t : Fin s, ∑ u : Fin s,
              (f (samples t) - μ) * (f (samples u) - μ)) := by
            congr 1
            ext samples
            exact hsquare samples
    _ = ∑ t : Fin s, ∑ u : Fin s,
          (rowSqNormTraceProbability (steps := s) A hden).expectationReal
            (fun samples => (f (samples t) - μ) * (f (samples u) - μ)) := by
            rw [FiniteProbability.expectationReal_sum]
            apply Finset.sum_congr rfl
            intro t _
            rw [FiniteProbability.expectationReal_sum]
    _ = ∑ t : Fin s, ∑ i : Fin m,
          rowSqNormProb A i * (f i - μ) ^ 2 := by
            apply Finset.sum_congr rfl
            intro t _
            calc
              (∑ u : Fin s,
                (rowSqNormTraceProbability (steps := s) A hden).expectationReal
                  (fun samples =>
                    (f (samples t) - μ) * (f (samples u) - μ)))
                  = (rowSqNormTraceProbability (steps := s) A hden).expectationReal
                      (fun samples =>
                        (f (samples t) - μ) * (f (samples t) - μ)) := by
                    apply Finset.sum_eq_single t
                    · intro u _ hut
                      exact hdiff t u hut.symm
                    · intro ht_not
                      exact False.elim (ht_not (Finset.mem_univ t))
              _ = ∑ i : Fin m,
                    rowSqNormProb A i * (f i - μ) ^ 2 := hsame t
    _ = (s : ℝ) * ∑ i : Fin m,
          rowSqNormProb A i * (f i - μ) ^ 2 := by
            rw [Finset.sum_const]
            simp only [Finset.card_univ, Fintype.card_fin, nsmul_eq_mul]

/-- Sample-average form of the finite iid variance calculation. -/
theorem rowSqNormTraceProbability_expectationReal_sampleAverage_sub_mean_sq
    {m n s : ℕ} (A : Fin m → Fin n → ℝ)
    (hden : 0 < rowSqNormProbDen A) (hs : 0 < (s : ℝ))
    (f : Fin m → ℝ) :
    let μ : ℝ := ∑ i : Fin m, rowSqNormProb A i * f i
    (rowSqNormTraceProbability (steps := s) A hden).expectationReal
      (fun samples => ((∑ t : Fin s, f (samples t)) / (s : ℝ) - μ) ^ 2) =
      (1 / (s : ℝ)) *
        ∑ i : Fin m, rowSqNormProb A i * (f i - μ) ^ 2 := by
  classical
  let μ : ℝ := ∑ i : Fin m, rowSqNormProb A i * f i
  have hcentered :=
    rowSqNormTraceProbability_expectationReal_centered_sum_sq (s := s) A hden f
  have hpoint : ∀ samples : RowTrace m s,
      (∑ t : Fin s, f (samples t)) / (s : ℝ) - μ =
        (∑ t : Fin s, (f (samples t) - μ)) / (s : ℝ) := by
    intro samples
    rw [Finset.sum_sub_distrib, Finset.sum_const]
    simp only [Finset.card_univ, Fintype.card_fin, nsmul_eq_mul]
    field_simp [ne_of_gt hs]
  calc
    (rowSqNormTraceProbability (steps := s) A hden).expectationReal
      (fun samples => ((∑ t : Fin s, f (samples t)) / (s : ℝ) - μ) ^ 2)
        = (rowSqNormTraceProbability (steps := s) A hden).expectationReal
            (fun samples =>
              ((∑ t : Fin s, (f (samples t) - μ)) / (s : ℝ)) ^ 2) := by
            congr 1
            ext samples
            rw [hpoint samples]
    _ = (rowSqNormTraceProbability (steps := s) A hden).expectationReal
          (fun samples => (∑ t : Fin s, (f (samples t) - μ)) ^ 2) /
            (s : ℝ) ^ 2 := by
          unfold FiniteProbability.expectationReal
          simp_rw [div_eq_mul_inv]
          calc
            ∑ samples : RowTrace m s,
                (rowSqNormTraceProbability (steps := s) A hden).prob samples *
                  ((∑ t : Fin s, (f (samples t) - μ)) * (s : ℝ)⁻¹) ^ 2
                = ∑ samples : RowTrace m s,
                    ((rowSqNormTraceProbability (steps := s) A hden).prob samples *
                      (∑ t : Fin s, (f (samples t) - μ)) ^ 2) *
                      ((s : ℝ) ^ 2)⁻¹ := by
                    apply Finset.sum_congr rfl
                    intro samples _
                    ring
            _ = (∑ samples : RowTrace m s,
                    (rowSqNormTraceProbability (steps := s) A hden).prob samples *
                      (∑ t : Fin s, (f (samples t) - μ)) ^ 2) *
                    ((s : ℝ) ^ 2)⁻¹ := by
                    rw [Finset.sum_mul]
    _ = ((s : ℝ) * ∑ i : Fin m,
          rowSqNormProb A i * (f i - μ) ^ 2) / (s : ℝ) ^ 2 := by
          rw [hcentered]
    _ = (1 / (s : ℝ)) *
        ∑ i : Fin m, rowSqNormProb A i * (f i - μ) ^ 2 := by
          field_simp [ne_of_gt hs]

end NumStability
