import ComputationalMathematics.HDP.Matrix.Weyl
import Mathlib.Data.Finset.Lattice.Fold

/-!
# Finite maximum of ordered eigenvalue perturbations

For positive-dimensional real symmetric matrix pairs, the existing indexed
Weyl bound controls the ordinary maximum of all corresponding differences.
-/

noncomputable section

namespace NumStability.HDP.Matrix

/-- Reuse the constant-one pointwise estimate to obtain the literal finite
maximum in every positive dimension. -/
theorem weyl_finite_maximum
    {n : ℕ} (hn : 0 < n) (S T : Matrix (Fin n) (Fin n) ℝ)
    (hS : S.IsHermitian) (hT : T.IsHermitian) :
    (Finset.univ : Finset (Fin n)).sup'
      (show (Finset.univ : Finset (Fin n)).Nonempty from
        ⟨⟨0, hn⟩, Finset.mem_univ _⟩)
      (fun i ↦ |NumStability.hermitianOrderedEigenvalue hS i -
        NumStability.hermitianOrderedEigenvalue hT i|) ≤
      NumStability.realMatrixOperatorNorm (S - T) := by
  exact Finset.sup'_le _ _ fun i _ ↦
    NumStability.HDP.Matrix.abs_hermitianOrderedEigenvalue_sub_le_operatorNorm
      S T hS hT i

end NumStability.HDP.Matrix
