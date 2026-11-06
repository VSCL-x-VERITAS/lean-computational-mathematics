/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.LinearAlgebra.PiTensorProduct.Basis

/-!
# Product inner products on finite tensor products

Finite orthonormal bases give coordinates on the actual `PiTensorProduct`
quotient. Their Euclidean inner product is independent of the bases and has
the product rule on pure tensors. In finite dimension this supplies named
Hilbert structures, without registering a competing global norm instance.

The named structures must be selected locally, including the seminormed-group
superclass when another imported module supplies that class directly. In
particular, the norm from `PiTensorProduct.InjectiveSeminorm` is a separate
construction and is not used here. Empty families have the scalar inner
product; singleton families retain the original inner product. No positive
dimension is required.
-/

set_option autoImplicit false

noncomputable section

open scoped BigOperators ComplexConjugate

namespace PiTensorProduct

variable {ι : Type*} [Fintype ι] {M : ι → Type*}
  [∀ i, NormedAddCommGroup (M i)] [∀ i, InnerProductSpace ℂ (M i)]

local instance : DecidableEq ι := Classical.decEq _

section Coordinates

variable {κ : ι → Type*} [∀ i, Fintype (κ i)]

/-- Coordinates in the tensor basis of finite orthonormal bases. The domain
is the existing multilinearity quotient, with its existing linear structure. -/
def orthonormalCoordinates (e : ∀ i, OrthonormalBasis (κ i) ℂ (M i)) :
    PiTensorProduct ℂ M ≃ₗ[ℂ] EuclideanSpace ℂ (∀ i, κ i) :=
  (Basis.piTensorProduct (fun i => (e i).toBasis)).equivFun.trans
    (WithLp.linearEquiv 2 ℂ ((∀ i, κ i) → ℂ)).symm

@[simp]
theorem orthonormalCoordinates_tprod_apply
    (e : ∀ i, OrthonormalBasis (κ i) ℂ (M i)) (u : ∀ i, M i) (p : ∀ i, κ i) :
    orthonormalCoordinates e (tprod ℂ u) p = ∏ i, (e i).repr (u i) (p i) := by
  simp [orthonormalCoordinates, Module.Basis.equivFun_apply,
    Basis.piTensorProduct_repr_tprod_apply]

/-- The Euclidean coordinate inner product of pure tensors is the product
of the inner products of their factors. -/
theorem orthonormalCoordinates_inner_tprod
    (e : ∀ i, OrthonormalBasis (κ i) ℂ (M i)) (u v : ∀ i, M i) :
    inner ℂ (orthonormalCoordinates e (tprod ℂ u))
        (orthonormalCoordinates e (tprod ℂ v)) = ∏ i, inner ℂ (u i) (v i) := by
  classical
  rw [PiLp.inner_apply]
  simp_rw [RCLike.inner_apply, orthonormalCoordinates_tprod_apply,
    map_prod, ← Finset.prod_mul_distrib]
  rw [← Fintype.prod_sum (fun i j =>
    (e i).repr (v i) j * conj ((e i).repr (u i) j))]
  apply Finset.prod_congr rfl
  intro i _
  exact (e i).repr.inner_map_map (u i) (v i)

/-- The scalar form obtained from tensor coordinates, before choosing any
normed structure on the tensor quotient. -/
def innerWithBasis (e : ∀ i, OrthonormalBasis (κ i) ℂ (M i))
    (x y : PiTensorProduct ℂ M) : ℂ :=
  inner ℂ (orthonormalCoordinates e x) (orthonormalCoordinates e y)

@[simp]
theorem innerWithBasis_tprod (e : ∀ i, OrthonormalBasis (κ i) ℂ (M i))
    (u v : ∀ i, M i) :
    innerWithBasis e (tprod ℂ u) (tprod ℂ v) = ∏ i, inner ℂ (u i) (v i) :=
  orthonormalCoordinates_inner_tprod e u v

theorem innerWithBasis_add_left (e : ∀ i, OrthonormalBasis (κ i) ℂ (M i))
    (x y z : PiTensorProduct ℂ M) :
    innerWithBasis e (x + y) z = innerWithBasis e x z + innerWithBasis e y z := by
  simp [innerWithBasis, inner_add_left]

theorem innerWithBasis_add_right (e : ∀ i, OrthonormalBasis (κ i) ℂ (M i))
    (x y z : PiTensorProduct ℂ M) :
    innerWithBasis e x (y + z) = innerWithBasis e x y + innerWithBasis e x z := by
  simp [innerWithBasis, inner_add_right]

theorem innerWithBasis_smul_left (e : ∀ i, OrthonormalBasis (κ i) ℂ (M i))
    (r : ℂ) (x y : PiTensorProduct ℂ M) :
    innerWithBasis e (r • x) y = conj r * innerWithBasis e x y := by
  simp [innerWithBasis, inner_smul_left]

theorem innerWithBasis_smul_right (e : ∀ i, OrthonormalBasis (κ i) ℂ (M i))
    (r : ℂ) (x y : PiTensorProduct ℂ M) :
    innerWithBasis e x (r • y) = r * innerWithBasis e x y := by
  simp [innerWithBasis, inner_smul_right]

