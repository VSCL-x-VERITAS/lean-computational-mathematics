/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.TemporalDerivative
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Examples.MovingStep
import ComputationalMathematics.Source.LeVeque.Chapter04.Cell

/-!
# LeVeque equation (4.2): classical-reading discrepancy and local correction

The unrestricted ordinary-derivative reading fails when a transported jump
crosses a cell endpoint. The distinct correction differentiates actual local
rectangle conservation almost everywhere in time for the book's open grid cell.
Its exceptional null set may depend on the selected cell.

These declarations do not refute distributional conservation or establish
unspecified endpoint-trace conventions. The existing classical specialization
remains separate. Neither correction nor refutation is labeled source equivalence.
-/

namespace NumStability
open MeasureTheory Set

/-- Literal ordinary-derivative interpretation, separated from any correction. -/
def Leveque04Equation02PrintedClassicalClaim : Prop :=
  ∀ (q : ℝ → ℝ → ℝ) (flux : ℝ → ℝ),
    IsRectangleConservationLawSolution q flux →
    ∀ (a b t : ℝ), a < b → 0 < t →
      HasDerivAt (fun s => ∫ x in a..b, q x s)
        (flux (q a t)-flux (q b t)) t

/-- Separate discrepancy target; no claim that distributional differentiation fails. -/
def Leveque04Equation02ClassicalRefutationTarget : Prop :=
  ¬ Leveque04Equation02PrintedClassicalClaim

/-- Separately labeled local almost-everywhere correction for the actual open grid cell.
The exceptional set is allowed to depend on the selected cell. -/
def Leveque04Equation02LocalAECorrectionTarget : Prop :=
  ∀ (m : ℕ) (interface : ℤ → ℝ) (q : ℝ → ℝ → Fin m → ℝ)
      (flux : (Fin m → ℝ) → Fin m → ℝ) (left right horizon : ℝ) (i : ℤ),
    LocalConservationLaw.RectangleReferenceOn q flux left right horizon →
    0 ≤ horizon →
    interface (i-1) ∈ Icc left right → interface i ∈ Icc left right →
    interface (i-1) < interface i →
    ∀ᵐ t : ℝ, t ∈ Icc 0 horizon →
      HasDerivAt (fun s => ∫ x in leveque04_cell interface i, q x s)
        (flux (q (interface (i-1)) t)-flux (q (interface i) t)) t


theorem leveque04_equation02_classical_refuted :
    Leveque04Equation02ClassicalRefutationTarget := by
  intro h
  exact MovingStep.timeShiftedStep_no_classical_mass_derivative 0 1 _
    (h (MovingStep.timeShiftedStep 0 1) id (MovingStep.timeShiftedStep_rectangle 0 1)
      0 1 1 zero_lt_one zero_lt_one)

theorem leveque04_equation02_corrected_ae :
    Leveque04Equation02LocalAECorrectionTarget := by
  intro m interface q flux left right horizon i hreference hhorizon hleft hright hcell
  have hIntegral :
      (fun s : ℝ => ∫ x in leveque04_cell interface i, q x s) =
        (fun s : ℝ => ∫ x in (interface (i-1))..(interface i), q x s) := by
    funext s
    simp only [leveque04_cell]
    rw [intervalIntegral.integral_of_le hcell.le, integral_Ioc_eq_integral_Ioo]
  rw [hIntegral]
  exact hreference.hasDerivAt_mass_ae hhorizon hleft hright


end NumStability
