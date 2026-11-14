import Mathlib.Analysis.Seminorm
import Mathlib.Analysis.Complex.Basic
import Mathlib.LinearAlgebra.FiniteDimensional.Defs

/-! Proof-free target for Bhatia, Matrix Analysis (1997), I.2, printed page 7. -/

universe u

namespace NumStability.Bhatia.Chapter01.Targets

def normEquivalence : Prop :=
  ∀ (V : Type u) [AddCommGroup V] [Module ℂ V] [FiniteDimensional ℂ V]
      (N₁ N₂ : Seminorm ℂ V),
    (∀ x : V, N₁ x = 0 ↔ x = 0) →
    (∀ x : V, N₂ x = 0 ↔ x = 0) →
    ∃ c C : ℝ, 0 < c ∧ 0 < C ∧
      ∀ x : V, c * N₁ x ≤ N₂ x ∧ N₂ x ≤ C * N₁ x

end NumStability.Bhatia.Chapter01.Targets
