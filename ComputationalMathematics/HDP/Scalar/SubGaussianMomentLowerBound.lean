import ComputationalMathematics.HDP.Scalar.SubGaussian.Basic

/-!
# A second-moment lower bound for the exact sub-Gaussian gauge

The exponential-square definition of the gauge forces a universal lower
bound whenever the ordinary second moment is one.  This applies to every
probability space and does not rely on a particular law or coupling.
-/

namespace NumStability.HDP.Scalar.SubGaussian

open MeasureTheory
open scoped ENNReal

/-- A real random variable with unit second moment has exact `ψ₂` gauge at
least `1 / √(log 2)`.  The bound holds even when the gauge is infinite. -/
theorem psiTwoGauge_ge_of_unit_secondMoment
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    [IsProbabilityMeasure μ] {X : Ω → ℝ}
    (hSq : Integrable (fun ω => X ω ^ 2) μ)
    (hMoment : (∫ ω, X ω ^ 2 ∂μ) = 1) :
    ENNReal.ofReal (1 / Real.sqrt (Real.log 2)) ≤ PsiTwoGauge μ X := by
  have hlog : 0 < Real.log 2 := Real.log_pos (by norm_num)
  have hsqrt : 0 < Real.sqrt (Real.log 2) := Real.sqrt_pos.2 hlog
  let q : ℝ := 1 / Real.sqrt (Real.log 2)
  have hq : 0 < q := div_pos one_pos hsqrt
  have hqSq : q ^ 2 = 1 / Real.log 2 := by
    dsimp [q]
    rw [div_pow, Real.sq_sqrt hlog.le]
    norm_num
  unfold PsiTwoGauge
  apply le_sInf
  intro t ht
  rcases ht with ⟨_hMeas, ht0, htTop, hExpInt, hBound⟩
  have htPos : 0 < t.toReal := ENNReal.toReal_pos ht0 htTop
  have hDivInt : Integrable (fun ω => X ω ^ 2 / t.toReal ^ 2) μ :=
    hSq.div_const _
  have hJensen := NumStability.HDP.Scalar.Preliminaries.jensenIntegral
    (μ := μ) (X := fun ω => X ω ^ 2 / t.toReal ^ 2)
    (φ := Real.exp) convexOn_exp hDivInt hExpInt
  have hIntegral :
      (∫ ω, X ω ^ 2 / t.toReal ^ 2 ∂μ) = 1 / t.toReal ^ 2 := by
    simp only [div_eq_mul_inv, integral_mul_const, hMoment, one_mul]
  have hExp : Real.exp (1 / t.toReal ^ 2) ≤ 2 := by
    simpa only [NumStability.HDP.Scalar.Preliminaries.expectation, hIntegral] using
      hJensen.trans hBound
  have hLogBound : 1 / t.toReal ^ 2 ≤ Real.log 2 := by
    calc
      1 / t.toReal ^ 2 = Real.log (Real.exp (1 / t.toReal ^ 2)) := by
        rw [Real.log_exp]
      _ ≤ Real.log 2 := Real.log_le_log (by positivity) hExp
  have hRealBound : q ≤ t.toReal := by
    apply (sq_le_sq₀ hq.le htPos.le).mp
    rw [hqSq]
    apply (div_le_iff₀ hlog).2
    have hmul := (div_le_iff₀ (sq_pos_of_pos htPos)).mp hLogBound
    simpa [mul_comm] using hmul
  rw [ENNReal.ofReal_le_iff_le_toReal htTop]
  exact hRealBound

end NumStability.HDP.Scalar.SubGaussian
