/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.GodunovOrderWitness
import ComputationalMathematics.Source.LeVeque.Chapter04.UpwindWavePropagation

/-!
# Stability and accumulated error of the signed Godunov step

For constant-speed advection, the selected Godunov flux is the signed
upwind flux. Under the scalar CFL condition its step is a convex
combination of the current cell and one upwind neighbor.
-/

namespace NumStability

private theorem signedUpwind_formula
    (speed ratio width : ℝ) (old : ℤ → ℝ) (i : ℤ)
    (hwidth : width ≠ 0) :
    leveque04_signedUpwindStep (ratio * width) width speed old i =
      old i - ratio *
        (leveque04_positiveVelocity speed * (old i - old (i - 1)) +
          leveque04_negativeVelocity speed * (old (i + 1) - old i)) := by
  rw [leveque04_equation35]
  simp only [leveque04_leftWaveJump, leveque04_rightWaveJump]
  field_simp

/-- Under CFL, one signed upwind/Godunov step preserves a uniform
absolute-value bound. -/
theorem leveque04_signedUpwindStep_bound
    (speed ratio width bound : ℝ) (old : ℤ → ℝ) (i : ℤ)
    (hratio : 0 < ratio) (hwidth : 0 < width) (hcfl : |speed * ratio| ≤ 1)
    (hold : ∀ j, |old j| ≤ bound) :
    |leveque04_signedUpwindStep (ratio * width) width speed old i| ≤ bound := by
  rw [signedUpwind_formula speed ratio width old i (ne_of_gt hwidth)]
  have hcfl' : -1 ≤ speed * ratio ∧ speed * ratio ≤ 1 := abs_le.mp hcfl
  by_cases hs : 0 ≤ speed
  · have hc : 0 ≤ speed * ratio := mul_nonneg hs hratio.le
    have hc1 : speed * ratio ≤ 1 := hcfl'.2
    have hleft := hold (i - 1)
    have hhere := hold i
    simp only [leveque04_positiveVelocity, leveque04_negativeVelocity,
      max_eq_left hs, min_eq_right hs]
    have heq : old i - ratio * (speed * (old i - old (i - 1)) + 0 * (old (i + 1) - old i)) =
        (speed * ratio) * old (i - 1) + (1 - speed * ratio) * old i := by ring
    rw [heq]
    calc
      |speed * ratio * old (i - 1) + (1 - speed * ratio) * old i| ≤
          |speed * ratio * old (i - 1)| + |(1 - speed * ratio) * old i| := abs_add_le _ _
      _ ≤ bound := by
        rw [abs_mul (speed * ratio) (old (i - 1)),
          abs_mul (1 - speed * ratio) (old i), abs_of_nonneg hc,
          abs_of_nonneg (by linarith : 0 ≤ 1 - speed * ratio)]
        nlinarith [mul_le_mul_of_nonneg_left hleft hc,
          mul_le_mul_of_nonneg_left hhere (by linarith : 0 ≤ 1 - speed * ratio)]
  · have hsneg : speed < 0 := lt_of_not_ge hs
    have hc : speed * ratio ≤ 0 := mul_nonpos_of_nonpos_of_nonneg hsneg.le hratio.le
    have hc1 : -1 ≤ speed * ratio := hcfl'.1
    simp only [leveque04_positiveVelocity, leveque04_negativeVelocity,
      max_eq_right hsneg.le, min_eq_left hsneg.le]
    have heq : old i - ratio * (0 * (old i - old (i - 1)) + speed * (old (i + 1) - old i)) =
        (-speed * ratio) * old (i + 1) + (1 + speed * ratio) * old i := by ring
    rw [heq]
    calc
      |(-speed * ratio) * old (i + 1) + (1 + speed * ratio) * old i| ≤
          |(-speed * ratio) * old (i + 1)| + |(1 + speed * ratio) * old i| := abs_add_le _ _
      _ ≤ bound := by
        rw [abs_mul (-speed * ratio) (old (i + 1)),
          abs_mul (1 + speed * ratio) (old i),
          abs_of_nonneg (by linarith : 0 ≤ -speed * ratio),
          abs_of_nonneg (by linarith : 0 ≤ 1 + speed * ratio)]
        nlinarith [mul_le_mul_of_nonneg_left (hold (i + 1)) (by linarith : 0 ≤ -speed * ratio),
          mul_le_mul_of_nonneg_left (hold i) (by linarith : 0 ≤ 1 + speed * ratio)]

