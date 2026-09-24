import ComputationalMathematics.HDP.Vector.L1Ball
import ComputationalMathematics.HDP.Vector.Isotropy
import Mathlib.MeasureTheory.Integral.Prod
import Mathlib.MeasureTheory.Constructions.Pi
import Mathlib.Analysis.SpecialFunctions.Gamma.Beta
import Mathlib.Analysis.SpecialFunctions.Pow.Integral
import Mathlib.MeasureTheory.Measure.Lebesgue.Integral

/-!
# Coordinate moments of uniform finite-dimensional `ℓ₁` balls

This module splits off one coordinate by the volume-preserving finite-product
equivalence, identifies the remaining cross-section with a lower-dimensional
`ℓ₁` ball, and records the one-dimensional beta integral used for exact
second moments.
-/

noncomputable section

open scoped BigOperators ENNReal
open Set MeasureTheory

namespace NumStability.HDP.Vector.L1Ball

/-- The lower-dimensional section of an `ℓ₁` ball at coordinate value `t`. -/
def coordinateSection (n : ℕ) (r t : ℝ) : Set (Fin n → ℝ) :=
  ball n (r - |t|)

/-- The product-space presentation obtained after splitting one coordinate. -/
def splitBall (n : ℕ) (r : ℝ) : Set (ℝ × (Fin n → ℝ)) :=
  {z | |z.1| + ∑ j, |z.2 j| ≤ r}

/-- A compact coordinate box containing the product-space presentation. -/
def boundingBox (n : ℕ) (r : ℝ) : Set (ℝ × (Fin n → ℝ)) :=
  Icc (-r) r ×ˢ Icc (fun _ ↦ -r) (fun _ ↦ r)

theorem continuous_sum_abs {n : ℕ} :
    Continuous (fun x : Fin n → ℝ ↦ ∑ j, |x j|) := by
  fun_prop

theorem measurableSet_coordinateSection {n : ℕ} (r t : ℝ) :
    MeasurableSet (coordinateSection n r t) := by
  rw [show coordinateSection n r t =
      {x : Fin n → ℝ | ∑ j, |x j| ≤ r - |t|} by
    ext x
    simp [coordinateSection, mem_ball_iff]]
  exact measurableSet_le continuous_sum_abs.measurable measurable_const

theorem measurableSet_splitBall {n : ℕ} (r : ℝ) :
    MeasurableSet (splitBall n r) := by
  exact measurableSet_le
    ((continuous_abs.comp continuous_fst).add
      (continuous_sum_abs.comp continuous_snd)).measurable
    measurable_const

theorem splitBall_subset_boundingBox {n : ℕ} {r : ℝ} :
    splitBall n r ⊆ boundingBox n r := by
  rintro ⟨t, y⟩ hty
  simp only [splitBall, Set.mem_setOf_eq] at hty
  have hsum_nonneg : 0 ≤ ∑ j, |y j| :=
    Finset.sum_nonneg fun j _ ↦ abs_nonneg (y j)
  have ht_abs : |t| ≤ r :=
    le_trans (le_add_of_nonneg_right hsum_nonneg) hty
  have ht : t ∈ Icc (-r) r := abs_le.mp ht_abs
  have hy : y ∈ Icc (fun _ ↦ -r) (fun _ ↦ r) := by
    constructor
    · intro j
      have hj_sum : |y j| ≤ ∑ k, |y k| :=
        Finset.single_le_sum (fun k _ ↦ abs_nonneg (y k)) (Finset.mem_univ j)
      exact (abs_le.mp (le_trans hj_sum
        (le_trans (le_add_of_nonneg_left (abs_nonneg t)) hty))).1
    · intro j
      have hj_sum : |y j| ≤ ∑ k, |y k| :=
        Finset.single_le_sum (fun k _ ↦ abs_nonneg (y k)) (Finset.mem_univ j)
      exact (abs_le.mp (le_trans hj_sum
        (le_trans (le_add_of_nonneg_left (abs_nonneg t)) hty))).2
  exact ⟨ht, hy⟩

theorem coordinate_square_integrableOn_splitBall {n : ℕ} {r : ℝ} :
    IntegrableOn (fun z : ℝ × (Fin n → ℝ) ↦ z.1 ^ 2)
      (splitBall n r) volume := by
  apply IntegrableOn.mono_set _ splitBall_subset_boundingBox
  exact (continuous_fst.pow 2).continuousOn.integrableOn_compact
    (isCompact_Icc.prod isCompact_Icc)

