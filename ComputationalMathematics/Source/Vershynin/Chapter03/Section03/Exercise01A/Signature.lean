import ComputationalMathematics.HDP.Vector.Spherical

/-! Frozen contract signature for the isotropy assertion in Exercise 3.3.1. -/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_ex_3_3_1a__contract_type : Prop :=
  ∀ {n : ℕ} {Ω : Type*} [MeasurableSpace Ω]
      (μ : Measure Ω) (X : Fin n → Ω → ℝ),
    0 < n →
      HasLaw (fun ω i => X i ω)
        (Measure.map
          (fun x : Metric.sphere
              (0 : EuclideanSpace ℝ (Fin n)) 1 =>
            Real.sqrt n •
              WithLp.ofLp (x : EuclideanSpace ℝ (Fin n)))
          (ProbabilityTheory.cond
            (Measure.toSphere
              (volume : Measure (EuclideanSpace ℝ (Fin n))))
            Set.univ)) μ →
      NumStability.HDP.Vector.Isotropy.IsIsotropic μ X

end NumStability.HDP.Contract
