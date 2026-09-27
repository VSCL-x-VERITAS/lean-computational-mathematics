/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter03.RiemannTwoFamily

/-!
# The intermediate state in a two-family Riemann problem

Equation (3.29) and Figures 3.4–3.5, printed pages 55–56/raw PDF pages
77–78. The two ordered jumps pass through a unique intermediate state.
-/

namespace NumStability

/-- Equation (3.29): the first characteristic component comes from the
right state and the second from the left state. -/
noncomputable def leveque03_twoFamilyIntermediate
    (eigenbasis : Module.Basis (Fin 2) ℝ (Fin 2 → ℝ))
    (left right : Fin 2 → ℝ) : Fin 2 → ℝ :=
  leveque03_characteristicVariables eigenbasis right 0 • eigenbasis 0 +
    leveque03_characteristicVariables eigenbasis left 1 • eigenbasis 1

/-- The first and second state jumps follow their respective eigenvectors. -/
theorem leveque03_twoFamilyIntermediate_jumps
    (eigenbasis : Module.Basis (Fin 2) ℝ (Fin 2 → ℝ))
    (left right : Fin 2 → ℝ) :
    (leveque03_twoFamilyIntermediate eigenbasis left right - left =
      (leveque03_characteristicVariables eigenbasis right 0 -
        leveque03_characteristicVariables eigenbasis left 0) • eigenbasis 0) ∧
    (right - leveque03_twoFamilyIntermediate eigenbasis left right =
      (leveque03_characteristicVariables eigenbasis right 1 -
        leveque03_characteristicVariables eigenbasis left 1) • eigenbasis 1) := by
  have hl := (leveque03_riemannStates_decompose eigenbasis left right).1
  have hr := (leveque03_riemannStates_decompose eigenbasis left right).2
  simp only [Fin.sum_univ_succ, Fin.sum_univ_zero, add_zero] at hl hr
  have hfin : (Fin.succ 0 : Fin 2) = 1 := rfl
  simp only [hfin] at hl hr
  constructor
  · conv_lhs =>
      rhs
      rw [hl]
    ext i
    simp only [leveque03_twoFamilyIntermediate, Pi.add_apply, Pi.sub_apply,
      Pi.smul_apply, smul_eq_mul]
    ring
  · conv_lhs =>
      lhs
      rw [hr]
    ext i
    simp only [leveque03_twoFamilyIntermediate, Pi.add_apply, Pi.sub_apply,
      Pi.smul_apply, smul_eq_mul]
    ring

/-- Between the ordered characteristic rays, the Riemann solution equals
the intermediate state. -/
theorem leveque03_twoFamilyIntermediate_solution
    (eigenbasis : Module.Basis (Fin 2) ℝ (Fin 2 → ℝ))
    (speeds : Fin 2 → ℝ) (hordered : StrictMono speeds)
    (initialState : ℝ → (Fin 2 → ℝ)) (left right : Fin 2 → ℝ)
    (hdata : IsRiemannData initialState left right)
    (X T : ℝ) (hT : 0 < T)
    (hfirst : speeds 0 * T < X) (hsecond : X < speeds 1 * T) :
    leveque03_initialDataSolution eigenbasis speeds initialState X T =
      leveque03_twoFamilyIntermediate eigenbasis left right := by
  have hP : speeds 0 < X / T := (lt_div_iff₀ hT).mpr hfirst
  have hnext : X / T < speeds 1 := (div_lt_iff₀ hT).mpr hsecond
  have hmax (p : Fin 2) (hp : (0 : Fin 2) < p) : X / T < speeds p := by
    fin_cases p
    · simp at hp
    · exact hnext
  have hc := leveque03_riemannSolution_cutoff eigenbasis speeds hordered
    initialState left right hdata X T hT (0 : Fin 2) hP hmax
  simpa [leveque03_twoFamilyIntermediate, Finset.sum_filter,
    Fin.sum_univ_succ] using hc