theorem sum_abs_insertNth {n : ℕ} (i : Fin (n + 1))
    (t : ℝ) (y : Fin n → ℝ) :
    ∑ j, |i.insertNth t y j| = |t| + ∑ j, |y j| := by
  rw [Fin.sum_univ_succAbove (fun j ↦ |i.insertNth t y j|) i]
  simp

/-- Splitting coordinate `i` converts the coordinate-square set integral to
the corresponding product-space integral. -/
theorem coordinate_square_change_variables {n : ℕ} (r : ℝ)
    (i : Fin (n + 1)) :
    (∫ x in ball (n + 1) r, (x i) ^ 2) =
      ∫ z : ℝ × (Fin n → ℝ) in splitBall n r, z.1 ^ 2 := by
  let e : (Fin (n + 1) → ℝ) ≃ᵐ ℝ × (Fin n → ℝ) :=
    MeasurableEquiv.piFinSuccAbove (fun _ ↦ ℝ) i
  have he : MeasurePreserving e :=
    volume_preserving_piFinSuccAbove (fun _ : Fin (n + 1) ↦ ℝ) i
  have h := he.symm.setIntegral_preimage_emb e.symm.measurableEmbedding
    (fun x : Fin (n + 1) → ℝ ↦ (x i) ^ 2) (ball (n + 1) r)
  have hpre : e.symm ⁻¹' ball (n + 1) r = splitBall n r := by
    ext z
    change e.symm z ∈ ball (n + 1) r ↔ z ∈ splitBall n r
    rw [mem_ball_iff]
    change (∑ j, |i.insertNth z.1 z.2 j| ≤ r) ↔ _
    rw [sum_abs_insertNth]
    simp [splitBall]
  have hfun : (fun z : ℝ × (Fin n → ℝ) ↦ (e.symm z i) ^ 2) =
      (fun z ↦ z.1 ^ 2) := by
    funext z
    simp [e, MeasurableEquiv.piFinSuccAbove_symm_apply,
      Fin.insertNthEquiv_apply]
  rw [← h, hpre, hfun]

/-- Fubini cross-section formula for a coordinate-square set integral over an
`ℓ₁` ball. -/
theorem coordinate_square_cross_section {n : ℕ} (r : ℝ)
    (i : Fin (n + 1)) :
    (∫ x in ball (n + 1) r, (x i) ^ 2) =
      ∫ t : ℝ, t ^ 2 * (volume (coordinateSection n r t)).toReal := by
  rw [coordinate_square_change_variables r i]
  rw [← integral_indicator (measurableSet_splitBall r)]
  rw [Measure.volume_eq_prod]
  rw [integral_prod _
    (coordinate_square_integrableOn_splitBall.integrable_indicator
      (measurableSet_splitBall r))]
  apply integral_congr_ae
  filter_upwards with t
  have hfun : (fun y : Fin n → ℝ ↦
      (splitBall n r).indicator (fun z ↦ z.1 ^ 2) (t, y)) =
      (coordinateSection n r t).indicator (fun _ ↦ t ^ 2) := by
    funext y
    by_cases hy : y ∈ coordinateSection n r t
    · have hty : (t, y) ∈ splitBall n r := by
        simp [coordinateSection, mem_ball_iff, splitBall] at hy ⊢
        linarith
      simp [Set.indicator_of_mem hy, Set.indicator_of_mem hty]
    · have hty : (t, y) ∉ splitBall n r := by
        simp [coordinateSection, mem_ball_iff, splitBall] at hy ⊢
        linarith
      simp [Set.indicator_of_notMem hy, Set.indicator_of_notMem hty]
  rw [hfun, integral_indicator (measurableSet_coordinateSection r t), setIntegral_const,
    measureReal_def, smul_eq_mul]
  ring

/-- Cross-section formula after substituting the exact lower-dimensional
`ℓ₁`-ball volume. -/
theorem coordinate_square_cross_section_volume {n : ℕ} (hn : 0 < n)
    (r : ℝ) (i : Fin (n + 1)) :
    (∫ x in ball (n + 1) r, (x i) ^ 2) =
      ∫ t : ℝ, t ^ 2 *
        (ENNReal.ofReal (r - |t|) ^ n *
          ENNReal.ofReal ((2 : ℝ) ^ n / n.factorial)).toReal := by
  rw [coordinate_square_cross_section r i]
  simp_rw [coordinateSection, volume_ball hn]

