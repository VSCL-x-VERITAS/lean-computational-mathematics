/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.REAPointMeasurement
import ComputationalMathematics.Source.LeVeque.Chapter04.REAInputQualifiedResidual
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.PositiveRectangleEquivalence

/-!
# A fixed measured criterion for the actual conservative rectangle certificate

The carrier is the existing weak conservative path. The defect is literally
its same-flux rectangle defect. Every positive forward rectangle is tested by
singleton counting/evaluation, with the original width-times-envelope-integral
budget. Integrability and nonnegativity of the prescribed envelope remain an
explicit input qualification. There is no exact-reference or smoothness premise.
-/

noncomputable section
open Set MeasureTheory

namespace NumStability.REA.ConservativeRectangleResidual

theorem field_determines_defect {m : ℕ} (flux : State m → State m)
    (i : Input m) (w v : ConservativePath flux i)
    (he : ∀ x, ∀ t ∈ Icc 0 i.step, w.field x t = v.field x t) :
    (fun r : ForwardRectangle i.step => RectangleDefect flux w.field r) =
      fun r => RectangleDefect flux v.field r := by
  funext r
  have hstart : r.start ∈ Icc 0 i.step :=
    ⟨r.start_nonneg, r.time_pos.le.trans r.stop_le⟩
  have hstop : r.stop ∈ Icc 0 i.step :=
    ⟨r.start_nonneg.trans r.time_pos.le, r.stop_le⟩
  have hmass (t : ℝ) (ht : t ∈ Icc 0 i.step) (a b : ℝ) :
      (∫ x in a..b, w.field x t) = ∫ x in a..b, v.field x t :=
    intervalIntegral.integral_congr (fun x _ => he x t ht)
  have hboundary :
      (∫ t in r.start..r.stop, flux (w.field r.left t) - flux (w.field r.right t)) =
        ∫ t in r.start..r.stop, flux (v.field r.left t) - flux (v.field r.right t) := by
    apply intervalIntegral.integral_congr
    intro t ht
    rw [uIcc_of_le r.time_pos.le] at ht
    have hti : t ∈ Icc 0 i.step :=
      ⟨r.start_nonneg.trans ht.1, ht.2.trans r.stop_le⟩
    change flux (w.field r.left t) - flux (w.field r.right t) =
      flux (v.field r.left t) - flux (v.field r.right t)
    rw [he r.left t hti, he r.right t hti]
  unfold RectangleDefect
  rw [hmass r.stop hstop r.left r.right, hmass r.start hstart r.left r.right, hboundary]

/-- Equation compatibility is derived from the existing actual rectangle law
and the orientation theorem, on the unchanged weak integrability carrier. -/
theorem equation_iff_zero_defect {m : ℕ} (flux : State m → State m)
    (i : Input m) (w : ConservativePath flux i) :
    ConservativeIVP flux i.initial i.step w.field ↔
      ∀ r : ForwardRectangle i.step, RectangleDefect flux w.field r = 0 := by
  change ((∀ x, w.field x 0 = i.initial x) ∧ _) ↔ _
  rw [and_iff_right w.initial]
  rw [LocalConservationLaw.rectangleReferenceOn_all_iff_positive_defect
    w.field flux i.step w.spatial_integrable w.flux_integrable]
  constructor
  · intro h r
    exact h r.left r.right r.space_pos r.start r.stop r.start_nonneg r.time_pos r.stop_le
  · intro h a b hab s t hs hst ht
    exact h ⟨a, b, s, t, hab, hs, hst, ht⟩

/-- The actual vector-valued conservative defect, indexed by every positive
forward rectangle with the explicitly full measurable space. -/
def presentation {m : ℕ} (flux : State m → State m) (hm : 0 < m) :
    ResidualPresentation (ConservativeIVP flux) where
  components := m
  components_pos := hm
  Path := ConservativePath flux
  Index := fun i => ForwardRectangle i.step
  indexMeasurableSpace := fun _ => ⊤
  field := fun _ w => w.field
  same_initial := fun _ w => w.initial
  defect := fun _ w r => RectangleDefect flux w.field r
  field_determines_defect := field_determines_defect flux
  same_equation_on_carrier := equation_iff_zero_defect flux

