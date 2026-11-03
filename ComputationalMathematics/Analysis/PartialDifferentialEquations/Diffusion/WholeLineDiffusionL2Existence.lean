/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Diffusion.WholeLineCrankNicolsonEvolution
import ComputationalMathematics.Analysis.Normed.Lp.PointwiseCompactness
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Diffusion.WholeLineDiffusionL2Uniqueness
import Mathlib.Order.Filter.AtTopBot.Archimedean

/-!
# Finite-energy CN solutions with unbounded nonnegative coefficients

Clipped coefficients give actual bounded-operator CN solutions with a uniform
ℓ² bound. Product compactness and lower semicontinuity of the ℓ² norm give a
limit, and each finite three-point equation passes to that pointwise limit.
No upper bound on the original coefficient sequence is required.
-/

namespace NumStability

open Filter
open scoped Topology

private def clippedCNGrid (b : ℤ → ℝ) (hpos : ∀ i, 0 ≤ b i)
    (width : ℝ) (hwidth : 0 < width) (timeStep : ℝ) (htime : 0 ≤ timeStep)
    (k : ℕ) : WholeLineCrankNicolsonGrid where
  diffusivity i := min (b i) (k : ℝ)
  bound := (k : ℝ)
  bound_nonneg := Nat.cast_nonneg k
  diffusivity_le i := by
    rw [abs_of_nonneg (le_min (hpos i) (Nat.cast_nonneg k))]
    exact min_le_right _ _
  diffusivity_nonneg i := le_min (hpos i) (Nat.cast_nonneg k)
  width := width
  width_pos := hwidth
  timeStep := timeStep
  timeStep_nonneg := htime

private theorem wholeLineCN_update_norm_le (grid : WholeLineCrankNicolsonGrid)
    (before : lp (fun _ : ℤ => ℝ) 2) : ‖grid.update before‖ ≤ ‖before‖ := by
  have hzero : grid.update 0 = 0 := by
    symm
    apply (grid.eq_update_iff 0 0).mpr
    intro i
    change (0 : ℝ) - 0 = grid.timeStep / 2 *
      ((grid.diffusivity (i + 1) * ((0 + 0) - (0 + 0)) -
        grid.diffusivity i * ((0 + 0) - (0 + 0))) / grid.width ^ 2)
    simp
  simpa only [hzero, sub_zero] using grid.update_norm_sub_le before 0

/-- Every nonnegative interface coefficient sequence, even unbounded along the
entire integer line, admits a finite-energy CN after-state of no greater norm.
The time step has no upper restriction. -/
theorem wholeLineDiffusionL2_exists
    (b : ℤ → ℝ) (hpos : ∀ i, 0 ≤ b i)
    (width timeStep : ℝ) (hwidth : 0 < width) (htime : 0 ≤ timeStep)
    (before : lp (fun _ : ℤ => ℝ) 2) :
    ∃ after : lp (fun _ : ℤ => ℝ) 2,
      IsWholeLineWeightedDiffusionCNStep b width timeStep before after ∧
        ‖after‖ ≤ ‖before‖ := by
  let grid := clippedCNGrid b hpos width hwidth timeStep htime
  let F : ℕ → lp (fun _ : ℤ => ℝ) 2 := fun k => (grid k).update before
  have hnorm (k : ℕ) : ‖F k‖ ≤ ‖before‖ := wholeLineCN_update_norm_le (grid k) before
  obtain ⟨after, hafterNorm, φ, hφ, hlimit⟩ :=
    l2_exists_pointwise_convergent_subseq F ‖before‖ hnorm
  have hcast : Tendsto (fun k => (φ k : ℝ)) atTop atTop :=
    (tendsto_natCast_atTop_atTop : Tendsto (fun k : ℕ => (k : ℝ)) atTop atTop).comp
      hφ.tendsto_atTop
  have hcoeff (i : ℤ) :
      Tendsto (fun k => min (b i) (φ k : ℝ)) atTop (𝓝 (b i)) := by
    apply tendsto_const_nhds.congr'
    filter_upwards [hcast.eventually (eventually_ge_atTop (b i))] with k hk
    exact (min_eq_left hk).symm
  refine ⟨after, ?_, hafterNorm⟩
  intro i
  have hleft := (hlimit i).sub (tendsto_const_nhds (x := before i))
  have hsum (j : ℤ) : Tendsto (fun k => F (φ k) j + before j) atTop
      (𝓝 (after j + before j)) :=
    (hlimit j).add tendsto_const_nhds
  have hright : Tendsto
      (fun k => timeStep / 2 *
        ((min (b (i + 1)) (φ k : ℝ) *
            ((F (φ k) (i + 1) + before (i + 1)) - (F (φ k) i + before i)) -
          min (b i) (φ k : ℝ) *
            ((F (φ k) i + before i) - (F (φ k) (i - 1) + before (i - 1)))) /
          width ^ 2)) atTop
      (𝓝 (timeStep / 2 *
        ((b (i + 1) * ((after (i + 1) + before (i + 1)) - (after i + before i)) -
          b i * ((after i + before i) - (after (i - 1) + before (i - 1)))) /
          width ^ 2))) :=
    tendsto_const_nhds.mul
      ((((hcoeff (i + 1)).mul ((hsum (i + 1)).sub (hsum i))).sub
        ((hcoeff i).mul ((hsum i).sub (hsum (i - 1))))).div_const (width ^ 2))
  have heq : (fun k => F (φ k) i - before i) =
      (fun k => timeStep / 2 *
        ((min (b (i + 1)) (φ k : ℝ) *
            ((F (φ k) (i + 1) + before (i + 1)) - (F (φ k) i + before i)) -
          min (b i) (φ k : ℝ) *
            ((F (φ k) i + before i) - (F (φ k) (i - 1) + before (i - 1)))) /
          width ^ 2)) := by
    funext k
    exact (grid (φ k)).update_spec before i
  rw [heq] at hleft
  exact tendsto_nhds_unique hleft hright

