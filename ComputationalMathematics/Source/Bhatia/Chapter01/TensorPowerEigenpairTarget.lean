/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.Complex.Basic
import Mathlib.Analysis.InnerProductSpace.Defs
import Mathlib.LinearAlgebra.FiniteDimensional.Defs
import Mathlib.LinearAlgebra.PiTensorProduct
import Mathlib.LinearAlgebra.Eigenspace.Basic

/-!
Proof-free statement for Bhatia, Matrix Analysis (1997),
I.4 tensor-power property 5, printed p. 15 / PDF p. 27.

The carrier, elementary tensor and factorwise action are actual existing
PiTensorProduct definitions. No arbitrary tensor action or realization is an
input. HasEigenvector carries nonzeroness. The paired input tuples are arbitrary
and may repeat; the explicit output vector witnesses the eigenvalue conclusion.
No Hilbert structure on PiTensorProduct is claimed or needed by this algebraic
statement. The ambient H domain remains the source's finite-dimensional complex
Hilbert spaces, with arbitrary A and all positive k.
-/

set_option autoImplicit false
universe u
open scoped BigOperators

namespace NumStability.Bhatia.Chapter01.Targets

/-- The prescribed elementary tensor is the nonzero eigenvector; no spectral
classification, multiplicity claim, or diagonalizability hypothesis is added. -/
def tensorPowerEigenpairTarget : Prop :=
  ∀ (H : Type u)
      [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (k : ℕ), 0 < k →
    ∀ (A : H →ₗ[ℂ] H) (α : Fin k → ℂ) (u : Fin k → H),
      (∀ i : Fin k, Module.End.HasEigenvector A (α i) (u i)) →
      let T := PiTensorProduct ℂ (fun _ : Fin k => H)
      let P : T →ₗ[ℂ] T := PiTensorProduct.map (fun _ : Fin k => A)
      Module.End.HasEigenvalue P (∏ i : Fin k, α i) ∧
      Module.End.HasEigenvector P (∏ i : Fin k, α i)
        (PiTensorProduct.tprod ℂ u)

end NumStability.Bhatia.Chapter01.Targets
