import ComputationalMathematics.HDP.Vector.NormConcentration
import ComputationalMathematics.HDP.Vector.SubGaussian
import ComputationalMathematics.HDP.Vector.LinearMarginals
import ComputationalMathematics.HDP.Vector.SphericalSubGaussian
import ComputationalMathematics.HDP.Metric.NormDeviationNet
import ComputationalMathematics.HDP.Metric.EuclideanSphereCovering
import ComputationalMathematics.HDP.Probability.FiniteUnion
import ComputationalMathematics.Analysis.SingularValues.ApproximateIsometries

/-!
# Fixed-direction concentration for matrices with isotropic sub-Gaussian rows

This module turns the reusable coordinate norm-concentration theorem into the
fixed-direction estimate used in the proof of Vershynin's Theorem 4.6.1.
-/

noncomputable section

open Matrix MeasureTheory ProbabilityTheory Set
open scoped ENNReal BigOperators

namespace NumStability.HDP.Matrix

/-- For a fixed unit direction, a matrix with independent isotropic
sub-Gaussian rows has the standard Bernstein tail for its normalized squared
action norm. The scale `K` uniformly bounds the vector `ψ₂` norms of the
rows. -/
theorem exists_fixedDirection_normalizedSquaredNorm_tail :
    ∃ c : ℝ, 0 < c ∧
      ∀ {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
        [IsProbabilityMeasure μ] {m n : ℕ} [Nonempty (Fin m)]
        (A : Ω → Matrix (Fin m) (Fin n) ℝ) {K : ℝ},
        0 < K →
        (∀ i j, Measurable (fun ω => A ω i j)) →
        (∀ i j, MemLp (fun ω => A ω i j) 2 μ) →
        (∀ i, NumStability.HDP.Vector.Isotropy.IsIsotropic μ
          (fun j ω => A ω i j)) →
        (∀ i, NumStability.HDP.Vector.SubGaussian.PsiTwoNorm μ
          (fun j ω => A ω i j) ≤ ENNReal.ofReal K) →
        iIndepFun (fun i ω => fun j => A ω i j) μ →
        ∀ (x : Fin n → ℝ), NumStability.vecNorm2 x = 1 →
        ∀ {u : ℝ}, 0 ≤ u →
          μ.real {ω |
            |NumStability.vecNorm2 ((A ω).mulVec x) ^ 2 / (m : ℝ) - 1| ≥ u} ≤
              2 * Real.exp (-(c * min (u ^ 2) u / K ^ 4 * (m : ℝ))) := by
  rcases NumStability.HDP.Vector.NormConcentration.normalizedSquaredEuclideanNorm_tail with
    ⟨c, hc, htail⟩
  refine ⟨c, hc, ?_⟩
  intro Ω instΩ μ instμ m n instm A K hK hMeas hLp hIso hPsi hIndep x hx u hu
  let X : Fin m → Ω → ℝ := fun i ω =>
    NumStability.HDP.Vector.linearMarginal (fun j ω' => A ω' i j) x ω
  have hXMeas : ∀ i, Measurable (X i) := by
    intro i
    dsimp [X, NumStability.HDP.Vector.linearMarginal]
    fun_prop
  have hScalarLe (i : Fin m) :
      NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ (X i) ≤
        NumStability.HDP.Vector.SubGaussian.PsiTwoNorm μ
          (fun j ω => A ω i j) := by
    unfold NumStability.HDP.Vector.SubGaussian.PsiTwoNorm
    exact le_iSup
      (fun v : NumStability.HDP.Vector.SubGaussian.UnitDirection n =>
        NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
          (NumStability.HDP.Vector.linearMarginal
            (fun j ω => A ω i j) v.1)) ⟨x, hx⟩
  have hXFinite : ∀ i,
      NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ (X i) < ∞ := by
    intro i
    have hle := (hScalarLe i).trans (hPsi i)
    exact hle.trans_lt ENNReal.ofReal_lt_top
  have hXSecond : ∀ i, (∫ ω, X i ω ^ 2 ∂μ) = 1 := by
    intro i
    have hbilinear :=
      NumStability.HDP.Vector.Isotropy.integral_linearMarginal_mul_linearMarginal
        (fun j => hLp i j) (hIso i) x x
    calc
      (∫ ω, X i ω ^ 2 ∂μ) =
          ∫ ω, X i ω * X i ω ∂μ := by
            congr 1
            funext ω
            rw [pow_two]
      _ = ∑ j, x j * x j := hbilinear
      _ = NumStability.vecNorm2 x ^ 2 := by
        rw [NumStability.vecNorm2_sq]
        simp only [NumStability.vecNorm2Sq, pow_two]
      _ = 1 := by rw [hx]; norm_num
  have hXIndep : iIndepFun X μ := by
    have hcomp := hIndep.comp
      (fun _i (row : Fin n → ℝ) => ∑ j, row j * x j)
      (fun _i => by fun_prop)
    simpa [X, Function.comp_def,
      NumStability.HDP.Vector.linearMarginal] using hcomp
  let Kx : ℝ :=
    NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ X
  have hKxle : Kx ≤ K := by
    dsimp [Kx, NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax]
    apply Finset.sup'_le Finset.univ_nonempty
    intro i _hi
    have hle := (hScalarLe i).trans (hPsi i)
    have hreal := ENNReal.toReal_mono ENNReal.ofReal_ne_top hle
    simpa [ENNReal.toReal_ofReal hK.le] using hreal
  have hKxnonneg : 0 ≤ Kx := by
    simpa [Kx] using
      (NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax_nonneg
        (μ := μ) (X := X))
  have hKxpos : 0 < Kx := by
    have hlower :=
      NumStability.HDP.Vector.NormConcentration.one_le_scaled_psiTwoNormMax_sq
        X hXMeas hXFinite hXSecond
    by_contra hnot
    have hzero : Kx = 0 := le_antisymm (le_of_not_gt hnot) hKxnonneg
    rw [show NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ X = Kx by rfl,
      hzero] at hlower
    norm_num at hlower
  have hraw := htail X hXMeas hXFinite hXSecond hXIndep hu
  have hevent :
      {ω |
        |NumStability.vecNorm2 ((A ω).mulVec x) ^ 2 / (m : ℝ) - 1| ≥ u} =
      {ω |
        |NumStability.vecNorm2 (fun i => X i ω) ^ 2 / (m : ℝ) - 1| ≥ u} := by
    ext ω
    have hv : (A ω).mulVec x = fun i => X i ω := by
      funext i
      simp [X, NumStability.HDP.Vector.linearMarginal, Matrix.mulVec, dotProduct]
    simp only [Set.mem_setOf_eq, hv]
  rw [hevent]
  refine hraw.trans ?_
  apply mul_le_mul_of_nonneg_left (Real.exp_le_exp.mpr ?_) (by norm_num)
  apply neg_le_neg
  have hmin : 0 ≤ min (u ^ 2) u := le_min (sq_nonneg u) hu
  have hpow : Kx ^ 4 ≤ K ^ 4 := by
    exact pow_le_pow_left₀ hKxnonneg hKxle 4
  have hratio : min (u ^ 2) u / K ^ 4 ≤ min (u ^ 2) u / Kx ^ 4 := by
    exact div_le_div_of_nonneg_left hmin (pow_pos hKxpos 4) hpow
  change c * min (u ^ 2) u / Kx ^ 4 * (m : ℝ) ≥
    c * min (u ^ 2) u / K ^ 4 * (m : ℝ)
  calc
    c * min (u ^ 2) u / K ^ 4 * (m : ℝ) =
        c * (min (u ^ 2) u / K ^ 4) * (m : ℝ) := by ring
    _ ≤ c * (min (u ^ 2) u / Kx ^ 4) * (m : ℝ) := by
      gcongr
    _ = c * min (u ^ 2) u / Kx ^ 4 * (m : ℝ) := by ring

/-- Sharp two-scale version of the fixed-direction estimate.  Unlike the
common-denominator corollary above, this retains Bernstein's quadratic
`K⁴` branch and linear `K²` branch separately; that distinction is what
produces the `K² max(δ,δ²)` scale in Theorem 4.6.1. -/
theorem exists_fixedDirection_normalizedSquaredNorm_tail_sharp :
    ∃ c : ℝ, 0 < c ∧
      ∀ {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
        [IsProbabilityMeasure μ] {m n : ℕ} [Nonempty (Fin m)]
        (A : Ω → Matrix (Fin m) (Fin n) ℝ) {K : ℝ},
        0 < K →
        (∀ i j, Measurable (fun ω => A ω i j)) →
        (∀ i j, MemLp (fun ω => A ω i j) 2 μ) →
        (∀ i, NumStability.HDP.Vector.Isotropy.IsIsotropic μ
          (fun j ω => A ω i j)) →
        (∀ i, NumStability.HDP.Vector.SubGaussian.PsiTwoNorm μ
          (fun j ω => A ω i j) ≤ ENNReal.ofReal K) →
        iIndepFun (fun i ω => fun j => A ω i j) μ →
        ∀ (x : Fin n → ℝ), NumStability.vecNorm2 x = 1 →
        ∀ {u : ℝ}, 0 ≤ u →
          μ.real {ω |
            |NumStability.vecNorm2 ((A ω).mulVec x) ^ 2 / (m : ℝ) - 1| ≥ u} ≤
              2 * Real.exp (-(c *
                min (u ^ 2 / K ^ 4) (u / K ^ 2) * (m : ℝ))) := by
  rcases NumStability.HDP.Vector.NormConcentration.centeredSquares_bernsteinAverageTailPsiTwo with
    ⟨c, hc, htail⟩
  refine ⟨c, hc, ?_⟩
  intro Ω instΩ μ instμ m n instm A K hK hMeas hLp hIso hPsi hIndep x hx u hu
  let X : Fin m → Ω → ℝ := fun i ω =>
    NumStability.HDP.Vector.linearMarginal (fun j ω' => A ω' i j) x ω
  have hXMeas : ∀ i, Measurable (X i) := by
    intro i
    dsimp [X, NumStability.HDP.Vector.linearMarginal]
    fun_prop
  have hScalarLe (i : Fin m) :
      NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ (X i) ≤
        NumStability.HDP.Vector.SubGaussian.PsiTwoNorm μ
          (fun j ω => A ω i j) := by
    unfold NumStability.HDP.Vector.SubGaussian.PsiTwoNorm
    exact le_iSup
      (fun v : NumStability.HDP.Vector.SubGaussian.UnitDirection n =>
        NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
          (NumStability.HDP.Vector.linearMarginal
            (fun j ω => A ω i j) v.1)) ⟨x, hx⟩
  have hXFinite : ∀ i,
      NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ (X i) < ∞ := by
    intro i
    have hle := (hScalarLe i).trans (hPsi i)
    exact hle.trans_lt ENNReal.ofReal_lt_top
  have hXSecond : ∀ i, (∫ ω, X i ω ^ 2 ∂μ) = 1 := by
    intro i
    have hbilinear :=
      NumStability.HDP.Vector.Isotropy.integral_linearMarginal_mul_linearMarginal
        (fun j => hLp i j) (hIso i) x x
    calc
      (∫ ω, X i ω ^ 2 ∂μ) =
          ∫ ω, X i ω * X i ω ∂μ := by
            congr 1
            funext ω
            rw [pow_two]
      _ = ∑ j, x j * x j := hbilinear
      _ = NumStability.vecNorm2 x ^ 2 := by
        rw [NumStability.vecNorm2_sq]
        simp only [NumStability.vecNorm2Sq, pow_two]
      _ = 1 := by rw [hx]; norm_num
  have hXIndep : iIndepFun X μ := by
    have hcomp := hIndep.comp
      (fun _i (row : Fin n → ℝ) => ∑ j, row j * x j)
      (fun _i => by fun_prop)
    simpa [X, Function.comp_def,
      NumStability.HDP.Vector.linearMarginal] using hcomp
  let Kx : ℝ := NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ X
  have hKxle : Kx ≤ K := by
    dsimp [Kx, NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax]
    apply Finset.sup'_le Finset.univ_nonempty
    intro i _hi
    have hle := (hScalarLe i).trans (hPsi i)
    have hreal := ENNReal.toReal_mono ENNReal.ofReal_ne_top hle
    simpa [ENNReal.toReal_ofReal hK.le] using hreal
  have hKxnonneg : 0 ≤ Kx := by
    simpa [Kx] using
      (NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax_nonneg
        (μ := μ) (X := X))
  have hKxpos : 0 < Kx := by
    have hlower :=
      NumStability.HDP.Vector.NormConcentration.one_le_scaled_psiTwoNormMax_sq
        X hXMeas hXFinite hXSecond
    by_contra hnot
    have hzero : Kx = 0 := le_antisymm (le_of_not_gt hnot) hKxnonneg
    rw [show NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ X = Kx by rfl,
      hzero] at hlower
    norm_num at hlower
  have hraw := htail X hXMeas hXFinite hXSecond hXIndep hu
  have hm : 0 < m := Fin.pos_iff_nonempty.mpr inferInstance
  simp only [Fintype.card_fin,
    NumStability.HDP.Vector.NormConcentration.centeredSquareAverage_eq_normSq_div_sub_one
      hm] at hraw
  have hevent :
      {ω |
        |NumStability.vecNorm2 ((A ω).mulVec x) ^ 2 / (m : ℝ) - 1| ≥ u} =
      {ω |
        |NumStability.vecNorm2 (fun i => X i ω) ^ 2 / (m : ℝ) - 1| ≥ u} := by
    ext ω
    have hv : (A ω).mulVec x = fun i => X i ω := by
      funext i
      simp [X, NumStability.HDP.Vector.linearMarginal, Matrix.mulVec, dotProduct]
    simp only [Set.mem_setOf_eq, hv]
  rw [hevent]
  refine hraw.trans ?_
  apply mul_le_mul_of_nonneg_left (Real.exp_le_exp.mpr ?_) (by norm_num)
  apply neg_le_neg
  have hquad : u ^ 2 / K ^ 4 ≤ u ^ 2 / Kx ^ 4 := by
    apply div_le_div_of_nonneg_left (sq_nonneg u) (pow_pos hKxpos 4)
    exact pow_le_pow_left₀ hKxnonneg hKxle 4
  have hlinear : u / K ^ 2 ≤ u / Kx ^ 2 := by
    apply div_le_div_of_nonneg_left hu (sq_pos_of_pos hKxpos)
    exact pow_le_pow_left₀ hKxnonneg hKxle 2
  have hmin :
      min (u ^ 2 / K ^ 4) (u / K ^ 2) ≤
        min (u ^ 2 / Kx ^ 4) (u / Kx ^ 2) :=
    min_le_min hquad hlinear
  change c * min (u ^ 2 / Kx ^ 4) (u / Kx ^ 2) * (m : ℝ) ≥
    c * min (u ^ 2 / K ^ 4) (u / K ^ 2) * (m : ℝ)
  gcongr

/-- Normalizing a centered Gram matrix by the positive row count scales its
real operator norm by the reciprocal row count. -/
theorem realMatrixOperatorNorm_normalizedGram_eq
    {m n : ℕ} (hm : 0 < m) (A : Matrix (Fin m) (Fin n) ℝ) :
    NumStability.realMatrixOperatorNorm
        (((m : ℝ)⁻¹) • (A.transpose * A) -
          (1 : Matrix (Fin n) (Fin n) ℝ)) =
      (m : ℝ)⁻¹ *
        NumStability.realMatrixOperatorNorm
          (A.transpose * A - (m : ℝ) • (1 : Matrix (Fin n) (Fin n) ℝ)) := by
  have hmreal : 0 < (m : ℝ) := by exact_mod_cast hm
  have hmat :
      ((m : ℝ)⁻¹) • (A.transpose * A) -
          (1 : Matrix (Fin n) (Fin n) ℝ) =
        ((m : ℝ)⁻¹) •
          (A.transpose * A -
            (m : ℝ) • (1 : Matrix (Fin n) (Fin n) ℝ)) := by
    ext i j
    simp only [Matrix.sub_apply, Matrix.smul_apply, smul_eq_mul]
    field_simp
  rw [hmat]
  have hclm : NumStability.realMatrixContinuousLinearMap
      (((m : ℝ)⁻¹) •
        (A.transpose * A -
          (m : ℝ) • (1 : Matrix (Fin n) (Fin n) ℝ))) =
      ((m : ℝ)⁻¹) • NumStability.realMatrixContinuousLinearMap
        (A.transpose * A -
          (m : ℝ) • (1 : Matrix (Fin n) (Fin n) ℝ)) := by
    ext x i
    simp [NumStability.realMatrixContinuousLinearMap, Matrix.mulVec, dotProduct,
      Finset.mul_sum]
  unfold NumStability.realMatrixOperatorNorm
  rw [hclm, norm_smul, Real.norm_eq_abs,
    abs_of_pos (inv_pos.mpr hmreal)]

/-- A normalized Gram-deviation bound yields the corresponding two-sided
extreme-singular-value bounds.  This is the deterministic implication from
Equation (4.22) to Equation (4.21). -/
theorem extremeSingularValueBounds_of_normalizedGramDeviation
    {m n : ℕ} (hm : 0 < m)
    (A : Matrix (Fin m) (Fin (n + 1)) ℝ) {K δ : ℝ}
    (hK : 1 ≤ K) (hδ : 0 < δ)
    (hGram : NumStability.realMatrixOperatorNorm
      (((m : ℝ)⁻¹) • (A.transpose * A) - 1) ≤
        K ^ 2 * max δ (δ ^ 2)) :
    Real.sqrt (m : ℝ) - Real.sqrt (m : ℝ) * (K ^ 2 * δ) ≤
        NumStability.rectCourantFischerSingularValue A (Fin.last n) ∧
      NumStability.rectCourantFischerSingularValue A (Fin.last n) ≤
        NumStability.rectCourantFischerSingularValue A (0 : Fin (n + 1)) ∧
      NumStability.rectCourantFischerSingularValue A (0 : Fin (n + 1)) ≤
        Real.sqrt (m : ℝ) + Real.sqrt (m : ℝ) * (K ^ 2 * δ) := by
  have hmreal : 0 < (m : ℝ) := by exact_mod_cast hm
  have hsqrtm : 0 < Real.sqrt (m : ℝ) := Real.sqrt_pos.2 hmreal
  let η : ℝ := K ^ 2 * δ
  have hη : 0 < η :=
    mul_pos (sq_pos_of_pos (lt_of_lt_of_le zero_lt_one hK)) hδ
  let B : Matrix (Fin m) (Fin (n + 1)) ℝ :=
    (Real.sqrt (m : ℝ))⁻¹ • A
  have hBGram : B.transpose * B - 1 =
      ((m : ℝ)⁻¹) • (A.transpose * A) - 1 := by
    ext i j
    simp only [B, Matrix.sub_apply, Matrix.mul_apply, Matrix.transpose_apply,
      Matrix.smul_apply, smul_eq_mul, Matrix.one_apply]
    have hsquare := Real.sq_sqrt hmreal.le
    congr 1
    rw [Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro k _hk
    field_simp
    rw [hsquare]
    ring
  have hscale : K ^ 2 * max δ (δ ^ 2) ≤ max η (η ^ 2) := by
    have hKsqOne : 1 ≤ K ^ 2 := by nlinarith
    have hKpow : K ^ 2 ≤ K ^ 4 := by
      calc
        K ^ 2 = K ^ 2 * 1 := by ring
        _ ≤ K ^ 2 * K ^ 2 :=
          mul_le_mul_of_nonneg_left hKsqOne (sq_nonneg K)
        _ = K ^ 4 := by ring
    rw [mul_max_of_nonneg δ (δ ^ 2) (sq_nonneg K)]
    apply max_le
    · exact le_max_left η (η ^ 2)
    · calc
        K ^ 2 * δ ^ 2 ≤ K ^ 4 * δ ^ 2 :=
          mul_le_mul_of_nonneg_right hKpow (sq_nonneg δ)
        _ = η ^ 2 := by simp [η]; ring
        _ ≤ max η (η ^ 2) := le_max_right _ _
  have hBbound : NumStability.realMatrixOperatorNorm (B.transpose * B - 1) ≤
      max η (η ^ 2) := by
    rw [hBGram]
    exact hGram.trans hscale
  have happrox :=
    (NumStability.approximateIsometry_of_gramDeviation B hη hBbound).1
  have hBaction (x : EuclideanSpace ℝ (Fin (n + 1))) :
      ‖Matrix.toEuclideanLin B x‖ =
        (Real.sqrt (m : ℝ))⁻¹ * ‖Matrix.toEuclideanLin A x‖ := by
    change ‖WithLp.toLp 2 (B.mulVec x)‖ = _
    have hv : B.mulVec x = (Real.sqrt (m : ℝ))⁻¹ • A.mulVec x := by
      ext i
      simp only [B, Matrix.mulVec, dotProduct, Matrix.smul_apply, smul_eq_mul,
        Pi.smul_apply]
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro j _hj
      ring
    rw [hv, WithLp.toLp_smul, norm_smul]
    rw [Real.norm_eq_abs, abs_inv, abs_of_pos hsqrtm]
    rfl
  have hlower (x : EuclideanSpace ℝ (Fin (n + 1))) :
      (Real.sqrt (m : ℝ) - Real.sqrt (m : ℝ) * η) * ‖x‖ ≤
        ‖Matrix.toEuclideanLin A x‖ := by
    have h := (happrox x).1
    rw [hBaction, inv_mul_eq_div] at h
    have h' := (le_div_iff₀ hsqrtm).1 h
    nlinarith
  have hupper (x : EuclideanSpace ℝ (Fin (n + 1))) :
      ‖Matrix.toEuclideanLin A x‖ ≤
        (Real.sqrt (m : ℝ) + Real.sqrt (m : ℝ) * η) * ‖x‖ := by
    have h := (happrox x).2
    rw [hBaction, inv_mul_eq_div] at h
    have h' := (div_le_iff₀ hsqrtm).1 h
    nlinarith
  have hOptimal :=
    NumStability.rectCourantFischer_extremeSingularValues_areOptimalBounds A
  refine ⟨hOptimal.2.2 _ hlower,
    NumStability.rectCourantFischerSingularValue_antitone A
      (Fin.zero_le (Fin.last n)), hOptimal.2.1 _ hupper⟩

/-- A quarter-net union bound upgrades fixed-direction concentration to an
operator-norm tail for the centered (unnormalized) Gram matrix.  Keeping the
factor `m` outside the matrix avoids introducing a square-root scaling merely
for this probabilistic reduction. -/
theorem exists_gramDeviation_tail_of_independent_isotropic_subGaussian_rows :
    ∃ c : ℝ, 0 < c ∧
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
        ∀ (N : Finset (EuclideanSpace ℝ (Fin n))),
          NumStability.HDP.Metric.IsFiniteUnitSphereNet (1 / 4 : ℝ) N →
          N.Nonempty →
          ∀ {u : ℝ}, 0 ≤ u →
            μ.real {ω |
              2 * (m : ℝ) * u <
                NumStability.realMatrixOperatorNorm
                  ((A ω).transpose * A ω -
                    (m : ℝ) • (1 : Matrix (Fin n) (Fin n) ℝ))} ≤
              N.card *
                (2 * Real.exp (-(c *
                  min (u ^ 2 / K ^ 4) (u / K ^ 2) * (m : ℝ)))) := by
  rcases exists_fixedDirection_normalizedSquaredNorm_tail_sharp with
    ⟨c, hc, hfixed⟩
  refine ⟨c, hc, ?_⟩
  intro Ω instΩ μ instμ m n hm hn A K hK hMeas hLp hIso hPsi hIndep
    N hN hNnonempty u hu
  letI : Nonempty (Fin m) := ⟨⟨0, hm⟩⟩
  let p : ℝ :=
    2 * Real.exp (-(c * min (u ^ 2 / K ^ 4) (u / K ^ 2) * (m : ℝ)))
  let E : EuclideanSpace ℝ (Fin n) → Set Ω := fun x =>
    {ω | |NumStability.vecNorm2 ((A ω).mulVec (fun j => x j)) ^ 2 /
      (m : ℝ) - 1| ≥ u}
  have hsingle : ∀ x ∈ N, μ.real (E x) ≤ p := by
    intro x hxN
    have hx : NumStability.vecNorm2 (fun j => x j) = 1 := by
      rw [← NumStability.HDP.Vector.Spherical.norm_toLp_eq_vecNorm2]
      simpa using hN.1 x hxN
    exact hfixed A hK hMeas hLp hIso hPsi hIndep
      (fun j => x j) hx hu
  have hp : 0 ≤ p := by
    dsimp [p]
    positivity
  have hsubset :
      {ω |
        2 * (m : ℝ) * u <
          NumStability.realMatrixOperatorNorm
            ((A ω).transpose * A ω -
              (m : ℝ) • (1 : Matrix (Fin n) (Fin n) ℝ))} ⊆
        ⋃ x ∈ N, E x := by
    intro ω hω
    obtain ⟨x, hxN, _hxmax, hall⟩ :=
      NumStability.HDP.Metric.exists_net_norm_sq_deviation_max_bounds
        hn (A ω) (m : ℝ) (1 / 4 : ℝ) N (by norm_num) (by norm_num)
          hN hNnonempty
    let R : Matrix (Fin n) (Fin n) ℝ :=
      (A ω).transpose * A ω -
        (m : ℝ) • (1 : Matrix (Fin n) (Fin n) ℝ)
    have hR : R.IsHermitian := by
      have hgram : ((A ω).transpose * A ω).IsHermitian := by
        simpa using Matrix.isHermitian_conjTranspose_mul_self (A ω)
      have hone :
          ((m : ℝ) • (1 : Matrix (Fin n) (Fin n) ℝ)).IsHermitian := by
        rw [Matrix.IsHermitian]
        ext i j
        simp [Matrix.one_apply, eq_comm]
      exact hgram.sub hone
    obtain ⟨_hop, v, hv, hvq, _hvmax⟩ :=
      NumStability.symmetricRealMatrixOperatorNorm_quadratic_characterization
        hn R hR
    have hvbound := hall v hv
    norm_num at hvbound
    have hopbound :
        NumStability.realMatrixOperatorNorm R ≤
          2 * |‖Matrix.toEuclideanLin (A ω) x‖ ^ 2 - (m : ℝ)| := by
      calc
        NumStability.realMatrixOperatorNorm R =
            |NumStability.realMatrixQuadraticForm R v| := hvq.symm
        _ = |‖Matrix.toEuclideanLin (A ω) v‖ ^ 2 - (m : ℝ)| := by
          congr 1
          rw [show R = (A ω).transpose * A ω -
              (m : ℝ) • (1 : Matrix (Fin n) (Fin n) ℝ) by rfl,
            NumStability.HDP.Metric.realMatrixQuadraticForm_gram_sub_smul_one,
            hv, one_pow, mul_one]
        _ ≤ 2 * |‖Matrix.toEuclideanLin (A ω) x‖ ^ 2 - (m : ℝ)| := hvbound
    have hmreal : 0 < (m : ℝ) := by exact_mod_cast hm
    have hsample :
        (m : ℝ) * u <
          |‖Matrix.toEuclideanLin (A ω) x‖ ^ 2 - (m : ℝ)| := by
      change 2 * (m : ℝ) * u < NumStability.realMatrixOperatorNorm R at hω
      nlinarith
    have haction :
        NumStability.vecNorm2 ((A ω).mulVec (fun j => x j)) =
          ‖Matrix.toEuclideanLin (A ω) x‖ := by
      rw [← NumStability.HDP.Vector.Spherical.norm_toLp_eq_vecNorm2]
      rfl
    have hnormalized :
        u < |NumStability.vecNorm2 ((A ω).mulVec (fun j => x j)) ^ 2 /
          (m : ℝ) - 1| := by
      rw [haction]
      rw [show ‖Matrix.toEuclideanLin (A ω) x‖ ^ 2 / (m : ℝ) - 1 =
          (‖Matrix.toEuclideanLin (A ω) x‖ ^ 2 - (m : ℝ)) / (m : ℝ) by
        field_simp]
      rw [abs_div, abs_of_pos hmreal]
      exact (lt_div_iff₀ hmreal).2 (by simpa [mul_comm] using hsample)
    simp only [Set.mem_iUnion, E, Set.mem_setOf_eq]
    exact ⟨x, hxN, hnormalized.le⟩
  exact (measureReal_mono hsubset (by
    exact ne_top_of_le_ne_top
      (show μ Set.univ ≠ (⊤ : ℝ≥0∞) by simp)
      (measure_mono (Set.subset_univ _)))).trans
    (NumStability.HDP.Probability.measureReal_biUnion_le N E p hp hsingle)

/-- The preceding Gram-deviation estimate with the standard `9ⁿ`
quarter-net cardinality already substituted. -/
theorem exists_gramDeviation_tail_nine_pow_of_independent_isotropic_subGaussian_rows :
    ∃ c : ℝ, 0 < c ∧
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
        ∀ {u : ℝ}, 0 ≤ u →
          μ.real {ω |
            2 * (m : ℝ) * u <
              NumStability.realMatrixOperatorNorm
                ((A ω).transpose * A ω -
                  (m : ℝ) • (1 : Matrix (Fin n) (Fin n) ℝ))} ≤
            (9 ^ n : ℕ) *
              (2 * Real.exp (-(c *
                min (u ^ 2 / K ^ 4) (u / K ^ 2) * (m : ℝ)))) := by
  rcases exists_gramDeviation_tail_of_independent_isotropic_subGaussian_rows with
    ⟨c, hc, htail⟩
  refine ⟨c, hc, ?_⟩
  intro Ω instΩ μ instμ m n hm hn A K hK hMeas hLp hIso hPsi hIndep u hu
  obtain ⟨N, hN, hNnonempty, hNcard⟩ :=
    NumStability.HDP.Metric.exists_quarterNet_card_le_nine_pow n hn
  refine (htail hm hn A hK hMeas hLp hIso hPsi hIndep
    N hN hNnonempty hu).trans ?_
  gcongr

/-- Normalized centered-Gram form of the `9ⁿ` net tail. -/
theorem exists_normalizedGramDeviation_tail_nine_pow_of_independent_isotropic_subGaussian_rows :
    ∃ c : ℝ, 0 < c ∧
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
        ∀ {u : ℝ}, 0 ≤ u →
          μ.real {ω |
            2 * u <
              NumStability.realMatrixOperatorNorm
                (((m : ℝ)⁻¹) • ((A ω).transpose * A ω) -
                  (1 : Matrix (Fin n) (Fin n) ℝ))} ≤
            (9 ^ n : ℕ) *
              (2 * Real.exp (-(c *
                min (u ^ 2 / K ^ 4) (u / K ^ 2) * (m : ℝ)))) := by
  rcases exists_gramDeviation_tail_nine_pow_of_independent_isotropic_subGaussian_rows with
    ⟨c, hc, htail⟩
  refine ⟨c, hc, ?_⟩
  intro Ω instΩ μ instμ m n hm hn A K hK hMeas hLp hIso hPsi hIndep u hu
  have hmreal : 0 < (m : ℝ) := by exact_mod_cast hm
  have hevent :
      {ω |
        2 * u <
          NumStability.realMatrixOperatorNorm
            (((m : ℝ)⁻¹) • ((A ω).transpose * A ω) -
              (1 : Matrix (Fin n) (Fin n) ℝ))} =
      {ω |
        2 * (m : ℝ) * u <
          NumStability.realMatrixOperatorNorm
            ((A ω).transpose * A ω -
              (m : ℝ) • (1 : Matrix (Fin n) (Fin n) ℝ))} := by
    ext ω
    simp only [Set.mem_setOf_eq,
      realMatrixOperatorNorm_normalizedGram_eq hm (A ω), inv_mul_eq_div]
    rw [lt_div_iff₀ hmreal]
    constructor <;> intro h <;> nlinarith
  rw [hevent]
  exact htail hm hn A hK hMeas hLp hIso hPsi hIndep hu

/-- One absolute enlargement of the deviation parameter absorbs the `9ⁿ`
quarter-net cardinality into a `2 exp (-t²)` tail. -/
theorem exists_constant_absorbing_nine_pow_gram_tail {c : ℝ} (hc : 0 < c) :
    ∃ C : ℝ, 0 < C ∧
      ∀ {m n : ℕ}, 0 < m → 0 < n →
        ∀ {K t : ℝ}, 0 < K → 0 ≤ t →
          let δ := C *
            (Real.sqrt ((n : ℝ) / (m : ℝ)) + t / Real.sqrt (m : ℝ))
          let u := K ^ 2 / 2 * max δ (δ ^ 2)
          (9 ^ n : ℕ) *
              (2 * Real.exp (-(c *
                min (u ^ 2 / K ^ 4) (u / K ^ 2) * (m : ℝ)))) ≤
            2 * Real.exp (-(t ^ 2)) := by
  let C : ℝ := 6 / Real.sqrt c
  have hsqrtc : 0 < Real.sqrt c := Real.sqrt_pos.2 hc
  have hC : 0 < C := by dsimp [C]; positivity
  refine ⟨C, hC, ?_⟩
  intro m n hm hn K t hK ht
  dsimp only
  let s : ℝ := Real.sqrt ((n : ℝ) / (m : ℝ)) +
    t / Real.sqrt (m : ℝ)
  let δ : ℝ := C * s
  let q : ℝ := max δ (δ ^ 2)
  let u : ℝ := K ^ 2 / 2 * q
  have hmreal : 0 < (m : ℝ) := by exact_mod_cast hm
  have hnreal : 0 < (n : ℝ) := by exact_mod_cast hn
  have hs0 : 0 ≤ s := by
    dsimp [s]
    positivity
  have hδ0 : 0 ≤ δ := mul_nonneg hC.le hs0
  have hqδ : δ ≤ q := le_max_left _ _
  have hqδsq : δ ^ 2 ≤ q := le_max_right _ _
  have hq0 : 0 ≤ q := hδ0.trans hqδ
  have hKsq : 0 < K ^ 2 := sq_pos_of_pos hK
  have hKfour : 0 < K ^ 4 := pow_pos hK 4
  have huquad : u ^ 2 / K ^ 4 = q ^ 2 / 4 := by
    dsimp [u]
    field_simp
    ring
  have hulinear : u / K ^ 2 = q / 2 := by
    dsimp [u]
    field_simp
  have hmin : δ ^ 2 / 4 ≤ min (u ^ 2 / K ^ 4) (u / K ^ 2) := by
    rw [huquad, hulinear]
    apply le_min
    · have hsq : δ ^ 2 ≤ q ^ 2 := by nlinarith
      linarith
    · nlinarith
  have hsqrtm : 0 < Real.sqrt (m : ℝ) := Real.sqrt_pos.2 hmreal
  have hsqrtnm :
      Real.sqrt ((n : ℝ) / (m : ℝ)) ^ 2 =
        (n : ℝ) / (m : ℝ) :=
    Real.sq_sqrt (div_nonneg hnreal.le hmreal.le)
  have hsqrtm_sq : Real.sqrt (m : ℝ) ^ 2 = (m : ℝ) :=
    Real.sq_sqrt hmreal.le
  have hsquare : (n : ℝ) + t ^ 2 ≤ (m : ℝ) * s ^ 2 := by
    have hcross :
        0 ≤ Real.sqrt ((n : ℝ) / (m : ℝ)) *
          (t / Real.sqrt (m : ℝ)) := by positivity
    have ha :
        (m : ℝ) * Real.sqrt ((n : ℝ) / (m : ℝ)) ^ 2 = (n : ℝ) := by
      rw [hsqrtnm]
      field_simp
    have hb :
        (m : ℝ) * (t / Real.sqrt (m : ℝ)) ^ 2 = t ^ 2 := by
      rw [div_pow, hsqrtm_sq]
      field_simp
    dsimp [s]
    nlinarith [mul_nonneg hmreal.le hcross]
  have hCsq : C ^ 2 = 36 / c := by
    dsimp [C]
    rw [div_pow, Real.sq_sqrt hc.le]
    norm_num
  have hdelta : δ ^ 2 = C ^ 2 * s ^ 2 := by
    dsimp [δ]
    ring
  have hexponent :
      9 * (n : ℝ) + t ^ 2 ≤
        c * min (u ^ 2 / K ^ 4) (u / K ^ 2) * (m : ℝ) := by
    calc
      9 * (n : ℝ) + t ^ 2 ≤ 9 * ((n : ℝ) + t ^ 2) := by
        nlinarith [sq_nonneg t]
      _ ≤ 9 * ((m : ℝ) * s ^ 2) := by gcongr
      _ = c * (δ ^ 2 / 4) * (m : ℝ) := by
        rw [hdelta, hCsq]
        field_simp
        ring
      _ ≤ c * min (u ^ 2 / K ^ 4) (u / K ^ 2) * (m : ℝ) := by
        gcongr
  have h9 : (9 : ℝ) ≤ Real.exp 9 := by
    calc
      (9 : ℝ) ≤ 9 + 1 := by norm_num
      _ ≤ Real.exp 9 := Real.add_one_le_exp 9
  have hpow : ((9 ^ n : ℕ) : ℝ) ≤ Real.exp (9 * (n : ℝ)) := by
    rw [Nat.cast_pow, Nat.cast_ofNat]
    calc
      (9 : ℝ) ^ n ≤ (Real.exp 9) ^ n :=
        pow_le_pow_left₀ (by norm_num) h9 n
      _ = Real.exp ((n : ℝ) * 9) := (Real.exp_nat_mul 9 n).symm
      _ = Real.exp (9 * (n : ℝ)) := by ring
  have hexp :
      Real.exp (-(c * min (u ^ 2 / K ^ 4) (u / K ^ 2) * (m : ℝ))) ≤
        Real.exp (-(9 * (n : ℝ) + t ^ 2)) := by
    exact Real.exp_le_exp.mpr (neg_le_neg hexponent)
  calc
    (9 ^ n : ℕ) *
          (2 * Real.exp (-(c *
            min (u ^ 2 / K ^ 4) (u / K ^ 2) * (m : ℝ)))) =
        (((9 ^ n : ℕ) : ℝ) *
          (2 * Real.exp (-(c *
            min (u ^ 2 / K ^ 4) (u / K ^ 2) * (m : ℝ))))) := rfl
    _ ≤ Real.exp (9 * (n : ℝ)) *
          (2 * Real.exp (-(9 * (n : ℝ) + t ^ 2))) := by gcongr
    _ = 2 * Real.exp (-(t ^ 2)) := by
      calc
        Real.exp (9 * (n : ℝ)) *
            (2 * Real.exp (-(9 * (n : ℝ) + t ^ 2))) =
          2 * (Real.exp (9 * (n : ℝ)) *
            Real.exp (-(9 * (n : ℝ) + t ^ 2))) := by ring
        _ = 2 * Real.exp
            (9 * (n : ℝ) + -(9 * (n : ℝ) + t ^ 2)) := by
          rw [Real.exp_add]
        _ = 2 * Real.exp (-(t ^ 2)) := by ring_nf

/-- Uniform normalized Gram-matrix deviation for a matrix with independent
isotropic sub-Gaussian rows, at the source's `K² max(δ,δ²)` scale and
`2 exp (-t²)` tail. -/
theorem exists_normalizedGramDeviation_tail_of_independent_isotropic_subGaussian_rows :
    ∃ C : ℝ, 0 < C ∧
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
        ∀ {t : ℝ}, 0 ≤ t →
          let δ := C *
            (Real.sqrt ((n : ℝ) / (m : ℝ)) + t / Real.sqrt (m : ℝ))
          μ.real {ω |
            K ^ 2 * max δ (δ ^ 2) <
              NumStability.realMatrixOperatorNorm
                (((m : ℝ)⁻¹) • ((A ω).transpose * A ω) -
                  (1 : Matrix (Fin n) (Fin n) ℝ))} ≤
            2 * Real.exp (-(t ^ 2)) := by
  rcases exists_normalizedGramDeviation_tail_nine_pow_of_independent_isotropic_subGaussian_rows with
    ⟨c, hc, htail⟩
  rcases exists_constant_absorbing_nine_pow_gram_tail hc with ⟨C, hC, habsorb⟩
  refine ⟨C, hC, ?_⟩
  intro Ω instΩ μ instμ m n hm hn A K hK hMeas hLp hIso hPsi hIndep t ht
  dsimp only
  let δ : ℝ := C *
    (Real.sqrt ((n : ℝ) / (m : ℝ)) + t / Real.sqrt (m : ℝ))
  let u : ℝ := K ^ 2 / 2 * max δ (δ ^ 2)
  have hδ : 0 ≤ δ := by
    dsimp [δ]
    positivity
  have hu : 0 ≤ u := by
    dsimp [u]
    positivity
  have hbound := htail hm hn A hK hMeas hLp hIso hPsi hIndep hu
  have hevent :
      {ω |
        K ^ 2 * max δ (δ ^ 2) <
          NumStability.realMatrixOperatorNorm
            (((m : ℝ)⁻¹) • ((A ω).transpose * A ω) -
              (1 : Matrix (Fin n) (Fin n) ℝ))} =
      {ω |
        2 * u <
          NumStability.realMatrixOperatorNorm
            (((m : ℝ)⁻¹) • ((A ω).transpose * A ω) -
              (1 : Matrix (Fin n) (Fin n) ℝ))} := by
    ext ω
    simp only [Set.mem_setOf_eq]
    dsimp [u]
    constructor <;> intro h <;> nlinarith
  rw [hevent]
  exact hbound.trans (habsorb hm hn hK ht)

end NumStability.HDP.Matrix
