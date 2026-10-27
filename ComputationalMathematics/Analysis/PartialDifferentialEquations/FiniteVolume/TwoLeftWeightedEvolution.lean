/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.ThreePointInfluenceDomains
import Mathlib.Algebra.Module.Submodule.LinearMap
import Mathlib.Algebra.BigOperators.Pi
import Mathlib.Algebra.Module.LinearMap.End
import Mathlib.Algebra.Module.Equiv.Basic
import Mathlib.Data.Nat.Choose.Sum

/-!
# Weighted two-left-cell evolution and its exact influence domain

Repeated weighted shifts are evaluated using the commuting binomial theorem.
Actual functional influence is precisely nonzero coefficient support, including
zero weights. Attaching initial unit cells gives an exact interval union.
-/

noncomputable section
namespace NumStability
open Set
open scoped BigOperators

private def weightedShift (a : ℝ) (d : ℤ) : Module.End ℝ (ℤ → ℝ) :=
  a • LinearMap.funLeft ℝ ℝ (fun i : ℤ => i - d)

private theorem weightedShift_pow (a : ℝ) (d : ℤ) (n : ℕ)
    (old : ℤ → ℝ) (i : ℤ) :
    (weightedShift a d ^ n) old i = a ^ n * old (i - (n : ℤ) * d) := by
  induction n generalizing old i with
  | zero => simp
  | succ n ih =>
    rw [pow_succ', Module.End.mul_apply]
    simp only [weightedShift, LinearMap.smul_apply, Pi.smul_apply,
      smul_eq_mul, LinearMap.funLeft_apply]
    change a * ((weightedShift a d) ^ n) old (i - d) = _
    rw [ih]
    have hindex : i - d - (n : ℤ) * d = i - ((n + 1 : ℕ) : ℤ) * d := by
      push_cast
      ring
    rw [hindex, pow_succ]
    ring

private theorem weightedShift_commute (a b : ℝ) (d e : ℤ) :
    Commute (weightedShift a d) (weightedShift b e) := by
  change weightedShift a d * weightedShift b e =
    weightedShift b e * weightedShift a d
  ext old i
  simp only [Module.End.mul_apply, weightedShift, LinearMap.smul_apply,
    Pi.smul_apply, smul_eq_mul, LinearMap.funLeft_apply]
  have hindex : i - d - e = i - e - d := by ring
  rw [hindex]
  ring

theorem twoLeftWeightedEvolution_eq_binomial_sum :
    ∀ (a b : ℝ) (n : ℕ) (old : ℤ → ℝ) (i : ℤ),
    Nat.iterate (fun values : ℤ → ℝ =>
      fun j => a * values (j-1) + b * values (j-2)) n old i =
      ∑ k ∈ Finset.range (n+1),
        (n.choose k : ℝ) * a^(n-k) * b^k * old (i-(n:ℤ)-(k:ℤ)) := by
  intro a b n old i
  let X := weightedShift b 2
  let Y := weightedShift a 1
  have hfun : (⇑(X + Y)) = (fun values : ℤ → ℝ =>
      fun j => a * values (j - 1) + b * values (j - 2)) := by
    funext values j
    simp [X, Y, weightedShift, add_comm]
  have h := congrArg (fun f : Module.End ℝ (ℤ → ℝ) => f old i)
    ((weightedShift_commute b a 2 1).add_pow n)
  change ((X + Y) ^ n) old i = _ at h
  rw [Module.End.pow_apply, hfun] at h
  rw [h]
  simp only [LinearMap.sum_apply, Finset.sum_apply]
  apply Finset.sum_congr rfl
  intro k hk
  have hkn : k ≤ n := Nat.lt_succ_iff.mp (Finset.mem_range.mp hk)
  simp only [Module.End.mul_apply, weightedShift_pow,
    Module.End.natCast_apply, nsmul_eq_mul]
  change b ^ k * (a ^ (n-k) * ((n.choose k : ℝ) *
    old (i - (k : ℤ) * 2 - ((n-k : ℕ) : ℤ) * 1))) = _
  have hindex : i - (k : ℤ) * 2 - ((n - k : ℕ) : ℤ) * 1 =
      i - (n : ℤ) - (k : ℤ) := by
    rw [Int.ofNat_sub hkn]
    ring
  rw [hindex]
  ring


theorem twoLeftWeightedEvolution_initialSiteInfluences_iff :
    ∀ (a b : ℝ) (n : ℕ) (i site : ℤ),
    InitialSiteInfluences
      (fun _ (values : ℤ → ℝ) j => a * values (j-1) + b * values (j-2))
      n i site ↔
      ∃ k ∈ Finset.range (n+1),
        site = i - (n : ℤ) - (k : ℤ) ∧
        (n.choose k : ℝ) * a^(n-k) * b^k ≠ 0 := by
  classical
  intro a b n i site
  have heval (values : ℤ → ℝ) :
      centeredStencilEvolution
        (fun _ (values : ℤ → ℝ) j => a * values (j-1) + b * values (j-2))
        values n i =
      ∑ k ∈ Finset.range (n+1),
        (n.choose k : ℝ) * a^(n-k) * b^k * values (i-(n:ℤ)-(k:ℤ)) := by
    rw [centeredStencilEvolution_const]
    exact twoLeftWeightedEvolution_eq_binomial_sum a b n values i
  constructor
  · rintro ⟨left, right, houtside, hdifferent⟩
    by_contra hnone
    apply hdifferent
    dsimp only
    rw [heval, heval]
    apply Finset.sum_congr rfl
    intro k hk
    by_cases hsite : site = i - (n : ℤ) - (k : ℤ)
    · have hz : (n.choose k : ℝ) * a^(n-k) * b^k = 0 := by
        by_contra hne
        exact hnone ⟨k, hk, hsite, hne⟩
      rw [hz, zero_mul, zero_mul]
    · rw [houtside _ (Ne.symm hsite)]
  · rintro ⟨k, hk, hsite, hcoefficient⟩
    refine ⟨(fun _ => 0), (fun j => if j = site then 1 else 0), ?_, ?_⟩
    · intro j hj
      simp [hj]
    · dsimp only
      rw [heval, heval]
      simp only [mul_zero, Finset.sum_const_zero]
      have hsingle :
          (∑ l ∈ Finset.range (n+1),
            (n.choose l : ℝ) * a^(n-l) * b^l *
              (if i-(n:ℤ)-(l:ℤ) = site then 1 else 0)) =
            (n.choose k : ℝ) * a^(n-k) * b^k := by
        rw [Finset.sum_eq_single k]
        · simp [← hsite]
        · intro l _hl hlk
          have haway : i - (n : ℤ) - (l : ℤ) ≠ site := by
            intro heq
            apply hlk
            omega
          simp [haway]
        · intro hnot
          exact False.elim (hnot hk)
      rw [hsingle]
      exact Ne.symm hcoefficient


def twoLeftPhysicalCellDomain (courant : ℝ) (n : ℕ) : Set ℝ :=
  {x | ∃ site : ℤ,
    InitialSiteInfluences
      (fun _ (values : ℤ → ℝ) j =>
        (2-courant) * values (j-1) + (courant-1) * values (j-2))
      n 0 site ∧ x ∈ Icc (site : ℝ) ((site : ℝ) + 1)}



private theorem consecutiveUnitCells (offset : ℝ) (n : ℕ) (x : ℝ) :
    (∃ k ≤ n, x ∈ Icc (offset-(k:ℝ)) (offset-(k:ℝ)+1)) ↔
      x ∈ Icc (offset-(n:ℝ)) (offset+1) := by
  constructor
  · rintro ⟨k, hkn, hx⟩
    have hcast : (k : ℝ) ≤ n := by exact_mod_cast hkn
    have hkzero : (0 : ℝ) ≤ k := Nat.cast_nonneg k
    constructor <;> linarith [hx.1, hx.2]
  · intro hx
    induction n with
    | zero => exact ⟨0, le_rfl, by simpa using hx⟩
    | succ n ih =>
      by_cases hcut : offset-(n:ℝ) ≤ x
      · obtain ⟨k, hk, hcell⟩ := ih ⟨hcut, hx.2⟩
        exact ⟨k, Nat.le_trans hk (Nat.le_succ n), hcell⟩
      · refine ⟨n+1, le_rfl, hx.1, ?_⟩
        push_cast
        linarith

theorem twoLeftPhysicalCellDomain_eq :
    ∀ (courant : ℝ) (n : ℕ),
    twoLeftPhysicalCellDomain courant n =
      if courant = 1 then Icc (-(n : ℝ)) (1-(n : ℝ))
      else if courant = 2 then Icc (-2*(n : ℝ)) (1-2*(n : ℝ))
      else Icc (-2*(n : ℝ)) (1-(n : ℝ)) := by
  classical
  intro courant n
  have hdomain (x : ℝ) : x ∈ twoLeftPhysicalCellDomain courant n ↔
      ∃ k ∈ Finset.range (n+1),
        (n.choose k : ℝ) * (2-courant)^(n-k) * (courant-1)^k ≠ 0 ∧
        x ∈ Icc (-(n:ℝ)-(k:ℝ)) (1-(n:ℝ)-(k:ℝ)) := by
    constructor
    · rintro ⟨site, hinfluence, hcell⟩
      obtain ⟨k, hk, hsite, hc⟩ :=
        (twoLeftWeightedEvolution_initialSiteInfluences_iff (2-courant) (courant-1) n 0 site).mp hinfluence
      refine ⟨k, hk, hc, ?_⟩
      rw [hsite] at hcell
      norm_num only [Int.cast_sub, Int.cast_neg, Int.cast_natCast, Int.cast_zero, zero_sub] at hcell
      (convert hcell using 1; congr 1; ring)
    · rintro ⟨k, hk, hc, hcell⟩
      refine ⟨0-(n:ℤ)-(k:ℤ),
        (twoLeftWeightedEvolution_initialSiteInfluences_iff (2-courant) (courant-1) n 0 _).mpr
          ⟨k, hk, rfl, hc⟩, ?_⟩
      norm_num only [Int.cast_sub, Int.cast_neg, Int.cast_natCast, Int.cast_zero, zero_sub]
      (convert hcell using 1; congr 1; ring)
  ext x
  rw [hdomain]
  by_cases h1 : courant = 1
  · simp only [h1, if_pos]
    constructor
    · rintro ⟨k, _hk, hc, hx⟩
      have hkzero : k = 0 := by
        by_contra hne
        have hz : (n.choose k : ℝ) * (2-(1:ℝ))^(n-k) * ((1:ℝ)-1)^k = 0 := by
          rw [sub_self, zero_pow hne, mul_zero]
        exact hc hz
      subst k
      simpa using hx
    · intro hx
      refine ⟨0, Finset.mem_range.mpr (by omega), ?_, ?_⟩
      · simp only [Nat.choose_zero_right, Nat.cast_one, Nat.sub_zero,
          show (2:ℝ)-1=1 by norm_num, pow_zero, one_pow, mul_one]
        exact one_ne_zero
      ·
        simpa using hx
  · by_cases h2 : courant = 2
    · simp only [h2, show (2:ℝ) ≠ 1 by norm_num, if_false, if_pos]
      constructor
      · rintro ⟨k, hk, hc, hx⟩
        have hkn : k ≤ n := Nat.lt_succ_iff.mp (Finset.mem_range.mp hk)
        have hsub : n-k = 0 := by
          by_contra hne
          have hz : (n.choose k : ℝ) * (2-(2:ℝ))^(n-k) * ((2:ℝ)-1)^k = 0 := by
            rw [sub_self, zero_pow hne, mul_zero, zero_mul]
          exact hc hz
        have hkn_eq : k = n := by omega
        subst k
        (convert hx using 1; congr 1) <;> ring
      · intro hx
        refine ⟨n, Finset.mem_range.mpr (by omega), ?_, ?_⟩
        · simp only [Nat.choose_self, Nat.cast_one, Nat.sub_self, pow_zero,
            show (2:ℝ)-1=1 by norm_num, one_pow, mul_one]
          exact one_ne_zero
        · (convert hx using 1; congr 1) <;> ring
    · simp only [h1, h2, if_false]
      have ha : 2-courant ≠ 0 := by intro heq; apply h2; linarith
      have hb : courant-1 ≠ 0 := by intro heq; apply h1; linarith
      have hcoeff (k : ℕ) (hk : k ≤ n) :
          (n.choose k : ℝ) * (2-courant)^(n-k) * (courant-1)^k ≠ 0 :=
        mul_ne_zero (mul_ne_zero (by exact_mod_cast Nat.choose_ne_zero hk)
          (pow_ne_zero _ ha)) (pow_ne_zero _ hb)
      constructor
      · rintro ⟨k, hk, _hc, hx⟩
        have hkn : k ≤ n := Nat.lt_succ_iff.mp (Finset.mem_range.mp hk)
        have hcast : (k : ℝ) ≤ n := by exact_mod_cast hkn
        have hkzero : (0 : ℝ) ≤ k := Nat.cast_nonneg k
        constructor <;> linarith [hx.1, hx.2]
      · intro hx
        have hbounds : x ∈ Icc (-(n:ℝ)-(n:ℝ)) (-(n:ℝ)+1) := by
          constructor <;> linarith [hx.1, hx.2]
        obtain ⟨k, hk, hcell⟩ := (consecutiveUnitCells (-(n:ℝ)) n x).mpr hbounds
        refine ⟨k, Finset.mem_range.mpr (Nat.lt_succ_iff.mpr hk), hcoeff k hk, ?_⟩
        (convert hcell using 1; congr 1; ring)

end NumStability
end
