import ComputationalMathematics.HDP.Scalar.SubExponentialExamples
import ComputationalMathematics.HDP.Scalar.SubExponentialCentering
import Mathlib.Probability.Independence.Basic

/-!
# Obstruction to the literal normalized Bernstein large-deviation display

The unnumbered display after Vershynin's Corollary 2.8.3 suppresses the
dependence on the common `ψ₁` scale in its large-deviation exponent, writing
`2 exp (-t * sqrt N)`.  A centered, scaled exponential variable shows that no
choice of the regime threshold can repair that coefficient.

This file records the reusable mathematical obstruction.  Source-facing
discrepancy wrappers live under `ComputationalMathematics.Source.Vershynin`.
-/

noncomputable section

open MeasureTheory ProbabilityTheory Set
open scoped ENNReal

namespace NumStability.HDP.Scalar.IndependentSums.Bernstein

open NumStability.HDP.Scalar.SubExponential
open NumStability.HDP.Scalar.SubExponentialExamples

/-- The centered scale-two rate-one exponential variable used in the
large-deviation obstruction. -/
def centeredScaledExponential (x : ℝ) : ℝ := 2 * x - 2

private instance expMeasureOneProbability : IsProbabilityMeasure (expMeasure 1) :=
  ProbabilityTheory.isProbabilityMeasure_expMeasure (by norm_num)

/-- The exact open upper tail of the rate-one exponential law. -/
theorem expMeasureOne_real_Ioi (a : ℝ) (ha : 0 ≤ a) :
    (expMeasure 1).real (Ioi a) = Real.exp (-a) := by
  have hcompl := probReal_add_probReal_compl
    (μ := expMeasure 1) (s := Iic a) measurableSet_Iic
  rw [← ProbabilityTheory.cdf_eq_real,
    ProbabilityTheory.cdf_expMeasure_eq (by norm_num), if_pos ha] at hcompl
  simp only [compl_Iic] at hcompl
  simp only [one_mul] at hcompl
  linarith

/-- The obstruction variable is measurable. -/
theorem measurable_centeredScaledExponential : Measurable centeredScaledExponential := by
  simpa [centeredScaledExponential] using
    (measurable_const.mul measurable_id).sub measurable_const

/-- The obstruction variable is integrable under the rate-one exponential law. -/
theorem integrable_centeredScaledExponential :
    Integrable centeredScaledExponential (expMeasure 1) := by
  exact (integrable_id_expMeasure_one.const_mul 2).sub (integrable_const 2)

/-- The obstruction variable is centered. -/
theorem integral_centeredScaledExponential :
    (∫ x : ℝ, centeredScaledExponential x ∂expMeasure 1) = 0 := by
  rw [show centeredScaledExponential = fun x : ℝ ↦ 2 * x - 2 by rfl]
  rw [integral_sub (integrable_id_expMeasure_one.const_mul 2) (integrable_const 2),
    integral_const_mul, integral_id_expMeasure_one, integral_const, probReal_univ]
  norm_num

/-- The obstruction variable has finite `ψ₁` gauge, so it lies in the source's
sub-exponential class. -/
theorem psiOneGauge_centeredScaledExponential_lt_top :
    PsiOneGauge (expMeasure 1) centeredScaledExponential < ∞ := by
  have hscaled :
      PsiOneGauge (expMeasure 1) (fun x : ℝ ↦ 2 * x) < ∞ := by
    rw [psiOneGauge_smul_of_pos (by norm_num), psiOneGauge_id_expMeasure_one]
    exact ENNReal.mul_lt_top (by simp) (by simp)
  have hconst :
      PsiOneGauge (expMeasure 1) (fun _x : ℝ ↦ (-2 : ℝ)) < ∞ := by
    exact lt_of_le_of_lt
      (psiOneGauge_const_le_two_mul_abs (μ := expMeasure 1) (-2))
      ENNReal.ofReal_lt_top
  have hadd := psiOneGauge_add_le (μ := expMeasure 1)
    (X := fun x : ℝ ↦ 2 * x) (Y := fun _x : ℝ ↦ (-2 : ℝ))
  exact lt_of_le_of_lt (by simpa [centeredScaledExponential] using hadd)
    (ENNReal.add_lt_top.mpr ⟨hscaled, hconst⟩)

