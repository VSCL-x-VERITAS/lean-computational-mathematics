/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxDifference
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CenteredStencilEvolution
import Mathlib.Logic.Function.Iterate
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.AdvectionRefinementCFL
import Mathlib.Topology.UrysohnsLemma
import Mathlib.Tactic

/-!
# Scalar observations of two-point finite-volume fluxes

The cells have their left face at `origin + j * width`. At each refinement
level the time horizon is reached in `n + 1` steps. Any fixed two-point flux
has a radius-one numerical domain. If the positive advection characteristic
lies beyond its limiting cone, one fixed continuous compactly supported datum
prevents convergence of the numerical observation to that characteristic.

This is a convergence obstruction; it asserts no arbitrary-flux norm instability.
-/

open Filter
open scoped Topology

namespace NumStability

/-- Exact means on left-face cells of a fixed-ratio refinement. -/
noncomputable def fixedRatioLeftCellMeans
    (origin T ratio : ℝ) (profile : ℝ → ℝ) (n : ℕ) (j : ℤ) : ℝ :=
  oneDimensionalCellAverage profile
    (origin + (j : ℝ) * fixedRatioRefinementCellWidth T ratio n)
    (origin + ((j : ℝ) + 1) * fixedRatioRefinementCellWidth T ratio n)

/-- The conservative update using one fixed two-point numerical flux.
The time-step index is retained in the common evolution interface. -/
noncomputable def twoPointFluxRefinementUpdate
    (T ratio : ℝ) (numericalFlux : ℝ → ℝ → ℝ)
    (n : ℕ) (_ : ℕ) (u : ℤ → ℝ) (i : ℤ) : ℝ :=
  conservativeFluxDifferenceUpdateInt
    ((T / ((n + 1 : ℕ) : ℝ)) / fixedRatioRefinementCellWidth T ratio n)
    u (fun j => numericalFlux (u (j - 1)) (u j)) i

private theorem twoPointFluxRefinementUpdate_radius_one
    (T ratio : ℝ) (flux : ℝ → ℝ → ℝ) (n k : ℕ)
    (a b : ℤ → ℝ) (i : ℤ)
    (h : ∀ j ∈ Set.Icc (i - (1 : ℤ)) (i + (1 : ℤ)), a j = b j) :
    twoPointFluxRefinementUpdate T ratio flux n k a i =
      twoPointFluxRefinementUpdate T ratio flux n k b i := by
  have hl := h (i - 1) (by constructor <;> omega)
  have hc := h i (by constructor <;> omega)
  have hr := h (i + 1) (by constructor <;> omega)
  simp only [twoPointFluxRefinementUpdate, conservativeFluxDifferenceUpdateInt,
    add_sub_cancel_right, hl, hc, hr]

private theorem twoPointFluxRefinementUpdate_zero_evolution
    (T ratio : ℝ) (flux : ℝ → ℝ → ℝ) (n steps : ℕ) :
    centeredStencilEvolution (twoPointFluxRefinementUpdate T ratio flux n)
      (fun _ : ℤ => (0 : ℝ)) steps = (fun _ : ℤ => (0 : ℝ)) := by
  change centeredStencilEvolution
    (fun _ => twoPointFluxRefinementUpdate T ratio flux n 0)
    (fun _ : ℤ => (0 : ℝ)) steps = (fun _ : ℤ => (0 : ℝ))
  rw [centeredStencilEvolution_const]
  apply Function.iterate_fixed
  funext i
  simp [twoPointFluxRefinementUpdate, conservativeFluxDifferenceUpdateInt]

