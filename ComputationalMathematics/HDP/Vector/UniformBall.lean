import ComputationalMathematics.HDP.Vector.Spherical
import ComputationalMathematics.HDP.Vector.SubGaussianDomination
import ComputationalMathematics.HDP.Convex.LinearImage

/-!
# Uniform Euclidean-ball laws

This module begins the polar-coordinate construction of normalized volume on
a Euclidean ball.  The angular coordinate has the canonical uniform sphere
law and the radial coordinate has density proportional to `r^(n-1)` on
`(0, 1)`.  The resulting vector is a pointwise radial contraction of the
spherical vector of radius `√n`.
-/

noncomputable section

open MeasureTheory ProbabilityTheory Metric
open scoped ENNReal Pointwise

namespace NumStability.HDP.Vector.UniformBall

/-- The positive radial coordinate used by Mathlib's polar decomposition. -/
abbrev PositiveRadius := Set.Ioi (0 : ℝ)

/-- The radius law of normalized volume on the unit ball in positive
dimension: density proportional to `r^(n-1)` on `(0, 1)`. -/
def unitRadiusMeasure (n : ℕ) : Measure PositiveRadius :=
  ProbabilityTheory.cond (Measure.volumeIoiPow (n - 1))
    (Set.Iio ⟨1, Set.mem_Ioi.2 one_pos⟩)

/-- The normalized radial law is a probability measure in positive
dimension. -/
theorem unitRadiusMeasure_isProbabilityMeasure (n : ℕ) :
    IsProbabilityMeasure (unitRadiusMeasure n) := by
  unfold unitRadiusMeasure
  apply cond_isProbabilityMeasure_of_finite
  · rw [Measure.volumeIoiPow_apply_Iio]
    apply ne_of_gt
    apply ENNReal.ofReal_pos.mpr
    positivity
  · rw [Measure.volumeIoiPow_apply_Iio]
    exact ENNReal.ofReal_ne_top

/-- Product polar law: independent uniform direction and normalized radius. -/
def polarBallMeasure (n : ℕ) :
    Measure
      (Metric.sphere (0 : EuclideanSpace ℝ (Fin n)) 1 × PositiveRadius) :=
  (@NumStability.HDP.Vector.Spherical.uniformUnitSphereMeasure n).prod
    (unitRadiusMeasure n)

/-- The polar product law is a probability measure in positive dimension. -/
theorem polarBallMeasure_isProbabilityMeasure {n : ℕ} (hn : 0 < n) :
    IsProbabilityMeasure (polarBallMeasure n) := by
  letI : IsProbabilityMeasure
      (@NumStability.HDP.Vector.Spherical.uniformUnitSphereMeasure n) :=
    NumStability.HDP.Vector.Spherical.uniformUnitSphereMeasure_isProbabilityMeasure hn
  letI : IsProbabilityMeasure (unitRadiusMeasure n) :=
    unitRadiusMeasure_isProbabilityMeasure n
  unfold polarBallMeasure
  infer_instance

/-- On polar space, the spherical vector ignores the radial coordinate and
has Euclidean radius `√n`. -/
def polarSphereVector (n : ℕ) :
    Fin n →
      (Metric.sphere (0 : EuclideanSpace ℝ (Fin n)) 1 × PositiveRadius) → ℝ :=
  fun i p ↦ Real.sqrt n *
    WithLp.ofLp (p.1 : EuclideanSpace ℝ (Fin n)) i

/-- The polar model of normalized volume on the Euclidean ball of radius
`√n`. -/
def polarBallVector (n : ℕ) :
    Fin n →
      (Metric.sphere (0 : EuclideanSpace ℝ (Fin n)) 1 × PositiveRadius) → ℝ :=
  NumStability.HDP.Vector.SubGaussian.radialContraction
    (fun p ↦ min p.2.1 1) (polarSphereVector n)

lemma measurable_polarSphereVector (n : ℕ) (i : Fin n) :
    Measurable (polarSphereVector n i) := by
  unfold polarSphereVector
  fun_prop

