/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter03.RiemannCoordinates
import ComputationalMathematics.Source.LeVeque.Chapter03.CauchySolution

/-!
# The linear Riemann solution away from characteristic rays

Equation (3.19), printed page 53/raw PDF page 75. Each family contributes
its right coefficient where its ray lies to the left of the observation point,
and its left coefficient where the ray lies to the right. The source leaves
values on characteristic rays unspecified, so this statement excludes them.
-/

namespace NumStability

/-- The constructed Riemann solution is the sum of the two selected families
of right eigenvectors, partitioned by the sign of each characteristic foot. -/
theorem leveque03_riemannSolution_offRays
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ)
    (initialState : ℝ → (Fin m → ℝ)) (left right : Fin m → ℝ)
    (hdata : IsRiemannData initialState left right)
    (X T : ℝ) (hoff : ∀ p, X - speeds p * T ≠ 0) :
    leveque03_initialDataSolution eigenbasis speeds initialState X T =
      ∑ p, if 0 < X - speeds p * T then
          (leveque03_characteristicVariables eigenbasis right p) • eigenbasis p
        else
          (leveque03_characteristicVariables eigenbasis left p) • eigenbasis p := by
  rw [leveque03_initialDataSolution_formula]
  apply Finset.sum_congr rfl
  intro p _
  rcases lt_trichotomy (X - speeds p * T) 0 with hneg | heq | hpos
  · rw [if_neg (not_lt.mpr hneg.le), hdata.1 _ hneg]
    exact congrArg (fun c => c • eigenbasis p)
      (leveque03_characteristicVariable_leftEigenvector eigenbasis
        (fun _ _ => left) p 0 0).symm
  · exact False.elim ((hoff p) heq)
  · rw [if_pos hpos, hdata.2 _ hpos]
    exact congrArg (fun c => c • eigenbasis p)
      (leveque03_characteristicVariable_leftEigenvector eigenbasis
        (fun _ _ => right) p 0 0).symm

/-- Equation (3.19): for positive time, speeds below `X / T` contribute the
right Riemann coefficients and speeds above it contribute the left ones. -/
theorem leveque03_riemannSolution_speedPartition
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ)
    (initialState : ℝ → (Fin m → ℝ)) (left right : Fin m → ℝ)
    (hdata : IsRiemannData initialState left right)
    (X T : ℝ) (hT : 0 < T) (hoff : ∀ p, X - speeds p * T ≠ 0) :
    leveque03_initialDataSolution eigenbasis speeds initialState X T =
      (∑ p ∈ Finset.univ.filter (fun p => speeds p < X / T),
        (leveque03_characteristicVariables eigenbasis right p) • eigenbasis p) +
      (∑ p ∈ Finset.univ.filter (fun p => X / T < speeds p),
        (leveque03_characteristicVariables eigenbasis left p) • eigenbasis p) := by
  classical
  have hright (p : Fin m) :
      (0 < X - speeds p * T) ↔ speeds p < X / T := by
    rw [sub_pos, lt_div_iff₀ hT]
  have hleft (p : Fin m) :
      (¬ 0 < X - speeds p * T) ↔ X / T < speeds p := by
    rw [div_lt_iff₀ hT]
    constructor
    · intro hn
      have hneg : X - speeds p * T < 0 := by
        rcases lt_trichotomy (X - speeds p * T) 0 with hneg | heq | hpos
        · exact hneg
        · exact False.elim ((hoff p) heq)
        · exact False.elim (hn hpos)
      linarith
    · intro h
      linarith
  have hrset : Finset.univ.filter (fun p : Fin m => 0 < X - speeds p * T) =
      Finset.univ.filter (fun p => speeds p < X / T) := by
    ext p
    simp only [Finset.mem_filter, Finset.mem_univ, true_and]
    exact hright p
  have hlset : Finset.univ.filter (fun p : Fin m => ¬ 0 < X - speeds p * T) =
      Finset.univ.filter (fun p => X / T < speeds p) := by
    ext p
    simp only [Finset.mem_filter, Finset.mem_univ, true_and]
    exact hleft p
  rw [leveque03_riemannSolution_offRays eigenbasis speeds initialState left right
    hdata X T hoff, Finset.sum_ite, hrset, hlset]

/-- Equation (3.18) when `P` is the largest family whose characteristic ray
lies to the left of the observation point. The printed family numbering is
one-based; `Fin m` uses zero-based indices. The maximal family exists by the
explicit `P` hypothesis, and no value is selected on a characteristic ray. -/
theorem leveque03_riemannSolution_cutoff
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ) (hordered : StrictMono speeds)
    (initialState : ℝ → (Fin m → ℝ)) (left right : Fin m → ℝ)
    (hdata : IsRiemannData initialState left right)
    (X T : ℝ) (hT : 0 < T) (P : Fin m)
    (hP : speeds P < X / T)
    (hmax : ∀ p, P < p → X / T < speeds p) :
    leveque03_initialDataSolution eigenbasis speeds initialState X T =
      (∑ p ∈ Finset.univ.filter (fun p => p ≤ P),
        (leveque03_characteristicVariables eigenbasis right p) • eigenbasis p) +
      (∑ p ∈ Finset.univ.filter (fun p => P < p),
        (leveque03_characteristicVariables eigenbasis left p) • eigenbasis p) := by
  classical
  have hoff : ∀ p, X - speeds p * T ≠ 0 := by
    intro p
    by_cases hle : p ≤ P
    · have hlt : speeds p < X / T :=
        lt_of_le_of_lt (hordered.monotone hle) hP
      have hfoot : 0 < X - speeds p * T := by
        rw [sub_pos]
        exact (lt_div_iff₀ hT).mp hlt
      exact ne_of_gt hfoot
    · have hgt := hmax p (lt_of_not_ge hle)
      have hfoot : X - speeds p * T < 0 := by
        rw [sub_neg]
        exact (div_lt_iff₀ hT).mp hgt
      exact ne_of_lt hfoot
  have hrset : Finset.univ.filter (fun p : Fin m => speeds p < X / T) =
      Finset.univ.filter (fun p => p ≤ P) := by
    ext p
    simp only [Finset.mem_filter, Finset.mem_univ, true_and]
    constructor
    · intro hs
      by_contra hn
      exact (not_lt_of_ge (hmax p (lt_of_not_ge hn)).le) hs
    · intro hp
      exact lt_of_le_of_lt (hordered.monotone hp) hP
  have hlset : Finset.univ.filter (fun p : Fin m => X / T < speeds p) =
      Finset.univ.filter (fun p => P < p) := by
    ext p
    simp only [Finset.mem_filter, Finset.mem_univ, true_and]
    constructor
    · intro hs
      by_contra hn
      have hp : p ≤ P := le_of_not_gt hn
      exact (not_lt_of_ge (lt_of_le_of_lt (hordered.monotone hp) hP).le) hs
    · exact hmax p
  rw [leveque03_riemannSolution_speedPartition eigenbasis speeds initialState
    left right hdata X T hT hoff, hrset, hlset]

end NumStability
