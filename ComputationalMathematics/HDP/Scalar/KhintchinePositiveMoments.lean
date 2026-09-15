import ComputationalMathematics.HDP.Scalar.KhintchineLowMoments

/-!
# Khintchine inequalities below the second moment

This module proves the positive-`p`, `p < 2` version requested by Exercise
2.6.7. It generalizes the exercise's extrapolation argument and supplies an
explicit positive lower coefficient depending only on `K` and `p`.
-/

noncomputable section

open MeasureTheory
open ProbabilityTheory
open scoped BigOperators ENNReal

namespace NumStability.HDP.Scalar.KhintchinePositiveMoments

open NumStability.HDP.Scalar.Khintchine
open NumStability.HDP.Scalar.KhintchineLowMoments
open NumStability.HDP.Scalar.SubGaussian

/-- The Hölder interpolation inequality between positive `Lᵖ`, `L²`, and
`L³` moments when `p < 2`. -/
theorem lpExtrapolationOfPosLtTwo
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] {Z : Ω → ℝ}
    {p : ℝ} (hp0 : 0 < p) (hp2 : p < 2)
    (hZp : MemLp Z (ENNReal.ofReal p) μ) (hZ3 : MemLp Z 3 μ) :
    (∫ ω, |Z ω| ^ (2 : ℝ) ∂μ) ≤
      (∫ ω, |Z ω| ^ p ∂μ) ^ (1 / (3 - p) : ℝ) *
        (∫ ω, |Z ω| ^ (3 : ℝ) ∂μ) ^
          ((2 - p) / (3 - p) : ℝ) := by
  let r : ℝ := 3 - p
  let s : ℝ := (3 - p) / (2 - p)
  let a : ℝ := p / (3 - p)
  let b : ℝ := 3 * (2 - p) / (3 - p)
  have h2p : 0 < 2 - p := by linarith
  have h3p : 0 < 3 - p := by linarith
  have hr : 1 < r := by dsimp [r]; linarith
  have hs : 1 < s := by
    dsimp [s]
    rw [one_lt_div₀] <;> linarith
  have hrs : r.HolderConjugate s := by
    rw [Real.holderConjugate_iff]
    refine ⟨hr, ?_⟩
    dsimp [r, s]
    field_simp [h2p.ne', h3p.ne']
    ring
  have ha : 0 < a := by
    dsimp [a]
    exact div_pos hp0 h3p
  have hb : 0 < b := by
    dsimp [b]
    exact div_pos (mul_pos (by norm_num) h2p) h3p
  have hf0 := hZp.norm_rpow_div (q := ENNReal.ofReal a)
  have hf : MemLp (fun ω => |Z ω| ^ a) (ENNReal.ofReal r) μ := by
    convert hf0 using 1
    · funext ω
      simp [ENNReal.toReal_ofReal ha.le, Real.norm_eq_abs]
    · rw [← ENNReal.ofReal_div_of_pos ha]
      apply congrArg ENNReal.ofReal
      dsimp [a, r]
      field_simp [hp0.ne', h3p.ne']
  have hg0 := hZ3.norm_rpow_div (q := ENNReal.ofReal b)
  have hg : MemLp (fun ω => |Z ω| ^ b) (ENNReal.ofReal s) μ := by
    convert hg0 using 1
    · funext ω
      simp [ENNReal.toReal_ofReal hb.le, Real.norm_eq_abs]
    · rw [show (3 : ENNReal) = ENNReal.ofReal 3 by norm_num,
        ← ENNReal.ofReal_div_of_pos hb]
      apply congrArg ENNReal.ofReal
      dsimp [b, s]
      field_simp [h2p.ne', h3p.ne']
  have hc := integral_mul_le_Lp_mul_Lq_of_nonneg
    (μ := μ) (p := r) (q := s)
    (f := fun ω => |Z ω| ^ a) (g := fun ω => |Z ω| ^ b)
    hrs
    (Filter.Eventually.of_forall fun ω => Real.rpow_nonneg (abs_nonneg _) _)
    (Filter.Eventually.of_forall fun ω => Real.rpow_nonneg (abs_nonneg _) _)
    hf hg
  have hfg : (fun ω => |Z ω| ^ a * |Z ω| ^ b) =
      (fun ω => |Z ω| ^ (2 : ℝ)) := by
    funext ω
    rw [← Real.rpow_add_of_nonneg (abs_nonneg _) (by positivity) (by positivity)]
    congr 1
    dsimp [a, b]
    field_simp [h3p.ne']
    ring
  have hfr : (fun ω => (|Z ω| ^ a) ^ r) =
      (fun ω => |Z ω| ^ p) := by
    funext ω
    rw [← Real.rpow_mul (abs_nonneg _)]
    congr 1
    dsimp [a, r]
    field_simp [h3p.ne']
  have hgs : (fun ω => (|Z ω| ^ b) ^ s) =
      (fun ω => |Z ω| ^ (3 : ℝ)) := by
    funext ω
    rw [← Real.rpow_mul (abs_nonneg _)]
    congr 1
    dsimp [b, s]
    field_simp [h2p.ne', h3p.ne']
  rw [hfg, hfr, hgs] at hc
  simpa [r, s, one_div_div] using hc

/-- Algebraic extraction of a lower bound from a two-moment interpolation
estimate. -/
theorem lower_of_interpolation_rpow
    {A Lp B alpha beta : ℝ}
    (hA : 0 ≤ A) (hLp : 0 ≤ Lp) (hB : 0 < B)
    (ha : 0 < alpha) (hb : 0 < beta) (hsum : alpha + beta = 2)
    (hinter : A ^ (2 : ℝ) ≤ Lp ^ alpha * (B * A) ^ beta) :
    B ^ (-beta / alpha) * A ≤ Lp := by
  by_cases hAz : A = 0
  · simp [hAz, hLp]
  have hApos : 0 < A := lt_of_le_of_ne hA (Ne.symm hAz)
  have hfactor : A ^ alpha * A ^ beta ≤
      (Lp ^ alpha * B ^ beta) * A ^ beta := by
    calc
      A ^ alpha * A ^ beta = A ^ (2 : ℝ) := by
        rw [← Real.rpow_add hApos]
        exact congrArg (fun z : ℝ => A ^ z) hsum
      _ ≤ Lp ^ alpha * (B * A) ^ beta := hinter
      _ = (Lp ^ alpha * B ^ beta) * A ^ beta := by
        rw [Real.mul_rpow hB.le hA]
        ring
  have hmain : A ^ alpha ≤ Lp ^ alpha * B ^ beta := by
    by_contra hnot
    have hgt : Lp ^ alpha * B ^ beta < A ^ alpha := lt_of_not_ge hnot
    have hstrict : (Lp ^ alpha * B ^ beta) * A ^ beta <
        A ^ alpha * A ^ beta :=
      mul_lt_mul_of_pos_right hgt (Real.rpow_pos_of_pos hApos beta)
    exact (not_lt_of_ge hfactor) hstrict
  have hBneg : 0 ≤ B ^ (-beta) := Real.rpow_nonneg hB.le _
  have hscaled := mul_le_mul_of_nonneg_left hmain hBneg
  have hscaled' : B ^ (-beta) * A ^ alpha ≤ Lp ^ alpha := by
    calc
      B ^ (-beta) * A ^ alpha ≤
          B ^ (-beta) * (Lp ^ alpha * B ^ beta) := hscaled
      _ = Lp ^ alpha := by
        calc
          B ^ (-beta) * (Lp ^ alpha * B ^ beta) =
              Lp ^ alpha * (B ^ (-beta) * B ^ beta) := by ring
          _ = Lp ^ alpha * B ^ (-beta + beta) := by
            rw [Real.rpow_add hB]
          _ = Lp ^ alpha := by norm_num
  have hcoeff : 0 ≤ B ^ (-beta / alpha) := Real.rpow_nonneg hB.le _
  apply (Real.rpow_le_rpow_iff (mul_nonneg hcoeff hA) hLp ha).mp
  calc
    (B ^ (-beta / alpha) * A) ^ alpha =
        B ^ (-beta) * A ^ alpha := by
      rw [Real.mul_rpow hcoeff hA, ← Real.rpow_mul hB.le]
      congr 2
      field_simp [ha.ne']
    _ ≤ Lp ^ alpha := hscaled'

/-- Exercise 2.6.7: for every `0 < p < 2`, the Khintchine lower coefficient
may be chosen as `(C * (1 + K)) ^ (-3 * (2 - p) / p)`; the upper coefficient
remains one. -/
theorem independentSubGaussianKhintchinePosLtTwo :
    ∃ C : ℝ, 1 ≤ C ∧
      ∀ {ι Ω : Type*} [Fintype ι] [Nonempty ι]
        [MeasurableSpace Ω] {μ : Measure Ω}
        [IsProbabilityMeasure μ] {X : ι → Ω → ℝ},
        (∀ i, IsSubGaussian μ (X i)) →
        (∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0) →
        (∀ i, Var[X i; μ] = 1) →
        iIndepFun X μ →
        ∀ (a : ι → ℝ) (p : ℝ), 0 < p → p < 2 →
          let K := psiTwoNormMax μ X
          let S : Ω → ℝ := fun ω => ∑ i, a i * X i ω
          let A := Real.sqrt (∑ i, a i ^ 2)
          let c := (C * (1 + K)) ^ (-(3 * (2 - p) / p))
          0 < c ∧ c * A ≤ lpNorm S (ENNReal.ofReal p) μ ∧
            lpNorm S (ENNReal.ofReal p) μ ≤ A := by
  rcases independentSubGaussianKhintchine with ⟨C₀, hC₀, hKhin⟩
  let C : ℝ := 2 * C₀
  have hC : 1 ≤ C := by dsimp [C]; nlinarith
  refine ⟨C, hC, ?_⟩
  intro ι Ω _ _ _ μ _ X hSub hCenter hVariance hIndep a p hp0 hp2
  let K : ℝ := psiTwoNormMax μ X
  let S : Ω → ℝ := fun ω => ∑ i, a i * X i ω
  let Q : ℝ := ∑ i, a i ^ 2
  let A : ℝ := Real.sqrt Q
  let B : ℝ := C * (1 + K)
  let alpha : ℝ := p / (3 - p)
  let beta : ℝ := 3 * (2 - p) / (3 - p)
  have h2p : 0 < 2 - p := by linarith
  have h3p : 0 < 3 - p := by linarith
  have halpha : 0 < alpha := by dsimp [alpha]; exact div_pos hp0 h3p
  have hbeta : 0 < beta := by
    dsimp [beta]
    exact div_pos (mul_pos (by norm_num) h2p) h3p
  have hab : alpha + beta = 2 := by
    dsimp [alpha, beta]
    field_simp [h3p.ne']
    ring
  have hK : 0 ≤ K := by
    simpa [K] using psiTwoNormMax_nonneg (μ := μ) (X := X)
  have hQ : 0 ≤ Q := by
    dsimp [Q]
    exact Finset.sum_nonneg fun i _ => sq_nonneg _
  have hA : 0 ≤ A := Real.sqrt_nonneg Q
  have hCpos : 0 < C := lt_of_lt_of_le zero_lt_one hC
  have hB : 0 < B := mul_pos hCpos (by linarith)
  have hXTwo : ∀ i, MemLp (X i) 2 μ := by
    intro i
    simpa only [ENNReal.ofReal_ofNat] using
      isSubGaussian_memLp_of_one_le (hSub i) (p := 2) (by norm_num)
  have hXThree : ∀ i, MemLp (X i) 3 μ := by
    intro i
    simpa only [ENNReal.ofReal_ofNat] using
      isSubGaussian_memLp_of_one_le (hSub i) (p := 3) (by norm_num)
  have hSTwo : MemLp S 2 μ := by
    dsimp [S]
    exact memLp_finset_sum Finset.univ fun i _ => (hXTwo i).const_mul (a i)
  have hSThree : MemLp S 3 μ := by
    dsimp [S]
    exact memLp_finset_sum Finset.univ fun i _ => (hXThree i).const_mul (a i)
  have hp_le_two : ENNReal.ofReal p ≤ 2 := by
    rw [← ENNReal.ofReal_ofNat]
    exact ENNReal.ofReal_le_ofReal hp2.le
  have hSP : MemLp S (ENNReal.ofReal p) μ := hSTwo.mono_exponent hp_le_two
  have hSecond : (∫ ω, S ω ^ 2 ∂μ) = Q := by
    simpa [S, Q] using weightedIndependentCenteredUnitVariance_secondMoment
      a hXTwo (fun i => (hCenter i).2) hVariance hIndep
  have hM2 : (∫ ω, |S ω| ^ (2 : ℝ) ∂μ) = Q := by
    simpa only [Real.rpow_two, sq_abs] using hSecond
  have hNormTwo : lpNorm S 2 μ = A := by
    rw [lpNorm_eq_integral_norm_rpow_toReal (by norm_num) (by norm_num)
      hSTwo.aestronglyMeasurable]
    simp only [ENNReal.toReal_ofNat, Real.norm_eq_abs]
    rw [hM2]
    norm_num [A, Real.sqrt_eq_rpow]
  have hUpperP : lpNorm S (ENNReal.ofReal p) μ ≤ A := by
    have he : eLpNorm S (ENNReal.ofReal p) μ ≤ eLpNorm S 2 μ :=
      eLpNorm_le_eLpNorm_of_exponent_le hp_le_two hSP.aestronglyMeasurable
    have hr : lpNorm S (ENNReal.ofReal p) μ ≤ lpNorm S 2 μ := by
      rw [← toReal_eLpNorm hSP.aestronglyMeasurable,
        ← toReal_eLpNorm hSTwo.aestronglyMeasurable]
      exact ENNReal.toReal_mono hSTwo.eLpNorm_ne_top he
    simpa [hNormTwo] using hr
  have hThreeKhin := (hKhin hSub hCenter hVariance hIndep a 3 (by norm_num)).2
  have hUpperThree : lpNorm S 3 μ ≤ B * A := by
    have hsqrt3 : Real.sqrt 3 ≤ 2 := by
      rw [Real.sqrt_le_iff]
      norm_num
    calc
      lpNorm S 3 μ ≤ C₀ * K * Real.sqrt 3 * A := by
        simpa only [S, K, A, ENNReal.ofReal_ofNat] using hThreeKhin
      _ ≤ C₀ * K * 2 * A := by gcongr
      _ ≤ (2 * C₀) * (1 + K) * A := by
        have hC₀nonneg : 0 ≤ C₀ := le_trans zero_le_one hC₀
        nlinarith [mul_nonneg hC₀nonneg hK, mul_nonneg hA hK]
      _ = B * A := by simp [B, C]
  let Mp : ℝ := ∫ ω, |S ω| ^ p ∂μ
  let M3 : ℝ := ∫ ω, |S ω| ^ (3 : ℝ) ∂μ
  have hMp : 0 ≤ Mp := by
    dsimp [Mp]
    exact integral_nonneg_of_ae (Filter.Eventually.of_forall fun ω => by positivity)
  have hM3 : 0 ≤ M3 := by
    dsimp [M3]
    exact integral_nonneg_of_ae (Filter.Eventually.of_forall fun ω => by positivity)
  have hNormP : lpNorm S (ENNReal.ofReal p) μ = Mp ^ (1 / p : ℝ) := by
    rw [lpNorm_eq_integral_norm_rpow_toReal
      (ENNReal.ofReal_ne_zero_iff.mpr hp0) ENNReal.ofReal_ne_top
      hSP.aestronglyMeasurable]
    rw [ENNReal.toReal_ofReal hp0.le]
    simp only [Real.norm_eq_abs, Mp, one_div]
  have hNormThree : lpNorm S 3 μ = M3 ^ (1 / 3 : ℝ) := by
    rw [lpNorm_eq_integral_norm_rpow_toReal (by norm_num) (by norm_num)
      hSThree.aestronglyMeasurable]
    simp only [ENNReal.toReal_ofNat, Real.norm_eq_abs]
    norm_num [M3]
  have hMpFactor : Mp ^ (1 / (3 - p) : ℝ) =
      (lpNorm S (ENNReal.ofReal p) μ) ^ alpha := by
    rw [hNormP, ← Real.rpow_mul hMp]
    congr 2
    dsimp [alpha]
    field_simp [hp0.ne', h3p.ne']
  have hM3Factor : M3 ^ ((2 - p) / (3 - p) : ℝ) =
      (lpNorm S 3 μ) ^ beta := by
    rw [hNormThree, ← Real.rpow_mul hM3]
    congr 2
    dsimp [beta]
    field_simp [h3p.ne']
  have hRaw := lpExtrapolationOfPosLtTwo hp0 hp2 hSP hSThree
  have hInterp : A ^ (2 : ℝ) ≤
      (lpNorm S (ENNReal.ofReal p) μ) ^ alpha *
        (lpNorm S 3 μ) ^ beta := by
    rw [hM2] at hRaw
    change Q ≤ _ at hRaw
    rw [show (∫ ω, |S ω| ^ p ∂μ) = Mp by rfl,
      show (∫ ω, |S ω| ^ (3 : ℝ) ∂μ) = M3 by rfl,
      hMpFactor, hM3Factor] at hRaw
    simpa [A, Real.rpow_two, Real.sq_sqrt hQ] using hRaw
  have hUpperThreePow : (lpNorm S 3 μ) ^ beta ≤ (B * A) ^ beta :=
    Real.rpow_le_rpow lpNorm_nonneg hUpperThree hbeta.le
  have hInterpB : A ^ (2 : ℝ) ≤
      (lpNorm S (ENNReal.ofReal p) μ) ^ alpha * (B * A) ^ beta :=
    hInterp.trans (mul_le_mul_of_nonneg_left hUpperThreePow
      (Real.rpow_nonneg lpNorm_nonneg _))
  have hLower := lower_of_interpolation_rpow hA lpNorm_nonneg hB
    halpha hbeta hab hInterpB
  have hLower' : B ^ (-(3 * (2 - p) / p)) * A ≤
      lpNorm S (ENNReal.ofReal p) μ := by
    convert hLower using 1
    congr 2
    dsimp [alpha, beta]
    field_simp [hp0.ne', h3p.ne']
  have hCoeff : 0 < B ^ (-(3 * (2 - p) / p)) :=
    Real.rpow_pos_of_pos hB _
  simpa only [K, S, A, B] using ⟨hCoeff, hLower', hUpperP⟩

end NumStability.HDP.Scalar.KhintchinePositiveMoments
