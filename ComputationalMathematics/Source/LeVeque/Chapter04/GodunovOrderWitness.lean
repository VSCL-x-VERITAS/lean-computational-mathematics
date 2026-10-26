/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.Error.Measures.ConvexCombination
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.ScalarStencilTaylor
import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsOrderWitness
import ComputationalMathematics.Source.LeVeque.Chapter04.PositiveSpeedUpwind
import ComputationalMathematics.Source.LeVeque.Chapter04.LinearGodunovCharacteristicStep

import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

/-!
# LeVeque Chapter 4: order of the piecewise-constant Godunov step

For positive constant-speed advection, the selected Godunov interface
flux is the upwind flux. A quadratic initial profile gives an exact
nonzero first-order time-normalized defect at every interior Courant
number. A local Taylor estimate gives the corresponding upper bound.
-/

namespace NumStability

open intervalIntegral

/-- For the exact quadratic cell averages, the positive-speed Godunov
step differs from the translated exact average by `c(1-c)h²`, where
`c=speed*ratio` is the Courant number. -/
theorem leveque04_positiveGodunov_quadraticDefect
    (speed ratio width : ℝ) (i : ℤ)
    (hspeed : 0 < speed) (hwidth : 0 < width) :
    let old : ℤ → ℝ := leveque04_quadraticCellAverage width
    leveque04_positiveUpwindStep (ratio * width) width speed old i -
      (((i : ℝ) * width - speed * (ratio * width)) ^ 2 + width ^ 2 / 12) =
        (speed * ratio) * (1 - speed * ratio) * width ^ 2 := by
  dsimp only
  rw [leveque04_equation26 (ratio * width) width speed
    (leveque04_quadraticCellAverage width) i hspeed]
  have hne : width ≠ 0 := ne_of_gt hwidth
  simp only [leveque04_quadraticCellAverage]
  push_cast
  field_simp
  ring

/-- Under a strict interior CFL number, the exact time-normalized
quadratic defect is a positive constant times the cell width. -/
theorem leveque04_positiveGodunov_quadraticResidual
    (speed ratio width : ℝ) (i : ℤ)
    (hspeed : 0 < speed) (hratio : 0 < ratio) (hwidth : 0 < width)
    (hcfl : speed * ratio < 1) :
    let old : ℤ → ℝ := leveque04_quadraticCellAverage width
    (leveque04_positiveUpwindStep (ratio * width) width speed old i -
      (((i : ℝ) * width - speed * (ratio * width)) ^ 2 + width ^ 2 / 12)) /
        (ratio * width) = speed * (1 - speed * ratio) * width ∧
      0 < speed * (1 - speed * ratio) := by
  dsimp only
  rw [leveque04_positiveGodunov_quadraticDefect
    speed ratio width i hspeed hwidth]
  constructor
  · have hrne : ratio ≠ 0 := ne_of_gt hratio
    have hwne : width ≠ 0 := ne_of_gt hwidth
    field_simp
  · exact mul_pos hspeed (sub_pos.mpr hcfl)

/-- The sharp Godunov defect uses the exact new-time cell average
of the moving quadratic profile, rather than a point sample. -/
theorem leveque04_positiveGodunov_quadraticExactAverageResidual
    (speed ratio width : ℝ) (i : ℤ)
    (hspeed : 0 < speed) (hratio : 0 < ratio) (hwidth : 0 < width)
    (hcfl : speed * ratio < 1) :
    let old : ℤ → ℝ := leveque04_quadraticCellAverage width
    (leveque04_positiveUpwindStep (ratio * width) width speed old i -
      oneDimensionalCellAverage
        (fun x : ℝ => (x - speed * (ratio * width)) ^ 2)
        ((i : ℝ) * width - width / 2)
        ((i : ℝ) * width + width / 2)) / (ratio * width) =
        speed * (1 - speed * ratio) * width ∧
      0 < speed * (1 - speed * ratio) := by
  rw [leveque04_translatedQuadraticAverage
    ((i : ℝ) * width) width (speed * (ratio * width)) hwidth]
  exact leveque04_positiveGodunov_quadraticResidual
    speed ratio width i hspeed hratio hwidth hcfl

