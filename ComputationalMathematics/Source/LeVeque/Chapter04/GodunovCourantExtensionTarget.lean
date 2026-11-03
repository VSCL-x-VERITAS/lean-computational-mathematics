/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFiniteActionEvolution
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.IntrinsicBurgersWaveBound

/-!
# The full-step Courant extension for finite Burgers data

The finite-action evolution is fixed by all supplied interior and exterior
states before the horizon and intrinsic encountered-wave bound are selected.
The inclusive full-step condition gives integrable physical face fluxes,
their exact time averages and the actual terminal cell means, including
interactions, zero propagation bound and terminal contact.
-/

noncomputable section
open MeasureTheory
open scoped Interval

namespace NumStability

def Leveque04GodunovCourantExtensionTarget : Prop :=
  ∀ (N : ℕ), 1 ≤ N → ∀ (old : Fin (N + 2) → ℝ) (origin width : ℝ), 0 < width →
    let U := leveque04_burgersFiniteActionEvolution old origin width
    (∀ horizon bound : ℝ, 0 < horizon → 0 ≤ bound →
      Burgers.IntrinsicWaveBound U horizon bound →
      bound * horizon ≤ width →
      (∀ j : Fin (N + 1),
        IntervalIntegrable (fun time => U (leveque04_burgersActionFace origin width j.val) time ^ 2 / 2)
          volume 0 horizon ∧
        (∫ time in (0 : ℝ)..horizon, U (leveque04_burgersActionFace origin width j.val) time ^ 2 / 2) /
          horizon = leveque04_burgersFiniteGridFlux old j) ∧
      (∀ cell : Fin N,
        IsOneDimensionalCellAverage (fun x => U x horizon)
          (leveque04_burgersActionFace origin width cell.castSucc.val)
          (leveque04_burgersActionFace origin width cell.succ.val)
          (leveque04_burgersFiniteGridStep horizon width old cell)))

end NumStability
