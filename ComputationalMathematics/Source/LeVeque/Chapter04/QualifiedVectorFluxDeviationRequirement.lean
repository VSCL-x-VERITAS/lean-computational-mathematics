/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.FluxLipschitzCondition
import Mathlib.Analysis.Normed.Group.Constructions

/-!
# Vector flux deviation requirements

The displayed right-then-left maximum controls one finite-dimensional vector
triple for its supplied real coefficient. The local characterization permits
the coefficient and neighborhood to depend on the fixed reference state.
Neither arbitrary-flux existence nor a global uniform coefficient is inferred.
Constant physical and numerical fluxes give a nonvacuous local instance.
-/

namespace NumStability
noncomputable section

def leveque04_vectorFluxDeviationRequirementS06 {m : ℕ}
    (physicalFlux : (Fin m → ℝ) → Fin m → ℝ)
    (numericalFlux : (Fin m → ℝ) → (Fin m → ℝ) → Fin m → ℝ)
    (L : ℝ) (reference left right : Fin m → ℝ) : Prop :=
  ‖numericalFlux left right - physicalFlux reference‖ ≤
    L * max ‖right-reference‖ ‖left-reference‖

def Leveque04Equation15VectorRequirementDefinitionTargetS06 : Prop :=
  ∀ m : ℕ, 0 < m →
    (∀ (physicalFlux : (Fin m → ℝ) → Fin m → ℝ)
      (numericalFlux : (Fin m → ℝ) → (Fin m → ℝ) → Fin m → ℝ),
      (∀ (L : ℝ) (reference left right : Fin m → ℝ),
        leveque04_vectorFluxDeviationRequirementS06 physicalFlux numericalFlux
            L reference left right ↔
          ‖numericalFlux left right - physicalFlux reference‖ ≤
            L * max ‖right-reference‖ ‖left-reference‖) ∧
      (∀ reference : Fin m → ℝ,
        IsLeveque04FluxLipschitzAt physicalFlux numericalFlux reference ↔
          ∃ L radius : ℝ, 0 ≤ L ∧ 0 < radius ∧
            ∀ left right : Fin m → ℝ,
              ‖left-reference‖ < radius → ‖right-reference‖ < radius →
              leveque04_vectorFluxDeviationRequirementS06 physicalFlux numericalFlux
                L reference left right) ∧
      (IsLeveque04LocallyLipschitzFlux physicalFlux numericalFlux ↔
        ∀ reference : Fin m → ℝ, ∃ L radius : ℝ, 0 ≤ L ∧ 0 < radius ∧
          ∀ left right : Fin m → ℝ,
            ‖left-reference‖ < radius → ‖right-reference‖ < radius →
            leveque04_vectorFluxDeviationRequirementS06 physicalFlux numericalFlux
              L reference left right)) ∧
    (∀ constant : Fin m → ℝ,
      IsLeveque04LocallyLipschitzFlux (fun _ => constant) (fun _ _ => constant))

theorem leveque04Equation15VectorRequirementDefinition_exact_b786_s06 :
    Leveque04Equation15VectorRequirementDefinitionTargetS06 := by
  intro m _hm
  constructor
  · intro physicalFlux numericalFlux
    refine ⟨?_,?_,?_⟩
    · intro L reference left right
      rfl
    · intro reference
      simp only [IsLeveque04FluxLipschitzAt,leveque04_vectorFluxDeviationRequirementS06,max_comm]
    · simp only [IsLeveque04LocallyLipschitzFlux,IsLeveque04FluxLipschitzAt,
        leveque04_vectorFluxDeviationRequirementS06,max_comm]
  · intro constant reference
    refine ⟨0,1,le_rfl,zero_lt_one,?_⟩
    intro left right _hleft _hright
    simp

end
end NumStability
