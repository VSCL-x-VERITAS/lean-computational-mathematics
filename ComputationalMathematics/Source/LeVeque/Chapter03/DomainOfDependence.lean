/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter03.CauchySolution

/-!
# Domain of dependence for a constant-coefficient hyperbolic system

Equation (3.14) and the following dependence assertion, printed page 51/raw
PDF page 73. The characteristic-foot set may contain fewer than `m` distinct
points if some speeds coincide.
-/

namespace NumStability

/-- Equation (3.14): the set of all characteristic feet at the initial line
that reach `(X,T)` along one of the `m` characteristic families. -/
def leveque03_domainOfDependence {m : ℕ} (speeds : Fin m → ℝ)
    (X T : ℝ) : Set ℝ :=
  Set.range (fun p => X - speeds p * T)

/-- The domain of dependence is finite because there are only `m` families. -/
theorem leveque03_domainOfDependence_finite {m : ℕ}
    (speeds : Fin m → ℝ) (X T : ℝ) :
    (leveque03_domainOfDependence speeds X T).Finite := by
  exact Set.finite_range _

/-- Agreement of two arbitrary initial profiles on the characteristic feet
forces their constructed solutions to agree at `(X,T)`. Values elsewhere
cannot affect that point. -/
theorem leveque03_initialDataSolution_dependsOnDomain {m : ℕ}
    (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ)
    (initialState₁ initialState₂ : ℝ → (Fin m → ℝ))
    (X T : ℝ)
    (hagree : ∀ x ∈ leveque03_domainOfDependence speeds X T,
      initialState₁ x = initialState₂ x) :
    leveque03_initialDataSolution eigenbasis speeds initialState₁ X T =
      leveque03_initialDataSolution eigenbasis speeds initialState₂ X T := by
  have hprofiles :
      (fun p => leveque03_initialCharacteristicVariables eigenbasis initialState₁
        (X - speeds p * T) p) =
      (fun p => leveque03_initialCharacteristicVariables eigenbasis initialState₂
        (X - speeds p * T) p) := by
    funext p
    simp only [leveque03_initialCharacteristicVariables,
      leveque03_characteristicVariables]
    rw [hagree (X - speeds p * T) ⟨p, rfl⟩]
  simpa only [leveque03_initialDataSolution] using
    congrArg (fun w => ((Pi.basisFun ℝ (Fin m)).toMatrix eigenbasis).mulVec w)
      hprofiles

end NumStability
