/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.NoncrossingAttainedLabelsTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.LagrangianSpecificVolumeIntegral
import Mathlib.MeasureTheory.Integral.IntervalIntegral.FundThmCalculus
import Mathlib.MeasureTheory.Integral.DominatedConvergence
import Mathlib.Topology.Order.IntermediateValue

/-!
# LeVeque Chapter 2: NoncrossingAttainedLabels

Proof that the attained mass labels remain ordered.
-/

open MeasureTheory
namespace NumStability.Leveque02Tracer

theorem noncrossingAttainedLabels : noncrossingAttainedLabelsTarget := by
  intro initialDensity referenceLocation particlePosition eulerianVelocity
    eulerianDensity timeDomain _hne _hzero hintegrable hinit
    hinitial _htrajectory hpositive t ht hcontinuous
  let D := Set.range (lagrangianMassLabel initialDensity referenceLocation)
  have hstrict : StrictMono (lagrangianMassLabel initialDensity referenceLocation) :=
    (lagrangianMassLabelInjective initialDensity referenceLocation hintegrable hinit).1
  have hlabelcont : Continuous (lagrangianMassLabel initialDensity referenceLocation) := by
    exact intervalIntegral.continuous_primitive hintegrable referenceLocation
  have hopen : IsOpen D := by
    apply isOpen_iff_mem_nhds.mpr
    rintro y ⟨x, rfl⟩
    have hleft : lagrangianMassLabel initialDensity referenceLocation (x - 1) <
        lagrangianMassLabel initialDensity referenceLocation x :=
      hstrict (sub_lt_self x zero_lt_one)
    have hright : lagrangianMassLabel initialDensity referenceLocation x <
        lagrangianMassLabel initialDensity referenceLocation (x + 1) :=
      hstrict (lt_add_of_pos_right x zero_lt_one)
    apply Filter.mem_of_superset (isOpen_Ioo.mem_nhds ⟨hleft, hright⟩)
    intro y hy
    exact intermediate_value_univ (x - 1) (x + 1) hlabelcont
      ⟨le_of_lt hy.1, le_of_lt hy.2⟩
  have hconvex : ∀ a ∈ D, ∀ b ∈ D, Set.uIcc a b ⊆ D := by
    intro a ha b hb y hy
    rcases le_total a b with hab | hba
    · have hIcc : y ∈ Set.Icc a b := by
        simpa [Set.uIcc_of_le hab] using hy
      rcases ha with ⟨xa, rfl⟩
      rcases hb with ⟨xb, rfl⟩
      exact intermediate_value_univ xa xb hlabelcont hIcc
    · have hIcc : y ∈ Set.Icc b a := by
        simpa [Set.uIcc_of_ge hba] using hy
      rcases ha with ⟨xa, rfl⟩
      rcases hb with ⟨xb, rfl⟩
      exact intermediate_value_univ xb xa hlabelcont hIcc
  let V : ℝ → ℝ := fun η =>
    lagrangianSpecificVolume eulerianDensity particlePosition η t
  have hVpos (η : ℝ) (hη : η ∈ D) : 0 < V η := by
    exact div_pos zero_lt_one (hpositive t ht η hη)
  have hiff :
      IntervalIdentity initialDensity referenceLocation particlePosition eulerianDensity t ↔
        MassCoordinateJacobian initialDensity referenceLocation particlePosition eulerianDensity t := by
    constructor
    · intro hinterval η hη
      have hVat : ContinuousAt V η := hcontinuous.continuousAt (hopen.mem_nhds hη)
      have hF : HasDerivAt (fun b => ∫ ζ in η..b, V ζ) (V η) η :=
        intervalIntegral.integral_hasDerivAt_right
          (by simp)
          (hcontinuous.stronglyMeasurableAtFilter hopen η hη)
          hVat
      have hG : HasDerivAt (fun b => (∫ ζ in η..b, V ζ) + particlePosition η t)
          (V η) η := by
        convert hF.add_const (particlePosition η t) using 1
      have hevent :
          (fun b => (∫ ζ in η..b, V ζ) + particlePosition η t) =ᶠ[nhds η]
            (fun b => particlePosition b t) := by
        filter_upwards [(hopen.mem_nhds hη)] with b hb
        have h := hinterval η hη b hb
        dsimp [V] at *
        linarith
      exact hG.congr_of_eventuallyEq hevent.symm
    · intro hjac a ha b hb
      have hsegment : Set.uIcc a b ⊆ D := hconvex a ha b hb
      exact lagrangianSpecificVolumeIntegral initialDensity referenceLocation
        particlePosition eulerianDensity a b t hintegrable hinit hinitial
        (fun η hη => hsegment hη)
        (fun η hη => hpositive t ht η (hsegment hη))
        (fun η hη => hjac η (hsegment hη))
        ((hcontinuous.mono hsegment).intervalIntegrable)
  refine ⟨hiff, ?_⟩
  intro hinterval a ha b hb hab
  have hsegment : Set.uIcc a b ⊆ D := hconvex a ha b hb
  have hsegmentIcc : Set.Icc a b ⊆ D := by
    simpa [Set.uIcc_of_le hab.le] using hsegment
  have hpos : 0 < ∫ η in a..b, V η := by
    apply intervalIntegral.integral_pos hab (hcontinuous.mono hsegmentIcc)
    · intro η hη
      have hIcc : η ∈ Set.Icc a b := ⟨le_of_lt hη.1, hη.2⟩
      exact le_of_lt (hVpos η
        (hsegment (by simpa [Set.uIcc_of_le hab.le] using hIcc)))
    · refine ⟨a, Set.left_mem_Icc.mpr hab.le, ?_⟩
      exact hVpos a ha
  have hidentity := hinterval a ha b hb
  dsimp [V] at hpos
  rw [hidentity] at hpos
  exact sub_pos.mp hpos

end NumStability.Leveque02Tracer
