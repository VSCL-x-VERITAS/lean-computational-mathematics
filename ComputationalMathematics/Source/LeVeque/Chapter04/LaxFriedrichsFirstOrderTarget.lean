/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsFormalOrder
import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsCauchyAccuracy

/-!
# Lax–Friedrichs first-order accuracy

Proof-free specification for the original Chapter4 formal first-order claim.
The general smooth-reference estimate is distinct from the explicit scalar
leading term and sharp local example. The actual linear Cauchy global bound is
an explicit derived consequence under complete-eigenbasis CFL and fixed smooth
compact data; no unconditional nonlinear or discontinuous-data rate is asserted.
-/

open MeasureTheory Filter
open scoped Topology
open Set NumStability.LocalConservationLaw
namespace NumStability

/-- Formal first-order accuracy, with actual local and linear global references. -/
def leveque04_laxFriedrichs_firstOrder_target : Prop :=
  (∀ {m : ℕ} [NeZero m] (q : ℝ → ℝ → Fin m → ℝ) (flux : (Fin m → ℝ) → Fin m → ℝ)
    (states : Set (Fin m → ℝ)) (L R H a b d left right finish ratio : ℝ)
    (_hhyperbolic : IsHyperbolicFluxOn flux states)
    (_hreference : RectangleReferenceOn q flux L R H)
    (_hq : ContDiffOn ℝ 2 (Function.uncurry q) (Icc L R ×ˢ Icc 0 H))
    (_hstates : ∀ x ∈ Icc L R, ∀ τ ∈ Icc 0 H, q x τ ∈ states)
    (_hflux : ContDiffOn ℝ 2
      (Function.uncurry (fun x τ => flux (q x τ))) (Icc L R ×ˢ Icc 0 H))
    (_hLa : L < a) (_hal : a < left) (_hlr : left ≤ right) (_hrb : right < b)
    (_hbR : b < R) (_h0f : 0 < finish)
    (_hfd : finish < d) (_hdH : d < H) (_hratio : 0 < ratio),
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
  (∀ (g : ℝ → ℝ) (speed ratio center : ℝ) (_hratio : 0 < ratio)
    (_hsmooth : ContDiffAt ℝ 3 g center),
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
  (∀ (speed ratio width : ℝ) (i : ℤ)
    (_hratio : 0 < ratio) (_hwidth : 0 < width)
    (_hcfl : |speed * ratio| < 1),
    (leveque04_scalarLaxFriedrichsStep (speed * ratio)
        (leveque04_quadraticCellAverage width) i -
      oneDimensionalCellAverage
        (fun x : ℝ => (x - speed * ratio * width) ^ 2)
        ((i : ℝ) * width - width / 2)
        ((i : ℝ) * width + width / 2)) / (ratio * width) =
      ((1 - (speed * ratio) ^ 2) / ratio) * width ) ∧
  (∀ {m : ℕ} [NeZero m] (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ)) (speeds : Fin m → ℝ)
    (_heigen : ∀ p, coefficient.mulVec (basis p) = speeds p • basis p)
    (profile : Fin m → ℝ → ℝ) (ratio horizon : ℝ)
    (_hratio : 0 < ratio) (_hhorizon : 0 ≤ horizon)
    (_hcfl : ∀ p, |speeds p * ratio| ≤ 1)
    (_hsmooth : ∀ p, ContDiff ℝ 2 (profile p))
    (_hcompact : ∀ p, HasCompactSupport (profile p)),
    let initial := fun x => basis.equivFun.symm (fun p => profile p x)
    let reference := linearCharacteristicEvolution basis speeds initial
    (∀ x, reference x 0 = initial x) ∧
    IsRectangleConservationLawSolution reference coefficient.mulVec ∧
    ∃ C : ℝ, 0 ≤ C ∧ ∀ width : ℝ, 0 < width →
      ∀ n : ℕ, (n : ℝ) * ratio * width ≤ horizon → ∀ i : ℤ,
      ‖((leveque04_linearLaxFriedrichsConservativeStep coefficient ratio width)^[n]
          (leveque04_linearCauchyCellMeans basis speeds initial width 0)) i -
          leveque04_linearCauchyCellMeans basis speeds initial width
            ((n : ℝ) * ratio * width) i‖ ≤ C * width)

end NumStability
