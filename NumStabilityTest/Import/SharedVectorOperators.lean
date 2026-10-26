/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.MatrixNorms.Basic

/-!
# Shared vector-operator compatibility

Checks the public constructor, projections and dependent eliminators retained
when the legacy linearity predicate forwards to Mathlib. The operation checks
use arbitrary functions, preserving the unbundled domains of the original API.
Inverse predicates retain the order of the matrix and its proposed inverse.
-/

namespace NumStabilityTest.SharedVectorOperators

open NumStability

variable {n m k : ℕ} {T : ComplexVectorMap n m}

example : IsComplexVectorMapLinear T = IsLinearMap ℂ T := rfl

example
    (ha : ∀ x y : CVec n,
      T (complexVecAdd x y) = complexVecAdd (T x) (T y))
    (hs : ∀ (a : ℂ) (x : CVec n),
      T (complexVecSMul a x) = complexVecSMul a (T x)) :
    IsComplexVectorMapLinear T :=
  IsComplexVectorMapLinear.mk ha hs

example
    (ha : ∀ x y : CVec n,
      T (complexVecAdd x y) = complexVecAdd (T x) (T y))
    (hs : ∀ (a : ℂ) (x : CVec n),
      T (complexVecSMul a x) = complexVecSMul a (T x)) :
    IsComplexVectorMapLinear T :=
  { map_add := ha, map_smul := hs }

example (h : IsComplexVectorMapLinear T) (x y : CVec n) :
    T (complexVecAdd x y) = complexVecAdd (T x) (T y) :=
  IsComplexVectorMapLinear.map_add h x y

example (h : IsComplexVectorMapLinear T) (a : ℂ) (x : CVec n) :
    T (complexVecSMul a x) = complexVecSMul a (T x) :=
  IsComplexVectorMapLinear.map_smul h a x

example (h : IsComplexVectorMapLinear T) (x y : CVec n) :
    T (complexVecAdd x y) = complexVecAdd (T x) (T y) :=
  h.map_add x y

example (h : IsComplexVectorMapLinear T) : T 0 = 0 := h.map_zero

example {motive : IsComplexVectorMapLinear T → Sort u}
    (step : ∀ ha hs, motive (IsComplexVectorMapLinear.mk ha hs))
    (h : IsComplexVectorMapLinear T) : motive h :=
  IsComplexVectorMapLinear.rec step h

example {motive : IsComplexVectorMapLinear T → Sort u}
    (h : IsComplexVectorMapLinear T)
    (step : ∀ ha hs, motive (IsComplexVectorMapLinear.mk ha hs)) : motive h :=
  IsComplexVectorMapLinear.recOn h step

example {motive : IsComplexVectorMapLinear T → Sort u}
    (h : IsComplexVectorMapLinear T)
    (step : ∀ ha hs, motive (IsComplexVectorMapLinear.mk ha hs)) : motive h :=
  IsComplexVectorMapLinear.casesOn h step

example (h : IsComplexVectorMapLinear T) :
    IsComplexVectorMapLinear.rec (motive := fun _ => ℕ) (fun _ _ => 7) h = 7 := by
  cases h
  rfl

/-- The legacy eliminator remains usable in computable definitions. -/
private def eliminatorValue (h : IsComplexVectorMapLinear T) : ℕ :=
  IsComplexVectorMapLinear.rec (motive := fun _ => ℕ) (fun _ _ => 7) h

example (h : IsComplexVectorMapLinear T) : eliminatorValue h = 7 := rfl

example (h : IsComplexVectorMapLinear T) :
    complexVectorMapLinearMap T h =
      { toFun := T, map_add' := h.map_add, map_smul' := h.map_smul } := rfl

example (A : ComplexVectorMap m k) (B : ComplexVectorMap n m) :
    complexVectorMapComp A B = Function.comp A B := rfl

example (A B : ComplexVectorMap n m) : complexVectorMapAdd A B = A + B := rfl

example (a : ℂ) (A : ComplexVectorMap n m) :
    complexVectorMapSMul a A = a • A := rfl

example (A : ComplexVectorMap n m) : complexVectorMapNeg A = -A := rfl

example (A B : ComplexVectorMap n m) : complexVectorMapSub A B = A - B := rfl

example (A B : CMatrix n n) :
    IsComplexMatrixLeftInverse A B =
      Function.LeftInverse (complexMatrixVecMul B) (complexMatrixVecMul A) := rfl

example (A B : CMatrix n n) :
    IsComplexMatrixRightInverse A B =
      Function.RightInverse (complexMatrixVecMul B) (complexMatrixVecMul A) := rfl

example (A B : CMatrix n n) (h : IsComplexMatrixRightInverse A B) (x : CVec n) :
    complexMatrixVecMul A (complexMatrixVecMul B x) = x := h x

end NumStabilityTest.SharedVectorOperators
