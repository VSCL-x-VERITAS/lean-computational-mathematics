import ComputationalMathematics.Source.Vershynin.Chapter03.Section03.Exercise01B.Signature

/-! Source-facing contract for the non-independence assertion in Exercise 3.3.1. -/

noncomputable section

namespace NumStability.HDP.Contract

/-- Exercise 3.3.1, printed page 49, with its necessary effective-domain
condition made explicit: in dimension at least two, the coordinates of a
spherically distributed vector are not mutually independent. -/
theorem hdp_03_ex_3_3_1b : hdp_03_ex_3_3_1b__contract_type := by
  intro n Ω _ μ X hn hX
  exact NumStability.HDP.Vector.Spherical.not_iIndepFun_of_hasSphericalLaw hn hX

/-- The omitted dimension condition is necessary: in dimension one the
singleton coordinate family is independent. -/
theorem hdp_03_ex_3_3_1b_dimension_one_obstruction :
    hdp_03_ex_3_3_1b_dimension_one_obstruction__contract_type :=
  NumStability.HDP.Vector.Spherical.one_dimensional_coordinates_independent

set_option linter.style.nameCheck false in
theorem hdp_03_ex_3_3_1b__contract : hdp_03_ex_3_3_1b__contract_type :=
  hdp_03_ex_3_3_1b

end NumStability.HDP.Contract
