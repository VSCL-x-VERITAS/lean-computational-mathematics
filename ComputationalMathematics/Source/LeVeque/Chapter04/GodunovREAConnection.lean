/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.REAIntegralUpdate
import ComputationalMathematics.Source.LeVeque.Chapter04.REACharacteristicEvolution
import ComputationalMathematics.Source.LeVeque.Chapter04.REAUniformReconstruction
import ComputationalMathematics.Source.LeVeque.Chapter04.GodunovStability
import ComputationalMathematics.Source.LeVeque.Chapter04.GodunovPhysicalAccuracy
import ComputationalMathematics.Source.LeVeque.Chapter04.GodunovOrderWitness
import ComputationalMathematics.Source.LeVeque.Chapter04.LinearGodunovCharacteristicStep
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearRiemannFluxAverage

/-!
# Linear Godunov wave step as a certified REA average

The selected linear Riemann method's wave update equals the average of a
rectangle-certified REA stage when its assembled physical face traces agree
with the selected local Riemann fluxes. This isolates the face-selection
obligation from the algebraic update and characteristic order proofs.
-/

namespace NumStability

open MeasureTheory

/-- The actual linear Godunov wave update is the REA average under certified
face-trace selection and the physical time-to-cell-width ratio. -/
theorem leveque04_linearGodunovWaveStep_eq_reaAverage
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (hcoefficient : IsRealHyperbolicMatrix coefficient)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (basis p) = speeds p • basis p)
    {grid : OneDimensionalFiniteVolumeGrid}
    {old : ℤ → (Fin m → ℝ)}
    (stage : Leveque04REAStage
      (linearHyperbolicConservationLaw coefficient hcoefficient) grid old
      (fun q => IsRectangleConservationLawSolution q coefficient.mulVec))
    (timeStep ratio : ℝ) (htime : 0 < timeStep)
    (hratio : ∀ i, timeStep / grid.cellVolume i = ratio)
    (hface : ∀ j,
      oneDimensionalCellAverage
        (fun τ => coefficient.mulVec (stage.evolved (grid.cellLeft j) τ))
        0 timeStep =
      rectangleRiemannInterfaceFlux
        (linearRectangleRiemannInterfaceFluxMethod coefficient
          hcoefficient basis speeds heigen) old (fun _ => trivial) j)
    (i : ℤ) :
    stage.nextAverage timeStep i =
      leveque04_linearGodunovWaveStep basis speeds ratio old i := by
  let method := linearRectangleRiemannInterfaceFluxMethod coefficient
    hcoefficient basis speeds heigen
  have hstep := stage.nextAverage_eq_selectedRiemannStep
    method (fun _ => trivial) timeStep htime hface i
  calc
    stage.nextAverage timeStep i =
        riemannFiniteVolumeUpdate grid timeStep old
          (rectangleRiemannInterfaceFlux method old (fun _ => trivial)) i := hstep
    _ = conservativeFluxDifferenceUpdateInt ratio old
          (rectangleRiemannInterfaceFlux method old (fun _ => trivial)) i := by
        simp only [riemannFiniteVolumeUpdate,
          conservativeFluxDifferenceUpdateInt, hratio i]
    _ = leveque04_linearGodunovWaveStep basis speeds ratio old i :=
      leveque04_linearGodunovWaveStep_selected coefficient hcoefficient
        basis speeds heigen old ratio i

