/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.PrintedHeatBalanceTarget
import Mathlib.Analysis.SpecialFunctions.Integrals.Basic

/-!
# Counterexample to the printed sign in LeVeque equation (2.24)

With rightward signed Fourier flux, conservation gives left endpoint flux
minus right endpoint flux.  The printed bracket in (2.24) has the opposite
order.  A smooth affine temperature field with spatially varying conductivity
makes the two nonzero rates opposite, refuting the literal target.
-/

open MeasureTheory Set Filter
open scoped Topology

namespace NumStability.Leveque02Tracer

/-- The literal endpoint order printed in (2.24) contradicts the conserving Fourier model. -/
theorem printedHeatBalanceTarget_false : ¬ printedHeatBalanceTarget := by
  intro h
  let temperature : ℝ → ℝ → ℝ := fun x τ ↦ x + τ * 2
  let capacity : ℝ → ℝ := fun _ ↦ 1
  let conductivity : ℝ → ℝ := fun x ↦ 2 * x
  let gradient : ℝ → ℝ := fun _ ↦ 1
  have hint : ∀ τ : ℝ,
      IntervalIntegrable (fun x ↦ thermalEnergyDensity capacity temperature x τ)
        volume 0 1 := by
    intro τ
    simpa [thermalEnergyDensity, capacity, temperature] using
      (continuous_id.add continuous_const).intervalIntegrable (a := (0 : ℝ)) (b := 1)
  have hgrad : ∀ x ∈ Icc (0 : ℝ) 1,
      HasDerivAt (fun ξ ↦ temperature ξ 0) (gradient x) x := by
    intro x _hx
    simpa [temperature, gradient] using (hasDerivAt_id x).add_const (0 : ℝ)
  have hintegral : ∀ τ : ℝ,
      (∫ x in (0 : ℝ)..1, thermalEnergyDensity capacity temperature x τ) =
        (1 / 2 : ℝ) + τ * 2 := by
    intro τ
    norm_num [thermalEnergyDensity, capacity, temperature]
    exact Or.inl rfl
  have hrate : HasDerivAt
      (fun τ ↦ ∫ x in (0 : ℝ)..1, thermalEnergyDensity capacity temperature x τ)
      2 0 := by
    rw [show (fun τ ↦ ∫ x in (0 : ℝ)..1,
      thermalEnergyDensity capacity temperature x τ) =
        (fun τ ↦ (1 / 2 : ℝ) + τ * 2) from funext hintegral]
    convert (hasDerivAt_const (0 : ℝ) (1 / 2 : ℝ)).add
      ((hasDerivAt_id (0 : ℝ)).mul_const 2) using 1
    all_goals norm_num
  have hbad := h temperature capacity conductivity gradient 0 1 0 (by norm_num)
    (Filter.Eventually.of_forall hint) hgrad
  have hout := hbad (by simpa [fourierHeatFlux, conductivity, gradient] using hrate)
  have hfalse := hout.unique hrate
  norm_num [fourierHeatFlux, conductivity, gradient] at hfalse
  exact (by norm_num : (-2 : ℝ) - 0 ≠ 2) hfalse

end NumStability.Leveque02Tracer
