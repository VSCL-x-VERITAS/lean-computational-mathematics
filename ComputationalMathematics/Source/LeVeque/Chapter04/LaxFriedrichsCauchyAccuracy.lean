/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsSystemPhysicalAccuracy
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearCharacteristicEvolution
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLinearEquiv
import Mathlib.Analysis.Calculus.ContDiff.RCLike
import Mathlib.Analysis.Calculus.ContDiff.Deriv
import Mathlib.Analysis.Calculus.Deriv.Support

/-!
# Lax–Friedrichs accuracy for the actual linear Cauchy evolution

The reference is the characteristic evolution of the supplied initial data.
Its grid values are physical vector cell integrals. The numerical operator is
the conservative update with the Lax–Friedrichs numerical flux, rather than an
assumed scalar-mode recurrence. The fixed basis determines the error constant.
-/

namespace NumStability

open MeasureTheory
open scoped BigOperators

/-- The actual conservative Lax–Friedrichs update at `dt = ratio * width`. -/
noncomputable def leveque04_linearLaxFriedrichsConservativeStep {m : ℕ}
    (coefficient : Matrix (Fin m) (Fin m) ℝ) (ratio width : ℝ)
    (old : ℤ → Fin m → ℝ) : ℤ → Fin m → ℝ :=
  leveque04_finiteVolumeUpdate (ratio * width) width old
    (leveque04_localInterfaceFlux
      (leveque04_laxFriedrichsFlux (ratio * width) width coefficient.mulVec) old)

theorem leveque04_linearLaxFriedrichsConservativeStep_eq
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ) (ratio width : ℝ)
    (hratio : 0 < ratio) (hwidth : 0 < width) :
    leveque04_linearLaxFriedrichsConservativeStep coefficient ratio width =
      leveque04_linearLaxFriedrichsStep coefficient ratio := by
  funext old i k
  simpa [leveque04_linearLaxFriedrichsConservativeStep,
    mul_div_cancel_right₀ ratio hwidth.ne'] using
    leveque04_linearLaxFriedrichsStep_eq_equation20 coefficient
      (ratio * width) width (mul_pos hratio hwidth) hwidth old i k

/-- Physical cell means of the actual characteristic Cauchy field. -/
noncomputable def leveque04_linearCauchyCellMeans {m : ℕ}
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ) (initial : ℝ → Fin m → ℝ)
    (width time : ℝ) (i : ℤ) : Fin m → ℝ :=
  oneDimensionalCellAverage
    (fun x => linearCharacteristicEvolution basis speeds initial x time)
    ((i : ℝ) * width - width / 2) ((i : ℝ) * width + width / 2)

theorem leveque04_characteristicEvolution_modalData
    {m : ℕ} (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ) (profile : Fin m → ℝ → ℝ) (x time : ℝ) :
    linearCharacteristicEvolution basis speeds
        (fun y => basis.equivFun.symm (fun p => profile p y)) x time =
      basis.equivFun.symm (fun p => profile p (x - speeds p * time)) := by
  simpa only [linearCharacteristicEvolution, LinearEquiv.apply_symm_apply] using
    basis.sum_equivFun (basis.equivFun.symm
      (fun p => profile p (x - speeds p * time)))

theorem leveque04_linearCauchyCellMeans_modalData
    {m : ℕ} (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ) (profile : Fin m → ℝ → ℝ)
    (hprofile : ∀ p, Continuous (profile p)) (width time : ℝ) (i : ℤ) :
    leveque04_linearCauchyCellMeans basis speeds
        (fun y => basis.equivFun.symm (fun p => profile p y)) width time i =
      basis.equivFun.symm (fun p => oneDimensionalCellAverage
        (fun x => profile p (x - speeds p * time))
        ((i : ℝ) * width - width / 2) ((i : ℝ) * width + width / 2)) := by
  have hc : Continuous (fun x => fun p => profile p (x - speeds p * time)) :=
    continuous_pi fun p => (hprofile p).comp (continuous_id.sub continuous_const)
  simp only [leveque04_linearCauchyCellMeans,
    leveque04_characteristicEvolution_modalData]
  rw [oneDimensionalCellAverage_linearEquiv basis.equivFun.symm _ _ _
    (hc.intervalIntegrable _ _)]
  congr 1
  funext p
  exact oneDimensionalCellAverage_apply _ _ _ (hc.intervalIntegrable _ _) p

