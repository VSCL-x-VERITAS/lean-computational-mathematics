import Mathlib.MeasureTheory.Constructions.HaarToSphere
import Mathlib.MeasureTheory.Measure.Haar.InnerProductSpace
import Mathlib.Probability.ConditionalProbability
import Mathlib.Probability.HasLaw
import ComputationalMathematics.HDP.Vector.Isotropy

/-!
# Spherical random-vector laws

This module selects the canonical normalized surface measure on the Euclidean
unit sphere and pushes it forward by radial scaling.  It provides the reusable
law underlying spherical random vectors.
-/

noncomputable section

open MeasureTheory ProbabilityTheory Metric
open scoped Pointwise ENNReal

namespace NumStability.HDP.Vector.Spherical

/-- The action of a linear isometry equivalence on the unit sphere. -/
noncomputable def unitSphereMap {E : Type*} [NormedAddCommGroup E]
    [InnerProductSpace ℝ E] (e : E ≃ₗᵢ[ℝ] E) :
    Metric.sphere (0 : E) 1 → Metric.sphere (0 : E) 1 :=
  fun x ↦ ⟨e x, by simpa [Metric.mem_sphere] using e.norm_map x⟩

theorem measurable_unitSphereMap {E : Type*} [NormedAddCommGroup E]
    [InnerProductSpace ℝ E] [MeasurableSpace E] [BorelSpace E]
    (e : E ≃ₗᵢ[ℝ] E) :
    Measurable (unitSphereMap e) := by
  exact (e.continuous.measurable.comp measurable_subtype_coe).subtype_mk

