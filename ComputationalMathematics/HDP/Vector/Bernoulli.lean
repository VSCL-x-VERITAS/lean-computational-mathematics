import ComputationalMathematics.HDP.Vector.IndependentCoordinates
import ComputationalMathematics.HDP.Scalar.IndependentSums.Hoeffding.Basic

/-!
# Symmetric Bernoulli random vectors

This module packages the finite-dimensional symmetric Bernoulli law and proves
its isotropy by reducing to the independent standardized-coordinate bridge.
-/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Vector.Bernoulli

open NumStability.HDP.Scalar.IndependentSums.Hoeffding

/-- A finite random vector is symmetric Bernoulli when its coordinates are
mutually independent and each coordinate has the Rademacher law. -/
def IsSymmetricBernoulli {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (μ : Measure Ω) (X : Fin n → Ω → ℝ) : Prop :=
  iIndepFun X μ ∧ ∀ i, HasLaw (X i) rademacherPMF.toMeasure μ

/-- The product Rademacher law on the discrete cube `{-1, 1}^n`. -/
def discreteCubeMeasure (n : ℕ) : Measure (Fin n → ℝ) :=
  Measure.pi (fun _ : Fin n => rademacherPMF.toMeasure)

/-- A random vector is uniformly distributed on the unit discrete cube when
its joint law is the product Rademacher measure. -/
def HasUniformDiscreteCubeLaw {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (μ : Measure Ω) (X : Fin n → Ω → ℝ) : Prop :=
  HasLaw (fun ω i => X i ω) (discreteCubeMeasure n) μ

/-- Independent Rademacher coordinates are equivalent to the uniform joint
law on the unit discrete cube. -/
theorem isSymmetricBernoulli_iff_hasUniformDiscreteCubeLaw
    {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    {μ : Measure Ω} [IsProbabilityMeasure μ] {X : Fin n → Ω → ℝ} :
    IsSymmetricBernoulli μ X ↔ HasUniformDiscreteCubeLaw μ X := by
  constructor
  · intro hX
    have hMeas : ∀ i, AEMeasurable (X i) μ := fun i => (hX.2 i).aemeasurable
    refine ⟨aemeasurable_pi_lambda _ hMeas, ?_⟩
    rw [(iIndepFun_iff_map_fun_eq_pi_map hMeas).1 hX.1]
    unfold discreteCubeMeasure
    congr 1
    funext i
    exact (hX.2 i).map_eq
  · intro hX
    have hCoord : ∀ i, HasLaw (X i) rademacherPMF.toMeasure μ := by
      intro i
      have hEval := (measurePreserving_eval
        (fun _ : Fin n => rademacherPMF.toMeasure) i).hasLaw
      exact hEval.fun_comp hX
    refine ⟨?_, hCoord⟩
    apply (iIndepFun_iff_map_fun_eq_pi_map fun i => (hCoord i).aemeasurable).2
    rw [hX.map_eq]
    unfold discreteCubeMeasure
    congr 1
    funext i
    exact (hCoord i).map_eq.symm

/-- The identity random variable under the Rademacher law is square-integrable. -/
theorem rademacher_id_memLp : MemLp id 2 rademacherPMF.toMeasure := by
  have hm : Measurable rademacherValue := measurable_of_countable _
  have hv : MemLp rademacherValue 2 fairBernoulliPMF.toMeasure := by
    apply MemLp.of_bound hm.aestronglyMeasurable 1
    filter_upwards with b
    cases b <;> simp [rademacherValue]
  rw [show rademacherPMF.toMeasure =
      Measure.map rademacherValue fairBernoulliPMF.toMeasure by
        symm
        simpa [rademacherPMF] using
          PMF.toMeasure_map rademacherValue fairBernoulliPMF hm]
  apply (memLp_map_measure_iff aestronglyMeasurable_id hm.aemeasurable).2
  simp

/-- Any random variable with the Rademacher law is square-integrable. -/
theorem memLp_of_hasLaw_rademacher
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} {Z : Ω → ℝ}
    (hZ : HasLaw Z rademacherPMF.toMeasure μ) : MemLp Z 2 μ := by
  have h := (memLp_map_measure_iff aestronglyMeasurable_id hZ.aemeasurable).1
    (hZ.map_eq ▸ rademacher_id_memLp)
  simpa [Function.comp_def] using h

/-- Any random variable with the Rademacher law has mean zero. -/
theorem integral_eq_zero_of_hasLaw_rademacher
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} {Z : Ω → ℝ}
    (hZ : HasLaw Z rademacherPMF.toMeasure μ) : ∫ ω, Z ω ∂μ = 0 := by
  exact hZ.integral_eq.trans rademacherPMF_mean

/-- Any random variable with the Rademacher law has variance one. -/
theorem variance_eq_one_of_hasLaw_rademacher
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} [IsProbabilityMeasure μ]
    {Z : Ω → ℝ} (hZ : HasLaw Z rademacherPMF.toMeasure μ) :
    variance Z μ = 1 := by
  rw [hZ.variance_eq, variance_eq_sub rademacher_id_memLp]
  change (∫ x : ℝ, x ^ 2 ∂rademacherPMF.toMeasure) -
      (∫ x : ℝ, x ∂rademacherPMF.toMeasure) ^ 2 = 1
  rw [rademacherPMF_mean]
  simpa [Function.id_def, pow_two] using rademacherPMF_variance

/-- Every finite symmetric Bernoulli random vector is isotropic. -/
theorem isIsotropic_of_isSymmetricBernoulli
    {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Fin n → Ω → ℝ} (hX : IsSymmetricBernoulli μ X) :
    NumStability.HDP.Vector.Isotropy.IsIsotropic μ X := by
  apply NumStability.HDP.Vector.Isotropy.isIsotropic_of_iIndepFun_mean_zero_variance_one
  · intro i
    exact memLp_of_hasLaw_rademacher (hX.2 i)
  · exact hX.1
  · intro i
    exact integral_eq_zero_of_hasLaw_rademacher (hX.2 i)
  · intro i
    exact variance_eq_one_of_hasLaw_rademacher (hX.2 i)

end NumStability.HDP.Vector.Bernoulli
