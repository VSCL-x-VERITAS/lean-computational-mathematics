import ComputationalMathematics.HDP.Probability.FiniteGaussianTranslation
import ComputationalMathematics.HDP.Vector.GaussianMixtureJointLaw

/-! Ordinary joint-law specialization for unit-variance product Gaussian components. -/
set_option autoImplicit false
noncomputable section
open MeasureTheory ProbabilityTheory
open scoped NNReal

namespace GaussianComponentJointLawPreparation

/-- One fair Bool chooses an entire product component; its encoded joint law
equals the existing independent Rademacher/noise observation construction. -/
def ComponentProductGaussianJointLawClosedTarget : Prop :=
  ∀ (n : ℕ) (mean : Fin n → ℝ),
    let μminus : Measure (Fin n → ℝ) :=
      Measure.pi (fun j ↦ gaussianReal (-(mean j)) 1)
    let μplus : Measure (Fin n → ℝ) :=
      Measure.pi (fun j ↦ gaussianReal (mean j) 1)
    let prior : Measure Bool :=
      (PMF.bernoulli (1 / 2)
        (half_le_self (zero_le_one : (0 : ℝ≥0) ≤ 1))).toMeasure
    let likelihood : Kernel Bool (Fin n → ℝ) :=
      Kernel.boolKernel μminus μplus
    Measure.map
        (fun z : Bool × (Fin n → ℝ) ↦
          (NumStability.HDP.Scalar.IndependentSums.Hoeffding.rademacherValue z.1, z.2))
        (Measure.compProd prior likelihood) =
      Measure.map
        (fun z : ℝ × (Fin n → ℝ) ↦
          (z.1, NumStability.HDP.Vector.GaussianMixture.mixtureMap mean z))
        (NumStability.HDP.Vector.GaussianMixture.latentNoiseObservationMeasure n)

end GaussianComponentJointLawPreparation
end
