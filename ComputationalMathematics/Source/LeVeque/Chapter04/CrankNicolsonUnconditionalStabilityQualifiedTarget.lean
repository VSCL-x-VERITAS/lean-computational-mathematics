/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.CrankNicolsonUnconditionalStabilityPowerBridge

/-!
# Owner-qualified CN refinement stability: prospective proof-free target

This uncompiled draft states the actual CN-specific owner-selected convention.
It preserves the actual solved source4.13 operator, all finite-energy data and
all executed prefixes along every unrestricted positive refinement path.
No source admission, statement acceptance or proof is asserted by this file.
-/

open Filter
open scoped Topology

namespace NumStability

/-- The selected available-face approximation convention. No continuity or
boundedness of the physical coefficient is part of this predicate. -/
def Leveque04CNAvailableFaceApproximation
    (β : ℝ → ℝ) (faces : ℝ → ℤ → ℝ) : Prop :=
  ∀ (R ε : ℝ), 0 < R → 0 < ε →
    ∃ η : ℝ, 0 < η ∧
      ∀ (h : ℝ), 0 < h → h < η →
        ∀ i : ℤ, |((i : ℝ) - 1 / 2) * h| ≤ R →
          |faces h i - β (((i : ℝ) - 1 / 2) * h)| < ε

/-- The actual owner-qualified finite-horizon unconditional stability assertion.
The constant and cutoff precede every tail mesh, executed prefix and datum. -/
def Leveque04CrankNicolsonUnconditionalQualifiedStabilityTarget : Prop :=
  ∀ (β : ℝ → ℝ), (∀ x, 0 ≤ β x) →
    ∀ (faces : ℝ → ℤ → ℝ)
      (faces_nonneg : ∀ h, 0 < h → ∀ i, 0 ≤ faces h i),
      Leveque04CNAvailableFaceApproximation β faces →
        ∀ (T : ℝ), 0 < T →
          ∀ (width duration : ℕ → ℝ)
            (width_pos : ∀ m, 0 < width m)
            (duration_pos : ∀ m, 0 < duration m),
            Tendsto width atTop (𝓝 0) →
              Tendsto duration atTop (𝓝 0) →
                ∃ C : ℝ, 0 ≤ C ∧
                  ∃ m0 : ℕ, ∀ m : ℕ, m0 ≤ m →
                    let grid : WholeLineDiffusionL2Grid :=
                      { diffusivity := faces (width m)
                        diffusivity_nonneg := faces_nonneg (width m) (width_pos m)
                        width := width m
                        width_pos := width_pos m
                        timeStep := duration m
                        timeStep_nonneg := (duration_pos m).le }
                    let N := (leveque04_crankNicolsonSourceUpdate grid).1
                    ∀ (k : ℕ), (k : ℝ) * duration m ≤ T →
                      ∀ before : lp (fun _ : ℤ => ℝ) 2,
                        grid.meshL2 ((N^[k]) before) ≤ C * grid.meshL2 before

end NumStability
