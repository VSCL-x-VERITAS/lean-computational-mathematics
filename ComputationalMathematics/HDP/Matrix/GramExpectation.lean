import ComputationalMathematics.HDP.Matrix.IsotropicRows
import ComputationalMathematics.HDP.Probability.TailExpectation

/-!
# Expected normalized Gram deviation

This file integrates the normalized Gram-matrix tail from Equation (4.22).
-/

noncomputable section

open Matrix MeasureTheory ProbabilityTheory Set
open scoped ENNReal

namespace NumStability.HDP.Matrix

/-- Independent isotropic sub-Gaussian rows have expected normalized Gram
deviation of order `K² (sqrt (n/m) + n/m)`.  Integrability is explicit under
the source module's finite-expectation convention. -/
theorem exists_expected_normalizedGramDeviation_bound_of_independent_isotropic_subGaussian_rows :
    ∃ D : ℝ, 0 < D ∧
      ∀ {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
        [IsProbabilityMeasure μ] {m n : ℕ}
        (_hm : 0 < m) (_hn : 0 < n)
        (A : Ω → Matrix (Fin m) (Fin n) ℝ) {K : ℝ},
        0 < K →
        (∀ i j, Measurable (fun ω => A ω i j)) →
        (∀ i j, MemLp (fun ω => A ω i j) 2 μ) →
        (∀ i, NumStability.HDP.Vector.Isotropy.IsIsotropic μ
          (fun j ω => A ω i j)) →
        (∀ i, NumStability.HDP.Vector.SubGaussian.PsiTwoNorm μ
          (fun j ω => A ω i j) ≤ ENNReal.ofReal K) →
        iIndepFun (fun i ω => fun j => A ω i j) μ →
        Integrable (fun ω =>
          NumStability.realMatrixOperatorNorm
            (((m : ℝ)⁻¹) • ((A ω).transpose * A ω) -
              (1 : Matrix (Fin n) (Fin n) ℝ))) μ →
        (∫ ω, NumStability.realMatrixOperatorNorm
            (((m : ℝ)⁻¹) • ((A ω).transpose * A ω) -
              (1 : Matrix (Fin n) (Fin n) ℝ)) ∂μ) ≤
          D * K ^ 2 *
            (Real.sqrt ((n : ℝ) / (m : ℝ)) + (n : ℝ) / (m : ℝ)) := by
  rcases exists_normalizedGramDeviation_tail_of_independent_isotropic_subGaussian_rows with
    ⟨C, hC, htail⟩
  let D : ℝ := 3 * C + 6 * C ^ 2
  have hD : 0 < D := by dsimp [D]; nlinarith [sq_nonneg C]
  refine ⟨D, hD, ?_⟩
  intro Ω _ μ _ m n hm hn A K hK hMeas hLp hIso hPsi hIndep hNormInt
  let Y : Ω → ℝ := fun ω =>
    NumStability.realMatrixOperatorNorm
      (((m : ℝ)⁻¹) • ((A ω).transpose * A ω) -
        (1 : Matrix (Fin n) (Fin n) ℝ))
  let a : ℝ := Real.sqrt ((n : ℝ) / (m : ℝ))
  let A₀ : ℝ := K ^ 2 * ((3 * C / 2) * a + 2 * C ^ 2 * a ^ 2)
  let B₀ : ℝ := K ^ 2 * ((C / 2) * a + 2 * C ^ 2 * a ^ 2)
  have hmR : (0 : ℝ) < m := by exact_mod_cast hm
  have hnR : (0 : ℝ) < n := by exact_mod_cast hn
  have hn1 : (1 : ℝ) ≤ (n : ℝ) := by
    exact_mod_cast (Nat.one_le_iff_ne_zero.mpr (Nat.ne_of_gt hn))
  have ha : 0 < a := by dsimp [a]; positivity
  have hsqrtm : 0 < Real.sqrt (m : ℝ) := Real.sqrt_pos.2 hmR
  have hsqrtn1 : 1 ≤ Real.sqrt (n : ℝ) := (Real.one_le_sqrt).2 hn1
  have ha_div : a = Real.sqrt (n : ℝ) / Real.sqrt (m : ℝ) := by
    dsimp [a]
    exact Real.sqrt_div (x := (n : ℝ)) (by positivity) (m : ℝ)
  have hinv_le_a : 1 / Real.sqrt (m : ℝ) ≤ a := by
    rw [ha_div]
    exact (div_le_div_iff_of_pos_right hsqrtm).2 hsqrtn1
  have ha_sq : a ^ 2 = (n : ℝ) / (m : ℝ) := by
    dsimp [a]
    exact Real.sq_sqrt (div_nonneg hnR.le hmR.le)
  have hinvm_le_asq : 1 / (m : ℝ) ≤ a ^ 2 := by
    rw [ha_sq]
    exact (div_le_div_iff_of_pos_right hmR).2 hn1
  have hB₀ : 0 < B₀ := by
    dsimp [B₀]
    have hKsq : 0 < K ^ 2 := sq_pos_of_pos hK
    positivity
  have htail' : ∀ {s : ℝ}, 0 < s →
      μ.real {ω | A₀ + B₀ * s < Y ω} ≤ 2 * Real.exp (-s) := by
    intro s hs
    let t : ℝ := Real.sqrt s
    let z : ℝ := t / Real.sqrt (m : ℝ)
    let δ : ℝ := C * (a + z)
    have ht : 0 < t := by dsimp [t]; exact Real.sqrt_pos.2 hs
    have ht_sq : t ^ 2 = s := by dsimp [t]; exact Real.sq_sqrt hs.le
    have hz0 : 0 ≤ z := by dsimp [z]; positivity
    have hδ0 : 0 ≤ δ := by dsimp [δ]; positivity
    have ht_le : t ≤ (1 + s) / 2 := by
      nlinarith [sq_nonneg (t - 1)]
    have hz_le : z ≤ a * ((1 + s) / 2) := by
      calc
        z = t * (1 / Real.sqrt (m : ℝ)) := by dsimp [z]; ring
        _ ≤ ((1 + s) / 2) * (1 / Real.sqrt (m : ℝ)) := by gcongr
        _ ≤ ((1 + s) / 2) * a := by gcongr
        _ = a * ((1 + s) / 2) := by ring
    have hz_sq : z ^ 2 ≤ a ^ 2 * s := by
      have hz_eq : z ^ 2 = s * (1 / (m : ℝ)) := by
        dsimp [z]
        rw [div_pow, ht_sq, Real.sq_sqrt hmR.le]
        field_simp
      rw [hz_eq]
      nlinarith [mul_le_mul_of_nonneg_left hinvm_le_asq hs.le]
    have hmax : max δ (δ ^ 2) ≤ δ + δ ^ 2 := by
      rw [max_le_iff]
      exact ⟨le_add_of_nonneg_right (sq_nonneg δ),
        le_add_of_nonneg_left hδ0⟩
    have hsq : (a + z) ^ 2 ≤ 2 * (a ^ 2 + z ^ 2) := by
      nlinarith [sq_nonneg (a - z)]
    have hδbound :
        δ + δ ^ 2 ≤
          C * (a + z) + 2 * C ^ 2 * (a ^ 2 + z ^ 2) := by
      have hδsq : δ ^ 2 ≤ 2 * C ^ 2 * (a ^ 2 + z ^ 2) := by
        have hmul := mul_le_mul_of_nonneg_left hsq (sq_nonneg C)
        dsimp [δ]
        nlinarith
      dsimp [δ]
      linarith
    have hlinear :
        C * (a + z) ≤ C * (a + a * ((1 + s) / 2)) := by gcongr
    have hquad :
        2 * C ^ 2 * (a ^ 2 + z ^ 2) ≤
          2 * C ^ 2 * (a ^ 2 + a ^ 2 * s) := by gcongr
    have hthreshold :
        K ^ 2 * max δ (δ ^ 2) ≤ A₀ + B₀ * s := by
      calc
        K ^ 2 * max δ (δ ^ 2) ≤ K ^ 2 * (δ + δ ^ 2) := by gcongr
        _ ≤ K ^ 2 *
            (C * (a + z) + 2 * C ^ 2 * (a ^ 2 + z ^ 2)) := by gcongr
        _ ≤ K ^ 2 *
            (C * (a + a * ((1 + s) / 2)) +
              2 * C ^ 2 * (a ^ 2 + a ^ 2 * s)) := by gcongr
        _ = A₀ + B₀ * s := by
          dsimp [A₀, B₀]
          ring
    have hsource := htail hm hn A hK hMeas hLp hIso hPsi hIndep ht.le
    have hsubset : {ω | A₀ + B₀ * s < Y ω} ⊆
        {ω | K ^ 2 * max δ (δ ^ 2) < Y ω} := by
      intro ω hω
      exact hthreshold.trans_lt hω
    have hmono := measureReal_mono hsubset (by
      exact ne_top_of_le_ne_top
        (show μ Set.univ ≠ (⊤ : ℝ≥0∞) by simp)
        (measure_mono (Set.subset_univ _)))
    refine hmono.trans ?_
    simpa [Y, δ, z, t, a, ht_sq] using hsource
  have hExpected :=
    NumStability.HDP.Probability.expectation_le_add_two_mul_of_exponential_upper_tail
      hNormInt hB₀ htail'
  change (∫ ω, Y ω ∂μ) ≤ D * K ^ 2 * (a + (n : ℝ) / (m : ℝ))
  rw [← ha_sq]
  calc
    (∫ ω, Y ω ∂μ) ≤ A₀ + 2 * B₀ := hExpected
    _ = K ^ 2 * ((5 * C / 2) * a + 6 * C ^ 2 * a ^ 2) := by
      dsimp [A₀, B₀]
      ring
    _ ≤ K ^ 2 * (D * a + D * a ^ 2) := by
      gcongr <;> dsimp [D] <;> nlinarith [sq_nonneg C]
    _ = D * K ^ 2 * (a + a ^ 2) := by ring

end NumStability.HDP.Matrix
