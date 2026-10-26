/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.Error.Measures.ConvexCombination
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.ScalarStencilTaylor
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LaxFriedrichsMonotonicity
import ComputationalMathematics.Source.LeVeque.Chapter04.CenteredAndLaxFriedrichsFlux
import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsStability
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.QuadraticCellAverage
import ComputationalMathematics.Analysis.Calculus.FirstOrderTaylor
import Mathlib.Analysis.SpecialFunctions.Integrals.Basic
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

/-!
# LeVeque Chapter 4: a sharp first-order Lax–Friedrichs defect

For the zero-flux equation and a quadratic stationary profile, the actual
Lax–Friedrichs update changes an exact cell average by one cell-width
squared. With a fixed positive time-to-width ratio, its local residual is
exactly linear in the width. This witnesses the first-order leading term;
a general smooth-data upper estimate is a separate task.
-/

namespace NumStability

open intervalIntegral

/-- The exact cell average of a translated linear-advection profile is
the original profile's cell-average function evaluated at the
translated cell center. -/
theorem leveque04_translatedProfileCellAverage
    (profile : ℝ → ℝ) (center width speed time : ℝ) :
    oneDimensionalCellAverage (fun x => profile (x - speed * time))
        (center - width / 2) (center + width / 2) =
      oneDimensionalCellAverage profile
        (center - speed * time - width / 2)
        (center - speed * time + width / 2) := by
  rw [oneDimensionalCellAverage_comp_sub_right]
  congr 1 <;> ring

/-- Exact average of the quadratic profile over the cell centered at `i*h`.
The `h²/12` correction distinguishes cell averages from point values. -/
noncomputable def leveque04_quadraticCellAverage
    (cellWidth : ℝ) (i : ℤ) : ℝ :=
  ((i : ℝ) * cellWidth) ^ 2 + cellWidth ^ 2 / 12

/-- Exact quadratic cell average at an arbitrary real center. This
also supplies the translated quadratic data used by the Godunov
order witness. -/
theorem leveque04_quadraticAverageAtCenter
    (center width : ℝ) (hwidth : 0 < width) :
    oneDimensionalCellAverage (fun x : ℝ => x ^ 2)
        (center - width / 2) (center + width / 2) =
      center ^ 2 + width ^ 2 / 12 := by
  exact oneDimensionalCellAverage_quadratic center width hwidth

/-- A translated quadratic profile has this exact cell average. -/
theorem leveque04_translatedQuadraticAverage
    (center width offset : ℝ) (hwidth : 0 < width) :
    oneDimensionalCellAverage (fun x : ℝ => (x - offset) ^ 2)
        (center - width / 2) (center + width / 2) =
      (center - offset) ^ 2 + width ^ 2 / 12 := by
  exact oneDimensionalCellAverage_translated_quadratic center width offset hwidth

theorem leveque04_quadraticCellAverage_exact
    (cellWidth : ℝ) (i : ℤ) (hwidth : 0 < cellWidth) :
    oneDimensionalCellAverage (fun x : ℝ => x ^ 2)
        ((i : ℝ) * cellWidth - cellWidth / 2)
        ((i : ℝ) * cellWidth + cellWidth / 2) =
      leveque04_quadraticCellAverage cellWidth i := by
  simpa only [leveque04_quadraticCellAverage] using
    oneDimensionalCellAverage_quadratic ((i : ℝ) * cellWidth) cellWidth hwidth

/-- For moving quadratic exact data, the linear Lax–Friedrichs step
has the explicit viscosity defect `(1 - courant²) * width²`. -/
theorem leveque04_laxFriedrichs_quadraticAdvectionDefect
    (courant width : ℝ) (i : ℤ) :
    leveque04_scalarLaxFriedrichsStep courant
        (leveque04_quadraticCellAverage width) i -
      ((((i : ℝ) * width - courant * width) ^ 2) + width ^ 2 / 12) =
      (1 - courant ^ 2) * width ^ 2 := by
  simp only [leveque04_scalarLaxFriedrichsStep,
    leveque04_quadraticCellAverage]
  push_cast
  ring

