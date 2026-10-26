/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.REAAcousticRiemannFields
import ComputationalMathematics.Source.LeVeque.Chapter04.REALinearCauchyRegions

/-!
# Identifying acoustic REA with characteristic evolution

The selected local Riemann field and the independent characteristic Cauchy
field coincide off the acoustic fronts. Front representatives are immaterial
to the resulting almost-everywhere identity, including first contact.
-/

namespace NumStability

open MeasureTheory

/-- Inside an acoustic fan, the characteristic samples lie in precisely
the two adjacent reconstructed cells. -/
theorem leveque04_acousticCharacteristic_eq_localFan
    (density soundSpeed : ℝ)
    (himpedance : acousticImpedance density soundSpeed ≠ 0)
    (states : ℤ → Fin 2 → ℝ) (origin width time : ℝ)
    (hwidth : 0 < width) (hsound : 0 ≤ soundSpeed) (htime : 0 ≤ time)
    (hcfl : 2 * soundSpeed * time ≤ width)
    (j : ℤ) (x : ℝ)
    (hx : x ∈ Set.Ioo (origin + (j : ℝ) * width - soundSpeed * time)
      (origin + (j : ℝ) * width + soundSpeed * time)) :
    linearCharacteristicEvolution
      (leveque04_acousticEigenbasis density soundSpeed himpedance)
      (leveque04_acousticSpeeds 0 soundSpeed)
      (leveque04_uniformReconstruction origin width states) x time =
    leveque04_acousticREAField density soundSpeed himpedance
      states origin width j x time := by
  have hspeeds : ∀ p : Fin 2, -soundSpeed ≤ leveque04_acousticSpeeds 0 soundSpeed p ∧
      leveque04_acousticSpeeds 0 soundSpeed p ≤ soundSpeed := by
    intro p
    fin_cases p <;> simp [leveque04_acousticSpeeds, hsound]
  simpa only [leveque04_acousticREAField, neg_mul, ← sub_eq_add_neg] using
    leveque04_linearCharacteristic_eq_localFan
      (leveque04_acousticEigenbasis density soundSpeed himpedance)
      (leveque04_acousticSpeeds 0 soundSpeed) states origin width (-soundSpeed) soundSpeed time
      hwidth htime hspeeds (by nlinarith) j x
      (by simpa only [neg_mul, ← sub_eq_add_neg] using hx)

/-- In the open gap between neighboring acoustic fans, both characteristic
samples retain the same reconstructed state. -/
theorem leveque04_acousticCharacteristic_eq_gapState
    (density soundSpeed : ℝ)
    (himpedance : acousticImpedance density soundSpeed ≠ 0)
    (states : ℤ → Fin 2 → ℝ) (origin width time : ℝ)
    (hwidth : 0 < width) (hsound : 0 ≤ soundSpeed) (htime : 0 ≤ time)
    (j : ℤ) (x : ℝ)
    (hx : x ∈ Set.Ioo (origin + ((j - 1 : ℤ) : ℝ) * width + soundSpeed * time)
      (origin + (j : ℝ) * width - soundSpeed * time)) :
    linearCharacteristicEvolution
      (leveque04_acousticEigenbasis density soundSpeed himpedance)
      (leveque04_acousticSpeeds 0 soundSpeed)
      (leveque04_uniformReconstruction origin width states) x time = states j := by
  have hspeeds : ∀ p : Fin 2, -soundSpeed ≤ leveque04_acousticSpeeds 0 soundSpeed p ∧
      leveque04_acousticSpeeds 0 soundSpeed p ≤ soundSpeed := by
    intro p
    fin_cases p <;> simp [leveque04_acousticSpeeds, hsound]
  exact leveque04_linearCharacteristic_eq_gapState
    (leveque04_acousticEigenbasis density soundSpeed himpedance)
    (leveque04_acousticSpeeds 0 soundSpeed) states origin width (-soundSpeed) soundSpeed time
    hwidth htime hspeeds j x (by simpa only [neg_mul, ← sub_eq_add_neg] using hx)

