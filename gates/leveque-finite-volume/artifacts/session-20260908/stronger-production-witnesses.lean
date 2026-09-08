import ComputationalMathematics.Source.LeVeque.Chapter01.LinearRiemannEigensolution
import ComputationalMathematics.Source.LeVeque.Chapter01.NonlinearShockFormation
import ComputationalMathematics.Source.LeVeque.Chapter01.ScalarHyperbolicity

open MeasureTheory Set Filter
open scoped Topology

namespace NumStability.Chapter01Evidence

/-- A nonempty scalar hyperbolic system with unequal initial states instantiates
the entire audited spectral conclusion, including every real temporal endpoint. -/
theorem linearRiemann_nonvacuous_instance :
    ∃ (eigenvalues : Fin 1 → ℝ) (eigenbasis : Module.Basis (Fin 1) ℝ (Fin 1 → ℝ)),
      (∀ p, (constantCoefficientScalarMatrix 1).mulVec (eigenbasis p) =
        eigenvalues p • eigenbasis p) ∧
      IsRectangleConservationLawSolution
        (linearRiemannSolution eigenbasis eigenvalues 0 3 1)
        (constantCoefficientScalarMatrix 1).mulVec ∧
      (∀ x, linearRiemannSolution eigenbasis eigenvalues 0 3 1 x 0 =
        riemannData 0 3 1 x) ∧
      (∀ x t, 0 < t →
        linearRiemannSolution eigenbasis eigenvalues 0 3 1 x t =
        linearRiemannSolution eigenbasis eigenvalues 0 3 1 (x / t) 1) :=
  leveque01_linearRiemann_eigensolution (leveque01_scalarEquation_isHyperbolic 1) 0 3 1

/-- The explicit flux and state jointly realize the audited existence claim;
there is no extra premise whose inconsistency could trivialize it. -/
theorem huberShock_nonvacuous_instance :
    ContDiff ℝ 1 huberFlux ∧
    (¬ ∃ a b : ℝ, ∀ u, huberFlux u = a * u + b) ∧
    IsRectangleConservationLawSolution HuberShock.shockState huberFlux ∧
    ContDiff ℝ ⊤ (fun x => HuberShock.shockState x 0) ∧
    (∀ t, 0 ≤ t → t < 1 → Continuous (fun x => HuberShock.shockState x t)) ∧
    Tendsto (fun x => HuberShock.shockState x 1) (𝓝[<] 0) (𝓝 1) ∧
    Tendsto (fun x => HuberShock.shockState x 1) (𝓝[>] 0) (𝓝 (-1)) := by
  exact ⟨huberFlux_contDiff_one, huberFlux_not_affine,
    HuberShock.shockState_isRectangleConservationLawSolution,
    HuberShock.shockState_initial_smooth,
    fun _ _ ht => HuberShock.shockState_continuous_before ht,
    HuberShock.shockState_jump_traces (by norm_num)⟩

end NumStability.Chapter01Evidence

#check NumStability.leveque01_linearRiemann_eigensolution
#print axioms NumStability.leveque01_linearRiemann_eigensolution
#check NumStability.leveque01_nonlinear_shock_formation
#print axioms NumStability.leveque01_nonlinear_shock_formation
#check NumStability.Chapter01Evidence.linearRiemann_nonvacuous_instance
#print axioms NumStability.Chapter01Evidence.linearRiemann_nonvacuous_instance
#check NumStability.Chapter01Evidence.huberShock_nonvacuous_instance
#print axioms NumStability.Chapter01Evidence.huberShock_nonvacuous_instance
