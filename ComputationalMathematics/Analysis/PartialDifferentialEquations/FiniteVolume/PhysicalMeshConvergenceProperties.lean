/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RealNormPhysicalMeshConvergence
import Mathlib.Tactic

/-!
# Geometry and errors on refining physical meshes

These results concern the actual cells, observation slabs and width-weighted
errors in `PhysicalMeshConvergenceCriteria`. They do not assert that a numerical
evolution converges or identify a differential-equation solution.
-/

noncomputable section

namespace NumStability

open Filter MeasureTheory Set
open scoped Topology ENNReal

variable {A E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]

theorem uniformPhysicalSpaceCell_bounds (origin dx : A → ℝ)
    (hdx : ∀ a, 0 < dx a) (a : A) (x : ℝ) :
    x ∈ Icc (uniformPhysicalEdge origin dx a (uniformPhysicalSpaceCell origin dx a x))
      (uniformPhysicalEdge origin dx a (uniformPhysicalSpaceCell origin dx a x + 1)) := by
  have hl := (le_div_iff₀ (hdx a)).mp (Int.floor_le ((x - origin a) / dx a))
  have hu := (div_lt_iff₀ (hdx a)).mp (Int.lt_floor_add_one ((x - origin a) / dx a))
  dsimp [uniformPhysicalEdge, uniformPhysicalSpaceCell]
  push_cast
  constructor <;> linarith

theorem isPhysicalCellMesh_uniform (origin dx : A → ℝ) (hdx : ∀ a, 0 < dx a) :
    IsPhysicalCellMesh univ (fun _ => univ) (uniformPhysicalEdge origin dx) dx := by
  refine ⟨MeasurableSet.univ, fun _ => ⟨0, mem_univ _⟩, ?_, ?_, ?_⟩
  · intro a i _
    dsimp [uniformPhysicalEdge]
    push_cast
    refine ⟨by linarith [hdx a], by linarith, subset_univ _⟩
  · intro a i j _ _ hij
    have hc : (i : ℝ) + 1 ≤ j := by exact_mod_cast (show i + 1 ≤ j by omega)
    have hm := mul_le_mul_of_nonneg_right hc (hdx a).le
    dsimp [uniformPhysicalEdge]
    push_cast
    linarith
  · intro a x _
    exact ⟨uniformPhysicalSpaceCell origin dx a x, mem_univ _,
      uniformPhysicalSpaceCell_bounds origin dx hdx a x⟩

theorem isPhysicalTimeMesh_uniform (dt : A → ℝ) (hdt : ∀ a, 0 < dt a) :
    IsPhysicalTimeMesh (uniformPhysicalTime dt) dt := by
  intro a
  refine ⟨by simp [uniformPhysicalTime], ?_⟩
  intro n
  dsimp [uniformPhysicalTime]
  push_cast
  constructor <;> linarith [hdt a]

theorem hasPhysicalObservationTime_of_horizon (time : A → ℕ → ℝ) (dt : A → ℝ)
    (steps : A → ℕ) (T : ℝ) (ht : IsPhysicalTimeMesh time dt)
    (hc : HasPhysicalHorizon time steps T) : HasPhysicalObservationTime time steps T := by
  refine ⟨hc.1, fun a => ?_⟩
  rw [← hc.2 a]
  exact ⟨le_rfl, (ht a).2 (steps a) |>.1⟩

theorem physicalTime_tendsto_of_bracket (l : Filter A) (time : A → ℕ → ℝ)
    (dt : A → ℝ) (steps : A → ℕ) (T : ℝ) (ht : IsPhysicalTimeMesh time dt)
    (hc : ∀ a, time a (steps a) ≤ T ∧ T < time a (steps a + 1))
    (hr : Tendsto dt l (𝓝 0)) : Tendsto (fun a => time a (steps a)) l (𝓝 T) := by
  apply tendsto_of_tendsto_of_tendsto_of_le_of_le
    (show Tendsto (fun a => T - dt a) l (𝓝 T) by simpa using tendsto_const_nhds.sub hr)
    tendsto_const_nhds
  · intro a
    have hw := ((ht a).2 (steps a)).2
    have hu := (hc a).2
    linarith
  · exact fun a => (hc a).1

theorem hasPhysicalReconstructionIndices_uniform (origin dx dt : A → ℝ)
    (h : ∀ a, 0 < dx a ∧ 0 < dt a) :
    HasPhysicalReconstructionIndices univ (fun _ => univ)
      (uniformPhysicalEdge origin dx) (uniformPhysicalTime dt)
      (uniformPhysicalSpaceCell origin dx) (uniformPhysicalTimeCell dt) := by
  refine ⟨fun a x _ => ⟨mem_univ _, uniformPhysicalSpaceCell_bounds origin dx
    (fun a => (h a).1) a x⟩, ?_⟩
  intro a t ht
  have hl := (le_div_iff₀ (h a).2).mp (Nat.floor_le (div_nonneg ht (h a).2.le))
  have hu := (div_lt_iff₀ (h a).2).mp (Nat.lt_floor_add_one (t / dt a))
  dsimp [uniformPhysicalTime, uniformPhysicalTimeCell]
  push_cast
  constructor <;> linarith

