import ComputationalMathematics.HDP.Scalar.LimitTheorems

/-!
Cross-split stable API for `HDP-01-DEF-STANDARD-NORMAL`.

The semantic producer owns the canonical Gaussian law and the random-variable
predicate; this leaf owns only the stable source-facing law name.
-/

namespace NumStability.HDP.Contract

open MeasureTheory

/-- The standard normal probability law from Chapter 1, equation (1.6). -/
noncomputable def hdp_01_hdef_hstandard_hnormal : Measure ℝ :=
  NumStability.HDP.Scalar.LimitTheorems.standardNormalLaw

/-- The standard normal law bundled as a probability measure for weak/CDF limits. -/
noncomputable def hdp_01_hdef_hstandard_hnormal_probability :
    ProbabilityMeasure ℝ :=
  ⟨hdp_01_hdef_hstandard_hnormal, by
    dsimp [hdp_01_hdef_hstandard_hnormal]
    infer_instance⟩

/-- Equation (1.6): the density of the standard normal law. -/
theorem hdp_01_heq_h1_d6 :
    hdp_01_hdef_hstandard_hnormal =
        volume.withDensity (ProbabilityTheory.gaussianPDF 0 1) ∧
      ProbabilityTheory.gaussianPDFReal 0 1 =
        fun x : ℝ => (Real.sqrt (2 * Real.pi))⁻¹ * Real.exp (-(x ^ 2) / 2) := by
  constructor
  · simpa [hdp_01_hdef_hstandard_hnormal,
      NumStability.HDP.Scalar.LimitTheorems.standardNormalLaw] using
      (ProbabilityTheory.gaussianReal_of_var_ne_zero 0
        (v := (1 : NNReal)) one_ne_zero)
  · exact NumStability.HDP.Scalar.LimitTheorems.standardNormalLaw_pdf

end NumStability.HDP.Contract
