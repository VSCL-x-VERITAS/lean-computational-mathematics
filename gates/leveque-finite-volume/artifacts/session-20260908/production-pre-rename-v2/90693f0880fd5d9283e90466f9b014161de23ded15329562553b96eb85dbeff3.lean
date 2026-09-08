/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw.VariableCoefficient
import ComputationalMathematics.Source.LeVeque.Chapter01.ScalarHyperbolicity
import Mathlib.Analysis.Calculus.ContDiff.Operations
import Mathlib.Tactic.FunProp
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Positivity

/-!
# LeVeque Chapter 1, variable coefficients and conservation form

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,
printed page 8 (raw PDF page 30). A smooth positive scalar coefficient witnesses
failure of a local flux representation for the unchanged state variable.
-/

namespace NumStability

/-- A positive smooth pointwise hyperbolic scalar transport coefficient need
not admit any local flux for the unchanged density, even when that flux is
allowed to depend explicitly on position. This does not rule out changes of
density or integrating factors. -/
theorem leveque01_exists_hyperbolic_variableCoefficient_without_localFlux :
    ∃ coefficient : ℝ → ℝ,
      ContDiff ℝ (⊤ : ℕ∞) coefficient ∧
      (∀ x, 0 < coefficient x) ∧
      (∀ x, IsRealHyperbolicMatrix (constantCoefficientScalarMatrix (coefficient x))) ∧
      ¬ ∃ flux : ℝ → ℝ → ℝ, RepresentsScalarTransportFlux coefficient flux := by
  refine ⟨fun x => 1 + x ^ 2, by fun_prop, ?_, ?_, ?_⟩
  · intro x
    positivity
  · intro x
    exact leveque01_scalarEquation_isHyperbolic (1 + x ^ 2)
  · rintro ⟨flux, hflux⟩
    have h := hflux.coefficient_eq 0 1
    norm_num at h


end NumStability
