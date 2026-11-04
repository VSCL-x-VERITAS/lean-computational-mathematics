import ComputationalMathematics.HDP.Vector.CovarianceEstimationBound
import ComputationalMathematics.HDP.Vector.CovarianceEstimation
import ComputationalMathematics.HDP.Scalar.SubGaussianDomination
import ComputationalMathematics.HDP.Vector.IsotropyMarginals
import ComputationalMathematics.HDP.Vector.SubGaussianL2
import ComputationalMathematics.HDP.Metric.EuclideanSphereCovering
import ComputationalMathematics.HDP.Probability.FiniteUnion
import ComputationalMathematics.HDP.Probability.TailExpectation
import ComputationalMathematics.HDP.Matrix.OperatorNormIntegrability
import ComputationalMathematics.HDP.Matrix.SubGaussianEntries

/-!
# Covariance estimation without an invertibility hypothesis

This file proves the source-facing covariance estimate directly from iid
samples and the relative marginal `ψ₂` hypothesis.  In particular it does not
introduce a full-dimensional whitening variable when the population
second-moment matrix is singular.
-/

noncomputable section

open Matrix MeasureTheory ProbabilityTheory Set
open scoped ENNReal BigOperators NNReal

namespace NumStability.HDP.Vector.Covariance

/-- The exact `ψ₂` gauge depends only on the law of a measurable random
variable. -/
theorem psiTwoGauge_eq_of_identDistrib
    {Ω Ω' : Type*} [MeasurableSpace Ω] [MeasurableSpace Ω']
    {μ : Measure Ω} {ν : Measure Ω'} {X : Ω → ℝ} {Y : Ω' → ℝ}
    (hX : Measurable X) (hY : Measurable Y)
    (h : IdentDistrib X Y μ ν) :
    NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X =
      NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge ν Y := by
  have hXLaw : HasLaw X (μ.map X) μ := ⟨hX.aemeasurable, rfl⟩
  simpa only [NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm] using
    NumStability.HDP.Scalar.SubGaussian.psiTwoNorm_eq_of_sameLaw
      hX hY hXLaw (h.hasLaw hXLaw)

/-- The `L²` norm of a unit marginal is bounded by the square root of the
operator norm of the vector's second-moment matrix. -/
theorem eLpNorm_linearMarginal_le_sqrt_secondMoment_operatorNorm
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    {n : ℕ} (hn : 0 < n) (Z : Fin n → Ω → ℝ)
    (hZ : ∀ j, MemLp (Z j) 2 μ)
    (x : EuclideanSpace ℝ (Fin n)) (hx : ‖x‖ = 1) :
    eLpNorm (NumStability.HDP.Vector.linearMarginal Z (fun j => x j)) 2 μ ≤
      ENNReal.ofReal (Real.sqrt (NumStability.realMatrixOperatorNorm
        (secondMomentMatrix μ Z))) := by
  let f : Ω → ℝ :=
    NumStability.HDP.Vector.linearMarginal Z (fun j => x j)
  have hf : MemLp f 2 μ := by
    dsimp [f, NumStability.HDP.Vector.linearMarginal]
    exact memLp_finset_sum Finset.univ (fun j _ => (hZ j).mul_const (x j))
  have hprod : ∀ a b, Integrable (fun ω => Z a ω * Z b ω) μ := by
    intro a b
    exact (hZ a).integrable_mul (hZ b)
  let Sigma : Matrix (Fin n) (Fin n) ℝ := secondMomentMatrix μ Z
  let q : ℝ := NumStability.realMatrixQuadraticForm Sigma x
  have hqint : (∫ ω, f ω ^ 2 ∂μ) = q := by
    have hmoment :=
      NumStability.HDP.Vector.Isotropy.marginalSecondMoment_eq_quadraticForm
        μ Z hprod (fun j => x j)
    have hq : (∑ a, ∑ b, x a * Sigma a b * x b) = q := by
      dsimp [q, NumStability.realMatrixQuadraticForm]
      rw [NumStability.HDP.Matrix.realMatrix_bilinear_eq_weighted_entry_sum]
      rw [Fintype.sum_prod_type]
      apply Finset.sum_congr rfl
      intro a _ha
      apply Finset.sum_congr rfl
      intro b _hb
      ring
    simpa [f, Sigma,
      NumStability.HDP.Vector.Isotropy.marginalSecondMoment] using
        hmoment.trans hq
  have hq0 : 0 ≤ q := by
    rw [← hqint]
    exact integral_nonneg (fun ω => sq_nonneg _)
  have hSigmaHerm : Sigma.IsHermitian := by
    rw [Matrix.IsHermitian]
    ext a b
    simp [Sigma, secondMomentMatrix, mul_comm]
  obtain ⟨_hop, _v, _hv, _hvq, hvmax⟩ :=
    NumStability.symmetricRealMatrixOperatorNorm_quadratic_characterization
      hn Sigma hSigmaHerm
  have hqle : q ≤ NumStability.realMatrixOperatorNorm Sigma := by
    exact (le_abs_self q).trans (hvmax x hx)
  have hnorm0 : 0 ≤ NumStability.realMatrixOperatorNorm Sigma := norm_nonneg _
  have hsqrt : Real.sqrt q ≤
      Real.sqrt (NumStability.realMatrixOperatorNorm Sigma) :=
    Real.sqrt_le_sqrt hqle
  have heq : eLpNorm f 2 μ = ENNReal.ofReal (Real.sqrt q) := by
    rw [hf.eLpNorm_eq_integral_rpow_norm (by norm_num) (by norm_num)]
    rw [show (∫ a, ‖f a‖ ^ (2 : ℝ≥0∞).toReal ∂μ) = q by
      simpa [Real.norm_eq_abs, sq_abs] using hqint]
    rw [show (2 : ℝ≥0∞).toReal⁻¹ = (1 / 2 : ℝ) by norm_num]
    rw [← Real.sqrt_eq_rpow]
  rw [heq]
  exact ENNReal.ofReal_le_ofReal hsqrt

