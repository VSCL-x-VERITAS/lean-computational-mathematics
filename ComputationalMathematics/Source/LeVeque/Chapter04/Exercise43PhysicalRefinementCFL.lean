/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.TwoLeftWeightedEvolution
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.AdvectionRefinementCFL
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage
import ComputationalMathematics.Source.LeVeque.Chapter04.Equation64ModifiedUpwind

/-!
# LeVeque Exercise 4.3(d): physical fixed-time CFL refinement

The printed update is evolved on positive fixed-ratio meshes shrinking at a
fixed physical observation. Its coefficient-sensitive domain carries actual
initial cells. Both full departure-cell inclusion and limiting characteristic
foot coverage hold precisely for Courant numbers in the inclusive interval [1,2].
The initialized evolution uses normalized interval integrals; its locality
identity holds for their totalized values without requiring integrability.
-/

noncomputable section
namespace NumStability
open Set Filter
open scoped Topology BigOperators

/-- The printed fixed method at one member of the existing fixed-ratio physical mesh family. -/
def Leveque04Eq64RefinementUpdate
    (speed T courant : ℝ) (n : ℕ) : ℕ → (ℤ → ℝ) → ℤ → ℝ :=
  fun _ values j => leveque04_equation64_step speed (T / ((n+1 : ℕ) : ℝ))
    (fixedRatioRefinementCellWidth T (courant/speed) n)
    (values (j-2)) (values (j-1)) (values j)

/-- Actual coefficient-sensitive influence, attached to the physical initial cells centered at X+j*dx. -/
def Leveque04Eq64RefinementDomain
    (speed X T courant : ℝ) (n : ℕ) : Set ℝ :=
  {x | ∃ site : ℤ,
    InitialSiteInfluences (Leveque04Eq64RefinementUpdate speed T courant n)
      (n+1) 0 site ∧
    x ∈ Icc
      (X + (site:ℝ) * fixedRatioRefinementCellWidth T (courant/speed) n -
        fixedRatioRefinementCellWidth T (courant/speed) n / 2)
      (X + (site:ℝ) * fixedRatioRefinementCellWidth T (courant/speed) n +
        fixedRatioRefinementCellWidth T (courant/speed) n / 2)}

/-- The characteristic foot at the fixed physical observation lies in the limiting numerical domain. -/
def IsLeveque04Eq64RefinementCFL (speed X T courant : ℝ) : Prop :=
  ∀ ε : ℝ, 0 < ε → ∃ N : ℕ, ∀ n : ℕ, N ≤ n →
    ∃ x ∈ Leveque04Eq64RefinementDomain speed X T courant n,
      |x - (X-speed*T)| < ε

def Leveque04Eq64PhysicalRefinementCFLTarget : Prop :=
  ∀ (speed X T courant : ℝ), 0 < speed → 0 < T → 0 < courant →
    (∀ n : ℕ,
      0 < T / ((n+1 : ℕ) : ℝ) ∧
      0 < fixedRatioRefinementCellWidth T (courant/speed) n ∧
      ((n+1 : ℕ) : ℝ) * (T / ((n+1 : ℕ) : ℝ)) = T ∧
      speed * (T / ((n+1 : ℕ) : ℝ)) /
        fixedRatioRefinementCellWidth T (courant/speed) n = courant) ∧
    Tendsto (fun n : ℕ => T / ((n+1 : ℕ) : ℝ)) atTop (𝓝 0) ∧
    Tendsto (fixedRatioRefinementCellWidth T (courant/speed)) atTop (𝓝 0) ∧
    (∀ (n : ℕ) (left right : ℝ → ℝ),
      EqOn left right (Leveque04Eq64RefinementDomain speed X T courant n) →
      centeredStencilEvolution (Leveque04Eq64RefinementUpdate speed T courant n)
        (fun j : ℤ => oneDimensionalCellAverage left
          (X + (j:ℝ) * fixedRatioRefinementCellWidth T (courant/speed) n -
            fixedRatioRefinementCellWidth T (courant/speed) n / 2)
          (X + (j:ℝ) * fixedRatioRefinementCellWidth T (courant/speed) n +
            fixedRatioRefinementCellWidth T (courant/speed) n / 2)) (n+1) 0 =
      centeredStencilEvolution (Leveque04Eq64RefinementUpdate speed T courant n)
        (fun j : ℤ => oneDimensionalCellAverage right
          (X + (j:ℝ) * fixedRatioRefinementCellWidth T (courant/speed) n -
            fixedRatioRefinementCellWidth T (courant/speed) n / 2)
          (X + (j:ℝ) * fixedRatioRefinementCellWidth T (courant/speed) n +
            fixedRatioRefinementCellWidth T (courant/speed) n / 2)) (n+1) 0) ∧
    ((∀ n : ℕ,
      Icc (X-speed*T-fixedRatioRefinementCellWidth T (courant/speed) n/2)
        (X-speed*T+fixedRatioRefinementCellWidth T (courant/speed) n/2) ⊆
        Leveque04Eq64RefinementDomain speed X T courant n) ↔
      1 ≤ courant ∧ courant ≤ 2) ∧
    (IsLeveque04Eq64RefinementCFL speed X T courant ↔
      1 ≤ courant ∧ courant ≤ 2)


