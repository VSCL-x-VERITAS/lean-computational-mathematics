import ComputationalMathematics.Analysis.MatrixSpectral
import Mathlib.LinearAlgebra.FiniteDimensional.Lemmas

/-!
# Courant--Fischer for finite real symmetric matrices

This module gives the max--min theorem in a witness form: a leading spectral
subspace attains the ordered eigenvalue as its least unit Rayleigh value, and
every subspace of the same dimension contains a unit vector whose Rayleigh
value is no larger.  This is logically the finite-dimensional maximum over
subspaces without committing source-facing statements to a particular
topological encoding of `max` and `min`.
-/

namespace NumStability

open scoped BigOperators RealInnerProductSpace

noncomputable section

/-- The decreasingly ordered eigenvalues of a real Hermitian matrix. -/
def hermitianOrderedEigenvalue {n : ℕ} {A : Matrix (Fin n) (Fin n) ℝ}
    (hA : A.IsHermitian) : Fin n → ℝ :=
  (Matrix.isHermitian_iff_isSymmetric.mp hA).eigenvalues
    finrank_euclideanSpace_fin

/-- An orthonormal eigenbasis aligned with `hermitianOrderedEigenvalue`. -/
def hermitianOrderedEigenbasis {n : ℕ} {A : Matrix (Fin n) (Fin n) ℝ}
    (hA : A.IsHermitian) :
    OrthonormalBasis (Fin n) ℝ (EuclideanSpace ℝ (Fin n)) :=
  (Matrix.isHermitian_iff_isSymmetric.mp hA).eigenvectorBasis
    finrank_euclideanSpace_fin

theorem hermitianOrderedEigenvalue_antitone {n : ℕ}
    {A : Matrix (Fin n) (Fin n) ℝ} (hA : A.IsHermitian) :
    Antitone (hermitianOrderedEigenvalue hA) :=
  (Matrix.isHermitian_iff_isSymmetric.mp hA).eigenvalues_antitone
    finrank_euclideanSpace_fin

theorem hermitianOrderedEigenbasis_apply {n : ℕ}
    {A : Matrix (Fin n) (Fin n) ℝ} (hA : A.IsHermitian) (a : Fin n) :
    A.toEuclideanLin (hermitianOrderedEigenbasis hA a) =
      hermitianOrderedEigenvalue hA a • hermitianOrderedEigenbasis hA a :=
  (Matrix.isHermitian_iff_isSymmetric.mp hA).apply_eigenvectorBasis
    finrank_euclideanSpace_fin a

theorem hermitianOrderedEigenbasis_orthonormal {n : ℕ}
    {A : Matrix (Fin n) (Fin n) ℝ} (hA : A.IsHermitian) :
    Orthonormal ℝ (hermitianOrderedEigenbasis hA) :=
  (hermitianOrderedEigenbasis hA).orthonormal

/-- The real Rayleigh quadratic form of a matrix. -/
def matrixRayleighForm {n : ℕ} (A : Matrix (Fin n) (Fin n) ℝ)
    (x : EuclideanSpace ℝ (Fin n)) : ℝ :=
  inner ℝ x (A.toEuclideanLin x)

/-- Spectral-coordinate expansion of the Rayleigh form. -/
theorem matrixRayleighForm_eq_sum {n : ℕ}
    {A : Matrix (Fin n) (Fin n) ℝ} (hA : A.IsHermitian)
    (x : EuclideanSpace ℝ (Fin n)) :
    matrixRayleighForm A x = ∑ a : Fin n,
      hermitianOrderedEigenvalue hA a *
        ((hermitianOrderedEigenbasis hA).repr x a) ^ 2 := by
  let b := hermitianOrderedEigenbasis hA
  let T := A.toEuclideanLin
  calc
    matrixRayleighForm A x = ∑ a : Fin n,
        inner ℝ x (b a) * inner ℝ (b a) (T x) := by
      simpa [matrixRayleighForm, b, T] using
        (OrthonormalBasis.sum_inner_mul_inner b x (T x)).symm
    _ = ∑ a : Fin n,
        hermitianOrderedEigenvalue hA a * (b.repr x a) ^ 2 := by
      apply Finset.sum_congr rfl
      intro a _
      have hinner : inner ℝ x (b a) = b.repr x a := by
        rw [b.repr_apply_apply]
        exact real_inner_comm (b a) x
      have hcoord :=
        (Matrix.isHermitian_iff_isSymmetric.mp hA).eigenvectorBasis_apply_self_apply
          finrank_euclideanSpace_fin x a
      change b.repr (T x) a = hermitianOrderedEigenvalue hA a * b.repr x a at hcoord
      have hinnerT : inner ℝ (b a) (T x) = b.repr (T x) a := by
        rw [b.repr_apply_apply]
      rw [hinner, hinnerT, hcoord]
      ring
    _ = _ := rfl

