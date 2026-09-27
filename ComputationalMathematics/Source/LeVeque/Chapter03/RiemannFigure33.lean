/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter03.RiemannWaveSums
import ComputationalMathematics.Source.LeVeque.Chapter03.RiemannThreeFamily

/-!
# The four states in Figure 3.3

Printed page 54/raw PDF page 76. For three strictly ordered wave families,
the Riemann solution has left and right exterior states and two intermediate
states formed by successive wave jumps. The figure's marked point lies in
the first intermediate wedge.
-/

namespace NumStability

/-- All three wave vectors sum to the right-minus-left Riemann jump. -/
theorem leveque03_sumRiemannWaves
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (left right : Fin m → ℝ) :
    ∑ p, leveque03_riemannWave eigenbasis left right p = right - left := by
  have hcoord := (leveque03_waveStrength_fromJump eigenbasis left right).2.2
  calc
    ∑ p, leveque03_riemannWave eigenbasis left right p =
        ∑ p, (leveque03_characteristicVariables eigenbasis (right - left) p) •
          eigenbasis p := by
      apply Finset.sum_congr rfl
      intro p _
      simp only [leveque03_riemannWave]
      rw [(hcoord p).2]
    _ = right - left :=
      (leveque03_eigenvectorSuperposition eigenbasis
        (fun _ _ => right - left) 0 0).symm

/-- The four Figure 3.3 states progress from `qₗ` to `qᵣ` by adding waves
one, two, and three in their ordered directions. -/
theorem leveque03_figure33_fourStates
    (eigenbasis : Module.Basis (Fin 3) ℝ (Fin 3 → ℝ))
    (left right : Fin 3 → ℝ) :
    let W := leveque03_riemannWave eigenbasis left right
    let qlStar := left + W 0
    let qrStar := qlStar + W 1
    qrStar + W 2 = right := by
  dsimp only
  have hsum := leveque03_sumRiemannWaves eigenbasis left right
  simp only [Fin.sum_univ_succ, Fin.sum_univ_zero] at hsum
  ext i
  have hi := congrFun hsum i
  simp only [Pi.add_apply, Pi.sub_apply, add_zero] at hi ⊢
  norm_num at hi
  linarith

/-- The marked point in the first wedge has the first intermediate state. -/
theorem leveque03_figure33_firstWedge
    (eigenbasis : Module.Basis (Fin 3) ℝ (Fin 3 → ℝ))
    (speeds : Fin 3 → ℝ) (hordered : StrictMono speeds)
    (initialState : ℝ → (Fin 3 → ℝ)) (left right : Fin 3 → ℝ)
    (hdata : IsRiemannData initialState left right)
    (X T : ℝ) (hT : 0 < T)
    (hfirst : speeds 0 * T < X) (hsecond : X < speeds 1 * T) :
    leveque03_initialDataSolution eigenbasis speeds initialState X T =
      left + leveque03_riemannWave eigenbasis left right 0 := by
  have hq := leveque03_threeFamilyFirstWedge eigenbasis speeds hordered
    initialState left right hdata X T hT hfirst hsecond
  have hl := (leveque03_riemannStates_decompose eigenbasis left right).1
  rw [hq]
  conv_rhs =>
    lhs
    rw [hl]
  ext i
  simp only [Fin.sum_univ_succ, Fin.sum_univ_zero,
    leveque03_riemannWave, leveque03_waveStrength,
    Pi.add_apply, Pi.smul_apply,
    smul_eq_mul, add_zero, sub_mul]
  norm_num
  ring