/-- The actual whole-line CN equation has exactly one finite-energy solution
for every nonnegative coefficient sequence, with no coefficient bound. -/
theorem wholeLineDiffusionL2_existsUnique
    (b : ℤ → ℝ) (hpos : ∀ i, 0 ≤ b i)
    (width timeStep : ℝ) (hwidth : 0 < width) (htime : 0 ≤ timeStep)
    (before : lp (fun _ : ℤ => ℝ) 2) :
    ∃! after : lp (fun _ : ℤ => ℝ) 2,
      IsWholeLineWeightedDiffusionCNStep b width timeStep before after := by
  obtain ⟨after, hstep, _⟩ := wholeLineDiffusionL2_exists b hpos width timeStep hwidth htime before
  exact ⟨after, hstep, fun other hother =>
    wholeLineDiffusion_l2_step_unique b hpos width timeStep htime before other after hother hstep⟩

/-- Every two actual finite-energy CN steps contract their difference, even
when the nonnegative face coefficients grow without bound. -/
theorem wholeLineDiffusionL2_norm_sub_le
    (b : ℤ → ℝ) (hpos : ∀ i, 0 ≤ b i)
    (width timeStep : ℝ) (hwidth : 0 < width) (htime : 0 ≤ timeStep)
    (before₁ after₁ before₂ after₂ : lp (fun _ : ℤ => ℝ) 2)
    (h₁ : IsWholeLineWeightedDiffusionCNStep b width timeStep before₁ after₁)
    (h₂ : IsWholeLineWeightedDiffusionCNStep b width timeStep before₂ after₂) :
    ‖after₁ - after₂‖ ≤ ‖before₁ - before₂‖ := by
  obtain ⟨limit, hlimit, hnorm⟩ :=
    wholeLineDiffusionL2_exists b hpos width timeStep hwidth htime (before₁ - before₂)
  have hdiff : IsWholeLineWeightedDiffusionCNStep b width timeStep
      (before₁ - before₂) (after₁ - after₂) := by
    simpa only [lp.coeFn_sub] using
      wholeLineWeightedDiffusionCNStep_sub b width timeStep before₁ after₁ before₂ after₂ h₁ h₂
  have heq := wholeLineDiffusion_l2_step_unique b hpos width timeStep htime
    (before₁ - before₂) (after₁ - after₂) limit hdiff hlimit
  rw [heq]
  exact hnorm

end NumStability
