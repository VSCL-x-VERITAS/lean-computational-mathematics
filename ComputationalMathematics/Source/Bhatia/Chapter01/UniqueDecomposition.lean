/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Source.Bhatia.Chapter01.DirectSumTarget

/-!
# Bhatia's unique direct-sum decomposition

Source correspondence for Section I.3, printed page 9. Complementary
subspaces give a unique ordered pair of summands. For an orthogonal complement,
those summands are orthogonal. The algebraic case requires no orthogonality.
-/

set_option autoImplicit false
universe u

namespace NumStability.Bhatia.Chapter01

/-- Unique ordered summands for algebraic and orthogonal complements. -/
theorem uniqueDecomposition : Targets.uniqueDecomposition.{u} := by
  intro H _ _ _ M N
  have decompose (h : IsCompl M N) (x : H) :
      ∃! p : M × N, p.1.val + p.2.val = x := by
    let e := Submodule.prodEquivOfIsCompl M N h
    refine ⟨e.symm x, e.apply_symm_apply x, ?_⟩
    intro p hp
    apply e.injective
    exact hp.trans (e.apply_symm_apply x).symm
  constructor
  · exact decompose
  · intro hN x
    have hcompl : IsCompl M N := by
      rw [hN]
      exact M.isCompl_orthogonal_of_hasOrthogonalProjection
    refine ⟨decompose hcompl x, ?_⟩
    intro p _
    have hp : p.2.val ∈ Mᗮ := by simpa only [hN] using p.2.property
    exact (M.mem_orthogonal p.2.val).mp hp p.1.val p.1.property

end NumStability.Bhatia.Chapter01
