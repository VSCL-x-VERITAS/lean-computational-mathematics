/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.PartialDifferentialEquations.DifferentialForm
import ComputationalMathematics.Analysis.PartialDifferentialEquations.EquationOfState

/-!
# LeVeque Chapter 2, printed page 25: closing the system

The momentum balance of the previous page becomes a differential equation, the
pair is observed to be coupled and nonlinear, and an algebraic relation between
pressure and density is added to close it.

The reusable mathematics lives in
`ComputationalMathematics.Analysis.PartialDifferentialEquations.EquationOfState`
and its imports.
-/

namespace NumStability

/-- Equation (2.34): conservation of momentum in differential form.

The source assumes the density, the velocity and the pressure are all smooth and
obtains the pointwise equation from the momentum balance. That derivation is the
page 17 derivation with the momentum density in place of the tracer density and
the momentum flux in place of the tracer flux, so it is reused rather than
repeated, with the same four costs carried as named hypotheses.

The second conjunct names the flux the equation is taken against, so the row
says the differentiated quantity is `ρu² + p` rather than an abstract field. -/
theorem leveque02_equation34_momentumEquation
    {rho u pressure mt Fx : ℝ → ℝ → ℝ}
    (hcomm : CommutesWithSectionIntegral (fun x t => rho x t * u x t) mt)
    (hbalance : IsSectionBalance (fun x t => rho x t * u x t)
      (momentumFlux rho u pressure))
    (hflux : ∀ t x₁ x₂, ∀ x ∈ Set.uIcc x₁ x₂,
      HasDerivAt (fun y => momentumFlux rho u pressure y t) (Fx x t) x)
    (hfluxint : ∀ t x₁ x₂,
      IntervalIntegrable (fun x => Fx x t) MeasureTheory.volume x₁ x₂)
    (hcontm : ∀ t, Continuous fun x => mt x t)
    (hcontF : ∀ t, Continuous fun x => Fx x t) :
    (∀ x t, mt x t + Fx x t = 0) ∧
      (∀ x t, momentumFlux rho u pressure x t
        = rho x t * u x t * u x t + pressure x t) :=
  ⟨fun x t => differentialForm_of_sectionBalance hcomm hbalance hflux hfluxint
     hcontm hcontF x t,
   fun _ _ => rfl⟩

/-- Equations (2.32) and (2.34) are coupled and nonlinear.

Coupling is visible in the equations: the mass flux is the momentum density and
the momentum flux is built from both. Nonlinearity is not visible, and the
source states it without argument, so it is proved here. Read as a function of
the conserved variables the momentum flux is not additive, and two states with
the same density and different momenta witness it. No linear system has these
fluxes. -/
theorem leveque02_massMomentumCoupledNonlinear :
    (∀ (rho u : ℝ → ℝ → ℝ) (x t : ℝ),
        advectiveFlux u (rho x t) x t = u x t * rho x t) ∧
      (∀ (rho u pressure : ℝ → ℝ → ℝ) (x t : ℝ),
        momentumFlux rho u pressure x t
          = rho x t * u x t * u x t + pressure x t) ∧
      (∃ (P : ℝ → ℝ) (rho₁ m₁ rho₂ m₂ : ℝ),
        0 < rho₁ ∧ 0 < rho₂ ∧
          conservedMomentumFlux P (rho₁ + rho₂) (m₁ + m₂)
            ≠ conservedMomentumFlux P rho₁ m₁
              + conservedMomentumFlux P rho₂ m₂) :=
  ⟨fun _ _ _ _ => rfl, fun _ _ _ _ _ => rfl,
   conservedMomentumFlux_not_additive⟩

/-- The isentropic flow assumption.

The source says that with no shock waves present the entropy may be taken
constant, and that such a flow lets the pressure be determined from the density
alone. The physical premise is not formalizable here, but what it is assumed
*for* is, and that is the first conjunct: the pressure being a function of the
density is exactly the condition that equal densities carry equal pressures,
with no function quantifier left in the statement.

