import ComputationalMathematics.HDP.Probability.BalancedGaussianTesting
import ComputationalMathematics.HDP.Scalar.IndependentSums.Hoeffding.Basic

/-!
# Rademacher signs and Gaussian testing

Reusable measure identities and testing bounds for independent Rademacher
labels and Gaussian observations. Outer-measure identities retain arbitrary
decision sets while the probability bounds reuse the scalar Hoeffding API.
-/

open Set MeasureTheory ProbabilityTheory
open scoped ENNReal NNReal Real

namespace NumStability.HDP.Probability

open NumStability.HDP.Scalar.IndependentSums.Hoeffding

theorem fairBernoulliPMF_toMeasure_eq :
    fairBernoulliPMF.toMeasure =
      (2 : ℝ≥0∞)⁻¹ • Measure.dirac false +
        (2 : ℝ≥0∞)⁻¹ • Measure.dirac true := by
  ext s hs
  by_cases ht : true ∈ s <;> by_cases hf : false ∈ s <;>
    simp [fairBernoulliPMF, PMF.bernoulli_apply, ht, hf]

theorem rademacherPMF_toMeasure_eq :
    rademacherPMF.toMeasure =
      (2 : ℝ≥0∞)⁻¹ • Measure.dirac (1 : ℝ) +
        (2 : ℝ≥0∞)⁻¹ • Measure.dirac (-1 : ℝ) := by
  rw [show rademacherPMF.toMeasure =
      Measure.map rademacherValue fairBernoulliPMF.toMeasure by
    exact (PMF.toMeasure_map rademacherValue fairBernoulliPMF
      (measurable_of_countable rademacherValue)).symm]
  have hr : Measurable rademacherValue := measurable_of_countable _
  rw [fairBernoulliPMF_toMeasure_eq, Measure.map_add _ _ hr]
  simp [Measure.map_smul, rademacherValue, add_comm]

theorem gaussianReal_prod_translate_outer
    {S : Type*} [MeasurableSpace S] (nu : Measure S) [SFinite nu]
    (a : ℝ) :
    OuterMeasure.map (fun z : ℝ × S ↦ (a + z.1, z.2))
        ((gaussianReal 0 1).prod nu).toOuterMeasure =
      ((gaussianReal a 1).prod nu).toOuterMeasure := by
  let e : ℝ × S ≃ᵐ ℝ × S :=
    MeasurableEquiv.prodCongr
      (Homeomorph.addLeft a).toMeasurableEquiv
      (MeasurableEquiv.refl S)
  have he : (e : ℝ × S → ℝ × S) = fun z ↦ (a + z.1, z.2) := rfl
  have hmap : Measure.map e ((gaussianReal 0 1).prod nu) =
      (gaussianReal a 1).prod nu := by
    rw [show Measure.map e ((gaussianReal 0 1).prod nu) =
        (Measure.map (a + ·) (gaussianReal 0 1)).prod
          (Measure.map id nu) by
      simpa [e] using
        (Measure.map_prod_map (gaussianReal 0 1) nu
          (by fun_prop : Measurable (a + ·)) measurable_id).symm]
    simp [gaussianReal_map_const_add]
  ext A
  simp only [OuterMeasure.map_apply, Measure.toOuterMeasure_apply]
  rw [← he, ← e.map_apply, hmap]

theorem dirac_prod_toOuterMeasure
    {T : Type*} [MeasurableSpace T] (mu : Measure T) [SFinite mu]
    (r : ℝ) :
    ((Measure.dirac r).prod mu).toOuterMeasure =
      OuterMeasure.map (Prod.mk r) mu.toOuterMeasure := by
  rw [Measure.dirac_prod]
  ext A
  simp only [Measure.toOuterMeasure_apply, OuterMeasure.map_apply]
  have h : MeasurableEmbedding (Prod.mk r : T → ℝ × T) := by
    simpa only [id_eq] using
      (MeasurableEmbedding.prodMk_left r MeasurableEmbedding.id)
  exact h.map_apply mu A

