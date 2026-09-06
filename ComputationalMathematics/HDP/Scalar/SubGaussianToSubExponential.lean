import ComputationalMathematics.HDP.Scalar.SubExponentialCharacterization

/-!
# Sub-gaussian variables are sub-exponential

Reusable bridges from the square-root moment growth of a sub-gaussian random
variable to the linear moment growth of a sub-exponential random variable.
-/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Scalar.SubGaussian

universe u

/-- A sub-gaussian moment bound at scale `K` is a sub-exponential moment bound
at the same scale, since `sqrt p <= p` for `p >= 1`. -/
theorem momentBound_to_subExponentialMomentBound
    {Omega : Type*} [MeasurableSpace Omega]
    {mu : Measure Omega} {X : Omega -> Real} {K : Real}
    (h : SubGaussianMomentBound mu X K) :
    SubExponential.SubExponentialMomentBound mu X K := by
  rcases h with ⟨hMeas, hK, hGrowth⟩
  refine ⟨hMeas, hK, hGrowth.1, ?_⟩
  intro p hp
  obtain ⟨hInt, hBound⟩ := hGrowth.2 p hp
  refine ⟨hInt, hBound.trans ?_⟩
  have hp0 : 0 <= p := le_trans (by norm_num) hp
  have hSqrt : Real.sqrt p <= p := by
    rw [Real.sqrt_le_iff]
    constructor
    · exact hp0
    · nlinarith
  have hBase : K * Real.sqrt p <= K * p :=
    mul_le_mul_of_nonneg_left hSqrt hK.le
  exact Real.rpow_le_rpow (mul_nonneg hK.le (Real.sqrt_nonneg p)) hBase hp0

/-- Any of the four noncentered sub-gaussian properties implies a
sub-exponential moment property. -/
theorem property_to_subExponentialMoment
    {Omega : Type u} [MeasurableSpace Omega]
    {mu : Measure Omega} [IsProbabilityMeasure mu] {X : Omega -> Real} :
    (∃ i : SubGaussianPropertyKind,
      i ≠ .linearMGF ∧ ∃ K : Real, 0 < K ∧ SubGaussianProperty mu X i K) ->
      ∃ K : Real, 0 < K ∧
        SubExponential.SubExponentialProperty mu X .moment K := by
  rintro ⟨i, hi, K, hK, hProp⟩
  have hMeas : Measurable X := by
    cases i <;> exact hProp.1
  let hCharacterization := subGaussianCharacterization_absolute.{u, u}
  let C := hCharacterization.choose
  have hBase := hCharacterization.choose_spec.2.1
    (Ω := Omega) (μ := mu) (X := X)
  obtain ⟨Km, hKm, hKmBound, hMoment⟩ :=
    hBase hMeas i .moment hi (by simp) hK hProp
  exact ⟨Km, hKm, momentBound_to_subExponentialMomentBound hMoment⟩

end NumStability.HDP.Scalar.SubGaussian