lemma measurable_polarRadius (n : ℕ) :
    Measurable
      (fun p : Metric.sphere (0 : EuclideanSpace ℝ (Fin n)) 1 ×
        PositiveRadius ↦ min p.2.1 1) := by
  fun_prop

lemma polarRadius_abs_le_one {n : ℕ}
    (p : Metric.sphere (0 : EuclideanSpace ℝ (Fin n)) 1 × PositiveRadius) :
    |min p.2.1 1| ≤ 1 := by
  rw [abs_of_pos (lt_min p.2.2 one_pos)]
  exact min_le_right _ _

/-- The polar ball model is a radial contraction of the polar sphere model,
so its vector `ψ₂` norm cannot be larger. -/
theorem polarBall_psiTwoNorm_le_polarSphere (n : ℕ) :
    NumStability.HDP.Vector.SubGaussian.PsiTwoNorm
        (polarBallMeasure n) (polarBallVector n) ≤
      NumStability.HDP.Vector.SubGaussian.PsiTwoNorm
        (polarBallMeasure n) (polarSphereVector n) := by
  apply NumStability.HDP.Vector.SubGaussian.radialContraction_psiTwoNorm_le
  · exact measurable_polarRadius n
  · exact measurable_polarSphereVector n
  · intro p
    exact polarRadius_abs_le_one p

/-- The polar sphere vector has the canonical spherical vector law. -/
theorem hasLaw_polarSphereVector (n : ℕ) :
    HasLaw (fun p i ↦ polarSphereVector n i p)
      (NumStability.HDP.Vector.Spherical.sphericalVectorMeasure n)
      (polarBallMeasure n) := by
  letI : IsProbabilityMeasure (unitRadiusMeasure n) :=
    unitRadiusMeasure_isProbabilityMeasure n
  have hFst : HasLaw Prod.fst
      (@NumStability.HDP.Vector.Spherical.uniformUnitSphereMeasure n)
      (polarBallMeasure n) := by
    exact MeasureTheory.measurePreserving_fst.hasLaw
  have hSphere : HasLaw
      (fun x : Metric.sphere (0 : EuclideanSpace ℝ (Fin n)) 1 ↦
        fun i ↦ Real.sqrt n *
          WithLp.ofLp (x : EuclideanSpace ℝ (Fin n)) i)
      (NumStability.HDP.Vector.Spherical.sphericalVectorMeasure n)
      (@NumStability.HDP.Vector.Spherical.uniformUnitSphereMeasure n) := by
    refine ⟨(by fun_prop), ?_⟩
    rfl
  simpa [polarSphereVector, Function.comp_def] using hSphere.comp hFst

/-- The polar sphere model and the canonical spherical law have the same
vector `ψ₂` norm. -/
theorem polarSphere_psiTwoNorm_eq_sphericalVectorMeasure
    (n : ℕ) :
    NumStability.HDP.Vector.SubGaussian.PsiTwoNorm
        (polarBallMeasure n) (polarSphereVector n) =
      NumStability.HDP.Vector.SubGaussian.PsiTwoNorm
        (NumStability.HDP.Vector.Spherical.sphericalVectorMeasure n)
        (fun i x ↦ x i) := by
  exact NumStability.HDP.Vector.SubGaussian.psiTwoNorm_eq_of_hasLaw
    (measurable_polarSphereVector n) (hasLaw_polarSphereVector n)

/-- The polar ball model has vector `ψ₂` norm no larger than the
canonical spherical law. -/
theorem polarBall_psiTwoNorm_le_sphericalVectorMeasure
    (n : ℕ) :
    NumStability.HDP.Vector.SubGaussian.PsiTwoNorm
        (polarBallMeasure n) (polarBallVector n) ≤
      NumStability.HDP.Vector.SubGaussian.PsiTwoNorm
        (NumStability.HDP.Vector.Spherical.sphericalVectorMeasure n)
        (fun i x ↦ x i) := by
  calc
    _ ≤ NumStability.HDP.Vector.SubGaussian.PsiTwoNorm
          (polarBallMeasure n) (polarSphereVector n) :=
      polarBall_psiTwoNorm_le_polarSphere n
    _ = _ := polarSphere_psiTwoNorm_eq_sphericalVectorMeasure n

