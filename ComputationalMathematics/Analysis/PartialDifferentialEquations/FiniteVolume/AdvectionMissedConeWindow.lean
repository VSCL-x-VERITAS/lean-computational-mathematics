/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.AdvectionRefinementCFL
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.TranslatedMeshWindow
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLipschitzTrace
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.UniformAdvection
import Mathlib.Analysis.Calculus.BumpFunction.InnerProduct

/-!
# A fixed advected cutoff outside a stencil cone

A characteristic displacement beyond the fixed-ratio stencil reach separates
one smooth cutoff from all initial read cones of a fixed physical window.
The transported cutoff has cell average one throughout that window, while
the zero profile has cell average zero. The cutoff is fixed before refinement.
Numerical locality and physical grid-norm arguments can use this construction.
-/

open Set Filter
open scoped Topology
namespace NumStability

/-- A fixed smooth nonnegative compactly supported scalar profile is zero on
all initial cell cones in a positive-length window, and its actual advected
cell means are one there. The construction covers either sign of the speed. -/
theorem exists_advection_missedCone_cellAverage_window :
  ∀ (speed origin T ratio : ℝ) (radius : ℕ),
    0 < T → 0 < ratio → (radius : ℝ) < |speed| * ratio →
    let gap : ℝ := |speed| * T - (radius : ℝ) * T / ratio
    let foot : ℝ := origin - speed * T
    ∃ cutoff : ContDiffBump foot,
      cutoff.rIn = gap / 4 ∧ cutoff.rOut = gap / 2 ∧
      (∀ᶠ n : ℕ in atTop,
        fixedRatioRefinementCellWidth T ratio n ≤ gap / 16) ∧
      ∀ n : ℕ,
        let h : ℝ := fixedRatioRefinementCellWidth T ratio n
        h ≤ gap / 16 →
        ∀ j ∈ translatedMeshWindow
            (origin - gap / 16) (origin + gap / 16) origin h,
          EqOn (fun _ : ℝ => (0 : ℝ)) (cutoff : ℝ → ℝ)
            (Icc
              (origin + (j : ℝ) * h -
                ((n + 1 : ℕ) : ℝ) * (radius : ℝ) * h)
              (origin + ((j : ℝ) + 1) * h +
                ((n + 1 : ℕ) : ℝ) * (radius : ℝ) * h)) ∧
          oneDimensionalCellAverage
              (fun x => travelingWave (fun _ : ℝ => (0 : ℝ)) speed x T)
              (origin + (j : ℝ) * h) (origin + ((j : ℝ) + 1) * h) = 0 ∧
          oneDimensionalCellAverage
              (fun x => travelingWave (cutoff : ℝ → ℝ) speed x T)
              (origin + (j : ℝ) * h) (origin + ((j : ℝ) + 1) * h) = 1 := by
  intro speed origin T ratio radius hT hratio hmiss
  let reach : ℝ := (radius : ℝ) * T / ratio
  let gap : ℝ := |speed| * T - reach
  let foot : ℝ := origin - speed * T
  have hr : (radius : ℝ) / ratio < |speed| :=
    (div_lt_iff₀ hratio).mpr hmiss
  have hreach_lt : reach < |speed| * T := by
    calc
      reach = ((radius : ℝ) / ratio) * T := by dsimp [reach]; ring
      _ < |speed| * T := mul_lt_mul_of_pos_right hr hT
  have hgap : 0 < gap := sub_pos.mpr hreach_lt
  have hgapid : |speed| * T = reach + gap := by dsimp [gap]; ring
  let cutoff : ContDiffBump foot :=
    ⟨gap / 4, gap / 2, by positivity, by linarith⟩
  refine ⟨cutoff, rfl, rfl, ?_, ?_⟩
  · have hhalf : Tendsto
        (fun n : ℕ => fixedRatioRefinementCellWidth T ratio n / 2)
        atTop (𝓝 0) := by
      simpa only [fixedRatioRefinementCellWidth, Nat.cast_zero,
        mul_zero, zero_mul, zero_add, zero_div] using
        (fixedRatioRefinement_cellConeRadius_tendsto T ratio 0 hratio)
    have hwidth : Tendsto (fixedRatioRefinementCellWidth T ratio)
        atTop (𝓝 0) := by
      simpa only [div_mul_cancel₀ _ (by norm_num : (2 : ℝ) ≠ 0), zero_mul]
        using hhalf.mul_const 2
    exact hwidth.eventually_le_const (by positivity : 0 < gap / 16)
  · intro n
    dsimp only
    intro hsmall j hj
    set h : ℝ := fixedRatioRefinementCellWidth T ratio n with hhdef
    change h ≤ gap / 16 at hsmall
    change j ∈ translatedMeshWindow
      (origin - gap / 16) (origin + gap / 16) origin h at hj
    have hn : ((n + 1 : ℕ) : ℝ) ≠ 0 := by positivity
    have hhpos : 0 < h := by
      rw [hhdef]
      unfold fixedRatioRefinementCellWidth
      positivity
    have hreach : ((n + 1 : ℕ) : ℝ) * (radius : ℝ) * h = reach := by
      rw [hhdef]
      dsimp [fixedRatioRefinementCellWidth, reach]
      field_simp [hratio.ne', hn]
    have hmem : origin - gap / 16 ≤ origin + (j : ℝ) * h ∧
        origin + (j : ℝ) * h ≤ origin + gap / 16 :=
      (mem_translatedMeshWindow_iff
        (origin - gap / 16) (origin + gap / 16) origin h hhpos j).mp hj
    have hcell : origin + (j : ℝ) * h < origin + ((j : ℝ) + 1) * h := by
      nlinarith
    refine ⟨?_, ?_, ?_⟩
    · intro y hy
      rw [hreach] at hy
      have hyabs : |y - origin| ≤ reach + gap / 8 := by
        apply abs_le.mpr
        constructor <;> linarith [hy.1, hy.2, hmem.1, hmem.2]
      have hfoot : |foot - origin| = |speed| * T := by
        have hid : foot - origin = -(speed * T) := by dsimp [foot]; ring
        rw [hid, abs_neg, abs_mul, abs_of_pos hT]
      have htri : |foot - origin| ≤ |foot - y| + |y - origin| := by
        simpa only [Real.dist_eq] using (dist_triangle foot y origin)
      rw [hfoot, abs_sub_comm foot y] at htri
      have hyfar : cutoff.rOut ≤ dist y foot := by
        rw [Real.dist_eq]
        change gap / 2 ≤ |y - foot|
        linarith [hgapid]
      exact (cutoff.zero_of_le_dist hyfar).symm
    · simpa only [travelingWave] using
        (oneDimensionalCellAverage_const (0 : ℝ)
          (origin + (j : ℝ) * h) (origin + ((j : ℝ) + 1) * h)
          (ne_of_lt hcell))
    · have hplateau : EqOn
          (fun x => travelingWave (cutoff : ℝ → ℝ) speed x T)
          (fun _ : ℝ => (1 : ℝ))
          (Icc (origin + (j : ℝ) * h) (origin + ((j : ℝ) + 1) * h)) := by
        intro x hx
        change cutoff (x - speed * T) = 1
        apply cutoff.one_of_mem_closedBall
        rw [Metric.mem_closedBall, Real.dist_eq]
        change |(x - speed * T) - foot| ≤ gap / 4
        have hid : (x - speed * T) - foot = x - origin := by
          dsimp [foot]
          ring
        rw [hid]
        apply abs_le.mpr
        constructor <;> linarith [hx.1, hx.2, hmem.1, hmem.2]
      calc
        oneDimensionalCellAverage
            (fun x => travelingWave (cutoff : ℝ → ℝ) speed x T)
            (origin + (j : ℝ) * h) (origin + ((j : ℝ) + 1) * h) =
            oneDimensionalCellAverage (fun _ : ℝ => (1 : ℝ))
              (origin + (j : ℝ) * h) (origin + ((j : ℝ) + 1) * h) := by
          unfold oneDimensionalCellAverage
          congr 1
          apply intervalIntegral.integral_congr
          rw [uIcc_of_le hcell.le]
          exact hplateau
        _ = 1 := oneDimensionalCellAverage_const (1 : ℝ)
          (origin + (j : ℝ) * h) (origin + ((j : ℝ) + 1) * h)
          (ne_of_lt hcell)

end NumStability
