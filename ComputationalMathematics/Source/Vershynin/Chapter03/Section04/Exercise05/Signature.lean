import ComputationalMathematics.HDP.Vector.FiniteAtomicSubGaussian

/-! Frozen proof-free signature for Exercise 3.4.5. -/

noncomputable section

open scoped BigOperators NNReal ENNReal

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_ex_3_4_5__contract_type : Prop :=
  ∀ K : ℝ, 0 < K →
    ∃ c n₀ : ℝ, 0 < c ∧ 0 ≤ n₀ ∧
      ∀ {N n : ℕ}, 0 < N →
        ∀ (p : Fin N → ℝ≥0) (hp : ∑ i, p i = 1)
          (x : Fin N → Fin n → ℝ),
          Function.Injective x →
          (∀ i, 0 < p i) →
          n₀ ≤ (n : ℝ) →
          NumStability.HDP.Vector.Isotropy.IsIsotropic
              (NumStability.HDP.Vector.FrameIsotropy.finiteWeightedVectorMeasure p hp x)
              (fun j : Fin n ↦ fun y : Fin n → ℝ ↦ y j) →
          NumStability.HDP.Vector.SubGaussian.PsiTwoNorm
              (NumStability.HDP.Vector.FrameIsotropy.finiteWeightedVectorMeasure p hp x)
              (fun j : Fin n ↦ fun y : Fin n → ℝ ↦ y j) ≤ ENNReal.ofReal K →
          Real.exp (c * n) ≤ (N : ℝ)

end NumStability.HDP.Contract