/-- Beta-integral form of the one-dimensional coordinate-square moment. -/
theorem integral_sq_mul_sub_pow_eq_beta {n : ℕ} {r : ℝ} (hr : 0 < r) :
    (∫ t : ℝ in 0..r, t ^ 2 * (r - t) ^ n) =
      ((r : ℂ) ^ (n + 3) * Complex.betaIntegral 3 (n + 1)).re := by
  have h := Complex.betaIntegral_scaled (3 : ℂ) (n + 1 : ℂ) hr
  have hs : (3 : ℂ) - 1 = (2 : ℕ) := by norm_num
  have ht : (n + 1 : ℂ) - 1 = (n : ℕ) := by ring
  have hst : (3 : ℂ) + (n + 1 : ℂ) - 1 = (n + 3 : ℕ) := by
    push_cast
    ring
  rw [hs, ht, hst] at h
  simp only [Complex.cpow_natCast] at h
  have hre := congrArg Complex.re h
  simpa [← Complex.ofReal_pow, ← Complex.ofReal_sub, ← Complex.ofReal_mul,
    intervalIntegral.integral_ofReal] using hre

theorem betaIntegral_three_nat_add_one (n : ℕ) :
    Complex.betaIntegral 3 (n + 1) =
      ((2 * n.factorial / (n + 3).factorial : ℝ) : ℂ) := by
  rw [Complex.betaIntegral_eq_Gamma_mul_div]
  · have hg : Complex.Gamma ((3 : ℂ) + (n + 1 : ℂ)) =
        (n + 3).factorial := by
      simpa [Nat.cast_add, add_assoc, add_comm, add_left_comm] using
        Complex.Gamma_nat_eq_factorial (n + 3)
    rw [hg]
    norm_num [Complex.Gamma_nat_eq_factorial]
  · norm_num
  · change 0 < (n : ℝ) + 1
    positivity

/-- Closed form of the scaled beta integral used by the exact coordinate
second-moment computation. -/
theorem integral_sq_mul_sub_pow {n : ℕ} {r : ℝ} (hr : 0 < r) :
    (∫ t : ℝ in 0..r, t ^ 2 * (r - t) ^ n) =
      r ^ (n + 3) * (2 * n.factorial / (n + 3).factorial) := by
  rw [integral_sq_mul_sub_pow_eq_beta hr, betaIntegral_three_nat_add_one]
  rw [show (r : ℂ) ^ (n + 3) = ((r ^ (n + 3) : ℝ) : ℂ) by simp]
  simp only [Complex.mul_re, Complex.ofReal_re, Complex.ofReal_im, mul_zero,
    sub_zero]

/-- Elementary polynomial integral underlying the layer-cake computation of
the normalized coordinate second moment. -/
theorem integral_mul_sub_pow (n : ℕ) (r : ℝ) :
    (∫ t in (0 : ℝ)..r, t * (r - t) ^ n) =
      r ^ (n + 2) /
        (((n + 1 : ℕ) : ℝ) * ((n + 2 : ℕ) : ℝ)) := by
  have hpoint (t : ℝ) :
      t * (r - t) ^ n = r * (r - t) ^ n - (r - t) ^ (n + 1) := by
    rw [pow_succ]
    ring
  have hpow (k : ℕ) :
      IntervalIntegrable (fun t : ℝ ↦ (r - t) ^ k) volume 0 r :=
    ((continuous_const.sub continuous_id).pow k).intervalIntegrable 0 r
  simp_rw [hpoint]
  rw [intervalIntegral.integral_sub ((hpow n).const_mul _) (hpow (n + 1)),
    intervalIntegral.integral_const_mul]
  rw [intervalIntegral.integral_comp_sub_left (fun u : ℝ ↦ u ^ n) r,
    intervalIntegral.integral_comp_sub_left (fun u : ℝ ↦ u ^ (n + 1)) r]
  simp only [sub_self, sub_zero, integral_pow]
  push_cast
  field_simp
  ring

private def sectionConstant (n : ℕ) : ℝ :=
  (2 : ℝ) ^ n / n.factorial

private theorem sectionConstant_nonneg (n : ℕ) : 0 ≤ sectionConstant n := by
  unfold sectionConstant
  positivity