/-- Uniform one-step errors accumulate linearly under the signed
upwind/Godunov CFL condition. -/
theorem leveque04_signedUpwindStep_iterate_error
    (speed ratio width initialError localError : ℝ)
    (initial : ℤ → ℝ) (exactState : ℕ → ℤ → ℝ) (n : ℕ)
    (hratio : 0 < ratio) (hwidth : 0 < width)
    (hcfl : |speed * ratio| ≤ 1)
    (hinitial : ∀ i, |initial i - exactState 0 i| ≤ initialError)
    (hlocal : ∀ k i,
      |leveque04_signedUpwindStep (ratio * width) width speed
          (exactState k) i - exactState (k + 1) i| ≤ localError)
    (i : ℤ) :
    |((leveque04_signedUpwindStep (ratio * width) width speed)^[n]
        initial) i - exactState n i| ≤
      initialError + (n : ℝ) * localError := by
  induction n generalizing i with
  | zero => simpa using hinitial i
  | succ n ih =>
      let approx :=
        ((leveque04_signedUpwindStep (ratio * width) width speed)^[n] initial)
      let error := fun j => approx j - exactState n j
      have herror : ∀ j, |error j| ≤ initialError + (n : ℝ) * localError :=
        fun j => ih j
      have hstep := leveque04_signedUpwindStep_bound speed ratio width
        (initialError + (n : ℝ) * localError) error i hratio hwidth hcfl herror
      have hlinear :
          leveque04_signedUpwindStep (ratio * width) width speed approx i -
            leveque04_signedUpwindStep (ratio * width) width speed
              (exactState n) i =
          leveque04_signedUpwindStep (ratio * width) width speed error i := by
        rw [signedUpwind_formula speed ratio width approx i (ne_of_gt hwidth),
          signedUpwind_formula speed ratio width (exactState n) i (ne_of_gt hwidth),
          signedUpwind_formula speed ratio width error i (ne_of_gt hwidth)]
        dsimp [error]
        ring
      rw [Function.iterate_succ_apply']
      calc
        |leveque04_signedUpwindStep (ratio * width) width speed approx i -
            exactState (n + 1) i| =
          |(leveque04_signedUpwindStep (ratio * width) width speed approx i -
              leveque04_signedUpwindStep (ratio * width) width speed
                (exactState n) i) +
            (leveque04_signedUpwindStep (ratio * width) width speed
                (exactState n) i - exactState (n + 1) i)| := by congr 1; ring
        _ ≤ |leveque04_signedUpwindStep (ratio * width) width speed error i| +
              |leveque04_signedUpwindStep (ratio * width) width speed
                (exactState n) i - exactState (n + 1) i| := by
            rw [hlinear]
            exact abs_add_le _ _
        _ ≤ initialError + ((n + 1 : ℕ) : ℝ) * localError := by
          have hl := hlocal n i
          push_cast
          linarith

/-- For a smooth exact advection sequence, the signed linear Godunov
step has a first-order error at any fixed time horizon. -/
theorem leveque04_signedGodunov_smoothProfile_globalError
    (profile profile' : ℕ → ℝ → ℝ)
    (speed ratio width K horizon : ℝ) (n : ℕ) (i : ℤ)
    (hratio : 0 < ratio) (hwidth : 0 < width) (hK : 0 ≤ K)
    (hcfl : |speed * ratio| ≤ 1)
    (hprofile : ∀ k x, HasDerivAt (profile k) (profile' k x) x)
    (hLip : ∀ k x y, |profile' k x - profile' k y| ≤ K * |x - y|)
    (hevolution : ∀ k x,
      profile (k + 1) x = profile k (x - speed * ratio * width))
    (hhorizon : (n : ℝ) * ratio * width ≤ horizon) :
    let exactState := fun k (j : ℤ) =>
      oneDimensionalCellAverage (profile k)
        ((j : ℝ) * width - width / 2)
        ((j : ℝ) * width + width / 2)
    |((leveque04_signedUpwindStep (ratio * width) width speed)^[n]
        (exactState 0)) i - exactState n i| ≤
      (2 * K * horizon / ratio) * width := by
  let exactState := fun k (j : ℤ) =>
    oneDimensionalCellAverage (profile k)
      ((j : ℝ) * width - width / 2)
      ((j : ℝ) * width + width / 2)
  have htime : 0 < ratio * width := mul_pos hratio hwidth
  have hlocal : ∀ k j,
      |leveque04_signedUpwindStep (ratio * width) width speed
          (exactState k) j - exactState (k + 1) j| ≤ 2 * K * width ^ 2 := by
    intro k j
    have hresidual := leveque04_signedGodunov_smoothProfileResidual
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
    dsimp only at hresidual
    rw [← signedUpwind_formula speed ratio width (exactState k) j
      (ne_of_gt hwidth), hnext] at hresidual
    have hmul := mul_le_mul_of_nonneg_right hresidual htime.le
    rw [abs_div, abs_of_pos htime, div_mul_cancel₀ _ (ne_of_gt htime)] at hmul
    have hfactor :
        2 * K / ratio * width * (ratio * width) = 2 * K * width ^ 2 := by
      field_simp
    simpa only [hfactor] using hmul
  have hglobal := leveque04_signedUpwindStep_iterate_error
    speed ratio width 0 (2 * K * width ^ 2)
    (exactState 0) exactState n hratio hwidth hcfl
    (by intro j; simp) hlocal i
  dsimp only at hglobal ⊢
  have hnonneg : 0 ≤ 2 * K * width / ratio :=
    div_nonneg (mul_nonneg (mul_nonneg (by norm_num) hK) hwidth.le) hratio.le
  have hscaled := mul_le_mul_of_nonneg_right hhorizon hnonneg
  calc
    _ ≤ (n : ℝ) * (2 * K * width ^ 2) := by simpa using hglobal
    _ ≤ (2 * K * horizon / ratio) * width := by
      convert hscaled using 1 <;> field_simp

/-- Each characteristic coordinate of the linear Godunov wave step is
the existing signed scalar upwind step. -/
theorem leveque04_linearGodunov_characteristicUpwind
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ) (ratio width : ℝ)
    (old : ℤ → (Fin m → ℝ)) (i : ℤ) (p : Fin m)
    (hwidth : 0 < width) :
    eigenbasis.equivFun
        (leveque04_linearGodunovWaveStep eigenbasis waveSpeed ratio old i) p =
      leveque04_signedUpwindStep (ratio * width) width (waveSpeed p)
        (fun j => eigenbasis.equivFun (old j) p) i := by
  rw [leveque04_linearGodunovWaveStep_characteristic,
    signedUpwind_formula (waveSpeed p) ratio width
      (fun j => eigenbasis.equivFun (old j) p) i (ne_of_gt hwidth)]

/-- Iterating the linear-system Godunov wave step commutes with
selection of a characteristic coordinate. -/
theorem leveque04_linearGodunov_characteristicIterate
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ) (ratio width : ℝ)
    (initial : ℤ → (Fin m → ℝ)) (n : ℕ) (i : ℤ) (p : Fin m)
    (hwidth : 0 < width) :
    eigenbasis.equivFun
        (((leveque04_linearGodunovWaveStep eigenbasis waveSpeed ratio)^[n]
          initial) i) p =
      ((leveque04_signedUpwindStep (ratio * width) width
        (waveSpeed p))^[n]
        (fun j => eigenbasis.equivFun (initial j) p)) i := by
  induction n generalizing i with
  | zero => rfl
  | succ n ih =>
      rw [Function.iterate_succ_apply',
        leveque04_linearGodunov_characteristicUpwind
          eigenbasis waveSpeed ratio width _ i p hwidth]
      have hcoord :
          (fun j => eigenbasis.equivFun
            (((leveque04_linearGodunovWaveStep eigenbasis waveSpeed ratio)^[n]
              initial) j) p) =
          ((leveque04_signedUpwindStep (ratio * width) width
            (waveSpeed p))^[n]
            (fun j => eigenbasis.equivFun (initial j) p)) := by
        funext j
        exact ih j
      rw [hcoord, Function.iterate_succ_apply']

/-- The linear Godunov wave update has a first-order fixed-time error
in every characteristic coordinate on smooth exact cell averages. -/
theorem leveque04_linearGodunov_smoothCharacteristic_globalError
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ)
    (profile profile' : Fin m → ℕ → ℝ → ℝ)
    (ratio width K horizon : ℝ) (n : ℕ) (i : ℤ) (p : Fin m)
    (hratio : 0 < ratio) (hwidth : 0 < width) (hK : 0 ≤ K)
    (hcfl : ∀ p, |waveSpeed p * ratio| ≤ 1)
    (hprofile : ∀ p k x,
      HasDerivAt (profile p k) (profile' p k x) x)
    (hLip : ∀ p k x y,
      |profile' p k x - profile' p k y| ≤ K * |x - y|)
    (hevolution : ∀ p k x,
      profile p (k + 1) x =
        profile p k (x - waveSpeed p * ratio * width))
    (hhorizon : (n : ℝ) * ratio * width ≤ horizon) :
    let exactState := fun k (j : ℤ) =>
      eigenbasis.equivFun.symm (fun p =>
        oneDimensionalCellAverage (profile p k)
          ((j : ℝ) * width - width / 2)
          ((j : ℝ) * width + width / 2))
    |eigenbasis.equivFun
        (((leveque04_linearGodunovWaveStep eigenbasis waveSpeed ratio)^[n]
          (exactState 0)) i) p -
      eigenbasis.equivFun (exactState n i) p| ≤
      (2 * K * horizon / ratio) * width := by
  dsimp only
  rw [leveque04_linearGodunov_characteristicIterate
    eigenbasis waveSpeed ratio width _ n i p hwidth]
  simp only [LinearEquiv.apply_symm_apply]
  exact leveque04_signedGodunov_smoothProfile_globalError
    (profile p) (profile' p) (waveSpeed p) ratio width K horizon n i
    hratio hwidth hK (hcfl p) (hprofile p) (hLip p)
    (hevolution p) hhorizon

/-- The certified selected-Riemann-flux Godunov method inherits the
fixed-time characteristic error bound from its wave update. -/
theorem leveque04_selectedLinearGodunov_smoothCharacteristic_globalError
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (hcoefficient : IsRealHyperbolicMatrix coefficient)
    (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (eigenbasis p) =
      waveSpeed p • eigenbasis p)
    (profile profile' : Fin m → ℕ → ℝ → ℝ)
    (ratio width K horizon : ℝ) (n : ℕ) (i : ℤ) (p : Fin m)
    (hratio : 0 < ratio) (hwidth : 0 < width) (hK : 0 ≤ K)
    (hcfl : ∀ p, |waveSpeed p * ratio| ≤ 1)
    (hprofile : ∀ p k x,
      HasDerivAt (profile p k) (profile' p k x) x)
    (hLip : ∀ p k x y,
      |profile' p k x - profile' p k y| ≤ K * |x - y|)
    (hevolution : ∀ p k x,
      profile p (k + 1) x =
        profile p k (x - waveSpeed p * ratio * width))
    (hhorizon : (n : ℝ) * ratio * width ≤ horizon) :
    let method := linearRectangleRiemannInterfaceFluxMethod coefficient
      hcoefficient eigenbasis waveSpeed heigen
    let selected := fun old (j : ℤ) =>
      conservativeFluxDifferenceUpdateInt ratio old
        (rectangleRiemannInterfaceFlux method old (fun _ => True.intro)) j
    let exactState := fun k (j : ℤ) =>
      eigenbasis.equivFun.symm (fun p =>
        oneDimensionalCellAverage (profile p k)
          ((j : ℝ) * width - width / 2)
          ((j : ℝ) * width + width / 2))
    |eigenbasis.equivFun
        ((selected^[n] (exactState 0)) i) p -
      eigenbasis.equivFun (exactState n i) p| ≤
      (2 * K * horizon / ratio) * width := by
  dsimp only
  have hselected :
      (fun old (j : ℤ) =>
        conservativeFluxDifferenceUpdateInt ratio old
          (rectangleRiemannInterfaceFlux
            (linearRectangleRiemannInterfaceFluxMethod coefficient
              hcoefficient eigenbasis waveSpeed heigen) old
            (fun _ => True.intro)) j) =
        leveque04_linearGodunovWaveStep eigenbasis waveSpeed ratio := by
    funext old j
    exact leveque04_linearGodunovWaveStep_selected coefficient hcoefficient
      eigenbasis waveSpeed heigen old ratio j
  rw [hselected]
  exact leveque04_linearGodunov_smoothCharacteristic_globalError
    eigenbasis waveSpeed profile profile' ratio width K horizon n i p
    hratio hwidth hK hcfl hprofile hLip hevolution hhorizon

end NumStability
