/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.ThreePointInfluenceDomains

/-!
# Influence of a positive three-point update

Strictly positive coefficients prevent cancellation of a nonnegative impulse.
For this fixed update the actual single-coordinate influence set equals the
complete radius-`steps` interval. This is a statement about discrete initial
arrays; PDE data classes and physical initialization require separate bridges.
-/

namespace NumStability

def weightedThreePointStep (left center right : ℤ → ℝ) (u : ℤ → ℝ) (i : ℤ) : ℝ :=
  left i * u (i - 1) + center i * u i + right i * u (i + 1)

theorem weightedThreePointEvolution_nonneg
    (left center right : ℤ → ℝ)
    (hl : ∀ i, 0 ≤ left i) (hc : ∀ i, 0 ≤ center i) (hr : ∀ i, 0 ≤ right i)
    (u : ℤ → ℝ) (hu : ∀ i, 0 ≤ u i) (n : ℕ) :
    ∀ i, 0 ≤ centeredStencilEvolution
      (fun _ => weightedThreePointStep left center right) u n i := by
  induction n with
  | zero => exact hu
  | succ n ih =>
    intro i
    exact add_nonneg (add_nonneg (mul_nonneg (hl i) (ih (i - 1)))
      (mul_nonneg (hc i) (ih i))) (mul_nonneg (hr i) (ih (i + 1)))

theorem weightedThreePointEvolution_zero
    (left center right : ℤ → ℝ) (n : ℕ) :
    centeredStencilEvolution (fun _ => weightedThreePointStep left center right)
      (fun _ => 0) n = (fun _ => 0) := by
  induction n with
  | zero => rfl
  | succ n ih =>
    funext i
    simp [centeredStencilEvolution, ih, weightedThreePointStep]

theorem weightedThreePointEvolution_pos_of_mem_interval
    (left center right : ℤ → ℝ)
    (hl : ∀ i, 0 < left i) (hc : ∀ i, 0 < center i) (hr : ∀ i, 0 < right i)
    (u : ℤ → ℝ) (hu : ∀ i, 0 ≤ u i) (site : ℤ) (hsite : 0 < u site)
    (n : ℕ) (i : ℤ) (h : site ∈ Set.Icc (i - (n : ℤ)) (i + (n : ℤ))) :
    0 < centeredStencilEvolution
      (fun _ => weightedThreePointStep left center right) u n i := by
  induction n generalizing i with
  | zero =>
    have heq : site = i := by have := h.1; have := h.2; omega
    simpa [centeredStencilEvolution, heq] using hsite
  | succ n ih =>
    have hn := weightedThreePointEvolution_nonneg left center right
      (fun j => (hl j).le) (fun j => (hc j).le) (fun j => (hr j).le) u hu n
    change 0 < left i * centeredStencilEvolution
      (fun _ => weightedThreePointStep left center right) u n (i - 1) +
      center i * centeredStencilEvolution
        (fun _ => weightedThreePointStep left center right) u n i +
      right i * centeredStencilEvolution
        (fun _ => weightedThreePointStep left center right) u n (i + 1)
    rcases lt_trichotomy site i with hlt | heq | hgt
    · have hm : site ∈ Set.Icc ((i - 1) - (n : ℤ)) ((i - 1) + (n : ℤ)) := by
        constructor <;> have := h.1 <;> have := h.2 <;> omega
      have hp := mul_pos (hl i) (ih (i - 1) hm)
      linarith [mul_nonneg (hc i).le (hn i), mul_nonneg (hr i).le (hn (i + 1))]
    · have hm : site ∈ Set.Icc (i - (n : ℤ)) (i + (n : ℤ)) := by
        constructor <;> omega
      have hp := mul_pos (hc i) (ih i hm)
      linarith [mul_nonneg (hl i).le (hn (i - 1)), mul_nonneg (hr i).le (hn (i + 1))]
    · have hm : site ∈ Set.Icc ((i + 1) - (n : ℤ)) ((i + 1) + (n : ℤ)) := by
        constructor <;> have := h.1 <;> have := h.2 <;> omega
      have hp := mul_pos (hr i) (ih (i + 1) hm)
      linarith [mul_nonneg (hl i).le (hn (i - 1)), mul_nonneg (hc i).le (hn i)]

theorem weightedThreePoint_initialSiteInfluences_iff
    (left center right : ℤ → ℝ)
    (hl : ∀ i, 0 < left i) (hc : ∀ i, 0 < center i) (hr : ∀ i, 0 < right i)
    (n : ℕ) (i site : ℤ) :
    InitialSiteInfluences (fun _ => weightedThreePointStep left center right) n i site ↔
      site ∈ Set.Icc (i - (n : ℤ)) (i + (n : ℤ)) := by
  constructor
  · exact threePoint_fixedMethod_influence_subset
      (fun _ j a b c => left j * a + center j * b + right j * c) n i site
  · intro h
    let impulse : ℤ → ℝ := fun j => if j = site then 1 else 0
    have hnonneg : ∀ j, 0 ≤ impulse j := by
      intro j
      dsimp [impulse]
      split_ifs <;> norm_num
    have hpositive : 0 < impulse site := by simp [impulse]
    have hp := weightedThreePointEvolution_pos_of_mem_interval
      left center right hl hc hr impulse hnonneg site hpositive n i h
    refine ⟨(fun _ => 0), impulse, ?_, ?_⟩
    · intro j hj
      simp [impulse, hj]
    · change centeredStencilEvolution
        (fun _ => weightedThreePointStep left center right) (fun _ => 0) n i ≠ _
      rw [weightedThreePointEvolution_zero]
      exact ne_of_lt hp

end NumStability
