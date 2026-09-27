/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter03.DomainOfDependence
import ComputationalMathematics.Source.LeVeque.Chapter03.CharacteristicCurves

/-!
# Range of influence and Figure 3.2

Printed page 52/raw PDF page 74. One initial point can influence only its
forward characteristic rays. The figure's three ordered speeds also order
their backward feet and forward rays.
-/

namespace NumStability

/-- The future space-time rays through one initial point, one for each
characteristic family. -/
def leveque03_rangeOfInfluence {m : ℕ} (speeds : Fin m → ℝ)
    (origin : ℝ) : Set (ℝ × ℝ) :=
  {xt | 0 ≤ xt.2 ∧ ∃ p, xt.1 = leveque03_characteristicCurve speeds p origin xt.2}

/-- Domain of dependence and range of influence are reciprocal at
nonnegative times. -/
theorem leveque03_domain_iff_range {m : ℕ} (speeds : Fin m → ℝ)
    (origin X T : ℝ) (hT : 0 ≤ T) :
    origin ∈ leveque03_domainOfDependence speeds X T ↔
      (X, T) ∈ leveque03_rangeOfInfluence speeds origin := by
  constructor
  · rintro ⟨p, hp⟩
    refine ⟨hT, p, ?_⟩
    dsimp [leveque03_characteristicCurve]
    linarith
  · rintro ⟨_, p, hp⟩
    refine ⟨p, ?_⟩
    dsimp [leveque03_characteristicCurve] at hp
    linarith

/-- Changing only the data at `origin` cannot change a solution value
outside all forward rays from that point. -/
theorem leveque03_noInfluenceOutsideRays {m : ℕ}
    (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ) (initialState₁ initialState₂ : ℝ → (Fin m → ℝ))
    (origin X T : ℝ) (hT : 0 ≤ T)
    (hagree : ∀ x, x ≠ origin → initialState₁ x = initialState₂ x)
    (houtside : (X, T) ∉ leveque03_rangeOfInfluence speeds origin) :
    leveque03_initialDataSolution eigenbasis speeds initialState₁ X T =
      leveque03_initialDataSolution eigenbasis speeds initialState₂ X T := by
  apply leveque03_initialDataSolution_dependsOnDomain
    eigenbasis speeds initialState₁ initialState₂ X T
  intro x hx
  apply hagree
  intro heq
  subst x
  exact houtside ((leveque03_domain_iff_range speeds origin X T hT).mp hx)

/-- Figure 3.2: for `λ¹ < 0 < λ² < λ³` and positive time, the three backward
feet occur in reverse order and the three forward rays in speed order. -/
theorem leveque03_figure32_orderedRays
    (speeds : Fin 3 → ℝ) (X origin T : ℝ)
    (hleft : speeds 0 < 0) (hmiddle : 0 < speeds 1)
    (hright : speeds 1 < speeds 2) (hT : 0 < T) :
    X - speeds 2 * T < X - speeds 1 * T ∧
    X - speeds 1 * T < X - speeds 0 * T ∧
    leveque03_characteristicCurve speeds 0 origin T < origin ∧
    origin < leveque03_characteristicCurve speeds 1 origin T ∧
    leveque03_characteristicCurve speeds 1 origin T <
      leveque03_characteristicCurve speeds 2 origin T := by
  have h02 : speeds 0 < speeds 1 := lt_trans hleft hmiddle
  have h21T := mul_lt_mul_of_pos_right hright hT
  have h10T := mul_lt_mul_of_pos_right h02 hT
  have h0T := mul_neg_of_pos_of_neg hT hleft
  have h1T := mul_pos hmiddle hT
  dsimp [leveque03_characteristicCurve]
  refine ⟨?_, ?_, ?_, ?_, ?_⟩ <;> nlinarith

end NumStability
