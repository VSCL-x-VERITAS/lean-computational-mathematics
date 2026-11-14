/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Source.Bhatia.Chapter01.MatrixGroupTopologyTarget
import Mathlib.LinearAlgebra.Matrix.Charpoly.Basic
import Mathlib.Topology.Algebra.Module.Cardinality
import Mathlib.Algebra.Polynomial.Roots

/-!
# Bhatia Chapter I: topology of the invertible and unitary matrices

Exercise I.2.7, printed page 7. The determinant is continuous, so the invertible
matrices are open. For each `A`, `det (A + t I)` is the characteristic polynomial
of `-A` evaluated at `t`; it has finitely many roots, so `A + t I` is invertible
for `t` arbitrarily close to `0`. A unitary matrix has entries of modulus at most
one, so the unitary matrices are a closed subset of a product of closed disks.
-/

set_option autoImplicit false

namespace NumStability.Bhatia.Chapter01

open Matrix Polynomial

/-- Every entry of a matrix with `Aᴴ A = 1` has norm at most one. -/
private lemma norm_entry_le_one {n : ℕ} {A : Matrix (Fin n) (Fin n) ℂ}
    (h : A.conjTranspose * A = 1) (i j : Fin n) : ‖A i j‖ ≤ 1 := by
  have hjj := congrFun (congrFun h j) j
  simp only [Matrix.mul_apply, Matrix.conjTranspose_apply, Matrix.one_apply_eq] at hjj
  have hsum : ∑ k, ‖A k j‖ ^ 2 = 1 := by
    have : (∑ k, (‖A k j‖ ^ 2 : ℝ) : ℂ) = 1 := by
      rw [← hjj]
      push_cast
      refine Finset.sum_congr rfl fun k _ => ?_
      rw [Complex.star_def, Complex.conj_mul']
    exact_mod_cast this
  have hle : ‖A i j‖ ^ 2 ≤ 1 := by
    rw [← hsum]
    exact Finset.single_le_sum (f := fun k => ‖A k j‖ ^ 2) (fun k _ => by positivity)
      (Finset.mem_univ i)
  nlinarith [norm_nonneg (A i j)]

/-- Exercise I.2.7: the invertible matrices are dense and open, and the unitary
matrices are compact. -/
theorem invertibleMatricesDenseOpen : Targets.invertibleMatricesDenseOpen := by
  intro n
  have hset : {A : Matrix (Fin n) (Fin n) ℂ | IsUnit A} = (fun A => A.det) ⁻¹' {0}ᶜ := by
    ext A
    simp [Matrix.isUnit_iff_isUnit_det, isUnit_iff_ne_zero]
  refine ⟨?_, ?_⟩
  · intro A
    -- `A + t • 1` is invertible away from the finitely many roots of `charpoly (-A)`.
    set p : ℂ[X] := (-A).charpoly
    have hp : p ≠ 0 := (Matrix.charpoly_monic _).ne_zero
    have hfin : ((p.roots.toFinset : Finset ℂ) : Set ℂ).Countable := (Finset.countable_toSet _)
    have hdense := hfin.dense_compl ℂ
    let g : ℂ → Matrix (Fin n) (Fin n) ℂ := fun t => A + Matrix.diagonal fun _ => t
    have hg : Continuous g :=
      continuous_const.add (Continuous.matrix_diagonal (continuous_pi fun _ => continuous_id))
    have hunit : ∀ t ∉ ((p.roots.toFinset : Finset ℂ) : Set ℂ), IsUnit (g t) := by
      intro t ht
      have hne : p.eval t ≠ 0 := by
        intro h0
        exact ht (by simpa [Multiset.mem_toFinset] using (Polynomial.mem_roots hp).2 h0)
      rw [Matrix.eval_charpoly, Matrix.scalar_apply, sub_neg_eq_add, add_comm] at hne
      exact (Matrix.isUnit_iff_isUnit_det _).2 (isUnit_iff_ne_zero.2 hne)
    have h0 : g 0 = A := by simp [g]
    rw [← h0]
    have hmem : g 0 ∈ closure (g '' ((p.roots.toFinset : Finset ℂ) : Set ℂ)ᶜ) :=
      image_closure_subset_closure_image hg ⟨0, hdense.closure_eq ▸ Set.mem_univ _, rfl⟩
    refine closure_mono ?_ hmem
    rintro _ ⟨t, ht, rfl⟩
    exact hunit t ht
  · rw [hset]
    exact (isOpen_compl_singleton).preimage (continuous_id.matrix_det)

theorem unitaryMatricesCompact : Targets.unitaryMatricesCompact := by
  intro n
  have hclosed : IsClosed {A : Matrix (Fin n) (Fin n) ℂ |
      A * A.conjTranspose = 1 ∧ A.conjTranspose * A = 1} := by
    refine IsClosed.inter ?_ ?_
    · exact isClosed_eq (continuous_id.matrix_mul continuous_id.matrix_conjTranspose)
        continuous_const
    · exact isClosed_eq (continuous_id.matrix_conjTranspose.matrix_mul continuous_id)
        continuous_const
  have hbox : IsCompact (Set.univ.pi fun _ : Fin n =>
      Set.univ.pi fun _ : Fin n => Metric.closedBall (0 : ℂ) 1) :=
    isCompact_univ_pi fun _ => isCompact_univ_pi fun _ => isCompact_closedBall _ _
  refine hbox.of_isClosed_subset hclosed ?_
  intro A hA
  simp only [Set.mem_pi, Set.mem_univ, true_implies, Metric.mem_closedBall, dist_zero_right]
  exact fun i j => norm_entry_le_one hA.2 i j

end NumStability.Bhatia.Chapter01