The second conjunct is that this is an assumption rather than a description: a
pressure that varies where the density does not is outside the class. -/
theorem leveque02_isentropicFlowAssumption :
    (∀ pressure rho : ℝ → ℝ → ℝ,
        IsentropicClosure pressure rho ↔
          ∀ x t y s, rho x t = rho y s → pressure x t = pressure y s) ∧
      (∃ pressure rho : ℝ → ℝ → ℝ, ¬ IsentropicClosure pressure rho) :=
  ⟨fun pressure rho => isentropicClosure_iff pressure rho,
   exists_not_isentropicClosure⟩

/-- Equation (2.35): the isentropic equation of state.

The first conjunct is the printed formula. The second and third are its
derivative and the positivity of that derivative, which is what connects this
particular law to the realizability assumption (2.37) printed two lines below
it. -/
theorem leveque02_equation35_isentropicEquationOfState
    {kappa gamma : ℝ} (hk : 0 < kappa) (hg : 0 < gamma) :
    (∀ rho : ℝ, isentropicPressure kappa gamma rho = kappa * rho ^ gamma) ∧
      (∀ rho : ℝ, 0 < rho → HasDerivAt (isentropicPressure kappa gamma)
        (kappa * (gamma * rho ^ (gamma - 1))) rho) ∧
      (∀ rho : ℝ, 0 < rho → 0 < kappa * (gamma * rho ^ (gamma - 1))) :=
  ⟨fun _ => rfl,
   fun _ h => isentropicPressure_hasDerivAt h,
   fun _ h => isentropicPressure_deriv_pos hk hg h⟩

/-- Equation (2.36): a general equation of state.

The printed form `p = P(ρ)` is the closure of the previous row, and the row says
so rather than restating the formula: a pressure field is of that form exactly
when it is determined pointwise by the density. -/
theorem leveque02_equation36_generalEquationOfState (pressure rho : ℝ → ℝ → ℝ) :
    (∃ P : ℝ → ℝ, ∀ x t, pressure x t = P (rho x t)) ↔
      ∀ x t y s, rho x t = rho y s → pressure x t = pressure y s :=
  isentropicClosure_iff pressure rho

/-- Equation (2.37): the physical realizability assumption.

The printed assumption is that `P'(ρ) > 0` for positive `ρ`, and the source's
reason is that increasing the density should increase the pressure. That reason
is the first conjunct, proved rather than asserted: a positive derivative on the
positive densities makes the pressure strictly increasing there, which is a
global statement the local assumption buys.

The second conjunct shows the assumption excludes something, so it is a
hypothesis and not a description of every state law. -/
theorem leveque02_equation37_pressureMonotonicity :
    (∀ P P' : ℝ → ℝ, IsRealisticEquationOfState P P' →
        StrictMonoOn P (Set.Ioi 0)) ∧
      (∃ P P' : ℝ → ℝ,
        (∀ rho, 0 < rho → HasDerivAt P (P' rho) rho) ∧
          ¬ IsRealisticEquationOfState P P') :=
  ⟨fun _ _ h => strictMonoOn_of_isRealisticEquationOfState h,
   exists_not_isRealisticEquationOfState⟩

/-- The isentropic equation of state satisfies the monotonicity assumption.

The source notes this in passing; here it is the conclusion, and the strict
increase of the pressure with the density follows for that law in particular. -/
theorem leveque02_isentropicStateIsMonotone {kappa gamma : ℝ}
    (hk : 0 < kappa) (hg : 0 < gamma) :
    IsRealisticEquationOfState (isentropicPressure kappa gamma)
        (fun rho => kappa * (gamma * rho ^ (gamma - 1))) ∧
      StrictMonoOn (isentropicPressure kappa gamma) (Set.Ioi 0) :=
  ⟨isRealisticEquationOfState_isentropic hk hg,
   strictMonoOn_of_isRealisticEquationOfState
     (isRealisticEquationOfState_isentropic hk hg)⟩

end NumStability
