/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter03.RiemannWaveSums

/-!
# Heaviside representation of the linear Riemann solution

Equations (3.27) and (3.28), printed page 55/raw PDF page 77. The source
specifies the two strict branches of the step function but leaves its value
at the origin open. The solution formula is therefore stated off the rays.
-/

namespace NumStability

/-- Equation (3.28), without assigning an origin value. -/
def leveque03_IsHeaviside (H : ℝ → ℝ) : Prop :=
  (∀ x, x < 0 → H x = 0) ∧ (∀ x, 0 < x → H x = 1)

/-- The two strict Heaviside branches are jointly satisfiable. -/
theorem leveque03_heaviside_exists : ∃ H : ℝ → ℝ, leveque03_IsHeaviside H := by
  refine ⟨fun x => if 0 < x then 1 else 0, ?_⟩
  constructor
  · intro x hx
    simp [not_lt.mpr hx.le]
  · intro x hx
    simp [hx]

/-- Equation (3.27): sum the wave vectors whose rays have passed the
observation point. -/
theorem leveque03_riemannSolution_heaviside
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ)
    (initialState : ℝ → (Fin m → ℝ)) (left right : Fin m → ℝ)
    (hdata : IsRiemannData initialState left right)
    (H : ℝ → ℝ) (hH : leveque03_IsHeaviside H)
    (X T : ℝ) (hT : 0 < T) (hoff : ∀ p, X - speeds p * T ≠ 0) :
    leveque03_initialDataSolution eigenbasis speeds initialState X T =
      left + ∑ p, H (X - speeds p * T) •
        leveque03_riemannWave eigenbasis left right p := by
  classical
  have hsum :
      (∑ p ∈ Finset.univ.filter (fun p => speeds p < X / T),
        leveque03_riemannWave eigenbasis left right p) =
      ∑ p, H (X - speeds p * T) •
        leveque03_riemannWave eigenbasis left right p := by
    calc
      (∑ p ∈ Finset.univ.filter (fun p => speeds p < X / T),
          leveque03_riemannWave eigenbasis left right p) =
          ∑ p, if speeds p < X / T then
            leveque03_riemannWave eigenbasis left right p else 0 := by
        symm
        rw [Finset.sum_ite]
        simp
      _ = ∑ p, H (X - speeds p * T) •
            leveque03_riemannWave eigenbasis left right p := by
        apply Finset.sum_congr rfl
        intro p _
        by_cases hp : speeds p < X / T
        · have hfoot : 0 < X - speeds p * T := by
            rw [sub_pos]
            exact (lt_div_iff₀ hT).mp hp
          simp [hp, hH.2 _ hfoot]
        · have hfoot : X - speeds p * T < 0 := by
            have hne := hoff p
            have hnonpos : X - speeds p * T ≤ 0 := by
              rw [sub_nonpos]
              exact (div_le_iff₀ hT).mp (le_of_not_gt hp)
            exact lt_of_le_of_ne hnonpos hne
          simp [hp, hH.1 _ hfoot]
  rw [leveque03_riemannSolution_fromLeft eigenbasis speeds initialState
    left right hdata X T hT hoff, hsum]

end NumStability