/-- Uniform physical-component error for fixed actual Cauchy data. The
derivative Lipschitz bound is a quantitative smoothness hypothesis, not a
supplied numerical residual or an assumed evolution equation. -/
theorem leveque04_linearLaxFriedrichs_actualCauchy_globalError
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (basis p) = speeds p • basis p)
    (profile : Fin m → ℝ → ℝ) (ratio width K horizon : ℝ)
    (hratio : 0 < ratio) (hwidth : 0 < width) (hK : 0 ≤ K)
    (hcfl : ∀ p, |speeds p * ratio| ≤ 1)
    (hprofile : ∀ p, Differentiable ℝ (profile p))
    (hLip : ∀ p x y, |deriv (profile p) x - deriv (profile p) y| ≤ K * |x - y|)
    (n : ℕ) (i : ℤ) (k : Fin m)
    (hhorizon : (n : ℝ) * ratio * width ≤ horizon) :
    let initial := fun y => basis.equivFun.symm (fun p => profile p y)
    |(((leveque04_linearLaxFriedrichsConservativeStep coefficient ratio width)^[n]
        (leveque04_linearCauchyCellMeans basis speeds initial width 0)) i -
        leveque04_linearCauchyCellMeans basis speeds initial width
          ((n : ℝ) * ratio * width) i) k| ≤
      (∑ p, |basis p k|) * ((2 * K * horizon / ratio) * width) := by
  dsimp only
  rw [leveque04_linearLaxFriedrichsConservativeStep_eq coefficient ratio width
    hratio hwidth]
  let translated := fun p (j : ℕ) x =>
    profile p (x - speeds p * ((j : ℝ) * ratio * width))
  let translated' := fun p (j : ℕ) x =>
    deriv (profile p) (x - speeds p * ((j : ℝ) * ratio * width))
  have hd : ∀ p j x, HasDerivAt (translated p j) (translated' p j x) x := by
    intro p j x
    simpa only [translated, translated', mul_one] using
      ((hprofile p _).hasDerivAt.comp x
        ((hasDerivAt_id x).sub_const (speeds p * ((j : ℝ) * ratio * width))))
  have hl : ∀ p j x y,
      |translated' p j x - translated' p j y| ≤ K * |x - y| := by
    intro p j x y
    simpa only [translated', sub_sub_sub_cancel_right] using
      hLip p (x - speeds p * ((j : ℝ) * ratio * width))
        (y - speeds p * ((j : ℝ) * ratio * width))
  have he : ∀ p j x, translated p (j + 1) x =
      translated p j (x - speeds p * ratio * width) := by
    intro p j x
    dsimp only [translated]
    congr 1
    push_cast
    ring
  have hm (j : ℕ) (l : ℤ) :
      leveque04_linearCauchyCellMeans basis speeds
          (fun y => basis.equivFun.symm (fun p => profile p y)) width
          ((j : ℝ) * ratio * width) l =
        basis.equivFun.symm (fun p => oneDimensionalCellAverage (translated p j)
          ((l : ℝ) * width - width / 2) ((l : ℝ) * width + width / 2)) :=
    leveque04_linearCauchyCellMeans_modalData basis speeds profile
      (fun p => (hprofile p).continuous) width _ l
  have hz :
      leveque04_linearCauchyCellMeans basis speeds
          (fun y => basis.equivFun.symm (fun p => profile p y)) width 0 =
        fun l : ℤ => basis.equivFun.symm (fun p =>
          oneDimensionalCellAverage (translated p 0)
            ((l : ℝ) * width - width / 2) ((l : ℝ) * width + width / 2)) := by
    funext l
    simpa only [Nat.cast_zero, zero_mul] using hm 0 l
  rw [hz, hm n i]
  exact
    leveque04_linearLaxFriedrichs_smoothPhysicalComponent_globalError
      coefficient basis speeds heigen translated translated' ratio width K horizon n i k
      hratio hwidth hK hcfl hd hl he hhorizon

/-- Compactly supported `C²` modal data supply a mesh-independent Lipschitz
bound on their derivatives. No global derivative bound is an extra premise. -/
theorem leveque04_compactC2_modalDerivative_bound
    {m : ℕ} (profile : Fin m → ℝ → ℝ)
    (hsmooth : ∀ p, ContDiff ℝ 2 (profile p))
    (hcompact : ∀ p, HasCompactSupport (profile p)) :
    ∃ K : ℝ, 0 ≤ K ∧ ∀ p x y,
      |deriv (profile p) x - deriv (profile p) y| ≤ K * |x - y| := by
  classical
  have hbound (p : Fin m) : ∃ C : NNReal, LipschitzWith C (deriv (profile p)) :=
    ContDiff.lipschitzWith_of_hasCompactSupport (hcompact p).deriv
      ((hsmooth p).deriv' : ContDiff ℝ 1 (deriv (profile p))) (by decide)
  choose C hC using hbound
  refine ⟨∑ p, (C p : ℝ), Finset.sum_nonneg (fun p _ => (C p).coe_nonneg), ?_⟩
  intro p x y
  have hp : (C p : ℝ) ≤ ∑ q, (C q : ℝ) :=
    Finset.single_le_sum (fun q _ => (C q).coe_nonneg) (Finset.mem_univ p)
  have hd : |deriv (profile p) x - deriv (profile p) y| ≤ (C p : ℝ) * |x - y| := by
    simpa only [Real.dist_eq] using (hC p).dist_le_mul x y
  exact hd.trans
    (mul_le_mul_of_nonneg_right hp (abs_nonneg _))

/-- The actual physical Pi-norm error is uniformly first order at every
integer-grid cell and every step up to a fixed physical horizon. Compact `C²`
initial modal data and the fixed eigenbasis determine the constant before any
mesh width or step count is selected. -/
theorem leveque04_linearLaxFriedrichs_compactC2Cauchy_firstOrder
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (basis p) = speeds p • basis p)
    (profile : Fin m → ℝ → ℝ) (ratio horizon : ℝ)
    (hratio : 0 < ratio) (hhorizon : 0 ≤ horizon)
    (hcfl : ∀ p, |speeds p * ratio| ≤ 1)
    (hsmooth : ∀ p, ContDiff ℝ 2 (profile p))
    (hcompact : ∀ p, HasCompactSupport (profile p)) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ width : ℝ, 0 < width →
      ∀ n : ℕ, (n : ℝ) * ratio * width ≤ horizon → ∀ i : ℤ,
      let initial := fun y => basis.equivFun.symm (fun p => profile p y)
      ‖((leveque04_linearLaxFriedrichsConservativeStep coefficient ratio width)^[n]
          (leveque04_linearCauchyCellMeans basis speeds initial width 0)) i -
          leveque04_linearCauchyCellMeans basis speeds initial width
            ((n : ℝ) * ratio * width) i‖ ≤ C * width := by
  classical
  obtain ⟨K, hK, hLip⟩ :=
    leveque04_compactC2_modalDerivative_bound profile hsmooth hcompact
  let B : ℝ := ∑ k : Fin m, ∑ p : Fin m, |basis p k|
  have hB : 0 ≤ B := Finset.sum_nonneg fun _ _ =>
    Finset.sum_nonneg fun _ _ => abs_nonneg _
  have hfactor : 0 ≤ 2 * K * horizon / ratio := by positivity
  refine ⟨B * (2 * K * horizon / ratio), mul_nonneg hB hfactor, ?_⟩
  intro width hwidth n hn i
  dsimp only
  apply (pi_norm_le_iff_of_nonneg
    (mul_nonneg (mul_nonneg hB hfactor) hwidth.le)).mpr
  intro k
  rw [Real.norm_eq_abs]
  have hrow : (∑ p : Fin m, |basis p k|) ≤ B :=
    Finset.single_le_sum (f := fun q : Fin m => ∑ p : Fin m, |basis p q|)
      (fun q _ => Finset.sum_nonneg fun _ _ => abs_nonneg _)
      (Finset.mem_univ k)
  calc
    _ ≤ (∑ p, |basis p k|) * ((2 * K * horizon / ratio) * width) :=
      leveque04_linearLaxFriedrichs_actualCauchy_globalError coefficient basis speeds
        heigen profile ratio width K horizon hratio hwidth hK hcfl
        (fun p => (hsmooth p).differentiable (by decide)) hLip n i k hn
    _ ≤ B * ((2 * K * horizon / ratio) * width) :=
      mul_le_mul_of_nonneg_right hrow (mul_nonneg hfactor hwidth.le)
    _ = B * (2 * K * horizon / ratio) * width := by ring

end NumStability
