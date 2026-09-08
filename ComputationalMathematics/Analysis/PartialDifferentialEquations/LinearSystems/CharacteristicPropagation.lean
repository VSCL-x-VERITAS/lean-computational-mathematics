/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.ClassicalCharacteristics
import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearSystems.EigenbasisCoordinates

/-!
# Propagation of the components of a linear hyperbolic system

An independently supplied jointly differentiable system solution has each
eigenbasis coordinate transported at its eigenvalue. Summing the coordinates
reconstructs the entire state.
-/

namespace NumStability

theorem constantCoefficientSystem_characteristicPropagation {m : ℕ}
    (A : Matrix (Fin m) (Fin m) ℝ) (b : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ) (heigen : ∀ i, A.mulVec (b i) = speeds i • b i)
    (q : ℝ → ℝ → (Fin m → ℝ))
    (hq : Differentiable ℝ (Function.uncurry q))
    (hpde : ∀ x t, IsConstantCoefficientLinearSystemSolutionAt q A x t) :
    (∀ i x t, b.equivFun (q x t) i =
      b.equivFun (q (x - speeds i * t) 0) i) ∧
    ∀ x t, q x t =
      ∑ i, (b.equivFun (q (x - speeds i * t) 0) i) • b i := by
  have hcoordinates (i : Fin m) (x t : ℝ) :
      b.equivFun (q x t) i = b.equivFun (q (x - speeds i * t) 0) i := by
    let L : (Fin m → ℝ) →L[ℝ] ℝ :=
      (ContinuousLinearMap.proj (R := ℝ) i).comp
        b.equivFun.toContinuousLinearEquiv.toContinuousLinearMap
    have hcoord : Differentiable ℝ
        (Function.uncurry (fun ξ τ => b.equivFun (q ξ τ) i)) := by
      exact L.differentiable.comp hq
    have heq := linearAdvection_eq_travelingWave_of_differentiable hcoord
      (fun ξ τ => (constantCoefficientSystem_iff_eigenbasisAdvection
        A b speeds heigen q ξ τ).mp (hpde ξ τ) i)
    exact congrFun (congrFun heq x) t
  refine ⟨hcoordinates, ?_⟩
  intro x t
  rw [← b.sum_equivFun (q x t)]
  apply Finset.sum_congr rfl
  intro i _
  rw [hcoordinates i x t]

end NumStability