/-- The quadratic defect is measured against the exact cell average
of the translated linear-advection solution. -/
theorem leveque04_laxFriedrichs_quadraticExactAverageDefect
    (speed ratio width : ℝ) (i : ℤ) (hwidth : 0 < width) :
    leveque04_scalarLaxFriedrichsStep (speed * ratio)
        (leveque04_quadraticCellAverage width) i -
      oneDimensionalCellAverage
        (fun x : ℝ => (x - speed * ratio * width) ^ 2)
        ((i : ℝ) * width - width / 2)
        ((i : ℝ) * width + width / 2) =
      (1 - (speed * ratio) ^ 2) * width ^ 2 := by
  convert leveque04_laxFriedrichs_quadraticAdvectionDefect
    (speed * ratio) width i using 1
  · rw [leveque04_translatedQuadraticAverage
      ((i : ℝ) * width) width (speed * ratio * width) hwidth]

/-- At a fixed positive time-to-width ratio and a strict CFL
number, the quadratic exact-average residual is a nonzero multiple
of the width. -/
theorem leveque04_laxFriedrichs_quadraticAdvectionResidual
    (speed ratio width : ℝ) (i : ℤ)
    (hratio : 0 < ratio) (hwidth : 0 < width) :
    (leveque04_scalarLaxFriedrichsStep (speed * ratio)
        (leveque04_quadraticCellAverage width) i -
      oneDimensionalCellAverage
        (fun x : ℝ => (x - speed * ratio * width) ^ 2)
        ((i : ℝ) * width - width / 2)
        ((i : ℝ) * width + width / 2)) / (ratio * width) =
      ((1 - (speed * ratio) ^ 2) / ratio) * width := by
  rw [leveque04_laxFriedrichs_quadraticExactAverageDefect
    speed ratio width i hwidth]
  have hrne : ratio ≠ 0 := ne_of_gt hratio
  have hwne : width ≠ 0 := ne_of_gt hwidth
  field_simp

/-- A quadratic solution of linear advection witnesses a strictly
positive first-order Lax–Friedrichs residual at every strict CFL
number. The exact average here is evaluated at the new time. -/
theorem leveque04_laxFriedrichs_quadraticAdvectionResidual_pos
    (speed ratio width : ℝ) (i : ℤ)
    (hratio : 0 < ratio) (hwidth : 0 < width)
    (hcfl : |speed * ratio| < 1) :
    0 < (leveque04_scalarLaxFriedrichsStep (speed * ratio)
          (leveque04_quadraticCellAverage width) i -
        oneDimensionalCellAverage
          (fun x : ℝ => (x - speed * ratio * width) ^ 2)
          ((i : ℝ) * width - width / 2)
          ((i : ℝ) * width + width / 2)) / (ratio * width) := by
  rw [leveque04_laxFriedrichs_quadraticAdvectionResidual
    speed ratio width i hratio hwidth]
  have hsq : (speed * ratio) ^ 2 < 1 := by
    have h := abs_lt.mp hcfl
    nlinarith [sq_nonneg (speed * ratio)]
  exact mul_pos (div_pos (sub_pos.mpr hsq) hratio) hwidth

/-- At zero physical flux, one Lax–Friedrichs step adds exactly `h²` to
each exact quadratic cell average. -/
theorem leveque04_laxFriedrichs_quadraticDefect
    (timeStep cellWidth : ℝ) (i : ℤ)
    (htime : 0 < timeStep) (hwidth : 0 < cellWidth) :
    let old : ℤ → (Fin 1 → ℝ) :=
      fun j _ => leveque04_quadraticCellAverage cellWidth j
    leveque04_finiteVolumeUpdate timeStep cellWidth old
        (leveque04_localInterfaceFlux
          (leveque04_laxFriedrichsFlux timeStep cellWidth
            (fun _ => (0 : Fin 1 → ℝ))) old) i 0 =
      leveque04_quadraticCellAverage cellWidth i + cellWidth ^ 2 := by
  dsimp only
  rw [leveque04_equation20 timeStep cellWidth
    (fun _ => (0 : Fin 1 → ℝ))
    (fun j _ => leveque04_quadraticCellAverage cellWidth j) i 0 htime hwidth]
  simp only [Pi.zero_apply, sub_self, mul_zero, sub_zero,
    leveque04_quadraticCellAverage]
  push_cast
  ring

