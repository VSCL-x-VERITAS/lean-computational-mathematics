import Mathlib.Probability.Kernel.Posterior
import Mathlib.Probability.ProbabilityMassFunction.Constructions
import ComputationalMathematics.HDP.Probability.FiniteGaussianDensity
import ComputationalMathematics.MeasureTheory.Constructions.Pi
import Mathlib.MeasureTheory.Group.Arithmetic
import Mathlib.MeasureTheory.Measure.WithDensity
import Mathlib.MeasureTheory.Measure.Decomposition.Lebesgue
import Mathlib.Probability.Kernel.Composition.MeasureComp
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Ring

/-!
# A finite Gaussian posterior with one shared label

Under the fair Bool prior, one label chooses the entire product Gaussian law.
For nonzero coordinate variances, the predictive mixture is absolutely
continuous with respect to product Lebesgue measure. Its posterior probability
of the positive label equals the normalized likelihood almost everywhere
under the predictive mixture. Means may have either sign and the index may be empty.
-/

set_option autoImplicit false
open MeasureTheory ProbabilityTheory
open scoped BigOperators ENNReal NNReal ProbabilityTheory
universe u
namespace NumStability.HDP.Probability

/-- Shared-label Gaussian posterior likelihood ratio, predictive-mixture almost everywhere. -/
theorem vectorGaussianLikelihoodRatio_posterior {ι : Type u} [Fintype ι]
    (r : ι → ℝ) (v : ι → ℝ≥0) (hv : ∀ j, v j ≠ 0) :
    let μminus := Measure.pi (fun j ↦ gaussianReal (-(r j)) (v j))
        let μplus := Measure.pi (fun j ↦ gaussianReal (r j) (v j))
        let K := Kernel.boolKernel μminus μplus
        let π := (PMF.bernoulli (1 / 2)
          (half_le_self (zero_le_one : (0 : ℝ≥0) ≤ 1))).toMeasure
        let M := K ∘ₘ π
        M ≪ Measure.pi (fun _ : ι ↦ (volume : Measure ℝ)) ∧
          ∀ᵐ x ∂M, (posterior K π) x ({true} : Set Bool) =
            ENNReal.ofReal (NumStability.HDP.Probability.vectorGaussianLikelihoodRatio r v x) := by
  classical
  let μminus : Measure (ι → ℝ) := Measure.pi (fun j ↦ gaussianReal (-(r j)) (v j))
  let μplus : Measure (ι → ℝ) := Measure.pi (fun j ↦ gaussianReal (r j) (v j))
  let K := Kernel.boolKernel μminus μplus
  let π : Measure Bool := (PMF.bernoulli (1 / 2)
    (half_le_self (zero_le_one : (0 : ℝ≥0) ≤ 1))).toMeasure
  let M : Measure (ι → ℝ) := K ∘ₘ π
  let baseMeasure : Measure (ι → ℝ) := Measure.pi (fun _ : ι ↦ (volume : Measure ℝ))
  let c : ℝ≥0∞ := ENNReal.ofReal (1 / 2 : ℝ)
  let Fplus : (ι → ℝ) → ℝ≥0∞ := fun x ↦ ENNReal.ofReal (vectorGaussianLikelihood r v x)
  let Fminus : (ι → ℝ) → ℝ≥0∞ := fun x ↦
    ENNReal.ofReal (vectorGaussianLikelihood (fun j ↦ -(r j)) v x)
  let G : (ι → ℝ) → ℝ≥0∞ := fun x ↦ ENNReal.ofReal
    ((1 / 2 : ℝ) * (vectorGaussianLikelihood (fun j ↦ -(r j)) v x +
      vectorGaussianLikelihood r v x))
  letI : IsProbabilityMeasure μminus := by dsimp [μminus]; infer_instance
  letI : IsProbabilityMeasure μplus := by dsimp [μplus]; infer_instance
  letI : IsProbabilityMeasure π := by dsimp [π]; infer_instance
  letI : IsMarkovKernel K := by dsimp [K]; infer_instance
  letI : IsProbabilityMeasure M := by dsimp [M]; infer_instance
  letI : SigmaFinite baseMeasure := by dsimp [baseMeasure]; infer_instance
  have hpositive (m : ι → ℝ) (x : ι → ℝ) : 0 < vectorGaussianLikelihood m v x := by
    unfold vectorGaussianLikelihood
    exact Finset.prod_pos fun j _ ↦ gaussianPDFReal_pos (m j) (v j) (x j) (hv j)
  have hmeas (m : ι → ℝ) : Measurable
      (fun x : ι → ℝ ↦ ENNReal.ofReal (vectorGaussianLikelihood m v x)) := by
    apply Measurable.ennreal_ofReal
    unfold vectorGaussianLikelihood
    exact Finset.measurable_prod Finset.univ fun j _ ↦
      (measurable_gaussianPDFReal (m j) (v j)).comp (measurable_pi_apply j)
  have hFp : Measurable Fplus := hmeas r
  have hFm : Measurable Fminus := hmeas (fun j ↦ -(r j))
  have hGsplit : G = c • Fplus + c • Fminus := by
    funext x
    dsimp [G, c, Fplus, Fminus]
    rw [ENNReal.ofReal_mul (by norm_num : (0 : ℝ) ≤ 1 / 2),
      ENNReal.ofReal_add (hpositive (fun j ↦ -(r j)) x).le (hpositive r x).le]
    simp [mul_add, add_comm]
  have hcFp : Measurable (c • Fplus) := by
    simpa only [Pi.smul_apply, smul_eq_mul] using hFp.const_mul c
  have hcFm : Measurable (c • Fminus) := by
    simpa only [Pi.smul_apply, smul_eq_mul] using hFm.const_mul c
  have hG : Measurable G := by rw [hGsplit]; exact hcFp.add hcFm
  have hGzero : ∀ x, G x ≠ 0 := by
    intro x
    apply ne_of_gt
    apply ENNReal.ofReal_pos.mpr
    exact mul_pos (by norm_num) (add_pos (hpositive (fun j ↦ -(r j)) x) (hpositive r x))
  have hGtop : ∀ x, G x ≠ ∞ := fun _ ↦ ENNReal.ofReal_ne_top
  have hpriorTrue : π ({true} : Set Bool) = c := by
    dsimp [π]
    rw [(PMF.bernoulli (1 / 2)
      (half_le_self (zero_le_one : (0 : ℝ≥0) ≤ 1))).toMeasure_apply_singleton
      true (measurableSet_singleton true)]
    norm_num [PMF.bernoulli_apply, c, ENNReal.ofReal_div_of_pos]
  have hpriorFalse : π ({false} : Set Bool) = c := by
    dsimp [π]
    rw [(PMF.bernoulli (1 / 2)
      (half_le_self (zero_le_one : (0 : ℝ≥0) ≤ 1))).toMeasure_apply_singleton
      false (measurableSet_singleton false)]
    norm_num [PMF.bernoulli_apply, c, ENNReal.ofReal_div_of_pos]
  have hdplus : μplus = baseMeasure.withDensity Fplus :=
    pi_gaussianReal_eq_withDensity r v hv
  have hdminus : μminus = baseMeasure.withDensity Fminus :=
    pi_gaussianReal_eq_withDensity (fun j ↦ -(r j)) v hv
  have hmixture : M = baseMeasure.withDensity G := by
    calc
      M = c • μplus + c • μminus := by
        dsimp [M, K]
        rw [boolKernel_comp_measure, hpriorTrue, hpriorFalse]
      _ = c • baseMeasure.withDensity Fplus + c • baseMeasure.withDensity Fminus := by rw [hdplus, hdminus]
      _ = baseMeasure.withDensity G := by
        rw [hGsplit, withDensity_add_left hcFp (c • Fminus),
          withDensity_smul c hFp, withDensity_smul c hFm]
  have hAC : M ≪ baseMeasure := by
    rw [hmixture]
    exact withDensity_absolutelyContinuous baseMeasure G
  have hbase : μplus.rnDeriv baseMeasure =ᵐ[baseMeasure] Fplus := by
    rw [hdplus]
    exact Measure.rnDeriv_withDensity baseMeasure hFp
  have hright :
      μplus.rnDeriv (baseMeasure.withDensity G) =ᵐ[baseMeasure] fun x ↦ (G x)⁻¹ * μplus.rnDeriv baseMeasure x :=
    Measure.rnDeriv_withDensity_right μplus baseMeasure hG.aemeasurable
      (ae_of_all _ hGzero) (ae_of_all _ hGtop)
  have hrn : μplus.rnDeriv M =ᵐ[baseMeasure] fun x ↦ (G x)⁻¹ * Fplus x := by
    rw [hmixture]
    filter_upwards [hright, hbase] with x hx hb
    rw [hx, hb]
  have hrnM : μplus.rnDeriv M =ᵐ[M] fun x ↦ (G x)⁻¹ * Fplus x := hAC.ae_eq hrn
  change M ≪ baseMeasure ∧ ∀ᵐ x ∂M,
    (posterior K π) x ({true} : Set Bool) = ENNReal.ofReal (vectorGaussianLikelihoodRatio r v x)
  refine ⟨hAC, ?_⟩
  filter_upwards [posterior_boolKernel_apply_true μminus μplus π, hrnM] with x hp hr
  rw [hp, hpriorTrue, hr]
  have hsum : 0 < vectorGaussianLikelihood (fun j ↦ -(r j)) v x +
      vectorGaussianLikelihood r v x :=
    add_pos (hpositive (fun j ↦ -(r j)) x) (hpositive r x)
  have hhalfSum : 0 < (1 / 2 : ℝ) *
      (vectorGaussianLikelihood (fun j ↦ -(r j)) v x +
        vectorGaussianLikelihood r v x) := mul_pos (by norm_num) hsum
  dsimp [c, G, Fplus]
  rw [← ENNReal.ofReal_inv_of_pos hhalfSum,
    ← ENNReal.ofReal_mul (inv_nonneg.mpr hhalfSum.le),
    ← ENNReal.ofReal_mul (by norm_num : (0 : ℝ) ≤ 1 / 2)]
  apply congrArg ENNReal.ofReal
  unfold vectorGaussianLikelihoodRatio
  field_simp [ne_of_gt hsum]


end NumStability.HDP.Probability
