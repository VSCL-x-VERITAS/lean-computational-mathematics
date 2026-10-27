/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.REALinearCauchyRegions
import ComputationalMathematics.Source.LeVeque.Chapter04.REABoundedSelection

/-!
# Exact bilateral linear Riemann assembly

Actual adjacent-state eigenbasis Riemann solutions assemble into the
independent characteristic Cauchy field throughout a closed noninteracting
step. The condition uses the spectral spread rather than a symmetric CFL.
-/

namespace NumStability

open MeasureTheory

/-- The selected shifted linear Riemann field retains its left state
strictly before every characteristic front. -/
theorem leveque04_linearRiemannField_left
    {m : ℕ} (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ) (states : ℤ → Fin m → ℝ)
    (origin width lower : ℝ) (hlower : ∀ p, lower ≤ speeds p)
    (j : ℤ) (x time : ℝ) (htime : 0 ≤ time)
    (hx : x < origin + (j : ℝ) * width + lower * time) :
    linearRiemannSolution basis speeds (states j) (states j) (states (j + 1))
      (x - (origin + (j : ℝ) * width)) time = states j := by
  rw [linearRiemannSolution_eq_characteristicEvolution]
  have harg (p : Fin m) : x - (origin + (j : ℝ) * width) - speeds p * time < 0 := by
    nlinarith [mul_le_mul_of_nonneg_right (hlower p) htime]
  simpa only [linearCharacteristicEvolution, riemannData, harg, if_pos] using
    basis.sum_repr (states j)

/-- The selected shifted linear Riemann field retains its right state
strictly after every characteristic front. -/
theorem leveque04_linearRiemannField_right
    {m : ℕ} (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ) (states : ℤ → Fin m → ℝ)
    (origin width upper : ℝ) (hupper : ∀ p, speeds p ≤ upper)
    (j : ℤ) (x time : ℝ) (htime : 0 ≤ time)
    (hx : origin + (j : ℝ) * width + upper * time < x) :
    linearRiemannSolution basis speeds (states j) (states j) (states (j + 1))
      (x - (origin + (j : ℝ) * width)) time = states (j + 1) := by
  rw [linearRiemannSolution_eq_characteristicEvolution]
  have harg (p : Fin m) : 0 < x - (origin + (j : ℝ) * width) - speeds p * time := by
    nlinarith [mul_le_mul_of_nonneg_right (hupper p) htime]
  have hnot (p : Fin m) : ¬ x - (origin + (j : ℝ) * width) - speeds p * time < 0 :=
    not_lt_of_gt (harg p)
  simpa only [linearCharacteristicEvolution, riemannData, hnot, harg, if_false, if_pos] using
    basis.sum_repr (states (j + 1))

/-- The closed-step assembly forwards the actual selected linear local
solutions to the existing canonical bilateral Riemann-chain producer. -/
noncomputable def leveque04_linearREAClosedEvolution
    {m : ℕ} (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ) (states : ℤ → Fin m → ℝ)
    (origin width lower upper step : ℝ)
    (hwidth : 0 < width) (hstep : 0 ≤ step) (horder : lower ≤ upper)
    (hspeeds : ∀ p, lower ≤ speeds p ∧ speeds p ≤ upper)
    (hinteraction : (upper - lower) * step ≤ width) : ℝ → ℝ → Fin m → ℝ :=
  leveque04_reaBoundedEvolution states
    (fun j x t => linearRiemannSolution basis speeds (states j) (states j) (states (j + 1))
      (x - (origin + (j : ℝ) * width)) t)
    (fun _ => lower) (fun _ => upper) origin width (|lower| + |upper|) step
    hwidth (add_nonneg (abs_nonneg _) (abs_nonneg _)) hstep
    (by
      intro j
      refine ⟨?_, horder, ?_⟩
      · nlinarith [neg_abs_le lower, abs_nonneg upper]
      · nlinarith [le_abs_self upper, abs_nonneg lower])
    (by intro j; push_cast; nlinarith)
    (fun j x t ht hx => leveque04_linearRiemannField_left
      basis speeds states origin width lower (fun p => (hspeeds p).1) j x t ht.1 hx)
    (fun j x t ht hx => leveque04_linearRiemannField_right
      basis speeds states origin width upper (fun p => (hspeeds p).2) j x t ht.1 hx)

