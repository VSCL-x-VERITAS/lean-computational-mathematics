/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.Exercise43ThreeCell
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.TranslatedReconstructionAverage
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Ring
import Mathlib.Tactic.Linarith

/-!
# LeVeque Chapter 4, Exercise 4.3: physical multicell wave propagation

The actual piecewise constant reconstruction is translated through one to two
or two to three cells. Initial and evolved integrability, the initial average,
occupied constant regions, and the exact printed numerical updates are explicit.
Values at grid interfaces and outside the relevant cells remain arbitrary.
-/

namespace NumStability
open Set MeasureTheory

/-- Actual initial and evolved averages and occupied regions for (4.64). -/
def Leveque04TwoCellPhysicalWavePropagationTarget : Prop :=
  ∀ (m : ℕ) (q : ℝ → Fin (m+1) → ℝ)
      (priorLeft left current : Fin (m+1) → ℝ)
      (speed timeStep width : ℝ),
    0 < speed → 0 < timeStep → 0 < width →
    width ≤ speed*timeStep → speed*timeStep ≤ 2*width →
    (∀ x ∈ Ioo (-2*width) (-width), q x = priorLeft) →
    (∀ x ∈ Ioo (-width) 0, q x = left) →
    (∀ x ∈ Ioo 0 width, q x = current) →
    IntervalIntegrable q volume 0 width ∧
    IntervalIntegrable (fun x => q (x-speed*timeStep)) volume 0 width ∧
    oneDimensionalCellAverage q 0 width = current ∧
    (∀ x ∈ Ioo 0 (speed*timeStep-width), q (x-speed*timeStep) = priorLeft) ∧
    (∀ x ∈ Ioo (speed*timeStep-width) width, q (x-speed*timeStep) = left) ∧
    ∀ p, oneDimensionalCellAverage (fun x => q (x-speed*timeStep)) 0 width p =
      leveque04_equation64_step speed timeStep width (priorLeft p) (left p) (current p)

/-- Actual reconstruction evolution for the analogous two-to-three-cell method. -/
def Leveque04ThreeCellPhysicalWavePropagationTarget : Prop :=
  ∀ (m : ℕ) (q : ℝ → Fin (m+1) → ℝ)
      (priorThird priorSecond priorFirst current : Fin (m+1) → ℝ)
      (speed timeStep width : ℝ),
    0 < speed → 0 < timeStep → 0 < width →
    2*width ≤ speed*timeStep → speed*timeStep ≤ 3*width →
    (∀ x ∈ Ioo (-3*width) (-2*width), q x = priorThird) →
    (∀ x ∈ Ioo (-2*width) (-width), q x = priorSecond) →
    (∀ x ∈ Ioo (-width) 0, q x = priorFirst) →
    (∀ x ∈ Ioo 0 width, q x = current) →
    IntervalIntegrable q volume 0 width ∧
    IntervalIntegrable (fun x => q (x-speed*timeStep)) volume 0 width ∧
    oneDimensionalCellAverage q 0 width = current ∧
    (∀ x ∈ Ioo 0 (speed*timeStep-2*width), q (x-speed*timeStep) = priorThird) ∧
    (∀ x ∈ Ioo (speed*timeStep-2*width) width, q (x-speed*timeStep) = priorSecond) ∧
    ∀ p, oneDimensionalCellAverage (fun x => q (x-speed*timeStep)) 0 width p =
      leveque04_threeCellWaveStep speed timeStep width
        (priorThird p) (priorSecond p) (priorFirst p) (current p)


private theorem exercise43_physicalWavePropagation :
    Leveque04TwoCellPhysicalWavePropagationTarget ∧
      Leveque04ThreeCellPhysicalWavePropagationTarget := by
  have hinitial (m : ℕ) (q : ℝ → Fin (m+1) → ℝ)
      (left current : Fin (m+1) → ℝ) (width : ℝ) (hw : 0 < width)
      (hl : ∀ x ∈ Ioo (-width) 0, q x = left)
      (hc : ∀ x ∈ Ioo 0 width, q x = current) :
      IntervalIntegrable q volume 0 width ∧
      oneDimensionalCellAverage q 0 width = current := by
    have hi := translated_adjacent_cellAverage m (fun x => q (x+width))
      left current width width hw le_rfl (by linarith)
      (by intro x hx; apply hl; constructor <;> linarith [hx.1,hx.2])
      (by intro x hx; apply hc; constructor <;> linarith [hx.1,hx.2])
    constructor
    · simpa only [sub_add_cancel] using hi.1
    · simpa [sub_add_cancel, two_mul, hw.ne'] using hi.2
  constructor
  · intro m q priorLeft left current speed timeStep width _ _ hw hlo hup hfar hnear hcurrent
    have hi := hinitial m q left current width hw hnear hcurrent
    have hf := translated_adjacent_cellAverage m q priorLeft left width
      (speed*timeStep) hw hlo hup hfar hnear
    refine ⟨hi.1,hf.1,hi.2,?_,?_,?_⟩
    · intro x hx
      apply hfar
      constructor <;> linarith [hx.1,hx.2]
    · intro x hx
      apply hnear
      constructor <;> linarith [hx.1,hx.2]
    · intro p
      rw [hf.2]
      simp only [Pi.add_apply, Pi.smul_apply, smul_eq_mul]
      unfold leveque04_equation64_step
      field_simp [hw.ne']
      ring
  · intro m q priorThird priorSecond priorFirst current speed timeStep width _ _ hw hlo hup hthird hsecond hfirst hcurrent
    have hi := hinitial m q priorFirst current width hw hfirst hcurrent
    have hf := translated_adjacent_cellAverage m (fun x => q (x-width))
      priorThird priorSecond width (speed*timeStep-width) hw (by linarith) (by linarith)
      (by intro x hx; apply hthird; constructor <;> linarith [hx.1,hx.2])
      (by intro x hx; apply hsecond; constructor <;> linarith [hx.1,hx.2])
    have heq : (fun x => q (x-(speed*timeStep-width)-width)) =
        (fun x => q (x-speed*timeStep)) := by
      funext x
      congr 1
      ring
    change IntervalIntegrable (fun x => q (x-(speed*timeStep-width)-width)) volume 0 width ∧
      oneDimensionalCellAverage (fun x => q (x-(speed*timeStep-width)-width)) 0 width =
        ((speed*timeStep-width-width)/width) • priorThird +
          ((2*width-(speed*timeStep-width))/width) • priorSecond at hf
    rw [heq] at hf
    refine ⟨hi.1,hf.1,hi.2,?_,?_,?_⟩
    · intro x hx
      apply hthird
      constructor <;> linarith [hx.1,hx.2]
    · intro x hx
      apply hsecond
      constructor <;> linarith [hx.1,hx.2]
    · intro p
      rw [hf.2]
      simp only [Pi.add_apply, Pi.smul_apply, smul_eq_mul]
      unfold leveque04_threeCellWaveStep
      field_simp [hw.ne']
      ring


/-- Exercise 4.3(a): full and fractional crossings reproduce (4.64). -/
theorem leveque04_exercise43_twoCellPhysicalWavePropagation :
    Leveque04TwoCellPhysicalWavePropagationTarget :=
  exercise43_physicalWavePropagation.1

/-- Exercise 4.3(e): two full crossings and a fractional third give the method. -/
theorem leveque04_exercise43_threeCellPhysicalWavePropagation :
    Leveque04ThreeCellPhysicalWavePropagationTarget :=
  exercise43_physicalWavePropagation.2

end NumStability
