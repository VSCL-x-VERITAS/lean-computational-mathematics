/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.Calculus.SecondOrderTaylor

import Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic
import Mathlib.MeasureTheory.Integral.Bochner.Basic
import Mathlib.MeasureTheory.Integral.IntervalIntegral.FundThmCalculus
import Mathlib.Analysis.Calculus.Deriv.Mul
import Mathlib.Analysis.Calculus.MeanValue
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

/-!
# One-dimensional finite-volume cell averages

Source-independent definitions for the average of a Banach-space-valued field
over an ordered, nondegenerate one-dimensional cell.  The accompanying
predicate records both nondegeneracy and interval integrability explicitly.
-/

open MeasureTheory
open scoped Interval

namespace NumStability

/-- A finite-volume grid represented by a nonempty measurable partition of a
chosen spatial domain.  Geometry-specific shape conditions are intentionally
left to downstream grid structures. -/
structure FiniteVolumeCellPartition (Cell Point : Type*)
    [MeasurableSpace Point] where
  /-- The spatial region covered by the modeled partition. -/
  domain : Set Point
  /-- The measurable spatial region assigned to each cell. -/
  cellRegion : Cell → Set Point
  cells_nonempty : Nonempty Cell
  measurable_cell : ∀ cell, MeasurableSet (cellRegion cell)
  disjoint_cells : ∀ {cell₁ cell₂}, cell₁ ≠ cell₂ →
    Disjoint (cellRegion cell₁) (cellRegion cell₂)
  covers_domain : ∀ point,
    point ∈ domain ↔ ∃ cell, point ∈ cellRegion cell

/-- A cellwise material property represented by the material-parameter value
obtained after averaging over that cell.  The wrapper keeps the role of an
assigned effective property distinct from the underlying spatial parameter
field without postulating an unconstrained conversion or suitability
predicate. -/
structure CellAveragedMaterialProperty (Parameter : Type*) where
  /-- The effective material parameter assigned after cell averaging. -/
  averagedParameter : Parameter

/-- A model-indexed rule for averaging material parameters over finite-volume
cells.  The rule is deliberately not fixed to an arithmetic, harmonic, or
tensor mean.  Its two laws capture the source-independent content of being a
cell average: changing a field outside the cell has no effect, and constant
fields are reproduced on positive finite-volume cells. -/
structure CellMaterialAveragingRule
    (Model Cell Point Parameter : Type*) [MeasurableSpace Point]
    (cellRegion : Cell → Set Point) where
  /-- Compute an effective parameter from a model, measure, cell, and
  spatially varying parameter field. -/
  averageParameter :
    Model → Measure Point → Cell → (Point → Parameter) → Parameter
  local_congr : ∀ model volumeMeasure cell field₁ field₂,
    Set.EqOn field₁ field₂ (cellRegion cell) →
      averageParameter model volumeMeasure cell field₁ =
        averageParameter model volumeMeasure cell field₂
  preserves_constants : ∀ model volumeMeasure cell parameter,
    volumeMeasure (cellRegion cell) ≠ 0 →
      volumeMeasure (cellRegion cell) ≠ ⊤ →
        averageParameter model volumeMeasure cell (fun _ => parameter) =
          parameter

/-- The normalized Bochner integral of a field over a measurable cell region.
The associated predicate below records the hypotheses under which this is a
genuine finite, positive-volume average. -/
noncomputable def cellVolumeAverage
    {Point E : Type*} [MeasurableSpace Point]
    [NormedAddCommGroup E] [NormedSpace ℝ E]
    (μ : Measure Point) (region : Set Point) (field : Point → E) : E :=
  (μ region).toReal⁻¹ • ∫ point in region, field point ∂μ

/-- `average` is the normalized volume average of `field` on `region`.
Positivity, finiteness, and integrability rule out the degenerate conventions
of `ENNReal.toReal` and the Bochner integral. -/
def IsCellVolumeAverage
    {Point E : Type*} [MeasurableSpace Point]
    [NormedAddCommGroup E] [NormedSpace ℝ E]
    (μ : Measure Point) (region : Set Point) (field : Point → E)
    (average : E) : Prop :=
  μ region ≠ 0 ∧
    μ region ≠ ⊤ ∧
    IntegrableOn field region μ ∧
    average = cellVolumeAverage μ region field

