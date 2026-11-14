/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.TensorProduct

/-!
# Positive tensor powers of finite dimensional real inner product spaces

The parameter `r` represents degree `r + 1`. The one-factor carrier is the
original space, and each recursive step adds a factor on the left using the
binary tensor product and its existing inner product. This construction includes
zero dimensional spaces and introduces no convention for degree zero.
-/

set_option autoImplicit false
noncomputable section
universe u
open scoped TensorProduct

namespace NumStability.RealHilbertTensor

/-- A finite dimensional real inner product space, bundled with its structures. -/
structure FiniteSpace where
  carrier : Type u
  [normed : NormedAddCommGroup carrier]
  [innerProduct : InnerProductSpace ℝ carrier]
  [finiteDimensional : FiniteDimensional ℝ carrier]

attribute [instance] FiniteSpace.normed FiniteSpace.innerProduct
  FiniteSpace.finiteDimensional

/-- Bundle the original space as a one-factor tensor power. -/
def ofSpace (E : Type u) [NormedAddCommGroup E] [InnerProductSpace ℝ E]
    [FiniteDimensional ℝ E] : FiniteSpace where
  carrier := E
  normed := inferInstance
  innerProduct := inferInstance
  finiteDimensional := inferInstance

/-- The binary tensor product with its product inner product and finite dimension. -/
def step (X Y : FiniteSpace.{u}) : FiniteSpace where
  carrier := X.carrier ⊗[ℝ] Y.carrier
  normed := inferInstance
  innerProduct := inferInstance
  finiteDimensional := by
    letI := X.finiteDimensional
    letI := Y.finiteDimensional
    exact Module.Finite.tensorProduct (R := ℝ) (M := X.carrier) (N := Y.carrier)

/-- The tensor power of degree `r + 1`, associated from the right. -/
def power (E : Type u) [NormedAddCommGroup E] [InnerProductSpace ℝ E]
    [FiniteDimensional ℝ E] : ℕ → FiniteSpace
  | 0 => ofSpace E
  | r + 1 => step (ofSpace E) (power E r)

/-- The pure tensor with the prescribed factors in their original order. -/
def pure (E : Type u) [NormedAddCommGroup E] [InnerProductSpace ℝ E]
    [FiniteDimensional ℝ E] :
    (r : ℕ) → (Fin (r + 1) → E) → (power E r).carrier
  | 0, x => x 0
  | r + 1, x => TensorProduct.tmul ℝ (x 0) (pure E r (fun i => x i.succ))

end NumStability.RealHilbertTensor