/-- The selected linear assembly equals independent characteristic
evolution away from its extreme fronts. Intermediate wavefront values use
the same left-cell representative, so they require no extra exclusion. -/
theorem leveque04_linearREA_eq_characteristicCauchy_offFronts
    {m : ℕ} (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ) (states : ℤ → Fin m → ℝ)
    (origin width lower upper step : ℝ)
    (hwidth : 0 < width) (hstep : 0 ≤ step) (horder : lower ≤ upper)
    (hspeeds : ∀ p, lower ≤ speeds p ∧ speeds p ≤ upper)
    (hinteraction : (upper - lower) * step ≤ width)
    (x time : ℝ) (htime : time ∈ Set.Icc 0 step)
    (hoff : ∀ j : ℤ,
      x ≠ origin + (j : ℝ) * width + lower * time ∧
      x ≠ origin + (j : ℝ) * width + upper * time) :
    leveque04_linearREAClosedEvolution basis speeds states origin width lower upper step
      hwidth hstep horder hspeeds hinteraction x time =
    linearCharacteristicEvolution basis speeds
      (leveque04_uniformReconstruction origin width states) x time := by
  let fields := fun j x t => linearRiemannSolution basis speeds
    (states j) (states j) (states (j + 1)) (x - (origin + (j : ℝ) * width)) t
  have hbound : 0 ≤ |lower| + |upper| := add_nonneg (abs_nonneg _) (abs_nonneg _)
  have hfronts : ∀ j : ℤ, -(|lower| + |upper|) ≤ (fun _ : ℤ => lower) j ∧
      (fun _ : ℤ => lower) j ≤ (fun _ : ℤ => upper) j ∧
      (fun _ : ℤ => upper) j ≤ |lower| + |upper| := by
    intro j
    refine ⟨?_, horder, ?_⟩
    · nlinarith [neg_abs_le lower, abs_nonneg upper]
    · nlinarith [le_abs_self upper, abs_nonneg lower]
  have hseparate : ∀ j : ℤ,
      origin + (j : ℝ) * width + upper * step ≤
        origin + ((j + 1 : ℤ) : ℝ) * width + lower * step := by
    intro j
    push_cast
    nlinarith
  have hleft : ∀ (j : ℤ) (y τ : ℝ), τ ∈ Set.Icc 0 step →
      y < origin + (j : ℝ) * width + lower * τ → fields j y τ = states j := by
    intro j y τ ht hy
    exact leveque04_linearRiemannField_left basis speeds states origin width lower
      (fun p => (hspeeds p).1) j y τ ht.1 hy
  have hright : ∀ (j : ℤ) (y τ : ℝ), τ ∈ Set.Icc 0 step →
      origin + (j : ℝ) * width + upper * τ < y → fields j y τ = states (j + 1) := by
    intro j y τ ht hy
    exact leveque04_linearRiemannField_right basis speeds states origin width upper
      (fun p => (hspeeds p).2) j y τ ht.1 hy
  have htravel : (upper - lower) * time ≤ width :=
    (mul_le_mul_of_nonneg_left htime.2 (sub_nonneg.mpr horder)).trans hinteraction
  let k : ℤ := ⌈(x - origin - lower * time) / width⌉
  have hindex := Int.ceil_eq_iff.mp (show ⌈(x - origin - lower * time) / width⌉ = k from rfl)
  have hlo : origin + ((k - 1 : ℤ) : ℝ) * width + lower * time < x := by
    have h := (lt_div_iff₀ hwidth).mp hindex.1
    push_cast
    linarith
  have hhi : x < origin + (k : ℝ) * width + lower * time := by
    have h := (div_le_iff₀ hwidth).mp hindex.2
    exact lt_of_le_of_ne (by linarith) (hoff k).1
  by_cases hfan : x < origin + ((k - 1 : ℤ) : ℝ) * width + upper * time
  · have hselection := leveque04_reaBoundedEvolution_eq_profile states fields
      (fun _ => lower) (fun _ => upper) origin width (|lower| + |upper|) step
      hwidth hbound hstep hfronts hseparate hleft hright (k - 1) x time htime ⟨hlo, hfan⟩
    have hcharacteristic := leveque04_linearCharacteristic_eq_localFan
      basis speeds states origin width lower upper time hwidth htime.1 hspeeds htravel
      (k - 1) x ⟨hlo, hfan⟩
    rw [hcharacteristic]
    simpa only [leveque04_linearREAClosedEvolution, fields] using hselection
  · have hgap : origin + ((k - 1 : ℤ) : ℝ) * width + upper * time < x :=
      lt_of_le_of_ne (le_of_not_gt hfan) (hoff (k - 1)).2.symm
    have hselection := leveque04_reaBoundedEvolution_eq_state states fields
      (fun _ => lower) (fun _ => upper) origin width (|lower| + |upper|) step
      hwidth hbound hstep hfronts hseparate hleft hright k x time htime ⟨hgap, hhi⟩
    have hcharacteristic := leveque04_linearCharacteristic_eq_gapState
      basis speeds states origin width lower upper time hwidth htime.1 hspeeds
      k x ⟨hgap, hhi⟩
    rw [hcharacteristic]
    simpa only [leveque04_linearREAClosedEvolution, fields] using hselection

