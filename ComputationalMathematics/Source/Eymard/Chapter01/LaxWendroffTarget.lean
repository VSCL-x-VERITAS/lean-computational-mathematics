/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.FiniteVolume.LaxWendroffOperators
import ComputationalMathematics.Analysis.FiniteVolume.FluxConsistency
import Mathlib.Topology.MetricSpace.Lipschitz

/-!
# The first Lax-Wendroff conclusion in Eymard, Gallouet and Herbin

The fixed-flux explicit family uses the existing generic conservative update
on actual positive adjacent source intervals. The named mesh evidence is the
same source hypothesis, now also used by the concrete reconstruction.
-/

set_option autoImplicit false
noncomputable section
open MeasureTheory Filter
open scoped Topology BigOperators ENNReal

namespace NumStability.Eymard.Chapter01

/-- Theorem 21.2, first conclusion. Stability and a.e. convergence are hypotheses.
The fixed g is bound once, before all meshes, interfaces and time levels. -/
def laxWendroffTarget : Prop :=
  ∀ (physicalFlux initial : ℝ → ℝ) (lower upper : ℝ),
    ContDiff ℝ 1 physicalFlux → MemLp initial ∞ volume →
    (∀ᵐ x : ℝ, lower ≤ initial x ∧ initial x ≤ upper) →
    ∀ (g : ℝ → ℝ → ℝ), LocallyLipschitz (fun z : ℝ × ℝ => g z.1 z.2) →
    NumStability.FiniteVolume.IsScalarFluxConsistent physicalFlux g →
    ∀ (alpha : ℝ) (face : ℕ → ℤ → ℝ) (k : ℕ → ℝ),
    0 < alpha → ∀ (hmesh : ∀ m, laxWendroffMesh (face m)),
    (∀ m i, alpha * laxWendroffMeshSize (face m) ≤ laxWendroffWidth (face m) i) →
    (∀ m, 0 < k m) →
    Tendsto (fun m => laxWendroffMeshSize (face m)) atTop (𝓝 0) →
    Tendsto k atTop (𝓝 0) →
    (∃ A : ℝ, 0 ≤ A ∧ ∀ m,
      MemLp (laxWendroffReconstruction (face m) (hmesh m) (k m) initial g) ∞
        (volume.restrict laxWendroffHalfSpace) ∧
      ∀ᵐ z ∂(volume.restrict laxWendroffHalfSpace),
        |laxWendroffReconstruction (face m) (hmesh m) (k m) initial g z| ≤ A) →
    ∀ u : (ℝ × ℝ) → ℝ,
      (∀ᵐ z ∂(volume.restrict laxWendroffHalfSpace),
        Tendsto (fun m => laxWendroffReconstruction (face m) (hmesh m) (k m) initial g z)
          atTop (𝓝 (u z))) →
      laxWendroffWeakSolution physicalFlux initial u

end NumStability.Eymard.Chapter01