/-- A Bernstein tail for averages of centered squares with a common upper
bound on the exact `ψ₂` gauges.  Unlike the normalized-coordinate lemma, the
common second moment `q` may be arbitrary (including zero). -/
theorem exists_centeredSquares_average_tail_of_psiTwo_le :
    ∃ c : ℝ, 0 < c ∧
      ∀ {ι Ω : Type*} [Fintype ι] [Nonempty ι] [MeasurableSpace Ω]
        {μ : Measure Ω} [IsProbabilityMeasure μ]
        (V : ι → Ω → ℝ) {q L : ℝ},
        0 < L →
        (∀ i, Measurable (V i)) →
        (∀ i, NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ (V i) ≤
          ENNReal.ofReal L) →
        (∀ i, (∫ ω, V i ω ^ 2 ∂μ) = q) →
        iIndepFun V μ →
        ∀ {u : ℝ}, 0 ≤ u →
          μ.real {ω |
            |∑ i, (Fintype.card ι : ℝ)⁻¹ * (V i ω ^ 2 - q)| ≥ u} ≤
            2 * Real.exp (-(c *
              min (u ^ 2 / L ^ 4) (u / L ^ 2) *
                (Fintype.card ι : ℝ))) := by
  rcases
      NumStability.HDP.Scalar.SubExponential.centeredSubExponentialPsiOneNorm_uniform with
    ⟨C, hC, hCenterGauge⟩
  let A : ℝ := 4096 * (Real.exp 1) ^ 4 * C
  let c : ℝ := min (1 / (4 * A ^ 2)) (1 / (2 * A))
  have hCpos : 0 < C := lt_of_lt_of_le zero_lt_one hC
  have hA : 0 < A := by dsimp [A]; positivity
  have hc : 0 < c := by dsimp [c]; positivity
  refine ⟨c, hc, ?_⟩
  intro ι Ω _ _ _ μ _ V q L hL hMeas hGauge hSecond hIndep u hu
  let W : ι → Ω → ℝ := fun i ω => V i ω ^ 2 - q
  have hFinite : ∀ i,
      NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ (V i) < ∞ := by
    intro i
    exact (hGauge i).trans_lt ENNReal.ofReal_lt_top
  have hWMeas : ∀ i, Measurable (W i) := by
    intro i
    dsimp [W]
    fun_prop
  have hWCenter : ∀ i, Integrable (W i) μ ∧ (∫ ω, W i ω ∂μ) = 0 := by
    intro i
    have hSquareFinite :
        NumStability.HDP.Scalar.SubExponential.PsiOneGauge μ
            (fun ω => V i ω ^ 2) < ∞ :=
      (NumStability.HDP.Scalar.SubExponential.psiOneGauge_sq_lt_top_iff
        (hMeas i)).2 (hFinite i)
    have hCenteredFinite :=
      (NumStability.HDP.Scalar.SubExponential.centeredSubExponentialPsiOneNorm
        (by fun_prop : Measurable (fun ω => V i ω ^ 2)) hSquareFinite).1
    have hWFinite :
        NumStability.HDP.Scalar.SubExponential.PsiOneGauge μ (W i) < ∞ := by
      simpa [W, hSecond i] using hCenteredFinite
    have hAbsInt :=
      (NumStability.HDP.Scalar.SubExponential.psiOneGaugeToMomentOne
        (hWMeas i) hWFinite).1
    have hWInt : Integrable (W i) μ := by
      apply (integrable_norm_iff (hWMeas i).aestronglyMeasurable).1
      simpa [Real.norm_eq_abs] using hAbsInt
    refine ⟨hWInt, ?_⟩
    have hSquareInt : Integrable (fun ω => V i ω ^ 2) μ := by
      have hAdd := hWInt.add (integrable_const q)
      have hEq : (fun ω => V i ω ^ 2) = (fun ω => W i ω + q) := by
        funext ω
        dsimp [W]
        ring
      rw [hEq]
      exact hAdd
    rw [show (∫ ω, W i ω ∂μ) =
        (∫ ω, V i ω ^ 2 ∂μ) - (∫ _ω : Ω, q ∂μ) by
      simpa [W] using integral_sub hSquareInt (integrable_const q)]
    simp [hSecond i]
  have hWGauge : ∀ i,
      NumStability.HDP.Scalar.SubExponential.PsiOneGauge μ (W i) ≤
        ENNReal.ofReal (C * L ^ 2) := by
    intro i
    have hbase := hCenterGauge (by fun_prop : Measurable (fun ω => V i ω ^ 2))
      ((NumStability.HDP.Scalar.SubExponential.psiOneGauge_sq_lt_top_iff
        (hMeas i)).2 (hFinite i))
    rw [hSecond i,
      NumStability.HDP.Scalar.SubExponential.psiOneGauge_sq_eq_psiTwoGauge_sq
        (hMeas i)] at hbase
    calc
      NumStability.HDP.Scalar.SubExponential.PsiOneGauge μ (W i) ≤
          ENNReal.ofReal C *
            NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ (V i) ^ 2 := by
        simpa [W] using hbase
      _ ≤ ENNReal.ofReal C * (ENNReal.ofReal L) ^ 2 := by
        gcongr
        exact hGauge i
      _ = ENNReal.ofReal (C * L ^ 2) := by
        rw [ENNReal.ofReal_mul hCpos.le, ENNReal.ofReal_pow hL.le]
  have hScale : 0 < C * L ^ 2 := mul_pos hCpos (sq_pos_of_pos hL)
  have hLinear : ∀ i,
      NumStability.HDP.Scalar.IndependentSums.Bernstein.SubExponentialLinearMGF
        μ (W i) (A * L ^ 2) := by
    intro i
    have h :=
      NumStability.HDP.Scalar.IndependentSums.Bernstein.psiOneGaugeToLinearMGF_le
        (hWMeas i) hScale (hWCenter i) (hWGauge i)
    simpa [A, mul_assoc] using h
  have hWIndep : iIndepFun W μ := by
    have hcomp := hIndep.comp (fun _i z => z ^ 2 - q) (fun _i => by fun_prop)
    simpa [W, Function.comp_def] using hcomp
  have hcardNat : 0 < Fintype.card ι := by
    rw [← Finset.card_univ]
    exact Finset.card_pos.mpr Finset.univ_nonempty
  have hraw :=
    NumStability.HDP.Scalar.IndependentSums.Bernstein.bernsteinAverageTail
      (K := A * L ^ 2) (mul_pos hA (sq_pos_of_pos hL)) hLinear hWIndep
      hcardNat hu
  have hcard : (0 : ℝ) < Fintype.card ι := by exact_mod_cast hcardNat
  have hquad :
      c * (u ^ 2 / L ^ 4) * (Fintype.card ι : ℝ) ≤
        u ^ 2 /
          (4 * ∑ _i : ι,
            ((Fintype.card ι : ℝ)⁻¹ * (A * L ^ 2)) ^ 2) := by
    have hcA : c ≤ 1 / (4 * A ^ 2) := by
      dsimp [c]
      exact min_le_left _ _
    rw [Finset.sum_const, Finset.card_univ, nsmul_eq_mul]
    have hL2 : 0 < L ^ 2 := sq_pos_of_pos hL
    have hL4 : 0 < L ^ 4 := pow_pos hL 4
    have hA2 : 0 < A ^ 2 := sq_pos_of_pos hA
    have hcoef : c * (4 * A ^ 2) ≤ 1 := by
      exact (le_div_iff₀ (mul_pos (by norm_num) hA2)).mp hcA
    have hmul := mul_le_mul_of_nonneg_right hcoef (sq_nonneg u)
    field_simp
    nlinarith
  have hlinearBranch :
      c * (u / L ^ 2) * (Fintype.card ι : ℝ) ≤
        u / (2 * ((Fintype.card ι : ℝ)⁻¹ * (A * L ^ 2))) := by
    have hcA : c ≤ 1 / (2 * A) := by
      dsimp [c]
      exact min_le_right _ _
    have hL2 : 0 < L ^ 2 := sq_pos_of_pos hL
    have hcoef : c * (2 * A) ≤ 1 := by
      exact (le_div_iff₀ (mul_pos (by norm_num) hA)).mp hcA
    have hmul := mul_le_mul_of_nonneg_right hcoef hu
    field_simp
    nlinarith
  have hexponent :
      c * min (u ^ 2 / L ^ 4) (u / L ^ 2) *
          (Fintype.card ι : ℝ) ≤
        min
          (u ^ 2 /
            (4 * ∑ _i : ι,
              ((Fintype.card ι : ℝ)⁻¹ * (A * L ^ 2)) ^ 2))
          (u / (2 * ((Fintype.card ι : ℝ)⁻¹ * (A * L ^ 2)))) := by
    apply le_min
    · calc
        c * min (u ^ 2 / L ^ 4) (u / L ^ 2) * (Fintype.card ι : ℝ) ≤
            c * (u ^ 2 / L ^ 4) * (Fintype.card ι : ℝ) := by
          gcongr
          exact min_le_left _ _
        _ ≤ _ := hquad
    · calc
        c * min (u ^ 2 / L ^ 4) (u / L ^ 2) * (Fintype.card ι : ℝ) ≤
            c * (u / L ^ 2) * (Fintype.card ι : ℝ) := by
          gcongr
          exact min_le_right _ _
        _ ≤ _ := hlinearBranch
  exact hraw.trans (mul_le_mul_of_nonneg_left
    (Real.exp_le_exp.mpr (neg_le_neg hexponent)) (by norm_num))

