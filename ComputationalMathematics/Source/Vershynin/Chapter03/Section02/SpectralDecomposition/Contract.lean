import ComputationalMathematics.Source.Vershynin.Chapter03.Section02.SpectralDecomposition.Signature

/-! Source-facing contract for the spectral decomposition in Section 3.2. -/

noncomputable section

namespace NumStability.HDP.Contract

/-- Section 3.2, printed page 45: a real symmetric positive-semidefinite matrix
has an orthonormal diagonalization and nonnegative eigenvalues. -/
theorem hdp_03_body_3_2_spectral_decomposition :
    hdp_03_body_3_2_spectral_decomposition__contract_type := by
  intro n M hM
  refine ⟨?_, ?_, ?_⟩
  · exact hM.1.spectral_theorem
  · exact hM.eigenvalues_nonneg
  · exact hM.1.eigenvalues₀_antitone

set_option linter.style.nameCheck false in
/-- The implementation inhabits the frozen Section 3.2 spectral-decomposition signature. -/
theorem hdp_03_body_3_2_spectral_decomposition__contract :
    hdp_03_body_3_2_spectral_decomposition__contract_type :=
  hdp_03_body_3_2_spectral_decomposition

end NumStability.HDP.Contract