private theorem eq64RefinementMesh (speed T courant : ℝ)
    (hspeed : 0 < speed) (hT : 0 < T) (hcourant : 0 < courant) (n : ℕ) :
    0 < T / ((n+1 : ℕ) : ℝ) ∧
    0 < fixedRatioRefinementCellWidth T (courant/speed) n ∧
    ((n+1 : ℕ) : ℝ) * (T / ((n+1 : ℕ) : ℝ)) = T ∧
    speed * (T / ((n+1 : ℕ) : ℝ)) /
      fixedRatioRefinementCellWidth T (courant/speed) n = courant := by
  have hn : 0 < ((n+1 : ℕ) : ℝ) := by positivity
  have hratio := div_pos hcourant hspeed
  refine ⟨div_pos hT hn, div_pos hT (mul_pos hratio hn), ?_, ?_⟩
  · field_simp
  · unfold fixedRatioRefinementCellWidth
    field_simp [ne_of_gt hn, ne_of_gt hT, ne_of_gt hspeed, ne_of_gt hcourant]

private theorem eq64RefinementUpdate (speed T courant : ℝ)
    (hspeed : 0 < speed) (hT : 0 < T) (hcourant : 0 < courant) (n : ℕ) :
    Leveque04Eq64RefinementUpdate speed T courant n =
      (fun _ (values : ℤ → ℝ) j =>
        (2-courant) * values (j-1) + (courant-1) * values (j-2)) := by
  funext k values j
  dsimp [Leveque04Eq64RefinementUpdate]
  rw [leveque04_equation64 speed _ _ _ _ _ hspeed
    (ne_of_gt (eq64RefinementMesh speed T courant hspeed hT hcourant n).2.1)]
  rw [(eq64RefinementMesh speed T courant hspeed hT hcourant n).2.2.2]
  ring

private theorem eq64RefinementTimeTendsto (T : ℝ) :
    Tendsto (fun n : ℕ => T / ((n+1 : ℕ) : ℝ)) atTop (𝓝 0) := by
  simpa only [Nat.cast_add, Nat.cast_one, div_eq_mul_inv, one_mul, mul_zero] using
    (tendsto_one_div_add_atTop_nhds_zero_nat (𝕜 := ℝ)).const_mul T

private theorem eq64RefinementWidthTendsto (T ratio : ℝ) (hratio : 0 < ratio) :
    Tendsto (fixedRatioRefinementCellWidth T ratio) atTop (𝓝 0) := by
  have h : Tendsto (fun n : ℕ => fixedRatioRefinementCellWidth T ratio n / 2)
      atTop (𝓝 0) := by
    simpa only [Nat.cast_zero, mul_zero, zero_mul, zero_add, zero_div] using
      fixedRatioRefinement_cellConeRadius_tendsto T ratio 0 hratio
  simpa only [div_mul_cancel₀ _ (by norm_num : (2:ℝ) ≠ 0), zero_mul] using h.mul_const 2



private theorem eq64PhysicalCellNormalized (X width x : ℝ) (hwidth : 0 < width) (site : ℤ) :
    (x-X)/width+1/2 ∈ Icc (site:ℝ) ((site:ℝ)+1) ↔
    x ∈ Icc (X+(site:ℝ)*width-width/2) (X+(site:ℝ)*width+width/2) := by
  constructor
  · intro hx
    have hl := mul_le_mul_of_nonneg_right hx.1 (le_of_lt hwidth)
    have hr := mul_le_mul_of_nonneg_right hx.2 (le_of_lt hwidth)
    have hdiv := div_mul_cancel₀ (x-X) (ne_of_gt hwidth)
    constructor <;> nlinarith
  · intro hx
    have hl : (site:ℝ)-1/2 ≤ (x-X)/width :=
      (le_div_iff₀ hwidth).2 (by nlinarith [hx.1])
    have hr : (x-X)/width ≤ (site:ℝ)+1/2 :=
      (div_le_iff₀ hwidth).2 (by nlinarith [hx.2])
    constructor <;> linarith

