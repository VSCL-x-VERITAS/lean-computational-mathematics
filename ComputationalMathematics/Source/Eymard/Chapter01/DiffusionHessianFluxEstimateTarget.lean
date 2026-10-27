/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.FiniteVolume.RectangleHessianFluxEstimate

/-!
# Diffusion Hessian Flux Estimate Target

Owner-adopted specificity-20261026 realization of Example 1.2's introductory
order-h claim. The explicit M*h value is an authored estimate, not a printed
constant. No geometric, differential, integrability or error-bound conclusion
is an assumed input. Boundary fluxes and discrete-solution errors are separate.

Source-faithfulness and proof status are recorded in `docs/formalization/eymard-chapter-01.md`.
-/

set_option autoImplicit false
noncomputable section

namespace NumStability.Eymard.Chapter01

open Set MeasureTheory
open NumStability.FiniteVolume NumStability.FiniteVolume.Planar
open NumStability.FiniteVolume.RectangleHessianFluxEstimate

/-- Owner-adopted specificity-20261026 realization of Example 1.2's introductory
order-h claim. The explicit M*h value is an authored estimate, not a printed
constant. No geometric, differential, integrability or error-bound conclusion
is an assumed input. Boundary fluxes and discrete-solution errors are separate. -/
def diffusionHessianFluxEstimateTarget : Prop :=
  ∀ (K L : Rectangle2) (σ : Segment) (U : Set Point)
    (u : Point → ℝ) (M : ℝ),
    Disjoint K.region L.region → IsFullCommonRectangleSide K L σ →
    closure K.region ∪ closure L.region ⊆ U → HasBoundedHessianOn U u M →
      0 < dist K.center L.center ∧ 0 < σ.length ∧
      ‖centreNormal K L‖ = 1 ∧
      inner ℝ (L.center - K.center) (σ.b - σ.a) = 0 ∧
      segmentSupportingFoot σ K.center ∈ σ.carrier ∧
      segmentSupportingFoot σ K.center ∈ segment ℝ K.center L.center ∧
      σ.carrier ⊆ frontier K.region ∧
      (∀ x ∈ closure K.region, ∀ y ∈ σ.carrier,
        inner ℝ (x - y) (centreNormal K L) ≤ 0) ∧
      IntegrableOn (fun x => inner ℝ (gradient u x) (centreNormal K L))
        σ.carrier lengthMeasure ∧
      normalizedError K L σ u ≤ M * diameterSize K L ∧
      |numericalFlux K L σ u - exactFlux K L σ u| ≤
        σ.length * M * diameterSize K L ∧
      diameterSize K L ≤ Real.sqrt 2 * edgeSize K L ∧
      normalizedError K L σ u ≤ (Real.sqrt 2 * M) * edgeSize K L

end NumStability.Eymard.Chapter01
