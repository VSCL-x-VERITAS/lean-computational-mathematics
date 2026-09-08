/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw.BalanceLaw

/-!
# LeVeque Chapter 1, source terms for nonconserved contaminant mass

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,
printed page 4 (raw PDF page 26).
-/

open MeasureTheory

namespace NumStability

/-- Under classical differentiation and integrability hypotheses, a mass rate
different from boundary transport requires a nonzero internal source. The scalar
contaminant is represented in one component and the transport speed is constant. -/
theorem leveque01_nonconservation_requires_sourceTerm
    (q : ℝ → ℝ → (Fin 1 → ℝ)) (speed : ℝ)
    (qt qx : ℝ → (Fin 1 → ℝ)) (a b t : ℝ) (massRate : Fin 1 → ℝ)
    (hqt : ∀ x, HasDerivAt (fun τ => q x τ) (qt x) t)
    (hqx : ∀ x, HasDerivAt (fun ξ => q ξ t) (qx x) x)
    (hqtIntegrable : IntervalIntegrable qt volume a b)
    (hqxIntegrable : IntervalIntegrable qx volume a b)
    (hmassRate : HasDerivAt (fun τ => ∫ x in a..b, q x τ) massRate t)
    (hinterchange : HasDerivAt (fun τ => ∫ x in a..b, q x τ) (∫ x in a..b, qt x) t)
    (hdefect : massRate ≠ speed • q a t - speed • q b t) :
    ∃ production : ℝ → (Fin 1 → ℝ),
      (∀ x, IsBalanceLawSolutionAt q (fun state => speed • state) (production x) x t) ∧
      IntervalIntegrable production volume a b ∧
      (∫ x in a..b, production x) = massRate - (speed • q a t - speed • q b t) ∧
      production ≠ 0 ∧ ¬ (∀ x, IsConservationLawSolutionAt q (fun state => speed • state) x t) :=
  nonconservation_requires_nonzero_source q (fun state => speed • state) qt
    (fun x => speed • qx x) a b t massRate hqt
    (fun x => (hqx x).const_smul speed) hqtIntegrable (hqxIntegrable.smul speed)
    hmassRate hinterchange hdefect

/-- Unit production with zero transport provides an actual application:
the mass of a unit cell changes and the source has a nonzero integral. -/
theorem leveque01_sourceTerm_unitProduction (t : ℝ) :
    (∀ x, IsBalanceLawSolutionAt
      (fun (_x : ℝ) (τ : ℝ) (_i : Fin 1) => τ)
      (fun (_state : Fin 1 → ℝ) => 0) (fun _ => 1) x t) ∧
    HasDerivAt (fun τ => ∫ _x in (0 : ℝ)..1, (fun _i : Fin 1 => τ))
      (fun _ => 1) t ∧
    (∫ _x in (0 : ℝ)..1, (fun _i : Fin 1 => (1 : ℝ))) ≠ 0 :=
  uniform_unit_production_nonvacuity t

end NumStability
