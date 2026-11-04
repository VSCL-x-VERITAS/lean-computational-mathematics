/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Algebra.Order.Floor.Ring
import Mathlib.Topology.Instances.Real.Lemmas
import Mathlib.Topology.MetricSpace.Pseudo.Lemmas
import Mathlib.Tactic

/-!
# Nondegenerate samples on refining affine grids

Local uniform consistency is imposed only at available sample sites. Continuity
and positivity at one physical point then give an actual positive lattice
sample, even for moving grid origins. A finite grid must cover that point with
an interior margin. All finite witnesses are eventual, so early empty grids
are allowed. No numerical method, stability hypothesis or source-book module
is imported here.
-/

open Set Filter
open scoped Topology

namespace NumStability

/-- Local uniform sampling error on the available sites, without any off-grid
extension of the sampled arrays. The index type may vary with refinement. -/
def LocallyUniformFaceSamples {ι : ℕ → Type*} (β : ℝ → ℝ)
    (site samples : ∀ j, ι j → ℝ) : Prop :=
  ∀ A B : ℝ, A < B → ∀ ε : ℝ, 0 < ε →
    ∀ᶠ j in atTop, ∀ k : ι j,
      site j k ∈ Icc A B → |samples j k - β (site j k)| < ε

/-- The actual floor-selected affine face lies less than one width to the left
of the given physical point. -/
theorem affine_face_floor_proximity (origin width x : ℝ) (hw : 0 < width) :
    0 ≤ x - (origin + (⌊(x - origin) / width⌋ : ℤ) * width) ∧
    x - (origin + (⌊(x - origin) / width⌋ : ℤ) * width) < width := by
  have h0 := Int.sub_floor_div_mul_nonneg (x - origin) hw
  have h1 := Int.sub_floor_div_mul_lt (x - origin) hw
  constructor <;> linarith

/-- Uniformly consistent samples sufficiently near a positive continuity point
are eventually positive. No chosen sample or lower-bound witness is assumed. -/
theorem LocallyUniformFaceSamples.eventually_positive_near
    {ι : ℕ → Type*} {β : ℝ → ℝ} {site samples : ∀ j, ι j → ℝ}
    (hs : LocallyUniformFaceSamples β site samples) {x : ℝ}
    (hc : ContinuousAt β x) (hp : 0 < β x) :
    ∃ δ : ℝ, 0 < δ ∧ ∀ᶠ j in atTop, ∀ k : ι j,
      |site j k - x| < δ → β x / 2 ≤ samples j k := by
  obtain ⟨δ, hδ, hcont⟩ := Metric.continuousAt_iff.mp hc (β x / 4) (by positivity)
  refine ⟨min δ 1, lt_min hδ zero_lt_one, ?_⟩
  filter_upwards [hs (x - 1) (x + 1) (by linarith) (β x / 4) (by positivity)]
    with j hj
  intro k hk
  have hnear := abs_lt.mp (lt_of_lt_of_le hk (min_le_right δ 1))
  have hmem : site j k ∈ Icc (x - 1) (x + 1) := by
    constructor <;> linarith
  have he := abs_lt.mp (hj k hmem)
  have hb := abs_lt.mp (hcont (by
    simpa only [Real.dist_eq] using lt_of_lt_of_le hk (min_le_left δ 1)))
  linarith

/-- Refinement supplies an actual uniformly positive whole-line face. Its index
is the floor of the physical point's affine grid coordinate. -/
theorem LocallyUniformFaceSamples.wholeLine_positive
    {β : ℝ → ℝ} {origin width : ℕ → ℝ} {samples : ℕ → ℤ → ℝ}
    (hs : LocallyUniformFaceSamples β
      (fun (j : ℕ) (k : ℤ) => origin j + (k : ℝ) * width j) samples)
    {x : ℝ} (hc : ContinuousAt β x) (hp : 0 < β x)
    (hw : ∀ j, 0 < width j) (href : Tendsto width atTop (nhds 0)) :
    ∃ c : ℝ, 0 < c ∧ ∀ᶠ j in atTop,
      c ≤ samples j ⌊(x - origin j) / width j⌋ := by
  obtain ⟨δ, hδ, hpos⟩ := hs.eventually_positive_near hc hp
  refine ⟨β x / 2, by positivity, ?_⟩
  filter_upwards [hpos, href.eventually_lt_const hδ] with j hj hwδ
  apply hj
  have hh := affine_face_floor_proximity (origin j) (width j) x (hw j)
  rw [abs_sub_comm, abs_of_nonneg hh.1]
  exact hh.2.trans hwδ

