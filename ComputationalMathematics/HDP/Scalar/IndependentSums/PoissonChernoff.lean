import ComputationalMathematics.HDP.Scalar.IndependentSums.Chernoff
import Mathlib.MeasureTheory.Integral.Bochner.Set

/-! Chernoff foundations for the Poisson law. -/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators ENNReal NNReal Function

namespace NumStability.HDP.Scalar.IndependentSums.PoissonChernoff

lemma poissonMeasureReal_singleton (rate : ℝ≥0) (n : ℕ) :
    (ProbabilityTheory.poissonMeasure rate).real {n} =
      ProbabilityTheory.poissonPMFReal rate n := by
  rw [Measure.real_def, ProbabilityTheory.poissonMeasure,
    PMF.toMeasure_apply_singleton _ n (measurableSet_singleton n)]
  rw [ProbabilityTheory.poissonPMF]
  exact ENNReal.toReal_ofReal ProbabilityTheory.poissonPMFReal_nonneg

theorem integrable_exp_nat_poisson (rate : ℝ≥0) (s : ℝ) :
    Integrable (fun n : ℕ => Real.exp (s * (n : ℝ)))
      (ProbabilityTheory.poissonMeasure rate) := by
  let f : ℕ → ℝ := fun n => Real.exp (s * (n : ℝ))
  have hsingle : ∀ n : ℕ, IntegrableOn f {n}
      (ProbabilityTheory.poissonMeasure rate) := by
    intro n
    exact integrableOn_singleton
  have hseries : Summable (fun n : ℕ =>
      Real.exp (-(rate : ℝ)) *
        (((rate : ℝ) * Real.exp s) ^ n / (Nat.factorial n : ℝ))) := by
    exact Summable.mul_left _
      (NormedSpace.expSeries_div_hasSum_exp ((rate : ℝ) * Real.exp s)).summable
  have hnorm : Summable (fun n : ℕ =>
      ∫ x : ℕ in ({n} : Set ℕ), ‖f x‖ ∂
        (ProbabilityTheory.poissonMeasure rate)) := by
    apply hseries.congr
    intro n
    rw [integral_singleton, poissonMeasureReal_singleton]
    simp only [smul_eq_mul, f, Real.norm_eq_abs, abs_of_pos (Real.exp_pos _)]
    rw [ProbabilityTheory.poissonPMFReal]
    have hexp : Real.exp (s * (n : ℝ)) = Real.exp s ^ n := by
      rw [mul_comm, Real.exp_nat_mul]
    rw [hexp, mul_pow]
    ring
  have hunion : (⋃ n : ℕ, ({n} : Set ℕ)) = Set.univ := by
    ext n
    simp
  have h := integrableOn_iUnion_of_summable_integral_norm hsingle hnorm
  simpa [hunion, integrableOn_univ, f] using h

/-- The exact moment-generating function of a Poisson random variable. -/
theorem poissonMgfExact (rate : ℝ≥0) (s : ℝ) :
    (∫ n : ℕ, Real.exp (s * (n : ℝ)) ∂
        (ProbabilityTheory.poissonMeasure rate)) =
      Real.exp ((rate : ℝ) * (Real.exp s - 1)) := by
  rw [ProbabilityTheory.poissonMeasure]
  rw [PMF.integral_eq_tsum _ _ (integrable_exp_nat_poisson rate s)]
  simp_rw [smul_eq_mul]
  have hpmf (n : ℕ) :
      ((ProbabilityTheory.poissonPMF rate) n).toReal =
        ProbabilityTheory.poissonPMFReal rate n := by
    rw [ProbabilityTheory.poissonPMF]
    exact ENNReal.toReal_ofReal ProbabilityTheory.poissonPMFReal_nonneg
  simp_rw [hpmf]
  have hterm (n : ℕ) :
      ProbabilityTheory.poissonPMFReal rate n * Real.exp (s * (n : ℝ)) =
        Real.exp (-(rate : ℝ)) *
          (((rate : ℝ) * Real.exp s) ^ n / (Nat.factorial n : ℝ)) := by
    rw [ProbabilityTheory.poissonPMFReal]
    have hexp : Real.exp (s * (n : ℝ)) = Real.exp s ^ n := by
      rw [mul_comm, Real.exp_nat_mul]
    rw [hexp, mul_pow]
    ring
  calc
    (∑' n : ℕ, ProbabilityTheory.poissonPMFReal rate n *
        Real.exp (s * (n : ℝ))) =
        ∑' n : ℕ, Real.exp (-(rate : ℝ)) *
          (((rate : ℝ) * Real.exp s) ^ n / (Nat.factorial n : ℝ)) :=
      tsum_congr hterm
    _ = Real.exp (-(rate : ℝ)) *
        ∑' n : ℕ, (((rate : ℝ) * Real.exp s) ^ n /
          (Nat.factorial n : ℝ)) := tsum_mul_left
    _ = Real.exp (-(rate : ℝ)) *
        Real.exp ((rate : ℝ) * Real.exp s) := by
      congr 1
      exact
        (NormedSpace.expSeries_div_hasSum_exp
          ((rate : ℝ) * Real.exp s)).tsum_eq.trans
          (congr_fun Real.exp_eq_exp_ℝ ((rate : ℝ) * Real.exp s)).symm
    _ = Real.exp ((rate : ℝ) * (Real.exp s - 1)) := by
      rw [← Real.exp_add]
      congr 1
      ring

