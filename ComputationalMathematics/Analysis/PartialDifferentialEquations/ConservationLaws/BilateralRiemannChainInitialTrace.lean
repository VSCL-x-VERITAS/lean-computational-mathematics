/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.RiemannChainUniformWindow
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.FiniteRiemannChainInitialTrace

/-!
# Initial reconstruction and traces of a bilateral Riemann chain

The actual compatible-window evolution reconstructs each lattice cell state and mass. A fixed local window transfers constituent initial traces to the bilateral field.
-/

namespace NumStability

theorem bilateralRiemannChainEvolution_initial_eq_cell_state
    {E : Type*} [AddCommGroup E] (states : ℤ → E) (fields : ℤ → ℝ → ℝ → E)
    (origin width horizon : ℝ) (hwidth : 0 < width) (hhorizon : 0 ≤ horizon)
    (hfinite : ∀ x time, time ∈ Set.Icc 0 horizon →
      ∃ radius, IsRiemannChainWindow states (fun j => fields j x time) radius)
    (hleft : ∀ (j : ℤ) (x : ℝ), x < origin + (j : ℝ) * width → fields j x 0 = states j)
    (hright : ∀ (j : ℤ) (x : ℝ), origin + (j : ℝ) * width < x → fields j x 0 = states (j + 1))
    (cell : ℤ) (x : ℝ)
    (hx : x ∈ Set.Ioo (origin + (cell : ℝ) * width)
      (origin + ((cell + 1 : ℤ) : ℝ) * width)) :
    bilateralRiemannChainEvolution states fields horizon hfinite x 0 = states (cell + 1) := by
  have ht : (0 : ℝ) ∈ Set.Icc 0 horizon := ⟨le_refl _, hhorizon⟩
  obtain ⟨small, hs⟩ := hfinite x 0 ht
  obtain ⟨extra, he⟩ := exists_nat_gt (max (-cell) (cell + 2))
  let radius := max small extra
  have hsmall : small ≤ radius := Nat.le_max_left _ _
  have hextra : extra ≤ radius := Nat.le_max_right _ _
  have hlow := (le_max_left (-cell) (cell + 2)).trans_lt he
  have hupp := (le_max_right (-cell) (cell + 2)).trans_lt he
  have hnonnegative : 0 ≤ cell + 1 + (radius : ℤ) := by omega
  let k := (cell + 1 + (radius : ℤ)).toNat
  have hk : (k : ℤ) = cell + 1 + (radius : ℤ) := Int.toNat_of_nonneg hnonnegative
  rw [bilateralRiemannChainEvolution_eq_window states fields horizon hfinite x 0 ht
    radius (hs.mono hsmall)]
  unfold integerRiemannChainWindow
  have hp := finiteRiemannChainAssembly_eq_state
    (fun j : ℕ => states ((j : ℤ) - radius))
    (fun j : ℕ => fields ((j : ℤ) - radius) x 0) (2 * radius) k (by omega)
    (by
      intro j hj
      have hi : (((j : ℤ) - radius : ℤ) : ℝ) ≤ (cell : ℝ) := by
        have hi' : (j : ℤ) - radius ≤ cell := by omega
        exact_mod_cast hi'
      have hiw := mul_le_mul_of_nonneg_right hi hwidth.le
      have heq := hright ((j : ℤ) - radius) x (by linarith [hx.1])
      simpa only [Nat.cast_add, Nat.cast_one, sub_add_eq_add_sub] using heq)
    (by
      intro j hj hjcount
      apply hleft ((j : ℤ) - radius) x
      have hi : ((cell + 1 : ℤ) : ℝ) ≤ (((j : ℤ) - radius : ℤ) : ℝ) := by
        have hi' : cell + 1 ≤ (j : ℤ) - radius := by omega
        exact_mod_cast hi'
      have hiw := mul_le_mul_of_nonneg_right hi hwidth.le
      linarith [hx.2])
  have hk' : (k : ℤ) - radius = cell + 1 := by omega
  simpa only [hk'] using hp

theorem bilateralRiemannChainEvolution_initial_cell_integral
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]
    (states : ℤ → E) (fields : ℤ → ℝ → ℝ → E)
    (origin width horizon : ℝ) (hwidth : 0 < width) (hhorizon : 0 ≤ horizon)
    (hfinite : ∀ x time, time ∈ Set.Icc 0 horizon →
      ∃ radius, IsRiemannChainWindow states (fun j => fields j x time) radius)
    (hleft : ∀ (j : ℤ) (x : ℝ), x < origin + (j : ℝ) * width → fields j x 0 = states j)
    (hright : ∀ (j : ℤ) (x : ℝ), origin + (j : ℝ) * width < x → fields j x 0 = states (j + 1))
    (cell : ℤ) :
    (∫ x in (origin + (cell : ℝ) * width)..(origin + ((cell + 1 : ℤ) : ℝ) * width),
      bilateralRiemannChainEvolution states fields horizon hfinite x 0) = width • states (cell + 1) := by
  have horder : origin + (cell : ℝ) * width <
      origin + ((cell + 1 : ℤ) : ℝ) * width := by
    simp only [Int.cast_add, Int.cast_one]
    linarith
  have heq : (∫ x in (origin + (cell : ℝ) * width)..(origin + ((cell + 1 : ℤ) : ℝ) * width),
      bilateralRiemannChainEvolution states fields horizon hfinite x 0) =
      ∫ _ in (origin + (cell : ℝ) * width)..(origin + ((cell + 1 : ℤ) : ℝ) * width),
        states (cell + 1) := by
    apply intervalIntegral.integral_congr_ae
    filter_upwards [MeasureTheory.volume.ae_ne (origin + ((cell + 1 : ℤ) : ℝ) * width)] with x hne hx
    have hx' : x ∈ Set.Ioc (origin + (cell : ℝ) * width)
        (origin + ((cell + 1 : ℤ) : ℝ) * width) := by
      simpa only [Set.uIoc_of_le horder.le] using hx
    exact bilateralRiemannChainEvolution_initial_eq_cell_state states fields origin width horizon
      hwidth hhorizon hfinite hleft hright cell x ⟨hx'.1, lt_of_le_of_ne hx'.2 hne⟩
  rw [heq, intervalIntegral.integral_const]
  congr 1
  simp only [Int.cast_add, Int.cast_one]
  ring

