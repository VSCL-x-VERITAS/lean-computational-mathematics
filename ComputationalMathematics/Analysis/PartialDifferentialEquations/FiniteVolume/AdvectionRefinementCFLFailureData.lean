/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.AdvectionRefinementCFL
import Mathlib.Topology.Separation.Hausdorff

/-!
# Fixed failure data outside an advection read cone

Two continuous initial fields witness failure of all-data convergence when the
transported characteristic foot lies outside the limiting numerical read cone.
-/

open Set Metric Filter
open scoped Topology

namespace NumStability

/-- A transported characteristic foot outside the limiting three-point read
cone admits two fixed continuous initial fields with distinct exact values and
eventually identical numerical observations. Hence all-data convergence fails.
Physically local initialization may inspect each complete closed grid cell. -/
theorem advectionRefinement_missedFoot_pair_of_localInitialization :
  ∀ (update : ℕ → ℕ → (ℤ → ℝ) → ℤ → ℝ)
    (initialData : ℕ → (ℝ → ℝ) → ℤ → ℝ) (speed X T ratio : ℝ),
    0 < T → 0 < ratio → IsCenteredStencilUpdateFamily 1 update →
      IsLocalRefinementInitialization initialData X T ratio →
      T / ratio < |(X - speed * T) - X| →
      (∃ f g : ℝ → ℝ, Continuous f ∧ Continuous g ∧
        f (X - speed * T) ≠ g (X - speed * T) ∧
        (∀ᶠ n in Filter.atTop,
          centeredRefinementApproximation update initialData n f =
            centeredRefinementApproximation update initialData n g)) ∧
      ¬ IsAdvectionRefinementConvergent update initialData speed X T := by
  intro update initialData speed X T ratio hT hratio hlocal hinitial hmissed
  let foot : ℝ := X - speed * T
  let width : ℕ → ℝ := fixedRatioRefinementCellWidth T ratio
  let Rn : ℕ → ℝ := fun n => ((n+1 : ℕ) : ℝ) * width n + width n / 2
  let ε : ℝ := (|foot - X| - T / ratio) / 4
  have hgap : T / ratio < |foot - X| := hmissed
  have hε : 0 < ε := by dsimp [ε]; linarith
  obtain ⟨f, g, hf, hg, houtside, hdistinct⟩ :=
    evaluation_continuous_essential_neighborhood foot ε hε
  have hwidth (n : ℕ) : 0 ≤ width n := by
    dsimp [width, fixedRatioRefinementCellWidth]
    positivity
  have hlimit : Tendsto Rn atTop (𝓝 (T / ratio)) := by
    simpa only [Rn, width, fixedRatioRefinementCellWidth, Nat.cast_one,
      mul_one, one_mul] using
      fixedRatioRefinement_cellConeRadius_tendsto T ratio 1 hratio
  have hradius : ∀ᶠ n in atTop, Rn n < T / ratio + ε :=
    hlimit.eventually (Iio_mem_nhds (by linarith : T / ratio < T / ratio + ε))
  have hequal : ∀ᶠ n in atTop,
      centeredRefinementApproximation update initialData n f =
        centeredRefinementApproximation update initialData n g := by
    filter_upwards [hradius] with n hn
    have hagree : EqOn f g (Icc (X - Rn n) (X + Rn n)) := by
      intro y hy
      apply houtside y
      intro hclose
      have hybound : |y - X| ≤ Rn n :=
        abs_le.mpr ⟨by linarith [hy.1], by linarith [hy.2]⟩
      have hdist : |foot - y| < ε := by
        simpa only [Metric.mem_ball, Real.dist_eq, abs_sub_comm] using hclose
      have htriangle := abs_sub_le foot y X
      dsimp [ε] at hn hdist
      linarith
    change centeredStencilEvolution (update n) (initialData n f) (n+1) 0 =
      centeredStencilEvolution (update n) (initialData n g) (n+1) 0
    apply centeredStencilEvolution_localInitialization
      (update n) 1 (initialData n) X (width n) (hwidth n) (hlocal n) f g (n+1) 0
    · exact hinitial n f g hf hg
    · simpa only [Rn, Nat.cast_one, Int.cast_zero, zero_mul, add_zero,
        mul_one, sub_add_eq_sub_sub, add_assoc] using hagree
  refine ⟨⟨f, g, hf, hg, hdistinct, hequal⟩, ?_⟩
  intro hconverges
  exact hdistinct (tendsto_nhds_unique_of_eventuallyEq
    (hconverges f hf) (hconverges g hg) hequal)

end NumStability