/-! ## Identification with normalized Lebesgue volume -/

/-- Conditioning each factor separately agrees with conditioning the product
on the corresponding rectangle, provided the first conditioning mass is
nonzero and finite. -/
theorem cond_prod_cond
    {α β : Type*} [MeasurableSpace α] [MeasurableSpace β]
    (μ : Measure α) (ν : Measure β) [SFinite μ] [SFinite ν]
    (s : Set α) (t : Set β)
    (hμ0 : μ s ≠ 0) (hμt : μ s ≠ ⊤) :
    (ProbabilityTheory.cond μ s).prod (ProbabilityTheory.cond ν t) =
      ProbabilityTheory.cond (μ.prod ν) (s ×ˢ t) := by
  unfold ProbabilityTheory.cond
  rw [Measure.prod_smul_left, Measure.prod_smul_right,
    Measure.prod_restrict, Measure.prod_prod s t]
  rw [ENNReal.mul_inv (Or.inl hμ0) (Or.inl hμt)]
  rw [smul_smul]

/-- The Euclidean-space realization of `ℝⁿ` used by Mathlib's polar
homeomorphism. -/
abbrev EuclideanAmbient (n : ℕ) := EuclideanSpace ℝ (Fin n)

/-- The open unit ball with the origin removed, regarded as a subset of the
nonzero Euclidean vectors. -/
def puncturedUnitBall (n : ℕ) :
    Set ({0}ᶜ : Set (EuclideanAmbient n)) :=
  {x | ‖(x : EuclideanAmbient n)‖ < 1}

theorem image_puncturedUnitBall (n : ℕ) :
    (homeomorphUnitSphereProd (EuclideanAmbient n)) '' puncturedUnitBall n =
      Set.univ ×ˢ Set.Iio ⟨1, Set.mem_Ioi.2 one_pos⟩ := by
  ext p
  constructor
  · rintro ⟨x, hx, rfl⟩
    refine ⟨Set.mem_univ _, ?_⟩
    change (((homeomorphUnitSphereProd (EuclideanAmbient n)) x).2 : ℝ) < 1
    rw [homeomorphUnitSphereProd_apply_snd_coe]
    exact hx
  · rintro ⟨_hp, hr⟩
    refine ⟨(homeomorphUnitSphereProd (EuclideanAmbient n)).symm p, ?_, ?_⟩
    · change ‖(((homeomorphUnitSphereProd (EuclideanAmbient n)).symm p :
          ({0}ᶜ : Set (EuclideanAmbient n))) : EuclideanAmbient n)‖ < 1
      rw [homeomorphUnitSphereProd_symm_apply_coe, norm_smul,
        Real.norm_eq_abs, abs_of_pos p.2.2]
      simpa [Metric.mem_sphere] using hr
    · simp

/-- The independently normalized angular and radial factors are the
conditional polar-coordinate product measure on the unit-radius rectangle. -/
theorem polarBallMeasure_eq_cond_prod (n : ℕ) (hn : 0 < n) :
    polarBallMeasure n =
      ProbabilityTheory.cond
        ((volume : Measure (EuclideanAmbient n)).toSphere.prod
          (Measure.volumeIoiPow (n - 1)))
        (Set.univ ×ˢ Set.Iio ⟨1, Set.mem_Ioi.2 one_pos⟩) := by
  letI : Nonempty (Fin n) := Fin.pos_iff_nonempty.mp hn
  unfold polarBallMeasure unitRadiusMeasure
    NumStability.HDP.Vector.Spherical.uniformUnitSphereMeasure
  apply cond_prod_cond
  · exact Measure.measure_univ_ne_zero.mpr
      (Measure.toSphere_ne_zero
        (volume : Measure (EuclideanAmbient n)))
  · exact measure_ne_top _ _

