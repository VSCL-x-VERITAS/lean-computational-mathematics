/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.Adjoint
import Mathlib.Analysis.InnerProductSpace.Trace
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.LinearAlgebra.Matrix.ToLin
import Mathlib.Data.Matrix.Basis

/-!
# The Hilbert-Schmidt structure on algebraic Hom

Transparent statement contracts for Bhatia, Matrix Analysis (1997), I.4.
-/

set_option autoImplicit false
noncomputable section
universe u v
open scoped TensorProduct BigOperators
namespace NumStability.Bhatia.Chapter01.Targets

/-- Printed14/PDF26. A genuine positive-definite trace core is constructed on
ALL algebraic Hom, with its EXISTING addition and complex module structure.
It is an existential conclusion, never an assumed Hilbert-Schmidt predicate.
The induced norm is the Hilbert-Schmidt norm, not the operator norm.
This standalone clause needs no tensor-Hom phi or unresolved dual convention. -/
def hilbertSchmidtHomTarget : Prop :=
  ∀ (H : Type u) (K : Type v)
      [NormedAddCommGroup H] [InnerProductSpace ℂ H] [FiniteDimensional ℂ H]
      [NormedAddCommGroup K] [InnerProductSpace ℂ K] [FiniteDimensional ℂ K],
    let L := H →ₗ[ℂ] K
    ∃ core : InnerProductSpace.Core ℂ L,
      (∀ (A B : L),
        core.inner A B = LinearMap.trace ℂ H ((LinearMap.adjoint A).comp B)) ∧
      (letI : InnerProductSpace.Core ℂ L := core
       letI : NormedAddCommGroup L := core.toNormedAddCommGroup
       letI : InnerProductSpace ℂ L :=
         InnerProductSpace.ofCore (inferInstance : PreInnerProductSpace.Core ℂ L)
       CompleteSpace L ∧
       (∀ (e : OrthonormalBasis (Fin (Module.finrank ℂ H)) ℂ H)
          (f : OrthonormalBasis (Fin (Module.finrank ℂ K)) ℂ K),
         ∃ units : OrthonormalBasis
             (Fin (Module.finrank ℂ K) × Fin (Module.finrank ℂ H)) ℂ L,
           ∀ (i : Fin (Module.finrank ℂ K)) (j : Fin (Module.finrank ℂ H)),
             units (i, j) = Matrix.toLin e.toBasis f.toBasis (Matrix.single i j (1 : ℂ))))

end NumStability.Bhatia.Chapter01.Targets
