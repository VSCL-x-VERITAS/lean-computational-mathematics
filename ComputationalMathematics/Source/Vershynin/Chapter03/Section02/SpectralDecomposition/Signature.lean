import Mathlib.Analysis.Matrix.PosDef
import Mathlib.Analysis.Matrix.Spectrum

/-! Frozen contract signature for the spectral decomposition in Section 3.2. -/

noncomputable section

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_body_3_2_spectral_decomposition__contract_type : Prop :=
  ∀ {n : ℕ} (M : Matrix (Fin n) (Fin n) ℝ) (hM : M.PosSemidef),
      M = ((Unitary.conjStarAlgAut ℝ (Matrix (Fin n) (Fin n) ℝ))
          hM.1.eigenvectorUnitary)
          (Matrix.diagonal (RCLike.ofReal ∘ hM.1.eigenvalues)) ∧
        (∀ i, 0 ≤ hM.1.eigenvalues i) ∧
        Antitone hM.1.eigenvalues₀

end NumStability.HDP.Contract
