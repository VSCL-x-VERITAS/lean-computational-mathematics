/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.InnerProductSpace.LinearMap.PositiveSquareRoot
import Mathlib.Algebra.Star.Unitary

/-!
# Normality and commutation of polar factors

A finite-dimensional complex operator written as a full unitary factor times
a positive factor is normal exactly when those two factors commute.

The forward implication compares two positive square roots of the square of
the positive factor. It never cancels that factor, so singular operators,
zero positive factors and the zero-dimensional space are included.
-/

set_option autoImplicit false

namespace NumStability

/-- Normality of an operator with supplied unitary and positive polar factors
is equivalent to commutation of those factors, including when the positive
factor is singular. -/
theorem isStarNormal_iff_commute_of_unitary_positive
    {H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H]
    [FiniteDimensional ℂ H] (A U P : H →ₗ[ℂ] H)
    (hU : U ∈ unitary (H →ₗ[ℂ] H)) (hP : P.IsPositive)
    (hA : A = U.comp P) :
    IsStarNormal A ↔ U.comp P = P.comp U := by
  have hUl : (LinearMap.adjoint U).comp U = LinearMap.id :=
    (Unitary.mem_iff.mp hU).1
  have hUr : U.comp (LinearMap.adjoint U) = LinearMap.id :=
    (Unitary.mem_iff.mp hU).2
  have hPs : LinearMap.adjoint P = P := hP.1.adjoint_eq
  have hGram : (LinearMap.adjoint A).comp A = P.comp P := by
    rw [hA, LinearMap.adjoint_comp, hPs, LinearMap.comp_assoc,
      ← LinearMap.comp_assoc P U U.adjoint, hUl, LinearMap.id_comp]
  have hcoGram : A.comp (LinearMap.adjoint A) =
      U.comp ((P.comp P).comp U.adjoint) := by
    rw [hA, LinearMap.adjoint_comp, hPs]
    simp only [LinearMap.comp_assoc]
  constructor
  · intro hN
    have hnormal : (LinearMap.adjoint A).comp A = A.comp (LinearMap.adjoint A) :=
      hN.star_comm_self.eq
    rw [hGram, hcoGram] at hnormal
    let Q : H →ₗ[ℂ] H := U.comp (P.comp U.adjoint)
    have hQ : Q.IsPositive := hP.conj_adjoint U
    have hQsq : Q.comp Q = P.comp P := by
      calc
        Q.comp Q = U.comp (P.comp ((U.adjoint.comp U).comp (P.comp U.adjoint))) := by
          simp only [Q, LinearMap.comp_assoc]
        _ = U.comp ((P.comp P).comp U.adjoint) := by
          rw [hUl, LinearMap.id_comp]
          simp only [LinearMap.comp_assoc]
        _ = P.comp P := hnormal.symm
    have hPP : (P.comp P).IsPositive := by
      simpa only [hPs] using LinearMap.isPositive_adjoint_comp_self P
    have hQP : Q = P :=
      (positiveSquareRoot_unique (P.comp P) hPP Q hQ hQsq).trans
        (positiveSquareRoot_unique (P.comp P) hPP P hP rfl).symm
    have hright := congrArg (fun T : H →ₗ[ℂ] H => T.comp U) hQP
    change (U.comp (P.comp U.adjoint)).comp U = P.comp U at hright
    simpa only [LinearMap.comp_assoc, ← LinearMap.comp_assoc U.adjoint U,
      hUl, LinearMap.id_comp] using hright
  · intro hcomm
    have hco : U.comp ((P.comp P).comp U.adjoint) = P.comp P := by
      calc
        U.comp ((P.comp P).comp U.adjoint) =
            (U.comp P).comp (P.comp U.adjoint) := by
          simp only [LinearMap.comp_assoc]
        _ = (P.comp U).comp (P.comp U.adjoint) := by rw [hcomm]
        _ = P.comp ((U.comp P).comp U.adjoint) := by
          simp only [LinearMap.comp_assoc]
        _ = P.comp ((P.comp U).comp U.adjoint) := by rw [hcomm]
        _ = P.comp P := by rw [LinearMap.comp_assoc U.adjoint U P, hUr]; simp
    constructor
    change (LinearMap.adjoint A).comp A = A.comp (LinearMap.adjoint A)
    rw [hGram, hcoGram, hco]

end NumStability
