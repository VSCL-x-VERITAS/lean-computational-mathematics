/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Source.Bhatia.Chapter01.NumericalRangeNormalTarget
import ComputationalMathematics.Source.Bhatia.Chapter01.NumericalRangeBasic
import ComputationalMathematics.Analysis.InnerProductSpace.LinearMap.NumericalRangeConvexity
import Mathlib.LinearAlgebra.Eigenspace.Triangularizable
import Mathlib.Analysis.Complex.Polynomial.Basic

/-!
# Bhatia Chapter I: numerical ranges of normal and Hermitian operators

Exercise I.2.9, printed page 8. For a normal operator `A`, `‖A* v‖ = ‖A v‖`,
and the same holds for every shift `A - μ I`. Hence an eigenvector of `A` for
`μ` is an eigenvector of `A*` for `conj μ`, eigenvectors for distinct
eigenvalues are orthogonal, and `ker (A - μ)² = ker (A - μ)`, so generalized
eigenspaces are eigenspaces and the eigenspaces span the space.

Write a unit vector in the span of some eigenspaces as `x = ∑ μ, x_μ` with
`A x_μ = μ x_μ`, indexed by distinct eigenvalues. Orthogonality gives
`⟨x, A x⟩ = ∑ μ, ‖x_μ‖² μ` and `∑ μ, ‖x_μ‖² = 1`, a convex combination of the
eigenvalues whose components are nonzero. This is part (ii), and with the
spanning result it gives `W(A) ⊆ conv σ(A)`. The reverse inclusion uses that
eigenvalues lie in `W(A)` and that `W(A)` is convex (Toeplitz–Hausdorff). For
Hermitian `A` the eigenvalues are real numbers in `[a, b]`, and the hull of a
set containing `a` and `b` inside the real interval is that interval.
-/

set_option autoImplicit false
universe u

namespace NumStability.Bhatia.Chapter01

variable {H : Type u} [NormedAddCommGroup H] [InnerProductSpace ℂ H]

/-- A normal operator satisfies `‖A* v‖ = ‖A v‖`. -/
private lemma norm_adjoint_apply_eq [FiniteDimensional ℂ H] {A : H →ₗ[ℂ] H}
    (hA : A.comp (LinearMap.adjoint A) = (LinearMap.adjoint A).comp A) (v : H) :
    ‖LinearMap.adjoint A v‖ = ‖A v‖ := by
  have h : inner ℂ (LinearMap.adjoint A v) (LinearMap.adjoint A v) = inner ℂ (A v) (A v) := by
    rw [LinearMap.adjoint_inner_right, ← LinearMap.adjoint_inner_left, ← LinearMap.comp_apply A,
      hA, LinearMap.comp_apply]
  rw [@norm_eq_sqrt_re_inner ℂ, @norm_eq_sqrt_re_inner ℂ, h]

/-- The adjoint of a shift `A - μ I` is `A* - conj μ I`. -/
private lemma adjoint_sub_smul_id [FiniteDimensional ℂ H] (A : H →ₗ[ℂ] H) (μ : ℂ) :
    LinearMap.adjoint (A - μ • LinearMap.id) =
      LinearMap.adjoint A - starRingEnd ℂ μ • LinearMap.id := by
  rw [map_sub, LinearMap.adjoint.map_smulₛₗ, LinearMap.adjoint_id]

/-- Every shift `A - μ I` of a normal operator is normal. -/
private lemma normal_sub_smul_id [FiniteDimensional ℂ H] {A : H →ₗ[ℂ] H}
    (hA : A.comp (LinearMap.adjoint A) = (LinearMap.adjoint A).comp A) (μ : ℂ) :
    (A - μ • LinearMap.id).comp (LinearMap.adjoint (A - μ • LinearMap.id)) =
      (LinearMap.adjoint (A - μ • LinearMap.id)).comp (A - μ • LinearMap.id) := by
  rw [adjoint_sub_smul_id]
  refine LinearMap.ext fun v => ?_
  have h := LinearMap.congr_fun hA v
  simp only [LinearMap.comp_apply] at h
  simp only [LinearMap.comp_apply, LinearMap.sub_apply, LinearMap.smul_apply, LinearMap.id_apply,
    map_sub, map_smul, h]
  module

