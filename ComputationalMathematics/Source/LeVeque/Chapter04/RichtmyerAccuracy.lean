/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerLinearFlux
import ComputationalMathematics.Source.LeVeque.Chapter04.GodunovOrderWitness
import ComputationalMathematics.Analysis.Calculus.SecondOrderTaylor

import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

/-!
# LeVeque Chapter 4: scalar Richtmyer accuracy foundations

For a scalar linear flux, the actual two-step Richtmyer update is the
standard Lax–Wendroff stencil. Its quadratic Taylor polynomial is
reproduced exactly; cubic remainders give a second-order normalized
local residual under a fixed time-to-width ratio.
-/

namespace NumStability

/-- The scalar linear-flux Richtmyer method is the standard
Lax–Wendroff stencil with Courant number `speed*dt/width`. -/
theorem leveque04_richtmyerScalarStep
    (speed timeStep width : ℝ) (old : ℤ → ℝ) (i : ℤ)
    (hwidth : 0 < width) :
    leveque04_finiteVolumeUpdate timeStep width
        (fun (j : ℤ) (_ : Fin 1) => old j)
        (leveque04_localInterfaceFlux
          (leveque04_richtmyerFlux timeStep width
            (fun (state : Fin 1 → ℝ) (_ : Fin 1) => speed * state 0))
          (fun (j : ℤ) (_ : Fin 1) => old j)) i 0 =
      old i - (speed * timeStep / (2 * width)) *
          (old (i + 1) - old (i - 1)) +
        (speed * timeStep / width) ^ 2 / 2 *
          (old (i + 1) - 2 * old i + old (i - 1)) := by
  have hne : width ≠ 0 := ne_of_gt hwidth
  simp only [leveque04_finiteVolumeUpdate,
    conservativeFluxDifferenceUpdateInt, leveque04_localInterfaceFlux,
    leveque04_richtmyerFlux, leveque04_richtmyerPredictor,
    Pi.sub_apply, Pi.add_apply, Pi.smul_apply, smul_eq_mul]
  field_simp
  simp
  ring

/-- The Lax–Wendroff stencil reproduces the second-order Taylor
polynomial of a translated smooth cell average exactly. -/
theorem leveque04_laxWendroff_quadraticTaylor
    (courant width base slope curvature : ℝ) :
    let left := base - width * slope + width ^ 2 * curvature / 2
    let current := base
    let right := base + width * slope + width ^ 2 * curvature / 2
    current - courant / 2 * (right - left) +
      courant ^ 2 / 2 * (right - 2 * current + left) =
        base - courant * width * slope +
          (courant * width) ^ 2 * curvature / 2 := by
  dsimp only
  ring

/-- Exact cell average of a cubic profile. The correction term is
linear in the cell center. -/
theorem leveque04_cubicAverageAtCenter
    (center width : ℝ) (hwidth : 0 < width) :
    oneDimensionalCellAverage (fun x : ℝ => x ^ 3)
        (center - width / 2) (center + width / 2) =
      center ^ 3 + center * width ^ 2 / 4 := by
  have hne : width ≠ 0 := ne_of_gt hwidth
  simp only [oneDimensionalCellAverage, smul_eq_mul, integral_pow]
  have hspan : center + width / 2 - (center - width / 2) = width := by ring
  rw [hspan]
  field_simp [hne]
  ring