/-- Chernoff's upper-tail bound for a Poisson random variable. -/
theorem poissonChernoffUpper
    (rate : ℝ≥0) {t : ℝ} (ht : (rate : ℝ) < t) :
    (ProbabilityTheory.poissonMeasure rate).real {n : ℕ | t ≤ (n : ℝ)} ≤
      Real.exp (-(rate : ℝ)) *
        ((Real.exp 1 * (rate : ℝ) / t) ^ t) := by
  have ht0 : 0 < t := lt_of_le_of_lt (NNReal.coe_nonneg rate) ht
  by_cases hr0 : rate = 0
  · subst rate
    have hsub : {n : ℕ | t ≤ (n : ℝ)} ⊆ ({0} : Set ℕ)ᶜ := by
      intro n hn hn0
      simp only [Set.mem_singleton_iff] at hn0
      subst n
      norm_num at hn
      linarith
    have hmass0 :
        (ProbabilityTheory.poissonMeasure (0 : ℝ≥0)).real ({0} : Set ℕ) = 1 := by
      simpa [ProbabilityTheory.poissonPMFReal] using
        poissonMeasureReal_singleton (0 : ℝ≥0) 0
    have hcomp :
        (ProbabilityTheory.poissonMeasure (0 : ℝ≥0)).real ({0} : Set ℕ)ᶜ = 0 := by
      rw [probReal_compl_eq_one_sub (measurableSet_singleton 0), hmass0]
      norm_num
    have hevent :
        (ProbabilityTheory.poissonMeasure (0 : ℝ≥0)).real
          {n : ℕ | t ≤ (n : ℝ)} = 0 := by
      apply le_antisymm
      · exact (measureReal_mono hsub).trans_eq hcomp
      · positivity
    rw [hevent]
    positivity
  have hr : 0 < (rate : ℝ) := lt_of_le_of_ne (NNReal.coe_nonneg rate)
    (by exact_mod_cast Ne.symm hr0)
  let s : ℝ := Real.log (t / (rate : ℝ))
  have hs : 0 < s := by
    dsimp [s]
    apply Real.log_pos
    rw [one_lt_div hr]
    exact ht
  have hmarkov :=
    NumStability.HDP.Scalar.IndependentSums.Hoeffding.exponentialMarkovUpper
      (μ := ProbabilityTheory.poissonMeasure rate)
      (S := fun n : ℕ => (n : ℝ)) (lam := s) (t := t)
      (measurable_of_countable _) hs (integrable_exp_nat_poisson rate s)
  calc
    (ProbabilityTheory.poissonMeasure rate).real {n : ℕ | t ≤ (n : ℝ)} ≤
        Real.exp (-(s * t)) *
          (∫ n : ℕ, Real.exp (s * (n : ℝ)) ∂
            (ProbabilityTheory.poissonMeasure rate)) := by
      exact hmarkov
    _ = Real.exp (-(s * t)) *
        Real.exp ((rate : ℝ) * (Real.exp s - 1)) := by
      rw [poissonMgfExact]
    _ = Real.exp (-(rate : ℝ)) *
        ((Real.exp 1 * (rate : ℝ) / t) ^ t) := by
      have hratio : 0 < t / (rate : ℝ) := div_pos ht0 hr
      have hbase : 0 < Real.exp 1 * (rate : ℝ) / t :=
        div_pos (mul_pos (Real.exp_pos _) hr) ht0
      dsimp [s]
      rw [Real.exp_log hratio]
      rw [Real.rpow_def_of_pos hbase]
      rw [Real.log_div (mul_ne_zero (ne_of_gt (Real.exp_pos (1 : ℝ)))
        (ne_of_gt hr)) (ne_of_gt ht0)]
      rw [Real.log_mul (ne_of_gt (Real.exp_pos (1 : ℝ))) (ne_of_gt hr)]
      rw [Real.log_exp]
      rw [← Real.exp_add]
      rw [← Real.exp_add]
      congr 1
      rw [Real.log_div (ne_of_gt ht0) (ne_of_gt hr)]
      field_simp
      ring

