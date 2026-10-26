/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Topology.MetricSpace.Pseudo.Lemmas
import Mathlib.Topology.Instances.Real.Lemmas
import Mathlib.Algebra.Order.Floor.Ring
import Mathlib.Tactic

/-!
# Physical coverage by refining integer grids

Compatible finite-radius grids approach every point of their limiting
interval. Expanding finite grids with shrinking spacing approach every real
point even when the origin is omitted. Floor inequalities give the witnesses.
-/

open Set Filter
open scoped Topology
namespace NumStability

/-- A compatible refining three-point read graph fills its limiting physical
interval. Each target point is the limit of actual reachable grid sites. -/
theorem threePoint_refining_sites_fill_interval
    (X radius : ℝ) (width : ℕ → ℝ) (steps : ℕ → ℕ)
    (hwidth : ∀ k, 0 < width k)
    (hscale : ∀ k, (steps k : ℝ)*width k = radius)
    (hw : Tendsto width atTop (nhds 0)) :
    ∀ y ∈ Icc (X-radius) (X+radius), ∃ site : ℕ → ℤ,
      (∀ k, -(steps k : ℤ) ≤ site k ∧ site k ≤ steps k) ∧
      Tendsto (fun k => X+(site k : ℝ)*width k) atTop (nhds y) := by
  intro y hy
  let site := fun k => Int.floor ((y-X)/width k)
  have hbound (k : ℕ) : -(steps k : ℤ) ≤ site k ∧ site k ≤ steps k := by
    have hl : -((steps k : ℤ) : ℝ) ≤ (y-X)/width k := by
      apply (le_div_iff₀ (hwidth k)).mpr
      simp only [Int.cast_natCast]
      nlinarith [hy.1,hscale k]
    have hr : (y-X)/width k ≤ ((steps k : ℤ) : ℝ) := by
      apply (div_le_iff₀ (hwidth k)).mpr
      simp only [Int.cast_natCast]
      nlinarith [hy.2,hscale k]
    constructor
    · exact Int.le_floor.mpr (by simpa only [Int.cast_neg] using hl)
    · have hs := Int.floor_le ((y-X)/width k)
      exact_mod_cast hs.trans hr
  refine ⟨site,hbound,?_⟩
  apply tendsto_iff_dist_tendsto_zero.mpr
  apply squeeze_zero (fun _ => dist_nonneg) _ hw
  intro k
  have hle := Int.floor_le ((y-X)/width k)
  have hlt := Int.lt_floor_add_one ((y-X)/width k)
  have hlmul := mul_le_mul_of_nonneg_right hle (hwidth k).le
  have hrmul := mul_lt_mul_of_pos_right hlt (hwidth k)
  have hcancel : ((y-X)/width k)*width k = y-X := div_mul_cancel₀ _ (hwidth k).ne'
  rw [hcancel] at hlmul hrmul
  rw [Real.dist_eq]
  apply abs_le.mpr
  dsimp [site]
  constructor <;> linarith

/-- Every physical point is approached by nonzero sites in a shrinking lattice.
If the finite grid's physical radius grows without bound, these sites are
eventually inside that finite grid. The omission of one initial cell creates
no gap in this limiting spatial coverage. -/
theorem expandingGrid_offOrigin_fill_line
    (X : ℝ) (width : ℕ → ℝ) (cap : ℕ → ℕ)
    (hwidth : ∀ k, 0 < width k)
    (hw : Tendsto width atTop (nhds 0))
    (hcap : Tendsto (fun k => (cap k : ℝ)*width k) atTop atTop) :
    ∀ y : ℝ, ∃ site : ℕ → ℤ,
      (∀ k, site k ≠ 0) ∧
      (∀ k, dist (X+(site k : ℝ)*width k) y ≤ width k) ∧
      (∀ᶠ k in atTop, -(cap k : ℤ) ≤ site k ∧ site k ≤ cap k) ∧
      Tendsto (fun k => X+(site k : ℝ)*width k) atTop (nhds y) := by
  intro y
  let site := fun k => if Int.floor ((y-X)/width k) = 0 then 1
    else Int.floor ((y-X)/width k)
  have hnonzero (k : ℕ) : site k ≠ 0 := by
    dsimp [site]
    split_ifs with h <;> simp_all
  have herror (k : ℕ) : dist (X+(site k : ℝ)*width k) y ≤ width k := by
    have hf := Int.floor_le ((y-X)/width k)
    have hg := Int.lt_floor_add_one ((y-X)/width k)
    have hl := mul_le_mul_of_nonneg_right hf (hwidth k).le
    have hr := mul_lt_mul_of_pos_right hg (hwidth k)
    have hc : ((y-X)/width k)*width k = y-X := div_mul_cancel₀ _ (hwidth k).ne'
    rw [hc] at hl hr
    rw [Real.dist_eq]
    apply abs_le.mpr
    dsimp [site]
    split_ifs with h
    · simp only [h,Int.cast_zero,zero_mul,zero_add] at hl hr
      norm_num only [Int.cast_one]
      constructor <;> linarith
    · constructor <;> nlinarith
  have hbound : ∀ᶠ k in atTop, -(cap k : ℤ) ≤ site k ∧ site k ≤ cap k := by
    filter_upwards [hw.eventually_lt_const (by norm_num : (0 : ℝ) < 1),
      hcap.eventually_gt_atTop (|y-X|+2)] with k hk hc
    have he := abs_le.mp (by simpa only [Real.dist_eq] using herror k)
    have hlo := neg_abs_le (y-X)
    have hhi := le_abs_self (y-X)
    have hl : -((cap k : ℤ) : ℝ) ≤ (site k : ℝ) := by
      simp only [Int.cast_natCast]
      nlinarith [hwidth k]
    have hr : (site k : ℝ) ≤ ((cap k : ℤ) : ℝ) := by
      simp only [Int.cast_natCast]
      nlinarith [hwidth k]
    constructor
    · exact_mod_cast hl
    · exact_mod_cast hr
  refine ⟨site,hnonzero,herror,hbound,?_⟩
  exact tendsto_iff_dist_tendsto_zero.mpr (squeeze_zero (fun _ => dist_nonneg) herror hw)



