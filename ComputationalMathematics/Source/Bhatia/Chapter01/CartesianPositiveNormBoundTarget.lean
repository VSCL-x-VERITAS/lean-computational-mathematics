/-
Scratch proposal for I.6.18.bound only. Not compiled, frozen, audited, or accepted.
No theorem proof is supplied. All mathematical choices remain reviewable.
-/
import Mathlib.Analysis.InnerProductSpace.Adjoint
import Mathlib.Analysis.InnerProductSpace.Positive
import Mathlib.Analysis.Normed.Module.FiniteDimension

set_option autoImplicit false
noncomputable section
universe u

namespace NumStability.Bhatia.Chapter01.Targets

/-- Proposed universal bound for the actual Cartesian parts of T.
All norms below are norms of continuous linear maps, hence operator norms.
No nontriviality or positive-dimension premise is imposed. -/
def cartesianPositiveNormBoundProposed : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (T : H →ₗ[ℂ] H),
    let A : H →ₗ[ℂ] H := (2 : ℂ)⁻¹ • (T + LinearMap.adjoint T)
    let B : H →ₗ[ℂ] H := (2 * Complex.I)⁻¹ • (T - LinearMap.adjoint T)
    A.IsPositive → B.IsPositive →
      ‖T.toContinuousLinearMap‖ ^ 2 ≤
        ‖A.toContinuousLinearMap‖ ^ 2 + ‖B.toContinuousLinearMap‖ ^ 2

end NumStability.Bhatia.Chapter01.Targets
