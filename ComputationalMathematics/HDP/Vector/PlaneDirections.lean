import Mathlib.Analysis.Fourier.AddCircle
import Mathlib.Analysis.SpecialFunctions.Integrals.Basic
import Mathlib.MeasureTheory.Group.Prod
import Mathlib.MeasureTheory.Integral.Prod

/-!
# Uniform unoriented directions in the plane

An unoriented direction in the plane is represented by an angle modulo `π`.
The metric distance on this additive circle is the acute angle between two
directions. This module computes its mean under two independent uniform laws.
-/

noncomputable section

open MeasureTheory Set
open scoped Interval

namespace NumStability.HDP.Vector

local instance : Fact (0 < Real.pi) := ⟨Real.pi_pos⟩

/-- An unoriented direction in the plane, represented by an angle modulo `π`. -/
abbrev PlaneDirection := AddCircle Real.pi

/-- The normalized Haar probability law on unoriented planar directions. -/
abbrev planeDirectionMeasure : Measure PlaneDirection := AddCircle.haarAddCircle

/-- A metric ball in the unoriented direction circle has its expected
normalized arc length.  This is the measure computation used by planar
hyperplane-separation arguments. -/
theorem planeDirectionMeasure_closedBall (x : PlaneDirection) (r : ℝ) :
    planeDirectionMeasure (Metric.closedBall x r) =
      ENNReal.ofReal (min Real.pi (2 * r) / Real.pi) := by
  have hpi : ENNReal.ofReal Real.pi ≠ 0 :=
    ENNReal.ofReal_ne_zero_iff.mpr Real.pi_pos
  have hvolume := @AddCircle.volume_closedBall Real.pi _ x r
  rw [AddCircle.volume_eq_smul_haarAddCircle, Measure.smul_apply] at hvolume
  simp only [smul_eq_mul] at hvolume
  rw [ENNReal.ofReal_div_of_pos Real.pi_pos]
  change AddCircle.haarAddCircle (Metric.closedBall x r) = _
  calc
    AddCircle.haarAddCircle (Metric.closedBall x r) =
        1 * AddCircle.haarAddCircle (Metric.closedBall x r) := by rw [one_mul]
    _ = (ENNReal.ofReal Real.pi)⁻¹ *
        (ENNReal.ofReal Real.pi *
          AddCircle.haarAddCircle (Metric.closedBall x r)) := by
      rw [← mul_assoc, ENNReal.inv_mul_cancel hpi (by finiteness), one_mul]
    _ = (ENNReal.ofReal Real.pi)⁻¹ *
        ENNReal.ofReal (min Real.pi (2 * r)) := by rw [hvolume]
    _ = ENNReal.ofReal (min Real.pi (2 * r)) /
        ENNReal.ofReal Real.pi := by
      rw [ENNReal.div_eq_inv_mul, mul_comm]

/-- The acute angle between two unoriented planar directions. -/
def acuteAngle (x y : PlaneDirection) : ℝ := dist x y

/-- The integral of `|x|` over the centered interval of length `π`. -/
theorem integral_abs_neg_half_pi_half_pi :
    (∫ x in -(Real.pi / 2)..Real.pi / 2, |x|) = Real.pi ^ 2 / 4 := by
  rw [← intervalIntegral.integral_add_adjacent_intervals (b := 0)
    (Continuous.intervalIntegrable continuous_abs _ _)
    (Continuous.intervalIntegrable continuous_abs _ _)]
  have hneg :
      (∫ x in -(Real.pi / 2)..0, |x|) =
        ∫ x in -(Real.pi / 2)..0, -x := by
    apply intervalIntegral.integral_congr
    intro x hx
    rw [uIcc_of_le (by linarith [Real.pi_pos])] at hx
    rw [abs_of_nonpos hx.2]
  have hpos :
      (∫ x in 0..Real.pi / 2, |x|) =
        ∫ x in 0..Real.pi / 2, x := by
    apply intervalIntegral.integral_congr
    intro x hx
    rw [uIcc_of_le (by linarith [Real.pi_pos])] at hx
    rw [abs_of_nonneg hx.1]
  rw [hneg, hpos, intervalIntegral.integral_neg, integral_id, integral_id]
  ring

/-- A uniform unoriented planar direction has mean distance `π / 4` from
the zero direction. -/
theorem integral_norm_planeDirectionMeasure :
    (∫ x : PlaneDirection, ‖x‖ ∂planeDirectionMeasure) = Real.pi / 4 := by
  rw [planeDirectionMeasure, AddCircle.integral_haarAddCircle]
  have hvolume :
      (∫ x : PlaneDirection, ‖x‖) = Real.pi ^ 2 / 4 := by
    rw [← AddCircle.intervalIntegral_preimage Real.pi (-(Real.pi / 2))]
    have hendpoint : -(Real.pi / 2) + Real.pi = Real.pi / 2 := by ring
    rw [hendpoint]
    calc
      (∫ x in -(Real.pi / 2)..Real.pi / 2,
          ‖(x : AddCircle Real.pi)‖) =
          ∫ x in -(Real.pi / 2)..Real.pi / 2, |x| := by
            apply intervalIntegral.integral_congr
            intro x hx
            rw [uIcc_of_le (by linarith [Real.pi_pos])] at hx
            apply (AddCircle.norm_coe_eq_abs_iff Real.pi Real.pi_ne_zero).2
            rw [abs_le]
            simpa [abs_of_pos Real.pi_pos] using hx
      _ = Real.pi ^ 2 / 4 := integral_abs_neg_half_pi_half_pi
  rw [hvolume]
  simp only [smul_eq_mul]
  field_simp

/-- The mean acute angle between two independent uniformly distributed
unoriented directions in the plane is `π / 4`. -/
theorem integral_acuteAngle_planeDirectionMeasure_prod :
    (∫ z : PlaneDirection × PlaneDirection,
        acuteAngle z.1 z.2 ∂planeDirectionMeasure.prod planeDirectionMeasure) =
      Real.pi / 4 := by
  let φ : PlaneDirection × PlaneDirection → PlaneDirection × PlaneDirection :=
    fun z => (z.1 - z.2, z.2)
  let μ := planeDirectionMeasure.prod planeDirectionMeasure
  have hpres : MeasurePreserving φ μ μ :=
    MeasureTheory.measurePreserving_sub_prod planeDirectionMeasure planeDirectionMeasure
  have hmeas : AEStronglyMeasurable
      (fun z : PlaneDirection × PlaneDirection => ‖z.1‖) (Measure.map φ μ) := by
    rw [hpres.map_eq]
    fun_prop
  calc
    (∫ z : PlaneDirection × PlaneDirection,
        acuteAngle z.1 z.2 ∂μ) =
        ∫ z : PlaneDirection × PlaneDirection, ‖z.1 - z.2‖ ∂μ := by
          simp [acuteAngle, dist_eq_norm]
    _ = ∫ z : PlaneDirection × PlaneDirection, ‖z.1‖ ∂Measure.map φ μ := by
          exact (integral_map hpres.measurable.aemeasurable hmeas).symm
    _ = ∫ z : PlaneDirection × PlaneDirection, ‖z.1‖ ∂μ := by rw [hpres.map_eq]
    _ = ∫ x : PlaneDirection, ‖x‖ ∂planeDirectionMeasure := by
          rw [MeasureTheory.integral_fun_fst, MeasureTheory.probReal_univ, one_smul]
    _ = Real.pi / 4 := integral_norm_planeDirectionMeasure

end NumStability.HDP.Vector
