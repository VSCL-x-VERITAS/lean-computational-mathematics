/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.PartialDifferentialEquations.HeatConduction

/-!
# LeVeque Chapter 2, printed page 21: variable diffusion and heat conduction

The page lets the diffusion coefficient vary, combines diffusion with advection,
and then reads the whole discussion again for heat, where the conserved quantity
is the internal energy rather than the temperature.

One row of the page is deliberately absent. Equation (2.24), the integral form
of the heat balance, carries a sign that under the chapter's own evaluation-bar
convention, fixed at (2.7), disagrees with the heat flux stated on the same page
and with the differential form (2.25) printed just below it. That is recorded as
`LEV-CH02-INC-004` and routed to the audit rather than resolved here, because
deciding a printed sign from a text extraction is exactly the kind of call this
campaign does not make on its own.

The reusable mathematics lives in
`ComputationalMathematics.Analysis.PartialDifferentialEquations.HeatConduction`.
-/

namespace NumStability

/-- Equation (2.22): a diffusion coefficient varying in space.

The first conjunct is the printed equation. The second names the quantity the
coefficient multiplies, so the row says that `q_x` is the spatial derivative of
the density rather than leaving it an unconstrained family. -/
theorem leveque02_equation22_variableDiffusion
    {q qt qx Fx : ℝ → ℝ → ℝ} {beta : ℝ → ℝ}
    (hqx : ∀ x t, HasDerivAt (fun y => q y t) (qx x t) x)
    (hFx : ∀ x t,
      HasDerivAt (fun y => diffusiveFlux (beta y) (qx y t)) (Fx x t) x)
    (hlaw : ∀ x t, qt x t + Fx x t = 0) (x t : ℝ) :
    qt x t = deriv (fun y => beta y * qx y t) x ∧
      qx x t = deriv (fun y => q y t) x :=
  variableDiffusion_of_conservationLaw hqx hFx hlaw x t

/-- Equation (2.23): the advection-diffusion equation.

The flux is the sum the source writes, `ū q - β q_x`, so both mechanisms are
present in the same conservation law, and the equation that comes out carries
the advective term on the left and the diffusive one on the right exactly as
printed. -/
theorem leveque02_equation23_advectionDiffusion
    {q qt qx qxx : ℝ → ℝ → ℝ} {speed beta : ℝ}
    (hqx : ∀ x t, HasDerivAt (fun y => q y t) (qx x t) x)
    (hqxx : ∀ x t, HasDerivAt (fun y => qx y t) (qxx x t) x)
    (hlaw : ∀ x t, qt x t
      + deriv (fun y => speed * q y t + diffusiveFlux beta (qx y t)) x = 0)
    (x t : ℝ) :
    qt x t + speed * qx x t = beta * qxx x t :=
  advectionDiffusion_of_conservationLaw hqx hqxx hlaw x t

/-- The density of internal energy.

The source writes `E(x,t) = κ(x) q(x,t)`, and writing that product down as a
definition would make the identification true by construction. The row states
instead the properties an energy density must have relative to a temperature
field and a heat capacity, and derives the product from them: an assignment
determined pointwise by the temperature, scaling with it, and equal to the
capacity on a unit temperature has no choice but to be that product.

The second conjunct shows the property package is inhabited, and the third that
it is a restriction rather than a description, since an assignment ignoring the
temperature fails it wherever the capacity is nonzero. -/
theorem leveque02_internalEnergyDensity (capacity : ℝ → ℝ) :
    (∀ E : (ℝ → ℝ → ℝ) → ℝ → ℝ → ℝ, IsInternalEnergyDensity E capacity →
        ∀ q x t, E q x t = capacity x * q x t) ∧
      IsInternalEnergyDensity (fun q x t => capacity x * q x t) capacity ∧
      (∀ x₀ : ℝ, capacity x₀ ≠ 0 →
        ¬ IsInternalEnergyDensity (fun _ _ _ => 0) capacity) :=
  ⟨fun _ h q x t => h.eq_capacity_mul q x t,
   isInternalEnergyDensity_capacity_mul capacity,
   fun _ h => exists_not_isInternalEnergyDensity h⟩

/-- Fourier's law of heat conduction, and how it differs from Fick's law.

The printed law is the first conjunct: the energy flux is minus the thermal
conductivity times the temperature gradient. The next three are its direction
and its equality case, which is what "conduction" means physically.

