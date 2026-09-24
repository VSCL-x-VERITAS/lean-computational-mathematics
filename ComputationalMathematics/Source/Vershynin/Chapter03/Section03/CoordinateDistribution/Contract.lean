import ComputationalMathematics.Source.Vershynin.Chapter03.Section03.CoordinateDistribution.Signature

/-! Source-facing contract for the coordinate-distribution definition in Section 3.3.4. -/

noncomputable section

namespace NumStability.HDP.Contract

/-- Section 3.3.4, printed page 52: the coordinate distribution chooses
uniformly among the vectors `√n eᵢ`.  The canonical witness chooses the index
itself from the uniform law on `Fin n`. -/
theorem hdp_03_body_3_3_coordinate_distribution :
    hdp_03_body_3_3_coordinate_distribution__contract_type := by
  intro n _
  refine ⟨(measurable_of_countable _).aemeasurable, ?_⟩
  rfl

set_option linter.style.nameCheck false in
theorem hdp_03_body_3_3_coordinate_distribution__contract :
    hdp_03_body_3_3_coordinate_distribution__contract_type :=
  hdp_03_body_3_3_coordinate_distribution

end NumStability.HDP.Contract
