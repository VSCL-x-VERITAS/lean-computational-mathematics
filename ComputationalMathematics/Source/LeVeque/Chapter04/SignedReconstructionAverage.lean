import ComputationalMathematics.Source.LeVeque.Chapter04.REAUniformReconstruction
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.TranslatedReconstructionAverage
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLinearEquiv

/-!
# Signed translated averages of uniform reconstruction

The ceiling-indexed, piecewise constant reconstruction yields the signed upwind
recurrence after translation by at most one cell. The result includes zero
displacement and both neighboring-cell endpoints.
-/

namespace NumStability

section
open MeasureTheory

/-- The translated cell average of the actual ceiling-indexed uniform reconstruction
is the signed upwind recurrence when the displacement has magnitude at most one cell.
The shared bound includes zero displacement and both full-neighbor endpoints. -/
def Leveque04SignedReconstructionAverageBridgeTarget : Prop :=
  ∀ (origin width dt speed : ℝ) (old : ℤ → ℝ) (j : ℤ),
    0 < width →
    0 < dt →
    |speed * dt| ≤ width →
    NumStability.oneDimensionalCellAverage
        (fun x => NumStability.leveque04_uniformReconstruction
          origin width old (x - speed * dt))
        (NumStability.leveque04_uniformInterface origin width (j - 1))
        (NumStability.leveque04_uniformInterface origin width j) =
      old j - dt / width *
        (max speed 0 * (old j - old (j - 1)) +
          min speed 0 * (old (j + 1) - old j))

end

section
open MeasureTheory Set
set_option autoImplicit false

private theorem cellAverage_apply
    (f : ℝ → Fin 1 → ℝ) (a b : ℝ)
    (hf : IntervalIntegrable f volume a b) (i : Fin 1) :
    NumStability.oneDimensionalCellAverage f a b i =
      NumStability.oneDimensionalCellAverage (fun x => f x i) a b := by
  exact NumStability.oneDimensionalCellAverage_apply f a b hf i

end

section
open MeasureTheory Set
set_option autoImplicit false

private theorem reconstruction_cell_const
    (origin width : ℝ) (hw : 0 < width) (old : ℤ → ℝ) (i : ℤ)
    (x : ℝ) (hx : x ∈ NumStability.leveque04_cell
      (NumStability.leveque04_uniformInterface origin width) i) :
    NumStability.leveque04_uniformReconstruction origin width old x = old i :=
  NumStability.leveque04_uniformReconstruction_cell origin width hw old i x hx

end

section
open MeasureTheory Set
set_option autoImplicit false

