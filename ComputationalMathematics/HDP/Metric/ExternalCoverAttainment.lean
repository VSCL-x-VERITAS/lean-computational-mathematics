import Mathlib.Topology.MetricSpace.CoveringNumbers

/-! # Finite external-cover attainment

A finite external covering number is attained by a finite ambient cover.
The statement applies to every radius in a pseudoemetric space.
-/

open scoped ENNReal NNReal

namespace NumStability.HDP.Metric

/-- A finite external covering number is attained by a finite cover with centers
in the ambient space, for every radius in a pseudoemetric space. -/
theorem exists_set_encard_eq_externalCoveringNumber
    {T : Type*} [PseudoEMetricSpace T] {K : Set T} {ε : ℝ≥0}
    (h : Metric.externalCoveringNumber ε K ≠ ⊤) :
    ∃ C : Set T, C.Finite ∧ Metric.IsCover ε K C ∧
      C.encard = Metric.externalCoveringNumber ε K := by
  have hfinite := h
  simp only [Metric.externalCoveringNumber, ne_eq, iInf_eq_top,
    Set.encard_eq_top_iff, not_forall, Set.not_infinite] at hfinite
  obtain ⟨C', hC'cover, _hC'fin⟩ := hfinite
  have : Nonempty {s : Set T // Metric.IsCover ε K s} := ⟨⟨C', hC'cover⟩⟩
  obtain ⟨C, hC⟩ :=
    ENat.exists_eq_iInf (fun C : {s : Set T // Metric.IsCover ε K s} =>
      (C : Set T).encard)
  have hcard : (C : Set T).encard = Metric.externalCoveringNumber ε K := by
    rw [hC]
    simp_rw [iInf_subtype]
    rfl
  refine ⟨C, Set.encard_ne_top_iff.mp ?_, C.2, hcard⟩
  rw [hcard]
  exact h

end NumStability.HDP.Metric
