/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.SingularValues.Basic
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.Analysis.Complex.Trigonometric
import Mathlib.LinearAlgebra.Matrix.Trace

/-!
# The projector sphere in complex dimension two

Proof-free target for Bhatia, Matrix Analysis (1997), Problem I.6.2,
printed page 20 / PDF page 32. The metric quantity is the explicit Frobenius
norm, and the sphere lies in the affine trace-one Hermitian carrier.
-/

set_option autoImplicit false
noncomputable section

namespace NumStability.Bhatia.Chapter01.Targets

/-- The full unit-column outer-product set is the stated Frobenius sphere,
with the complete displayed real-parameter family. -/
def projectorSphereTarget : Prop :=
  let P : Set (Matrix (Fin 2) (Fin 2) ℂ) :=
    {T | ∃ x : EuclideanSpace ℂ (Fin 2), ‖x‖ = 1 ∧
      T = fun i j => (WithLp.ofLp x) i * star ((WithLp.ofLp x) j)}
  let c := (1 / 2 : ℂ) • (1 : Matrix (Fin 2) (Fin 2) ℂ)
  let R : ℝ × ℝ → Matrix (Fin 2) (Fin 2) ℂ := fun p =>
    c + (1 / 2 : ℂ) •
      !![(Real.cos (2 * p.1) : ℂ),
          Complex.exp (Complex.I * (p.2 : ℂ)) * (Real.sin (2 * p.1) : ℂ);
        Complex.exp (-Complex.I * (p.2 : ℂ)) * (Real.sin (2 * p.1) : ℂ),
          -(Real.cos (2 * p.1) : ℂ)]
  P = {T | T.IsHermitian ∧ Matrix.trace T = 1 ∧
    complexMatrixFrobenius (T - c) = 1 / Real.sqrt 2} ∧
  P = Set.range R ∧
  ∀ t w : ℝ,
    let x : EuclideanSpace ℂ (Fin 2) :=
      WithLp.toLp 2 ![(Real.cos t : ℂ),
        Complex.exp (-Complex.I * (w : ℂ)) * (Real.sin t : ℂ)]
    ‖x‖ = 1 ∧
      (fun i j => (WithLp.ofLp x) i * star ((WithLp.ofLp x) j)) = R (t, w)

end NumStability.Bhatia.Chapter01.Targets
