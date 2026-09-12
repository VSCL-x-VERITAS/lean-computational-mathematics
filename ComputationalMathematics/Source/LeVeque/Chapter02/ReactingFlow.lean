/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.PartialDifferentialEquations.DiffusiveFlux
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ReactingFlow
import ComputationalMathematics.Source.LeVeque.Chapter01.Hyperbolicity

/-!
# LeVeque Chapter 2, printed page 23: sources that depend on the state

Section 2.5.1 closes with a rod in a bath, and Section 2.5.2 turns to chemical
species advected in a flow. Both examples have sources that depend on the state,
which is what the external heat source of the previous page deliberately did
not.

The reusable mathematics lives in
`ComputationalMathematics.Analysis.PartialDifferentialEquations.ReactingFlow`.
-/

namespace NumStability

/-- A rod immersed in a bath: Newton's law of cooling as a source term.

The printed source is proportional to `q0 - q(x,t)` with the conductivity
between rod and bath as the constant, and the first conjunct is that equation
with the second spatial derivative named as the derivative operator applied
twice. The next three are what the proportionality means physically: the source
vanishes exactly at the bath temperature, and pushes the rod towards the bath
from either side.

The last is the contrast with the external heat source of the previous page.
That example was written `ψ(x,t)` rather than `ψ(q,x,t)`, and this one cannot
be: a source proportional to the difference from the bath depends on the state,
so the difference of two solutions no longer satisfies the source-free law. -/
theorem leveque02_newtonCoolingSource
    {q qt qx qxx : ℝ → ℝ → ℝ} {beta conductivity bath : ℝ}
    (hD : 0 < conductivity)
    (hqx : ∀ x t, HasDerivAt (fun y => q y t) (qx x t) x)
    (hqxx : ∀ x t, HasDerivAt (fun y => qx y t) (qxx x t) x)
    (hlaw : ∀ x t, qt x t + deriv (fun y => diffusiveFlux beta (qx y t)) x
      = newtonCoolingSource conductivity bath (q x t)) (x t : ℝ) :
    (qt x t = beta * qxx x t + conductivity * (bath - q x t) ∧
        qxx x t = deriv (fun y => deriv (fun z => q z t) y) x) ∧
      (∀ v : ℝ, newtonCoolingSource conductivity bath v = 0 ↔ v = bath) ∧
      (∀ v : ℝ, v < bath → 0 < newtonCoolingSource conductivity bath v) ∧
      (∀ v : ℝ, bath < v → newtonCoolingSource conductivity bath v < 0) ∧
      ¬ IsStateIndependentSource
        (fun v _ _ => newtonCoolingSource conductivity bath v) := by
  have hflux : HasDerivAt (fun y => diffusiveFlux beta (qx y t))
      (-beta * qxx x t) x := by
    simpa [diffusiveFlux] using (hqxx x t).const_mul (-beta)
  have hzero := hlaw x t
  rw [hflux.deriv] at hzero
  have hsecond : qxx x t = deriv (fun y => deriv (fun z => q z t) y) x := by
    have hfun : (fun y => deriv (fun z => q z t) y) = fun y => qx y t :=
      funext fun y => (hqx y t).deriv
    rw [hfun, (hqxx x t).deriv]
  refine ⟨⟨?_, hsecond⟩,
    fun v => newtonCoolingSource_eq_zero_iff (ne_of_gt hD),
    fun v hv => newtonCoolingSource_pos_of_lt hD hv,
    fun v hv => newtonCoolingSource_neg_of_gt hD hv,
    newtonCooling_not_isStateIndependentSource (ne_of_gt hD)⟩
  simp only [newtonCoolingSource] at hzero
  linarith

/-- Equation (2.29): the two-isotope decay system.

The printed system gives each species an advection equation with a source, one
losing what the other gains. The first conjunct is the cancellation that makes
those sources a decay: the total concentration satisfies the advection equation
with no source at all, so nothing is created or destroyed overall.

The second is why that is worth stating. Neither species alone is source free
whenever the rate and the decaying concentration are nonzero, so the
conservation is a property of the pair. -/
theorem leveque02_equation29_radioactiveDecaySystem
    {q1 q1t q1x q2t q2x : ℝ → ℝ → ℝ} {speed rate : ℝ}
    (h1 : ∀ x t, q1t x t + speed * q1x x t = -(rate * q1 x t))
    (h2 : ∀ x t, q2t x t + speed * q2x x t = rate * q1 x t) :
    (∀ x t, (q1t x t + q2t x t) + speed * (q1x x t + q2x x t) = 0) ∧
      (∀ first : ℝ, rate ≠ 0 → first ≠ 0 →
        (decaySource rate first).1 ≠ 0 ∧ (decaySource rate first).2 ≠ 0) :=
  ⟨fun x t => decay_total_isSourceFree h1 h2 x t,
   fun _ hr hf => decay_species_not_sourceFree hr hf⟩

/-- The decay system is hyperbolic with a diagonal coefficient matrix.

The source says the system has the form `q_t + A q_x = ψ(q)` with `A` diagonal
and both diagonal entries equal to the advection speed, and that this is a
hyperbolic system with a source term. Hyperbolicity is the Chapter 1 condition,
and it holds of the advection speed on the diagonal in any number of species,
with the standard basis as the eigenbasis.

The source term is what stops this being the plain hyperbolic system of
Chapter 1, and the second conjunct records that the decay source is not
identically zero. -/
theorem leveque02_decaySystemDiagonalHyperbolic (speed : ℝ) :
    (∀ m : ℕ, leveque01IsHyperbolicMatrix
        (Matrix.diagonal (fun _ : Fin m => speed))) ∧
      (∀ rate first : ℝ, rate ≠ 0 → first ≠ 0 →
        decaySource rate first ≠ (0, 0)) := by
  refine ⟨fun m => isRealHyperbolicMatrix_diagonal_const speed, ?_⟩
  intro rate first hr hf hcon
  have := congrArg Prod.snd hcon
  simp only [decaySource] at this
  exact (mul_ne_zero hr hf) this

/-- Equation (2.30): reaction, advection and diffusion together, and the
diffusion coefficient as a matrix.

The source says the coefficient could differ between species, in which case it
is a diagonal matrix rather than a scalar. The claim here is that this widens
the model: a diagonal coefficient acts as one scalar on every state exactly when
all its entries are that scalar, so distinct entries are a genuinely different
equation and not a change of notation. -/
theorem leveque02_diffusionCoefficientMayBeMatrix {m : ℕ}
    (coefficients : Fin m → ℝ) (scalar : ℝ) :
    (∀ (v : Fin m → ℝ) (i : Fin m),
        coefficients i * v i = scalar * v i) ↔ ∀ i, coefficients i = scalar :=
  diagonalDiffusion_eq_scalar_iff coefficients scalar

end NumStability
