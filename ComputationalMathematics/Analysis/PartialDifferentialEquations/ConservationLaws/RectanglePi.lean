/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Rectangle
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLinearEquiv

/-!
# Componentwise rectangle conservation

A finite vector field solves a diagonal conservation law precisely
when its scalar coordinates satisfy the corresponding rectangle laws.
-/

open MeasureTheory

namespace NumStability

/-- Scalar rectangle solutions assemble into a finite diagonal vector
conservation-law solution. -/
theorem IsRectangleConservationLawSolution.pi
    {m : ℕ} (q : ℝ → ℝ → Fin m → ℝ)
    (flux : Fin m → ℝ → ℝ)
    (hq : ∀ p : Fin m,
      IsRectangleConservationLawSolution (fun x t => q x t p) (flux p)) :
    IsRectangleConservationLawSolution q
      (fun state p => flux p (state p)) := by
  have hspace (a b t : ℝ) :
      IntervalIntegrable (fun x => q x t) volume a b :=
    (intervalIntegrable_pi_iff _ a b).2 (fun p => (hq p).1 a b t)
  have htime (x s t : ℝ) :
      IntervalIntegrable (fun τ p => flux p (q x τ p)) volume s t :=
    (intervalIntegrable_pi_iff _ s t).2 (fun p => (hq p).2.1 x s t)
  refine ⟨hspace, htime, ?_⟩
  intro a b s t
  funext p
  let proj := (ContinuousLinearMap.proj (R := ℝ) p :
    (Fin m → ℝ) →L[ℝ] ℝ)
  have ht := proj.intervalIntegral_comp_comm (hspace a b t)
  have hs := proj.intervalIntegral_comp_comm (hspace a b s)
  have hf := proj.intervalIntegral_comp_comm
    ((htime a s t).sub (htime b s t))
  change (∫ x in a..b, q x t p) = (∫ x in a..b, q x t) p at ht
  change (∫ x in a..b, q x s p) = (∫ x in a..b, q x s) p at hs
  change (∫ τ in s..t, flux p (q a τ p) - flux p (q b τ p)) =
    (∫ τ in s..t,
      (fun r => flux r (q a τ r)) - (fun r => flux r (q b τ r))) p at hf
  calc
    ((∫ x in a..b, q x t) - (∫ x in a..b, q x s)) p =
      (∫ x in a..b, q x t p) - (∫ x in a..b, q x s p) := by
        simp only [Pi.sub_apply, ht, hs]
    _ = ∫ τ in s..t,
        flux p (q a τ p) - flux p (q b τ p) :=
      (hq p).2.2 a b s t
    _ = (∫ τ in s..t,
        (fun r => flux r (q a τ r)) - (fun r => flux r (q b τ r))) p := hf

/-- Evaluation of the unique coordinate of a one-component rectangle
solution gives the scalar rectangle conservation law. -/
theorem IsRectangleConservationLawSolution.fin1
    (q : ℝ → ℝ → Fin 1 → ℝ) (flux : ℝ → ℝ)
    (hq : IsRectangleConservationLawSolution q
      (fun state _ => flux (state 0))) :
    IsRectangleConservationLawSolution (fun x t => q x t 0) flux := by
  rcases hq with ⟨hspace, htime, hbalance⟩
  have hs (a b t : ℝ) :
      IntervalIntegrable (fun x => q x t 0) volume a b :=
    (intervalIntegrable_pi_iff _ a b).1 (hspace a b t) 0
  have ht (x s t : ℝ) :
      IntervalIntegrable (fun τ => flux (q x τ 0)) volume s t :=
    (intervalIntegrable_pi_iff _ s t).1 (htime x s t) 0
  refine ⟨hs, ht, ?_⟩
  intro a b s t
  let proj := (ContinuousLinearMap.proj (R := ℝ) (0 : Fin 1) :
    (Fin 1 → ℝ) →L[ℝ] ℝ)
  have hst := proj.intervalIntegral_comp_comm (hspace a b t)
  have hss := proj.intervalIntegral_comp_comm (hspace a b s)
  have hft := proj.intervalIntegral_comp_comm
    ((htime a s t).sub (htime b s t))
  change (∫ x in a..b, q x t 0) = (∫ x in a..b, q x t) 0 at hst
  change (∫ x in a..b, q x s 0) = (∫ x in a..b, q x s) 0 at hss
  change (∫ τ in s..t, flux (q a τ 0) - flux (q b τ 0)) =
    (∫ τ in s..t,
      (fun _ : Fin 1 => flux (q a τ 0)) -
        (fun _ : Fin 1 => flux (q b τ 0))) 0 at hft
  have hbal0 := congrArg (fun v : Fin 1 → ℝ => v 0)
    (hbalance a b s t)
  calc
    (∫ x in a..b, q x t 0) - (∫ x in a..b, q x s 0) =
      ((∫ x in a..b, q x t) - (∫ x in a..b, q x s)) 0 := by
        simp only [Pi.sub_apply, hst, hss]
    _ = (∫ τ in s..t,
        (fun _ : Fin 1 => flux (q a τ 0)) -
          (fun _ : Fin 1 => flux (q b τ 0))) 0 := hbal0
    _ = ∫ τ in s..t, flux (q a τ 0) - flux (q b τ 0) := hft.symm

end NumStability
