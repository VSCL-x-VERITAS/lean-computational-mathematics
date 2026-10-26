-- Analysis/LinearOperators/Basic.lean
--
-- Basic finite complex-linear operator infrastructure.

import Mathlib.Algebra.Module.LinearMap.Defs
import ComputationalMathematics.Analysis.VectorNorms.Basic

/-!
# Finite complex-linear operator infrastructure

Defines the finite complex-vector map interfaces and linear-map bridges used
by subordinate operator and matrix norms.

The source-facing names below forward to Mathlib's linearity predicate and
standard function operations. Their existing names and interfaces remain
supported; no compatibility-wrapper removal is scheduled.
-/

namespace NumStability

open scoped BigOperators
open scoped ComplexOrder
open ENNReal


/-- A linear-map-shaped object from `C^n` to `C^m`.  This keeps Chapter 6's
    mixed subordinate norm infrastructure independent of a concrete matrix
    representation until the matrix API is fixed. -/
abbrev ComplexVectorMap (n m : ℕ) := CVec n → CVec m

/-- Mathlib linearity under the legacy source-facing name. -/
abbrev IsComplexVectorMapLinear {n m : ℕ} (T : ComplexVectorMap n m) : Prop :=
  IsLinearMap ℂ T

namespace IsComplexVectorMapLinear

/-- Compatibility constructor forwarding to `IsLinearMap.mk`. -/
@[match_pattern]
abbrev mk {n m : ℕ} {T : ComplexVectorMap n m}
    (map_add : ∀ x y : CVec n,
      T (complexVecAdd x y) = complexVecAdd (T x) (T y))
    (map_smul : ∀ (a : ℂ) (x : CVec n),
      T (complexVecSMul a x) = complexVecSMul a (T x)) :
    IsComplexVectorMapLinear T :=
  IsLinearMap.mk map_add map_smul

/-- Retain the former generated constructor spelling as a forwarding alias. -/
abbrev mk._flat_ctor {n m : ℕ} {T : ComplexVectorMap n m}
    (map_add : ∀ x y : CVec n,
      T (complexVecAdd x y) = complexVecAdd (T x) (T y))
    (map_smul : ∀ (a : ℂ) (x : CVec n),
      T (complexVecSMul a x) = complexVecSMul a (T x)) :
    IsComplexVectorMapLinear T :=
  IsComplexVectorMapLinear.mk map_add map_smul

/-- Compatibility projection forwarding to `IsLinearMap.map_add`. -/
abbrev map_add {n m : ℕ} {T : ComplexVectorMap n m}
    (self : IsComplexVectorMapLinear T) (x y : CVec n) :
    T (complexVecAdd x y) = complexVecAdd (T x) (T y) :=
  IsLinearMap.map_add self x y

/-- Compatibility projection forwarding to `IsLinearMap.map_smul`. -/
abbrev map_smul {n m : ℕ} {T : ComplexVectorMap n m}
    (self : IsComplexVectorMapLinear T) (a : ℂ) (x : CVec n) :
    T (complexVecSMul a x) = complexVecSMul a (T x) :=
  IsLinearMap.map_smul self a x

/-- Compatibility eliminator using the canonical `IsLinearMap` projections. -/
@[elab_as_elim]
abbrev rec {n m : ℕ} {T : ComplexVectorMap n m}
    {motive : IsComplexVectorMapLinear T → Sort u}
    (mk : ∀ (map_add : ∀ x y : CVec n,
        T (complexVecAdd x y) = complexVecAdd (T x) (T y))
      (map_smul : ∀ (a : ℂ) (x : CVec n),
        T (complexVecSMul a x) = complexVecSMul a (T x)),
      motive (IsComplexVectorMapLinear.mk map_add map_smul))
    (t : IsComplexVectorMapLinear T) : motive t :=
  mk (IsLinearMap.map_add t) (IsLinearMap.map_smul t)

