import ComputationalMathematics.HDP.Vector.GaussianPolar
import ComputationalMathematics.HDP.Vector.GaussianNormConcentration
import ComputationalMathematics.HDP.Vector.StandardGaussianSubGaussian
import ComputationalMathematics.HDP.Scalar.GaussianTails
import ComputationalMathematics.HDP.Scalar.SubGaussianDomination
import ComputationalMathematics.HDP.Vector.SubGaussianDomination

/-!
# Sub-Gaussian marginals of spherical vectors

This module transfers Gaussian radial-direction facts to quantitative
sub-Gaussian bounds for the normalized uniform spherical law.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped ENNReal BigOperators

namespace NumStability.HDP.Vector.Spherical

open NumStability.HDP

theorem gaussianDirection_sphericalVectorLaw (d : ℕ) :
    HasLaw
      (fun x : Fin (d + 1) → ℝ ↦
        fun i ↦ Real.sqrt (d + 1) *
          WithLp.ofLp
            (NumStability.gaussianUnitDirection d x :
              EuclideanSpace ℝ (Fin (d + 1))) i)
      (Vector.Spherical.sphericalVectorMeasure (d + 1))
      (NumStability.standardGaussianVectorMeasure (d + 1)) := by
  have hdir :=
    Vector.Gaussian.hasLaw_gaussianUnitDirection_of_isStandardNormal
      d (Vector.Gaussian.canonical_isStandardNormal (d + 1))
  let f : Metric.sphere
      (0 : EuclideanSpace ℝ (Fin (d + 1))) 1 →
      (Fin (d + 1) → ℝ) :=
    fun y i ↦ Real.sqrt (d + 1) *
      WithLp.ofLp (y : EuclideanSpace ℝ (Fin (d + 1))) i
  have hf : Measurable f := by
    dsimp [f]
    fun_prop
  have hcanonical : HasLaw f
      (Vector.Spherical.sphericalVectorMeasure (d + 1))
      (@Vector.Spherical.uniformUnitSphereMeasure (d + 1)) := by
    refine ⟨hf.aemeasurable, ?_⟩
    unfold Vector.Spherical.sphericalVectorMeasure
    apply Measure.map_congr
    filter_upwards [] with y
    funext i
    simp [f, Pi.smul_apply, smul_eq_mul]
  simpa [f, Function.comp_def] using hcanonical.comp hdir

