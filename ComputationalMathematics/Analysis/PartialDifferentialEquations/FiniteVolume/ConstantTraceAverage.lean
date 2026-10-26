/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.SpatialConstancy
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage

/-!
# Averaging a mapped constant trace

A selected trace constant on the positive-time integration interval has an
integrable image under any map into a real Banach space. Its normalized
time average is the image of the selected state.
-/

open MeasureTheory
namespace NumStability

/-- A trace constant on an open interval has an integrable mapped flux and
the expected average. Endpoint values and values outside the interval are free. -/
theorem oneDimensionalCellAverage_map_of_constantTraceOn
    {State E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]
    (flux : State → E) (field : ℝ → State) (state : State)
    (a b : ℝ) (hab : a < b)
    (htrace : ∀ τ ∈ Set.Ioo a b, field τ = state) :
    IntervalIntegrable (fun τ => flux (field τ)) volume a b ∧
      oneDimensionalCellAverage (fun τ => flux (field τ)) a b = flux state := by
  have heqOpen : (fun τ => flux (field τ)) =ᵐ[volume.restrict (Set.Ioo a b)]
      (fun _ => flux state) :=
    (ae_restrict_mem measurableSet_Ioo).mono (fun τ hτ => congrArg flux (htrace τ hτ))
  have heq : (fun τ => flux (field τ)) =ᵐ[volume.restrict (Set.uIoc a b)]
      (fun _ => flux state) := by
    rw [Set.uIoc_of_le hab.le]
    exact ae_restrict_of_ae_eq_of_ae_restrict Ioo_ae_eq_Ioc heqOpen
  refine ⟨(intervalIntegrable_congr_ae heq).mpr intervalIntegrable_const,?_⟩
  have hint := intervalIntegral.integral_congr_ae_restrict heq
  rw [oneDimensionalCellAverage,hint,intervalIntegral.integral_const]
  simp [smul_smul,(sub_pos.mpr hab).ne']

/-- A constant trace has an integrable mapped flux and the expected average.
No regularity of the map away from the selected state is needed. -/
theorem oneDimensionalCellAverage_map_of_constantTrace
    {State E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]
    (flux : State → E) (field : ℝ → State) (state : State)
    (timeStep : ℝ) (htime : 0 < timeStep)
    (htrace : ∀ τ ∈ Set.uIoc 0 timeStep, field τ = state) :
    IntervalIntegrable (fun τ => flux (field τ)) volume 0 timeStep ∧
      oneDimensionalCellAverage (fun τ => flux (field τ)) 0 timeStep = flux state := by
  apply oneDimensionalCellAverage_map_of_constantTraceOn flux field state 0 timeStep htime
  intro τ hτ
  exact htrace τ (by simpa only [Set.uIoc_of_le htime.le] using ⟨hτ.1,hτ.2.le⟩)

/-- The original physical-flux trace of a spatially constant integral-balance
solution has the expected average on every contained positive time interval. -/
theorem spatially_constant_integral_balance_physicalFluxAverage_on_Icc
    {m : ℕ} (q : ℝ → ℝ → (Fin m → ℝ))
    (physicalFlux : (Fin m → ℝ) → (Fin m → ℝ))
    (left right a b : ℝ) (hcell : left < right) (hab : a ≤ b)
    (hspatial : ∀ x t, x ∈ Set.Icc left right → t ∈ Set.Icc a b →
      q x t = q left t)
    (hbalance : ∀ t, t ∈ Set.Icc a b →
      (∫ x in left..right, q x t) - (∫ x in left..right, q x a) =
        ∫ τ in a..t, (physicalFlux (q left τ) - physicalFlux (q right τ)))
    (x start finish : ℝ) (hx : x ∈ Set.Icc left right)
    (hstart : a ≤ start) (hfinish : finish ≤ b) (htime : start < finish) :
    IntervalIntegrable (fun τ => physicalFlux (q x τ)) MeasureTheory.volume start finish ∧
      oneDimensionalCellAverage (fun τ => physicalFlux (q x τ)) start finish =
        physicalFlux (q left a) := by
  have hconst := spatially_constant_integral_balance_time_constant_on_Icc q physicalFlux
    left right a b hcell hab hspatial hbalance
  apply oneDimensionalCellAverage_map_of_constantTraceOn
    physicalFlux (fun τ => q x τ) (q left a) start finish htime
  intro τ hτ
  have hτ' : τ ∈ Set.Icc a b :=
    ⟨le_trans hstart hτ.1.le, le_trans hτ.2.le hfinish⟩
  rw [hspatial x τ hx hτ', hconst left τ ((show left ∈ Set.Icc left right from ⟨le_rfl, hcell.le⟩)) hτ']

end NumStability
