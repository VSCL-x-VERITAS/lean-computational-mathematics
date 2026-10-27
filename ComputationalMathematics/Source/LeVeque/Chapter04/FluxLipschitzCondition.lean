/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.FluxDeviationBound
import ComputationalMathematics.Source.LeVeque.Chapter04.Consistency
import Mathlib.Analysis.Normed.Group.Basic
import Mathlib.Analysis.Normed.Group.Real
import Mathlib.Analysis.Normed.Group.Uniform
import Mathlib.Topology.Order.OrderClosed

/-!
# LeVeque Chapter 4, equation (4.15): a local flux requirement

The source states (4.15) as a typical requirement on a numerical flux
near a constant state. The numerical flux is not assumed to meet it
automatically. One coefficient controls both arguments inside a
neighborhood of a fixed reference state.
-/

namespace NumStability

/-- The local vector-valued reading of (4.15) near one constant state. -/
def IsLeveque04FluxLipschitzAt
    {E : Type*} [NormedAddCommGroup E]
    (physicalFlux : E → E) (numericalFlux : E → E → E)
    (reference : E) : Prop :=
  ∃ L : ℝ, ∃ δ : ℝ, 0 ≤ L ∧ 0 < δ ∧
    ∀ left right : E,
      ‖left - reference‖ < δ →
      ‖right - reference‖ < δ →
      ‖numericalFlux left right - physicalFlux reference‖ ≤
        L * max ‖left - reference‖ ‖right - reference‖

/-- The source's numerical flux meets the local condition at every
constant reference state, with neighborhood and coefficient allowed to
depend on that state. -/
def IsLeveque04LocallyLipschitzFlux
    {E : Type*} [NormedAddCommGroup E]
    (physicalFlux : E → E) (numericalFlux : E → E → E) : Prop :=
  ∀ reference, IsLeveque04FluxLipschitzAt
    physicalFlux numericalFlux reference

/-- The local bound forces the constant-state consistency value of
(4.14) at the same reference state. -/
theorem IsLeveque04FluxLipschitzAt.consistent
    {E : Type*} [NormedAddCommGroup E]
    {physicalFlux : E → E} {numericalFlux : E → E → E}
    {reference : E}
    (hlocal : IsLeveque04FluxLipschitzAt
      physicalFlux numericalFlux reference) :
    numericalFlux reference reference = physicalFlux reference := by
  obtain ⟨L, δ, _, hδ, hbound⟩ := hlocal
  have hzero : ‖numericalFlux reference reference -
      physicalFlux reference‖ ≤ 0 := by
    simpa using hbound reference reference (by simpa using hδ)
      (by simpa using hδ)
  exact sub_eq_zero.mp (norm_eq_zero.mp
    (le_antisymm hzero (norm_nonneg _)))

/-- A local requirement at every state gives the existing vector
consistency condition (4.14). -/
theorem IsLeveque04LocallyLipschitzFlux.consistent
    {m : ℕ}
    [NormedAddCommGroup (Fin m → ℝ)]
    {physicalFlux : (Fin m → ℝ) → (Fin m → ℝ)}
    {numericalFlux : (Fin m → ℝ) → (Fin m → ℝ) → (Fin m → ℝ)}
    (hlocal : IsLeveque04LocallyLipschitzFlux
      physicalFlux numericalFlux) :
    IsLeveque04ConsistentFlux physicalFlux numericalFlux := by
  intro reference
  exact (hlocal reference).consistent

/-- For scalar states, the quantified local requirement specializes to
the literal displayed inequality already defined for (4.15). -/
theorem IsLeveque04FluxLipschitzAt.scalar_form
    {physicalFlux : ℝ → ℝ} {numericalFlux : ℝ → ℝ → ℝ}
    {reference : ℝ}
    (hlocal : IsLeveque04FluxLipschitzAt
      physicalFlux numericalFlux reference) :
    ∃ L : ℝ, ∃ δ : ℝ, 0 ≤ L ∧ 0 < δ ∧
      ∀ left right : ℝ,
        |left - reference| < δ → |right - reference| < δ →
          leveque04_fluxDeviationBound physicalFlux numericalFlux
            L reference left right := by
  obtain ⟨L, δ, hL, hδ, hbound⟩ := hlocal
  exact ⟨L, δ, hL, hδ, fun left right hl hr =>
    hbound left right hl hr⟩

open Filter Set
open scoped Topology

/-- The local linear bound suffices for the paired limit at the same equal
reference state. This is a sufficient condition, not a converse characterization
of continuity or a bound uniform over all reference states. -/
theorem IsLeveque04FluxLipschitzAt.tendsto_diagonal
    {E : Type*} [NormedAddCommGroup E]
    {physicalFlux : E → E} {numericalFlux : E → E → E}
    {reference : E}
    (hlocal : IsLeveque04FluxLipschitzAt
      physicalFlux numericalFlux reference) :
    Tendsto (fun p : E × E => numericalFlux p.1 p.2)
      (𝓝 (reference, reference)) (𝓝 (physicalFlux reference)) := by
  obtain ⟨L, δ, _hL, hδ, hbound⟩ := hlocal
  have hleft : Tendsto (fun p : E × E => ‖p.1 - reference‖)
      (𝓝 (reference, reference)) (𝓝 0) := by
    simpa using (Filter.Tendsto.norm
      ((continuous_fst.tendsto (reference, reference)).sub
        (tendsto_const_nhds (x := reference))))
  have hright : Tendsto (fun p : E × E => ‖p.2 - reference‖)
      (𝓝 (reference, reference)) (𝓝 0) := by
    simpa using (Filter.Tendsto.norm
      ((continuous_snd.tendsto (reference, reference)).sub
        (tendsto_const_nhds (x := reference))))
  have hmax : Tendsto (fun p : E × E =>
      max ‖p.1 - reference‖ ‖p.2 - reference‖)
      (𝓝 (reference, reference)) (𝓝 0) := by
    simpa using hleft.max hright
  have hscaled : Tendsto (fun p : E × E =>
      L * max ‖p.1 - reference‖ ‖p.2 - reference‖)
      (𝓝 (reference, reference)) (𝓝 0) := by
    simpa using tendsto_const_nhds.mul hmax
  apply Metric.tendsto_nhds.mpr
  intro ε hε
  filter_upwards [hleft.eventually (Iio_mem_nhds hδ),
      hright.eventually (Iio_mem_nhds hδ),
      hscaled.eventually (Iio_mem_nhds hε)] with p hp hq hs
  rw [dist_eq_norm]
  calc
    ‖numericalFlux p.1 p.2 - physicalFlux reference‖ ≤
        L * max ‖p.1 - reference‖ ‖p.2 - reference‖ := hbound p.1 p.2 hp hq
    _ < ε := hs

end NumStability
