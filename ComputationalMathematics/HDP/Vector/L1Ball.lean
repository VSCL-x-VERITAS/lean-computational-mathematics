import ComputationalMathematics.HDP.Convex.Uniform
import Mathlib.Analysis.Normed.Lp.PiLp
import Mathlib.MeasureTheory.Measure.Lebesgue.VolumeOfBalls

/-!
# Uniform laws on finite-dimensional `ℓ₁` balls

This module supplies the geometric and measure-theoretic foundation for the
`ℓ₁`-ball example in high-dimensional probability.  It realizes the `ℓ₁`
gauge through Mathlib's finite `PiLp 1` space, proves that every positive-radius
ball is a convex body, and packages its normalized-volume probability law.
-/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Vector.L1Ball

/-- The continuous linear identification of ordinary coordinate functions
with the finite-dimensional `PiLp 1` space. -/
def toL1 (n : ℕ) :
    (Fin n → ℝ) ≃L[ℝ] PiLp 1 (fun _ : Fin n ↦ ℝ) :=
  (PiLp.continuousLinearEquiv 1 ℝ (fun _ : Fin n ↦ ℝ)).symm

/-- The closed `ℓ₁` ball of radius `r` in `ℝⁿ`. -/
def ball (n : ℕ) (r : ℝ) : Set (Fin n → ℝ) :=
  toL1 n ⁻¹' Metric.closedBall 0 r

/-- Membership in the `ℓ₁` ball is the usual coordinate absolute-value
inequality. -/
theorem mem_ball_iff {n : ℕ} {r : ℝ} {x : Fin n → ℝ} :
    x ∈ ball n r ↔ ∑ i, |x i| ≤ r := by
  simp [ball, toL1, Metric.mem_closedBall, dist_zero_right,
    PiLp.norm_eq_of_L1, Real.norm_eq_abs]

/-- Positive-radius finite-dimensional `ℓ₁` balls are convex bodies. -/
theorem isConvexBody_ball (n : ℕ) {r : ℝ} (hr : 0 < r) :
    NumStability.HDP.Convex.IsConvexBody (ball n r) := by
  refine ⟨?_, ?_, ?_⟩
  · exact (convex_closedBall (0 : PiLp 1 (fun _ : Fin n ↦ ℝ)) r).linear_preimage
      (toL1 n).toLinearMap
  · exact (toL1 n).antilipschitz.isBounded_preimage Metric.isBounded_closedBall
  · let U : Set (Fin n → ℝ) := toL1 n ⁻¹' Metric.ball 0 r
    have hUopen : IsOpen U :=
      Metric.isOpen_ball.preimage (toL1 n).continuous
    have hzero : (0 : Fin n → ℝ) ∈ U := by
      simp [U, hr]
    have hsub : U ⊆ ball n r := by
      exact Set.preimage_mono Metric.ball_subset_closedBall
    refine ⟨0, mem_interior_iff_mem_nhds.mpr ?_⟩
    exact Filter.mem_of_superset (hUopen.mem_nhds hzero) hsub

/-- Normalized Lebesgue volume on the `ℓ₁` ball. -/
def uniformMeasure (n : ℕ) (r : ℝ) : Measure (Fin n → ℝ) :=
  NumStability.HDP.Convex.uniformConvexBodyMeasure (ball n r)

/-- Normalized volume on a positive-radius `ℓ₁` ball is a probability
measure. -/
theorem uniformMeasure_isProbabilityMeasure (n : ℕ) {r : ℝ} (hr : 0 < r) :
    IsProbabilityMeasure (uniformMeasure n r) := by
  unfold uniformMeasure
  exact NumStability.HDP.Convex.uniformConvexBodyMeasure_isProbabilityMeasure
    (isConvexBody_ball n hr)

/-- Integration under normalized `ℓ₁`-ball volume is the corresponding set
integral divided by the ball's Lebesgue volume. -/
theorem integral_uniformMeasure {n : ℕ} {r : ℝ}
    (f : (Fin n → ℝ) → ℝ) :
    ∫ x, f x ∂uniformMeasure n r =
      ((volume (ball n r))⁻¹).toReal *
        ∫ x in ball n r, f x ∂volume := by
  simp [uniformMeasure, NumStability.HDP.Convex.uniformConvexBodyMeasure,
    ProbabilityTheory.cond, MeasureTheory.integral_smul_measure, smul_eq_mul]