/-- The inverse polar homeomorphism sends the normalized polar product law to
normalized volume on the punctured unit ball. -/
theorem map_polarBallMeasure_polarInverse (n : ℕ) (hn : 0 < n) :
    Measure.map
        (homeomorphUnitSphereProd (EuclideanAmbient n)).symm
        (polarBallMeasure n) =
      ProbabilityTheory.cond
        ((volume : Measure (EuclideanAmbient n)).comap Subtype.val)
        (puncturedUnitBall n) := by
  letI : Nonempty (Fin n) := Fin.pos_iff_nonempty.mp hn
  let e := (homeomorphUnitSphereProd
    (EuclideanAmbient n)).toMeasurableEquiv
  have hp : MeasurePreserving e
      ((volume : Measure (EuclideanAmbient n)).comap Subtype.val)
      ((volume : Measure (EuclideanAmbient n)).toSphere.prod
        (Measure.volumeIoiPow (n - 1))) := by
    simpa [e] using
      (Measure.measurePreserving_homeomorphUnitSphereProd
        (volume : Measure (EuclideanAmbient n)))
  have hps : MeasurePreserving e.symm
      ((volume : Measure (EuclideanAmbient n)).toSphere.prod
        (Measure.volumeIoiPow (n - 1)))
      ((volume : Measure (EuclideanAmbient n)).comap Subtype.val) := hp.symm
  have himage : e.symm ''
      (Set.univ ×ˢ Set.Iio ⟨1, Set.mem_Ioi.2 one_pos⟩) =
        puncturedUnitBall n := by
    rw [← show e '' puncturedUnitBall n =
      Set.univ ×ˢ Set.Iio ⟨1, Set.mem_Ioi.2 one_pos⟩ by
        simpa [e] using image_puncturedUnitBall n]
    exact e.symm_image_image (puncturedUnitBall n)
  rw [polarBallMeasure_eq_cond_prod n hn]
  have h := NumStability.HDP.Convex.map_cond_of_measurableEquiv
      e.symm
      ((volume : Measure (EuclideanAmbient n)).toSphere.prod
        (Measure.volumeIoiPow (n - 1)))
      ((volume : Measure (EuclideanAmbient n)).comap Subtype.val)
      (Set.univ ×ˢ Set.Iio ⟨1, Set.mem_Ioi.2 one_pos⟩)
      1 (by simp) (by simp) (by simpa using hps.map_eq)
  rw [himage] at h
  simpa [e] using h

theorem image_puncturedUnitBall_coe (n : ℕ) :
    ((fun x : ({0}ᶜ : Set (EuclideanAmbient n)) ↦
        (x : EuclideanAmbient n)) '' puncturedUnitBall n) =
      Metric.ball (0 : EuclideanAmbient n) 1 \ {0} := by
  ext x
  constructor
  · rintro ⟨y, hy, rfl⟩
    refine ⟨?_, ?_⟩
    · simpa [Metric.mem_ball, dist_zero_right, puncturedUnitBall] using hy
    · change (y : EuclideanAmbient n) ≠ 0
      intro h
      exact y.property (by simp [h])
  · rintro ⟨hxball, hx0⟩
    have hxne : x ≠ 0 := by simpa using hx0
    let y : ({0}ᶜ : Set (EuclideanAmbient n)) :=
      ⟨x, by simpa using hxne⟩
    refine ⟨y, ?_, rfl⟩
    simpa [y, Metric.mem_ball, dist_zero_right, puncturedUnitBall] using hxball

