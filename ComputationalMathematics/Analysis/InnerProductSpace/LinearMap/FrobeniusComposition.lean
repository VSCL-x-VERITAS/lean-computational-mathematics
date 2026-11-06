/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.InnerProductSpace.LinearMap.Frobenius

/-!
# Frobenius norm under isometric and coisometric composition

Composition on the left by an isometry preserves the Gram operator.
Composition on the right by a coisometry preserves its trace. Thus each
preserves the intrinsic Frobenius norm. The hypotheses use the corresponding
adjoint equations directly; unitary operators satisfy both equations.

All operators act on an arbitrary finite-dimensional complex inner-product
space, including dimension zero. No invertibility premise is needed.
-/

set_option autoImplicit false

namespace NumStability

variable {H : Type*} [NormedAddCommGroup H]
variable [InnerProductSpace ℂ H] [FiniteDimensional ℂ H]

/-- Left composition preserves the Frobenius norm when the left operator's
adjoint composed with that operator is the identity. -/
theorem linearMapFrobenius_comp_left_of_adjoint_comp_self
    (U A : H →ₗ[ℂ] H) (hU : (LinearMap.adjoint U).comp U = LinearMap.id) :
    linearMapFrobenius (U.comp A) = linearMapFrobenius A := by
  have hgram : (LinearMap.adjoint (U.comp A)).comp (U.comp A) =
      (LinearMap.adjoint A).comp A := by
    calc
      _ = (LinearMap.adjoint A).comp (((LinearMap.adjoint U).comp U).comp A) := by
        rw [LinearMap.adjoint_comp]
        rfl
      _ = _ := by rw [hU, LinearMap.id_comp]
  rw [linearMapFrobenius_eq_sqrt_re_trace,
    linearMapFrobenius_eq_sqrt_re_trace, hgram]

/-- Right composition preserves the Frobenius norm when the right operator
composed with its adjoint is the identity. -/
theorem linearMapFrobenius_comp_right_of_comp_adjoint_self
    (A V : H →ₗ[ℂ] H) (hV : V.comp (LinearMap.adjoint V) = LinearMap.id) :
    linearMapFrobenius (A.comp V) = linearMapFrobenius A := by
  have htrace :
      LinearMap.trace ℂ H ((LinearMap.adjoint (A.comp V)).comp (A.comp V)) =
        LinearMap.trace ℂ H ((LinearMap.adjoint A).comp A) := by
    calc
      _ = LinearMap.trace ℂ H
          (((LinearMap.adjoint V).comp ((LinearMap.adjoint A).comp A)).comp V) := by
        rw [LinearMap.adjoint_comp]
        rfl
      _ = LinearMap.trace ℂ H
          (V.comp ((LinearMap.adjoint V).comp ((LinearMap.adjoint A).comp A))) :=
        LinearMap.trace_comp_comm' V _
      _ = LinearMap.trace ℂ H
          ((V.comp (LinearMap.adjoint V)).comp ((LinearMap.adjoint A).comp A)) := rfl
      _ = _ := by rw [hV, LinearMap.id_comp]
  rw [linearMapFrobenius_eq_sqrt_re_trace,
    linearMapFrobenius_eq_sqrt_re_trace, htrace]

end NumStability
