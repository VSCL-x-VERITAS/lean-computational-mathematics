import ComputationalMathematics.Source.Vershynin.Chapter03.Section04.Definition01.Signature

/-! Definition 3.4.1: sub-Gaussian random vectors and their `ψ₂` norm. -/

noncomputable section

namespace NumStability.HDP.Contract

/-- A finite random vector is sub-Gaussian exactly when all of its scalar
linear marginals are sub-Gaussian, and its vector `ψ₂` norm is their supremum
over Euclidean unit directions. -/
theorem hdp_03_def_3_4_1 : hdp_03_def_3_4_1__contract_type := by
  intro n _ Ω _ μ _ X
  exact ⟨NumStability.HDP.Vector.SubGaussian.isSubGaussian_iff,
    NumStability.HDP.Vector.SubGaussian.psiTwoNorm_eq_iSup⟩

set_option linter.style.nameCheck false in
theorem hdp_03_def_3_4_1__contract : hdp_03_def_3_4_1__contract_type :=
  hdp_03_def_3_4_1

end NumStability.HDP.Contract
