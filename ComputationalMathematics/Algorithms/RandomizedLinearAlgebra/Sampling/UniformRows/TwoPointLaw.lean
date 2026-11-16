import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Sampling.UniformRows.Core

/-!
# Two-coordinate laws for uniform replacement sampling

Two distinct coordinates of the literal iid uniform row trace have product
expectations and collision probability equal to the reciprocal population size.
-/

namespace NumStability
open scoped BigOperators

/-- Product-law pointwise factorization for two distinct coordinates of an iid
    uniform row trace. -/
private theorem uniformRowTraceProbMass_two_point_factor
    {m steps : ℕ} (t u : Fin steps) (htu : t ≠ u)
    (f g : Fin m → ℝ) (x : RowTrace m steps) :
    (∏ r : Fin steps,
      if r = t then uniformRowProb (x r) * f (x r)
      else if r = u then uniformRowProb (x r) * g (x r)
      else uniformRowProb (x r)) =
    (∏ r : Fin steps, uniformRowProb (x r)) *
      f (x t) * g (x u) := by
  classical
  have hfactor : ∀ r : Fin steps,
      (if r = t then uniformRowProb (x r) * f (x r)
      else if r = u then uniformRowProb (x r) * g (x r)
      else uniformRowProb (x r)) =
      uniformRowProb (x r) *
        (if r = t then f (x r) else if r = u then g (x r) else 1) := by
    intro r
    by_cases hrt : r = t
    · simp [hrt]
    · by_cases hru : r = u
      · simp [hru]
      · simp [hrt, hru]
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

/-- Two distinct coordinates of the iid uniform row trace have product
    expectation equal to the product of their one-step expectations. -/
theorem uniformRowTraceProbMass_marginal_two_ne {m steps : ℕ}
    (hm : 0 < m) (t u : Fin steps) (htu : t ≠ u)
    (f g : Fin m → ℝ) :
    (∑ samples : RowTrace m steps,
      uniformRowTraceProbMass samples *
        (f (samples t) * g (samples u))) =
      (∑ i : Fin m, uniformRowProb i * f i) *
      (∑ i : Fin m, uniformRowProb i * g i) := by
  classical
  have hprod :=
    Finset.prod_univ_sum
      (t := fun _ : Fin steps => (Finset.univ : Finset (RowSample m)))
      (f := fun r x =>
        if r = t then uniformRowProb x * f x
        else if r = u then uniformRowProb x * g x
        else uniformRowProb x)
  have hleft :
      (∏ r : Fin steps,
        ∑ x ∈ (Finset.univ : Finset (RowSample m)),
          (if r = t then uniformRowProb x * f x
          else if r = u then uniformRowProb x * g x
          else uniformRowProb x)) =
      (∑ i : Fin m, uniformRowProb i * f i) *
      (∑ i : Fin m, uniformRowProb i * g i) := by
    simp [uniformRowProb_sum_eq_one hm]
    have hprod_t := Finset.prod_eq_mul_prod_diff_singleton
      (s := (Finset.univ : Finset (Fin steps))) t
      (fun r : Fin steps =>
        if r = t then ∑ i : Fin m, uniformRowProb i * f i
        else if r = u then ∑ i : Fin m, uniformRowProb i * g i
        else 1)
      (by intro h; simp at h)
    simp at hprod_t
    rw [hprod_t]
    have herase :
        (∏ x_1 ∈ Finset.univ \ {t},
          if x_1 = t then ∑ i : Fin m, uniformRowProb i * f i
          else if x_1 = u then ∑ i : Fin m, uniformRowProb i * g i
          else 1) =
        ∑ i : Fin m, uniformRowProb i * g i := by
      rw [Finset.sdiff_singleton_eq_erase]
      have hprod_u := Finset.prod_eq_mul_prod_diff_singleton
        (s := ((Finset.univ : Finset (Fin steps)).erase t)) u
        (fun r : Fin steps =>
          if r = t then ∑ i : Fin m, uniformRowProb i * f i
          else if r = u then ∑ i : Fin m, uniformRowProb i * g i
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
            if x_1 = t then ∑ i : Fin m, uniformRowProb i * f i
            else if x_1 = u then ∑ i : Fin m, uniformRowProb i * g i
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
        ∏ r, (if r = t then uniformRowProb (x r) * f (x r)
          else if r = u then uniformRowProb (x r) * g (x r)
          else uniformRowProb (x r)))
        = ∑ samples : RowTrace m steps,
          uniformRowTraceProbMass samples *
            (f (samples t) * g (samples u)) := by
    simp [uniformRowTraceProbMass, RowTrace]
    apply Finset.sum_congr rfl
    intro x _
    simpa [mul_assoc] using
      uniformRowTraceProbMass_two_point_factor t u htu f g x
  rw [← hright, ← hprod]
  exact hleft

