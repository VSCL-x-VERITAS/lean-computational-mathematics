import ComputationalMathematics.HDP.Vector.GaussianIndependence
import ComputationalMathematics.HDP.Vector.GaussianAffine

/-!
# Frozen signatures for Gaussian independence and covariance

The first proposition states the correct independence/uncorrelated equivalence.
The second freezes a counterexample to the adjacent printed parenthetical that
incorrectly identifies every independent Gaussian covariance with the identity.
-/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_body_3_3_normal_independent_iff_uncorrelated__contract_type : Prop :=
  ∀ {n : ℕ} {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X : Fin n → Ω → ℝ},
    HasGaussianLaw (fun ω i => X i ω) μ →
      (iIndepFun X μ ↔ ∀ i j, i ≠ j → cov[X i, X j; μ] = 0)

set_option linter.style.nameCheck false in
def hdp_03_body_3_3_normal_identity_parenthetical_obstruction__contract_type : Prop :=
  ∃ (S B : Matrix (Fin 1) (Fin 1) ℝ),
    S.PosSemidef ∧ IsUnit S ∧ B.PosSemidef ∧ B * B = S ∧
      let ν := NumStability.HDP.Vector.Gaussian.affineGaussianVectorMeasure
        (0 : Fin 1 → ℝ) B
      let X : Fin 1 → (Fin 1 → ℝ) → ℝ := fun i x => x i
      NumStability.HDP.Vector.Gaussian.HasAffineStandardNormalLaw ν X 0 B ∧
        iIndepFun X ν ∧
        NumStability.HDP.Vector.Covariance.covarianceMatrix ν X = S ∧
        S ≠ 1

end NumStability.HDP.Contract