/-- Positive-time face agreement with the selected linear Riemann fields
supplies the physical-flux condition in the REA-to-Godunov bridge. -/
theorem leveque04_linearGodunovWaveStep_eq_reaAverage_of_faceTrace
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (hcoefficient : IsRealHyperbolicMatrix coefficient)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (basis p) = speeds p • basis p)
    {grid : OneDimensionalFiniteVolumeGrid}
    {old : ℤ → (Fin m → ℝ)}
    (stage : Leveque04REAStage
      (linearHyperbolicConservationLaw coefficient hcoefficient) grid old
      (fun q => IsRectangleConservationLawSolution q coefficient.mulVec))
    (timeStep ratio : ℝ) (htime : 0 < timeStep)
    (hratio : ∀ i, timeStep / grid.cellVolume i = ratio)
    (htrace : ∀ j τ, τ ∈ Set.uIoc 0 timeStep →
      stage.evolved (grid.cellLeft j) τ =
        ((linearRectangleRiemannInterfaceFluxMethod coefficient
          hcoefficient basis speeds heigen).solve
          (adjacentCellRiemannProblem
            (linearHyperbolicConservationLaw coefficient hcoefficient) old j)
          trivial).solution 0 τ)
    (i : ℤ) :
    stage.nextAverage timeStep i =
      leveque04_linearGodunovWaveStep basis speeds ratio old i := by
  apply leveque04_linearGodunovWaveStep_eq_reaAverage coefficient
    hcoefficient basis speeds heigen stage timeStep ratio htime hratio _ i
  intro j
  have havg := linearRectangleRiemannInterfaceFluxMethod_flux_eq_timeAverage
    coefficient hcoefficient basis speeds heigen
    (adjacentCellRiemannProblem
      (linearHyperbolicConservationLaw coefficient hcoefficient) old j) htime
  unfold rectangleRiemannInterfaceFlux adjacentCellRectangleRiemannInformation
  rw [havg]
  unfold oneDimensionalCellAverage
  congr 1
  apply intervalIntegral.integral_congr_ae
  exact Filter.Eventually.of_forall (fun τ hτ =>
    congrArg coefficient.mulVec (htrace j τ hτ))

/-- The half-cell CFL bound and piecewise-constant reconstruction discharge
the physical face-trace premise for the selected linear Riemann method. -/
theorem leveque04_linearGodunovWaveStep_eq_reaAverage_of_halfCFL
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (hcoefficient : IsRealHyperbolicMatrix coefficient)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (basis p) = speeds p • basis p)
    {grid : OneDimensionalFiniteVolumeGrid}
    {old : ℤ → (Fin m → ℝ)}
    (stage : Leveque04REAStage
      (linearHyperbolicConservationLaw coefficient hcoefficient) grid old
      (fun q => IsRectangleConservationLawSolution q coefficient.mulVec))
    (interface : ℤ → ℝ)
    (hgrid : ∀ j, grid.cellLeft j = interface (j - 1))
    (hreconstruct : ∀ j x, x ∈ leveque04_cell interface j →
      stage.reconstructed x = old j)
    (hface : ∀ j, stage.reconstructed (interface j) = old j)
    (hevolution : ∀ x τ, stage.evolved x τ =
      linearCharacteristicEvolution basis speeds stage.reconstructed x τ)
    (bound timeStep ratio : ℝ) (hbound : 0 ≤ bound) (htime : 0 < timeStep)
    (hspeeds : ∀ p, -bound ≤ speeds p ∧ speeds p ≤ bound)
    (hwidth : ∀ j, 0 < leveque04_cellWidth interface j)
    (hCFL : ∀ j, 2 * bound * timeStep ≤ leveque04_cellWidth interface j)
    (hratio : ∀ j, timeStep / grid.cellVolume j = ratio)
    (i : ℤ) :
    stage.nextAverage timeStep i =
      leveque04_linearGodunovWaveStep basis speeds ratio old i := by
  apply leveque04_linearGodunovWaveStep_eq_reaAverage_of_faceTrace
    coefficient hcoefficient basis speeds heigen stage
    timeStep ratio htime hratio _ i
  intro j τ hτ
  have hτpos : 0 < τ := by
    simpa only [min_eq_left htime.le] using hτ.1
  have hτle : τ ≤ timeStep := by
    simpa only [max_eq_right htime.le] using hτ.2
  rw [hgrid j, hevolution]
  have hlocal := leveque04_linearCharacteristic_face_eq_localRiemann_of_halfCFL
    basis speeds interface old stage.reconstructed hreconstruct hface
    bound timeStep hbound htime hspeeds hwidth hCFL (j - 1) τ ⟨hτpos, hτle⟩
  simpa only [sub_add_cancel] using hlocal

