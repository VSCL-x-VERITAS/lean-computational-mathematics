/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.FiniteVolume.MaterialInterface
import ComputationalMathematics.Analysis.FiniteVolume.ForwardDifference
import ComputationalMathematics.Analysis.FiniteVolume.LocalConservativity

/-!
# Harmonic Interface Target

Closed proof-free target for the owner-selected positive two-material interface.
Existence/uniqueness concerns the interface value, not a global discrete/PDE solution.

Source-faithfulness and proof status are recorded in `docs/formalization/eymard-chapter-01.md`.
-/

set_option autoImplicit false

noncomputable section

namespace NumStability.Eymard.Chapter01
open NumStability.FiniteVolume

/-- Closed proof-free target for the owner-selected positive two-material interface.
Existence/uniqueness concerns the interface value, not a global discrete/PDE solution. -/
def harmonicInterfaceTarget : Prop :=
  ∀ xK s xL kK kL uK uL : ℝ,
    xK < s → s < xL → 0 < kK → 0 < kL →
    let dK := s - xK
    let dL := xL - s
    let D := dK / kK + dL / kL
    let tau := 1 / D
    0 < dK ∧ 0 < dL ∧ 0 < D ∧
    0 < dK * kL + dL * kK ∧ 0 < kL / dL + kK / dK ∧ 0 < tau ∧
    tau = kK * kL / (dK * kL + dL * kK) ∧
    (∀ x : ℝ, x < s → alignedInterfaceCoefficient s kK kL x = kK) ∧
    (∀ x : ℝ, s < x → alignedInterfaceCoefficient s kK kL x = kL) ∧
    (∃! v : ℝ, SatisfiesMaterialInterface xK s xL kK kL uK uL v) ∧
    (∀ v : ℝ, SatisfiesMaterialInterface xK s xL kK kL uK uL v →
      v = (uL * kL / dL + uK * kK / dK) / (kL / dL + kK / dK) ∧
      ContinuousOn (interfaceProfile xK s xL uK uL v) (Set.Icc xK xL) ∧
      interfaceProfile xK s xL uK uL v xK = uK ∧
      interfaceProfile xK s xL uK uL v s = v ∧
      interfaceProfile xK s xL uK uL v xL = uL ∧
      (∀ x : ℝ, HasDerivAt (interfaceLeftBranch xK s uK v) ((v - uK) / dK) x) ∧
      (∀ x : ℝ, HasDerivAt (interfaceRightBranch s xL uL v) ((uL - v) / dL) x) ∧
      forwardDifferenceQuotient (interfaceLeftBranch xK s uK v) xK dK = (v - uK) / dK ∧
      forwardDifferenceQuotient (interfaceRightBranch s xL uL v) s dL = (uL - v) / dL ∧
      -kK * deriv (interfaceLeftBranch xK s uK v) s = (uK - uL) / D ∧
      -kL * deriv (interfaceRightBranch s xL uL v) s = (uK - uL) / D ∧
      (uK - uL) / D = -tau * (uL - uK) ∧
      materialOutwardFlux xK s xL kK kL uK uL v false = (uK - uL) / D ∧
      materialOutwardFlux xK s xL kK kL uK uL v true = -((uK - uL) / D) ∧
      IsLocallyConservative (fun _ : Unit => false) (fun _ : Unit => true)
        (fun (_ : Unit) (side : Bool) (_ : Unit) =>
          materialOutwardFlux xK s xL kK kL uK uL v side) ∧
      (∀ h : ℝ, 0 < h → dK = h / 2 → dL = h / 2 →
        tau = (2 * kK * kL / (kK + kL)) / h ∧
        (uK - uL) / D = -(2 * kK * kL / (kK + kL)) * (uL - uK) / h))

end NumStability.Eymard.Chapter01
