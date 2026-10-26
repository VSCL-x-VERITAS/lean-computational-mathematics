/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.GodunovStability
import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsBasisMeanTransfer

/-!
# Physical-component accuracy of the selected linear Godunov update

The certified selected Riemann-flux method's characteristic error
bound transfers to physical state components through the same finite
basis reconstruction used for Lax–Friedrichs.
-/

namespace NumStability

/-- Each physical component of the certified selected linear-system
Godunov update has a fixed-horizon first-order error on smooth exact
cell averages. The basis factor is independent of the mesh. -/
theorem leveque04_selectedLinearGodunov_smoothPhysicalComponent_globalError
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (hcoefficient : IsRealHyperbolicMatrix coefficient)
    (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (eigenbasis p) =
      waveSpeed p • eigenbasis p)
    (profile profile' : Fin m → ℕ → ℝ → ℝ)
    (ratio width K horizon : ℝ) (n : ℕ) (i : ℤ) (k : Fin m)
    (hratio : 0 < ratio) (hwidth : 0 < width) (hK : 0 ≤ K)
    (hcfl : ∀ p, |waveSpeed p * ratio| ≤ 1)
    (hprofile : ∀ p j x,
      HasDerivAt (profile p j) (profile' p j x) x)
    (hLip : ∀ p j x y,
      |profile' p j x - profile' p j y| ≤ K * |x - y|)
    (hevolution : ∀ p j x,
      profile p (j + 1) x =
        profile p j (x - waveSpeed p * ratio * width))
    (hhorizon : (n : ℝ) * ratio * width ≤ horizon) :
    let method := linearRectangleRiemannInterfaceFluxMethod coefficient
      hcoefficient eigenbasis waveSpeed heigen
    let selected := fun old (j : ℤ) =>
      conservativeFluxDifferenceUpdateInt ratio old
        (rectangleRiemannInterfaceFlux method old (fun _ => True.intro)) j
    let exactState := fun j (l : ℤ) =>
      eigenbasis.equivFun.symm (fun p =>
        oneDimensionalCellAverage (profile p j)
          ((l : ℝ) * width - width / 2)
          ((l : ℝ) * width + width / 2))
    |(selected^[n] (exactState 0)) i k - exactState n i k| ≤
      (∑ p : Fin m, |eigenbasis p k|) *
        ((2 * K * horizon / ratio) * width) := by
  dsimp only
  let method := linearRectangleRiemannInterfaceFluxMethod coefficient
    hcoefficient eigenbasis waveSpeed heigen
  let selected := fun old (j : ℤ) =>
    conservativeFluxDifferenceUpdateInt ratio old
      (rectangleRiemannInterfaceFlux method old (fun _ => True.intro)) j
  let exactState := fun j (l : ℤ) =>
    eigenbasis.equivFun.symm (fun p =>
      oneDimensionalCellAverage (profile p j)
        ((l : ℝ) * width - width / 2)
        ((l : ℝ) * width + width / 2))
  let evolved := (selected^[n] (exactState 0)) i
  have hcoord (p : Fin m) :
      |eigenbasis.equivFun evolved p -
        eigenbasis.equivFun (exactState n i) p| ≤
        (2 * K * horizon / ratio) * width := by
    exact leveque04_selectedLinearGodunov_smoothCharacteristic_globalError
      coefficient hcoefficient eigenbasis waveSpeed heigen
      profile profile' ratio width K horizon n i p
      hratio hwidth hK hcfl hprofile hLip hevolution hhorizon
  calc
    |evolved k - exactState n i k| ≤
      ∑ p : Fin m, |eigenbasis p k| *
        |eigenbasis.equivFun evolved p -
          eigenbasis.equivFun (exactState n i) p| :=
        leveque04_basis_physicalComponent_abs_le
          eigenbasis evolved (exactState n i) k
    _ ≤ ∑ p : Fin m, |eigenbasis p k| *
        ((2 * K * horizon / ratio) * width) := by
      apply Finset.sum_le_sum
      intro p _
      exact mul_le_mul_of_nonneg_left (hcoord p) (abs_nonneg _)
    _ = (∑ p : Fin m, |eigenbasis p k|) *
        ((2 * K * horizon / ratio) * width) := by
      rw [Finset.sum_mul]

end NumStability
