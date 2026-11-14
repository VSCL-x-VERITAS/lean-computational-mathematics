/-
SPDX-License-Identifier: MIT
Bhatia, Matrix Analysis (1997), Chapter I.5.
-/
import ComputationalMathematics.Source.Bhatia.Chapter01.WedgeDefinitions

set_option autoImplicit false
universe u
open scoped BigOperators

namespace NumStability.Bhatia.Chapter01.Targets

noncomputable section

/-- I.5.wedge: definitional equality for every input, with no vector hypothesis. -/
def wedgeDefinition : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
    [FiniteDimensional ℂ H] (k : ℕ) (hk : 0 < k) (x : Fin k → H),
    normalizedWedge k hk x =
      (((Real.sqrt (Nat.factorial k : ℝ))⁻¹ : ℝ) : ℂ) •
        ∑ σ : Equiv.Perm (Fin k),
          (((Equiv.Perm.sign σ : ℤ) : ℂ) •
            PiTensorProduct.tprod ℂ (fun i : Fin k => x (σ i)))


end

end NumStability.Bhatia.Chapter01.Targets
