/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Calculus.MeanValue

/-!
# Flux representation of scalar transport with a variable coefficient

For the unchanged density, a local flux that represents the transport operator
on every differentiable profile forces the coefficient to be constant.
Explicit spatial dependence of the proposed flux is allowed.
-/

namespace NumStability

/-- A local scalar flux represents a spatial transport operator for the fixed
state variable if the actual composed spatial derivative agrees on every
differentiable test profile. Explicit dependence on position is allowed. -/
def RepresentsScalarTransportFlux (coefficient : ℝ → ℝ)
    (flux : ℝ → ℝ → ℝ) : Prop :=
  ∀ (profile : ℝ → ℝ) (x slope : ℝ), HasDerivAt profile slope x →
    HasDerivAt (fun y => flux y (profile y)) (coefficient x * slope) x

/-- Constant test profiles force every fixed-state flux slice to be constant
in position. This excludes hidden zero-order production terms. -/
theorem RepresentsScalarTransportFlux.position_independent
    {coefficient : ℝ → ℝ} {flux : ℝ → ℝ → ℝ}
    (h : RepresentsScalarTransportFlux coefficient flux) (x y state : ℝ) :
    flux x state = flux y state := by
  have hzero (z : ℝ) : HasDerivAt (fun z => flux z state) 0 z := by
    simpa using h (fun _ => state) z 0 (hasDerivAt_const z state)
  exact is_const_of_deriv_eq_zero (fun z => (hzero z).differentiableAt)
    (fun z => (hzero z).deriv) x y

/-- Affine test profiles identify the state derivative at the same fixed state
with the coefficient at any independently selected spatial point. -/
theorem RepresentsScalarTransportFlux.state_derivative
    {coefficient : ℝ → ℝ} {flux : ℝ → ℝ → ℝ}
    (h : RepresentsScalarTransportFlux coefficient flux) (x : ℝ) :
    HasDerivAt (flux 0) (coefficient x) 0 := by
  have htest := h (fun y => y - x) x 1 ((hasDerivAt_id x).sub_const x)
  have hfun : (fun y => flux y (y - x)) = fun y => flux 0 (y - x) := by
    funext y
    exact h.position_independent y 0 (y - x)
  rw [hfun] at htest
  have htest' : HasDerivAt (fun y => flux 0 (y - x)) (coefficient x) (0 + x) := by
    simpa using htest
  have hcomp := htest'.comp 0 ((hasDerivAt_id 0).add_const x)
  simpa only [Function.comp_def, add_sub_cancel_right, mul_one] using hcomp

theorem RepresentsScalarTransportFlux.coefficient_eq
    {coefficient : ℝ → ℝ} {flux : ℝ → ℝ → ℝ}
    (h : RepresentsScalarTransportFlux coefficient flux) (x y : ℝ) :
    coefficient x = coefficient y :=
  (h.state_derivative x).unique (h.state_derivative y)

end NumStability
