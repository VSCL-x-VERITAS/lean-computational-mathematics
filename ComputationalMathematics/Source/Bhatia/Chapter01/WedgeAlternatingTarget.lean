/-
SPDX-License-Identifier: MIT
Bhatia, Matrix Analysis (1997), Chapter I.5.
-/
import ComputationalMathematics.Source.Bhatia.Chapter01.WedgeDefinitions

set_option autoImplicit false
universe u

namespace NumStability.Bhatia.Chapter01.Targets

noncomputable section

/-- I.5.wedge-alternating: both the transposition identity and repeated-factor
zero are retained for arbitrary tuples. The distinct-position quantifiers also
cover adjacent positions and endpoints; for k=1 their premises cannot hold.
-/
def wedgeAlternating : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
    [FiniteDimensional ℂ H] (k : ℕ) (hk : 0 < k) (x : Fin k → H),
    (∀ i j : Fin k, i ≠ j →
      normalizedWedge k hk (fun r => x (Equiv.swap i j r)) =
        -normalizedWedge k hk x) ∧
    ((∃ i j : Fin k, i ≠ j ∧ x i = x j) →
      normalizedWedge k hk x = 0)


end

end NumStability.Bhatia.Chapter01.Targets