/-- The canonical normalized integral satisfies the volume-average predicate
on every finite, positive-volume cell where the field is integrable. -/
theorem cellVolumeAverage_isCellVolumeAverage
    {Point E : Type*} [MeasurableSpace Point]
    [NormedAddCommGroup E] [NormedSpace ℝ E]
    (μ : Measure Point) (region : Set Point) (field : Point → E)
    (hpositive : μ region ≠ 0) (hfinite : μ region ≠ ⊤)
    (hintegrable : IntegrableOn field region μ) :
    IsCellVolumeAverage μ region field
      (cellVolumeAverage μ region field) :=
  ⟨hpositive, hfinite, hintegrable, rfl⟩

/-- The average of a field over the one-dimensional interval from `left` to
`right`: its Bochner integral divided by the cell width.

Use `IsOneDimensionalCellAverage` when the mathematical assertion must also
record that the interval is nondegenerate and the field is integrable there.
-/
noncomputable def oneDimensionalCellAverage
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (field : ℝ → E) (left right : ℝ) : E :=
  (right - left)⁻¹ • ∫ x in left..right, field x

/-- `average` is the finite-volume average of `field` on an ordered,
nondegenerate cell, with interval integrability stated explicitly. -/
def IsOneDimensionalCellAverage
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (field : ℝ → E) (left right : ℝ) (average : E) : Prop :=
  left < right ∧
    IntervalIntegrable field volume left right ∧
      average = oneDimensionalCellAverage field left right

/-- The canonical average satisfies the cell-average predicate whenever the
cell is ordered and the field is interval integrable. -/
theorem oneDimensionalCellAverage_isCellAverage
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (field : ℝ → E) {left right : ℝ}
    (hcell : left < right)
    (hfield : IntervalIntegrable field volume left right) :
    IsOneDimensionalCellAverage field left right
      (oneDimensionalCellAverage field left right) :=
  ⟨hcell, hfield, rfl⟩

/-- Multiplying a cell average by its positive width recovers the cell
integral. -/
theorem cellWidth_smul_oneDimensionalCellAverage
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (field : ℝ → E) {left right : ℝ} (hcell : left < right) :
    (right - left) • oneDimensionalCellAverage field left right =
      ∫ x in left..right, field x := by
  have hwidth : right - left ≠ 0 := sub_ne_zero.mpr (ne_of_gt hcell)
  simp [oneDimensionalCellAverage, smul_smul, hwidth]

/-- Translation of a one-dimensional profile translates the cell
interval by the same amount without changing its width. -/
theorem oneDimensionalCellAverage_comp_sub_right
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (field : ℝ → E) (left right shift : ℝ) :
    oneDimensionalCellAverage (fun x => field (x - shift)) left right =
      oneDimensionalCellAverage field (left - shift) (right - shift) := by
  have hwidth : (right - shift) - (left - shift) = right - left := by ring
  simp only [oneDimensionalCellAverage, hwidth]
  rw [intervalIntegral.integral_comp_sub_right (f := field) (d := shift)]

/-- For a continuous real profile, the derivative of its fixed-width
cell-average function is the face-value difference divided by width. -/
theorem oneDimensionalCellAverage_hasDerivAt_center
    (profile : ℝ → ℝ) (width center : ℝ)
    (hprofile : Continuous profile) (hwidth : 0 < width) :
    HasDerivAt
      (fun c => oneDimensionalCellAverage profile (c - width / 2) (c + width / 2))
      ((profile (center + width / 2) - profile (center - width / 2)) / width)
      center := by
  let F : ℝ → ℝ := fun y => ∫ x in (0 : ℝ)..y, profile x
  have hF (y : ℝ) : HasDerivAt F (profile y) y :=
    hprofile.integral_hasStrictDerivAt 0 y |>.hasDerivAt
  have hu : HasDerivAt (fun c : ℝ => c + width / 2) 1 center := by
    convert (hasDerivAt_id center).add_const (width / 2) using 1
  have hl : HasDerivAt (fun c : ℝ => c - width / 2) 1 center := by
    convert (hasDerivAt_id center).sub_const (width / 2) using 1
  have hd : HasDerivAt
      (fun c => (F (c + width / 2) - F (c - width / 2)) / width)
      ((profile (center + width / 2) - profile (center - width / 2)) / width)
      center := by
    convert (((hF (center + width / 2)).comp center hu).sub
      ((hF (center - width / 2)).comp center hl)).mul_const width⁻¹ using 1 <;> simp [div_eq_mul_inv]
  have heq : (fun c => oneDimensionalCellAverage profile (c - width / 2) (c + width / 2)) =
      (fun c => (F (c + width / 2) - F (c - width / 2)) / width) := by
    funext c
    have hadd := intervalIntegral.integral_add_adjacent_intervals
      (hprofile.intervalIntegrable (μ := MeasureTheory.volume) 0 (c - width / 2))
      (hprofile.intervalIntegrable (μ := MeasureTheory.volume) (c - width / 2) (c + width / 2))
    have hwne : width ≠ 0 := ne_of_gt hwidth
    simp only [oneDimensionalCellAverage, smul_eq_mul]
    have hspan : c + width / 2 - (c - width / 2) = width := by ring
    rw [hspan]
    dsimp [F]
    have hinterval :
        (∫ x in c - width / 2..c + width / 2, profile x) =
          (∫ x in (0 : ℝ)..c + width / 2, profile x) -
          (∫ x in (0 : ℝ)..c - width / 2, profile x) := by
      linarith only [hadd]
    rw [hinterval]
    simp [div_eq_mul_inv, mul_comm]
  rw [heq]
  exact hd

