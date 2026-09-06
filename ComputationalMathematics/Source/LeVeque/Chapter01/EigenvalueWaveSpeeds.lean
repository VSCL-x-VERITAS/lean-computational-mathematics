/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.EigenmodeWaves
import ComputationalMathematics.Source.LeVeque.Chapter01.Equation01

/-!
# LeVeque Chapter 1, eigenvalues as wave speeds

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,
printed page 3 (raw PDF page 25).
-/

namespace NumStability

/-- A mode carried by an eigenvector of the coefficient matrix solves the
constant system as a translated profile whose speed is the corresponding
eigenvalue. -/
theorem leveque01_eigenvaluesAreWaveSpeeds
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    {profile : ℝ → ℝ} {profile' speed : ℝ}
    (eigenvector : Fin m → ℝ) (x t : ℝ)
    (heigen : coefficient.mulVec eigenvector = speed • eigenvector)
    (hprofile : HasDerivAt profile profile' (x - speed * t)) :
    leveque01_equation01_constantLinearSystemAt
      (eigenmodeTravelingWave profile speed eigenvector)
      coefficient x t :=
  eigenmodeTravelingWave_isConstantCoefficientSolutionAt
    coefficient eigenvector x t heigen hprofile

end NumStability