theorem physicalCellWidth_tendsto_zero (l : Filter A) (domain : Set ℝ)
    (active : A → Set ℤ) (edge : A → ℤ → ℝ) (dx dt : A → ℝ)
    (hr : IsSpaceTimeRefinement l dx dt) (hm : IsPhysicalCellMesh domain active edge dx)
    (index : A → ℤ) (hi : ∀ a, index a ∈ active a) :
    Tendsto (fun a => edge a (index a + 1) - edge a (index a)) l (𝓝 0) := by
  exact squeeze_zero (fun a => sub_nonneg.mpr ((hm.2.2.1 a (index a) (hi a)).1.le))
    (fun a => (hm.2.2.1 a (index a) (hi a)).2.1) hr.2.2.1

theorem physicalCellCenter_tendsto (l : Filter A) (domain : Set ℝ)
    (active : A → Set ℤ) (edge : A → ℤ → ℝ) (dx dt : A → ℝ)
    (hr : IsSpaceTimeRefinement l dx dt) (hm : IsPhysicalCellMesh domain active edge dx)
    (index : A → ℤ) (x : ℝ)
    (hi : ∀ a, index a ∈ active a ∧ x ∈ Icc (edge a (index a)) (edge a (index a + 1))) :
    Tendsto (fun a => physicalCellCenter edge a (index a)) l (𝓝 x) := by
  apply tendsto_iff_norm_sub_tendsto_zero.mpr
  apply squeeze_zero (fun _ => norm_nonneg _) _ hr.2.2.1
  intro a
  rw [Real.norm_eq_abs, abs_le]
  have hw := (hm.2.2.1 a (index a) (hi a).1).2.1
  have hx := (hi a).2
  dsimp [physicalCellCenter]
  constructor <;> linarith [hx.1, hx.2]

theorem physicalReconstructionIndices_tendsto (l : Filter A) (domain : Set ℝ)
    (active : A → Set ℤ) (edge : A → ℤ → ℝ) (time : A → ℕ → ℝ) (dx dt : A → ℝ)
    (spaceCell : A → ℝ → ℤ) (timeCell : A → ℝ → ℕ)
    (hr : IsSpaceTimeRefinement l dx dt) (hm : IsPhysicalCellMesh domain active edge dx)
    (ht : IsPhysicalTimeMesh time dt)
    (hl : HasPhysicalReconstructionIndices domain active edge time spaceCell timeCell)
    (x t : ℝ) (hx : x ∈ domain) (ht0 : 0 ≤ t) :
    Tendsto (fun a => (physicalCellCenter edge a (spaceCell a x), time a (timeCell a t)))
      l (𝓝 (x, t)) := by
  exact (physicalCellCenter_tendsto l domain active edge dx dt hr hm
    (fun a => spaceCell a x) x (fun a => hl.1 a x hx)).prodMk_nhds
      (physicalTime_tendsto_of_bracket l time dt (fun a => timeCell a t) t ht
        (fun a => hl.2 a t ht0) hr.2.2.2)

@[simp] theorem physicalCellGridMeasure_singleton (active : A → Set ℤ)
    (edge : A → ℤ → ℝ) (a : A) (i : ℤ) :
    physicalCellGridMeasure active edge a {i} = physicalCellWeight active edge a i := by
  simp [physicalCellGridMeasure, withDensity_apply]

theorem physicalCellGridMeasure_singleton_pos (domain : Set ℝ) (active : A → Set ℤ)
    (edge : A → ℤ → ℝ) (dx : A → ℝ) (hm : IsPhysicalCellMesh domain active edge dx)
    (a : A) (i : ℤ) (hi : i ∈ active a) :
    physicalCellGridMeasure active edge a {i} = ENNReal.ofReal (edge a (i + 1) - edge a i) ∧
      0 < physicalCellGridMeasure active edge a {i} := by
  have hw : 0 < edge a (i + 1) - edge a i := sub_pos.mpr (hm.2.2.1 a i hi).1
  simp [physicalCellWeight, hi, hw]

@[simp] theorem physicalCellWeight_uniform (origin dx : A → ℝ) (a : A) (i : ℤ) :
    physicalCellWeight (fun _ => univ) (uniformPhysicalEdge origin dx) a i =
      ENNReal.ofReal (dx a) := by
  simp only [physicalCellWeight, mem_univ, if_true, uniformPhysicalEdge]
  congr 1
  push_cast
  ring