private lemma exp_add_half_le (δ : ℝ) (hδ0 : 0 ≤ δ) (hδ1 : δ ≤ 1) :
    Real.exp (δ / 2) ≤ 1 + δ / 2 + (δ / 2) ^ 2 := by
  have hrem := Real.abs_exp_sub_one_sub_id_le (x := δ / 2) (by
    calc
      |δ / 2| = δ / 2 := abs_of_nonneg (by positivity)
      _ ≤ 1 := by linarith)
  have hrem' : Real.exp (δ / 2) - 1 - δ / 2 ≤ (δ / 2) ^ 2 :=
    (le_abs_self _).trans hrem
  linarith

private lemma exp_neg_half_le (δ : ℝ) (hδ0 : 0 ≤ δ) (hδ1 : δ ≤ 1) :
    Real.exp (-δ / 2) ≤ 1 - δ / 2 + (δ / 2) ^ 2 := by
  have hrem := Real.abs_exp_sub_one_sub_id_le (x := -δ / 2) (by
    calc
      |-δ / 2| = δ / 2 := by
        rw [abs_of_nonpos (by linarith)]
        ring
      _ ≤ 1 := by linarith)
  have hrem' : Real.exp (-δ / 2) - 1 - (-δ / 2) ≤ (-δ / 2) ^ 2 :=
    (le_abs_self _).trans hrem
  linarith

