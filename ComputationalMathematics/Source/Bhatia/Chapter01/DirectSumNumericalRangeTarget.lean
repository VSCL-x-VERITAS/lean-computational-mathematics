/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.ProdL2
import Mathlib.Analysis.Normed.Module.FiniteDimension
import Mathlib.Topology.Algebra.Module.LinearMapPiProd
import Mathlib.Analysis.Convex.Hull

/-!
# Bhatia Exercise I.3.1(i): numerical range of a direct sum

The diagonal operator acts on the actual Hilbert L2 product. The conclusion is
the real convex hull of the union of both full unit-sphere numerical ranges.
-/

set_option autoImplicit false
universe u v

namespace NumStability.Bhatia.Chapter01.Targets

/-- The direct sum fills precisely the convex hull of both numerical ranges. -/
def numericalRangeDirectSum : Prop :=
  ∀ (H : Type u) (K : Type v)
      [NormedAddCommGroup H] [InnerProductSpace ℂ H] [FiniteDimensional ℂ H]
      [NormedAddCommGroup K] [InnerProductSpace ℂ K] [FiniteDimensional ℂ K]
      (A₁ : H →L[ℂ] H) (A₂ : K →L[ℂ] K),
    let L := WithLp.prodContinuousLinearEquiv 2 ℂ H K
    let A := L.symm.toContinuousLinearMap.comp
      ((A₁.prodMap A₂).comp L.toContinuousLinearMap)
    let W₁ : Set ℂ := {z : ℂ | ∃ x : H, ‖x‖ = 1 ∧ z = inner ℂ x (A₁ x)}
    let W₂ : Set ℂ := {z : ℂ | ∃ x : K, ‖x‖ = 1 ∧ z = inner ℂ x (A₂ x)}
    {z : ℂ | ∃ x : WithLp 2 (H × K), ‖x‖ = 1 ∧ z = inner ℂ x (A x)} =
      convexHull ℝ (W₁ ∪ W₂)

end NumStability.Bhatia.Chapter01.Targets
