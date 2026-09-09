/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.LocalLinearAdvection
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.CFLUnitShift
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.StationaryRiemannField
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RefiningLineMethod

/-!
A full nonvacuous high-resolution line family on a fixed physical interval, using genuine local smooth references and the exact CFL-one operator.
-/

namespace NumStability.LocalLinearAdvection
open NumStability.LocalConservationLaw
open NumStability.CFLUnitShift
open NumStability
open MeasureTheory Set
variable {m : ℕ}
local notation "State" => Fin m → ℝ

/-- A smooth local physical reference advances exactly at CFL one, provided
the active cell and its backward-shifted predecessor stay in the box. -/
theorem local_cfl1_exact {q : ℝ → ℝ → State} {states : Set State}
    {L R H : ℝ} (hq : SmoothReferenceOn q id states L R H)
    (h : ℝ) (hh : 0 < h) (hhH : h ≤ H) (j : ℤ)
    (hleft : L ≤ (grid h hh).cellLeft j - h)
    (hright : (grid h hh).cellRight j ≤ R) :
    advance h hh (fun k => finiteVolumeCellAverageOn (grid h hh) (fun x => q x 0) k) j =
      finiteVolumeCellAverageOn (grid h hh) (fun x => q x h) j := by
  rw [advance_eq_shift]
  have havg := local_cell_average_shift hq
    ((grid h hh).cell_nonempty j).le ⟨hh.le, hhH⟩ hleft hright
  have hl : (grid h hh).cellLeft j - h = (grid h hh).cellLeft (j - 1) := by
    simp only [grid, Int.cast_sub, Int.cast_one]
    ring
  have hr : (grid h hh).cellRight j - h = (grid h hh).cellRight (j - 1) := by
    simp only [grid, Int.cast_sub, Int.cast_one]
    ring
  rw [hl, hr] at havg
  exact havg.symm

/-- Only the actually entering predecessor average is needed at CFL one.
There is no condition on values at unused exterior cells. -/
theorem local_cfl1_exact_of_projection {q : ℝ → ℝ → State} {states : Set State}
    {L R H : ℝ} (hq : SmoothReferenceOn q id states L R H)
    (h : ℝ) (hh : 0 < h) (hhH : h ≤ H) (j : ℤ)
    (hleft : L ≤ (grid h hh).cellLeft j - h)
    (hright : (grid h hh).cellRight j ≤ R)
    (values : ℤ → State)
    (hprojection : values (j - 1) =
      finiteVolumeCellAverageOn (grid h hh) (fun x => q x 0) (j - 1)) :
    advance h hh values j = finiteVolumeCellAverageOn (grid h hh) (fun x => q x h) j := by
  rw [advance_eq_shift, hprojection]
  simpa only [advance_eq_shift] using local_cfl1_exact hq h hh hhH j hleft hright

/-- The zero constant is uniform for every smooth local rectangle reference,
every admitted mesh, and every cell obeying the stated physical containment.
This is the local-reference accuracy component; family geometry/admission and
finite-window oscillation remain separate obligations. -/
theorem local_refinement_zero_defect {q : ℝ → ℝ → State} {states : Set State}
    {L R H : ℝ} (hq : SmoothReferenceOn q id states L R H)
    (p : ℝ) (_hp : 1 < p) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ (n : ℕ) (j : ℤ), meshSize n ≤ H →
      L ≤ (grid (meshSize n) (meshSize_pos n)).cellLeft j - meshSize n →
      (grid (meshSize n) (meshSize_pos n)).cellRight j ≤ R →
      ∀ values : ℤ → State,
        values (j - 1) = finiteVolumeCellAverageOn (grid (meshSize n) (meshSize_pos n))
          (fun x => q x 0) (j - 1) →
        ‖advance (meshSize n) (meshSize_pos n) values j -
          finiteVolumeCellAverageOn (grid (meshSize n) (meshSize_pos n))
            (fun x => q x (meshSize n)) j‖ ≤ C * meshSize n * (meshSize n) ^ p := by
  refine ⟨0, le_rfl, ?_⟩
  intro n j hH hl hr values hproj
  rw [local_cfl1_exact_of_projection hq (meshSize n) (meshSize_pos n) hH j hl hr values hproj]
  simp only [sub_self, norm_zero, zero_mul, le_refl]

