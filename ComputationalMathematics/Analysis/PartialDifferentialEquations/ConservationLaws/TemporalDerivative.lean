/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Rectangle
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.LocalRectangleReference
import ComputationalMathematics.MeasureTheory.Integral.IntervalIntegral.LebesgueDifferentiation

/-!
# Temporal mass derivatives from rectangle conservation

For any finite real state space and flux, rectangle conservation gives the
mass-rate identity almost everywhere in time on each fixed spatial interval.
The exceptional null set may depend on that spatial interval.
-/

open MeasureTheory Set Filter
open scoped Topology

namespace NumStability

/-- Local rectangle conservation gives the mass-rate identity almost
everywhere in the physical time interval, with no assumptions outside it. -/
theorem LocalConservationLaw.RectangleReferenceOn.hasDerivAt_mass_ae
    {m : ℕ} {q : ℝ → ℝ → Fin m → ℝ} {flux : (Fin m → ℝ) → Fin m → ℝ}
    {left right horizon : ℝ}
    (h : LocalConservationLaw.RectangleReferenceOn q flux left right horizon)
    (hhorizon : 0 ≤ horizon) {a b : ℝ}
    (ha : a ∈ Icc left right) (hb : b ∈ Icc left right) :
    ∀ᵐ t, t ∈ Icc 0 horizon → HasDerivAt (fun s => ∫ x in a..b, q x s)
      (flux (q a t) - flux (q b t)) t := by
  have hflux : IntervalIntegrable (fun r => flux (q a r) - flux (q b r))
      volume 0 horizon := (h.2.1 a ha).sub (h.2.1 b hb)
  have hleft : ∀ᵐ t : ℝ, t ≠ 0 := by simp [ae_iff, measure_singleton]
  have hright : ∀ᵐ t : ℝ, t ≠ horizon := by simp [ae_iff, measure_singleton]
  filter_upwards [ae_hasDerivAt_intervalIntegral_pi_on _ hhorizon hflux,
    hleft, hright] with t ht htzero hthorizon
  intro htime
  have hzero : (0 : ℝ) ∈ Icc 0 horizon := ⟨le_refl _, hhorizon⟩
  apply ((ht htime 0 hzero).add_const (∫ x in a..b, q x 0)).congr_of_eventuallyEq
  filter_upwards [Ioo_mem_nhds (lt_of_le_of_ne htime.1 (Ne.symm htzero))
    (lt_of_le_of_ne htime.2 hthorizon)] with s hs
  exact sub_eq_iff_eq_add.mp (h.2.2 a ha b hb 0 hzero s ⟨hs.1.le, hs.2.le⟩)

theorem IsRectangleConservationLawSolution.hasDerivAt_mass_ae
    {ι : Type*} [Fintype ι] {q : ℝ → ℝ → ι → ℝ}
    {flux : (ι → ℝ) → ι → ℝ}
    (h : IsRectangleConservationLawSolution q flux) (a b : ℝ) :
    ∀ᵐ t, HasDerivAt (fun s => ∫ x in a..b, q x s)
      (flux (q a t) - flux (q b t)) t := by
  have hflux (s t : ℝ) :
      IntervalIntegrable (fun r => flux (q a r) - flux (q b r)) volume s t :=
    (h.2.1 a s t).sub (h.2.1 b s t)
  filter_upwards [ae_hasDerivAt_intervalIntegral_pi _ hflux] with t ht
  have heq : (fun s => ∫ x in a..b, q x s) =
      (fun s => (∫ r in (0 : ℝ)..s, flux (q a r) - flux (q b r)) +
        (∫ x in a..b, q x 0)) := by
    funext s
    exact sub_eq_iff_eq_add.mp (h.2.2 a b 0 s)
  rw [heq]
  exact (ht 0).add_const _

end NumStability
