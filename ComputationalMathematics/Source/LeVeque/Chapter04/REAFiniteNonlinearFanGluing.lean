/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.REAFanAssembly

/-!
# Finite gluing of noninteracting Riemann fan profiles

This set-theoretic construction selects one local profile inside each fan
and the background outside all fans. Pairwise disjoint fan interiors make
the selection independent of the arbitrary choice of a witnessing index.
No linearity of the state space or flux is used.
-/

namespace NumStability

/-- Select a local state on any one of finitely many fan interiors. -/
noncomputable def leveque04_finiteFanGluing {ι V : Type*}
    (indices : Finset ι) (fan : ι → Set ℝ)
    (background : ℝ → V) (riemann : ι → ℝ → V) (x : ℝ) : V := by
  classical
  exact if h : ∃ i, i ∈ indices ∧ x ∈ fan i then
    riemann (Classical.choose h) x
  else background x

/-- Pairwise disjoint fan interiors identify the selected local Riemann
profile, independently of the choice used by the finite gluing operator. -/
theorem leveque04_finiteFanGluing_eq_local {ι V : Type*}
    (indices : Finset ι) (fan : ι → Set ℝ)
    (background : ℝ → V) (riemann : ι → ℝ → V)
    (hdisjoint : ∀ i ∈ indices, ∀ j ∈ indices,
      i ≠ j → Disjoint (fan i) (fan j))
    (j : ι) (hj : j ∈ indices) (x : ℝ) (hx : x ∈ fan j) :
    leveque04_finiteFanGluing indices fan background riemann x =
      riemann j x := by
  classical
  have h : ∃ i, i ∈ indices ∧ x ∈ fan i := ⟨j, hj, hx⟩
  have heq : Classical.choose h = j := by
    have hi := Classical.choose_spec h
    by_contra hne
    exact (Set.disjoint_left.mp
      (hdisjoint (Classical.choose h) hi.1 j hj hne) hi.2 hx).elim
  simp [leveque04_finiteFanGluing, h, heq]

/-- Outside every fan interior, finite gluing gives the background state. -/
theorem leveque04_finiteFanGluing_eq_background {ι V : Type*}
    (indices : Finset ι) (fan : ι → Set ℝ)
    (background : ℝ → V) (riemann : ι → ℝ → V)
    (x : ℝ) (hx : ∀ i ∈ indices, x ∉ fan i) :
    leveque04_finiteFanGluing indices fan background riemann x =
      background x := by
  classical
  have h : ¬ ∃ i, i ∈ indices ∧ x ∈ fan i := by
    rintro ⟨i, hi, hxi⟩
    exact hx i hi hxi
  simp [leveque04_finiteFanGluing, h]

/-- A field with the prescribed local Riemann profiles and background is
uniquely identified with the finite gluing on a noninteracting fan family. -/
theorem leveque04_finiteFanGluing_eq_of_local_background {ι V : Type*}
    (indices : Finset ι) (fan : ι → Set ℝ)
    (background candidate : ℝ → V) (riemann : ι → ℝ → V)
    (hdisjoint : ∀ i ∈ indices, ∀ j ∈ indices,
      i ≠ j → Disjoint (fan i) (fan j))
    (hlocal : ∀ i ∈ indices, ∀ x ∈ fan i,
      candidate x = riemann i x)
    (houtside : ∀ x, (∀ i ∈ indices, x ∉ fan i) →
      candidate x = background x)
    (x : ℝ) :
    candidate x =
      leveque04_finiteFanGluing indices fan background riemann x := by
  by_cases h : ∃ i, i ∈ indices ∧ x ∈ fan i
  · obtain ⟨i, hi, hxi⟩ := h
    rw [hlocal i hi x hxi]
    exact (leveque04_finiteFanGluing_eq_local
      indices fan background riemann hdisjoint i hi x hxi).symm
  · have hx : ∀ i ∈ indices, x ∉ fan i := by
      intro i hi hxi
      exact h ⟨i, hi, hxi⟩
    rw [houtside x hx]
    exact (leveque04_finiteFanGluing_eq_background
      indices fan background riemann x hx).symm

end NumStability
