/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.ThreePointStencilReachability
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateInfluence
import Mathlib.Tactic

/-!
# Fixed-method influence and three-point read graphs

Defines actual functional influence for one fixed three-point evolution and
separates it from the fixed syntactic read graph and influence attainable across
the class of callbacks. Every fixed method has influence contained in the graph;
the class union fills it. Inputs are unrestricted and this is not an admissible
perturbation or whole-line PDE support theorem.
-/

open Set
namespace NumStability

/-- Actual functional influence at one initial site for a fixed evolution. -/
def InitialSiteInfluences (update : ℕ → (ℤ → ℝ) → ℤ → ℝ)
    (steps : ℕ) (observation site : ℤ) : Prop :=
  SingleCoordinateInfluences
    (fun initial => centeredStencilEvolution update initial steps observation) site

/-- Possible influence over the allowed class; this is an explicit union of
fixed-method influence domains, not the domain of each particular method. -/
def threePointPermittedInfluenceDomain (steps : ℕ) (observation : ℤ) : Set ℤ :=
  {site | ∃ F : ℕ → ℤ → ℝ → ℝ → ℝ → ℝ,
    InitialSiteInfluences
      (fun k u j => F k j (u (j-1)) (u j) (u (j+1))) steps observation site}

theorem threePoint_fixedMethod_influence_subset
    (F : ℕ → ℤ → ℝ → ℝ → ℝ → ℝ) (steps : ℕ) (observation site : ℤ)
    (h : InitialSiteInfluences
      (fun k u j => F k j (u (j-1)) (u j) (u (j+1))) steps observation site) :
    site ∈ Icc (observation-(steps : ℤ)) (observation+(steps : ℤ)) := by
  obtain ⟨left,right,houtside,hdifferent⟩ := h
  by_contra hsite
  apply hdifferent
  apply centeredStencilEvolution_locality
    (fun k u j => F k j (u (j-1)) (u j) (u (j+1))) 1
  · intro k a b j hlocal
    rw [hlocal (j-1) (by constructor <;> omega),hlocal j (by constructor <;> omega),
      hlocal (j+1) (by constructor <;> omega)]
  · intro j hj
    apply houtside
    intro heq
    apply hsite
    simpa only [Nat.cast_one,mul_one,heq] using hj

theorem threePoint_permittedInfluenceDomain_eq (steps : ℕ) (observation : ℤ) :
    threePointPermittedInfluenceDomain steps observation =
      Icc (observation-(steps : ℤ)) (observation+(steps : ℤ)) := by
  ext site
  constructor
  · rintro ⟨F,h⟩
    exact threePoint_fixedMethod_influence_subset F steps observation site h
  · intro hsite
    have hz : -(steps : ℤ) ≤ site-observation ∧ site-observation ≤ steps := by
      constructor <;> linarith [hsite.1,hsite.2]
    obtain ⟨F,hF⟩ := threePointEvolution_possibleRead steps (site-observation) hz (E := ℝ)
    refine ⟨F,(fun _ => 0),(fun j => if j=site then 1 else 0),?_,?_⟩
    · intro j hj
      simp [hj]
    · dsimp only
      rw [hF _ observation,hF _ observation]
      simp

/-- Actual fixed-method influence can be empty although permitted influence
covers the full stencil interval. -/
theorem threePoint_constantCallback_no_influence
    (steps : ℕ) (observation site : ℤ) :
    ¬ InitialSiteInfluences (fun _ _ _ => 0) (steps+1) observation site := by
  rintro ⟨left,right,_,hdiff⟩
  exact hdiff (threePointEvolution_constantCallback left right steps observation)

/-- The fixed syntactic read graph of the displayed three-point update;
its edge offsets are independent of the values returned by the callback. -/
def threePointStencilReadGraphDomain (steps : ℕ) (observation : ℤ) : Set ℤ :=
  {site | ∃ offset : ℕ → ℤ,
    (∀ k < steps, -1 ≤ offset k ∧ offset k ≤ 1) ∧
    ∑ k ∈ Finset.range steps, offset k = site-observation}

theorem threePoint_readGraphDomain_eq (steps : ℕ) (observation : ℤ) :
    threePointStencilReadGraphDomain steps observation =
      Icc (observation-(steps : ℤ)) (observation+(steps : ℤ)) := by
  ext site
  constructor
  · rintro ⟨offset,hbound,hsum⟩
    have hl : (∑ _k ∈ Finset.range steps, (-1 : ℤ)) ≤
        ∑ k ∈ Finset.range steps, offset k :=
      Finset.sum_le_sum (fun k hk => (hbound k (Finset.mem_range.mp hk)).1)
    have hr : (∑ k ∈ Finset.range steps, offset k) ≤
        ∑ _k ∈ Finset.range steps, (1 : ℤ) :=
      Finset.sum_le_sum (fun k hk => (hbound k (Finset.mem_range.mp hk)).2)
    simp only [Finset.sum_const,Finset.card_range,hsum,smul_neg,nsmul_eq_mul,mul_one] at hl hr
    constructor <;> linarith
  · intro hsite
    apply threePointOffsets_reach_interval
    constructor <;> linarith [hsite.1,hsite.2]

theorem threePoint_readGraph_eq_permittedInfluence (steps : ℕ) (observation : ℤ) :
    threePointStencilReadGraphDomain steps observation =
      threePointPermittedInfluenceDomain steps observation := by
  rw [threePoint_readGraphDomain_eq,threePoint_permittedInfluenceDomain_eq]


end NumStability