/-- Iterating an exact linear REA stage that meets the half-cell fan bound
inherits the selected Godunov method's first-order fixed-horizon estimate in
each characteristic coordinate. The stage constructor is supplied for every
cell array reached by the iteration. -/
theorem leveque04_linearREA_smoothCharacteristic_globalError
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (hcoefficient : IsRealHyperbolicMatrix coefficient)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (basis p) = speeds p • basis p)
    (grid : OneDimensionalFiniteVolumeGrid)
    (interface : ℤ → ℝ)
    (hgrid : ∀ j, grid.cellLeft j = interface (j - 1))
    (stage : (old : ℤ → (Fin m → ℝ)) →
      Leveque04REAStage
        (linearHyperbolicConservationLaw coefficient hcoefficient) grid old
        (fun q => IsRectangleConservationLawSolution q coefficient.mulVec))
    (hreconstruct : ∀ old j x, x ∈ leveque04_cell interface j →
      (stage old).reconstructed x = old j)
    (hface : ∀ old j, (stage old).reconstructed (interface j) = old j)
    (hstageEvolution : ∀ old x τ, (stage old).evolved x τ =
      linearCharacteristicEvolution basis speeds (stage old).reconstructed x τ)
    (bound ratio width K horizon : ℝ)
    (hbound : 0 ≤ bound) (hratioPos : 0 < ratio) (hwidthPos : 0 < width)
    (hspeeds : ∀ p, -bound ≤ speeds p ∧ speeds p ≤ bound)
    (hcellWidth : ∀ j, 0 < leveque04_cellWidth interface j)
    (hCFL : ∀ j, 2 * bound * (ratio * width) ≤ leveque04_cellWidth interface j)
    (hgridRatio : ∀ j, (ratio * width) / grid.cellVolume j = ratio)
    (hK : 0 ≤ K)
    (hcfl : ∀ p, |speeds p * ratio| ≤ 1)
    (profile profile' : Fin m → ℕ → ℝ → ℝ)
    (hprofile : ∀ p k x, HasDerivAt (profile p k) (profile' p k x) x)
    (hLip : ∀ p k x y,
      |profile' p k x - profile' p k y| ≤ K * |x - y|)
    (hevolution : ∀ p k x,
      profile p (k + 1) x =
        profile p k (x - speeds p * ratio * width))
    (n : ℕ) (i : ℤ) (p : Fin m)
    (hhorizon : (n : ℝ) * ratio * width ≤ horizon) :
    let reaStep := fun old (j : ℤ) => (stage old).nextAverage (ratio * width) j
    let exactState := fun k (j : ℤ) =>
      basis.equivFun.symm (fun p =>
        oneDimensionalCellAverage (profile p k)
          ((j : ℝ) * width - width / 2)
          ((j : ℝ) * width + width / 2))
    |basis.equivFun ((reaStep^[n] (exactState 0)) i) p -
      basis.equivFun (exactState n i) p| ≤
      (2 * K * horizon / ratio) * width := by
  dsimp only
  have hstep : (fun old (j : ℤ) => (stage old).nextAverage (ratio * width) j) =
      leveque04_linearGodunovWaveStep basis speeds ratio := by
    funext old j
    exact leveque04_linearGodunovWaveStep_eq_reaAverage_of_halfCFL
      coefficient hcoefficient basis speeds heigen (stage old)
      interface hgrid (hreconstruct old) (hface old)
      (hstageEvolution old) bound (ratio * width) ratio hbound
      (mul_pos hratioPos hwidthPos) hspeeds hcellWidth hCFL hgridRatio j
  rw [hstep]
  exact leveque04_linearGodunov_smoothCharacteristic_globalError
    basis speeds profile profile' ratio width K horizon n i p
    hratioPos hwidthPos hK hcfl hprofile hLip hevolution hhorizon

/-- On a uniform grid, the concrete exact characteristic REA stage agrees
with the selected linear Godunov wave step under the half-cell CFL bound. -/
theorem leveque04_linearUniformREA_eq_godunovWaveStep
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (hcoefficient : IsRealHyperbolicMatrix coefficient)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (basis p) = speeds p • basis p)
    (origin width ratio bound : ℝ)
    (hwidth : 0 < width) (hratio : 0 < ratio) (hbound : 0 ≤ bound)
    (hspeeds : ∀ p, -bound ≤ speeds p ∧ speeds p ≤ bound)
    (hCFL : 2 * bound * (ratio * width) ≤ width)
    (old : ℤ → Fin m → ℝ) (i : ℤ) :
    (leveque04_linearUniformStage coefficient hcoefficient basis speeds heigen
      origin width hwidth old).nextAverage (ratio * width) i =
      leveque04_linearGodunovWaveStep basis speeds ratio old i := by
  apply leveque04_linearGodunovWaveStep_eq_reaAverage_of_halfCFL
    coefficient hcoefficient basis speeds heigen
    (leveque04_linearUniformStage coefficient hcoefficient basis speeds heigen
      origin width hwidth old)
    (leveque04_uniformInterface origin width)
    (fun _ => rfl)
    (fun j x hx => leveque04_uniformReconstruction_cell
      origin width hwidth old j x hx)
    (fun j => leveque04_uniformReconstruction_face origin width hwidth old j)
    (fun _ _ => rfl)
    bound (ratio * width) ratio hbound (mul_pos hratio hwidth) hspeeds
  · intro j
    dsimp [leveque04_cellWidth, leveque04_uniformInterface]
    push_cast
    nlinarith
  · intro j
    convert hCFL using 1
    dsimp [leveque04_cellWidth, leveque04_uniformInterface]
    push_cast
    ring
  · intro j
    have hvolume :
        (leveque04_uniformGrid origin width hwidth).cellVolume j = width := by
      dsimp [OneDimensionalFiniteVolumeGrid.cellVolume,
        leveque04_uniformGrid, leveque04_uniformInterface]
      push_cast
      ring
    rw [hvolume]
    field_simp

/-- The constructed exact linear REA method has a fixed-horizon first-order
bound in every characteristic coordinate on centered uniform cells. -/
theorem leveque04_linearUniformREA_smoothCharacteristic_globalError
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (hcoefficient : IsRealHyperbolicMatrix coefficient)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (basis p) = speeds p • basis p)
    (bound ratio width K horizon : ℝ)
    (hbound : 0 ≤ bound) (hratio : 0 < ratio) (hwidth : 0 < width)
    (hspeeds : ∀ p, -bound ≤ speeds p ∧ speeds p ≤ bound)
    (hCFL : 2 * bound * ratio ≤ 1)
    (hK : 0 ≤ K) (hcfl : ∀ p, |speeds p * ratio| ≤ 1)
    (profile profile' : Fin m → ℕ → ℝ → ℝ)
    (hprofile : ∀ p k x, HasDerivAt (profile p k) (profile' p k x) x)
    (hLip : ∀ p k x y,
      |profile' p k x - profile' p k y| ≤ K * |x - y|)
    (hevolution : ∀ p k x,
      profile p (k + 1) x =
        profile p k (x - speeds p * ratio * width))
    (n : ℕ) (i : ℤ) (p : Fin m)
    (hhorizon : (n : ℝ) * ratio * width ≤ horizon) :
    let stage := fun old => leveque04_linearUniformStage
      coefficient hcoefficient basis speeds heigen (width / 2) width hwidth old
    let reaStep := fun old (j : ℤ) => (stage old).nextAverage (ratio * width) j
    let exactState := fun k (j : ℤ) =>
      basis.equivFun.symm (fun p =>
        oneDimensionalCellAverage (profile p k)
          ((j : ℝ) * width - width / 2)
          ((j : ℝ) * width + width / 2))
    |basis.equivFun ((reaStep^[n] (exactState 0)) i) p -
      basis.equivFun (exactState n i) p| ≤
      (2 * K * horizon / ratio) * width := by
  dsimp only
  have hscaled : 2 * bound * (ratio * width) ≤ width := by
    nlinarith [mul_le_mul_of_nonneg_right hCFL hwidth.le]
  have hstep : (fun old (j : ℤ) =>
      (leveque04_linearUniformStage coefficient hcoefficient basis speeds
        heigen (width / 2) width hwidth old).nextAverage (ratio * width) j) =
      leveque04_linearGodunovWaveStep basis speeds ratio := by
    funext old j
    exact leveque04_linearUniformREA_eq_godunovWaveStep
      coefficient hcoefficient basis speeds heigen (width / 2) width
      ratio bound hwidth hratio hbound hspeeds hscaled old j
  rw [hstep]
  exact leveque04_linearGodunov_smoothCharacteristic_globalError
    basis speeds profile profile' ratio width K horizon n i p
    hratio hwidth hK hcfl hprofile hLip hevolution hhorizon

/-- The same concrete uniform REA method has a physical-component
fixed-horizon first-order error; the basis factor is mesh independent. -/
theorem leveque04_linearUniformREA_smoothPhysical_globalError
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (hcoefficient : IsRealHyperbolicMatrix coefficient)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (basis p) = speeds p • basis p)
    (bound ratio width K horizon : ℝ)
    (hbound : 0 ≤ bound) (hratio : 0 < ratio) (hwidth : 0 < width)
    (hspeeds : ∀ p, -bound ≤ speeds p ∧ speeds p ≤ bound)
    (hCFL : 2 * bound * ratio ≤ 1)
    (hK : 0 ≤ K) (hcfl : ∀ p, |speeds p * ratio| ≤ 1)
    (profile profile' : Fin m → ℕ → ℝ → ℝ)
    (hprofile : ∀ p k x, HasDerivAt (profile p k) (profile' p k x) x)
    (hLip : ∀ p k x y,
      |profile' p k x - profile' p k y| ≤ K * |x - y|)
    (hevolution : ∀ p k x,
      profile p (k + 1) x =
        profile p k (x - speeds p * ratio * width))
    (n : ℕ) (i : ℤ) (k : Fin m)
    (hhorizon : (n : ℝ) * ratio * width ≤ horizon) :
    let stage := fun old => leveque04_linearUniformStage
      coefficient hcoefficient basis speeds heigen (width / 2) width hwidth old
    let reaStep := fun old (j : ℤ) => (stage old).nextAverage (ratio * width) j
    let exactState := fun s (j : ℤ) =>
      basis.equivFun.symm (fun p =>
        oneDimensionalCellAverage (profile p s)
          ((j : ℝ) * width - width / 2)
          ((j : ℝ) * width + width / 2))
    |(reaStep^[n] (exactState 0)) i k - exactState n i k| ≤
      (∑ p : Fin m, |basis p k|) *
        ((2 * K * horizon / ratio) * width) := by
  dsimp only
  let stage := fun old => leveque04_linearUniformStage
    coefficient hcoefficient basis speeds heigen (width / 2) width hwidth old
  let reaStep := fun old (j : ℤ) => (stage old).nextAverage (ratio * width) j
  let exactState := fun s (j : ℤ) =>
    basis.equivFun.symm (fun p =>
      oneDimensionalCellAverage (profile p s)
        ((j : ℝ) * width - width / 2)
        ((j : ℝ) * width + width / 2))
  let evolved := (reaStep^[n] (exactState 0)) i
  have hcoord (p : Fin m) :
      |basis.equivFun evolved p - basis.equivFun (exactState n i) p| ≤
        (2 * K * horizon / ratio) * width := by
    exact leveque04_linearUniformREA_smoothCharacteristic_globalError
      coefficient hcoefficient basis speeds heigen
      bound ratio width K horizon hbound hratio hwidth hspeeds hCFL hK hcfl
      profile profile' hprofile hLip hevolution n i p hhorizon
  calc
    |evolved k - exactState n i k| ≤
      ∑ p : Fin m, |basis p k| *
        |basis.equivFun evolved p - basis.equivFun (exactState n i) p| :=
        leveque04_basis_physicalComponent_abs_le
          basis evolved (exactState n i) k
    _ ≤ ∑ p : Fin m, |basis p k| *
        ((2 * K * horizon / ratio) * width) := by
      apply Finset.sum_le_sum
      intro p _
      exact mul_le_mul_of_nonneg_left (hcoord p) (abs_nonneg _)
    _ = (∑ p : Fin m, |basis p k|) *
        ((2 * K * horizon / ratio) * width) := by
      rw [Finset.sum_mul]

/-- A positive characteristic of the concrete uniform REA method has an
exact nonzero first-order normalized residual on quadratic cell averages. -/
theorem leveque04_linearUniformREA_quadraticCharacteristicResidual
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (hcoefficient : IsRealHyperbolicMatrix coefficient)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (basis p) = speeds p • basis p)
    (origin width ratio bound : ℝ)
    (hwidth : 0 < width) (hratio : 0 < ratio) (hbound : 0 ≤ bound)
    (hspeeds : ∀ p, -bound ≤ speeds p ∧ speeds p ≤ bound)
    (hCFL : 2 * bound * (ratio * width) ≤ width)
    (p : Fin m) (hspeed : 0 < speeds p) (hcfl : speeds p * ratio < 1)
    (i : ℤ) :
    let old : ℤ → Fin m → ℝ := fun j => basis.equivFun.symm
      (fun _ => leveque04_quadraticCellAverage width j)
    (basis.equivFun
        ((leveque04_linearUniformStage coefficient hcoefficient basis speeds
          heigen origin width hwidth old).nextAverage (ratio * width) i) p -
      oneDimensionalCellAverage
        (fun x : ℝ => (x - speeds p * (ratio * width)) ^ 2)
        ((i : ℝ) * width - width / 2)
        ((i : ℝ) * width + width / 2)) / (ratio * width) =
        speeds p * (1 - speeds p * ratio) * width ∧
      0 < speeds p * (1 - speeds p * ratio) := by
  dsimp only
  let old : ℤ → Fin m → ℝ := fun j => basis.equivFun.symm
    (fun _ => leveque04_quadraticCellAverage width j)
  have hcoord (j : ℤ) :
      basis.equivFun (old j) p = leveque04_quadraticCellAverage width j := by
    simp only [old, LinearEquiv.apply_symm_apply]
  have hstep :
      basis.equivFun
          ((leveque04_linearUniformStage coefficient hcoefficient basis speeds
            heigen origin width hwidth old).nextAverage (ratio * width) i) p =
        leveque04_positiveUpwindStep (ratio * width) width (speeds p)
          (leveque04_quadraticCellAverage width) i := by
    rw [leveque04_linearUniformREA_eq_godunovWaveStep coefficient hcoefficient
      basis speeds heigen origin width ratio bound hwidth hratio hbound
      hspeeds hCFL old i]
    rw [leveque04_linearGodunovWaveStep_characteristic]
    rw [hcoord i, hcoord (i - 1), hcoord (i + 1)]
    simp only [leveque04_positiveVelocity, leveque04_negativeVelocity,
      max_eq_left hspeed.le, min_eq_right hspeed.le, zero_mul, add_zero]
    rw [leveque04_equation25 (ratio * width) width (speeds p)
      (leveque04_quadraticCellAverage width) i hspeed]
    have hwne : width ≠ 0 := ne_of_gt hwidth
    field_simp
  rw [hstep]
  exact leveque04_positiveGodunov_quadraticExactAverageResidual
    (speeds p) ratio width i hspeed hratio hwidth hcfl

/-- A supplied approximate evolution inherits a one-step error relative
to the selected Godunov update from a pointwise error against the concrete
exact uniform REA evolution. -/
theorem leveque04_approximateLinearUniformREA_godunovError
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (hcoefficient : IsRealHyperbolicMatrix coefficient)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (basis p) = speeds p • basis p)
    (origin width ratio bound : ℝ)
    (hwidth : 0 < width) (hratio : 0 < ratio) (hbound : 0 ≤ bound)
    (hspeeds : ∀ p, -bound ≤ speeds p ∧ speeds p ≤ bound)
    (hCFL : 2 * bound * (ratio * width) ≤ width)
    (old : ℤ → Fin m → ℝ) (i : ℤ) (error : ℝ)
    {ApproximateValid : (ℝ → ℝ → (Fin m → ℝ)) → Prop}
    (approximate : Leveque04REAStage
      (linearHyperbolicConservationLaw coefficient hcoefficient)
      (leveque04_uniformGrid origin width hwidth) old ApproximateValid)
    (happroximate : IntervalIntegrable
      (fun x => approximate.evolved x (ratio * width)) volume
      ((leveque04_uniformGrid origin width hwidth).cellLeft i)
      ((leveque04_uniformGrid origin width hwidth).cellRight i))
    (herror : ∀ x ∈ Set.uIoc
      ((leveque04_uniformGrid origin width hwidth).cellLeft i)
      ((leveque04_uniformGrid origin width hwidth).cellRight i),
      ‖approximate.evolved x (ratio * width) -
        (leveque04_linearUniformStage coefficient hcoefficient basis
          speeds heigen origin width hwidth old).evolved x (ratio * width)‖ ≤
        error) :
    ‖approximate.nextAverage (ratio * width) i -
      leveque04_linearGodunovWaveStep basis speeds ratio old i‖ ≤ error := by
  have hreference : IntervalIntegrable
      (fun x => (leveque04_linearUniformStage coefficient hcoefficient basis
        speeds heigen origin width hwidth old).evolved x (ratio * width))
      volume
      ((leveque04_uniformGrid origin width hwidth).cellLeft i)
      ((leveque04_uniformGrid origin width hwidth).cellRight i) := by
    exact leveque04_linearUniformEvolution_intervalIntegrable basis speeds
      origin width hwidth old (ratio * width) _ _
  rw [← leveque04_linearUniformREA_eq_godunovWaveStep coefficient
    hcoefficient basis speeds heigen origin width ratio bound hwidth hratio
    hbound hspeeds hCFL old i]
  exact leveque04_reaApproximateEvolution_cellAverageError
    (leveque04_linearUniformStage coefficient hcoefficient basis speeds
      heigen origin width hwidth old) approximate (ratio * width) i error
      hreference happroximate herror

end NumStability