/-- Leading spectral subspace through rank `i`. -/
def hermitianLeadSubspace {n : ℕ} {A : Matrix (Fin n) (Fin n) ℝ}
    (hA : A.IsHermitian) (i : Fin n) :
    Submodule ℝ (EuclideanSpace ℝ (Fin n)) :=
  Submodule.span ℝ
    (⇑(hermitianOrderedEigenbasis hA) '' (↑(Finset.Iic i) : Set (Fin n)))

/-- Trailing spectral subspace from rank `i`. -/
def hermitianTrailSubspace {n : ℕ} {A : Matrix (Fin n) (Fin n) ℝ}
    (hA : A.IsHermitian) (i : Fin n) :
    Submodule ℝ (EuclideanSpace ℝ (Fin n)) :=
  Submodule.span ℝ
    (⇑(hermitianOrderedEigenbasis hA) '' (↑(Finset.Ici i) : Set (Fin n)))

private theorem hermitian_repr_eq_zero_of_mem_span {n : ℕ}
    (b : OrthonormalBasis (Fin n) ℝ (EuclideanSpace ℝ (Fin n)))
    (s : Set (Fin n)) {x : EuclideanSpace ℝ (Fin n)}
    (hx : x ∈ Submodule.span ℝ (b '' s)) {j : Fin n} (hj : j ∉ s) :
    b.repr x j = 0 := by
  rw [OrthonormalBasis.repr_apply_apply]
  refine Submodule.span_induction (p := fun y _ => inner ℝ (b j) y = 0) ?_ ?_ ?_ ?_ hx
  · rintro y ⟨l, hl, rfl⟩
    have hjl : j ≠ l := by rintro rfl; exact hj hl
    rw [orthonormal_iff_ite.mp b.orthonormal j l]
    simp [hjl]
  · change inner ℝ (b j) 0 = 0
    rw [inner_zero_right]
  · intro u v _ _ ihu ihv
    rw [inner_add_right, ihu, ihv, add_zero]
  · intro a u _ ih
    rw [inner_smul_right, ih, mul_zero]

private theorem hermitian_sum_repr_sq {n : ℕ}
    (b : OrthonormalBasis (Fin n) ℝ (EuclideanSpace ℝ (Fin n)))
    (x : EuclideanSpace ℝ (Fin n)) :
    ∑ j : Fin n, (b.repr x j) ^ 2 = ‖x‖ ^ 2 := by
  simpa [OrthonormalBasis.repr_apply_apply] using b.sum_sq_inner_right x

/-- Every vector in the leading subspace has Rayleigh form at least the
`i`-th ordered eigenvalue times its squared norm. -/
theorem hermitianOrderedEigenvalue_mul_norm_sq_le_rayleigh_of_mem_lead
    {n : ℕ} {A : Matrix (Fin n) (Fin n) ℝ} (hA : A.IsHermitian)
    (i : Fin n) {x : EuclideanSpace ℝ (Fin n)}
    (hx : x ∈ hermitianLeadSubspace hA i) :
    hermitianOrderedEigenvalue hA i * ‖x‖ ^ 2 ≤ matrixRayleighForm A x := by
  rw [matrixRayleighForm_eq_sum hA]
  let b := hermitianOrderedEigenbasis hA
  have hzero : ∀ j : Fin n, ¬ (j ≤ i) → b.repr x j = 0 := by
    intro j hji
    exact hermitian_repr_eq_zero_of_mem_span b _ hx (by simpa using hji)
  have hterm : ∀ j : Fin n,
      hermitianOrderedEigenvalue hA i * (b.repr x j) ^ 2 ≤
        hermitianOrderedEigenvalue hA j * (b.repr x j) ^ 2 := by
    intro j
    by_cases hji : j ≤ i
    · exact mul_le_mul_of_nonneg_right
        (hermitianOrderedEigenvalue_antitone hA hji) (sq_nonneg _)
    · rw [hzero j hji]
      simp
  calc
    hermitianOrderedEigenvalue hA i * ‖x‖ ^ 2 =
        hermitianOrderedEigenvalue hA i * ∑ j : Fin n, (b.repr x j) ^ 2 := by
      rw [hermitian_sum_repr_sq]
    _ = ∑ j : Fin n,
        hermitianOrderedEigenvalue hA i * (b.repr x j) ^ 2 := by
      rw [Finset.mul_sum]
    _ ≤ ∑ j : Fin n,
        hermitianOrderedEigenvalue hA j * (b.repr x j) ^ 2 :=
      Finset.sum_le_sum (fun j _ => hterm j)