lemma abs_weightedSum_le_vecNorm2 {n : ℕ}
    (u x : Fin n → ℝ) (hu : NumStability.vecNorm2 u = 1) :
    |∑ i, u i * x i| ≤ NumStability.vecNorm2 x := by
  let u' : EuclideanSpace ℝ (Fin n) := WithLp.toLp 2 u
  let x' : EuclideanSpace ℝ (Fin n) := WithLp.toLp 2 x
  have hcs := abs_real_inner_le_norm u' x'
  have hu' : ‖u'‖ = 1 := by
    rw [EuclideanSpace.norm_eq]
    simp only [u', Real.norm_eq_abs, sq_abs]
    rw [show ∑ i, u i ^ 2 = NumStability.vecNorm2 u ^ 2 by
      exact (NumStability.vecNorm2_sq u).symm]
    rw [hu]
    norm_num
  have hx' : ‖x'‖ = NumStability.vecNorm2 x := by
    rw [EuclideanSpace.norm_eq]
    simp only [x', Real.norm_eq_abs, sq_abs]
    rw [show ∑ i, x i ^ 2 = NumStability.vecNorm2 x ^ 2 by
      exact (NumStability.vecNorm2_sq x).symm]
    exact Real.sqrt_sq (NumStability.vecNorm2_nonneg x)
  have hinner (a b : ℝ) : inner ℝ a b = a * b := by
    simpa using (RCLike.inner_apply' a b)
  simpa [u', x', PiLp.inner_apply, hu', hx', hinner, mul_comm] using hcs

lemma norm_toLp_eq_vecNorm2 {n : ℕ} (x : Fin n → ℝ) :
    ‖WithLp.toLp 2 x‖ = NumStability.vecNorm2 x := by
  rw [EuclideanSpace.norm_eq]
  simp only [Real.norm_eq_abs, sq_abs]
  rw [show ∑ i, x i ^ 2 = NumStability.vecNorm2 x ^ 2 by
    exact (NumStability.vecNorm2_sq x).symm]
  exact Real.sqrt_sq (NumStability.vecNorm2_nonneg x)

noncomputable def gaussianDirectionVector (d : ℕ)
    (x : Fin (d + 1) → ℝ) : Fin (d + 1) → ℝ :=
  fun i ↦ Real.sqrt (d + 1) *
    WithLp.ofLp
      (NumStability.gaussianUnitDirection d x :
        EuclideanSpace ℝ (Fin (d + 1))) i

lemma measurable_gaussianDirectionVector (d : ℕ) (i : Fin (d + 1)) :
    Measurable (fun x ↦ gaussianDirectionVector d x i) := by
  have hdir := NumStability.measurable_gaussianUnitDirection d
  have hcoord : Measurable
      (fun y : NumStability.OrthogonalSphere (d + 1) ↦
        WithLp.ofLp (y : EuclideanSpace ℝ (Fin (d + 1))) i) := by
    fun_prop
  exact measurable_const.mul (hcoord.comp hdir)

lemma gaussianDirectionVectorLaw (d : ℕ) :
    HasLaw (gaussianDirectionVector d)
      (Vector.Spherical.sphericalVectorMeasure (d + 1))
      (NumStability.standardGaussianVectorMeasure (d + 1)) := by
  simpa [gaussianDirectionVector] using gaussianDirection_sphericalVectorLaw d

lemma linearMarginal_gaussianDirectionVector_of_ne_zero
    (d : ℕ) (u x : Fin (d + 1) → ℝ) (hx : x ≠ 0) :
    Vector.linearMarginal
        (fun i x ↦ gaussianDirectionVector d x i) u x =
      Real.sqrt (d + 1) * (NumStability.vecNorm2 x)⁻¹ *
        (∑ i, u i * x i) := by
  simp only [Vector.linearMarginal, gaussianDirectionVector,
    NumStability.gaussianUnitDirection,
    NumStability.gaussianUnitDirectionValue, hx, if_false,
    PiLp.smul_apply, smul_eq_mul]
  rw [norm_toLp_eq_vecNorm2]
  calc
    ∑ i, Real.sqrt (d + 1) * ((NumStability.vecNorm2 x)⁻¹ * x i) * u i =
        ∑ i, (Real.sqrt (d + 1) * (NumStability.vecNorm2 x)⁻¹) *
          (u i * x i) := by
            apply Finset.sum_congr rfl
            intro i _
            ring
    _ = _ := by rw [Finset.mul_sum]

lemma abs_linearMarginal_gaussianDirectionVector_le_sqrt
    (d : ℕ) (u : Vector.SubGaussian.UnitDirection (d + 1))
    (x : Fin (d + 1) → ℝ) :
    |Vector.linearMarginal
        (fun i x ↦ gaussianDirectionVector d x i) u.1 x| ≤
      Real.sqrt (d + 1) := by
  unfold Vector.linearMarginal gaussianDirectionVector
  have hfactor :
      (∑ i, Real.sqrt (d + 1) *
          WithLp.ofLp
            (NumStability.gaussianUnitDirection d x :
              EuclideanSpace ℝ (Fin (d + 1))) i * u.1 i) =
        Real.sqrt (d + 1) *
          (∑ i, u.1 i * WithLp.ofLp
            (NumStability.gaussianUnitDirection d x :
              EuclideanSpace ℝ (Fin (d + 1))) i) := by
    rw [Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro i _
    ring
  rw [hfactor, abs_mul]
  have hdir : NumStability.vecNorm2
      (fun i ↦ WithLp.ofLp
        (NumStability.gaussianUnitDirection d x :
          EuclideanSpace ℝ (Fin (d + 1))) i) = 1 := by
    rw [← norm_toLp_eq_vecNorm2]
    have hp := (NumStability.gaussianUnitDirection d x).property
    rw [Metric.mem_sphere, dist_zero_right] at hp
    simp at hp ⊢
  have hsum := abs_weightedSum_le_vecNorm2
    u.1
    (fun i ↦ WithLp.ofLp
      (NumStability.gaussianUnitDirection d x :
        EuclideanSpace ℝ (Fin (d + 1))) i)
    u.2
  rw [hdir] at hsum
  simpa [abs_of_nonneg (Real.sqrt_nonneg _)] using
    (mul_le_mul_of_nonneg_left hsum (Real.sqrt_nonneg _))

theorem gaussianDirection_marginal_tail_four :
    ∃ a : ℝ, 0 < a ∧
      ∀ (d : ℕ) (u : Vector.SubGaussian.UnitDirection (d + 1))
        (t : ℝ), 0 ≤ t →
        (NumStability.standardGaussianVectorMeasure (d + 1)).real
            {x | |Vector.linearMarginal
              (fun i x ↦ gaussianDirectionVector d x i) u.1 x| ≥ t} ≤
          4 * Real.exp (-(a * t ^ 2)) := by
  rcases Vector.Gaussian.standardGaussianEuclideanNormDeviation_tail with
    ⟨c, hc, hRadius⟩
  let a : ℝ := min (1 / 8 : ℝ) (c / 4)
  have ha : 0 < a := lt_min (by norm_num) (div_pos hc (by norm_num))
  refine ⟨a, ha, ?_⟩
  intro d u t ht
  let mu := NumStability.standardGaussianVectorMeasure (d + 1)
  let Y : (Fin (d + 1) → ℝ) → ℝ :=
    Vector.linearMarginal
      (fun i x ↦ gaussianDirectionVector d x i) u.1
  let Z : (Fin (d + 1) → ℝ) → ℝ :=
    fun x ↦ ∑ i, u.1 i * x i
  let R : (Fin (d + 1) → ℝ) → ℝ := NumStability.vecNorm2
  let s : ℝ := Real.sqrt (d + 1)
  have hspos : 0 < s := by
    dsimp [s]
    positivity
  by_cases hts : t ≤ s
  · let A : Set (Fin (d + 1) → ℝ) := {x | |Z x| ≥ t / 2}
    let B : Set (Fin (d + 1) → ℝ) := {x | |R x - s| ≥ s / 2}
    have hsub : {x | |Y x| ≥ t} ⊆ A ∪ B := by
      intro x hx
      by_cases hxB : x ∈ B
      · exact Or.inr hxB
      · apply Or.inl
        change |Z x| ≥ t / 2
        have hRclose : |R x - s| < s / 2 := by
          exact lt_of_not_ge hxB
        have hRpos : 0 < R x := by
          have := (abs_lt.mp hRclose).1
          linarith
        have hx0 : x ≠ 0 := by
          intro hxzero
          have hRzero : R x = 0 := by
            rw [hxzero]
            exact NumStability.vecNorm2_zero
          linarith
        have hformula : Y x = s * (R x)⁻¹ * Z x := by
          simpa [Y, Z, R, s] using
            linearMarginal_gaussianDirectionVector_of_ne_zero d u.1 x hx0
        have hmul : t * R x ≤ s * |Z x| := by
          have h1 := mul_le_mul_of_nonneg_right hx (le_of_lt hRpos)
          rw [hformula, abs_mul, abs_mul,
            abs_of_nonneg (le_of_lt hspos), abs_inv,
            abs_of_pos hRpos] at h1
          calc
            t * R x ≤ (s * (R x)⁻¹ * |Z x|) * R x := h1
            _ = s * |Z x| := by field_simp
        have hRlower : s / 2 ≤ R x := by
          have := (abs_lt.mp hRclose).1
          linarith
        have hscaled : t * (s / 2) ≤ s * |Z x| := by
          exact le_trans
            (mul_le_mul_of_nonneg_left hRlower ht) hmul
        nlinarith
    have hUnion := MeasureTheory.measureReal_union_le (μ := mu) A B
    have hMeasureSub : mu.real {x | |Y x| ≥ t} ≤ mu.real (A ∪ B) :=
      MeasureTheory.measureReal_mono hsub
    have hZlaw := Vector.Gaussian.unitWeightedGaussianLaw u
    have hAeq : mu.real A = (gaussianReal 0 1).real {z : ℝ | |z| ≥ t / 2} := by
      unfold Measure.real
      congr 1
      calc
        mu A = Measure.map Z mu {z : ℝ | |z| ≥ t / 2} := by
          rw [Measure.map_apply
            (by dsimp [Z]; fun_prop)
            (by
              change MeasurableSet ((fun z : ℝ ↦ |z|) ⁻¹' Set.Ici (t / 2))
              exact measurableSet_Ici.preimage measurable_id.abs)]
          rfl
        _ = (gaussianReal 0 1) {z : ℝ | |z| ≥ t / 2} := by
          rw [hZlaw.map_eq]
    have hAtail : mu.real A ≤ 2 * Real.exp (-(t ^ 2 / 8)) := by
      rw [hAeq]
      have h := Scalar.GaussianTails.standardNormal_twoSidedTail_le
        (t / 2) (by positivity)
      simpa [show -((t / 2) ^ 2) / 2 = -(t ^ 2 / 8) by ring] using h
    have hBtail : mu.real B ≤
        2 * Real.exp (-(c * (s / 2) ^ 2)) := by
      have h := hRadius
        (X := fun i (x : Fin (d + 1) → ℝ) ↦ x i)
        (fun _ ↦ measurable_pi_apply _)
        (Vector.Gaussian.canonical_isStandardNormal (d + 1))
        (t := s / 2) (by positivity)
      simpa [mu, B, R, s] using h
    have haEight : a ≤ 1 / 8 := min_le_left _ _
    have haC : a ≤ c / 4 := min_le_right _ _
    have htSq : t ^ 2 ≤ s ^ 2 := by nlinarith
    have hAexp : Real.exp (-(t ^ 2 / 8)) ≤
        Real.exp (-(a * t ^ 2)) := by
      apply Real.exp_le_exp.mpr
      nlinarith [sq_nonneg t]
    have hBexp : Real.exp (-(c * (s / 2) ^ 2)) ≤
        Real.exp (-(a * t ^ 2)) := by
      apply Real.exp_le_exp.mpr
      nlinarith [sq_nonneg t, sq_nonneg s]
    calc
      mu.real {x | |Y x| ≥ t} ≤ mu.real (A ∪ B) := hMeasureSub
      _ ≤ mu.real A + mu.real B := hUnion
      _ ≤ 2 * Real.exp (-(t ^ 2 / 8)) +
          2 * Real.exp (-(c * (s / 2) ^ 2)) := add_le_add hAtail hBtail
      _ ≤ 2 * Real.exp (-(a * t ^ 2)) +
          2 * Real.exp (-(a * t ^ 2)) := by gcongr
      _ = 4 * Real.exp (-(a * t ^ 2)) := by ring
  · have hempty : {x | |Y x| ≥ t} = ∅ := by
      apply Set.eq_empty_iff_forall_notMem.mpr
      intro x hx
      have hbound := abs_linearMarginal_gaussianDirectionVector_le_sqrt d u x
      change |Y x| ≥ t at hx
      exact hts (le_trans hx hbound)
    rw [hempty]
    simp only [MeasureTheory.measureReal_empty]
    exact mul_nonneg (by norm_num) (Real.exp_nonneg _)

theorem gaussianDirection_psiTwoNorm_le :
    ∃ C : ℝ, 0 < C ∧ ∀ d : ℕ,
      Vector.SubGaussian.PsiTwoNorm
          (NumStability.standardGaussianVectorMeasure (d + 1))
          (fun i x ↦ gaussianDirectionVector d x i) ≤
        ENNReal.ofReal C := by
  rcases gaussianDirection_marginal_tail_four with ⟨a, ha, hTailFour⟩
  let K : ℝ := (Real.sqrt a)⁻¹
  have hK : 0 < K := inv_pos.mpr (Real.sqrt_pos.2 ha)
  let q : ℝ :=
    Scalar.SubGaussian.subGaussianTailThresholdScale 4 2
  have hq : 0 < q := lt_of_lt_of_le (by norm_num)
    (Scalar.SubGaussian.one_le_subGaussianTailThresholdScale
      (A := 4) (B := 2) (by norm_num) (by norm_num))
  let C : ℝ := (4096 * Real.exp 1) * (q * K)
  have hC : 0 < C := by
    dsimp [C]
    positivity
  refine ⟨C, hC, ?_⟩
  intro d
  unfold Vector.SubGaussian.PsiTwoNorm
  apply iSup_le
  intro u
  let mu := NumStability.standardGaussianVectorMeasure (d + 1)
  let Y : (Fin (d + 1) → ℝ) → ℝ :=
    Vector.linearMarginal
      (fun i x ↦ gaussianDirectionVector d x i) u.1
  have hY : Measurable Y := by
    exact Vector.SubGaussian.measurable_linearMarginal
      (measurable_gaussianDirectionVector d) u.1
  have hKsq : K ^ 2 = a⁻¹ := by
    dsimp [K]
    rw [inv_pow, Real.sq_sqrt ha.le]
  have hTailK : ∀ t : ℝ, 0 ≤ t →
      mu.real {x | |Y x| ≥ t} ≤
        4 * Real.exp (-t ^ 2 / K ^ 2) := by
    intro t ht
    calc
      mu.real {x | |Y x| ≥ t} ≤
          4 * Real.exp (-(a * t ^ 2)) := by
            simpa [mu, Y] using hTailFour d u t ht
      _ = 4 * Real.exp (-t ^ 2 / K ^ 2) := by
        congr 2
        rw [hKsq]
        field_simp [ne_of_gt ha]
  rcases Scalar.SubGaussian.subGaussianTailThreshold_rescale
      (A := 4) (B := 2) (by norm_num) (by norm_num) hK hTailK with
    ⟨K', hK', hK'le, hTailTwo⟩
  have hProp : Scalar.SubGaussian.SubGaussianProperty mu Y .tail K' := by
    exact ⟨hY, hK', hTailTwo⟩
  have hGauge := Scalar.SubGaussian.psiTwoGauge_le_of_property
    .tail hK' hProp
  change Scalar.SubGaussian.PsiTwoGauge mu Y ≤ ENNReal.ofReal C
  refine hGauge.trans ?_
  apply ENNReal.ofReal_le_ofReal
  have hpos : 0 < 4096 * Real.exp 1 := by positivity
  have hscaled := mul_le_mul_of_nonneg_left hK'le (le_of_lt hpos)
  simpa [C, q, mul_assoc] using hscaled

theorem sphericalVector_psiTwoNorm_le :
    ∃ C : ℝ, 0 < C ∧ ∀ n : ℕ, 0 < n →
      Vector.SubGaussian.PsiTwoNorm
          (Vector.Spherical.sphericalVectorMeasure n)
          (fun i x ↦ x i) ≤
        ENNReal.ofReal C := by
  rcases gaussianDirection_psiTwoNorm_le with ⟨C, hC, hBound⟩
  refine ⟨C, hC, ?_⟩
  intro n hn
  obtain ⟨d, rfl⟩ := Nat.exists_eq_succ_of_ne_zero (Nat.ne_of_gt hn)
  rw [← Vector.SubGaussian.psiTwoNorm_eq_of_hasLaw
    (measurable_gaussianDirectionVector d) (gaussianDirectionVectorLaw d)]
  simpa [Nat.succ_eq_add_one] using hBound d

/-- The canonical uniform law on `sqrt n` times the Euclidean sphere is
sub-Gaussian with a dimension-free vector `psi_2` bound. -/
theorem sphericalVector_isSubGaussian_psiTwoNorm_le :
    ∃ C : ℝ, 0 < C ∧ ∀ n : ℕ, 0 < n →
      Vector.SubGaussian.IsSubGaussian
          (Vector.Spherical.sphericalVectorMeasure n)
          (fun i x ↦ x i) ∧
      Vector.SubGaussian.PsiTwoNorm
          (Vector.Spherical.sphericalVectorMeasure n)
          (fun i x ↦ x i) ≤
        ENNReal.ofReal C := by
  rcases sphericalVector_psiTwoNorm_le with ⟨C, hC, hBound⟩
  refine ⟨C, hC, ?_⟩
  intro n hn
  letI : IsProbabilityMeasure
      (Vector.Spherical.sphericalVectorMeasure n) :=
    Vector.Spherical.sphericalVectorMeasure_isProbabilityMeasure hn
  have hle := hBound n hn
  exact ⟨Vector.SubGaussian.isSubGaussian_of_psiTwoNorm_lt_top
      (hle.trans_lt ENNReal.ofReal_lt_top), hle⟩

end NumStability.HDP.Vector.Spherical
