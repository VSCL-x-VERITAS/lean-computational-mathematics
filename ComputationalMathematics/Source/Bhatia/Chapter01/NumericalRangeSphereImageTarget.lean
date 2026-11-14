/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.Analysis.Convex.Basic
import Mathlib.LinearAlgebra.Complex.FiniteDimensional
import Mathlib.LinearAlgebra.Matrix.Trace

/-!
# The trace image of the prescribed projector sphere

Proof-free target for Bhatia, Matrix Analysis (1997), Problem I.6.2,
printed pages 20–21 / PDF pages 32–33. The map is the actual matrix
formula `T ↦ tr (A T)` on all unit-vector outer products in complex dimension
two. The generic geometric trichotomy is a separate supporting proposition.
-/

set_option autoImplicit false
noncomputable section

namespace NumStability.Bhatia.Chapter01.Targets

/-- The prescribed trace map sends the full projector sphere to a point,
a closed nondegenerate segment, or a closed filled ellipse; its image is convex. -/
def numericalRangeSphereImageTarget : Prop :=
  ∀ A : Matrix (Fin 2) (Fin 2) ℂ,
    let P : Set (Matrix (Fin 2) (Fin 2) ℂ) :=
      {T | ∃ x : EuclideanSpace ℂ (Fin 2), ‖x‖ = 1 ∧
        T = fun i j => (WithLp.ofLp x) i * star ((WithLp.ofLp x) j)}
    let Y : Set ℂ := (fun T : Matrix (Fin 2) (Fin 2) ℂ => Matrix.trace (A * T)) '' P
    let q := Matrix.trace (A * ((1 / 2 : ℂ) • (1 : Matrix (Fin 2) (Fin 2) ℂ)))
    (Y = {q} ∨
      (∃ d : ℂ, d ≠ 0 ∧ Y = segment ℝ (q - d) (q + d)) ∨
      (∃ B : EuclideanSpace ℝ (Fin 2) ≃ₗ[ℝ] ℂ,
        Y = (fun x : EuclideanSpace ℝ (Fin 2) => q + B x) ''
          Metric.closedBall (0 : EuclideanSpace ℝ (Fin 2)) 1)) ∧
      Convex ℝ Y

end NumStability.Bhatia.Chapter01.Targets
