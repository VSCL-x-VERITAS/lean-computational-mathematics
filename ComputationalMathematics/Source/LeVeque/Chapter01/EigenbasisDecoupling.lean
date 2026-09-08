/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearSystems.EigenbasisCoordinates

/-!
# LeVeque Chapter 1, decomposition into scalar wave equations

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,
printed page 3 (raw PDF page 25). A single real eigenbasis supplies all scalar equations.
-/

namespace NumStability

/-- General scalar-equation decomposition on printed page 3.
One eigenbasis is fixed for all fields and all points; the equivalence includes
the reverse reconstruction of a system solution from its scalar equations. -/
theorem leveque01_hyperbolicSystem_scalarWaveDecomposition {m : ℕ}
    (A : Matrix (Fin m) (Fin m) ℝ) (hA : IsRealHyperbolicMatrix A) :
    ∃ (speeds : Fin m → ℝ) (b : Module.Basis (Fin m) ℝ (Fin m → ℝ)),
      (∀ i, A.mulVec (b i) = speeds i • b i) ∧
      ∀ (q : ℝ → ℝ → (Fin m → ℝ)) (x t : ℝ),
        IsConstantCoefficientLinearSystemSolutionAt q A x t ↔
          ∀ i, IsLinearAdvectionSolutionAt
            (fun ξ τ => b.equivFun (q ξ τ) i) (speeds i) x t := by
  rcases hA with ⟨speeds, b, heigen⟩
  exact ⟨speeds, b, heigen, constantCoefficientSystem_iff_eigenbasisAdvection A b speeds heigen⟩


end NumStability