/-- The exact Lebesgue volume of an `ℓ₁` ball in positive dimension. -/
theorem volume_ball {n : ℕ} (hn : 0 < n) (r : ℝ) :
    volume (ball n r) =
      (ENNReal.ofReal r) ^ n *
        ENNReal.ofReal ((2 : ℝ) ^ n / (n.factorial : ℝ)) := by
  letI : Nonempty (Fin n) := Fin.pos_iff_nonempty.mp hn
  have hset :
      ball n r =
        {x : Fin n → ℝ |
          (∑ i, |x i| ^ (1 : ℝ)) ^ (1 / (1 : ℝ)) ≤ r} := by
    ext x
    simp [mem_ball_iff, Real.rpow_one]
  rw [hset, MeasureTheory.volume_sum_rpow_le (Fin n) (p := (1 : ℝ)) (by norm_num)]
  have hGamma : Real.Gamma ((1 : ℝ) + 1) = 1 := by
    rw [show (1 : ℝ) + 1 = (1 : ℕ) + 1 by norm_num,
      Real.Gamma_nat_eq_factorial]
    norm_num
  simp [hGamma, Real.Gamma_nat_eq_factorial]

/-- Every coordinate hyperplane has zero ambient Lebesgue volume. -/
theorem volume_coord_hyperplane {n : ℕ} (i : Fin n) (a : ℝ) :
    volume {x : Fin n → ℝ | x i = a} = 0 := by
  rw [MeasureTheory.volume_pi]
  exact Measure.pi_hyperplane (fun _ : Fin n ↦ (volume : Measure ℝ)) i a

/-- The vector supported at coordinate `i` with value `t`. -/
def coordinateVector {n : ℕ} (i : Fin n) (t : ℝ) : Fin n → ℝ :=
  fun j => if j = i then t else 0

/-- Translation by `t` in coordinate `i`. -/
def coordinateShift {n : ℕ} (i : Fin n) (t : ℝ)
    (x : Fin n → ℝ) : Fin n → ℝ :=
  coordinateVector i t + x

@[simp] theorem coordinateShift_apply_same {n : ℕ} (i : Fin n) (t : ℝ)
    (x : Fin n → ℝ) : coordinateShift i t x i = t + x i := by
  simp [coordinateShift, coordinateVector]

@[simp] theorem coordinateShift_apply_ne {n : ℕ} (i j : Fin n)
    (hji : j ≠ i) (t : ℝ) (x : Fin n → ℝ) :
    coordinateShift i t x j = x j := by
  simp [coordinateShift, coordinateVector, hji]

/-- Shifting a vector with nonnegative selected coordinate farther into that
half-space increases its `ℓ₁` gauge by exactly the shift. -/
theorem sum_abs_coordinateShift_of_nonneg {n : ℕ} (i : Fin n) (t : ℝ)
    (x : Fin n → ℝ) (ht : 0 ≤ t) (hxi : 0 ≤ x i) :
    ∑ j, |coordinateShift i t x j| = t + ∑ j, |x j| := by
  classical
  rw [← Finset.sum_erase_add Finset.univ
      (fun j ↦ |coordinateShift i t x j|) (Finset.mem_univ i),
    ← Finset.sum_erase_add Finset.univ (fun j ↦ |x j|) (Finset.mem_univ i)]
  have htx : 0 ≤ t + x i := add_nonneg ht hxi
  simp only [coordinateShift_apply_same, abs_of_nonneg htx, abs_of_nonneg hxi]
  have hsum :
      ∑ j ∈ Finset.univ.erase i, |coordinateShift i t x j| =
        ∑ j ∈ Finset.univ.erase i, |x j| := by
    apply Finset.sum_congr rfl
    intro j hj
    have hji : j ≠ i := Finset.ne_of_mem_erase hj
    simp [coordinateShift_apply_ne i j hji]
  rw [hsum]
  ring

/-- Shifting a vector with nonpositive selected coordinate farther into that
half-space increases its `ℓ₁` gauge by exactly the shift magnitude. -/
theorem sum_abs_coordinateShift_neg_of_nonpos {n : ℕ} (i : Fin n) (t : ℝ)
    (x : Fin n → ℝ) (ht : 0 ≤ t) (hxi : x i ≤ 0) :
    ∑ j, |coordinateShift i (-t) x j| = t + ∑ j, |x j| := by
  classical
  rw [← Finset.sum_erase_add Finset.univ
      (fun j ↦ |coordinateShift i (-t) x j|) (Finset.mem_univ i),
    ← Finset.sum_erase_add Finset.univ (fun j ↦ |x j|) (Finset.mem_univ i)]
  have htx : -t + x i ≤ 0 := by linarith
  simp only [coordinateShift_apply_same, abs_of_nonpos htx, abs_of_nonpos hxi]
  have hsum :
      ∑ j ∈ Finset.univ.erase i, |coordinateShift i (-t) x j| =
        ∑ j ∈ Finset.univ.erase i, |x j| := by
    apply Finset.sum_congr rfl
    intro j hj
    have hji : j ≠ i := Finset.ne_of_mem_erase hj
    simp [coordinateShift_apply_ne i j hji]
  rw [hsum]
  ring