private theorem eq64RefinementDomainNormalized (speed X T courant : ℝ)
    (hspeed : 0 < speed) (hT : 0 < T) (hcourant : 0 < courant) (n : ℕ) (x : ℝ) :
    x ∈ Leveque04Eq64RefinementDomain speed X T courant n ↔
      (x-X)/fixedRatioRefinementCellWidth T (courant/speed) n+1/2 ∈
        twoLeftPhysicalCellDomain courant (n+1) := by
  unfold Leveque04Eq64RefinementDomain twoLeftPhysicalCellDomain
  rw [eq64RefinementUpdate speed T courant hspeed hT hcourant n]
  constructor
  · rintro ⟨site, hinfluence, hcell⟩
    exact ⟨site, hinfluence,
      (eq64PhysicalCellNormalized X _ x
        (eq64RefinementMesh speed T courant hspeed hT hcourant n).2.1 site).mpr hcell⟩
  · rintro ⟨site, hinfluence, hcell⟩
    exact ⟨site, hinfluence,
      (eq64PhysicalCellNormalized X _ x
        (eq64RefinementMesh speed T courant hspeed hT hcourant n).2.1 site).mp hcell⟩

private theorem eq64RefinementTravel (speed T courant : ℝ)
    (hspeed : 0 < speed) (hT : 0 < T) (hcourant : 0 < courant) (n : ℕ) :
    ((n+1 : ℕ) : ℝ) * fixedRatioRefinementCellWidth T (courant/speed) n =
      speed*T/courant := by
  have hn : ((n+1 : ℕ) : ℝ) ≠ 0 := by positivity
  unfold fixedRatioRefinementCellWidth
  field_simp [hn, ne_of_gt hspeed, ne_of_gt hcourant]



private theorem eq64RefinementDomainBounds (speed X T courant : ℝ)
    (hspeed : 0 < speed) (hT : 0 < T) (hcourant : 0 < courant) (n : ℕ) :
    Leveque04Eq64RefinementDomain speed X T courant n =
      if courant = 1 ∨ courant = 2 then
        Icc (X-speed*T-fixedRatioRefinementCellWidth T (courant/speed) n/2)
          (X-speed*T+fixedRatioRefinementCellWidth T (courant/speed) n/2)
      else
        Icc (X-2*(speed*T/courant)-fixedRatioRefinementCellWidth T (courant/speed) n/2)
          (X-speed*T/courant+fixedRatioRefinementCellWidth T (courant/speed) n/2) := by
  have hw := (eq64RefinementMesh speed T courant hspeed hT hcourant n).2.1
  have ht := eq64RefinementTravel speed T courant hspeed hT hcourant n
  ext x
  rw [eq64RefinementDomainNormalized speed X T courant hspeed hT hcourant n x,
    twoLeftPhysicalCellDomain_eq courant (n+1)]
  by_cases h1 : courant = 1
  · subst courant
    simp only [true_or, if_true, mem_Icc] at *
    simp only [div_one] at ht
    constructor
    · intro hx
      have hl := mul_le_mul_of_nonneg_right hx.1 (le_of_lt hw)
      have hr := mul_le_mul_of_nonneg_right hx.2 (le_of_lt hw)
      have hd := div_mul_cancel₀ (x-X) (ne_of_gt hw)
      constructor <;> nlinarith
    · intro hx
      constructor
      · have h := (le_div_iff₀ hw).2 (show (-(↑(n+1):ℝ)-1/2)*_ ≤ x-X by nlinarith [hx.1])
        linarith
      · have h := (div_le_iff₀ hw).2 (show x-X ≤ (1-(↑(n+1):ℝ)-1/2)*_ by nlinarith [hx.2])
        linarith
  · by_cases h2 : courant = 2
    · subst courant
      simp only [if_neg h1, or_true, if_true, mem_Icc]
      constructor
      · intro hx
        have hl := mul_le_mul_of_nonneg_right hx.1 (le_of_lt hw)
        have hr := mul_le_mul_of_nonneg_right hx.2 (le_of_lt hw)
        have hd := div_mul_cancel₀ (x-X) (ne_of_gt hw)
        constructor <;> nlinarith
      · intro hx
        constructor
        · have h := (le_div_iff₀ hw).2 (show (-2*(↑(n+1):ℝ)-1/2)*_ ≤ x-X by nlinarith [hx.1])
          linarith
        · have h := (div_le_iff₀ hw).2 (show x-X ≤ (1-2*(↑(n+1):ℝ)-1/2)*_ by nlinarith [hx.2])
          linarith
    · simp only [if_neg h1, if_neg h2, if_neg (not_or.mpr ⟨h1,h2⟩), mem_Icc]
      constructor
      · intro hx
        have hl := mul_le_mul_of_nonneg_right hx.1 (le_of_lt hw)
        have hr := mul_le_mul_of_nonneg_right hx.2 (le_of_lt hw)
        have hd := div_mul_cancel₀ (x-X) (ne_of_gt hw)
        constructor <;> nlinarith
      · intro hx
        constructor
        · have h := (le_div_iff₀ hw).2 (show (-2*(↑(n+1):ℝ)-1/2)*_ ≤ x-X by nlinarith [hx.1])
          linarith
        · have h := (div_le_iff₀ hw).2 (show x-X ≤ (1-(↑(n+1):ℝ)-1/2)*_ by nlinarith [hx.2])
          linarith