/-- Fixed-direction concentration for an empirical second-moment matrix with
independent rows having a common (not necessarily invertible) second-moment
matrix. -/
theorem exists_fixedDirection_sampleCovariance_tail :
    ∃ c : ℝ, 0 < c ∧
      ∀ {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
        [IsProbabilityMeasure μ] {m n : ℕ} [Nonempty (Fin m)]
        (X : Fin m → Ω → Fin n → ℝ)
        (Sigma : Matrix (Fin n) (Fin n) ℝ) {L : ℝ},
        0 < L →
        (∀ i j, Measurable (fun ω => X i ω j)) →
        (∀ i j, MemLp (fun ω => X i ω j) 2 μ) →
        (∀ i, secondMomentMatrix μ (fun j ω => X i ω j) = Sigma) →
        (∀ i, NumStability.HDP.Vector.SubGaussian.PsiTwoNorm μ
          (fun j ω => X i ω j) ≤ ENNReal.ofReal L) →
        iIndepFun X μ →
        ∀ (x : EuclideanSpace ℝ (Fin n)), ‖x‖ = 1 →
        ∀ {u : ℝ}, 0 ≤ u →
          μ.real {ω |
            |NumStability.realMatrixQuadraticForm
              (NumStability.HDP.Vector.Covariance.randomSampleCovariance X ω - Sigma) x| ≥ u} ≤
            2 * Real.exp (-(c *
              min (u ^ 2 / L ^ 4) (u / L ^ 2) * (m : ℝ))) := by
  rcases exists_centeredSquares_average_tail_of_psiTwo_le with ⟨c, hc, htail⟩
  refine ⟨c, hc, ?_⟩
  intro Ω _ μ _ m n _ X Sigma L hL hMeas hLp hSecond hPsi hIndep x hx u hu
  let V : Fin m → Ω → ℝ := fun i ω =>
    NumStability.HDP.Vector.linearMarginal (fun j ω' => X i ω' j)
      (fun j => x j) ω
  let q : ℝ := NumStability.realMatrixQuadraticForm Sigma x
  have hVMeas : ∀ i, Measurable (V i) := by
    intro i
    dsimp [V, NumStability.HDP.Vector.linearMarginal]
    fun_prop
  have hVGauge : ∀ i,
      NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ (V i) ≤
        ENNReal.ofReal L := by
    intro i
    have hxVec : NumStability.vecNorm2 (fun j => x j) = 1 := by
      rw [← NumStability.HDP.Vector.Spherical.norm_toLp_eq_vecNorm2]
      exact hx
    have hscalar :
        NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ (V i) ≤
          NumStability.HDP.Vector.SubGaussian.PsiTwoNorm μ
            (fun j ω => X i ω j) := by
      unfold NumStability.HDP.Vector.SubGaussian.PsiTwoNorm
      exact le_iSup
        (fun v : NumStability.HDP.Vector.SubGaussian.UnitDirection n =>
          NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
            (NumStability.HDP.Vector.linearMarginal
              (fun j ω => X i ω j) v.1)) ⟨(fun j => x j), hxVec⟩
    exact hscalar.trans (hPsi i)
  have hVSecond : ∀ i, (∫ ω, V i ω ^ 2 ∂μ) = q := by
    intro i
    have hprod : ∀ a b, Integrable
        (fun ω => X i ω a * X i ω b) μ := by
      intro a b
      exact (hLp i a).integrable_mul (hLp i b)
    have hmoment :=
      NumStability.HDP.Vector.Isotropy.marginalSecondMoment_eq_quadraticForm
        μ (fun j ω => X i ω j) hprod (fun j => x j)
    rw [hSecond i] at hmoment
    have hq : (∑ a, ∑ b, x a * Sigma a b * x b) = q := by
      dsimp [q, NumStability.realMatrixQuadraticForm]
      rw [NumStability.HDP.Matrix.realMatrix_bilinear_eq_weighted_entry_sum]
      rw [Fintype.sum_prod_type]
      apply Finset.sum_congr rfl
      intro a _ha
      apply Finset.sum_congr rfl
      intro b _hb
      ring
    simpa [V, NumStability.HDP.Vector.Isotropy.marginalSecondMoment] using
      hmoment.trans hq
  have hVIndep : iIndepFun V μ := by
    have hcomp := hIndep.comp
      (fun _i row => ∑ j, row j * x j) (fun _i => by fun_prop)
    simpa [V, Function.comp_def,
      NumStability.HDP.Vector.linearMarginal] using hcomp
  have hsource := htail V hL hVMeas hVGauge hVSecond hVIndep hu
  have hsampleForm : ∀ ω,
      NumStability.realMatrixQuadraticForm
          (NumStability.HDP.Vector.Covariance.randomSampleCovariance X ω) x =
        ∑ i, (m : ℝ)⁻¹ * V i ω ^ 2 := by
    intro ω
    let A : Matrix (Fin m) (Fin n) ℝ := fun i j => X i ω j
    have hmat :
        NumStability.HDP.Vector.Covariance.randomSampleCovariance X ω =
          (m : ℝ)⁻¹ • (A.transpose * A) := by
      ext a b
      simp only [NumStability.HDP.Vector.Covariance.randomSampleCovariance,
        NumStability.HDP.Vector.Covariance.sampleCovariance, A,
        Matrix.smul_apply, smul_eq_mul, Matrix.mul_apply,
        Matrix.transpose_apply]
    rw [hmat]
    have hq : NumStability.realMatrixQuadraticForm (A.transpose * A) x =
        ‖Matrix.toEuclideanLin A x‖ ^ 2 := by
      have h :=
        NumStability.HDP.Metric.realMatrixQuadraticForm_gram_sub_smul_one
          A 0 x
      simpa using h
    have hnorm : ‖Matrix.toEuclideanLin A x‖ ^ 2 = ∑ i, V i ω ^ 2 := by
      rw [show ‖Matrix.toEuclideanLin A x‖ =
          NumStability.vecNorm2 (fun i => V i ω) by
        rw [← NumStability.HDP.Vector.Spherical.norm_toLp_eq_vecNorm2]
        congr 1]
      exact NumStability.vecNorm2_sq (fun i => V i ω)
    rw [show NumStability.realMatrixQuadraticForm
        ((m : ℝ)⁻¹ • (A.transpose * A)) x =
          (m : ℝ)⁻¹ *
            NumStability.realMatrixQuadraticForm (A.transpose * A) x by
      rw [show NumStability.realMatrixQuadraticForm
          ((m : ℝ)⁻¹ • (A.transpose * A)) x =
            ∑ ij : Fin n × Fin n,
              (x ij.2 * x ij.1) *
                (((m : ℝ)⁻¹ • (A.transpose * A)) ij.1 ij.2) by
        exact NumStability.HDP.Matrix.realMatrix_bilinear_eq_weighted_entry_sum
          ((m : ℝ)⁻¹ • (A.transpose * A)) x x]
      rw [show NumStability.realMatrixQuadraticForm (A.transpose * A) x =
            ∑ ij : Fin n × Fin n,
              (x ij.2 * x ij.1) * (A.transpose * A) ij.1 ij.2 by
        exact NumStability.HDP.Matrix.realMatrix_bilinear_eq_weighted_entry_sum
          (A.transpose * A) x x]
      simp only [Matrix.smul_apply, smul_eq_mul, Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro ij _hij
      ring]
    rw [hq, hnorm, Finset.mul_sum]
  have hcentered : ∀ ω,
      ∑ i, (m : ℝ)⁻¹ * (V i ω ^ 2 - q) =
        (∑ i, (m : ℝ)⁻¹ * V i ω ^ 2) - q := by
    intro ω
    simp_rw [mul_sub]
    rw [Finset.sum_sub_distrib]
    rw [Finset.sum_const, Finset.card_univ, Fintype.card_fin,
      nsmul_eq_mul]
    have hmNat : 0 < m := Fin.pos_iff_nonempty.mpr inferInstance
    have hm : (m : ℝ) ≠ 0 := by exact_mod_cast (Nat.ne_of_gt hmNat)
    field_simp
  have hevent :
      {ω |
        |NumStability.realMatrixQuadraticForm
          (NumStability.HDP.Vector.Covariance.randomSampleCovariance X ω - Sigma) x| ≥ u} =
      {ω | |∑ i, (m : ℝ)⁻¹ * (V i ω ^ 2 - q)| ≥ u} := by
    ext ω
    simp only [Set.mem_setOf_eq]
    rw [show NumStability.realMatrixQuadraticForm
        (NumStability.HDP.Vector.Covariance.randomSampleCovariance X ω - Sigma) x =
          NumStability.realMatrixQuadraticForm
              (NumStability.HDP.Vector.Covariance.randomSampleCovariance X ω) x -
            NumStability.realMatrixQuadraticForm Sigma x by
      simp [NumStability.realMatrixQuadraticForm, map_sub, inner_sub_left]]
    rw [hsampleForm ω, show NumStability.realMatrixQuadraticForm Sigma x = q by rfl]
    rw [hcentered ω]
  rw [hevent]
  simpa only [Fintype.card_fin] using hsource

/-- A quarter-net union bound for a general empirical second-moment matrix.
The population matrix may be singular. -/
theorem exists_sampleCovarianceDeviation_tail_nine_pow :
    ∃ c : ℝ, 0 < c ∧
      ∀ {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
        [IsProbabilityMeasure μ] {m n : ℕ},
        0 < m → 0 < n →
        ∀ (X : Fin m → Ω → Fin n → ℝ)
          (Sigma : Matrix (Fin n) (Fin n) ℝ) {L : ℝ},
        0 < L →
        (∀ i j, Measurable (fun ω => X i ω j)) →
        (∀ i j, MemLp (fun ω => X i ω j) 2 μ) →
        (∀ i, secondMomentMatrix μ (fun j ω => X i ω j) = Sigma) →
        (∀ i, NumStability.HDP.Vector.SubGaussian.PsiTwoNorm μ
          (fun j ω => X i ω j) ≤ ENNReal.ofReal L) →
        iIndepFun X μ →
        ∀ {u : ℝ}, 0 ≤ u →
          μ.real {ω |
            2 * u < NumStability.realMatrixOperatorNorm
              (randomSampleCovariance X ω - Sigma)} ≤
            (9 ^ n : ℕ) *
              (2 * Real.exp (-(c *
                min (u ^ 2 / L ^ 4) (u / L ^ 2) * (m : ℝ)))) := by
  rcases exists_fixedDirection_sampleCovariance_tail with ⟨c, hc, hfixed⟩
  refine ⟨c, hc, ?_⟩
  intro Ω _ μ _ m n hm hn X Sigma L hL hMeas hLp hSecond hPsi hIndep u hu
  letI : Nonempty (Fin m) := ⟨⟨0, hm⟩⟩
  obtain ⟨N, hN, hNnonempty, hNcard⟩ :=
    NumStability.HDP.Metric.exists_quarterNet_card_le_nine_pow n hn
  let p : ℝ :=
    2 * Real.exp (-(c * min (u ^ 2 / L ^ 4) (u / L ^ 2) * (m : ℝ)))
  let E : EuclideanSpace ℝ (Fin n) → Set Ω := fun x =>
    {ω | |NumStability.realMatrixQuadraticForm
      (randomSampleCovariance X ω - Sigma) x| ≥ u}
  have hsingle : ∀ x ∈ N, μ.real (E x) ≤ p := by
    intro x hxN
    exact hfixed X Sigma hL hMeas hLp hSecond hPsi hIndep x (hN.1 x hxN) hu
  have hp : 0 ≤ p := by dsimp [p]; positivity
  have hSigmaHerm : Sigma.IsHermitian := by
    let i : Fin m := Classical.choice inferInstance
    rw [← hSecond i]
    rw [Matrix.IsHermitian]
    ext a b
    simp [secondMomentMatrix, mul_comm]
  have hsubset :
      {ω |
        2 * u < NumStability.realMatrixOperatorNorm
          (randomSampleCovariance X ω - Sigma)} ⊆
        ⋃ x ∈ N, E x := by
    intro ω hω
    let R : Matrix (Fin n) (Fin n) ℝ := randomSampleCovariance X ω - Sigma
    have hSampleHerm : (randomSampleCovariance X ω).IsHermitian := by
      rw [Matrix.IsHermitian]
      ext a b
      simp [randomSampleCovariance, sampleCovariance, mul_comm]
    have hR : R.IsHermitian := hSampleHerm.sub hSigmaHerm
    obtain ⟨_hop, v, hv, hvq, _hvmax⟩ :=
      NumStability.symmetricRealMatrixOperatorNorm_quadratic_characterization
        hn R hR
    have hattain : ∃ v : EuclideanSpace ℝ (Fin n), ‖v‖ = 1 ∧
        ‖NumStability.realMatrixContinuousLinearMap R‖ ≤
          |inner ℝ (NumStability.realMatrixContinuousLinearMap R v) v| := by
      refine ⟨v, hv, ?_⟩
      simpa [NumStability.realMatrixOperatorNorm,
        NumStability.realMatrixQuadraticForm,
        NumStability.realMatrixContinuousLinearMap] using hvq.symm.le
    obtain ⟨x, hxN, _hxmax, _hxupper, hxbound⟩ :=
      NumStability.HDP.Metric.exists_net_quadratic_abs_max_bounds
        (NumStability.realMatrixContinuousLinearMap R) (1 / 4 : ℝ) N
        (by norm_num) (by norm_num) hN hNnonempty hattain
    have hlarge : u < |NumStability.realMatrixQuadraticForm R x| := by
      have htwo :
          NumStability.realMatrixOperatorNorm R ≤
            2 * |NumStability.realMatrixQuadraticForm R x| := by
        norm_num at hxbound ⊢
        simpa [NumStability.realMatrixOperatorNorm,
          NumStability.realMatrixQuadraticForm,
          NumStability.realMatrixContinuousLinearMap] using hxbound
      change 2 * u < NumStability.realMatrixOperatorNorm R at hω
      nlinarith
    simp only [Set.mem_iUnion, E, Set.mem_setOf_eq]
    exact ⟨x, hxN, hlarge.le⟩
  have hmono := measureReal_mono hsubset (by
    exact ne_top_of_le_ne_top
      (show μ Set.univ ≠ (⊤ : ℝ≥0∞) by simp)
      (measure_mono (Set.subset_univ _)))
  refine hmono.trans ?_
  have hNcardR : (N.card : ℝ) ≤ ((9 ^ n : ℕ) : ℝ) := by exact_mod_cast hNcard
  exact (NumStability.HDP.Probability.measureReal_biUnion_le N E p hp hsingle).trans
    (by simpa [p] using mul_le_mul_of_nonneg_right hNcardR (by positivity :
      0 ≤ 2 * Real.exp (-(c * min (u ^ 2 / L ^ 4) (u / L ^ 2) * (m : ℝ)))))

/-- Uniform operator-norm tail after absorbing the quarter-net cardinality. -/
theorem exists_sampleCovarianceDeviation_tail :
    ∃ C : ℝ, 0 < C ∧
      ∀ {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
        [IsProbabilityMeasure μ] {m n : ℕ},
        0 < m → 0 < n →
        ∀ (X : Fin m → Ω → Fin n → ℝ)
          (Sigma : Matrix (Fin n) (Fin n) ℝ) {L : ℝ},
        0 < L →
        (∀ i j, Measurable (fun ω => X i ω j)) →
        (∀ i j, MemLp (fun ω => X i ω j) 2 μ) →
        (∀ i, secondMomentMatrix μ (fun j ω => X i ω j) = Sigma) →
        (∀ i, NumStability.HDP.Vector.SubGaussian.PsiTwoNorm μ
          (fun j ω => X i ω j) ≤ ENNReal.ofReal L) →
        iIndepFun X μ →
        ∀ {t : ℝ}, 0 ≤ t →
          let delta := C *
            (Real.sqrt ((n : ℝ) / (m : ℝ)) + t / Real.sqrt (m : ℝ))
          μ.real {ω |
            L ^ 2 * max delta (delta ^ 2) <
              NumStability.realMatrixOperatorNorm
                (randomSampleCovariance X ω - Sigma)} ≤
            2 * Real.exp (-(t ^ 2)) := by
  rcases exists_sampleCovarianceDeviation_tail_nine_pow with ⟨c, hc, htail⟩
  rcases NumStability.HDP.Matrix.exists_constant_absorbing_nine_pow_gram_tail hc with
    ⟨C, hC, habsorb⟩
  refine ⟨C, hC, ?_⟩
  intro Ω _ μ _ m n hm hn X Sigma L hL hMeas hLp hSecond hPsi hIndep t ht
  dsimp only
  let delta : ℝ := C *
    (Real.sqrt ((n : ℝ) / (m : ℝ)) + t / Real.sqrt (m : ℝ))
  let u : ℝ := L ^ 2 / 2 * max delta (delta ^ 2)
  have hdelta : 0 ≤ delta := by dsimp [delta]; positivity
  have hu : 0 ≤ u := by dsimp [u]; positivity
  have hbound := htail hm hn X Sigma hL hMeas hLp hSecond hPsi hIndep hu
  have hevent :
      {ω |
        L ^ 2 * max delta (delta ^ 2) <
          NumStability.realMatrixOperatorNorm
            (randomSampleCovariance X ω - Sigma)} =
      {ω |
        2 * u < NumStability.realMatrixOperatorNorm
          (randomSampleCovariance X ω - Sigma)} := by
    ext ω
    simp only [Set.mem_setOf_eq]
    dsimp [u]
    constructor <;> intro h <;> nlinarith
  rw [hevent]
  exact hbound.trans (habsorb hm hn hL ht)

/-- Expected operator-norm error for independent common-covariance rows with
a uniform vector `ψ₂` bound.  Entrywise square-integrability supplies the
integrability needed for the expectation; it is not an extra premise. -/
theorem exists_expected_sampleCovariance_error_bound :
    ∃ D : ℝ, 0 < D ∧
      ∀ {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
        [IsProbabilityMeasure μ] {m n : ℕ},
        0 < m → 0 < n →
        ∀ (X : Fin m → Ω → Fin n → ℝ)
          (Sigma : Matrix (Fin n) (Fin n) ℝ) {L : ℝ},
        0 < L →
        (∀ i j, Measurable (fun ω => X i ω j)) →
        (∀ i j, MemLp (fun ω => X i ω j) 2 μ) →
        (∀ i, secondMomentMatrix μ (fun j ω => X i ω j) = Sigma) →
        (∀ i, NumStability.HDP.Vector.SubGaussian.PsiTwoNorm μ
          (fun j ω => X i ω j) ≤ ENNReal.ofReal L) →
        iIndepFun X μ →
        (∫ ω, NumStability.realMatrixOperatorNorm
          (randomSampleCovariance X ω - Sigma) ∂μ) ≤
          D * L ^ 2 *
            (Real.sqrt ((n : ℝ) / (m : ℝ)) + (n : ℝ) / (m : ℝ)) := by
  rcases exists_sampleCovarianceDeviation_tail with ⟨C, hC, htail⟩
  let D : ℝ := 3 * C + 6 * C ^ 2
  have hD : 0 < D := by dsimp [D]; nlinarith [sq_nonneg C]
  refine ⟨D, hD, ?_⟩
  intro Ω _ μ _ m n hm hn X Sigma L hL hMeas hLp hSecond hPsi hIndep
  let Y : Ω → ℝ := fun ω => NumStability.realMatrixOperatorNorm
    (randomSampleCovariance X ω - Sigma)
  let a : ℝ := Real.sqrt ((n : ℝ) / (m : ℝ))
  let A0 : ℝ := L ^ 2 * ((3 * C / 2) * a + 2 * C ^ 2 * a ^ 2)
  let B0 : ℝ := L ^ 2 * ((C / 2) * a + 2 * C ^ 2 * a ^ 2)
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
  have hB0 : 0 < B0 := by
    dsimp [B0]
    have hLsq : 0 < L ^ 2 := sq_pos_of_pos hL
    positivity
  have htail' : ∀ {s : ℝ}, 0 < s →
      μ.real {ω | A0 + B0 * s < Y ω} ≤ 2 * Real.exp (-s) := by
    intro s hs
    let t : ℝ := Real.sqrt s
    let z : ℝ := t / Real.sqrt (m : ℝ)
    let delta : ℝ := C * (a + z)
    have ht : 0 < t := by dsimp [t]; exact Real.sqrt_pos.2 hs
    have ht_sq : t ^ 2 = s := by dsimp [t]; exact Real.sq_sqrt hs.le
    have hz0 : 0 ≤ z := by dsimp [z]; positivity
    have hdelta0 : 0 ≤ delta := by dsimp [delta]; positivity
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
    have hmax : max delta (delta ^ 2) ≤ delta + delta ^ 2 := by
      rw [max_le_iff]
      exact ⟨le_add_of_nonneg_right (sq_nonneg delta),
        le_add_of_nonneg_left hdelta0⟩
    have hsq : (a + z) ^ 2 ≤ 2 * (a ^ 2 + z ^ 2) := by
      nlinarith [sq_nonneg (a - z)]
    have hdeltabound : delta + delta ^ 2 ≤
        C * (a + z) + 2 * C ^ 2 * (a ^ 2 + z ^ 2) := by
      have hdeltasq : delta ^ 2 ≤ 2 * C ^ 2 * (a ^ 2 + z ^ 2) := by
        have hmul := mul_le_mul_of_nonneg_left hsq (sq_nonneg C)
        dsimp [delta]
        nlinarith
      dsimp [delta]
      linarith
    have hlinear : C * (a + z) ≤
        C * (a + a * ((1 + s) / 2)) := by gcongr
    have hquad : 2 * C ^ 2 * (a ^ 2 + z ^ 2) ≤
        2 * C ^ 2 * (a ^ 2 + a ^ 2 * s) := by gcongr
    have hthreshold :
        L ^ 2 * max delta (delta ^ 2) ≤ A0 + B0 * s := by
      calc
        L ^ 2 * max delta (delta ^ 2) ≤ L ^ 2 * (delta + delta ^ 2) := by gcongr
        _ ≤ L ^ 2 *
            (C * (a + z) + 2 * C ^ 2 * (a ^ 2 + z ^ 2)) := by gcongr
        _ ≤ L ^ 2 *
            (C * (a + a * ((1 + s) / 2)) +
              2 * C ^ 2 * (a ^ 2 + a ^ 2 * s)) := by gcongr
        _ = A0 + B0 * s := by dsimp [A0, B0]; ring
    have hsource := htail hm hn X Sigma hL hMeas hLp hSecond hPsi hIndep ht.le
    have hsubset : {ω | A0 + B0 * s < Y ω} ⊆
        {ω | L ^ 2 * max delta (delta ^ 2) < Y ω} := by
      intro ω hω
      exact hthreshold.trans_lt hω
    have hmono := measureReal_mono hsubset (by
      exact ne_top_of_le_ne_top
        (show μ Set.univ ≠ (⊤ : ℝ≥0∞) by simp)
        (measure_mono (Set.subset_univ _)))
    refine hmono.trans ?_
    simpa [Y, delta, z, t, a, ht_sq] using hsource
  have hYInt : Integrable Y μ := by
    apply NumStability.HDP.Matrix.integrable_realMatrixOperatorNorm_of_entries
      (fun ω => randomSampleCovariance X ω - Sigma)
    intro ij
    have hsum : Integrable
        (fun ω => ∑ i, X i ω ij.1 * X i ω ij.2) μ := by
      apply integrable_finset_sum
      intro i _hi
      exact (hLp i ij.1).integrable_mul (hLp i ij.2)
    have hentry := (hsum.const_mul (m : ℝ)⁻¹).sub (integrable_const (Sigma ij.1 ij.2))
    simpa [randomSampleCovariance, sampleCovariance, Matrix.sub_apply] using hentry
  have hExpected :=
    NumStability.HDP.Probability.expectation_le_add_two_mul_of_exponential_upper_tail
      hYInt hB0 htail'
  change (∫ ω, Y ω ∂μ) ≤ D * L ^ 2 * (a + (n : ℝ) / (m : ℝ))
  rw [← ha_sq]
  calc
    (∫ ω, Y ω ∂μ) ≤ A0 + 2 * B0 := hExpected
    _ = L ^ 2 * ((5 * C / 2) * a + 6 * C ^ 2 * a ^ 2) := by
      dsimp [A0, B0]
      ring
    _ ≤ L ^ 2 * (D * a + D * a ^ 2) := by
      gcongr <;> dsimp [D] <;> nlinarith [sq_nonneg C]
    _ = D * L ^ 2 * (a + a ^ 2) := by ring

/-- Source-facing iid covariance estimate.  The only distributional size
hypothesis is the relative marginal `ψ₂`/`L²` condition on the population
vector.  Identical distribution transports it, the common second moment, and
square-integrability to every sample row. -/
theorem exists_expected_sampleCovariance_error_bound_of_iid :
    ∃ D : ℝ, 0 < D ∧
      ∀ {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
        [IsProbabilityMeasure μ] {m n : ℕ},
        0 < m → 0 < n →
        ∀ (Z : Ω → Fin n → ℝ) (X : Fin m → Ω → Fin n → ℝ)
          (K : ℝ≥0),
        1 ≤ K →
        (∀ j, Measurable (fun ω => Z ω j)) →
        (∀ j, MemLp (fun ω => Z ω j) 2 μ) →
        (∀ i j, Measurable (fun ω => X i ω j)) →
        (∀ i, IdentDistrib (X i) Z μ μ) →
        iIndepFun X μ →
        NumStability.HDP.Vector.SubGaussian.SatisfiesPsiTwoL2Bound μ
          (fun j ω => Z ω j) K →
        (∫ ω, NumStability.realMatrixOperatorNorm
          (randomSampleCovariance X ω -
            secondMomentMatrix μ (fun j ω => Z ω j)) ∂μ) ≤
          D * (K : ℝ) ^ 2 *
            (Real.sqrt ((n : ℝ) / (m : ℝ)) + (n : ℝ) / (m : ℝ)) *
            NumStability.realMatrixOperatorNorm
              (secondMomentMatrix μ (fun j ω => Z ω j)) := by
  rcases exists_expected_sampleCovariance_error_bound with ⟨D, hD, hbound⟩
  refine ⟨D, hD, ?_⟩
  intro Ω _ μ _ m n hm hn Z X K hK hZMeas hZLp hXMeas hIdent hIndep hRel
  let Sigma : Matrix (Fin n) (Fin n) ℝ :=
    secondMomentMatrix μ (fun j ω => Z ω j)
  let s : ℝ := NumStability.realMatrixOperatorNorm Sigma
  have hs0 : 0 ≤ s := by dsimp [s]; exact norm_nonneg _
  have hXLp : ∀ i j, MemLp (fun ω => X i ω j) 2 μ := by
    intro i j
    have hcoord := (hIdent i).comp (measurable_pi_apply j)
    exact hcoord.symm.memLp_snd (hZLp j)
  have hSecond : ∀ i,
      secondMomentMatrix μ (fun j ω => X i ω j) = Sigma := by
    intro i
    ext a b
    have hprod := (hIdent i).comp
      ((measurable_pi_apply a).mul (measurable_pi_apply b))
    simpa [Sigma, secondMomentMatrix, Function.comp_def] using hprod.integral_eq
  have hPopulationPsi :
      NumStability.HDP.Vector.SubGaussian.PsiTwoNorm μ
          (fun j ω => Z ω j) ≤
        ENNReal.ofReal ((K : ℝ) * Real.sqrt s) := by
    unfold NumStability.HDP.Vector.SubGaussian.PsiTwoNorm
    refine iSup_le fun v => ?_
    let x : EuclideanSpace ℝ (Fin n) := WithLp.toLp 2 v.1
    have hx : ‖x‖ = 1 := by
      dsimp [x]
      rw [NumStability.HDP.Vector.Spherical.norm_toLp_eq_vecNorm2]
      exact v.2
    have hL2 :=
      eLpNorm_linearMarginal_le_sqrt_secondMoment_operatorNorm
        hn (fun j ω => Z ω j) hZLp x hx
    have hbase := hRel v.1
    calc
      NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
          (NumStability.HDP.Vector.linearMarginal
            (fun j ω => Z ω j) v.1) ≤
          (K : ℝ≥0∞) * eLpNorm
            (NumStability.HDP.Vector.linearMarginal
              (fun j ω => Z ω j) v.1) 2 μ := hbase
      _ ≤ (K : ℝ≥0∞) * ENNReal.ofReal (Real.sqrt s) := by
        apply mul_le_mul_right
        simpa [x, Sigma, s] using hL2
      _ = ENNReal.ofReal ((K : ℝ) * Real.sqrt s) := by
        rw [ENNReal.ofReal_mul (by positivity : 0 ≤ (K : ℝ))]
        simp
  have hSamplePsi : ∀ i,
      NumStability.HDP.Vector.SubGaussian.PsiTwoNorm μ
          (fun j ω => X i ω j) ≤
        ENNReal.ofReal ((K : ℝ) * Real.sqrt s) := by
    intro i
    unfold NumStability.HDP.Vector.SubGaussian.PsiTwoNorm
    refine iSup_le fun v => ?_
    let F : (Fin n → ℝ) → ℝ := fun z => ∑ j, z j * v.1 j
    have hF : Measurable F := by dsimp [F]; fun_prop
    have hLaw : IdentDistrib
        (NumStability.HDP.Vector.linearMarginal
          (fun j ω => X i ω j) v.1)
        (NumStability.HDP.Vector.linearMarginal
          (fun j ω => Z ω j) v.1) μ μ := by
      simpa [F, Function.comp_def,
        NumStability.HDP.Vector.linearMarginal] using (hIdent i).comp hF
    have hSampleMeas : Measurable
        (NumStability.HDP.Vector.linearMarginal
          (fun j ω => X i ω j) v.1) := by
      unfold NumStability.HDP.Vector.linearMarginal
      fun_prop
    have hPopulationMeas : Measurable
        (NumStability.HDP.Vector.linearMarginal
          (fun j ω => Z ω j) v.1) := by
      unfold NumStability.HDP.Vector.linearMarginal
      fun_prop
    change NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ
        (NumStability.HDP.Vector.linearMarginal
          (fun j ω => X i ω j) v.1) ≤
      ENNReal.ofReal ((K : ℝ) * Real.sqrt s)
    rw [psiTwoGauge_eq_of_identDistrib hSampleMeas hPopulationMeas hLaw]
    exact le_iSup
      (fun w : NumStability.HDP.Vector.SubGaussian.UnitDirection n =>
        NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
          (NumStability.HDP.Vector.linearMarginal
            (fun j ω => Z ω j) w.1)) v |>.trans hPopulationPsi
  by_cases hs : s = 0
  · have hSigmaZero : Sigma = 0 := by
      have hnorm : ‖NumStability.realMatrixContinuousLinearMap Sigma‖ = 0 := by
        simpa [s, NumStability.realMatrixOperatorNorm] using hs
      have hclm : NumStability.realMatrixContinuousLinearMap Sigma = 0 :=
        norm_eq_zero.mp hnorm
      apply Matrix.toEuclideanLin.injective
      apply LinearMap.ext
      intro x
      have happ := congrArg (fun T => T x) hclm
      simpa [NumStability.realMatrixContinuousLinearMap] using happ
    have hXzero : ∀ᵐ ω ∂μ, ∀ i j, X i ω j = 0 := by
      rw [ae_all_iff]
      intro i
      rw [ae_all_iff]
      intro j
      have hsqInt : Integrable (fun ω => X i ω j ^ 2) μ := by
        simpa [pow_two] using (hXLp i j).integrable_mul (hXLp i j)
      have hsqIntegral : (∫ ω, X i ω j ^ 2 ∂μ) = 0 := by
        have hentry := congrArg (fun M : Matrix (Fin n) (Fin n) ℝ => M j j)
          (hSecond i)
        rw [hSigmaZero] at hentry
        have : (∫ ω, X i ω j * X i ω j ∂μ) = 0 := by
          simpa [secondMomentMatrix] using hentry
        simpa [pow_two] using this
      have hsqZero : (fun ω => X i ω j ^ 2) =ᵐ[μ] 0 :=
        (integral_eq_zero_iff_of_nonneg (fun ω => sq_nonneg _) hsqInt).1
          hsqIntegral
      filter_upwards [hsqZero] with ω hω
      simpa using (sq_eq_zero_iff.mp hω)
    have herrorZero :
        (fun ω => NumStability.realMatrixOperatorNorm
          (randomSampleCovariance X ω - Sigma)) =ᵐ[μ] 0 := by
      filter_upwards [hXzero] with ω hω
      have hsample : randomSampleCovariance X ω = 0 := by
        ext a b
        simp [randomSampleCovariance, sampleCovariance, hω]
      rw [hsample, hSigmaZero, sub_zero]
      change ‖NumStability.realMatrixContinuousLinearMap (0 : Matrix (Fin n) (Fin n) ℝ)‖ = 0
      rw [show NumStability.realMatrixContinuousLinearMap
          (0 : Matrix (Fin n) (Fin n) ℝ) = 0 by
        ext x i
        simp [NumStability.realMatrixContinuousLinearMap]]
      exact norm_zero
    rw [show (∫ ω, NumStability.realMatrixOperatorNorm
        (randomSampleCovariance X ω - Sigma) ∂μ) = 0 by
      simpa using integral_congr_ae herrorZero]
    simp [s, Sigma, hs]
  · have hspos : 0 < s := lt_of_le_of_ne hs0 (Ne.symm hs)
    let L : ℝ := (K : ℝ) * Real.sqrt s
    have hKreal : 0 < (K : ℝ) := by
      exact_mod_cast (lt_of_lt_of_le zero_lt_one hK)
    have hL : 0 < L := mul_pos hKreal (Real.sqrt_pos.2 hspos)
    have hmain := hbound hm hn X Sigma hL hXMeas hXLp hSecond hSamplePsi hIndep
    change (∫ ω, NumStability.realMatrixOperatorNorm
        (randomSampleCovariance X ω - Sigma) ∂μ) ≤
      D * (K : ℝ) ^ 2 *
        (Real.sqrt ((n : ℝ) / (m : ℝ)) + (n : ℝ) / (m : ℝ)) * s
    calc
      (∫ ω, NumStability.realMatrixOperatorNorm
          (randomSampleCovariance X ω - Sigma) ∂μ) ≤
          D * L ^ 2 *
            (Real.sqrt ((n : ℝ) / (m : ℝ)) + (n : ℝ) / (m : ℝ)) := hmain
      _ = D * (K : ℝ) ^ 2 *
          (Real.sqrt ((n : ℝ) / (m : ℝ)) + (n : ℝ) / (m : ℝ)) * s := by
        dsimp [L]
        rw [mul_pow, Real.sq_sqrt hs0]
        ring

/-- Finite population coordinate second moments and identical full-vector
laws give a finite ordinary expectation of the actual sample error norm. -/
theorem integrable_sampleCovariance_error_of_iid
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} [IsFiniteMeasure μ]
    {m n : ℕ} (Z : Ω → Fin n → ℝ) (X : Fin m → Ω → Fin n → ℝ)
    (hZLp : ∀ j, MemLp (fun ω ↦ Z ω j) 2 μ)
    (hIdent : ∀ i, IdentDistrib (X i) Z μ μ) :
    Integrable (fun ω ↦ NumStability.realMatrixOperatorNorm
      (randomSampleCovariance X ω -
        secondMomentMatrix μ (fun j ω ↦ Z ω j))) μ := by
  have hXLp : ∀ i j, MemLp (fun ω ↦ X i ω j) 2 μ := by
    intro i j
    exact ((hIdent i).comp (measurable_pi_apply j)).symm.memLp_snd (hZLp j)
  apply NumStability.HDP.Matrix.integrable_realMatrixOperatorNorm_of_entries
  intro ij
  have hsum : Integrable (fun ω ↦ ∑ i, X i ω ij.1 * X i ω ij.2) μ :=
    integrable_finset_sum _ (fun i _ ↦ (hXLp i ij.1).integrable_mul (hXLp i ij.2))
  simpa only [randomSampleCovariance, sampleCovariance, Matrix.sub_apply] using
    (hsum.const_mul (m : ℝ)⁻¹).sub
      (integrable_const (secondMomentMatrix μ (fun j ω ↦ Z ω j) ij.1 ij.2))

/-- In dimension zero, both covariance matrices and their actual norm error
vanish; the zero error is integrable under every measure. -/
theorem sampleCovariance_error_zero_dimension
    {Ω : Type*} [MeasurableSpace Ω] (μ : Measure Ω) {m : ℕ}
    (Z : Ω → Fin 0 → ℝ) (X : Fin m → Ω → Fin 0 → ℝ) :
    secondMomentMatrix μ (fun j ω ↦ Z ω j) = 0 ∧
      (∀ ω, randomSampleCovariance X ω = 0) ∧
      NumStability.realMatrixOperatorNorm
        (secondMomentMatrix μ (fun j ω ↦ Z ω j)) = 0 ∧
      (∀ ω, NumStability.realMatrixOperatorNorm
        (randomSampleCovariance X ω -
          secondMomentMatrix μ (fun j ω ↦ Z ω j)) = 0) ∧
      Integrable (fun ω ↦ NumStability.realMatrixOperatorNorm
        (randomSampleCovariance X ω -
          secondMomentMatrix μ (fun j ω ↦ Z ω j))) μ ∧
      (∫ ω, NumStability.realMatrixOperatorNorm
        (randomSampleCovariance X ω -
          secondMomentMatrix μ (fun j ω ↦ Z ω j)) ∂μ) = 0 := by
  have hSigma : secondMomentMatrix μ (fun j ω ↦ Z ω j) = 0 :=
    Subsingleton.elim _ _
  have hSample (ω : Ω) : randomSampleCovariance X ω = 0 :=
    Subsingleton.elim _ _
  have hNorm (A : Matrix (Fin 0) (Fin 0) ℝ) :
      NumStability.realMatrixOperatorNorm A = 0 :=
    ContinuousLinearMap.opNorm_subsingleton _
  exact ⟨hSigma, hSample, hNorm _, fun _ ↦ hNorm _,
    by simpa only [hNorm] using (integrable_zero Ω ℝ μ),
    by simp only [hNorm, integral_zero]⟩

/-- The iid covariance estimate in every dimension, with the same uniform
constant as the positive-dimensional producer. -/
theorem exists_expected_sampleCovariance_error_bound_of_iid_all_dimensions :
    ∃ D : ℝ, 0 < D ∧
      ∀ {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
        [IsProbabilityMeasure μ] {m n : ℕ},
        0 < m →
        ∀ (Z : Ω → Fin n → ℝ) (X : Fin m → Ω → Fin n → ℝ)
          (K : ℝ≥0),
        1 ≤ K →
        (∀ j, Measurable (fun ω ↦ Z ω j)) →
        (∀ j, MemLp (fun ω ↦ Z ω j) 2 μ) →
        (∀ i j, Measurable (fun ω ↦ X i ω j)) →
        (∀ i, IdentDistrib (X i) Z μ μ) →
        iIndepFun X μ →
        NumStability.HDP.Vector.SubGaussian.SatisfiesPsiTwoL2Bound μ
          (fun j ω ↦ Z ω j) K →
        (∫ ω, NumStability.realMatrixOperatorNorm
          (randomSampleCovariance X ω -
            secondMomentMatrix μ (fun j ω ↦ Z ω j)) ∂μ) ≤
          D * (K : ℝ) ^ 2 *
            (Real.sqrt ((n : ℝ) / (m : ℝ)) + (n : ℝ) / (m : ℝ)) *
            NumStability.realMatrixOperatorNorm
              (secondMomentMatrix μ (fun j ω ↦ Z ω j)) := by
  obtain ⟨D, hD, hbound⟩ := exists_expected_sampleCovariance_error_bound_of_iid
  refine ⟨D, hD, ?_⟩
  intro Ω instΩ μ instμ m n hm Z X K hK hZMeas hZLp hXMeas hIdent hIndep hRel
  cases n with
  | zero =>
      obtain ⟨_, _, hSigmaNorm, _, _, hError⟩ :=
        sampleCovariance_error_zero_dimension μ Z X
      simp only [hError, hSigmaNorm, mul_zero, le_refl]
  | succ n =>
      exact hbound hm (Nat.succ_pos n) Z X K hK hZMeas hZLp hXMeas hIdent hIndep hRel

end NumStability.HDP.Vector.Covariance