/-- The exact quadratic-data truncation residual rules out any uniform
second-order bound for the selected positive-speed Godunov step at an
interior Courant number. -/
theorem leveque04_positiveGodunov_quadraticResidual_not_secondOrder
    (speed ratio : ℝ) (hspeed : 0 < speed) (hratio : 0 < ratio)
    (hcfl : speed * ratio < 1) :
    ∀ C : ℝ, 0 ≤ C →
      ∃ width : ℝ, 0 < width ∧ ∀ i : ℤ,
        C * width ^ 2 <
          (leveque04_positiveUpwindStep (ratio * width) width speed
              (leveque04_quadraticCellAverage width) i -
            oneDimensionalCellAverage
              (fun x : ℝ => (x - speed * (ratio * width)) ^ 2)
              ((i : ℝ) * width - width / 2)
              ((i : ℝ) * width + width / 2)) / (ratio * width) := by
  intro C hC
  let k := speed * (1 - speed * ratio)
  have hk : 0 < k := mul_pos hspeed (sub_pos.mpr hcfl)
  let width := k / (C + 1)
  have hden : 0 < C + 1 := by linarith
  have hwidth : 0 < width := div_pos hk hden
  refine ⟨width, hwidth, ?_⟩
  have hCwidth : C * width < k := by
    have hbalance : width * (C + 1) = k := by
      dsimp [width]
      field_simp [hden.ne']
    nlinarith
  intro i
  have hresidual :=
    (leveque04_positiveGodunov_quadraticExactAverageResidual
      speed ratio width i hspeed hratio hwidth hcfl).1
  rw [hresidual]
  have hpositive := mul_lt_mul_of_pos_right hCwidth hwidth
  nlinarith

/-- The actual positive-speed upwind update, which is the selected
scalar Godunov update for linear advection, inherits the first-order
time-normalized bound at a fixed positive mesh ratio. -/
theorem leveque04_positiveGodunov_taylorResidual
    (speed ratio width base slope shifted bound : ℝ)
    (old : ℤ → ℝ) (i : ℤ)
    (hspeed : 0 < speed) (hratio : 0 < ratio) (hwidth : 0 < width)
    (hcfl : speed * ratio ≤ 1)
    (hcurrent : |old i - base| ≤ bound * width ^ 2)
    (hleft : |old (i - 1) - (base - width * slope)| ≤
      bound * width ^ 2)
    (hshift : |shifted - (base - (speed * ratio) * width * slope)| ≤
      bound * width ^ 2) :
    |(leveque04_positiveUpwindStep (ratio * width) width speed old i -
        shifted) / (ratio * width)| ≤ (2 * bound / ratio) * width := by
  have htime : 0 < ratio * width := mul_pos hratio hwidth
  have hwidthNe : width ≠ 0 := ne_of_gt hwidth
  have hratioNe : ratio ≠ 0 := ne_of_gt hratio
  have hstep := leveque04_positiveGodunov_taylorError
    (speed * ratio) width base slope (old i) (old (i - 1))
    shifted bound ⟨mul_nonneg hspeed.le hratio.le, hcfl⟩
    hcurrent hleft hshift
  rw [leveque04_equation26 (ratio * width) width speed old i hspeed]
  have hcoef : speed * (ratio * width) / width = speed * ratio := by
    field_simp
  rw [hcoef]
  rw [abs_div, abs_of_pos htime]
  apply (div_le_iff₀ htime).mpr
  convert hstep using 1; field_simp

/-- Either signed upwind direction has the same second-order one-step
Taylor error under a unit Courant bound. -/
theorem leveque04_signedGodunov_taylorError
    (speed ratio width base slope current left right shifted bound : ℝ)
    (hratio : 0 ≤ ratio) (hcfl : |speed * ratio| ≤ 1)
    (hcurrent : |current - base| ≤ bound * width ^ 2)
    (hleft : |left - (base - width * slope)| ≤ bound * width ^ 2)
    (hright : |right - (base + width * slope)| ≤ bound * width ^ 2)
    (hshift : |shifted - (base - speed * ratio * width * slope)| ≤
      bound * width ^ 2) :
    |current - ratio *
        (leveque04_positiveVelocity speed * (current - left) +
          leveque04_negativeVelocity speed * (right - current)) - shifted| ≤
      2 * bound * width ^ 2 := by
  rcases le_total 0 speed with hspeed | hspeed
  · have hc : 0 ≤ speed * ratio ∧ speed * ratio ≤ 1 := by
      constructor
      · exact mul_nonneg hspeed hratio
      · exact (abs_le.mp hcfl).2
    have h := leveque04_positiveGodunov_taylorError
      (speed * ratio) width base slope current left shifted bound
      hc hcurrent hleft hshift
    simp only [leveque04_positiveVelocity, leveque04_negativeVelocity,
      max_eq_left hspeed, min_eq_right hspeed, zero_mul, add_zero]
    have hraw : (Nat.rawCast 1 : ℝ) = 1 := by norm_num
    convert h using 1 <;> try simp only [hraw, mul_one]
    congr 1
    ring
  · have hc : 0 ≤ -(speed * ratio) ∧ -(speed * ratio) ≤ 1 := by
      constructor
      · exact neg_nonneg.mpr (mul_nonpos_of_nonpos_of_nonneg hspeed hratio)
      · have := (abs_le.mp hcfl).1
        linarith
    have hright' : |right - (base - width * (-slope))| ≤
        bound * width ^ 2 := by convert hright using 1 <;> ring
    have hshift' :
        |shifted - (base - (-(speed * ratio)) * width * (-slope))| ≤
          bound * width ^ 2 := by convert hshift using 1 <;> ring
    have h := leveque04_positiveGodunov_taylorError
      (-(speed * ratio)) width base (-slope) current right shifted bound
      hc hcurrent hright' hshift'
    simp only [leveque04_positiveVelocity, leveque04_negativeVelocity,
      max_eq_right hspeed, min_eq_left hspeed, zero_mul, zero_add]
    have hraw : (Nat.rawCast 1 : ℝ) = 1 := by norm_num
    convert h using 1 <;> try simp only [hraw, mul_one]
    congr 1
    ring

/-- Each characteristic coordinate of the selected linear Godunov
wave step inherits the signed scalar Taylor error bound. -/
theorem leveque04_linearGodunov_characteristicTaylorError
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ) (ratio width : ℝ)
    (old : ℤ → (Fin m → ℝ)) (i : ℤ) (p : Fin m)
    (base slope shifted bound : ℝ)
    (hratio : 0 ≤ ratio) (hcfl : |waveSpeed p * ratio| ≤ 1)
    (hcurrent : |eigenbasis.equivFun (old i) p - base| ≤
      bound * width ^ 2)
    (hleft : |eigenbasis.equivFun (old (i - 1)) p -
        (base - width * slope)| ≤ bound * width ^ 2)
    (hright : |eigenbasis.equivFun (old (i + 1)) p -
        (base + width * slope)| ≤ bound * width ^ 2)
    (hshift : |shifted -
        (base - waveSpeed p * ratio * width * slope)| ≤
          bound * width ^ 2) :
    |eigenbasis.equivFun
        (leveque04_linearGodunovWaveStep eigenbasis waveSpeed ratio old i) p -
          shifted| ≤ 2 * bound * width ^ 2 := by
  rw [leveque04_linearGodunovWaveStep_characteristic]
  exact leveque04_signedGodunov_taylorError
    (waveSpeed p) ratio width base slope
    (eigenbasis.equivFun (old i) p)
    (eigenbasis.equivFun (old (i - 1)) p)
    (eigenbasis.equivFun (old (i + 1)) p)
    shifted bound hratio hcfl hcurrent hleft hright hshift

