import ComputationalMathematics.HDP.Vector.FrameIsotropy
import ComputationalMathematics.HDP.Scalar.SubGaussian
import ComputationalMathematics.Analysis.MatrixAlgebra
import ComputationalMathematics.HDP.Vector.LinearMarginals
import ComputationalMathematics.HDP.Vector.SubGaussianFinite
import Mathlib.Analysis.SpecialFunctions.Log.NegMulLog

/-!
# Finite-support sub-Gaussian vectors

This module proves the entropy bound behind the fact that an isotropic vector
with dimension-free vector `ψ₂` norm needs exponentially many support points.
-/

noncomputable section

open ProbabilityTheory
open scoped BigOperators NNReal ENNReal

namespace NumStability.HDP.Vector.FiniteSupport


theorem entropy_le_log_card {N : ℕ} (hN : 0 < N)
    (p : Fin N → ℝ≥0) (hp : ∑ i, p i = 1) :
    ∑ i, Real.negMulLog (p i : ℝ) ≤ Real.log N := by
  have hNreal : (0 : ℝ) < N := by exact_mod_cast hN
  have hweight_nonneg : ∀ i ∈ (Finset.univ : Finset (Fin N)),
      0 ≤ (N : ℝ)⁻¹ := by
    intro _ _
    positivity
  have hweight_sum : ∑ _i : Fin N, (N : ℝ)⁻¹ = 1 := by
    rw [Finset.sum_const, Finset.card_univ, Fintype.card_fin, nsmul_eq_mul]
    field_simp
  have harg : ∀ i ∈ (Finset.univ : Finset (Fin N)),
      (N : ℝ) * (p i : ℝ) ∈ Set.Ici (0 : ℝ) := by
    intro i _
    exact mul_nonneg hNreal.le (p i).2
  have hj := Real.concaveOn_negMulLog.le_map_sum
    (t := (Finset.univ : Finset (Fin N)))
    (w := fun _i : Fin N ↦ (N : ℝ)⁻¹)
    (p := fun i ↦ (N : ℝ) * (p i : ℝ))
    hweight_nonneg hweight_sum harg
  have hmean :
      ∑ i : Fin N, (N : ℝ)⁻¹ • ((N : ℝ) * (p i : ℝ)) = (1 : ℝ) := by
    simp only [smul_eq_mul]
    calc
      ∑ i : Fin N, (N : ℝ)⁻¹ * ((N : ℝ) * (p i : ℝ)) =
          ∑ i : Fin N, (p i : ℝ) := by
            apply Finset.sum_congr rfl
            intro i _
            field_simp
      _ = 1 := by exact_mod_cast hp
  rw [hmean, Real.negMulLog_one] at hj
  simp only [smul_eq_mul] at hj
  have hexpand :
      ∑ i : Fin N, (N : ℝ)⁻¹ *
          Real.negMulLog ((N : ℝ) * (p i : ℝ)) =
        -Real.log N + ∑ i : Fin N, Real.negMulLog (p i : ℝ) := by
    simp_rw [Real.negMulLog_mul]
    rw [show (∑ i : Fin N, (N : ℝ)⁻¹ *
          ((p i : ℝ) * Real.negMulLog (N : ℝ) +
            (N : ℝ) * Real.negMulLog (p i : ℝ))) =
        ∑ i : Fin N,
          ((N : ℝ)⁻¹ * ((p i : ℝ) * Real.negMulLog (N : ℝ)) +
            (N : ℝ)⁻¹ * ((N : ℝ) * Real.negMulLog (p i : ℝ))) by
      apply Finset.sum_congr rfl
      intro i _
      ring]
    rw [Finset.sum_add_distrib]
    have hfirst :
        ∑ i : Fin N, (N : ℝ)⁻¹ *
            ((p i : ℝ) * Real.negMulLog (N : ℝ)) =
          -Real.log N := by
      have hpReal : ∑ i : Fin N, (p i : ℝ) = 1 := by exact_mod_cast hp
      calc
        ∑ i : Fin N, (N : ℝ)⁻¹ *
              ((p i : ℝ) * Real.negMulLog (N : ℝ)) =
            ∑ i : Fin N,
              ((N : ℝ)⁻¹ * Real.negMulLog (N : ℝ)) * (p i : ℝ) := by
                apply Finset.sum_congr rfl
                intro i _
                ring
        _ = ((N : ℝ)⁻¹ * Real.negMulLog (N : ℝ)) *
              (∑ i : Fin N, (p i : ℝ)) := by rw [Finset.mul_sum]
        _ = -Real.log N := by
          rw [hpReal]
          simp [Real.negMulLog, hNreal.ne']
    rw [hfirst]
    congr 1
    apply Finset.sum_congr rfl
    intro i _
    field_simp
  rw [hexpand] at hj
  linarith

theorem squarePoint_of_psiTwoGauge_le
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : MeasureTheory.Measure Ω} [MeasureTheory.IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ}
    (hX : Measurable X) (hK : 0 < K)
    (hle : NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X ≤
      ENNReal.ofReal K) :
    NumStability.HDP.Scalar.SubGaussian.SubGaussianSquarePoint μ X K := by
  open NumStability.HDP.Scalar.SubGaussian in
  by_cases hzero : PsiTwoGauge μ X = 0
  · have hAd := psiTwoAdmissible_of_gauge_zero hX hzero hK
    refine ⟨hX, hK, ?_, ?_⟩
    · simpa [ENNReal.toReal_ofReal hK.le] using hAd.2.2.2.1
    · simpa [ENNReal.toReal_ofReal hK.le] using hAd.2.2.2.2
  · have hfinite : PsiTwoGauge μ X < ∞ :=
      lt_of_le_of_lt hle ENNReal.ofReal_lt_top
    have hpos : 0 < PsiTwoGauge μ X := bot_lt_iff_ne_bot.mpr hzero
    have hPoint := psiTwoGauge_squarePoint_of_pos hX hfinite hpos
    have hAd : PsiTwoAdmissible μ X (PsiTwoGauge μ X) := by
      refine ⟨hX, ne_of_gt hpos, ne_of_lt hfinite, ?_, ?_⟩
      · simpa using hPoint.2.2.1
      · simpa using hPoint.2.2.2
    have hMono := psiTwoAdmissible_mono hAd hle
      ((ENNReal.ofReal_ne_zero_iff).2 hK) ENNReal.ofReal_ne_top
    refine ⟨hX, hK, ?_, ?_⟩
    · simpa [ENNReal.toReal_ofReal hK.le] using hMono.2.2.2.1
    · simpa [ENNReal.toReal_ofReal hK.le] using hMono.2.2.2.2