end NumStability.LocalLinearAdvection


namespace NumStability.HighResolutionAdvectionLine
open NumStability NumStability.LocalConservationLaw NumStability.DirectionalLine
open NumStability.CFLUnitShift
open MeasureTheory Set Filter
open scoped BigOperators Topology

noncomputable def h (n : ℕ) : ℝ := meshSize (n + 1)

theorem h_pos (n : ℕ) : 0 < h n := meshSize_pos (n + 1)

theorem h_eq (n : ℕ) : h n = 1 / ((n : ℝ) + 2) := by
  simp only [h, meshSize, Nat.cast_add, Nat.cast_one]
  congr 1; ring

theorem h_mul (n : ℕ) : h n * ((n : ℝ) + 2) = 1 := by
  rw [h_eq]
  have : (n : ℝ) + 2 ≠ 0 := by positivity
  field_simp

theorem h_le_half (n : ℕ) : h n ≤ 1 / 2 := by
  rw [h_eq, div_le_div_iff₀ (by positivity) (by norm_num)]
  norm_num

theorem h_tendsto_zero : Tendsto h atTop (𝓝 0) :=
  meshSize_tendsto_zero.comp (tendsto_add_atTop_nat 1)

theorem input_geometry (n : ℕ) (j : ℤ)
    (hj : j ∈ Finset.Ico (-1) ((-1 : ℤ) + ((n + 5 : ℕ) : ℤ))) :
    (-2 : ℝ) ≤ (grid (h n) (h_pos n)).cellLeft j ∧
    (grid (h n) (h_pos n)).cellRight j ≤ 2 := by
  simp only [Finset.mem_Ico, Nat.cast_add, Nat.cast_ofNat] at hj
  have hjl : (-1 : ℝ) ≤ (j : ℝ) := by exact_mod_cast hj.1
  have hjr : (j : ℝ) ≤ (n : ℝ) + 3 := by
    have : j ≤ (n : ℤ) + 3 := by omega
    exact_mod_cast this
  simp only [grid]
  have hl := mul_le_mul_of_nonneg_right hjl (h_pos n).le
  have hr := mul_le_mul_of_nonneg_right hjr (h_pos n).le
  have hp := h_pos n
  have hb := h_le_half n
  have he := h_mul n
  constructor <;> nlinarith

theorem active_coverage (n : ℕ) (x : ℝ) (hx : x ∈ Icc (0 : ℝ) 1) :
    ∃ j ∈ Finset.Ico (0 : ℤ) (0 + (n + 4 : ℕ)),
      x ∈ Icc ((grid (h n) (h_pos n)).cellLeft j)
        ((grid (h n) (h_pos n)).cellRight j) := by
  let k : ℤ := ⌊x * ((n : ℝ) + 2)⌋
  have hk0 : 0 ≤ k := Int.floor_nonneg.mpr (mul_nonneg hx.1 (by positivity))
  have hkle := Int.floor_le (x * ((n : ℝ) + 2))
  have hklt := Int.lt_floor_add_one (x * ((n : ℝ) + 2))
  have hkmax : k ≤ (n : ℤ) + 2 := by
    have hkr : (k : ℝ) ≤ (n : ℝ) + 2 := by
      dsimp [k]
      nlinarith [mul_le_mul_of_nonneg_right hx.2 (show 0 ≤ (n : ℝ) + 2 by positivity)]
    exact_mod_cast hkr
  refine ⟨k + 1, ?_, ?_⟩
  · simp only [Finset.mem_Ico, Nat.cast_add, Nat.cast_ofNat]
    omega
  · simp only [grid, Int.cast_add, Int.cast_one, add_sub_cancel_right]
    have hl := mul_le_mul_of_nonneg_right hkle (h_pos n).le
    have hr := mul_lt_mul_of_pos_right hklt (h_pos n)
    have he := h_mul n
    have heq : (x * ((n : ℝ) + 2)) * h n = x := by
      calc
        _ = x * (h n * ((n : ℝ) + 2)) := by ring
        _ = x := by rw [he, mul_one]
    change (k : ℝ) * h n ≤ x ∧ x ≤ ((k : ℝ) + 1) * h n
    dsimp [k] at *
    constructor <;> nlinarith

