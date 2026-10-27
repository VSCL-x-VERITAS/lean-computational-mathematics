/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsClosedC2Rectangle
import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsOrderWitness
import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsUnrestrictedLeadingResidual
import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsViscosity

/-!
# Formal order and viscosity of Lax–Friedrichs

The source-scoped result combines the local first-order estimate, the scalar
leading residual, and the scheme's artificial viscosity.
-/

open MeasureTheory Filter
open scoped Topology
open Set NumStability.LocalConservationLaw
namespace NumStability

/-- Formal local first order, the scalar leading residual, and artificial viscosity of Lax–Friedrichs. -/
theorem leveque04_laxFriedrichs_formalOrderAndViscosity :
  (∀ {m : ℕ} [NeZero m] (q : ℝ → ℝ → Fin m → ℝ) (flux : (Fin m → ℝ) → Fin m → ℝ)
    (states : Set (Fin m → ℝ)) (L R H a b d left right finish ratio : ℝ)
    (_hhyperbolic : IsHyperbolicFluxOn flux states)
    (hreference : RectangleReferenceOn q flux L R H)
    (hq : ContDiffOn ℝ 2 (Function.uncurry q) (Icc L R ×ˢ Icc 0 H))
    (_hstates : ∀ x ∈ Icc L R, ∀ τ ∈ Icc 0 H, q x τ ∈ states)
    (hflux : ContDiffOn ℝ 2
      (Function.uncurry (fun x τ => flux (q x τ))) (Icc L R ×ˢ Icc 0 H))
    (hLa : L < a) (hal : a < left) (_hlr : left ≤ right) (hrb : right < b)
    (hbR : b < R) (h0f : 0 < finish)
    (hfd : finish < d) (hdH : d < H) (hratio : 0 < ratio),
    ∃ threshold C : ℝ, 0 < threshold ∧ 0 ≤ C ∧
      ∀ center ∈ Icc left right, ∀ time ∈ Icc 0 finish,
        ∀ width : ℝ, 0 < width → width < threshold →
          center - width ∈ Ioo L R ∧ center + width ∈ Ioo L R ∧
          time + ratio * width ∈ Ioo 0 H ∧
          ∀ (old : ℤ → Fin m → ℝ) (i : ℤ),
            old (i - 1) = q (center - width) time →
            old i = q center time → old (i + 1) = q (center + width) time →
            ‖(ratio * width)⁻¹ •
                (leveque04_finiteVolumeUpdate (ratio * width) width old
                  (leveque04_localInterfaceFlux
                    (leveque04_laxFriedrichsFlux (ratio * width) width flux) old) i -
                  q center (time + ratio * width))‖ ≤ C * width ) ∧
  (∀ (g : ℝ → ℝ) (speed ratio center : ℝ) (hratio : 0 < ratio)
    (hsmooth : ContDiffAt ℝ 3 g center),
    ∃ threshold C : ℝ, 0 < threshold ∧ 0 ≤ C ∧
      ∀ width : ℝ, 0 < width → width < threshold →
      ∀ (old : ℤ → ℝ) (i : ℤ), old (i - 1) = g (center - width) →
        old (i + 1) = g (center + width) →
        |(leveque04_finiteVolumeUpdate (ratio * width) width
          (fun (j : ℤ) (_ : Fin 1) => old j)
          (leveque04_localInterfaceFlux
            (leveque04_laxFriedrichsFlux (ratio * width) width
              (fun (state : Fin 1 → ℝ) (_ : Fin 1) => speed * state 0))
            (fun (j : ℤ) (_ : Fin 1) => old j)) i 0 -
          g (center - speed * ratio * width)) / (ratio * width) -
          (1 - (speed * ratio) ^ 2) / (2 * ratio) * width * deriv (deriv g) center| ≤
          C * width ^ 2 ) ∧
  (∀ {m : ℕ} (timeStep cellWidth : ℝ)
    (htime : 0 < timeStep)
    (hwidth : 0 < cellWidth)
    (physicalFlux : (Fin m → ℝ) → (Fin m → ℝ))
    (left right : Fin m → ℝ),
    leveque04_laxFriedrichsFlux timeStep cellWidth
        physicalFlux left right =
      leveque04_centeredFlux physicalFlux left right -
        (leveque04_laxFriedrichsViscosity timeStep cellWidth /
          cellWidth) • (right - left) ) ∧
  (∀ (ratio cellWidth : ℝ)
    (hratio : 0 < ratio) (hwidth : 0 < cellWidth),
    leveque04_laxFriedrichsViscosity (ratio * cellWidth) cellWidth =
      cellWidth / (2 * ratio) ) ∧
  (∀ (ratio : ℝ) (hratio : 0 < ratio)
    (cellWidth : ℕ → ℝ)
    (hwidth : ∀ n, 0 < cellWidth n)
    (hrefine : Filter.Tendsto cellWidth Filter.atTop (nhds 0)),
    Filter.Tendsto
      (fun n => leveque04_laxFriedrichsViscosity
        (ratio * cellWidth n) (cellWidth n))
      Filter.atTop (nhds 0) ) ∧
  (∀ (speed ratio width : ℝ) (i : ℤ)
    (hratio : 0 < ratio) (hwidth : 0 < width)
    (hcfl : |speed * ratio| < 1),
    (leveque04_scalarLaxFriedrichsStep (speed * ratio)
        (leveque04_quadraticCellAverage width) i -
      oneDimensionalCellAverage
        (fun x : ℝ => (x - speed * ratio * width) ^ 2)
        ((i : ℝ) * width - width / 2)
        ((i : ℝ) * width + width / 2)) / (ratio * width) =
      ((1 - (speed * ratio) ^ 2) / ratio) * width )
 := by
  exact ⟨leveque04_laxFriedrichs_c2RectangleReference_closedTimeRegionalResidual,
    leveque04_laxFriedrichs_unrestrictedSmoothAdvectionLeadingResidual,
    (fun {m} timeStep cellWidth _htime hwidth physicalFlux left right =>
      @leveque04_laxFriedrichsFlux_eq_viscous m timeStep cellWidth hwidth
        physicalFlux left right),
    leveque04_laxFriedrichsViscosity_fixedRatio,
    leveque04_laxFriedrichsViscosity_tendsto_zero,
    (fun speed ratio width i hratio hwidth _hcfl =>
      leveque04_laxFriedrichs_quadraticAdvectionResidual speed ratio width i
        hratio hwidth)⟩

end NumStability