private theorem fixedRatioRefinement_exact_reach
    (T ratio : ℝ) (hratio : 0 < ratio) (n : ℕ) :
    ((n + 1 : ℕ) : ℝ) * fixedRatioRefinementCellWidth T ratio n = T / ratio := by
  have hn : ((n + 1 : ℕ) : ℝ) ≠ 0 := by positivity
  unfold fixedRatioRefinementCellWidth
  field_simp [hratio.ne', hn]

private theorem fixedRatioLeftCellMeans_zero_of_rightRay_zero
    (origin T ratio : ℝ) (profile : ℝ → ℝ)
    (hT : 0 < T) (hratio : 0 < ratio)
    (hzero : ∀ x : ℝ, origin - T / ratio ≤ x → profile x = 0)
    (n : ℕ) (j : ℤ) (hj : -((n + 1 : ℕ) : ℤ) ≤ j) :
    fixedRatioLeftCellMeans origin T ratio profile n j = 0 := by
  have hw : 0 < fixedRatioRefinementCellWidth T ratio n := by
    unfold fixedRatioRefinementCellWidth
    positivity
  have hjr : -((n + 1 : ℕ) : ℝ) ≤ (j : ℝ) := by exact_mod_cast hj
  have hm := mul_le_mul_of_nonneg_right hjr hw.le
  have hreach := fixedRatioRefinement_exact_reach T ratio hratio n
  let a : ℝ := origin + (j : ℝ) * fixedRatioRefinementCellWidth T ratio n
  let b : ℝ := origin + ((j : ℝ) + 1) * fixedRatioRefinementCellWidth T ratio n
  have ha : origin - T / ratio ≤ a := by dsimp [a]; nlinarith
  have hab : a ≤ b := by dsimp [a, b]; nlinarith
  have hint : (∫ x in a..b, profile x) = 0 := by
    calc
      (∫ x in a..b, profile x) = ∫ _ in a..b, (0 : ℝ) := by
        apply intervalIntegral.integral_congr
        intro x hx
        rw [Set.uIcc_of_le hab] at hx
        exact hzero x (ha.trans hx.1)
      _ = 0 := by simp
  change (b - a)⁻¹ • (∫ x in a..b, profile x) = 0
  rw [hint]
  simp

private theorem twoPointFluxRefinement_terminal_zero
    (origin T ratio : ℝ) (flux : ℝ → ℝ → ℝ) (profile : ℝ → ℝ)
    (hT : 0 < T) (hratio : 0 < ratio)
    (hzero : ∀ x : ℝ, origin - T / ratio ≤ x → profile x = 0) (n : ℕ) :
    centeredRefinementApproximation (twoPointFluxRefinementUpdate T ratio flux)
      (fun n f => fixedRatioLeftCellMeans origin T ratio f n) n profile = 0 := by
  have heq :
      centeredStencilEvolution (twoPointFluxRefinementUpdate T ratio flux n)
        (fixedRatioLeftCellMeans origin T ratio profile n) (n + 1) 0 =
      centeredStencilEvolution (twoPointFluxRefinementUpdate T ratio flux n)
        (fun _ : ℤ => (0 : ℝ)) (n + 1) 0 := by
    apply centeredStencilEvolution_locality (twoPointFluxRefinementUpdate T ratio flux n) 1
    · intro k a b i h
      exact twoPointFluxRefinementUpdate_radius_one T ratio flux n k a b i h
    · intro j hj
      simp only [Nat.cast_one, mul_one, zero_sub, zero_add] at hj
      exact fixedRatioLeftCellMeans_zero_of_rightRay_zero
        origin T ratio profile hT hratio hzero n j hj.1
  unfold centeredRefinementApproximation
  rw [heq, twoPointFluxRefinementUpdate_zero_evolution]

/-- Strict positive scalar Courant violation excludes the characteristic foot
from the limiting numerical cone and prevents convergence for all continuous
compactly supported whole-line data. The numerical flux is fixed before the
data are quantified; no consistency or stability hypothesis is imposed. -/
theorem twoPointFluxScalarObservation_cflObstruction :
    ∀ (speed origin T ratio : ℝ) (numericalFlux : ℝ → ℝ → ℝ),
      0 < speed → 0 < T → 0 < ratio → 1 < speed * ratio →
      (origin - speed * T ∉ Set.Icc (origin - T / ratio) (origin + T / ratio)) ∧
        ¬ (∀ profile : ℝ → ℝ, Continuous profile → HasCompactSupport profile →
          Tendsto (fun n =>
            centeredRefinementApproximation (twoPointFluxRefinementUpdate T ratio numericalFlux)
              (fun n f => fixedRatioLeftCellMeans origin T ratio f n) n profile)
            atTop (𝓝 (profile (origin - speed * T)))) := by
  intro speed origin T ratio flux _hspeed hT hratio hcfl
  have htravel : T / ratio < speed * T := by
    apply (div_lt_iff₀ hratio).2
    nlinarith [mul_lt_mul_of_pos_right hcfl hT]
  have hfoot : origin - speed * T < origin - T / ratio := by linarith
  constructor
  · intro hmem
    exact (not_le_of_gt hfoot) hmem.1
  · intro hconverges
    obtain ⟨profile, hpoint, hcompact, hsupport, _⟩ :=
      exists_continuousMap_one_of_isCompact_subset_isOpen
        (K := {origin - speed * T})
        (V := Set.Ioo (origin - speed * T - 1) (origin - T / ratio))
        isCompact_singleton isOpen_Ioo (by
          intro x hx
          have hxp : x = origin - speed * T := Set.mem_singleton_iff.mp hx
          subst x
          exact ⟨by linarith, hfoot⟩)
    have hone : profile (origin - speed * T) = 1 :=
      hpoint (Set.mem_singleton (origin - speed * T))
    have hzero : ∀ x : ℝ, origin - T / ratio ≤ x → profile x = 0 := by
      intro x hx
      apply image_eq_zero_of_notMem_tsupport
      intro hxs
      exact (not_lt_of_ge hx) (hsupport hxs).2
    have hall : (fun n =>
        centeredRefinementApproximation (twoPointFluxRefinementUpdate T ratio flux)
          (fun n f => fixedRatioLeftCellMeans origin T ratio f n) n profile) =
        (fun _ : ℕ => (0 : ℝ)) := by
      funext n
      exact twoPointFluxRefinement_terminal_zero
        origin T ratio flux profile hT hratio hzero n
    have hlimit := hconverges profile profile.continuous hcompact
    rw [hall, hone] at hlimit
    have hfalse : (0 : ℝ) = 1 := tendsto_nhds_unique tendsto_const_nhds hlimit
    norm_num at hfalse

end NumStability