/-- An eigenvector of a normal operator for `μ` is an eigenvector of its adjoint for
`conj μ`. -/
private lemma adjoint_apply_of_eigen [FiniteDimensional ℂ H] {A : H →ₗ[ℂ] H}
    (hA : A.comp (LinearMap.adjoint A) = (LinearMap.adjoint A).comp A) {μ : ℂ} {v : H}
    (hv : A v = μ • v) : LinearMap.adjoint A v = starRingEnd ℂ μ • v := by
  have h := norm_adjoint_apply_eq (normal_sub_smul_id hA μ) v
  rw [adjoint_sub_smul_id] at h
  simp only [LinearMap.sub_apply, LinearMap.smul_apply, LinearMap.id_apply, hv, sub_self,
    norm_zero, norm_eq_zero] at h
  exact sub_eq_zero.1 h

/-- Eigenvectors of a normal operator for distinct eigenvalues are orthogonal. -/
private lemma inner_eq_zero_of_eigen [FiniteDimensional ℂ H] {A : H →ₗ[ℂ] H}
    (hA : A.comp (LinearMap.adjoint A) = (LinearMap.adjoint A).comp A) {μ ν : ℂ} {v w : H}
    (hv : A v = μ • v) (hw : A w = ν • w) (hne : μ ≠ ν) : inner ℂ v w = 0 := by
  have h1 : inner ℂ v (A w) = ν * inner ℂ v w := by rw [hw, inner_smul_right]
  have h2 : inner ℂ v (A w) = μ * inner ℂ v w := by
    rw [← LinearMap.adjoint_inner_left, adjoint_apply_of_eigen hA hv, inner_smul_left]
    simp
  have h3 : (μ - ν) * inner ℂ v w = 0 := by rw [sub_mul, ← h2, ← h1, sub_self]
  exact (mul_eq_zero.1 h3).resolve_left (sub_ne_zero.2 hne)

/-- A normal operator has `ker B² ⊆ ker B`. -/
private lemma eq_zero_of_apply_apply_eq_zero [FiniteDimensional ℂ H] {B : H →ₗ[ℂ] H}
    (hB : B.comp (LinearMap.adjoint B) = (LinearMap.adjoint B).comp B) {v : H}
    (h : B (B v) = 0) : B v = 0 := by
  have h1 : LinearMap.adjoint B (B v) = 0 := by
    rw [← norm_eq_zero, norm_adjoint_apply_eq hB, h, norm_zero]
  have h2 : inner ℂ (B v) (B v) = 0 := by
    rw [← LinearMap.adjoint_inner_left, h1, inner_zero_left]
  exact inner_self_eq_zero.1 h2

/-- A normal operator has `ker B^(k+1) ⊆ ker B`. -/
private lemma eq_zero_of_pow_apply_eq_zero [FiniteDimensional ℂ H] {B : H →ₗ[ℂ] H}
    (hB : B.comp (LinearMap.adjoint B) = (LinearMap.adjoint B).comp B) :
    ∀ (k : ℕ) (v : H), (B ^ (k + 1)) v = 0 → B v = 0 := by
  intro k
  induction k with
  | zero => intro v h; simpa using h
  | succ k ih =>
    intro v h
    rw [pow_succ, Module.End.mul_apply] at h
    exact eq_zero_of_apply_apply_eq_zero hB (ih (B v) h)

/-- The eigenspaces of a normal operator on a finite-dimensional complex inner
product space span the space. -/
private lemma iSup_eigenspace_eq_top [FiniteDimensional ℂ H] {A : H →ₗ[ℂ] H}
    (hA : A.comp (LinearMap.adjoint A) = (LinearMap.adjoint A).comp A) :
    ⨆ μ : ℂ, Module.End.eigenspace A μ = ⊤ := by
  rw [← Module.End.iSup_maxGenEigenspace_eq_top A]
  refine iSup_congr fun μ => le_antisymm ?_ ?_
  · intro v hv
    refine (Module.End.mem_maxGenEigenspace A μ v).2 ⟨1, ?_⟩
    rw [Module.End.mem_eigenspace_iff] at hv
    simp [hv]
  · intro v hv
    obtain ⟨k, hk⟩ := (Module.End.mem_maxGenEigenspace A μ v).1 hv
    rw [Module.End.mem_eigenspace_iff]
    cases k with
    | zero => simp only [pow_zero, Module.End.one_apply] at hk; simp [hk]
    | succ k =>
      have hB := eq_zero_of_pow_apply_eq_zero (normal_sub_smul_id hA μ) k v
        (by simpa [Module.End.one_eq_id] using hk)
      simpa [sub_eq_zero] using hB

