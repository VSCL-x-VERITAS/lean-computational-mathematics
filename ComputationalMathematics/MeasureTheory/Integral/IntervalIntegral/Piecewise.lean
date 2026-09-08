/-
SPDX-License-Identifier: MIT
-/

import Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic

/-!
# Interval integrability of piecewise functions

Measurable pasting preserves integrability on every finite oriented interval.
-/

open MeasureTheory Set Filter
open scoped Topology

namespace NumStability

noncomputable section

theorem intervalIntegrable_piecewise {s : Set ℝ} [DecidablePred (· ∈ s)]
    {f g : ℝ → ℝ} {a b : ℝ} (hs : MeasurableSet s)
    (hf : IntervalIntegrable f volume a b) (hg : IntervalIntegrable g volume a b) :
    IntervalIntegrable (s.piecewise f g) volume a b := by
  rw [intervalIntegrable_iff]
  exact Integrable.piecewise (s := s) (μ := volume.restrict (uIoc a b)) hs
    hf.def'.integrableOn hg.def'.integrableOn


end

end NumStability
