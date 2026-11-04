/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalMeshConvergenceCriteria

/-!
# Real norm qualifications on physical meshes

A prescribed real grid norm is represented by a real normed error space and an
injective real-linear map to the actual grid differences. The linear structure
retains real homogeneity, which an additive-group norm alone need not satisfy.
The physical geometry and refinement conditions are the existing ones.
-/

noncomputable section

namespace NumStability

open Filter MeasureTheory Set
open scoped Topology ENNReal

variable {A E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]

/-- Convergence in a prescribed real grid norm on an actual physical mesh.
The representation is fixed before qualification and its represented error is
the numerical-reference difference, extended by zero at inactive cells. -/
def HasPhysicalRealNormConvergence (l : Filter A) (domain : Set ℝ)
    (active : A → Set ℤ) (edge : A → ℤ → ℝ) (dx dt : A → ℝ)
    (time : A → ℕ → ℝ) (steps : A → ℕ) (Q : A → ℕ → ℤ → E)
    (reference : A → ℤ → E)
    (X : A → Type*) [∀ a, NormedAddCommGroup (X a)]
    [∀ a, NormedSpace ℝ (X a)]
    (representation : ∀ a, X a →ₗ[ℝ] (ℤ → E)) (T : ℝ) : Prop :=
  HasPhysicalChosenNormConvergence l domain active edge dx dt time steps Q
    reference X (fun a => (representation a).toAddMonoidHom) T

end NumStability
