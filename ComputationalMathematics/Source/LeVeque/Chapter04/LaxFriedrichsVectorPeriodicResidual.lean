/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsVectorPeriodicAverages
import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsVectorSmoothExactAccuracy
import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsConjugateNonlinear

/-!
# Smooth exact residual of the periodic coupled-vector stencil

The exact vector cell averages at a wrapped periodic cell supply the three
neighbor values of the actual equation-(4.20) update. This transfers the
smooth real-line local estimate to every periodic cell, including seams.
-/

namespace NumStability

open MeasureTheory

theorem leveque04_periodicVectorLaxFriedrichs_smoothExactResidual
    {m : ℕ} (n : ℕ) [NeZero n] (hn : 2 ≤ n)
    (q qX : ℝ → ℝ → Fin m → ℝ)
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
    (i : ZMod n) :
    let exactState := leveque04_periodicVectorExactCellAverage n q width time
    let exactNext := leveque04_periodicVectorExactCellAverage
      n q width (time + ratio * width)
    ‖(ratio * width)⁻¹ •
        (leveque04_periodicVectorLaxFriedrichsStep n flux ratio
          exactState i - exactNext i)‖ ≤
      ((Kspace + ratio * Kflux + Ktime * ratio ^ 2 +
          ratio * (2 * (Kjac * S ^ 2))) / ratio) * width := by
  dsimp only
  let c : ℝ := (i.val : ℝ) * width
  let avg : ℝ → Fin m → ℝ := fun d =>
    oneDimensionalCellAverage (fun x => q x time)
      (d - width / 2) (d + width / 2)
  let fluxSlope : ℝ → Fin m → ℝ := fun d =>
    jacobian (avg d)
      (width⁻¹ •
        (q (d + width / 2) time - q (d - width / 2) time))
  let exactState := leveque04_periodicVectorExactCellAverage n q width time
  let old : ℤ → Fin m → ℝ := fun j =>
    if j = -1 then exactState (i - 1)
    else if j = 0 then exactState i else exactState (i + 1)
  have hleft : old (0 - 1) = avg (c - width) := by
    simp only [old, zero_sub, ite_true]
    simpa only [avg, c] using
      leveque04_periodicVectorExactCellAverage_left
        n hn q width time hperiod i
  have hcenter : old 0 = avg c := by
    simp [old, exactState, avg, c,
      leveque04_periodicVectorExactCellAverage, periodicGridSample]
  have hright : old (0 + 1) = avg (c + width) := by
    have h := leveque04_periodicVectorExactCellAverage_right
      n hn q width time hperiod i
    have hc : (((i.val + 1 : ℕ) : ℝ) * width) = c + width := by
      dsimp [c]
      push_cast
      ring
    simp only [old, zero_add]
    have hne : (1 : ℤ) ≠ -1 := by norm_num
    have hne0 : (1 : ℤ) ≠ 0 := by norm_num
    simp only [hne, hne0, ↓reduceIte]
    simpa only [exactState, avg, hc] using h
  have hlocal := leveque04_laxFriedrichs_vectorSmoothExactSolution_localAccuracy
    q qX flux jacobian avg fluxSlope old 0 c time ratio width
    Kspace Kflux Ktime Kjac S
    hratio hwidth hKspace hKflux hKtime hKjac hS
    hq (fun _ => rfl) (fun _ => rfl)
    hleft hcenter hright hprofile hprofileLip hflux hjacobianLip
    (by simpa only [fluxSlope, avg] using hfluxSlopeLip)
    (by simpa only [c, avg] using hfaceLeftClose i)
    (by simpa only [c, avg] using hfaceRightClose i)
    (by simpa only [c] using hfluxTimeCont i)
    (by simpa only [c] using haverageRateLip i)
  have hbridge :
      leveque04_periodicVectorLaxFriedrichsStep n flux ratio exactState i =
      leveque04_finiteVolumeUpdate (ratio * width) width old
        (leveque04_localInterfaceFlux
          (leveque04_laxFriedrichsFlux
            (ratio * width) width flux) old) 0 := by
    funext p
    exact leveque04_periodicVectorLaxFriedrichs_eq_equation20
      n flux ratio width hratio hwidth exactState i p
  simpa only [hbridge, exactState, c,
    leveque04_periodicVectorExactCellAverage, periodicGridSample,
    old, avg] using hlocal

end NumStability
