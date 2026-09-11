/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.PartialDifferentialEquations.VariableCoefficientAdvection

/-!
# LeVeque Chapter 2, printed page 19: a velocity that varies with position

Section 2.1.1 lets the fluid velocity depend on position. The conservation law
picks up a term, and the characteristic curves stop being straight.

Each wrapper keeps the printed nouns in the statement: the flux is the one
equation (2.4) names, applied to a velocity field that happens not to depend on
time; the conservation law is written both with the derivative operator and in
the subscript notation the source uses; and the characteristic curves are
defined by the differential equation (2.17) rather than by a name.

The reusable mathematics lives in
`ComputationalMathematics.Analysis.PartialDifferentialEquations.VariableCoefficientAdvection`.
-/

namespace NumStability

/-- Equation (2.16): with a velocity varying in position, the flux (2.4) gives
the conservation law `q_t + (u(x) q)_x = 0`.

The first conjunct identifies the flux the source names: equation (2.4) applied
to a velocity field independent of time is the product `u(x) q(x,t)`, so the
quantity differentiated in the second conjunct is the printed one. The second is
the equation, written in the subscript notation of (2.11) on the left and with
the derivative operator on the right.

The third is where a varying velocity actually bites: the product rule expands
the flux derivative as `u'(x) q + u(x) q_x`, and the extra first term is absent
from the constant-coefficient case. The fourth shows that term is not
bookkeeping. It exhibits a velocity and a density for which the conservative
residual vanishes everywhere while the advective residual vanishes nowhere, so
the conservative form (2.16) and the advective form `q_t + u q_x = 0` are
different equations, not two spellings of one. -/
theorem leveque02_equation16_variableCoefficientConservation
    {u u' : ℝ → ℝ} {q qt qx Fx : ℝ → ℝ → ℝ}
    (hu : ∀ x, HasDerivAt u (u' x) x)
    (hqt : ∀ x t, HasDerivAt (fun τ => q x τ) (qt x t) t)
    (hqx : ∀ x t, HasDerivAt (fun ξ => q ξ t) (qx x t) x)
    (hFx : ∀ x t, HasDerivAt (fun y => u y * q y t) (Fx x t) x) :
    (∀ x t, advectiveFlux (fun z _ => u z) (q x t) x t = u x * q x t) ∧
      (∀ x t, qt x t + Fx x t = 0 ↔
        deriv (fun τ => q x τ) t + deriv (fun y => u y * q y t) x = 0) ∧
      (∀ x t, Fx x t = u' x * q x t + u x * qx x t) ∧
      (∃ (v : ℝ → ℝ) (r rt rx : ℝ → ℝ → ℝ),
        (∀ y, HasDerivAt v 1 y) ∧
          (∀ y s, HasDerivAt (fun τ => r y τ) (rt y s) s) ∧
          (∀ y s, HasDerivAt (fun ξ => r ξ s) (rx y s) y) ∧
          (∀ y s, rt y s + deriv (fun ξ => v ξ * r ξ s) y = 0) ∧
          (∀ y s, rt y s + v y * rx y s ≠ 0)) := by
  refine ⟨fun x t => rfl,
    fun x t => variableAdvection_iff_subscriptForm hqt hFx x t,
    fun x t => (hFx x t).unique (variableFlux_hasDerivAt (hu x) (hqx x t)),
    conservativeForm_ne_advectiveForm⟩

/-- Equation (2.17): the characteristic curves of a variable-coefficient
advection equation solve `X'(t) = u(X(t))`.

The first conjunct recovers the rays of printed page 18 as the constant-velocity
case, so (2.17) generalises the earlier picture rather than replacing it. The
second is what licenses the source's "we can solve the equation (2.17) with
initial condition `X(0) = x₀` to obtain *a particular* characteristic curve": for
a Lipschitz velocity field the curve through a point is unique, so there is such
a thing as the characteristic through `x₀`. The third shows the condition is a
restriction: a curve of constant speed is not a characteristic of a velocity
field that varies. -/
theorem leveque02_equation17_characteristicOde :
    (∀ speed x₀ : ℝ,
        IsCharacteristicCurve (fun _ => speed) fun t => x₀ + speed * t) ∧
      (∀ (u : ℝ → ℝ) (K : NNReal), LipschitzWith K u →
        ∀ X Y : ℝ → ℝ, IsCharacteristicCurve u X → IsCharacteristicCurve u Y →
          ∀ t₀ : ℝ, X t₀ = Y t₀ → X = Y) ∧
      (∃ (u : ℝ → ℝ) (X : ℝ → ℝ),
        (∀ t, HasDerivAt X 1 t) ∧ ¬ IsCharacteristicCurve u X) :=
  ⟨fun speed x₀ => isCharacteristicCurve_uniform speed x₀,
   fun _ _ hu _ _ hX hY _ h => isCharacteristicCurve_unique hu hX hY h,
   exists_not_isCharacteristicCurve⟩

/-- The characteristic curves track material particles.

The source's reason is that the velocity of such a curve at any time matches the
fluid velocity at the point it has reached. The first conjunct is that match,
stated as a relation between the curve's derivative and the velocity field at
the curve's own position rather than as a property of a name; the second is its
contrapositive, so a curve moving at any other rate is excluded.

The third is the part that makes "particular material particles" mean something.
For a Lipschitz velocity field two curves apart at one time are apart at every
time, so each particle has a trajectory of its own and trajectories do not cross.
Without it, the phrase would describe no more than a curve tangent to the flow. -/
theorem leveque02_characteristicsTrackMaterialParticles :
    (∀ (u : ℝ → ℝ) (X : ℝ → ℝ), IsCharacteristicCurve u X →
        ∀ t, HasDerivAt X (u (X t)) t) ∧
      (∀ (u : ℝ → ℝ) (X : ℝ → ℝ) (v t : ℝ), HasDerivAt X v t → v ≠ u (X t) →
        ¬ IsCharacteristicCurve u X) ∧
      (∀ (u : ℝ → ℝ) (K : NNReal), LipschitzWith K u →
        ∀ (X Y : ℝ → ℝ) (t₀ : ℝ), IsCharacteristicCurve u X →
          IsCharacteristicCurve u Y → X t₀ ≠ Y t₀ → ∀ t, X t ≠ Y t) :=
  ⟨fun _ _ hX => hX,
   fun _ _ _ _ hX h => not_isCharacteristicCurve_of_velocity_ne hX h,
   fun _ _ hu _ _ _ hX hY h => isCharacteristicCurve_ne_of_ne hu hX hY h⟩

end NumStability
