/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.PrintedSourceIntegralTarget

/-!
# Counterexample to the printed source-integral flux sign

The smooth field `q(x,t)=x+t` with identity flux and constant source `2`
satisfies (2.28). Its mass rate on `[0,1]` is `1`, whereas the printed
plus-sign expression is `1+2=3`.
-/

open MeasureTheory Set Filter
open scoped Topology

namespace NumStability.Leveque02Tracer

/-- The literal unnumbered integral display preceding (2.28) is false. -/
theorem printedSourceIntegralTarget_false : ¬ printedSourceIntegralTarget := by
  intro h
  let q : ℝ → ℝ → ℝ := fun x τ => x + τ
  let flux : ℝ → ℝ := id
  let sourceDensity : ℝ → ℝ → ℝ → ℝ := fun _ _ _ => 2
  let qt : ℝ → ℝ := fun _ => 1
  let fluxDerivative : ℝ → ℝ := fun _ => 1
  have hpoint : ∀ x ∈ Icc (0 : ℝ) 1,
      HasDerivAt (fun τ => q x τ) (qt x) 0 ∧
      HasDerivAt (fun ξ => flux (q ξ 0)) (fluxDerivative x) x ∧
      qt x + fluxDerivative x = sourceDensity (q x 0) x 0 := by
    intro x _hx
    constructor
    · simpa [q, qt, add_comm] using
        (hasDerivAt_id (0 : ℝ)).add_const x
    constructor
    · simpa [q, flux, fluxDerivative] using
        (hasDerivAt_id x).add_const (0 : ℝ)
    · norm_num [qt, fluxDerivative, sourceDensity]
  have hintegral : ∀ τ : ℝ,
      (∫ x in (0 : ℝ)..1, q x τ) = (1 / 2 : ℝ) + τ := by
    intro τ
    norm_num [q]
    exact one_mul τ
  have hrate : HasDerivAt (fun τ => ∫ x in (0 : ℝ)..1, q x τ) 1 0 := by
    rw [show (fun τ => ∫ x in (0 : ℝ)..1, q x τ) =
      (fun τ => (1 / 2 : ℝ) + τ) from funext hintegral]
    convert (hasDerivAt_const (0 : ℝ) (1 / 2 : ℝ)).add (hasDerivAt_id 0) using 1
    all_goals norm_num
  have hprinted := h q flux sourceDensity qt fluxDerivative 0 1 0 1
    (by norm_num) hpoint hrate
  have hbad := hprinted (by simpa [qt] using hrate)
  have hunique := hbad.unique hrate
  norm_num [fluxDerivative, sourceDensity, intervalIntegral.integral_const] at hunique
  exact (by norm_num : (1 : ℝ) + 1 * 2 ≠ 1) hunique

end NumStability.Leveque02Tracer
