/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw.Hyperbolicity

/-!
# LeVeque Chapter 1, flux Jacobian hyperbolicity

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,
printed page 3 (raw PDF page 25).
-/

namespace NumStability

/-- The flux is hyperbolic at a state exactly when its actual Jacobian admits
a complete independent real eigenvector family. Repeated eigenvalues are allowed. -/
theorem leveque01_fluxJacobian_hyperbolicity_iff {m : ℕ}
    (flux : (Fin m → ℝ) → (Fin m → ℝ)) (state : Fin m → ℝ)
    (derivative : (Fin m → ℝ) →L[ℝ] (Fin m → ℝ))
    (hderivative : HasFDerivAt flux derivative state) :
    IsHyperbolicFluxAt flux state ↔
      ∃ (eigenvalues : Fin m → ℝ) (eigenvectors : Fin m → (Fin m → ℝ)),
        LinearIndependent ℝ eigenvectors ∧
          ∀ p, derivative (eigenvectors p) = eigenvalues p • eigenvectors p :=
  isHyperbolicFluxAt_iff_independent_real_eigenvectors flux state derivative hderivative

end NumStability