/-- Every vector in the trailing subspace has Rayleigh form at most the
`i`-th ordered eigenvalue times its squared norm. -/
theorem rayleigh_le_hermitianOrderedEigenvalue_mul_norm_sq_of_mem_trail
    {n : ℕ} {A : Matrix (Fin n) (Fin n) ℝ} (hA : A.IsHermitian)
    (i : Fin n) {x : EuclideanSpace ℝ (Fin n)}
    (hx : x ∈ hermitianTrailSubspace hA i) :
    matrixRayleighForm A x ≤ hermitianOrderedEigenvalue hA i * ‖x‖ ^ 2 := by
  rw [matrixRayleighForm_eq_sum hA]
  let b := hermitianOrderedEigenbasis hA
  have hzero : ∀ j : Fin n, ¬ (i ≤ j) → b.repr x j = 0 := by
    intro j hij
    exact hermitian_repr_eq_zero_of_mem_span b _ hx (by simpa using hij)
  have hterm : ∀ j : Fin n,
      hermitianOrderedEigenvalue hA j * (b.repr x j) ^ 2 ≤
        hermitianOrderedEigenvalue hA i * (b.repr x j) ^ 2 := by
    intro j
    by_cases hij : i ≤ j
    · exact mul_le_mul_of_nonneg_right
        (hermitianOrderedEigenvalue_antitone hA hij) (sq_nonneg _)
    · rw [hzero j hij]
      simp
  calc
    ∑ j : Fin n,
        hermitianOrderedEigenvalue hA j * (b.repr x j) ^ 2 ≤
      ∑ j : Fin n,
        hermitianOrderedEigenvalue hA i * (b.repr x j) ^ 2 :=
      Finset.sum_le_sum (fun j _ => hterm j)
    _ = hermitianOrderedEigenvalue hA i *
        ∑ j : Fin n, (b.repr x j) ^ 2 := by
      rw [Finset.mul_sum]
    _ = hermitianOrderedEigenvalue hA i * ‖x‖ ^ 2 := by
      rw [hermitian_sum_repr_sq]

