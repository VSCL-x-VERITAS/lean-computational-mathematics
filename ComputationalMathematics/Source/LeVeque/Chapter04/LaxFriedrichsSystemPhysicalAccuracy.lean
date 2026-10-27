/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsSystemStability

/-!
# Physical-component accuracy for linear-system Lax–Friedrichs

The established first-order bound on each characteristic coordinate
also gives a first-order bound on each physical state component. The
constant depends only on the fixed eigenbasis.
-/

namespace NumStability

/-- At a fixed physical horizon, every component of a constant-system
Lax–Friedrichs state has first-order error. The basis factor is
independent of the mesh width and step count. -/
theorem leveque04_linearLaxFriedrichs_smoothPhysicalComponent_globalError
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
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
    let exactState := fun j (l : ℤ) =>
      eigenbasis.equivFun.symm (fun p =>
        oneDimensionalCellAverage (profile p j)
          ((l : ℝ) * width - width / 2)
          ((l : ℝ) * width + width / 2))
    |(((leveque04_linearLaxFriedrichsStep coefficient ratio)^[n]
        (exactState 0)) i - exactState n i) k| ≤
      (∑ p : Fin m, |eigenbasis p k|) *
        ((2 * K * horizon / ratio) * width) := by
  dsimp only
  let exactState := fun j (l : ℤ) =>
    eigenbasis.equivFun.symm (fun p =>
      oneDimensionalCellAverage (profile p j)
        ((l : ℝ) * width - width / 2)
        ((l : ℝ) * width + width / 2))
  let evolved := ((leveque04_linearLaxFriedrichsStep coefficient ratio)^[n]
    (exactState 0)) i
  let v := evolved - exactState n i
  have hcoordinate (p : Fin m) :
      |eigenbasis.equivFun v p| ≤
        (2 * K * horizon / ratio) * width := by
    simpa only [v, evolved, map_sub, Pi.sub_apply] using
      leveque04_linearLaxFriedrichs_smoothCharacteristic_globalError
        coefficient eigenbasis waveSpeed heigen profile profile'
        ratio width K horizon n i p hratio hwidth hK hcfl
        hprofile hLip hevolution hhorizon
  have hrepr : v k = ∑ p : Fin m,
      eigenbasis.equivFun v p * eigenbasis p k := by
    conv_lhs => rw [← eigenbasis.sum_equivFun v]
    simp only [Finset.sum_apply, Pi.smul_apply, smul_eq_mul]
  change |v k| ≤ _
  rw [hrepr]
  calc
    |∑ p : Fin m, eigenbasis.equivFun v p * eigenbasis p k| ≤
        ∑ p : Fin m, |eigenbasis.equivFun v p * eigenbasis p k| :=
          Finset.abs_sum_le_sum_abs _ _
    _ = ∑ p : Fin m, |eigenbasis.equivFun v p| *
          |eigenbasis p k| := by simp only [abs_mul]
    _ ≤ ∑ p : Fin m, ((2 * K * horizon / ratio) * width) *
          |eigenbasis p k| := by
            apply Finset.sum_le_sum
            intro p _
            exact mul_le_mul_of_nonneg_right (hcoordinate p) (abs_nonneg _)
    _ = (∑ p : Fin m, |eigenbasis p k|) *
          ((2 * K * horizon / ratio) * width) := by
            rw [Finset.sum_mul]
            apply Finset.sum_congr rfl
            intro p _
            ring

end NumStability
