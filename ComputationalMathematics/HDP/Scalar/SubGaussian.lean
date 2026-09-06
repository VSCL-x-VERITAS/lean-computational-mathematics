import Mathlib.Probability.Distributions.Gaussian.Real
import Mathlib.Probability.Distributions.Gaussian.HasGaussianLaw.Independence
import Mathlib.Analysis.SpecialFunctions.Gaussian.GaussianIntegral
import Mathlib.Analysis.SpecialFunctions.Gamma.Beta
import Mathlib.Analysis.SpecialFunctions.Stirling
import Mathlib.Analysis.Complex.ExponentialBounds
import Mathlib.Analysis.SpecialFunctions.Trigonometric.DerivHyp
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Series
import Mathlib.Analysis.SpecificLimits.Basic
import Mathlib.Analysis.Convex.SpecificFunctions.Basic
import Mathlib.MeasureTheory.Integral.Bochner.Basic
import Mathlib.MeasureTheory.Integral.Gamma
import Mathlib.MeasureTheory.Function.L1Space.Integrable
import Mathlib.Probability.Moments.IntegrableExpMul
import Mathlib.Tactic
import ComputationalMathematics.HDP.Scalar.Preliminaries
import ComputationalMathematics.HDP.Scalar.IndependentSums.Hoeffding
import ComputationalMathematics.Source.Vershynin.Chapter02.Section06.Exercise09.Signature

/-!
# Standard-normal MGF

This module proves the standard-normal moment-generating-function identity
used by the Chapter 2 sub-Gaussian development.
-/

noncomputable section

open MeasureTheory
open ProbabilityTheory
open Filter
open scoped Topology
open scoped BigOperators
open scoped NNReal ENNReal

namespace NumStability.HDP.Scalar.SubGaussian

/-- The standard-normal MGF is `exp (lam ^ 2 / 2)`. -/
theorem standardNormalMGF (lam : ℝ) :
    ∫ x, Real.exp (lam * x) ∂(gaussianReal 0 1) =
      Real.exp (lam ^ 2 / 2) := by
  rw [integral_gaussianReal_eq_integral_smul (μ := (0 : ℝ)) (v := (1 : NNReal))
    (f := fun x : ℝ => Real.exp (lam * x)) (by norm_num)]
  change (∫ x : ℝ, gaussianPDFReal 0 1 x * Real.exp (lam * x)) =
    Real.exp (lam ^ 2 / 2)
  have hpdf (x : ℝ) :
      gaussianPDFReal 0 1 x =
        (Real.sqrt (2 * Real.pi))⁻¹ * Real.exp (-x ^ 2 / 2) := by
    simp [gaussianPDFReal]
  simp_rw [hpdf]
  have hshift :
      ∫ x : ℝ, Real.exp (-(x - lam) ^ 2 / 2) =
        ∫ x : ℝ, Real.exp (-x ^ 2 / 2) :=
    integral_sub_right_eq_self (fun x : ℝ => Real.exp (-x ^ 2 / 2)) lam
  have hpoint :
      (fun x : ℝ =>
        (Real.sqrt (2 * Real.pi))⁻¹ * Real.exp (-x ^ 2 / 2) *
          Real.exp (lam * x)) =
        (fun x : ℝ =>
          Real.exp (lam ^ 2 / 2) *
            ((Real.sqrt (2 * Real.pi))⁻¹ *
              Real.exp (-(x - lam) ^ 2 / 2))) := by
    funext x
    calc
      (Real.sqrt (2 * Real.pi))⁻¹ * Real.exp (-x ^ 2 / 2) * Real.exp (lam * x) =
          (Real.sqrt (2 * Real.pi))⁻¹ *
            (Real.exp (-x ^ 2 / 2) * Real.exp (lam * x)) := by ring
      _ = (Real.sqrt (2 * Real.pi))⁻¹ *
            Real.exp (-x ^ 2 / 2 + lam * x) := by
              rw [Real.exp_add]
      _ = Real.exp (lam ^ 2 / 2) *
            ((Real.sqrt (2 * Real.pi))⁻¹ * Real.exp (-(x - lam) ^ 2 / 2)) := by
              calc
                (Real.sqrt (2 * Real.pi))⁻¹ *
                    Real.exp (-x ^ 2 / 2 + lam * x) =
                    (Real.sqrt (2 * Real.pi))⁻¹ *
                      Real.exp (lam ^ 2 / 2 + (-(x - lam) ^ 2 / 2)) := by
                        congr 1
                        congr 1
                        nlinarith
                _ = Real.exp (lam ^ 2 / 2) *
                      ((Real.sqrt (2 * Real.pi))⁻¹ * Real.exp (-(x - lam) ^ 2 / 2)) := by
                        rw [Real.exp_add]
                        ring
  have hgauss :
      ∫ x : ℝ, Real.exp (-x ^ 2 / 2) = Real.sqrt (Real.pi / (1 / 2)) := by
    have hnorm := ProbabilityTheory.integral_gaussianPDFReal_eq_one (0 : ℝ)
      (v := (1 : NNReal)) (by norm_num)
    simp_rw [hpdf] at hnorm
    rw [integral_const_mul] at hnorm
    norm_num [Real.sqrt_eq_rpow] at hnorm ⊢
    field_simp at hnorm ⊢
    nlinarith
  rw [hpoint, integral_const_mul, integral_const_mul, hshift, hgauss]
  norm_num [Real.sqrt_eq_rpow]
  field_simp

private structure StandardNormalSquareMGFProviders where
  hVar : gaussianReal 0 1 = volume.withDensity (gaussianPDF 0 1)
  hPdfMeas : Measurable (gaussianPDF 0 1)
  hPdfTop : ∀ x : ℝ, gaussianPDF 0 1 x < ⊤
  hToReal : ∀ x : ℝ, (gaussianPDF 0 1 x).toReal = gaussianPDFReal 0 1 x
  hWithDensity : ∀ {g : ℝ → ℝ},
    Integrable g (volume.withDensity (gaussianPDF 0 1)) ↔
      Integrable (fun x => g x * (gaussianPDF 0 1 x).toReal) volume
  hIntegral : ∀ {f : ℝ → ℝ},
    (∫ x, f x ∂(gaussianReal 0 1)) =
      ∫ x, gaussianPDFReal 0 1 x * f x
  hConstMul : ∀ (r : ℝ) (f : ℝ → ℝ),
    (∫ x, r * f x) = r * (∫ x, f x)
  hExp : ∀ {b : ℝ}, 0 < b →
    Integrable (fun x : ℝ => Real.exp (-b * x ^ 2)) volume
  hGaussian : ∀ (b : ℝ),
    ∫ x : ℝ, Real.exp (-b * x ^ 2) = Real.sqrt (Real.pi / b)
  hIff : ∀ {b : ℝ},
    Integrable (fun x : ℝ => Real.exp (-b * x ^ 2)) volume ↔ 0 < b

private theorem standardNormalSquareMGF_integrable
    (lam : ℝ) (hsmall : |lam| < (Real.sqrt 2)⁻¹)
    (p : StandardNormalSquareMGFProviders) :
    Integrable (fun x : ℝ => Real.exp (lam ^ 2 * x ^ 2)) (gaussianReal 0 1) := by
  have hsq : lam ^ 2 < (1 / 2 : ℝ) := by
    have hinv : 0 ≤ (Real.sqrt 2)⁻¹ := by positivity
    have hsq' : lam ^ 2 < ((Real.sqrt 2)⁻¹) ^ 2 := by
      calc
        lam ^ 2 = |lam| ^ 2 := (sq_abs lam).symm
        _ < |(Real.sqrt 2)⁻¹| ^ 2 :=
          (sq_lt_sq₀ (abs_nonneg lam) (abs_nonneg ((Real.sqrt 2)⁻¹))).2
            (by simpa [abs_of_nonneg hinv] using hsmall)
        _ = ((Real.sqrt 2)⁻¹) ^ 2 := sq_abs _
    simpa [Real.sq_sqrt (by norm_num : (0 : ℝ) ≤ 2)] using hsq'
  have hb : 0 < (1 / 2 : ℝ) - lam ^ 2 := sub_pos.mpr hsq
  rw [p.hVar]
  apply (p.hWithDensity (g := fun x : ℝ => Real.exp (lam ^ 2 * x ^ 2))).2
  simp only [p.hToReal]
  have htarget : Integrable (fun x : ℝ => gaussianPDFReal 0 1 x *
      Real.exp (lam ^ 2 * x ^ 2)) volume := by
    rw [show (fun x : ℝ => gaussianPDFReal 0 1 x * Real.exp (lam ^ 2 * x ^ 2)) =
      (fun x => (Real.sqrt (2 * Real.pi))⁻¹ *
        Real.exp (-((1 / 2 : ℝ) - lam ^ 2) * x ^ 2)) by
    funext x
    have hpdf (x : ℝ) : gaussianPDFReal 0 1 x =
        (Real.sqrt (2 * Real.pi))⁻¹ * Real.exp (-x ^ 2 / 2) := by
      simp [gaussianPDFReal]
    rw [hpdf]
    calc
      (Real.sqrt (2 * Real.pi))⁻¹ * Real.exp (-x ^ 2 / 2) *
          Real.exp (lam ^ 2 * x ^ 2) =
          (Real.sqrt (2 * Real.pi))⁻¹ *
            (Real.exp (-x ^ 2 / 2) * Real.exp (lam ^ 2 * x ^ 2)) := by ring
      _ = (Real.sqrt (2 * Real.pi))⁻¹ *
          Real.exp (-x ^ 2 / 2 + lam ^ 2 * x ^ 2) := by rw [Real.exp_add]
      _ = (Real.sqrt (2 * Real.pi))⁻¹ *
          Real.exp (-((1 / 2 : ℝ) - lam ^ 2) * x ^ 2) := by
            congr 2
            ring]
    exact (p.hExp hb).const_mul _
  simpa only [mul_comm] using htarget

private theorem standardNormalSquareMGF_value
    (lam : ℝ) (hsmall : |lam| < (Real.sqrt 2)⁻¹)
    (p : StandardNormalSquareMGFProviders) :
    ∫ x : ℝ, Real.exp (lam ^ 2 * x ^ 2) ∂(gaussianReal 0 1) =
      (Real.sqrt (1 - 2 * lam ^ 2))⁻¹ := by
  have hsq : lam ^ 2 < (1 / 2 : ℝ) := by
    have hinv : 0 ≤ (Real.sqrt 2)⁻¹ := by positivity
    have hsq' : lam ^ 2 < ((Real.sqrt 2)⁻¹) ^ 2 := by
      calc
        lam ^ 2 = |lam| ^ 2 := (sq_abs lam).symm
        _ < |(Real.sqrt 2)⁻¹| ^ 2 :=
          (sq_lt_sq₀ (abs_nonneg lam) (abs_nonneg ((Real.sqrt 2)⁻¹))).2
            (by simpa [abs_of_nonneg hinv] using hsmall)
        _ = ((Real.sqrt 2)⁻¹) ^ 2 := sq_abs _
    simpa [Real.sq_sqrt (by norm_num : (0 : ℝ) ≤ 2)] using hsq'
  have hb : 0 < (1 / 2 : ℝ) - lam ^ 2 := sub_pos.mpr hsq
  have hq : 0 < 1 - 2 * lam ^ 2 := by nlinarith
  rw [p.hIntegral]
  have hpdf (x : ℝ) : gaussianPDFReal 0 1 x =
      (Real.sqrt (2 * Real.pi))⁻¹ * Real.exp (-x ^ 2 / 2) := by
    simp [gaussianPDFReal]
  simp_rw [hpdf]
  rw [show (fun x : ℝ => (Real.sqrt (2 * Real.pi))⁻¹ *
      Real.exp (-x ^ 2 / 2) * Real.exp (lam ^ 2 * x ^ 2)) =
      (fun x => (Real.sqrt (2 * Real.pi))⁻¹ *
        Real.exp (-((1 / 2 : ℝ) - lam ^ 2) * x ^ 2)) by
    funext x
    calc
      (Real.sqrt (2 * Real.pi))⁻¹ * Real.exp (-x ^ 2 / 2) *
          Real.exp (lam ^ 2 * x ^ 2) =
          (Real.sqrt (2 * Real.pi))⁻¹ *
            (Real.exp (-x ^ 2 / 2) * Real.exp (lam ^ 2 * x ^ 2)) := by ring
      _ = (Real.sqrt (2 * Real.pi))⁻¹ *
          Real.exp (-x ^ 2 / 2 + lam ^ 2 * x ^ 2) := by rw [Real.exp_add]
      _ = (Real.sqrt (2 * Real.pi))⁻¹ *
          Real.exp (-((1 / 2 : ℝ) - lam ^ 2) * x ^ 2) := by
            congr 2
            ring]
  rw [p.hConstMul, p.hGaussian]
  apply (sq_eq_sq₀ (by positivity) (by positivity)).1
  rw [mul_pow]
  simp only [inv_pow]
  rw [Real.sq_sqrt (by positivity : (0 : ℝ) ≤ 2 * Real.pi),
    Real.sq_sqrt (div_nonneg (by positivity : (0 : ℝ) ≤ Real.pi) hb.le),
    Real.sq_sqrt hq.le]
  field_simp

