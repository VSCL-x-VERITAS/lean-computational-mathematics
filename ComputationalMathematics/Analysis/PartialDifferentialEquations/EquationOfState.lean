/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.PartialDifferentialEquations.GasDynamics
import Mathlib.Analysis.SpecialFunctions.Pow.Deriv

/-!
# Equations of state, and why the mass-momentum system is nonlinear

Printed page 25 of LeVeque's Chapter 2 closes the mass and momentum system by
adding an algebraic relation between pressure and density, and records two things
about the system it has built.

The equations are coupled and nonlinear. Coupling is visible in the statements;
nonlinearity is not something a reader should be asked to take on trust, so it is
proved here: the momentum flux, read as a function of the conserved variables, is
not additive, and a pair of states witnesses that.

The physical realizability assumption is that the pressure rises with the
density. Written as a positive derivative it is a local condition, and what makes
it worth assuming is the global consequence, that the pressure is a strictly
increasing function of the density. That consequence is proved, and the
isentropic law is shown to satisfy the assumption.
-/

namespace NumStability

open Set

/-! ### The isentropic equation of state -/

/-- Equation (2.35): the isentropic equation of state. -/
noncomputable def isentropicPressure (kappa gamma rho : ℝ) : ℝ :=
  kappa * rho ^ gamma

/-- Its derivative, wherever the density is positive. -/
theorem isentropicPressure_hasDerivAt {kappa gamma rho : ℝ} (h : 0 < rho) :
    HasDerivAt (isentropicPressure kappa gamma)
      (kappa * (gamma * rho ^ (gamma - 1))) rho := by
  have hx : rho ≠ 0 := ne_of_gt h
  simpa [isentropicPressure] using
    (Real.hasDerivAt_rpow_const (x := rho) (p := gamma) (Or.inl hx)).const_mul kappa

/-- Equation (2.35) satisfies the realizability assumption (2.37): with a
positive coefficient and a positive exponent the pressure rises with the
density. -/
theorem isentropicPressure_deriv_pos {kappa gamma rho : ℝ}
    (hk : 0 < kappa) (hg : 0 < gamma) (h : 0 < rho) :
    0 < kappa * (gamma * rho ^ (gamma - 1)) :=
  mul_pos hk (mul_pos hg (Real.rpow_pos_of_pos h _))

/-! ### Physical realizability -/

/-- Equation (2.37): an equation of state is physically realistic when its
derivative is positive at every positive density. -/
def IsRealisticEquationOfState (P P' : ℝ → ℝ) : Prop :=
  (∀ rho, 0 < rho → HasDerivAt P (P' rho) rho) ∧ ∀ rho, 0 < rho → 0 < P' rho

/-- The isentropic law is realistic. -/
theorem isRealisticEquationOfState_isentropic {kappa gamma : ℝ}
    (hk : 0 < kappa) (hg : 0 < gamma) :
    IsRealisticEquationOfState (isentropicPressure kappa gamma)
      (fun rho => kappa * (gamma * rho ^ (gamma - 1))) :=
  ⟨fun _ h => isentropicPressure_hasDerivAt h,
   fun _ h => isentropicPressure_deriv_pos hk hg h⟩

/-- What the assumption buys: the pressure is a strictly increasing function of
the density on the positive densities, which is the intuition the source says it
matches. The positive derivative is local; this is the global statement it is
assumed for. -/
theorem strictMonoOn_of_isRealisticEquationOfState {P P' : ℝ → ℝ}
    (h : IsRealisticEquationOfState P P') : StrictMonoOn P (Ioi 0) := by
  obtain ⟨hderiv, hpos⟩ := h
  refine strictMonoOn_of_deriv_pos (convex_Ioi 0) ?_ ?_
  · exact fun rho hrho => ((hderiv rho (mem_Ioi.1 hrho)).differentiableAt).continuousAt.continuousWithinAt
  · intro rho hrho
    rw [interior_Ioi] at hrho
    rw [(hderiv rho (mem_Ioi.1 hrho)).deriv]
    exact hpos rho (mem_Ioi.1 hrho)

/-- The assumption is a restriction: a state law whose pressure falls with the
density fails it, and then the pressure is not increasing. -/
theorem exists_not_isRealisticEquationOfState :
    ∃ P P' : ℝ → ℝ,
      (∀ rho, 0 < rho → HasDerivAt P (P' rho) rho) ∧
        ¬ IsRealisticEquationOfState P P' := by
  refine ⟨fun rho => -rho, fun _ => -1, fun rho _ => by simpa using (hasDerivAt_id rho).neg, ?_⟩
  rintro ⟨-, hpos⟩
  have := hpos 1 one_pos
  norm_num at this

/-! ### What an equation of state assumes -/

/-- The closure the source reaches for when it drops the energy equation: the
pressure is determined by the density alone. -/
def IsentropicClosure (pressure rho : ℝ → ℝ → ℝ) : Prop :=
  ∃ P : ℝ → ℝ, ∀ x t, pressure x t = P (rho x t)

/-- What that closure amounts to, with no function quantifier: wherever the
density agrees the pressure agrees. This is the checkable form of "the pressure
is determined by the density at the point". -/
theorem isentropicClosure_iff (pressure rho : ℝ → ℝ → ℝ) :
    IsentropicClosure pressure rho ↔
      ∀ x t y s, rho x t = rho y s → pressure x t = pressure y s := by
  constructor
  · rintro ⟨P, hP⟩ x t y s hrho
    rw [hP x t, hP y s, hrho]
  · intro h
    classical
    refine ⟨fun r => if hr : ∃ p : ℝ × ℝ, rho p.1 p.2 = r then
      pressure (Classical.choose hr).1 (Classical.choose hr).2 else 0, ?_⟩
    intro x t
    have hex : ∃ p : ℝ × ℝ, rho p.1 p.2 = rho x t := ⟨(x, t), rfl⟩
    show pressure x t = dite _ _ _
    rw [dif_pos hex]
    exact (h _ _ x t (Classical.choose_spec hex)).symm

/-- The closure is a restriction: a pressure that varies where the density does
not is outside it, so assuming an equation of state is an assumption. -/
theorem exists_not_isentropicClosure :
    ∃ pressure rho : ℝ → ℝ → ℝ, ¬ IsentropicClosure pressure rho := by
  refine ⟨fun x _ => x, fun _ _ => 0, ?_⟩
  rw [isentropicClosure_iff]
  intro h
  have := h 0 0 1 0 rfl
  norm_num at this

/-! ### Nonlinearity of the mass-momentum system -/

/-- The momentum flux read as a function of the conserved variables: the
convective part is the squared momentum over the density, and the pressure is a
function of the density. -/
noncomputable def conservedMomentumFlux (P : ℝ → ℝ) (rho momentum : ℝ) : ℝ :=
  momentum * momentum / rho + P rho

/-- The system is nonlinear, and this is the witness. Two states with the same
density and different momenta have a combined momentum flux that is not the sum
of theirs, so the flux is not additive in the conserved variables and no linear
system has these solutions. -/
theorem conservedMomentumFlux_not_additive :
    ∃ (P : ℝ → ℝ) (rho₁ m₁ rho₂ m₂ : ℝ),
      0 < rho₁ ∧ 0 < rho₂ ∧
        conservedMomentumFlux P (rho₁ + rho₂) (m₁ + m₂)
          ≠ conservedMomentumFlux P rho₁ m₁ + conservedMomentumFlux P rho₂ m₂ := by
  refine ⟨fun _ => 0, 1, 0, 1, 2, one_pos, one_pos, ?_⟩
  norm_num [conservedMomentumFlux]

end NumStability
