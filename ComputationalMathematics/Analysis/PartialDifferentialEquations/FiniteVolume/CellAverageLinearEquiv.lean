/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage
import Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic
import Mathlib.MeasureTheory.SpecificCodomains.Pi
import Mathlib.Topology.Algebra.Module.FiniteDimension

/-!
# Linear coordinate changes and finite-volume cell averages

An invertible linear change of coordinates commutes with a normalized
Bochner cell integral for interval-integrable fields in finite-dimensional
real normed spaces.
-/

namespace NumStability

/-- A finite-dimensional real linear equivalence commutes with the
one-dimensional normalized cell average. -/
theorem oneDimensionalCellAverage_linearEquiv
    {E F : Type*}
    [NormedAddCommGroup E] [NormedSpace ℝ E] [FiniteDimensional ℝ E]
    [NormedAddCommGroup F] [NormedSpace ℝ F] [FiniteDimensional ℝ F]
    (coordinates : E ≃ₗ[ℝ] F)
    (field : ℝ → E) (left right : ℝ)
    (hfield : IntervalIntegrable field MeasureTheory.volume left right) :
    oneDimensionalCellAverage (fun x => coordinates (field x)) left right =
      coordinates (oneDimensionalCellAverage field left right) := by
  simp only [oneDimensionalCellAverage]
  have hcomm :
      (∫ x in left..right, coordinates (field x)) =
        coordinates (∫ x in left..right, field x) := by
    simpa only [LinearEquiv.coe_toContinuousLinearEquiv'] using
      (ContinuousLinearMap.intervalIntegral_comp_comm
        coordinates.toContinuousLinearEquiv.toContinuousLinearMap hfield)
  rw [hcomm]
  exact (map_smul coordinates _ _).symm

/-- A coordinate of a finite vector cell average is the scalar cell
average of that coordinate. -/
theorem oneDimensionalCellAverage_apply
    {m : ℕ} (field : ℝ → (Fin m → ℝ)) (left right : ℝ)
    (hfield : IntervalIntegrable field MeasureTheory.volume left right)
    (p : Fin m) :
    oneDimensionalCellAverage field left right p =
      oneDimensionalCellAverage (fun x => field x p) left right := by
  simp only [oneDimensionalCellAverage, Pi.smul_apply, smul_eq_mul]
  have hcomm := ContinuousLinearMap.intervalIntegral_comp_comm
    (ContinuousLinearMap.proj (R := ℝ) p : (Fin m → ℝ) →L[ℝ] ℝ)
    hfield
  simpa only [ContinuousLinearMap.proj_apply] using
    congrArg (fun z : ℝ => (right - left)⁻¹ * z) hcomm.symm

/-- Interval integrability of a finite real vector field is equivalent
to interval integrability of all its scalar coordinates. -/
theorem intervalIntegrable_pi_iff
    {m : ℕ} (field : ℝ → (Fin m → ℝ)) (left right : ℝ) :
    IntervalIntegrable field MeasureTheory.volume left right ↔
      ∀ p, IntervalIntegrable (fun x => field x p)
        MeasureTheory.volume left right := by
  constructor
  · intro h p
    exact ⟨h.1.eval p, h.2.eval p⟩
  · intro h
    exact ⟨MeasureTheory.Integrable.of_eval (fun p => (h p).1),
      MeasureTheory.Integrable.of_eval (fun p => (h p).2)⟩

end NumStability