theorem isotropic_weighted_norm_sq
    {N n : ℕ} (p : Fin N → ℝ≥0) (hp : ∑ i, p i = 1)
    (x : Fin N → Fin n → ℝ)
    (hIso : NumStability.HDP.Vector.Isotropy.IsIsotropic
      (NumStability.HDP.Vector.FrameIsotropy.finiteWeightedVectorMeasure p hp x)
      (fun j : Fin n ↦ fun y : Fin n → ℝ ↦ y j)) :
    ∑ i, (p i : ℝ) * NumStability.vecNorm2Sq (x i) = (n : ℝ) := by
  have hcoord (j : Fin n) :
      ∑ i, (p i : ℝ) * (x i j) ^ 2 = 1 := by
    have h := NumStability.HDP.Vector.Isotropy.integral_sq_coordinate hIso j
    unfold NumStability.HDP.Vector.FrameIsotropy.finiteWeightedVectorMeasure at h
    rw [MeasureTheory.integral_map (measurable_of_countable _).aemeasurable] at h
    · rw [PMF.integral_eq_sum] at h
      simpa [NumStability.HDP.Vector.FrameIsotropy.finiteWeightedPMF] using h
    · apply Measurable.aestronglyMeasurable
      fun_prop
  calc
    ∑ i, (p i : ℝ) * NumStability.vecNorm2Sq (x i) =
        ∑ i, ∑ j, (p i : ℝ) * (x i j) ^ 2 := by
          apply Finset.sum_congr rfl
          intro i _
          rw [NumStability.vecNorm2Sq, Finset.mul_sum]
    _ = ∑ j, ∑ i, (p i : ℝ) * (x i j) ^ 2 := by
          rw [Finset.sum_comm]
    _ = ∑ _j : Fin n, (1 : ℝ) := by
          apply Finset.sum_congr rfl
          intro j _
          exact hcoord j
    _ = n := by simp