/-- Core computation: a unit vector that is a finite sum of eigenvectors of a normal
operator, with eigenvalue labels, has `⟨x, A x⟩` in the real convex hull of every set
containing the labels of the nonzero summands. -/
private lemma inner_mem_convexHull_of_finsupp [FiniteDimensional ℂ H] {A : H →ₗ[ℂ] H}
    (hA : A.comp (LinearMap.adjoint A) = (LinearMap.adjoint A).comp A) (s : Set ℂ)
    (f : ℂ →₀ H) (hf : ∀ μ, A (f μ) = μ • f μ) (hs : ∀ μ, f μ ≠ 0 → μ ∈ s) {x : H}
    (hx : (f.sum fun _ v => v) = x) (hx1 : ‖x‖ = 1) :
    inner ℂ x (A x) ∈ convexHull ℝ s := by
  classical
  have hxs : x = ∑ μ ∈ f.support, f μ := hx.symm
  have hdiag : ∀ μ ∈ f.support, ∀ c : ℂ → ℂ,
      ∑ ν ∈ f.support, inner ℂ (f μ) (c ν • f ν) = c μ * ((‖f μ‖ ^ 2 : ℝ) : ℂ) := by
    intro μ hμ c
    rw [Finset.sum_eq_single μ]
    · rw [inner_smul_right, inner_self_eq_norm_sq_to_K]; norm_cast
    · intro ν _ hνμ
      rw [inner_smul_right, inner_eq_zero_of_eigen hA (hf μ) (hf ν) (Ne.symm hνμ), mul_zero]
    · intro h; exact absurd hμ h
  have hval : inner ℂ x (A x) = ∑ μ ∈ f.support, ((‖f μ‖ ^ 2 : ℝ) : ℂ) * μ := by
    rw [hxs, map_sum, sum_inner]
    refine Finset.sum_congr rfl fun μ hμ => ?_
    rw [inner_sum]
    simp_rw [hf]
    rw [hdiag μ hμ (fun ν => ν), mul_comm]
  have hone : ∑ μ ∈ f.support, ‖f μ‖ ^ 2 = (1 : ℝ) := by
    have h : inner ℂ x x = ∑ μ ∈ f.support, ((‖f μ‖ ^ 2 : ℝ) : ℂ) := by
      conv_lhs => rw [hxs]
      rw [sum_inner]
      refine Finset.sum_congr rfl fun μ hμ => ?_
      rw [inner_sum]
      have := hdiag μ hμ (fun _ => 1)
      simp only [one_smul, one_mul] at this
      exact this
    rw [inner_self_eq_norm_sq_to_K, hx1] at h
    have h' : ((∑ μ ∈ f.support, ‖f μ‖ ^ 2 : ℝ) : ℂ) = 1 := by
      push_cast at h ⊢; rw [← h]; simp
    exact_mod_cast h'
  rw [hval]
  simp_rw [← Complex.real_smul]
  exact (convex_convexHull ℝ s).sum_mem (fun μ _ => sq_nonneg _) hone
    (fun μ hμ => subset_convexHull ℝ s (hs μ (Finsupp.mem_support_iff.1 hμ)))

/-- Exercise I.2.9(i): for normal `A`, `W(A)` is the convex hull of the eigenvalues
of `A`. -/
theorem numericalRangeNormalEqConvexHull : Targets.numericalRangeNormalEqConvexHull.{u} := by
  intro H _ _ _ A hA
  refine Set.Subset.antisymm ?_ ?_
  · rintro z ⟨x, hx, rfl⟩
    have hmem : x ∈ ⨆ μ : ℂ, Module.End.eigenspace A μ := by
      rw [iSup_eigenspace_eq_top hA]; trivial
    obtain ⟨f, hf, hsum⟩ := (Submodule.mem_iSup_iff_exists_finsupp _ x).1 hmem
    exact inner_mem_convexHull_of_finsupp hA {lam : ℂ | ∃ v : H, v ≠ 0 ∧ A v = lam • v} f
      (fun μ => Module.End.mem_eigenspace_iff.1 (hf μ))
      (fun μ h => ⟨f μ, h, Module.End.mem_eigenspace_iff.1 (hf μ)⟩) hsum hx
  · exact convexHull_min (fun lam hlam => eigenvalueMemNumericalRange H A lam hlam)
      (NumStability.convex_numerical_range A)

