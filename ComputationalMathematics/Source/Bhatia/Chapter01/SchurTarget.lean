/-
SPDX-License-Identifier: MIT
Bhatia, Matrix Analysis (1997), I.2, printed pages 4–5 (PDF16–17),
with finite complex Hilbert-space conventions on PDF13 and coordinates PDF15–16.
-/
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.LinearAlgebra.Matrix.ToLin
import Mathlib.LinearAlgebra.Matrix.ConjTranspose
import Mathlib.LinearAlgebra.Matrix.Block
import Mathlib.LinearAlgebra.UnitaryGroup

set_option autoImplicit false

open scoped Matrix

universe u

namespace NumStability.Bhatia.Chapter01.Targets

/-- All prefixes of the witnessed ordered orthonormal basis are invariant.
`k = 0` is the empty prefix and `k = n` the whole basis. -/
def schurInitialSpansInvariant
    {H : Type u} [NormedAddCommGroup H] [InnerProductSpace ℂ H]
    {n : ℕ} (A : H →ₗ[ℂ] H) (Y : OrthonormalBasis (Fin n) ℂ H) : Prop :=
  ∀ (k : Fin (n + 1)) (x : H),
    x ∈ Submodule.span ℂ
      ((fun i : Fin n => Y i) '' {i : Fin n | i.val < k.val}) →
    A x ∈ Submodule.span ℂ
      ((fun i : Fin n => Y i) '' {i : Fin n | i.val < k.val})

/-- The arbitrary-space assertion, together with its coordinate realization.
No basis is supplied to obtain the Schur basis `Y`. The reference basis `E`
occurs only inside the conclusion, after `Y` has been witnessed. -/
def schurBasisAndCoordinates : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (A : H →ₗ[ℂ] H),
    let n := Module.finrank ℂ H
    ∃ Y : OrthonormalBasis (Fin n) ℂ H,
      schurInitialSpansInvariant A Y ∧
      ∀ E : OrthonormalBasis (Fin n) ℂ H,
        ∃ Q : Matrix.unitaryGroup (Fin n) ℂ,
          ∃ T : Matrix (Fin n) (Fin n) ℂ,
            (∀ i j : Fin n,
              (Q : Matrix (Fin n) (Fin n) ℂ) i j = E.repr (Y j) i) ∧
            T = LinearMap.toMatrix Y.toBasis Y.toBasis A ∧
            Matrix.BlockTriangular T (fun i : Fin n => i) ∧
            LinearMap.toMatrix E.toBasis E.toBasis A =
              (Q : Matrix (Fin n) (Fin n) ℂ) * T *
                (Q : Matrix (Fin n) (Fin n) ℂ).conjTranspose

/-- The printed all-matrices formulation, including dimension zero. -/
def schurMatrix : Prop :=
  ∀ (n : ℕ) (A : Matrix (Fin n) (Fin n) ℂ),
    ∃ Q : Matrix.unitaryGroup (Fin n) ℂ,
      ∃ T : Matrix (Fin n) (Fin n) ℂ,
        Matrix.BlockTriangular T (fun i : Fin n => i) ∧
        A = (Q : Matrix (Fin n) (Fin n) ℂ) * T *
          (Q : Matrix (Fin n) (Fin n) ℂ).conjTranspose

/-- Both source formulations; coordinate data explicitly connect arbitrary H
with actual complex matrices in `schurBasisAndCoordinates`. -/
def schur : Prop :=
  schurBasisAndCoordinates.{u} ∧ schurMatrix

end NumStability.Bhatia.Chapter01.Targets
