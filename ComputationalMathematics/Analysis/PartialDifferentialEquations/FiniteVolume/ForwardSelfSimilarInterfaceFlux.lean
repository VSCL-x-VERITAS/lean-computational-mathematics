/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.LocalRectangleReference
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.ConstantTraceAverage
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannData

/-!
# Forward self-similar interface flux

A selected Riemann field satisfying local integral conservation on a positive
time step has a constant interface trace under self-similarity. The field stays
in its admissible state domain, and its flux average is the flux of that trace.
No continuation to negative times or regularity outside that domain is needed.
-/

namespace NumStability
open MeasureTheory

/-- A selected forward Riemann field in its physical state domain gives the
actual interface flux average. The physical flux need only be specified on
that domain, and the PDE certificate is confined to the numerical step. -/
theorem forward_domain_selfsimilar_interface
    {m : ℕ} (states : Set (Fin (m+1) → ℝ))
    (flux : (Fin (m+1) → ℝ) → Fin (m+1) → ℝ)
    (q : ℝ → ℝ → Fin (m+1) → ℝ) (profile : ℝ → Fin (m+1) → ℝ)
    (leftState rightState : Fin (m+1) → ℝ) (left right timeStep : ℝ)
    (hl : left < 0) (hr : 0 < right) (htime : 0 < timeStep)
    (hinitial : IsRiemannData (fun x => q x 0) leftState rightState)
    (hphysical : LocalConservationLaw.RectangleReferenceOn q flux left right timeStep)
    (hdomain : ∀ x ∈ Set.Icc left right, ∀ t ∈ Set.Icc 0 timeStep, q x t ∈ states)
    (hself : ∀ x t, 0 < t → t ≤ timeStep → q x t = profile (x/t)) :
    IsRiemannData (fun x => q x 0) leftState rightState ∧
    LocalConservationLaw.RectangleReferenceOn q flux left right timeStep ∧
    profile 0 ∈ states ∧
    (∀ τ, 0 < τ → τ ≤ timeStep → q 0 τ = profile 0) ∧
    IntervalIntegrable (fun τ => flux (q 0 τ)) volume 0 timeStep ∧
    oneDimensionalCellAverage (fun τ => flux (q 0 τ)) 0 timeStep = flux (profile 0) := by
  have htrace (τ : ℝ) (hτ : 0 < τ) (hτT : τ ≤ timeStep) : q 0 τ = profile 0 := by
    simpa only [zero_div] using hself 0 τ hτ hτT
  have hm : profile 0 ∈ states := by
    rw [← htrace timeStep htime le_rfl]
    exact hdomain 0 ⟨hl.le,hr.le⟩ timeStep ⟨htime.le,le_rfl⟩
  have ha := oneDimensionalCellAverage_map_of_constantTraceOn flux (fun τ => q 0 τ)
    (profile 0) 0 timeStep htime (fun τ hτ => htrace τ hτ.1 hτ.2.le)
  exact ⟨hinitial,hphysical,hm,htrace,ha.1,ha.2⟩

end NumStability
