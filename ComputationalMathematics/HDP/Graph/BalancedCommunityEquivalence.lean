import Mathlib.Data.Fintype.EquivFin
import Mathlib.Logic.Equiv.Fin.Basic
import Mathlib.Logic.Equiv.Sum

/-!
# Equivalences for balanced finite community labels

Equal finite fibers identify a labeled carrier with a community label and an
offset within that community. The construction uses Mathlib's fiber and
finite-cardinality equivalences and includes empty fibers.
-/

namespace NumStability.HDP.Graph

/-- Identify equal-sized binary label classes with their label and offset. -/
theorem exists_balancedCommunityEquiv {α : Type*} [Fintype α]
    {k : ℕ} {community : α → Fin 2}
    (h : ∀ b : Fin 2, Fintype.card {x : α // community x = b} = k) :
    ∃ e : α ≃ Fin 2 × Fin k, ∀ x, (e x).1 = community x := by
  exact ⟨(Equiv.sigmaFiberEquiv community).symm.trans
    (Equiv.sigmaEquivProdOfEquiv
      (fun b : Fin 2 => Fintype.equivFinOfCardEq (h b))), fun _ => rfl⟩

/-- Flatten equal-sized binary label classes while retaining their labels. -/
theorem exists_balancedCommunityIndexEquiv {α : Type*} [Fintype α]
    {k : ℕ} {community : α → Fin 2}
    (h : ∀ b : Fin 2, Fintype.card {x : α // community x = b} = k) :
    ∃ e : α ≃ Fin (2 * k),
      ∀ x, ((finProdFinEquiv (m := 2) (n := k)).symm (e x)).1 = community x := by
  obtain ⟨e, he⟩ := exists_balancedCommunityEquiv h
  refine ⟨e.trans finProdFinEquiv, ?_⟩
  intro x
  simpa only [Equiv.trans_apply, Equiv.symm_apply_apply] using he x

end NumStability.HDP.Graph