open Set

/-- If the profile derivative is Lipschitz, the face-difference
formula for the derivative of its fixed-width cell average has
the same Lipschitz constant. -/
theorem oneDimensionalCellAverage_faceSlope_lipschitz
    (f f' : ℝ → ℝ) (K width x y : ℝ)
    (hwidth : 0 < width)
    (hf : ∀ z, HasDerivAt f (f' z) z)
    (hLip : ∀ a b, |f' a - f' b| ≤ K * |a - b|) :
    |(f (x + width / 2) - f (x - width / 2)) / width -
      (f (y + width / 2) - f (y - width / 2)) / width| ≤
      K * |x - y| := by
  let H : ℝ → ℝ := fun t => f (x + t) - f (y + t)
  have hH : ∀ t, HasDerivAt H (f' (x + t) - f' (y + t)) t := by
    intro t
    have hx : HasDerivAt (fun s : ℝ => x + s) 1 t := by
      convert (hasDerivAt_id t).const_add x using 1
    have hy : HasDerivAt (fun s : ℝ => y + s) 1 t := by
      convert (hasDerivAt_id t).const_add y using 1
    convert ((hf (x + t)).comp t hx).sub ((hf (y + t)).comp t hy) using 1 <;> simp [H]
  have hb : ∀ t ∈ Ico (-width / 2) (width / 2),
      ‖f' (x + t) - f' (y + t)‖ ≤ K * |x - y| := by
    intro t _
    rw [Real.norm_eq_abs]
    convert hLip (x + t) (y + t) using 1 <;> ring
  have hseg := norm_image_sub_le_of_norm_deriv_le_segment'
    (f := H) (a := -width / 2) (b := width / 2)
    (fun t _ => (hH t).hasDerivWithinAt) hb
    (width / 2) ⟨by linarith, le_refl _⟩
  have hraw : |(f (x + width / 2) - f (y + width / 2)) -
      (f (x - width / 2) - f (y - width / 2))| ≤
      K * |x - y| * width := by
    have hw : width / 2 - -width / 2 = width := by ring
    have hx : x + -width / 2 = x - width / 2 := by ring
    have hy : y + -width / 2 = y - width / 2 := by ring
    simpa only [H, Real.norm_eq_abs, hw, hx, hy] using hseg
  have hwne : width ≠ 0 := ne_of_gt hwidth
  have h := (div_le_iff₀ hwidth).mpr hraw
  convert h using 1
  rw [← sub_div, abs_div, abs_of_pos hwidth]
  congr 1
  ring

/-- Differentiating the face-difference slope differentiates the
profile at each face. This is the second center derivative of a
fixed-width cell average when the profile is twice differentiable. -/
theorem oneDimensionalCellAverage_faceSlope_hasDerivAt
    (f f' : ℝ → ℝ) (width center : ℝ)
    (hf : ∀ x, HasDerivAt f (f' x) x) :
    HasDerivAt
      (fun c => (f (c + width / 2) - f (c - width / 2)) / width)
      ((f' (center + width / 2) - f' (center - width / 2)) / width)
      center := by
  have hu : HasDerivAt (fun c : ℝ => c + width / 2) 1 center := by
    convert (hasDerivAt_id center).add_const (width / 2) using 1
  have hl : HasDerivAt (fun c : ℝ => c - width / 2) 1 center := by
    convert (hasDerivAt_id center).sub_const (width / 2) using 1
  convert (((hf (center + width / 2)).comp center hu).sub
    ((hf (center - width / 2)).comp center hl)).div_const width using 1 <;> simp

/-- The slope between neighboring exact cell averages approximates the profile derivative at their shared face to quadratic order. -/
theorem oneDimensionalCellAverage_centeredSlope_error_le
    (f f' f'' : ℝ → ℝ) (K face width : ℝ)
    (hK : 0 ≤ K) (hwidth : 0 < width)
    (hf : ∀ x, HasDerivAt f (f' x) x)
    (hf' : ∀ x, HasDerivAt f' (f'' x) x)
    (hLip : ∀ x y, |f'' x - f'' y| ≤ K * |x - y|) :
    |(oneDimensionalCellAverage f (face) (face + width) -
        oneDimensionalCellAverage f (face - width) face) / width -
      f' face| ≤ K * width ^ 2 / 2 := by
  let avg : ℝ → ℝ := fun c =>
    oneDimensionalCellAverage f (c - width / 2) (c + width / 2)
  let slope : ℝ → ℝ := fun c =>
    (f (c + width / 2) - f (c - width / 2)) / width
  let slope2 : ℝ → ℝ := fun c =>
    (f' (c + width / 2) - f' (c - width / 2)) / width
  have hc : Continuous f := continuous_iff_continuousAt.mpr (fun x => (hf x).continuousAt)
  have hAvg : ∀ c, HasDerivAt avg (slope c) c := by
    intro c
    exact oneDimensionalCellAverage_hasDerivAt_center f width c hc hwidth
  have hSlope : ∀ c, HasDerivAt slope (slope2 c) c := by
    intro c
    exact oneDimensionalCellAverage_faceSlope_hasDerivAt f f' width c hf
  have hSlopeLip : ∀ x y, |slope2 x - slope2 y| ≤ K * |x - y| := by
    intro x y
    exact oneDimensionalCellAverage_faceSlope_lipschitz f' f'' K width x y
      hwidth hf' hLip
  have h1 := centeredDifference_deriv_error_le_of_lipschitzSecondDeriv
    avg slope slope2 K face width hK hwidth hAvg hSlope hSlopeLip
  have h2 := centeredDifference_deriv_error_le_of_lipschitzSecondDeriv
    f f' f'' K face width hK hwidth hf hf' hLip
  have htri := abs_add_le
    ((avg (face + width / 2) - avg (face - width / 2)) / width - slope face)
    (slope face - f' face)
  have hbound : |(avg (face + width / 2) - avg (face - width / 2)) / width -
      f' face| ≤ K * width ^ 2 / 2 := by
    have hid : (avg (face + width / 2) - avg (face - width / 2)) / width -
        f' face =
      ((avg (face + width / 2) - avg (face - width / 2)) / width - slope face) +
        (slope face - f' face) := by ring
    rw [hid]
    linarith [h1, h2, htri]
  have hplus : avg (face + width / 2) =
      oneDimensionalCellAverage f face (face + width) := by
    dsimp [avg]
    congr 1 <;> ring
  have hminus : avg (face - width / 2) =
      oneDimensionalCellAverage f (face - width) face := by
    dsimp [avg]
    congr 1 <;> ring
  rw [hplus, hminus] at hbound
  exact hbound

/-- Averaging a continuous derivative gives the corresponding face difference quotient. -/
theorem oneDimensionalCellAverage_derivativeProfile_eq_faceSlope
    (f f' : ℝ → ℝ) (left right : ℝ)
    (hf : ∀ x, HasDerivAt f (f' x) x)
    (hf' : Continuous f') :
    oneDimensionalCellAverage f' left right =
      (f right - f left) / (right - left) := by
  have hInt : IntervalIntegrable f' volume left right :=
    hf'.intervalIntegrable _ _
  have h := intervalIntegral.integral_eq_sub_of_hasDerivAt
    (fun x _ => hf x) hInt
  simp only [oneDimensionalCellAverage, h, smul_eq_mul]
  ring

/-- The spatial derivative of an exact-average centered-slope error is the corresponding error for the profile derivative. -/
theorem oneDimensionalCellAverage_centeredSlopeError_hasDerivAt
    (f f' f'' : ℝ → ℝ) (width : ℝ)
    (hwidth : 0 < width)
    (hf : ∀ x, HasDerivAt f (f' x) x)
    (hf' : ∀ x, HasDerivAt f' (f'' x) x) :
    ∀ face, HasDerivAt
      (fun c => (oneDimensionalCellAverage f c (c + width) -
          oneDimensionalCellAverage f (c - width) c) / width - f' c)
      ((oneDimensionalCellAverage f' face (face + width) -
          oneDimensionalCellAverage f' (face - width) face) / width - f'' face)
      face := by
  let avg : ℝ → ℝ := fun c =>
    oneDimensionalCellAverage f (c - width / 2) (c + width / 2)
  let avgP : ℝ → ℝ := fun c =>
    oneDimensionalCellAverage f' (c - width / 2) (c + width / 2)
  have hc : Continuous f := continuous_iff_continuousAt.mpr (fun x => (hf x).continuousAt)
  have hcP : Continuous f' := continuous_iff_continuousAt.mpr (fun x => (hf' x).continuousAt)
  have hAvg : ∀ c, HasDerivAt avg (avgP c) c := by
    intro c
    have h := oneDimensionalCellAverage_hasDerivAt_center f width c hc hwidth
    have hface : (f (c + width / 2) - f (c - width / 2)) / width = avgP c := by
      change _ = oneDimensionalCellAverage f' (c - width / 2) (c + width / 2)
      rw [oneDimensionalCellAverage_derivativeProfile_eq_faceSlope f f' (c - width / 2) (c + width / 2) hf hcP]
      congr 1
      ring
    convert h using 1
    exact hface.symm
  intro face
  have hplus : HasDerivAt (fun c : ℝ => c + width / 2) 1 face := by
    convert (hasDerivAt_id face).add_const (width / 2) using 1
  have hminus : HasDerivAt (fun c : ℝ => c - width / 2) 1 face := by
    convert (hasDerivAt_id face).sub_const (width / 2) using 1
  have hraw := (((hAvg (face + width / 2)).comp face hplus).sub
    ((hAvg (face - width / 2)).comp face hminus)).div_const width |>.sub (hf' face)
  convert hraw using 1
  · funext c
    dsimp [avg]
    have hp : oneDimensionalCellAverage f
        (c + width / 2 - width / 2) (c + width / 2 + width / 2) =
        oneDimensionalCellAverage f c (c + width) := by
      congr 1 <;> ring
    have hm : oneDimensionalCellAverage f
        (c - width / 2 - width / 2) (c - width / 2 + width / 2) =
        oneDimensionalCellAverage f (c - width) c := by
      congr 1 <;> ring
    simp only [hp, hm]
  · dsimp [avgP]
    have hp : oneDimensionalCellAverage f'
        (face + width / 2 - width / 2) (face + width / 2 + width / 2) =
        oneDimensionalCellAverage f' face (face + width) := by
      congr 1 <;> ring
    have hm : oneDimensionalCellAverage f'
        (face - width / 2 - width / 2) (face - width / 2 + width / 2) =
        oneDimensionalCellAverage f' (face - width) face := by
      congr 1 <;> ring
    rw [hp, hm]
    ring

/-- Neighboring face-slope errors cancel to cubic order when the third derivative is Lipschitz. -/
theorem oneDimensionalCellAverage_centeredSlopeError_neighbor_bound
    (f f' f'' f''' : ℝ → ℝ) (K face width : ℝ)
    (hK : 0 ≤ K) (hwidth : 0 < width)
    (hf : ∀ x, HasDerivAt f (f' x) x)
    (hf' : ∀ x, HasDerivAt f' (f'' x) x)
    (hf'' : ∀ x, HasDerivAt f'' (f''' x) x)
    (hLip : ∀ x y, |f''' x - f''' y| ≤ K * |x - y|) :
    let err : ℝ → ℝ := fun c =>
      (oneDimensionalCellAverage f c (c + width) -
        oneDimensionalCellAverage f (c - width) c) / width - f' c
    |err (face + width) - err face| ≤ K * width ^ 3 / 2 := by
  intro err
  have hErr := oneDimensionalCellAverage_centeredSlopeError_hasDerivAt f f' f'' width
    hwidth hf hf'
  have hbound (y : ℝ) :
      |(oneDimensionalCellAverage f' y (y + width) -
        oneDimensionalCellAverage f' (y - width) y) / width - f'' y| ≤
        K * width ^ 2 / 2 :=
    oneDimensionalCellAverage_centeredSlope_error_le
      f' f'' f''' K y width hK hwidth hf' hf'' hLip
  have hseg : ∀ y ∈ Set.Ico face (face + width),
      ‖(oneDimensionalCellAverage f' y (y + width) -
        oneDimensionalCellAverage f' (y - width) y) / width - f'' y‖ ≤
        K * width ^ 2 / 2 := by
    intro y _
    rw [Real.norm_eq_abs]
    exact hbound y
  have hm := norm_image_sub_le_of_norm_deriv_le_segment'
    (f := err) (a := face) (b := face + width)
    (fun y _ => (hErr y).hasDerivWithinAt) hseg
    (face + width) ⟨by linarith, le_refl _⟩
  have hw : face + width - face = width := by ring
  rw [Real.norm_eq_abs, hw] at hm
  nlinarith [hm]

end NumStability
