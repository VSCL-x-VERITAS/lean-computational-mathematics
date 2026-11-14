/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Source.Bhatia.Chapter01.PositiveContractionTarget
import Mathlib.Analysis.InnerProductSpace.StarOrder
import Mathlib.Analysis.CStarAlgebra.ContinuousFunctionalCalculus.Order

/-!
# Positive contractions

Source correspondence for Bhatia, *Matrix Analysis* (1997), Chapter I.2,
printed page 7 (PDF page 19): a positive operator is contractive exactly
when it lies below the identity in the Loewner order. The norm is the
actual operator norm, and the finite-dimensional domain includes zero.
-/

set_option autoImplicit false

namespace NumStability.Bhatia.Chapter01

/-- The positive-contraction criterion on every finite-dimensional complex
Hilbert space. -/
theorem positiveContraction : Targets.positiveContraction := by
  intro H _ _ _ A hA
  letI := FiniteDimensional.complete ℂ H
  have hnonneg : 0 ≤ A.toContinuousLinearMap :=
    (ContinuousLinearMap.nonneg_iff_isPositive _).mpr
      ((LinearMap.isPositive_toContinuousLinearMap_iff A).mpr hA)
  exact (CStarAlgebra.norm_le_one_iff_of_nonneg A.toContinuousLinearMap hnonneg).trans
    (ContinuousLinearMap.coe_le_coe_iff A.toContinuousLinearMap 1).symm

end NumStability.Bhatia.Chapter01
