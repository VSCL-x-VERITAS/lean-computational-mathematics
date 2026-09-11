/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.PartialDifferentialEquations.AdvectionClassification
import ComputationalMathematics.Analysis.PartialDifferentialEquations.DifferentialForm
import Mathlib.Analysis.ODE.Gronwall

/-!
# Advection by a velocity that varies in space

Printed page 19 of LeVeque's Chapter 2 lets the fluid velocity depend on
position. Two things change, and this module carries both.

The conservation law becomes `q_t + (u(x) q)_x = 0`, and that is genuinely
different from `q_t + u(x) q_x = 0`: the product rule leaves a term `u'(x) q`
behind, so the conservative and the advective form of the same equation have
different solutions as soon as the velocity is not constant. A witness below
exhibits a density satisfying one and not the other.

The characteristic curves stop being straight lines and become solutions of the
ordinary differential equation `X'(t) = u(X(t))`. The rays of the
constant-velocity case are recovered as the special case, and a Lipschitz
velocity field determines the curve through a point uniquely, which is what the
source's "we can solve the equation with initial condition `X(0) = x₀` to obtain
a particular characteristic curve" relies on.
-/

namespace NumStability

/-! ### The conservative form -/

/-- The spatial derivative of the flux `u(x) q(x,t)` by the product rule.