theorem signedReconstructionAverageBridge :
    NumStability.Leveque04SignedReconstructionAverageBridgeTarget := by
  intro origin width dt speed old j hw hdt hbound
  let L := NumStability.leveque04_uniformInterface origin width (j - 1)
  let R := NumStability.leveque04_uniformInterface origin width j
  let recf := NumStability.leveque04_uniformReconstruction origin width old
  have hspan : R - L = width := by
    dsimp [L, R, NumStability.leveque04_uniformInterface]
    push_cast
    ring
  have hR : L + width = R := by linarith
  have hprev : NumStability.leveque04_uniformInterface origin width (j - 1 - 1) = L - width := by
    dsimp [L, NumStability.leveque04_uniformInterface]
    push_cast
    ring
  have hbound' : -(width) ≤ speed * dt ∧ speed * dt ≤ width := abs_le.mp hbound
  by_cases hnonneg : 0 ≤ speed * dt
  · have hspeed : 0 ≤ speed := by
      by_contra hs
      have hs' : speed < 0 := lt_of_not_ge hs
      have : speed * dt < 0 := mul_neg_of_neg_of_pos hs' hdt
      linarith
    let dist := width + speed * dt
    let q : ℝ → Fin 1 → ℝ := fun x _ => recf (L + width + x)
    have hfar : ∀ x ∈ Ioo (-2 * width) (-width),
        q x = fun _ : Fin 1 => old (j - 1) := by
      intro x hx
      have hx' : x ∈ Ioo (-2 * width) (-width) := hx
      have hcell : L + width + x ∈ NumStability.leveque04_cell
          (NumStability.leveque04_uniformInterface origin width) (j - 1) := by
        rw [NumStability.leveque04_cell, Set.mem_Ioo]
        constructor
        · rw [hprev]
          linarith [hx'.1]
        · change L + width + x < L
          linarith [hx'.2]
      have hv := reconstruction_cell_const origin width hw old (j - 1)
        (L + width + x) hcell
      funext k
      simp [q, recf, hv]
    have hnear : ∀ x ∈ Ioo (-width) 0,
        q x = fun _ : Fin 1 => old j := by
      intro x hx
      have hx' : x ∈ Ioo (-width) 0 := hx
      have hcell : L + width + x ∈ NumStability.leveque04_cell
          (NumStability.leveque04_uniformInterface origin width) j := by
        rw [NumStability.leveque04_cell, Set.mem_Ioo]
        constructor
        · change L < L + width + x
          linarith [hx'.1]
        · change L + width + x < R
          linarith [hR, hx'.2]
      have hv := reconstruction_cell_const origin width hw old j
        (L + width + x) hcell
      funext k
      simp [q, recf, hv]
    have hlocal := NumStability.translated_adjacent_cellAverage
      (m := 0) q (fun _ : Fin 1 => old (j - 1))
      (fun _ : Fin 1 => old j) width dist hw
      (by dsimp [dist]; linarith)
      (by dsimp [dist]; linarith [hbound'.2])
      hfar hnear
    have hscalar := congrFun hlocal.2 (0 : Fin 1)
    rw [cellAverage_apply (fun x => q (x - dist)) 0 width hlocal.1 (0 : Fin 1)] at hscalar
    have havg :
        NumStability.oneDimensionalCellAverage
          (fun x => recf (L + x - speed * dt)) 0 width =
          (speed * dt / width) * old (j - 1) +
            ((width - speed * dt) / width) * old j := by
      have hfun : (fun x => q (x - dist) (0 : Fin 1)) =
          (fun x => recf (L + x - speed * dt)) := by
        funext x
        dsimp [q, dist]
        congr 1
        ring
      rw [hfun] at hscalar
      have hfarWeight : (dist - width) / width = speed * dt / width := by
        dsimp [dist]
        congr 1
        ring
      have hnearWeight : (2 * width - dist) / width = (width - speed * dt) / width := by
        dsimp [dist]
        congr 1
        ring
      simpa only [hfarWeight, hnearWeight, Pi.smul_apply, Pi.add_apply,
        smul_eq_mul] using hscalar
    have hphysical :
        NumStability.oneDimensionalCellAverage
          (fun x => recf (x - speed * dt)) L R =
        NumStability.oneDimensionalCellAverage
          (fun x => recf (L + x - speed * dt)) 0 width := by
      have hi := intervalIntegral.integral_comp_add_left
        (f := fun x => recf (x - speed * dt)) (a := (0 : ℝ)) (b := width) L
      simp only [add_zero, hR] at hi
      simp only [NumStability.oneDimensionalCellAverage, hspan, sub_zero, smul_eq_mul]
      rw [hi]
    rw [hphysical, havg]
    rw [max_eq_left hspeed, min_eq_right hspeed]
    have hdtne : dt ≠ 0 := ne_of_gt hdt
    field_simp [hw.ne', hdtne]
    ring
  · have hnegative : speed * dt < 0 := lt_of_not_ge hnonneg
    have hspeed : speed < 0 := by
      by_contra hs
      have hs' : 0 ≤ speed := le_of_not_gt hs
      have : 0 ≤ speed * dt := mul_nonneg hs' hdt.le
      linarith
    let e := -(speed * dt)
    let dist := width + e
    let q : ℝ → Fin 1 → ℝ := fun x _ => recf (R - width - x)
    have hepos : 0 < e := by dsimp [e]; linarith
    have hebound : e ≤ width := by dsimp [e]; linarith [hbound'.1]
    have hfar : ∀ x ∈ Ioo (-2 * width) (-width),
        q x = fun _ : Fin 1 => old (j + 1) := by
      intro x hx
      have hx' : x ∈ Ioo (-2 * width) (-width) := hx
      have hcell : R - width - x ∈ NumStability.leveque04_cell
          (NumStability.leveque04_uniformInterface origin width) (j + 1) := by
        rw [NumStability.leveque04_cell, Set.mem_Ioo]
        constructor
        · have hcenter : NumStability.leveque04_uniformInterface origin width (j + 1 - 1) = R := by
            dsimp [R, NumStability.leveque04_uniformInterface]
            push_cast
            ring
          rw [hcenter]
          linarith [hx'.2]
        · have hnext : NumStability.leveque04_uniformInterface origin width (j + 1) =
              R + width := by
            dsimp [R, NumStability.leveque04_uniformInterface]
            push_cast
            ring
          rw [hnext]
          linarith [hx'.1]
      have hv := reconstruction_cell_const origin width hw old (j + 1)
        (R - width - x) hcell
      funext k
      simp [q, recf, hv]
    have hnear : ∀ x ∈ Ioo (-width) 0,
        q x = fun _ : Fin 1 => old j := by
      intro x hx
      have hx' : x ∈ Ioo (-width) 0 := hx
      have hcell : R - width - x ∈ NumStability.leveque04_cell
          (NumStability.leveque04_uniformInterface origin width) j := by
        rw [NumStability.leveque04_cell, Set.mem_Ioo]
        constructor
        · have hleft : NumStability.leveque04_uniformInterface origin width (j - 1) = R - width := by
            change L = R - width
            linarith [hspan]
          rw [hleft]
          linarith [hx'.2]
        · change R - width - x < R
          linarith [hx'.1]
      have hv := reconstruction_cell_const origin width hw old j
        (R - width - x) hcell
      funext k
      simp [q, recf, hv]
    have hlocal := NumStability.translated_adjacent_cellAverage
      (m := 0) q (fun _ : Fin 1 => old (j + 1))
      (fun _ : Fin 1 => old j) width dist hw
      (by dsimp [dist]; linarith [hepos])
      (by dsimp [dist]; linarith [hebound])
      hfar hnear
    have hscalar := congrFun hlocal.2 (0 : Fin 1)
    rw [cellAverage_apply (fun x => q (x - dist)) 0 width hlocal.1 (0 : Fin 1)] at hscalar
    have hlocalAvg :
        NumStability.oneDimensionalCellAverage
          (fun x => recf (R + e - x)) 0 width =
          (e / width) * old (j + 1) + ((width - e) / width) * old j := by
      have hfun : (fun x => q (x - dist) (0 : Fin 1)) =
          (fun x => recf (R + e - x)) := by
        funext x
        dsimp [q, dist]
        congr 1
        dsimp [e]
        ring
      rw [hfun] at hscalar
      have hfarWeight : (dist - width) / width = e / width := by
        dsimp [dist]
        congr 1
        ring
      have hnearWeight : (2 * width - dist) / width = (width - e) / width := by
        dsimp [dist]
        congr 1
        ring
      simpa only [hfarWeight, hnearWeight, Pi.smul_apply, Pi.add_apply,
        smul_eq_mul] using hscalar
    have hphysical :
        NumStability.oneDimensionalCellAverage
          (fun x => recf (x - speed * dt)) L R =
        NumStability.oneDimensionalCellAverage
          (fun x => recf (R + e - x)) 0 width := by
      have hinterval : R - width = L := by linarith [hspan]
      have hi := intervalIntegral.integral_comp_sub_left
        (f := fun x => recf (x + e)) (d := R) (a := (0 : ℝ)) (b := width)
      simp only [hinterval, sub_zero] at hi
      have hfunLeft : (fun x => recf (R + e - x)) =
          (fun x => recf (R - x + e)) := by
        funext x
        congr 1
        ring
      have hfunRight : (fun x => recf (x - speed * dt)) =
          (fun x => recf (x + e)) := by
        funext x
        dsimp [e]
        congr 1
      simp only [NumStability.oneDimensionalCellAverage, hspan, sub_zero, smul_eq_mul]
      rw [hfunLeft, hfunRight, hi]
    rw [hphysical, hlocalAvg]
    rw [max_eq_right (le_of_lt hspeed), min_eq_left (le_of_lt hspeed)]
    have hdtne : dt ≠ 0 := ne_of_gt hdt
    field_simp [hw.ne', hdtne]
    dsimp [e]
    ring

end

end NumStability
