import ComputationalMathematics.Source.Vershynin.Chapter03.Section04.Exercise04.Signature

/-! Exercise 3.4.4: `ψ₂` norm of the coordinate distribution. -/

noncomputable section

namespace NumStability.HDP.Contract

/-- The coordinate distribution has vector `ψ₂` norm comparable to
`sqrt (n / log n)` with dimension-free positive constants. -/
theorem hdp_03_ex_3_4_4 : hdp_03_ex_3_4_4__contract_type := by
  refine ⟨1 / Real.sqrt 2, 1, by positivity, by positivity, ?_⟩
  intro n _ hn
  rw [NumStability.HDP.Vector.CoordinateDistribution.coordinateDistribution_psiTwoNorm_exact]
  have hcomp :=
    NumStability.HDP.Vector.CoordinateDistribution.coordinatePsiTwoScale_comparable hn
  constructor
  · exact ENNReal.ofReal_mono hcomp.1
  · simpa using ENNReal.ofReal_mono hcomp.2

set_option linter.style.nameCheck false in
theorem hdp_03_ex_3_4_4__contract : hdp_03_ex_3_4_4__contract_type :=
  hdp_03_ex_3_4_4

end NumStability.HDP.Contract
