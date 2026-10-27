/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsOrderWitness
import ComputationalMathematics.Analysis.Calculus.FirstOrderTaylorDistance

/-!
# Smooth nonlinear flux in the Lax–Friedrichs residual

The source's nonlinear stencil has a first-order normalized local
residual when the cell values and exact next average admit the stated
Taylor bounds. A Lipschitz physical-flux derivative supplies the two
flux-linearization estimates required by that residual theorem.
-/

namespace NumStability

/-- A second-order neighbor expansion and a bounded first-order offset
give a uniform linear distance bound on a bounded mesh range. -/
theorem leveque04_neighborDistanceScale
    (old base offset width valueBound M maxWidth : ℝ)
    (hwidth : 0 ≤ width) (hmax : width ≤ maxWidth)
    (hvalueBound : 0 ≤ valueBound)
    (hlinear : |old - (base + offset)| ≤ valueBound * width ^ 2)
    (hoffset : |offset| ≤ M * width) :
    |old - base| ≤ (M + valueBound * maxWidth) * width := by
  have htri :
      |old - base| ≤ |old - (base + offset)| + |offset| := by
    calc
      _ = |(old - (base + offset)) + offset| := by congr 1; ring
      _ ≤ _ := abs_add_le _ _
  have hsmall : valueBound * width ^ 2 ≤
      valueBound * maxWidth * width := by
    have h := mul_le_mul_of_nonneg_left hmax
      (mul_nonneg hvalueBound hwidth)
    nlinarith
  nlinarith

/-- Smooth physical flux and bounded neighbor distances supply the
nonlinear flux part of the Lax–Friedrichs local residual. -/
theorem leveque04_laxFriedrichs_smoothFluxTaylorResidual
    (flux flux' : ℝ → ℝ) (ratio width base slope shifted
      valueBound K S : ℝ)
    (old : ℤ → ℝ) (i : ℤ)
    (hratio : 0 < ratio) (hwidth : 0 < width)
    (hvalueBound : 0 ≤ valueBound)
    (hK : 0 ≤ K) (hS : 0 ≤ S)
    (hcfl : |flux' base * ratio| ≤ 1)
    (hderiv : ∀ y, HasDerivAt flux (flux' y) y)
    (hLip : ∀ y z, |flux' y - flux' z| ≤ K * |y - z|)
    (hleft : |old (i - 1) - (base - width * slope)| ≤
      valueBound * width ^ 2)
    (hright : |old (i + 1) - (base + width * slope)| ≤
      valueBound * width ^ 2)
    (hshift : |shifted - (base - (flux' base * ratio) * width * slope)| ≤
      valueBound * width ^ 2)
    (hdistLeft : |old (i - 1) - base| ≤ S * width)
    (hdistRight : |old (i + 1) - base| ≤ S * width) :
    |(leveque04_finiteVolumeUpdate (ratio * width) width
        (fun (j : ℤ) (_ : Fin 1) => old j)
        (leveque04_localInterfaceFlux
          (leveque04_laxFriedrichsFlux (ratio * width) width
            (fun (state : Fin 1 → ℝ) (_ : Fin 1) => flux (state 0)))
          (fun (j : ℤ) (_ : Fin 1) => old j)) i 0 - shifted) /
        (ratio * width)| ≤
      ((2 * valueBound + ratio * (K * S ^ 2)) / ratio) * width := by
  apply leveque04_laxFriedrichs_nonlinearTaylorResidual
    flux ratio width (flux' base) base slope shifted
    valueBound (flux base - flux' base * base) (K * S ^ 2)
    old i hratio hwidth hvalueBound hcfl hleft hright hshift
  · have h := firstOrderTaylorError_le_of_distanceScale
      flux flux' K S width base (old (i - 1))
      hK hS hwidth.le hderiv hLip hdistLeft
    convert h using 1 <;> ring
  · have h := firstOrderTaylorError_le_of_distanceScale
      flux flux' K S width base (old (i + 1))
      hK hS hwidth.le hderiv hLip hdistRight
    convert h using 1 <;> ring

/-- A uniform bound on the exact-average slope and an upper mesh width
derive the neighbor-distance premises of the smooth-flux residual. -/
theorem leveque04_laxFriedrichs_smoothFluxTaylorResidual_of_slopeBound
    (flux flux' : ℝ → ℝ) (ratio width base slope shifted
      valueBound K M maxWidth : ℝ)
    (old : ℤ → ℝ) (i : ℤ)
    (hratio : 0 < ratio) (hwidth : 0 < width)
    (hmax : width ≤ maxWidth)
    (hvalueBound : 0 ≤ valueBound)
    (hK : 0 ≤ K) (hM : 0 ≤ M)
    (hslope : |slope| ≤ M)
    (hcfl : |flux' base * ratio| ≤ 1)
    (hderiv : ∀ y, HasDerivAt flux (flux' y) y)
    (hLip : ∀ y z, |flux' y - flux' z| ≤ K * |y - z|)
    (hleft : |old (i - 1) - (base - width * slope)| ≤
      valueBound * width ^ 2)
    (hright : |old (i + 1) - (base + width * slope)| ≤
      valueBound * width ^ 2)
    (hshift : |shifted - (base - (flux' base * ratio) * width * slope)| ≤
      valueBound * width ^ 2) :
    |(leveque04_finiteVolumeUpdate (ratio * width) width
        (fun (j : ℤ) (_ : Fin 1) => old j)
        (leveque04_localInterfaceFlux
          (leveque04_laxFriedrichsFlux (ratio * width) width
            (fun (state : Fin 1 → ℝ) (_ : Fin 1) => flux (state 0)))
          (fun (j : ℤ) (_ : Fin 1) => old j)) i 0 - shifted) /
        (ratio * width)| ≤
      ((2 * valueBound + ratio * (K * (M + valueBound * maxWidth) ^ 2)) /
        ratio) * width := by
  have hS : 0 ≤ M + valueBound * maxWidth := by
    have hmaxnonneg : 0 ≤ maxWidth := le_trans hwidth.le hmax
    positivity
  apply leveque04_laxFriedrichs_smoothFluxTaylorResidual
    flux flux' ratio width base slope shifted valueBound K
    (M + valueBound * maxWidth) old i
    hratio hwidth hvalueBound hK hS hcfl hderiv hLip
    hleft hright hshift
  · apply leveque04_neighborDistanceScale
      (old (i - 1)) base (-width * slope) width valueBound M maxWidth
      hwidth.le hmax hvalueBound
    · convert hleft using 1 <;> ring
    · calc
        |-width * slope| = |slope| * width := by
          rw [abs_mul, abs_neg, abs_of_pos hwidth]; ring
        _ ≤ M * width := mul_le_mul_of_nonneg_right hslope hwidth.le
  · apply leveque04_neighborDistanceScale
      (old (i + 1)) base (width * slope) width valueBound M maxWidth
      hwidth.le hmax hvalueBound hright
    calc
      |width * slope| = |slope| * width := by
        rw [abs_mul, abs_of_pos hwidth]; ring
      _ ≤ M * width := mul_le_mul_of_nonneg_right hslope hwidth.le

end NumStability
