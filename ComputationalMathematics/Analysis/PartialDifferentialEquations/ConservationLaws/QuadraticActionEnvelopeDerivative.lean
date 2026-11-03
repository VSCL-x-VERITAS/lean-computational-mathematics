/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.QuadraticActionMinimizerBound
import Mathlib.Analysis.Calculus.LocalExtr.Basic
import Mathlib.Analysis.Calculus.Deriv.Pow
import Mathlib.Analysis.Calculus.Deriv.Inv

/-!
# Derivatives of a quadratic action envelope at differentiability points

An attained action majorizes the envelope and touches it at the observation.
Fermat's theorem identifies the derivative of the envelope with that of this
actual touching action. No regularity or uniqueness of the minimizing foot is
assumed. These lemmas alone do not assert differentiability of the envelope.
-/

open Set Filter
open scoped Topology

namespace NumStability

/-- Spatial derivative at any differentiability point of an attained envelope. -/
theorem quadraticActionEnvelope_spatial_hasDerivAt
    (potential envelope : ℝ → ℝ) (time x foot : ℝ) (htime : 0 < time)
    (hmajor : ∀ z, envelope z ≤ potential foot + (z - foot) ^ 2 / (2 * time))
    (htouch : envelope x = potential foot + (x - foot) ^ 2 / (2 * time))
    (hdiff : DifferentiableAt ℝ envelope x) :
    HasDerivAt envelope ((x - foot) / time) x := by
  have haction : HasDerivAt (fun z => potential foot + (z - foot) ^ 2 / (2 * time))
      ((x - foot) / time) x := by
    convert (hasDerivAt_const x (potential foot)).add
      ((((hasDerivAt_id x).sub_const foot).pow 2).div_const (2 * time)) using 1
    simp only [id_eq]
    field_simp [ne_of_gt htime]
    ring
  have hlocal : IsLocalMin
      (fun z => potential foot + (z - foot) ^ 2 / (2 * time) - envelope z) x := by
    exact Filter.Eventually.of_forall (fun z => by
      change potential foot + (x - foot) ^ 2 / (2 * time) - envelope x ≤ _
      rw [htouch]
      linarith [hmajor z])
  have hzero := hlocal.hasDerivAt_eq_zero (haction.sub hdiff.hasDerivAt)
  convert hdiff.hasDerivAt using 1
  linarith

/-- Time derivative at any positive differentiability point of an attained
envelope. Majorization is needed only at positive comparison times. -/
theorem quadraticActionEnvelope_temporal_hasDerivAt
    (potential envelope : ℝ → ℝ) (x time foot : ℝ) (htime : 0 < time)
    (hmajor : ∀ s, 0 < s → envelope s ≤ potential foot + (x - foot) ^ 2 / (2 * s))
    (htouch : envelope time = potential foot + (x - foot) ^ 2 / (2 * time))
    (hdiff : DifferentiableAt ℝ envelope time) :
    HasDerivAt envelope (-((x - foot) / time) ^ 2 / 2) time := by
  have haction : HasDerivAt (fun s => potential foot + (x - foot) ^ 2 / (2 * s))
      (-((x - foot) / time) ^ 2 / 2) time := by
    convert (hasDerivAt_const time (potential foot)).add
      ((hasDerivAt_const time ((x - foot) ^ 2)).div
        ((hasDerivAt_id time).const_mul 2) (by positivity : 2 * time ≠ 0)) using 1
    simp only [id_eq]
    field_simp [ne_of_gt htime]
    ring
  have hlocal : IsLocalMin
      (fun s => potential foot + (x - foot) ^ 2 / (2 * s) - envelope s) time := by
    filter_upwards [isOpen_Ioi.mem_nhds htime] with s hs
    change potential foot + (x - foot) ^ 2 / (2 * time) - envelope time ≤ _
    rw [htouch]
    linarith [hmajor s hs]
  have hzero := hlocal.hasDerivAt_eq_zero (haction.sub hdiff.hasDerivAt)
  convert hdiff.hasDerivAt using 1
  linarith

end NumStability
