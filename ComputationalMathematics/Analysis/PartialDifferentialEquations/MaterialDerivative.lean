/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.PartialDifferentialEquations.VariableCoefficientAdvection

/-!
# Differentiating along a characteristic curve

Printed page 20 of LeVeque's Chapter 2 follows a density along a characteristic
of a variable-coefficient flow and finds that it is no longer constant. The
printed calculation is a chain of four expressions, and this module supplies
each link.

The first link is the chain rule for a curve that need not be straight, which is
what the constant-velocity case of page 18 could take for granted. The second
replaces the curve's velocity by the fluid velocity, which is what makes the
curve characteristic. The third rewrites the advective term through the
conservative one, and it is here that the extra term of a varying velocity
appears. The fourth uses the conservation law to kill the first two terms.

The operator the source names the material derivative is the first link read as
an operator: it differentiates along the trajectory of a particle carried by the
fluid.

The same calculation run on the nonconservative equation gives zero instead, so
its solutions are constant along characteristics while those of the conservative
equation are not. That contrast is the point of the printed page, and it is
stated here as two theorems rather than as a remark.
-/

namespace NumStability

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]

/-- The chain rule along an arbitrary differentiable curve.

This is the material derivative in its general form: the rate of change a
traveller on the curve observes is the partial derivative in time plus the
curve's velocity times the partial derivative in space. -/
theorem hasDerivAt_along_curve
    {q : ℝ → ℝ → E} {X : ℝ → ℝ} {X' : ℝ} {qt qx : E} {t : ℝ}
    (hq : DifferentiableAt ℝ (Function.uncurry q) (X t, t))
    (hX : HasDerivAt X X' t)
    (ht : HasDerivAt (fun τ => q (X t) τ) qt t)
    (hx : HasDerivAt (fun ξ => q ξ t) qx (X t)) :
    HasDerivAt (fun τ => q (X τ) τ) (qt + X' • qx) t := by
  let F := fderiv ℝ (Function.uncurry q) (X t, t)
  have hF : HasFDerivAt (Function.uncurry q) F (X t, t) := hq.hasFDerivAt
  have hspace : HasDerivAt (fun ξ : ℝ => (ξ, t)) ((1 : ℝ), (0 : ℝ)) (X t) :=
    (hasDerivAt_id (X t)).prodMk (hasDerivAt_const (X t) t)
  have htime : HasDerivAt (fun τ : ℝ => (X t, τ)) ((0 : ℝ), (1 : ℝ)) t :=
    (hasDerivAt_const t (X t)).prodMk (hasDerivAt_id t)
  have hcurve : HasDerivAt (fun τ : ℝ => (X τ, τ)) (X', (1 : ℝ)) t :=
    hX.prodMk (hasDerivAt_id t)
  have hx' : HasDerivAt (fun ξ => q ξ t) (F (1, 0)) (X t) := by
    simpa only [Function.comp_def, Function.uncurry_apply_pair] using
      hF.comp_hasDerivAt (X t) hspace
  have ht' : HasDerivAt (fun τ => q (X t) τ) (F (0, 1)) t := by
    simpa only [Function.comp_def, Function.uncurry_apply_pair] using
      hF.comp_hasDerivAt t htime
  have hpair : (X', (1 : ℝ)) = X' • ((1 : ℝ), 0) + (0, 1) := by
    ext <;> simp
  have hvalue : F (X', 1) = qt + X' • qx := by
    rw [hpair, map_add, map_smul, hx'.unique hx, ht'.unique ht, add_comm]
  simpa only [Function.comp_def, Function.uncurry_apply_pair, hvalue] using
    hF.comp_hasDerivAt (f := fun τ : ℝ => (X τ, τ)) t hcurve

/-- The material derivative along a characteristic: the curve's velocity in the
chain rule is the fluid velocity at the point the curve has reached. -/
theorem hasDerivAt_along_characteristicCurve
    {q : ℝ → ℝ → ℝ} {u : ℝ → ℝ} {X : ℝ → ℝ} {qt qx : ℝ} {t : ℝ}
    (hX : IsCharacteristicCurve u X)
    (hq : DifferentiableAt ℝ (Function.uncurry q) (X t, t))
    (ht : HasDerivAt (fun τ => q (X t) τ) qt t)
    (hx : HasDerivAt (fun ξ => q ξ t) qx (X t)) :
    HasDerivAt (fun τ => q (X τ) τ) (qt + u (X t) * qx) t := by
  simpa [smul_eq_mul] using hasDerivAt_along_curve hq (hX t) ht hx

/-- Equation (2.18): along a characteristic of a variable-coefficient
conservation law, the density decays at the rate the velocity spreads it.

The three equalities of the printed chain are the three conjuncts. The first is
the chain rule with the fluid velocity substituted; the second rewrites the
advective term through the conservative one, which is where the term `u'(x) q`
enters; the third applies the conservation law (2.16) and leaves `-u'(X(t)) q`.

When the velocity is constant the last term vanishes and the density is constant
along the curve, which is the page 18 picture; when it is not, the curve is no
longer straight and the density no longer constant, but an ordinary differential
equation along the curve has replaced the partial one. -/
theorem characteristic_materialDerivative_of_conservationLaw
    {q qt qx Fx : ℝ → ℝ → ℝ} {u u' : ℝ → ℝ} {X : ℝ → ℝ} {t : ℝ}
    (hX : IsCharacteristicCurve u X)
    (hq : DifferentiableAt ℝ (Function.uncurry q) (X t, t))
    (hqt : ∀ x s, HasDerivAt (fun τ => q x τ) (qt x s) s)
    (hqx : ∀ x s, HasDerivAt (fun ξ => q ξ s) (qx x s) x)
    (hu : ∀ x, HasDerivAt u (u' x) x)
    (hFx : ∀ x s, HasDerivAt (fun y => u y * q y s) (Fx x s) x)
    (hlaw : ∀ x s, qt x s + Fx x s = 0) :
    HasDerivAt (fun τ => q (X τ) τ)
        (qt (X t) t + u (X t) * qx (X t) t) t ∧
      qt (X t) t + u (X t) * qx (X t) t
        = qt (X t) t + Fx (X t) t - u' (X t) * q (X t) t ∧
      qt (X t) t + u (X t) * qx (X t) t = -(u' (X t) * q (X t) t) := by
  have hchain := hasDerivAt_along_characteristicCurve hX hq (hqt (X t) t)
    (hqx (X t) t)
  have hprod : Fx (X t) t = u' (X t) * q (X t) t + u (X t) * qx (X t) t :=
    (hFx (X t) t).unique (variableFlux_hasDerivAt (hu (X t)) (hqx (X t) t))
  refine ⟨hchain, by rw [hprod]; ring, ?_⟩
  have hzero := hlaw (X t) t
  rw [hprod] at hzero
  linarith

/-- Equation (2.19): for the nonconservative advection equation the same
calculation gives zero, so the density *is* constant along characteristics.

This is the contrast the source draws. The two equations differ by the term
`u'(x) q`, and that term is exactly what decides whether a particle carries its
density unchanged. -/
theorem characteristic_constant_of_nonconservative
    {q qt qx : ℝ → ℝ → ℝ} {u : ℝ → ℝ} {X : ℝ → ℝ}
    (hX : IsCharacteristicCurve u X)
    (hq : ∀ t, DifferentiableAt ℝ (Function.uncurry q) (X t, t))
    (hqt : ∀ x s, HasDerivAt (fun τ => q x τ) (qt x s) s)
    (hqx : ∀ x s, HasDerivAt (fun ξ => q ξ s) (qx x s) x)
    (hlaw : ∀ x s, qt x s + u x * qx x s = 0) :
    ∀ t, q (X t) t = q (X 0) 0 := by
  have hd : ∀ t, HasDerivAt (fun τ => q (X τ) τ) 0 t := by
    intro t
    have hchain := hasDerivAt_along_characteristicCurve hX (hq t) (hqt (X t) t)
      (hqx (X t) t)
    rwa [hlaw (X t) t] at hchain
  intro t
  simpa using is_const_of_deriv_eq_zero (fun τ => (hd τ).differentiableAt)
    (fun τ => (hd τ).deriv) t 0

end NumStability