/-- Adding back the null origin converts punctured conditional volume into
the usual normalized-volume law on the open unit ball. -/
theorem map_cond_comap_puncturedUnitBall (n : ℕ) (hn : 0 < n) :
    Measure.map Subtype.val
        (ProbabilityTheory.cond
          ((volume : Measure (EuclideanAmbient n)).comap Subtype.val)
          (puncturedUnitBall n)) =
      ProbabilityTheory.cond (volume : Measure (EuclideanAmbient n))
        (Metric.ball 0 1) := by
  letI : Nonempty (Fin n) := Fin.pos_iff_nonempty.mp hn
  let s : Set ({0}ᶜ : Set (EuclideanAmbient n)) := puncturedUnitBall n
  let t : Set (EuclideanAmbient n) := Metric.ball 0 1 \ {0}
  have ht : t = Subtype.val '' s := by
    simpa [s, t] using (image_puncturedUnitBall_coe n).symm
  have hs_pre : Subtype.val ⁻¹' t = s := by
    rw [ht]
    exact Subtype.val_injective.preimage_image s
  have hsub : t ⊆ ({0}ᶜ : Set (EuclideanAmbient n)) := by
    intro x hx
    exact hx.2
  have hmap_restrict :
      Measure.map Subtype.val
          (((volume : Measure (EuclideanAmbient n)).comap
            Subtype.val).restrict s) =
        (volume : Measure (EuclideanAmbient n)).restrict t := by
    rw [← hs_pre]
    rw [← (MeasurableEmbedding.subtype_coe
      (measurableSet_singleton (0 : EuclideanAmbient n)).compl).restrict_map]
    rw [map_comap_subtype_coe
      (measurableSet_singleton (0 : EuclideanAmbient n)).compl]
    exact Measure.restrict_restrict_of_subset hsub
  have hmass :
      ((volume : Measure (EuclideanAmbient n)).comap Subtype.val) s =
        (volume : Measure (EuclideanAmbient n)) t := by
    calc
      ((volume : Measure (EuclideanAmbient n)).comap Subtype.val) s =
          (volume : Measure (EuclideanAmbient n)) (Subtype.val '' s) :=
        comap_subtype_coe_apply
          (measurableSet_singleton (0 : EuclideanAmbient n)).compl volume s
      _ = (volume : Measure (EuclideanAmbient n)) t := by rw [ht]
  have ht_measure : (volume : Measure (EuclideanAmbient n)) t =
      volume (Metric.ball (0 : EuclideanAmbient n) 1) := by
    simpa [t] using
      (measure_diff_null (s := Metric.ball (0 : EuclideanAmbient n) 1)
        (measure_singleton (0 : EuclideanAmbient n)))
  unfold ProbabilityTheory.cond
  rw [Measure.map_smul, hmap_restrict, hmass, ht_measure]
  congr 1
  apply Measure.restrict_congr_set
  filter_upwards [(volume : Measure (EuclideanAmbient n)).ae_ne 0] with x hx
  apply propext
  change (x ∈ Metric.ball (0 : EuclideanAmbient n) 1 \ {0}) ↔
    x ∈ Metric.ball (0 : EuclideanAmbient n) 1
  constructor
  · exact fun h ↦ h.1
  · intro h
    exact ⟨h, by simpa using hx⟩

/-- The unscaled vector reconstructed from a polar direction and radius. -/
def polarUnitVector (n : ℕ) :
    Metric.sphere (0 : EuclideanAmbient n) 1 × PositiveRadius →
      EuclideanAmbient n :=
  fun p ↦ p.2.1 • (p.1 : EuclideanAmbient n)

lemma measurable_polarUnitVector (n : ℕ) :
    Measurable (polarUnitVector n) := by
  unfold polarUnitVector
  fun_prop

lemma measurable_polarUnitFunction (n : ℕ) :
    Measurable (fun p ↦ WithLp.ofLp (polarUnitVector n p)) := by
  exact (MeasurableEquiv.toLp 2 (Fin n → ℝ)).symm.measurable.comp
    (measurable_polarUnitVector n)