/-- With fixed `dt/h=r>0`, the time-normalized local defect on this smooth
stationary solution is exactly `h/r`, showing the leading first-order scale. -/
theorem leveque04_laxFriedrichs_quadraticResidual
    (ratio cellWidth : ℝ) (i : ℤ)
    (hratio : 0 < ratio) (hwidth : 0 < cellWidth) :
    let old : ℤ → (Fin 1 → ℝ) :=
      fun j _ => leveque04_quadraticCellAverage cellWidth j
    (leveque04_finiteVolumeUpdate (ratio * cellWidth) cellWidth old
        (leveque04_localInterfaceFlux
          (leveque04_laxFriedrichsFlux (ratio * cellWidth) cellWidth
            (fun _ => (0 : Fin 1 → ℝ))) old) i 0 -
      leveque04_quadraticCellAverage cellWidth i) /
      (ratio * cellWidth) = cellWidth / ratio := by
  dsimp only
  rw [leveque04_laxFriedrichs_quadraticDefect
    (ratio * cellWidth) cellWidth i (mul_pos hratio hwidth) hwidth]
  have hrne : ratio ≠ 0 := ne_of_gt hratio
  have hwne : cellWidth ≠ 0 := ne_of_gt hwidth
  field_simp
  ring


/-- The Taylor estimate applies to the actual finite-volume update (4.20)
for a linear advection flux. The exact next cell average is `shifted`;
the three Taylor hypotheses encode its local smoothness. -/
theorem leveque04_laxFriedrichs_linearTaylorError
    (speed timeStep width base slope shifted bound : ℝ)
    (old : ℤ → ℝ) (i : ℤ)
    (htime : 0 < timeStep) (hwidth : 0 < width)
    (hbound : 0 ≤ bound) (hcfl : |speed * timeStep / width| ≤ 1)
    (hleft : |old (i - 1) - (base - width * slope)| ≤ bound * width ^ 2)
    (hright : |old (i + 1) - (base + width * slope)| ≤ bound * width ^ 2)
    (hshift : |shifted - (base - (speed * timeStep / width) * width * slope)| ≤
      bound * width ^ 2) :
    |leveque04_finiteVolumeUpdate timeStep width
        (fun (j : ℤ) (_ : Fin 1) => old j)
        (leveque04_localInterfaceFlux
          (leveque04_laxFriedrichsFlux timeStep width
            (fun (state : Fin 1 → ℝ) (_ : Fin 1) => speed * state 0))
          (fun (j : ℤ) (_ : Fin 1) => old j)) i 0 - shifted| ≤
      2 * bound * width ^ 2 := by
  rw [leveque04_scalarLaxFriedrichsStep_eq_equation20
    speed timeStep width htime hwidth old i]
  have h := leveque04_laxFriedrichs_taylorError
    (speed * timeStep / width) width base slope
    (old (i - 1)) (old (i + 1)) shifted bound
    (le_of_lt hwidth) hbound hcfl hleft hright hshift
  dsimp [leveque04_scalarLaxFriedrichsStep] at *
  convert h using 1; ring_nf

