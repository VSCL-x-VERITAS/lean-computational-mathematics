/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.LocalRectangleReference
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageAE
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLipschitzTrace
import Mathlib.Tactic.Abel

/-!
# Exact cell mass balance from a local physical reference

Local rectangle conservation supplies the normalized spatial mass change
and time-averaged physical face fluxes on each contained forward rectangle.
No whole-line or all-time reference is required.
-/

open MeasureTheory
namespace NumStability

/-- Local rectangle conservation gives the exact normalized cell mass
change through the time-averaged physical fluxes at its actual faces. -/
theorem rectangleReferenceOn_cellAverage_mass_balance
    {m : ℕ} (q : ℝ → ℝ → Fin m → ℝ)
    (flux : (Fin m → ℝ) → Fin m → ℝ) (left right horizon a b s t : ℝ)
    (hq : LocalConservationLaw.RectangleReferenceOn q flux left right horizon)
    (ha : a ∈ Set.Icc left right) (hb : b ∈ Set.Icc left right)
    (hs : s ∈ Set.Icc 0 horizon) (ht : t ∈ Set.Icc 0 horizon)
    (hab : a < b) (hst : s < t) :
    (b - a) • (oneDimensionalCellAverage (fun x => q x t) a b -
      oneDimensionalCellAverage (fun x => q x s) a b) =
      (t - s) • (oneDimensionalCellAverage (fun τ => flux (q a τ)) s t -
        oneDimensionalCellAverage (fun τ => flux (q b τ)) s t) := by
  have htime (x : ℝ) (hx : x ∈ Set.Icc left right) :
      IntervalIntegrable (fun τ => flux (q x τ)) volume s t :=
    (hq.2.1 x hx).mono_set
      (Set.uIcc_subset_uIcc (Set.Icc_subset_uIcc hs) (Set.Icc_subset_uIcc ht))
  rw [smul_sub, cellWidth_smul_oneDimensionalCellAverage _ hab,
    cellWidth_smul_oneDimensionalCellAverage _ hab, hq.2.2 a ha b hb s hs t ht,
    intervalIntegral.integral_sub (htime a ha) (htime b hb), smul_sub,
    cellWidth_smul_oneDimensionalCellAverage _ hst,
    cellWidth_smul_oneDimensionalCellAverage _ hst]

/-- Local physical conservation and the known initial cell average give the normalized conservative update. -/
theorem rectangleReferenceOn_cellAverage_step_of_initial
    {m : ℕ} (q : ℝ → ℝ → Fin m → ℝ)
    (flux : (Fin m → ℝ) → Fin m → ℝ) (initial : Fin m → ℝ)
    (left right horizon a b : ℝ)
    (hq : LocalConservationLaw.RectangleReferenceOn q flux left right horizon)
    (ha : a ∈ Set.Icc left right) (hb : b ∈ Set.Icc left right)
    (hab : a < b) (hhorizon : 0 < horizon)
    (hinitial : oneDimensionalCellAverage (fun x => q x 0) a b = initial) :
    oneDimensionalCellAverage (fun x => q x horizon) a b =
      initial - (horizon / (b - a)) •
        (oneDimensionalCellAverage (fun time => flux (q b time)) 0 horizon -
          oneDimensionalCellAverage (fun time => flux (q a time)) 0 horizon) := by
  have hbalance := rectangleReferenceOn_cellAverage_mass_balance q flux left right horizon a b 0 horizon
    hq ha hb ⟨le_refl _, hhorizon.le⟩ ⟨hhorizon.le, le_refl _⟩ hab hhorizon
  rw [sub_zero, hinitial] at hbalance
  have hscaled := congrArg (fun v => (b - a)⁻¹ • v) hbalance
  simp only [smul_smul, inv_mul_cancel₀ (sub_pos.mpr hab).ne', one_smul] at hscaled
  have hcoefficient : (b - a)⁻¹ * horizon = horizon / (b - a) := by ring
  rw [hcoefficient] at hscaled
  calc
    _ = (horizon / (b - a)) •
        (oneDimensionalCellAverage (fun time => flux (q a time)) 0 horizon -
          oneDimensionalCellAverage (fun time => flux (q b time)) 0 horizon) + initial :=
      (sub_eq_iff_eq_add).mp hscaled
    _ = _ := by rw [smul_sub, smul_sub]; abel

/-- Local rectangle conservation with almost-everywhere constant initial and boundary
traces determines the terminal cell mean and supplies its integrability. -/
def RectangleBoundaryMeanPrerequisiteAf976Proposal : Prop :=
  ∀ (d : ℕ) (q : ℝ → ℝ → Fin d → ℝ)
    (flux : (Fin d → ℝ) → Fin d → ℝ)
    (initial leftFlux rightFlux : Fin d → ℝ) (a b step : ℝ),
    a < b → 0 < step →
    LocalConservationLaw.RectangleReferenceOn q flux a b step →
    ((fun x => q x 0) =ᵐ[volume.restrict (Set.uIoc a b)] (fun _ => initial)) →
    ((fun t => flux (q a t)) =ᵐ[volume.restrict (Set.uIoc 0 step)]
      (fun _ => leftFlux)) →
    ((fun t => flux (q b t)) =ᵐ[volume.restrict (Set.uIoc 0 step)]
      (fun _ => rightFlux)) →
    IntervalIntegrable (fun x => q x step) volume a b ∧
    oneDimensionalCellAverage (fun x => q x step) a b =
      initial - (step / (b - a)) • (rightFlux - leftFlux)
/-- The local conservation reference and constant traces imply the terminal
integrability and conservative cell-average formula. -/
theorem rectangleBoundaryMeanPrerequisiteAf976 :
    RectangleBoundaryMeanPrerequisiteAf976Proposal := by
  intro d q flux initial leftFlux rightFlux a b step hab hstep hq hinitial hleft hright
  have hi : oneDimensionalCellAverage (fun x => q x 0) a b = initial :=
    (oneDimensionalCellAverage_congr_ae hinitial).trans
      (oneDimensionalCellAverage_const initial a b (ne_of_lt hab))
  have hl : oneDimensionalCellAverage (fun t => flux (q a t)) 0 step = leftFlux :=
    (oneDimensionalCellAverage_congr_ae hleft).trans
      (oneDimensionalCellAverage_const leftFlux 0 step (ne_of_lt hstep))
  have hr : oneDimensionalCellAverage (fun t => flux (q b t)) 0 step = rightFlux :=
    (oneDimensionalCellAverage_congr_ae hright).trans
      (oneDimensionalCellAverage_const rightFlux 0 step (ne_of_lt hstep))
  have he := rectangleReferenceOn_cellAverage_step_of_initial q flux initial
    a b step a b hq ⟨le_rfl, hab.le⟩ ⟨hab.le, le_rfl⟩ hab hstep hi
  rw [hl, hr] at he
  exact ⟨hq.1 step ⟨hstep.le, le_rfl⟩, he⟩
end NumStability
