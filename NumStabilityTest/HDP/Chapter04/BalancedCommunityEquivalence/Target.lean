import Mathlib.Data.Fintype.EquivFin
import Mathlib.Logic.Equiv.Sum

universe u

namespace NumStability.HDP.Verification

/-- Ordinary finite labeling interface, including empty fibers. -/
def BalancedCommunityEquivalenceClosedTarget : Prop :=
  ∀ (α : Type u) [Fintype α] (k : ℕ) (community : α → Fin 2),
    (∀ b : Fin 2, Fintype.card {x : α // community x = b} = k) →
      ∃ e : α ≃ Fin 2 × Fin k, ∀ x, (e x).1 = community x

end NumStability.HDP.Verification
