/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.REAGeneralPrescribedCertificate
import Mathlib.MeasureTheory.Measure.Count

/-!
# Singleton measurement of any finite-state field

Counting measure, the full raw submodule and linear point evaluation preserve
the ordinary finite-state norm at the selected point. No positivity of the
state dimension or regularity/measurability of the supplied field is required.
-/

noncomputable section
namespace NumStability.REA.PointMeasurement
open Set MeasureTheory

abbrev PointDomain {α : Type} (j : α) := ({j} : Set α)

def evaluation {α : Type} (d : ℕ) (j : α) :
    (⊤ : Submodule ℝ (PointDomain j → State d)) →ₗ[ℝ] State d where
  toFun e := e.val ⟨j, mem_singleton j⟩
  map_add' _ _ := rfl
  map_smul' _ _ := rfl

/-- Actual nonzero singleton counting geometry with onto point evaluation. -/
def geometry {α : Type} [MeasurableSpace α] (d : ℕ) (j : α) :
    MeasuredFieldGeometry α d (State d) where
  domain := {j}
  domain_nonempty := singleton_nonempty j
  measure := Measure.count
  measure_ne_zero := by
    letI : Nonempty (PointDomain j) := ⟨⟨j, mem_singleton j⟩⟩
    exact Measure.count_ne_zero''
  raw := ⊤
  toValue := evaluation d j
  onto := by
    intro y
    exact ⟨⟨fun _ => y, Submodule.mem_top⟩, rfl⟩
  kernel_ae_zero := by
    intro e
    rw [Measure.ae_count_iff]
    constructor
    · intro h x
      have hx : x = ⟨j, mem_singleton j⟩ := Subtype.ext (mem_singleton_iff.mp x.property)
      subst x
      exact h
    · intro h
      exact h ⟨j, mem_singleton j⟩

theorem measuredBound_iff {α : Type} [MeasurableSpace α]
    (d : ℕ) (j : α) (f : α → State d) (budget : ℝ) :
    MeasuredBound (geometry d j) f budget ↔ 0 ≤ budget ∧ ‖f j‖ ≤ budget := by
  constructor
  · rintro ⟨hbudget, e, he, hn⟩
    refine ⟨hbudget, ?_⟩
    change ‖e.val ⟨j, mem_singleton j⟩‖ ≤ budget at hn
    rwa [he ⟨j, mem_singleton j⟩] at hn
  · rintro ⟨hbudget, hn⟩
    let e : (⊤ : Submodule ℝ (PointDomain j → State d)) :=
      ⟨fun x => f x, Submodule.mem_top⟩
    exact ⟨hbudget, e, fun _ => rfl, hn⟩

end NumStability.REA.PointMeasurement