/-- The certified linear Riemann-interface flux produces the same
characteristic accuracy bound; this statement uses the selected
Godunov method rather than an independent upwind surrogate. -/
theorem leveque04_selectedLinearGodunov_characteristicTaylorError
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (hcoefficient : IsRealHyperbolicMatrix coefficient)
    (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (eigenbasis p) =
      waveSpeed p • eigenbasis p)
    (ratio width : ℝ) (old : ℤ → (Fin m → ℝ))
    (i : ℤ) (p : Fin m) (base slope shifted bound : ℝ)
    (hratio : 0 ≤ ratio) (hcfl : |waveSpeed p * ratio| ≤ 1)
    (hcurrent : |eigenbasis.equivFun (old i) p - base| ≤
      bound * width ^ 2)
    (hleft : |eigenbasis.equivFun (old (i - 1)) p -
        (base - width * slope)| ≤ bound * width ^ 2)
    (hright : |eigenbasis.equivFun (old (i + 1)) p -
        (base + width * slope)| ≤ bound * width ^ 2)
    (hshift : |shifted -
        (base - waveSpeed p * ratio * width * slope)| ≤
          bound * width ^ 2) :
    let method := linearRectangleRiemannInterfaceFluxMethod coefficient
      hcoefficient eigenbasis waveSpeed heigen
    let faceFlux := rectangleRiemannInterfaceFlux method old (fun _ => True.intro)
    |eigenbasis.equivFun
        (conservativeFluxDifferenceUpdateInt ratio old faceFlux i) p -
          shifted| ≤ 2 * bound * width ^ 2 := by
  dsimp only
  rw [leveque04_linearGodunovWaveStep_selected coefficient hcoefficient
    eigenbasis waveSpeed heigen old ratio i]
  exact leveque04_linearGodunov_characteristicTaylorError
    eigenbasis waveSpeed ratio width old i p base slope shifted bound
    hratio hcfl hcurrent hleft hright hshift