/-- Exercise I.2.9(i): for Hermitian `A` whose eigenvalues are real numbers in `[a, b]`,
with `a` and `b` themselves eigenvalues, `W(A)` is the real interval `[a, b]`. -/
theorem numericalRangeHermitianInterval : Targets.numericalRangeHermitianInterval.{u} := by
  intro H _ _ _ A a b hA ha hb hall
  have hN : A.comp (LinearMap.adjoint A) = (LinearMap.adjoint A).comp A := by rw [← hA]
  rw [numericalRangeNormalEqConvexHull H A hN]
  refine Set.Subset.antisymm ?_ ?_
  · have hconv : Convex ℝ ((fun t : ℝ => (t : ℂ)) '' Set.Icc a b) :=
      (convex_Icc a b).linear_image Complex.ofRealCLM.toLinearMap
    refine convexHull_min ?_ hconv
    intro lam hlam
    obtain ⟨t, ht, hat, htb⟩ := hall lam hlam
    exact ⟨t, ⟨hat, htb⟩, ht.symm⟩
  · rintro z ⟨t, ⟨hat, htb⟩, rfl⟩
    have ht : t ∈ segment ℝ a b := by rw [segment_eq_Icc (hat.trans htb)]; exact ⟨hat, htb⟩
    obtain ⟨p, q, hp, hq, hpq, hpqt⟩ := ht
    have hseg : (t : ℂ) ∈ segment ℝ (a : ℂ) (b : ℂ) :=
      ⟨p, q, hp, hq, hpq, by rw [← hpqt]; simp [Complex.real_smul]⟩
    let S : Set ℂ := {lam : ℂ | ∃ v : H, v ≠ 0 ∧ A v = lam • v}
    have ha' : (a : ℂ) ∈ S := ha
    have hb' : (b : ℂ) ∈ S := hb
    exact segment_subset_convexHull ha' hb' hseg

/-- Exercise I.2.9(ii): a unit vector in the span of eigenspaces of a normal operator
for `λ₁, …, λₖ` has `⟨x, A x⟩` in the convex hull of `λ₁, …, λₖ`. -/
theorem normalEigenspanInnerMemConvexHull :
    Targets.normalEigenspanInnerMemConvexHull.{u} := by
  intro H _ _ _ A k lam x hA _ hx hmem
  have hle : (⨆ j, LinearMap.ker (A - lam j • LinearMap.id)) ≤
      ⨆ μ : ℂ, ⨆ (_ : μ ∈ Set.range lam), Module.End.eigenspace A μ := by
    refine iSup_le fun j => ?_
    refine le_trans ?_ (le_iSup_of_le (lam j) (le_iSup_of_le ⟨j, rfl⟩ le_rfl))
    intro v hv
    rw [LinearMap.mem_ker, LinearMap.sub_apply, LinearMap.smul_apply, LinearMap.id_apply,
      sub_eq_zero] at hv
    exact Module.End.mem_eigenspace_iff.2 hv
  obtain ⟨f, hf, hsum⟩ := (Submodule.mem_iSup_iff_exists_finsupp _ x).1 (hle hmem)
  have hf' : ∀ μ, f μ ∈ Module.End.eigenspace A μ ∧ (f μ ≠ 0 → μ ∈ Set.range lam) := by
    intro μ
    have h := hf μ
    by_cases hμ : μ ∈ Set.range lam
    · rw [iSup_pos hμ] at h; exact ⟨h, fun _ => hμ⟩
    · rw [iSup_neg hμ, Submodule.mem_bot] at h
      exact ⟨by rw [h]; exact Submodule.zero_mem _, fun h' => absurd h h'⟩
  exact inner_mem_convexHull_of_finsupp hA _ f
    (fun μ => Module.End.mem_eigenspace_iff.1 (hf' μ).1) (fun μ => (hf' μ).2) hsum hx

end NumStability.Bhatia.Chapter01