/-- A singleton family of copies of the obstruction variable is independent. -/
theorem iIndepFun_centeredScaledExponential_unit :
    iIndepFun (fun _u : Unit ↦ centeredScaledExponential) (expMeasure 1) :=
  ProbabilityTheory.iIndepFun.of_subsingleton

/-- The tail of the centered scale-two exponential eventually exceeds the
literal coefficient-one large-deviation branch, regardless of the proposed
regime threshold. -/
theorem centeredScaledExponential_violates_literal_large_tail (C : ℝ) :
    ∃ t : ℝ, 0 ≤ t ∧ C ≤ t ∧
      2 * Real.exp (-t) <
        (expMeasure 1).real {x | centeredScaledExponential x ≥ t} := by
  let t : ℝ := max C 4
  have ht0 : 0 ≤ t := le_trans (by norm_num) (le_max_right C 4)
  have hCt : C ≤ t := le_max_left C 4
  have ht4 : 4 ≤ t := le_max_right C 4
  have htail : Real.exp (-(t / 2 + 1)) ≤
      (expMeasure 1).real {x | centeredScaledExponential x ≥ t} := by
    rw [← expMeasureOne_real_Ioi (t / 2 + 1) (by linarith)]
    apply measureReal_mono (h₂ := measure_ne_top _ _)
    intro x hx
    simp only [mem_Ioi, mem_setOf_eq] at hx ⊢
    unfold centeredScaledExponential
    linarith
  have hexp : 2 * Real.exp (-t) < Real.exp (-(t / 2 + 1)) := by
    calc
      2 * Real.exp (-t) < Real.exp 1 * Real.exp (-t) :=
        mul_lt_mul_of_pos_right Real.exp_one_gt_two (Real.exp_pos _)
      _ = Real.exp (1 - t) := by
        rw [← Real.exp_add]
        congr 1
      _ ≤ Real.exp (-(t / 2 + 1)) := Real.exp_le_exp.mpr (by linarith)
  exact ⟨t, ht0, hCt, hexp.trans_le htail⟩

/-- The source's literal coefficient-one large-deviation branch has no valid
positive threshold even for one centered sub-exponential random variable. -/
theorem no_literal_normalizedLargeTail_threshold :
    ¬ ∃ C : ℝ, 0 < C ∧
      ∀ {t : ℝ}, 0 ≤ t → C ≤ t →
        (expMeasure 1).real {x | centeredScaledExponential x ≥ t} ≤
          2 * Real.exp (-t) := by
  rintro ⟨C, _hC, htail⟩
  obtain ⟨t, ht0, hCt, hcontra⟩ := centeredScaledExponential_violates_literal_large_tail C
  exact (not_lt_of_ge (htail ht0 hCt)) hcontra

/-- Exact singleton obstruction to the absolute-value event occurring in the
book's normalized display.  For `N = 1`, normalization and the displayed
large-deviation exponent both simplify to the expressions below. -/
theorem no_literal_normalizedLargeTail_threshold_abs :
    ¬ ∃ C : ℝ, 0 < C ∧
      ∀ {t : ℝ}, 0 ≤ t → C ≤ t →
        (expMeasure 1).real {x | |centeredScaledExponential x| ≥ t} ≤
          2 * Real.exp (-t) := by
  intro h
  apply no_literal_normalizedLargeTail_threshold
  rcases h with ⟨C, hC, htail⟩
  refine ⟨C, hC, fun {t} ht0 hCt ↦ ?_⟩
  calc
    (expMeasure 1).real {x | centeredScaledExponential x ≥ t} ≤
        (expMeasure 1).real {x | |centeredScaledExponential x| ≥ t} := by
      apply measureReal_mono (h₂ := measure_ne_top _ _)
      intro x hx
      simp only [mem_setOf_eq] at hx ⊢
      exact hx.trans (le_abs_self _)
    _ ≤ 2 * Real.exp (-t) := htail ht0 hCt

end NumStability.HDP.Scalar.IndependentSums.Bernstein