/-- The next wedge has the second intermediate state. -/
theorem leveque03_figure33_secondWedge
    (eigenbasis : Module.Basis (Fin 3) ℝ (Fin 3 → ℝ))
    (speeds : Fin 3 → ℝ) (hordered : StrictMono speeds)
    (initialState : ℝ → (Fin 3 → ℝ)) (left right : Fin 3 → ℝ)
    (hdata : IsRiemannData initialState left right)
    (X T : ℝ) (hT : 0 < T)
    (hfirst : speeds 1 * T < X) (hsecond : X < speeds 2 * T) :
    leveque03_initialDataSolution eigenbasis speeds initialState X T =
      left + leveque03_riemannWave eigenbasis left right 0 +
        leveque03_riemannWave eigenbasis left right 1 := by
  have h0 : speeds 0 < X / T :=
    lt_trans (hordered (by decide)) ((lt_div_iff₀ hT).mpr hfirst)
  have h1 : speeds 1 < X / T := (lt_div_iff₀ hT).mpr hfirst
  have h2 : X / T < speeds 2 := (div_lt_iff₀ hT).mpr hsecond
  have hoff : ∀ p : Fin 3, X - speeds p * T ≠ 0 := by
    intro p
    fin_cases p
    · exact ne_of_gt (sub_pos.mpr ((lt_div_iff₀ hT).mp h0))
    · exact ne_of_gt (sub_pos.mpr hfirst)
    · exact ne_of_lt (sub_neg.mpr hsecond)
  have hq := leveque03_riemannSolution_fromLeft eigenbasis speeds initialState
    left right hdata X T hT hoff
  simpa [Finset.sum_filter, Fin.sum_univ_succ, h0, h1,
    not_lt.mpr h2.le, add_assoc] using hq

/-- Left of all three rays the Riemann state is the left datum. -/
theorem leveque03_figure33_leftExterior
    (eigenbasis : Module.Basis (Fin 3) ℝ (Fin 3 → ℝ))
    (speeds : Fin 3 → ℝ) (hordered : StrictMono speeds)
    (initialState : ℝ → (Fin 3 → ℝ)) (left right : Fin 3 → ℝ)
    (hdata : IsRiemannData initialState left right)
    (X T : ℝ) (hT : 0 < T) (hleft : X < speeds 0 * T) :
    leveque03_initialDataSolution eigenbasis speeds initialState X T = left := by
  have h0 : X / T < speeds 0 := (div_lt_iff₀ hT).mpr hleft
  have h1 : X / T < speeds 1 := lt_trans h0 (hordered (by decide))
  have h2 : X / T < speeds 2 := lt_trans h1 (hordered (by decide))
  have hoff : ∀ p : Fin 3, X - speeds p * T ≠ 0 := by
    intro p
    fin_cases p
    · exact ne_of_lt (sub_neg.mpr hleft)
    · exact ne_of_lt (sub_neg.mpr ((div_lt_iff₀ hT).mp h1))
    · exact ne_of_lt (sub_neg.mpr ((div_lt_iff₀ hT).mp h2))
  have hq := leveque03_riemannSolution_fromLeft eigenbasis speeds initialState
    left right hdata X T hT hoff
  simpa [Finset.sum_filter, Fin.sum_univ_succ,
    not_lt.mpr h0.le, not_lt.mpr h1.le, not_lt.mpr h2.le] using hq

/-- Right of all three rays the Riemann state is the right datum. -/
theorem leveque03_figure33_rightExterior
    (eigenbasis : Module.Basis (Fin 3) ℝ (Fin 3 → ℝ))
    (speeds : Fin 3 → ℝ) (hordered : StrictMono speeds)
    (initialState : ℝ → (Fin 3 → ℝ)) (left right : Fin 3 → ℝ)
    (hdata : IsRiemannData initialState left right)
    (X T : ℝ) (hT : 0 < T) (hright : speeds 2 * T < X) :
    leveque03_initialDataSolution eigenbasis speeds initialState X T = right := by
  have h2 : speeds 2 < X / T := (lt_div_iff₀ hT).mpr hright
  have h1 : speeds 1 < X / T := lt_trans (hordered (by decide)) h2
  have h0 : speeds 0 < X / T := lt_trans (hordered (by decide)) h1
  have hoff : ∀ p : Fin 3, X - speeds p * T ≠ 0 := by
    intro p
    fin_cases p
    · exact ne_of_gt (sub_pos.mpr ((lt_div_iff₀ hT).mp h0))
    · exact ne_of_gt (sub_pos.mpr ((lt_div_iff₀ hT).mp h1))
    · exact ne_of_gt (sub_pos.mpr hright)
  have hq := leveque03_riemannSolution_fromRight eigenbasis speeds initialState
    left right hdata X T hT hoff
  simpa [Finset.sum_filter, Fin.sum_univ_succ,
    not_lt.mpr h0.le, not_lt.mpr h1.le, not_lt.mpr h2.le] using hq

end NumStability