/-- Compatibility argument order for the legacy dependent eliminator. -/
@[elab_as_elim]
abbrev recOn {n m : ℕ} {T : ComplexVectorMap n m}
    {motive : IsComplexVectorMapLinear T → Sort u}
    (t : IsComplexVectorMapLinear T)
    (mk : ∀ (map_add : ∀ x y : CVec n,
        T (complexVecAdd x y) = complexVecAdd (T x) (T y))
      (map_smul : ∀ (a : ℂ) (x : CVec n),
        T (complexVecSMul a x) = complexVecSMul a (T x)),
      motive (IsComplexVectorMapLinear.mk map_add map_smul)) : motive t :=
  rec mk t

/-- Compatibility case analysis using the canonical linearity fields. -/
@[elab_as_elim]
abbrev casesOn {n m : ℕ} {T : ComplexVectorMap n m}
    {motive : IsComplexVectorMapLinear T → Sort u}
    (t : IsComplexVectorMapLinear T)
    (mk : ∀ (map_add : ∀ x y : CVec n,
        T (complexVecAdd x y) = complexVecAdd (T x) (T y))
      (map_smul : ∀ (a : ℂ) (x : CVec n),
        T (complexVecSMul a x) = complexVecSMul a (T x)),
      motive (IsComplexVectorMapLinear.mk map_add map_smul)) : motive t :=
  rec mk t

end IsComplexVectorMapLinear

/-- Composition of source-facing vector maps. -/
def complexVectorMapComp {n m k : ℕ} (A : ComplexVectorMap m k)
    (B : ComplexVectorMap n m) : ComplexVectorMap n k :=
  Function.comp A B

/-- Pointwise addition of source-facing vector maps. -/
noncomputable def complexVectorMapAdd {n m : ℕ} (A B : ComplexVectorMap n m) :
    ComplexVectorMap n m :=
  A + B

/-- Scalar multiplication of a source-facing vector map. -/
noncomputable def complexVectorMapSMul {n m : ℕ} (a : ℂ)
    (A : ComplexVectorMap n m) : ComplexVectorMap n m :=
  a • A

/-- Pointwise scalar action in the legacy explicit-vector notation. -/
@[simp]
theorem complexVectorMapSMul_apply {n m : ℕ} (a : ℂ)
    (A : ComplexVectorMap n m) (x : CVec n) :
    complexVectorMapSMul a A x = complexVecSMul a (A x) := rfl

/-- Pointwise negation of a source-facing vector map. -/
noncomputable def complexVectorMapNeg {n m : ℕ} (A : ComplexVectorMap n m) :
    ComplexVectorMap n m :=
  -A

/-- Pointwise subtraction of source-facing vector maps. -/
noncomputable def complexVectorMapSub {n m : ℕ} (A B : ComplexVectorMap n m) :
    ComplexVectorMap n m :=
  A - B

/-- A source-facing square map is singular if it has a nonzero kernel vector. -/
def IsSingularComplexVectorMap {n : ℕ} (A : ComplexVectorMap n n) : Prop :=
  ∃ x : CVec n, x ≠ 0 ∧ A x = 0

lemma complexVectorMapComp_linear {n m k : ℕ} {A : ComplexVectorMap m k}
    {B : ComplexVectorMap n m} (hA : IsComplexVectorMapLinear A)
    (hB : IsComplexVectorMapLinear B) :
    IsComplexVectorMapLinear (complexVectorMapComp A B) := by
  constructor
  · intro x y
    change A (B (x + y)) = A (B x) + A (B y)
    rw [IsLinearMap.map_add hB, IsLinearMap.map_add hA]
  · intro a x
    change A (B (a • x)) = a • A (B x)
    rw [IsLinearMap.map_smul hB, IsLinearMap.map_smul hA]

lemma complexVectorMapAdd_linear {n m : ℕ} {A B : ComplexVectorMap n m}
    (hA : IsComplexVectorMapLinear A) (hB : IsComplexVectorMapLinear B) :
    IsComplexVectorMapLinear (complexVectorMapAdd A B) := by
  constructor
  · intro x y
    change A (x + y) + B (x + y) = (A x + B x) + (A y + B y)
    rw [IsLinearMap.map_add hA, IsLinearMap.map_add hB]
    abel
  · intro a x
    change A (a • x) + B (a • x) = a • (A x + B x)
    rw [IsLinearMap.map_smul hA, IsLinearMap.map_smul hB, smul_add]