/-- The assembled acoustic field is the independent characteristic Cauchy
field at every point off the two families of acoustic fronts, throughout
the closed half-cell step. -/
theorem leveque04_acousticREA_eq_characteristicCauchy_offFronts
    (density soundSpeed : ℝ)
    (himpedance : acousticImpedance density soundSpeed ≠ 0)
    (states : ℤ → Fin 2 → ℝ) (origin width step : ℝ)
    (hwidth : 0 < width) (hsound : 0 ≤ soundSpeed) (hstep : 0 ≤ step)
    (hcfl : soundSpeed * step / width ≤ 1 / 2)
    (x time : ℝ) (htime : time ∈ Set.Icc 0 step)
    (hoff : ∀ j : ℤ,
      x ≠ origin + (j : ℝ) * width - soundSpeed * time ∧
      x ≠ origin + (j : ℝ) * width + soundSpeed * time) :
    leveque04_acousticREAClosedEvolution density soundSpeed himpedance
      states origin width step hwidth hsound hstep hcfl x time =
    linearCharacteristicEvolution
      (leveque04_acousticEigenbasis density soundSpeed himpedance)
      (leveque04_acousticSpeeds 0 soundSpeed)
      (leveque04_uniformReconstruction origin width states) x time := by
  let fields := leveque04_acousticREAField density soundSpeed himpedance
    states origin width
  have hspeeds : ∀ j : ℤ, -soundSpeed ≤ (fun _ : ℤ => -soundSpeed) j ∧
      (fun _ : ℤ => -soundSpeed) j ≤ (fun _ : ℤ => soundSpeed) j ∧
      (fun _ : ℤ => soundSpeed) j ≤ soundSpeed := by
    intro j
    exact ⟨le_refl _, neg_le_self hsound, le_refl _⟩
  have hinteraction : ∀ j : ℤ,
      origin + (j : ℝ) * width + soundSpeed * step ≤
        origin + ((j + 1 : ℤ) : ℝ) * width + (-soundSpeed) * step := by
    intro j
    have h := (div_le_iff₀ hwidth).mp hcfl
    push_cast
    nlinarith
  have hleft : ∀ (j : ℤ) (y τ : ℝ), τ ∈ Set.Icc 0 step →
      y < origin + (j : ℝ) * width + (-soundSpeed) * τ →
        fields j y τ = states j := by
    intro j y τ ht hy
    exact leveque04_acousticREAField_left density soundSpeed himpedance
      states origin width hsound j y τ ht.1 hy
  have hright : ∀ (j : ℤ) (y τ : ℝ), τ ∈ Set.Icc 0 step →
      origin + (j : ℝ) * width + soundSpeed * τ < y →
        fields j y τ = states (j + 1) := by
    intro j y τ ht hy
    exact leveque04_acousticREAField_right density soundSpeed himpedance
      states origin width hsound j y τ ht.1 hy
  have htravel : 2 * soundSpeed * time ≤ width := by
    have h := (div_le_iff₀ hwidth).mp hcfl
    nlinarith [mul_le_mul_of_nonneg_left htime.2 hsound]
  let k : ℤ := ⌈(x - origin + soundSpeed * time) / width⌉
  have hindex := Int.ceil_eq_iff.mp (show
    ⌈(x - origin + soundSpeed * time) / width⌉ = k from rfl)
  have hlo : origin + ((k - 1 : ℤ) : ℝ) * width - soundSpeed * time < x := by
    have h := (lt_div_iff₀ hwidth).mp hindex.1
    push_cast
    linarith
  have hhi : x < origin + (k : ℝ) * width - soundSpeed * time := by
    have h := (div_le_iff₀ hwidth).mp hindex.2
    exact lt_of_le_of_ne (by linarith) (hoff k).1
  by_cases hfan : x < origin + ((k - 1 : ℤ) : ℝ) * width + soundSpeed * time
  · have hselection := leveque04_reaBoundedEvolution_eq_profile states fields
      (fun _ => -soundSpeed) (fun _ => soundSpeed)
      origin width soundSpeed step hwidth hsound hstep hspeeds hinteraction
      hleft hright (k - 1) x time htime
      ⟨by simpa only [neg_mul, ← sub_eq_add_neg] using hlo, hfan⟩
    have hcharacteristic := leveque04_acousticCharacteristic_eq_localFan
      density soundSpeed himpedance states origin width time
      hwidth hsound htime.1 htravel (k - 1) x ⟨hlo, hfan⟩
    rw [hcharacteristic]
    simpa only [leveque04_acousticREAClosedEvolution,
      leveque04_acousticClosedEvolution, fields] using hselection
  · have hgap : origin + ((k - 1 : ℤ) : ℝ) * width + soundSpeed * time < x :=
      lt_of_le_of_ne (le_of_not_gt hfan) (hoff (k - 1)).2.symm
    have hselection := leveque04_reaBoundedEvolution_eq_state states fields
      (fun _ => -soundSpeed) (fun _ => soundSpeed)
      origin width soundSpeed step hwidth hsound hstep hspeeds hinteraction
      hleft hright k x time htime
      ⟨hgap, by simpa only [neg_mul, ← sub_eq_add_neg] using hhi⟩
    have hcharacteristic := leveque04_acousticCharacteristic_eq_gapState
      density soundSpeed himpedance states origin width time
      hwidth hsound htime.1 k x ⟨hgap, hhi⟩
    rw [hcharacteristic]
    simpa only [leveque04_acousticREAClosedEvolution,
      leveque04_acousticClosedEvolution, fields] using hselection

/-- The assembled acoustic REA evolution equals the independent exact
characteristic evolution almost everywhere in space at every time in the
closed half-cell step, including time zero and first front contact. -/
theorem leveque04_acousticREA_eq_characteristicCauchy_ae
    (density soundSpeed : ℝ)
    (himpedance : acousticImpedance density soundSpeed ≠ 0)
    (states : ℤ → Fin 2 → ℝ) (origin width step : ℝ)
    (hwidth : 0 < width) (hsound : 0 ≤ soundSpeed) (hstep : 0 ≤ step)
    (hcfl : soundSpeed * step / width ≤ 1 / 2)
    (time : ℝ) (htime : time ∈ Set.Icc 0 step) :
    (fun x => leveque04_acousticREAClosedEvolution density soundSpeed himpedance
      states origin width step hwidth hsound hstep hcfl x time) =ᵐ[volume]
    (fun x => linearCharacteristicEvolution
      (leveque04_acousticEigenbasis density soundSpeed himpedance)
      (leveque04_acousticSpeeds 0 soundSpeed)
      (leveque04_uniformReconstruction origin width states) x time) := by
  have hfronts : ∀ᵐ x ∂volume, ∀ j : ℤ,
      x ≠ origin + (j : ℝ) * width - soundSpeed * time ∧
      x ≠ origin + (j : ℝ) * width + soundSpeed * time := by
    apply ae_all_iff.mpr
    intro j
    exact (Measure.ae_ne volume _).and (Measure.ae_ne volume _)
  filter_upwards [hfronts] with x hx
  exact leveque04_acousticREA_eq_characteristicCauchy_offFronts
    density soundSpeed himpedance states origin width step
    hwidth hsound hstep hcfl x time htime hx

end NumStability
