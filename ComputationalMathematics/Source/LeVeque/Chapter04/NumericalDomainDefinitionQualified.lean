/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.NumericalDomainDefinitionQualifiedTarget
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.EssentialPointDomains

/-!
# The owner-qualified numerical-domain definition

The fixed-class, fixed-observation neighborhood convention is the supplied
qualification of the printed informal definition. The four explanatory
consequences reuse generic essential-point domain results. No structural,
refinement-limit, convergence or implicit-domain assertion is made.
-/

namespace NumStability

theorem leveque04_numericalDomainDefinitionQualified :
    Leveque04NumericalDomainDefinitionQualifiedTarget := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩
  · intro State admissible initialization update steps observe point
    rfl
  · intro m _ State admissible initialization update steps observe point
    rfl
  · intro E V admissible left right heq
    exact essentialPointDomain_eq_of_eq_on_class admissible left right heq
  · intro E V admissible value
    exact essentialPointDomain_const admissible value
  · intro point
    exact essentialPointDomain_continuous_evaluation (V := ℝ) point
  · intro m _ point
    exact essentialPointDomain_continuous_evaluation (V := Fin m → ℝ) point

end NumStability