/-- The reconstructed polar vector has normalized-volume law on the Euclidean
unit ball. -/
theorem map_polarUnitVector (n : ℕ) (hn : 0 < n) :
    Measure.map (polarUnitVector n) (polarBallMeasure n) =
      ProbabilityTheory.cond (volume : Measure (EuclideanAmbient n))
        (Metric.ball 0 1) := by
  calc
    Measure.map (polarUnitVector n) (polarBallMeasure n) =
      Measure.map
        (Subtype.val ∘
          (homeomorphUnitSphereProd (EuclideanAmbient n)).symm)
        (polarBallMeasure n) := by
          congr 1
    _ = Measure.map Subtype.val
        (Measure.map (homeomorphUnitSphereProd
          (EuclideanAmbient n)).symm (polarBallMeasure n)) := by
      rw [Measure.map_map]
      · exact measurable_subtype_coe
      · exact (homeomorphUnitSphereProd
          (EuclideanAmbient n)).symm.continuous.measurable
    _ = Measure.map Subtype.val
        (ProbabilityTheory.cond
          ((volume : Measure (EuclideanAmbient n)).comap Subtype.val)
          (puncturedUnitBall n)) := by
      rw [map_polarBallMeasure_polarInverse n hn]
    _ = ProbabilityTheory.cond (volume : Measure (EuclideanAmbient n))
        (Metric.ball 0 1) := map_cond_comap_puncturedUnitBall n hn

/-- The unit Euclidean ball represented in ordinary coordinate functions. -/
def functionUnitBall (n : ℕ) : Set (Fin n → ℝ) :=
  WithLp.ofLp '' Metric.ball (0 : EuclideanAmbient n) 1

theorem norm_toLp_eq_vecNorm2 {n : ℕ} (x : Fin n → ℝ) :
    ‖WithLp.toLp 2 x‖ = NumStability.vecNorm2 x := by
  unfold NumStability.vecNorm2 NumStability.vecNorm2Sq
  rw [EuclideanSpace.norm_eq]
  simp [Real.norm_eq_abs, sq_abs]

theorem functionUnitBall_eq (n : ℕ) :
    functionUnitBall n =
      {x : Fin n → ℝ | NumStability.vecNorm2 x < 1} := by
  ext x
  constructor
  · rintro ⟨y, hy, rfl⟩
    simpa [Metric.mem_ball, dist_zero_right, ← norm_toLp_eq_vecNorm2]
      using hy
  · intro hx
    refine ⟨WithLp.toLp 2 x, ?_, by simp⟩
    simpa [Metric.mem_ball, dist_zero_right, norm_toLp_eq_vecNorm2]
      using hx

/-- Coordinate conversion transports normalized volume on the Euclidean unit
ball to normalized volume on its coordinate-function realization. -/
theorem map_cond_euclidean_unitBall (n : ℕ) :
    Measure.map WithLp.ofLp
        (ProbabilityTheory.cond (volume : Measure (EuclideanAmbient n))
          (Metric.ball 0 1)) =
      NumStability.HDP.Convex.uniformConvexBodyMeasure
        (functionUnitBall n) := by
  let e : EuclideanAmbient n ≃ᵐ (Fin n → ℝ) :=
    (MeasurableEquiv.toLp 2 (Fin n → ℝ)).symm
  have hp : MeasurePreserving e
      (volume : Measure (EuclideanAmbient n))
      (volume : Measure (Fin n → ℝ)) := by
    simpa [e] using (PiLp.volume_preserving_ofLp (Fin n))
  unfold NumStability.HDP.Convex.uniformConvexBodyMeasure
  simpa [e, functionUnitBall] using
    NumStability.HDP.Convex.map_cond_of_measurableEquiv
      e (volume : Measure (EuclideanAmbient n))
      (volume : Measure (Fin n → ℝ))
      (Metric.ball 0 1) 1 (by simp) (by simp)
      (by simpa using hp.map_eq)

