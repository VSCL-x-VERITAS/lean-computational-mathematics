import ComputationalMathematics.Source.Vershynin.Chapter04.Lemma08.OwnerQualifiedNumericalTarget

/-!
# Lemma 4.2.8: numerical covering and packing comparison

The unrestricted ENat comparison composes Mathlib's packing-to-exterior-cover
bound with the exterior-to-internal-cover bound, and its converse comparison.
-/

noncomputable section

universe u

namespace NumStability.HDP.Contract

/-- Both inequalities of the complete owner-qualified positive-radius lemma. -/
theorem hdp_04_lemma_4_2_8_owner_qualified_numerical_proved :
    hdp_04_lemma_4_2_8_owner_qualified_numerical.{u} := by
  intro T _ K ε _hε
  exact ⟨(Metric.packingNumber_two_mul_le_externalCoveringNumber ε K).trans
    (Metric.externalCoveringNumber_le_coveringNumber ε K),
    Metric.coveringNumber_le_packingNumber ε K⟩

end NumStability.HDP.Contract
