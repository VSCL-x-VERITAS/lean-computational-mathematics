import ComputationalMathematics.HDP.Vector.GaussianMixture

/-!
# Vershynin Chapter 4, Definition 4.7.4
-/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.IndependentSums.Hoeffding

/-- Vershynin, Definition 4.7.4: the equal mixture of `N(μ,I)` and
`N(-μ,I)` is the law of `θμ+g` for an independent Rademacher sign and
standard Gaussian vector; an `m`-sample has the corresponding product law. -/
theorem hdp_04_definition_4_7_4 (m : ℕ) {n : ℕ} (μ : Fin n → ℝ) :
    NumStability.HDP.Vector.GaussianMixture.gaussianMixtureMeasure μ =
        Measure.map
          (fun z : ℝ × (Fin n → ℝ) ↦ fun i ↦ z.1 * μ i + z.2 i)
          (rademacherPMF.toMeasure.prod
            (NumStability.standardGaussianVectorMeasure n)) ∧
      NumStability.HDP.Vector.GaussianMixture.gaussianMixtureSampleMeasure m μ =
        Measure.pi (fun _ : Fin m ↦
          NumStability.HDP.Vector.GaussianMixture.gaussianMixtureMeasure μ) :=
  ⟨rfl, rfl⟩

end NumStability.HDP.Contract
