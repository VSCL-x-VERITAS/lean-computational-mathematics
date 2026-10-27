/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.GodunovBurgersSelectedEntropy
import ComputationalMathematics.Source.LeVeque.Chapter04.GodunovBurgersFiniteChainEntropy

/-!
# Forward Burgers entropy including the initial-time face

The existing entropy primitive has the prescribed initial limit. Endpoint
FTC gives its initial-to-forward flux balance, and the selected shocks and
fans satisfy entropy inequalities on the full forward half-line. Ordered
cone assembly transports these to the actual finite field under nonstrict
CFL. Entropy uniqueness and complete generic system scope are separate.
-/

open MeasureTheory Set Filter
open scoped Topology
namespace NumStability

private theorem initial_entropy_potential (left right reference x : ℝ) :
    2 * leveque04_burgersInitialPotential (max left reference) (max right reference) x -
      leveque04_burgersInitialPotential left right x - reference * x =
        leveque04_burgersInitialPotential |left - reference| |right - reference| x := by
  have hmax (u : ℝ) : 2 * max u reference - u - reference = |u - reference| := by
    rw [← max_sub_min_eq_abs' u reference]
    linarith [max_add_min u reference]
  unfold leveque04_burgersInitialPotential
  split_ifs
  · rw [← hmax left]
    ring
  · rw [← hmax right]
    ring

theorem leveque04_burgersRarefactionEntropyPotential_initialTrace
    (left right reference x : ℝ) (horder : left ≤ right) :
    Tendsto (fun τ => leveque04_burgersRarefactionEntropyPotential left right reference x τ)
      (𝓝[>] (0 : ℝ))
      (𝓝 (leveque04_burgersInitialPotential |left - reference| |right - reference| x)) := by
  have hraised := leveque04_burgersRarefactionPotential_initialTrace
    (max left reference) (max right reference) x (max_le_max_right reference horder)
  have hbase := leveque04_burgersRarefactionPotential_initialTrace left right x horder
  have htime : Tendsto (fun τ : ℝ => reference ^ 2 * τ / 2)
      (𝓝[>] (0 : ℝ)) (𝓝 0) := by
    have h : Tendsto (fun τ : ℝ => τ) (𝓝[>] (0 : ℝ)) (𝓝 0) :=
      tendsto_id.mono_left nhdsWithin_le_nhds
    simpa using (h.const_mul (reference ^ 2)).div_const 2
  simpa only [leveque04_burgersRarefactionEntropyPotential, add_zero,
    initial_entropy_potential] using (((hraised.const_mul 2).sub hbase).sub_const
      (reference * x)).add htime

theorem leveque04_burgersRarefactionGlobalCandidate_entropy_flux_integrable_from_initial
    (left right reference x t : ℝ) (horder : left ≤ right) (ht : 0 < t) :
    IntervalIntegrable (fun τ => burgersKruzkovFlux reference
      (leveque04_burgersRarefactionGlobalCandidate left right x τ)) volume 0 t := by
  have hraised := leveque04_burgersRarefactionGlobalCandidate_intervalIntegrable_fluxTime
    (max left reference) (max right reference) x 0 t (max_le_max_right reference horder)
  have hbase := leveque04_burgersRarefactionGlobalCandidate_intervalIntegrable_fluxTime
    left right x 0 t horder
  apply ((hraised.const_mul 2).sub hbase |>.sub (intervalIntegrable_const (c := reference ^ 2 / 2))).congr
  intro τ hτ
  have hτpos : 0 < τ := by simpa only [min_eq_left ht.le] using hτ.1
  dsimp only
  simp only [leveque04_burgersRarefactionGlobalCandidate_positive
    (max left reference) (max right reference) x τ hτpos,
    leveque04_burgersRarefactionGlobalCandidate_positive left right x τ hτpos,
    leveque04_burgersRarefactionForward_max_reference, burgersKruzkovFlux_eq_max]
  ring

theorem leveque04_burgersRarefactionGlobalCandidate_entropy_flux_from_initial
    (left right reference x t : ℝ) (horder : left ≤ right) (ht : 0 < t) :
    (∫ τ in (0 : ℝ)..t, burgersKruzkovFlux reference
      (leveque04_burgersRarefactionGlobalCandidate left right x τ)) =
      leveque04_burgersInitialPotential |left - reference| |right - reference| x -
        leveque04_burgersRarefactionEntropyPotential left right reference x t := by
  have hint := leveque04_burgersRarefactionGlobalCandidate_entropy_flux_integrable_from_initial
    left right reference x t horder ht
  have hd : ∀ τ ∈ Ioo (0 : ℝ) t,
      HasDerivAt (fun σ => leveque04_burgersRarefactionEntropyPotential left right reference x σ)
        (-burgersKruzkovFlux reference (leveque04_burgersRarefactionGlobalCandidate left right x τ)) τ := by
    intro τ hτ
    rw [leveque04_burgersRarefactionGlobalCandidate_positive _ _ _ _ hτ.1]
    exact leveque04_burgersRarefactionEntropyPotential_time_hasDerivAt
      left right reference x τ horder hτ.1
  have hh := intervalIntegral.integral_eq_sub_of_hasDerivAt_of_tendsto ht hd hint.neg
    (leveque04_burgersRarefactionEntropyPotential_initialTrace left right reference x horder)
    ((leveque04_burgersRarefactionEntropyPotential_time_hasDerivAt left right reference x t
      horder ht).continuousAt.tendsto.mono_left inf_le_left)
  rw [intervalIntegral.integral_neg] at hh
  linarith

theorem leveque04_burgersRarefactionGlobalCandidate_entropy_rectangle_from_initial
    (left right reference a b t : ℝ) (horder : left ≤ right) (ht : 0 < t) :
    (∫ x in a..b, |leveque04_burgersRarefactionGlobalCandidate left right x t - reference|) -
      (∫ x in a..b, |leveque04_burgersRarefactionGlobalCandidate left right x 0 - reference|) =
      ∫ τ in (0 : ℝ)..t,
        burgersKruzkovFlux reference (leveque04_burgersRarefactionGlobalCandidate left right a τ) -
        burgersKruzkovFlux reference (leveque04_burgersRarefactionGlobalCandidate left right b τ) := by
  have hinitial : (fun x => |leveque04_burgersRarefactionGlobalCandidate left right x 0 - reference|) =
      riemannData |left - reference| |right - reference| |right - reference| := by
    funext x
    rw [leveque04_burgersRarefactionGlobalCandidate_initial]
    simp only [riemannData]
    split_ifs <;> rfl
  rw [show (fun x => |leveque04_burgersRarefactionGlobalCandidate left right x t - reference|) =
      fun x => |leveque04_burgersRarefactionForward left right x t - reference| by
        funext x; rw [leveque04_burgersRarefactionGlobalCandidate_positive _ _ _ _ ht], hinitial,
    leveque04_burgersRarefactionForward_entropy_mass_potential left right reference a b t horder ht,
    leveque04_burgersInitialPotential_mass,
    intervalIntegral.integral_sub
      (leveque04_burgersRarefactionGlobalCandidate_entropy_flux_integrable_from_initial
        left right reference a t horder ht)
      (leveque04_burgersRarefactionGlobalCandidate_entropy_flux_integrable_from_initial
        left right reference b t horder ht),
    leveque04_burgersRarefactionGlobalCandidate_entropy_flux_from_initial left right reference a t horder ht,
    leveque04_burgersRarefactionGlobalCandidate_entropy_flux_from_initial left right reference b t horder ht]
  ring

theorem leveque04_burgersSelectedField_entropy_rectangle_forward
    (left right reference a b s t : ℝ) (hab : a ≤ b) (hs : 0 ≤ s) (hst : s ≤ t) :
    (∫ x in a..b, |leveque04_burgersSelectedField left right x t - reference|) -
      (∫ x in a..b, |leveque04_burgersSelectedField left right x s - reference|) ≤
      ∫ τ in s..t,
        burgersKruzkovFlux reference (leveque04_burgersSelectedField left right a τ) -
        burgersKruzkovFlux reference (leveque04_burgersSelectedField left right b τ) := by
  by_cases hspos : 0 < s
  · exact leveque04_burgersSelectedField_entropy_rectangle_positive
      left right reference a b s t hab hspos hst
  have hs0 : s = 0 := by linarith
  subst s
  by_cases ht0 : t = 0
  · subst t
    simp
  have ht : 0 < t := lt_of_le_of_ne hst (Ne.symm ht0)
  by_cases horder : left ≤ right
  · simpa only [leveque04_burgersSelectedField, if_pos horder] using
      (leveque04_burgersRarefactionGlobalCandidate_entropy_rectangle_from_initial
        left right reference a b t horder ht).le
  · simpa only [leveque04_burgersSelectedField, if_neg horder] using
      travelingRiemannJump_entropy_rectangle left right ((left + right) / 2)
        (fun u => |u - reference|) (burgersKruzkovFlux reference)
        (burgersKruzkovFlux_shock_dissipation left right reference (le_of_not_ge horder))
        a b 0 t hab hst

/-- Every entropy-flux trace on a forward interval is integrable, including
the initial-time face and either orientation of its time endpoints. -/
theorem leveque04_burgersSelectedField_entropy_flux_integrable_forward
    (left right reference x s t : ℝ) (hs : 0 ≤ s) (ht : 0 ≤ t) :
    IntervalIntegrable (fun τ => burgersKruzkovFlux reference
      (leveque04_burgersSelectedField left right x τ)) volume s t := by
  have hzero (u : ℝ) (hu : 0 ≤ u) :
      IntervalIntegrable (fun τ => burgersKruzkovFlux reference
        (leveque04_burgersSelectedField left right x τ)) volume 0 u := by
    by_cases hu0 : u = 0
    · subst u
      simp
    have hup : 0 < u := lt_of_le_of_ne hu (Ne.symm hu0)
    by_cases horder : left ≤ right
    · simpa only [leveque04_burgersSelectedField, if_pos horder] using
        leveque04_burgersRarefactionGlobalCandidate_entropy_flux_integrable_from_initial
          left right reference x u horder hup
    · have heq : (fun τ => burgersKruzkovFlux reference
          (leveque04_burgersSelectedField left right x τ)) =
          (fun τ => travelingWave
            (riemannData (burgersKruzkovFlux reference left) (burgersKruzkovFlux reference right)
              (burgersKruzkovFlux reference right)) ((left + right) / 2) x τ) := by
        funext τ
        simp only [leveque04_burgersSelectedField, if_neg horder, travelingWave, riemannData]
        split_ifs <;> rfl
      rw [heq]
      exact travelingWave_intervalIntegrable_time _ (riemannData_intervalIntegrable _ _ _)
        ((left + right) / 2) x 0 u
  exact (hzero s hs).symm.trans (hzero t ht)

/-- The actual constructed finite shock/fan evolution satisfies every
reference-state entropy inequality on the entire forward step, including
the initial entropy face, under the nonstrict cone CFL. -/
theorem leveque04_burgersFiniteChain_entropy_rectangle_forward
    (states : ℕ → ℝ) (count : ℕ) (width bound horizon reference a b s t : ℝ)
    (hwidth : 0 < width) (hbound : 0 ≤ bound)
    (hstates : ∀ j ≤ count, -bound ≤ states j ∧ states j ≤ bound)
    (hcfl : 2 * bound * horizon ≤ width)
    (hab : a ≤ b) (hs : 0 ≤ s) (hst : s ≤ t) (ht : t ≤ horizon) :
    (∫ x in a..b, |leveque04_burgersFiniteChain states count width x t 0 - reference|) -
      (∫ x in a..b, |leveque04_burgersFiniteChain states count width x s 0 - reference|) ≤
        ∫ τ in s..t,
          burgersKruzkovFlux reference (leveque04_burgersFiniteChain states count width a τ 0) -
          burgersKruzkovFlux reference (leveque04_burgersFiniteChain states count width b τ 0) := by
  apply finiteRiemannChain_entropy_rectangle_of_ordered_profiles
    (fun (j : ℕ) (_ : Fin 1) => states j)
    (fun j (x τ : ℝ) (_ : Fin 1) => leveque04_burgersSelectedField
      (states j) (states (j + 1)) (x - (j : ℝ) * width) τ) count
    (fun u => |u 0 - reference|) (fun u => burgersKruzkovFlux reference (u 0))
    a b s t hab hst
  · intro x _ τ hτ
    have hforward : τ ∈ Set.Icc 0 horizon := ⟨hs.trans hτ.1, hτ.2.trans ht⟩
    apply isOrderedFiniteRiemannChain_of_uniform_cones _ _ count width bound horizon x τ
      hwidth hbound hforward hcfl
    · intro j hj hx
      funext p
      exact leveque04_burgersSelectedField_left_of_cone
        (states j) (states (j + 1)) bound (x - (j : ℝ) * width) τ
        (hstates j (by omega)) (hstates (j + 1) (by omega)) hforward.1 (by linarith)
    · intro j hj hx
      funext p
      exact leveque04_burgersSelectedField_right_of_closed_cone
        (states j) (states (j + 1)) bound (x - (j : ℝ) * width) τ
        (hstates j (by omega)) (hstates (j + 1) (by omega)) hforward.1 (by linarith)
  · intro j _ τ _
    have h := leveque04_burgersSelectedField_entropy_space_integrable
      (states j) (states (j + 1)) reference (a - (j : ℝ) * width) (b - (j : ℝ) * width) τ
    simpa only [sub_add_cancel] using h.comp_sub_right ((j : ℝ) * width)
  · intro j _ x _
    exact leveque04_burgersSelectedField_entropy_flux_integrable_forward
      (states j) (states (j + 1)) reference (x - (j : ℝ) * width) s t hs (hs.trans hst)
  · intro j _
    change (∫ x in a..b, |leveque04_burgersSelectedField (states j) (states (j + 1))
      (x - (j : ℝ) * width) t - reference|) -
      (∫ x in a..b, |leveque04_burgersSelectedField (states j) (states (j + 1))
        (x - (j : ℝ) * width) s - reference|) ≤ _
    rw [intervalIntegral.integral_comp_sub_right
      (f := fun y => |leveque04_burgersSelectedField (states j) (states (j + 1)) y t - reference|),
      intervalIntegral.integral_comp_sub_right
      (f := fun y => |leveque04_burgersSelectedField (states j) (states (j + 1)) y s - reference|)]
    exact leveque04_burgersSelectedField_entropy_rectangle_forward
      (states j) (states (j + 1)) reference (a - (j : ℝ) * width) (b - (j : ℝ) * width)
      s t (by linarith) hs hst


end NumStability
