import ComputationalMathematics.HDP.Scalar.SubExponentialCharacterization

/-!
# The property-(c) sub-exponential gauge

The prose of Definition 2.7.5 calls the sub-exponential norm the smallest
parameter in property (c), while display (2.21) uses property (d).  This module
keeps the property-(c) infimum as a separate reusable gauge so both immutable
source statements can be represented without identifying quantitatively
different parameters.
-/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Scalar.SubExponential

/-- A finite positive extended-real scale whose real value satisfies property
(c) of Proposition 2.7.1. -/
def PsiOnePropertyThreeAdmissible {Omega : Type*} [MeasurableSpace Omega]
    (mu : Measure Omega) (X : Omega -> Real) (t : ENNReal) : Prop :=
  t ≠ 0 ∧ t ≠ ⊤ ∧ SubExponentialAbsoluteMGFLocal mu X t.toReal

/-- The literal property-(c) infimum named in the prose of Definition 2.7.5. -/
noncomputable def PsiOnePropertyThreeGauge
    {Omega : Type*} [MeasurableSpace Omega]
    (mu : Measure Omega) (X : Omega -> Real) : ENNReal :=
  sInf {t : ENNReal | PsiOnePropertyThreeAdmissible mu X t}

/-- At a positive real scale, property-three admissibility is exactly property
(c) itself. -/
theorem psiOnePropertyThreeAdmissible_ofReal_iff
    {Omega : Type*} [MeasurableSpace Omega]
    {mu : Measure Omega} {X : Omega -> Real} {K : Real} (hK : 0 < K) :
    PsiOnePropertyThreeAdmissible mu X (ENNReal.ofReal K) ↔
      SubExponentialAbsoluteMGFLocal mu X K := by
  unfold PsiOnePropertyThreeAdmissible
  simp [ENNReal.toReal_ofReal hK.le, hK]

/-- The property-(c) gauge is finite exactly when property (c) holds at some
positive real scale. -/
theorem psiOnePropertyThreeGauge_finite_iff
    {Omega : Type*} [MeasurableSpace Omega]
    {mu : Measure Omega} {X : Omega -> Real} :
    PsiOnePropertyThreeGauge mu X < (⊤ : ENNReal) ↔
      ∃ K : Real, 0 < K ∧ SubExponentialAbsoluteMGFLocal mu X K := by
  constructor
  · intro hGauge
    by_cases hNonempty :
        Set.Nonempty {t : ENNReal | PsiOnePropertyThreeAdmissible mu X t}
    · rcases hNonempty with ⟨t, ht0, htTop, hProperty⟩
      have htPos : 0 < t.toReal := ENNReal.toReal_pos ht0 htTop
      exact ⟨t.toReal, htPos, hProperty⟩
    · have hEmpty : {t : ENNReal | PsiOnePropertyThreeAdmissible mu X t} = ∅ :=
        Set.not_nonempty_iff_eq_empty.mp hNonempty
      rw [PsiOnePropertyThreeGauge, hEmpty] at hGauge
      simp at hGauge
  · rintro ⟨K, hK, hProperty⟩
    calc
      PsiOnePropertyThreeGauge mu X ≤ ENNReal.ofReal K := by
        apply sInf_le
        exact (psiOnePropertyThreeAdmissible_ofReal_iff hK).2 hProperty
      _ < (⊤ : ENNReal) := ENNReal.ofReal_lt_top

end NumStability.HDP.Scalar.SubExponential
