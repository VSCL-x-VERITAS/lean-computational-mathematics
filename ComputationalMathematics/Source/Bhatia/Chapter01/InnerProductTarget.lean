/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.LinearAlgebra.Matrix.RowCol

/-! Proof-free source target for Bhatia, *Matrix Analysis* (1997), Chapter I.1,
printed pages 1–2 (PDF pages 13–14). The general-space convention and induced
norm are followed by the standard complex coordinate specialization. -/

universe u

namespace NumStability.Bhatia.Chapter01.Targets

/-- Complex inner-product conventions, their induced norm, and column coordinates. -/
def innerProduct : Prop :=
  (∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H],
    (∀ (a : ℂ) (x y : H),
      inner ℂ (a • x) y = star a * inner ℂ x y) ∧
    (∀ (a : ℂ) (x y : H),
      inner ℂ x (a • y) = a * inner ℂ x y) ∧
    (∀ (x y z : H),
      inner ℂ (x + y) z = inner ℂ x z + inner ℂ y z) ∧
    (∀ (x y z : H),
      inner ℂ x (y + z) = inner ℂ x y + inner ℂ x z) ∧
    (∀ x : H, inner ℂ x x = 0 ↔ x = 0) ∧
    (∀ x : H, (inner ℂ x x).im = 0 ∧ 0 ≤ (inner ℂ x x).re) ∧
    (∀ x : H, ‖x‖ = Real.sqrt (inner ℂ x x).re)) ∧
  (∀ (n : ℕ) (x y : EuclideanSpace ℂ (Fin n)),
    inner ℂ x y =
      ((Matrix.replicateCol (Fin 1) (fun i => x i)).conjTranspose *
        Matrix.replicateCol (Fin 1) (fun i => y i)) 0 0) ∧
  (∀ (n : ℕ) (x : EuclideanSpace ℂ (Fin n)),
    ‖x‖ = Real.sqrt (inner ℂ x x).re)

end NumStability.Bhatia.Chapter01.Targets
