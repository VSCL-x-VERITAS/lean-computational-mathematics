/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter03.CharacteristicCoordinates

/-!
# Straight characteristics for constant-coefficient systems

The pth family on printed page 48/raw PDF page 70 has speed `λᵖ` and
characteristic curve `X(t) = x₀ + λᵖ t`.
-/

namespace NumStability

/-- The pth straight characteristic through its initial point `origin`. -/
def leveque03_characteristicCurve
    {m : ℕ} (eigenvalues : Fin m → ℝ) (p : Fin m)
    (origin time : ℝ) : ℝ :=
  origin + eigenvalues p * time

/-- Distinct eigenvalue speeds give distinct characteristic-family curves
through each point of the space-time plane. -/
theorem leveque03_strictCharacteristicFamilies
    {m : ℕ} (eigenvalues : Fin m → ℝ)
    (hdistinct : Function.Injective eigenvalues) (x t : ℝ) :
    (∀ p, leveque03_characteristicCurve eigenvalues p
      (x - eigenvalues p * t) t = x) ∧
      Function.Injective
        (fun p => leveque03_characteristicCurve eigenvalues p
          (x - eigenvalues p * t)) := by
  constructor
  · intro p
    simp [leveque03_characteristicCurve]
  · intro p q hcurve
    have hzero := congrFun hcurve 0
    have hone := congrFun hcurve 1
    simp only [leveque03_characteristicCurve, mul_zero, add_zero] at hzero
    simp only [leveque03_characteristicCurve, mul_one] at hone
    apply hdistinct
    linarith

end NumStability
