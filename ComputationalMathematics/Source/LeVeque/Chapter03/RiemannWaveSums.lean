/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter03.RiemannWaveStrength
import ComputationalMathematics.Source.LeVeque.Chapter03.RiemannCoordinates

/-!
# Wave-sum forms of the linear Riemann solution

Equations (3.25) and (3.26), printed page 54/raw PDF page 76. The solution
may be built from the left state by adding passed waves or from the right
state by subtracting waves still ahead of the observation point.
-/

namespace NumStability

/-- Equation (3.25): start with the left state and add every wave whose
characteristic speed lies below the observation slope. -/
theorem leveque03_riemannSolution_fromLeft
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ)
    (initialState : ℝ → (Fin m → ℝ)) (left right : Fin m → ℝ)
    (hdata : IsRiemannData initialState left right)
    (X T : ℝ) (hT : 0 < T) (hoff : ∀ p, X - speeds p * T ≠ 0) :
    leveque03_initialDataSolution eigenbasis speeds initialState X T =
      left + ∑ p ∈ Finset.univ.filter (fun p => speeds p < X / T),
        leveque03_riemannWave eigenbasis left right p := by
  classical
  let hcond : Fin m → Prop := fun p => 0 < X - speeds p * T
  let fL : Fin m → (Fin m → ℝ) := fun p =>
    leveque03_characteristicVariables eigenbasis left p • eigenbasis p
  let fR : Fin m → (Fin m → ℝ) := fun p =>
    leveque03_characteristicVariables eigenbasis right p • eigenbasis p
  let fW : Fin m → (Fin m → ℝ) := fun p =>
    leveque03_riemannWave eigenbasis left right p
  have hpoint (p : Fin m) : fR p = fL p + fW p := by
    simp only [fR, fL, fW, leveque03_riemannWave, leveque03_waveStrength]
    rw [sub_smul]
    abel
  have hsum :
      (∑ p, if hcond p then fR p else fL p) =
        (∑ p, fL p) + (∑ p, if hcond p then fW p else 0) := by
    rw [← Finset.sum_add_distrib]
    apply Finset.sum_congr rfl
    intro p _
    by_cases hp : hcond p
    · simp [hp, hpoint p]
    · simp [hp]
  have hset : Finset.univ.filter hcond =
      Finset.univ.filter (fun p : Fin m => speeds p < X / T) := by
    ext p
    simp only [Finset.mem_filter, Finset.mem_univ, true_and, hcond]
    rw [sub_pos, lt_div_iff₀ hT]
  calc
    leveque03_initialDataSolution eigenbasis speeds initialState X T =
        ∑ p, if hcond p then fR p else fL p := by
      simpa only [hcond, fR, fL] using
        leveque03_riemannSolution_offRays eigenbasis speeds initialState
          left right hdata X T hoff
    _ = (∑ p, fL p) + (∑ p, if hcond p then fW p else 0) := hsum
    _ = left + ∑ p ∈ Finset.univ.filter (fun p => speeds p < X / T),
          leveque03_riemannWave eigenbasis left right p := by
      conv_rhs =>
        lhs
        rw [(leveque03_riemannStates_decompose eigenbasis left right).1]
      simp only [fL, fW, Finset.sum_ite, Finset.sum_const_zero, add_zero,
        hset]

/-- Equation (3.26): start with the right state and subtract every wave whose
characteristic speed lies above the observation slope. -/
theorem leveque03_riemannSolution_fromRight
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ)
    (initialState : ℝ → (Fin m → ℝ)) (left right : Fin m → ℝ)
    (hdata : IsRiemannData initialState left right)
    (X T : ℝ) (hT : 0 < T) (hoff : ∀ p, X - speeds p * T ≠ 0) :
    leveque03_initialDataSolution eigenbasis speeds initialState X T =
      right - ∑ p ∈ Finset.univ.filter (fun p => X / T < speeds p),
        leveque03_riemannWave eigenbasis left right p := by
  classical
  let hcond : Fin m → Prop := fun p => 0 < X - speeds p * T
  let fL : Fin m → (Fin m → ℝ) := fun p =>
    leveque03_characteristicVariables eigenbasis left p • eigenbasis p
  let fR : Fin m → (Fin m → ℝ) := fun p =>
    leveque03_characteristicVariables eigenbasis right p • eigenbasis p
  let fW : Fin m → (Fin m → ℝ) := fun p =>
    leveque03_riemannWave eigenbasis left right p
  have hpoint (p : Fin m) : fL p = fR p - fW p := by
    simp only [fR, fL, fW, leveque03_riemannWave, leveque03_waveStrength]
    rw [sub_smul]
    abel
  have hsum :
      (∑ p, if hcond p then fR p else fL p) =
        (∑ p, fR p) - (∑ p, if ¬ hcond p then fW p else 0) := by
    rw [← Finset.sum_sub_distrib]
    apply Finset.sum_congr rfl
    intro p _
    by_cases hp : hcond p
    · simp [hp]
    · simp [hp, hpoint p]
  have hset : Finset.univ.filter (fun p : Fin m => ¬ hcond p) =
      Finset.univ.filter (fun p : Fin m => X / T < speeds p) := by
    ext p
    simp only [Finset.mem_filter, Finset.mem_univ, true_and, hcond]
    rw [div_lt_iff₀ hT]
    constructor
    · intro hn
      rcases lt_trichotomy (X - speeds p * T) 0 with hneg | heq | hpos
      · exact sub_neg.mp hneg
      · exact False.elim ((hoff p) heq)
      · exact False.elim (hn hpos)
    · intro h
      exact not_lt.mpr (sub_nonpos.mpr h.le)
  calc
    leveque03_initialDataSolution eigenbasis speeds initialState X T =
        ∑ p, if hcond p then fR p else fL p := by
      simpa only [hcond, fR, fL] using
        leveque03_riemannSolution_offRays eigenbasis speeds initialState
          left right hdata X T hoff
    _ = (∑ p, fR p) - (∑ p, if ¬ hcond p then fW p else 0) := hsum
    _ = right - ∑ p ∈ Finset.univ.filter (fun p => X / T < speeds p),
          leveque03_riemannWave eigenbasis left right p := by
      conv_rhs =>
        lhs
        rw [(leveque03_riemannStates_decompose eigenbasis left right).2]
      simp only [fR, fW, Finset.sum_ite, Finset.sum_const_zero, add_zero,
        hset]

end NumStability