/-- The same prescribed rectangle budget, with no endpoint argument. -/
def rectangleBudget {m : ℕ} (eta : Input m → ℝ → ℝ) (i : Input m)
    (r : ForwardRectangle i.step) : ℝ :=
  (r.right - r.left) * ∫ t in r.start..r.stop, eta i t

/-- The prescribed pointwise rectangle-residual measurement and error budget. -/
def policy {m : ℕ} (flux : State m → State m) (hm : 0 < m)
    (eta : Input m → ℝ → ℝ) :
    ResidualPolicy (presentation flux hm) (fun i => ForwardRectangle i.step)
      (fun _ _ => State m) where
  tests_nonempty := fun i =>
    ⟨⟨0, 1, 0, i.step, zero_lt_one, le_refl 0, i.step_pos, le_refl i.step⟩⟩
  geometry := fun i r => @PointMeasurement.geometry (ForwardRectangle i.step) (⊤) m r
  budget := rectangleBudget eta

/-- Exact unqualified norm bounds. Their nonnegative budgets follow already
from the norm inequalities, without an additional analytic hypothesis. -/
theorem residualCertificate_iff {m : ℕ} (flux : State m → State m) (hm : 0 < m)
    (eta : Input m → ℝ → ℝ) (i : Input m) (endpoint : Profile m) :
    ResidualCertificate (presentation flux hm) (policy flux hm eta) i endpoint ↔
      ∃ w : ConservativePath flux i,
        (∀ x, w.field x i.step = endpoint x) ∧
        ∀ r : ForwardRectangle i.step,
          ‖RectangleDefect flux w.field r‖ ≤ rectangleBudget eta i r := by
  letI : MeasurableSpace (ForwardRectangle i.step) := ⊤
  constructor
  · rintro ⟨w, hend, hb⟩
    refine ⟨w, hend, ?_⟩
    intro r
    exact ((@PointMeasurement.measuredBound_iff (ForwardRectangle i.step) (⊤) m r
      (fun r => RectangleDefect flux w.field r) (rectangleBudget eta i r)).1 (hb r)).2
  · rintro ⟨w, hend, hb⟩
    refine ⟨w, hend, ?_⟩
    intro r
    apply (@PointMeasurement.measuredBound_iff (ForwardRectangle i.step) (⊤) m r
      (fun r => RectangleDefect flux w.field r) (rectangleBudget eta i r)).2
    exact ⟨(norm_nonneg _).trans (hb r), hb r⟩

/-- The original envelope guards, fixed from the input before execution. -/
def qualification {m : ℕ} (eta : Input m → ℝ → ℝ) (i : Input m) : Prop :=
  IntervalIntegrable (eta i) volume 0 i.step ∧ ∀ t ∈ Icc 0 i.step, 0 ≤ eta i t

/-- A single prescribed general criterion for this SAME conservative equation. -/
def criterion {m : ℕ} (flux : State m → State m) (hm : 0 < m)
    (eta : Input m → ℝ → ℝ) : Criterion (ConservativeIVP flux) :=
  .residual
    (InputQualifiedResidual.presentation (presentation flux hm) (qualification eta))
    (InputQualifiedResidual.policy (policy flux hm eta) (qualification eta))

/-- Exact adapter for every input, endpoint and prescribed envelope. This is
not a proof of a source-facing target-valued representation proposition. -/
theorem certificate_iff {m : ℕ} (flux : State m → State m) (hm : 0 < m)
    (eta : Input m → ℝ → ℝ) (i : Input m) (endpoint : Profile m) :
    Certificate (criterion flux hm eta) i endpoint ↔ RectangleCertificate flux eta i endpoint := by
  change ResidualCertificate
    (InputQualifiedResidual.presentation (presentation flux hm) (qualification eta))
    (InputQualifiedResidual.policy (policy flux hm eta) (qualification eta)) i endpoint ↔ _
  rw [InputQualifiedResidual.certificate_iff, residualCertificate_iff]
  constructor
  · rintro ⟨⟨hi, hn⟩, w, hend, hb⟩
    exact ⟨hi, hn, w, hend, hb⟩
  · rintro ⟨hi, hn, w, hend, hb⟩
    exact ⟨⟨hi, hn⟩, w, hend, hb⟩

end NumStability.REA.ConservativeRectangleResidual
