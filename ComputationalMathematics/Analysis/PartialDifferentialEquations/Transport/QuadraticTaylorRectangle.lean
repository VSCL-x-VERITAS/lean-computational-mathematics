/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.QuadraticTaylorApproximation
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.PositiveRectangleEquivalence

/-!
# Exact rectangle defect of the quadratic advection Taylor path

The approximation differs from its transported reference by a spatially
constant error. That error cancels from the boundary-flux difference; its
change in time gives the entire rectangle defect. The identities hold for
all oriented endpoints. On forward rectangles the prescribed residual budget
is sharp, including collapsed rectangles and zero speed or curvature.
-/

noncomputable section
open MeasureTheory

namespace NumStability.AdvectionTaylor

theorem integral_residualBudget_subinterval (speed curvature s t : ℝ) :
    (∫ τ in s..t, residualBudget speed curvature τ) =
      |curvature| * speed ^ 2 * (t ^ 2 - s ^ 2) := by
  unfold residualBudget
  rw [intervalIntegral.integral_const_mul, integral_id]
  ring

theorem quadraticTaylorPath_rectangleDefect
    (speed curvature linear constant a b s t : ℝ) :
    LocalConservationLaw.rectangleDefect
      (quadraticTaylorPath speed curvature linear constant)
      (fun state : ℝ => speed * state) a b s t =
        -curvature * speed ^ 2 * (b - a) * (t ^ 2 - s ^ 2) := by
  let q := quadraticTaylorPath speed curvature linear constant
  let v := travelingWave (quadraticProfile curvature linear constant) speed
  have hmass (τ : ℝ) : (∫ x in a..b, q x τ) - (∫ x in a..b, v x τ) =
      (b - a) * (-curvature * speed ^ 2 * τ ^ 2) := by
    rw [← intervalIntegral.integral_sub
      (quadraticTaylorPath_intervalIntegrable speed curvature linear constant τ a b)
      (quadraticReference_intervalIntegrable speed curvature linear constant τ a b)]
    calc
      (∫ x in a..b, q x τ - v x τ) =
          ∫ _x in a..b, -curvature * speed ^ 2 * τ ^ 2 := by
        apply intervalIntegral.integral_congr
        intro x _hx
        exact quadraticTaylorPath_sub_reference speed curvature linear constant x τ
      _ = _ := by rw [intervalIntegral.integral_const]; rfl
  have hboundary : (fun τ => speed * q a τ - speed * q b τ) =
      fun τ => speed * v a τ - speed * v b τ := by
    funext τ
    have ha := quadraticTaylorPath_sub_reference speed curvature linear constant a τ
    have hb := quadraticTaylorPath_sub_reference speed curvature linear constant b τ
    change q a τ - v a τ = _ at ha
    change q b τ - v b τ = _ at hb
    linear_combination speed * ha - speed * hb
  have href := (quadraticReference_isRectangleConservationLawSolution
    speed curvature linear constant).2.2 a b s t
  change (∫ x in a..b, v x t) - (∫ x in a..b, v x s) = _ at href
  simp only [smul_eq_mul] at href
  change (∫ x in a..b, q x t) - (∫ x in a..b, q x s) -
    (∫ τ in s..t, speed * q a τ - speed * q b τ) = _
  rw [hboundary]
  calc
    _ = ((∫ x in a..b, q x t) - (∫ x in a..b, v x t)) -
        ((∫ x in a..b, q x s) - (∫ x in a..b, v x s)) := by linarith [href]
    _ = _ := by rw [hmass t, hmass s]; ring

theorem quadraticTaylorPath_rectangleDefect_norm
    (speed curvature linear constant a b s t : ℝ)
    (hab : a ≤ b) (hs : 0 ≤ s) (hst : s ≤ t) :
    ‖LocalConservationLaw.rectangleDefect
      (quadraticTaylorPath speed curvature linear constant)
      (fun state : ℝ => speed * state) a b s t‖ =
        (b - a) * ∫ τ in s..t, residualBudget speed curvature τ := by
  have hdiff : 0 ≤ t ^ 2 - s ^ 2 := by
    nlinarith [mul_nonneg (sub_nonneg.mpr hst) (add_nonneg (hs.trans hst) hs)]
  rw [quadraticTaylorPath_rectangleDefect, integral_residualBudget_subinterval]
  simp only [Real.norm_eq_abs, abs_mul, abs_neg,
    abs_of_nonneg (sq_nonneg speed), abs_of_nonneg (sub_nonneg.mpr hab),
    abs_of_nonneg hdiff]
  ring

private theorem integral_vector {m : ℕ} (f : ℝ → ℝ) (a b : ℝ) :
    (∫ x in a..b, fun _ : Fin m => f x) = fun _ => ∫ x in a..b, f x := by
  simpa only [Pi.smul_def, smul_eq_mul, mul_one] using
    (intervalIntegral.integral_smul_const (a := a) (b := b) (μ := volume)
      f (fun _ : Fin m => (1 : ℝ)))

theorem quadraticTaylorPath_vector_rectangleDefect (m : ℕ)
    (speed curvature linear constant a b s t : ℝ) :
    LocalConservationLaw.rectangleDefect
      (fun x τ (_ : Fin m) => quadraticTaylorPath speed curvature linear constant x τ)
      (fun state : Fin m → ℝ => speed • state) a b s t =
        fun _ => -curvature * speed ^ 2 * (b - a) * (t ^ 2 - s ^ 2) := by
  unfold LocalConservationLaw.rectangleDefect
  simp only [Pi.smul_def, smul_eq_mul, Pi.sub_def, integral_vector]
  funext component
  exact quadraticTaylorPath_rectangleDefect speed curvature linear constant a b s t

theorem quadraticTaylorPath_vector_rectangleDefect_norm (m : ℕ) [Nonempty (Fin m)]
    (speed curvature linear constant a b s t : ℝ)
    (hab : a ≤ b) (hs : 0 ≤ s) (hst : s ≤ t) :
    ‖LocalConservationLaw.rectangleDefect
      (fun x τ (_ : Fin m) => quadraticTaylorPath speed curvature linear constant x τ)
      (fun state : Fin m → ℝ => speed • state) a b s t‖ =
        (b - a) * ∫ τ in s..t, residualBudget speed curvature τ := by
  rw [quadraticTaylorPath_vector_rectangleDefect, pi_norm_const]
  have h := quadraticTaylorPath_rectangleDefect_norm
    speed curvature linear constant a b s t hab hs hst
  rwa [quadraticTaylorPath_rectangleDefect] at h

end NumStability.AdvectionTaylor