theorem rademacher_prod_toOuterMeasure
    {T : Type*} [MeasurableSpace T] (mu : Measure T) [SFinite mu] :
    (rademacherPMF.toMeasure.prod mu).toOuterMeasure =
      (2 : ℝ≥0∞)⁻¹ •
          OuterMeasure.map (Prod.mk (1 : ℝ)) mu.toOuterMeasure +
        (2 : ℝ≥0∞)⁻¹ •
          OuterMeasure.map (Prod.mk (-1 : ℝ)) mu.toOuterMeasure := by
  rw [rademacherPMF_toMeasure_eq, Measure.add_prod,
    Measure.prod_smul_left, Measure.prod_smul_left,
    Measure.add_toOuterMeasure, Measure.smul_toOuterMeasure,
    Measure.smul_toOuterMeasure,
    dirac_prod_toOuterMeasure, dirac_prod_toOuterMeasure]

/-- The raw outer law of a Rademacher sign, independent standard Gaussian,
and residual variable is exactly the balanced shifted-Gaussian outer law.
Because this is an equality of outer measures, it applies to every event,
without a measurability hypothesis. -/
theorem balancedGaussianBitOuter_eq_map_rademacher
    {S : Type*} [MeasurableSpace S] (residual : Measure S)
    [SFinite residual] (theta : ℝ) :
    OuterMeasure.map
        (fun omega : ℝ × (ℝ × S) ↦
          (decide (omega.1 = 1),
            (theta * omega.1 + omega.2.1, omega.2.2)))
        (rademacherPMF.toMeasure.prod
          ((gaussianReal 0 1).prod residual)).toOuterMeasure =
      balancedGaussianBitOuter residual theta := by
  let mu : Measure (ℝ × S) := (gaussianReal 0 1).prod residual
  let F : ℝ × (ℝ × S) → Bool × (ℝ × S) := fun omega ↦
    (decide (omega.1 = 1), (theta * omega.1 + omega.2.1, omega.2.2))
  have hpos :
      OuterMeasure.map F
          (OuterMeasure.map (Prod.mk (1 : ℝ)) mu.toOuterMeasure) =
        OuterMeasure.map (fun z : ℝ × S ↦ (true, z))
          ((gaussianReal theta 1).prod residual).toOuterMeasure := by
    rw [OuterMeasure.map_map,
      ← gaussianReal_prod_translate_outer residual theta,
      OuterMeasure.map_map]
    congr 2
    funext z
    simp [F]
  have hneg :
      OuterMeasure.map F
          (OuterMeasure.map (Prod.mk (-1 : ℝ)) mu.toOuterMeasure) =
        OuterMeasure.map (fun z : ℝ × S ↦ (false, z))
          ((gaussianReal (-theta) 1).prod residual).toOuterMeasure := by
    rw [OuterMeasure.map_map,
      ← gaussianReal_prod_translate_outer residual (-theta),
      OuterMeasure.map_map]
    congr 2
    funext z
    norm_num [F]
  change OuterMeasure.map F
      (rademacherPMF.toMeasure.prod mu).toOuterMeasure = _
  rw [rademacher_prod_toOuterMeasure mu]
  simp only [map_add, map_smul]
  rw [hpos, hneg]
  simp only [balancedGaussianBitOuter, smul_add]

/-- Setwise form of `balancedGaussianBitOuter_eq_map_rademacher`, valid for
an arbitrary event `A`. -/
theorem balancedGaussianBitOuter_apply_eq_rademacher
    {S : Type*} [MeasurableSpace S] (residual : Measure S)
    [SFinite residual] (theta : ℝ)
    (A : Set (Bool × (ℝ × S))) :
    (rademacherPMF.toMeasure.prod
        ((gaussianReal 0 1).prod residual)).toOuterMeasure
      ((fun omega : ℝ × (ℝ × S) ↦
          (decide (omega.1 = 1),
            (theta * omega.1 + omega.2.1, omega.2.2))) ⁻¹' A) =
      balancedGaussianBitOuter residual theta A := by
  rw [← OuterMeasure.map_apply]
  rw [balancedGaussianBitOuter_eq_map_rademacher residual theta]

end NumStability.HDP.Probability
