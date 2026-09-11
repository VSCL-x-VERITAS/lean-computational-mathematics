/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ScalarFlux

/-!
# What kind of equation the advection equation is

Printed page 17 of LeVeque's Chapter 2 specialises the differential conservation
law to the flux `f(q) = ū q` and then classifies the result in one sentence: it
is a scalar, linear, constant-coefficient partial differential equation of
hyperbolic type.

Each of those four words is a checkable property, and none of them is carried by
an identifier. This module supplies the two that are about the equation's
*structure* rather than its dimension or its spectrum:

* **linear** -- the solutions at a point are closed under addition and under
  scaling, and the class is not merely the zero function;
* **constant-coefficient** -- the equation is the constant case of the general
  variable-coefficient advection equation, and its solution set is invariant
  under translation in space and in time. The invariance is what separates a
  constant coefficient from a variable one: a witness below exhibits a
  variable-coefficient equation whose solutions are *not* translation invariant,
  so the property is a restriction rather than a restatement.

The remaining two words are reused rather than reproved: "scalar" is the
one-component specialisation already established for the Chapter 1 advection
equation, and "hyperbolic type" is the Chapter 1 hyperbolicity of the
one-by-one coefficient matrix.

The specialisation of the conservation law to the flux (2.5) is also here,
stated as an equivalence, because the source says the law "becomes" the
advection equation and that is a two-way claim.
-/

namespace NumStability

/-! ### The flux (2.5) differentiates through a density profile -/

/-- The `x`-derivative of the composed flux `f(q(x,t))` for `f(q) = ū q`.

