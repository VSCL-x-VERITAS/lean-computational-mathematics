/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.InnerProductSpace.LinearMap.PositiveSquareRoot
import ComputationalMathematics.Source.Bhatia.Chapter01.PositiveSquareRootTarget

/-!
# Positive square roots in Bhatia, Chapter I

Bhatia, *Matrix Analysis* (1997), Section I.2, printed page 5 (PDF page 17):
every positive semidefinite operator has a unique positive square root.
Existence and uniqueness apply on every finite-dimensional complex Hilbert
space, including dimension zero; uniqueness is among positive roots.
-/

set_option autoImplicit false
universe u

namespace NumStability.Bhatia.Chapter01

/-- Every positive operator has exactly one positive square root. -/
theorem positiveSquareRoot : Targets.positiveSquareRoot.{u} := by
  intro H _ _ _ A hA
  exact NumStability.existsUnique_positiveSquareRoot A hA

end NumStability.Bhatia.Chapter01