theorem atom_exp_norm_sq_le_two
    {N n : ℕ} (p : Fin N → ℝ≥0) (hp : ∑ i, p i = 1)
    (x : Fin N → Fin n → ℝ) {K : ℝ}
    (hPoint : ∀ u : Fin n → ℝ, NumStability.vecNorm2 u = 1 →
      NumStability.HDP.Scalar.SubGaussian.SubGaussianSquarePoint
        (NumStability.HDP.Vector.FrameIsotropy.finiteWeightedVectorMeasure p hp x)
        (NumStability.HDP.Vector.linearMarginal
          (fun j : Fin n ↦ fun y : Fin n → ℝ ↦ y j) u) K) :
    ∀ i, (p i : ℝ) * Real.exp (NumStability.vecNorm2Sq (x i) / K ^ 2) ≤ 2 := by
  intro i
  by_cases hxzero : x i = 0
  · have hpi : (p i : ℝ) ≤ 1 := by
      have hpile : p i ≤ ∑ j, p j :=
        Finset.single_le_sum (fun j _ ↦ (zero_le (p j))) (Finset.mem_univ i)
      rw [hp] at hpile
      exact_mod_cast hpile
    simp [hxzero, NumStability.vecNorm2Sq]
    linarith
  · have hxnorm : 0 < NumStability.vecNorm2 (x i) := by
      exact lt_of_le_of_ne (NumStability.vecNorm2_nonneg _) (Ne.symm (by
        intro h
        apply hxzero
        exact funext ((NumStability.vecNorm2_eq_zero_iff _).mp h)))
    let u : Fin n → ℝ := fun j ↦ (NumStability.vecNorm2 (x i))⁻¹ * x i j
    have hu : NumStability.vecNorm2 u = 1 := by
      exact NumStability.vecNorm2_inv_smul_self_of_pos (x i) hxnorm
    have hBound := (hPoint u hu).2.2.2
    unfold NumStability.HDP.Vector.FrameIsotropy.finiteWeightedVectorMeasure at hBound
    rw [MeasureTheory.integral_map (measurable_of_countable _).aemeasurable] at hBound
    · rw [PMF.integral_eq_sum] at hBound
      simp only [NumStability.HDP.Vector.FrameIsotropy.finiteWeightedPMF,
        PMF.ofFintype_apply, ENNReal.coe_toReal, smul_eq_mul] at hBound
      let g : Fin N → ℝ := fun j ↦
        (p j : ℝ) * Real.exp
          ((NumStability.HDP.Vector.linearMarginal
            (fun k : Fin n ↦ fun y : Fin n → ℝ ↦ y k) u (x j)) ^ 2 / K ^ 2)
      have hterm :
          (p i : ℝ) * Real.exp
              ((NumStability.HDP.Vector.linearMarginal
                (fun j : Fin n ↦ fun y : Fin n → ℝ ↦ y j) u (x i)) ^ 2 / K ^ 2) ≤
            ∑ j, (p j : ℝ) * Real.exp
              ((NumStability.HDP.Vector.linearMarginal
                (fun k : Fin n ↦ fun y : Fin n → ℝ ↦ y k) u (x j)) ^ 2 / K ^ 2) := by
        have hg : g i ≤ ∑ j, g j :=
          Finset.single_le_sum (s := Finset.univ) (f := g)
            (fun j _ ↦ by dsimp [g]; positivity) (Finset.mem_univ i)
        simpa [g] using hg
      have hinner :
          NumStability.HDP.Vector.linearMarginal
              (fun j : Fin n ↦ fun y : Fin n → ℝ ↦ y j) u (x i) =
            NumStability.vecNorm2 (x i) := by
        unfold NumStability.HDP.Vector.linearMarginal u
        rw [show (∑ j : Fin n, x i j *
              ((NumStability.vecNorm2 (x i))⁻¹ * x i j)) =
            ∑ j : Fin n,
              ((NumStability.vecNorm2 (x i))⁻¹ * x i j) * x i j by
          apply Finset.sum_congr rfl
          intro j _
          ring]
        exact NumStability.vecInnerProduct_inv_smul_self_eq_norm (x i) hxnorm
      calc
        (p i : ℝ) * Real.exp (NumStability.vecNorm2Sq (x i) / K ^ 2) =
            (p i : ℝ) * Real.exp
              ((NumStability.HDP.Vector.linearMarginal
                (fun j : Fin n ↦ fun y : Fin n → ℝ ↦ y j) u (x i)) ^ 2 /
                  K ^ 2) := by rw [hinner, NumStability.vecNorm2_sq]
        _ ≤ ∑ j, (p j : ℝ) * Real.exp
              ((NumStability.HDP.Vector.linearMarginal
                (fun k : Fin n ↦ fun y : Fin n → ℝ ↦ y k) u (x j)) ^ 2 / K ^ 2) := hterm
        _ ≤ 2 := hBound
    · apply Measurable.aestronglyMeasurable
      unfold NumStability.HDP.Vector.linearMarginal
      fun_prop