/-- A two-sided quadratic concentration bound for a Poisson law, with the
explicit universal constant `1 / 4`. -/
theorem poissonTwoSidedQuadraticBound
    (rate : ℝ≥0) {δ : ℝ} (hδ0 : 0 < δ) (hδ1 : δ ≤ 1) :
    (ProbabilityTheory.poissonMeasure rate).real
        {n : ℕ | δ * (rate : ℝ) ≤ |(n : ℝ) - (rate : ℝ)|} ≤
      2 * Real.exp (-(rate : ℝ) * δ ^ 2 / 4) := by
  let m : ℝ := rate
  have hm : 0 ≤ m := by positivity
  have hupper_markov :=
    NumStability.HDP.Scalar.IndependentSums.Hoeffding.exponentialMarkovUpper
      (μ := ProbabilityTheory.poissonMeasure rate)
      (S := fun n : ℕ => (n : ℝ)) (lam := δ / 2) (t := (1 + δ) * m)
      (measurable_of_countable _) (by linarith)
      (integrable_exp_nat_poisson rate (δ / 2))
  have hlower_markov :=
    NumStability.HDP.Scalar.IndependentSums.Hoeffding.exponentialMarkovUpper
      (μ := ProbabilityTheory.poissonMeasure rate)
      (S := fun n : ℕ => -(n : ℝ)) (lam := δ / 2) (t := -(1 - δ) * m)
      (measurable_of_countable _) (by linarith)
      (by
        convert integrable_exp_nat_poisson rate (-δ / 2) using 1
        ext n
        congr 1
        ring)
  have hupper_exp : Real.exp (δ / 2) ≤ 1 + δ / 2 + (δ / 2) ^ 2 :=
    exp_add_half_le δ hδ0.le hδ1
  have hlower_exp : Real.exp (-δ / 2) ≤ 1 - δ / 2 + (δ / 2) ^ 2 :=
    exp_neg_half_le δ hδ0.le hδ1
  have hupper_coeff :
      -(δ / 2 * ((1 + δ) * m)) + (Real.exp (δ / 2) - 1) * m ≤
        -(m * δ ^ 2 / 4) := by
    have hcoeff :
        -(δ / 2 * (1 + δ)) + (Real.exp (δ / 2) - 1) ≤
          -(δ ^ 2 / 4) := by
      nlinarith [hupper_exp]
    have := mul_le_mul_of_nonneg_right hcoeff hm
    nlinarith
  have hlower_coeff :
      -(δ / 2 * (-(1 - δ) * m)) + (Real.exp (-δ / 2) - 1) * m ≤
        -(m * δ ^ 2 / 4) := by
    have hcoeff :
        (δ / 2) * (1 - δ) + (Real.exp (-δ / 2) - 1) ≤
          -(δ ^ 2 / 4) := by
      nlinarith [hlower_exp]
    have := mul_le_mul_of_nonneg_right hcoeff hm
    nlinarith
  have hupper_raw :
      (ProbabilityTheory.poissonMeasure rate).real
          ((fun n : ℕ => (n : ℝ)) ⁻¹' Set.Ici ((1 + δ) * m)) ≤
        Real.exp (-(δ / 2 * ((1 + δ) * m))) *
          Real.exp ((Real.exp (δ / 2) - 1) * m) := by
    refine hupper_markov.trans_eq ?_
    rw [poissonMgfExact]
    congr 2
    dsimp [m]
    ring
  have hlower_raw :
      (ProbabilityTheory.poissonMeasure rate).real
          ((fun n : ℕ => -(n : ℝ)) ⁻¹' Set.Ici (-(1 - δ) * m)) ≤
        Real.exp (-(δ / 2 * (-(1 - δ) * m))) *
          Real.exp ((Real.exp (-δ / 2) - 1) * m) := by
    refine hlower_markov.trans_eq ?_
    have hint :
        (∫ n : ℕ, Real.exp (δ / 2 * -(n : ℝ)) ∂
            (ProbabilityTheory.poissonMeasure rate)) =
          Real.exp ((rate : ℝ) * (Real.exp (-δ / 2) - 1)) := by
      have hfun : (fun n : ℕ => Real.exp (δ / 2 * -(n : ℝ))) =
          (fun n : ℕ => Real.exp ((-δ / 2) * (n : ℝ))) := by
        funext n
        congr 1
        ring
      rw [hfun, poissonMgfExact]
    rw [hint]
    congr 2
    dsimp [m]
    ring
  have hupper :
      (ProbabilityTheory.poissonMeasure rate).real
          {n : ℕ | (1 + δ) * m ≤ (n : ℝ)} ≤
        Real.exp (-(m * δ ^ 2 / 4)) := by
    refine hupper_raw.trans ?_
    rw [← Real.exp_add]
    exact Real.exp_le_exp.2 hupper_coeff
  have hlower :
      (ProbabilityTheory.poissonMeasure rate).real
          {n : ℕ | (n : ℝ) ≤ (1 - δ) * m} ≤
        Real.exp (-(m * δ ^ 2 / 4)) := by
    have hset : {n : ℕ | (n : ℝ) ≤ (1 - δ) * m} =
        (fun n : ℕ => -(n : ℝ)) ⁻¹' Set.Ici (-(1 - δ) * m) := by
      ext n
      simp only [Set.mem_setOf_eq, Set.mem_preimage, Set.mem_Ici]
      constructor <;> intro h <;> linarith
    rw [hset]
    refine hlower_raw.trans ?_
    rw [← Real.exp_add]
    exact Real.exp_le_exp.2 hlower_coeff
  let U : Set ℕ := {n | (1 + δ) * m ≤ (n : ℝ)}
  let L : Set ℕ := {n | (n : ℝ) ≤ (1 - δ) * m}
  have hsubset : {n : ℕ | δ * m ≤ |(n : ℝ) - m|} ⊆ U ∪ L := by
    intro n hn
    by_cases hu : (1 + δ) * m ≤ (n : ℝ)
    · exact Or.inl hu
    · right
      have hnotupper : (n : ℝ) < (1 + δ) * m := lt_of_not_ge hu
      by_contra hnotlower
      have hlower' : (1 - δ) * m < (n : ℝ) := lt_of_not_ge hnotlower
      have habs : |(n : ℝ) - m| < δ * m := by
        rw [abs_lt]
        constructor <;> linarith
      exact (not_lt_of_ge hn) habs
  have hmono {A B : Set ℕ} (hAB : A ⊆ B) :
      (ProbabilityTheory.poissonMeasure rate).real A ≤
        (ProbabilityTheory.poissonMeasure rate).real B := by
    exact measureReal_mono hAB
  have hunion :
      (ProbabilityTheory.poissonMeasure rate).real (U ∪ L) ≤
        (ProbabilityTheory.poissonMeasure rate).real U +
          (ProbabilityTheory.poissonMeasure rate).real L := by
    rw [Measure.real_def, Measure.real_def, Measure.real_def]
    calc
      ((ProbabilityTheory.poissonMeasure rate) (U ∪ L)).toReal ≤
          ((ProbabilityTheory.poissonMeasure rate) U +
            (ProbabilityTheory.poissonMeasure rate) L).toReal := by
        apply ENNReal.toReal_mono
        · exact ENNReal.add_ne_top.mpr
            ⟨measure_ne_top _ U, measure_ne_top _ L⟩
        · exact measure_union_le U L
      _ = ((ProbabilityTheory.poissonMeasure rate) U).toReal +
          ((ProbabilityTheory.poissonMeasure rate) L).toReal :=
        ENNReal.toReal_add (measure_ne_top _ U) (measure_ne_top _ L)
  calc
    (ProbabilityTheory.poissonMeasure rate).real
        {n : ℕ | δ * (rate : ℝ) ≤ |(n : ℝ) - (rate : ℝ)|} ≤
        (ProbabilityTheory.poissonMeasure rate).real (U ∪ L) := by
      simpa [m] using hmono hsubset
    _ ≤ (ProbabilityTheory.poissonMeasure rate).real U +
        (ProbabilityTheory.poissonMeasure rate).real L := hunion
    _ ≤ Real.exp (-(m * δ ^ 2 / 4)) + Real.exp (-(m * δ ^ 2 / 4)) :=
      add_le_add (by simpa [U] using hupper) (by simpa [L] using hlower)
    _ = 2 * Real.exp (-(rate : ℝ) * δ ^ 2 / 4) := by
      dsimp [m]
      ring

/-! Exact foundations for the endpoint and sharpness discussion in Remark 2.3.4. -/

/-- The Stirling equivalent for a Poisson point mass also holds at rate zero.
At that endpoint both sides vanish eventually. -/
theorem poissonPointMass_isEquivalent_stirling_all (rate : ℝ≥0) :
    Asymptotics.IsEquivalent Filter.atTop
      (fun k : ℕ => ProbabilityTheory.poissonPMFReal rate k)
      (fun k : ℕ =>
        Real.exp (-(rate : ℝ)) *
          (Real.exp 1 * (rate : ℝ) / (k : ℝ)) ^ k /
            Real.sqrt (2 * (k : ℝ) * Real.pi)) := by
  rcases eq_or_lt_of_le (zero_le rate) with hrate | hrate
  · subst rate
    have hleft : (fun _ : ℕ => (0 : ℝ)) =ᶠ[Filter.atTop]
        (fun k : ℕ => ProbabilityTheory.poissonPMFReal (0 : ℝ≥0) k) := by
      filter_upwards [Filter.eventually_atTop.2
        ⟨1, fun _ hk => hk⟩] with k hk
      have hk0 : k ≠ 0 := Nat.ne_of_gt (lt_of_lt_of_le Nat.zero_lt_one hk)
      simp [ProbabilityTheory.poissonPMFReal, hk0]
    have hright : (fun _ : ℕ => (0 : ℝ)) =ᶠ[Filter.atTop]
        (fun k : ℕ =>
          Real.exp (-((0 : ℝ≥0) : ℝ)) *
            (Real.exp 1 * ((0 : ℝ≥0) : ℝ) / (k : ℝ)) ^ k /
              Real.sqrt (2 * (k : ℝ) * Real.pi)) := by
      filter_upwards [Filter.eventually_atTop.2
        ⟨1, fun _ hk => hk⟩] with k hk
      have hk0 : k ≠ 0 := Nat.ne_of_gt (lt_of_lt_of_le Nat.zero_lt_one hk)
      simp [hk0]
    exact (Asymptotics.IsEquivalent.refl.congr_left hleft).congr_right hright
  · exact
      NumStability.HDP.Scalar.IndependentSums.Chernoff.poissonPointMass_isEquivalent_stirling
        rate hrate

/-- A Poisson upper tail contains its first point mass and is bounded by the
matching Chernoff profile.  Together with Stirling's formula this is the exact
tail-versus-point comparison used to justify sharpness up to a square-root
factor. -/
theorem poissonPointMass_le_upperTail_le_chernoffProfile
    (rate : ℝ≥0) {k : ℕ} (hk : (rate : ℝ) < (k : ℝ)) :
    ProbabilityTheory.poissonPMFReal rate k ≤
        (ProbabilityTheory.poissonMeasure rate).real
          {n : ℕ | (k : ℝ) ≤ (n : ℝ)} ∧
      (ProbabilityTheory.poissonMeasure rate).real
          {n : ℕ | (k : ℝ) ≤ (n : ℝ)} ≤
        Real.exp (-(rate : ℝ)) *
          (Real.exp 1 * (rate : ℝ) / (k : ℝ)) ^ k := by
  constructor
  · rw [← poissonMeasureReal_singleton]
    apply measureReal_mono
    intro n hn
    have hn' : n = k := by
      simpa only [Set.mem_singleton_iff] using hn
    subst n
    change (k : ℝ) ≤ (k : ℝ)
    exact le_rfl
    · exact measure_ne_top _ _
  · simpa only [Real.rpow_natCast] using
      poissonChernoffUpper rate (t := (k : ℝ)) hk

end NumStability.HDP.Scalar.IndependentSums.PoissonChernoff