/-- Covering a fixed physical margin produces an actual interior active index.
The selected face index equals that active index, and both adjacent active
inputs exist. -/
theorem affine_face_floor_finite_interior (origin width x R : ℝ) (cells : ℕ)
    (hw : 0 < width) (hR : width < R)
    (hl : origin ≤ x - R) (hr : x + R ≤ origin + (cells : ℝ) * width) :
    ∃ i : Fin cells, 1 ≤ i.val ∧ i.val + 1 < cells ∧
      (i.val : ℤ) = ⌊(x - origin) / width⌋ := by
  let k : ℤ := ⌊(x - origin) / width⌋
  have hh := affine_face_floor_proximity origin width x hw
  have hkpos : (0 : ℝ) < (k : ℝ) * width := by
    dsimp [k]
    linarith
  have hk0 : (0 : ℤ) < k := by
    have : (0 : ℝ) < (k : ℝ) := (mul_pos_iff_of_pos_right hw).mp hkpos
    exact_mod_cast this
  have hkright : ((k : ℝ) + 1) * width < (cells : ℝ) * width := by
    dsimp [k]
    linarith
  have hklt : k + 1 < (cells : ℤ) := by
    have : (k : ℝ) + 1 < (cells : ℝ) := (mul_lt_mul_iff_left₀ hw).mp hkright
    exact_mod_cast this
  have hcast : (k.toNat : ℤ) = k := Int.toNat_of_nonneg hk0.le
  have hnpos : 1 ≤ k.toNat := by omega
  have hnlt : k.toNat + 1 < cells := by omega
  exact ⟨⟨k.toNat, by omega⟩, hnpos, hnlt, hcast⟩

/-- Finite-domain local uniform sampling and actual physical overlap yield a
positive sample at an injected interior active index. Early empty grids impose
no requirement: the witness and its nonempty domain are eventual. -/
theorem LocallyUniformFaceSamples.finite_interior_positive
    {β : ℝ → ℝ} {origin width : ℕ → ℝ} {cells : ℕ → ℕ}
    {samples : ∀ j, Fin (cells j + 1) → ℝ}
    (hs : LocallyUniformFaceSamples β
      (fun (j : ℕ) (k : Fin (cells j + 1)) => origin j + (k.val : ℝ) * width j) samples)
    {x R : ℝ} (hc : ContinuousAt β x) (hp : 0 < β x) (hR : 0 < R)
    (hw : ∀ j, 0 < width j) (href : Tendsto width atTop (nhds 0))
    (hcover : ∀ᶠ j in atTop,
      origin j ≤ x - R ∧ x + R ≤ origin j + (cells j : ℝ) * width j) :
    ∃ c : ℝ, 0 < c ∧ ∀ᶠ j in atTop,
      ∃ i : Fin (cells j), 1 ≤ i.val ∧ i.val + 1 < cells j ∧
        c ≤ samples j ⟨i.val, Nat.lt_succ_of_lt i.isLt⟩ := by
  obtain ⟨δ, hδ, hpos⟩ := hs.eventually_positive_near hc hp
  refine ⟨β x / 2, by positivity, ?_⟩
  filter_upwards [hpos, hcover, href.eventually_lt_const (lt_min hR hδ)]
    with j hj hcov hjw
  obtain ⟨i, hi0, hi1, hki⟩ := affine_face_floor_finite_interior
    (origin j) (width j) x R (cells j) (hw j)
    (hjw.trans_le (min_le_left R δ)) hcov.1 hcov.2
  refine ⟨i, hi0, hi1, hj _ ?_⟩
  have hh := affine_face_floor_proximity (origin j) (width j) x (hw j)
  have hcast : (i.val : ℝ) = (⌊(x - origin j) / width j⌋ : ℤ) := by
    exact_mod_cast hki
  change |origin j + (i.val : ℝ) * width j - x| < δ
  rw [hcast, abs_sub_comm, abs_of_nonneg hh.1]
  exact hh.2.trans (hjw.trans_le (min_le_right R δ))

/-- Eventual interior witnesses give a genuinely nonempty tail, without asking
for a value in `Fin 0` on an early mesh. This form supports reindexing a later
numerical argument onto that tail. -/
theorem exists_interior_sample_tail {cells : ℕ → ℕ}
    {samples : ∀ j, Fin (cells j + 1) → ℝ} {c : ℝ}
    (h : ∀ᶠ j in atTop,
      ∃ i : Fin (cells j), 1 ≤ i.val ∧ i.val + 1 < cells j ∧
        c ≤ samples j ⟨i.val, Nat.lt_succ_of_lt i.isLt⟩) :
    ∃ start : ℕ, ∀ j : ℕ, 3 ≤ cells (j + start) ∧
      ∃ i : Fin (cells (j + start)), 1 ≤ i.val ∧ i.val + 1 < cells (j + start) ∧
        c ≤ samples (j + start) ⟨i.val, Nat.lt_succ_of_lt i.isLt⟩ := by
  obtain ⟨start, hstart⟩ := eventually_atTop.mp h
  refine ⟨start, fun j => ?_⟩
  obtain ⟨i, hi0, hi1, hc⟩ := hstart (j + start) (by omega)
  exact ⟨by omega, i, hi0, hi1, hc⟩

end NumStability