theorem weighted_norm_sq_div_le_log_two_add_entropy
    {N n : ℕ} (p : Fin N → ℝ≥0) (hp : ∑ i, p i = 1)
    (x : Fin N → Fin n → ℝ) {K : ℝ}
    (hAtom : ∀ i,
      (p i : ℝ) * Real.exp (NumStability.vecNorm2Sq (x i) / K ^ 2) ≤ 2) :
    ∑ i, (p i : ℝ) * (NumStability.vecNorm2Sq (x i) / K ^ 2) ≤
      Real.log 2 + ∑ i, Real.negMulLog (p i : ℝ) := by
  have hpoint (i : Fin N) :
      (p i : ℝ) * (NumStability.vecNorm2Sq (x i) / K ^ 2) ≤
        (p i : ℝ) * Real.log 2 + Real.negMulLog (p i : ℝ) := by
    by_cases hpi0 : (p i : ℝ) = 0
    · simp [hpi0]
    · have hpi : 0 < (p i : ℝ) := lt_of_le_of_ne (p i).2 (Ne.symm hpi0)
      have hexp :
          Real.exp (NumStability.vecNorm2Sq (x i) / K ^ 2) ≤
            2 / (p i : ℝ) := by
        exact (le_div_iff₀ hpi).2 (by simpa [mul_comm] using hAtom i)
      have hlog :
          NumStability.vecNorm2Sq (x i) / K ^ 2 ≤
            Real.log (2 / (p i : ℝ)) := by
        exact (Real.le_log_iff_exp_le (div_pos (by norm_num) hpi)).2 hexp
      have hlogdiv : Real.log (2 / (p i : ℝ)) =
          Real.log 2 - Real.log (p i : ℝ) := by
        rw [Real.log_div (by norm_num) hpi.ne']
      rw [hlogdiv] at hlog
      have hmul := mul_le_mul_of_nonneg_left hlog hpi.le
      rw [Real.negMulLog]
      linarith
  calc
    ∑ i, (p i : ℝ) * (NumStability.vecNorm2Sq (x i) / K ^ 2) ≤
        ∑ i, ((p i : ℝ) * Real.log 2 +
          Real.negMulLog (p i : ℝ)) := Finset.sum_le_sum (fun i _ ↦ hpoint i)
    _ = Real.log 2 + ∑ i, Real.negMulLog (p i : ℝ) := by
      rw [Finset.sum_add_distrib, ← Finset.sum_mul]
      have hpReal : ∑ i : Fin N, (p i : ℝ) = 1 := by exact_mod_cast hp
      rw [hpReal, one_mul]

theorem exp_dimension_div_sq_sub_log_two_le_card
    {N n : ℕ} (hN : 0 < N)
    (p : Fin N → ℝ≥0) (hp : ∑ i, p i = 1)
    (x : Fin N → Fin n → ℝ) {K : ℝ}
    (hIso : NumStability.HDP.Vector.Isotropy.IsIsotropic
      (NumStability.HDP.Vector.FrameIsotropy.finiteWeightedVectorMeasure p hp x)
      (fun j : Fin n ↦ fun y : Fin n → ℝ ↦ y j))
    (hPoint : ∀ u : Fin n → ℝ, NumStability.vecNorm2 u = 1 →
      NumStability.HDP.Scalar.SubGaussian.SubGaussianSquarePoint
        (NumStability.HDP.Vector.FrameIsotropy.finiteWeightedVectorMeasure p hp x)
        (NumStability.HDP.Vector.linearMarginal
          (fun j : Fin n ↦ fun y : Fin n → ℝ ↦ y j) u) K) :
    Real.exp ((n : ℝ) / K ^ 2 - Real.log 2) ≤ (N : ℝ) := by
  have hAtom := atom_exp_norm_sq_le_two p hp x hPoint
  have hWeighted := weighted_norm_sq_div_le_log_two_add_entropy p hp x hAtom
  have hIsoNorm := isotropic_weighted_norm_sq p hp x hIso
  have hsumdiv :
      ∑ i, (p i : ℝ) * (NumStability.vecNorm2Sq (x i) / K ^ 2) =
        (n : ℝ) / K ^ 2 := by
    calc
      ∑ i, (p i : ℝ) * (NumStability.vecNorm2Sq (x i) / K ^ 2) =
          (∑ i, (p i : ℝ) * NumStability.vecNorm2Sq (x i)) / K ^ 2 := by
            rw [Finset.sum_div]
            apply Finset.sum_congr rfl
            intro i _
            ring
      _ = (n : ℝ) / K ^ 2 := by rw [hIsoNorm]
  rw [hsumdiv] at hWeighted
  have hEntropy := entropy_le_log_card hN p hp
  have hlog : (n : ℝ) / K ^ 2 - Real.log 2 ≤ Real.log N := by
    linarith
  have hexp := Real.exp_le_exp.mpr hlog
  rw [Real.exp_log (by exact_mod_cast hN)] at hexp
  exact hexp

theorem exp_half_dimension_div_sq_le_card
    {N n : ℕ} (hN : 0 < N)
    (p : Fin N → ℝ≥0) (hp : ∑ i, p i = 1)
    (x : Fin N → Fin n → ℝ) {K : ℝ} (hK : 0 < K)
    (hlarge : 2 * K ^ 2 * Real.log 2 ≤ (n : ℝ))
    (hIso : NumStability.HDP.Vector.Isotropy.IsIsotropic
      (NumStability.HDP.Vector.FrameIsotropy.finiteWeightedVectorMeasure p hp x)
      (fun j : Fin n ↦ fun y : Fin n → ℝ ↦ y j))
    (hPoint : ∀ u : Fin n → ℝ, NumStability.vecNorm2 u = 1 →
      NumStability.HDP.Scalar.SubGaussian.SubGaussianSquarePoint
        (NumStability.HDP.Vector.FrameIsotropy.finiteWeightedVectorMeasure p hp x)
        (NumStability.HDP.Vector.linearMarginal
          (fun j : Fin n ↦ fun y : Fin n → ℝ ↦ y j) u) K) :
    Real.exp ((1 / (2 * K ^ 2)) * n) ≤ (N : ℝ) := by
  have hexact := exp_dimension_div_sq_sub_log_two_le_card hN p hp x hIso hPoint
  have hKsq : 0 < K ^ 2 := sq_pos_of_pos hK
  have hcompare : (1 / (2 * K ^ 2)) * (n : ℝ) ≤
      (n : ℝ) / K ^ 2 - Real.log 2 := by
    apply (le_sub_iff_add_le).2
    apply (le_div_iff₀ hKsq).2
    calc
      ((1 / (2 * K ^ 2)) * (n : ℝ) + Real.log 2) * K ^ 2 =
          (n : ℝ) / 2 + K ^ 2 * Real.log 2 := by field_simp
      _ ≤ (n : ℝ) := by linarith
  exact (Real.exp_le_exp.mpr hcompare).trans hexact

theorem exp_half_dimension_div_sq_le_card_of_vector_psiTwoNorm_le
    {N n : ℕ} (hN : 0 < N)
    (p : Fin N → ℝ≥0) (hp : ∑ i, p i = 1)
    (x : Fin N → Fin n → ℝ) {K : ℝ} (hK : 0 < K)
    (hlarge : 2 * K ^ 2 * Real.log 2 ≤ (n : ℝ))
    (hIso : NumStability.HDP.Vector.Isotropy.IsIsotropic
      (NumStability.HDP.Vector.FrameIsotropy.finiteWeightedVectorMeasure p hp x)
      (fun j : Fin n ↦ fun y : Fin n → ℝ ↦ y j))
    (hPsi : NumStability.HDP.Vector.SubGaussian.PsiTwoNorm
        (NumStability.HDP.Vector.FrameIsotropy.finiteWeightedVectorMeasure p hp x)
        (fun j : Fin n ↦ fun y : Fin n → ℝ ↦ y j) ≤ ENNReal.ofReal K) :
    Real.exp ((1 / (2 * K ^ 2)) * n) ≤ (N : ℝ) := by
  apply exp_half_dimension_div_sq_le_card hN p hp x hK hlarge hIso
  intro u hu
  apply squarePoint_of_psiTwoGauge_le
  · unfold NumStability.HDP.Vector.linearMarginal
    fun_prop
  · exact hK
  · exact (NumStability.HDP.Vector.SubGaussian.scalarPsiTwoNorm_le_vectorPsiTwoNorm
      u hu).trans hPsi

/-- For each fixed positive vector `ψ₂` bound, sufficiently high-dimensional
isotropic finite laws need exponentially many atoms. -/
theorem exists_exponential_support_lower_bound (K : ℝ) (hK : 0 < K) :
    ∃ c : ℝ, 0 < c ∧
      ∀ {N n : ℕ}, 0 < N →
        ∀ (p : Fin N → ℝ≥0) (hp : ∑ i, p i = 1)
          (x : Fin N → Fin n → ℝ),
          2 * K ^ 2 * Real.log 2 ≤ (n : ℝ) →
          NumStability.HDP.Vector.Isotropy.IsIsotropic
              (NumStability.HDP.Vector.FrameIsotropy.finiteWeightedVectorMeasure p hp x)
              (fun j : Fin n ↦ fun y : Fin n → ℝ ↦ y j) →
          NumStability.HDP.Vector.SubGaussian.PsiTwoNorm
              (NumStability.HDP.Vector.FrameIsotropy.finiteWeightedVectorMeasure p hp x)
              (fun j : Fin n ↦ fun y : Fin n → ℝ ↦ y j) ≤ ENNReal.ofReal K →
          Real.exp (c * n) ≤ (N : ℝ) := by
  refine ⟨1 / (2 * K ^ 2), by positivity, ?_⟩
  intro N n hN p hp x hlarge hIso hPsi
  exact exp_half_dimension_div_sq_le_card_of_vector_psiTwoNorm_le
    hN p hp x hK hlarge hIso hPsi

end NumStability.HDP.Vector.FiniteSupport