private theorem standardNormalSquareMGF_not_integrable
    (lam : ℝ) (hlarge : (Real.sqrt 2)⁻¹ ≤ |lam|)
    (p : StandardNormalSquareMGFProviders) :
    ¬ Integrable (fun x : ℝ => Real.exp (lam ^ 2 * x ^ 2)) (gaussianReal 0 1) := by
  intro hInt
  rw [p.hVar] at hInt
  have hvol := (p.hWithDensity (g := fun x : ℝ => Real.exp (lam ^ 2 * x ^ 2))).1 hInt
  simp only [p.hToReal] at hvol
  have hvol' : Integrable (fun x : ℝ => gaussianPDFReal 0 1 x *
      Real.exp (lam ^ 2 * x ^ 2)) volume := by
    simpa only [mul_comm] using hvol
  have hsq : (1 / 2 : ℝ) ≤ lam ^ 2 := by
    have hinv : 0 ≤ (Real.sqrt 2)⁻¹ := by positivity
    have hsq' : ((Real.sqrt 2)⁻¹) ^ 2 ≤ |lam| ^ 2 := by
      calc
        ((Real.sqrt 2)⁻¹) ^ 2 = |(Real.sqrt 2)⁻¹| ^ 2 := (sq_abs _).symm
        _ ≤ |lam| ^ 2 :=
          (sq_le_sq₀ (abs_nonneg ((Real.sqrt 2)⁻¹)) (abs_nonneg lam)).2
            (by simpa [abs_of_nonneg hinv] using hlarge)
    simpa [abs_sq, Real.sq_sqrt (by norm_num : (0 : ℝ) ≤ 2)] using hsq'
  have hrew : (fun x : ℝ => gaussianPDFReal 0 1 x * Real.exp (lam ^ 2 * x ^ 2)) =
      (fun x => (Real.sqrt (2 * Real.pi))⁻¹ *
        Real.exp (-((1 / 2 : ℝ) - lam ^ 2) * x ^ 2)) := by
    funext x
    have hpdf (x : ℝ) : gaussianPDFReal 0 1 x =
        (Real.sqrt (2 * Real.pi))⁻¹ * Real.exp (-x ^ 2 / 2) := by
      simp [gaussianPDFReal]
    rw [hpdf]
    calc
      (Real.sqrt (2 * Real.pi))⁻¹ * Real.exp (-x ^ 2 / 2) *
          Real.exp (lam ^ 2 * x ^ 2) =
          (Real.sqrt (2 * Real.pi))⁻¹ *
            (Real.exp (-x ^ 2 / 2) * Real.exp (lam ^ 2 * x ^ 2)) := by ring
      _ = (Real.sqrt (2 * Real.pi))⁻¹ *
          Real.exp (-x ^ 2 / 2 + lam ^ 2 * x ^ 2) := by rw [Real.exp_add]
      _ = (Real.sqrt (2 * Real.pi))⁻¹ *
          Real.exp (-((1 / 2 : ℝ) - lam ^ 2) * x ^ 2) := by
            congr 2
            ring
  rw [hrew] at hvol'
  have hbad : ¬ Integrable (fun x : ℝ =>
      Real.exp (-((1 / 2 : ℝ) - lam ^ 2) * x ^ 2)) := by
    rw [p.hIff]
    exact not_lt_of_ge (sub_nonpos.mpr hsq)
  have hc : (Real.sqrt (2 * Real.pi))⁻¹ ≠ 0 := by positivity
  exact hbad ((integrable_const_mul_iff (isUnit_iff_ne_zero.mpr hc) _).mp hvol')

/-! Exercise 2.5.5(a): the standard normal square-MGF is finite exactly on
the neighborhood `|lam| < 1 / sqrt 2`, where it equals the displayed inverse
square-root formula, and is non-integrable at and beyond the boundary. -/
theorem standardNormalSquareMGF (lam : ℝ) :
    (|lam| < (Real.sqrt 2)⁻¹ →
      Integrable (fun x : ℝ => Real.exp (lam ^ 2 * x ^ 2)) (gaussianReal 0 1) ∧
        (∫ x : ℝ, Real.exp (lam ^ 2 * x ^ 2) ∂(gaussianReal 0 1)) =
          (Real.sqrt (1 - 2 * lam ^ 2))⁻¹) ∧
    ((Real.sqrt 2)⁻¹ ≤ |lam| →
      ¬ Integrable (fun x : ℝ => Real.exp (lam ^ 2 * x ^ 2)) (gaussianReal 0 1)) := by
  let p : StandardNormalSquareMGFProviders :=
    { hVar := ProbabilityTheory.gaussianReal_of_var_ne_zero 0 (by norm_num)
      hPdfMeas := ProbabilityTheory.measurable_gaussianPDF 0 1
      hPdfTop := fun x => ProbabilityTheory.gaussianPDF_lt_top
      hToReal := fun x => ProbabilityTheory.toReal_gaussianPDF x
      hWithDensity := by
        intro g
        exact (integrable_withDensity_iff
          (ProbabilityTheory.measurable_gaussianPDF 0 1)
          (ae_of_all _ (fun x => ProbabilityTheory.gaussianPDF_lt_top)))
      hIntegral := by
        intro f
        simpa only [smul_eq_mul] using
          (ProbabilityTheory.integral_gaussianReal_eq_integral_smul
            (μ := (0 : ℝ)) (v := (1 : NNReal)) (f := f) (by norm_num))
      hConstMul := MeasureTheory.integral_const_mul
      hExp := _root_.integrable_exp_neg_mul_sq
      hGaussian := _root_.integral_gaussian
      hIff := _root_.integrable_exp_neg_mul_sq_iff }
  constructor
  · intro hsmall
    exact ⟨standardNormalSquareMGF_integrable lam hsmall
        p,
      standardNormalSquareMGF_value lam hsmall p⟩
  · intro hlarge
    exact standardNormalSquareMGF_not_integrable lam hlarge p

/-! Exercise 2.5.1: exact standard-normal `Lᵖ` moments and a uniform
`O(√p)` estimate.  The norm statement uses Mathlib's root-free `eLpNorm'`
representation, while the growth companion exposes the equivalent real
integral form used by the source calculation. -/
theorem standardNormalLpNorm (p : ℝ) (hp : 1 ≤ p) :
    (eLpNorm' (fun x : ℝ => x) p (gaussianReal 0 1)).toReal =
      (2 ^ (p / 2) * Real.Gamma ((1 + p) / 2) / Real.Gamma (1 / 2)) ^ (1 / p) := by
  have hp0 : 0 < p := lt_of_lt_of_le zero_lt_one hp
  have hpm : 0 ≤ p := hp0.le
  have hInt : Integrable (fun x : ℝ => |x| ^ p) (gaussianReal 0 1) :=
    integrable_rpow_abs_of_integrable_exp_mul (t := (1 : ℝ)) one_ne_zero
      (integrable_exp_mul_gaussianReal (μ := (0 : ℝ)) (v := (1 : NNReal)) 1)
      (integrable_exp_mul_gaussianReal (μ := (0 : ℝ)) (v := (1 : NNReal)) (-1)) hpm
  have hnonneg : 0 ≤ᶠ[ae (gaussianReal 0 1)] (fun x : ℝ => |x| ^ p) :=
    Filter.Eventually.of_forall (fun x => Real.rpow_nonneg (abs_nonneg x) p)
  have hlin :
      (∫⁻ x : ℝ, ‖(fun y : ℝ => y) x‖ₑ ^ p ∂(gaussianReal 0 1)) =
        ENNReal.ofReal (∫ x : ℝ, |x| ^ p ∂(gaussianReal 0 1)) := by
    calc
      (∫⁻ x : ℝ, ‖(fun y : ℝ => y) x‖ₑ ^ p ∂(gaussianReal 0 1)) =
          ∫⁻ x : ℝ, ENNReal.ofReal (|x| ^ p) ∂(gaussianReal 0 1) := by
            apply lintegral_congr
            intro x
            rw [Real.enorm_eq_ofReal_abs]
            rw [ENNReal.ofReal_rpow_of_nonneg (abs_nonneg x) hpm]
      _ = ENNReal.ofReal (∫ x : ℝ, |x| ^ p ∂(gaussianReal 0 1)) :=
        (MeasureTheory.ofReal_integral_eq_lintegral_ofReal hInt hnonneg).symm
  rw [MeasureTheory.eLpNorm'_eq_lintegral_enorm, hlin, ← ENNReal.toReal_rpow,
    ENNReal.toReal_ofReal (integral_nonneg (fun x =>
      Real.rpow_nonneg (abs_nonneg x) p))]
  congr 1
  rw [ProbabilityTheory.integral_gaussianReal_eq_integral_smul (μ := (0 : ℝ))
    (v := (1 : NNReal)) (f := fun x : ℝ => |x| ^ p) (by norm_num)]
  simp_rw [smul_eq_mul]
  rw [show (fun x : ℝ =>
      gaussianPDFReal 0 1 x * |x| ^ p) =
      (fun x : ℝ =>
        (Real.sqrt (2 * Real.pi))⁻¹ *
          (|x| ^ p * Real.exp (-x ^ 2 / 2))) by
    funext x
    have hpdf :
        gaussianPDFReal 0 1 x =
          (Real.sqrt (2 * Real.pi))⁻¹ * Real.exp (-x ^ 2 / 2) := by
      simp [gaussianPDFReal]
    rw [hpdf]
    ring]
  rw [integral_const_mul]
  have habs :
      (∫ x : ℝ, |x| ^ p * Real.exp (-x ^ 2 / 2)) =
        2 * ∫ x : ℝ in Set.Ioi 0, x ^ p * Real.exp (-x ^ 2 / 2) := by
    calc
      (∫ x : ℝ, |x| ^ p * Real.exp (-x ^ 2 / 2)) =
          ∫ x : ℝ, (|x| ^ p * Real.exp (-|x| ^ 2 / 2)) := by
            apply integral_congr_ae
            filter_upwards [] with x
            rw [sq_abs]
      _ = 2 * ∫ x : ℝ in Set.Ioi 0, x ^ p * Real.exp (-x ^ 2 / 2) := by
        exact integral_comp_abs (f := fun x : ℝ =>
          x ^ p * Real.exp (-x ^ 2 / 2))
  rw [habs]
  have hgamma := integral_rpow_mul_exp_neg_mul_rpow (p := (2 : ℝ))
    (q := p) (b := (1 / 2 : ℝ)) (by norm_num) (by linarith) (by norm_num)
  have hgamma' :
      ∫ x : ℝ in Set.Ioi 0, x ^ p * Real.exp (-x ^ 2 / 2) =
        (1 / 2) ^ (-(p + 1) / 2) * (1 / 2) * Real.Gamma ((p + 1) / 2) := by
    calc
      (∫ x : ℝ in Set.Ioi 0, x ^ p * Real.exp (-x ^ 2 / 2)) =
          ∫ x : ℝ in Set.Ioi 0, x ^ p * Real.exp (-(1 / 2) * x ^ 2) := by
            apply setIntegral_congr_fun measurableSet_Ioi
            intro x hx
            dsimp
            rw [show -x ^ 2 / 2 = -(1 / 2) * x ^ 2 by ring]
            have hx2 : x ^ (2 : ℝ) = x ^ (2 : ℕ) := by
              norm_num [Real.rpow_natCast]
            rw [hx2]
      _ = _ := hgamma
  rw [hgamma']
  have hsqrt : 0 < Real.sqrt (2 * Real.pi) := by positivity
  have hgamma0 : 0 < Real.Gamma (1 / 2) :=
    Real.Gamma_pos_of_pos (by norm_num)
  have hgammaP : 0 < Real.Gamma ((p + 1) / 2) :=
    Real.Gamma_pos_of_pos (by linarith)
  rw [show (1 + p) / 2 = (p + 1) / 2 by ring]
  have hpi : Real.Gamma (1 / 2) = Real.sqrt Real.pi := by
    exact Real.Gamma_one_half_eq
  rw [hpi]
  field_simp [hsqrt.ne', hgamma0.ne']
  rw [show (1 / 2 : ℝ) ^ (-((p + 1) / 2)) =
      2 ^ ((p + 1) / 2) by
    rw [show (1 / 2 : ℝ) = (2 : ℝ)⁻¹ by ring,
      Real.inv_rpow (by positivity : (0 : ℝ) ≤ 2),
      Real.rpow_neg (by positivity : (0 : ℝ) ≤ 2)]
    simp]
  rw [Real.sqrt_mul (by norm_num : (0 : ℝ) ≤ 2)]
  simp only [Real.sqrt_eq_rpow]
  rw [show (p + 1) / 2 = p / 2 + 1 / 2 by ring,
    Real.rpow_add (by norm_num : (0 : ℝ) < 2)]
  ring

theorem standardNormalLpNormGrowth :
    ∃ C : ℝ, 0 < C ∧
      ∀ p : ℝ, 1 ≤ p →
        (∫ x : ℝ, |x| ^ p ∂(gaussianReal 0 1)) ^ (1 / p) ≤ C * Real.sqrt p := by
  refine ⟨2 * Real.exp 1, by positivity, ?_⟩
  intro p hp
  have hp0 : 0 < p := lt_of_lt_of_le zero_lt_one hp
  have hpm : 0 ≤ p := hp0.le
  have hq : 0 < Real.sqrt p := Real.sqrt_pos.2 hp0
  have hq2 : (Real.sqrt p) ^ 2 = p := Real.sq_sqrt hpm
  have hdiv : p / Real.sqrt p = Real.sqrt p := by
    apply (div_eq_iff hq.ne').2
    nlinarith [hq2]
  have hInt : Integrable (fun x : ℝ => |x| ^ p) (gaussianReal 0 1) :=
    integrable_rpow_abs_of_integrable_exp_mul (t := (1 : ℝ)) one_ne_zero
      (integrable_exp_mul_gaussianReal (μ := (0 : ℝ)) (v := (1 : NNReal)) 1)
      (integrable_exp_mul_gaussianReal (μ := (0 : ℝ)) (v := (1 : NNReal)) (-1)) hpm
  have hplus : Integrable (fun x : ℝ => Real.exp (Real.sqrt p * x))
      (gaussianReal 0 1) :=
    integrable_exp_mul_gaussianReal (μ := (0 : ℝ)) (v := (1 : NNReal)) _
  have hminus : Integrable (fun x : ℝ => Real.exp (-Real.sqrt p * x))
      (gaussianReal 0 1) :=
    integrable_exp_mul_gaussianReal (μ := (0 : ℝ)) (v := (1 : NNReal)) _
  have hsum : Integrable (fun x : ℝ =>
      Real.exp (Real.sqrt p * x) + Real.exp (-Real.sqrt p * x))
      (gaussianReal 0 1) := hplus.add hminus
  have hpoint : ∀ x : ℝ, |x| ^ p ≤
      (p / Real.sqrt p) ^ p *
        (Real.exp (Real.sqrt p * x) + Real.exp (-Real.sqrt p * x)) := by
    intro x
    have h := rpow_abs_le_mul_max_exp x hpm hq.ne'
    rw [abs_of_pos hq] at h
    calc
      |x| ^ p ≤ (p / Real.sqrt p) ^ p *
          max (Real.exp (Real.sqrt p * x)) (Real.exp (-Real.sqrt p * x)) := by
            simpa using h
      _ ≤ (p / Real.sqrt p) ^ p *
          (Real.exp (Real.sqrt p * x) + Real.exp (-Real.sqrt p * x)) := by
            apply mul_le_mul_of_nonneg_left
            · exact max_le
                (le_add_of_nonneg_right (Real.exp_nonneg _))
                (le_add_of_nonneg_left (Real.exp_nonneg _))
            · positivity
  have hprod : Integrable (fun x : ℝ =>
      (p / Real.sqrt p) ^ p *
        (Real.exp (Real.sqrt p * x) + Real.exp (-Real.sqrt p * x)))
      (gaussianReal 0 1) := hsum.const_mul _
  have hbound := integral_mono_ae hInt hprod
    (Filter.Eventually.of_forall hpoint)
  have hsumEval :
      (∫ x : ℝ, Real.exp (Real.sqrt p * x) +
        Real.exp (-Real.sqrt p * x) ∂(gaussianReal 0 1)) =
        2 * Real.exp (p / 2) := by
    rw [integral_add hplus hminus, standardNormalMGF, standardNormalMGF]
    simp [hq2]
    ring
  have hbound' :
      (∫ x : ℝ, |x| ^ p ∂(gaussianReal 0 1)) ≤
        (Real.sqrt p) ^ p * (2 * Real.exp (p / 2)) := by
    calc
      (∫ x : ℝ, |x| ^ p ∂(gaussianReal 0 1)) ≤
          (p / Real.sqrt p) ^ p *
            (∫ x : ℝ, Real.exp (Real.sqrt p * x) +
              Real.exp (-Real.sqrt p * x) ∂(gaussianReal 0 1)) := by
        simpa [integral_const_mul] using hbound
      _ = (Real.sqrt p) ^ p * (2 * Real.exp (p / 2)) := by
        rw [hsumEval, hdiv]
  have hB : 2 * Real.exp (p / 2) ≤ (2 * Real.exp 1) ^ p := by
    have htwo : (2 : ℝ) ≤ 2 ^ p := by
      simpa using Real.rpow_le_rpow_of_exponent_le (x := (2 : ℝ))
        (y := (1 : ℝ)) (z := p) (by norm_num) hp
    have hexp : Real.exp (p / 2) ≤ Real.exp p := by
      exact Real.exp_le_exp.2 (by linarith)
    calc
      2 * Real.exp (p / 2) ≤ 2 ^ p * Real.exp p :=
        mul_le_mul htwo hexp (by positivity) (by positivity)
      _ = (2 * Real.exp 1) ^ p := by
        rw [Real.mul_rpow (by norm_num) (by positivity), Real.exp_one_rpow]
  have hroot := Real.rpow_le_rpow
    (integral_nonneg (fun x => Real.rpow_nonneg (abs_nonneg x) p)) hbound'
      (one_div_pos.mpr hp0).le
  calc
    (∫ x : ℝ, |x| ^ p ∂(gaussianReal 0 1)) ^ (1 / p) ≤
        ((Real.sqrt p) ^ p * (2 * Real.exp (p / 2))) ^ (1 / p) := hroot
    _ = Real.sqrt p * (2 * Real.exp (p / 2)) ^ (1 / p) := by
      rw [Real.mul_rpow (by positivity : (0 : ℝ) ≤ (Real.sqrt p) ^ p)
        (by positivity), ← Real.rpow_mul hq.le]
      congr 1
      field_simp
      simp
    _ ≤ 2 * Real.exp 1 * Real.sqrt p := by
      have hBroot : (2 * Real.exp (p / 2)) ^ (1 / p) ≤
          ((2 * Real.exp 1) ^ p) ^ (1 / p) :=
        Real.rpow_le_rpow (by positivity) hB (one_div_pos.mpr hp0).le
      have hCroot : ((2 * Real.exp 1) ^ p) ^ (1 / p) =
          2 * Real.exp 1 := by
        rw [← Real.rpow_mul (by positivity : (0 : ℝ) ≤ 2 * Real.exp 1)]
        field_simp
        simp
      rw [hCroot] at hBroot
      calc
        Real.sqrt p * (2 * Real.exp (p / 2)) ^ (1 / p) ≤
            Real.sqrt p * (2 * Real.exp 1) :=
          mul_le_mul_of_nonneg_left hBroot hq.le
        _ = 2 * Real.exp 1 * Real.sqrt p := by ring

/-! A coarse universal Gamma estimate used by the tail-to-moment conversion. -/
theorem gammaUpperBound {x : ℝ} (hx : 1 / 2 ≤ x) :
    Real.Gamma x ≤ 4 * x ^ x := by
  have hxpos : 0 < x := by linarith
  by_cases hx1 : x ≤ 1
  · have hgamma : Real.Gamma x ≤ Real.Gamma (1 / 2) :=
      Real.Gamma_strictAntiOn_Ioc.antitoneOn
        (by norm_num)
        (by exact ⟨hxpos, hx1⟩)
        hx
    have hpow : x ≤ x ^ x := by
      have h := Real.rpow_le_rpow_of_exponent_ge
        (x := x) (y := (1 : ℝ)) (z := x) hxpos hx1 hx1
      simpa [Real.rpow_one] using h
    rw [Real.Gamma_one_half_eq] at hgamma
    have hsqrt : Real.sqrt Real.pi ≤ 2 := by
      rw [Real.sqrt_le_iff]
      constructor <;> nlinarith [Real.pi_le_four]
    nlinarith
  · have hxgt : 1 < x := lt_of_not_ge hx1
    by_cases hx2 : x ≤ 2
    · have hconv : ConvexOn ℝ (Set.Ioi 0) Real.Gamma := Real.convexOn_Gamma
      rcases hconv with ⟨_, hineq⟩
      have h := hineq (x := (1 : ℝ)) (y := (2 : ℝ))
          (show (1 : ℝ) ∈ Set.Ioi 0 by norm_num)
          (show (2 : ℝ) ∈ Set.Ioi 0 by norm_num)
          (a := 2 - x) (b := x - 1)
          (by linarith) (by linarith) (by ring)
      have hgamma : Real.Gamma x ≤ 1 := by
        have harg : (2 - x) • (1 : ℝ) + (x - 1) • (2 : ℝ) = x := by
          simp [smul_eq_mul]
          ring
        have hrhs : (2 - x) • Real.Gamma (1 : ℝ) +
            (x - 1) • Real.Gamma (2 : ℝ) = 1 := by
          rw [Real.Gamma_one, Real.Gamma_two]
          simp [smul_eq_mul]
          ring
        rw [← harg]
        exact h.trans_eq hrhs
      have hpow : 1 ≤ x ^ x := Real.one_le_rpow (le_of_lt hxgt) (by positivity)
      nlinarith
    · have hxgt2 : 2 < x := lt_of_not_ge hx2
      let n : ℕ := Nat.floor x
      have hnle : (n : ℝ) ≤ x := by
        dsimp [n]
        exact Nat.floor_le hxpos.le
      have hxlt : x < (n : ℝ) + 1 := by
        dsimp [n]
        exact Nat.lt_floor_add_one x
      have hn2 : 2 ≤ n := by
        by_contra hn
        have hn1 : n ≤ 1 := by omega
        have hn1' : (n : ℝ) ≤ 1 := by exact_mod_cast hn1
        nlinarith
      have hconv : ConvexOn ℝ (Set.Ioi 0) Real.Gamma := Real.convexOn_Gamma
      rcases hconv with ⟨_, hineq⟩
      have h := hineq (x := (n : ℝ)) (y := (n : ℝ) + 1)
          (show (n : ℝ) ∈ Set.Ioi 0 by
            exact Set.mem_Ioi.mpr (by exact_mod_cast (show 0 < n by omega)))
          (show (n : ℝ) + 1 ∈ Set.Ioi 0 by
            exact Set.mem_Ioi.mpr (by positivity))
          (a := (n : ℝ) + 1 - x) (b := x - (n : ℝ))
          (by linarith) (by linarith) (by ring)
      have hmono : Real.Gamma (n : ℝ) ≤ Real.Gamma ((n : ℝ) + 1) := by
        apply Real.Gamma_strictMonoOn_Ici.monotoneOn
        · exact Set.mem_Ici.mpr (by exact_mod_cast hn2)
        · exact Set.mem_Ici.mpr (by exact_mod_cast (show 2 ≤ n + 1 by omega))
        · linarith
      have hgamma : Real.Gamma x ≤ Real.Gamma ((n : ℝ) + 1) := by
        calc
          Real.Gamma x ≤
              ((n : ℝ) + 1 - x) * Real.Gamma (n : ℝ) +
                (x - (n : ℝ)) * Real.Gamma ((n : ℝ) + 1) := by
            have harg : ((n : ℝ) + 1 - x) • (n : ℝ) +
                (x - (n : ℝ)) • ((n : ℝ) + 1) = x := by
              simp [smul_eq_mul]
              ring
            calc
              Real.Gamma x = Real.Gamma
                  (((n : ℝ) + 1 - x) • (n : ℝ) +
                    (x - (n : ℝ)) • ((n : ℝ) + 1)) := congrArg Real.Gamma harg.symm
              _ ≤ ((n : ℝ) + 1 - x) • Real.Gamma (n : ℝ) +
                    (x - (n : ℝ)) • Real.Gamma ((n : ℝ) + 1) := h
              _ = ((n : ℝ) + 1 - x) * Real.Gamma (n : ℝ) +
                    (x - (n : ℝ)) * Real.Gamma ((n : ℝ) + 1) := by
                simp [smul_eq_mul]
          _ ≤ ((n : ℝ) + 1 - x) * Real.Gamma ((n : ℝ) + 1) +
                (x - (n : ℝ)) * Real.Gamma ((n : ℝ) + 1) := by
            gcongr
            linarith
          _ = Real.Gamma ((n : ℝ) + 1) := by
            rw [← add_mul]
            ring
      rw [Real.Gamma_nat_eq_factorial n] at hgamma
      have hfac : (n.factorial : ℝ) ≤ (n : ℝ) ^ n := by
        exact_mod_cast Nat.factorial_le_pow n
      have hbase : (n : ℝ) ^ n ≤ x ^ n := by
        gcongr
      have hexp : x ^ (n : ℝ) ≤ x ^ x := by
        apply Real.rpow_le_rpow_of_exponent_le
        · linarith
        · exact hnle
      have hpow : (n : ℝ) ^ n ≤ x ^ x := by
        calc
          (n : ℝ) ^ n ≤ x ^ n := hbase
          _ = x ^ (n : ℝ) := by rw [Real.rpow_natCast]
          _ ≤ x ^ x := hexp
      nlinarith

/-- The root-free integral form of the usual `Lᵖ` moment-growth hypothesis. -/
def LpMomentGrowth {Ω : Type*} [MeasurableSpace Ω] (μ : Measure Ω)
    (X : Ω → ℝ) (K : ℝ) : Prop :=
  AEMeasurable X μ ∧
    ∀ p : ℝ, 1 ≤ p →
      Integrable (fun ω => |X ω| ^ p) μ ∧
        (∫ ω, |X ω| ^ p ∂μ) ≤ (K * Real.sqrt p) ^ p

/-! The tail-to-moment direction of Proposition 2.5.2. -/
theorem tailToAbsoluteMoment
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ} (hX : Measurable X) (hK : 0 < K)
    (hTail : ∀ t : ℝ, 0 ≤ t →
      μ {ω | t < |X ω|} ≤ ENNReal.ofReal (2 * Real.exp (-t ^ 2 / K ^ 2)))
    (p : ℝ) (hp : 1 ≤ p) :
    NumStability.HDP.Scalar.Preliminaries.absoluteMoment μ X p ≤
      ENNReal.ofReal ((8 * Real.exp 1 * K * Real.sqrt p) ^ p) := by
  have hp0 : 0 < p := lt_of_lt_of_le zero_lt_one hp
  have hformula := NumStability.HDP.Scalar.Preliminaries.momentTailFormula
    (μ := μ) (X := X) hX hp0
  have hupper :
      (∫⁻ t in Set.Ioi 0,
        μ {ω | t < |X ω|} * ENNReal.ofReal (t ^ (p - 1))) ≤
        ∫⁻ t in Set.Ioi 0,
          ENNReal.ofReal (2 * Real.exp (-t ^ 2 / K ^ 2)) *
            ENNReal.ofReal (t ^ (p - 1)) := by
    apply MeasureTheory.setLIntegral_mono
    · fun_prop
    · intro t ht
      exact mul_le_mul_left (hTail t (le_of_lt (Set.mem_Ioi.mp ht))) _
  have hInt : IntegrableOn
      (fun t : ℝ => t ^ (p - 1) * Real.exp (-(K⁻¹ ^ 2) * t ^ 2)) (Set.Ioi 0) := by
    apply integrableOn_rpow_mul_exp_neg_mul_sq
    · positivity
    · linarith
  have hscale : ∀ t : ℝ,
      ENNReal.ofReal (2 * Real.exp (-t ^ 2 / K ^ 2)) *
          ENNReal.ofReal (t ^ (p - 1)) =
        ENNReal.ofReal (2 * (t ^ (p - 1) *
          Real.exp (-(K⁻¹ ^ 2) * t ^ 2))) := by
    intro t
    calc
      ENNReal.ofReal (2 * Real.exp (-t ^ 2 / K ^ 2)) *
          ENNReal.ofReal (t ^ (p - 1)) =
        ENNReal.ofReal ((2 * Real.exp (-t ^ 2 / K ^ 2)) *
          (t ^ (p - 1))) := (ENNReal.ofReal_mul (by positivity)).symm
      _ = ENNReal.ofReal (2 * (t ^ (p - 1) *
          Real.exp (-(K⁻¹ ^ 2) * t ^ 2))) := by
        congr 1
        field_simp
  have hInt2 : IntegrableOn
      (fun t : ℝ => 2 * (t ^ (p - 1) *
        Real.exp (-(K⁻¹ ^ 2) * t ^ 2))) (Set.Ioi 0) := hInt.const_mul _
  have hEq2 := MeasureTheory.ofReal_integral_eq_lintegral_ofReal hInt2
    (by
      filter_upwards [MeasureTheory.ae_restrict_mem measurableSet_Ioi] with t ht
      have ht0 : 0 < t := Set.mem_Ioi.mp ht
      positivity)
  have hGamma := integral_rpow_mul_exp_neg_mul_rpow
    (p := (2 : ℝ)) (q := p - 1) (b := K⁻¹ ^ 2) (by norm_num) (by linarith) (by positivity)
  have hIntEval :
      (∫ t in Set.Ioi 0,
        t ^ (p - 1) * Real.exp (-(K⁻¹ ^ 2) * t ^ 2)) =
        (K⁻¹ ^ 2) ^ (-p / 2) * (1 / 2) * Real.Gamma (p / 2) := by
    simpa [mul_comm] using hGamma
  have hupperEval :
      (∫⁻ t in Set.Ioi 0,
        ENNReal.ofReal (2 * Real.exp (-t ^ 2 / K ^ 2)) *
          ENNReal.ofReal (t ^ (p - 1))) ≤
        ENNReal.ofReal (2 * ((K⁻¹ ^ 2) ^ (-p / 2) *
          (1 / 2) * Real.Gamma (p / 2))) := by
    rw [MeasureTheory.setLIntegral_congr_fun measurableSet_Ioi
      (fun t _ => hscale t)]
    rw [← hEq2, MeasureTheory.integral_const_mul, hIntEval]
  have hGammaBound : Real.Gamma (p / 2) ≤ 4 * (p / 2) ^ (p / 2) :=
    gammaUpperBound (by linarith)
  have hcalc :
      ENNReal.ofReal p * ENNReal.ofReal
          (2 * ((K⁻¹ ^ 2) ^ (-p / 2) * (1 / 2) * Real.Gamma (p / 2))) ≤
        ENNReal.ofReal ((8 * Real.exp 1 * K * Real.sqrt p) ^ p) := by
    rw [← ENNReal.ofReal_mul (by positivity : 0 ≤ p)]
    apply ENNReal.ofReal_le_ofReal
    have hKpow : (K⁻¹ ^ 2) ^ (-p / 2) = K ^ p := by
      rw [← Real.rpow_natCast, ← Real.rpow_mul (by positivity : 0 ≤ K⁻¹)]
      rw [show (↑(2 : ℕ) : ℝ) * (-p / 2) = -p by norm_num; ring]
      rw [Real.inv_rpow (by positivity : 0 ≤ K)]
      rw [Real.rpow_neg (by positivity : 0 ≤ K)]
      simp
    rw [hKpow]
    have hexp : p ≤ Real.exp p := by
      nlinarith [Real.add_one_le_exp p]
    have hroot : 0 ≤ Real.sqrt p := by positivity
    have hgam : 0 ≤ Real.Gamma (p / 2) :=
      (Real.Gamma_pos_of_pos (by linarith)).le
    have hpowp : 0 ≤ p ^ (p / 2) := by positivity
    have hbase : (p / 2) ^ (p / 2) ≤ p ^ (p / 2) := by
      apply Real.rpow_le_rpow
      · positivity
      · linarith
      · positivity
    have hmulGamma : p * K ^ p * Real.Gamma (p / 2) ≤
        p * K ^ p * (4 * (p / 2) ^ (p / 2)) := by
      exact mul_le_mul_of_nonneg_left hGammaBound (by positivity)
    have hmulBase : 4 * p * K ^ p * (p / 2) ^ (p / 2) ≤
        4 * p * K ^ p * p ^ (p / 2) := by
      exact mul_le_mul_of_nonneg_left hbase (by positivity)
    have hcoef : 4 * p ≤ 8 * Real.exp p := by
      nlinarith [hexp, Real.exp_pos p]
    have hmulCoef : 4 * p * K ^ p * p ^ (p / 2) ≤
        8 * Real.exp p * K ^ p * p ^ (p / 2) := by
      exact mul_le_mul_of_nonneg_right
        (mul_le_mul_of_nonneg_right hcoef (by positivity)) (by positivity)
    have hstep : 2 * p * (K ^ p * (1 / 2) * Real.Gamma (p / 2)) ≤
        8 * Real.exp p * K ^ p * p ^ (p / 2) := by
      calc
        2 * p * (K ^ p * (1 / 2) * Real.Gamma (p / 2)) =
            p * K ^ p * Real.Gamma (p / 2) := by ring
        _ ≤ p * K ^ p * (4 * (p / 2) ^ (p / 2)) := hmulGamma
        _ = 4 * p * K ^ p * (p / 2) ^ (p / 2) := by ring
        _ ≤ 4 * p * K ^ p * p ^ (p / 2) := hmulBase
        _ ≤ 8 * Real.exp p * K ^ p * p ^ (p / 2) := hmulCoef
    have hpnonneg : 0 ≤ p := by linarith
    have h8 : (8 : ℝ) ≤ (8 : ℝ) ^ p := by
      have h := Real.rpow_le_rpow_of_exponent_le
        (x := (8 : ℝ)) (y := (1 : ℝ)) (z := p) (by norm_num) hp
      simpa using h
    have hexprpow : Real.exp p = (Real.exp 1) ^ p := by
      rw [Real.rpow_def_of_pos (Real.exp_pos 1), Real.log_exp]
      congr 1
      ring
    have hconst0 : 8 * Real.exp p ≤ (8 * Real.exp 1) ^ p := by
      calc
        8 * Real.exp p ≤ 8 ^ p * Real.exp p :=
          mul_le_mul_of_nonneg_right h8 (Real.exp_pos p).le
        _ = 8 ^ p * (Real.exp 1) ^ p := by rw [hexprpow]
        _ = (8 * Real.exp 1) ^ p := by
          rw [Real.mul_rpow (by norm_num) (by positivity)]
    have hconst : 8 * Real.exp p * K ^ p * p ^ (p / 2) ≤
        (8 * Real.exp 1 * K * Real.sqrt p) ^ p := by
      have h8e : 0 ≤ (8 : ℝ) * Real.exp 1 := by positivity
      have h8eK : 0 ≤ (8 : ℝ) * Real.exp 1 * K := by positivity
      calc
        8 * Real.exp p * K ^ p * p ^ (p / 2) =
            (8 * Real.exp p) * (K ^ p * p ^ (p / 2)) := by ring
        _ ≤ (8 * Real.exp 1) ^ p * (K ^ p * p ^ (p / 2)) := by
          exact mul_le_mul_of_nonneg_right hconst0 (by positivity)
        _ = (8 * Real.exp 1) ^ p * (K ^ p * (Real.sqrt p) ^ p) := by
          rw [Real.sqrt_eq_rpow, ← Real.rpow_mul (by positivity : 0 ≤ p)]
          congr 2
          ring
        _ = (8 * Real.exp 1 * K * Real.sqrt p) ^ p := by
          rw [Real.mul_rpow h8eK (by positivity), Real.mul_rpow h8e (by positivity)]
          ring
    simpa [mul_assoc, mul_left_comm, mul_comm] using hstep.trans hconst
  calc
    NumStability.HDP.Scalar.Preliminaries.absoluteMoment μ X p =
        ENNReal.ofReal p *
          (∫⁻ t in Set.Ioi 0,
            μ {ω | t < |X ω|} * ENNReal.ofReal (t ^ (p - 1))) := hformula.1
    _ ≤ ENNReal.ofReal p *
          (∫⁻ t in Set.Ioi 0,
            ENNReal.ofReal (2 * Real.exp (-t ^ 2 / K ^ 2)) *
              ENNReal.ofReal (t ^ (p - 1))) :=
      mul_le_mul_right hupper _
    _ ≤ ENNReal.ofReal p * ENNReal.ofReal
          (2 * ((K⁻¹ ^ 2) ^ (-p / 2) * (1 / 2) * Real.Gamma (p / 2))) :=
      mul_le_mul_right hupperEval _
    _ ≤ ENNReal.ofReal ((8 * Real.exp 1 * K * Real.sqrt p) ^ p) := hcalc

theorem tailToLpMomentGrowth
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ} (hX : Measurable X) (hK : 0 < K)
    (hTail : ∀ t : ℝ, 0 ≤ t →
      μ.real {ω | |X ω| ≥ t} ≤ 2 * Real.exp (-t ^ 2 / K ^ 2)) :
    LpMomentGrowth μ X (8 * Real.exp 1 * K) := by
  have hTail' : ∀ t : ℝ, 0 ≤ t →
      μ {ω | t < |X ω|} ≤ ENNReal.ofReal (2 * Real.exp (-t ^ 2 / K ^ 2)) := by
    intro t ht
    let A : Set Ω := {ω | t < |X ω|}
    let B : Set Ω := {ω | |X ω| ≥ t}
    have hAB : A ⊆ B := by
      intro ω hω
      change t < |X ω| at hω
      change t ≤ |X ω|
      exact le_of_lt hω
    have hB : μ B ≤ ENNReal.ofReal (2 * Real.exp (-t ^ 2 / K ^ 2)) := by
      rw [← ENNReal.ofReal_toReal (measure_ne_top μ B)]
      apply ENNReal.ofReal_le_ofReal
      simpa [B, MeasureTheory.measureReal_def] using hTail t ht
    exact (measure_mono hAB).trans hB
  refine ⟨hX.aemeasurable, ?_⟩
  intro p hp
  have hmoment := tailToAbsoluteMoment hX hK hTail' p hp
  have hfinite :
      NumStability.HDP.Scalar.Preliminaries.absoluteMoment μ X p < (⊤ : ENNReal) :=
    lt_of_le_of_lt hmoment (by simp)
  have hmeas : AEMeasurable (fun ω => |X ω| ^ p) μ := by
    fun_prop
  have hInt : Integrable (fun ω => |X ω| ^ p) μ := by
    refine ⟨hmeas.aestronglyMeasurable, ?_⟩
    rw [hasFiniteIntegral_iff_norm]
    change (∫⁻ ω, ENNReal.ofReal ‖|X ω| ^ p‖ ∂μ) < (⊤ : ENNReal)
    convert hfinite using 1
    apply MeasureTheory.lintegral_congr_ae
    filter_upwards [] with ω
    rw [Real.norm_eq_abs, abs_of_nonneg (Real.rpow_nonneg (abs_nonneg _) _)]
    rfl
  constructor
  · exact hInt
  · have hEq := MeasureTheory.ofReal_integral_eq_lintegral_ofReal hInt
      (Filter.Eventually.of_forall (fun ω => by positivity))
    have hbound : ENNReal.ofReal (∫ ω, |X ω| ^ p ∂μ) ≤
        ENNReal.ofReal ((8 * Real.exp 1 * K * Real.sqrt p) ^ p) := by
      calc
        ENNReal.ofReal (∫ ω, |X ω| ^ p ∂μ) =
            NumStability.HDP.Scalar.Preliminaries.absoluteMoment μ X p := by
          simpa [NumStability.HDP.Scalar.Preliminaries.absoluteMoment,
            Real.norm_eq_abs] using hEq
        _ ≤ ENNReal.ofReal ((8 * Real.exp 1 * K * Real.sqrt p) ^ p) := hmoment
    exact (ENNReal.ofReal_le_ofReal_iff (by positivity)).mp hbound

/-! The moment-to-square-MGF implication from Proposition 2.5.2. -/

/-- Bounds every positive even absolute moment at a sub-Gaussian scale. -/
def EvenMomentBound {Ω : Type*} [MeasurableSpace Ω] (μ : Measure Ω)
    (X : Ω → ℝ) (K : ℝ) : Prop :=
  ∀ n : ℕ, 1 ≤ n →
    Integrable (fun ω => |X ω| ^ (2 * n)) μ ∧
      (∫ ω, |X ω| ^ (2 * n) ∂μ) ≤ K ^ (2 * n) * (2 * n : ℝ) ^ n

/-- The `n`th nonnegative term in the square-MGF power series. -/
def squareMGFTerm {Ω : Type*} (X : Ω → ℝ) (lam : ℝ) (n : ℕ) (ω : Ω) : ENNReal :=
  ENNReal.ofReal (((lam ^ 2 * X ω ^ 2) ^ n) / (n.factorial : ℝ))

lemma squareMGFTerm_aemeasurable
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} {X : Ω → ℝ}
    (hX : AEMeasurable X μ) (lam : ℝ) (n : ℕ) :
    AEMeasurable (squareMGFTerm X lam n) μ := by
  unfold squareMGFTerm
  fun_prop

lemma exp_series_pointwise (x : ℝ) (hx : 0 ≤ x) :
    ENNReal.ofReal (Real.exp x) =
      ∑' n : ℕ, ENNReal.ofReal (x ^ n / (n.factorial : ℝ)) := by
  rw [← ENNReal.ofReal_tsum_of_nonneg (fun n => by positivity)
    (NormedSpace.expSeries_div_summable x)]
  rw [NormedSpace.expSeries_div_hasSum_exp x |>.tsum_eq]
  rw [← Real.exp_eq_exp_ℝ]

lemma geom_bound (q : ℝ) (hq0 : 0 ≤ q) (hq : q ≤ 1 / 2) :
    (∑' n : ℕ, q ^ n) ≤ Real.exp (2 * q) := by
  have hqlt : q < 1 := lt_of_le_of_lt hq (by norm_num)
  have hsum := (hasSum_geometric_of_lt_one hq0 hqlt).tsum_eq
  rw [hsum]
  have hden : 0 < 1 - q := sub_pos.mpr hqlt
  have hrat : (1 - q)⁻¹ ≤ 1 + 2 * q := by
    rw [inv_eq_one_div]
    apply (div_le_iff₀ hden).2
    nlinarith [mul_nonneg hq0 (sub_nonneg.mpr (by linarith : q ≤ 1 / 2))]
  exact hrat.trans (by simpa [add_comm] using Real.add_one_le_exp (2 * q))

lemma factorial_ratio_bound (n : ℕ) (hn : 1 ≤ n) :
    ((2 * n : ℝ) ^ n) / (n.factorial : ℝ) ≤ (2 * Real.exp 1) ^ n := by
  have hfac := Stirling.le_factorial_stirling n
  have hroot : 1 ≤ Real.sqrt (2 * Real.pi * (n : ℝ)) := by
    rw [Real.one_le_sqrt]
    have hpi : (2 : ℝ) ≤ Real.pi := by
      nlinarith [Real.one_le_pi_div_two]
    have hnpos : (0 : ℝ) < (n : ℝ) := by
      exact_mod_cast (show 0 < n by omega)
    have hn1' : (1 : ℝ) ≤ (n : ℝ) := by exact_mod_cast hn
    have hpn : 2 * (n : ℝ) ≤ Real.pi * n :=
      mul_le_mul_of_nonneg_right hpi (le_of_lt hnpos)
    have hn1 : (1 : ℝ) ≤ 2 * (n : ℝ) := by nlinarith
    have hprod : (1 : ℝ) ≤ Real.pi * n := hn1.trans hpn
    nlinarith [hprod]
  have hn0 : (0 : ℝ) ≤ n := Nat.cast_nonneg n
  have hepos : 0 < Real.exp 1 := Real.exp_pos _
  have hbase : 0 ≤ (n : ℝ) / Real.exp 1 := by positivity
  have hfac' : (n : ℝ) ^ n / (Real.exp 1) ^ n ≤ (n.factorial : ℝ) := by
    have hfac'' := (le_trans (mul_le_mul_of_nonneg_right hroot
      (by positivity : 0 ≤ ((n : ℝ) / Real.exp 1) ^ n)) hfac)
    simpa [div_pow] using hfac''
  have hmul : (n : ℝ) ^ n ≤ (n.factorial : ℝ) * (Real.exp 1) ^ n := by
    rw [← div_le_iff₀ (by positivity : 0 < (Real.exp 1) ^ n)]
    simpa [div_pow] using hfac'
  have hmul' : (2 * n : ℝ) ^ n ≤ (n.factorial : ℝ) * (2 * Real.exp 1) ^ n := by
    rw [mul_pow]
    calc
      2 ^ n * (n : ℝ) ^ n ≤ 2 ^ n * ((n.factorial : ℝ) * (Real.exp 1) ^ n) :=
        mul_le_mul_of_nonneg_left hmul (by positivity)
      _ = (n.factorial : ℝ) * (2 * Real.exp 1) ^ n := by
        rw [mul_pow]
        ring
  exact (div_le_iff₀ (by positivity : (0 : ℝ) < (n.factorial : ℝ))).2
    (by simpa [mul_comm] using hmul')

lemma squareMGFTerm_eq_mul
    {Ω : Type*} (X : Ω → ℝ) (lam : ℝ) (n : ℕ) (ω : Ω) :
    squareMGFTerm X lam n ω =
      ENNReal.ofReal ((lam ^ 2) ^ n / (n.factorial : ℝ)) *
        ENNReal.ofReal (|X ω| ^ (2 * n)) := by
  unfold squareMGFTerm
  rw [← ENNReal.ofReal_mul (by positivity :
    0 ≤ (lam ^ 2) ^ n / (n.factorial : ℝ))]
  congr 1
  rw [mul_pow]
  have hXsq : X ω ^ 2 = |X ω| ^ 2 := (sq_abs _).symm
  rw [hXsq, ← pow_mul]
  ring

lemma evenMomentBound_of_lpMomentGrowth
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} {X : Ω → ℝ} {K : ℝ}
    (hLp : LpMomentGrowth μ X K) : EvenMomentBound μ X K := by
  intro n hn
  have hp := hLp.2 (2 * (n : ℝ)) (by
    have hn' : (1 : ℝ) ≤ n := by exact_mod_cast hn
    nlinarith)
  have hpn : 2 * (n : ℝ) = ((2 * n : ℕ) : ℝ) := by norm_num
  have hfun : (fun ω => |X ω| ^ (2 * (n : ℝ))) =
      (fun ω => |X ω| ^ (2 * n : ℕ)) := by
    funext ω
    rw [hpn, Real.rpow_natCast]
  rw [hfun] at hp
  have heq : (K * Real.sqrt (2 * (n : ℝ))) ^ (2 * (n : ℕ)) =
      K ^ (2 * (n : ℕ)) * (2 * (n : ℝ)) ^ n := by
    rw [mul_pow, pow_mul, pow_mul]
    rw [Real.sq_sqrt (by positivity : (0 : ℝ) ≤ 2 * (n : ℝ))]
  constructor
  · exact hp.1
  · calc
      (∫ ω, |X ω| ^ (2 * n) ∂μ) ≤
          (K * Real.sqrt (2 * (n : ℝ))) ^ (2 * (n : ℝ)) := hp.2
      _ = (K * Real.sqrt (2 * (n : ℝ))) ^ (2 * n : ℕ) := by
        rw [hpn, Real.rpow_natCast]
      _ = K ^ (2 * n) * (2 * (n : ℝ)) ^ n := heq

lemma squareMGFTerm_lintegral_le_geom
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} {X : Ω → ℝ} {K lam : ℝ}
    (hMom : EvenMomentBound μ X K) {n : ℕ} (hn : 1 ≤ n) :
    (∫⁻ ω, squareMGFTerm X lam n ω ∂μ) ≤
      ENNReal.ofReal ((2 * Real.exp 1 * (lam * K) ^ 2) ^ n) := by
  have hm := hMom n hn
  have hterm := squareMGFTerm_eq_mul X lam n
  rw [lintegral_congr_ae (Filter.Eventually.of_forall (fun ω => hterm ω))]
  rw [lintegral_const_mul' _ _ (by simp)]
  rw [← ofReal_integral_eq_lintegral_ofReal hm.1
    (Filter.Eventually.of_forall (fun ω => by positivity))]
  have hscalar : 0 ≤ (lam ^ 2) ^ n / (n.factorial : ℝ) := by positivity
  have hbound := mul_le_mul_of_nonneg_left hm.2 hscalar
  rw [← ENNReal.ofReal_mul hscalar]
  apply ENNReal.ofReal_le_ofReal
  calc
    (lam ^ 2) ^ n / (n.factorial : ℝ) *
          (∫ ω, |X ω| ^ (2 * n) ∂μ) ≤
        (lam ^ 2) ^ n / (n.factorial : ℝ) *
          (K ^ (2 * n) * (2 * n : ℝ) ^ n) := hbound
    _ = ((lam * K) ^ (2 * n) * (2 * n : ℝ) ^ n) /
          (n.factorial : ℝ) := by ring
    _ ≤ (2 * Real.exp 1 * (lam * K) ^ 2) ^ n := by
      have hratio := factorial_ratio_bound n hn
      have hnonneg : 0 ≤ (lam * K) ^ (2 * n) := by
        rw [pow_mul]
        positivity
      apply (div_le_iff₀ (by positivity : (0 : ℝ) < (n.factorial : ℝ))).2
      have hratio' : (2 * n : ℝ) ^ n ≤ (2 * Real.exp 1) ^ n * (n.factorial : ℝ) :=
        (div_le_iff₀ (by positivity : (0 : ℝ) < (n.factorial : ℝ))).mp hratio
      calc
        (lam * K) ^ (2 * n) * (2 * n : ℝ) ^ n ≤
            (lam * K) ^ (2 * n) * ((2 * Real.exp 1) ^ n * (n.factorial : ℝ)) := by
              gcongr
        _ = (2 * Real.exp 1 * (lam * K) ^ 2) ^ n * (n.factorial : ℝ) := by
              calc
                (lam * K) ^ (2 * n) * ((2 * Real.exp 1) ^ n * (n.factorial : ℝ)) =
                    ((lam * K) ^ 2) ^ n * (2 * Real.exp 1) ^ n * (n.factorial : ℝ) := by
                      rw [pow_mul]
                      ring
                _ = (2 * Real.exp 1 * (lam * K) ^ 2) ^ n * (n.factorial : ℝ) := by
                      rw [← mul_pow]
                      ring

lemma squareMGF_lintegral_le
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K lam : ℝ}
    (hX : AEMeasurable X μ) (hK : 0 ≤ K)
    (hMom : EvenMomentBound μ X K) (hsmall : |lam| * K ≤ 1 / 4) :
    (∫⁻ ω, ENNReal.ofReal (Real.exp (lam ^ 2 * X ω ^ 2)) ∂μ) ≤
      ENNReal.ofReal (Real.exp (4 * Real.exp 1 * (lam * K) ^ 2)) := by
  let q : ℝ := 2 * Real.exp 1 * (lam * K) ^ 2
  have hprod : |lam * K| ≤ 1 / 4 := by
    rw [abs_mul, abs_of_nonneg hK]
    exact hsmall
  have hsq : (lam * K) ^ 2 ≤ (1 / 4 : ℝ) ^ 2 := by
    apply (sq_le_sq (a := lam * K) (b := (1 / 4 : ℝ))).2
    simpa using hprod
  have hq0 : 0 ≤ q := by positivity
  have hqhalf : q ≤ 1 / 2 := by
    have hfirst : q ≤ 2 * Real.exp 1 * (1 / 4 : ℝ) ^ 2 := by
      dsimp [q]
      exact mul_le_mul_of_nonneg_left hsq (by positivity)
    have hexp : Real.exp 1 ≤ 3 := Real.exp_one_lt_three.le
    nlinarith [hfirst]
  have hqsum : Summable (fun n : ℕ => q ^ n) := by
    exact (hasSum_geometric_of_lt_one hq0
      (lt_of_le_of_lt hqhalf (by norm_num))).summable
  have hterm_sum :
      (∑' n : ℕ, ∫⁻ ω, squareMGFTerm X lam n ω ∂μ) ≤
        ∑' n : ℕ, ENNReal.ofReal (q ^ n) := by
    apply ENNReal.tsum_le_tsum
    intro n
    cases n with
    | zero => simp [squareMGFTerm]
    | succ n =>
        simpa [q] using
          (squareMGFTerm_lintegral_le_geom hMom (n := n + 1) (by omega))
  calc
    (∫⁻ ω, ENNReal.ofReal (Real.exp (lam ^ 2 * X ω ^ 2)) ∂μ) =
        ∫⁻ ω, ∑' n : ℕ, squareMGFTerm X lam n ω ∂μ := by
          apply lintegral_congr_ae
          filter_upwards [] with ω
          exact exp_series_pointwise (lam ^ 2 * X ω ^ 2) (by positivity)
    _ = ∑' n : ℕ, ∫⁻ ω, squareMGFTerm X lam n ω ∂μ := by
          apply lintegral_tsum
          intro n
          exact squareMGFTerm_aemeasurable hX lam n
    _ ≤ ∑' n : ℕ, ENNReal.ofReal (q ^ n) := hterm_sum
    _ = ENNReal.ofReal (∑' n : ℕ, q ^ n) := by
          symm
          exact ENNReal.ofReal_tsum_of_nonneg (fun n => by positivity) hqsum
    _ ≤ ENNReal.ofReal (Real.exp (2 * q)) :=
          ENNReal.ofReal_le_ofReal (geom_bound q hq0 hqhalf)
    _ = ENNReal.ofReal (Real.exp (4 * Real.exp 1 * (lam * K) ^ 2)) := by
          congr 2
          dsimp [q]
          ring

lemma squareMGF_real_le
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K lam : ℝ}
    (hX : AEMeasurable X μ) (hK : 0 ≤ K)
    (hMom : EvenMomentBound μ X K) (hsmall : |lam| * K ≤ 1 / 4) :
    Integrable (fun ω => Real.exp (lam ^ 2 * X ω ^ 2)) μ ∧
      (∫ ω, Real.exp (lam ^ 2 * X ω ^ 2) ∂μ) ≤
        Real.exp (4 * Real.exp 1 * (lam * K) ^ 2) := by
  have hbound := squareMGF_lintegral_le hX hK hMom hsmall
  have hmeas : AEMeasurable (fun ω => Real.exp (lam ^ 2 * X ω ^ 2)) μ := by
    fun_prop
  have hfinite :
      (∫⁻ ω, ‖Real.exp (lam ^ 2 * X ω ^ 2)‖ₑ ∂μ) < (⊤ : ENNReal) := by
    have htop : ENNReal.ofReal (Real.exp (4 * Real.exp 1 * (lam * K) ^ 2)) <
        (⊤ : ENNReal) :=
      ENNReal.ofReal_lt_top
    refine lt_of_le_of_lt ?_ htop
    simpa only [← ofReal_norm_eq_enorm, Real.norm_eq_abs,
      abs_of_pos (Real.exp_pos _)] using hbound
  have hInt : Integrable (fun ω => Real.exp (lam ^ 2 * X ω ^ 2)) μ :=
    ⟨hmeas.aestronglyMeasurable, (hasFiniteIntegral_iff_enorm).2 hfinite⟩
  refine ⟨hInt, ?_⟩
  have hEq := ofReal_integral_eq_lintegral_ofReal hInt
    (Filter.Eventually.of_forall (fun ω => (Real.exp_pos _).le))
  rw [← hEq] at hbound
  exact (ENNReal.ofReal_le_ofReal_iff (Real.exp_nonneg _)).mp hbound

/-! If the `Lᵖ` moments grow like `K * sqrt p`, then the square-exponential
MGF is bounded on the source's local scale. The displayed constants come from
the Stirling lower bound and the resulting geometric series. -/
theorem momentToSquareMGF
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ} (hK : 0 < K)
    (hLp : LpMomentGrowth μ X K) (lam : ℝ)
    (hsmall : |lam| ≤ (4 * K)⁻¹) :
    Integrable (fun ω => Real.exp (lam ^ 2 * X ω ^ 2)) μ ∧
      (∫ ω, Real.exp (lam ^ 2 * X ω ^ 2) ∂μ) ≤
        Real.exp (4 * Real.exp 1 * (lam * K) ^ 2) := by
  have hsmall' : |lam| * K ≤ 1 / 4 := by
    calc
      |lam| * K ≤ (4 * K)⁻¹ * K :=
        mul_le_mul_of_nonneg_right hsmall hK.le
      _ = 1 / 4 := by field_simp
  exact squareMGF_real_le hLp.1 hK.le
    (evenMomentBound_of_lpMomentGrowth hLp) hsmall'

lemma exp_le_add_exp_sq (x : ℝ) :
    Real.exp x ≤ x + Real.exp (x ^ 2) := by
  have hcosh (y : ℝ) : Real.cosh y ≤ Real.exp (y ^ 2 / 2) :=
    Real.cosh_le_exp_half_sq y
  rcases le_total x 0 with hx | hx
  · have hy : 0 ≤ -x := neg_nonneg.mpr hx
    have hs : -x ≤ Real.sinh (-x) := (Real.self_le_sinh_iff).2 hy
    have hmain : Real.exp x - x ≤ Real.cosh (-x) := by
      rw [Real.cosh_eq]
      simp only [neg_neg]
      have hpos : 0 < Real.exp (-x) := Real.exp_pos _
      have hident : Real.exp x = (Real.exp (-x))⁻¹ := by
        simpa using (Real.exp_neg (-x))
      rw [hident]
      rw [Real.sinh_eq] at hs
      simp only [neg_neg] at hs
      rw [hident] at hs
      field_simp at hs ⊢
      nlinarith [hs]
    have hhalf : Real.exp ((-x) ^ 2 / 2) ≤ Real.exp ((-x) ^ 2) := by
      rw [Real.exp_le_exp]
      nlinarith [sq_nonneg x]
    have hsq : (-x) ^ 2 = x ^ 2 := by ring
    have hchain : Real.cosh (-x) ≤ Real.exp (x ^ 2) := by
      exact (hcosh (-x)).trans (by simpa [hsq] using hhalf)
    linarith [hmain, hchain]
  · have hcoshsub : Real.cosh x - Real.sinh x = Real.exp (-x) :=
      Real.cosh_sub_sinh x
    have hs : Real.sinh x - x ≤ Real.cosh x - 1 := by
      have he : 1 - x ≤ Real.exp (-x) := by
        simpa [sub_eq_add_neg, add_comm] using (Real.add_one_le_exp (-x))
      linarith [hcoshsub]
    have hmain : Real.exp x - x ≤ 2 * Real.cosh x - 1 := by
      rw [← Real.cosh_add_sinh x]
      linarith
    have hsq : 2 * Real.cosh x - 1 ≤ Real.exp (x ^ 2) := by
      have hc := hcosh x
      have hp : 0 ≤ Real.exp (x ^ 2 / 2) := Real.exp_nonneg _
      have hsquare : (Real.exp (x ^ 2 / 2) - 1) ^ 2 ≥ 0 := sq_nonneg _
      have hexp : Real.exp (x ^ 2 / 2) ^ 2 = Real.exp (x ^ 2) := by
        calc
          Real.exp (x ^ 2 / 2) ^ 2 =
              Real.exp (x ^ 2 / 2) * Real.exp (x ^ 2 / 2) := by ring
          _ = Real.exp (x ^ 2 / 2 + x ^ 2 / 2) := by rw [Real.exp_add]
          _ = Real.exp (x ^ 2) := by congr 1; ring
      rw [← hexp]
      nlinarith
    linarith [hmain, hsq]

lemma exp_le_abs_add_exp_sq (x : ℝ) :
    Real.exp x ≤ |x| + Real.exp (x ^ 2) := by
  exact (exp_le_add_exp_sq x).trans (by
    simpa [add_comm] using add_le_add_right (le_abs_self x) (Real.exp (x ^ 2)))

/-- A local exponential-square moment bound on the unit parameter window. -/
def SquareMGFLocal {Ω : Type*} [MeasurableSpace Ω] (μ : Measure Ω)
    (X : Ω → ℝ) (C : ℝ) : Prop :=
  AEMeasurable X μ ∧
    ∀ t : ℝ, |t| ≤ 1 →
      Integrable (fun ω => Real.exp (t ^ 2 * X ω ^ 2)) μ ∧
        (∫ ω, Real.exp (t ^ 2 * X ω ^ 2) ∂μ) ≤ Real.exp (C * t ^ 2)

lemma integrable_exp_mul_of_square
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    {X : Ω → ℝ} (hX : AEMeasurable X μ) (hIntX : Integrable X μ)
    {a : ℝ} (hSq : Integrable (fun ω => Real.exp (a ^ 2 * X ω ^ 2)) μ) :
    Integrable (fun ω => Real.exp (a * X ω)) μ := by
  have hdom : Integrable (fun ω => |a| * |X ω| +
      Real.exp (a ^ 2 * X ω ^ 2)) μ := by
    have hlin : Integrable (fun ω => |a| * |X ω|) μ :=
      hIntX.norm.const_mul |a|
    exact hlin.add hSq
  refine MeasureTheory.Integrable.mono' hdom ?_ ?_
  · fun_prop
  filter_upwards [] with ω
  have hpoint := exp_le_abs_add_exp_sq (a * X ω)
  have hposExp : 0 < Real.exp (a * X ω) := Real.exp_pos _
  simpa only [Real.norm_eq_abs, abs_of_pos hposExp, abs_mul, mul_pow] using hpoint

/-! A centered local square-MGF bound implies a global linear MGF bound. -/
theorem squareMGFToMGF
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {C : ℝ} (hC : 0 ≤ C)
    (hCenter : Integrable X μ ∧ (∫ ω, X ω ∂μ) = 0)
    (hSquare : SquareMGFLocal μ X C) (lam : ℝ) :
    Integrable (fun ω => Real.exp (lam * X ω)) μ ∧
      (∫ ω, Real.exp (lam * X ω) ∂μ) ≤
        Real.exp ((C + 1 / 2) * lam ^ 2) := by
  by_cases hsmall : |lam| ≤ 1
  · have hsq := hSquare.2 lam hsmall
    have hInt := integrable_exp_mul_of_square hSquare.1 hCenter.1 hsq.1
    refine ⟨hInt, ?_⟩
    have hlin : Integrable (fun ω => lam * X ω) μ := hCenter.1.const_mul lam
    have hsum : Integrable (fun ω => lam * X ω +
        Real.exp (lam ^ 2 * X ω ^ 2)) μ := hlin.add hsq.1
    have hmono := MeasureTheory.integral_mono_ae hInt hsum
      (Filter.Eventually.of_forall (fun ω => by
        have hpoint := exp_le_add_exp_sq (lam * X ω)
        convert hpoint using 1; ring))
    calc
      (∫ ω, Real.exp (lam * X ω) ∂μ) ≤
          ∫ ω, lam * X ω + Real.exp (lam ^ 2 * X ω ^ 2) ∂μ := hmono
      _ = lam * (∫ ω, X ω ∂μ) +
          ∫ ω, Real.exp (lam ^ 2 * X ω ^ 2) ∂μ := by
            rw [integral_add hlin hsq.1, integral_const_mul]
      _ = ∫ ω, Real.exp (lam ^ 2 * X ω ^ 2) ∂μ := by
            rw [hCenter.2]
            ring
      _ ≤ Real.exp (C * lam ^ 2) := hsq.2
      _ ≤ Real.exp ((C + 1 / 2) * lam ^ 2) := by
            apply Real.exp_le_exp.mpr
            nlinarith [sq_nonneg lam]
  · have hlam : 1 < |lam| := lt_of_not_ge hsmall
    have hlam2 : 1 ≤ lam ^ 2 := by
      have hsquare := sq_abs lam
      nlinarith
    have hsq := hSquare.2 1 (by norm_num)
    have hInt : Integrable (fun ω => Real.exp (lam * X ω)) μ := by
      have hdom : Integrable (fun ω => Real.exp (lam ^ 2 / 2) *
          Real.exp (X ω ^ 2)) μ := by
        simpa using hsq.1.const_mul (Real.exp (lam ^ 2 / 2))
      refine MeasureTheory.Integrable.mono' hdom
        ((hSquare.1.const_mul lam).exp.aestronglyMeasurable) ?_
      filter_upwards [] with ω
      have hyoung : lam * X ω ≤ lam ^ 2 / 2 + X ω ^ 2 / 2 := by
        nlinarith [sq_nonneg (lam - X ω)]
      have hpos : 0 < Real.exp (lam * X ω) := Real.exp_pos _
      rw [Real.norm_eq_abs, abs_of_pos hpos]
      calc
        Real.exp (lam * X ω) ≤ Real.exp (lam ^ 2 / 2 + X ω ^ 2 / 2) :=
          Real.exp_le_exp.mpr hyoung
        _ = Real.exp (lam ^ 2 / 2) * Real.exp (X ω ^ 2 / 2) := by
          rw [Real.exp_add]
        _ ≤ Real.exp (lam ^ 2 / 2) * Real.exp (X ω ^ 2) := by
          gcongr
          nlinarith [sq_nonneg (X ω)]
    refine ⟨hInt, ?_⟩
    have hdom : Integrable (fun ω => Real.exp (lam ^ 2 / 2) *
        Real.exp (X ω ^ 2)) μ := by
      simpa using hsq.1.const_mul (Real.exp (lam ^ 2 / 2))
    have hmono := MeasureTheory.integral_mono_ae hInt hdom
      (Filter.Eventually.of_forall (fun ω => by
        have hyoung : lam * X ω ≤ lam ^ 2 / 2 + X ω ^ 2 / 2 := by
          nlinarith [sq_nonneg (lam - X ω)]
        calc
          Real.exp (lam * X ω) ≤ Real.exp (lam ^ 2 / 2 + X ω ^ 2 / 2) :=
            Real.exp_le_exp.mpr hyoung
          _ = Real.exp (lam ^ 2 / 2) * Real.exp (X ω ^ 2 / 2) := by
            rw [Real.exp_add]
          _ ≤ Real.exp (lam ^ 2 / 2) * Real.exp (X ω ^ 2) := by
            gcongr
            nlinarith [sq_nonneg (X ω)]))
    calc
      (∫ ω, Real.exp (lam * X ω) ∂μ) ≤
          ∫ ω, Real.exp (lam ^ 2 / 2) * Real.exp (X ω ^ 2) ∂μ := hmono
      _ = Real.exp (lam ^ 2 / 2) *
          (∫ ω, Real.exp (X ω ^ 2) ∂μ) := by rw [integral_const_mul]
      _ ≤ Real.exp (lam ^ 2 / 2) * Real.exp C := by
        gcongr
        simpa using hsq.2
      _ = Real.exp (lam ^ 2 / 2 + C) := by
        rw [Real.exp_add]
      _ ≤ Real.exp ((C + 1 / 2) * lam ^ 2) := by
            apply Real.exp_le_exp.mpr
            have hprod : 0 ≤ C * (lam ^ 2 - 1) :=
              mul_nonneg hC (sub_nonneg.mpr hlam2)
            nlinarith

/-! The square-MGF tail conversion used by the sub-Gaussian equivalences. -/
theorem squareMGFToTail
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ}
    (hX : Measurable X) (hK : 0 < K)
    (hMGF : Integrable (fun ω => Real.exp (X ω ^ 2 / K ^ 2)) μ ∧
      (∫ ω, Real.exp (X ω ^ 2 / K ^ 2) ∂μ) ≤ 2)
    {t : ℝ} (ht : 0 ≤ t) :
    μ.real {ω | |X ω| ≥ t} ≤ 2 * Real.exp (-t ^ 2 / K ^ 2) := by
  let Y : Ω → ℝ := fun ω => Real.exp (X ω ^ 2 / K ^ 2)
  have hY : Measurable Y := by
    simpa [Y] using (hX.pow_const 2).div_const (K ^ 2) |>.exp
  have hY_nonneg : ∀ᵐ ω ∂μ, 0 ≤ Y ω :=
    Filter.Eventually.of_forall (fun ω => le_of_lt (Real.exp_pos _))
  have hKsq : 0 ≤ K ^ 2 := (sq_pos_of_pos hK).le
  have hmarkov :=
    NumStability.HDP.Scalar.Preliminaries.markovInequalityFinite
      hY hY_nonneg hMGF.1 (Real.exp_pos (t ^ 2 / K ^ 2))
  have hsubset : {ω | |X ω| ≥ t} ⊆
      Y ⁻¹' Set.Ici (Real.exp (t ^ 2 / K ^ 2)) := by
    intro ω hω
    change Real.exp (t ^ 2 / K ^ 2) ≤ Real.exp (X ω ^ 2 / K ^ 2)
    apply (Real.exp_le_exp).2
    apply (div_le_div_of_nonneg_right _ hKsq)
    have habs : |t| ≤ |X ω| := by simpa [abs_of_nonneg ht] using hω
    exact (sq_le_sq).mpr habs
  have hmono {A B : Set Ω} (hAB : A ⊆ B) :
      μ.real A ≤ μ.real B := by
    rw [Measure.real_def, Measure.real_def]
    exact ENNReal.toReal_mono (measure_ne_top μ B) (measure_mono hAB)
  calc
    μ.real {ω | |X ω| ≥ t} ≤ μ.real (Y ⁻¹' Set.Ici (Real.exp (t ^ 2 / K ^ 2))) :=
      hmono hsubset
    _ ≤ (∫ ω, Y ω ∂μ) / Real.exp (t ^ 2 / K ^ 2) := by
      simpa [NumStability.HDP.Scalar.Preliminaries.expectation] using hmarkov
    _ ≤ 2 / Real.exp (t ^ 2 / K ^ 2) := by
      exact div_le_div_of_nonneg_right hMGF.2 (le_of_lt (Real.exp_pos _))
    _ = 2 * Real.exp (-t ^ 2 / K ^ 2) := by
      rw [div_eq_mul_inv, ← Real.exp_neg]
      ring

/-! Exercise 2.5.5(b): a square-MGF bound valid for every real parameter
forces the variable to have no mass beyond the corresponding deterministic
threshold.  We retain the tail-zero form, which is the measure-theoretic
meaning of the source's essential boundedness conclusion. -/
theorem squareMGFGlobalTailZero
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ}
    (hX : Measurable X) (hK : 0 ≤ K)
    (hMGF : ∀ lam : ℝ,
      Integrable (fun ω => Real.exp (lam ^ 2 * X ω ^ 2)) μ ∧
        (∫ ω, Real.exp (lam ^ 2 * X ω ^ 2) ∂μ) ≤ Real.exp (K * lam ^ 2))
    {t : ℝ} (ht : 0 ≤ t) (hthreshold : K < t ^ 2) :
    μ.real {ω | |X ω| ≥ t} = 0 := by
  have hgap : 0 < t ^ 2 - K := sub_pos.mpr hthreshold
  have hbound : ∀ n : ℕ,
      μ.real {ω | |X ω| ≥ t} ≤
        Real.exp (-((n : ℝ) ^ 2) * (t ^ 2 - K)) := by
    intro n
    by_cases hn : n = 0
    · subst n
      have hprob : μ.real {ω | |X ω| ≥ t} ≤ 1 := by
        rw [Measure.real_def]
        exact ENNReal.toReal_mono ENNReal.one_ne_top prob_le_one
      simpa using hprob
    · let a : ℝ := (n : ℝ) ^ 2
      let Y : Ω → ℝ := fun ω => Real.exp (a * X ω ^ 2)
      have ha : 0 < a := by
        dsimp [a]
        positivity
      have hY : Measurable Y := by
        dsimp [Y]
        fun_prop
      have hmarkov :=
        NumStability.HDP.Scalar.Preliminaries.markovInequalityFinite
          (μ := μ) hY
          (Filter.Eventually.of_forall (fun ω => le_of_lt (Real.exp_pos _)))
          (by simpa [Y, a] using (hMGF (n : ℝ)).1)
          (Real.exp_pos (a * t ^ 2))
      have hsubset : {ω | |X ω| ≥ t} ⊆
          Y ⁻¹' Set.Ici (Real.exp (a * t ^ 2)) := by
        intro ω hω
        change Real.exp (a * t ^ 2) ≤ Real.exp (a * X ω ^ 2)
        apply (Real.exp_le_exp).2
        apply mul_le_mul_of_nonneg_left _ ha.le
        exact (sq_le_sq).mpr (by simpa [abs_of_nonneg ht] using hω)
      have hmono {A B : Set Ω} (hAB : A ⊆ B) : μ.real A ≤ μ.real B := by
        rw [Measure.real_def, Measure.real_def]
        exact ENNReal.toReal_mono (measure_ne_top μ B) (measure_mono hAB)
      calc
        μ.real {ω | |X ω| ≥ t} ≤
            μ.real (Y ⁻¹' Set.Ici (Real.exp (a * t ^ 2))) := hmono hsubset
        _ ≤ (∫ ω, Y ω ∂μ) / Real.exp (a * t ^ 2) := by
          simpa [NumStability.HDP.Scalar.Preliminaries.expectation] using hmarkov
        _ ≤ Real.exp (K * a) / Real.exp (a * t ^ 2) := by
          apply div_le_div_of_nonneg_right _ (le_of_lt (Real.exp_pos _))
          simpa [Y, a] using (hMGF (n : ℝ)).2
        _ = Real.exp (-a * (t ^ 2 - K)) := by
          rw [div_eq_mul_inv, ← Real.exp_neg, ← Real.exp_add]
          congr 1
          ring
        _ = Real.exp (-((n : ℝ) ^ 2) * (t ^ 2 - K)) := by rfl
  have hpow : Tendsto (fun n : ℕ => (n : ℝ) ^ 2) atTop atTop := by
    exact (tendsto_pow_atTop (α := ℝ) (n := 2) (by norm_num)).comp
      tendsto_natCast_atTop_atTop
  have hscaled : Tendsto
      (fun n : ℕ => (t ^ 2 - K) * (n : ℝ) ^ 2) atTop atTop :=
    hpow.const_mul_atTop hgap
  have hlim : Tendsto
      (fun n : ℕ => Real.exp (-((n : ℝ) ^ 2) * (t ^ 2 - K))) atTop (𝓝 0) := by
    apply Real.tendsto_exp_atBot.comp
    simpa [Function.comp_def, mul_comm] using
      (tendsto_neg_atTop_atBot.comp hscaled)
  exact le_antisymm
    (le_of_tendsto_of_tendsto' tendsto_const_nhds hlim (fun n => hbound n))
    (by positivity)

/-! The two-sided tail conversion from an all-parameter linear MGF bound. -/
theorem mgfToTail
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ}
    (hX : Measurable X) (hK : 0 < K)
    (hMGF : ∀ lam : ℝ,
      Integrable (fun ω => Real.exp (lam * X ω)) μ ∧
        (∫ ω, Real.exp (lam * X ω) ∂μ) ≤ Real.exp (K ^ 2 * lam ^ 2))
    {t : ℝ} (ht : 0 ≤ t) :
    μ.real {ω | |X ω| ≥ t} ≤ 2 * Real.exp (-t ^ 2 / (4 * K ^ 2)) := by
  by_cases ht0 : t = 0
  · rw [ht0]
    have hprob : μ.real {ω | |X ω| ≥ 0} ≤ 1 := by
      rw [Measure.real_def]
      exact ENNReal.toReal_mono ENNReal.one_ne_top prob_le_one
    calc
      μ.real {ω | |X ω| ≥ 0} ≤ 1 := hprob
      _ ≤ 2 * Real.exp (-0 ^ 2 / (4 * K ^ 2)) := by
        simp
  have htpos : 0 < t := lt_of_le_of_ne ht (Ne.symm ht0)
  let lam : ℝ := t / (2 * K ^ 2)
  have hlam : 0 < lam := by
    dsimp [lam]
    positivity
  have hupper : μ.real {ω | X ω ≥ t} ≤
      Real.exp (-t ^ 2 / (4 * K ^ 2)) := by
    let Y : Ω → ℝ := fun ω => Real.exp (lam * X ω)
    have hY : Measurable Y := by
      simpa [Y] using (hX.const_mul lam).exp
    have hmarkov :=
      NumStability.HDP.Scalar.Preliminaries.markovInequalityFinite hY
        (Filter.Eventually.of_forall (fun ω => le_of_lt (Real.exp_pos _)))
        (hMGF lam).1 (Real.exp_pos (lam * t))
    have hsubset : {ω | X ω ≥ t} ⊆
        Y ⁻¹' Set.Ici (Real.exp (lam * t)) := by
      intro ω hω
      change Real.exp (lam * t) ≤ Real.exp (lam * X ω)
      exact (Real.exp_le_exp).2 (mul_le_mul_of_nonneg_left hω hlam.le)
    have hmono {A B : Set Ω} (hAB : A ⊆ B) :
        μ.real A ≤ μ.real B := by
      rw [Measure.real_def, Measure.real_def]
      exact ENNReal.toReal_mono (measure_ne_top μ B) (measure_mono hAB)
    calc
      μ.real {ω | X ω ≥ t} ≤ μ.real (Y ⁻¹' Set.Ici (Real.exp (lam * t))) :=
        hmono hsubset
      _ ≤ (∫ ω, Y ω ∂μ) / Real.exp (lam * t) := by
        simpa [NumStability.HDP.Scalar.Preliminaries.expectation] using hmarkov
      _ ≤ Real.exp (K ^ 2 * lam ^ 2) / Real.exp (lam * t) := by
        exact div_le_div_of_nonneg_right (hMGF lam).2 (le_of_lt (Real.exp_pos _))
      _ = Real.exp (-t ^ 2 / (4 * K ^ 2)) := by
        rw [div_eq_mul_inv, ← Real.exp_neg, ← Real.exp_add]
        congr 1
        dsimp [lam]
        field_simp [ne_of_gt hK]
        ring
  have hlower : μ.real {ω | -X ω ≥ t} ≤
      Real.exp (-t ^ 2 / (4 * K ^ 2)) := by
    let Y : Ω → ℝ := fun ω => Real.exp (lam * (-X ω))
    have hY : Measurable Y := by
      simpa [Y] using ((hX.neg.const_mul lam).exp)
    have hmarkov :=
      NumStability.HDP.Scalar.Preliminaries.markovInequalityFinite hY
        (Filter.Eventually.of_forall (fun ω => le_of_lt (Real.exp_pos _)))
        (by simpa [Y, mul_assoc] using (hMGF (-lam)).1)
        (Real.exp_pos (lam * t))
    have hsubset : {ω | -X ω ≥ t} ⊆
        Y ⁻¹' Set.Ici (Real.exp (lam * t)) := by
      intro ω hω
      change Real.exp (lam * t) ≤ Real.exp (lam * (-X ω))
      exact (Real.exp_le_exp).2 (mul_le_mul_of_nonneg_left hω hlam.le)
    have hmono {A B : Set Ω} (hAB : A ⊆ B) :
        μ.real A ≤ μ.real B := by
      rw [Measure.real_def, Measure.real_def]
      exact ENNReal.toReal_mono (measure_ne_top μ B) (measure_mono hAB)
    calc
      μ.real {ω | -X ω ≥ t} ≤ μ.real (Y ⁻¹' Set.Ici (Real.exp (lam * t))) :=
        hmono hsubset
      _ ≤ (∫ ω, Y ω ∂μ) / Real.exp (lam * t) := by
        simpa [NumStability.HDP.Scalar.Preliminaries.expectation] using hmarkov
      _ ≤ Real.exp (K ^ 2 * (-lam) ^ 2) / Real.exp (lam * t) := by
        exact div_le_div_of_nonneg_right (by simpa [Y, mul_assoc] using (hMGF (-lam)).2)
          (le_of_lt (Real.exp_pos _))
      _ = Real.exp (-t ^ 2 / (4 * K ^ 2)) := by
        rw [div_eq_mul_inv, ← Real.exp_neg, ← Real.exp_add]
        congr 1
        dsimp [lam]
        field_simp [ne_of_gt hK]
        ring
  have hsubset : {ω | |X ω| ≥ t} ⊆
      {ω | X ω ≥ t} ∪ {ω | -X ω ≥ t} := by
    intro ω hω
    change t ≤ |X ω| at hω
    change t ≤ X ω ∨ t ≤ -X ω
    by_cases h : t ≤ X ω
    · exact Or.inl h
    · right
      have hlt : X ω < t := lt_of_not_ge h
      by_contra hnot
      exact (not_lt_of_ge hω) ((abs_lt).2 (by constructor <;> linarith))
  have hunion : μ.real ({ω | X ω ≥ t} ∪ {ω | -X ω ≥ t}) ≤
      μ.real {ω | X ω ≥ t} + μ.real {ω | -X ω ≥ t} := by
    rw [Measure.real_def, Measure.real_def, Measure.real_def]
    calc
      (μ ({ω | X ω ≥ t} ∪ {ω | -X ω ≥ t})).toReal ≤
          (μ {ω | X ω ≥ t} + μ {ω | -X ω ≥ t}).toReal := by
        apply ENNReal.toReal_mono
        · exact ENNReal.add_ne_top.mpr ⟨measure_ne_top μ _, measure_ne_top μ _⟩
        · exact measure_union_le _ _
      _ = (μ {ω | X ω ≥ t}).toReal + (μ {ω | -X ω ≥ t}).toReal :=
        ENNReal.toReal_add (measure_ne_top μ _) (measure_ne_top μ _)
  calc
    μ.real {ω | |X ω| ≥ t} ≤
        μ.real ({ω | X ω ≥ t} ∪ {ω | -X ω ≥ t}) := by
      rw [Measure.real_def, Measure.real_def]
      exact ENNReal.toReal_mono (measure_ne_top μ _) (measure_mono hsubset)
    _ ≤ μ.real {ω | X ω ≥ t} + μ.real {ω | -X ω ≥ t} := hunion
    _ ≤ Real.exp (-t ^ 2 / (4 * K ^ 2)) +
        Real.exp (-t ^ 2 / (4 * K ^ 2)) := add_le_add hupper hlower
    _ = 2 * Real.exp (-t ^ 2 / (4 * K ^ 2)) := by ring

/-! The all-parameter MGF bound forces centering (Exercise 2.5.4). -/
theorem mgfBoundForcesMeanZero
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ}
    (hX : Integrable X μ)
    (hMGF : ∀ lam : ℝ,
      Integrable (fun ω => Real.exp (lam * X ω)) μ ∧
        (∫ ω, Real.exp (lam * X ω) ∂μ) ≤ Real.exp (K ^ 2 * lam ^ 2)) :
    (∫ ω, X ω ∂μ) = 0 := by
  let m : ℝ := ∫ ω, X ω ∂μ
  have hquad : ∀ lam : ℝ, lam * m ≤ K ^ 2 * lam ^ 2 := by
    intro lam
    have hconv : ConvexOn ℝ Set.univ (fun x : ℝ => Real.exp (lam * x)) := by
      have hcomp := convexOn_exp.comp_linearMap ((LinearMap.mul ℝ ℝ) lam)
      simpa [Function.comp_def] using hcomp
    have hjensen :=
      NumStability.HDP.Scalar.Preliminaries.jensenIntegral hconv hX (hMGF lam).1
    have hexp : Real.exp (lam * m) ≤ Real.exp (K ^ 2 * lam ^ 2) := by
      calc
        Real.exp (lam * m) ≤
            ∫ ω, Real.exp (lam * X ω) ∂μ := by
          simpa [m, NumStability.HDP.Scalar.Preliminaries.expectation,
            Function.comp_def] using hjensen
        _ ≤ Real.exp (K ^ 2 * lam ^ 2) := (hMGF lam).2
    exact Real.exp_le_exp.mp hexp
  by_contra hm
  have hm2 : 0 < m ^ 2 := sq_pos_of_ne_zero hm
  let d : ℝ := 2 * (K ^ 2 + 1)
  have hd : 0 < d := by
    dsimp [d]
    nlinarith [sq_nonneg K]
  have hbad := hquad (m / d)
  dsimp [d] at hbad
  field_simp [ne_of_gt hd] at hbad
  nlinarith [hm2, sq_nonneg K]

/-! Exercise 2.6.9: a finite two-point sub-Gaussian witness for the strict
inequality between the centered and uncentered `ψ₂` gauges.  The gauge below
is the exact Orlicz gauge for a two-point law, written after evaluating its
finite expectation. -/
/-- Admissibility of a ψ₂ scale for a two-point law. -/
def twoPointPsiTwoAdmissible (a b q t : ℝ) : Prop :=
  0 < t ∧ (1 - q) * Real.exp ((a / t) ^ 2) + q * Real.exp ((b / t) ^ 2) ≤ 2

/-- The infimum of admissible ψ₂ scales for a two-point law. -/
def twoPointPsiTwoNorm (a b q : ℝ) : ℝ :=
  sInf {t : ℝ | twoPointPsiTwoAdmissible a b q t}

lemma twoPointPsiTwoNorm_le_of_admissible {a b q t : ℝ}
    (ht : twoPointPsiTwoAdmissible a b q t) :
    twoPointPsiTwoNorm a b q ≤ t := by
  unfold twoPointPsiTwoNorm
  apply csInf_le
  · exact ⟨0, by intro s hs; exact le_of_lt hs.1⟩
  · exact ht

lemma twoPointPsiTwoNorm_ge_of_lower {a b q r : ℝ}
    (hS : Set.Nonempty {t : ℝ | twoPointPsiTwoAdmissible a b q t})
    (hLower : ∀ t, twoPointPsiTwoAdmissible a b q t → r ≤ t) :
    r ≤ twoPointPsiTwoNorm a b q := by
  unfold twoPointPsiTwoNorm
  apply le_csInf hS
  intro t ht
  exact hLower t ht

/-- The asymmetric two-point probability law used in Exercise 2.6.9. -/
def exercise269Law : Measure ℝ :=
  (999 / 1000 : ENNReal) • Measure.dirac (-1) +
    (1 / 1000 : ENNReal) • Measure.dirac 4

/-- The mean of `exercise269Law`. -/
def exercise269Mean : ℝ :=
  (999 / 1000 : ℝ) * (-1) + (1 / 1000 : ℝ) * 4

lemma exercise269Law_probability : IsProbabilityMeasure exercise269Law := by
  apply isProbabilityMeasure_iff.mpr
  simp [exercise269Law, ENNReal.div_eq_inv_mul]
  calc
    (1000 : ENNReal)⁻¹ * 999 + 1000⁻¹ = 1000⁻¹ * 999 + 1000⁻¹ * 1 := by
      rw [mul_one]
    _ = 1000⁻¹ * (999 + 1) := by rw [mul_add]
    _ = (1000 : ENNReal)⁻¹ * 1000 := by norm_num
    _ = 1 := by exact ENNReal.inv_mul_cancel (by norm_num) (by norm_num)

lemma exercise269Law_integral (f : ℝ → ℝ) :
    ∫ x, f x ∂exercise269Law = (999 / 1000 : ℝ) * f (-1) +
      (1 / 1000 : ℝ) * f 4 := by
  rw [exercise269Law, MeasureTheory.integral_add_measure]
  · rw [MeasureTheory.integral_smul_measure, MeasureTheory.integral_smul_measure,
      MeasureTheory.integral_dirac, MeasureTheory.integral_dirac]
    norm_num
  · apply Integrable.smul_measure
    · exact integrable_dirac (by simp)
    · apply ENNReal.mul_ne_top <;> simp
  · apply Integrable.smul_measure
    · exact integrable_dirac (by simp)
    · simp

lemma exercise269_raw_nonempty :
    Set.Nonempty {t : ℝ | twoPointPsiTwoAdmissible (-1) 4 (1 / 1000) t} := by
  refine ⟨10, ?_⟩
  constructor
  · norm_num
  have h₁ : Real.exp ((-1 / 10 : ℝ) ^ 2) ≤ 1 / (1 - (1 / 100 : ℝ)) := by
    convert Real.exp_bound_div_one_sub_of_interval (x := (1 / 100 : ℝ)) (by norm_num)
      (by norm_num) using 1; norm_num
  have h₂ : Real.exp ((4 / 10 : ℝ) ^ 2) ≤ 1 / (1 - (16 / 100 : ℝ)) := by
    convert Real.exp_bound_div_one_sub_of_interval (x := (16 / 100 : ℝ)) (by norm_num)
      (by norm_num) using 1; norm_num
  calc
    (1 - (1 / 1000 : ℝ)) * Real.exp ((-1 / 10 : ℝ) ^ 2) +
        (1 / 1000 : ℝ) * Real.exp ((4 / 10 : ℝ) ^ 2) ≤
        (1 - (1 / 1000 : ℝ)) * (1 / (1 - (1 / 100 : ℝ))) +
        (1 / 1000 : ℝ) * (1 / (1 - (16 / 100 : ℝ))) := by
          gcongr
    _ ≤ 2 := by norm_num

lemma exercise269_centered_nonempty :
    Set.Nonempty {t : ℝ | twoPointPsiTwoAdmissible (-1 / 200) (999 / 200)
      (1 / 1000) t} := by
  refine ⟨10, ?_⟩
  constructor
  · norm_num
  have h₁ : Real.exp ((-1 / 200 / 10 : ℝ) ^ 2) ≤
      1 / (1 - (1 / 4000000 : ℝ)) := by
    convert Real.exp_bound_div_one_sub_of_interval (x := (1 / 4000000 : ℝ)) (by norm_num)
      (by norm_num) using 1; norm_num
  have h₂ : Real.exp ((999 / 200 / 10 : ℝ) ^ 2) ≤
      1 / (1 - (998001 / 4000000 : ℝ)) := by
    convert Real.exp_bound_div_one_sub_of_interval (x := (998001 / 4000000 : ℝ))
      (by norm_num) (by norm_num) using 1; norm_num
  calc
    (1 - (1 / 1000 : ℝ)) * Real.exp ((-1 / 200 / 10 : ℝ) ^ 2) +
        (1 / 1000 : ℝ) * Real.exp ((999 / 200 / 10 : ℝ) ^ 2) ≤
        (1 - (1 / 1000 : ℝ)) * (1 / (1 - (1 / 4000000 : ℝ))) +
        (1 / 1000 : ℝ) * (1 / (1 - (998001 / 4000000 : ℝ))) := by
          gcongr
    _ ≤ 2 := by norm_num

lemma exercise269_exp_small : Real.exp (9 / 25 : ℝ) ≤ 3 / 2 := by
  apply (Real.le_log_iff_exp_le (by norm_num : (0 : ℝ) < 3 / 2)).mp
  have h := Real.le_log_one_add_of_nonneg (x := (1 / 2 : ℝ)) (by norm_num)
  norm_num at h ⊢
  linarith

lemma exercise269_exp_six : Real.exp (6 : ℝ) < 405 := by
  have hbase : Real.exp 1 < (2719 / 1000 : ℝ) := by
    exact lt_trans Real.exp_one_lt_d9 (by norm_num)
  have hpow : Real.exp 1 ^ 6 < (2719 / 1000 : ℝ) ^ 6 := by
    exact pow_lt_pow_left₀ hbase (by positivity) (by norm_num)
  calc
    Real.exp (6 : ℝ) = Real.exp 1 ^ 6 := by
      rw [← Real.exp_nat_mul 1 6]
      norm_num
    _ < (2719 / 1000 : ℝ) ^ 6 := hpow
    _ < 405 := by norm_num

lemma exercise269_raw_admissible :
    twoPointPsiTwoAdmissible (-1) 4 (1 / 1000) (5 / 3) := by
  constructor
  · norm_num
  have hsmall := exercise269_exp_small
  have hlarge : Real.exp (144 / 25 : ℝ) < 405 := by
    exact lt_of_le_of_lt ((Real.exp_le_exp).2 (by norm_num)) exercise269_exp_six
  norm_num only [one_div, sub_eq_add_neg]
  convert (show (999 / 1000 : ℝ) * Real.exp (9 / 25) +
      (1 / 1000 : ℝ) * Real.exp (144 / 25) ≤ 2 by
    nlinarith [hsmall, hlarge]) using 1

lemma exercise269_centered_lower :
    ∀ t, twoPointPsiTwoAdmissible (-1 / 200) (999 / 200) (1 / 1000) t →
      9 / 5 ≤ t := by
  intro t ht
  by_contra hnot
  have htpos : 0 < t := ht.1
  have htle : t ≤ 9 / 5 := le_of_not_ge hnot
  have ht_sq : t ^ 2 ≤ (9 / 5 : ℝ) ^ 2 := by
    have hnonneg : 0 ≤ (9 / 5 : ℝ) - t := by linarith
    have hsum : 0 ≤ (9 / 5 : ℝ) + t := by positivity
    nlinarith [mul_nonneg hnonneg hsum]
  have hfrac : (999 / 200 : ℝ) ^ 2 / (9 / 5 : ℝ) ^ 2 ≤
      (999 / 200 : ℝ) ^ 2 / t ^ 2 := by
    exact div_le_div_of_nonneg_left (sq_nonneg _) (sq_pos_of_pos htpos) ht_sq
  have hratio : (7 : ℝ) ≤ (999 / 200 / t) ^ 2 := by
    calc
      (7 : ℝ) ≤ (999 / 200 : ℝ) ^ 2 / (9 / 5 : ℝ) ^ 2 := by norm_num
      _ ≤ (999 / 200 : ℝ) ^ 2 / t ^ 2 := hfrac
      _ = (999 / 200 / t) ^ 2 := by field_simp
  have hexp7 : (1001 : ℝ) < Real.exp 7 := by
    have hbase : (27 / 10 : ℝ) < Real.exp 1 := by
      exact lt_trans (by norm_num) Real.exp_one_gt_d9
    have hpow : (27 / 10 : ℝ) ^ 7 < Real.exp 1 ^ 7 := by
      exact pow_lt_pow_left₀ hbase (by norm_num) (by norm_num)
    calc
      (1001 : ℝ) < (27 / 10 : ℝ) ^ 7 := by norm_num
      _ < Real.exp 1 ^ 7 := hpow
      _ = Real.exp 7 := by
        rw [← Real.exp_nat_mul 1 7]
        norm_num
  have hexp : (1001 : ℝ) < Real.exp ((999 / 200 / t) ^ 2) := by
    exact lt_of_lt_of_le hexp7 ((Real.exp_le_exp).2 hratio)
  have hsmall : (1 : ℝ) ≤ Real.exp ((-1 / 200 / t) ^ 2) :=
    Real.one_le_exp (sq_nonneg _)
  have hcontra : 2 <
      (1 - (1 / 1000 : ℝ)) * Real.exp ((-1 / 200 / t) ^ 2) +
        (1 / 1000 : ℝ) * Real.exp ((999 / 200 / t) ^ 2) := by
    nlinarith
  linarith [ht.2, hcontra]

theorem exercise269_counterexample :
    ∃ (μ : Measure ℝ) (X : ℝ → ℝ),
      IsProbabilityMeasure μ ∧
      μ = exercise269Law ∧
      X = (fun x : ℝ => x) ∧
      ∫ x, X x ∂μ = exercise269Mean ∧
      twoPointPsiTwoNorm (-1) 4 (1 / 1000) <
        twoPointPsiTwoNorm (-1 / 200) (999 / 200) (1 / 1000) := by
  have hraw := twoPointPsiTwoNorm_le_of_admissible exercise269_raw_admissible
  have hcenter := twoPointPsiTwoNorm_ge_of_lower exercise269_centered_nonempty
    exercise269_centered_lower
  have hmean : ∫ x, (fun x : ℝ => x) x ∂exercise269Law = exercise269Mean := by
    rw [exercise269Law_integral]
    norm_num [exercise269Mean]
  refine ⟨exercise269Law, (fun x : ℝ => x), exercise269Law_probability, rfl, rfl, ?_, ?_⟩
  · exact hmean
  · exact lt_of_le_of_lt hraw (lt_of_lt_of_le (by norm_num) hcenter)

/-! The `L²` interpolation estimate used in Exercise 2.6.6. -/
theorem lpExtrapolation
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] {Z : Ω → ℝ}
    (hZ1 : MemLp Z 1 μ) (hZ3 : MemLp Z 3 μ) :
    (∫ ω, |Z ω| ^ (2 : ℝ) ∂μ) ^ (1 / 2 : ℝ) ≤
      (∫ ω, |Z ω| ∂μ) ^ (1 / 4 : ℝ) *
        (∫ ω, |Z ω| ^ (3 : ℕ) ∂μ) ^ (1 / 4 : ℝ) := by
  have hf0 := hZ1.norm_rpow_div (q := (1 / 2 : ENNReal))
  have hg0 := hZ3.norm_rpow_div (q := (3 / 2 : ENNReal))
  have hq : (3 : ENNReal) / (3 / 2 : ENNReal) = 2 := by
    rw [ENNReal.div_eq_inv_mul, ENNReal.div_eq_inv_mul]
    rw [ENNReal.mul_inv (by norm_num) (by norm_num)]
    simp only [inv_inv]
    rw [mul_assoc, ENNReal.inv_mul_cancel (by norm_num) (by norm_num), mul_one]
  have hf : MemLp (fun ω => |Z ω| ^ (1 / 2 : ℝ)) 2 μ := by
    convert hf0 using 1 <;> norm_num
  have hg : MemLp (fun ω => |Z ω| ^ (3 / 2 : ℝ)) 2 μ := by
    rw [hq] at hg0
    convert hg0 using 1; norm_num
  have hc := integral_mul_le_Lp_mul_Lq_of_nonneg
    (μ := μ) (p := (2 : ℝ)) (q := (2 : ℝ))
    (f := fun ω => |Z ω| ^ (1 / 2 : ℝ))
    (g := fun ω => |Z ω| ^ (3 / 2 : ℝ)) Real.HolderConjugate.two_two
    (Filter.Eventually.of_forall (fun ω => Real.rpow_nonneg (abs_nonneg _) _))
    (Filter.Eventually.of_forall (fun ω => Real.rpow_nonneg (abs_nonneg _) _))
    (by simpa using hf) (by simpa using hg)
  have hfg : (fun ω =>
      (|Z ω| ^ (1 / 2 : ℝ)) * (|Z ω| ^ (3 / 2 : ℝ))) =
      (fun ω => |Z ω| ^ (2 : ℝ)) := by
    funext ω
    rw [← Real.rpow_add_of_nonneg (abs_nonneg _) (by positivity) (by positivity)]
    have h : (1 / 2 : ℝ) + 3 / 2 = 2 := by ring
    rw [h]
  have hff : (fun ω =>
      (|Z ω| ^ (1 / 2 : ℝ)) ^ (2 : ℝ)) =
      (fun ω => |Z ω|) := by
    funext ω
    rw [← Real.rpow_mul (abs_nonneg _)]
    have h : (1 / 2 : ℝ) * 2 = 1 := by ring
    rw [h, Real.rpow_one]
  have hgg : (fun ω =>
      (|Z ω| ^ (3 / 2 : ℝ)) ^ (2 : ℝ)) =
      (fun ω => |Z ω| ^ (3 : ℕ)) := by
    funext ω
    rw [← Real.rpow_mul (abs_nonneg _)]
    have h : (3 / 2 : ℝ) * 2 = 3 := by ring
    rw [h]
    exact Real.rpow_natCast _ 3
  rw [hfg, hff, hgg] at hc
  have hpow := Real.rpow_le_rpow
    (integral_nonneg_of_ae (Filter.Eventually.of_forall (fun ω => by positivity)))
    hc (by norm_num : (0 : ℝ) ≤ 1 / 2)
  have hA : 0 ≤ ∫ ω, |Z ω| ∂μ :=
    integral_nonneg_of_ae (Filter.Eventually.of_forall (fun ω => by positivity))
  have hB : 0 ≤ ∫ ω, |Z ω| ^ (3 : ℕ) ∂μ :=
    integral_nonneg_of_ae (Filter.Eventually.of_forall (fun ω => by positivity))
  calc
    (∫ ω, |Z ω| ^ (2 : ℝ) ∂μ) ^ (1 / 2 : ℝ) ≤
        ((∫ ω, |Z ω| ∂μ) ^ (1 / 2 : ℝ) *
          (∫ ω, |Z ω| ^ (3 : ℕ) ∂μ) ^ (1 / 2 : ℝ)) ^ (1 / 2 : ℝ) := hpow
    _ = (∫ ω, |Z ω| ∂μ) ^ (1 / 4 : ℝ) *
        (∫ ω, |Z ω| ^ (3 : ℕ) ∂μ) ^ (1 / 4 : ℝ) := by
      rw [← Real.mul_rpow hA hB]
      rw [← Real.rpow_mul (mul_nonneg hA hB)]
      norm_num
      rw [Real.mul_rpow hA hB]

/-! The Gaussian sum law in equation (2.18), together with its weighted form. -/
theorem independentGaussianSumLaw {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {σ : ι → ℝ≥0}
    (hLaw : ∀ i, HasLaw (X i) (gaussianReal 0 (σ i)) μ)
    (hIndep : iIndepFun X μ) :
    HasLaw (fun ω => ∑ i, X i ω)
      (gaussianReal 0 (∑ i, σ i)) μ := by
  have hGaussian : ∀ i, HasGaussianLaw (X i) μ := fun i =>
    (hLaw i).hasGaussianLaw
  have hSumGaussian : HasGaussianLaw (fun ω => ∑ i, X i ω) μ :=
    hIndep.hasGaussianLaw_fun_sum hGaussian
  have hLp : ∀ i, MemLp (X i) 2 μ := fun i => (hGaussian i).memLp_two
  have hPair : (↑(Finset.univ : Finset ι) : Set ι).Pairwise
      (fun i j => X i ⟂ᵢ[μ] X j) := by
    intro i hi j hj hij
    exact hIndep.indepFun hij
  have hVar_i : ∀ i, Var[X i; μ] = (σ i : ℝ) := by
    intro i
    calc
      Var[X i; μ] = Var[id; μ.map (X i)] := by
        symm
        simpa using (variance_map (X := id) (Y := X i)
          (μ := μ) (by fun_prop) (hLaw i).aemeasurable)
      _ = Var[id; gaussianReal 0 (σ i)] := by rw [hLaw i |>.map_eq]
      _ = (σ i : ℝ) := by simp [variance_id_gaussianReal]
  have hsum_fun : (fun ω => ∑ i, X i ω) = ∑ i, X i := by
    funext ω
    simp
  have hVar : Var[fun ω => ∑ i, X i ω; μ] = ∑ i, (σ i : ℝ) := by
    have hVar' := IndepFun.variance_sum (s := Finset.univ) (fun i _ => hLp i) hPair
    calc
      Var[fun ω => ∑ i, X i ω; μ] = Var[∑ i, X i; μ] := by rw [hsum_fun]
      _ = ∑ i, Var[X i; μ] := by simpa using hVar'
      _ = ∑ i, (σ i : ℝ) := by simp [hVar_i]
  have hMean_i : ∀ i, (∫ ω, X i ω ∂μ) = 0 := by
    intro i
    calc
      (∫ ω, X i ω ∂μ) = ∫ x, id x ∂(μ.map (X i)) := by
        symm
        simpa using (integral_map (hLaw i).aemeasurable aestronglyMeasurable_id)
      _ = ∫ x, id x ∂(gaussianReal 0 (σ i)) := by rw [hLaw i |>.map_eq]
      _ = 0 := by simp
  have hMean : (∫ ω, (∑ i, X i ω) ∂μ) = 0 := by
    rw [integral_finset_sum]
    · simp [hMean_i]
    · intro i hi
      exact (hGaussian i).integrable
  have hEq := hSumGaussian.isGaussian_map.eq_gaussianReal (μ.map (fun ω => ∑ i, X i ω))
  refine { aemeasurable := hSumGaussian.aemeasurable, map_eq := ?_ }
  calc
    μ.map (fun ω => ∑ i, X i ω) =
        gaussianReal (∫ x, id x ∂μ.map (fun ω => ∑ i, X i ω))
          Var[id; μ.map (fun ω => ∑ i, X i ω)].toNNReal := hEq
    _ = gaussianReal 0 (∑ i, σ i) := by
      rw [integral_map hSumGaussian.aemeasurable aestronglyMeasurable_id]
      rw [variance_map aemeasurable_id hSumGaussian.aemeasurable]
      simp only [id_eq, Function.id_comp]
      rw [hMean, hVar]
      congr 2
      apply NNReal.eq
      have hnonneg : 0 ≤ ∑ i, (σ i : ℝ) :=
        Finset.sum_nonneg fun i _ => (σ i).property
      rw [Real.coe_toNNReal _ hnonneg]
      simp

/-! Parameterized five-way interface for Proposition 2.5.2. -/
/-- The two-sided sub-Gaussian tail-bound presentation. -/
def SubGaussianTailBound {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) (K : ℝ) : Prop :=
  Measurable X ∧ 0 < K ∧
    ∀ t : ℝ, 0 ≤ t →
      μ.real {ω | |X ω| ≥ t} ≤ 2 * Real.exp (-t ^ 2 / K ^ 2)

/-- The moment-growth presentation of a sub-Gaussian bound. -/
def SubGaussianMomentBound {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) (K : ℝ) : Prop :=
  Measurable X ∧ 0 < K ∧ LpMomentGrowth μ X K

/-- The square-MGF presentation on a scale-dependent parameter window. -/
def SubGaussianSquareWindow {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) (K : ℝ) : Prop :=
  Measurable X ∧ 0 < K ∧
    ∀ lam : ℝ, |lam| ≤ K⁻¹ →
      Integrable (fun ω => Real.exp (lam ^ 2 * X ω ^ 2)) μ ∧
        (∫ ω, Real.exp (lam ^ 2 * X ω ^ 2) ∂μ) ≤
          Real.exp (K ^ 2 * lam ^ 2)

/-- The one-point exponential-square presentation of a sub-Gaussian bound. -/
def SubGaussianSquarePoint {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) (K : ℝ) : Prop :=
  Measurable X ∧ 0 < K ∧
    Integrable (fun ω => Real.exp (X ω ^ 2 / K ^ 2)) μ ∧
      (∫ ω, Real.exp (X ω ^ 2 / K ^ 2) ∂μ) ≤ 2

/-! Threshold-parametrized versions of the tail and point square-MGF clauses.

Remark 2.5.3 says that the printed threshold `2` can be replaced by any fixed
`A > 1`, at the cost of changing the scale by a constant depending only on
`A`.  These predicates expose that threshold so the rescaling statement can be
checked directly rather than being hidden in prose. -/
/-- A sub-Gaussian tail bound with an explicit leading threshold. -/
def SubGaussianTailBoundWithThreshold {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) (K A : ℝ) : Prop :=
  Measurable X ∧ 0 < K ∧
    ∀ t : ℝ, 0 ≤ t →
      μ.real {ω | |X ω| ≥ t} ≤ A * Real.exp (-t ^ 2 / K ^ 2)

/-- A one-point exponential-square bound with an explicit threshold. -/
def SubGaussianSquarePointWithThreshold {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) (K A : ℝ) : Prop :=
  Measurable X ∧ 0 < K ∧
    Integrable (fun ω => Real.exp (X ω ^ 2 / K ^ 2)) μ ∧
      (∫ ω, Real.exp (X ω ^ 2 / K ^ 2) ∂μ) ≤ A

noncomputable def subGaussianTailThresholdScale (A B : ℝ) : ℝ :=
  if A ≤ B then 1 else (Real.sqrt (Real.log B / Real.log A))⁻¹

noncomputable def subGaussianSquarePointThresholdScale (A B : ℝ) : ℝ :=
  if A ≤ B then 1 else (Real.sqrt ((B - 1) / (A - 1)))⁻¹

/-- Rescale a tail bound from one threshold greater than one to another. -/
def subGaussianTailThreshold_rescale
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K A B : ℝ} (hA : 1 < A) (hB : 1 < B) (hK : 0 < K)
    (hTail : ∀ t : ℝ, 0 ≤ t →
      μ.real {ω | |X ω| ≥ t} ≤ A * Real.exp (-t ^ 2 / K ^ 2)) :
    ∃ K' : ℝ, 0 < K' ∧
      K' ≤ subGaussianTailThresholdScale A B * K ∧
      ∀ t : ℝ, 0 ≤ t →
        μ.real {ω | |X ω| ≥ t} ≤ B * Real.exp (-t ^ 2 / K' ^ 2) := by
  by_cases hAB : A ≤ B
  · refine ⟨K, hK, by simp [subGaussianTailThresholdScale, hAB], fun t ht => ?_⟩
    calc
      μ.real {ω | |X ω| ≥ t} ≤ A * Real.exp (-t ^ 2 / K ^ 2) := hTail t ht
      _ ≤ B * Real.exp (-t ^ 2 / K ^ 2) := by
        exact mul_le_mul_of_nonneg_right hAB (le_of_lt (Real.exp_pos _))
  · have hBA : B < A := lt_of_not_ge hAB
    have hLogA : 0 < Real.log A := Real.log_pos hA
    have hLogB : 0 < Real.log B := Real.log_pos hB
    have hLogBA : Real.log B < Real.log A := Real.log_lt_log (by linarith) hBA
    let c : ℝ := Real.log B / Real.log A
    have hc : 0 < c := div_pos hLogB hLogA
    have hc1 : c < 1 := (div_lt_one hLogA).2 hLogBA
    let K' : ℝ := K / Real.sqrt c
    have hK' : 0 < K' := div_pos hK (Real.sqrt_pos.2 hc)
    have hK'bound : K' ≤ subGaussianTailThresholdScale A B * K := by
      simp [subGaussianTailThresholdScale, hAB, K', c, div_eq_inv_mul]
    have hSqSqrt : (Real.sqrt c) ^ 2 = c := Real.sq_sqrt hc.le
    have hKsq : K' ^ 2 = K ^ 2 / c := by
      dsimp [K']
      field_simp [ne_of_gt hK, ne_of_gt (Real.sqrt_pos.2 hc)]
      exact hSqSqrt.symm
    have hScale (t : ℝ) : t ^ 2 / K' ^ 2 = c * (t ^ 2 / K ^ 2) := by
      rw [hKsq]
      field_simp [ne_of_gt hK, ne_of_gt hc]
    have hSourceExponent (t : ℝ) : -t ^ 2 / K ^ 2 =
        -(t ^ 2 / K ^ 2) := by ring
    have hTargetExponent (t : ℝ) : -t ^ 2 / K' ^ 2 =
        -(c * (t ^ 2 / K ^ 2)) := by
      calc
        -t ^ 2 / K' ^ 2 = -(t ^ 2 / K' ^ 2) := by ring
        _ = -(c * (t ^ 2 / K ^ 2)) := by rw [hScale]
    have hProb (s : Set Ω) : μ.real s ≤ 1 := by
      calc
        μ.real s ≤ μ.real Set.univ := by
          simp only [Measure.real_def]
          exact ENNReal.toReal_mono (measure_ne_top μ Set.univ)
            (measure_mono (Set.subset_univ _))
        _ = 1 := probReal_univ
    refine ⟨K', hK', hK'bound, fun t ht => ?_⟩
    let u : ℝ := t ^ 2 / K ^ 2
    by_cases hu : u ≤ Real.log A
    · have hcu : c * u ≤ Real.log B := by
        have hcLog : c * Real.log A = Real.log B := by
          dsimp [c]
          field_simp [ne_of_gt hLogA]
        nlinarith
      have hExp : B⁻¹ ≤ Real.exp (-(c * u)) := by
        calc
          B⁻¹ = Real.exp (-Real.log B) := by
            rw [Real.exp_neg, Real.exp_log (by linarith)]
          _ ≤ Real.exp (-(c * u)) := by
            apply Real.exp_le_exp.mpr
            linarith
      have hOne : (1 : ℝ) ≤ B * Real.exp (-(c * u)) := by
        calc
          (1 : ℝ) = B * B⁻¹ := by field_simp [ne_of_gt hB]
          _ ≤ B * Real.exp (-(c * u)) :=
            mul_le_mul_of_nonneg_left hExp (by linarith)
      calc
        μ.real {ω | |X ω| ≥ t} ≤ 1 := hProb _
        _ ≤ B * Real.exp (-(c * u)) := hOne
        _ = B * Real.exp (-t ^ 2 / K' ^ 2) := by
          rw [hTargetExponent, show u = t ^ 2 / K ^ 2 by rfl]
    · have hu' : Real.log A < u := lt_of_not_ge hu
      have hExpCmp : A * Real.exp (-u) ≤ B * Real.exp (-(c * u)) := by
        rw [← Real.exp_log (by linarith : 0 < A), ← Real.exp_log (by linarith : 0 < B)]
        rw [← Real.exp_add, ← Real.exp_add]
        apply Real.exp_le_exp.mpr
        have hnonneg : 0 ≤ (1 - c) * (u - Real.log A) :=
          mul_nonneg (by linarith) (by linarith)
        have hcLog : c * Real.log A = Real.log B := by
          dsimp [c]
          field_simp [ne_of_gt hLogA]
        nlinarith
      calc
        μ.real {ω | |X ω| ≥ t} ≤ A * Real.exp (-u) := by
          calc
            μ.real {ω | |X ω| ≥ t} ≤ A * Real.exp (-t ^ 2 / K ^ 2) := hTail t ht
            _ = A * Real.exp (-u) := by rw [hSourceExponent, show u = t ^ 2 / K ^ 2 by rfl]
        _ ≤ B * Real.exp (-(c * u)) := hExpCmp
        _ = B * Real.exp (-t ^ 2 / K' ^ 2) := by
          rw [hTargetExponent, show u = t ^ 2 / K ^ 2 by rfl]

/-- Rescale a square-point bound between thresholds greater than one. -/
def subGaussianSquarePointThreshold_rescale
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K A B : ℝ} (hX : Measurable X)
    (hA : 1 < A) (hB : 1 < B) (hK : 0 < K)
    (hInt : Integrable (fun ω => Real.exp (X ω ^ 2 / K ^ 2)) μ)
    (hBound : (∫ ω, Real.exp (X ω ^ 2 / K ^ 2) ∂μ) ≤ A) :
    ∃ K' : ℝ, 0 < K' ∧
      K' ≤ subGaussianSquarePointThresholdScale A B * K ∧
      Integrable (fun ω => Real.exp (X ω ^ 2 / K' ^ 2)) μ ∧
        (∫ ω, Real.exp (X ω ^ 2 / K' ^ 2) ∂μ) ≤ B := by
  by_cases hAB : A ≤ B
  · refine ⟨K, hK, by simp [subGaussianSquarePointThresholdScale, hAB],
      hInt, hBound.trans hAB⟩
  · have hBA : B < A := lt_of_not_ge hAB
    have hA1 : 0 < A - 1 := sub_pos.mpr hA
    have hB1 : 0 < B - 1 := by linarith
    let c : ℝ := (B - 1) / (A - 1)
    have hc : 0 < c := div_pos hB1 hA1
    have hc1 : c < 1 := (div_lt_one hA1).2 (by linarith)
    let K' : ℝ := K / Real.sqrt c
    have hK' : 0 < K' := div_pos hK (Real.sqrt_pos.2 hc)
    have hK'bound : K' ≤ subGaussianSquarePointThresholdScale A B * K := by
      simp [subGaussianSquarePointThresholdScale, hAB, K', c, div_eq_inv_mul]
    have hSqSqrt : (Real.sqrt c) ^ 2 = c := Real.sq_sqrt hc.le
    have hKsq : K' ^ 2 = K ^ 2 / c := by
      dsimp [K']
      field_simp [ne_of_gt hK, ne_of_gt (Real.sqrt_pos.2 hc)]
      exact hSqSqrt.symm
    have hScale (ω : Ω) : X ω ^ 2 / K' ^ 2 =
        c * (X ω ^ 2 / K ^ 2) := by
      rw [hKsq]
      field_simp [ne_of_gt hK, ne_of_gt hc]
    have hChord (y : ℝ) : Real.exp (c * y) ≤ (1 - c) + c * Real.exp y := by
      have hConv := convexOn_exp.2 (Set.mem_univ (0 : ℝ))
        (Set.mem_univ y) (sub_nonneg.mpr hc1.le) hc.le (by ring)
      simpa only [smul_eq_mul, zero_mul, mul_zero, add_zero, zero_add, Real.exp_zero,
        mul_one] using hConv
    let f : Ω → ℝ := fun ω => Real.exp (X ω ^ 2 / K ^ 2)
    let g : Ω → ℝ := fun ω => (1 - c) + c * f ω
    have hGInt : Integrable g μ := by
      dsimp [g]
      exact (integrable_const (1 - c)).add (hInt.const_mul c)
    have hTargetInt : Integrable (fun ω => Real.exp (X ω ^ 2 / K' ^ 2)) μ := by
      refine hGInt.mono' ?_ ?_
      · fun_prop
      · filter_upwards [] with ω
        rw [hScale]
        simpa [f, Real.norm_eq_abs, abs_of_pos (Real.exp_pos _)] using
          hChord (X ω ^ 2 / K ^ 2)
    have hTargetBound :
        (∫ ω, Real.exp (X ω ^ 2 / K' ^ 2) ∂μ) ≤ B := by
      have hPoint : ∀ᵐ ω ∂μ,
          Real.exp (X ω ^ 2 / K' ^ 2) ≤ g ω := by
        filter_upwards [] with ω
        rw [hScale]
        simpa [f] using hChord (X ω ^ 2 / K ^ 2)
      calc
        (∫ ω, Real.exp (X ω ^ 2 / K' ^ 2) ∂μ) ≤ ∫ ω, g ω ∂μ :=
          integral_mono_ae hTargetInt hGInt hPoint
        _ = (1 - c) + c * (∫ ω, f ω ∂μ) := by
          dsimp [g]
          rw [integral_add (integrable_const (1 - c)) (hInt.const_mul c)]
          simp [f, integral_const_mul, probReal_univ]
        _ ≤ B := by
          have hBoundF : (∫ ω, f ω ∂μ) ≤ A := by simpa [f] using hBound
          have hMul := mul_le_mul_of_nonneg_left hBoundF hc.le
          calc
            (1 - c) + c * (∫ ω, f ω ∂μ) ≤ (1 - c) + c * A := by linarith
            _ = B := by
              dsimp [c]
              field_simp [ne_of_gt hA1]
              ring
    exact ⟨K', hK', hK'bound, hTargetInt, hTargetBound⟩

/-! Remark 2.5.3: the fixed threshold `2` in the tail and point square-MGF
clauses may be replaced by any fixed `A > 1`, with only an `A`-dependent
rescaling of the positive parameter. -/
theorem subGaussianThresholdRemark
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (A : ℝ) (hA : 1 < A) :
    ((∃ K : ℝ, 0 < K ∧ SubGaussianTailBoundWithThreshold μ X K 2) ↔
      ∃ K : ℝ, 0 < K ∧ SubGaussianTailBoundWithThreshold μ X K A) ∧
    ((∃ K : ℝ, 0 < K ∧ SubGaussianSquarePointWithThreshold μ X K 2) ↔
      ∃ K : ℝ, 0 < K ∧ SubGaussianSquarePointWithThreshold μ X K A) := by
  constructor
  · constructor
    · rintro ⟨K, hK, hTail⟩
      rcases subGaussianTailThreshold_rescale (A := 2) (B := A)
          (by norm_num) hA hK hTail.2.2 with ⟨K', hK', _, hTail'⟩
      exact ⟨K', hK', hTail.1, hK', hTail',⟩
    · rintro ⟨K, hK, hTail⟩
      rcases subGaussianTailThreshold_rescale (A := A) (B := 2)
          hA (by norm_num) hK hTail.2.2 with ⟨K', hK', _, hTail'⟩
      exact ⟨K', hK', hTail.1, hK', hTail',⟩
  · constructor
    · rintro ⟨K, hK, hPoint⟩
      rcases subGaussianSquarePointThreshold_rescale (A := 2) (B := A)
          hPoint.1 (by norm_num) hA hK hPoint.2.2.1 hPoint.2.2.2 with
        ⟨K', hK', _, hInt', hBound'⟩
      exact ⟨K', hK', hPoint.1, hK', hInt', hBound'⟩
    · rintro ⟨K, hK, hPoint⟩
      rcases subGaussianSquarePointThreshold_rescale (A := A) (B := 2)
          hPoint.1 hA (by norm_num) hK hPoint.2.2.1 hPoint.2.2.2 with
        ⟨K', hK', _, hInt', hBound'⟩
      exact ⟨K', hK', hPoint.1, hK', hInt', hBound'⟩

theorem one_le_subGaussianTailThresholdScale
    {A B : ℝ} (hA : 1 < A) (hB : 1 < B) :
    1 ≤ subGaussianTailThresholdScale A B := by
  rw [subGaussianTailThresholdScale]
  split_ifs with hAB
  · exact le_rfl
  · have hBA : B < A := lt_of_not_ge hAB
    have hLogA : 0 < Real.log A := Real.log_pos hA
    have hLogB : 0 < Real.log B := Real.log_pos hB
    have hLogBA : Real.log B < Real.log A := Real.log_lt_log (by linarith) hBA
    let c : ℝ := Real.log B / Real.log A
    have hc : 0 < c := div_pos hLogB hLogA
    have hc1 : c < 1 := (div_lt_one hLogA).2 hLogBA
    have hspos : 0 < Real.sqrt c := Real.sqrt_pos.2 hc
    have hsle : Real.sqrt c ≤ 1 := by
      nlinarith [Real.sq_sqrt hc.le]
    simpa [c] using (one_le_inv₀ hspos).2 hsle

theorem one_le_subGaussianSquarePointThresholdScale
    {A B : ℝ} (hA : 1 < A) (hB : 1 < B) :
    1 ≤ subGaussianSquarePointThresholdScale A B := by
  rw [subGaussianSquarePointThresholdScale]
  split_ifs with hAB
  · exact le_rfl
  · have hBA : B < A := lt_of_not_ge hAB
    have hA1 : 0 < A - 1 := by linarith
    have hB1 : 0 < B - 1 := by linarith
    let c : ℝ := (B - 1) / (A - 1)
    have hc : 0 < c := div_pos hB1 hA1
    have hc1 : c < 1 := (div_lt_one hA1).2 (by linarith)
    have hspos : 0 < Real.sqrt c := Real.sqrt_pos.2 hc
    have hsle : Real.sqrt c ≤ 1 := by
      nlinarith [Real.sq_sqrt hc.le]
    simpa [c] using (one_le_inv₀ hspos).2 hsle

/-- The centered linear-MGF presentation of a sub-Gaussian bound. -/
def SubGaussianLinearMGF {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) (K : ℝ) : Prop :=
  Measurable X ∧ 0 < K ∧ Integrable X μ ∧
    (∫ ω, X ω ∂μ) = 0 ∧
      ∀ lam : ℝ,
        Integrable (fun ω => Real.exp (lam * X ω)) μ ∧
          (∫ ω, Real.exp (lam * X ω) ∂μ) ≤ Real.exp (K ^ 2 * lam ^ 2)

/-- The five equivalent presentations of the sub-Gaussian property. -/
inductive SubGaussianPropertyKind
  | tail
  | moment
  | squareWindow
  | squarePoint
  | linearMGF

/-- Interpret a sub-Gaussian presentation at a specified scale. -/
def SubGaussianProperty {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) :
    SubGaussianPropertyKind → ℝ → Prop
  | .tail => SubGaussianTailBound μ X
  | .moment => SubGaussianMomentBound μ X
  | .squareWindow => SubGaussianSquareWindow μ X
  | .squarePoint => SubGaussianSquarePoint μ X
  | .linearMGF => SubGaussianLinearMGF μ X

def SubGaussianPropertyWithThreshold {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) (A : ℝ) :
    SubGaussianPropertyKind → ℝ → Prop
  | .tail => fun K => SubGaussianTailBoundWithThreshold μ X K A
  | .moment => SubGaussianMomentBound μ X
  | .squareWindow => SubGaussianSquareWindow μ X
  | .squarePoint => fun K => SubGaussianSquarePointWithThreshold μ X K A
  | .linearMGF => SubGaussianLinearMGF μ X

noncomputable def subGaussianThresholdToStandardScale (A : ℝ) : ℝ :=
  max (subGaussianTailThresholdScale A 2)
    (subGaussianSquarePointThresholdScale A 2)

noncomputable def subGaussianStandardToThresholdScale (A : ℝ) : ℝ :=
  max (subGaussianTailThresholdScale 2 A)
    (subGaussianSquarePointThresholdScale 2 A)

theorem one_le_subGaussianThresholdToStandardScale
    {A : ℝ} (hA : 1 < A) : 1 ≤ subGaussianThresholdToStandardScale A :=
  (one_le_subGaussianTailThresholdScale hA (by norm_num)).trans
    (le_max_left _ _)

theorem one_le_subGaussianStandardToThresholdScale
    {A : ℝ} (hA : 1 < A) : 1 ≤ subGaussianStandardToThresholdScale A :=
  (one_le_subGaussianTailThresholdScale (by norm_num) hA).trans
    (le_max_left _ _)

private theorem subGaussianMomentToSquareWindow
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ} (hK : 0 < K)
    (hMom : SubGaussianMomentBound μ X K) :
    SubGaussianSquareWindow μ X (8 * K) := by
  have he : Real.exp 1 ≤ 4 := by
    exact le_trans (le_of_lt Real.exp_one_lt_d9) (by norm_num)
  refine ⟨hMom.1, by positivity, ?_⟩
  intro lam hlam
  have hsmall : |lam| ≤ (4 * K)⁻¹ := by
    calc
      |lam| ≤ (8 * K)⁻¹ := hlam
      _ ≤ (4 * K)⁻¹ := by
        have h := one_div_le_one_div_of_le (by positivity : (0 : ℝ) < 4 * K)
          (by nlinarith : 4 * K ≤ 8 * K)
        simpa [one_div] using h
  have h := momentToSquareMGF hK hMom.2.2 lam hsmall
  refine ⟨h.1, ?_⟩
  calc
    (∫ ω, Real.exp (lam ^ 2 * X ω ^ 2) ∂μ) ≤
        Real.exp (4 * Real.exp 1 * (lam * K) ^ 2) := h.2
    _ ≤ Real.exp ((8 * K) ^ 2 * lam ^ 2) := by
      apply Real.exp_le_exp.mpr
      have hmul := mul_le_mul_of_nonneg_right he
        (by positivity : 0 ≤ 4 * (lam * K) ^ 2)
      calc
        4 * Real.exp 1 * (lam * K) ^ 2 ≤ 16 * (lam * K) ^ 2 := by
          nlinarith
        _ ≤ 64 * (lam * K) ^ 2 := by
          nlinarith [sq_nonneg (lam * K)]
        _ = (8 * K) ^ 2 * lam ^ 2 := by ring

private theorem subGaussianSquareWindowToPoint
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ} (hK : 0 < K)
    (hSquare : SubGaussianSquareWindow μ X K) :
    SubGaussianSquarePoint μ X (2 * K) := by
  have hparam : |(2 * K)⁻¹| ≤ K⁻¹ := by
    rw [abs_of_pos (by positivity)]
    have htwo : (0 : ℝ) < 2 * K := by positivity
    have h := one_div_le_one_div_of_le hK (by nlinarith : K ≤ 2 * K)
    simpa [one_div, abs_of_pos htwo] using h
  have h := hSquare.2.2 ((2 * K)⁻¹) hparam
  have hEq : (fun ω => Real.exp (((2 * K)⁻¹) ^ 2 * X ω ^ 2)) =
      (fun ω => Real.exp (X ω ^ 2 / (2 * K) ^ 2)) := by
    funext ω
    congr 1
    field_simp
  refine ⟨hSquare.1, by positivity, ?_, ?_⟩
  · rw [hEq] at h
    exact h.1
  · calc
      (∫ ω, Real.exp (X ω ^ 2 / (2 * K) ^ 2) ∂μ) =
          ∫ ω, Real.exp (((2 * K)⁻¹) ^ 2 * X ω ^ 2) ∂μ := by
            rw [hEq]
      _ ≤ Real.exp (K ^ 2 * ((2 * K)⁻¹) ^ 2) := h.2
      _ = Real.exp (1 / 4) := by
        congr 1
        field_simp
        norm_num
      _ ≤ 2 := by
        apply le_trans (Real.exp_bound_div_one_sub_of_interval (by norm_num) (by norm_num))
        norm_num

private theorem subGaussianSquarePointToTail
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ}
    (hPoint : SubGaussianSquarePoint μ X K) :
    SubGaussianTailBound μ X K := by
  refine ⟨hPoint.1, hPoint.2.1, ?_⟩
  intro t ht
  exact squareMGFToTail hPoint.1 hPoint.2.1
    ⟨hPoint.2.2.1, hPoint.2.2.2⟩ ht

private theorem subGaussianTailToMoment
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ}
    (hTail : SubGaussianTailBound μ X K) :
    SubGaussianMomentBound μ X (8 * Real.exp 1 * K) := by
  exact ⟨hTail.1,
    mul_pos (mul_pos (by norm_num) (Real.exp_pos 1)) hTail.2.1,
    tailToLpMomentGrowth hTail.1 hTail.2.1 hTail.2.2⟩

private theorem subGaussianSquareWindowToLinear
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ} (hK : 0 < K)
    (hCenter : Integrable X μ ∧ (∫ ω, X ω ∂μ) = 0)
    (hSquare : SubGaussianSquareWindow μ X K) :
    SubGaussianLinearMGF μ X (2 * K) := by
  let Y : Ω → ℝ := fun ω => X ω / K
  have hY : Measurable Y := by
    simpa [Y] using hSquare.1.div_const K
  have hSquareY : SquareMGFLocal μ Y 1 := by
    refine ⟨hY.aemeasurable, ?_⟩
    intro t ht
    have hparam : |t / K| ≤ K⁻¹ := by
      calc
        |t / K| = |t| / K := by rw [abs_div, abs_of_pos hK]
        _ ≤ 1 / K := div_le_div_of_nonneg_right ht hK.le
        _ = K⁻¹ := by rw [one_div]
    have h := hSquare.2.2 (t / K) hparam
    have hEq : (fun ω => Real.exp (t ^ 2 * Y ω ^ 2)) =
        (fun ω => Real.exp ((t / K) ^ 2 * X ω ^ 2)) := by
      funext ω
      congr 1
      dsimp [Y]
      field_simp
    refine ⟨?_, ?_⟩
    · rw [← hEq] at h
      exact h.1
    · calc
        (∫ ω, Real.exp (t ^ 2 * Y ω ^ 2) ∂μ) =
            ∫ ω, Real.exp ((t / K) ^ 2 * X ω ^ 2) ∂μ := by rw [hEq]
        _ ≤ Real.exp (K ^ 2 * (t / K) ^ 2) := h.2
        _ = Real.exp (1 * t ^ 2) := by
          congr 1
          field_simp
  have hYCenter : Integrable Y μ ∧ (∫ ω, Y ω ∂μ) = 0 := by
    refine ⟨?_, ?_⟩
    · simpa [Y, div_eq_inv_mul] using hCenter.1.const_mul K⁻¹
    · have hInt := hCenter.1.const_mul K⁻¹
      calc
        (∫ ω, Y ω ∂μ) = ∫ ω, K⁻¹ * X ω ∂μ := by
          congr 1
          funext ω
          dsimp [Y]
          field_simp
        _ = K⁻¹ * (∫ ω, X ω ∂μ) := by rw [integral_const_mul]
        _ = 0 := by rw [hCenter.2]; ring
  have h := squareMGFToMGF (by norm_num : (0 : ℝ) ≤ 1)
    hYCenter hSquareY
  refine ⟨hSquare.1, by positivity, hCenter.1, hCenter.2, ?_⟩
  intro lam
  have h' := h (lam * K)
  have hEq : (fun ω => Real.exp ((lam * K) * Y ω)) =
      (fun ω => Real.exp (lam * X ω)) := by
    funext ω
    congr 1
    dsimp [Y]
    field_simp
  refine ⟨?_, ?_⟩
  · simpa [hEq] using h'.1
  · calc
      (∫ ω, Real.exp (lam * X ω) ∂μ) =
          ∫ ω, Real.exp ((lam * K) * Y ω) ∂μ := by rw [hEq]
      _ ≤ Real.exp ((1 + 1 / 2) * (lam * K) ^ 2) := h'.2
      _ ≤ Real.exp ((2 * K) ^ 2 * lam ^ 2) := by
        apply Real.exp_le_exp.mpr
        nlinarith [sq_nonneg (lam * K)]

private theorem subGaussianLinearToTail
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ}
    (hLinear : SubGaussianLinearMGF μ X K) :
    SubGaussianTailBound μ X (2 * K) := by
  refine ⟨hLinear.1, ?_, ?_⟩
  · nlinarith [hLinear.2.1]
  · intro t ht
    convert mgfToTail hLinear.1 hLinear.2.1 hLinear.2.2.2.2 ht using 1; ring

private theorem subGaussianToTail
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (i : SubGaussianPropertyKind) {K : ℝ} (hK : 0 < K)
    (hProp : SubGaussianProperty μ X i K) :
    ∃ T : ℝ, 0 < T ∧ T ≤ 16 * K ∧ SubGaussianTailBound μ X T := by
  cases i with
  | tail => exact ⟨K, hK, by nlinarith, hProp⟩
  | moment =>
      have hSq := subGaussianMomentToSquareWindow hK hProp
      have hPoint := subGaussianSquareWindowToPoint (by positivity) hSq
      have hTail := subGaussianSquarePointToTail hPoint
      refine ⟨16 * K, by positivity, le_rfl, ?_⟩
      convert hTail using 1; ring
  | squareWindow =>
      have hPoint := subGaussianSquareWindowToPoint hK hProp
      have hTail := subGaussianSquarePointToTail hPoint
      refine ⟨2 * K, by positivity, by nlinarith, ?_⟩
      simpa [SubGaussianProperty] using hTail
  | squarePoint =>
      have hTail := subGaussianSquarePointToTail hProp
      refine ⟨K, hK, by nlinarith, ?_⟩
      simpa [SubGaussianProperty] using hTail
  | linearMGF =>
      have hTail := subGaussianLinearToTail hProp
      refine ⟨2 * K, by positivity, by nlinarith, ?_⟩
      simpa [SubGaussianProperty] using hTail

private theorem subGaussianFromTail
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (i : SubGaussianPropertyKind)
    (hCenter : i = .linearMGF → Integrable X μ ∧ (∫ ω, X ω ∂μ) = 0)
    {T : ℝ} (hT : 0 < T)
    (hTail : SubGaussianTailBound μ X T) :
    ∃ K : ℝ, 0 < K ∧ K ≤ 128 * Real.exp 1 * T ∧
      SubGaussianProperty μ X i K := by
  cases i with
  | tail =>
      refine ⟨T, hT, ?_, hTail⟩
      have he : (1 : ℝ) ≤ Real.exp 1 := Real.one_le_exp (by norm_num)
      have h := mul_le_mul_of_nonneg_right
        (show (1 : ℝ) ≤ 128 * Real.exp 1 by nlinarith) hT.le
      simpa using h
  | moment =>
      let K := 8 * Real.exp 1 * T
      have hMom := subGaussianTailToMoment hTail
      refine ⟨K, by dsimp [K]; positivity, ?_, ?_⟩
      · have h : (8 : ℝ) ≤ 128 := by norm_num
        have he : 0 ≤ Real.exp 1 * T := by positivity
        have hbound := mul_le_mul_of_nonneg_right h he
        simpa [K, mul_assoc] using hbound
      · simpa [SubGaussianProperty, K] using hMom
  | squareWindow =>
      let K := 64 * Real.exp 1 * T
      have hMom := subGaussianTailToMoment hTail
      have hSq := subGaussianMomentToSquareWindow (by
        positivity) hMom
      refine ⟨K, by dsimp [K]; positivity, ?_, ?_⟩
      · have h : (64 : ℝ) ≤ 128 := by norm_num
        have he : 0 ≤ Real.exp 1 * T := by positivity
        have hbound := mul_le_mul_of_nonneg_right h he
        simpa [K, mul_assoc] using hbound
      · convert hSq using 1
        all_goals simp [K]
        all_goals ring
  | squarePoint =>
      let K := 128 * Real.exp 1 * T
      have hMom := subGaussianTailToMoment hTail
      have hSq := subGaussianMomentToSquareWindow (by
        positivity) hMom
      have hPoint := subGaussianSquareWindowToPoint (by
        positivity) hSq
      refine ⟨K, by dsimp [K]; positivity, le_rfl, ?_⟩
      convert hPoint using 1
      all_goals simp [K]
      all_goals ring
  | linearMGF =>
      let K₀ := 64 * Real.exp 1 * T
      let K := 2 * K₀
      have hCentered := hCenter rfl
      have hMom := subGaussianTailToMoment hTail
      have hSq := subGaussianMomentToSquareWindow (by
        positivity) hMom
      have hLinear := subGaussianSquareWindowToLinear (by
        positivity) hCentered hSq
      refine ⟨K, by dsimp [K, K₀]; positivity, ?_, ?_⟩
      · dsimp [K, K₀]
        exact le_of_eq (by ring)
      · convert hLinear using 1
        all_goals simp [K, K₀]
        all_goals ring

private theorem subGaussianConvert
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (i j : SubGaussianPropertyKind)
    (hCenter : j = .linearMGF → Integrable X μ ∧ (∫ ω, X ω ∂μ) = 0)
    {Ki : ℝ} (hKi : 0 < Ki) (hProp : SubGaussianProperty μ X i Ki) :
    ∃ Kj : ℝ, 0 < Kj ∧ Kj ≤ 4096 * Real.exp 1 * Ki ∧
      SubGaussianProperty μ X j Kj := by
  rcases subGaussianToTail i hKi hProp with
    ⟨T, hT, hTbound, hTail⟩
  rcases subGaussianFromTail j hCenter hT hTail with
    ⟨Kj, hKj, hKjbound, hResult⟩
  refine ⟨Kj, hKj, ?_, hResult⟩
  calc
    Kj ≤ 128 * Real.exp 1 * T := hKjbound
    _ ≤ 128 * Real.exp 1 * (16 * Ki) := by
      exact mul_le_mul_of_nonneg_left hTbound (by positivity)
    _ = 2048 * Real.exp 1 * Ki := by ring
    _ ≤ 4096 * Real.exp 1 * Ki := by
      have hpos : 0 < Real.exp 1 * Ki := mul_pos (Real.exp_pos 1) hKi
      nlinarith

private theorem subGaussianThresholdToStandard
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (A : ℝ) (hA : 1 < A) (i : SubGaussianPropertyKind)
    {K : ℝ} (hK : 0 < K) (hProp : SubGaussianPropertyWithThreshold μ X A i K) :
    ∃ K' : ℝ, 0 < K' ∧ K' ≤ subGaussianThresholdToStandardScale A * K ∧
      SubGaussianProperty μ X i K' := by
  cases i with
  | tail =>
      change SubGaussianTailBoundWithThreshold μ X K A at hProp
      rcases subGaussianTailThreshold_rescale (A := A) (B := 2)
          hA (by norm_num) hK hProp.2.2 with ⟨K', hK', hK'bound, hTail⟩
      refine ⟨K', hK', ?_, ?_⟩
      · exact hK'bound.trans (mul_le_mul_of_nonneg_right
          (le_max_left _ _) hK.le)
      · exact ⟨hProp.1, hK', hTail⟩
  | moment =>
      refine ⟨K, hK, ?_, hProp⟩
      simpa using mul_le_mul_of_nonneg_right
        (one_le_subGaussianThresholdToStandardScale hA) hK.le
  | squareWindow =>
      refine ⟨K, hK, ?_, hProp⟩
      simpa using mul_le_mul_of_nonneg_right
        (one_le_subGaussianThresholdToStandardScale hA) hK.le
  | squarePoint =>
      change SubGaussianSquarePointWithThreshold μ X K A at hProp
      rcases subGaussianSquarePointThreshold_rescale (A := A) (B := 2)
          hProp.1 hA (by norm_num) hK hProp.2.2.1 hProp.2.2.2 with
        ⟨K', hK', hK'bound, hInt, hBound⟩
      refine ⟨K', hK', ?_, ?_⟩
      · exact hK'bound.trans (mul_le_mul_of_nonneg_right
          (le_max_right _ _) hK.le)
      · exact ⟨hProp.1, hK', hInt, hBound⟩
  | linearMGF =>
      refine ⟨K, hK, ?_, hProp⟩
      simpa using mul_le_mul_of_nonneg_right
        (one_le_subGaussianThresholdToStandardScale hA) hK.le

private theorem subGaussianStandardToThreshold
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (A : ℝ) (hA : 1 < A) (i : SubGaussianPropertyKind)
    {K : ℝ} (hK : 0 < K) (hProp : SubGaussianProperty μ X i K) :
    ∃ K' : ℝ, 0 < K' ∧ K' ≤ subGaussianStandardToThresholdScale A * K ∧
      SubGaussianPropertyWithThreshold μ X A i K' := by
  cases i with
  | tail =>
      change SubGaussianTailBound μ X K at hProp
      rcases subGaussianTailThreshold_rescale (A := 2) (B := A)
          (by norm_num) hA hK hProp.2.2 with ⟨K', hK', hK'bound, hTail⟩
      refine ⟨K', hK', ?_, ?_⟩
      · exact hK'bound.trans (mul_le_mul_of_nonneg_right
          (le_max_left _ _) hK.le)
      · exact ⟨hProp.1, hK', hTail⟩
  | moment =>
      refine ⟨K, hK, ?_, hProp⟩
      simpa using mul_le_mul_of_nonneg_right
        (one_le_subGaussianStandardToThresholdScale hA) hK.le
  | squareWindow =>
      refine ⟨K, hK, ?_, hProp⟩
      simpa using mul_le_mul_of_nonneg_right
        (one_le_subGaussianStandardToThresholdScale hA) hK.le
  | squarePoint =>
      change SubGaussianSquarePoint μ X K at hProp
      rcases subGaussianSquarePointThreshold_rescale (A := 2) (B := A)
          hProp.1 (by norm_num) hA hK hProp.2.2.1 hProp.2.2.2 with
        ⟨K', hK', hK'bound, hInt, hBound⟩
      refine ⟨K', hK', ?_, ?_⟩
      · exact hK'bound.trans (mul_le_mul_of_nonneg_right
          (le_max_right _ _) hK.le)
      · exact ⟨hProp.1, hK', hInt, hBound⟩
  | linearMGF =>
      refine ⟨K, hK, ?_, hProp⟩
      simpa using mul_le_mul_of_nonneg_right
        (one_le_subGaussianStandardToThresholdScale hA) hK.le

/-! Stable compositional form of Proposition 2.5.2. -/
theorem subGaussianCharacterization
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (hCenter : Integrable X μ ∧ (∫ ω, X ω ∂μ) = 0) :
    ∃ C : ℝ, 1 ≤ C ∧
      ∀ i j : SubGaussianPropertyKind, ∀ {Ki : ℝ}, 0 < Ki →
        SubGaussianProperty μ X i Ki →
          ∃ Kj : ℝ, 0 < Kj ∧ Kj ≤ C * Ki ∧
            SubGaussianProperty μ X j Kj := by
  have he : (1 : ℝ) ≤ Real.exp 1 := Real.one_le_exp (by norm_num)
  refine ⟨4096 * Real.exp 1, by nlinarith, ?_⟩
  intro i j Ki hKi hProp
  exact subGaussianConvert i j (fun _ => hCenter) hKi hProp

/-! Source-faithful uniform form of Proposition 2.5.2.

The first conjunct compares the four properties that do not require centering.
The second adds the linear MGF property for centered random variables.  The
single comparison constant is chosen before the probability space and random
variable, making its absoluteness explicit in the type.
-/
theorem subGaussianCharacterization_absolute :
    ∃ C : ℝ, 1 ≤ C ∧
      (∀ {Ω : Type*} [MeasurableSpace Ω]
          {μ : Measure Ω} [IsProbabilityMeasure μ] {X : Ω → ℝ},
        Measurable X →
          ∀ i j : SubGaussianPropertyKind,
            i ≠ .linearMGF → j ≠ .linearMGF → ∀ {Ki : ℝ}, 0 < Ki →
              SubGaussianProperty μ X i Ki →
                ∃ Kj : ℝ, 0 < Kj ∧ Kj ≤ C * Ki ∧
                  SubGaussianProperty μ X j Kj) ∧
      (∀ {Ω : Type*} [MeasurableSpace Ω]
          {μ : Measure Ω} [IsProbabilityMeasure μ] {X : Ω → ℝ},
        Measurable X → Integrable X μ ∧ (∫ ω, X ω ∂μ) = 0 →
          ∀ i j : SubGaussianPropertyKind, ∀ {Ki : ℝ}, 0 < Ki →
            SubGaussianProperty μ X i Ki →
              ∃ Kj : ℝ, 0 < Kj ∧ Kj ≤ C * Ki ∧
                SubGaussianProperty μ X j Kj) := by
  have he : (1 : ℝ) ≤ Real.exp 1 := Real.one_le_exp (by norm_num)
  refine ⟨4096 * Real.exp 1, by nlinarith, ?_, ?_⟩
  · intro Ω _ μ _ X _ i j _ hj Ki hKi hProp
    exact subGaussianConvert i j (fun h => (hj h).elim) hKi hProp
  · intro Ω _ μ _ X _ hCenter i j Ki hKi hProp
    exact subGaussianConvert i j (fun _ => hCenter) hKi hProp

/-! Full quantitative form of Remark 2.5.3 for an arbitrary fixed threshold
`A > 1`.  The comparison constant may depend on `A`, but is chosen before the
probability space and random variable. -/
theorem subGaussianThresholdCharacterization_absolute (A : ℝ) (hA : 1 < A) :
    ∃ C : ℝ, 1 ≤ C ∧
      (∀ {Ω : Type*} [MeasurableSpace Ω]
          {μ : Measure Ω} [IsProbabilityMeasure μ] {X : Ω → ℝ},
        Measurable X →
          ∀ i j : SubGaussianPropertyKind,
            i ≠ .linearMGF → j ≠ .linearMGF → ∀ {Ki : ℝ}, 0 < Ki →
              SubGaussianPropertyWithThreshold μ X A i Ki →
                ∃ Kj : ℝ, 0 < Kj ∧ Kj ≤ C * Ki ∧
                  SubGaussianPropertyWithThreshold μ X A j Kj) ∧
      (∀ {Ω : Type*} [MeasurableSpace Ω]
          {μ : Measure Ω} [IsProbabilityMeasure μ] {X : Ω → ℝ},
        Measurable X → Integrable X μ ∧ (∫ ω, X ω ∂μ) = 0 →
          ∀ i j : SubGaussianPropertyKind, ∀ {Ki : ℝ}, 0 < Ki →
            SubGaussianPropertyWithThreshold μ X A i Ki →
              ∃ Kj : ℝ, 0 < Kj ∧ Kj ≤ C * Ki ∧
                SubGaussianPropertyWithThreshold μ X A j Kj) := by
  rcases subGaussianCharacterization_absolute with ⟨C₀, hC₀, hBase, hCentered⟩
  let Cᵢ := subGaussianThresholdToStandardScale A
  let Cₒ := subGaussianStandardToThresholdScale A
  have hCᵢ : 1 ≤ Cᵢ := one_le_subGaussianThresholdToStandardScale hA
  have hCₒ : 1 ≤ Cₒ := one_le_subGaussianStandardToThresholdScale hA
  have hC₀nonneg : 0 ≤ C₀ := by linarith
  have hCᵢnonneg : 0 ≤ Cᵢ := by linarith
  have hCₒnonneg : 0 ≤ Cₒ := by linarith
  have hC₀Cᵢ : 1 ≤ C₀ * Cᵢ := by
    have := mul_le_mul hC₀ hCᵢ (by norm_num : (0 : ℝ) ≤ 1) hC₀nonneg
    simpa using this
  have hC : 1 ≤ Cₒ * C₀ * Cᵢ := by
    calc
      1 ≤ C₀ * Cᵢ := hC₀Cᵢ
      _ = 1 * (C₀ * Cᵢ) := by ring
      _ ≤ Cₒ * (C₀ * Cᵢ) :=
        mul_le_mul_of_nonneg_right hCₒ (mul_nonneg hC₀nonneg hCᵢnonneg)
      _ = Cₒ * C₀ * Cᵢ := by ring
  refine ⟨Cₒ * C₀ * Cᵢ, hC, ?_, ?_⟩
  · intro Ω _ μ _ X hX i j hi hj Ki hKi hProp
    rcases subGaussianThresholdToStandard A hA i hKi hProp with
      ⟨Kₛ, hKₛ, hKₛbound, hStandard⟩
    rcases hBase hX i j hi hj hKₛ hStandard with
      ⟨Kₜ, hKₜ, hKₜbound, hTarget⟩
    rcases subGaussianStandardToThreshold A hA j hKₜ hTarget with
      ⟨Kj, hKj, hKjbound, hResult⟩
    refine ⟨Kj, hKj, ?_, hResult⟩
    calc
      Kj ≤ Cₒ * Kₜ := by simpa [Cₒ] using hKjbound
      _ ≤ Cₒ * (C₀ * Kₛ) :=
        mul_le_mul_of_nonneg_left hKₜbound hCₒnonneg
      _ ≤ Cₒ * (C₀ * (Cᵢ * Ki)) := by
        exact mul_le_mul_of_nonneg_left
          (mul_le_mul_of_nonneg_left (by simpa [Cᵢ] using hKₛbound) hC₀nonneg)
          hCₒnonneg
      _ = (Cₒ * C₀ * Cᵢ) * Ki := by ring
  · intro Ω _ μ _ X hX hCenter i j Ki hKi hProp
    rcases subGaussianThresholdToStandard A hA i hKi hProp with
      ⟨Kₛ, hKₛ, hKₛbound, hStandard⟩
    rcases hCentered hX hCenter i j hKₛ hStandard with
      ⟨Kₜ, hKₜ, hKₜbound, hTarget⟩
    rcases subGaussianStandardToThreshold A hA j hKₜ hTarget with
      ⟨Kj, hKj, hKjbound, hResult⟩
    refine ⟨Kj, hKj, ?_, hResult⟩
    calc
      Kj ≤ Cₒ * Kₜ := by simpa [Cₒ] using hKjbound
      _ ≤ Cₒ * (C₀ * Kₛ) :=
        mul_le_mul_of_nonneg_left hKₜbound hCₒnonneg
      _ ≤ Cₒ * (C₀ * (Cᵢ * Ki)) := by
        exact mul_le_mul_of_nonneg_left
          (mul_le_mul_of_nonneg_left (by simpa [Cᵢ] using hKₛbound) hC₀nonneg)
          hCₒnonneg
      _ = (Cₒ * C₀ * Cᵢ) * Ki := by ring

/-! The extended `ψ₂` gauge from Definition 2.5.6. -/
/-- Admissibility of an extended-real scale in the ψ₂ gauge. -/
def PsiTwoAdmissible {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) (t : ℝ≥0∞) : Prop :=
  Measurable X ∧ t ≠ 0 ∧ t ≠ ∞ ∧
    Integrable (fun ω => Real.exp (X ω ^ 2 / t.toReal ^ 2)) μ ∧
      (∫ ω, Real.exp (X ω ^ 2 / t.toReal ^ 2) ∂μ) ≤ 2

/-- The extended ψ₂ gauge of a measurable real-valued function. -/
noncomputable def PsiTwoGauge {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) : ℝ≥0∞ :=
  sInf {t : ℝ≥0∞ | PsiTwoAdmissible μ X t}

/-! The source-facing name for the `ψ₂` norm.  The extended value records
non-sub-Gaussian variables by `∞`; Definition 2.5.6 uses its finite part. -/
noncomputable def PsiTwoNorm {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) : ℝ≥0∞ :=
  PsiTwoGauge μ X

/-! A random variable is sub-Gaussian when it is measurable and satisfies
property (iv) of Proposition 2.5.2 at some positive scale.  The equivalence of
properties (i)--(iv) below makes the chosen representative immaterial. -/
def IsSubGaussian {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) : Prop :=
  Measurable X ∧ ∃ K : ℝ, 0 < K ∧ SubGaussianSquarePoint μ X K

/-! Equation (2.13), stated on the source's measurable sub-Gaussian domain. -/
theorem psiTwoNorm_eq_sInf
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X : Ω → ℝ}
    (_hX : Measurable X) (_hSub : IsSubGaussian μ X) :
    PsiTwoNorm μ X = sInf {t : ℝ≥0∞ | PsiTwoAdmissible μ X t} := by
  rfl

theorem psiTwoGauge_finite_iff
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] {X : Ω → ℝ} :
    PsiTwoGauge μ X < ∞ ↔
      ∃ K : ℝ, 0 < K ∧ SubGaussianSquarePoint μ X K := by
  constructor
  · intro hGauge
    by_cases hNonempty : Set.Nonempty {t : ℝ≥0∞ | PsiTwoAdmissible μ X t}
    · rcases hNonempty with ⟨t, ht⟩
      rcases ht with ⟨hMeas, ht0, htTop, hInt, hBound⟩
      have htPos : 0 < t.toReal := ENNReal.toReal_pos ht0 htTop
      refine ⟨t.toReal, htPos, ?_⟩
      exact ⟨hMeas, htPos, hInt, hBound⟩
    · have hEmpty : {t : ℝ≥0∞ | PsiTwoAdmissible μ X t} = ∅ :=
        Set.not_nonempty_iff_eq_empty.mp hNonempty
      rw [PsiTwoGauge, hEmpty] at hGauge
      simp at hGauge
  · rintro ⟨K, hK, hPoint⟩
    have ht0 : ENNReal.ofReal K ≠ 0 := (ENNReal.ofReal_ne_zero_iff).2 hK
    have htTop : ENNReal.ofReal K ≠ ∞ := ENNReal.ofReal_ne_top
    have htAdmissible : PsiTwoAdmissible μ X (ENNReal.ofReal K) := by
      refine ⟨hPoint.1, ht0, htTop, ?_, ?_⟩
      · simpa [ENNReal.toReal_ofReal hK.le] using hPoint.2.2.1
      · simpa [ENNReal.toReal_ofReal hK.le] using hPoint.2.2.2
    have hInf : PsiTwoGauge μ X ≤ ENNReal.ofReal K :=
      sInf_le htAdmissible
    exact lt_of_le_of_lt hInf ENNReal.ofReal_lt_top

/-- Any positive square-point witness is an explicit upper bound for the
`ψ₂` gauge, rather than merely a proof that the gauge is finite. -/
theorem psiTwoGauge_le_of_squarePoint
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X : Ω → ℝ} {K : ℝ}
    (hPoint : SubGaussianSquarePoint μ X K) :
    PsiTwoGauge μ X ≤ ENNReal.ofReal K := by
  have hAdmissible : PsiTwoAdmissible μ X (ENNReal.ofReal K) := by
    refine ⟨hPoint.1, (ENNReal.ofReal_ne_zero_iff).2 hPoint.2.1,
      ENNReal.ofReal_ne_top, ?_, ?_⟩
    · simpa [ENNReal.toReal_ofReal hPoint.2.1.le] using hPoint.2.2.1
    · simpa [ENNReal.toReal_ofReal hPoint.2.1.le] using hPoint.2.2.2
  exact sInf_le hAdmissible

/-! Definition 2.5.6 is independent of which of properties (i)--(iv) is used
to recognize the sub-Gaussian class. -/
theorem isSubGaussian_iff_property
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] {X : Ω → ℝ}
    (i : SubGaussianPropertyKind) (hi : i ≠ .linearMGF) :
    IsSubGaussian μ X ↔
      ∃ K : ℝ, 0 < K ∧ SubGaussianProperty μ X i K := by
  constructor
  · rintro ⟨_, K, hK, hPoint⟩
    have hPoint' : SubGaussianProperty μ X .squarePoint K := by
      simpa [SubGaussianProperty] using hPoint
    rcases subGaussianConvert .squarePoint i (fun h => (hi h).elim) hK hPoint' with
      ⟨Ki, hKi, _, hProp⟩
    exact ⟨Ki, hKi, hProp⟩
  · rintro ⟨K, hK, hProp⟩
    rcases subGaussianConvert i .squarePoint (fun h => by cases h) hK hProp with
      ⟨Kpoint, hKpoint, _, hPoint⟩
    have hPoint' : SubGaussianSquarePoint μ X Kpoint := by
      simpa [SubGaussianProperty] using hPoint
    exact ⟨hPoint'.1, Kpoint, hKpoint, hPoint'⟩

theorem isSubGaussian_iff_psiTwoNorm_finite
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] {X : Ω → ℝ} :
    IsSubGaussian μ X ↔ PsiTwoNorm μ X < ∞ := by
  constructor
  · rintro ⟨_, hPoint⟩
    simpa [PsiTwoNorm] using
      (psiTwoGauge_finite_iff (μ := μ) (X := X)).2 hPoint
  · intro hNorm
    have hGauge : PsiTwoGauge μ X < ∞ := by
      simpa [PsiTwoNorm] using hNorm
    rcases (psiTwoGauge_finite_iff (μ := μ) (X := X)).1 hGauge with
      ⟨K, hK, hPoint⟩
    exact ⟨hPoint.1, K, hK, hPoint⟩

/-! An explicit universal version of the property-to-gauge half of the
five-way characterization.  Keeping the numerical constant outside any
instance-dependent existential is useful for source statements whose
"absolute constant" quantifier must precede all random-variable data. -/
theorem psiTwoGauge_le_of_property
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (i : SubGaussianPropertyKind) {K : ℝ}
    (hK : 0 < K) (hProp : SubGaussianProperty μ X i K) :
    PsiTwoGauge μ X ≤ ENNReal.ofReal ((4096 * Real.exp 1) * K) := by
  rcases subGaussianToTail i hK hProp with
    ⟨T, hT, hTbound, hTail⟩
  rcases subGaussianFromTail .squarePoint (fun h => by cases h) hT hTail with
    ⟨Kpoint, hKpoint, hKpointBound, hPoint⟩
  have hAdmissible : PsiTwoAdmissible μ X (ENNReal.ofReal Kpoint) := by
    refine ⟨hPoint.1, (ENNReal.ofReal_ne_zero_iff).2 hKpoint,
      ENNReal.ofReal_ne_top, ?_, ?_⟩
    · simpa [ENNReal.toReal_ofReal hKpoint.le] using hPoint.2.2.1
    · simpa [ENNReal.toReal_ofReal hKpoint.le] using hPoint.2.2.2
  have hGauge : PsiTwoGauge μ X ≤ ENNReal.ofReal Kpoint :=
    sInf_le hAdmissible
  have hScaled : 128 * Real.exp 1 * T ≤
      (4096 * Real.exp 1) * K := by
    have hmul := mul_le_mul_of_nonneg_left hTbound
      (by positivity : 0 ≤ 128 * Real.exp 1)
    calc
      128 * Real.exp 1 * T ≤ 128 * Real.exp 1 * (16 * K) := hmul
      _ ≤ (4096 * Real.exp 1) * K := by
        nlinarith [mul_pos (Real.exp_pos 1) hK]
  exact hGauge.trans (ENNReal.ofReal_mono (hKpointBound.trans hScaled))

/-! A gauge-facing form of the five-way characterization.  Every one of the
    parameterized sub-Gaussian properties controls the exact `ψ₂` gauge up to
    one universal constant, and finite gauge is equivalent to each property
    being available at some positive scale. -/
theorem psiTwoGaugeCharacterizations
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ}
    (hCenter : Integrable X μ ∧ (∫ ω, X ω ∂μ) = 0) :
    ∃ C : ℝ, 1 ≤ C ∧
      (∀ i : SubGaussianPropertyKind, ∀ {K : ℝ}, 0 < K →
        SubGaussianProperty μ X i K →
          PsiTwoGauge μ X ≤ ENNReal.ofReal (C * K)) ∧
      (∀ i : SubGaussianPropertyKind,
        ((∃ K : ℝ, 0 < K ∧ SubGaussianProperty μ X i K) ↔
          PsiTwoGauge μ X < ∞)) := by
  let C : ℝ := 4096 * Real.exp 1
  have hC : 1 ≤ C := by
    dsimp [C]
    nlinarith [Real.one_le_exp (by norm_num : (0 : ℝ) ≤ 1)]
  refine ⟨C, hC, ?_, ?_⟩
  · intro i K hK hProp
    simpa [C] using psiTwoGauge_le_of_property i hK hProp
  · intro i
    constructor
    · rintro ⟨K, hK, hProp⟩
      rcases subGaussianToTail i hK hProp with
        ⟨T, hT, hTbound, hTail⟩
      rcases subGaussianFromTail .squarePoint (fun h => by cases h) hT hTail with
        ⟨Kpoint, hKpoint, _, hPoint⟩
      exact (psiTwoGauge_finite_iff (μ := μ) (X := X)).2
        ⟨Kpoint, hKpoint, hPoint⟩
    · intro hGauge
      rcases (psiTwoGauge_finite_iff (μ := μ) (X := X)).1 hGauge with
        ⟨Kpoint, hKpoint, hPoint⟩
      rcases subGaussianToTail .squarePoint hKpoint hPoint with
        ⟨T, hT, _, hTail⟩
      rcases subGaussianFromTail i (fun _ => hCenter) hT hTail with
        ⟨K, hK, _, hProp⟩
      exact ⟨K, hK, hProp⟩

/-! Centering preserves sub-Gaussianity with an absolute change of scale. -/
theorem centeredSubGaussian
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (i : SubGaussianPropertyKind) {K : ℝ} (hK : 0 < K)
    (hProp : SubGaussianProperty μ X i K) :
    ∃ C : ℝ, 1 ≤ C ∧
      Integrable X μ ∧
      ∃ K' : ℝ, 0 < K' ∧ K' ≤ C * K ∧
        SubGaussianProperty μ
          (fun ω => X ω - ∫ x, X x ∂μ) .squarePoint K' ∧
        PsiTwoGauge μ (fun ω => X ω - ∫ x, X x ∂μ) ≤
          ENNReal.ofReal (C * K) := by
  rcases subGaussianToTail i hK hProp with ⟨T, hT, hTK, hTail⟩
  have hMoment : SubGaussianMomentBound μ X (8 * Real.exp 1 * T) :=
    subGaussianTailToMoment hTail
  have hAbsInt : Integrable (fun ω => |X ω|) μ := by
    have h := (hMoment.2.2.2 1 (by norm_num : (1 : ℝ) ≤ 1)).1
    simpa using h
  have hInt : Integrable X μ := by
    apply (MeasureTheory.integrable_norm_iff hMoment.1.aestronglyMeasurable).mp
    simpa [Real.norm_eq_abs] using hAbsInt
  let m : ℝ := ∫ x, X x ∂μ
  have hMean : |m| ≤ 8 * Real.exp 1 * T := by
    have hMomentBound :=
      (hMoment.2.2.2 1 (by norm_num : (1 : ℝ) ≤ 1)).2
    have hIntegralNorm :=
      MeasureTheory.norm_integral_le_integral_norm X (μ := μ)
    dsimp [m]
    calc
      |∫ x, X x ∂μ| ≤ ∫ x, ‖X x‖ ∂μ := hIntegralNorm
      _ = ∫ x, |X x| ∂μ := by simp only [Real.norm_eq_abs]
      _ ≤ 8 * Real.exp 1 * T := by simpa using hMomentBound
  let Kc : ℝ := 32 * Real.exp 1 * T
  have hKc : 0 < Kc := by
    dsimp [Kc]
    positivity
  have hKc_twoT : 2 * T ≤ Kc := by
    dsimp [Kc]
    nlinarith [Real.one_le_exp (by norm_num : (0 : ℝ) ≤ 1), hT.le]
  have hCenter : Integrable (fun ω => X ω - m) μ ∧
      (∫ ω, X ω - m ∂μ) = 0 := by
    constructor
    · exact hInt.sub (integrable_const m)
    · dsimp [m]
      rw [integral_sub hInt (integrable_const _)]
      simp
  have hTailCenter :
      SubGaussianTailBound μ (fun ω => X ω - m) Kc := by
    refine ⟨hTail.1.sub_const m, hKc, ?_⟩
    intro t ht
    have hProb (s : Set Ω) : μ.real s ≤ 1 := by
      calc
        μ.real s ≤ μ.real Set.univ := by
          simp only [Measure.real_def]
          exact ENNReal.toReal_mono (measure_ne_top μ Set.univ)
            (measure_mono (Set.subset_univ _))
        _ = 1 := probReal_univ
    by_cases hsmall : t ≤ 2 * |m|
    · have htBound : t ≤ 16 * Real.exp 1 * T := by
        nlinarith [hMean]
      have htSq : t ^ 2 ≤ (16 * Real.exp 1 * T) ^ 2 := by
        exact (sq_le_sq₀ (by linarith) (by positivity)).2 htBound
      have hratio : t ^ 2 / Kc ^ 2 ≤ (1 / 4 : ℝ) := by
        apply (div_le_iff₀ (sq_pos_of_pos hKc)).2
        dsimp [Kc]
        nlinarith [htSq]
      have hexp : (1 : ℝ) ≤ 2 * Real.exp (-(t ^ 2 / Kc ^ 2)) := by
        have hbase := Real.add_one_le_exp (-(t ^ 2 / Kc ^ 2))
        nlinarith [hratio]
      calc
        μ.real {ω | |X ω - m| ≥ t} ≤ 1 := hProb _
        _ ≤ 2 * Real.exp (-t ^ 2 / Kc ^ 2) := by
          simpa only [neg_div] using hexp
    · have hlarge : 2 * |m| < t := lt_of_not_ge hsmall
      have hsubset : {ω | |X ω - m| ≥ t} ⊆
          {ω | |X ω| ≥ t / 2} := by
        intro ω hω
        change t ≤ |X ω - m| at hω
        by_contra hnot
        have hnot' : ¬ |X ω| ≥ t / 2 := by
          simpa only [Set.mem_setOf_eq] using hnot
        have hXlt : |X ω| < t / 2 := lt_of_not_ge hnot'
        have hmlt : |m| < t / 2 := by linarith
        have htriangle : |X ω - m| ≤ |X ω| + |m| := abs_sub _ _
        linarith
      have hhalf : 0 ≤ t / 2 := by linarith
      have hsource := hTail.2.2 (t / 2) hhalf
      have hsource' :
          2 * Real.exp (-(t / 2) ^ 2 / T ^ 2) ≤
            2 * Real.exp (-t ^ 2 / Kc ^ 2) := by
        apply mul_le_mul_of_nonneg_left _ (by norm_num)
        apply Real.exp_le_exp.mpr
        have hden : 4 * T ^ 2 ≤ Kc ^ 2 := by
          have hsq := (sq_le_sq₀ (by positivity) (by positivity)).2 hKc_twoT
          nlinarith [hsq]
        have hratio : t ^ 2 / Kc ^ 2 ≤ t ^ 2 / (4 * T ^ 2) := by
          exact div_le_div_of_nonneg_left (sq_nonneg t) (by positivity) hden
        calc
          -(t / 2) ^ 2 / T ^ 2 = -(t ^ 2 / (4 * T ^ 2)) := by
            field_simp
            ring
          _ ≤ -(t ^ 2 / Kc ^ 2) := by nlinarith [hratio]
          _ = -t ^ 2 / Kc ^ 2 := by simp only [neg_div]
      calc
        μ.real {ω | |X ω - m| ≥ t} ≤ μ.real {ω | |X ω| ≥ t / 2} := by
          rw [Measure.real_def, Measure.real_def]
          exact ENNReal.toReal_mono (measure_ne_top μ _)
            (measure_mono hsubset)
        _ ≤ 2 * Real.exp (-(t / 2) ^ 2 / T ^ 2) := hsource
        _ ≤ 2 * Real.exp (-t ^ 2 / Kc ^ 2) := hsource'

  rcases subGaussianFromTail .squarePoint (fun h => by cases h) hKc hTailCenter with
    ⟨K', hK', hK'c, hPoint⟩
  have hGaugeK' :
      PsiTwoGauge μ (fun ω => X ω - m) ≤ ENNReal.ofReal K' := by
    have hAdmissible :
        PsiTwoAdmissible μ (fun ω => X ω - m) (ENNReal.ofReal K') := by
      refine ⟨hPoint.1, (ENNReal.ofReal_ne_zero_iff).2 hK',
        ENNReal.ofReal_ne_top, ?_, ?_⟩
      · simpa [ENNReal.toReal_ofReal hK'.le] using hPoint.2.2.1
      · simpa [ENNReal.toReal_ofReal hK'.le] using hPoint.2.2.2
    exact sInf_le hAdmissible
  let C : ℝ := 65536 * (Real.exp 1) ^ 2
  have hC : 1 ≤ C := by
    dsimp [C]
    nlinarith [Real.one_le_exp (by norm_num : (0 : ℝ) ≤ 1)]
  have hK'bound : K' ≤ C * K := by
    have hTbound : T ≤ 16 * K := hTK
    dsimp [C, Kc] at hK'c ⊢
    nlinarith [Real.one_le_exp (by norm_num : (0 : ℝ) ≤ 1),
      sq_nonneg (Real.exp 1), mul_pos (Real.exp_pos 1) hT,
      mul_pos (Real.exp_pos 1) hK]
  refine ⟨C, hC, hInt, K', hK', hK'bound, ?_, ?_⟩
  · simpa [m] using hPoint
  · apply hGaugeK'.trans
    apply ENNReal.ofReal_mono hK'bound

/-! A finite independent-sum form of Proposition 2.6.1.  The input uses the
linear-MGF branch of the five-way interface; the conclusion exposes both the
same branch for the sum and the corresponding exact-gauge scale bound. -/
theorem independentCenteredSubGaussianSum
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {K : ι → ℝ}
    (hX : ∀ i, SubGaussianLinearMGF μ (X i) (K i))
    (hIndep : iIndepFun X μ)
    (hEnergy : 0 < ∑ i, K i ^ 2) :
    ∃ C : ℝ, 1 ≤ C ∧
      SubGaussianProperty μ (fun ω => ∑ i, X i ω) .linearMGF
        (Real.sqrt (∑ i, K i ^ 2)) ∧
      PsiTwoGauge μ (fun ω => ∑ i, X i ω) ≤
        ENNReal.ofReal (C * Real.sqrt (∑ i, K i ^ 2)) := by
  let S : Ω → ℝ := fun ω => ∑ i, X i ω
  let E : ℝ := ∑ i, K i ^ 2
  have hE : 0 < E := by simpa [E] using hEnergy
  have hS_meas : Measurable S := by
    dsimp [S]
    exact Finset.measurable_sum Finset.univ (fun i _ => (hX i).1)
  have hS_int : Integrable S μ := by
    dsimp [S]
    simpa only [Finset.sum_apply] using
      (integrable_finset_sum (μ := μ) Finset.univ
        (fun i hi => (hX i).2.2.1))
  have hS_mean : (∫ ω, S ω ∂μ) = 0 := by
    dsimp [S]
    rw [integral_finset_sum]
    · exact Finset.sum_eq_zero (fun i hi => (hX i).2.2.2.1)
    · exact fun i hi => (hX i).2.2.1
  have hS_exp (lam : ℝ) :
      Integrable (fun ω => Real.exp (lam * S ω)) μ := by
    have h := hIndep.integrable_exp_mul_sum
      (fun i => (hX i).1) (s := Finset.univ)
      (fun i hi => by simpa using ((hX i).2.2.2.2 lam).1)
    simpa [S] using h
  have hS_mgf (lam : ℝ) :
      (∫ ω, Real.exp (lam * S ω) ∂μ) ≤ Real.exp (E * lam ^ 2) := by
    have hFactor (i : ι) :
        (∫ ω, Real.exp (lam * (1 * X i ω)) ∂μ) ≤
          Real.exp (K i ^ 2 * lam ^ 2) := by
      simpa using ((hX i).2.2.2.2 lam).2
    have hProd :
        (∏ i, ∫ ω, Real.exp (lam * (1 * X i ω)) ∂μ) ≤
          ∏ i, Real.exp (K i ^ 2 * lam ^ 2) := by
      apply Finset.prod_le_prod
      · intro i hi
        exact integral_nonneg (fun ω => Real.exp_nonneg _)
      · intro i hi
        exact hFactor i
    have hFactorization :=
      NumStability.HDP.Scalar.IndependentSums.Hoeffding.mgfIndependentSum
        (μ := μ) (X := X) lam (fun _ => (1 : ℝ)) hIndep
        (fun i => by simpa using ((hX i).2.2.2.2 lam).1)
    calc
      (∫ ω, Real.exp (lam * S ω) ∂μ) =
          ∏ i, ∫ ω, Real.exp (lam * (1 * X i ω)) ∂μ := by
            simpa [S] using hFactorization
      _ ≤ ∏ i, Real.exp (K i ^ 2 * lam ^ 2) := hProd
      _ = Real.exp (E * lam ^ 2) := by
        rw [← Real.exp_sum]
        congr 1
        dsimp [E]
        rw [Finset.sum_mul]
  have hS_linear :
      SubGaussianLinearMGF μ S (Real.sqrt E) := by
    refine ⟨hS_meas, Real.sqrt_pos.2 hE, hS_int, hS_mean, ?_⟩
    intro lam
    refine ⟨hS_exp lam, ?_⟩
    simpa [Real.sq_sqrt hE.le, E, mul_comm] using hS_mgf lam
  rcases psiTwoGaugeCharacterizations
      (μ := μ) (X := S) ⟨hS_int, hS_mean⟩ with
    ⟨C, hC, hGauge, _⟩
  refine ⟨C, hC, ?_, ?_⟩
  · simpa [S, E] using hS_linear
  · exact hGauge .linearMGF (by positivity) hS_linear

/-! The tail form of Theorem 2.6.2.  The positive energy hypothesis keeps the
    denominator nonzero; the all-zero family is handled separately by the
    deterministic branch rather than by an undefined quotient. -/
theorem independentCenteredSubGaussianTail
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {K : ι → ℝ}
    (hX : ∀ i, SubGaussianLinearMGF μ (X i) (K i))
    (hIndep : iIndepFun X μ)
    (hEnergy : 0 < ∑ i, K i ^ 2)
    {t : ℝ} (ht : 0 ≤ t) :
    μ.real {ω | |∑ i, X i ω| ≥ t} ≤
      2 * Real.exp (-t ^ 2 / (4 * ∑ i, K i ^ 2)) := by
  let S : Ω → ℝ := fun ω => ∑ i, X i ω
  let E : ℝ := ∑ i, K i ^ 2
  have hE : 0 < E := by simpa [E] using hEnergy
  rcases independentCenteredSubGaussianSum hX hIndep hEnergy with
    ⟨_, _, hS, _⟩
  have hTail := subGaussianLinearToTail hS
  have hBound := hTail.2.2 t ht
  convert hBound using 1;
    norm_num [S, E, mul_pow, Real.sq_sqrt hE.le]

/-! The weighted linear-form version of Theorem 2.6.3.  As in the preceding
tail theorem, the source's ψ₂ scale is represented by a common positive
linear-MGF scale; positive coefficient energy keeps the displayed
denominator nonzero. -/
theorem independentWeightedCenteredSubGaussianTail
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {K : ℝ}
    (hK : 0 < K)
    (hX : ∀ i, SubGaussianLinearMGF μ (X i) K)
    (hIndep : iIndepFun X μ)
    {a : ι → ℝ}
    (hEnergy : 0 < ∑ i, a i ^ 2)
    {t : ℝ} (ht : 0 ≤ t) :
    μ.real {ω | |∑ i, a i * X i ω| ≥ t} ≤
      2 * Real.exp (-t ^ 2 / (4 * K ^ 2 * ∑ i, a i ^ 2)) := by
  let Y : ι → Ω → ℝ := fun i ω => a i * X i ω
  let S : Ω → ℝ := fun ω => ∑ i, Y i ω
  let A : ℝ := ∑ i, a i ^ 2
  have hA : 0 < A := by simpa [A] using hEnergy
  have hY_meas : ∀ i, Measurable (Y i) := by
    intro i
    dsimp [Y]
    exact measurable_const.mul (hX i).1
  have hIndepY : iIndepFun Y μ := by
    have h := hIndep.comp (fun i x => a i * x) (fun i => by fun_prop)
    simpa [Y, Function.comp_def] using h
  have hS_meas : Measurable S := by
    dsimp [S]
    exact Finset.measurable_sum Finset.univ (fun i _ => hY_meas i)
  have hS_int : Integrable S μ := by
    dsimp [S]
    simpa only [Finset.sum_apply] using
      (integrable_finset_sum (μ := μ) Finset.univ
        (fun i hi => (hX i).2.2.1.const_mul (a i)))
  have hS_mean : (∫ ω, S ω ∂μ) = 0 := by
    dsimp [S]
    rw [integral_finset_sum]
    · apply Finset.sum_eq_zero
      intro i hi
      rw [integral_const_mul, (hX i).2.2.2.1]
      ring
    · exact fun i hi => (hX i).2.2.1.const_mul (a i)
  have hS_exp (lam : ℝ) :
      Integrable (fun ω => Real.exp (lam * S ω)) μ := by
    have h := hIndepY.integrable_exp_mul_sum
      hY_meas (s := Finset.univ)
      (fun i hi => by
        convert ((hX i).2.2.2.2 (lam * a i)).1 using 1
        all_goals simp [Y]
        all_goals ring)
    simpa [S] using h
  have hS_mgf (lam : ℝ) :
      (∫ ω, Real.exp (lam * S ω) ∂μ) ≤
        Real.exp (K ^ 2 * lam ^ 2 * A) := by
    have hFactor (i : ι) :
        (∫ ω, Real.exp (lam * (1 * Y i ω)) ∂μ) ≤
          Real.exp (K ^ 2 * (lam * a i) ^ 2) := by
      simpa [Y, mul_assoc, mul_left_comm, mul_comm] using
        ((hX i).2.2.2.2 (lam * a i)).2
    have hProd :
        (∏ i, ∫ ω, Real.exp (lam * (1 * Y i ω)) ∂μ) ≤
          ∏ i, Real.exp (K ^ 2 * (lam * a i) ^ 2) := by
      apply Finset.prod_le_prod
      · intro i hi
        exact integral_nonneg (fun ω => Real.exp_nonneg _)
      · intro i hi
        exact hFactor i
    have hFactorization :=
      NumStability.HDP.Scalar.IndependentSums.Hoeffding.mgfIndependentSum
        (μ := μ) (X := Y) lam (fun _ => (1 : ℝ)) hIndepY
        (fun i => by
          convert ((hX i).2.2.2.2 (lam * a i)).1 using 1
          all_goals simp [Y]
          all_goals ring)
    calc
      (∫ ω, Real.exp (lam * S ω) ∂μ) =
          ∏ i, ∫ ω, Real.exp (lam * (1 * Y i ω)) ∂μ := by
            simpa [S] using hFactorization
      _ ≤ ∏ i, Real.exp (K ^ 2 * (lam * a i) ^ 2) := hProd
      _ = Real.exp (K ^ 2 * lam ^ 2 * A) := by
        rw [← Real.exp_sum]
        congr 1
        dsimp [A]
        simp_rw [mul_pow]
        rw [Finset.mul_sum]
        ring
  let L : ℝ := K * Real.sqrt A
  have hL : 0 < L := by
    dsimp [L]
    exact mul_pos hK (Real.sqrt_pos.2 hA)
  have hS_linear : SubGaussianLinearMGF μ S L := by
    refine ⟨hS_meas, hL, hS_int, hS_mean, ?_⟩
    intro lam
    refine ⟨hS_exp lam, ?_⟩
    have hLsq : L ^ 2 = K ^ 2 * A := by
      dsimp [L]
      rw [mul_pow, Real.sq_sqrt hA.le]
    calc
      (∫ ω, Real.exp (lam * S ω) ∂μ) ≤
          Real.exp (K ^ 2 * lam ^ 2 * A) := hS_mgf lam
      _ = Real.exp (L ^ 2 * lam ^ 2) := by rw [hLsq]; ring
  have hBound := (subGaussianLinearToTail hS_linear).2.2 t ht
  have hDen : (2 * L) ^ 2 = 4 * K ^ 2 * A := by
    dsimp [L]
    simp only [mul_pow]
    rw [Real.sq_sqrt hA.le]
    ring
  rw [hDen] at hBound
  simpa [S, Y, A] using hBound

/-! The exact gauge is subadditive at the level of admissible scales.  This is
the analytic core needed before passing to the a.e. quotient in Exercise
2.5.7. -/
lemma psiTwoAdmissible_add_of_admissible
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X Y : Ω → ℝ} {s t : ℝ≥0∞}
    (hs : PsiTwoAdmissible μ X s) (ht : PsiTwoAdmissible μ Y t) :
    PsiTwoAdmissible μ (fun ω => X ω + Y ω) (s + t) := by
  rcases hs with ⟨hX, hs0, hsTop, hXs, hXbound⟩
  rcases ht with ⟨hY, ht0, htTop, hYt, hYbound⟩
  have hspos : 0 < s.toReal := ENNReal.toReal_pos hs0 hsTop
  have htpos : 0 < t.toReal := ENNReal.toReal_pos ht0 htTop
  have hstTop : s + t ≠ ∞ := ENNReal.add_ne_top.2 ⟨hsTop, htTop⟩
  have hst0 : s + t ≠ 0 := by
    simp [hs0, ht0]
  have hstpos : 0 < (s + t).toReal := ENNReal.toReal_pos hst0 hstTop
  have hstreal : (s + t).toReal = s.toReal + t.toReal := by
    simpa using ENNReal.toReal_add hsTop htTop
  let a : ℝ := s.toReal / (s + t).toReal
  let b : ℝ := t.toReal / (s + t).toReal
  have ha : 0 ≤ a := div_nonneg hspos.le hstpos.le
  have hb : 0 ≤ b := div_nonneg htpos.le hstpos.le
  have hab : a + b = 1 := by
    dsimp [a, b]
    rw [hstreal]
    field_simp
  have harg : ∀ ω,
      (X ω + Y ω) ^ 2 / (s + t).toReal ^ 2 ≤
        a * (X ω ^ 2 / s.toReal ^ 2) + b * (Y ω ^ 2 / t.toReal ^ 2) := by
    intro ω
    have hsq := sq_nonneg (t.toReal * X ω - s.toReal * Y ω)
    dsimp [a, b]
    rw [hstreal]
    field_simp
    nlinarith
  have hpoint : ∀ ω,
      Real.exp ((X ω + Y ω) ^ 2 / (s + t).toReal ^ 2) ≤
        a * Real.exp (X ω ^ 2 / s.toReal ^ 2) +
          b * Real.exp (Y ω ^ 2 / t.toReal ^ 2) := by
    intro ω
    have hconv := convexOn_exp.2
      (show X ω ^ 2 / s.toReal ^ 2 ∈ Set.univ by trivial)
      (show Y ω ^ 2 / t.toReal ^ 2 ∈ Set.univ by trivial)
      ha hb hab
    exact (Real.exp_le_exp.mpr (harg ω)).trans hconv
  have hsum : Integrable (fun ω =>
      a * Real.exp (X ω ^ 2 / s.toReal ^ 2) +
        b * Real.exp (Y ω ^ 2 / t.toReal ^ 2)) μ := by
    exact (hXs.const_mul a).add (hYt.const_mul b)
  have hInt : Integrable
      (fun ω => Real.exp ((X ω + Y ω) ^ 2 / (s + t).toReal ^ 2)) μ := by
    refine MeasureTheory.Integrable.mono' hsum ?_ ?_
    · fun_prop
    · filter_upwards [] with ω
      simpa only [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _)] using hpoint ω
  refine ⟨hX.add hY, hst0, hstTop, hInt, ?_⟩
  have hmono := MeasureTheory.integral_mono_ae hInt hsum
    (Filter.Eventually.of_forall hpoint)
  calc
    (∫ ω, Real.exp ((X ω + Y ω) ^ 2 / (s + t).toReal ^ 2) ∂μ) ≤
        ∫ ω, a * Real.exp (X ω ^ 2 / s.toReal ^ 2) +
          b * Real.exp (Y ω ^ 2 / t.toReal ^ 2) ∂μ := hmono
    _ = a * (∫ ω, Real.exp (X ω ^ 2 / s.toReal ^ 2) ∂μ) +
          b * (∫ ω, Real.exp (Y ω ^ 2 / t.toReal ^ 2) ∂μ) := by
      rw [MeasureTheory.integral_add (hXs.const_mul a) (hYt.const_mul b),
        MeasureTheory.integral_const_mul, MeasureTheory.integral_const_mul]
    _ ≤ a * 2 + b * 2 := by
      gcongr
    _ = 2 := by rw [← add_mul, hab, one_mul]

lemma psiTwoAdmissible_neg_iff
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X : Ω → ℝ} {t : ℝ≥0∞} :
    PsiTwoAdmissible μ (fun ω => -X ω) t ↔ PsiTwoAdmissible μ X t := by
  constructor <;> intro h
  · rcases h with ⟨hX, ht0, htTop, hInt, hBound⟩
    have hX' : Measurable X := by simpa using hX.neg
    refine ⟨hX', ht0, htTop, ?_, ?_⟩
    · simpa [sq] using hInt
    · simpa [sq] using hBound
  · rcases h with ⟨hX, ht0, htTop, hInt, hBound⟩
    refine ⟨hX.neg, ht0, htTop, ?_, ?_⟩
    · simpa [sq] using hInt
    · simpa [sq] using hBound

theorem psiTwoGauge_neg
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X : Ω → ℝ} :
    PsiTwoGauge μ (fun ω => -X ω) = PsiTwoGauge μ X := by
  unfold PsiTwoGauge
  congr 1
  ext t
  exact psiTwoAdmissible_neg_iff

theorem psiTwoGauge_add_le
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X Y : Ω → ℝ} :
    PsiTwoGauge μ (fun ω => X ω + Y ω) ≤
      PsiTwoGauge μ X + PsiTwoGauge μ Y := by
  change sInf {t : ℝ≥0∞ | PsiTwoAdmissible μ (fun ω => X ω + Y ω) t} ≤
    sInf {s : ℝ≥0∞ | PsiTwoAdmissible μ X s} +
      sInf {t : ℝ≥0∞ | PsiTwoAdmissible μ Y t}
  simp only [sInf_eq_iInf]
  apply ENNReal.le_iInf₂_add_iInf₂
  intro s hs t ht
  have hadd := psiTwoAdmissible_add_of_admissible hs ht
  exact iInf_le_of_le (s + t) (iInf_le_of_le hadd le_rfl)

lemma psiTwoAdmissible_smul_iff
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X : Ω → ℝ} {c : ℝ} (hc : c ≠ 0)
    {t : ℝ≥0∞} (ht0 : t ≠ 0) (htTop : t ≠ ∞) :
    PsiTwoAdmissible μ (fun ω => c * X ω) (ENNReal.ofReal |c| * t) ↔
      PsiTwoAdmissible μ X t := by
  have hcabs : 0 < |c| := abs_pos.mpr hc
  have hcof0 : ENNReal.ofReal |c| ≠ 0 :=
    (ENNReal.ofReal_ne_zero_iff).2 hcabs
  have hct0 : ENNReal.ofReal |c| * t ≠ 0 := by
    exact mul_ne_zero hcof0 ht0
  have hctTop : ENNReal.ofReal |c| * t ≠ ∞ := by
    exact ENNReal.mul_ne_top ENNReal.ofReal_ne_top htTop
  have hscale : (ENNReal.ofReal |c| * t).toReal = |c| * t.toReal := by
    simp [ENNReal.toReal_mul]
  have harg : ∀ ω,
      (c * X ω) ^ 2 / (|c| * t.toReal) ^ 2 = X ω ^ 2 / t.toReal ^ 2 := by
    intro ω
    field_simp [ne_of_gt hcabs, ne_of_gt (ENNReal.toReal_pos ht0 htTop)]
    rw [sq_abs]
    ring
  have harg' : ∀ ω,
      (c * X ω) ^ 2 * ((|c| * t.toReal) ^ 2)⁻¹ =
        X ω ^ 2 * (t.toReal ^ 2)⁻¹ := by
    intro ω
    simpa [div_eq_mul_inv] using harg ω
  constructor
  · intro h
    rcases h with ⟨hX, _, _, hInt, hBound⟩
    have hX' : Measurable X := by
      have := hX.const_mul c⁻¹
      simpa [hc, mul_assoc] using this
    refine ⟨hX', ht0, htTop, ?_, ?_⟩
    · simpa only [hscale, div_eq_mul_inv, harg'] using hInt
    · simpa only [hscale, div_eq_mul_inv, harg'] using hBound
  · intro h
    rcases h with ⟨hX, _, _, hInt, hBound⟩
    refine ⟨hX.const_mul c, hct0, hctTop, ?_, ?_⟩
    · simpa only [hscale, div_eq_mul_inv, harg'] using hInt
    · simpa only [hscale, div_eq_mul_inv, harg'] using hBound

theorem psiTwoGauge_smul_of_ne_zero
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X : Ω → ℝ} {c : ℝ} (hc : c ≠ 0) :
    PsiTwoGauge μ (fun ω => c * X ω) =
      ENNReal.ofReal |c| * PsiTwoGauge μ X := by
  let a : ℝ≥0∞ := ENNReal.ofReal |c|
  have ha0 : a ≠ 0 := by
    dsimp [a]
    exact (ENNReal.ofReal_ne_zero_iff).2 (abs_pos.mpr hc)
  have haTop : a ≠ ∞ := by
    exact ENNReal.ofReal_ne_top
  apply le_antisymm
  · rw [show PsiTwoGauge μ (fun ω => c * X ω) =
      sInf {t : ℝ≥0∞ | PsiTwoAdmissible μ (fun ω => c * X ω) t} by rfl,
      show PsiTwoGauge μ X =
        sInf {t : ℝ≥0∞ | PsiTwoAdmissible μ X t} by rfl,
      sInf_eq_iInf', sInf_eq_iInf']
    rw [ENNReal.mul_iInf_of_ne ha0 haTop]
    apply le_iInf
    intro t
    exact iInf_le_of_le ⟨a * t.1, by
      have hiff := psiTwoAdmissible_smul_iff (μ := μ) (X := X) hc
        t.2.2.1 t.2.2.2.1
      exact hiff.2 t.2⟩ le_rfl
  · rw [show PsiTwoGauge μ (fun ω => c * X ω) =
      sInf {t : ℝ≥0∞ | PsiTwoAdmissible μ (fun ω => c * X ω) t} by rfl,
      show PsiTwoGauge μ X =
        sInf {t : ℝ≥0∞ | PsiTwoAdmissible μ X t} by rfl,
      sInf_eq_iInf', sInf_eq_iInf']
    rw [ENNReal.mul_iInf_of_ne ha0 haTop]
    apply le_iInf
    intro t
    have hiff := psiTwoAdmissible_smul_iff (μ := μ)
      (X := fun ω => c * X ω) (c := c⁻¹) (inv_ne_zero hc)
      t.2.2.1 t.2.2.2.1
    have hscaled : PsiTwoAdmissible μ X
        (ENNReal.ofReal |c⁻¹| * t.1) := by
      have hfun : (fun ω => c⁻¹ * (c * X ω)) = X := by
        funext ω
        field_simp [hc]
      simpa [hfun] using hiff.2 t.2
    have hca : ENNReal.ofReal |c| * ENNReal.ofReal |c⁻¹| = 1 := by
      rw [← ENNReal.ofReal_mul (abs_nonneg c)]
      simp [abs_inv, hc]
    have hmul : a * (ENNReal.ofReal |c⁻¹| * t.1) = t.1 := by
      dsimp [a]
      rw [← mul_assoc, hca, one_mul]
    exact iInf_le_of_le ⟨ENNReal.ofReal |c⁻¹| * t.1, hscaled⟩ (by
      exact le_of_eq hmul)

theorem psiTwoGauge_zero
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] :
    PsiTwoGauge μ (fun _ : Ω => (0 : ℝ)) = 0 := by
  apply le_antisymm
  · apply le_of_forall_gt_imp_ge_of_dense
    intro r hr
    by_cases hrTop : r = ∞
    · simp [hrTop]
    have hr0 : r ≠ 0 := ne_of_gt hr
    have hAd : PsiTwoAdmissible μ (fun _ : Ω => (0 : ℝ)) r := by
      refine ⟨measurable_const, hr0, hrTop, ?_, ?_⟩
      · simp
      · simp
    exact sInf_le hAd
  · exact bot_le

lemma psiTwoAdmissible_ae_congr
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X Y : Ω → ℝ} (hX : Measurable X) (hY : Measurable Y)
    (hXY : X =ᵐ[μ] Y) {t : ℝ≥0∞} :
    PsiTwoAdmissible μ X t ↔ PsiTwoAdmissible μ Y t := by
  have hfun : (fun ω => Real.exp (X ω ^ 2 / t.toReal ^ 2)) =ᵐ[μ]
      (fun ω => Real.exp (Y ω ^ 2 / t.toReal ^ 2)) := by
    filter_upwards [hXY] with ω hω
    simp [hω]
  constructor
  · intro h
    rcases h with ⟨_, ht0, htTop, hInt, hBound⟩
    refine ⟨hY, ht0, htTop, hInt.congr hfun, ?_⟩
    rw [integral_congr_ae hfun] at hBound
    exact hBound
  · intro h
    rcases h with ⟨_, ht0, htTop, hInt, hBound⟩
    refine ⟨hX, ht0, htTop, hInt.congr hfun.symm, ?_⟩
    rw [integral_congr_ae hfun.symm] at hBound
    exact hBound

theorem psiTwoGauge_ae_congr
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X Y : Ω → ℝ} (hX : Measurable X) (hY : Measurable Y)
    (hXY : X =ᵐ[μ] Y) :
    PsiTwoGauge μ X = PsiTwoGauge μ Y := by
  unfold PsiTwoGauge
  congr 1
  ext t
  exact psiTwoAdmissible_ae_congr hX hY hXY

lemma psiTwoAdmissible_mono
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X : Ω → ℝ} {s u : ℝ≥0∞}
    (hs : PsiTwoAdmissible μ X s) (hsu : s ≤ u)
    (hu0 : u ≠ 0) (huTop : u ≠ ∞) :
    PsiTwoAdmissible μ X u := by
  rcases hs with ⟨hX, hs0, hsTop, hInt, hBound⟩
  have hspos : 0 < s.toReal := ENNReal.toReal_pos hs0 hsTop
  have hupos : 0 < u.toReal := ENNReal.toReal_pos hu0 huTop
  have hsto : s.toReal ≤ u.toReal := ENNReal.toReal_mono huTop hsu
  have hsq : s.toReal ^ 2 ≤ u.toReal ^ 2 :=
    (sq_le_sq₀ hspos.le hupos.le).2 hsto
  have harg : ∀ ω,
      X ω ^ 2 / u.toReal ^ 2 ≤ X ω ^ 2 / s.toReal ^ 2 := by
    intro ω
    apply (div_le_div_iff₀ (by positivity : 0 < u.toReal ^ 2)
      (by positivity : 0 < s.toReal ^ 2)).2
    exact mul_le_mul_of_nonneg_left hsq (sq_nonneg (X ω))
  have hpoint : ∀ ω,
      Real.exp (X ω ^ 2 / u.toReal ^ 2) ≤
        Real.exp (X ω ^ 2 / s.toReal ^ 2) := fun ω =>
    Real.exp_le_exp.mpr (harg ω)
  have hInt' : Integrable (fun ω => Real.exp (X ω ^ 2 / u.toReal ^ 2)) μ := by
    refine MeasureTheory.Integrable.mono' hInt ?_ ?_
    · fun_prop
    · filter_upwards [] with ω
      simpa only [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _)] using hpoint ω
  refine ⟨hX, hu0, huTop, hInt', ?_⟩
  exact (MeasureTheory.integral_mono_ae hInt' hInt
    (Filter.Eventually.of_forall hpoint)).trans hBound

lemma psiTwoAdmissible_of_gauge_zero
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] {X : Ω → ℝ}
    (hX : Measurable X) (hGauge : PsiTwoGauge μ X = 0) {K : ℝ} (hK : 0 < K) :
    PsiTwoAdmissible μ X (ENNReal.ofReal K) := by
  have hlt : PsiTwoGauge μ X < ENNReal.ofReal K := by
    rw [hGauge]
    exact ENNReal.ofReal_pos.mpr hK
  unfold PsiTwoGauge at hlt
  rcases (sInf_lt_iff.mp hlt) with ⟨s, hs, hsK⟩
  have hMono := psiTwoAdmissible_mono hs hsK.le
    ((ENNReal.ofReal_ne_zero_iff).2 hK) ENNReal.ofReal_ne_top
  exact ⟨hX, hMono.2⟩

theorem psiTwoGauge_eq_zero_iff_ae_eq_zero
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] {X : Ω → ℝ}
    (hX : Measurable X) :
    PsiTwoGauge μ X = 0 ↔ X =ᵐ[μ] (fun _ : Ω => (0 : ℝ)) := by
  constructor
  · intro hGauge
    have hTail : ∀ K : ℝ, 0 < K → ∀ t : ℝ, 0 ≤ t →
        μ.real {ω | |X ω| ≥ t} ≤ 2 * Real.exp (-t ^ 2 / K ^ 2) := by
      intro K hK t ht
      have hAd := psiTwoAdmissible_of_gauge_zero hX hGauge hK
      have hPoint : SubGaussianSquarePoint μ X K := by
        refine ⟨hX, hK, ?_, ?_⟩
        · simpa [ENNReal.toReal_ofReal hK.le] using hAd.2.2.2.1
        · simpa [ENNReal.toReal_ofReal hK.le] using hAd.2.2.2.2
      exact squareMGFToTail hX hK ⟨hPoint.2.2.1, hPoint.2.2.2⟩ ht
    have hLpOne : LpMomentGrowth μ X (8 * Real.exp 1) := by
      have h := tailToLpMomentGrowth hX (by norm_num : (0 : ℝ) < 1)
        (hTail 1 (by norm_num))
      simpa using h
    have hInt : Integrable (fun ω => |X ω|) μ := by
      have h := hLpOne.2 1 (by norm_num : (1 : ℝ) ≤ 1)
      simpa using h.1
    have hBound : ∀ K : ℝ, 0 < K →
        (∫ ω, |X ω| ∂μ) ≤ 8 * Real.exp 1 * K := by
      intro K hK
      have hLp := tailToLpMomentGrowth hX hK (hTail K hK)
      have h := hLp.2 1 (by norm_num : (1 : ℝ) ≤ 1)
      simpa using h.2
    have hIntegralZero : (∫ ω, |X ω| ∂μ) = 0 := by
      apply le_antisymm
      · apply le_of_forall_gt_imp_ge_of_dense
        intro ε hε
        have hK : 0 < ε / (8 * Real.exp 1) := by positivity
        calc
          (∫ ω, |X ω| ∂μ) ≤ 8 * Real.exp 1 * (ε / (8 * Real.exp 1)) := by
            exact (hBound (ε / (8 * Real.exp 1)) hK).trans_eq (by
              field_simp)
          _ = ε := by field_simp
      · exact integral_nonneg_of_ae
          (Filter.Eventually.of_forall (fun ω => abs_nonneg (X ω)))
    have hAbs : (fun ω => |X ω|) =ᵐ[μ] (fun _ : Ω => (0 : ℝ)) :=
      (integral_eq_zero_iff_of_nonneg
        (fun ω => abs_nonneg (X ω)) hInt).mp hIntegralZero
    filter_upwards [hAbs] with ω hω
    exact abs_eq_zero.mp hω
  · intro hZero
    rw [psiTwoGauge_ae_congr hX measurable_const hZero]
    exact psiTwoGauge_zero

/-- At every positive finite exact `ψ₂` gauge, the defining exponential-square
bound is attained.  Fatou's lemma closes the infimum over larger admissible
scales. -/
theorem psiTwoGauge_squarePoint_of_pos
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ}
    (hX : Measurable X) (hFinite : PsiTwoGauge μ X < ∞)
    (hGaugePos : 0 < PsiTwoGauge μ X) :
    SubGaussianSquarePoint μ X (PsiTwoGauge μ X).toReal := by
  have hGaugeTop : PsiTwoGauge μ X ≠ ∞ := ne_of_lt hFinite
  have hGaugeZero : PsiTwoGauge μ X ≠ 0 := ne_of_gt hGaugePos
  have hGaugeRealPos : 0 < (PsiTwoGauge μ X).toReal :=
    ENNReal.toReal_pos hGaugeZero hGaugeTop
  let K : ℕ → ℝ := fun n =>
    (PsiTwoGauge μ X).toReal + 1 / ((n : ℝ) + 1)
  have hKPos : ∀ n, 0 < K n := by
    intro n
    dsimp [K]
    positivity
  have hGaugeLt : ∀ n, PsiTwoGauge μ X < ENNReal.ofReal (K n) := by
    intro n
    rw [← ENNReal.ofReal_toReal hGaugeTop]
    exact (ENNReal.ofReal_lt_ofReal_iff (hKPos n)).2 (by
      dsimp [K]
      have heps : 0 < 1 / ((n : ℝ) + 1) := by positivity
      linarith)
  have hAd : ∀ n, PsiTwoAdmissible μ X (ENNReal.ofReal (K n)) := by
    intro n
    have hlt := hGaugeLt n
    unfold PsiTwoGauge at hlt
    rcases (sInf_lt_iff.mp hlt) with ⟨s, hs, hsK⟩
    exact psiTwoAdmissible_mono hs hsK.le
      ((ENNReal.ofReal_ne_zero_iff).2 (hKPos n)) ENNReal.ofReal_ne_top
  have hPoint : ∀ n, SubGaussianSquarePoint μ X (K n) := by
    intro n
    have h := hAd n
    refine ⟨h.1, hKPos n, ?_, ?_⟩
    · simpa [ENNReal.toReal_ofReal (hKPos n).le] using h.2.2.2.1
    · simpa [ENNReal.toReal_ofReal (hKPos n).le] using h.2.2.2.2
  let f : ℕ → Ω → ℝ≥0∞ := fun n ω =>
    ENNReal.ofReal (Real.exp (X ω ^ 2 / (K n) ^ 2))
  let F : Ω → ℝ≥0∞ := fun ω =>
    ENNReal.ofReal
      (Real.exp (X ω ^ 2 / (PsiTwoGauge μ X).toReal ^ 2))
  have hK_tendsto : Tendsto K atTop
      (nhds (PsiTwoGauge μ X).toReal) := by
    dsimp [K]
    simpa using tendsto_const_nhds.add
      (tendsto_one_div_add_atTop_nhds_zero_nat :
        Tendsto (fun n : ℕ => 1 / ((n : ℝ) + 1)) atTop (nhds 0))
  have hfMeas : ∀ n, Measurable (f n) := by
    intro n
    dsimp [f]
    fun_prop
  have hfTendsto : ∀ ω, Tendsto (fun n => f n ω) atTop (nhds (F ω)) := by
    intro ω
    have hrealcont : ContinuousAt
        (fun k : ℝ => Real.exp (X ω ^ 2 / k ^ 2))
        (PsiTwoGauge μ X).toReal := by
      fun_prop (disch := positivity)
    have hcont : ContinuousAt
        (fun k : ℝ => ENNReal.ofReal (Real.exp (X ω ^ 2 / k ^ 2)))
        (PsiTwoGauge μ X).toReal := by
      simpa only [Function.comp_apply] using
        ENNReal.continuous_ofReal.continuousAt.comp hrealcont
    exact hcont.tendsto.comp hK_tendsto
  have hFatou : (∫⁻ ω, F ω ∂μ) ≤
      liminf (fun n => ∫⁻ ω, f n ω ∂μ) atTop := by
    have h := lintegral_liminf_le (μ := μ) hfMeas
    simpa only [(hfTendsto _).liminf_eq] using h
  have hLinBound : ∀ n, (∫⁻ ω, f n ω ∂μ) ≤ ENNReal.ofReal 2 := by
    intro n
    rw [← ofReal_integral_eq_lintegral_ofReal (hPoint n).2.2.1
      (Filter.Eventually.of_forall (fun ω => (Real.exp_pos _).le))]
    exact ENNReal.ofReal_le_ofReal (hPoint n).2.2.2
  have hFBound : (∫⁻ ω, F ω ∂μ) ≤ ENNReal.ofReal 2 :=
    hFatou.trans (Filter.liminf_le_of_frequently_le'
      (Filter.Frequently.of_forall hLinBound))
  have hTargetInt : Integrable
      (fun ω => Real.exp
        (X ω ^ 2 / (PsiTwoGauge μ X).toReal ^ 2)) μ := by
    refine ⟨?_, ?_⟩
    · fun_prop
    · rw [hasFiniteIntegral_iff_enorm]
      have hEq : (fun ω =>
          ‖Real.exp (X ω ^ 2 / (PsiTwoGauge μ X).toReal ^ 2)‖ₑ) = F := by
        funext ω
        simpa [F] using (ofReal_norm_eq_enorm
          (Real.exp
            (X ω ^ 2 / (PsiTwoGauge μ X).toReal ^ 2))).symm
      rw [hEq]
      exact hFBound.trans_lt ENNReal.ofReal_lt_top
  refine ⟨hX, hGaugeRealPos, hTargetInt, ?_⟩
  rw [integral_eq_lintegral_of_nonneg_ae
    (Filter.Eventually.of_forall (fun ω => (Real.exp_pos _).le))
    hTargetInt.aestronglyMeasurable]
  change (∫⁻ ω, F ω ∂μ).toReal ≤ 2
  exact ENNReal.toReal_le_of_le_ofReal (by positivity) hFBound

/-! Section 2.5 body display following Equation (2.16).  Unlike
`SubGaussianSquarePoint`, this statement retains the source's zero-gauge
variable and totalizes its displayed quotient in the standard Lean way. -/
theorem psiTwoGauge_squareMoment
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ}
    (hX : Measurable X) (hFinite : PsiTwoGauge μ X < ∞) :
    Integrable
        (fun ω => Real.exp
          (X ω ^ 2 / (PsiTwoGauge μ X).toReal ^ 2)) μ ∧
      (∫ ω, Real.exp
        (X ω ^ 2 / (PsiTwoGauge μ X).toReal ^ 2) ∂μ) ≤ 2 := by
  by_cases hGaugeZero : PsiTwoGauge μ X = 0
  · have hXZero : X =ᵐ[μ] (fun _ω : Ω => (0 : ℝ)) :=
      (psiTwoGauge_eq_zero_iff_ae_eq_zero hX).mp hGaugeZero
    have hFun : (fun ω => Real.exp
        (X ω ^ 2 / (PsiTwoGauge μ X).toReal ^ 2)) =ᵐ[μ]
        (fun _ω : Ω => (1 : ℝ)) := by
      filter_upwards [hXZero] with ω hω
      simp [hω, hGaugeZero]
    have hInt : Integrable (fun ω => Real.exp
        (X ω ^ 2 / (PsiTwoGauge μ X).toReal ^ 2)) μ :=
      (integrable_const (1 : ℝ)).congr hFun.symm
    refine ⟨hInt, ?_⟩
    rw [integral_congr_ae hFun]
    simp
  · have hGaugePos : 0 < PsiTwoGauge μ X :=
      bot_lt_iff_ne_bot.mpr hGaugeZero
    have hPoint := psiTwoGauge_squarePoint_of_pos hX hFinite hGaugePos
    exact ⟨hPoint.2.2.1, hPoint.2.2.2⟩

/-! Equation (2.14): the exact `ψ₂` gauge gives a sub-Gaussian tail with
one universal numerical constant.  The factor two in the scale corresponds to
the source exponent constant `c = 1 / 4`; it also makes the infimum-based
definition usable without assuming that the infimum is attained. -/
theorem psiTwoGaugeToTail
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ}
    (hX : Measurable X) (hFinite : PsiTwoGauge μ X < ∞)
    {t : ℝ} (ht : 0 ≤ t) :
    μ.real {ω | |X ω| ≥ t} ≤
      2 * Real.exp
        (-t ^ 2 / (2 * (PsiTwoGauge μ X).toReal) ^ 2) := by
  by_cases hGaugeZero : PsiTwoGauge μ X = 0
  · by_cases htZero : t = 0
    · subst t
      have hset : {ω | |X ω| ≥ (0 : ℝ)} = Set.univ := by
        ext ω
        simp [abs_nonneg]
      rw [hset]
      simp [hGaugeZero]
    · have hXZero : X =ᵐ[μ] (fun _ω : Ω => (0 : ℝ)) :=
        (psiTwoGauge_eq_zero_iff_ae_eq_zero hX).mp hGaugeZero
      have hEvent : {ω | |X ω| ≥ t} =ᵐ[μ] (∅ : Set Ω) := by
        filter_upwards [hXZero] with ω hω
        change (t ≤ |X ω|) = False
        rw [hω, abs_zero]
        exact propext (iff_false_intro
          (not_le_of_gt (lt_of_le_of_ne ht (Ne.symm htZero))))
      rw [Measure.real_def, measure_congr hEvent]
      simp only [measure_empty, ENNReal.toReal_zero]
      positivity
  · let u : ℝ≥0∞ := 2 * PsiTwoGauge μ X
    have hu0 : u ≠ 0 := by
      dsimp [u]
      exact mul_ne_zero (by norm_num) hGaugeZero
    have huTop : u ≠ ∞ := by
      dsimp [u]
      exact ENNReal.mul_ne_top (by norm_num) (ne_of_lt hFinite)
    have hGaugeLt : PsiTwoGauge μ X < u := by
      dsimp [u]
      simpa [mul_comm] using ENNReal.mul_lt_mul_right hGaugeZero
        (ne_of_lt hFinite) (by norm_num : (1 : ℝ≥0∞) < 2)
    have huAdmissible : PsiTwoAdmissible μ X u := by
      unfold PsiTwoGauge at hGaugeLt
      rcases (sInf_lt_iff.mp hGaugeLt) with ⟨s, hs, hsu⟩
      exact psiTwoAdmissible_mono hs hsu.le hu0 huTop
    have huPos : 0 < u.toReal := ENNReal.toReal_pos hu0 huTop
    have hPoint : SubGaussianSquarePoint μ X u.toReal :=
      ⟨huAdmissible.1, huPos, huAdmissible.2.2.2.1,
        huAdmissible.2.2.2.2⟩
    have hTail := squareMGFToTail hPoint.1 hPoint.2.1
      ⟨hPoint.2.2.1, hPoint.2.2.2⟩ ht
    simpa [u, ENNReal.toReal_mul] using hTail

/-! Equation (2.15): finite exact `ψ₂` gauge controls every `Lᵖ` moment
with one universal numerical constant. -/
theorem psiTwoGaugeToLpMomentGrowth
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ}
    (hX : Measurable X) (hFinite : PsiTwoGauge μ X < ∞) :
    LpMomentGrowth μ X
      (16 * Real.exp 1 * (PsiTwoGauge μ X).toReal) := by
  by_cases hGaugeZero : PsiTwoGauge μ X = 0
  · have hXZero : X =ᵐ[μ] (fun _ω : Ω => (0 : ℝ)) :=
      (psiTwoGauge_eq_zero_iff_ae_eq_zero hX).mp hGaugeZero
    refine ⟨hX.aemeasurable, ?_⟩
    intro p hp
    have hp0 : p ≠ 0 := ne_of_gt (lt_of_lt_of_le zero_lt_one hp)
    have hPowZero : (fun ω => |X ω| ^ p) =ᵐ[μ]
        (fun _ω : Ω => (0 : ℝ)) := by
      filter_upwards [hXZero] with ω hω
      simp [hω, hp0]
    have hInt : Integrable (fun ω => |X ω| ^ p) μ := by
      exact (integrable_zero Ω ℝ μ).congr hPowZero.symm
    refine ⟨hInt, ?_⟩
    rw [integral_congr_ae hPowZero]
    simp [hGaugeZero, hp0]
  · have hGaugeRealPos : 0 < (PsiTwoGauge μ X).toReal :=
      ENNReal.toReal_pos hGaugeZero (ne_of_lt hFinite)
    have hTail : ∀ t : ℝ, 0 ≤ t →
        μ.real {ω | |X ω| ≥ t} ≤
          2 * Real.exp
            (-t ^ 2 / (2 * (PsiTwoGauge μ X).toReal) ^ 2) := by
      intro t ht
      exact psiTwoGaugeToTail hX hFinite ht
    have hGrowth := tailToLpMomentGrowth hX (by positivity)
      (K := 2 * (PsiTwoGauge μ X).toReal) hTail
    convert hGrowth using 1 <;> ring

/-! Equation (2.16): a centered finite-gauge variable has a global linear MGF
bound with one explicit universal coefficient. -/
theorem psiTwoGaugeToMGF
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ}
    (hX : Measurable X) (hFinite : PsiTwoGauge μ X < ∞)
    (hCenter : Integrable X μ ∧ (∫ ω, X ω ∂μ) = 0)
    (lam : ℝ) :
    Integrable (fun ω => Real.exp (lam * X ω)) μ ∧
      (∫ ω, Real.exp (lam * X ω) ∂μ) ≤
        Real.exp
          ((128 * Real.exp 1) ^ 2 * lam ^ 2 *
            (PsiTwoGauge μ X).toReal ^ 2) := by
  by_cases hGaugeZero : PsiTwoGauge μ X = 0
  · have hXZero : X =ᵐ[μ] (fun _ω : Ω => (0 : ℝ)) :=
      (psiTwoGauge_eq_zero_iff_ae_eq_zero hX).mp hGaugeZero
    have hFun : (fun ω => Real.exp (lam * X ω)) =ᵐ[μ]
        (fun _ω : Ω => (1 : ℝ)) := by
      filter_upwards [hXZero] with ω hω
      simp [hω]
    have hInt : Integrable (fun ω => Real.exp (lam * X ω)) μ :=
      (integrable_const (1 : ℝ)).congr hFun.symm
    refine ⟨hInt, ?_⟩
    rw [integral_congr_ae hFun]
    simp [hGaugeZero]
  · have hGaugePos : 0 < PsiTwoGauge μ X :=
      bot_lt_iff_ne_bot.mpr hGaugeZero
    have hPoint := psiTwoGauge_squarePoint_of_pos hX hFinite hGaugePos
    have hTail := subGaussianSquarePointToTail hPoint
    rcases subGaussianFromTail .linearMGF (fun _ => hCenter)
        hPoint.2.1 hTail with ⟨K, hK, hKBound, hLinear⟩
    have hLam := hLinear.2.2.2.2 lam
    refine ⟨hLam.1, hLam.2.trans ?_⟩
    apply Real.exp_le_exp.mpr
    have hSq : K ^ 2 ≤
        (128 * Real.exp 1 * (PsiTwoGauge μ X).toReal) ^ 2 :=
      (sq_le_sq₀ hK.le (by positivity)).2 hKBound
    calc
      K ^ 2 * lam ^ 2 ≤
          (128 * Real.exp 1 * (PsiTwoGauge μ X).toReal) ^ 2 *
            lam ^ 2 := mul_le_mul_of_nonneg_right hSq (sq_nonneg lam)
      _ = (128 * Real.exp 1) ^ 2 * lam ^ 2 *
          (PsiTwoGauge μ X).toReal ^ 2 := by ring

/-! Proposition 2.6.1 in its intrinsic `ψ₂`-norm form.  The absolute
constant is quantified before every family and probability space.  The proof
uses the exact-gauge MGF estimate above, independence, and a separate
zero-energy branch, so no externally chosen scale appears in the statement. -/
theorem independentCenteredSubGaussianSumPsiTwo :
    ∃ C : ℝ, 1 ≤ C ∧
      ∀ {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
        {μ : Measure Ω} [IsProbabilityMeasure μ]
        {X : ι → Ω → ℝ},
        (∀ i, IsSubGaussian μ (X i)) →
        (∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0) →
        iIndepFun X μ →
          IsSubGaussian μ (fun ω => ∑ i, X i ω) ∧
            (PsiTwoNorm μ (fun ω => ∑ i, X i ω)).toReal ^ 2 ≤
              C * ∑ i, (PsiTwoNorm μ (X i)).toReal ^ 2 := by
  let A : ℝ := 128 * Real.exp 1
  let B : ℝ := 4096 * Real.exp 1
  let C : ℝ := (B * A) ^ 2
  have hAone : 1 ≤ A := by
    dsimp [A]
    nlinarith [Real.one_le_exp (by norm_num : (0 : ℝ) ≤ 1)]
  have hBone : 1 ≤ B := by
    dsimp [B]
    nlinarith [Real.one_le_exp (by norm_num : (0 : ℝ) ≤ 1)]
  have hBAone : 1 ≤ B * A := by
    have hprod : 0 ≤ (B - 1) * (A - 1) :=
      mul_nonneg (sub_nonneg.mpr hBone) (sub_nonneg.mpr hAone)
    nlinarith
  have hCone : 1 ≤ C := by
    dsimp [C]
    nlinarith [sq_nonneg (B * A)]
  refine ⟨C, hCone, ?_⟩
  intro ι Ω instι instΩ μ instμ X hSub hCenter hIndep
  let S : Ω → ℝ := fun ω => ∑ i, X i ω
  let E : ℝ := ∑ i, (PsiTwoGauge μ (X i)).toReal ^ 2
  have hXMeas : ∀ i, Measurable (X i) := fun i => (hSub i).1
  have hXFinite : ∀ i, PsiTwoGauge μ (X i) < ∞ := by
    intro i
    exact (psiTwoGauge_finite_iff (μ := μ) (X := X i)).2 (hSub i).2
  have hEnonneg : 0 ≤ E := by
    dsimp [E]
    exact Finset.sum_nonneg fun i _ => sq_nonneg _
  have hSMeas : Measurable S := by
    dsimp [S]
    exact Finset.measurable_sum Finset.univ fun i _ => hXMeas i
  have hSInt : Integrable S μ := by
    dsimp [S]
    simpa only [Finset.sum_apply] using
      (integrable_finset_sum (μ := μ) Finset.univ
        (fun i _ => (hCenter i).1))
  have hSMean : (∫ ω, S ω ∂μ) = 0 := by
    dsimp [S]
    rw [integral_finset_sum]
    · exact Finset.sum_eq_zero fun i _ => (hCenter i).2
    · exact fun i _ => (hCenter i).1
  by_cases hEzero : E = 0
  · have hGaugeZero : ∀ i, PsiTwoGauge μ (X i) = 0 := by
      intro i
      have hSqZero : (PsiTwoGauge μ (X i)).toReal ^ 2 = 0 :=
        (Finset.sum_eq_zero_iff_of_nonneg
          (fun j _ => sq_nonneg (PsiTwoGauge μ (X j)).toReal)).mp hEzero i
            (Finset.mem_univ i)
      have hRealZero : (PsiTwoGauge μ (X i)).toReal = 0 := by
        nlinarith [sq_nonneg (PsiTwoGauge μ (X i)).toReal]
      exact ((ENNReal.toReal_eq_zero_iff _).mp hRealZero).resolve_right
        (ne_of_lt (hXFinite i))
    have hXZero : ∀ i, X i =ᵐ[μ] (fun _ : Ω => (0 : ℝ)) := by
      intro i
      exact (psiTwoGauge_eq_zero_iff_ae_eq_zero (hXMeas i)).mp (hGaugeZero i)
    have hAllZero : ∀ᵐ ω ∂μ, ∀ i ∈ (Finset.univ : Finset ι), X i ω = 0 := by
      rw [Filter.eventually_all_finset]
      intro i _
      exact hXZero i
    have hSZero : S =ᵐ[μ] (fun _ : Ω => (0 : ℝ)) := by
      filter_upwards [hAllZero] with ω hω
      simp [S, hω]
    have hSGaugeZero : PsiTwoGauge μ S = 0 :=
      (psiTwoGauge_eq_zero_iff_ae_eq_zero hSMeas).2 hSZero
    have hSSub : IsSubGaussian μ S := by
      refine ⟨hSMeas, ?_⟩
      exact (psiTwoGauge_finite_iff (μ := μ) (X := S)).1 (by
        rw [hSGaugeZero]
        simp)
    refine ⟨by simpa [S] using hSSub, ?_⟩
    simp [PsiTwoNorm, S, hSGaugeZero, E, hEzero]
  · have hEpos : 0 < E := lt_of_le_of_ne hEnonneg (Ne.symm hEzero)
    have hSExp (lam : ℝ) :
        Integrable (fun ω => Real.exp (lam * S ω)) μ := by
      have h := hIndep.integrable_exp_mul_sum hXMeas (s := Finset.univ)
        (fun i _ => by
          simpa using (psiTwoGaugeToMGF (hXMeas i) (hXFinite i)
            (hCenter i) lam).1)
      simpa [S] using h
    have hSMGF (lam : ℝ) :
        (∫ ω, Real.exp (lam * S ω) ∂μ) ≤
          Real.exp (A ^ 2 * lam ^ 2 * E) := by
      have hFactor (i : ι) :
          (∫ ω, Real.exp (lam * (1 * X i ω)) ∂μ) ≤
            Real.exp (A ^ 2 * lam ^ 2 *
              (PsiTwoGauge μ (X i)).toReal ^ 2) := by
        simpa [A] using (psiTwoGaugeToMGF (hXMeas i) (hXFinite i)
          (hCenter i) lam).2
      have hProd :
          (∏ i, ∫ ω, Real.exp (lam * (1 * X i ω)) ∂μ) ≤
            ∏ i, Real.exp (A ^ 2 * lam ^ 2 *
              (PsiTwoGauge μ (X i)).toReal ^ 2) := by
        apply Finset.prod_le_prod
        · intro i _
          exact integral_nonneg fun ω => Real.exp_nonneg _
        · intro i _
          exact hFactor i
      have hFactorization :=
        NumStability.HDP.Scalar.IndependentSums.Hoeffding.mgfIndependentSum
          (μ := μ) (X := X) lam (fun _ => (1 : ℝ)) hIndep
          (fun i => by
            simpa using (psiTwoGaugeToMGF (hXMeas i) (hXFinite i)
              (hCenter i) lam).1)
      calc
        (∫ ω, Real.exp (lam * S ω) ∂μ) =
            ∏ i, ∫ ω, Real.exp (lam * (1 * X i ω)) ∂μ := by
              simpa [S] using hFactorization
        _ ≤ ∏ i, Real.exp (A ^ 2 * lam ^ 2 *
            (PsiTwoGauge μ (X i)).toReal ^ 2) := hProd
        _ = Real.exp (A ^ 2 * lam ^ 2 * E) := by
          rw [← Real.exp_sum]
          congr 1
          dsimp [E]
          rw [Finset.mul_sum]
    have hKpos : 0 < A * Real.sqrt E :=
      mul_pos (lt_of_lt_of_le zero_lt_one hAone) (Real.sqrt_pos.2 hEpos)
    have hSLinear : SubGaussianLinearMGF μ S (A * Real.sqrt E) := by
      refine ⟨hSMeas, hKpos, hSInt, hSMean, ?_⟩
      intro lam
      refine ⟨hSExp lam, ?_⟩
      have hEsqrt : (Real.sqrt E) ^ 2 = E := Real.sq_sqrt hEpos.le
      convert hSMGF lam using 1
      rw [mul_pow, hEsqrt]
      ring
    have hGaugeBound :
        PsiTwoGauge μ S ≤ ENNReal.ofReal (B * (A * Real.sqrt E)) := by
      simpa [B] using
        (psiTwoGauge_le_of_property .linearMGF hKpos hSLinear)
    have hSFinite : PsiTwoGauge μ S < ∞ :=
      hGaugeBound.trans_lt ENNReal.ofReal_lt_top
    have hGaugeRealBound :
        (PsiTwoGauge μ S).toReal ≤ B * (A * Real.sqrt E) := by
      exact ENNReal.toReal_le_of_le_ofReal (by positivity) hGaugeBound
    have hSqBound :
        (PsiTwoGauge μ S).toReal ^ 2 ≤
          (B * (A * Real.sqrt E)) ^ 2 :=
      (sq_le_sq₀ ENNReal.toReal_nonneg (by positivity)).2 hGaugeRealBound
    have hSSub : IsSubGaussian μ S := by
      refine ⟨hSMeas, ?_⟩
      exact (psiTwoGauge_finite_iff (μ := μ) (X := S)).1 hSFinite
    refine ⟨by simpa [S] using hSSub, ?_⟩
    have hEsqrt : (Real.sqrt E) ^ 2 = E := Real.sq_sqrt hEpos.le
    change (PsiTwoGauge μ S).toReal ^ 2 ≤ C * E
    calc
      (PsiTwoGauge μ S).toReal ^ 2 ≤
          (B * (A * Real.sqrt E)) ^ 2 := hSqBound
      _ = C * E := by
        dsimp [C]
        rw [show B * (A * Real.sqrt E) = (B * A) * Real.sqrt E by ring,
          mul_pow, hEsqrt]

/-! Theorem 2.6.2 in its intrinsic `ψ₂`-norm form.  One positive absolute
constant is quantified before every probability space and family.  The
zero-energy and zero-sum-gauge branches retain the source's universal domain
while making the displayed real quotient total in Lean. -/
theorem independentCenteredSubGaussianTailPsiTwo :
    ∃ c : ℝ, 0 < c ∧
      ∀ {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
        {μ : Measure Ω} [IsProbabilityMeasure μ]
        {X : ι → Ω → ℝ},
        (∀ i, IsSubGaussian μ (X i)) →
        (∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0) →
        iIndepFun X μ →
        ∀ {t : ℝ}, 0 ≤ t →
          μ.real {ω | |∑ i, X i ω| ≥ t} ≤
            2 * Real.exp
              (-(c * t ^ 2 /
                ∑ i, (PsiTwoNorm μ (X i)).toReal ^ 2)) := by
  rcases independentCenteredSubGaussianSumPsiTwo with ⟨C, hC, hSum⟩
  have hCpos : 0 < C := lt_of_lt_of_le zero_lt_one hC
  let c : ℝ := 1 / (4 * C)
  have hc : 0 < c := by
    dsimp [c]
    positivity
  refine ⟨c, hc, ?_⟩
  intro ι Ω instι instΩ μ instμ X hSub hCenter hIndep t ht
  let S : Ω → ℝ := fun ω => ∑ i, X i ω
  let E : ℝ := ∑ i, (PsiTwoNorm μ (X i)).toReal ^ 2
  obtain ⟨hSSub, hSBound⟩ := hSum hSub hCenter hIndep
  have hSSub' : IsSubGaussian μ S := by
    simpa [S] using hSSub
  have hSFinite : PsiTwoGauge μ S < ∞ := by
    have hNormFinite := (isSubGaussian_iff_psiTwoNorm_finite
      (μ := μ) (X := S)).1 hSSub'
    simpa [PsiTwoNorm] using hNormFinite
  have hSBound' : (PsiTwoGauge μ S).toReal ^ 2 ≤ C * E := by
    simpa [PsiTwoNorm, S, E] using hSBound
  have hEnonneg : 0 ≤ E := by
    dsimp [E]
    exact Finset.sum_nonneg fun i _ => sq_nonneg _
  have hProb (s : Set Ω) : μ.real s ≤ 1 := by
    rw [Measure.real_def]
    exact ENNReal.toReal_mono ENNReal.one_ne_top prob_le_one
  by_cases hEzero : E = 0
  · calc
      μ.real {ω | |∑ i, X i ω| ≥ t} ≤ 1 := hProb _
      _ ≤ 2 * Real.exp
          (-(c * t ^ 2 /
            ∑ i, (PsiTwoNorm μ (X i)).toReal ^ 2)) := by
        simp [E, hEzero]
  · have hEpos : 0 < E := lt_of_le_of_ne hEnonneg (Ne.symm hEzero)
    by_cases hGaugeZero : PsiTwoGauge μ S = 0
    · by_cases htZero : t = 0
      · subst t
        calc
          μ.real {ω | |∑ i, X i ω| ≥ 0} ≤ 1 := hProb _
          _ ≤ 2 * Real.exp
              (-(c * 0 ^ 2 /
                ∑ i, (PsiTwoNorm μ (X i)).toReal ^ 2)) := by norm_num
      · have hSZero : S =ᵐ[μ] (fun _ : Ω => (0 : ℝ)) :=
          (psiTwoGauge_eq_zero_iff_ae_eq_zero hSSub'.1).mp hGaugeZero
        have hEvent : {ω | |S ω| ≥ t} =ᵐ[μ] (∅ : Set Ω) := by
          filter_upwards [hSZero] with ω hω
          change (t ≤ |S ω|) = False
          rw [hω, abs_zero]
          exact propext (iff_false_intro
            (not_le_of_gt (lt_of_le_of_ne ht (Ne.symm htZero))))
        have hZeroProb : μ.real {ω | |S ω| ≥ t} = 0 := by
          rw [Measure.real_def, measure_congr hEvent]
          simp
        change μ.real {ω | |S ω| ≥ t} ≤
          2 * Real.exp (-(c * t ^ 2 / E))
        rw [hZeroProb]
        positivity
    · have hGaugeRealPos : 0 < (PsiTwoGauge μ S).toReal :=
        ENNReal.toReal_pos hGaugeZero (ne_of_lt hSFinite)
      have hTail := psiTwoGaugeToTail hSSub'.1 hSFinite ht
      have hDenom :
          (2 * (PsiTwoGauge μ S).toReal) ^ 2 ≤ 4 * C * E := by
        nlinarith [hSBound']
      have hRatio :
          c * t ^ 2 / E ≤
            t ^ 2 / (2 * (PsiTwoGauge μ S).toReal) ^ 2 := by
        calc
          c * t ^ 2 / E = t ^ 2 / (4 * C * E) := by
            dsimp [c]
            field_simp [ne_of_gt hCpos, ne_of_gt hEpos]
          _ ≤ t ^ 2 / (2 * (PsiTwoGauge μ S).toReal) ^ 2 := by
            exact div_le_div_of_nonneg_left (sq_nonneg t) (by positivity) hDenom
      change μ.real {ω | |S ω| ≥ t} ≤
        2 * Real.exp (-(c * t ^ 2 / E))
      calc
        μ.real {ω | |S ω| ≥ t} ≤
            2 * Real.exp
              (-t ^ 2 / (2 * (PsiTwoGauge μ S).toReal) ^ 2) := hTail
        _ ≤ 2 * Real.exp (-(c * t ^ 2 / E)) := by
          apply mul_le_mul_of_nonneg_left (Real.exp_le_exp.mpr ?_) (by norm_num)
          calc
            -t ^ 2 / (2 * (PsiTwoGauge μ S).toReal) ^ 2 =
                -(t ^ 2 / (2 * (PsiTwoGauge μ S).toReal) ^ 2) := by ring
            _ ≤ -(c * t ^ 2 / E) := neg_le_neg hRatio

/-! The largest intrinsic `ψ₂` norm in a nonempty finite family, in the
real-valued form used by Theorem 2.6.3. -/
noncomputable def psiTwoNormMax
    {ι Ω : Type*} [Fintype ι] [Nonempty ι] [MeasurableSpace Ω]
    (μ : Measure Ω) (X : ι → Ω → ℝ) : ℝ :=
  Finset.univ.sup' Finset.univ_nonempty
    (fun i => (PsiTwoNorm μ (X i)).toReal)

theorem psiTwoNorm_toReal_le_max
    {ι Ω : Type*} [Fintype ι] [Nonempty ι] [MeasurableSpace Ω]
    {μ : Measure Ω} {X : ι → Ω → ℝ} (i : ι) :
    (PsiTwoNorm μ (X i)).toReal ≤ psiTwoNormMax μ X := by
  exact Finset.le_sup' (fun j => (PsiTwoNorm μ (X j)).toReal)
    (Finset.mem_univ i)

theorem psiTwoNormMax_nonneg
    {ι Ω : Type*} [Fintype ι] [Nonempty ι] [MeasurableSpace Ω]
    {μ : Measure Ω} {X : ι → Ω → ℝ} :
    0 ≤ psiTwoNormMax μ X := by
  let i : ι := Classical.choice inferInstance
  exact le_trans ENNReal.toReal_nonneg (psiTwoNorm_toReal_le_max (μ := μ) (X := X) i)

/-! Theorem 2.6.3 in its intrinsic weighted `ψ₂`-norm form.  The nonempty
index hypothesis matches the source's implicit positive integer `N`, and the
zero weighted-scale branches retain every coefficient vector and threshold. -/
theorem independentWeightedCenteredSubGaussianTailPsiTwo :
    ∃ c : ℝ, 0 < c ∧
      ∀ {ι Ω : Type*} [Fintype ι] [Nonempty ι] [MeasurableSpace Ω]
        {μ : Measure Ω} [IsProbabilityMeasure μ]
        {X : ι → Ω → ℝ},
        (∀ i, IsSubGaussian μ (X i)) →
        (∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0) →
        iIndepFun X μ →
        ∀ (a : ι → ℝ) {t : ℝ}, 0 ≤ t →
          μ.real {ω | |∑ i, a i * X i ω| ≥ t} ≤
            2 * Real.exp
              (-(c * t ^ 2 /
                ((psiTwoNormMax μ X) ^ 2 * ∑ i, a i ^ 2))) := by
  rcases independentCenteredSubGaussianTailPsiTwo with ⟨c, hc, hTail⟩
  refine ⟨c, hc, ?_⟩
  intro ι Ω instι instNonempty instΩ μ instμ X hSub hCenter hIndep a t ht
  let Y : ι → Ω → ℝ := fun i ω => a i * X i ω
  let S : Ω → ℝ := fun ω => ∑ i, Y i ω
  let K : ℝ := psiTwoNormMax μ X
  let A : ℝ := ∑ i, a i ^ 2
  let E : ℝ := ∑ i, (PsiTwoNorm μ (Y i)).toReal ^ 2
  let D : ℝ := K ^ 2 * A
  have hYSub : ∀ i, IsSubGaussian μ (Y i) := by
    intro i
    apply (isSubGaussian_iff_psiTwoNorm_finite (μ := μ) (X := Y i)).2
    by_cases hai : a i = 0
    · simp [Y, hai, PsiTwoNorm, psiTwoGauge_zero]
    · have hXFinite :=
        (isSubGaussian_iff_psiTwoNorm_finite (μ := μ) (X := X i)).1 (hSub i)
      rw [PsiTwoNorm, show Y i = (fun ω => a i * X i ω) by rfl,
        psiTwoGauge_smul_of_ne_zero hai]
      exact ENNReal.mul_lt_top ENNReal.ofReal_lt_top (by
        simpa [PsiTwoNorm] using hXFinite)
  have hYCenter : ∀ i, Integrable (Y i) μ ∧ (∫ ω, Y i ω ∂μ) = 0 := by
    intro i
    refine ⟨by simpa [Y] using (hCenter i).1.const_mul (a i), ?_⟩
    simp [Y, integral_const_mul, (hCenter i).2]
  have hIndepY : iIndepFun Y μ := by
    have h := hIndep.comp (fun i x => a i * x) (fun i => by fun_prop)
    simpa [Y, Function.comp_def] using h
  have hYNorm (i : ι) :
      (PsiTwoNorm μ (Y i)).toReal =
        |a i| * (PsiTwoNorm μ (X i)).toReal := by
    by_cases hai : a i = 0
    · simp [Y, hai, PsiTwoNorm, psiTwoGauge_zero]
    · rw [PsiTwoNorm, show Y i = (fun ω => a i * X i ω) by rfl,
        psiTwoGauge_smul_of_ne_zero hai, ENNReal.toReal_mul,
        ENNReal.toReal_ofReal (abs_nonneg (a i))]
      rfl
  have hKnonneg : 0 ≤ K := by
    simpa [K] using (psiTwoNormMax_nonneg (μ := μ) (X := X))
  have hEnonneg : 0 ≤ E := by
    dsimp [E]
    exact Finset.sum_nonneg fun i _ => sq_nonneg _
  have hAnonneg : 0 ≤ A := by
    dsimp [A]
    exact Finset.sum_nonneg fun i _ => sq_nonneg _
  have hDnonneg : 0 ≤ D := mul_nonneg (sq_nonneg K) hAnonneg
  have hED : E ≤ D := by
    dsimp [E, D, A]
    calc
      ∑ i, (PsiTwoNorm μ (Y i)).toReal ^ 2 ≤
          ∑ i, K ^ 2 * a i ^ 2 := by
        apply Finset.sum_le_sum
        intro i _
        have hi : (PsiTwoNorm μ (X i)).toReal ≤ K := by
          simpa [K] using (psiTwoNorm_toReal_le_max (μ := μ) (X := X) i)
        have hsq : (PsiTwoNorm μ (X i)).toReal ^ 2 ≤ K ^ 2 := by
          nlinarith [ENNReal.toReal_nonneg (a := PsiTwoNorm μ (X i))]
        calc
          (PsiTwoNorm μ (Y i)).toReal ^ 2 =
              a i ^ 2 * (PsiTwoNorm μ (X i)).toReal ^ 2 := by
            rw [hYNorm, mul_pow, sq_abs]
          _ ≤ a i ^ 2 * K ^ 2 :=
            mul_le_mul_of_nonneg_left hsq (sq_nonneg (a i))
          _ = K ^ 2 * a i ^ 2 := by ring
      _ = K ^ 2 * ∑ i, a i ^ 2 := by rw [Finset.mul_sum]
  have hProb (s : Set Ω) : μ.real s ≤ 1 := by
    rw [Measure.real_def]
    exact ENNReal.toReal_mono ENNReal.one_ne_top prob_le_one
  change μ.real {ω | |∑ i, a i * X i ω| ≥ t} ≤
    2 * Real.exp (-(c * t ^ 2 / D))
  by_cases hDzero : D = 0
  · calc
      μ.real {ω | |∑ i, a i * X i ω| ≥ t} ≤ 1 := hProb _
      _ ≤ 2 * Real.exp (-(c * t ^ 2 / D)) := by simp [hDzero]
  · have hDpos : 0 < D := lt_of_le_of_ne hDnonneg (Ne.symm hDzero)
    by_cases hEzero : E = 0
    · have hYFinite : ∀ i, PsiTwoGauge μ (Y i) < ∞ := by
        intro i
        have := (isSubGaussian_iff_psiTwoNorm_finite
          (μ := μ) (X := Y i)).1 (hYSub i)
        simpa [PsiTwoNorm] using this
      have hGaugeZero : ∀ i, PsiTwoGauge μ (Y i) = 0 := by
        intro i
        have hSqZero : (PsiTwoNorm μ (Y i)).toReal ^ 2 = 0 :=
          (Finset.sum_eq_zero_iff_of_nonneg
            (fun j _ => sq_nonneg (PsiTwoNorm μ (Y j)).toReal)).mp hEzero i
              (Finset.mem_univ i)
        have hRealZero : (PsiTwoNorm μ (Y i)).toReal = 0 := by
          nlinarith [sq_nonneg (PsiTwoNorm μ (Y i)).toReal]
        have hNormZero : PsiTwoNorm μ (Y i) = 0 :=
          ((ENNReal.toReal_eq_zero_iff _).mp hRealZero).resolve_right
            (ne_of_lt (by simpa [PsiTwoNorm] using hYFinite i))
        simpa [PsiTwoNorm] using hNormZero
      have hYZero : ∀ i, Y i =ᵐ[μ] (fun _ : Ω => (0 : ℝ)) := by
        intro i
        exact (psiTwoGauge_eq_zero_iff_ae_eq_zero (hYSub i).1).mp (hGaugeZero i)
      have hAllZero : ∀ᵐ ω ∂μ, ∀ i ∈ (Finset.univ : Finset ι), Y i ω = 0 := by
        rw [Filter.eventually_all_finset]
        intro i _
        exact hYZero i
      have hSZero : S =ᵐ[μ] (fun _ : Ω => (0 : ℝ)) := by
        filter_upwards [hAllZero] with ω hω
        simp [S, hω]
      by_cases htZero : t = 0
      · subst t
        calc
          μ.real {ω | |∑ i, a i * X i ω| ≥ 0} ≤ 1 := hProb _
          _ ≤ 2 * Real.exp (-(c * 0 ^ 2 / D)) := by norm_num
      · have hEvent : {ω | |S ω| ≥ t} =ᵐ[μ] (∅ : Set Ω) := by
          filter_upwards [hSZero] with ω hω
          change (t ≤ |S ω|) = False
          rw [hω, abs_zero]
          exact propext (iff_false_intro
            (not_le_of_gt (lt_of_le_of_ne ht (Ne.symm htZero))))
        have hZeroProb : μ.real {ω | |S ω| ≥ t} = 0 := by
          rw [Measure.real_def, measure_congr hEvent]
          simp
        change μ.real {ω | |S ω| ≥ t} ≤ 2 * Real.exp (-(c * t ^ 2 / D))
        rw [hZeroProb]
        positivity
    · have hEpos : 0 < E := lt_of_le_of_ne hEnonneg (Ne.symm hEzero)
      have hTailY := hTail hYSub hYCenter hIndepY ht
      have hRatio : c * t ^ 2 / D ≤ c * t ^ 2 / E := by
        exact div_le_div_of_nonneg_left (mul_nonneg hc.le (sq_nonneg t)) hEpos hED
      calc
        μ.real {ω | |∑ i, a i * X i ω| ≥ t} ≤
            2 * Real.exp (-(c * t ^ 2 / E)) := by
          simpa [Y, E] using hTailY
        _ ≤ 2 * Real.exp (-(c * t ^ 2 / D)) := by
          apply mul_le_mul_of_nonneg_left (Real.exp_le_exp.mpr ?_) (by norm_num)
          exact neg_le_neg hRatio

/-! The exact a.e.-quotient carrier for Exercise 2.5.7.  The carrier is a
submodule of measurable finite-gauge representatives; quotienting by its
null submodule makes the definiteness statement literal. -/
/-- The submodule of measurable representatives with finite ψ₂ gauge. -/
def psiTwoMemberSubmodule
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ] : Submodule ℝ (Ω → ℝ) where
  carrier := {X | Measurable X ∧ PsiTwoGauge μ X < ∞}
  zero_mem' := by
    refine ⟨measurable_const, ?_⟩
    change PsiTwoGauge μ (fun _ : Ω => (0 : ℝ)) < ∞
    rw [psiTwoGauge_zero]
    simp
  add_mem' := by
    intro X Y hX hY
    refine ⟨hX.1.add hY.1, ?_⟩
    exact lt_of_le_of_lt (psiTwoGauge_add_le (μ := μ) (X := X) (Y := Y))
      (ENNReal.add_lt_top.mpr ⟨hX.2, hY.2⟩)
  smul_mem' := by
    intro c X hX
    refine ⟨hX.1.const_smul c, ?_⟩
    by_cases hc : c = 0
    · subst c
      simpa using (show PsiTwoGauge μ (fun _ : Ω => (0 : ℝ)) < ∞ by
        rw [psiTwoGauge_zero]
        simp)
    · rw [show c • X = (fun ω => c * X ω) by rfl,
      psiTwoGauge_smul_of_ne_zero hc]
      exact ENNReal.mul_lt_top ENNReal.ofReal_lt_top hX.2

/-- The submodule of representatives that vanish almost everywhere. -/
def psiTwoNullSubmodule
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ] :
    Submodule ℝ (psiTwoMemberSubmodule μ) where
  carrier := {X | (X : Ω → ℝ) =ᵐ[μ] (fun _ : Ω => (0 : ℝ))}
  zero_mem' := by
    change ((0 : psiTwoMemberSubmodule μ) : Ω → ℝ) =ᵐ[μ]
      (fun _ : Ω => (0 : ℝ))
    exact Filter.Eventually.of_forall (fun _ => rfl)
  add_mem' := by
    intro X Y hX hY
    change (X : Ω → ℝ) =ᵐ[μ] (fun _ : Ω => (0 : ℝ)) at hX
    change (Y : Ω → ℝ) =ᵐ[μ] (fun _ : Ω => (0 : ℝ)) at hY
    change (fun ω => X.1 ω + Y.1 ω) =ᵐ[μ] (fun _ : Ω => (0 : ℝ))
    filter_upwards [hX, hY] with ω hωX hωY
    simp [hωX, hωY]
  smul_mem' := by
    intro c X hX
    change (X : Ω → ℝ) =ᵐ[μ] (fun _ : Ω => (0 : ℝ)) at hX
    change (fun ω => c * X.1 ω) =ᵐ[μ] (fun _ : Ω => (0 : ℝ))
    filter_upwards [hX] with ω hω
    simp [hω]

/-- The a.e.-quotient of finite-ψ₂ representatives. -/
def psiTwoSpace
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ] :=
  psiTwoMemberSubmodule μ ⧸ psiTwoNullSubmodule μ

instance psiTwoSpace.instAddCommGroup
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ] : AddCommGroup (psiTwoSpace μ) := by
  unfold psiTwoSpace
  exact Submodule.Quotient.addCommGroup (psiTwoNullSubmodule μ)

instance psiTwoSpace.instModule
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ] : Module ℝ (psiTwoSpace μ) := by
  unfold psiTwoSpace
  exact Submodule.Quotient.module (psiTwoNullSubmodule μ)

/-- The ψ₂ gauge induced on the a.e.-quotient. -/
noncomputable def psiTwoQuotientGauge
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ] : psiTwoSpace μ → ℝ≥0∞ :=
  Quotient.lift
    (fun X : psiTwoMemberSubmodule μ => PsiTwoGauge μ X.1)
    (by
      intro X Y hXY
      have hmem : X - Y ∈ psiTwoNullSubmodule μ :=
        (psiTwoNullSubmodule μ).quotientRel_def.mp hXY
      have hzero : (X.1 - Y.1) =ᵐ[μ] (fun _ : Ω => (0 : ℝ)) := hmem
      have hXY' : X.1 =ᵐ[μ] Y.1 := by
        filter_upwards [hzero] with ω hω
        change X.1 ω - Y.1 ω = 0 at hω
        linarith
      exact psiTwoGauge_ae_congr X.2.1 Y.2.1 hXY')

/-- The real-valued ψ₂ norm on the a.e.-quotient. -/
noncomputable def psiTwoQuotientNorm
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ] : psiTwoSpace μ → ℝ :=
  fun x => (psiTwoQuotientGauge μ x).toReal

lemma psiTwoQuotientNorm_mk
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : psiTwoMemberSubmodule μ) :
    psiTwoQuotientNorm μ (Submodule.Quotient.mk X) =
      (PsiTwoGauge μ X.1).toReal := rfl

lemma psiTwoQuotientNorm_nonneg
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ] (x : psiTwoSpace μ) :
    0 ≤ psiTwoQuotientNorm μ x :=
  ENNReal.toReal_nonneg

lemma psiTwoQuotientNorm_zero
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ] :
    psiTwoQuotientNorm μ (0 : psiTwoSpace μ) = 0 := by
  change (psiTwoQuotientGauge μ (0 : psiTwoSpace μ)).toReal = 0
  rw [show (0 : psiTwoSpace μ) = Submodule.Quotient.mk (0 : psiTwoMemberSubmodule μ) by rfl,
    psiTwoQuotientGauge]
  change (PsiTwoGauge μ (0 : Ω → ℝ)).toReal = 0
  rw [show (0 : Ω → ℝ) = (fun _ : Ω => (0 : ℝ)) by rfl,
    psiTwoGauge_zero]
  rfl

lemma psiTwoQuotientNorm_eq_zero_iff
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ] (x : psiTwoSpace μ) :
    psiTwoQuotientNorm μ x = 0 ↔ x = 0 := by
  refine Submodule.Quotient.induction_on (psiTwoNullSubmodule μ) x ?_
  intro X
  have hfinite : PsiTwoGauge μ X.1 < ∞ := X.2.2
  rw [psiTwoQuotientNorm_mk]
  constructor
  · intro hnorm
    have hGauge : PsiTwoGauge μ X.1 = 0 := by
      exact (ENNReal.toReal_eq_zero_iff _).mp hnorm |>.resolve_right hfinite.ne
    apply (Submodule.Quotient.mk_eq_zero (psiTwoNullSubmodule μ)).2
    exact (psiTwoGauge_eq_zero_iff_ae_eq_zero X.2.1).mp hGauge
  · intro hx
    have hGauge : PsiTwoGauge μ X.1 = 0 := by
      apply (psiTwoGauge_eq_zero_iff_ae_eq_zero X.2.1).2
      exact (Submodule.Quotient.mk_eq_zero (psiTwoNullSubmodule μ)).mp hx
    simp [hGauge]

lemma psiTwoQuotientNorm_add_le
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    (x y : psiTwoSpace μ) :
    psiTwoQuotientNorm μ (x + y) ≤
      psiTwoQuotientNorm μ x + psiTwoQuotientNorm μ y := by
  refine Submodule.Quotient.induction_on (psiTwoNullSubmodule μ) x ?_
  intro X
  refine Submodule.Quotient.induction_on (psiTwoNullSubmodule μ) y ?_
  intro Y
  have hmk :
      (Submodule.Quotient.mk X : psiTwoSpace μ) + Submodule.Quotient.mk Y =
        Submodule.Quotient.mk (X + Y) :=
    (Submodule.Quotient.mk_add (psiTwoNullSubmodule μ) (x := X) (y := Y)).symm
  have hsum := (psiTwoMemberSubmodule μ).add_mem X.2 Y.2
  have hle := psiTwoGauge_add_le (μ := μ) (X := X.1) (Y := Y.1)
  have htopLeft : PsiTwoGauge μ (X + Y).1 ≠ ∞ := hsum.2.ne
  have htopRight : PsiTwoGauge μ X.1 + PsiTwoGauge μ Y.1 ≠ ∞ :=
    (ENNReal.add_lt_top.mpr ⟨X.2.2, Y.2.2⟩).ne
  have hreal := (ENNReal.toReal_le_toReal htopLeft htopRight).2 hle
  calc
    psiTwoQuotientNorm μ
        ((Submodule.Quotient.mk X : psiTwoSpace μ) + Submodule.Quotient.mk Y) =
        psiTwoQuotientNorm μ (Submodule.Quotient.mk (X + Y)) := congrArg _ hmk
    _ = (PsiTwoGauge μ (X + Y).1).toReal := rfl
    _ ≤ (PsiTwoGauge μ X.1).toReal + (PsiTwoGauge μ Y.1).toReal := by
      simpa [ENNReal.toReal_add X.2.2.ne Y.2.2.ne] using hreal
    _ = psiTwoQuotientNorm μ (Submodule.Quotient.mk X) +
        psiTwoQuotientNorm μ (Submodule.Quotient.mk Y) := by rfl

lemma psiTwoQuotientNorm_smul
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    (c : ℝ) (x : psiTwoSpace μ) :
    psiTwoQuotientNorm μ (c • x) = |c| * psiTwoQuotientNorm μ x := by
  refine Submodule.Quotient.induction_on (psiTwoNullSubmodule μ) x ?_
  intro X
  have hmk : c • (Submodule.Quotient.mk X : psiTwoSpace μ) =
      Submodule.Quotient.mk (c • X) :=
    (Submodule.Quotient.mk_smul (psiTwoNullSubmodule μ) c X).symm
  calc
    psiTwoQuotientNorm μ (c • (Submodule.Quotient.mk X : psiTwoSpace μ)) =
    psiTwoQuotientNorm μ (Submodule.Quotient.mk (c • X)) := congrArg _ hmk
    _ = (PsiTwoGauge μ (c • X).1).toReal := rfl
    _ = |c| * (PsiTwoGauge μ X.1).toReal := by
      change (PsiTwoGauge μ (fun ω => c * X.1 ω)).toReal =
        |c| * (PsiTwoGauge μ X.1).toReal
      by_cases hc : c = 0
      · subst c
        rw [show (fun ω => (0 : ℝ) * X.1 ω) = (fun _ : Ω => (0 : ℝ)) by
          funext ω; simp, psiTwoGauge_zero]
        simp
      · have hsmul :
            PsiTwoGauge μ (fun ω => c * X.1 ω) =
              ENNReal.ofReal |c| * PsiTwoGauge μ X.1 :=
          psiTwoGauge_smul_of_ne_zero (μ := μ) (X := X.1) hc
        rw [hsmul, ENNReal.toReal_mul]
        · simp [ENNReal.toReal_ofReal (abs_nonneg c)]
    _ = |c| * psiTwoQuotientNorm μ (Submodule.Quotient.mk X) := by rfl

/-- Norm axioms for the ψ₂ quotient model. -/
structure PsiTwoNormQuotientModelData
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ] where
  /-- The norm assigned to quotient classes. -/
  norm : psiTwoSpace μ → ℝ
  norm_nonneg : ∀ x, 0 ≤ norm x
  norm_zero : norm 0 = 0
  norm_eq_zero : ∀ x, norm x = 0 ↔ x = 0
  norm_add_le : ∀ x y, norm (x + y) ≤ norm x + norm y
  norm_smul : ∀ (c : ℝ) x, norm (c • x) = |c| * norm x

/-- The ψ₂ quotient model equipped with its induced norm. -/
noncomputable def psiTwoNormQuotientModelData
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ] :
    PsiTwoNormQuotientModelData μ :=
  { norm := psiTwoQuotientNorm μ
    norm_nonneg := psiTwoQuotientNorm_nonneg μ
    norm_zero := psiTwoQuotientNorm_zero μ
    norm_eq_zero := psiTwoQuotientNorm_eq_zero_iff μ
    norm_add_le := psiTwoQuotientNorm_add_le μ
    norm_smul := psiTwoQuotientNorm_smul μ }

theorem psiTwoNormQuotientModel
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ] :
    ∃ norm : psiTwoSpace μ → ℝ,
      (∀ x, 0 ≤ norm x) ∧
        norm 0 = 0 ∧
        (∀ x, norm x = 0 ↔ x = 0) ∧
        (∀ x y, norm (x + y) ≤ norm x + norm y) ∧
        (∀ (c : ℝ) x, norm (c • x) = |c| * norm x) := by
  refine ⟨psiTwoQuotientNorm μ, psiTwoQuotientNorm_nonneg μ,
    psiTwoQuotientNorm_zero μ, psiTwoQuotientNorm_eq_zero_iff μ,
    psiTwoQuotientNorm_add_le μ, psiTwoQuotientNorm_smul μ⟩

theorem psiTwoQuotientNorm_isNorm
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ] :
    (∀ x, 0 ≤ psiTwoQuotientNorm μ x) ∧
      psiTwoQuotientNorm μ 0 = 0 ∧
      (∀ x, psiTwoQuotientNorm μ x = 0 ↔ x = 0) ∧
      (∀ x y,
        psiTwoQuotientNorm μ (x + y) ≤
          psiTwoQuotientNorm μ x + psiTwoQuotientNorm μ y) ∧
      (∀ (c : ℝ) x,
        psiTwoQuotientNorm μ (c • x) =
          |c| * psiTwoQuotientNorm μ x) := by
  exact ⟨psiTwoQuotientNorm_nonneg μ, psiTwoQuotientNorm_zero μ,
    psiTwoQuotientNorm_eq_zero_iff μ, psiTwoQuotientNorm_add_le μ,
    psiTwoQuotientNorm_smul μ⟩
/-! Example 2.5.8(a): one absolute constant controls the `ψ₂` gauge of every
centered Gaussian, with the source's linear dependence on its scale. -/
theorem gaussianPsiTwoGauge_le_two_mul :
    PsiTwoGauge (gaussianReal 0 1) id ≤ ENNReal.ofReal 2 ∧
      ∀ σ : ℝ, 0 ≤ σ →
        PsiTwoGauge (gaussianReal 0 (⟨σ ^ 2, sq_nonneg σ⟩ : ℝ≥0)) id ≤
          ENNReal.ofReal (2 * σ) := by
  have hsqrt2 : 0 < Real.sqrt (2 : ℝ) := by positivity
  have hsqrt2_sq : (Real.sqrt (2 : ℝ)) ^ 2 = 2 := by
    exact Real.sq_sqrt (by norm_num)
  have hsmall : |(1 / 2 : ℝ)| < (Real.sqrt 2)⁻¹ := by
    rw [abs_of_nonneg (by norm_num)]
    field_simp
    nlinarith
  have hstd := (standardNormalSquareMGF (1 / 2)).1 hsmall
  have hsqrt2_bound : (Real.sqrt (1 - 2 * (1 / 2 : ℝ) ^ 2))⁻¹ ≤ 2 := by
    norm_num [hsqrt2_sq]
    nlinarith
  have hstdInt :
      Integrable (fun x : ℝ => Real.exp (x ^ 2 / (2 : ℝ) ^ 2))
        (gaussianReal 0 1) := by
    convert hstd.1 using 1
    all_goals funext x
    all_goals field_simp
  have hstdIntegral :
      (∫ x : ℝ, Real.exp (x ^ 2 / (2 : ℝ) ^ 2) ∂(gaussianReal 0 1)) =
        (Real.sqrt (1 - 2 * (1 / 2 : ℝ) ^ 2))⁻¹ := by
    calc
      (∫ x : ℝ, Real.exp (x ^ 2 / (2 : ℝ) ^ 2) ∂(gaussianReal 0 1)) =
          ∫ x : ℝ, Real.exp ((1 / 2 : ℝ) ^ 2 * x ^ 2) ∂(gaussianReal 0 1) := by
            apply integral_congr_ae
            filter_upwards [] with x
            congr 1
            field_simp
      _ = (Real.sqrt (1 - 2 * (1 / 2 : ℝ) ^ 2))⁻¹ := hstd.2
  constructor
  · apply psiTwoGauge_le_of_squarePoint
    refine ⟨measurable_id, by norm_num, ?_, ?_⟩
    · simpa [id_eq] using hstdInt
    · simpa [id_eq] using hstdIntegral.trans_le hsqrt2_bound
  · intro σ hσ
    by_cases hzero : σ = 0
    · subst σ
      have hvzero : (⟨(0 : ℝ) ^ 2, sq_nonneg (0 : ℝ)⟩ : ℝ≥0) = 0 := by
        apply NNReal.eq
        norm_num
      have hgauss : gaussianReal 0
          (⟨(0 : ℝ) ^ 2, sq_nonneg (0 : ℝ)⟩ : ℝ≥0) = Measure.dirac 0 := by
        rw [hvzero]
        exact ProbabilityTheory.gaussianReal_zero_var 0
      rw [hgauss]
      calc
        PsiTwoGauge (Measure.dirac 0) id =
            PsiTwoGauge (Measure.dirac 0) (fun _ : ℝ => (0 : ℝ)) :=
          psiTwoGauge_ae_congr measurable_id measurable_const (by
            simpa [id_eq] using
              (MeasureTheory.ae_eq_dirac (id : ℝ → ℝ)))
        _ = 0 := psiTwoGauge_zero
        _ ≤ ENNReal.ofReal (2 * 0) := by simp
    · have hσpos : 0 < σ := lt_of_le_of_ne hσ (Ne.symm hzero)
      let v : ℝ≥0 := ⟨σ ^ 2, sq_nonneg σ⟩
      have hLaw : HasLaw (fun x : ℝ => σ * x) (gaussianReal 0 v)
          (gaussianReal 0 1) := by
        simpa [v] using
          (ProbabilityTheory.gaussianReal_const_mul
            (ProbabilityTheory.HasLaw.id (μ := gaussianReal 0 1)) σ)
      let f : ℝ → ℝ := fun x => Real.exp (x ^ 2 / (2 * σ) ^ 2)
      have hcomp : (f ∘ (fun x : ℝ => σ * x)) =
          (fun x : ℝ => Real.exp ((1 / 2 : ℝ) ^ 2 * x ^ 2)) := by
        funext x
        dsimp [f]
        congr 1
        field_simp [hzero]
      have hfInt : Integrable f (gaussianReal 0 v) := by
        rw [← hLaw.map_eq]
        apply (integrable_map_measure
          (Continuous.aestronglyMeasurable (by fun_prop : Continuous f))
          hLaw.aemeasurable).2
        rw [hcomp]
        exact hstd.1
      have hfBound : (∫ x, f x ∂(gaussianReal 0 v)) ≤ 2 := by
        calc
          (∫ x, f x ∂(gaussianReal 0 v)) =
              ∫ x, f (σ * x) ∂(gaussianReal 0 1) := by
                symm
                exact hLaw.integral_comp
                  (Continuous.aestronglyMeasurable (by fun_prop : Continuous f))
          _ = ∫ x, (f ∘ (fun x : ℝ => σ * x)) x ∂(gaussianReal 0 1) := by rfl
          _ = ∫ x, Real.exp ((1 / 2 : ℝ) ^ 2 * x ^ 2) ∂(gaussianReal 0 1) := by
            rw [hcomp]
          _ = (Real.sqrt (1 - 2 * (1 / 2 : ℝ) ^ 2))⁻¹ := by
            simpa using hstd.2
          _ ≤ 2 := hsqrt2_bound
      apply psiTwoGauge_le_of_squarePoint
      exact ⟨measurable_id, by positivity, hfInt, by simpa [f] using hfBound⟩

/-! Qualitative corollary retained for downstream callers that need only
finiteness. -/
theorem gaussianPsiTwoGauge_finite :
    PsiTwoGauge (gaussianReal 0 1) id < ∞ ∧
      ∀ σ : ℝ, 0 ≤ σ →
        PsiTwoGauge (gaussianReal 0 (⟨σ ^ 2, sq_nonneg σ⟩ : ℝ≥0)) id < ∞ := by
  rcases gaussianPsiTwoGauge_le_two_mul with ⟨hstd, hscaled⟩
  exact ⟨hstd.trans_lt ENNReal.ofReal_lt_top,
    fun σ hσ => (hscaled σ hσ).trans_lt ENNReal.ofReal_lt_top⟩

/-! Example 2.5.8(c): an essentially bounded variable has finite `ψ₂` gauge.

The positive real `B` is an arbitrary essential bound for `|X|`; taking the
infimum over such bounds recovers the printed essential-supremum estimate. -/
theorem essentiallyBoundedPsiTwoGauge
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] {X : Ω → ℝ} {B : ℝ}
    (hX : Measurable X) (hB : 0 < B)
    (hBound : ∀ᵐ ω ∂μ, |X ω| ≤ B) :
    PsiTwoGauge μ X ≤
      ENNReal.ofReal (B / Real.sqrt (Real.log 2)) := by
  have hLog : 0 < Real.log 2 := by positivity
  have hSqrt : 0 < Real.sqrt (Real.log 2) := Real.sqrt_pos.2 hLog
  let K : ℝ := B / Real.sqrt (Real.log 2)
  have hK : 0 < K := div_pos hB hSqrt
  have hSqSqrt : (Real.sqrt (Real.log 2)) ^ 2 = Real.log 2 :=
    Real.sq_sqrt hLog.le
  have hPointwise : ∀ᵐ ω ∂μ,
      Real.exp (X ω ^ 2 / K ^ 2) ≤ (2 : ℝ) := by
    filter_upwards [hBound] with ω hω
    have hSq : X ω ^ 2 ≤ B ^ 2 := by
      rw [← sq_abs]
      exact (sq_le_sq₀ (abs_nonneg (X ω)) hB.le).2 hω
    have hArg : X ω ^ 2 / K ^ 2 ≤ Real.log 2 := by
      dsimp [K]
      calc
        X ω ^ 2 / (B / Real.sqrt (Real.log 2)) ^ 2 =
            X ω ^ 2 * (Real.sqrt (Real.log 2)) ^ 2 / B ^ 2 := by
              field_simp [ne_of_gt hB, ne_of_gt hSqrt]
        _ ≤ B ^ 2 * (Real.sqrt (Real.log 2)) ^ 2 / B ^ 2 := by
              gcongr
        _ = (Real.sqrt (Real.log 2)) ^ 2 := by
              field_simp [ne_of_gt hB]
        _ = Real.log 2 := hSqSqrt
    calc
      Real.exp (X ω ^ 2 / K ^ 2) ≤ Real.exp (Real.log 2) :=
        Real.exp_le_exp.mpr hArg
      _ = 2 := by rw [Real.exp_log (by norm_num)]
  have hInt : Integrable (fun ω => Real.exp (X ω ^ 2 / K ^ 2)) μ := by
    refine MeasureTheory.Integrable.mono' (integrable_const (2 : ℝ)) ?_ ?_
    · fun_prop
    · filter_upwards [hPointwise] with ω hω
      simpa only [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _)] using hω
  have hBoundIntegral :
      (∫ ω, Real.exp (X ω ^ 2 / K ^ 2) ∂μ) ≤ 2 := by
    calc
      (∫ ω, Real.exp (X ω ^ 2 / K ^ 2) ∂μ) ≤
          ∫ _ : Ω, (2 : ℝ) ∂μ :=
        MeasureTheory.integral_mono_ae hInt (integrable_const (2 : ℝ))
          hPointwise
      _ = 2 := by simp [probReal_univ]
  have hAdmissible : PsiTwoAdmissible μ X (ENNReal.ofReal K) := by
    refine ⟨hX, (ENNReal.ofReal_ne_zero_iff).2 hK,
      ENNReal.ofReal_ne_top, ?_, ?_⟩
    · simpa [ENNReal.toReal_ofReal hK.le] using hInt
    · simpa [ENNReal.toReal_ofReal hK.le] using hBoundIntegral
  have hInf : PsiTwoGauge μ X ≤ ENNReal.ofReal K := sInf_le hAdmissible
  simpa [K] using hInf

/-! Example 2.5.8(b): the exact gauge of the symmetric two-point law. -/
/-- The equal-weight law on `{-1, 1}` used in the ψ₂ example. -/
noncomputable def rademacherPsiTwoLaw : Measure ℝ :=
  (1 / 2 : ENNReal) • Measure.dirac (-1) +
    (1 / 2 : ENNReal) • Measure.dirac 1

lemma rademacherPsiTwoLaw_probability :
    IsProbabilityMeasure rademacherPsiTwoLaw := by
  apply isProbabilityMeasure_iff.mpr
  simp [rademacherPsiTwoLaw]
  calc
    (2 : ENNReal)⁻¹ + 2⁻¹ = (2 : ENNReal)⁻¹ + (2 : ENNReal)⁻¹ * 1 := by ring
    _ = (2 : ENNReal)⁻¹ * (1 + 1) := by ring
    _ = (2 : ENNReal)⁻¹ * 2 := by norm_num
    _ = 1 := by exact ENNReal.inv_mul_cancel (by norm_num) (by norm_num)

lemma rademacherPsiTwoLaw_integral (f : ℝ → ℝ) :
    ∫ x, f x ∂rademacherPsiTwoLaw =
      (1 / 2 : ℝ) * f (-1) + (1 / 2 : ℝ) * f 1 := by
  rw [rademacherPsiTwoLaw, MeasureTheory.integral_add_measure]
  · rw [MeasureTheory.integral_smul_measure, MeasureTheory.integral_smul_measure,
      MeasureTheory.integral_dirac, MeasureTheory.integral_dirac]
    norm_num
  · apply Integrable.smul_measure
    · exact integrable_dirac (by simp)
    · simp
  · apply Integrable.smul_measure
    · exact integrable_dirac (by simp)
    · simp

lemma rademacherPsiTwoGauge_admissible_iff {t : ℝ≥0∞} :
    PsiTwoAdmissible rademacherPsiTwoLaw id t ↔
      t ≠ 0 ∧ t ≠ ∞ ∧ Real.exp (1 / t.toReal ^ 2) ≤ 2 := by
  constructor
  · rintro ⟨hMeas, ht0, htTop, hInt, hBound⟩
    refine ⟨ht0, htTop, ?_⟩
    rw [rademacherPsiTwoLaw_integral] at hBound
    have hneg : Real.exp (id (-1 : ℝ) ^ 2 / t.toReal ^ 2) =
        Real.exp (1 / t.toReal ^ 2) := by
      simp only [id]
      congr 1
      ring
    have hpos : Real.exp (id (1 : ℝ) ^ 2 / t.toReal ^ 2) =
        Real.exp (1 / t.toReal ^ 2) := by
      simp only [id]
      congr 1
      ring
    calc
      Real.exp (1 / t.toReal ^ 2) =
          (1 / 2 : ℝ) * Real.exp (1 / t.toReal ^ 2) +
            (1 / 2 : ℝ) * Real.exp (1 / t.toReal ^ 2) := by ring
      _ = (1 / 2 : ℝ) * Real.exp (id (-1 : ℝ) ^ 2 / t.toReal ^ 2) +
            (1 / 2 : ℝ) * Real.exp (id (1 : ℝ) ^ 2 / t.toReal ^ 2) := by
              rw [hneg, hpos]
      _ ≤ 2 := hBound
  · rintro ⟨ht0, htTop, hBound⟩
    refine ⟨measurable_id, ht0, htTop, ?_, ?_⟩
    · apply Integrable.add_measure
      · apply Integrable.smul_measure
        · exact integrable_dirac (by simp)
        · simp
      · apply Integrable.smul_measure
        · exact integrable_dirac (by simp)
        · simp
    · rw [rademacherPsiTwoLaw_integral]
      have hneg : Real.exp (id (-1 : ℝ) ^ 2 / t.toReal ^ 2) =
          Real.exp (1 / t.toReal ^ 2) := by
        simp only [id]
        congr 1
        ring
      have hpos : Real.exp (id (1 : ℝ) ^ 2 / t.toReal ^ 2) =
          Real.exp (1 / t.toReal ^ 2) := by
        simp only [id]
        congr 1
        ring
      calc
        (1 / 2 : ℝ) * Real.exp (id (-1 : ℝ) ^ 2 / t.toReal ^ 2) +
            (1 / 2 : ℝ) * Real.exp (id (1 : ℝ) ^ 2 / t.toReal ^ 2) =
            (1 / 2 : ℝ) * Real.exp (1 / t.toReal ^ 2) +
              (1 / 2 : ℝ) * Real.exp (1 / t.toReal ^ 2) := by rw [hneg, hpos]
        _ ≤ 2 := by nlinarith [hBound]

theorem rademacherPsiTwoGauge_exact :
    PsiTwoGauge rademacherPsiTwoLaw id =
      ENNReal.ofReal (1 / Real.sqrt (Real.log 2)) := by
  let q : ℝ := 1 / Real.sqrt (Real.log 2)
  have hlog : 0 < Real.log 2 := Real.log_pos (by norm_num)
  have hsqrt : 0 < Real.sqrt (Real.log 2) := Real.sqrt_pos.2 hlog
  have hq : 0 < q := div_pos one_pos hsqrt
  have hqSq : q ^ 2 = 1 / Real.log 2 := by
    dsimp [q]
    rw [div_pow, Real.sq_sqrt hlog.le]
    norm_num
  have hExpIff {t : ℝ} (ht : 0 < t) :
      Real.exp (1 / t ^ 2) ≤ 2 ↔ q ≤ t := by
    constructor
    · intro hExp
      have hlog' : 1 / t ^ 2 ≤ Real.log 2 := by
        calc
          1 / t ^ 2 = Real.log (Real.exp (1 / t ^ 2)) := by
            rw [Real.log_exp]
          _ ≤ Real.log 2 := by
            exact Real.log_le_log (by positivity) hExp
      apply (sq_le_sq₀ hq.le ht.le).mp
      rw [hqSq]
      apply (div_le_iff₀ hlog).2
      have hmul := (div_le_iff₀ (sq_pos_of_pos ht)).mp hlog'
      simpa [mul_comm] using hmul
    · intro hqt
      have hsq : 1 / t ^ 2 ≤ Real.log 2 := by
        apply (div_le_iff₀ (sq_pos_of_pos ht)).2
        have hqtSq : q ^ 2 ≤ t ^ 2 := (sq_le_sq₀ hq.le ht.le).2 hqt
        rw [hqSq] at hqtSq
        have hmul := (div_le_iff₀ hlog).mp hqtSq
        simpa [mul_comm] using hmul
      calc
        Real.exp (1 / t ^ 2) ≤ Real.exp (Real.log 2) :=
          Real.exp_le_exp.mpr hsq
        _ = 2 := by rw [Real.exp_log (by norm_num)]
  have hqAdmissible :
      PsiTwoAdmissible rademacherPsiTwoLaw id (ENNReal.ofReal q) := by
    apply (rademacherPsiTwoGauge_admissible_iff).2
    refine ⟨ENNReal.ofReal_ne_zero_iff.mpr hq, ENNReal.ofReal_ne_top, ?_⟩
    rw [ENNReal.toReal_ofReal hq.le]
    exact (hExpIff hq).2 le_rfl
  unfold PsiTwoGauge
  apply le_antisymm
  · exact sInf_le hqAdmissible
  · apply le_sInf
    intro t ht
    rcases (rademacherPsiTwoGauge_admissible_iff).1 ht with ⟨ht0, htTop, hBound⟩
    have htpos : 0 < t.toReal := ENNReal.toReal_pos ht0 htTop
    rw [ENNReal.ofReal_le_iff_le_toReal htTop]
    exact (hExpIff htpos).mp hBound

theorem independentGaussianWeightedSumLaw {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {σ : ι → ℝ≥0} (a : ι → ℝ)
    (hLaw : ∀ i, HasLaw (X i) (gaussianReal 0 (σ i)) μ)
    (hIndep : iIndepFun X μ) :
    HasLaw (fun ω => ∑ i, a i * X i ω)
      (gaussianReal 0 (∑ i, Real.toNNReal ((a i) ^ 2) * σ i)) μ := by
  let Y : ι → Ω → ℝ := fun i ω => a i * X i ω
  let τ : ι → ℝ≥0 := fun i => Real.toNNReal ((a i) ^ 2) * σ i
  have hLawY : ∀ i, HasLaw (Y i) (gaussianReal 0 (τ i)) μ := by
    intro i
    simpa [Y, τ, Real.toNNReal_of_nonneg (sq_nonneg (a i))] using
      ProbabilityTheory.gaussianReal_const_mul (hLaw i) (a i)
  have hIndepY : iIndepFun Y μ := by
    have h := hIndep.comp (fun i x => a i * x) (fun i => by fun_prop)
    simpa [Y, Function.comp_def] using h
  have h := independentGaussianSumLaw hLawY hIndepY
  simpa [Y, τ] using h

end NumStability.HDP.Scalar.SubGaussian

namespace NumStability.HDP.Contract

/-! Stable Chapter 2 alias for the Gaussian `ψ₂` example. -/
theorem hdp_02_hexample_h2_d5_d8a :
    ∃ C : ℝ, 0 < C ∧
      NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge
          (ProbabilityTheory.gaussianReal 0 1) id ≤ ENNReal.ofReal C ∧
        ∀ σ : ℝ, 0 ≤ σ →
        NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge
            (ProbabilityTheory.gaussianReal 0
              (⟨σ ^ 2, sq_nonneg σ⟩ : ℝ≥0)) id ≤
          ENNReal.ofReal (C * σ) := by
  refine ⟨2, by norm_num, ?_⟩
  simpa using
    NumStability.HDP.Scalar.SubGaussian.gaussianPsiTwoGauge_le_two_mul

/-! Stable Chapter 2 alias for Proposition 2.5.2. -/
theorem hdp_02_hprop_h2_d5_d2 :
    ∃ C : ℝ, 1 ≤ C ∧
      (∀ {Ω : Type*} [MeasurableSpace Ω]
          {μ : Measure Ω} [IsProbabilityMeasure μ] {X : Ω → ℝ},
        Measurable X →
          ∀ i j : NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind,
            i ≠ .linearMGF → j ≠ .linearMGF → ∀ {Ki : ℝ}, 0 < Ki →
              NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty μ X i Ki →
                ∃ Kj : ℝ, 0 < Kj ∧ Kj ≤ C * Ki ∧
                  NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty μ X j Kj) ∧
      (∀ {Ω : Type*} [MeasurableSpace Ω]
          {μ : Measure Ω} [IsProbabilityMeasure μ] {X : Ω → ℝ},
        Measurable X → Integrable X μ ∧ (∫ ω, X ω ∂μ) = 0 →
          ∀ i j : NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind,
            ∀ {Ki : ℝ}, 0 < Ki →
              NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty μ X i Ki →
                ∃ Kj : ℝ, 0 < Kj ∧ Kj ≤ C * Ki ∧
                  NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty μ X j Kj) :=
  NumStability.HDP.Scalar.SubGaussian.subGaussianCharacterization_absolute

/-! Stable Chapter 2 alias for the gauge-facing characterization theorem. -/
theorem hdp_02_hthm_hpsi2_hnorm_hcharacterizations
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ}
    (hCenter : Integrable X μ ∧ (∫ ω, X ω ∂μ) = 0) :
    ∃ C : ℝ, 1 ≤ C ∧
      (∀ i : NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind,
        ∀ {K : ℝ}, 0 < K →
          NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty μ X i K →
            NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X ≤
              ENNReal.ofReal (C * K)) ∧
      (∀ i : NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind,
        ((∃ K : ℝ, 0 < K ∧
          NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty μ X i K) ↔
          NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X < ∞)) :=
  NumStability.HDP.Scalar.SubGaussian.psiTwoGaugeCharacterizations hCenter

/-! Compatibility alias for the earlier scale-parametric MGF formulation of
Proposition 2.6.1.  The exact source-facing alias below now exposes intrinsic
`ψ₂` norms and one universally quantified absolute constant. -/
theorem hdp_02_hprop_h2_d6_d1_mgfScale
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {K : ι → ℝ}
    (hX : ∀ i,
      NumStability.HDP.Scalar.SubGaussian.SubGaussianLinearMGF μ (X i) (K i))
    (hIndep : ProbabilityTheory.iIndepFun X μ)
    (hEnergy : 0 < ∑ i, K i ^ 2) :
    ∃ C : ℝ, 1 ≤ C ∧
      NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty μ
          (fun ω => ∑ i, X i ω) .linearMGF
          (Real.sqrt (∑ i, K i ^ 2)) ∧
      NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ
          (fun ω => ∑ i, X i ω) ≤
        ENNReal.ofReal (C * Real.sqrt (∑ i, K i ^ 2)) :=
  NumStability.HDP.Scalar.SubGaussian.independentCenteredSubGaussianSum
    hX hIndep hEnergy

/-! Stable Chapter 2 alias for Proposition 2.6.1. -/
theorem hdp_02_hprop_h2_d6_d1 :
    ∃ C : ℝ, 1 ≤ C ∧
      ∀ {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
        {μ : Measure Ω} [IsProbabilityMeasure μ]
        {X : ι → Ω → ℝ},
        (∀ i, NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ (X i)) →
        (∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0) →
        ProbabilityTheory.iIndepFun X μ →
          NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ
              (fun ω => ∑ i, X i ω) ∧
            (NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
                (fun ω => ∑ i, X i ω)).toReal ^ 2 ≤
              C * ∑ i,
                (NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
                  (X i)).toReal ^ 2 :=
  NumStability.HDP.Scalar.SubGaussian.independentCenteredSubGaussianSumPsiTwo

/-! Compatibility alias for the earlier scale-parametric MGF formulation of
Theorem 2.6.2.  The exact source-facing alias below uses intrinsic `ψ₂` norms
and quantifies one universal positive constant before the family. -/
theorem hdp_02_hthm_h2_d6_d2_mgfScale
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {K : ι → ℝ}
    (hX : ∀ i,
      NumStability.HDP.Scalar.SubGaussian.SubGaussianLinearMGF μ (X i) (K i))
    (hIndep : ProbabilityTheory.iIndepFun X μ)
    (hEnergy : 0 < ∑ i, K i ^ 2)
    {t : ℝ} (ht : 0 ≤ t) :
    μ.real {ω | |∑ i, X i ω| ≥ t} ≤
      2 * Real.exp (-t ^ 2 / (4 * ∑ i, K i ^ 2)) :=
  NumStability.HDP.Scalar.SubGaussian.independentCenteredSubGaussianTail
    hX hIndep hEnergy ht

/-! Stable Chapter 2 alias for Theorem 2.6.2. -/
theorem hdp_02_hthm_h2_d6_d2 :
    ∃ c : ℝ, 0 < c ∧
      ∀ {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
        {μ : Measure Ω} [IsProbabilityMeasure μ]
        {X : ι → Ω → ℝ},
        (∀ i, NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ (X i)) →
        (∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0) →
        ProbabilityTheory.iIndepFun X μ →
        ∀ {t : ℝ}, 0 ≤ t →
          μ.real {ω | |∑ i, X i ω| ≥ t} ≤
            2 * Real.exp
              (-(c * t ^ 2 /
                ∑ i,
                  (NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
                    (X i)).toReal ^ 2)) :=
  NumStability.HDP.Scalar.SubGaussian.independentCenteredSubGaussianTailPsiTwo

/-! Compatibility alias for the earlier common-MGF-scale formulation of
Theorem 2.6.3. -/
theorem hdp_02_hthm_h2_d6_d3_mgfScale
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {K : ℝ}
    (hK : 0 < K)
    (hX : ∀ i,
      NumStability.HDP.Scalar.SubGaussian.SubGaussianLinearMGF μ (X i) K)
    (hIndep : ProbabilityTheory.iIndepFun X μ)
    {a : ι → ℝ}
    (hEnergy : 0 < ∑ i, a i ^ 2)
    {t : ℝ} (ht : 0 ≤ t) :
    μ.real {ω | |∑ i, a i * X i ω| ≥ t} ≤
      2 * Real.exp (-t ^ 2 / (4 * K ^ 2 * ∑ i, a i ^ 2)) :=
  NumStability.HDP.Scalar.SubGaussian.independentWeightedCenteredSubGaussianTail
    hK hX hIndep hEnergy ht

/-! Stable Chapter 2 alias for Theorem 2.6.3. -/
theorem hdp_02_hthm_h2_d6_d3 :
    ∃ c : ℝ, 0 < c ∧
      ∀ {ι Ω : Type*} [Fintype ι] [Nonempty ι] [MeasurableSpace Ω]
        {μ : Measure Ω} [IsProbabilityMeasure μ]
        {X : ι → Ω → ℝ},
        (∀ i, NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ (X i)) →
        (∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0) →
        ProbabilityTheory.iIndepFun X μ →
        ∀ (a : ι → ℝ) {t : ℝ}, 0 ≤ t →
          μ.real {ω | |∑ i, a i * X i ω| ≥ t} ≤
            2 * Real.exp
              (-(c * t ^ 2 /
                ((NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ X) ^ 2 *
                  ∑ i, a i ^ 2))) :=
  NumStability.HDP.Scalar.SubGaussian.independentWeightedCenteredSubGaussianTailPsiTwo

/-! Stable Chapter 2 alias for Lemma 2.6.8. -/
theorem hdp_02_hlem_h2_d6_d8
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ}
    (i : NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind)
    {K : ℝ} (hK : 0 < K)
    (hProp : NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty μ X i K) :
    ∃ C : ℝ, 1 ≤ C ∧
      Integrable X μ ∧
      ∃ K' : ℝ, 0 < K' ∧ K' ≤ C * K ∧
        NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty μ
            (fun ω => X ω - ∫ x, X x ∂μ) .squarePoint K' ∧
        NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ
            (fun ω => X ω - ∫ x, X x ∂μ) ≤
          ENNReal.ofReal (C * K) :=
  NumStability.HDP.Scalar.SubGaussian.centeredSubGaussian i hK hProp

/-! Stable Chapter 2 alias for Remark 2.5.3. -/
theorem hdp_02_hrem_h2_d5_d3 (A : ℝ) (hA : 1 < A) :
    ∃ C : ℝ, 1 ≤ C ∧
      (∀ {Ω : Type*} [MeasurableSpace Ω]
          {μ : Measure Ω} [IsProbabilityMeasure μ] {X : Ω → ℝ},
        Measurable X →
          ∀ i j : NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind,
            i ≠ .linearMGF → j ≠ .linearMGF → ∀ {Ki : ℝ}, 0 < Ki →
              NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyWithThreshold
                  μ X A i Ki →
                ∃ Kj : ℝ, 0 < Kj ∧ Kj ≤ C * Ki ∧
                  NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyWithThreshold
                    μ X A j Kj) ∧
      (∀ {Ω : Type*} [MeasurableSpace Ω]
          {μ : Measure Ω} [IsProbabilityMeasure μ] {X : Ω → ℝ},
        Measurable X → Integrable X μ ∧ (∫ ω, X ω ∂μ) = 0 →
          ∀ i j : NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind,
            ∀ {Ki : ℝ}, 0 < Ki →
              NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyWithThreshold
                  μ X A i Ki →
                ∃ Kj : ℝ, 0 < Kj ∧ Kj ≤ C * Ki ∧
                  NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyWithThreshold
                    μ X A j Kj) :=
  NumStability.HDP.Scalar.SubGaussian.subGaussianThresholdCharacterization_absolute A hA

/-! Stable Chapter 2 rendering of Definition 2.5.6.  It names the class using
any of the equivalent uncentered properties (i)--(iv) and identifies its
finite `ψ₂` norm with the displayed positive-scale infimum. -/
theorem hdp_02_hdef_h2_d5_d6
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] {X : Ω → ℝ}
    (_hX : Measurable X) :
    (∀ i : NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind,
      i ≠ .linearMGF →
        (NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ X ↔
          ∃ K : ℝ, 0 < K ∧
            NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty μ X i K)) ∧
      (NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ X →
        NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ X < ∞ ∧
          NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ X =
            sInf {t : ℝ≥0∞ |
              NumStability.HDP.Scalar.SubGaussian.PsiTwoAdmissible μ X t}) := by
  constructor
  · intro i hi
    exact NumStability.HDP.Scalar.SubGaussian.isSubGaussian_iff_property i hi
  · intro hSub
    constructor
    · exact
        NumStability.HDP.Scalar.SubGaussian.isSubGaussian_iff_psiTwoNorm_finite.mp hSub
    · rfl

/-! Stable Chapter 2 alias for Exercise 2.5.7: the exact ψ₂ norm on the
measurable finite-gauge quotient modulo a.e. equality. -/
theorem hdp_02_hex_h2_d5_d7
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ] :
    (∀ x, 0 ≤ NumStability.HDP.Scalar.SubGaussian.psiTwoQuotientNorm μ x) ∧
      NumStability.HDP.Scalar.SubGaussian.psiTwoQuotientNorm μ 0 = 0 ∧
      (∀ x,
        NumStability.HDP.Scalar.SubGaussian.psiTwoQuotientNorm μ x = 0 ↔
          x = 0) ∧
      (∀ x y,
        NumStability.HDP.Scalar.SubGaussian.psiTwoQuotientNorm μ (x + y) ≤
          NumStability.HDP.Scalar.SubGaussian.psiTwoQuotientNorm μ x +
            NumStability.HDP.Scalar.SubGaussian.psiTwoQuotientNorm μ y) ∧
      (∀ (c : ℝ) x,
        NumStability.HDP.Scalar.SubGaussian.psiTwoQuotientNorm μ (c • x) =
          |c| *
            NumStability.HDP.Scalar.SubGaussian.psiTwoQuotientNorm μ x) :=
  NumStability.HDP.Scalar.SubGaussian.psiTwoQuotientNorm_isNorm μ

/-! Stable Chapter 2 alias for the essentially bounded `ψ₂` estimate. -/
theorem hdp_02_hexample_h2_d5_d8c
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] {X : Ω → ℝ} {B : ℝ}
    (hX : Measurable X) (hB : 0 < B)
    (hBound : ∀ᵐ ω ∂μ, |X ω| ≤ B) :
    NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X ≤
      ENNReal.ofReal (B / Real.sqrt (Real.log 2)) :=
  NumStability.HDP.Scalar.SubGaussian.essentiallyBoundedPsiTwoGauge hX hB hBound

/-! Stable Chapter 2 alias for the exact Rademacher `ψ₂` gauge. -/
theorem hdp_02_hexample_h2_d5_d8b :
    NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge
        NumStability.HDP.Scalar.SubGaussian.rademacherPsiTwoLaw id =
      ENNReal.ofReal (1 / Real.sqrt (Real.log 2)) :=
  NumStability.HDP.Scalar.SubGaussian.rademacherPsiTwoGauge_exact

/-! Stable Chapter 2 alias for the standard-normal `Lᵖ` moment formula. -/
theorem hdp_02_hex_h2_d5_d1 (p : ℝ) (hp : 1 ≤ p) :
    (eLpNorm' (fun x : ℝ => x) p (gaussianReal 0 1)).toReal =
      (2 ^ (p / 2) * Real.Gamma ((1 + p) / 2) / Real.Gamma (1 / 2)) ^ (1 / p) :=
  NumStability.HDP.Scalar.SubGaussian.standardNormalLpNorm p hp

/-! Stable Chapter 2 alias for the standard-normal square-MGF example. -/
theorem hdp_02_hex_h2_d5_d5a (lam : ℝ) :
    (|lam| < (Real.sqrt 2)⁻¹ →
      Integrable (fun x : ℝ => Real.exp (lam ^ 2 * x ^ 2)) (gaussianReal 0 1) ∧
        (∫ x : ℝ, Real.exp (lam ^ 2 * x ^ 2) ∂(gaussianReal 0 1)) =
          (Real.sqrt (1 - 2 * lam ^ 2))⁻¹) ∧
    ((Real.sqrt 2)⁻¹ ≤ |lam| →
      ¬ Integrable (fun x : ℝ => Real.exp (lam ^ 2 * x ^ 2)) (gaussianReal 0 1)) :=
  NumStability.HDP.Scalar.SubGaussian.standardNormalSquareMGF lam

/-! Stable Chapter 2 alias for the tail-to-moment direction. -/
theorem hdp_02_hlem_hsg_htail_hto_hmoment
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ} (hX : Measurable X) (hK : 0 < K)
    (hTail : ∀ t : ℝ, 0 ≤ t →
      μ.real {ω | |X ω| ≥ t} ≤ 2 * Real.exp (-t ^ 2 / K ^ 2)) :
    NumStability.HDP.Scalar.SubGaussian.LpMomentGrowth μ X
      (8 * Real.exp 1 * K) :=
  NumStability.HDP.Scalar.SubGaussian.tailToLpMomentGrowth hX hK hTail

/-- Stable Chapter 2 alias for the moment-to-square-MGF implication. -/
theorem hdp_02_hlem_hsg_hmoment_hto_hsquare_hmgf
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ} (hK : 0 < K)
    (hLp : NumStability.HDP.Scalar.SubGaussian.LpMomentGrowth μ X K)
    (lam : ℝ) (hsmall : |lam| ≤ (4 * K)⁻¹) :
    Integrable (fun ω => Real.exp (lam ^ 2 * X ω ^ 2)) μ ∧
      (∫ ω, Real.exp (lam ^ 2 * X ω ^ 2) ∂μ) ≤
        Real.exp (4 * Real.exp 1 * (lam * K) ^ 2) :=
  NumStability.HDP.Scalar.SubGaussian.momentToSquareMGF hK hLp lam hsmall

/-- Stable Chapter 2 alias for the square-MGF-to-MGF implication. -/
theorem hdp_02_hlem_hsg_hsquare_hmgf_hto_hmgf
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {C : ℝ} (hC : 0 ≤ C)
    (hCenter : Integrable X μ ∧ (∫ ω, X ω ∂μ) = 0)
    (hSquare : NumStability.HDP.Scalar.SubGaussian.SquareMGFLocal μ X C)
    (lam : ℝ) :
    Integrable (fun ω => Real.exp (lam * X ω)) μ ∧
      (∫ ω, Real.exp (lam * X ω) ∂μ) ≤
        Real.exp ((C + 1 / 2) * lam ^ 2) :=
  NumStability.HDP.Scalar.SubGaussian.squareMGFToMGF hC hCenter hSquare lam

/-! Stable Chapter 2 alias for the square-MGF-to-tail implication. -/
theorem hdp_02_hlem_hsg_hsquare_hmgf_hto_htail
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ}
    (hX : Measurable X) (hK : 0 < K)
    (hMGF : Integrable (fun ω => Real.exp (X ω ^ 2 / K ^ 2)) μ ∧
      (∫ ω, Real.exp (X ω ^ 2 / K ^ 2) ∂μ) ≤ 2)
    {t : ℝ} (ht : 0 ≤ t) :
    μ.real {ω | |X ω| ≥ t} ≤ 2 * Real.exp (-t ^ 2 / K ^ 2) :=
  NumStability.HDP.Scalar.SubGaussian.squareMGFToTail hX hK hMGF ht

/-! Stable Chapter 2 alias for the global square-MGF boundedness exercise. -/
theorem hdp_02_hex_h2_d5_d5b
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ}
    (hX : Measurable X) (hK : 0 ≤ K)
    (hMGF : ∀ lam : ℝ,
      Integrable (fun ω => Real.exp (lam ^ 2 * X ω ^ 2)) μ ∧
        (∫ ω, Real.exp (lam ^ 2 * X ω ^ 2) ∂μ) ≤ Real.exp (K * lam ^ 2))
    {t : ℝ} (ht : 0 ≤ t) (hthreshold : K < t ^ 2) :
    μ.real {ω | |X ω| ≥ t} = 0 :=
  NumStability.HDP.Scalar.SubGaussian.squareMGFGlobalTailZero
    hX hK hMGF ht hthreshold

/-! Stable Chapter 2 alias for the all-parameter MGF-to-tail implication. -/
theorem hdp_02_hlem_hsg_hmgf_hto_htail
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ}
    (hX : Measurable X) (hK : 0 < K)
    (hMGF : ∀ lam : ℝ,
      Integrable (fun ω => Real.exp (lam * X ω)) μ ∧
        (∫ ω, Real.exp (lam * X ω) ∂μ) ≤ Real.exp (K ^ 2 * lam ^ 2))
    {t : ℝ} (ht : 0 ≤ t) :
    μ.real {ω | |X ω| ≥ t} ≤ 2 * Real.exp (-t ^ 2 / (4 * K ^ 2)) :=
  NumStability.HDP.Scalar.SubGaussian.mgfToTail hX hK hMGF ht

/-! Stable Chapter 2 alias for Exercise 2.5.4. -/
theorem hdp_02_hex_h2_d5_d4
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ}
    (hX : Integrable X μ)
    (hMGF : ∀ lam : ℝ,
      Integrable (fun ω => Real.exp (lam * X ω)) μ ∧
        (∫ ω, Real.exp (lam * X ω) ∂μ) ≤ Real.exp (K ^ 2 * lam ^ 2)) :
    (∫ ω, X ω ∂μ) = 0 :=
  NumStability.HDP.Scalar.SubGaussian.mgfBoundForcesMeanZero hX hMGF

/-! Stable Chapter 2 alias for Exercise 2.6.9. -/
theorem hdp_02_hex_h2_d6_d9 : hdp_02_hex_h2_d6_d9__contract_type := by
  simpa [hdp_02_hex_h2_d6_d9__contract_type,
    NumStability.HDP.Scalar.SubGaussian.exercise269Law,
    NumStability.HDP.Scalar.SubGaussian.exercise269Mean,
    NumStability.HDP.Scalar.SubGaussian.twoPointPsiTwoNorm,
    NumStability.HDP.Scalar.SubGaussian.twoPointPsiTwoAdmissible] using
    NumStability.HDP.Scalar.SubGaussian.exercise269_counterexample

/-! Stable Chapter 2 alias for the `L²` interpolation estimate. -/
theorem hdp_02_hlem_hlp_hextrapolation
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] {Z : Ω → ℝ}
    (hZ1 : MemLp Z 1 μ) (hZ3 : MemLp Z 3 μ) :
    (∫ ω, |Z ω| ^ (2 : ℝ) ∂μ) ^ (1 / 2 : ℝ) ≤
      (∫ ω, |Z ω| ∂μ) ^ (1 / 4 : ℝ) *
        (∫ ω, |Z ω| ^ (3 : ℕ) ∂μ) ^ (1 / 4 : ℝ) :=
  NumStability.HDP.Scalar.SubGaussian.lpExtrapolation hZ1 hZ3

end NumStability.HDP.Contract