noncomputable def family (m : ℕ) : LineFamily m where
  flux := fun _ => id
  states := Set.univ
  left := -2
  right := 2
  interval_nonempty := by norm_num
  hyperbolic := by
    intro x hx state hstate
    have heq : (StationaryRiemannField.transportLaw (m := m)).physicalFlux = id :=
      funext StationaryRiemannField.physicalFlux
    rw [← heq]
    exact hyperbolicConservationLaw_isHyperbolicFluxAt _ state
  horizon := 1
  horizon_pos := by norm_num
  grid := fun n => grid (h n) (h_pos n)
  mesh := h
  mesh_pos := h_pos
  mesh_tendsto := h_tendsto_zero
  meshRatio := 1
  meshRatio_pos := by norm_num
  dt := h
  dt_pos := h_pos
  dt_le_horizon := fun n => (h_le_half n).trans (by norm_num)
  cfl := 1
  cfl_pos := by norm_num
  activeStart := fun _ => 0
  activeCount := fun n => n + 4
  activeCount_two_le := by intro n; omega
  targetLeft := 0
  targetRight := 1
  target_nonempty := by norm_num
  target_inside := by norm_num
  active_coverage := active_coverage
  inputStart := fun _ => -1
  inputCount := fun n => n + 5
  input_covers := by
    intro n j hj
    simp only [Finset.mem_Ico, Nat.cast_add, Nat.cast_ofNat] at hj ⊢
    omega
  input_geometry := by
    intro n j hj
    obtain ⟨hl, hr⟩ := input_geometry n j hj
    exact ⟨hl, hr, (grid_volume _ _ _).le, by rw [grid_volume, one_mul]⟩
  mesh_comparable := by intro n j hj; rw [grid_volume, one_mul]
  numericalFlux := fun _ values j => values (j - 1)
  admitted := fun _ _ => True
  line_local := by
    intro n values other heq j hj
    apply heq
    simp only [Finset.mem_Ico, Finset.mem_Icc, Nat.cast_add, Nat.cast_ofNat] at hj ⊢
    omega

theorem family_advance (m n : ℕ) (values : ℤ → Fin m → ℝ) (j : ℤ) :
    (family m).advance n values j = values (j - 1) :=
  advance_eq_shift (h n) (h_pos n) values j

