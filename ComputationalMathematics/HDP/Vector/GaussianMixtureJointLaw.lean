import ComputationalMathematics.HDP.Probability.FiniteGaussianTranslation
import ComputationalMathematics.HDP.Vector.GaussianMixtureCanonical
import Mathlib.Probability.Kernel.Basic
import Mathlib.Probability.Kernel.Composition.MeasureCompProd

/-!
# Joint law of a Boolean latent sign and one Gaussian mixture observation

Encoding the Boolean likelihood model by the existing Rademacher sign agrees
with the existing independent real-sign/Gaussian-noise model. The identity
includes dimension zero and zero mean. It asserts no clustering guarantee.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped NNReal
open NumStability.HDP.Scalar.IndependentSums.Hoeffding

namespace NumStability.HDP.Vector.GaussianMixture

/-- The joint likelihood measure and the independent latent/noise construction
agree after the Boolean latent variable is encoded as a real sign. -/
theorem oneRowBoolLikelihood_jointLaw (n : ℕ) (mean : Fin n → ℝ) :
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
      (NumStability.HDP.Vector.GaussianMixture.latentNoiseObservationMeasure n) := by
  let γ := NumStability.standardGaussianVectorMeasure n
  let prior : Measure Bool := fairBernoulliPMF.toMeasure
  let sign : Bool → ℝ := rademacherValue
  let shift : Bool → (Fin n → ℝ) → (Fin n → ℝ) :=
    fun b g i => sign b * mean i + g i
  let component : Bool → Measure (Fin n → ℝ) := fun b => Measure.map (shift b) γ
  let κ := Kernel.boolKernel (component false) (component true)
  let encode : Bool × (Fin n → ℝ) → ℝ × (Fin n → ℝ) := fun z => (sign z.1, z.2)
  let boolObs : Bool × (Fin n → ℝ) → ℝ × (Fin n → ℝ) :=
    fun z => (sign z.1, shift z.1 z.2)
  let realObs : ℝ × (Fin n → ℝ) → ℝ × (Fin n → ℝ) :=
    fun z => (z.1, mixtureMap mean z)
  have hSign : Measurable sign := measurable_of_countable _
  have hShift (b) : Measurable (shift b) := by
    dsimp [shift]
    fun_prop
  have hCompProb (b) : IsProbabilityMeasure (component b) :=
    Measure.isProbabilityMeasure_map (hShift b).aemeasurable
  letI : IsProbabilityMeasure (component false) := hCompProb false
  letI : IsProbabilityMeasure (component true) := hCompProb true
  have hEncode : Measurable encode := (hSign.comp measurable_fst).prodMk measurable_snd
  have hBoolObs : Measurable boolObs := by
    dsimp [boolObs, shift]
    fun_prop
  have hRealObs : Measurable realObs := by
    exact measurable_fst.prodMk (measurable_mixtureMap mean)
  have hLeft : Measure.map encode (Measure.compProd prior κ) =
      Measure.map boolObs (prior.prod γ) := by
    apply Measure.ext
    intro s hs
    rw [Measure.map_apply hEncode hs, Measure.map_apply hBoolObs hs,
      Measure.compProd_apply (hEncode hs), Measure.prod_apply (hBoolObs hs)]
    apply lintegral_congr
    intro b
    change κ b {v | (sign b, v) ∈ s} = γ {g | (sign b, shift b g) ∈ s}
    have hk : κ b = component b := by cases b <;> rfl
    rw [hk]
    change Measure.map (shift b) γ ((fun v => (sign b, v)) ⁻¹' s) = _
    have hsSection : MeasurableSet ((fun v : Fin n → ℝ => (sign b, v)) ⁻¹' s) :=
      (measurable_const.prodMk measurable_id) hs
    exact Measure.map_apply (hShift b) hsSection
  have hProd : latentNoiseObservationMeasure n =
      Measure.map (Prod.map sign id) (prior.prod γ) := by
    unfold latentNoiseObservationMeasure
    change (fairBernoulliPMF.map sign).toMeasure.prod γ = _
    rw [← PMF.toMeasure_map sign fairBernoulliPMF hSign]
    simpa only [Measure.map_id] using
      (Measure.map_prod_map prior γ hSign measurable_id)
  have hRight : Measure.map realObs (latentNoiseObservationMeasure n) =
      Measure.map boolObs (prior.prod γ) := by
    rw [hProd, Measure.map_map hRealObs (hSign.prodMap measurable_id)]
    rfl
  exact hLeft.trans hRight.symm


/-- The explicit unit-variance product Gaussian components realize the existing
joint law of the encoded fair Boolean label and its mixture observation. -/
theorem oneRowBoolGaussian_jointLaw (n : ℕ) (mean : Fin n → ℝ) :
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
      (NumStability.HDP.Vector.GaussianMixture.latentNoiseObservationMeasure n) := by
  have hfalse :
      Measure.map (fun g : Fin n → ℝ ↦ fun j ↦ rademacherValue false * mean j + g j)
        (NumStability.standardGaussianVectorMeasure n) =
      Measure.pi (fun j ↦ gaussianReal (-(mean j)) 1) := by
    simpa [NumStability.standardGaussianVectorMeasure, rademacherValue] using
      NumStability.HDP.Probability.pi_gaussianReal_zero_map_const_add (fun j : Fin n ↦ -(mean j)) (fun _ ↦ 1)
  have htrue :
      Measure.map (fun g : Fin n → ℝ ↦ fun j ↦ rademacherValue true * mean j + g j)
        (NumStability.standardGaussianVectorMeasure n) =
      Measure.pi (fun j ↦ gaussianReal (mean j) 1) := by
    simpa [NumStability.standardGaussianVectorMeasure, rademacherValue] using
      NumStability.HDP.Probability.pi_gaussianReal_zero_map_const_add mean (fun _ ↦ 1)
  have h := oneRowBoolLikelihood_jointLaw n mean
  dsimp only at h
  rw [hfalse, htrue] at h
  simpa only [fairBernoulliPMF] using h


end NumStability.HDP.Vector.GaussianMixture

end