/-- Real volume of every coordinate section, including the zero-dimensional
section at the endpoint. -/
theorem coordinateSection_volume_toReal (n : ℕ) {r t : ℝ} :
    (volume (coordinateSection n r t)).toReal =
      if |t| ≤ r then (r - |t|) ^ n * sectionConstant n else 0 := by
  cases n with
  | zero =>
      by_cases htr : |t| ≤ r
      · have hset : coordinateSection 0 r t = Set.univ := by
          ext x
          simp [coordinateSection, mem_ball_iff, htr]
        rw [hset, MeasureTheory.volume_pi, Measure.pi_univ]
        simp [sectionConstant, htr]
      · have hset : coordinateSection 0 r t = ∅ := by
          ext x
          simp [coordinateSection, mem_ball_iff, htr]
        rw [hset]
        simp [htr]
  | succ n =>
      rw [coordinateSection, volume_ball (Nat.succ_pos n), ENNReal.toReal_mul,
        ENNReal.toReal_pow]
      by_cases htr : |t| ≤ r
      · rw [ENNReal.toReal_ofReal (sub_nonneg.mpr htr),
          ENNReal.toReal_ofReal (by positivity :
            0 ≤ (2 : ℝ) ^ (n + 1) / ((n + 1).factorial : ℝ))]
        simp [sectionConstant, htr]
      · have hneg : r - |t| ≤ 0 := by linarith
        rw [ENNReal.ofReal_eq_zero.mpr hneg]
        simp [htr]

/-- An even, compactly supported coordinate-section integral is twice its
positive-half interval integral. -/
theorem integral_abs_truncated_sq (n : ℕ) {r c : ℝ} (hr : 0 < r) :
    (∫ t : ℝ, t ^ 2 *
      (if |t| ≤ r then (r - |t|) ^ n * c else 0)) =
      2 * ((∫ t : ℝ in 0..r, t ^ 2 * (r - t) ^ n) * c) := by
  let f : ℝ → ℝ := fun u ↦
    if u ≤ r then u ^ 2 * (r - u) ^ n * c else 0
  have hwhole : (fun t : ℝ ↦ t ^ 2 *
      (if |t| ≤ r then (r - |t|) ^ n * c else 0)) =
      (fun t ↦ f |t|) := by
    funext t
    by_cases htr : |t| ≤ r
    · simp [f, htr, sq_abs]
      ring
    · simp [f, htr]
  have hind : (Set.Ioi 0).indicator f =
      (Set.Ioc 0 r).indicator (fun u ↦ u ^ 2 * (r - u) ^ n * c) := by
    funext u
    by_cases hu : 0 < u
    · by_cases hur : u ≤ r
      · simp [f, hu, hur]
      · simp [f, hu, hur]
    · have hnot : u ∉ Set.Ioc 0 r := by simp [hu]
      simp [f, hu, hnot]
  have hhalf : (∫ u : ℝ in Set.Ioi 0, f u) =
      (∫ u : ℝ in 0..r, u ^ 2 * (r - u) ^ n) * c := by
    rw [← integral_indicator measurableSet_Ioi, hind,
      integral_indicator measurableSet_Ioc,
      ← intervalIntegral.integral_of_le hr.le,
      intervalIntegral.integral_mul_const]
  rw [hwhole, integral_comp_abs, hhalf]

/-- Exact unnormalized coordinate-square integral in dimension `n + 1`. -/
theorem coordinate_square_setIntegral {n : ℕ} {r : ℝ} (hr : 0 < r)
    (i : Fin (n + 1)) :
    (∫ x in ball (n + 1) r, (x i) ^ 2) =
      (2 : ℝ) ^ (n + 2) * r ^ (n + 3) / (n + 3).factorial := by
  rw [coordinate_square_cross_section r i]
  simp_rw [coordinateSection_volume_toReal]
  rw [integral_abs_truncated_sq n hr, integral_sq_mul_sub_pow hr]
  unfold sectionConstant
  have hnfac : (n.factorial : ℝ) ≠ 0 := by positivity
  have hn3fac : ((n + 3).factorial : ℝ) ≠ 0 := by positivity
  field_simp
  ring