private theorem finrank_span_orthonormalBasis_image_finset {n : ℕ}
    (b : OrthonormalBasis (Fin n) ℝ (EuclideanSpace ℝ (Fin n)))
    (s : Finset (Fin n)) :
    Module.finrank ℝ
        (Submodule.span ℝ (⇑b '' (↑s : Set (Fin n)))) = s.card := by
  classical
  have hli : LinearIndependent ℝ (fun k : {j // j ∈ s} => b (k : Fin n)) :=
    (b.orthonormal.comp (fun k : {j // j ∈ s} => (k : Fin n))
      Subtype.val_injective).linearIndependent
  have hrange : Set.range (fun k : {j // j ∈ s} => b (k : Fin n)) =
      ⇑b '' (↑s : Set (Fin n)) := by
    ext y
    constructor
    · rintro ⟨⟨l, hl⟩, rfl⟩
      exact ⟨l, Finset.mem_coe.mpr hl, rfl⟩
    · rintro ⟨l, hl, rfl⟩
      exact ⟨⟨l, Finset.mem_coe.mp hl⟩, rfl⟩
  rw [← hrange, finrank_span_eq_card hli]
  exact Fintype.card_coe s

theorem finrank_hermitianLeadSubspace {n : ℕ}
    {A : Matrix (Fin n) (Fin n) ℝ} (hA : A.IsHermitian) (i : Fin n) :
    Module.finrank ℝ (hermitianLeadSubspace hA i) = i.val + 1 := by
  rw [hermitianLeadSubspace,
    finrank_span_orthonormalBasis_image_finset, Fin.card_Iic]

theorem finrank_hermitianTrailSubspace {n : ℕ}
    {A : Matrix (Fin n) (Fin n) ℝ} (hA : A.IsHermitian) (i : Fin n) :
    Module.finrank ℝ (hermitianTrailSubspace hA i) = n - i.val := by
  rw [hermitianTrailSubspace,
    finrank_span_orthonormalBasis_image_finset, Fin.card_Ici]

theorem hermitianOrderedEigenbasis_mem_lead {n : ℕ}
    {A : Matrix (Fin n) (Fin n) ℝ} (hA : A.IsHermitian) (i : Fin n) :
    hermitianOrderedEigenbasis hA i ∈ hermitianLeadSubspace hA i := by
  apply Submodule.subset_span
  exact ⟨i, by simp, rfl⟩

theorem norm_hermitianOrderedEigenbasis {n : ℕ}
    {A : Matrix (Fin n) (Fin n) ℝ} (hA : A.IsHermitian) (i : Fin n) :
    ‖hermitianOrderedEigenbasis hA i‖ = 1 :=
  (hermitianOrderedEigenbasis hA).orthonormal.1 i

theorem matrixRayleighForm_hermitianOrderedEigenbasis {n : ℕ}
    {A : Matrix (Fin n) (Fin n) ℝ} (hA : A.IsHermitian) (i : Fin n) :
    matrixRayleighForm A (hermitianOrderedEigenbasis hA i) =
      hermitianOrderedEigenvalue hA i := by
  rw [matrixRayleighForm, hermitianOrderedEigenbasis_apply hA i,
    inner_smul_right, inner_self_eq_norm_sq_to_K,
    norm_hermitianOrderedEigenbasis hA i]
  simp

/-- Witness-form statement that `value i` is the maximum, over subspaces of
dimension `i+1`, of the minimum unit Rayleigh value on that subspace. -/
def IsCourantFischerMaxMin {n : ℕ}
    (A : Matrix (Fin n) (Fin n) ℝ) (value : Fin n → ℝ) (i : Fin n) : Prop :=
  ∃ E : Submodule ℝ (EuclideanSpace ℝ (Fin n)),
    Module.finrank ℝ E = i.val + 1 ∧
    (∀ x, x ∈ E → ‖x‖ = 1 → value i ≤ matrixRayleighForm A x) ∧
    (∃ x, x ∈ E ∧ ‖x‖ = 1 ∧ matrixRayleighForm A x = value i) ∧
    (∀ F : Submodule ℝ (EuclideanSpace ℝ (Fin n)),
      Module.finrank ℝ F = i.val + 1 →
        ∃ x, x ∈ F ∧ ‖x‖ = 1 ∧ matrixRayleighForm A x ≤ value i)

/-- Courant--Fischer max--min theorem for every ordered eigenvalue of a finite
real symmetric matrix. -/
theorem hermitian_courantFischer_maxMin {n : ℕ}
    (A : Matrix (Fin n) (Fin n) ℝ) (hA : A.IsHermitian) (i : Fin n) :
    IsCourantFischerMaxMin A (hermitianOrderedEigenvalue hA) i := by
  let b := hermitianOrderedEigenbasis hA
  refine ⟨hermitianLeadSubspace hA i,
    finrank_hermitianLeadSubspace hA i, ?_, ?_, ?_⟩
  · intro x hx hnorm
    have h := hermitianOrderedEigenvalue_mul_norm_sq_le_rayleigh_of_mem_lead
      hA i hx
    simpa [hnorm] using h
  · refine ⟨b i, ?_, ?_, ?_⟩
    · exact hermitianOrderedEigenbasis_mem_lead hA i
    · exact norm_hermitianOrderedEigenbasis hA i
    · exact matrixRayleighForm_hermitianOrderedEigenbasis hA i
  · intro E hE
    let W := hermitianTrailSubspace hA i
    have hW : Module.finrank ℝ W = n - i.val :=
      finrank_hermitianTrailSubspace hA i
    have hdim : Module.finrank ℝ (EuclideanSpace ℝ (Fin n)) <
        Module.finrank ℝ E + Module.finrank ℝ W := by
      rw [finrank_euclideanSpace_fin, hE, hW]
      have hi := i.isLt
      omega
    have hinf : E ⊓ W ≠ ⊥ := by
      intro hinf
      have hdisjoint : Disjoint E W := by
        rw [disjoint_iff_inf_le, hinf]
      have hle := Submodule.finrank_add_finrank_le_of_disjoint hdisjoint
      exact (not_le_of_gt hdim) hle
    obtain ⟨x, hxinf, hx0⟩ := Submodule.exists_mem_ne_zero_of_ne_bot hinf
    let y : EuclideanSpace ℝ (Fin n) := ‖x‖⁻¹ • x
    have hxE : x ∈ E := hxinf.1
    have hxW : x ∈ W := hxinf.2
    have hyE : y ∈ E := E.smul_mem _ hxE
    have hyW : y ∈ W := W.smul_mem _ hxW
    have hynorm : ‖y‖ = 1 := by
      exact norm_smul_inv_norm hx0
    refine ⟨y, hyE, hynorm, ?_⟩
    have h := rayleigh_le_hermitianOrderedEigenvalue_mul_norm_sq_of_mem_trail
      hA i hyW
    simpa [hynorm] using h

end

end NumStability