/-- A positive coordinate cap is the translation of the nonnegative half of
a smaller `ℓ₁` ball. -/
theorem coordinateShift_preimage_positiveCap {n : ℕ} (i : Fin n) {r t : ℝ}
    (ht : 0 ≤ t) :
    coordinateShift i t ⁻¹'
        (ball n r ∩ {x : Fin n → ℝ | t ≤ x i}) =
      ball n (r - t) ∩ {x : Fin n → ℝ | 0 ≤ x i} := by
  ext x
  simp only [Set.mem_preimage, Set.mem_inter_iff, Set.mem_setOf_eq, mem_ball_iff]
  constructor
  · rintro ⟨hball, hcoord⟩
    have hxi : 0 ≤ x i := by
      rw [coordinateShift_apply_same] at hcoord
      linarith
    have hsum := sum_abs_coordinateShift_of_nonneg i t x ht hxi
    rw [hsum] at hball
    exact ⟨by linarith, hxi⟩
  · rintro ⟨hball, hxi⟩
    have hsum := sum_abs_coordinateShift_of_nonneg i t x ht hxi
    constructor
    · rw [hsum]
      linarith
    · rw [coordinateShift_apply_same]
      linarith

/-- A negative coordinate cap is the translation of the nonpositive half of
a smaller `ℓ₁` ball. -/
theorem coordinateShift_preimage_negativeCap {n : ℕ} (i : Fin n) {r t : ℝ}
    (ht : 0 ≤ t) :
    coordinateShift i (-t) ⁻¹'
        (ball n r ∩ {x : Fin n → ℝ | x i ≤ -t}) =
      ball n (r - t) ∩ {x : Fin n → ℝ | x i ≤ 0} := by
  ext x
  simp only [Set.mem_preimage, Set.mem_inter_iff, Set.mem_setOf_eq, mem_ball_iff]
  constructor
  · rintro ⟨hball, hcoord⟩
    have hxi : x i ≤ 0 := by
      rw [coordinateShift_apply_same] at hcoord
      linarith
    have hsum := sum_abs_coordinateShift_neg_of_nonpos i t x ht hxi
    rw [hsum] at hball
    exact ⟨by linarith, hxi⟩
  · rintro ⟨hball, hxi⟩
    have hsum := sum_abs_coordinateShift_neg_of_nonpos i t x ht hxi
    constructor
    · rw [hsum]
      linarith
    · rw [coordinateShift_apply_same]
      linarith