theorem family_quality (m : ℕ) : (family m).HasControlledHighResolution := by
  constructor
  · refine ⟨2, by norm_num, ?_⟩
    intro q hq
    refine ⟨0, le_rfl, 0, ?_⟩
    intro n hn values hproj
    refine ⟨True.intro, ?_⟩
    intro j hj
    have hj' : 0 ≤ j ∧ j < (n : ℤ) + 4 := by
      simpa only [family, Finset.mem_Ico, Nat.cast_add, Nat.cast_ofNat, zero_add] using hj
    have hpred : j - 1 ∈ Finset.Ico (-1) ((-1 : ℤ) + ((n + 5 : ℕ) : ℤ)) := by
      simp only [Finset.mem_Ico, Nat.cast_add, Nat.cast_ofNat]
      omega
    have hgeom := input_geometry n (j - 1) hpred
    have hgeomj := input_geometry n j (by
      simp only [Finset.mem_Ico, Nat.cast_add, Nat.cast_ofNat]; omega)
    have hl : (-2 : ℝ) ≤ (grid (h n) (h_pos n)).cellLeft j - h n := by
      have he : (grid (h n) (h_pos n)).cellLeft j - h n =
          (grid (h n) (h_pos n)).cellLeft (j - 1) := by
        simp only [grid, Int.cast_sub, Int.cast_one]; ring
      rw [he]
      exact hgeom.1
    have href : NumStability.LocalConservationLaw.SmoothReferenceOn q id Set.univ (-2) 2 1 := hq
    have hexact := NumStability.LocalLinearAdvection.local_cfl1_exact_of_projection href
      (h n) (h_pos n) ((h_le_half n).trans (by norm_num)) j hl hgeomj.2 values
      (hproj (j - 1) hpred)
    change ‖advance (h n) (h_pos n) values j -
      finiteVolumeCellAverageOn (grid (h n) (h_pos n)) (fun x => q x (h n)) j‖ ≤
        (0 : ℝ) * h n * h n ^ (2 : ℝ)
    rw [hexact]
    simp
  · refine ⟨0, le_rfl, ?_⟩
    intro n values other hv ho E hE herr j hj
    rw [family_advance, family_advance]
    simp only [zero_mul, add_zero, one_mul]
    apply herr
    simp only [family, Finset.mem_Ico, Nat.cast_add, Nat.cast_ofNat] at hj ⊢
    omega
  · refine ⟨0, le_rfl, fun _ => 0, fun _ => le_rfl, tendsto_const_nhds, ?_⟩
    intro n values hv
    simp only [zero_mul, add_zero, one_mul, mul_zero]
    change windowVariation 0 (n + 4 - 1) ((family m).advance n values) ≤
      windowVariation (-1) (n + 5 - 1) values
    unfold windowVariation
    simp only [family_advance]
    have he (k : ℕ) :
        ‖values ((0 : ℤ) + k + 1 - 1) - values (0 + k - 1)‖ =
        ‖values ((-1 : ℤ) + k + 1) - values (-1 + k)‖ := by
      congr 2 <;> congr 1 <;> ring
    simp_rw [he]
    exact Finset.sum_le_sum_of_subset_of_nonneg
      (Finset.range_mono (by omega)) (fun _ _ _ => norm_nonneg _)

theorem smooth_local_reference :
    SpatialSmoothReferenceOn (fun x t => smoothProfile (x - t)) (fun _ => id)
      Set.univ (-2) 2 1 := by
  have hg := translated_is_conserved smoothProfile smoothProfile_integrable
  have hc : ContDiff ℝ ⊤ (fun p : ℝ × ℝ => smoothProfile (p.1 - p.2)) :=
    contDiff_pi.mpr (fun _ => contDiff_fst.sub contDiff_snd)
  refine ⟨hc.contDiffOn, ?_, fun _ _ _ _ => Set.mem_univ _⟩
  exact ⟨fun t _ => hg.1 (-2) 2 t, fun x _ => hg.2.1 x 0 1,
    fun a _ b _ s _ t _ => hg.2.2 a b s t⟩

theorem smooth_initial_projection (n : ℕ) :
    (family 1).InitialProjection n (fun x t => smoothProfile (x - t))
      (fun j => finiteVolumeCellAverageOn (grid (h n) (h_pos n)) smoothProfile j) := by
  intro j hj
  simp only [family, sub_zero]

/-- The nonsmooth physical example is a transported discontinuity of linear
advection. It is not misclassified as a smooth reference or nonlinear shock. -/
theorem step_local_reference :
    SpatialRectangleReferenceOn (fun x t => stepProfile (x - t)) (fun _ => id) (-2) 2 1 ∧
      ¬ ContinuousAt stepProfile 0 := by
  have hg := translated_is_conserved stepProfile stepProfile_integrable
  exact ⟨⟨fun t _ => hg.1 (-2) 2 t, fun x _ => hg.2.1 x 0 1,
    fun a _ b _ s _ t _ => hg.2.2 a b s t⟩, stepProfile_discontinuous⟩

/-- A literal scalar family satisfies the full current quality predicate.
The fixed target interval has positive length at every refinement. -/
theorem scalar_family_exists : ∃ f : LineFamily 1,
    f.HasControlledHighResolution ∧ f.targetLeft = 0 ∧ f.targetRight = 1 ∧
    f.flux = (fun _ => id) ∧ ∀ n values, f.admitted n values :=
  ⟨family 1, family_quality 1, rfl, rfl, rfl, fun _ _ => True.intro⟩

end NumStability.HighResolutionAdvectionLine
