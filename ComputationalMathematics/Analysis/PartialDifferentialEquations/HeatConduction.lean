/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.PartialDifferentialEquations.DiffusiveFlux

/-!
# Diffusion with a varying coefficient, and heat conduction

Printed page 21 of LeVeque's Chapter 2 lets the diffusion coefficient vary in
space, combines diffusion with advection, and then reads the whole discussion
again for heat, where the conserved quantity is not the temperature but the
internal energy.

Two things in that passage need care.

The internal energy density is `κ(x) q(x,t)`, a product of a material property
with the temperature. Writing that product down and calling it the energy would
make the identification true by definition and say nothing. Instead the
properties an energy density must have relative to a temperature field are
stated, and the product is *derived* from them: an assignment that is local in
the temperature, homogeneous in it, and equal to the heat capacity on a unit
temperature is necessarily that product.

Fourier's law and Fick's law look identical on the page, and the source says
they differ once the heat capacity varies. The difference is that Fourier makes
the *energy* flux proportional to the *temperature* gradient, while Fick makes
the flux proportional to the gradient of the conserved quantity itself. The
theorem below is that the two agree for every temperature field exactly when the
heat capacity is identically one, which is the condition the source names.
-/

namespace NumStability

/-! ### The internal energy density -/

/-- The properties an internal-energy density must have relative to a heat
capacity: it is determined pointwise by the temperature there, it scales with
the temperature, and a unit temperature carries an energy equal to the capacity.

Stating these instead of writing the product is what lets the identification be
a theorem. -/
structure IsInternalEnergyDensity
    (E : (ℝ → ℝ → ℝ) → ℝ → ℝ → ℝ) (capacity : ℝ → ℝ) : Prop where
  /-- The energy at a point depends on the temperature only through its value
  there. -/
  localInTemperature : ∀ q r x t, q x t = r x t → E q x t = E r x t
  /-- Scaling the temperature scales the energy. -/
  homogeneous : ∀ (c : ℝ) q x t, E (fun y s => c * q y s) x t = c * E q x t
  /-- A unit temperature carries the heat capacity as its energy. -/
  unitTemperature : ∀ x t, E (fun _ _ => 1) x t = capacity x

/-- The internal energy density is the product of the heat capacity with the
temperature, and it could not have been anything else.

This is the printed identification, obtained rather than assumed. -/
theorem IsInternalEnergyDensity.eq_capacity_mul
    {E : (ℝ → ℝ → ℝ) → ℝ → ℝ → ℝ} {capacity : ℝ → ℝ}
    (h : IsInternalEnergyDensity E capacity) (q : ℝ → ℝ → ℝ) (x t : ℝ) :
    E q x t = capacity x * q x t := by
  have hconst : E q x t = E (fun _ _ => q x t) x t :=
    h.localInTemperature q (fun _ _ => q x t) x t rfl
  have hscale : E (fun y s => q x t * (fun _ _ => (1 : ℝ)) y s) x t
      = q x t * E (fun _ _ => (1 : ℝ)) x t := h.homogeneous (q x t) _ x t
  rw [hconst]
  simpa [h.unitTemperature x t, mul_comm] using hscale

/-- The property package is satisfiable, and by the product itself. Without this
the determination theorem above could be about an empty class. -/
theorem isInternalEnergyDensity_capacity_mul (capacity : ℝ → ℝ) :
    IsInternalEnergyDensity (fun q x t => capacity x * q x t) capacity where
  localInTemperature := by
    intro q r x t h
    simp [h]
  homogeneous := by
    intro c q x t
    ring
  unitTemperature := by
    intro x t
    simp

/-- The package is a restriction: an assignment that ignores the temperature
fails it whenever some capacity is nonzero. -/
theorem exists_not_isInternalEnergyDensity {capacity : ℝ → ℝ} {x₀ : ℝ}
    (h : capacity x₀ ≠ 0) :
    ¬ IsInternalEnergyDensity (fun _ _ _ => 0) capacity := by
  intro hE
  exact h ((hE.unitTemperature x₀ 0).symm)

/-! ### Fourier's law against Fick's law -/

/-- Fourier's law and Fick's law agree for every temperature field exactly when
the heat capacity is identically one.

Fourier makes the energy flux proportional to the gradient of the temperature;
Fick would make it proportional to the gradient of the conserved quantity, which
here is the energy `κ q` and whose gradient carries the extra term `κ'(x) q`.
Requiring the two to coincide for every field forces the capacity to be constant
and then to be one, which is exactly the case the source singles out. -/
theorem fourierFlux_eq_fickFlux_iff_capacity_one
    {beta : ℝ} {capacity capacity' : ℝ → ℝ} (hbeta : beta ≠ 0)
    (hcap : ∀ x, HasDerivAt capacity (capacity' x) x) :
    (∀ (q qx : ℝ → ℝ → ℝ),
        (∀ x t, HasDerivAt (fun y => q y t) (qx x t) x) →
        ∀ x t, diffusiveFlux beta (qx x t)
          = diffusiveFlux beta (capacity' x * q x t + capacity x * qx x t))
      ↔ ∀ x, capacity x = 1 := by
  constructor
  · intro hagree x
    have hone := hagree (fun _ _ => 1) (fun _ _ => 0)
      (fun y s => by simpa using hasDerivAt_const y (1 : ℝ)) x 0
    have hcap' : capacity' x = 0 := by
      simp only [diffusiveFlux, mul_one, mul_zero, add_zero, mul_zero] at hone
      have hz : beta * capacity' x = 0 := by linarith
      rcases mul_eq_zero.1 hz with hb | hc
      · exact absurd hb hbeta
      · exact hc
    have hid := hagree (fun y _ => y) (fun _ _ => 1)
      (fun y s => by simpa using hasDerivAt_id y) x 0
    simp only [diffusiveFlux, hcap', zero_mul, zero_add, mul_one] at hid
    field_simp at hid
    linarith
  · intro hone q qx _ x t
    have hconst : capacity' x = 0 := by
      have hc : HasDerivAt capacity 0 x := by
        have : capacity = fun _ => (1 : ℝ) := funext hone
        rw [this]
        simpa using hasDerivAt_const x (1 : ℝ)
      exact (hcap x).unique hc
    simp [diffusiveFlux, hconst, hone x]

end NumStability
