import ComputationalMathematics.HDP.Vector.GaussianAffine

/-! Frozen discrepancy signature for Exercise 3.3.4. -/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

/-- The nondegenerate affine-Gaussian convention fixed by the preceding
Section 3.3.2 definition: the covariance matrix is required to be invertible. -/
def HasBookNondegenerateNormalLaw
    {n : ℕ} {Omega : Type*} [MeasurableSpace Omega]
    (mu : Measure Omega) [IsProbabilityMeasure mu]
    (X : Omega → EuclideanSpace ℝ (Fin n)) : Prop :=
  ∃ (m : Fin n → ℝ) (S B : Matrix (Fin n) (Fin n) ℝ),
    S.PosSemidef ∧ IsUnit S ∧ B.PosSemidef ∧ B * B = S ∧
      NumStability.HDP.Vector.Gaussian.HasAffineStandardNormalLaw mu
        (fun i omega => X omega i) m B

set_option linter.style.nameCheck false in
def hdp_03_ex_3_3_4_degenerate_obstruction__contract_type : Prop :=
  ∃ X : Unit → EuclideanSpace ℝ (Fin 1),
    HasGaussianLaw X (Measure.dirac ()) ∧
      (∀ theta : EuclideanSpace ℝ (Fin 1),
        HasGaussianLaw (fun omega => innerSL ℝ theta (X omega)) (Measure.dirac ())) ∧
      ¬ HasBookNondegenerateNormalLaw (Measure.dirac ()) X

end NumStability.HDP.Contract
