/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.Analysis.Convex.Basic
import Mathlib.LinearAlgebra.Complex.FiniteDimensional

/-!
# Planar linear images of round two-spheres

Proof-free target for Bhatia, Matrix Analysis (1997),
Problem I.6.2, printed pages 20–21 / PDF pages 32–33.

A round two-sphere lies in the affine carrier c + U, where U has real dimension
three. Its full image under an arbitrary real-linear map to the complex plane
is a point, a closed nondegenerate segment, or a closed filled ellipse, and is
convex. The ellipse is explicitly an invertible real-linear image of the closed
Euclidean unit disc, translated by the image of the sphere centre.
-/

set_option autoImplicit false
noncomputable section
universe u

namespace NumStability.Bhatia.Chapter01.Targets

/-- The generic geometric assertion in the last sentence of Problem I.6.2. -/
def sphereImageTrichotomyTarget : Prop :=
  ∀ (V : Type u) [NormedAddCommGroup V] [InnerProductSpace ℝ V]
      [FiniteDimensional ℝ V] (U : Submodule ℝ V)
      (c : V) (r : ℝ) (L : V →ₗ[ℝ] ℂ),
    Module.finrank ℝ U = 3 →
    0 < r →
      let S : Set V :=
        (fun v : U => c + (v : V)) '' Metric.sphere (0 : U) r
      let Y : Set ℂ := L '' S
      (Y = {L c} ∨
        (∃ d : ℂ, d ≠ 0 ∧ Y = segment ℝ (L c - d) (L c + d)) ∨
        (∃ B : EuclideanSpace ℝ (Fin 2) ≃ₗ[ℝ] ℂ,
          Y = (fun x : EuclideanSpace ℝ (Fin 2) => L c + B x) ''
            Metric.closedBall (0 : EuclideanSpace ℝ (Fin 2)) 1)) ∧
        Convex ℝ Y

end NumStability.Bhatia.Chapter01.Targets