theorem physicalCellGridMeasure_uniform (origin dx : A → ℝ) (a : A) :
    physicalCellGridMeasure (fun _ => univ) (uniformPhysicalEdge origin dx) a =
      ENNReal.ofReal (dx a) • Measure.count := by
  unfold physicalCellGridMeasure
  have hw : physicalCellWeight (fun _ => univ) (uniformPhysicalEdge origin dx) a =
      fun _ => ENNReal.ofReal (dx a) := funext (physicalCellWeight_uniform origin dx a)
  rw [hw, withDensity_const]

omit [NormedSpace ℝ E] [CompleteSpace E] in
theorem gridErrorENorm_physical_finite (active : A → Set ℤ) (edge : A → ℤ → ℝ)
    (a : A) (p : ℝ≥0∞) (hp0 : p ≠ 0) (hpinf : p ≠ ∞) (Q reference : ℤ → E) :
    gridErrorENorm p (physicalCellGridMeasure active edge a) Q reference =
      (∑' i : ℤ, physicalCellWeight active edge a i * ‖Q i - reference i‖ₑ ^ p.toReal) ^
        (1 / p.toReal) := by
  rw [gridErrorENorm, eLpNorm_eq_lintegral_rpow_enorm_toReal hp0 hpinf,
    physicalCellGridMeasure, lintegral_withDensity_eq_lintegral_mul _
      (measurable_of_countable _) (measurable_of_countable _), lintegral_count]
  rfl

omit [NormedSpace ℝ E] [CompleteSpace E] in
theorem gridErrorENorm_uniform_finite (origin dx : A → ℝ) (a : A)
    (p : ℝ≥0∞) (hp0 : p ≠ 0) (hpinf : p ≠ ∞) (Q reference : ℤ → E) :
    gridErrorENorm p
        (physicalCellGridMeasure (fun _ => univ) (uniformPhysicalEdge origin dx) a) Q reference =
      (ENNReal.ofReal (dx a) * ∑' i : ℤ, ‖Q i - reference i‖ₑ ^ p.toReal) ^
        (1 / p.toReal) := by
  rw [gridErrorENorm_physical_finite _ _ _ _ hp0 hpinf]
  simp only [physicalCellWeight_uniform, ENNReal.tsum_mul_left]

omit [NormedSpace ℝ E] [CompleteSpace E] in
theorem gridErrorENorm_physical_top (domain : Set ℝ) (active : A → Set ℤ)
    (edge : A → ℤ → ℝ) (dx : A → ℝ) (hm : IsPhysicalCellMesh domain active edge dx)
    (a : A) (Q reference : ℤ → E) :
    gridErrorENorm ∞ (physicalCellGridMeasure active edge a) Q reference =
      ⨆ i : active a, ‖Q i - reference i‖ₑ := by
  classical
  rw [gridErrorENorm, eLpNorm_exponent_top, eLpNormEssSup_eq_essSup_enorm]
  apply le_antisymm
  · apply essSup_le_of_ae_le
    apply ae_iff_of_countable.mpr
    intro i hi
    have hai : i ∈ active a := by
      by_contra hn
      exact hi (by simp [physicalCellWeight, hn])
    exact le_iSup_of_le ⟨i, hai⟩ le_rfl
  · apply iSup_le
    intro i
    exact ae_iff_of_countable.mp (ENNReal.ae_le_essSup
      (fun j : ℤ => ‖Q j - reference j‖ₑ)) i
      (ne_of_gt (physicalCellGridMeasure_singleton_pos domain active edge dx hm a i i.property).2)

theorem real_nonneg_tendsto_zero_iff {l : Filter A} {f : A → ℝ} (hf : ∀ a, 0 ≤ f a) :
    Tendsto f l (𝓝 0) ↔ ∀ ε : ℝ, 0 < ε → ∀ᶠ a in l, f a < ε := by
  constructor
  · intro h ε hε
    exact (tendsto_order.mp h).2 ε hε
  · intro h
    apply tendsto_order.mpr
    exact ⟨fun c hc => Eventually.of_forall (fun a => lt_of_lt_of_le hc (hf a)), h⟩

theorem ennreal_tendsto_zero_iff {l : Filter A} {f : A → ℝ≥0∞} :
    Tendsto f l (𝓝 0) ↔ ∀ ε : ℝ≥0∞, 0 < ε → ∀ᶠ a in l, f a < ε := by
  constructor
  · intro h ε hε
    exact (tendsto_order.mp h).2 ε hε
  · intro h
    apply tendsto_order.mpr
    exact ⟨fun c hc => (not_lt_of_ge bot_le hc).elim, h⟩

theorem norm_tendsto_zero_iff_eventually_lt {l : Filter A} (X : A → Type*)
    [∀ a, NormedAddCommGroup (X a)] (error : ∀ a, X a) :
    Tendsto (fun a => ‖error a‖) l (𝓝 0) ↔
      ∀ ε : ℝ, 0 < ε → ∀ᶠ a in l, ‖error a‖ < ε :=
  real_nonneg_tendsto_zero_iff (fun a => norm_nonneg (error a))

end NumStability