lemma complexVectorMapSMul_linear {n m : ℕ} {A : ComplexVectorMap n m}
    (a : ℂ) (hA : IsComplexVectorMapLinear A) :
    IsComplexVectorMapLinear (complexVectorMapSMul a A) := by
  constructor
  · intro x y
    change a • A (x + y) = a • A x + a • A y
    rw [IsLinearMap.map_add hA, smul_add]
  · intro b x
    change a • A (b • x) = b • (a • A x)
    rw [IsLinearMap.map_smul hA]
    exact smul_comm a b (A x)

lemma complexVectorMapNeg_linear {n m : ℕ} {A : ComplexVectorMap n m}
    (hA : IsComplexVectorMapLinear A) :
    IsComplexVectorMapLinear (complexVectorMapNeg A) := by
  simpa [complexVectorMapSMul, complexVectorMapNeg] using
    complexVectorMapSMul_linear (-1 : ℂ) hA

lemma complexVectorMapSub_linear {n m : ℕ} {A B : ComplexVectorMap n m}
    (hA : IsComplexVectorMapLinear A) (hB : IsComplexVectorMapLinear B) :
    IsComplexVectorMapLinear (complexVectorMapSub A B) := by
  simpa only [complexVectorMapAdd, complexVectorMapNeg, complexVectorMapSub,
    sub_eq_add_neg] using
    complexVectorMapAdd_linear hA (complexVectorMapNeg_linear hB)

lemma IsComplexVectorMapLinear.map_zero {n m : ℕ} {T : ComplexVectorMap n m}
    (hT : IsComplexVectorMapLinear T) : T 0 = 0 := by
  have h := hT.map_smul (0 : ℂ) (0 : CVec n)
  have hleft : complexVecSMul (0 : ℂ) (0 : CVec n) = 0 := by
    ext i
    simp [complexVecSMul]
  have hright : complexVecSMul (0 : ℂ) (T 0) = 0 := by
    ext i
    simp [complexVecSMul]
  rw [hleft, hright] at h
  exact h

/-- Mathlib linear-map wrapper for a source-facing complex vector map. -/
noncomputable def complexVectorMapLinearMap {n m : ℕ}
    (T : ComplexVectorMap n m) (hT : IsComplexVectorMapLinear T) :
    CVec n →ₗ[ℂ] CVec m where
  toFun := T
  map_add' := by
    intro x y
    simpa [complexVecAdd] using hT.map_add x y
  map_smul' := by
    intro a x
    simpa [complexVecSMul] using hT.map_smul a x

-- Keep lazily generated theorems in their frozen semantic owner.
run_meta do
  for declName in #[
      ``NumStability.complexVectorMapNeg,
      ``NumStability.complexVectorMapSub] do
    discard <| Lean.Meta.getEqnsFor? declName
  discard <| Lean.Meta.mkCongrSimpForConst?
    ``NumStability.complexVectorMapLinearMap []

@[simp]
theorem complexVectorMapLinearMap_apply {n m : ℕ}
    (T : ComplexVectorMap n m) (hT : IsComplexVectorMapLinear T)
    (x : CVec n) :
    complexVectorMapLinearMap T hT x = T x := rfl

theorem complexVectorNorm_pullback_of_linear_injective
    {n : ℕ} {μ : CVec n → ℝ} {S : ComplexVectorMap n n}
    (hμ : IsComplexVectorNorm μ) (hS : IsComplexVectorMapLinear S)
    (hinj_zero : ∀ x : CVec n, S x = 0 → x = 0) :
    IsComplexVectorNorm (fun x : CVec n => μ (S x)) := by
  constructor
  · intro x
    exact hμ.nonneg (S x)
  · intro x
    constructor
    · intro hx
      exact hinj_zero x ((hμ.eq_zero_iff (S x)).mp hx)
    · intro hx
      subst hx
      have hS0 : S 0 = 0 := hS.map_zero
      rw [hS0]
      exact (hμ.eq_zero_iff 0).mpr rfl
  · intro a x
    rw [hS.map_smul, hμ.smul]
  · intro x y
    rw [hS.map_add]
    exact hμ.add_le (S x) (S y)
end NumStability
