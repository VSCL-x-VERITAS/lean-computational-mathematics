/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage

/-!
# LeVeque equation (4.3): normalization of finite physical integral data

The displayed source proof rearranges the unnormalized integrated physical
balance and divides by the cell width. Partial integration operators allow this
step to apply to every chosen meaningful finite source integral interpretation.
Undefined integrals receive no default value. Arbitrary successful operator data
are an algebraic extension, not certification of a physical integration theory.

This source wrapper does not derive integrated conservation from the derivative
notation in (4.2), nor impose a classical or generalized derivative convention.
-/

namespace NumStability

/-- Integration-theory-independent form of the displayed derivation of (4.3).
The supplied partial integration operators record meaningful finite integral
values with `some`; undefined integrals remain `none`, without a default-zero
interpretation. The four defined values are linked to the actual conserved field,
selected open cell, endpoint times and physical boundary-flux functions.

The physical premise is the unnormalized integrated conservation identity printed
immediately before (4.3). The assertion only normalizes that identity. It does not
derive the physical balance, select an integration theory, or assert any numerical
algorithm output. The source integrated balance is separate from this normalization step. -/
def Leveque04Equation03PartialIntegralDataTarget : Prop :=
  ∀ {m : ℕ} (q : ℝ → ℝ → Fin m → ℝ) (flux : (Fin m → ℝ) → Fin m → ℝ)
      (spatialIntegral : (ℝ → Fin m → ℝ) → Set ℝ → Option (Fin m → ℝ))
      (temporalIntegral : (ℝ → Fin m → ℝ) → ℝ → ℝ → Option (Fin m → ℝ))
      (a b s t : ℝ) (oldMass newMass leftFluxIntegral rightFluxIntegral : Fin m → ℝ),
    a < b → s < t →
    spatialIntegral (fun x => q x s) (Set.Ioo a b) = some oldMass →
    spatialIntegral (fun x => q x t) (Set.Ioo a b) = some newMass →
    temporalIntegral (fun τ => flux (q a τ)) s t = some leftFluxIntegral →
    temporalIntegral (fun τ => flux (q b τ)) s t = some rightFluxIntegral →
    newMass - oldMass = leftFluxIntegral - rightFluxIntegral →
    (b - a)⁻¹ • newMass = (b - a)⁻¹ • oldMass -
      (b - a)⁻¹ • (rightFluxIntegral - leftFluxIntegral)


theorem leveque04_equation03_partialIntegralData :
    Leveque04Equation03PartialIntegralDataTarget := by
  unfold Leveque04Equation03PartialIntegralDataTarget
  intro m q flux spatialIntegral temporalIntegral a b s t
    oldMass newMass leftFluxIntegral rightFluxIntegral
    _ _ _ _ _ _ hbalance
  have hscaled := congrArg (fun v : Fin m → ℝ => (b - a)⁻¹ • v) hbalance
  simp only [smul_sub] at hscaled
  rw [smul_sub]
  calc
    (b - a)⁻¹ • newMass =
        ((b - a)⁻¹ • leftFluxIntegral - (b - a)⁻¹ • rightFluxIntegral) +
          (b - a)⁻¹ • oldMass := (sub_eq_iff_eq_add).mp hscaled
    _ = (b - a)⁻¹ • oldMass -
        ((b - a)⁻¹ • rightFluxIntegral - (b - a)⁻¹ • leftFluxIntegral) := by abel


end NumStability
