/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.SectionMassBalanceModel
import Mathlib.MeasureTheory.Integral.IntervalIntegral.FundThmCalculus

/-!
# Cumulative conservation on a fixed section

The source statement that section mass changes only through endpoint fluxes is
represented independently as a finite-time balance. Continuity of the net
endpoint flux supports the displayed ordinary derivative in equation (2.2).
-/

open MeasureTheory

namespace NumStability.Leveque02Tracer

/-- Every finite mass change equals accumulated left influx minus right outflux. -/
def IsCumulativeSectionConservation (q : ℝ → ℝ → ℝ)
    (leftFlux rightFlux : ℝ → ℝ) (a b t : ℝ) : Prop :=
  a < b ∧
    (∀ τ, IntervalIntegrable (fun x => q x τ) volume a b) ∧
    Continuous (fun τ => leftFlux τ - rightFlux τ) ∧
    ∀ s, (∫ x in a..b, q x s) - (∫ x in a..b, q x t) =
      ∫ τ in t..s, leftFlux τ - rightFlux τ

end NumStability.Leveque02Tracer

