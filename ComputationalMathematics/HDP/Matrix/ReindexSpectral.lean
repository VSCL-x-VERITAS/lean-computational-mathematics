import ComputationalMathematics.HDP.Matrix.OrderedEigenbasis
import Mathlib.Analysis.Matrix.Spectrum

/-!
# Matrix quantities under coordinate relabeling

Coordinate equivalences preserve the real L2 operator norm and ordinary
eigenspace dimensions. Coordinate permutations also preserve the complete
algebraically ordered spectrum, including multiplicities and tied values.
-/

noncomputable section

set_option backward.isDefEq.respectTransparency false

open Matrix
open scoped Matrix.Norms.L2Operator

namespace NumStability.HDP.Matrix

private theorem reindex_action {α β : Type*} [Fintype α] [Fintype β]
    (e : α ≃ β) (A : Matrix α α ℝ) (x : α → ℝ) :
    (Matrix.reindex e e A).mulVec (x ∘ e.symm) = (A.mulVec x) ∘ e.symm := by
  rw [Matrix.reindex_apply, Matrix.submatrix_mulVec_equiv]
  simp [Function.comp_def]

private theorem reindex_norm_le {α β : Type*} [Fintype α] [Fintype β]
    [DecidableEq α] [DecidableEq β] (e : α ≃ β) (A : Matrix α α ℝ) :
    ‖Matrix.reindex e e A‖ ≤ ‖A‖ := by
  let E := LinearIsometryEquiv.piLpCongrLeft 2 ℝ ℝ e
  change ‖Matrix.toEuclideanCLM (𝕜 := ℝ) (Matrix.reindex e e A)‖ ≤ ‖A‖
  apply ContinuousLinearMap.opNorm_le_bound _ (norm_nonneg A)
  intro x
  have hact : Matrix.toEuclideanCLM (𝕜 := ℝ) (n := β) (Matrix.reindex e e A) x =
      E (Matrix.toEuclideanCLM (𝕜 := ℝ) (n := α) A (E.symm x)) := by
    dsimp only [E]
    rw [LinearIsometryEquiv.piLpCongrLeft_symm]
    ext i
    change (A.submatrix e.symm e.symm).mulVec (fun j => x j) i =
      A.mulVec (fun j => x (e j)) (e.symm i)
    rw [Matrix.submatrix_mulVec_equiv]
    simp [Function.comp_def]
  rw [hact, E.norm_map]
  simpa only [E.symm.norm_map, Matrix.l2_opNorm_toEuclideanCLM] using
    (Matrix.toEuclideanCLM (𝕜 := ℝ) (n := α) A).le_opNorm (E.symm x)

/-- Reindexing rows and columns by the same equivalence preserves the L2 operator norm. -/
theorem l2_opNorm_reindex {α β : Type*} [Fintype α] [Fintype β]
    [DecidableEq α] [DecidableEq β] (e : α ≃ β) (A : Matrix α α ℝ) :
    ‖Matrix.reindex e e A‖ = ‖A‖ := by
  apply le_antisymm (reindex_norm_le e A)
  simpa [Matrix.reindex_apply, Matrix.submatrix_submatrix] using
    reindex_norm_le e.symm (Matrix.reindex e e A)

/-- Coordinate relabeling preserves every ordinary eigenspace dimension. -/
theorem finrank_eigenspace_reindex {α β : Type*} [Fintype α] [Fintype β]
    (e : α ≃ β) (A : Matrix α α ℝ) (r : ℝ) :
    Module.finrank ℝ (Module.End.eigenspace (Matrix.reindex e e A).mulVecLin r) =
      Module.finrank ℝ (Module.End.eigenspace A.mulVecLin r) := by
  let E : (β → ℝ) ≃ₗ[ℝ] (α → ℝ) := LinearEquiv.funCongrLeft ℝ ℝ e
  have hspace : Module.End.eigenspace (Matrix.reindex e e A).mulVecLin r =
      (Module.End.eigenspace A.mulVecLin r).comap E.toLinearMap := by
    ext x
    simp only [Module.End.mem_eigenspace_iff, Submodule.mem_comap, Matrix.mulVecLin_apply]
    have hx : x = (E x) ∘ e.symm := by ext i; simp [E]
    rw [hx, reindex_action]
    constructor
    · intro h
      ext i
      have hi := congrFun h (e i)
      simpa [E, Function.comp_def] using hi
    · intro h
      simpa [E, Function.comp_def] using congrArg (fun y => y ∘ e.symm) h
  rw [hspace, Submodule.comap_equiv_eq_map_symm, LinearEquiv.finrank_map_eq]

/-- Coordinate permutations preserve the complete decreasing Hermitian eigenvalue list. -/
theorem hermitianOrderedEigenvalue_reindex {n : ℕ} (e : Equiv.Perm (Fin n))
    (A : Matrix (Fin n) (Fin n) ℝ) (hA : A.IsHermitian)
    (hB : (Matrix.reindex e e A).IsHermitian) :
    NumStability.hermitianOrderedEigenvalue hB = NumStability.hermitianOrderedEigenvalue hA := by
  let E := LinearIsometryEquiv.piLpCongrLeft 2 ℝ ℝ e
  apply (NumStability.HDP.Matrix.antitone_eigenvalue_eq_ordered_of_eigenbasis hB
    (NumStability.hermitianOrderedEigenvalue hA)
    ((NumStability.hermitianOrderedEigenbasis hA).map E)
    (NumStability.hermitianOrderedEigenvalue_antitone hA) ?_).symm
  intro i
  simp only [OrthonormalBasis.map_apply]
  have hact : (Matrix.reindex e e A).toEuclideanLin
      (E (NumStability.hermitianOrderedEigenbasis hA i)) =
      E (A.toEuclideanLin (NumStability.hermitianOrderedEigenbasis hA i)) := by
    ext j
    exact congrFun (reindex_action e A
      (NumStability.hermitianOrderedEigenbasis hA i).ofLp) j
  rw [hact, NumStability.hermitianOrderedEigenbasis_apply, map_smul]

end NumStability.HDP.Matrix