/-- Independence of all choices of finite orthonormal bases, on all tensor
values. The two bases may even have different coordinate index types. -/
theorem innerWithBasis_independent {κ' : ι → Type*} [∀ i, Fintype (κ' i)]
    (e : ∀ i, OrthonormalBasis (κ i) ℂ (M i))
    (f : ∀ i, OrthonormalBasis (κ' i) ℂ (M i)) (x y : PiTensorProduct ℂ M) :
    innerWithBasis e x y = innerWithBasis f x y := by
  refine PiTensorProduct.induction_on x ?_ ?_
  · intro r u
    refine PiTensorProduct.induction_on y ?_ ?_
    · intro s v
      simp only [innerWithBasis_smul_left, innerWithBasis_smul_right, innerWithBasis_tprod]
    · intro y z hy hz
      simp only [innerWithBasis_add_right, hy, hz]
  · intro x z hx hz
    simp only [innerWithBasis_add_left, hx, hz]

end Coordinates

omit [Fintype ι] in
/-- A zero factor makes the actual tensor quotient zero, without any
positive-dimension or nontriviality assumption on the other factors. -/
theorem eq_zero_of_subsingleton_factor (i : ι) [Subsingleton (M i)]
    (x : PiTensorProduct ℂ M) : x = 0 := by
  refine PiTensorProduct.induction_on x ?_ ?_
  · intro r u
    rw [(tprod ℂ).map_coord_zero i (Subsingleton.elim (u i) 0), smul_zero]
  · intro x y hx hy
    rw [hx, hy, add_zero]

variable [∀ i, FiniteDimensional ℂ (M i)]

/-- The canonical product scalar form, using an internal orthonormal basis
only to construct it. `productInner_eq_innerWithBasis` removes that choice. -/
def productInner (x y : PiTensorProduct ℂ M) : ℂ :=
  innerWithBasis (fun i => stdOrthonormalBasis ℂ (M i)) x y

theorem productInner_eq_innerWithBasis {κ : ι → Type*} [∀ i, Fintype (κ i)]
    (e : ∀ i, OrthonormalBasis (κ i) ℂ (M i)) (x y : PiTensorProduct ℂ M) :
    productInner x y = innerWithBasis e x y :=
  innerWithBasis_independent _ e x y

@[simp]
theorem productInner_tprod (u v : ∀ i, M i) :
    productInner (tprod ℂ u) (tprod ℂ v) = ∏ i, inner ℂ (u i) (v i) :=
  innerWithBasis_tprod _ u v

/-- The definite inner-product core on the existing tensor quotient. -/
def productInnerCore : InnerProductSpace.Core ℂ (PiTensorProduct ℂ M) where
  inner := productInner
  conj_inner_symm x y := inner_conj_symm _ _
  re_inner_nonneg x := inner_self_nonneg
  add_left x y z := innerWithBasis_add_left _ x y z
  smul_left x y r := innerWithBasis_smul_left _ r x y
  definite x hx := by
    apply (orthonormalCoordinates (fun i => stdOrthonormalBasis ℂ (M i))).injective
    change inner ℂ (orthonormalCoordinates (fun i => stdOrthonormalBasis ℂ (M i)) x)
      (orthonormalCoordinates (fun i => stdOrthonormalBasis ℂ (M i)) x) = 0 at hx
    simpa using (inner_self_eq_zero.mp hx)

/-- The Hilbert norm on the actual tensor quotient. Select this named
structure locally; it is not a global typeclass instance. -/
def productNormedAddCommGroup : NormedAddCommGroup (PiTensorProduct ℂ M) :=
  (productInnerCore (M := M)).toNormedAddCommGroup

/-- The matching seminormed superclass. Select it explicitly when an import
also supplies a direct seminormed structure on `PiTensorProduct`. -/
def productSeminormedAddCommGroup : SeminormedAddCommGroup (PiTensorProduct ℂ M) :=
  (productNormedAddCommGroup (M := M)).toSeminormedAddCommGroup

/-- The product inner-product structure, relative to the explicitly selected
product norm. This also is a named structure, not a global instance. -/
def productInnerProductSpace :
    letI := productNormedAddCommGroup (M := M)
    letI := productSeminormedAddCommGroup (M := M)
    InnerProductSpace ℂ (PiTensorProduct ℂ M) :=
  letI := productNormedAddCommGroup (M := M)
  letI := productSeminormedAddCommGroup (M := M)
  InnerProductSpace.ofCore
    (@instCoreOfCore ℂ (PiTensorProduct ℂ M) _ _ _ (productInnerCore (M := M)))

/-- The matching normed-space superclass, named to make local structure
selection independent of other imported normed-tensor constructions. -/
def productNormedSpace :
    letI := productNormedAddCommGroup (M := M)
    letI := productSeminormedAddCommGroup (M := M)
    NormedSpace ℂ (PiTensorProduct ℂ M) :=
  letI := productNormedAddCommGroup (M := M)
  letI := productSeminormedAddCommGroup (M := M)
  (productInnerProductSpace (M := M)).toNormedSpace

/-- The named Hilbert structures preserve the original quotient addition
and complex module, rather than replacing the algebraic carrier. -/
theorem productStructures_algebra :
    let g := (inferInstance : AddCommGroup (PiTensorProduct ℂ M))
    let m := (inferInstance : Module ℂ (PiTensorProduct ℂ M))
    letI := productNormedAddCommGroup (M := M)
    letI := productSeminormedAddCommGroup (M := M)
    letI := productInnerProductSpace (M := M)
    letI := productNormedSpace (M := M)
    (inferInstance : NormedAddCommGroup (PiTensorProduct ℂ M)).toAddCommGroup = g ∧
      (inferInstance : NormedSpace ℂ (PiTensorProduct ℂ M)).toModule = m :=
  ⟨rfl, rfl⟩

section Hilbert

local instance : NormedAddCommGroup (PiTensorProduct ℂ M) := productNormedAddCommGroup
local instance : SeminormedAddCommGroup (PiTensorProduct ℂ M) := productSeminormedAddCommGroup
local instance : InnerProductSpace ℂ (PiTensorProduct ℂ M) := productInnerProductSpace
local instance : NormedSpace ℂ (PiTensorProduct ℂ M) := productNormedSpace

theorem inner_eq_productInner (x y : PiTensorProduct ℂ M) :
    inner ℂ x y = productInner x y := rfl

@[simp]
theorem inner_tprod (u v : ∀ i, M i) :
    inner ℂ (tprod ℂ u) (tprod ℂ v) = ∏ i, inner ℂ (u i) (v i) :=
  productInner_tprod u v

/-- Any finite orthonormal tensor coordinates are an isometry for the
canonical product Hilbert structures. -/
def orthonormalCoordinatesIsometry {κ : ι → Type*} [∀ i, Fintype (κ i)]
    (e : ∀ i, OrthonormalBasis (κ i) ℂ (M i)) :
    PiTensorProduct ℂ M ≃ₗᵢ[ℂ] EuclideanSpace ℂ (∀ i, κ i) :=
  (orthonormalCoordinates e).isometryOfInner fun x y =>
    (productInner_eq_innerWithBasis e x y).symm

/-- Completeness transported along the constructed Euclidean coordinate
isometry. This is named explicitly, like the associated norm and inner product. -/
theorem productCompleteSpace : CompleteSpace (PiTensorProduct ℂ M) :=
  (orthonormalCoordinatesIsometry
    (fun i => stdOrthonormalBasis ℂ (M i))).toIsometryEquiv.completeSpace

set_option backward.isDefEq.respectTransparency false in
/-- For one factor the product inner product is the original one. -/
theorem inner_subsingletonEquiv [Subsingleton ι] (i₀ : ι) (x y : PiTensorProduct ℂ M) :
    inner ℂ (subsingletonEquiv i₀ x) (subsingletonEquiv i₀ y) = inner ℂ x y := by
  letI : Unique ι := uniqueOfSubsingleton i₀
  refine PiTensorProduct.induction_on x ?_ ?_
  · intro r u
    refine PiTensorProduct.induction_on y ?_ ?_
    · intro s v
      simp [inner_smul_left, inner_smul_right, Subsingleton.elim (default : ι) i₀]
    · intro y z hy hz
      simpa only [map_add, inner_add_right] using congrArg₂ (· + ·) hy hz
  · intro x z hx hz
    simpa only [map_add, inner_add_left] using congrArg₂ (· + ·) hx hz

/-- The canonical one-factor identification is an actual Hilbert isometry. -/
def subsingletonIsometry [Subsingleton ι] (i₀ : ι) :
    PiTensorProduct ℂ M ≃ₗᵢ[ℂ] M i₀ :=
  (subsingletonEquiv i₀).isometryOfInner (inner_subsingletonEquiv i₀)

set_option backward.isDefEq.respectTransparency false in
/-- The empty-family tensor product has the scalar inner product. This is
infrastructure coherence, not a claim about a positive-arity source convention. -/
theorem inner_isEmptyEquiv [IsEmpty ι] (x y : PiTensorProduct ℂ M) :
    inner ℂ (isEmptyEquiv ι x) (isEmptyEquiv ι y) = inner ℂ x y := by
  refine PiTensorProduct.induction_on x ?_ ?_
  · intro r u
    refine PiTensorProduct.induction_on y ?_ ?_
    · intro s v
      simp [inner_smul_left, inner_smul_right]
    · intro y z hy hz
      simpa only [map_add, inner_add_right] using congrArg₂ (· + ·) hy hz
  · intro x z hx hz
    simpa only [map_add, inner_add_left] using congrArg₂ (· + ·) hx hz

/-- The internal empty-family tensor product is isometric to the scalars. -/
def isEmptyIsometry [IsEmpty ι] : PiTensorProduct ℂ M ≃ₗᵢ[ℂ] ℂ :=
  (isEmptyEquiv ι).isometryOfInner inner_isEmptyEquiv

end Hilbert

end PiTensorProduct