/-- Exact normalized coordinate second moment in dimension `n + 1`. -/
theorem coordinate_square_uniformMeasure {n : ℕ} {r : ℝ} (hr : 0 < r)
    (i : Fin (n + 1)) :
    (∫ x, (x i) ^ 2 ∂uniformMeasure (n + 1) r) =
      2 * r ^ 2 / (((n : ℝ) + 2) * ((n : ℝ) + 3)) := by
  rw [integral_uniformMeasure, coordinate_square_setIntegral hr i,
    volume_ball (Nat.succ_pos n) r, ENNReal.toReal_inv,
    ENNReal.toReal_mul, ENNReal.toReal_pow,
    ENNReal.toReal_ofReal hr.le,
    ENNReal.toReal_ofReal (by positivity :
      0 ≤ (2 : ℝ) ^ (n + 1) / ((n + 1).factorial : ℝ))]
  have hr0 : r ≠ 0 := hr.ne'
  have hn1fac : ((n + 1).factorial : ℝ) ≠ 0 := by positivity
  have hn3fac : ((n + 3).factorial : ℝ) ≠ 0 := by positivity
  have hfac : (n + 3).factorial =
      (n + 3) * (n + 2) * (n + 1).factorial := by
    rw [show n + 3 = (n + 2) + 1 by omega, Nat.factorial_succ,
      show n + 2 = (n + 1) + 1 by omega, Nat.factorial_succ]
    simp [Nat.mul_assoc]
  rw [hfac]
  field_simp
  push_cast
  simp only [pow_succ]
  ring

/-- Exact unnormalized coordinate-square integral in every positive
dimension. -/
theorem coordinate_square_setIntegral_posdim {d : ℕ} (hd : 0 < d)
    {r : ℝ} (hr : 0 < r) (i : Fin d) :
    (∫ x in ball d r, (x i) ^ 2) =
      (2 : ℝ) ^ (d + 1) * r ^ (d + 2) / (d + 2).factorial := by
  cases d with
  | zero => omega
  | succ n =>
      simpa [Nat.succ_eq_add_one, add_assoc] using
        coordinate_square_setIntegral (n := n) hr i

/-- Exact normalized coordinate second moment in every positive dimension. -/
theorem coordinate_square_uniformMeasure_posdim {d : ℕ} (hd : 0 < d)
    {r : ℝ} (hr : 0 < r) (i : Fin d) :
    (∫ x, (x i) ^ 2 ∂uniformMeasure d r) =
      2 * r ^ 2 / (((d : ℝ) + 1) * ((d : ℝ) + 2)) := by
  cases d with
  | zero => omega
  | succ n =>
      rw [coordinate_square_uniformMeasure (n := n) hr i]
      push_cast
      ring

/-- Every coordinate has unit second moment at the configured isotropic
radius. -/
theorem isotropicRadius_coordinate_square_uniformMeasure {d : ℕ}
    (hd : 0 < d) (i : Fin d) :
    (∫ x, (x i) ^ 2 ∂uniformMeasure d (isotropicRadius d)) = 1 := by
  rw [coordinate_square_uniformMeasure_posdim hd (isotropicRadius_pos d) i]
  unfold isotropicRadius
  have harg : 0 ≤ ((((d : ℝ) + 1) * ((d : ℝ) + 2)) / 2) := by positivity
  rw [Real.sq_sqrt harg]
  have h1 : (d : ℝ) + 1 ≠ 0 := by positivity
  have h2 : (d : ℝ) + 2 ≠ 0 := by positivity
  field_simp

/-- Reflection in coordinate `i`. -/
def coordinateSignFlip {n : ℕ} (i : Fin n)
    (x : Fin n → ℝ) : Fin n → ℝ :=
  fun j ↦ if j = i then -x j else x j

@[simp] theorem coordinateSignFlip_apply_same {n : ℕ} (i : Fin n)
    (x : Fin n → ℝ) : coordinateSignFlip i x i = -x i := by
  simp [coordinateSignFlip]

@[simp] theorem coordinateSignFlip_apply_ne {n : ℕ} (i j : Fin n)
    (hji : j ≠ i) (x : Fin n → ℝ) : coordinateSignFlip i x j = x j := by
  simp [coordinateSignFlip, hji]

/-- Coordinate reflection as a measurable equivalence. -/
def coordinateSignFlipEquiv {n : ℕ} (i : Fin n) :
    (Fin n → ℝ) ≃ᵐ (Fin n → ℝ) := by
  classical
  exact MeasurableEquiv.piCongrRight (fun j ↦
    if j = i then MeasurableEquiv.neg ℝ else MeasurableEquiv.refl ℝ)

theorem coordinateSignFlipEquiv_apply {n : ℕ} (i : Fin n)
    (x : Fin n → ℝ) :
    coordinateSignFlipEquiv i x = coordinateSignFlip i x := by
  classical
  funext j
  by_cases hji : j = i
  · simp [coordinateSignFlipEquiv, MeasurableEquiv.piCongrRight,
      Equiv.piCongrRight_apply, coordinateSignFlip, hji]
  · simp [coordinateSignFlipEquiv, MeasurableEquiv.piCongrRight,
      Equiv.piCongrRight_apply, coordinateSignFlip, hji]

