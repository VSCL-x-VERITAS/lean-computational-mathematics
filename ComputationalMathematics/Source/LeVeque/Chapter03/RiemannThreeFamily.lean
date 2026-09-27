/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter03.RiemannSolution

/-!
# The first wedge in a three-family linear Riemann solution

Equation (3.20), printed page 53/raw PDF page 75, as illustrated by Figure
3.3 on printed page 54/raw PDF page 76. The observation point is strictly
between the first and second characteristic rays.
-/

namespace NumStability

/-- In the first wedge of a three-family system, the first characteristic
strength comes from the right state and the other two from the left state. -/
theorem leveque03_threeFamilyFirstWedge
    (eigenbasis : Module.Basis (Fin 3) ℝ (Fin 3 → ℝ))
    (speeds : Fin 3 → ℝ) (hordered : StrictMono speeds)
    (initialState : ℝ → (Fin 3 → ℝ)) (left right : Fin 3 → ℝ)
    (hdata : IsRiemannData initialState left right)
    (X T : ℝ) (hT : 0 < T)
    (hfirst : speeds 0 * T < X) (hsecond : X < speeds 1 * T) :
    leveque03_initialDataSolution eigenbasis speeds initialState X T =
      (leveque03_characteristicVariables eigenbasis right 0) • eigenbasis 0 +
      (leveque03_characteristicVariables eigenbasis left 1) • eigenbasis 1 +
      (leveque03_characteristicVariables eigenbasis left 2) • eigenbasis 2 := by
  have hP : speeds 0 < X / T := (lt_div_iff₀ hT).mpr hfirst
  have hnext : X / T < speeds 1 := (div_lt_iff₀ hT).mpr hsecond
  have hmax (p : Fin 3) (hp : (0 : Fin 3) < p) : X / T < speeds p := by
    fin_cases p
    · simp at hp
    · exact hnext
    · exact lt_trans hnext (hordered (by decide))
  have hc := leveque03_riemannSolution_cutoff eigenbasis speeds hordered
    initialState left right hdata X T hT (0 : Fin 3) hP hmax
  simpa [Finset.sum_filter, Fin.sum_univ_succ, add_assoc] using hc

end NumStability
