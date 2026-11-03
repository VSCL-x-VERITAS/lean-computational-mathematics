/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.REASeminormCertificate
import ComputationalMathematics.Source.LeVeque.Chapter04.REAConservativeRectangleCriterion

/-!
# An actual conservative rectangle criterion with a literal raw seminorm

The singleton descriptor below directly specifies counting measure, top raw
submodule and `normSeminorm.comp` point evaluation. No old geometry-to-descriptor
conversion or hidden normed quotient is used. The same actual conservative
presentation and original input qualifications are retained.
-/

noncomputable section
namespace NumStability.REA.SeminormRecipe.Rectangle
open Set MeasureTheory

def pointDescriptor {α : Type} [MeasurableSpace α] (d : ℕ) (j : α) : Descriptor α d where
  domain := {j}
  domain_nonempty := singleton_nonempty j
  measure := Measure.count
  measure_ne_zero := by
    letI : Nonempty (PointMeasurement.PointDomain j) := ⟨⟨j, mem_singleton j⟩⟩
    exact Measure.count_ne_zero''
  raw := ⊤
  q := (normSeminorm ℝ (State d)).comp (PointMeasurement.evaluation d j)
  kernel_ae_zero := by
    intro e
    change ‖PointMeasurement.evaluation d j e‖ = 0 ↔ _
    rw [norm_eq_zero, Measure.ae_count_iff]
    constructor
    · intro h x
      have hx : x = ⟨j, mem_singleton j⟩ := Subtype.ext (mem_singleton_iff.mp x.property)
      subst x
      exact h
    · intro h
      exact h ⟨j, mem_singleton j⟩

theorem rawBound_point_iff {α : Type} [MeasurableSpace α]
    (d : ℕ) (j : α) (f : α → State d) (budget : ℝ) :
    RawBound (pointDescriptor d j) f budget ↔ 0 ≤ budget ∧ ‖f j‖ ≤ budget := by
  constructor
  · rintro ⟨hb, e, he, hn⟩
    refine ⟨hb, ?_⟩
    change ‖e.val ⟨j, mem_singleton j⟩‖ ≤ budget at hn
    rwa [he ⟨j, mem_singleton j⟩] at hn
  · rintro ⟨hb, hn⟩
    let e : (⊤ : Submodule ℝ (PointMeasurement.PointDomain j → State d)) :=
      ⟨fun x => f x, Submodule.mem_top⟩
    exact ⟨hb, e, fun _ => rfl, hn⟩

abbrev presentation {m : ℕ} (flux : State m → State m) (hm : 0 < m)
    (eta : Input m → ℝ → ℝ) : ResidualPresentation (ConservativeIVP flux) :=
  InputQualifiedResidual.presentation (ConservativeRectangleResidual.presentation flux hm)
    (ConservativeRectangleResidual.qualification eta)

def policy {m : ℕ} (flux : State m → State m) (hm : 0 < m)
    (eta : Input m → ℝ → ℝ) :
    ResidualPolicy (presentation flux hm eta) (fun i => ForwardRectangle i.step) where
  tests_nonempty := fun i =>
    ⟨⟨0, 1, 0, i.step, zero_lt_one, le_refl 0, i.step_pos, le_refl i.step⟩⟩
  descriptor := fun i r => @pointDescriptor (ForwardRectangle i.step) (⊤) m r
  budget := ConservativeRectangleResidual.rectangleBudget eta

def criterion {m : ℕ} (flux : State m → State m) (hm : 0 < m)
    (eta : Input m → ℝ → ℝ) : Criterion (ConservativeIVP flux) :=
  .residual (presentation flux hm eta) (policy flux hm eta)

/-- Exact direct-seminorm certification for the unchanged weak rectangle bound. -/
theorem certificate_iff {m : ℕ} (flux : State m → State m) (hm : 0 < m)
    (eta : Input m → ℝ → ℝ) (i : Input m) (endpoint : Profile m) :
    Certificate (criterion flux hm eta) i endpoint ↔ RectangleCertificate flux eta i endpoint := by
  change ResidualCertificate (presentation flux hm eta) (policy flux hm eta) i endpoint ↔ _
  letI : MeasurableSpace (ForwardRectangle i.step) := ⊤
  constructor
  · rintro ⟨⟨w, hQ⟩, hend, hb⟩
    refine ⟨hQ.1, hQ.2, w, hend, ?_⟩
    intro r
    exact ((@rawBound_point_iff (ForwardRectangle i.step) (⊤) m r
      (fun r => RectangleDefect flux w.field r)
      (ConservativeRectangleResidual.rectangleBudget eta i r)).1 (hb r)).2
  · rintro ⟨hi, hn, w, hend, hb⟩
    refine ⟨⟨w, ⟨hi, hn⟩⟩, hend, ?_⟩
    intro r
    apply (@rawBound_point_iff (ForwardRectangle i.step) (⊤) m r
      (fun r => RectangleDefect flux w.field r)
      (ConservativeRectangleResidual.rectangleBudget eta i r)).2
    exact ⟨(norm_nonneg _).trans (hb r), hb r⟩

end NumStability.REA.SeminormRecipe.Rectangle