/-- At a fixed positive time-to-width ratio, (4.20) has at most a
first-order time-normalized local residual under the stated Taylor bounds. -/
theorem leveque04_laxFriedrichs_linearTaylorResidual
    (speed ratio width base slope shifted bound : ℝ)
    (old : ℤ → ℝ) (i : ℤ)
    (hratio : 0 < ratio) (hwidth : 0 < width)
    (hbound : 0 ≤ bound) (hcfl : |speed * ratio| ≤ 1)
    (hleft : |old (i - 1) - (base - width * slope)| ≤ bound * width ^ 2)
    (hright : |old (i + 1) - (base + width * slope)| ≤ bound * width ^ 2)
    (hshift : |shifted - (base - (speed * ratio) * width * slope)| ≤
      bound * width ^ 2) :
    |(leveque04_finiteVolumeUpdate (ratio * width) width
        (fun (j : ℤ) (_ : Fin 1) => old j)
        (leveque04_localInterfaceFlux
          (leveque04_laxFriedrichsFlux (ratio * width) width
            (fun (state : Fin 1 → ℝ) (_ : Fin 1) => speed * state 0))
          (fun (j : ℤ) (_ : Fin 1) => old j)) i 0 - shifted) /
        (ratio * width)| ≤ (2 * bound / ratio) * width := by
  have hratioWidth : 0 < ratio * width := mul_pos hratio hwidth
  have hwidthNe : width ≠ 0 := ne_of_gt hwidth
  have hratioNe : ratio ≠ 0 := ne_of_gt hratio
  have hcfl' : |speed * (ratio * width) / width| ≤ 1 := by
    convert hcfl using 1; field_simp
  have hshift' :
      |shifted - (base - (speed * (ratio * width) / width) * width * slope)| ≤
        bound * width ^ 2 := by
    convert hshift using 1; field_simp
  have h := leveque04_laxFriedrichs_linearTaylorError
    speed (ratio * width) width base slope shifted bound old i
    hratioWidth hwidth hbound hcfl' hleft hright hshift'
  rw [abs_div, abs_of_pos hratioWidth]
  apply (div_le_iff₀ hratioWidth).mpr
  convert h using 1; field_simp


/-- With local second-order expansions of the cell averages, their exact
next-time value, and the nonlinear flux, the actual update (4.20) has
first-order time-normalized residual at fixed `dt/width = ratio`. -/
theorem leveque04_laxFriedrichs_nonlinearTaylorResidual
    (flux : ℝ → ℝ) (ratio width speed base slope shifted
      valueBound fluxBase fluxBound : ℝ)
    (old : ℤ → ℝ) (i : ℤ)
    (hratio : 0 < ratio) (hwidth : 0 < width)
    (hvalueBound : 0 ≤ valueBound)
    (hcfl : |speed * ratio| ≤ 1)
    (hleft : |old (i - 1) - (base - width * slope)| ≤
      valueBound * width ^ 2)
    (hright : |old (i + 1) - (base + width * slope)| ≤
      valueBound * width ^ 2)
    (hshift : |shifted - (base - (speed * ratio) * width * slope)| ≤
      valueBound * width ^ 2)
    (hfluxLeft : |flux (old (i - 1)) -
        (fluxBase + speed * old (i - 1))| ≤ fluxBound * width ^ 2)
    (hfluxRight : |flux (old (i + 1)) -
        (fluxBase + speed * old (i + 1))| ≤ fluxBound * width ^ 2) :
    |(leveque04_finiteVolumeUpdate (ratio * width) width
        (fun (j : ℤ) (_ : Fin 1) => old j)
        (leveque04_localInterfaceFlux
          (leveque04_laxFriedrichsFlux (ratio * width) width
            (fun (state : Fin 1 → ℝ) (_ : Fin 1) => flux (state 0)))
          (fun (j : ℤ) (_ : Fin 1) => old j)) i 0 - shifted) /
        (ratio * width)| ≤
      ((2 * valueBound + ratio * fluxBound) / ratio) * width := by
  have htime : 0 < ratio * width := mul_pos hratio hwidth
  have hwidthNe : width ≠ 0 := ne_of_gt hwidth
  have hratioNe : ratio ≠ 0 := ne_of_gt hratio
  rw [leveque04_equation20 (ratio * width) width
    (fun (state : Fin 1 → ℝ) (_ : Fin 1) => flux (state 0))
    (fun (j : ℤ) (_ : Fin 1) => old j) i 0 htime hwidth]
  simp only at *
  have hlinear := leveque04_laxFriedrichs_taylorError
    (speed * ratio) width base slope (old (i - 1)) (old (i + 1))
    shifted valueBound (le_of_lt hwidth) hvalueBound hcfl
    hleft hright hshift
  have hflux := leveque04_laxFriedrichs_fluxLinearizationError
    ratio width speed fluxBase fluxBound (old (i - 1)) (old (i + 1))
    (flux (old (i - 1))) (flux (old (i + 1)))
    hratio.le hfluxLeft hfluxRight
  have hcoef : ratio * width / (2 * width) = ratio / 2 := by
    field_simp
  rw [hcoef]
  have htri := abs_add_le
    (((old (i - 1) + old (i + 1)) / 2 -
        ratio / 2 * (flux (old (i + 1)) - flux (old (i - 1)))) -
       ((old (i - 1) + old (i + 1)) / 2 -
        speed * ratio / 2 * (old (i + 1) - old (i - 1))))
    (((old (i - 1) + old (i + 1)) / 2 -
        speed * ratio / 2 * (old (i + 1) - old (i - 1))) - shifted)
  have hsum :
      |(old (i - 1) + old (i + 1)) / 2 -
          ratio / 2 * (flux (old (i + 1)) - flux (old (i - 1))) - shifted| ≤
        (2 * valueBound + ratio * fluxBound) * width ^ 2 := by
    calc
      _ = |(((old (i - 1) + old (i + 1)) / 2 -
          ratio / 2 * (flux (old (i + 1)) - flux (old (i - 1)))) -
        ((old (i - 1) + old (i + 1)) / 2 -
          speed * ratio / 2 * (old (i + 1) - old (i - 1)))) +
        (((old (i - 1) + old (i + 1)) / 2 -
          speed * ratio / 2 * (old (i + 1) - old (i - 1))) - shifted)| := by
            congr 1
            ring
      _ ≤ _ := htri
      _ ≤ _ := by linarith
  rw [abs_div, abs_of_pos htime]
  apply (div_le_iff₀ htime).mpr
  convert hsum using 1; field_simp