/-- Figure 3.4(b): the two rays divide positive-time positions into left,
intermediate, and right constant states. -/
theorem leveque03_figure34_threeRegions
    (eigenbasis : Module.Basis (Fin 2) ℝ (Fin 2 → ℝ))
    (speeds : Fin 2 → ℝ) (hordered : StrictMono speeds)
    (initialState : ℝ → (Fin 2 → ℝ)) (left right : Fin 2 → ℝ)
    (hdata : IsRiemannData initialState left right)
    (T : ℝ) (hT : 0 < T) :
    (∀ X, X < speeds 0 * T →
      leveque03_initialDataSolution eigenbasis speeds initialState X T = left) ∧
    (∀ X, speeds 0 * T < X → X < speeds 1 * T →
      leveque03_initialDataSolution eigenbasis speeds initialState X T =
        leveque03_twoFamilyIntermediate eigenbasis left right) ∧
    (∀ X, speeds 1 * T < X →
      leveque03_initialDataSolution eigenbasis speeds initialState X T = right) := by
  refine ⟨?_, ?_, ?_⟩
  · intro X hleft
    have h0 : X / T < speeds 0 := (div_lt_iff₀ hT).mpr hleft
    have h1 : X / T < speeds 1 := lt_trans h0 (hordered (by decide))
    have hoff : ∀ p : Fin 2, X - speeds p * T ≠ 0 := by
      intro p
      fin_cases p
      · exact ne_of_lt (sub_neg.mpr hleft)
      · exact ne_of_lt (sub_neg.mpr ((div_lt_iff₀ hT).mp h1))
    have hq := leveque03_riemannSolution_fromLeft eigenbasis speeds initialState
      left right hdata X T hT hoff
    simpa [Finset.sum_filter, Fin.sum_univ_succ,
      not_lt.mpr h0.le, not_lt.mpr h1.le] using hq
  · intro X hfirst hsecond
    exact leveque03_twoFamilyIntermediate_solution eigenbasis speeds hordered
      initialState left right hdata X T hT hfirst hsecond
  · intro X hright
    have h1 : speeds 1 < X / T := (lt_div_iff₀ hT).mpr hright
    have h0 : speeds 0 < X / T := lt_trans (hordered (by decide)) h1
    have hoff : ∀ p : Fin 2, X - speeds p * T ≠ 0 := by
      intro p
      fin_cases p
      · exact ne_of_gt (sub_pos.mpr ((lt_div_iff₀ hT).mp h0))
      · exact ne_of_gt (sub_pos.mpr hright)
    have hq := leveque03_riemannSolution_fromRight eigenbasis speeds initialState
      left right hdata X T hT hoff
    simpa [Finset.sum_filter, Fin.sum_univ_succ,
      not_lt.mpr h0.le, not_lt.mpr h1.le] using hq

/-- Figure 3.5: interchanging distinct endpoint states changes the
intermediate state. -/
theorem leveque03_twoFamilyIntermediate_swap_ne
    (eigenbasis : Module.Basis (Fin 2) ℝ (Fin 2 → ℝ))
    (left right : Fin 2 → ℝ) (hne : left ≠ right) :
    leveque03_twoFamilyIntermediate eigenbasis left right ≠
      leveque03_twoFamilyIntermediate eigenbasis right left := by
  intro hsame
  have hc := congrArg eigenbasis.equivFun hsame
  have h0 := congrFun hc 0
  have h1 := congrFun hc 1
  simp [leveque03_twoFamilyIntermediate] at h0 h1
  have hl := (leveque03_riemannStates_decompose eigenbasis left right).1
  have hr := (leveque03_riemannStates_decompose eigenbasis left right).2
  simp only [Fin.sum_univ_succ, Fin.sum_univ_zero, add_zero] at hl hr
  have hfin : (Fin.succ 0 : Fin 2) = 1 := rfl
  simp only [hfin] at hl hr
  rw [h0, ← h1] at hr
  exact hne (hl.trans hr.symm)

/-- The intermediate state is the unique intersection of the first-wave
line through the left state and the second-wave line through the right. -/
theorem leveque03_twoFamilyIntermediate_intersection
    (eigenbasis : Module.Basis (Fin 2) ℝ (Fin 2 → ℝ))
    (left right : Fin 2 → ℝ) :
    {q : Fin 2 → ℝ | ∃ α : ℝ, q = left + α • eigenbasis 0} ∩
      {q | ∃ β : ℝ, q = right - β • eigenbasis 1} =
      {leveque03_twoFamilyIntermediate eigenbasis left right} := by
  ext q
  simp only [Set.mem_inter_iff, Set.mem_setOf_eq, Set.mem_singleton_iff]
  constructor
  · rintro ⟨⟨α, hα⟩, ⟨β, hβ⟩⟩
    apply eigenbasis.equivFun.injective
    ext p
    fin_cases p
    · rw [hβ]
      simp [leveque03_twoFamilyIntermediate,
        show leveque03_characteristicVariables eigenbasis right =
          eigenbasis.equivFun right from
            leveque03_characteristicCoordinates eigenbasis right]
    · rw [hα]
      simp [leveque03_twoFamilyIntermediate,
        show leveque03_characteristicVariables eigenbasis left =
          eigenbasis.equivFun left from
            leveque03_characteristicCoordinates eigenbasis left]
  · intro h
    subst q
    have hj := leveque03_twoFamilyIntermediate_jumps eigenbasis left right
    constructor
    · refine ⟨leveque03_characteristicVariables eigenbasis right 0 -
        leveque03_characteristicVariables eigenbasis left 0, ?_⟩
      exact (sub_eq_iff_eq_add).mp hj.1 |>.trans (add_comm _ _)
    · refine ⟨leveque03_characteristicVariables eigenbasis right 1 -
        leveque03_characteristicVariables eigenbasis left 1, ?_⟩
      apply (eq_sub_iff_add_eq).mpr
      simpa only [add_comm] using ((sub_eq_iff_eq_add).mp hj.2).symm

end NumStability