/-- Under iid uniform row sampling, two distinct trace coordinates collide
    with exact probability `1 / m`. -/
theorem uniformRowTraceProbability_eventProb_pair_collision_eq_inv
    {m steps : ℕ} (hm : 0 < m) (t u : Fin steps) (htu : t ≠ u) :
    (uniformRowTraceProbability (m := m) (steps := steps) hm).eventProb
      {samples | samples t = samples u} = (m : ℝ)⁻¹ := by
  classical
  let P := uniformRowTraceProbability (m := m) (steps := steps) hm
  have hdecomp :
      P.eventProb {samples : RowTrace m steps | samples t = samples u} =
        ∑ q : Fin m,
          P.expectationReal (fun samples =>
            (if samples t = q then 1 else 0) *
              (if samples u = q then 1 else 0)) := by
    unfold P FiniteProbability.eventProb FiniteProbability.expectationReal
      uniformRowTraceProbability
    rw [Finset.sum_comm]
    apply Finset.sum_congr rfl
    intro samples _
    by_cases hcoll : samples t = samples u
    · simp [hcoll, Finset.sum_ite_eq, Finset.mem_univ]
    · have hzero : ∀ q : Fin m,
        (if samples t = q then (1 : ℝ) else 0) *
          (if samples u = q then (1 : ℝ) else 0) = 0 := by
        intro q
        by_cases htq : samples t = q
        · have huq : samples u ≠ q := by
            intro huq
            exact hcoll (htq.trans huq.symm)
          simp [htq, huq]
        · simp [htq]
      simp [hcoll, hzero]
  have hq : ∀ q : Fin m,
      P.expectationReal (fun samples =>
        (if samples t = q then 1 else 0) *
          (if samples u = q then 1 else 0)) =
        uniformRowProb q * uniformRowProb q := by
    intro q
    have hbase :=
      uniformRowTraceProbMass_marginal_two_ne
        (m := m) (steps := steps) hm t u htu
        (fun i : Fin m => if i = q then (1 : ℝ) else 0)
        (fun i : Fin m => if i = q then (1 : ℝ) else 0)
    have hleft :
        P.expectationReal (fun samples =>
          (if samples t = q then 1 else 0) *
            (if samples u = q then 1 else 0)) =
        ∑ samples : RowTrace m steps,
          uniformRowTraceProbMass samples *
            ((if samples t = q then 1 else 0) *
              (if samples u = q then 1 else 0)) := rfl
    have hright0 :
        (∑ i : Fin m,
          uniformRowProb i * (if i = q then (1 : ℝ) else 0)) =
        uniformRowProb q := by
      simp [Finset.mem_univ]
    rw [hleft, hbase, hright0]
  have hsum_prob :
      (∑ q : Fin m, uniformRowProb q * uniformRowProb q) = (m : ℝ)⁻¹ := by
    have hmR : (m : ℝ) ≠ 0 := by exact_mod_cast (ne_of_gt hm)
    calc
      (∑ q : Fin m, uniformRowProb q * uniformRowProb q)
          = ∑ _q : Fin m, (m : ℝ)⁻¹ * (m : ℝ)⁻¹ := by
              apply Finset.sum_congr rfl
              intro q _
              rfl
      _ = (m : ℝ) * ((m : ℝ)⁻¹ * (m : ℝ)⁻¹) := by
              simp [Finset.sum_const, nsmul_eq_mul]
      _ = (m : ℝ)⁻¹ := by
              field_simp [hmR]
  rw [hdecomp]
  calc
    (∑ q : Fin m,
        P.expectationReal (fun samples =>
          (if samples t = q then 1 else 0) *
            (if samples u = q then 1 else 0)))
        = ∑ q : Fin m, uniformRowProb q * uniformRowProb q := by
            apply Finset.sum_congr rfl
            intro q _
            rw [hq q]
    _ = (m : ℝ)⁻¹ := hsum_prob

end NumStability