private theorem eq64RefinementFiniteCoverage (speed X T courant : ℝ)
    (hspeed : 0 < speed) (hT : 0 < T) (hcourant : 0 < courant)
    (h1 : 1 ≤ courant) (h2 : courant ≤ 2) (n : ℕ) :
    Icc (X-speed*T-fixedRatioRefinementCellWidth T (courant/speed) n/2)
        (X-speed*T+fixedRatioRefinementCellWidth T (courant/speed) n/2) ⊆
      Leveque04Eq64RefinementDomain speed X T courant n := by
  rw [eq64RefinementDomainBounds speed X T courant hspeed hT hcourant n]
  split_ifs with he
  · exact Subset.rfl
  · have hS : 0 < speed*T := mul_pos hspeed hT
    have hl : speed*T ≤ 2*(speed*T/courant) := by
      have hd := div_mul_cancel₀ (speed*T) (ne_of_gt hcourant)
      have h := mul_le_mul_of_nonneg_left h2 (le_of_lt hS)
      nlinarith
    have hr : speed*T/courant ≤ speed*T :=
      (div_le_iff₀ hcourant).2 (by nlinarith)
    intro x hx
    exact ⟨by linarith [hx.1], by linarith [hx.2]⟩

private theorem eq64RefinementCFLIff (speed X T courant : ℝ)
    (hspeed : 0 < speed) (hT : 0 < T) (hcourant : 0 < courant) :
    IsLeveque04Eq64RefinementCFL speed X T courant ↔
      1 ≤ courant ∧ courant ≤ 2 := by
  have hS : 0 < speed*T := mul_pos hspeed hT
  have hw := eq64RefinementWidthTendsto T (courant/speed) (div_pos hcourant hspeed)
  constructor
  · intro hcfl
    have lower : 1 ≤ courant := by
      by_contra hn
      have hc : courant < 1 := lt_of_not_ge hn
      have he : ¬(courant=1 ∨ courant=2) := by intro he; rcases he with h|h <;> linarith
      have hgap : 0 < speed*T/courant-speed*T := by
        have h := (lt_div_iff₀ hcourant).2 (show speed*T*courant < speed*T by nlinarith)
        linarith
      obtain ⟨N,hN⟩ := hcfl ((speed*T/courant-speed*T)/4) (by positivity)
      have hev := (tendsto_order.mp hw).2 ((speed*T/courant-speed*T)/2) (by positivity)
      obtain ⟨M,hM⟩ := eventually_atTop.mp hev
      obtain ⟨x,hx,hclose⟩ := hN (max N M) (le_max_left _ _)
      have hwidth := hM (max N M) (le_max_right _ _)
      rw [eq64RefinementDomainBounds speed X T courant hspeed hT hcourant,
        if_neg he] at hx
      have hdist := (abs_lt.mp hclose).1
      nlinarith [hx.2]
    have upper : courant ≤ 2 := by
      by_contra hn
      have hc : 2 < courant := lt_of_not_ge hn
      have he : ¬(courant=1 ∨ courant=2) := by intro he; rcases he with h|h <;> linarith
      have hgap : 0 < speed*T-2*(speed*T/courant) := by
        have hd := div_mul_cancel₀ (speed*T) (ne_of_gt hcourant)
        have hp := mul_pos hS (show 0 < courant-2 by linarith)
        nlinarith
      obtain ⟨N,hN⟩ := hcfl ((speed*T-2*(speed*T/courant))/4) (by positivity)
      have hev := (tendsto_order.mp hw).2 ((speed*T-2*(speed*T/courant))/2) (by positivity)
      obtain ⟨M,hM⟩ := eventually_atTop.mp hev
      obtain ⟨x,hx,hclose⟩ := hN (max N M) (le_max_left _ _)
      have hwidth := hM (max N M) (le_max_right _ _)
      rw [eq64RefinementDomainBounds speed X T courant hspeed hT hcourant,
        if_neg he] at hx
      have hdist := (abs_lt.mp hclose).2
      nlinarith [hx.1]
    exact ⟨lower,upper⟩
  · rintro ⟨h1,h2⟩ ε hε
    refine ⟨0, fun n _ => ⟨X-speed*T, ?_, ?_⟩⟩
    · apply eq64RefinementFiniteCoverage speed X T courant hspeed hT hcourant h1 h2 n
      have hp := (eq64RefinementMesh speed T courant hspeed hT hcourant n).2.1
      exact ⟨by linarith, by linarith⟩
    · simpa using hε