theorem bilateralRiemannChainEvolution_tendsto
    {E : Type*} [NormedAddCommGroup E] (states : ℤ → E) (fields : ℤ → ℝ → ℝ → E)
    (horizon : ℝ) (hhorizon : 0 ≤ horizon)
    (hfinite : ∀ x time, time ∈ Set.Icc 0 horizon →
      ∃ radius, IsRiemannChainWindow states (fun j => fields j x time) radius)
    (x : ℝ) (radius : ℕ) (l : Filter ℝ)
    (htime : ∀ᶠ time in l, time ∈ Set.Icc 0 horizon)
    (hradius : ∀ time ∈ Set.Icc 0 horizon,
      IsRiemannChainWindow states (fun j => fields j x time) radius)
    (hprofiles : ∀ j : ℤ, Filter.Tendsto (fields j x) l (nhds (fields j x 0))) :
    Filter.Tendsto (bilateralRiemannChainEvolution states fields horizon hfinite x) l
      (nhds (bilateralRiemannChainEvolution states fields horizon hfinite x 0)) := by
  have hlim := finiteRiemannChainAssembly_tendsto l
    (fun j : ℕ => states ((j : ℤ) - radius))
    (fun j : ℕ => fields ((j : ℤ) - radius) x 0)
    (fun j : ℕ => fields ((j : ℤ) - radius) x) (2 * radius)
    (fun j hj => hprofiles _)
  have hq0 := bilateralRiemannChainEvolution_eq_window states fields horizon hfinite x 0
    ⟨le_refl _, hhorizon⟩ radius (hradius 0 ⟨le_refl _, hhorizon⟩)
  rw [hq0]
  apply hlim.congr'
  filter_upwards [htime] with time ht
  exact (bilateralRiemannChainEvolution_eq_window states fields horizon hfinite x time ht
    radius (hradius time ht)).symm

end NumStability
