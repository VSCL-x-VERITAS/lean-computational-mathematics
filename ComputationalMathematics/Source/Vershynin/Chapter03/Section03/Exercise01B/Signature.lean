import ComputationalMathematics.HDP.Vector.Spherical

/-! Frozen contract signature for the non-independence assertion in Exercise 3.3.1. -/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_ex_3_3_1b__contract_type : Prop :=
  ∀ {n : ℕ} {Ω : Type*} [MeasurableSpace Ω]
      (μ : Measure Ω) (X : Fin n → Ω → ℝ),
    2 ≤ n →
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
      ¬ iIndepFun X μ

set_option linter.style.nameCheck false in
def hdp_03_ex_3_3_1b_dimension_one_obstruction__contract_type : Prop :=
  iIndepFun (fun i : Fin 1 => fun x : Fin 1 → ℝ => x i)
    (NumStability.HDP.Vector.Spherical.sphericalVectorMeasure 1)

end NumStability.HDP.Contract
