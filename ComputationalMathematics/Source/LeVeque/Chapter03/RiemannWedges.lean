/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter03.RiemannSolution

/-!
# Constant wedge states and one-family changes

The prose following equations (3.20) and (3.21), printed page 53/raw PDF page
75. An off-ray linear Riemann solution is constant where all characteristic
foot signs agree. Crossing only the `p`th ray changes only that wave's
coefficient.
-/

namespace NumStability

/-- Two off-ray observations in the same characteristic wedge have the same
Riemann state. Equality of every characteristic-foot sign describes the wedge
without choosing values on its boundary rays. -/
theorem leveque03_riemannSolution_sameWedge
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ)
    (initialState : ℝ → (Fin m → ℝ)) (left right : Fin m → ℝ)
    (hdata : IsRiemannData initialState left right)
    (X T Y S : ℝ)
    (hoffX : ∀ p, X - speeds p * T ≠ 0)
    (hoffY : ∀ p, Y - speeds p * S ≠ 0)
    (hsame : ∀ p, (0 < X - speeds p * T) ↔ (0 < Y - speeds p * S)) :
    leveque03_initialDataSolution eigenbasis speeds initialState X T =
      leveque03_initialDataSolution eigenbasis speeds initialState Y S := by
  rw [leveque03_riemannSolution_offRays eigenbasis speeds initialState left right
    hdata X T hoffX,
    leveque03_riemannSolution_offRays eigenbasis speeds initialState left right
      hdata Y S hoffY]
  apply Finset.sum_congr rfl
  intro p _
  by_cases hp : 0 < X - speeds p * T
  · have hq := (hsame p).mp hp
    simp [hp, hq]
  · have hq : ¬ 0 < Y - speeds p * S := fun h => hp ((hsame p).mpr h)
    simp [hp, hq]

/-- If only the `p`th ray separates two off-ray observations, the state change
is exactly the difference of their `p`th characteristic strengths in the
`p`th right-eigenvector direction. -/
theorem leveque03_singleWaveJump
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ)
    (initialState : ℝ → (Fin m → ℝ)) (left right : Fin m → ℝ)
    (hdata : IsRiemannData initialState left right)
    (p : Fin m) (XL TL XR TR : ℝ)
    (hoffL : ∀ j, XL - speeds j * TL ≠ 0)
    (hoffR : ∀ j, XR - speeds j * TR ≠ 0)
    (hleft : XL - speeds p * TL < 0)
    (hright : 0 < XR - speeds p * TR)
    (hsame : ∀ j, j ≠ p →
      ((0 < XL - speeds j * TL) ↔ (0 < XR - speeds j * TR))) :
    leveque03_initialDataSolution eigenbasis speeds initialState XR TR -
      leveque03_initialDataSolution eigenbasis speeds initialState XL TL =
      (leveque03_characteristicVariables eigenbasis right p -
        leveque03_characteristicVariables eigenbasis left p) • eigenbasis p := by
  let fL : Fin m → (Fin m → ℝ) := fun j =>
    if 0 < XL - speeds j * TL then
      (leveque03_characteristicVariables eigenbasis right j) • eigenbasis j
    else (leveque03_characteristicVariables eigenbasis left j) • eigenbasis j
  let fR : Fin m → (Fin m → ℝ) := fun j =>
    if 0 < XR - speeds j * TR then
      (leveque03_characteristicVariables eigenbasis right j) • eigenbasis j
    else (leveque03_characteristicVariables eigenbasis left j) • eigenbasis j
  have hsum : (∑ j, fR j) - (∑ j, fL j) = fR p - fL p := by
    rw [← Finset.sum_sub_distrib]
    apply Finset.sum_eq_single p
    · intro j _ hj
      have hdiff : fR j = fL j := by
        simp only [fR, fL]
        by_cases hjL : 0 < XL - speeds j * TL
        · have hjR := (hsame j hj).mp hjL
          simp [hjL, hjR]
        · have hjR : ¬ 0 < XR - speeds j * TR :=
            fun h => hjL ((hsame j hj).mpr h)
          simp [hjL, hjR]
      exact sub_eq_zero.mpr hdiff
    · simp
  rw [leveque03_riemannSolution_offRays eigenbasis speeds initialState left right
    hdata XR TR hoffR,
    leveque03_riemannSolution_offRays eigenbasis speeds initialState left right
      hdata XL TL hoffL]
  change (∑ j, fR j) - (∑ j, fL j) = _
  rw [hsum]
  simp only [fR, fL, if_pos hright,
    if_neg (not_lt.mpr hleft.le), sub_smul]

end NumStability