theorem map_polarUnitFunction (n : ℕ) (hn : 0 < n) :
    Measure.map (fun p ↦ WithLp.ofLp (polarUnitVector n p))
        (polarBallMeasure n) =
      NumStability.HDP.Convex.uniformConvexBodyMeasure
        (functionUnitBall n) := by
  calc
    Measure.map (fun p ↦ WithLp.ofLp (polarUnitVector n p))
        (polarBallMeasure n) =
      Measure.map WithLp.ofLp
        (Measure.map (polarUnitVector n) (polarBallMeasure n)) := by
      rw [Measure.map_map (by fun_prop) (measurable_polarUnitVector n)]
      rfl
    _ = Measure.map WithLp.ofLp
        (ProbabilityTheory.cond (volume : Measure (EuclideanAmbient n))
          (Metric.ball 0 1)) := by rw [map_polarUnitVector n hn]
    _ = _ := map_cond_euclidean_unitBall n

/-- The coordinate-function realization of the Euclidean ball of radius
`√n`. -/
def functionSqrtDimensionBall (n : ℕ) : Set (Fin n → ℝ) :=
  (fun x ↦ Real.sqrt n • x) '' functionUnitBall n

theorem functionSqrtDimensionBall_eq (n : ℕ) (hn : 0 < n) :
    functionSqrtDimensionBall n =
      {x : Fin n → ℝ | NumStability.vecNorm2 x < Real.sqrt n} := by
  have hsqrt : 0 < Real.sqrt (n : ℝ) :=
    Real.sqrt_pos.2 (by exact_mod_cast hn)
  rw [functionSqrtDimensionBall, functionUnitBall_eq]
  ext x
  constructor
  · rintro ⟨y, hy, rfl⟩
    change NumStability.vecNorm2 (fun i ↦ Real.sqrt n * y i) < Real.sqrt n
    change NumStability.vecNorm2 y < 1 at hy
    rw [NumStability.vecNorm2_smul, abs_of_pos hsqrt]
    calc
      Real.sqrt n * NumStability.vecNorm2 y < Real.sqrt n * 1 :=
        mul_lt_mul_of_pos_left hy hsqrt
      _ = Real.sqrt n := mul_one _
  · intro hx
    refine ⟨(Real.sqrt n)⁻¹ • x, ?_, ?_⟩
    · change NumStability.vecNorm2
        (fun i ↦ (Real.sqrt n)⁻¹ * x i) < 1
      change NumStability.vecNorm2 x < Real.sqrt n at hx
      rw [NumStability.vecNorm2_smul, abs_of_pos (inv_pos.mpr hsqrt)]
      calc
        (Real.sqrt n)⁻¹ * NumStability.vecNorm2 x <
            (Real.sqrt n)⁻¹ * Real.sqrt n :=
          mul_lt_mul_of_pos_left hx (inv_pos.mpr hsqrt)
        _ = 1 := inv_mul_cancel₀ hsqrt.ne'
    · change Real.sqrt n • ((Real.sqrt n)⁻¹ • x) = x
      rw [smul_smul, mul_inv_cancel₀ hsqrt.ne', one_smul]

/-- Scaling normalized volume on the unit ball by `√n` gives normalized
volume on the ball of radius `√n`. -/
theorem map_uniform_functionUnitBall_scale (n : ℕ) (hn : 0 < n) :
    Measure.map (fun x : Fin n → ℝ ↦ Real.sqrt n • x)
        (NumStability.HDP.Convex.uniformConvexBodyMeasure
          (functionUnitBall n)) =
      NumStability.HDP.Convex.uniformConvexBodyMeasure
        (functionSqrtDimensionBall n) := by
  have hsqrt : Real.sqrt (n : ℝ) ≠ 0 := by
    exact ne_of_gt (Real.sqrt_pos.2 (by exact_mod_cast hn))
  let u : ℝˣ := Units.mk0 (Real.sqrt n) hsqrt
  let e : (Fin n → ℝ) ≃ᵐ (Fin n → ℝ) :=
    (ContinuousLinearEquiv.smulLeft (R₁ := ℝ)
      (M₁ := Fin n → ℝ) u).toHomeomorph.toMeasurableEquiv
  let c : ℝ≥0∞ := ENNReal.ofReal
    |((Real.sqrt n) ^ Module.finrank ℝ (Fin n → ℝ))⁻¹|
  have hc0 : c ≠ 0 := by
    apply ne_of_gt
    apply ENNReal.ofReal_pos.mpr
    positivity
  have hct : c ≠ ⊤ := ENNReal.ofReal_ne_top
  have hmap : Measure.map e (volume : Measure (Fin n → ℝ)) =
      c • (volume : Measure (Fin n → ℝ)) := by
    simpa [e, u, c] using
      (Measure.map_addHaar_smul
        (volume : Measure (Fin n → ℝ)) hsqrt)
  unfold NumStability.HDP.Convex.uniformConvexBodyMeasure
  simpa [e, u, functionSqrtDimensionBall] using
    NumStability.HDP.Convex.map_cond_of_measurableEquiv
      e (volume : Measure (Fin n → ℝ))
      (volume : Measure (Fin n → ℝ)) (functionUnitBall n)
      c hc0 hct hmap

theorem ae_polarRadius_lt_one (n : ℕ) (hn : 0 < n) :
    ∀ᵐ p ∂polarBallMeasure n, p.2.1 < 1 := by
  rw [polarBallMeasure_eq_cond_prod n hn]
  filter_upwards [ProbabilityTheory.ae_cond_mem
    (MeasurableSet.univ.prod measurableSet_Iio)] with p hp
  exact hp.2

/-- The totalized polar-ball vector agrees almost everywhere with the literal
`√n` scaling of the reconstructed unit-ball vector. -/
theorem polarBallVector_ae_eq_scaledUnit (n : ℕ) (hn : 0 < n) :
    (fun p i ↦ polarBallVector n i p) =ᵐ[polarBallMeasure n]
      (fun p ↦ Real.sqrt n • WithLp.ofLp (polarUnitVector n p)) := by
  filter_upwards [ae_polarRadius_lt_one n hn] with p hp
  funext i
  unfold polarBallVector
    NumStability.HDP.Vector.SubGaussian.radialContraction
    polarSphereVector polarUnitVector
  change min p.2.1 1 *
      (Real.sqrt n * WithLp.ofLp (p.1 : EuclideanAmbient n) i) =
    (Real.sqrt n •
      WithLp.ofLp (p.2.1 • (p.1 : EuclideanAmbient n))) i
  rw [min_eq_left hp.le]
  simp only [Pi.smul_apply, smul_eq_mul, WithLp.ofLp_smul]
  ring

/-- The polar ball vector has exactly normalized Lebesgue-volume law on the
Euclidean ball of radius `√n`. -/
theorem map_polarBallVector (n : ℕ) (hn : 0 < n) :
    Measure.map (fun p i ↦ polarBallVector n i p) (polarBallMeasure n) =
      NumStability.HDP.Convex.uniformConvexBodyMeasure
        (functionSqrtDimensionBall n) := by
  calc
    Measure.map (fun p i ↦ polarBallVector n i p) (polarBallMeasure n) =
      Measure.map
        (fun p ↦ Real.sqrt n • WithLp.ofLp (polarUnitVector n p))
        (polarBallMeasure n) :=
      Measure.map_congr (polarBallVector_ae_eq_scaledUnit n hn)
    _ = Measure.map (fun x : Fin n → ℝ ↦ Real.sqrt n • x)
        (Measure.map (fun p ↦ WithLp.ofLp (polarUnitVector n p))
          (polarBallMeasure n)) := by
      rw [Measure.map_map]
      · rfl
      · fun_prop
      · exact measurable_polarUnitFunction n
    _ = Measure.map (fun x : Fin n → ℝ ↦ Real.sqrt n • x)
        (NumStability.HDP.Convex.uniformConvexBodyMeasure
          (functionUnitBall n)) := by
      rw [map_polarUnitFunction n hn]
    _ = _ := map_uniform_functionUnitBall_scale n hn

end NumStability.HDP.Vector.UniformBall