/-- Sampling a globally differentiable center-value function with Lipschitz derivative
gives a first-order normalized residual for the scalar Lax–Friedrichs stencil. -/
theorem leveque04_laxFriedrichs_lipschitzCenterResidual
    (g g' : ℝ → ℝ) (speed ratio width K : ℝ) (i : ℤ)
    (hratio : 0 < ratio) (hwidth : 0 < width) (hK : 0 ≤ K)
    (hcfl : |speed * ratio| ≤ 1)
    (hg : ∀ x, HasDerivAt g (g' x) x)
    (hLip : ∀ x y, |g' x - g' y| ≤ K * |x - y|) :
    |(leveque04_scalarLaxFriedrichsStep (speed * ratio)
        (fun j : ℤ => g ((j : ℝ) * width)) i -
      g ((i : ℝ) * width - speed * ratio * width)) / (ratio * width)| ≤
      (2 * K / ratio) * width := by
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
  have hstep := leveque04_laxFriedrichs_linearTaylorResidual
    speed ratio width (g center) (g' center)
    (g (center - speed * ratio * width)) K
    (fun j : ℤ => g ((j : ℝ) * width)) i
    hratio hwidth hK hcfl ?_ ?_ hshiftBound
  · have htime := mul_pos hratio hwidth
    rw [leveque04_scalarLaxFriedrichsStep_eq_equation20
      speed (ratio * width) width htime hwidth
      (fun j : ℤ => g ((j : ℝ) * width)) i] at hstep
    have hwne : width ≠ 0 := ne_of_gt hwidth
    have hcw : speed * (ratio * width) / width = speed * ratio := by
      field_simp
    rw [hcw] at hstep
    simpa [center] using hstep
  · convert hleft using 1 <;> simp [center] <;> ring
  · convert hright using 1 <;> simp [center] <;> ring

/-- The exact translated cell average of a smooth linear-advection profile
satisfies the first-order Lax–Friedrichs bound when its center-average
function has a globally Lipschitz derivative. -/
theorem leveque04_laxFriedrichs_lipschitzCellAverageResidual
    (profile averagedDeriv : ℝ → ℝ) (speed ratio width K : ℝ) (i : ℤ)
    (hratio : 0 < ratio) (hwidth : 0 < width) (hK : 0 ≤ K)
    (hcfl : |speed * ratio| ≤ 1)
    (hg : ∀ center, HasDerivAt
      (fun c => oneDimensionalCellAverage profile (c - width / 2) (c + width / 2))
      (averagedDeriv center) center)
    (hLip : ∀ x y, |averagedDeriv x - averagedDeriv y| ≤ K * |x - y|) :
    |(leveque04_scalarLaxFriedrichsStep (speed * ratio)
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
  have h := leveque04_laxFriedrichs_lipschitzCenterResidual
    (fun c => oneDimensionalCellAverage profile (c - width / 2) (c + width / 2))
    averagedDeriv speed ratio width K i hratio hwidth hK hcfl hg hLip
  exact h

/-- A profile with a globally Lipschitz first derivative gives a
first-order Lax–Friedrichs residual on its exact translated cell
averages, with a mesh-independent constant. -/
theorem leveque04_laxFriedrichs_smoothProfileResidual
    (profile profile' : ℝ → ℝ) (speed ratio width K : ℝ) (i : ℤ)
    (hratio : 0 < ratio) (hwidth : 0 < width) (hK : 0 ≤ K)
    (hcfl : |speed * ratio| ≤ 1)
    (hprofile : ∀ x, HasDerivAt profile (profile' x) x)
    (hLip : ∀ x y, |profile' x - profile' y| ≤ K * |x - y|) :
    |(leveque04_scalarLaxFriedrichsStep (speed * ratio)
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
  exact leveque04_laxFriedrichs_lipschitzCellAverageResidual
    profile
    (fun c => (profile (c + width / 2) - profile (c - width / 2)) / width)
    speed ratio width K i hratio hwidth hK hcfl
    (fun c => oneDimensionalCellAverage_hasDerivAt_center
      profile width c hcont hwidth)
    (fun x y => oneDimensionalCellAverage_faceSlope_lipschitz
      profile profile' K width x y hwidth hprofile hLip)

/-- A uniform one-step defect accumulates at most linearly under the
    scalar Lax–Friedrichs CFL bound. This transfers local truncation
    estimates to an error estimate over any finite number of steps. -/
theorem leveque04_laxFriedrichs_iterate_error
    (courant initialError localError : ℝ)
    (initial : ℤ → ℝ) (exactState : ℕ → ℤ → ℝ) (n : ℕ)
    (hcfl : |courant| ≤ 1)
    (hinitial : ∀ i, |initial i - exactState 0 i| ≤ initialError)
    (hlocal : ∀ k i,
      |leveque04_scalarLaxFriedrichsStep courant (exactState k) i -
        exactState (k + 1) i| ≤ localError) (i : ℤ) :
    |((leveque04_scalarLaxFriedrichsStep courant)^[n] initial) i -
      exactState n i| ≤ initialError + (n : ℝ) * localError := by
  induction n generalizing i with
  | zero => simpa using hinitial i
  | succ n ih =>
      let approx :=
        ((leveque04_scalarLaxFriedrichsStep courant)^[n] initial)
      let error := fun j => approx j - exactState n j
      have herror : ∀ j, |error j| ≤ initialError + (n : ℝ) * localError :=
        fun j => ih j
      have hstep := leveque04_scalarLaxFriedrichsStep_bound
        courant (initialError + (n : ℝ) * localError) hcfl error herror i
      have hlinear :
          leveque04_scalarLaxFriedrichsStep courant approx i -
            leveque04_scalarLaxFriedrichsStep courant (exactState n) i =
          leveque04_scalarLaxFriedrichsStep courant error i := by
        simp only [leveque04_scalarLaxFriedrichsStep]
        dsimp [error]
        ring
      rw [Function.iterate_succ_apply']
      calc
        |leveque04_scalarLaxFriedrichsStep courant approx i -
            exactState (n + 1) i| =
          |(leveque04_scalarLaxFriedrichsStep courant approx i -
              leveque04_scalarLaxFriedrichsStep courant (exactState n) i) +
            (leveque04_scalarLaxFriedrichsStep courant (exactState n) i -
              exactState (n + 1) i)| := by congr 1; ring
        _ ≤ |leveque04_scalarLaxFriedrichsStep courant error i| +
              |leveque04_scalarLaxFriedrichsStep courant (exactState n) i -
                exactState (n + 1) i| := by rw [hlinear]; exact abs_add_le _ _
        _ ≤ initialError + ((n + 1 : ℕ) : ℝ) * localError := by
          have hl := hlocal n i
          push_cast
          linarith

/-- For smooth translated exact cell averages, the scalar linear
    Lax–Friedrichs error at a fixed time horizon is first order in width.
    The profile sequence supplies the exact advection evolution. -/
theorem leveque04_laxFriedrichs_smoothProfile_globalError
    (profile profile' : ℕ → ℝ → ℝ)
    (speed ratio width K horizon : ℝ) (n : ℕ) (i : ℤ)
    (hratio : 0 < ratio) (hwidth : 0 < width) (hK : 0 ≤ K)
    (hcfl : |speed * ratio| ≤ 1)
    (hprofile : ∀ k x, HasDerivAt (profile k) (profile' k x) x)
    (hLip : ∀ k x y,
      |profile' k x - profile' k y| ≤ K * |x - y|)
    (hevolution : ∀ k x,
      profile (k + 1) x = profile k (x - speed * ratio * width))
    (hhorizon : (n : ℝ) * ratio * width ≤ horizon) :
    let exactState := fun k (j : ℤ) =>
      oneDimensionalCellAverage (profile k)
        ((j : ℝ) * width - width / 2)
        ((j : ℝ) * width + width / 2)
    |((leveque04_scalarLaxFriedrichsStep (speed * ratio))^[n]
        (exactState 0)) i - exactState n i| ≤
      (2 * K * horizon / ratio) * width := by
  let exactState := fun k (j : ℤ) =>
    oneDimensionalCellAverage (profile k)
      ((j : ℝ) * width - width / 2)
      ((j : ℝ) * width + width / 2)
  have htime : 0 < ratio * width := mul_pos hratio hwidth
  have hlocal : ∀ k j,
      |leveque04_scalarLaxFriedrichsStep (speed * ratio)
          (exactState k) j - exactState (k + 1) j| ≤ 2 * K * width ^ 2 := by
    intro k j
    have hresidual := leveque04_laxFriedrichs_smoothProfileResidual
      (profile k) (profile' k) speed ratio width K j
      hratio hwidth hK hcfl (hprofile k) (hLip k)
    have hnext :
        oneDimensionalCellAverage
          (fun x => profile k (x - speed * ratio * width))
          ((j : ℝ) * width - width / 2)
          ((j : ℝ) * width + width / 2) = exactState (k + 1) j := by
      congr 1
      funext x
      exact (hevolution k x).symm
    rw [hnext] at hresidual
    have hmul := mul_le_mul_of_nonneg_right hresidual htime.le
    rw [abs_div, abs_of_pos htime, div_mul_cancel₀ _ (ne_of_gt htime)] at hmul
    have hfactor :
        2 * K / ratio * width * (ratio * width) = 2 * K * width ^ 2 := by
      field_simp
    simpa only [hfactor] using hmul
  have hglobal := leveque04_laxFriedrichs_iterate_error
    (speed * ratio) 0 (2 * K * width ^ 2)
    (exactState 0) exactState n hcfl (by intro j; simp) hlocal i
  dsimp only at hglobal ⊢
  have hnonneg : 0 ≤ 2 * K * width / ratio :=
    div_nonneg (mul_nonneg (mul_nonneg (by norm_num) hK) hwidth.le) hratio.le
  have hscaled := mul_le_mul_of_nonneg_right hhorizon hnonneg
  calc
    _ ≤ (n : ℝ) * (2 * K * width ^ 2) := by simpa using hglobal
    _ ≤ (2 * K * horizon / ratio) * width := by
      convert hscaled using 1 <;> field_simp <;> ring


end NumStability