/-- A translated cubic solution has this exact finite-volume cell
average at the new time. -/
theorem leveque04_translatedCubicAverage
    (center width offset : ℝ) (hwidth : 0 < width) :
    oneDimensionalCellAverage (fun x : ℝ => (x - offset) ^ 3)
        (center - width / 2) (center + width / 2) =
      (center - offset) ^ 3 + (center - offset) * width ^ 2 / 4 := by
  simp only [oneDimensionalCellAverage, smul_eq_mul]
  rw [intervalIntegral.integral_comp_sub_right
    (a := center - width / 2) (b := center + width / 2)
    (f := fun x : ℝ => x ^ 3) offset]
  have hleft : center - width / 2 - offset =
      center - offset - width / 2 := by ring
  have hright : center + width / 2 - offset =
      center - offset + width / 2 := by ring
  rw [hleft, hright]
  have hspan : center + width / 2 - (center - width / 2) = width := by ring
  have hspan' : center - offset + width / 2 -
      (center - offset - width / 2) = width := by ring
  simpa only [oneDimensionalCellAverage, smul_eq_mul, hspan, hspan'] using
    leveque04_cubicAverageAtCenter (center - offset) width hwidth

/-- The scalar Richtmyer/Lax–Wendroff method has an exact cubic local
defect `((speed*ratio)^3 - speed*ratio) h³` on genuine cell averages. -/
theorem leveque04_richtmyer_cubicDefect
    (speed ratio width : ℝ) (i : ℤ) (hwidth : 0 < width) :
    let old : ℤ → ℝ :=
      fun j => ((j : ℝ) * width) ^ 3 + (j : ℝ) * width ^ 3 / 4
    leveque04_finiteVolumeUpdate (ratio * width) width
        (fun (j : ℤ) (_ : Fin 1) => old j)
        (leveque04_localInterfaceFlux
          (leveque04_richtmyerFlux (ratio * width) width
            (fun (state : Fin 1 → ℝ) (_ : Fin 1) => speed * state 0))
          (fun (j : ℤ) (_ : Fin 1) => old j)) i 0 -
      (((i : ℝ) * width - speed * (ratio * width)) ^ 3 +
        ((i : ℝ) * width - speed * (ratio * width)) * width ^ 2 / 4) =
      ((speed * ratio) ^ 3 - speed * ratio) * width ^ 3 := by
  dsimp only
  rw [leveque04_richtmyerScalarStep speed (ratio * width) width _ i hwidth]
  have hne : width ≠ 0 := ne_of_gt hwidth
  push_cast
  field_simp
  ring

/-- At fixed positive `dt/width`, the cubic local residual is exactly
quadratic in width. -/
theorem leveque04_richtmyer_cubicResidual
    (speed ratio width : ℝ) (i : ℤ)
    (hratio : 0 < ratio) (hwidth : 0 < width) :
    let old : ℤ → ℝ :=
      fun j => ((j : ℝ) * width) ^ 3 + (j : ℝ) * width ^ 3 / 4
    (leveque04_finiteVolumeUpdate (ratio * width) width
        (fun (j : ℤ) (_ : Fin 1) => old j)
        (leveque04_localInterfaceFlux
          (leveque04_richtmyerFlux (ratio * width) width
            (fun (state : Fin 1 → ℝ) (_ : Fin 1) => speed * state 0))
          (fun (j : ℤ) (_ : Fin 1) => old j)) i 0 -
      (((i : ℝ) * width - speed * (ratio * width)) ^ 3 +
        ((i : ℝ) * width - speed * (ratio * width)) * width ^ 2 / 4)) /
      (ratio * width) =
        (((speed * ratio) ^ 3 - speed * ratio) / ratio) * width ^ 2 := by
  dsimp only
  rw [leveque04_richtmyer_cubicDefect speed ratio width i hwidth]
  have hrne : ratio ≠ 0 := ne_of_gt hratio
  have hwne : width ≠ 0 := ne_of_gt hwidth
  field_simp

/-- Second-order Taylor data with cubic remainder give a cubic one-step
error for the Lax–Wendroff stencil under the unit Courant bound. -/
theorem leveque04_laxWendroff_taylorError
    (courant width base slope curvature left current right shifted bound : ℝ)
    (hwidth : 0 ≤ width) (hbound : 0 ≤ bound)
    (hcfl : |courant| ≤ 1)
    (hleft : |left - (base - width * slope + width ^ 2 * curvature / 2)| ≤
      bound * width ^ 3)
    (hcurrent : |current - base| ≤ bound * width ^ 3)
    (hright : |right - (base + width * slope + width ^ 2 * curvature / 2)| ≤
      bound * width ^ 3)
    (hshift : |shifted -
        (base - courant * width * slope +
          (courant * width) ^ 2 * curvature / 2)| ≤
      bound * width ^ 3) :
    |current - courant / 2 * (right - left) +
        courant ^ 2 / 2 * (right - 2 * current + left) - shifted| ≤
      4 * bound * width ^ 3 := by
  let radius := bound * width ^ 3
  let leftError := left - (base - width * slope + width ^ 2 * curvature / 2)
  let centerError := current - base
  let rightError := right - (base + width * slope + width ^ 2 * curvature / 2)
  let shiftError := shifted -
    (base - courant * width * slope + (courant * width) ^ 2 * curvature / 2)
  let leftWeight := (courant + courant ^ 2) / 2
  let centerWeight := 1 - courant ^ 2
  let rightWeight := (courant ^ 2 - courant) / 2
  have hradius : 0 ≤ radius := mul_nonneg hbound (pow_nonneg hwidth _)
  have hc := abs_le.mp hcfl
  have hsq : courant ^ 2 ≤ 1 := by
    have hprod := mul_nonneg (by linarith : 0 ≤ 1 - courant)
      (by linarith : 0 ≤ 1 + courant)
    nlinarith
  have hwleft : |leftWeight| ≤ 1 := by
    apply abs_le.mpr
    dsimp [leftWeight]
    constructor <;> nlinarith [sq_nonneg courant]
  have hwcenter : |centerWeight| ≤ 1 := by
    apply abs_le.mpr
    dsimp [centerWeight]
    constructor <;> nlinarith [sq_nonneg courant]
  have hwright : |rightWeight| ≤ 1 := by
    apply abs_le.mpr
    dsimp [rightWeight]
    constructor <;> nlinarith [sq_nonneg courant]
  have hleftBound : |leftWeight * leftError| ≤ radius := by
    calc
      _ = |leftWeight| * |leftError| := abs_mul _ _
      _ ≤ 1 * |leftError| :=
        mul_le_mul_of_nonneg_right hwleft (abs_nonneg _)
      _ ≤ radius := by simpa [leftError, radius] using hleft
  have hcenterBound : |centerWeight * centerError| ≤ radius := by
    calc
      _ = |centerWeight| * |centerError| := abs_mul _ _
      _ ≤ 1 * |centerError| :=
        mul_le_mul_of_nonneg_right hwcenter (abs_nonneg _)
      _ ≤ radius := by simpa [centerError, radius] using hcurrent
  have hrightBound : |rightWeight * rightError| ≤ radius := by
    calc
      _ = |rightWeight| * |rightError| := abs_mul _ _
      _ ≤ 1 * |rightError| :=
        mul_le_mul_of_nonneg_right hwright (abs_nonneg _)
      _ ≤ radius := by simpa [rightError, radius] using hright
  have hshiftBound : |shiftError| ≤ radius := by
    simpa [shiftError, radius] using hshift
  have hidentity :
      current - courant / 2 * (right - left) +
          courant ^ 2 / 2 * (right - 2 * current + left) - shifted =
        leftWeight * leftError + centerWeight * centerError +
          rightWeight * rightError - shiftError := by
    dsimp [leftWeight, centerWeight, rightWeight, leftError,
      centerError, rightError, shiftError]
    ring
  rw [hidentity]
  have htri1 := abs_add_le
    (leftWeight * leftError + centerWeight * centerError +
      rightWeight * rightError) (-shiftError)
  have htri2 := abs_add_le
    (leftWeight * leftError + centerWeight * centerError)
    (rightWeight * rightError)
  have htri3 := abs_add_le
    (leftWeight * leftError) (centerWeight * centerError)
  have htri :
      |leftWeight * leftError + centerWeight * centerError +
          rightWeight * rightError - shiftError| ≤
        |leftWeight * leftError| + |centerWeight * centerError| +
          |rightWeight * rightError| + |shiftError| := by
    have htri1' :
        |leftWeight * leftError + centerWeight * centerError +
            rightWeight * rightError - shiftError| ≤
          |leftWeight * leftError + centerWeight * centerError +
            rightWeight * rightError| + |shiftError| := by
      simpa only [sub_eq_add_neg, abs_neg] using htri1
    linarith
  dsimp [radius] at *
  linarith

/-- The actual scalar linear-flux Richtmyer update has cubic one-step
error when its old exact cell averages and new exact cell average have
uniform third-order Taylor remainders. -/
theorem leveque04_richtmyer_linearTaylorError
    (speed ratio width base slope curvature shifted bound : ℝ)
    (old : ℤ → ℝ) (i : ℤ)
    (hwidth : 0 < width) (hbound : 0 ≤ bound)
    (hcfl : |speed * ratio| ≤ 1)
    (hleft : |old (i - 1) -
        (base - width * slope + width ^ 2 * curvature / 2)| ≤
      bound * width ^ 3)
    (hcurrent : |old i - base| ≤ bound * width ^ 3)
    (hright : |old (i + 1) -
        (base + width * slope + width ^ 2 * curvature / 2)| ≤
      bound * width ^ 3)
    (hshift : |shifted -
        (base - (speed * ratio) * width * slope +
          ((speed * ratio) * width) ^ 2 * curvature / 2)| ≤
      bound * width ^ 3) :
    |leveque04_finiteVolumeUpdate (ratio * width) width
        (fun (j : ℤ) (_ : Fin 1) => old j)
        (leveque04_localInterfaceFlux
          (leveque04_richtmyerFlux (ratio * width) width
            (fun (state : Fin 1 → ℝ) (_ : Fin 1) => speed * state 0))
          (fun (j : ℤ) (_ : Fin 1) => old j)) i 0 - shifted| ≤
      4 * bound * width ^ 3 := by
  rw [leveque04_richtmyerScalarStep speed (ratio * width) width old i hwidth]
  have hne : width ≠ 0 := ne_of_gt hwidth
  have hcoef : speed * (ratio * width) / (2 * width) =
      (speed * ratio) / 2 := by field_simp
  have hcourant : speed * (ratio * width) / width = speed * ratio := by
    field_simp
  rw [hcoef, hcourant]
  exact leveque04_laxWendroff_taylorError
    (speed * ratio) width base slope curvature
    (old (i - 1)) (old i) (old (i + 1)) shifted bound
    hwidth.le hbound hcfl hleft hcurrent hright hshift

/-- At fixed positive `dt/width=ratio`, the scalar Richtmyer local
residual is at most quadratic in width under the Taylor hypotheses. -/
theorem leveque04_richtmyer_linearTaylorResidual
    (speed ratio width base slope curvature shifted bound : ℝ)
    (old : ℤ → ℝ) (i : ℤ)
    (hratio : 0 < ratio) (hwidth : 0 < width) (hbound : 0 ≤ bound)
    (hcfl : |speed * ratio| ≤ 1)
    (hleft : |old (i - 1) -
        (base - width * slope + width ^ 2 * curvature / 2)| ≤
      bound * width ^ 3)
    (hcurrent : |old i - base| ≤ bound * width ^ 3)
    (hright : |old (i + 1) -
        (base + width * slope + width ^ 2 * curvature / 2)| ≤
      bound * width ^ 3)
    (hshift : |shifted -
        (base - (speed * ratio) * width * slope +
          ((speed * ratio) * width) ^ 2 * curvature / 2)| ≤
      bound * width ^ 3) :
    |(leveque04_finiteVolumeUpdate (ratio * width) width
        (fun (j : ℤ) (_ : Fin 1) => old j)
        (leveque04_localInterfaceFlux
          (leveque04_richtmyerFlux (ratio * width) width
            (fun (state : Fin 1 → ℝ) (_ : Fin 1) => speed * state 0))
          (fun (j : ℤ) (_ : Fin 1) => old j)) i 0 - shifted) /
        (ratio * width)| ≤ (4 * bound / ratio) * width ^ 2 := by
  have htime : 0 < ratio * width := mul_pos hratio hwidth
  have hrne : ratio ≠ 0 := ne_of_gt hratio
  have hwne : width ≠ 0 := ne_of_gt hwidth
  have h := leveque04_richtmyer_linearTaylorError
    speed ratio width base slope curvature shifted bound old i
    hwidth hbound hcfl hleft hcurrent hright hshift
  rw [abs_div, abs_of_pos htime]
  apply (div_le_iff₀ htime).mpr
  convert h using 1; field_simp

/-- A Lipschitz second derivative of the sampled center function
gives a second-order normalized residual for the actual scalar
linear-flux Richtmyer update. -/
theorem leveque04_richtmyer_lipschitzCenterResidual
    (g g' g'' : ℝ → ℝ) (speed ratio width K : ℝ) (i : ℤ)
    (hratio : 0 < ratio) (hwidth : 0 < width) (hK : 0 ≤ K)
    (hcfl : |speed * ratio| ≤ 1)
    (hg : ∀ x, HasDerivAt g (g' x) x)
    (hg' : ∀ x, HasDerivAt g' (g'' x) x)
    (hLip : ∀ x y, |g'' x - g'' y| ≤ K * |x - y|) :
    let old : ℤ → ℝ := fun j => g ((j : ℝ) * width)
    |(leveque04_finiteVolumeUpdate (ratio * width) width
        (fun (j : ℤ) (_ : Fin 1) => old j)
        (leveque04_localInterfaceFlux
          (leveque04_richtmyerFlux (ratio * width) width
            (fun (state : Fin 1 → ℝ) (_ : Fin 1) => speed * state 0))
          (fun (j : ℤ) (_ : Fin 1) => old j)) i 0 -
      g ((i : ℝ) * width - speed * ratio * width)) / (ratio * width)| ≤
        (4 * K / ratio) * width ^ 2 := by
  dsimp only
  let center := (i : ℝ) * width
  have hleft := secondOrderTaylorError_le_of_lipschitzSecondDeriv
    g g' g'' K center (center - width) hK hg hg' hLip
  have hright := secondOrderTaylorError_le_of_lipschitzSecondDeriv
    g g' g'' K center (center + width) hK hg hg' hLip
  have hshift := secondOrderTaylorError_le_of_lipschitzSecondDeriv
    g g' g'' K center (center - speed * ratio * width) hK hg hg' hLip
  have hshiftBound :
      |g (center - speed * ratio * width) -
        (g center - (speed * ratio) * width * g' center +
          ((speed * ratio) * width) ^ 2 * g'' center / 2)| ≤ K * width ^ 3 := by
    have hcw : |speed * ratio * width| ≤ width := by
      rw [abs_mul, abs_of_pos hwidth]
      nlinarith [hcfl]
    have hpow : |speed * ratio * width| ^ 3 ≤ width ^ 3 := by
      gcongr
    have hprod := mul_le_mul_of_nonneg_left hpow hK
    have hshift' :
        |g (center - speed * ratio * width) -
          (g center - (speed * ratio) * width * g' center +
            ((speed * ratio) * width) ^ 2 * g'' center / 2)| ≤
          K * |speed * ratio * width| ^ 3 := by
      have hdelta : center - speed * ratio * width - center =
          -(speed * ratio * width) := by ring
      rw [hdelta, abs_neg] at hshift
      convert hshift using 1 <;> ring
    exact le_trans hshift' hprod
  have hstep := leveque04_richtmyer_linearTaylorResidual
    speed ratio width (g center) (g' center) (g'' center)
    (g (center - speed * ratio * width)) K
    (fun j : ℤ => g ((j : ℝ) * width)) i
    hratio hwidth hK hcfl ?_ ?_ ?_ hshiftBound
  · simpa [center] using hstep
  · convert hleft using 1 <;> simp [center, abs_of_pos hwidth] <;> ring
  · simp [center]
    positivity
  · convert hright using 1 <;> simp [center, abs_of_pos hwidth] <;> ring

/-- For exact translated cell averages, the actual scalar Richtmyer
update has a second-order normalized residual when the average's
second derivative has a mesh-independent Lipschitz bound. -/
theorem leveque04_richtmyer_lipschitzCellAverageResidual
    (profile averageDeriv averageSecondDeriv : ℝ → ℝ)
    (speed ratio width K : ℝ) (i : ℤ)
    (hratio : 0 < ratio) (hwidth : 0 < width) (hK : 0 ≤ K)
    (hcfl : |speed * ratio| ≤ 1)
    (hg : ∀ c, HasDerivAt
      (fun center => oneDimensionalCellAverage profile
        (center - width / 2) (center + width / 2))
      (averageDeriv c) c)
    (hg' : ∀ c, HasDerivAt averageDeriv (averageSecondDeriv c) c)
    (hLip : ∀ x y, |averageSecondDeriv x - averageSecondDeriv y| ≤
      K * |x - y|) :
    let old : ℤ → ℝ := fun j => oneDimensionalCellAverage profile
      ((j : ℝ) * width - width / 2)
      ((j : ℝ) * width + width / 2)
    |(leveque04_finiteVolumeUpdate (ratio * width) width
        (fun (j : ℤ) (_ : Fin 1) => old j)
        (leveque04_localInterfaceFlux
          (leveque04_richtmyerFlux (ratio * width) width
            (fun (state : Fin 1 → ℝ) (_ : Fin 1) => speed * state 0))
          (fun (j : ℤ) (_ : Fin 1) => old j)) i 0 -
      oneDimensionalCellAverage
        (fun x => profile (x - speed * ratio * width))
        ((i : ℝ) * width - width / 2)
        ((i : ℝ) * width + width / 2)) / (ratio * width)| ≤
        (4 * K / ratio) * width ^ 2 := by
  dsimp only
  have hnext : oneDimensionalCellAverage
        (fun x => profile (x - speed * ratio * width))
        ((i : ℝ) * width - width / 2)
        ((i : ℝ) * width + width / 2) =
      oneDimensionalCellAverage profile
        (((i : ℝ) * width - speed * ratio * width) - width / 2)
        (((i : ℝ) * width - speed * ratio * width) + width / 2) := by
    rw [oneDimensionalCellAverage_comp_sub_right]
    congr 1 <;> ring
  rw [hnext]
  exact leveque04_richtmyer_lipschitzCenterResidual
    (fun c => oneDimensionalCellAverage profile (c - width / 2) (c + width / 2))
    averageDeriv averageSecondDeriv speed ratio width K i
    hratio hwidth hK hcfl hg hg' hLip

/-- A profile with a globally Lipschitz second derivative gives a
second-order Richtmyer residual on its exact translated cell averages,
with a bound independent of cell width. -/
theorem leveque04_richtmyer_smoothProfileResidual
    (profile profile' profile'' : ℝ → ℝ)
    (speed ratio width K : ℝ) (i : ℤ)
    (hratio : 0 < ratio) (hwidth : 0 < width) (hK : 0 ≤ K)
    (hcfl : |speed * ratio| ≤ 1)
    (hprofile : ∀ x, HasDerivAt profile (profile' x) x)
    (hprofile' : ∀ x, HasDerivAt profile' (profile'' x) x)
    (hLip : ∀ x y, |profile'' x - profile'' y| ≤ K * |x - y|) :
    let old : ℤ → ℝ := fun j => oneDimensionalCellAverage profile
      ((j : ℝ) * width - width / 2)
      ((j : ℝ) * width + width / 2)
    |(leveque04_finiteVolumeUpdate (ratio * width) width
        (fun (j : ℤ) (_ : Fin 1) => old j)
        (leveque04_localInterfaceFlux
          (leveque04_richtmyerFlux (ratio * width) width
            (fun (state : Fin 1 → ℝ) (_ : Fin 1) => speed * state 0))
          (fun (j : ℤ) (_ : Fin 1) => old j)) i 0 -
      oneDimensionalCellAverage
        (fun x => profile (x - speed * ratio * width))
        ((i : ℝ) * width - width / 2)
        ((i : ℝ) * width + width / 2)) / (ratio * width)| ≤
        (4 * K / ratio) * width ^ 2 := by
  have hcont : Continuous profile :=
    continuous_iff_continuousAt.mpr (fun x => (hprofile x).continuousAt)
  exact leveque04_richtmyer_lipschitzCellAverageResidual
    profile
    (fun c => (profile (c + width / 2) - profile (c - width / 2)) / width)
    (fun c => (profile' (c + width / 2) - profile' (c - width / 2)) / width)
    speed ratio width K i hratio hwidth hK hcfl
    (fun c => oneDimensionalCellAverage_hasDerivAt_center
      profile width c hcont hwidth)
    (fun c => oneDimensionalCellAverage_faceSlope_hasDerivAt
      profile profile' width c hprofile)
    (fun x y => oneDimensionalCellAverage_faceSlope_lipschitz
      profile' profile'' K width x y hwidth hprofile' hLip)

/-- The linear-system Richtmyer update has a second-order local residual
    in each characteristic coordinate of a smooth exact solution. -/
theorem leveque04_richtmyer_systemSmoothResidual
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (eigenbasis p) =
      waveSpeed p • eigenbasis p)
    (profile profile' profile'' : Fin m → ℝ → ℝ)
    (ratio width K : ℝ) (i : ℤ) (p : Fin m)
    (hratio : 0 < ratio) (hwidth : 0 < width) (hK : 0 ≤ K)
    (hcfl : ∀ p, |waveSpeed p * ratio| ≤ 1)
    (hprofile : ∀ p x, HasDerivAt (profile p) (profile' p x) x)
    (hprofile' : ∀ p x, HasDerivAt (profile' p) (profile'' p x) x)
    (hLip : ∀ p x y,
      |profile'' p x - profile'' p y| ≤ K * |x - y|) :
    let old : ℤ → (Fin m → ℝ) := fun j =>
      eigenbasis.equivFun.symm (fun p =>
        oneDimensionalCellAverage (profile p)
          ((j : ℝ) * width - width / 2)
          ((j : ℝ) * width + width / 2))
    |(eigenbasis.equivFun
        (leveque04_finiteVolumeUpdate (ratio * width) width old
          (leveque04_localInterfaceFlux
            (leveque04_richtmyerFlux (ratio * width) width coefficient.mulVec)
            old) i) p -
      oneDimensionalCellAverage
        (fun x => profile p (x - waveSpeed p * ratio * width))
        ((i : ℝ) * width - width / 2)
        ((i : ℝ) * width + width / 2)) / (ratio * width)| ≤
      (4 * K / ratio) * width ^ 2 := by
  have hscalar := leveque04_richtmyer_smoothProfileResidual
    (profile p) (profile' p) (profile'' p)
    (waveSpeed p) ratio width K i hratio hwidth hK (hcfl p)
    (hprofile p) (hprofile' p) (hLip p)
  dsimp only at hscalar ⊢
  rw [leveque04_richtmyerScalarStep
    (waveSpeed p) (ratio * width) width _ i hwidth] at hscalar
  rw [leveque04_richtmyerLinearStep_characteristic
    coefficient eigenbasis waveSpeed heigen]
  simp only [LinearEquiv.apply_symm_apply]
  exact hscalar

end NumStability
