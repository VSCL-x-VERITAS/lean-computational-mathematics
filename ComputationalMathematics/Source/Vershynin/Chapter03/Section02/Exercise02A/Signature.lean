import ComputationalMathematics.HDP.Vector.AffineMoments

/-! Frozen signature for Exercise 3.2.2(a), affine transport from isotropy. -/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_ex_3_2_2a__contract_type : Prop :=
  ∀ {n : ℕ} {Ω : Type*} [MeasurableSpace Ω]
      {μ : Measure Ω} [IsProbabilityMeasure μ]
      (Z : Fin n → Ω → ℝ) (m : Fin n → ℝ)
      (S B : Matrix (Fin n) (Fin n) ℝ),
    (∀ i, MemLp (Z i) 2 μ) →
      NumStability.HDP.Vector.Covariance.meanVector μ Z = 0 →
      NumStability.HDP.Vector.Isotropy.IsIsotropic μ Z →
      S.PosSemidef → B.PosSemidef → B * B = S →
      NumStability.HDP.Vector.Covariance.meanVector μ
          (NumStability.HDP.Vector.affineTransform m B Z) = m ∧
        NumStability.HDP.Vector.Covariance.covarianceMatrix μ
          (NumStability.HDP.Vector.affineTransform m B Z) = S

end NumStability.HDP.Contract