/-- Coordinate reflection preserves product Lebesgue volume. -/
theorem coordinateSignFlip_volume_preserving {n : ℕ} (i : Fin n) :
    MeasurePreserving (coordinateSignFlipEquiv i) volume volume := by
  classical
  let es : Fin n → ℝ ≃ᵐ ℝ := fun j ↦
    if j = i then MeasurableEquiv.neg ℝ else MeasurableEquiv.refl ℝ
  have hes : ∀ j, MeasurePreserving (es j) volume volume := fun j ↦ by
    by_cases hji : j = i
    · subst j
      dsimp [es]
      rw [if_pos rfl]
      change MeasurePreserving (fun x : ℝ ↦ -x) volume volume
      exact Measure.measurePreserving_neg (volume : Measure ℝ)
    · dsimp [es]
      rw [if_neg hji]
      change MeasurePreserving (fun x : ℝ ↦ x) volume volume
      exact MeasurePreserving.id (volume : Measure ℝ)
  have h := MeasureTheory.volume_preserving_pi hes
  simpa [coordinateSignFlipEquiv, es, MeasurableEquiv.piCongrRight,
    Equiv.piCongrRight_apply] using h

theorem coordinateSignFlip_preimage_ball {n : ℕ} (i : Fin n) (r : ℝ) :
    coordinateSignFlipEquiv i ⁻¹' ball n r = ball n r := by
  classical
  ext x
  rw [Set.mem_preimage, mem_ball_iff, mem_ball_iff,
    coordinateSignFlipEquiv_apply]
  have hsum : ∑ j, |coordinateSignFlip i x j| = ∑ j, |x j| := by
    apply Finset.sum_congr rfl
    intro j _
    by_cases hji : j = i
    · subst j
      simp
    · simp [coordinateSignFlip_apply_ne i j hji]
  rw [hsum]

/-- Distinct-coordinate products integrate to zero over every centered
`ℓ₁` ball. -/
theorem coordinate_mul_setIntegral_eq_zero {n : ℕ} {r : ℝ}
    (i j : Fin n) (hij : i ≠ j) :
    (∫ x in ball n r, x i * x j) = 0 := by
  let e := coordinateSignFlipEquiv i
  have he : MeasurePreserving e volume volume :=
    coordinateSignFlip_volume_preserving i
  have h := he.setIntegral_preimage_emb e.measurableEmbedding
    (fun x : Fin n → ℝ ↦ x i * x j) (ball n r)
  have hpre : e ⁻¹' ball n r = ball n r :=
    coordinateSignFlip_preimage_ball i r
  rw [hpre] at h
  have hfun : (fun x : Fin n → ℝ ↦ e x i * e x j) =
      (fun x ↦ -(x i * x j)) := by
    funext x
    rw [show e x = coordinateSignFlip i x from
      coordinateSignFlipEquiv_apply i x]
    simp [coordinateSignFlip_apply_ne i j (Ne.symm hij)]
  rw [hfun, integral_neg] at h
  linarith

/-- Distinct coordinates have zero mixed second moment under normalized
`ℓ₁`-ball volume. -/
theorem coordinate_mul_uniformMeasure_eq_zero {n : ℕ} {r : ℝ}
    (i j : Fin n) (hij : i ≠ j) :
    (∫ x, x i * x j ∂uniformMeasure n r) = 0 := by
  rw [integral_uniformMeasure, coordinate_mul_setIntegral_eq_zero i j hij,
    mul_zero]

/-- Normalized volume on the `ℓ₁` ball at `isotropicRadius` is isotropic in
the source's uncentered second-moment sense. -/
theorem uniformMeasure_isIsotropic {d : ℕ} (hd : 0 < d) :
    NumStability.HDP.Vector.Isotropy.IsIsotropic
      (uniformMeasure d (isotropicRadius d))
      (fun i (x : Fin d → ℝ) ↦ x i) := by
  rw [NumStability.HDP.Vector.Isotropy.isIsotropic_iff_integral_mul]
  intro i j
  by_cases hij : i = j
  · subst j
    simp only [ite_true]
    simpa [pow_two] using isotropicRadius_coordinate_square_uniformMeasure hd i
  · rw [if_neg hij, coordinate_mul_uniformMeasure_eq_zero i j hij]

end NumStability.HDP.Vector.L1Ball