The last is the distinction the source draws. Fourier makes the energy flux
proportional to the gradient of the *temperature*; Fick would make it
proportional to the gradient of the conserved quantity, which here is the energy
`κ q`, and whose gradient carries the extra term `κ'(x) q`. Requiring the two to
agree for every temperature field forces the heat capacity to be identically
one, which is the case the source singles out when it says the two laws are
identical at `κ ≡ 1` and fundamentally different when `κ` varies. -/
theorem leveque02_fourierLawHeatFlux
    {beta : ℝ} {capacity capacity' : ℝ → ℝ} (hbeta : 0 < beta)
    (hcap : ∀ x, HasDerivAt capacity (capacity' x) x) :
    (∀ gradient : ℝ, diffusiveFlux beta gradient = -beta * gradient) ∧
      (∀ gradient : ℝ, 0 < gradient → diffusiveFlux beta gradient < 0) ∧
      (∀ gradient : ℝ, gradient < 0 → 0 < diffusiveFlux beta gradient) ∧
      (∀ gradient : ℝ, diffusiveFlux beta gradient = 0 ↔ gradient = 0) ∧
      ((∀ (q qx : ℝ → ℝ → ℝ),
          (∀ x t, HasDerivAt (fun y => q y t) (qx x t) x) →
          ∀ x t, diffusiveFlux beta (qx x t)
            = diffusiveFlux beta (capacity' x * q x t + capacity x * qx x t))
        ↔ ∀ x, capacity x = 1) :=
  ⟨fun _ => rfl,
   fun _ hg => diffusiveFlux_neg_of_gradient_pos hbeta hg,
   fun _ hg => diffusiveFlux_pos_of_gradient_neg hbeta hg,
   fun _ => diffusiveFlux_eq_zero_iff (ne_of_gt hbeta),
   fourierFlux_eq_fickFlux_iff_capacity_one (ne_of_gt hbeta) hcap⟩

/-- Equation (2.25): the differential form of the heat equation.

The conserved density is the internal energy, not the temperature, and the
second conjunct says so by naming the left-hand side as the time derivative of
`κ q`. Without it the row would assert a balance between two unconstrained
families and would not be about heat at all. -/
theorem leveque02_equation25_heatDifferentialForm
    {q qx Et Fx : ℝ → ℝ → ℝ} {capacity beta : ℝ → ℝ}
    (hEt : ∀ x t, HasDerivAt (fun τ => capacity x * q x τ) (Et x t) t)
    (hFx : ∀ x t,
      HasDerivAt (fun y => diffusiveFlux (beta y) (qx y t)) (Fx x t) x)
    (hlaw : ∀ x t, Et x t + Fx x t = 0) (x t : ℝ) :
    Et x t = deriv (fun y => beta y * qx y t) x ∧
      Et x t = deriv (fun τ => capacity x * q x τ) t :=
  heatDifferentialForm hEt hFx hlaw x t

/-- Equation (2.26): a heat capacity that does not vary with time.

The first conjunct is the step the source takes: the capacity passes through the
time derivative, so `(κ q)_t` is `κ q_t` and (2.25) becomes (2.26). The second
shows the hypothesis is doing work rather than tidying notation, by exhibiting a
capacity varying in time for which the two differ. -/
theorem leveque02_equation26_timeIndependentCapacity
    {q qt : ℝ → ℝ → ℝ} {capacity : ℝ → ℝ}
    (hqt : ∀ x t, HasDerivAt (fun τ => q x τ) (qt x t) t) :
    (∀ x t, HasDerivAt (fun τ => capacity x * q x τ) (capacity x * qt x t) t) ∧
      (∃ (kappa r : ℝ → ℝ → ℝ) (x t : ℝ),
        deriv (fun τ => kappa x τ * r x τ) t
          ≠ kappa x t * deriv (fun τ => r x τ) t) :=
  ⟨fun x t => hasDerivAt_energy_of_timeIndependent_capacity hqt x t,
   energy_timeDerivative_needs_timeIndependent_capacity⟩

/-- Equation (2.22) is the heat equation in the case of unit heat capacity.

With `κ ≡ 1` the internal energy is the temperature itself, so the conserved
density of (2.25) is the density of (2.22) and the two equations coincide. The
second conjunct is the converse direction of the same fact: unit capacity is
exactly the condition under which the energy and the temperature agree for every
temperature field. -/
theorem leveque02_heatEquationAtUnitCapacity {capacity : ℝ → ℝ} :
    ((∀ x, capacity x = 1) →
        ∀ (q : ℝ → ℝ → ℝ) (x t : ℝ), capacity x * q x t = q x t) ∧
      ((∀ (q : ℝ → ℝ → ℝ) (x t : ℝ), capacity x * q x t = q x t) →
        ∀ x, capacity x = 1) := by
  constructor
  · intro h q x t
    rw [h x, one_mul]
  · intro h x
    simpa using h (fun _ _ => 1) x 0

end NumStability
