/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsVectorPeriodicResidual
import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsVectorCharacteristicTransfer
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearCharacteristicCoordinates

/-!
# Characteristic-coordinate residual of the periodic vector scheme

Any finite basis converts the smooth physical-vector residual bound for
the actual equation-(4.20) update to each basis coordinate. Applied to
an eigenbasis, these are characteristic coordinates. The operator norm
records the basis conditioning explicitly.
-/

namespace NumStability

open MeasureTheory

theorem leveque04_basis_coordinate_abs_le_opNorm
    {m : ℕ} (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (v : Fin m → ℝ) (p : Fin m) :
    |basis.equivFun v p| ≤
      ‖basis.equivFun.toContinuousLinearEquiv.toContinuousLinearMap‖ * ‖v‖ := by
  exact basis_coordinate_abs_le_opNorm basis v p

theorem leveque04_periodicVectorLaxFriedrichs_smoothExactBasisCoordinateResidual
    {m : ℕ} (n : ℕ) [NeZero n] (hn : 2 ≤ n)
    (q qX : ℝ → ℝ → Fin m → ℝ)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (flux : (Fin m → ℝ) → Fin m → ℝ)
    (jacobian : (Fin m → ℝ) →
      (Fin m → ℝ) →L[ℝ] (Fin m → ℝ))
    (width time ratio Kspace Kflux Ktime Kjac S : ℝ)
    (hratio : 0 < ratio) (hwidth : 0 < width)
    (hKspace : 0 ≤ Kspace) (hKflux : 0 ≤ Kflux)
    (hKtime : 0 ≤ Ktime) (hKjac : 0 ≤ Kjac) (hS : 0 ≤ S)
    (hq : IsRectangleConservationLawSolution q flux)
    (hperiod : ∀ x, q (x + (n : ℝ) * width) time = q x time)
    (hprofile : ∀ x, HasDerivAt
      (fun y => q y time) (qX x time) x)
    (hprofileLip : ∀ x y,
      ‖qX x time - qX y time‖ ≤ Kspace * |x - y|)
    (hflux : ∀ u, HasFDerivAt flux (jacobian u) u)
    (hjacobianLip : ∀ u v,
      ‖jacobian u - jacobian v‖ ≤ Kjac * ‖u - v‖)
    (hfluxSlopeLip : ∀ c d,
      ‖jacobian
          (oneDimensionalCellAverage (fun x => q x time)
            (c - width / 2) (c + width / 2))
          (width⁻¹ •
            (q (c + width / 2) time - q (c - width / 2) time)) -
        jacobian
          (oneDimensionalCellAverage (fun x => q x time)
            (d - width / 2) (d + width / 2))
          (width⁻¹ •
            (q (d + width / 2) time - q (d - width / 2) time))‖ ≤
        Kflux * |c - d|)
    (hfaceLeftClose : ∀ i : ZMod n,
      let c := (i.val : ℝ) * width
      ‖q (c - width / 2) time -
        oneDimensionalCellAverage (fun x => q x time)
          (c - width / 2) (c + width / 2)‖ ≤ S * width)
    (hfaceRightClose : ∀ i : ZMod n,
      let c := (i.val : ℝ) * width
      ‖q (c + width / 2) time -
        oneDimensionalCellAverage (fun x => q x time)
          (c - width / 2) (c + width / 2)‖ ≤ S * width)
    (hfluxTimeCont : ∀ i : ZMod n,
      let c := (i.val : ℝ) * width
      Continuous (fun τ =>
        flux (q (c - width / 2) τ) -
          flux (q (c + width / 2) τ)))
    (haverageRateLip : ∀ i : ZMod n,
      let c := (i.val : ℝ) * width
      ∀ s τ,
        ‖width⁻¹ •
            (flux (q (c - width / 2) s) -
              flux (q (c + width / 2) s)) -
          width⁻¹ •
            (flux (q (c - width / 2) τ) -
              flux (q (c + width / 2) τ))‖ ≤
          Ktime * |s - τ|)
    (i : ZMod n) (p : Fin m) :
    let exactState := leveque04_periodicVectorExactCellAverage n q width time
    let exactNext := leveque04_periodicVectorExactCellAverage
      n q width (time + ratio * width)
    |(basis.equivFun
        (leveque04_periodicVectorLaxFriedrichsStep n flux ratio
          exactState i) p -
      basis.equivFun (exactNext i) p) / (ratio * width)| ≤
      ‖basis.equivFun.toContinuousLinearEquiv.toContinuousLinearMap‖ *
        (((Kspace + ratio * Kflux + Ktime * ratio ^ 2 +
          ratio * (2 * (Kjac * S ^ 2))) / ratio) * width) := by
  dsimp only
  let residual : Fin m → ℝ :=
    leveque04_periodicVectorLaxFriedrichsStep n flux ratio
      (leveque04_periodicVectorExactCellAverage n q width time) i -
    leveque04_periodicVectorExactCellAverage n q width
      (time + ratio * width) i
  have h := leveque04_periodicVectorLaxFriedrichs_smoothExactResidual
    n hn q qX flux jacobian width time ratio
    Kspace Kflux Ktime Kjac S
    hratio hwidth hKspace hKflux hKtime hKjac hS
    hq hperiod hprofile hprofileLip hflux hjacobianLip
    hfluxSlopeLip hfaceLeftClose hfaceRightClose
    hfluxTimeCont haverageRateLip i
  dsimp only at h
  have hcoord := leveque04_basis_coordinate_abs_le_opNorm basis
    ((ratio * width)⁻¹ • residual) p
  have hbound := mul_le_mul_of_nonneg_left h
    (norm_nonneg basis.equivFun.toContinuousLinearEquiv.toContinuousLinearMap)
  calc
    |(basis.equivFun
        (leveque04_periodicVectorLaxFriedrichsStep n flux ratio
          (leveque04_periodicVectorExactCellAverage n q width time) i) p -
      basis.equivFun
        (leveque04_periodicVectorExactCellAverage n q width
          (time + ratio * width) i) p) / (ratio * width)| =
      |basis.equivFun ((ratio * width)⁻¹ • residual) p| := by
        simp only [residual, map_smul, map_sub, Pi.sub_apply, Pi.smul_apply,
          smul_eq_mul, div_eq_inv_mul]
    _ ≤ ‖basis.equivFun.toContinuousLinearEquiv.toContinuousLinearMap‖ *
          ‖(ratio * width)⁻¹ • residual‖ := hcoord
    _ ≤ _ := hbound

end NumStability