/-- A Lipschitz derivative of the sampled center function gives a
first-order residual bound for the positive-speed upwind step. -/
theorem leveque04_positiveGodunov_lipschitzCenterResidual
    (g g' : ℝ → ℝ) (speed ratio width K : ℝ) (i : ℤ)
    (hspeed : 0 < speed) (hratio : 0 < ratio) (hwidth : 0 < width)
    (hK : 0 ≤ K) (hcfl : speed * ratio ≤ 1)
    (hg : ∀ x, HasDerivAt g (g' x) x)
    (hLip : ∀ x y, |g' x - g' y| ≤ K * |x - y|) :
    |(leveque04_positiveUpwindStep (ratio * width) width speed
        (fun j : ℤ => g ((j : ℝ) * width)) i -
      g ((i : ℝ) * width - speed * ratio * width)) / (ratio * width)| ≤
      (2 * K / ratio) * width := by
  let center := (i : ℝ) * width
  have hleft := firstOrderTaylorError_le_of_lipschitzDeriv
    g g' K center (center - width) hK hg hLip
  have hshift := firstOrderTaylorError_le_of_lipschitzDeriv
    g g' K center (center - speed * ratio * width) hK hg hLip
  have hcflsq : (speed * ratio) ^ 2 ≤ 1 := by
    have hcpos : 0 ≤ speed * ratio := mul_nonneg hspeed.le hratio.le
    nlinarith [sq_nonneg (speed * ratio)]
  have hwsq : 0 ≤ width ^ 2 := sq_nonneg width
  have hshiftBound :
      |g (center - speed * ratio * width) -
          (g center - (speed * ratio) * width * g' center)| ≤ K * width ^ 2 := by
    have hprod : K * ((speed * ratio) ^ 2 * width ^ 2) ≤ K * width ^ 2 := by
      have hh := mul_le_mul_of_nonneg_right hcflsq hwsq
      nlinarith
    have hshift' :
        |g (center - speed * ratio * width) -
            (g center - (speed * ratio) * width * g' center)| ≤
          K * ((speed * ratio) ^ 2 * width ^ 2) := by
      convert hshift using 1 <;> ring
    exact le_trans hshift' hprod
  have hstep := leveque04_positiveGodunov_taylorResidual
    speed ratio width (g center) (g' center)
    (g (center - speed * ratio * width)) K
    (fun j : ℤ => g ((j : ℝ) * width)) i
    hspeed hratio hwidth hcfl ?_ ?_ hshiftBound
  · simpa [center] using hstep
  · simp [center]
    positivity
  · convert hleft using 1 <;> simp [center] <;> ring

/-- Positive-speed Godunov on exact translated cell averages has a
first-order residual when the center-average function has a
globally Lipschitz derivative. -/
theorem leveque04_positiveGodunov_lipschitzCellAverageResidual
    (profile averagedDeriv : ℝ → ℝ) (speed ratio width K : ℝ) (i : ℤ)
    (hspeed : 0 < speed) (hratio : 0 < ratio) (hwidth : 0 < width)
    (hK : 0 ≤ K) (hcfl : speed * ratio ≤ 1)
    (hg : ∀ center, HasDerivAt
      (fun c => oneDimensionalCellAverage profile (c - width / 2) (c + width / 2))
      (averagedDeriv center) center)
    (hLip : ∀ x y, |averagedDeriv x - averagedDeriv y| ≤ K * |x - y|) :
    |(leveque04_positiveUpwindStep (ratio * width) width speed
        (fun j : ℤ => oneDimensionalCellAverage profile
          ((j : ℝ) * width - width / 2)
          ((j : ℝ) * width + width / 2)) i -
      oneDimensionalCellAverage
        (fun x => profile (x - speed * ratio * width))
        ((i : ℝ) * width - width / 2)
        ((i : ℝ) * width + width / 2)) / (ratio * width)| ≤
      (2 * K / ratio) * width := by
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
  exact leveque04_positiveGodunov_lipschitzCenterResidual
    (fun c => oneDimensionalCellAverage profile (c - width / 2) (c + width / 2))
    averagedDeriv speed ratio width K i
    hspeed hratio hwidth hK hcfl hg hLip

/-- A globally Lipschitz profile derivative supplies the first-order
Godunov residual on exact translated cell averages for positive
constant-speed advection. -/
theorem leveque04_positiveGodunov_smoothProfileResidual
    (profile profile' : ℝ → ℝ) (speed ratio width K : ℝ) (i : ℤ)
    (hspeed : 0 < speed) (hratio : 0 < ratio) (hwidth : 0 < width)
    (hK : 0 ≤ K) (hcfl : speed * ratio ≤ 1)
    (hprofile : ∀ x, HasDerivAt profile (profile' x) x)
    (hLip : ∀ x y, |profile' x - profile' y| ≤ K * |x - y|) :
    |(leveque04_positiveUpwindStep (ratio * width) width speed
        (fun j : ℤ => oneDimensionalCellAverage profile
          ((j : ℝ) * width - width / 2)
          ((j : ℝ) * width + width / 2)) i -
      oneDimensionalCellAverage
        (fun x => profile (x - speed * ratio * width))
        ((i : ℝ) * width - width / 2)
        ((i : ℝ) * width + width / 2)) / (ratio * width)| ≤
      (2 * K / ratio) * width := by
  have hcont : Continuous profile :=
    continuous_iff_continuousAt.mpr (fun x => (hprofile x).continuousAt)
  exact leveque04_positiveGodunov_lipschitzCellAverageResidual
    profile
    (fun c => (profile (c + width / 2) - profile (c - width / 2)) / width)
    speed ratio width K i hspeed hratio hwidth hK hcfl
    (fun c => oneDimensionalCellAverage_hasDerivAt_center
      profile width c hcont hwidth)
    (fun x y => oneDimensionalCellAverage_faceSlope_lipschitz
      profile profile' K width x y hwidth hprofile hLip)

/-- Either signed upwind direction has a first-order normalized residual on samples of a function with Lipschitz derivative. -/
theorem leveque04_signedGodunov_lipschitzCenterResidual
    (g g' : ℝ → ℝ) (speed ratio width K : ℝ) (i : ℤ)
    (hratio : 0 < ratio) (hwidth : 0 < width) (hK : 0 ≤ K)
    (hcfl : |speed * ratio| ≤ 1)
    (hg : ∀ x, HasDerivAt g (g' x) x)
    (hLip : ∀ x y, |g' x - g' y| ≤ K * |x - y|) :
    let old : ℤ → ℝ := fun j => g ((j : ℝ) * width)
    |(old i - ratio *
        (leveque04_positiveVelocity speed * (old i - old (i - 1)) +
          leveque04_negativeVelocity speed * (old (i + 1) - old i)) -
        g ((i : ℝ) * width - speed * ratio * width)) / (ratio * width)| ≤
      (2 * K / ratio) * width := by
  dsimp only
  let center := (i : ℝ) * width
  have hleft := firstOrderTaylorError_le_of_lipschitzDeriv
    g g' K center (center - width) hK hg hLip
  have hright := firstOrderTaylorError_le_of_lipschitzDeriv
    g g' K center (center + width) hK hg hLip
  have hshift := firstOrderTaylorError_le_of_lipschitzDeriv
    g g' K center (center - speed * ratio * width) hK hg hLip
  have hcflsq : (speed * ratio) ^ 2 ≤ 1 := by
    have h := abs_le.mp hcfl
    nlinarith [sq_nonneg (speed * ratio)]
  have hwsq : 0 ≤ width ^ 2 := sq_nonneg width
  have hshiftBound :
      |g (center - speed * ratio * width) -
          (g center - (speed * ratio) * width * g' center)| ≤ K * width ^ 2 := by
    have hprod : K * ((speed * ratio) ^ 2 * width ^ 2) ≤ K * width ^ 2 := by
      have hh := mul_le_mul_of_nonneg_right hcflsq hwsq
      nlinarith
    have hshift' :
        |g (center - speed * ratio * width) -
            (g center - (speed * ratio) * width * g' center)| ≤
          K * ((speed * ratio) ^ 2 * width ^ 2) := by
      convert hshift using 1 <;> ring
    exact le_trans hshift' hprod
  have hstep := leveque04_signedGodunov_taylorError
    speed ratio width (g center) (g' center)
    (g center) (g (center - width)) (g (center + width))
    (g (center - speed * ratio * width)) K
    hratio.le hcfl ?_ ?_ ?_ hshiftBound
  · have htime := mul_pos hratio hwidth
    rw [abs_div, abs_of_pos htime]
    apply (div_le_iff₀ htime).mpr
    convert hstep using 1 <;> (try simp [center]) <;>
      field_simp [ne_of_gt hratio] <;> ring
  · simp [center]
    positivity
  · convert hleft using 1 <;> simp [center] <;> ring
  · convert hright using 1 <;> simp [center] <;> ring

/-- The signed upwind formula inherits the residual bound on exact translated cell averages. -/
theorem leveque04_signedGodunov_lipschitzCellAverageResidual
    (profile averagedDeriv : ℝ → ℝ) (speed ratio width K : ℝ) (i : ℤ)
    (hratio : 0 < ratio) (hwidth : 0 < width) (hK : 0 ≤ K)
    (hcfl : |speed * ratio| ≤ 1)
    (hg : ∀ center, HasDerivAt
      (fun c => oneDimensionalCellAverage profile (c - width / 2) (c + width / 2))
      (averagedDeriv center) center)
    (hLip : ∀ x y, |averagedDeriv x - averagedDeriv y| ≤ K * |x - y|) :
    let old : ℤ → ℝ := fun j => oneDimensionalCellAverage profile
      ((j : ℝ) * width - width / 2)
      ((j : ℝ) * width + width / 2)
    |(old i - ratio *
        (leveque04_positiveVelocity speed * (old i - old (i - 1)) +
          leveque04_negativeVelocity speed * (old (i + 1) - old i)) -
      oneDimensionalCellAverage
        (fun x => profile (x - speed * ratio * width))
        ((i : ℝ) * width - width / 2)
        ((i : ℝ) * width + width / 2)) / (ratio * width)| ≤
      (2 * K / ratio) * width := by
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
  exact leveque04_signedGodunov_lipschitzCenterResidual
    (fun c => oneDimensionalCellAverage profile (c - width / 2) (c + width / 2))
    averagedDeriv speed ratio width K i hratio hwidth hK hcfl hg hLip

/-- A C¹,¹ initial profile supplies the signed Godunov scalar residual bound with a mesh-independent constant. -/
theorem leveque04_signedGodunov_smoothProfileResidual
    (profile profile' : ℝ → ℝ) (speed ratio width K : ℝ) (i : ℤ)
    (hratio : 0 < ratio) (hwidth : 0 < width) (hK : 0 ≤ K)
    (hcfl : |speed * ratio| ≤ 1)
    (hprofile : ∀ x, HasDerivAt profile (profile' x) x)
    (hLip : ∀ x y, |profile' x - profile' y| ≤ K * |x - y|) :
    let old : ℤ → ℝ := fun j => oneDimensionalCellAverage profile
      ((j : ℝ) * width - width / 2)
      ((j : ℝ) * width + width / 2)
    |(old i - ratio *
        (leveque04_positiveVelocity speed * (old i - old (i - 1)) +
          leveque04_negativeVelocity speed * (old (i + 1) - old i)) -
      oneDimensionalCellAverage
        (fun x => profile (x - speed * ratio * width))
        ((i : ℝ) * width - width / 2)
        ((i : ℝ) * width + width / 2)) / (ratio * width)| ≤
      (2 * K / ratio) * width := by
  have hcont : Continuous profile :=
    continuous_iff_continuousAt.mpr (fun x => (hprofile x).continuousAt)
  exact leveque04_signedGodunov_lipschitzCellAverageResidual profile
    (fun c => (profile (c + width / 2) - profile (c - width / 2)) / width)
    speed ratio width K i hratio hwidth hK hcfl
    (fun c => oneDimensionalCellAverage_hasDerivAt_center
      profile width c hcont hwidth)
    (fun x y => oneDimensionalCellAverage_faceSlope_lipschitz
      profile profile' K width x y hwidth hprofile hLip)

/-- The certified selected linear Godunov update inherits a first-order
residual in each characteristic coordinate when its old grid data
sample a center function with Lipschitz derivative. -/
theorem leveque04_selectedLinearGodunov_lipschitzCharacteristicResidual
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (hcoefficient : IsRealHyperbolicMatrix coefficient)
    (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (eigenbasis p) =
      waveSpeed p • eigenbasis p)
    (ratio width : ℝ) (old : ℤ → (Fin m → ℝ)) (i : ℤ)
    (g g' : Fin m → ℝ → ℝ) (K : Fin m → ℝ)
    (hratio : 0 < ratio) (hwidth : 0 < width)
    (hK : ∀ p, 0 ≤ K p)
    (hcfl : ∀ p, |waveSpeed p * ratio| ≤ 1)
    (hsample : ∀ j p, eigenbasis.equivFun (old j) p = g p ((j : ℝ) * width))
    (hg : ∀ p x, HasDerivAt (g p) (g' p x) x)
    (hLip : ∀ p x y, |g' p x - g' p y| ≤ K p * |x - y|)
    (p : Fin m) :
    let method := linearRectangleRiemannInterfaceFluxMethod coefficient
      hcoefficient eigenbasis waveSpeed heigen
    let faceFlux := rectangleRiemannInterfaceFlux method old (fun _ => True.intro)
    |(eigenbasis.equivFun
        (conservativeFluxDifferenceUpdateInt ratio old faceFlux i) p -
      g p ((i : ℝ) * width - waveSpeed p * ratio * width)) /
        (ratio * width)| ≤ (2 * K p / ratio) * width := by
  dsimp only
  rw [leveque04_linearGodunovWaveStep_selected coefficient hcoefficient
    eigenbasis waveSpeed heigen old ratio i]
  rw [leveque04_linearGodunovWaveStep_characteristic]
  rw [hsample i p, hsample (i - 1) p, hsample (i + 1) p]
  exact leveque04_signedGodunov_lipschitzCenterResidual
    (g p) (g' p) (waveSpeed p) ratio width (K p) i
    hratio hwidth (hK p) (hcfl p) (hg p) (hLip p)

/-- For exact cell averages of globally C¹,¹ characteristic profiles,
the certified selected linear-system Godunov method has a first-order
residual in every characteristic coordinate. -/
theorem leveque04_selectedLinearGodunov_smoothProfileResidual
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (hcoefficient : IsRealHyperbolicMatrix coefficient)
    (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (eigenbasis p) =
      waveSpeed p • eigenbasis p)
    (ratio width : ℝ) (i : ℤ)
    (profile profile' : Fin m → ℝ → ℝ) (K : Fin m → ℝ)
    (hratio : 0 < ratio) (hwidth : 0 < width)
    (hK : ∀ p, 0 ≤ K p)
    (hcfl : ∀ p, |waveSpeed p * ratio| ≤ 1)
    (hprofile : ∀ p x, HasDerivAt (profile p) (profile' p x) x)
    (hLip : ∀ p x y, |profile' p x - profile' p y| ≤ K p * |x - y|)
    (p : Fin m) :
    let old : ℤ → (Fin m → ℝ) := fun j => eigenbasis.equivFun.symm
      (fun p => oneDimensionalCellAverage (profile p)
        ((j : ℝ) * width - width / 2)
        ((j : ℝ) * width + width / 2))
    let method := linearRectangleRiemannInterfaceFluxMethod coefficient
      hcoefficient eigenbasis waveSpeed heigen
    let faceFlux := rectangleRiemannInterfaceFlux method old (fun _ => True.intro)
    |(eigenbasis.equivFun
        (conservativeFluxDifferenceUpdateInt ratio old faceFlux i) p -
      oneDimensionalCellAverage
        (fun x => profile p (x - waveSpeed p * ratio * width))
        ((i : ℝ) * width - width / 2)
        ((i : ℝ) * width + width / 2)) /
        (ratio * width)| ≤ (2 * K p / ratio) * width := by
  dsimp only
  have hcont (p : Fin m) : Continuous (profile p) :=
    continuous_iff_continuousAt.mpr (fun x => (hprofile p x).continuousAt)
  have hnext : oneDimensionalCellAverage
        (fun x => profile p (x - waveSpeed p * ratio * width))
        ((i : ℝ) * width - width / 2)
        ((i : ℝ) * width + width / 2) =
      oneDimensionalCellAverage (profile p)
        (((i : ℝ) * width - waveSpeed p * ratio * width) - width / 2)
        (((i : ℝ) * width - waveSpeed p * ratio * width) + width / 2) := by
    rw [oneDimensionalCellAverage_comp_sub_right]
    congr 1 <;> ring
  rw [hnext]
  exact leveque04_selectedLinearGodunov_lipschitzCharacteristicResidual coefficient hcoefficient eigenbasis
    waveSpeed heigen ratio width
    (fun j => eigenbasis.equivFun.symm
      (fun p => oneDimensionalCellAverage (profile p)
        ((j : ℝ) * width - width / 2)
        ((j : ℝ) * width + width / 2)))
    i
    (fun p c => oneDimensionalCellAverage (profile p) (c - width / 2) (c + width / 2))
    (fun p c => (profile p (c + width / 2) - profile p (c - width / 2)) / width)
    K hratio hwidth hK hcfl
    (by
      intro j p
      change (eigenbasis.equivFun (eigenbasis.equivFun.symm
        (fun q => oneDimensionalCellAverage (profile q)
          ((j : ℝ) * width - width / 2)
          ((j : ℝ) * width + width / 2)))) p = _
      rw [LinearEquiv.apply_symm_apply])
    (fun p c => oneDimensionalCellAverage_hasDerivAt_center
      (profile p) width c (hcont p) hwidth)
    (fun p x y => oneDimensionalCellAverage_faceSlope_lipschitz
      (profile p) (profile' p) (K p) width x y hwidth (hprofile p) (hLip p))
    p

end NumStability
