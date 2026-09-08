import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvectionGlobal
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Rectangle
import ComputationalMathematics.Source.LeVeque.Chapter01.Equation02
import ComputationalMathematics.Source.LeVeque.Chapter01.ScalarHyperbolicity

open MeasureTheory

namespace NumStability

/-- Uniform advection means that the field value is unchanged along each
material trajectory with the specified constant velocity. -/
def IsUniformAdvection {E : Type*} (q : ℝ → ℝ → E) (speed : ℝ) : Prop :=
  ∀ x t, q (x + speed * t) t = q x 0

/-- The kinematic transport condition determines the field from its initial profile. -/
theorem isUniformAdvection_iff_eq_travelingWave {E : Type*}
    (q : ℝ → ℝ → E) (speed : ℝ) :
    IsUniformAdvection q speed ↔ q = travelingWave (fun x => q x 0) speed := by
  constructor
  · intro h
    funext x t
    have hvalue := h (x - speed * t) t
    simpa only [sub_add_cancel, travelingWave] using hvalue
  · intro h x t
    conv_lhs => rw [h]
    rw [travelingWave_at_translated_point]

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]

/-- Uniformly transported differentiable initial data satisfy the classical PDE. -/
theorem IsUniformAdvection.isLinearAdvectionSolution
    {q : ℝ → ℝ → E} {speed : ℝ} (h : IsUniformAdvection q speed)
    (hdiff : Differentiable ℝ (fun x => q x 0)) :
    IsLinearAdvectionSolution q speed := by
  have heq := (isUniformAdvection_iff_eq_travelingWave q speed).mp h
  exact Eq.mpr (congrArg (fun field => IsLinearAdvectionSolution field speed) heq)
    (travelingWave_isLinearAdvectionSolution speed hdiff)

/-- Uniformly transported interval-integrable initial data satisfy rectangle conservation. -/
theorem IsUniformAdvection.isRectangleConservationLawSolution
    {q : ℝ → ℝ → E} {speed : ℝ} (h : IsUniformAdvection q speed)
    (hintegrable : ∀ a b, IntervalIntegrable (fun x => q x 0) volume a b) :
    IsRectangleConservationLawSolution q (fun state => speed • state) := by
  have heq := (isUniformAdvection_iff_eq_travelingWave q speed).mp h
  exact Eq.mpr
    (congrArg (fun field => IsRectangleConservationLawSolution field
      (fun state => speed • state)) heq)
    (travelingWave_isRectangleConservationLawSolution (fun x => q x 0) hintegrable speed)

/-- Real-scalar hyperbolicity, scalar specialization, and actual solution
satisfaction for fields carried unchanged by a constant-velocity flow. -/
theorem leveque01_equation02_uniformTransportModel (speed : ℝ) :
    IsRealHyperbolicMatrix (constantCoefficientScalarMatrix speed) ∧
    (∀ q x t, leveque01_equation01_constantLinearSystemAt
        (scalarAsOneComponentSystem q) (constantCoefficientScalarMatrix speed) x t ↔
      leveque01_equation02_scalarAdvectionAt q speed x t) ∧
    ∀ q : ℝ → ℝ → ℝ, IsUniformAdvection q speed →
      (Differentiable ℝ (fun x => q x 0) → IsLinearAdvectionSolution q speed) ∧
      ((∀ a b, IntervalIntegrable (fun x => q x 0) volume a b) →
        IsRectangleConservationLawSolution q (fun state => speed * state)) := by
  refine ⟨leveque01_scalarEquation_isHyperbolic speed,
    fun q x t => leveque01_equation02_isOneDimensionalSpecialization q speed x t, ?_⟩
  intro q h
  exact ⟨h.isLinearAdvectionSolution, h.isRectangleConservationLawSolution⟩

end NumStability

#check NumStability.IsUniformAdvection
#print axioms NumStability.IsUniformAdvection
#check NumStability.isUniformAdvection_iff_eq_travelingWave
#print axioms NumStability.isUniformAdvection_iff_eq_travelingWave
#check NumStability.IsUniformAdvection.isLinearAdvectionSolution
#print axioms NumStability.IsUniformAdvection.isLinearAdvectionSolution
#check NumStability.IsUniformAdvection.isRectangleConservationLawSolution
#print axioms NumStability.IsUniformAdvection.isRectangleConservationLawSolution
#check NumStability.leveque01_equation02_uniformTransportModel
#print axioms NumStability.leveque01_equation02_uniformTransportModel