This is the one computation that turns the conservation law into the advection
equation: the constant multiple passes through the derivative, so the flux
derivative is `ū` times the density derivative. -/
theorem uniformAdvectiveFlux_hasDerivAt {g : ℝ → ℝ} {g' speed x t : ℝ}
    (h : HasDerivAt g g' x) :
    HasDerivAt (fun y => uniformAdvectiveFlux speed (g y) y t) (speed * g') x := by
  simpa [uniformAdvectiveFlux] using h.const_mul speed

/-- Equation (2.12): for the flux `f(q) = ū q`, the differential conservation
law and the advection equation are the same condition at every point.

The source writes that the law "becomes" the advection equation. That is an
equivalence, and stating it as one is what keeps the step from being a one-way
weakening: neither form says more than the other once the two derivative
families are fixed. -/
theorem advectionEquation_iff_uniformFluxLaw
    {q qt qx : ℝ → ℝ → ℝ} {speed : ℝ}
    (hqt : ∀ x t, HasDerivAt (fun τ => q x τ) (qt x t) t)
    (hqx : ∀ x t, HasDerivAt (fun y => q y t) (qx x t) x)
    (x t : ℝ) :
    (qt x t + deriv (fun y => uniformAdvectiveFlux speed (q y t) y t) x = 0)
      ↔ IsLinearAdvectionSolutionAt q speed x t := by
  have hd :
      deriv (fun y => uniformAdvectiveFlux speed (q y t) y t) x = speed * qx x t :=
    (uniformAdvectiveFlux_hasDerivAt (hqx x t)).deriv
  rw [hd]
  constructor
  · intro h
    exact ⟨qt x t, qx x t, hqt x t, hqx x t, by simpa [smul_eq_mul] using h⟩
  · rintro ⟨a, b, ha, hb, hres⟩
    have h1 : a = qt x t := ha.unique (hqt x t)
    have h2 : b = qx x t := hb.unique (hqx x t)
    rw [h1, h2] at hres
    simpa [smul_eq_mul] using hres

/-- The advection equation written with named partial-derivative families, which
is how the source prints it: `q_t + ū q_x = 0`.

Uniqueness of derivatives is what lets the existential in the solution predicate
be replaced by the two named families, so the printed subscript form and the
predicate are interchangeable once those families are fixed. -/
theorem advectionSolution_iff_residual {q qt qx : ℝ → ℝ → ℝ} {speed : ℝ}
    (hqt : ∀ x t, HasDerivAt (fun τ => q x τ) (qt x t) t)
    (hqx : ∀ x t, HasDerivAt (fun y => q y t) (qx x t) x) (x t : ℝ) :
    IsLinearAdvectionSolutionAt q speed x t ↔ qt x t + speed * qx x t = 0 := by
  constructor
  · rintro ⟨a, b, ha, hb, hres⟩
    have h1 : a = qt x t := ha.unique (hqt x t)
    have h2 : b = qx x t := hb.unique (hqx x t)
    rw [h1, h2] at hres
    simpa [smul_eq_mul] using hres
  · intro h
    exact ⟨qt x t, qx x t, hqt x t, hqx x t, by simpa [smul_eq_mul] using h⟩

/-! ### Linear -/

section Linearity

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]

/-- The sum of two solutions is a solution. -/
theorem isLinearAdvectionSolutionAt_add {q r : ℝ → ℝ → E} {speed x t : ℝ}
    (hq : IsLinearAdvectionSolutionAt q speed x t)
    (hr : IsLinearAdvectionSolutionAt r speed x t) :
    IsLinearAdvectionSolutionAt (fun ξ τ => q ξ τ + r ξ τ) speed x t := by
  obtain ⟨a, b, ha, hb, hab⟩ := hq
  obtain ⟨c, d, hc, hd, hcd⟩ := hr
  refine ⟨a + c, b + d, ha.add hc, hb.add hd, ?_⟩
  have hsplit : a + c + speed • (b + d) = (a + speed • b) + (c + speed • d) := by
    rw [smul_add]
    abel
  rw [hsplit, hab, hcd, add_zero]

/-- A scalar multiple of a solution is a solution. -/
theorem isLinearAdvectionSolutionAt_smul {q : ℝ → ℝ → E} {speed x t : ℝ} (c : ℝ)
    (hq : IsLinearAdvectionSolutionAt q speed x t) :
    IsLinearAdvectionSolutionAt (fun ξ τ => c • q ξ τ) speed x t := by
  obtain ⟨a, b, ha, hb, hab⟩ := hq
  refine ⟨c • a, c • b, ha.const_smul c, hb.const_smul c, ?_⟩
  have hsplit : c • a + speed • c • b = c • (a + speed • b) := by
    rw [smul_add, smul_comm c speed b]
  rw [hsplit, hab, smul_zero]

/-- The zero density solves the equation, so the solution set is a genuine
linear subspace of the functions rather than merely closed under the two
operations. -/
theorem isLinearAdvectionSolutionAt_zero (speed x t : ℝ) :
    IsLinearAdvectionSolutionAt (fun _ _ => (0 : E)) speed x t := by
  refine ⟨0, 0, ?_, ?_, by simp⟩
  · simpa using (hasDerivAt_const t (0 : E))
  · simpa using (hasDerivAt_const x (0 : E))

end Linearity

/-- The solution class contains a profile whose spatial derivative vanishes
nowhere, so the linear subspace of solutions is not exhausted by the constants.

The data are exhibited as one existential outside every binder, and the guard is
that the spatial derivative is nonzero at *every* point rather than merely
somewhere. A guard of the weaker kind is satisfied by any nonzero constant,
which solves the equation for every speed and certifies nothing about
propagation; this one forces a genuinely non-constant solution. -/
theorem exists_isLinearAdvectionSolution_nonconstant (speed : ℝ) :
    ∃ q qt qx : ℝ → ℝ → ℝ,
      (∀ x t, HasDerivAt (fun τ => q x τ) (qt x t) t) ∧
        (∀ x t, HasDerivAt (fun y => q y t) (qx x t) x) ∧
        (∀ x t, IsLinearAdvectionSolutionAt q speed x t) ∧
        (∀ x t, qx x t ≠ 0) ∧
        ¬ ∃ c : ℝ, ∀ x t, q x t = c := by
  refine ⟨fun x t => x - speed * t, fun _ _ => -speed, fun _ _ => 1, ?_, ?_, ?_,
    fun _ _ => one_ne_zero, ?_⟩
  · intro x t
    simpa using ((hasDerivAt_id t).const_mul speed).const_sub x
  · intro x t
    simpa using (hasDerivAt_id x).sub_const (speed * t)
  · intro x t
    refine ⟨-speed, 1, ?_, ?_, by simp⟩
    · simpa using ((hasDerivAt_id t).const_mul speed).const_sub x
    · simpa using (hasDerivAt_id x).sub_const (speed * t)
  · rintro ⟨c, hc⟩
    have h0 : (0 : ℝ) - speed * 0 = c := hc 0 0
    have h1 : (1 : ℝ) - speed * 0 = c := hc 1 0
    rw [← h0] at h1
    norm_num at h1

/-! ### Constant-coefficient -/

/-- The advection equation with a coefficient that may depend on position and
time. The constant-coefficient equation of the source is the special case where
this coefficient is a constant function. -/
def IsAdvectionSolutionWithCoefficientAt
    (q : ℝ → ℝ → ℝ) (c : ℝ → ℝ → ℝ) (x t : ℝ) : Prop :=
  ∃ qt qx : ℝ, HasDerivAt (fun τ => q x τ) qt t ∧
    HasDerivAt (fun ξ => q ξ t) qx x ∧ qt + c x t * qx = 0

/-- "Constant-coefficient", spelled out: the equation of the source is exactly
the variable-coefficient equation with a coefficient that does not vary. -/
theorem isLinearAdvectionSolutionAt_iff_constantCoefficient
    (q : ℝ → ℝ → ℝ) (speed x t : ℝ) :
    IsLinearAdvectionSolutionAt q speed x t ↔
      IsAdvectionSolutionWithCoefficientAt q (fun _ _ => speed) x t := by
  constructor <;> rintro ⟨a, b, ha, hb, hres⟩ <;>
    exact ⟨a, b, ha, hb, by simpa [smul_eq_mul] using hres⟩

/-- A constant coefficient makes the solution set invariant under translation in
space and in time: shifting a solution's arguments produces a solution at the
correspondingly shifted point. -/
theorem isLinearAdvectionSolutionAt_translate
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    {q : ℝ → ℝ → E} {speed x t a b : ℝ}
    (h : IsLinearAdvectionSolutionAt q speed (x + a) (t + b)) :
    IsLinearAdvectionSolutionAt (fun ξ τ => q (ξ + a) (τ + b)) speed x t := by
  obtain ⟨qt, qx, ht, hx, hres⟩ := h
  refine ⟨qt, qx, ?_, ?_, hres⟩
  · have hshift : HasDerivAt (fun τ : ℝ => τ + b) 1 t := by
      simpa using (hasDerivAt_id t).add_const b
    simpa [Function.comp_def] using ht.scomp t hshift
  · have hshift : HasDerivAt (fun ξ : ℝ => ξ + a) 1 x := by
      simpa using (hasDerivAt_id x).add_const a
    simpa [Function.comp_def] using hx.scomp x hshift

/-- Translation invariance is a real consequence of the coefficient being
constant, not a property every advection equation has.

The witness is the equation with coefficient `c(x,t) = x`. The profile
`q(x,t) = x - t` solves it at the station `x = 1`, where the coefficient happens
to equal one; its translate by one unit does not solve it at the corresponding
station `x = 0`, where the coefficient is zero. So "constant-coefficient" is a
restriction on the equation and not a description of how it is written. -/
theorem variableCoefficient_not_translationInvariant :
    ∃ (q : ℝ → ℝ → ℝ) (c : ℝ → ℝ → ℝ) (a : ℝ),
      IsAdvectionSolutionWithCoefficientAt q c 1 0 ∧
        ¬ IsAdvectionSolutionWithCoefficientAt
            (fun ξ τ => q (ξ + a) τ) c 0 0 := by
  refine ⟨fun x t => x - t, fun x _ => x, 1, ⟨-1, 1, ?_, ?_, by norm_num⟩, ?_⟩
  · simpa using (hasDerivAt_id (0 : ℝ)).const_sub (1 : ℝ)
  · simpa using (hasDerivAt_id (1 : ℝ)).sub_const (0 : ℝ)
  · rintro ⟨a, b, ha, _, hres⟩
    have hqt : HasDerivAt (fun τ : ℝ => (0 + 1 : ℝ) - τ) (-1) 0 := by
      simpa using (hasDerivAt_id (0 : ℝ)).const_sub ((0 : ℝ) + 1)
    have heq : a = -1 := ha.unique hqt
    rw [heq] at hres
    norm_num at hres

end NumStability
