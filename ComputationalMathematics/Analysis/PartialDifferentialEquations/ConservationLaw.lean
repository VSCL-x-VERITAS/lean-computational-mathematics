/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Calculus.Deriv.Add
import Mathlib.Analysis.Calculus.Deriv.Mul
import Mathlib.Analysis.Calculus.Deriv.Pi
import Mathlib.Data.Matrix.Basic
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem

/-!
# One-dimensional conservation laws

Source-independent pointwise predicates for classical one-dimensional
conservation laws, their quasilinear form, and constant linear fluxes.
-/

namespace NumStability

/-- A state satisfies the classical conservation-law residual
`q_t + (flux(q))_x = 0` at `(x,t)`. -/
def IsConservationLawSolutionAt
    {ι : Type*} [Fintype ι]
    (q : ℝ → ℝ → (ι → ℝ))
    (flux : (ι → ℝ) → (ι → ℝ)) (x t : ℝ) : Prop :=
  ∃ qt fluxx : ι → ℝ,
    HasDerivAt (fun τ => q x τ) qt t ∧
      HasDerivAt (fun ξ => flux (q ξ t)) fluxx x ∧
        qt + fluxx = 0

/-- A state satisfies the quasilinear equation
`q_t + Dflux(q) q_x = 0` at `(x,t)`. -/
def IsQuasilinearConservationLawSolutionAt
    {ι : Type*} [Fintype ι]
    (q : ℝ → ℝ → (ι → ℝ))
    (fluxDerivative :
      (ι → ℝ) → ((ι → ℝ) →L[ℝ] (ι → ℝ)))
    (x t : ℝ) : Prop :=
  ∃ qt qx : ι → ℝ,
    HasDerivAt (fun τ => q x τ) qt t ∧
      HasDerivAt (fun ξ => q ξ t) qx x ∧
        qt + fluxDerivative (q x t) qx = 0

/-- Under the explicit differentiability hypotheses needed for the chain
rule, the conservation residual and its quasilinear form are equivalent. -/
theorem conservationLaw_iff_quasilinearAt
    {ι : Type*} [Fintype ι]
    (q : ℝ → ℝ → (ι → ℝ))
    (flux : (ι → ℝ) → (ι → ℝ))
    (fluxDerivative :
      (ι → ℝ) → ((ι → ℝ) →L[ℝ] (ι → ℝ)))
    (x t : ℝ) (qx : ι → ℝ)
    (hqx : HasDerivAt (fun ξ => q ξ t) qx x)
    (hflux : HasFDerivAt flux (fluxDerivative (q x t)) (q x t)) :
    IsConservationLawSolutionAt q flux x t ↔
      IsQuasilinearConservationLawSolutionAt q fluxDerivative x t := by
  have hchain :
      HasDerivAt (fun ξ => flux (q ξ t))
        (fluxDerivative (q x t) qx) x := by
    simpa only [Function.comp_apply, ContinuousLinearMap.comp_apply,
      ContinuousLinearMap.toSpanSingleton_apply, one_smul] using
      (hflux.comp x hqx.hasFDerivAt).hasDerivAt
  constructor
  · rintro ⟨qt, fluxx, hqt, hfluxx, hresidual⟩
    have hfluxx_unique : fluxx = fluxDerivative (q x t) qx :=
      hfluxx.unique hchain
    subst fluxx
    exact ⟨qt, qx, hqt, hqx, hresidual⟩
  · rintro ⟨qt, qx', hqt, hqx', hresidual⟩
    have hchain' :
        HasDerivAt (fun ξ => flux (q ξ t))
          (fluxDerivative (q x t) qx') x := by
      simpa only [Function.comp_apply, ContinuousLinearMap.comp_apply,
        ContinuousLinearMap.toSpanSingleton_apply, one_smul] using
        (hflux.comp x hqx'.hasFDerivAt).hasDerivAt
    exact ⟨qt, fluxDerivative (q x t) qx', hqt, hchain', hresidual⟩

/-- The constant linear flux `state ↦ A state`. -/
def constantLinearFlux
    {ι : Type*} [Fintype ι]
    (coefficient : Matrix ι ι ℝ) (state : ι → ℝ) : ι → ℝ :=
  coefficient.mulVec state

/-- Along a differentiable state curve, the derivative of a constant linear
flux is the same matrix applied to the state derivative. -/
theorem hasDerivAt_constantLinearFlux_comp
    {ι : Type*} [Fintype ι]
    (coefficient : Matrix ι ι ℝ)
    (state : ℝ → (ι → ℝ)) (stateDerivative : ι → ℝ) (x : ℝ)
    (hstate : HasDerivAt state stateDerivative x) :
    HasDerivAt (fun ξ => constantLinearFlux coefficient (state ξ))
      (coefficient.mulVec stateDerivative) x := by
  rw [hasDerivAt_pi] at hstate ⊢
  intro i
  simp only [constantLinearFlux, Matrix.mulVec, dotProduct]
  exact HasDerivAt.fun_sum fun j _ => (hstate j).const_mul (coefficient i j)

/-- A conservation law with constant linear flux `f(q) = A q` is exactly the
constant-coefficient first-order system `q_t + A q_x = 0`. -/
theorem conservationLaw_constantLinearFlux_iff
    {ι : Type*} [Fintype ι]
    (q : ℝ → ℝ → (ι → ℝ)) (coefficient : Matrix ι ι ℝ)
    (x t : ℝ) (qx : ι → ℝ)
    (hqx : HasDerivAt (fun ξ => q ξ t) qx x) :
    IsConservationLawSolutionAt q (constantLinearFlux coefficient) x t ↔
      IsConstantCoefficientLinearSystemSolutionAt q coefficient x t := by
  constructor
  · rintro ⟨qt, fluxx, hqt, hfluxx, hresidual⟩
    have hlinear := hasDerivAt_constantLinearFlux_comp
      coefficient (fun ξ => q ξ t) qx x hqx
    have hfluxx_unique : fluxx = coefficient.mulVec qx :=
      hfluxx.unique hlinear
    subst fluxx
    exact ⟨qt, qx, hqt, hqx, hresidual⟩
  · rintro ⟨qt, qx', hqt, hqx', hresidual⟩
    refine ⟨qt, coefficient.mulVec qx', hqt, ?_, hresidual⟩
    exact hasDerivAt_constantLinearFlux_comp
      coefficient (fun ξ => q ξ t) qx' x hqx'

/-- Every solution of a constant-coefficient system is a conservation-law
solution for the corresponding linear flux. -/
theorem constantCoefficientLinearSystem_isConservationLaw
    {ι : Type*} [Fintype ι]
    (q : ℝ → ℝ → (ι → ℝ)) (coefficient : Matrix ι ι ℝ)
    (x t : ℝ)
    (hsystem : IsConstantCoefficientLinearSystemSolutionAt
      q coefficient x t) :
    IsConservationLawSolutionAt q (constantLinearFlux coefficient) x t := by
  rcases hsystem with ⟨qt, qx, hqt, hqx, hresidual⟩
  refine ⟨qt, coefficient.mulVec qx, hqt, ?_, hresidual⟩
  exact hasDerivAt_constantLinearFlux_comp
    coefficient (fun ξ => q ξ t) qx x hqx

end NumStability
