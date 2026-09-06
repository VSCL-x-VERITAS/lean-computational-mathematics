import ComputationalMathematics.HDP.Scalar.IndependentSums.Bernstein

/-!
# Characterizations of sub-exponential random variables

This module assembles the reusable four-way absolute-value characterization
from `SubExponential` with the centered local-MGF characterization used by
Bernstein's inequality.  The main theorem exposes one absolute constant before
the ambient probability space and random variable, matching the uniformity
needed by downstream concentration results.
-/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Scalar.SubExponential

open NumStability.HDP.Scalar.IndependentSums.Bernstein

/-- Property (e) of Proposition 2.7.1 implies the moment-growth property (b).

The positive and negative endpoint values of the window give a two-sided
exponential-moment
bound with exponent `1`; `mgfToMoment` then gives the displayed scale. -/
theorem subExponentialLinearMGF_to_moment
    {Omega : Type*} [MeasurableSpace Omega]
    {mu : Measure Omega} [IsProbabilityMeasure mu]
    {X : Omega -> Real} {K : Real}
    (hLinear : SubExponentialLinearMGF mu X K) :
    LpMomentGrowth mu X (2 * Real.exp 1 * K) := by
  rcases hLinear with ⟨hX, hK, hInt, hCenter, hMGF⟩
  apply mgfToMoment hK (by norm_num : (0 : Real) <= 1)
  refine ⟨hX.aemeasurable, ?_, ?_⟩
  · have hInv : 0 < K⁻¹ := inv_pos.mpr hK
    have hAt := hMGF K⁻¹ (by simp [abs_of_pos hInv])
    refine ⟨?_, ?_⟩
    · simpa [div_eq_mul_inv, mul_comm] using hAt.1
    · simpa [div_eq_mul_inv, mul_comm, hK.ne'] using hAt.2
  · have hInv : 0 < K⁻¹ := inv_pos.mpr hK
    have hAt := hMGF (-K⁻¹) (by simp [abs_of_pos hInv])
    refine ⟨?_, ?_⟩
    · simpa [div_eq_mul_inv, mul_comm] using hAt.1
    · simpa [div_eq_mul_inv, mul_comm, hK.ne'] using hAt.2

/-- Uniform form of Proposition 2.7.1.

The first conjunct states the equivalence, up to one absolute factor, of the
tail, moment, local absolute-MGF, and one-point absolute-MGF properties.  Under
centering, the second conjunct adds the two implications between the moment
property and the local MGF bound for `X` itself.  Since the four absolute-value
properties are mutually equivalent, these two bridges make property (e)
equivalent to every one of properties (a)--(d). -/
theorem subExponentialCharacterization_uniform :
    ∃ C : Real, 1 <= C ∧
      ∀ {Omega : Type*} [MeasurableSpace Omega]
        {mu : Measure Omega} [IsProbabilityMeasure mu] {X : Omega -> Real},
        (∀ i j : SubExponentialPropertyKind, ∀ {Ki : Real},
          0 < Ki -> SubExponentialProperty mu X i Ki ->
            ∃ Kj : Real, 0 < Kj ∧ Kj <= C * Ki ∧
              SubExponentialProperty mu X j Kj) ∧
        ((Integrable X mu ∧ (∫ omega, X omega ∂mu) = 0) ->
          (∀ {K2 : Real}, 0 < K2 ->
            SubExponentialProperty mu X .moment K2 ->
              ∃ K5 : Real, 0 < K5 ∧ K5 <= C * K2 ∧
                SubExponentialLinearMGF mu X K5) ∧
          (∀ {K5 : Real}, 0 < K5 ->
            SubExponentialLinearMGF mu X K5 ->
              ∃ K2 : Real, 0 < K2 ∧ K2 <= C * K5 ∧
                SubExponentialProperty mu X .moment K2)) := by
  let C : Real :=
    1 + 512 * (Real.exp 1) ^ 3 + 4 * Real.exp 1 + 2 * Real.exp 1
  refine ⟨C, ?_, ?_⟩
  · dsimp [C]
    have hExp : 0 < Real.exp 1 := Real.exp_pos 1
    have hCube : 0 <= (Real.exp 1) ^ 3 := by positivity
    nlinarith
  · intro Omega _ mu _ X
    constructor
    · intro i j Ki hKi hProp
      obtain ⟨Kj, hKj, hKjBound, hResult⟩ :=
        subExponentialPropertyTransfer i j hKi hProp
      refine ⟨Kj, hKj, hKjBound.trans ?_, hResult⟩
      apply mul_le_mul_of_nonneg_right _ hKi.le
      dsimp [C]
      nlinarith [Real.exp_pos 1]
    · intro hCenter
      constructor
      · intro K2 hK2 hMoment
        change SubExponentialMomentBound mu X K2 at hMoment
        let K5 : Real := 4 * Real.exp 1 * K2
        refine ⟨K5, by dsimp [K5]; positivity, ?_, ?_⟩
        · apply mul_le_mul_of_nonneg_right _ hK2.le
          dsimp [K5, C]
          have hCube : 0 <= (Real.exp 1) ^ 3 := by positivity
          nlinarith [Real.exp_pos 1]
        · exact momentToLinearMGF hMoment.1 hK2 hCenter hMoment.2.2
      · intro K5 hK5 hLinear
        let K2 : Real := 2 * Real.exp 1 * K5
        have hMoment := subExponentialLinearMGF_to_moment hLinear
        refine ⟨K2, by dsimp [K2]; positivity, ?_, ?_⟩
        · apply mul_le_mul_of_nonneg_right _ hK5.le
          dsimp [K2, C]
          have hCube : 0 <= (Real.exp 1) ^ 3 := by positivity
          nlinarith [Real.exp_pos 1]
        · change SubExponentialMomentBound mu X K2
          exact ⟨hLinear.1, by dsimp [K2]; positivity, hMoment⟩

end NumStability.HDP.Scalar.SubExponential