/-- The sphere measure induced from volume is invariant under linear
isometry equivalences. -/
theorem map_volume_toSphere_unitSphereMap {E : Type*}
    [NormedAddCommGroup E] [InnerProductSpace ℝ E]
    [MeasurableSpace E] [BorelSpace E] [FiniteDimensional ℝ E]
    (e : E ≃ₗᵢ[ℝ] E) :
    Measure.map (unitSphereMap e) (volume : Measure E).toSphere =
      (volume : Measure E).toSphere := by
  ext s hs
  rw [Measure.map_apply (measurable_unitSphereMap e) hs]
  rw [Measure.toSphere_apply' _ (hs.preimage (measurable_unitSphereMap e)),
    Measure.toSphere_apply' _ hs]
  congr 1
  have hcone :
      (Set.Ioo (0 : ℝ) 1 •
          ((fun x : Metric.sphere (0 : E) 1 ↦ (x : E)) ''
            (unitSphereMap e ⁻¹' s)) : Set E) =
        (fun y : E ↦ e y) ⁻¹'
          (Set.Ioo (0 : ℝ) 1 •
            ((fun x : Metric.sphere (0 : E) 1 ↦ (x : E)) '' s) : Set E) := by
    ext y
    constructor
    · rintro ⟨a, ha, _, ⟨x, hx, rfl⟩, rfl⟩
      refine ⟨a, ha, (unitSphereMap e x : E),
        ⟨unitSphereMap e x, hx, rfl⟩, ?_⟩
      exact (e.map_smul a x).symm
    · rintro ⟨a, ha, _, ⟨z, hz, rfl⟩, hy⟩
      let x : Metric.sphere (0 : E) 1 :=
        ⟨e.symm z, by
          rw [Metric.mem_sphere, dist_zero_right, e.symm.norm_map]
          simpa [Metric.mem_sphere] using z.property⟩
      refine ⟨a, ha, (x : E), ⟨x, ?_, rfl⟩, ?_⟩
      · change unitSphereMap e x ∈ s
        simpa [x, unitSphereMap] using hz
      · apply e.injective
        simpa [x] using hy
  rw [hcone]
  exact MeasurePreserving.measure_preimage_equiv
    (f := e.toMeasurableEquiv) e.measurePreserving _

/-- Normalized surface measure on the unit sphere in `ℝⁿ`. -/
def uniformUnitSphereMeasure {n : ℕ} :
    Measure (Metric.sphere (0 : EuclideanSpace ℝ (Fin n)) 1) :=
  ProbabilityTheory.cond volume.toSphere Set.univ

noncomputable instance uniformUnitSphereMeasure_isZeroOrProbabilityMeasure
    {n : ℕ} :
    IsZeroOrProbabilityMeasure (@uniformUnitSphereMeasure n) := by
  unfold uniformUnitSphereMeasure
  infer_instance

/-- In positive dimension, normalized surface measure on the unit sphere is a
probability measure. -/
theorem uniformUnitSphereMeasure_isProbabilityMeasure {n : ℕ} (hn : 0 < n) :
    IsProbabilityMeasure (@uniformUnitSphereMeasure n) := by
  letI : Nonempty (Fin n) := Fin.pos_iff_nonempty.mp hn
  unfold uniformUnitSphereMeasure
  exact cond_isProbabilityMeasure_of_finite
    (Measure.measure_univ_ne_zero.mpr
      (Measure.toSphere_ne_zero
        (volume : Measure (EuclideanSpace ℝ (Fin n)))))
    (measure_ne_top _ _)

/-- Normalized surface measure is invariant under every Euclidean linear
isometry equivalence. -/
theorem map_uniformUnitSphereMeasure_unitSphereMap {n : ℕ}
    (e : EuclideanSpace ℝ (Fin n) ≃ₗᵢ[ℝ] EuclideanSpace ℝ (Fin n)) :
    Measure.map (unitSphereMap e) (@uniformUnitSphereMeasure n) =
      uniformUnitSphereMeasure := by
  simp only [uniformUnitSphereMeasure, ProbabilityTheory.cond,
    Measure.restrict_univ, Measure.map_smul,
    map_volume_toSphere_unitSphereMap]

/-- Integrals against normalized surface measure are unchanged by a
Euclidean linear isometry equivalence. -/
theorem integral_comp_unitSphereMap {n : ℕ}
    (e : EuclideanSpace ℝ (Fin n) ≃ₗᵢ[ℝ] EuclideanSpace ℝ (Fin n))
    (f : Metric.sphere (0 : EuclideanSpace ℝ (Fin n)) 1 → ℝ)
    (hf : AEStronglyMeasurable f uniformUnitSphereMeasure) :
    (∫ x, f (unitSphereMap e x) ∂uniformUnitSphereMeasure) =
      ∫ x, f x ∂uniformUnitSphereMeasure := by
  have hf' : AEStronglyMeasurable f
      (Measure.map (unitSphereMap e) uniformUnitSphereMeasure) := by
    rwa [map_uniformUnitSphereMeasure_unitSphereMap e]
  calc
    (∫ x, f (unitSphereMap e x) ∂uniformUnitSphereMeasure) =
        ∫ x, f x ∂Measure.map (unitSphereMap e) uniformUnitSphereMeasure :=
      (MeasureTheory.integral_map
        (measurable_unitSphereMap e).aemeasurable hf').symm
    _ = ∫ x, f x ∂uniformUnitSphereMeasure := by
      rw [map_uniformUnitSphereMeasure_unitSphereMap e]

/-- Negate one coordinate of a Euclidean vector. -/
noncomputable def coordinateSignFlip {n : ℕ} (i : Fin n) :
    EuclideanSpace ℝ (Fin n) ≃ₗᵢ[ℝ] EuclideanSpace ℝ (Fin n) :=
  LinearIsometryEquiv.piLpCongrRight 2 fun k ↦
    if k = i then LinearIsometryEquiv.neg ℝ
    else LinearIsometryEquiv.refl ℝ ℝ

@[simp] theorem coordinateSignFlip_apply {n : ℕ} (i k : Fin n)
    (x : EuclideanSpace ℝ (Fin n)) :
    WithLp.ofLp (coordinateSignFlip i x) k =
      if k = i then -WithLp.ofLp x k else WithLp.ofLp x k := by
  by_cases h : k = i <;> simp [coordinateSignFlip, h]

/-- Reindex a Euclidean vector by a coordinate permutation. -/
noncomputable def coordinatePermutation {n : ℕ} (e : Equiv.Perm (Fin n)) :
    EuclideanSpace ℝ (Fin n) ≃ₗᵢ[ℝ] EuclideanSpace ℝ (Fin n) :=
  LinearIsometryEquiv.piLpCongrLeft 2 ℝ ℝ e

@[simp] theorem coordinatePermutation_apply {n : ℕ}
    (e : Equiv.Perm (Fin n)) (k : Fin n)
    (x : EuclideanSpace ℝ (Fin n)) :
    WithLp.ofLp (coordinatePermutation e x) k = WithLp.ofLp x (e.symm k) := by
  rfl

/-- A coordinate function on the Euclidean unit sphere. -/
def unitSphereCoordinate {n : ℕ} (i : Fin n)
    (x : Metric.sphere (0 : EuclideanSpace ℝ (Fin n)) 1) : ℝ :=
  WithLp.ofLp (x : EuclideanSpace ℝ (Fin n)) i

theorem integrable_unitSphereCoordinate_mul {n : ℕ} (i j : Fin n) :
    Integrable (fun x ↦ unitSphereCoordinate i x * unitSphereCoordinate j x)
      uniformUnitSphereMeasure := by
  apply Integrable.of_bound (C := 1)
    (show AEStronglyMeasurable
      (fun x : Metric.sphere (0 : EuclideanSpace ℝ (Fin n)) 1 ↦
        WithLp.ofLp (x : EuclideanSpace ℝ (Fin n)) i *
          WithLp.ofLp (x : EuclideanSpace ℝ (Fin n)) j)
        uniformUnitSphereMeasure by fun_prop)
  filter_upwards [] with x
  have hxnorm : ‖(x : EuclideanSpace ℝ (Fin n))‖ = 1 := by
    simpa [Metric.mem_sphere] using x.property
  have hi : |unitSphereCoordinate i x| ≤ 1 := by
    simpa [unitSphereCoordinate, Real.norm_eq_abs, hxnorm] using
      PiLp.norm_apply_le (x : EuclideanSpace ℝ (Fin n)) i
  have hj : |unitSphereCoordinate j x| ≤ 1 := by
    simpa [unitSphereCoordinate, Real.norm_eq_abs, hxnorm] using
      PiLp.norm_apply_le (x : EuclideanSpace ℝ (Fin n)) j
  change |WithLp.ofLp (x : EuclideanSpace ℝ (Fin n)) i| ≤ 1 at hi
  change |WithLp.ofLp (x : EuclideanSpace ℝ (Fin n)) j| ≤ 1 at hj
  rw [Real.norm_eq_abs, abs_mul]
  exact (mul_le_mul hi hj (abs_nonneg _) zero_le_one).trans_eq (one_mul 1)

/-- Distinct coordinates have zero mixed second moment under normalized
surface measure. -/
theorem integral_unitSphereCoordinate_mul_eq_zero {n : ℕ}
    {i j : Fin n} (hij : i ≠ j) :
    (∫ x, unitSphereCoordinate i x * unitSphereCoordinate j x
      ∂uniformUnitSphereMeasure) = 0 := by
  have hinv := integral_comp_unitSphereMap (coordinateSignFlip i)
    (fun x ↦ unitSphereCoordinate i x * unitSphereCoordinate j x)
    (integrable_unitSphereCoordinate_mul i j).aestronglyMeasurable
  simp only [unitSphereMap, unitSphereCoordinate, coordinateSignFlip_apply,
    if_pos, if_neg hij.symm, neg_mul, integral_neg] at hinv
  change (∫ x : Metric.sphere (0 : EuclideanSpace ℝ (Fin n)) 1,
    WithLp.ofLp (x : EuclideanSpace ℝ (Fin n)) i *
    WithLp.ofLp (x : EuclideanSpace ℝ (Fin n)) j
    ∂uniformUnitSphereMeasure) = 0
  linarith

/-- All coordinates have the same second moment under normalized surface
measure. -/
theorem integral_sq_unitSphereCoordinate_eq {n : ℕ} (i j : Fin n) :
    (∫ x, unitSphereCoordinate i x ^ 2 ∂uniformUnitSphereMeasure) =
      ∫ x, unitSphereCoordinate j x ^ 2 ∂uniformUnitSphereMeasure := by
  have hinv := integral_comp_unitSphereMap
    (coordinatePermutation (Equiv.swap i j))
    (fun x ↦ unitSphereCoordinate i x ^ 2)
    ((integrable_unitSphereCoordinate_mul i i).congr
      (Filter.Eventually.of_forall fun x ↦ by simp [pow_two])).aestronglyMeasurable
  simpa [unitSphereMap, unitSphereCoordinate] using hinv.symm

/-- Every coordinate has second moment `1 / n` under normalized surface
measure in positive dimension. -/
theorem integral_sq_unitSphereCoordinate {n : ℕ} (hn : 0 < n) (i : Fin n) :
    (∫ x, unitSphereCoordinate i x ^ 2 ∂uniformUnitSphereMeasure) =
      (n : ℝ)⁻¹ := by
  letI : IsProbabilityMeasure (@uniformUnitSphereMeasure n) :=
    uniformUnitSphereMeasure_isProbabilityMeasure hn
  have hsphere (x : Metric.sphere
      (0 : EuclideanSpace ℝ (Fin n)) 1) :
      ∑ k, unitSphereCoordinate k x ^ 2 = 1 := by
    have hxnorm : ‖(x : EuclideanSpace ℝ (Fin n))‖ = 1 := by
      simpa [Metric.mem_sphere] using x.property
    calc
      ∑ k, unitSphereCoordinate k x ^ 2 =
          ‖(x : EuclideanSpace ℝ (Fin n))‖ ^ 2 := by
        simpa [unitSphereCoordinate, Real.norm_eq_abs] using
          (EuclideanSpace.norm_sq_eq
            (x : EuclideanSpace ℝ (Fin n))).symm
      _ = 1 := by simp [hxnorm]
  have hsum :
      (∫ x : Metric.sphere (0 : EuclideanSpace ℝ (Fin n)) 1,
        ∑ k : Fin n, unitSphereCoordinate k x ^ 2
        ∂(@uniformUnitSphereMeasure n)) = 1 := by
    calc
      (∫ x : Metric.sphere (0 : EuclideanSpace ℝ (Fin n)) 1,
        ∑ k : Fin n, unitSphereCoordinate k x ^ 2
          ∂(@uniformUnitSphereMeasure n)) =
          ∫ _x : Metric.sphere (0 : EuclideanSpace ℝ (Fin n)) 1,
            (1 : ℝ) ∂(@uniformUnitSphereMeasure n) := by
        apply integral_congr_ae
        filter_upwards [] with x
        exact hsphere x
      _ = 1 := by simp
  rw [integral_finset_sum Finset.univ] at hsum
  · have heq :
        (∑ _k : Fin n,
          ∫ x : Metric.sphere (0 : EuclideanSpace ℝ (Fin n)) 1,
            unitSphereCoordinate i x ^ 2
            ∂(@uniformUnitSphereMeasure n)) = 1 := by
      calc
        _ = ∑ k : Fin n,
            ∫ x, unitSphereCoordinate k x ^ 2
              ∂(@uniformUnitSphereMeasure n) := by
          apply Finset.sum_congr rfl
          intro k _hk
          exact (integral_sq_unitSphereCoordinate_eq k i).symm
        _ = 1 := hsum
    have heq' : (n : ℝ) *
        (∫ x, unitSphereCoordinate i x ^ 2
          ∂(@uniformUnitSphereMeasure n)) = 1 := by
      simpa using heq
    exact eq_inv_of_mul_eq_one_right heq'
  · intro k _hk
    exact (integrable_unitSphereCoordinate_mul k k).congr
      (Filter.Eventually.of_forall fun x ↦ by simp [pow_two])

/-- Coordinate-product second moments of normalized surface measure. -/
theorem integral_unitSphereCoordinate_mul {n : ℕ} (hn : 0 < n)
    (i j : Fin n) :
    (∫ x, unitSphereCoordinate i x * unitSphereCoordinate j x
      ∂uniformUnitSphereMeasure) = if i = j then (n : ℝ)⁻¹ else 0 := by
  by_cases hij : i = j
  · subst j
    simpa [pow_two] using integral_sq_unitSphereCoordinate hn i
  · simpa [hij] using integral_unitSphereCoordinate_mul_eq_zero hij

/-- The canonical spherical distribution in `ℝⁿ`: normalized surface measure
on the unit sphere, radially scaled to radius `√n`. -/
def sphericalVectorMeasure (n : ℕ) : Measure (Fin n → ℝ) :=
  Measure.map
    (fun x : Metric.sphere (0 : EuclideanSpace ℝ (Fin n)) 1 =>
      Real.sqrt n • WithLp.ofLp (x : EuclideanSpace ℝ (Fin n)))
    uniformUnitSphereMeasure

/-- The spherical distribution is a probability measure in positive
dimension. -/
theorem sphericalVectorMeasure_isProbabilityMeasure {n : ℕ} (hn : 0 < n) :
    IsProbabilityMeasure (sphericalVectorMeasure n) := by
  letI : IsProbabilityMeasure (@uniformUnitSphereMeasure n) :=
    uniformUnitSphereMeasure_isProbabilityMeasure hn
  unfold sphericalVectorMeasure
  exact Measure.isProbabilityMeasure_map (by fun_prop)

/-- In dimension at least two, the coordinates of the canonical spherical
distribution are not mutually independent. -/
theorem not_iIndepFun_sphericalVectorMeasure {n : ℕ} (hn : 2 ≤ n) :
    ¬ iIndepFun (fun i : Fin n => fun x : Fin n → ℝ => x i)
      (sphericalVectorMeasure n) := by
  let i : Fin n := ⟨0, lt_of_lt_of_le (by norm_num) hn⟩
  let j : Fin n := ⟨1, hn⟩
  have hij : i ≠ j := by simp [i, j]
  have hn0 : 0 < n := lt_of_lt_of_le (by norm_num) hn
  have hsqrt : 0 < Real.sqrt (n : ℝ) := Real.sqrt_pos.2 (by exact_mod_cast hn0)
  let c : ℝ := (3 / 4 : ℝ) * Real.sqrt n
  let U (k : Fin n) : Set (Metric.sphere
      (0 : EuclideanSpace ℝ (Fin n)) 1) :=
    {x | (3 / 4 : ℝ) < unitSphereCoordinate k x}
  have hU_open (k : Fin n) : IsOpen (U k) := by
    dsimp [U, unitSphereCoordinate]
    exact isOpen_lt continuous_const (by fun_prop)
  have hU_nonempty (k : Fin n) : (U k).Nonempty := by
    let ek : Metric.sphere (0 : EuclideanSpace ℝ (Fin n)) 1 :=
      ⟨EuclideanSpace.single k 1, by
        rw [Metric.mem_sphere, dist_zero_right, EuclideanSpace.norm_single]
        norm_num⟩
    refine ⟨ek, ?_⟩
    simp [U, unitSphereCoordinate, ek, EuclideanSpace.single_apply]
    norm_num
  letI : Measure.IsOpenPosMeasure (@uniformUnitSphereMeasure n) := by
    unfold uniformUnitSphereMeasure ProbabilityTheory.cond
    rw [Measure.restrict_univ]
    apply Measure.isOpenPosMeasure_smul
    rw [ENNReal.inv_ne_zero]
    exact measure_ne_top _ _
  have hU_pos (k : Fin n) : 0 < (@uniformUnitSphereMeasure n) (U k) :=
    (hU_open k).measure_pos _ (hU_nonempty k)
  let F : Metric.sphere (0 : EuclideanSpace ℝ (Fin n)) 1 → (Fin n → ℝ) :=
    fun x => Real.sqrt n • WithLp.ofLp (x : EuclideanSpace ℝ (Fin n))
  have hmap_marginal (k : Fin n) :
      (sphericalVectorMeasure n) ((fun x : Fin n → ℝ => x k) ⁻¹' Set.Ioi c) =
        (@uniformUnitSphereMeasure n) (U k) := by
    unfold sphericalVectorMeasure
    rw [Measure.map_apply (by fun_prop)
      (measurableSet_Ioi.preimage (measurable_pi_apply k))]
    congr 1
    ext x
    change c < Real.sqrt (n : ℝ) * unitSphereCoordinate k x ↔ x ∈ U k
    rw [show c = Real.sqrt (n : ℝ) * (3 / 4 : ℝ) by simp [c, mul_comm]]
    constructor <;> intro h
    · exact lt_of_mul_lt_mul_left h hsqrt.le
    · exact mul_lt_mul_of_pos_left h hsqrt
  have hpair_impossible (x : Metric.sphere
      (0 : EuclideanSpace ℝ (Fin n)) 1)
      (hi : x ∈ U i) (hj : x ∈ U j) : False := by
    have hxnorm : ‖(x : EuclideanSpace ℝ (Fin n))‖ = 1 := by
      simpa [Metric.mem_sphere] using x.property
    have hsum : ∑ k, unitSphereCoordinate k x ^ 2 = 1 := by
      calc
        ∑ k, unitSphereCoordinate k x ^ 2 =
            ‖(x : EuclideanSpace ℝ (Fin n))‖ ^ 2 := by
          simpa [unitSphereCoordinate, Real.norm_eq_abs] using
            (EuclideanSpace.norm_sq_eq
              (x : EuclideanSpace ℝ (Fin n))).symm
        _ = 1 := by simp [hxnorm]
    have hpairs :
        unitSphereCoordinate i x ^ 2 + unitSphereCoordinate j x ^ 2 ≤ 1 := by
      calc
        unitSphereCoordinate i x ^ 2 + unitSphereCoordinate j x ^ 2 =
            ∑ k ∈ ({i, j} : Finset (Fin n)), unitSphereCoordinate k x ^ 2 := by
          simp [hij]
        _ ≤ ∑ k : Fin n, unitSphereCoordinate k x ^ 2 := by
          apply Finset.sum_le_sum_of_subset_of_nonneg
          · simp
          · intro k _hk _hnot
            positivity
        _ = 1 := hsum
    change (3 / 4 : ℝ) < unitSphereCoordinate i x at hi
    change (3 / 4 : ℝ) < unitSphereCoordinate j x at hj
    nlinarith [sq_nonneg (unitSphereCoordinate i x - 3 / 4),
      sq_nonneg (unitSphereCoordinate j x - 3 / 4)]
  have hinter_zero :
      (sphericalVectorMeasure n)
          (((fun x : Fin n → ℝ => x i) ⁻¹' Set.Ioi c) ∩
            ((fun x : Fin n → ℝ => x j) ⁻¹' Set.Ioi c)) = 0 := by
    unfold sphericalVectorMeasure
    rw [Measure.map_apply (by fun_prop)
      ((measurableSet_Ioi.preimage (measurable_pi_apply i)).inter
        (measurableSet_Ioi.preimage (measurable_pi_apply j)))]
    have hempty :
        F ⁻¹' (((fun x : Fin n → ℝ => x i) ⁻¹' Set.Ioi c) ∩
          ((fun x : Fin n → ℝ => x j) ⁻¹' Set.Ioi c)) = ∅ := by
      apply Set.eq_empty_iff_forall_notMem.2
      intro x hx
      rcases hx with ⟨hxi, hxj⟩
      apply hpair_impossible x
      · change (3 / 4 : ℝ) < unitSphereCoordinate i x
        change c < Real.sqrt (n : ℝ) * unitSphereCoordinate i x at hxi
        rw [show c = Real.sqrt (n : ℝ) * (3 / 4 : ℝ) by simp [c, mul_comm]] at hxi
        exact lt_of_mul_lt_mul_left hxi hsqrt.le
      · change (3 / 4 : ℝ) < unitSphereCoordinate j x
        change c < Real.sqrt (n : ℝ) * unitSphereCoordinate j x at hxj
        rw [show c = Real.sqrt (n : ℝ) * (3 / 4 : ℝ) by simp [c, mul_comm]] at hxj
        exact lt_of_mul_lt_mul_left hxj hsqrt.le
    change (@uniformUnitSphereMeasure n)
      (F ⁻¹' (((fun x : Fin n → ℝ => x i) ⁻¹' Set.Ioi c) ∩
        ((fun x : Fin n → ℝ => x j) ⁻¹' Set.Ioi c))) = 0
    rw [hempty, measure_empty]
  intro hIndep
  have hfactor := (hIndep.indepFun hij).measure_inter_preimage_eq_mul
    (Set.Ioi c) (Set.Ioi c) measurableSet_Ioi measurableSet_Ioi
  rw [hinter_zero, hmap_marginal i, hmap_marginal j] at hfactor
  exact (mul_ne_zero (ne_of_gt (hU_pos i)) (ne_of_gt (hU_pos j))) hfactor.symm

/-- The canonical spherical distribution in positive dimension is
isotropic. -/
theorem sphericalVectorMeasure_isIsotropic {n : ℕ} (hn : 0 < n) :
    Isotropy.IsIsotropic (sphericalVectorMeasure n)
      (fun i : Fin n ↦ fun x : Fin n → ℝ ↦ x i) := by
  rw [Isotropy.isIsotropic_iff_integral_mul]
  intro i j
  unfold sphericalVectorMeasure
  rw [integral_map (by fun_prop)]
  · simp only [Pi.smul_apply, smul_eq_mul]
    have hpoint (x : Metric.sphere
        (0 : EuclideanSpace ℝ (Fin n)) 1) :
        (Real.sqrt n * WithLp.ofLp (x : EuclideanSpace ℝ (Fin n)) i) *
            (Real.sqrt n * WithLp.ofLp (x : EuclideanSpace ℝ (Fin n)) j) =
          (Real.sqrt n * Real.sqrt n) *
            (unitSphereCoordinate i x * unitSphereCoordinate j x) := by
      simp only [unitSphereCoordinate]
      ring
    simp_rw [hpoint]
    rw [integral_const_mul, integral_unitSphereCoordinate_mul hn]
    have hsqrt : Real.sqrt (n : ℝ) * Real.sqrt (n : ℝ) = (n : ℝ) :=
      Real.mul_self_sqrt (Nat.cast_nonneg n)
    have hn0 : (n : ℝ) ≠ 0 := by exact_mod_cast (Nat.ne_of_gt hn)
    by_cases hij : i = j
    · simp [hij, hsqrt, hn0]
    · simp [hij]
  · fun_prop

/-- A finite random vector has the spherical law when its joint law is the
canonical uniform surface measure on the sphere of radius `√n`. -/
def HasSphericalLaw {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (μ : Measure Ω) (X : Fin n → Ω → ℝ) : Prop :=
  HasLaw (fun ω i => X i ω) (sphericalVectorMeasure n) μ

/-- In dimension at least two, the coordinates of every random vector with
the canonical spherical law are not mutually independent. -/
theorem not_iIndepFun_of_hasSphericalLaw
    {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    {μ : Measure Ω} {X : Fin n → Ω → ℝ}
    (hn : 2 ≤ n) (hX : HasSphericalLaw μ X) :
    ¬ iIndepFun X μ := by
  unfold HasSphericalLaw at hX
  have hn0 : 0 < n := lt_of_lt_of_le (by norm_num) hn
  letI : IsProbabilityMeasure (sphericalVectorMeasure n) :=
    sphericalVectorMeasure_isProbabilityMeasure hn0
  letI : IsProbabilityMeasure μ := hX.isProbabilityMeasure
  have hXi : ∀ i, AEMeasurable (X i) μ := by
    intro i
    exact (measurable_pi_apply i).aemeasurable.comp_aemeasurable hX.aemeasurable
  have hmarg (i : Fin n) :
      Measure.map (fun x : Fin n → ℝ => x i) (sphericalVectorMeasure n) =
        Measure.map (X i) μ := by
    rw [← hX.map_eq]
    rw [AEMeasurable.map_map_of_aemeasurable
      (measurable_pi_apply i).aemeasurable hX.aemeasurable]
    rfl
  intro hIndep
  apply not_iIndepFun_sphericalVectorMeasure hn
  apply (iIndepFun_iff_map_fun_eq_pi_map
    (fun i => (measurable_pi_apply i).aemeasurable)).2
  have hprod := (iIndepFun_iff_map_fun_eq_pi_map hXi).1 hIndep
  calc
    Measure.map (fun x : Fin n → ℝ => fun i => x i)
        (sphericalVectorMeasure n) = sphericalVectorMeasure n := by
      convert Measure.map_id
    _ = Measure.map (fun ω i => X i ω) μ := hX.map_eq.symm
    _ = Measure.pi (fun i => Measure.map (X i) μ) := hprod
    _ = Measure.pi (fun i =>
        Measure.map (fun x : Fin n → ℝ => x i) (sphericalVectorMeasure n)) := by
      congr 1
      funext i
      exact (hmarg i).symm

/-- The one-dimensional coordinate family is independent, showing that the
dimension assumption in `not_iIndepFun_sphericalVectorMeasure` is necessary. -/
theorem one_dimensional_coordinates_independent :
    iIndepFun (fun i : Fin 1 => fun x : Fin 1 → ℝ => x i)
      (sphericalVectorMeasure 1) := by
  letI : IsProbabilityMeasure (sphericalVectorMeasure 1) :=
    sphericalVectorMeasure_isProbabilityMeasure (by norm_num)
  exact iIndepFun.of_subsingleton

/-- A random vector with the canonical spherical law is isotropic in positive
dimension. -/
theorem isIsotropic_of_hasSphericalLaw {Ω : Type*} [MeasurableSpace Ω]
    {n : ℕ} { μ : Measure Ω} {X : Fin n → Ω → ℝ}
    (hn : 0 < n) (hX : HasSphericalLaw μ X) :
    Isotropy.IsIsotropic μ X := by
  rw [Isotropy.isIsotropic_iff_integral_mul]
  intro i j
  have htransfer := hX.integral_comp
    (f := fun x : Fin n → ℝ ↦ x i * x j) (by fun_prop)
  have hcanonical :=
    (Isotropy.isIsotropic_iff_integral_mul
      (sphericalVectorMeasure n)
      (fun i : Fin n ↦ fun x : Fin n → ℝ ↦ x i)).1
      (sphericalVectorMeasure_isIsotropic hn) i j
  exact htransfer.trans hcanonical

/-- The joint-law characterization of a spherical random vector. -/
theorem hasSphericalLaw_iff {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    {μ : Measure Ω} {X : Fin n → Ω → ℝ} :
    HasSphericalLaw μ X ↔
      HasLaw (fun ω i => X i ω) (sphericalVectorMeasure n) μ :=
  Iff.rfl

end NumStability.HDP.Vector.Spherical