/-- The actual selected linear bilateral Riemann assembly equals the
independent Cauchy solution almost everywhere in space at every time
through the closed noninteracting step. -/
theorem leveque04_linearREA_eq_characteristicCauchy_ae
    {m : ℕ} (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ) (states : ℤ → Fin m → ℝ)
    (origin width lower upper step : ℝ)
    (hwidth : 0 < width) (hstep : 0 ≤ step) (horder : lower ≤ upper)
    (hspeeds : ∀ p, lower ≤ speeds p ∧ speeds p ≤ upper)
    (hinteraction : (upper - lower) * step ≤ width)
    (time : ℝ) (htime : time ∈ Set.Icc 0 step) :
    (fun x => leveque04_linearREAClosedEvolution basis speeds states
      origin width lower upper step hwidth hstep horder hspeeds hinteraction x time) =ᵐ[volume]
    (fun x => linearCharacteristicEvolution basis speeds
      (leveque04_uniformReconstruction origin width states) x time) := by
  have hfronts : ∀ᵐ x ∂volume, ∀ j : ℤ,
      x ≠ origin + (j : ℝ) * width + lower * time ∧
      x ≠ origin + (j : ℝ) * width + upper * time := by
    apply ae_all_iff.mpr
    intro j
    exact (Measure.ae_ne volume _).and (Measure.ae_ne volume _)
  filter_upwards [hfronts] with x hx
  exact leveque04_linearREA_eq_characteristicCauchy_offFronts
    basis speeds states origin width lower upper step
    hwidth hstep horder hspeeds hinteraction x time htime hx

/-- Spectral-spread noninteraction is exactly the ordering of the fronts
from every pair of adjacent uniform-grid Riemann problems. -/
theorem leveque04_linearREA_noninteraction_iff
    (origin width lower upper step : ℝ) :
    (upper - lower) * step ≤ width ↔
      ∀ j : ℤ, origin + (j : ℝ) * width + upper * step ≤
        origin + ((j + 1 : ℤ) : ℝ) * width + lower * step := by
  constructor
  · intro h j
    push_cast
    nlinarith
  · intro h
    have hzero := h 0
    norm_num at hzero
    nlinarith

/-- Cell averaging is insensitive to the extreme-front representatives,
so actual selected Riemann assembly has exactly the Cauchy average. -/
theorem leveque04_linearREA_cellAverage_eq_characteristicCauchy
    {m : ℕ} (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ) (states : ℤ → Fin m → ℝ)
    (origin width lower upper step : ℝ)
    (hwidth : 0 < width) (hstep : 0 ≤ step) (horder : lower ≤ upper)
    (hspeeds : ∀ p, lower ≤ speeds p ∧ speeds p ≤ upper)
    (hinteraction : (upper - lower) * step ≤ width)
    (time : ℝ) (htime : time ∈ Set.Icc 0 step) (cell : ℤ) :
    oneDimensionalCellAverage
      (fun x => leveque04_linearREAClosedEvolution basis speeds states
        origin width lower upper step hwidth hstep horder hspeeds hinteraction x time)
      (origin + (cell : ℝ) * width) (origin + ((cell + 1 : ℤ) : ℝ) * width) =
    oneDimensionalCellAverage
      (fun x => linearCharacteristicEvolution basis speeds
        (leveque04_uniformReconstruction origin width states) x time)
      (origin + (cell : ℝ) * width) (origin + ((cell + 1 : ℤ) : ℝ) * width) := by
  have hae := leveque04_linearREA_eq_characteristicCauchy_ae
    basis speeds states origin width lower upper step
    hwidth hstep horder hspeeds hinteraction time htime
  unfold oneDimensionalCellAverage
  congr 1
  apply intervalIntegral.integral_congr_ae
  filter_upwards [hae] with x hx
  exact fun _ => hx

/-- Actual local eigenbasis Riemann solutions assemble the exact linear
Cauchy evolution, with its prescribed initial field and governing matrix
conservation law. This applies to arbitrary bilateral cell data and permits
repeated characteristic speeds and endpoint contact. -/
theorem leveque04_linearREA_exactCauchy
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (basis p) = speeds p • basis p)
    (states : ℤ → Fin m → ℝ) (origin width lower upper step : ℝ)
    (hwidth : 0 < width) (hstep : 0 ≤ step) (horder : lower ≤ upper)
    (hspeeds : ∀ p, lower ≤ speeds p ∧ speeds p ≤ upper)
    (hinteraction : (upper - lower) * step ≤ width) :
    let initial := leveque04_uniformReconstruction origin width states
    let exact := linearCharacteristicEvolution basis speeds initial
    (∀ x, exact x 0 = initial x) ∧
      IsRectangleConservationLawSolution exact coefficient.mulVec ∧
      ∀ time ∈ Set.Icc 0 step,
        (fun x => leveque04_linearREAClosedEvolution basis speeds states
          origin width lower upper step hwidth hstep horder hspeeds hinteraction x time) =ᵐ[volume]
        (fun x => exact x time) := by
  dsimp only
  refine ⟨linearCharacteristicEvolution_initial basis speeds _, ?_, ?_⟩
  · apply linearCharacteristicEvolution_isRectangleSolution coefficient basis speeds heigen
    intro p a b
    exact leveque04_uniformReconstruction_intervalIntegrable
      origin width hwidth (fun j => basis.equivFun (states j) p) a b
  · intro time htime
    exact leveque04_linearREA_eq_characteristicCauchy_ae
      basis speeds states origin width lower upper step
      hwidth hstep horder hspeeds hinteraction time htime

end NumStability