/-- Every point within the physical radius is within two mesh widths of a
parity-compatible site, including when the step count is odd. -/
theorem finiteParityGrid_near_point
    (steps : ℕ) (width X y : ℝ) (hwidth : 0 < width)
    (hy : |y - X| ≤ (steps : ℝ) * width) :
    ∃ slot : ℕ, slot ≤ steps ∧
      dist (X + (((-(steps : ℤ) + 2 * (slot : ℤ)) : ℤ) : ℝ) * width) y <
        2 * width := by
  have hbounds := abs_le.mp hy
  have htwo : 0 < 2 * width := by positivity
  let q : ℝ := (y - X + (steps : ℝ) * width) / (2 * width)
  have hq0 : 0 ≤ q := by
    dsimp only [q]
    exact div_nonneg (by linarith [hbounds.1]) htwo.le
  have hqn : q ≤ (steps : ℝ) := by
    dsimp only [q]
    apply (div_le_iff₀ htwo).mpr
    nlinarith [hbounds.2]
  let slot : ℕ := Nat.floor q
  refine ⟨slot, Nat.floor_le_of_le hqn, ?_⟩
  have hle : (slot : ℝ) ≤ q := Nat.floor_le hq0
  have hlt : q < (slot : ℝ) + 1 := Nat.lt_floor_add_one q
  have hlmul := mul_le_mul_of_nonneg_right hle htwo.le
  have hrmul := mul_lt_mul_of_pos_right hlt htwo
  have hcancel : q * (2 * width) = y - X + (steps : ℝ) * width := by
    dsimp only [q]
    exact div_mul_cancel₀ _ htwo.ne'
  rw [hcancel] at hlmul hrmul
  rw [Real.dist_eq]
  push_cast
  apply abs_lt.mpr
  constructor <;> nlinarith

/-- A shrinking parity lattice with unbounded physical radius approaches every
point at every sufficiently fine level, independently of the changing parity. -/
theorem expandingParityGrid_eventually_near
    (X : ℝ) (width : ℕ → ℝ) (steps : ℕ → ℕ)
    (hwidth : ∀ k, 0 < width k) (hw : Tendsto width atTop (nhds 0))
    (hradius : Tendsto (fun k => (steps k : ℝ) * width k) atTop atTop) :
    ∀ (y ε : ℝ), 0 < ε → ∀ᶠ k in atTop,
      ∃ slot : ℕ, slot ≤ steps k ∧
        dist (X + (((-(steps k : ℤ) + 2 * (slot : ℤ)) : ℤ) : ℝ) * width k) y < ε := by
  intro y ε hε
  have heps : (0 : ℝ) < ε / 2 := half_pos hε
  filter_upwards [hradius.eventually_gt_atTop |y - X|,
    hw.eventually_lt_const heps] with k hk hsmall
  obtain ⟨slot, hslot, herror⟩ :=
    finiteParityGrid_near_point (steps k) (width k) X y (hwidth k) hk.le
  refine ⟨slot, hslot, herror.trans ?_⟩
  linarith

end NumStability
