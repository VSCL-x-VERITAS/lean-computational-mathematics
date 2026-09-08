import ComputationalMathematics.Source.LeVeque.Chapter01.ScalarHyperbolicity
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Tactic.NormNum

/-!
Scratch witness for the variable-coefficient conservation-form caveat on
LeVeque printed 8/raw 30. The chosen coefficient is a constructed witness,
not an example printed in the selected paragraph. This is not a closed row.
-/

namespace NumStability

/-- A state-only scalar flux represents a spatially varying transport
coefficient when its derivative at every independently supplied state agrees
with that coefficient at every spatial point. This keeps the dependent
quantity fixed; it allows no change of unknown or explicitly spatial flux. -/
def HasStateOnlyScalarFlux (coefficient : ℝ → ℝ) : Prop :=
  ∃ flux : ℝ → ℝ, ∀ x state : ℝ, HasDerivAt flux (coefficient x) state

/-- One derivative at a fixed state cannot represent two distinct spatial
coefficients. -/
theorem HasStateOnlyScalarFlux.coefficient_eq
    {coefficient : ℝ → ℝ} (hflux : HasStateOnlyScalarFlux coefficient)
    (x y : ℝ) : coefficient x = coefficient y := by
  rcases hflux with ⟨flux, hderiv⟩
  exact (hderiv x 0).unique (hderiv y 0)

/-- A real scalar coefficient can be hyperbolic at every spatial point
without admitting a flux depending only on the unchanged scalar state. -/
theorem leveque01_variableCoefficient_stateOnlyFluxObstruction :
    ∃ coefficient : ℝ → ℝ,
      (∀ x, leveque01IsHyperbolicMatrix
        (constantCoefficientScalarMatrix (coefficient x))) ∧
      ¬ HasStateOnlyScalarFlux coefficient := by
  refine ⟨id, fun x => leveque01_scalarEquation_isHyperbolic x, ?_⟩
  intro hflux
  have hzero_one : (0 : ℝ) = 1 := hflux.coefficient_eq 0 1
  exact zero_ne_one hzero_one

#check HasDerivAt.unique
#print axioms leveque01_variableCoefficient_stateOnlyFluxObstruction

end NumStability
