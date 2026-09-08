/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearSystems.CharacteristicPropagation

/-!
# LeVeque Chapter 1, complete component-wave propagation

LeVeque, printed page 3 (raw PDF page 25), relates each eigenvalue to the
propagation speed of the corresponding eigenbasis component. A complete basis
and nonzero eigenvectors are explicit. The characteristic-evolution conclusion
uses joint differentiability of the supplied field.

This correspondence preserves the original printed ambiguity and is subject
to independent statement auditing; proof compilation alone is not acceptance.
-/

namespace NumStability

theorem leveque01_eigenvalues_completeWavePropagation {m : ℕ}
    (A : Matrix (Fin m) (Fin m) ℝ) (hA : IsRealHyperbolicMatrix A) :
    ∃ (speeds : Fin m → ℝ) (b : Module.Basis (Fin m) ℝ (Fin m → ℝ)),
      (∀ i, b i ≠ 0 ∧ A.mulVec (b i) = speeds i • b i) ∧
      (∀ (q : ℝ → ℝ → (Fin m → ℝ)) (x t : ℝ),
        IsConstantCoefficientLinearSystemSolutionAt q A x t ↔
          ∀ i, IsLinearAdvectionSolutionAt
            (fun ξ τ => b.equivFun (q ξ τ) i) (speeds i) x t) ∧
      ∀ (q : ℝ → ℝ → (Fin m → ℝ)),
        Differentiable ℝ (Function.uncurry q) →
        (∀ x t, IsConstantCoefficientLinearSystemSolutionAt q A x t) →
        (∀ i x t, b.equivFun (q x t) i =
          b.equivFun (q (x - speeds i * t) 0) i) ∧
        ∀ x t, q x t =
          ∑ i, (b.equivFun (q (x - speeds i * t) 0) i) • b i := by
  obtain ⟨speeds, b, heigen⟩ := hA
  refine ⟨speeds, b, fun i => ⟨b.ne_zero i, heigen i⟩,
    constantCoefficientSystem_iff_eigenbasisAdvection A b speeds heigen, ?_⟩
  exact constantCoefficientSystem_characteristicPropagation A b speeds heigen

end NumStability