/-- The unnormalized mass of an absolute-coordinate tail is exactly the
volume of the `ℓ₁` ball whose radius is shortened by the threshold. -/
theorem volume_abs_coord_tail_ball {n : ℕ} (i : Fin n) {r t : ℝ}
    (ht : 0 ≤ t) :
    volume (ball n r ∩ {x : Fin n → ℝ | t ≤ |x i|}) =
      volume (ball n (r - t)) := by
  let P : Set (Fin n → ℝ) := ball n (r - t) ∩ {x | 0 ≤ x i}
  let N : Set (Fin n → ℝ) := ball n (r - t) ∩ {x | x i ≤ 0}
  let Cpos : Set (Fin n → ℝ) := ball n r ∩ {x | t ≤ x i}
  let Cneg : Set (Fin n → ℝ) := ball n r ∩ {x | x i ≤ -t}
  have hpre_pos : coordinateShift i t ⁻¹' Cpos = P := by
    simpa [P, Cpos] using coordinateShift_preimage_positiveCap i (r := r) ht
  have hpre_neg : coordinateShift i (-t) ⁻¹' Cneg = N := by
    simpa [N, Cneg] using coordinateShift_preimage_negativeCap i (r := r) ht
  have hvol_pos : volume Cpos = volume P := by
    have h := measure_preimage_add volume (coordinateVector i t) Cpos
    change volume (coordinateShift i t ⁻¹' Cpos) = volume Cpos at h
    rw [hpre_pos] at h
    exact h.symm
  have hvol_neg : volume Cneg = volume N := by
    have h := measure_preimage_add volume (coordinateVector i (-t)) Cneg
    change volume (coordinateShift i (-t) ⁻¹' Cneg) = volume Cneg at h
    rw [hpre_neg] at h
    exact h.symm
  have hball_union : ball n (r - t) = P ∪ N := by
    ext x
    constructor
    · intro hx
      rcases le_total 0 (x i) with hxi | hxi
      · exact Or.inl ⟨hx, hxi⟩
      · exact Or.inr ⟨hx, hxi⟩
    · rintro (hx | hx) <;> exact hx.1
  have htail_union :
      ball n r ∩ {x : Fin n → ℝ | t ≤ |x i|} = Cpos ∪ Cneg := by
    ext x
    constructor
    · rintro ⟨hxball, hxtail⟩
      rcases le_total 0 (x i) with hxi | hxi
      · left
        exact ⟨hxball, by simpa [abs_of_nonneg hxi] using hxtail⟩
      · right
        exact ⟨hxball, by
          change t ≤ |x i| at hxtail
          change x i ≤ -t
          rw [abs_of_nonpos hxi] at hxtail
          linarith⟩
    · rintro (hx | hx)
      · exact ⟨hx.1, by simpa [abs_of_nonneg (le_trans ht hx.2)] using hx.2⟩
      · dsimp [Cneg] at hx
        rcases hx with ⟨hxball, hxneg⟩
        change x i ≤ -t at hxneg
        have hxi : x i ≤ 0 := le_trans hxneg (neg_nonpos.mpr ht)
        exact ⟨hxball, by
          change t ≤ |x i|
          rw [abs_of_nonpos hxi]
          linarith⟩
  have hPN : AEDisjoint volume P N := by
    unfold AEDisjoint
    apply measure_mono_null _ (volume_coord_hyperplane i 0)
    rintro x ⟨hxP, hxN⟩
    exact le_antisymm hxN.2 hxP.2
  have hCC : AEDisjoint volume Cpos Cneg := by
    unfold AEDisjoint
    apply measure_mono_null _ (volume_coord_hyperplane i 0)
    rintro x ⟨hxP, hxN⟩
    dsimp [Cpos, Cneg] at hxP hxN
    rcases hxP with ⟨_, hxP⟩
    rcases hxN with ⟨_, hxN⟩
    change t ≤ x i at hxP
    change x i ≤ -t at hxN
    have hxi0 : x i = 0 := by linarith
    exact hxi0
  have hNmeas : MeasurableSet N := by
    apply MeasurableSet.inter
    · exact (toL1 n).continuous.measurable measurableSet_closedBall
    · exact measurableSet_le (measurable_pi_apply i) measurable_const
  have hCnegmeas : MeasurableSet Cneg := by
    apply MeasurableSet.inter
    · exact (toL1 n).continuous.measurable measurableSet_closedBall
    · exact measurableSet_le (measurable_pi_apply i) measurable_const
  calc
    volume (ball n r ∩ {x : Fin n → ℝ | t ≤ |x i|}) =
        volume (Cpos ∪ Cneg) := congrArg volume htail_union
    _ = volume Cpos + volume Cneg :=
      measure_union₀ hCnegmeas.nullMeasurableSet hCC
    _ = volume P + volume N := by rw [hvol_pos, hvol_neg]
    _ = volume (P ∪ N) :=
      (measure_union₀ hNmeas.nullMeasurableSet hPN).symm
    _ = volume (ball n (r - t)) := congrArg volume hball_union.symm

/-- Exact probability of an absolute-coordinate tail under normalized
`ℓ₁`-ball volume, in extended-nonnegative form. -/
theorem uniformMeasure_abs_coord_tail {n : ℕ} (hn : 0 < n)
    (i : Fin n) {r t : ℝ} (hr : 0 < r) (ht : 0 ≤ t) :
    uniformMeasure n r {x : Fin n → ℝ | t ≤ |x i|} =
      ENNReal.ofReal ((r - t) / r) ^ n := by
  have hball_meas : MeasurableSet (ball n r) :=
    (toL1 n).continuous.measurable measurableSet_closedBall
  unfold uniformMeasure NumStability.HDP.Convex.uniformConvexBodyMeasure
  rw [ProbabilityTheory.cond_apply hball_meas,
    volume_abs_coord_tail_ball i ht, volume_ball hn, volume_ball hn]
  let c : ENNReal := ENNReal.ofReal ((2 : ℝ) ^ n / (n.factorial : ℝ))
  have hC0 : c ≠ 0 := by
    exact (ENNReal.ofReal_pos.mpr (by positivity)).ne'
  have hCt : c ≠ ⊤ := ENNReal.ofReal_ne_top
  have hA0 : ENNReal.ofReal r ^ n ≠ 0 :=
    pow_ne_zero _ (ENNReal.ofReal_pos.mpr hr).ne'
  have hAt : ENNReal.ofReal r ^ n ≠ ⊤ :=
    ENNReal.pow_ne_top ENNReal.ofReal_ne_top
  change ((ENNReal.ofReal r ^ n) * c)⁻¹ *
      (ENNReal.ofReal (r - t) ^ n * c) = _
  rw [ENNReal.mul_inv (Or.inl hA0) (Or.inl hAt)]
  calc
    (ENNReal.ofReal r ^ n)⁻¹ * c⁻¹ *
          (ENNReal.ofReal (r - t) ^ n * c) =
        ((ENNReal.ofReal r ^ n)⁻¹ * ENNReal.ofReal (r - t) ^ n) *
          (c⁻¹ * c) := by ac_rfl
    _ = (ENNReal.ofReal r ^ n)⁻¹ * ENNReal.ofReal (r - t) ^ n := by
      rw [ENNReal.inv_mul_cancel hC0 hCt, mul_one]
    _ = ENNReal.ofReal (r - t) ^ n / ENNReal.ofReal r ^ n := by
      rw [ENNReal.div_eq_inv_mul]
    _ = (ENNReal.ofReal (r - t) / ENNReal.ofReal r) ^ n := by
      simp only [ENNReal.div_eq_inv_mul, mul_pow, ENNReal.inv_pow]
    _ = ENNReal.ofReal ((r - t) / r) ^ n := by
      rw [ENNReal.ofReal_div_of_pos hr]

/-- Real-valued form of the exact absolute-coordinate tail probability. -/
theorem uniformMeasure_abs_coord_tail_real {n : ℕ} (hn : 0 < n)
    (i : Fin n) {r t : ℝ} (hr : 0 < r) (ht : 0 ≤ t) (htr : t ≤ r) :
    (uniformMeasure n r).real {x : Fin n → ℝ | t ≤ |x i|} =
      ((r - t) / r) ^ n := by
  have h := congrArg ENNReal.toReal
    (uniformMeasure_abs_coord_tail hn i hr ht)
  simpa [Measure.real, ENNReal.toReal_ofReal,
    div_nonneg (sub_nonneg.mpr htr) hr.le] using h

/-- At half the radius, every absolute coordinate has the exact tail mass
`2⁻ⁿ`. -/
theorem uniformMeasure_abs_coord_half_radius_real {n : ℕ} (hn : 0 < n)
    (i : Fin n) {r : ℝ} (hr : 0 < r) :
    (uniformMeasure n r).real {x : Fin n → ℝ | r / 2 ≤ |x i|} =
      (1 / 2 : ℝ) ^ n := by
  rw [uniformMeasure_abs_coord_tail_real hn i hr (by positivity) (by linarith)]
  congr 1
  field_simp
  ring

/-- The radius for which normalized `ℓ₁`-ball volume has unit coordinate
second moments.  The moment identity itself is proved separately. -/
def isotropicRadius (n : ℕ) : ℝ :=
  Real.sqrt ((((n : ℝ) + 1) * ((n : ℝ) + 2)) / 2)

theorem isotropicRadius_pos (n : ℕ) : 0 < isotropicRadius n := by
  unfold isotropicRadius
  positivity

/-- The exact isotropic radius has the linear-in-dimension scale asserted by
the source exercise. -/
theorem isotropicRadius_linear_bounds {n : ℕ} (hn : 0 < n) :
    (n : ℝ) / 2 ≤ isotropicRadius n ∧
      isotropicRadius n ≤ 2 * n := by
  have hn' : (1 : ℝ) ≤ n := by exact_mod_cast hn
  have harg :
      0 ≤ (((n : ℝ) + 1) * ((n : ℝ) + 2)) / 2 := by positivity
  have hsquare := Real.sq_sqrt harg
  have hsqrt := Real.sqrt_nonneg
    ((((n : ℝ) + 1) * ((n : ℝ) + 2)) / 2)
  unfold isotropicRadius
  constructor <;> nlinarith

end NumStability.HDP.Vector.L1Ball
