import ComputationalMathematics.HDP.Metric.PackingFiniteWitnesses
import ComputationalMathematics.Source.Vershynin.Chapter04.Definition04.OwnerQualifiedPositiveTarget

/-!
# Definition 4.2.4 under the selected positive-radius ENat convention

The strict separation predicate and packing supremum agree with their explicit
forms. Finite packing values have largest finite witnesses, whereas infinity
means unbounded finite capacity and does not require an infinite optimizer.
-/

namespace NumStability.HDP.Contract

open Set
open scoped ENNReal NNReal

/-- Proof of the complete independently reviewed owner-qualified definition. -/
theorem definition424OwnerQualifiedPositiveTarget_proved :
    definition424OwnerQualifiedPositiveTarget := by
  intro T _ K ε _
  refine ⟨?_, rfl, ?_,
    NumStability.HDP.Metric.packingNumber_eq_top_iff_finite_witnesses K ε,
    _root_.Metric.packingNumber_empty ε, ?_⟩
  · intro N
    exact (hdp_04_hdef_h4_d2_d4 (K := K) (N := N) (ε := ε)).1
  · intro m hm
    constructor
    · obtain ⟨S, hSK, hfin, hsep, hcard⟩ :=
        _root_.Metric.exists_set_encard_eq_packingNumber (ε := ε) (A := K) (by simp [hm])
      exact ⟨S, hSK, hfin, hsep, hcard.trans hm⟩
    · intro Q hQK hsep
      have hcard : Q.encard ≤ (m : ℕ∞) := by
        simpa only [hm] using hsep.encard_le_packingNumber hQK
      exact ⟨Set.finite_of_encard_le_coe hcard, hcard⟩
  · intro hK
    exact ENat.one_le_iff_ne_zero.mpr
      (ne_of_gt (_root_.Metric.packingNumber_pos_iff.mpr hK))

end NumStability.HDP.Contract
