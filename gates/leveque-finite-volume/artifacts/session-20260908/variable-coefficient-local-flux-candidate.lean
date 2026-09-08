import ComputationalMathematics.Source.LeVeque.Chapter01.ScalarHyperbolicity
import Mathlib.Analysis.Calculus.ContDiff.Operations
import Mathlib.Analysis.Calculus.MeanValue
import Mathlib.Tactic.FunProp
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Positivity

namespace NumStability.Chapter01Scratch

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

/-- A positive smooth pointwise hyperbolic scalar transport coefficient need
not admit any local flux for the unchanged density, even when that flux is
allowed to depend explicitly on position. This does not rule out changes of
density or integrating factors. -/
theorem exists_positive_smooth_hyperbolic_transport_without_local_flux :
    ∃ coefficient : ℝ → ℝ,
      ContDiff ℝ (⊤ : ℕ∞) coefficient ∧
      (∀ x, 0 < coefficient x) ∧
      (∀ x, IsRealHyperbolicMatrix (constantCoefficientScalarMatrix (coefficient x))) ∧
      ¬ ∃ flux : ℝ → ℝ → ℝ, RepresentsScalarTransportFlux coefficient flux := by
  refine ⟨fun x => 1 + x ^ 2, by fun_prop, ?_, ?_, ?_⟩
  · intro x
    positivity
  · intro x
    exact leveque01_scalarEquation_isHyperbolic (1 + x ^ 2)
  · rintro ⟨flux, hflux⟩
    have h := hflux.coefficient_eq 0 1
    norm_num at h

#print axioms RepresentsScalarTransportFlux.position_independent
#print axioms RepresentsScalarTransportFlux.state_derivative
#print axioms RepresentsScalarTransportFlux.coefficient_eq
#print axioms exists_positive_smooth_hyperbolic_transport_without_local_flux

end NumStability.Chapter01Scratch