theorem leveque04_exercise43_physicalRefinementCFL :
    Leveque04Eq64PhysicalRefinementCFLTarget := by
  classical
  intro speed X T courant hspeed hT hcourant
  refine ⟨eq64RefinementMesh speed T courant hspeed hT hcourant,
    eq64RefinementTimeTendsto T,
    eq64RefinementWidthTendsto T (courant/speed) (div_pos hcourant hspeed),
    ?_, ?_, eq64RefinementCFLIff speed X T courant hspeed hT hcourant⟩
  · intro n left right heq
    rw [eq64RefinementUpdate speed T courant hspeed hT hcourant n,
      centeredStencilEvolution_const, centeredStencilEvolution_const,
      twoLeftWeightedEvolution_eq_binomial_sum, twoLeftWeightedEvolution_eq_binomial_sum]
    apply Finset.sum_congr rfl
    intro k hk
    by_cases hz : ((n+1).choose k : ℝ) * (2-courant)^((n+1)-k) * (courant-1)^k = 0
    · rw [hz, zero_mul, zero_mul]
    · congr 1
      unfold oneDimensionalCellAverage
      congr 1
      apply intervalIntegral.integral_congr
      have hw := (eq64RefinementMesh speed T courant hspeed hT hcourant n).2.1
      rw [uIcc_of_le (show
        X+(↑(0-((n+1 : ℕ):ℤ)-(k:ℤ)):ℝ)*fixedRatioRefinementCellWidth T (courant/speed) n-
          fixedRatioRefinementCellWidth T (courant/speed) n/2 ≤
        X+(↑(0-((n+1 : ℕ):ℤ)-(k:ℤ)):ℝ)*fixedRatioRefinementCellWidth T (courant/speed) n+
          fixedRatioRefinementCellWidth T (courant/speed) n/2 by linarith)]
      intro x hx
      apply heq
      refine ⟨0-((n+1 : ℕ):ℤ)-(k:ℤ), ?_, hx⟩
      rw [eq64RefinementUpdate speed T courant hspeed hT hcourant n]
      exact (twoLeftWeightedEvolution_initialSiteInfluences_iff
        (2-courant) (courant-1) (n+1) 0 _).mpr ⟨k,hk,rfl,hz⟩
  · constructor
    · intro hcover
      apply (eq64RefinementCFLIff speed X T courant hspeed hT hcourant).mp
      intro ε hε
      refine ⟨0, fun n _ => ⟨X-speed*T, hcover n ?_, ?_⟩⟩
      · have hw := (eq64RefinementMesh speed T courant hspeed hT hcourant n).2.1
        exact ⟨by linarith, by linarith⟩
      · simpa using hε
    · rintro ⟨h1,h2⟩
      exact eq64RefinementFiniteCoverage speed X T courant hspeed hT hcourant h1 h2


end NumStability
end
