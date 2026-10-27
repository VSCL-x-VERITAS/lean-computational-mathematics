/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LinearRiemannTraceFlux
import ComputationalMathematics.Source.LeVeque.Chapter04.FluxVectorSplitting
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

/-!
# LeVeque Chapter 4: linear flux-difference and flux-vector splitting

The selected certified linear Riemann flux equals the positive-matrix
left flux plus negative-matrix right flux. A nonlinear face flux can
give a valid flux-difference split without any statewise additive
flux-vector split; this exhibits the scope of the linear equivalence.
-/

namespace NumStability

/-- The actual selected linear Riemann face flux has the split-matrix
representation (4.56), for arbitrary left and right states. -/
theorem leveque04_selectedLinearFlux_eq_vectorSplit
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (hcoefficient : IsRealHyperbolicMatrix coefficient)
    (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (eigenbasis p) =
      waveSpeed p • eigenbasis p)
    (left right : Fin m → ℝ) :
    let method := linearRectangleRiemannInterfaceFluxMethod coefficient
      hcoefficient eigenbasis waveSpeed heigen
    method.numericalFluxFromInformation
        (method.extractInformation (method.solve ⟨left, right⟩ trivial)) =
      (leveque04_positiveCoefficientPart eigenbasis waveSpeed).mulVec left +
        (leveque04_negativeCoefficientPart eigenbasis waveSpeed).mulVec right := by
  have hdiag := (Leveque02Tracer.realEigenbasisDiagonalization
    coefficient waveSpeed eigenbasis heigen).2
  apply leveque04_equation56_from49 coefficient eigenbasis waveSpeed
    hdiag left right _
  simpa only using leveque04_equation49_selected coefficient
    hcoefficient eigenbasis waveSpeed heigen left right

/-- For every old cell array, the selected linear Riemann method and
its flux-vector splitting produce identical face fluxes and hence
identical conservative updates. -/
theorem leveque04_linearSplittingEquivalence
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (hcoefficient : IsRealHyperbolicMatrix coefficient)
    (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (eigenbasis p) =
      waveSpeed p • eigenbasis p)
    (old : ℤ → (Fin m → ℝ)) (scale : ℝ) (i : ℤ) :
    let method := linearRectangleRiemannInterfaceFluxMethod coefficient
      hcoefficient eigenbasis waveSpeed heigen
    let selected := rectangleRiemannInterfaceFlux method old (fun _ => trivial)
    let positive : ℤ → (Fin m → ℝ) := fun j =>
      (leveque04_positiveCoefficientPart eigenbasis waveSpeed).mulVec (old j)
    let negative : ℤ → (Fin m → ℝ) := fun j =>
      (leveque04_negativeCoefficientPart eigenbasis waveSpeed).mulVec (old j)
    (∀ j, selected j = FluxVectorSplitting.faceFlux positive negative j) ∧
      conservativeFluxDifferenceUpdateInt scale old selected i =
        conservativeFluxDifferenceUpdateInt scale old
          (FluxVectorSplitting.faceFlux positive negative) i := by
  dsimp only
  have hface (j : ℤ) :
      rectangleRiemannInterfaceFlux
          (linearRectangleRiemannInterfaceFluxMethod coefficient
            hcoefficient eigenbasis waveSpeed heigen)
          old (fun _ => trivial) j =
        FluxVectorSplitting.faceFlux
          (fun k => (leveque04_positiveCoefficientPart
            eigenbasis waveSpeed).mulVec (old k))
          (fun k => (leveque04_negativeCoefficientPart
            eigenbasis waveSpeed).mulVec (old k)) j := by
    change (linearRectangleRiemannInterfaceFluxMethod coefficient
        hcoefficient eigenbasis waveSpeed heigen).numericalFluxFromInformation
      ((linearRectangleRiemannInterfaceFluxMethod coefficient
        hcoefficient eigenbasis waveSpeed heigen).extractInformation
        ((linearRectangleRiemannInterfaceFluxMethod coefficient
          hcoefficient eigenbasis waveSpeed heigen).solve
          ⟨old (j - 1), old j⟩ trivial)) = _
    exact leveque04_selectedLinearFlux_eq_vectorSplit coefficient
      hcoefficient eigenbasis waveSpeed heigen (old (j - 1)) (old j)
  constructor
  · exact hface
  · simp only [conservativeFluxDifferenceUpdateInt,
      hface]

/-- An explicit nonlinear conservation-law flux and consistent
two-state numerical face flux. -/
def leveque04_nonlinearPhysicalFlux (state : ℝ) : ℝ := state ^ 2

def leveque04_nonlinearFaceFlux (left right : ℝ) : ℝ := left * right

/-- The nonlinear face flux is a valid flux-difference split: the
two directional effects sum to the physical-flux jump. -/
theorem leveque04_nonlinearFaceFlux_isDifferenceSplit
    (left right : ℝ) :
    leveque04_nonlinearPhysicalFlux right -
        leveque04_nonlinearPhysicalFlux left =
      (leveque04_nonlinearFaceFlux left right -
          leveque04_nonlinearPhysicalFlux left) +
        (leveque04_nonlinearPhysicalFlux right -
          leveque04_nonlinearFaceFlux left right) ∧
      leveque04_nonlinearFaceFlux left right =
        leveque04_nonlinearPhysicalFlux left +
          (leveque04_nonlinearFaceFlux left right -
            leveque04_nonlinearPhysicalFlux left) := by
  constructor <;> ring

/-- No positive-left/negative-right statewise vector splitting can
represent the nonlinear two-state product face flux. -/
theorem leveque04_nonlinearFaceFlux_notVectorSplit :
    ¬ ∃ positive negative : ℝ → ℝ,
      ∀ left right : ℝ,
        leveque04_nonlinearFaceFlux left right =
          positive left + negative right := by
  rintro ⟨positive, negative, h⟩
  have h00 := h 0 0
  have h01 := h 0 1
  have h10 := h 1 0
  have h11 := h 1 1
  simp only [leveque04_nonlinearFaceFlux, zero_mul, mul_zero,
    one_mul] at h00 h01 h10 h11
  linarith

end NumStability
