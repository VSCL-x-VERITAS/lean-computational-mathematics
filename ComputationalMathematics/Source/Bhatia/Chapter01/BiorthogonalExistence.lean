/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Source.Bhatia.Chapter01.BiorthogonalBasisTarget
import Mathlib.Analysis.InnerProductSpace.Dual
import Mathlib.Analysis.Normed.Module.FiniteDimension
import Mathlib.LinearAlgebra.Basis.Basic

set_option autoImplicit false

universe u

namespace NumStability.Bhatia.Chapter01

set_option backward.isDefEq.respectTransparency false in
/-- Bhatia, Exercise I.1.1: an independent tuple admits a biorthogonal tuple. -/
theorem biorthogonal_exists : Targets.biorthogonalExists.{u} := by
  classical
  intro H _ _ _ k X hX
  let S : Submodule ℂ H := Submodule.span ℂ (Set.range X)
  letI : CompleteSpace S := FiniteDimensional.complete ℂ S
  let b : Module.Basis (Fin k) ℂ S := Module.Basis.span hX
  let f : Fin k → S →L[ℂ] ℂ :=
    fun i => LinearMap.toContinuousLinearMap (b.coord i)
  let Y : Fin k → S := fun i => (InnerProductSpace.toDual ℂ S).symm (f i)
  refine ⟨fun i => (Y i : H), ?_⟩
  intro i j
  calc
    inner ℂ (Y i : H) (X j) = inner ℂ (Y i) (b j) := by
      rw [← Module.Basis.span_apply hX j]
      rfl
    _ = f i (b j) := InnerProductSpace.toDual_symm_apply
    _ = (if i = j then 1 else 0 : ℂ) := by
      simp [f, Module.Basis.coord_apply, Finsupp.single_apply, eq_comm]

end NumStability.Bhatia.Chapter01