The term `u'(x) q(x,t)` is what distinguishes this from the constant-velocity
case, where the velocity passes through the derivative untouched. -/
theorem variableFlux_hasDerivAt {u : ℝ → ℝ} {u' : ℝ} {q : ℝ → ℝ → ℝ} {qx x t : ℝ}
    (hu : HasDerivAt u u' x) (hq : HasDerivAt (fun y => q y t) qx x) :
    HasDerivAt (fun y => u y * q y t) (u' * q x t + u x * qx) x :=
  hu.mul hq

/-- Equation (2.16) written with the derivative operator, and the same equation
written with named partial-derivative families, are the same condition. -/
theorem variableAdvection_iff_subscriptForm
    {u : ℝ → ℝ} {q qt Fx : ℝ → ℝ → ℝ}
    (hqt : ∀ x t, HasDerivAt (fun τ => q x τ) (qt x t) t)
    (hFx : ∀ x t, HasDerivAt (fun y => u y * q y t) (Fx x t) x) (x t : ℝ) :
    qt x t + Fx x t = 0 ↔
      deriv (fun τ => q x τ) t + deriv (fun y => u y * q y t) x = 0 :=
  subscriptForm_iff_operatorForm hqt hFx x t

/-- The conservative form `q_t + (u q)_x = 0` and the advective form
`q_t + u q_x = 0` are different equations once the velocity varies.

The witness is the velocity `u(x) = x` and the density `q(x,t) = e^{-t}`, which
is uniform in space and decays in time. Its conservative residual vanishes
everywhere, because the decay exactly balances the spreading term `u'(x) q`,
while its advective residual is `-e^{-t}`, which is never zero. So writing the
velocity inside or outside the derivative is not a matter of notation. -/
theorem conservativeForm_ne_advectiveForm :
    ∃ (u : ℝ → ℝ) (q qt qx : ℝ → ℝ → ℝ),
      (∀ y, HasDerivAt u 1 y) ∧
        (∀ y s, HasDerivAt (fun τ => q y τ) (qt y s) s) ∧
        (∀ y s, HasDerivAt (fun ξ => q ξ s) (qx y s) y) ∧
        (∀ y s, qt y s + deriv (fun ξ => u ξ * q ξ s) y = 0) ∧
        (∀ y s, qt y s + u y * qx y s ≠ 0) := by
  refine ⟨id, fun _ t => Real.exp (-t), fun _ t => -Real.exp (-t), fun _ _ => 0,
    fun y => hasDerivAt_id y, ?_, ?_, ?_, ?_⟩
  · intro y s
    have h : HasDerivAt (fun τ : ℝ => Real.exp (-τ)) (Real.exp (-s) * -1) s :=
      ((hasDerivAt_id s).neg).exp
    have hv : Real.exp (-s) * -1 = -Real.exp (-s) := by ring
    rw [hv] at h
    exact h
  · intro y s
    exact hasDerivAt_const y (Real.exp (-s))
  · intro y s
    have hd : HasDerivAt (fun ξ : ℝ => ξ * Real.exp (-s)) (Real.exp (-s)) y := by
      simpa using (hasDerivAt_id y).mul_const (Real.exp (-s))
    show -Real.exp (-s) + deriv (fun ξ : ℝ => id ξ * Real.exp (-s)) y = 0
    simp only [id_eq, hd.deriv]
    ring
  · intro y s
    simp [(Real.exp_pos (-s)).ne']

/-! ### The characteristic curves -/

/-- Equation (2.17): a characteristic curve of a velocity field is a curve whose
velocity at every time is the fluid velocity at the point it has reached. -/
def IsCharacteristicCurve (u : ℝ → ℝ) (X : ℝ → ℝ) : Prop :=
  ∀ t, HasDerivAt X (u (X t)) t

/-- With a constant velocity the characteristic curves are the rays of printed
page 18, so (2.17) generalises rather than replaces them. -/
theorem isCharacteristicCurve_uniform (speed x₀ : ℝ) :
    IsCharacteristicCurve (fun _ => speed) fun t => x₀ + speed * t := by
  intro t
  have h : HasDerivAt (fun τ : ℝ => x₀ + speed * τ) (0 + speed * 1) t :=
    (hasDerivAt_const t x₀).add ((hasDerivAt_id t).const_mul speed)
  have hv : (0 : ℝ) + speed * 1 = speed := by ring
  rw [hv] at h
  exact h

/-- A Lipschitz velocity field determines the characteristic curve through a
point uniquely. This is what licenses the source's "we can solve the equation
(2.17) with initial condition `X(0) = x₀` to obtain *a particular*
characteristic curve": without it there would be no such thing as *the* curve
through a point. -/
theorem isCharacteristicCurve_unique {u : ℝ → ℝ} {K : NNReal}
    (hu : LipschitzWith K u) {X Y : ℝ → ℝ} {t₀ : ℝ}
    (hX : IsCharacteristicCurve u X) (hY : IsCharacteristicCurve u Y)
    (h : X t₀ = Y t₀) : X = Y :=
  ODE_solution_unique_univ (v := fun _ y => u y) (s := fun _ => Set.univ)
    (fun _ => hu.lipschitzOnWith) (fun t => ⟨hX t, trivial⟩)
    (fun t => ⟨hY t, trivial⟩) h

/-- Distinct material particles never meet.

Two characteristic curves that are apart at one time are apart at every time,
because meeting once would force them equal everywhere by uniqueness. This is
the content of the source's remark that the curves track the motion of
*particular* material particles: a particle has a trajectory of its own, and the
trajectories partition space-time rather than crossing. -/
theorem isCharacteristicCurve_ne_of_ne {u : ℝ → ℝ} {K : NNReal}
    (hu : LipschitzWith K u) {X Y : ℝ → ℝ} {t₀ : ℝ}
    (hX : IsCharacteristicCurve u X) (hY : IsCharacteristicCurve u Y)
    (h : X t₀ ≠ Y t₀) : ∀ t, X t ≠ Y t := by
  intro t hmeet
  exact h (congrFun (isCharacteristicCurve_unique hu hX hY hmeet) t₀)

/-- A curve whose velocity at some time is not the fluid velocity at the point
it has reached is not a characteristic curve. The condition is about the
relation between two quantities, not about how the curve is written. -/
theorem not_isCharacteristicCurve_of_velocity_ne {u : ℝ → ℝ} {X : ℝ → ℝ} {v t : ℝ}
    (hX : HasDerivAt X v t) (h : v ≠ u (X t)) : ¬ IsCharacteristicCurve u X :=
  fun hchar => h (hX.unique (hchar t))

/-- Being a characteristic curve is a restriction: a uniform curve fails it for
a velocity field that varies. -/
theorem exists_not_isCharacteristicCurve :
    ∃ (u : ℝ → ℝ) (X : ℝ → ℝ),
      (∀ t, HasDerivAt X 1 t) ∧ ¬ IsCharacteristicCurve u X := by
  refine ⟨id, id, fun t => hasDerivAt_id t, ?_⟩
  refine not_isCharacteristicCurve_of_velocity_ne (t := 0) (hasDerivAt_id 0) ?_
  norm_num

end NumStability
