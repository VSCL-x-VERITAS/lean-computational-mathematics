import ComputationalMathematics.HDP.Vector.GaussianMixtureCanonical
import Mathlib.Probability.Kernel.Basic
import Mathlib.Probability.Kernel.Composition.MeasureCompProd

/-!
An unexecuted, source-neutral target proposal for one latent/observed row.
This file defines a proposition; it contains no theorem asserting it.
The parameters include dimension zero and the zero mean.
-/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Vector.GaussianMixture.JointLawPreparation

/-- The forward Bool-to-real encoding of the joint likelihood law agrees with
the existing real-sign/noise model after observing the noisy point. -/
def oneRowBoolLikelihoodJointLawTarget (n : ℕ) (mean : Fin n → ℝ) : Prop :=
  let gamma : Measure (Fin n → ℝ) :=
    NumStability.standardGaussianVectorMeasure n
  let prior : Measure Bool :=
    NumStability.HDP.Scalar.IndependentSums.Hoeffding.fairBernoulliPMF.toMeasure
  let sign : Bool → ℝ :=
    NumStability.HDP.Scalar.IndependentSums.Hoeffding.rademacherValue
  let component : Bool → Measure (Fin n → ℝ) :=
    fun b ↦ Measure.map
      (fun g : Fin n → ℝ ↦ fun i : Fin n ↦ sign b * mean i + g i) gamma
  let likelihood : Kernel Bool (Fin n → ℝ) :=
    Kernel.boolKernel (component false) (component true)
  Measure.map
      (fun z : Bool × (Fin n → ℝ) ↦ (sign z.1, z.2))
      (Measure.compProd prior likelihood) =
    Measure.map
      (fun z : ℝ × (Fin n → ℝ) ↦
        (z.1, NumStability.HDP.Vector.GaussianMixture.mixtureMap mean z))
      (NumStability.HDP.Vector.GaussianMixture.latentNoiseObservationMeasure n)

/-- Universal closure for a later independently frozen ordinary foundation target.
This unexecuted definition asserts no inhabitant and adds no hypotheses. -/
def oneRowBoolLikelihoodJointLawClosedTarget : Prop :=
  ∀ (n : ℕ) (mean : Fin n → ℝ), oneRowBoolLikelihoodJointLawTarget n mean

end NumStability.HDP.Vector.GaussianMixture.JointLawPreparation


end
