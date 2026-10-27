/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.GodunovStability
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.ThreePointStencilReachability
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearSystemRefinementCFL
import Mathlib.Analysis.SpecificLimits.Basic
import Mathlib.Tactic

/-!
# LeVeque Chapter 4: a qualified functional-domain diagnosis

Under the literal fixed-method functional reading, the whole-interval claim
fails for an actual three-neighbor linear Godunov step. Each neighbor is
essential in one step, while exact fixed-time refinement retains only three
characteristic feet. An interior neighborhood cannot influence the result.
The specified diagonal physical Cauchy evolution supplies the rectangle law
and initial trace. The author's structural envelope interpretation remains
valid and is proved separately in ThreePointStructuralDomain.
-/

open Set Metric Filter
open scoped BigOperators Topology
namespace NumStability

def leveque04_threeModeShiftSpeeds : Fin 3 → ℝ := ![1,0,-1]
def leveque04_threeModeShiftOffsets : Fin 3 → ℤ := ![-1,0,1]
noncomputable def leveque04_threeModeGodunovStep :
    (ℤ → Fin 3 → ℝ) → ℤ → Fin 3 → ℝ :=
  leveque04_linearGodunovWaveStep (Pi.basisFun ℝ (Fin 3)) leveque04_threeModeShiftSpeeds 1

/-- Functional limiting dependence, with the original method fixed. Every
neighborhood must allow an initial-data change affecting arbitrarily refined
numerical observations. Initial fields are unrestricted in this definition. -/
def leveque04_threeModeFunctionalLimitingDomain
    (X : ℝ) (width : ℕ → ℝ) (steps : ℕ → ℕ) : Set ℝ :=
  {point | ∀ radius : ℝ, 0 < radius → ∀ start : ℕ,
    ∃ n : ℕ, start ≤ n ∧ ∃ left right : ℝ → Fin 3 → ℝ,
      (∀ y, y ∉ Metric.ball point radius → left y = right y) ∧
      ((leveque04_threeModeGodunovStep^[steps n])
        (fun j => left (X+(j : ℝ)*width n))) 0 ≠
      ((leveque04_threeModeGodunovStep^[steps n])
        (fun j => right (X+(j : ℝ)*width n))) 0}

/-- The functional interval assertion specialized to the actual genuine
three-neighbor linear Godunov method and fixed ratio one. This specialization
is kept separate from the author's possible structural interpretation. -/
def Leveque04ThreePointFunctionalIntervalClaim : Prop :=
  ∀ X T : ℝ, 0 < T → ∀ (width : ℕ → ℝ) (steps : ℕ → ℕ),
    (∀ n, 0 < width n) → (∀ n, 0 < steps n) →
    (∀ n, (steps n : ℝ)*width n = T) → Tendsto width atTop (nhds 0) →
    leveque04_threeModeFunctionalLimitingDomain X width steps = Icc (X-T) (X+T)


/-- A separate diagnosis witness contract: actual physical method,
genuine three-neighbor dependence, exact fixed-time refinement convergence,
an irrelevant interior neighborhood, and a functional-interval refutation. -/
def Leveque04ThreePointFunctionalDiagnosisWitnessTarget : Prop :=
  (¬Leveque04ThreePointFunctionalIntervalClaim) ∧
  (∀ j : ℤ, ∀ p : Fin 3, ∃ left right : ℤ → Fin 3 → ℝ,
    (∀ k, k ≠ j+leveque04_threeModeShiftOffsets p → left k = right k) ∧
    leveque04_threeModeGodunovStep left j ≠
      leveque04_threeModeGodunovStep right j) ∧
  (∀ initial : ℝ → Fin 3 → ℝ, Continuous initial →
    (∀ x, linearCharacteristicEvolution (Pi.basisFun ℝ (Fin 3))
      leveque04_threeModeShiftSpeeds initial x 0 = initial x) ∧
    IsRectangleConservationLawSolution
      (linearCharacteristicEvolution (Pi.basisFun ℝ (Fin 3))
        leveque04_threeModeShiftSpeeds initial)
      (Matrix.diagonal leveque04_threeModeShiftSpeeds).mulVec) ∧
  (∀ (initial : ℝ → Fin 3 → ℝ) (X T : ℝ)
    (width : ℕ → ℝ) (steps : ℕ → ℕ),
    (∀ n, (steps n : ℝ)*width n = T) →
    Tendsto (fun n => ((leveque04_threeModeGodunovStep^[steps n])
      (fun j => initial (X+(j : ℝ)*width n))) 0) atTop
      (nhds (linearCharacteristicEvolution (Pi.basisFun ℝ (Fin 3))
        leveque04_threeModeShiftSpeeds initial X T))) ∧
  (∀ (X T : ℝ), 0 < T → ∀ left right : ℝ → Fin 3 → ℝ,
    (∀ y, y ∉ Metric.ball (X+T/2) (T/4) → left y = right y) →
    ∀ (width : ℝ) (steps : ℕ), (steps : ℝ)*width = T →
    ((leveque04_threeModeGodunovStep^[steps])
      (fun j => left (X+(j : ℝ)*width))) 0 =
    ((leveque04_threeModeGodunovStep^[steps])
      (fun j => right (X+(j : ℝ)*width))) 0)

theorem leveque04_threeModeSignedStep_shift (p : Fin 3) :
    leveque04_signedUpwindStep 1 1 (leveque04_threeModeShiftSpeeds p) =
      fun u j => u (j+leveque04_threeModeShiftOffsets p) := by
  funext u j
  rw [leveque04_equation35]
  fin_cases p <;> simp [leveque04_threeModeShiftSpeeds,leveque04_threeModeShiftOffsets,
    leveque04_positiveVelocity,leveque04_negativeVelocity,
    leveque04_leftWaveJump,leveque04_rightWaveJump,Int.sub_eq_add_neg]

theorem leveque04_threeModeGodunov_iterate
    (initial : ℤ → Fin 3 → ℝ) (steps : ℕ) (i : ℤ) (p : Fin 3) :
    ((leveque04_threeModeGodunovStep^[steps]) initial) i p =
      initial (i+(steps : ℤ)*leveque04_threeModeShiftOffsets p) p := by
  have h := leveque04_linearGodunov_characteristicIterate (Pi.basisFun ℝ (Fin 3))
    leveque04_threeModeShiftSpeeds 1 1 initial steps i p (by norm_num)
  simp only [Pi.basisFun_equivFun,LinearEquiv.refl_apply,one_mul] at h
  change ((leveque04_threeModeGodunovStep^[steps]) initial) i p = _ at h
  rw [leveque04_threeModeSignedStep_shift] at h
  have hshift := centeredStencilEvolution_shiftSequence
    (fun _ => leveque04_threeModeShiftOffsets p) (fun j => initial j p) steps i
  rw [centeredStencilEvolution_const] at hshift
  simp only [Finset.sum_const,Finset.card_range,nsmul_eq_mul] at hshift
  exact h.trans hshift

/-- Unlike a constant callback, the one-step actual selected Godunov
operator uses each of the left, center and right initial vectors. -/
theorem leveque04_threeModeGodunov_each_neighbor_essential (j : ℤ) :
    ∀ p : Fin 3, ∃ left right : ℤ → Fin 3 → ℝ,
      (∀ k, k ≠ j+leveque04_threeModeShiftOffsets p → left k = right k) ∧
      leveque04_threeModeGodunovStep left j ≠ leveque04_threeModeGodunovStep right j := by
  intro p
  refine ⟨fun _ _ => 0,fun k _ => if k=j+leveque04_threeModeShiftOffsets p then 1 else 0,?_,?_⟩
  · intro k hk
    simp [hk]
  · intro h
    have hc := congrArg (fun v => v p) h
    have hleft := leveque04_threeModeGodunov_iterate (fun _ _ => 0) 1 j p
    have hright := leveque04_threeModeGodunov_iterate
      (fun k _ => if k=j+leveque04_threeModeShiftOffsets p then 1 else 0) 1 j p
    simp only [Function.iterate_one,Nat.cast_one,one_mul] at hleft hright
    dsimp only at hc
    rw [hleft,hright] at hc
    simp at hc

/-- After any number of steps only the three characteristic input sites
can influence this genuinely three-point vector operator. -/
theorem leveque04_threeModeGodunov_three_sites_determine
    (steps : ℕ) (i : ℤ) (left right : ℤ → Fin 3 → ℝ)
    (h : ∀ p, left (i+(steps : ℤ)*leveque04_threeModeShiftOffsets p) =
      right (i+(steps : ℤ)*leveque04_threeModeShiftOffsets p)) :
    ((leveque04_threeModeGodunovStep^[steps]) left) i =
      ((leveque04_threeModeGodunovStep^[steps]) right) i := by
  funext p
  rw [leveque04_threeModeGodunov_iterate,leveque04_threeModeGodunov_iterate,h p]

/-- Interior cells need not influence a genuinely three-input vector step:
this exact linear Godunov operator retains only three characteristic sites. -/
theorem leveque04_threeModeGodunov_interior_change_irrelevant
    (steps : ℕ) (hsteps : 2 ≤ steps) (i : ℤ) :
    (fun _ : Fin 3 => (0 : ℝ)) ≠ (fun _ : Fin 3 => (1 : ℝ)) ∧
    ((leveque04_threeModeGodunovStep^[steps]) (fun _ _ => (0 : ℝ))) i =
    ((leveque04_threeModeGodunovStep^[steps])
      (fun j _ => if j=i+1 then (1 : ℝ) else 0)) i := by
  constructor
  · intro h
    have hc := congrArg (fun v => v (0 : Fin 3)) h
    norm_num at hc
  · apply leveque04_threeModeGodunov_three_sites_determine
    intro p
    have hn : i+(steps : ℤ)*leveque04_threeModeShiftOffsets p ≠ i+1 := by
      fin_cases p <;> norm_num [leveque04_threeModeShiftOffsets] <;> omega
    simp [hn]

/-- Point-sample evolution is the existing exact physical characteristic
solution at the corresponding positive-mesh elapsed time. -/
theorem leveque04_threeModeGodunov_point_exact_characteristic
    (initial : ℝ → Fin 3 → ℝ) (X width : ℝ) (steps : ℕ) :
    ((leveque04_threeModeGodunovStep^[steps])
      (fun j => initial (X+(j : ℝ)*width))) 0 =
    linearCharacteristicEvolution (Pi.basisFun ℝ (Fin 3)) leveque04_threeModeShiftSpeeds
      initial X ((steps : ℝ)*width) := by
  funext p
  rw [leveque04_threeModeGodunov_iterate]
  have hcoord := linearCharacteristicEvolution_coordinate (Pi.basisFun ℝ (Fin 3))
    leveque04_threeModeShiftSpeeds initial X ((steps : ℝ)*width) p
  simp only [Pi.basisFun_equivFun,LinearEquiv.refl_apply] at hcoord
  rw [hcoord]
  congr 2
  have hspeed : (leveque04_threeModeShiftOffsets p : ℝ) = -leveque04_threeModeShiftSpeeds p := by
    fin_cases p <;> norm_num [leveque04_threeModeShiftOffsets,leveque04_threeModeShiftSpeeds]
  simp only [zero_add,Int.cast_mul,Int.cast_natCast,hspeed]
  ring


open Metric Filter
open scoped Topology

/-- Under compatible physical observation times, the selected numerical
evolution is exactly the physical characteristic reference on every grid. -/
theorem leveque04_threeModeGodunov_fixedTime_refinement_exact
    (initial : ℝ → Fin 3 → ℝ) (X T : ℝ)
    (width : ℕ → ℝ) (steps : ℕ → ℕ)
    (hscale : ∀ n, (steps n : ℝ)*width n = T) :
    (∀ n, ((leveque04_threeModeGodunovStep^[steps n])
      (fun j => initial (X+(j : ℝ)*width n))) 0 =
      linearCharacteristicEvolution (Pi.basisFun ℝ (Fin 3))
        leveque04_threeModeShiftSpeeds initial X T) ∧
    Tendsto (fun n => ((leveque04_threeModeGodunovStep^[steps n])
      (fun j => initial (X+(j : ℝ)*width n))) 0) atTop
      (𝓝 (linearCharacteristicEvolution (Pi.basisFun ℝ (Fin 3))
        leveque04_threeModeShiftSpeeds initial X T)) := by
  have heq (n : ℕ) := leveque04_threeModeGodunov_point_exact_characteristic
    initial X (width n) (steps n)
  simp only [hscale] at heq
  refine ⟨heq,?_⟩
  simpa only [heq] using
    (tendsto_const_nhds : Tendsto (fun _ : ℕ =>
      linearCharacteristicEvolution (Pi.basisFun ℝ (Fin 3))
        leveque04_threeModeShiftSpeeds initial X T) atTop (𝓝 _))

/-- At positive fixed time, a whole neighborhood of the midpoint between
the stationary and right-moving characteristic feet is irrelevant, even
though the actual one-step vector method uses all three neighbors. -/
theorem leveque04_threeModeGodunov_fixedTime_interior_neighborhood_irrelevant
    (X T : ℝ) (hT : 0 < T)
    (left right : ℝ → Fin 3 → ℝ)
    (hagrees : ∀ y, y ∉ ball (X+T/2) (T/4) → left y = right y)
    (width : ℝ) (steps : ℕ) (hscale : (steps : ℝ)*width = T) :
    ((leveque04_threeModeGodunovStep^[steps])
      (fun j => left (X+(j : ℝ)*width))) 0 =
    ((leveque04_threeModeGodunovStep^[steps])
      (fun j => right (X+(j : ℝ)*width))) 0 := by
  rw [leveque04_threeModeGodunov_point_exact_characteristic,
    leveque04_threeModeGodunov_point_exact_characteristic,hscale]
  funext p
  have hleft := linearCharacteristicEvolution_coordinate (Pi.basisFun ℝ (Fin 3))
    leveque04_threeModeShiftSpeeds left X T p
  have hright := linearCharacteristicEvolution_coordinate (Pi.basisFun ℝ (Fin 3))
    leveque04_threeModeShiftSpeeds right X T p
  simp only [Pi.basisFun_equivFun,LinearEquiv.refl_apply] at hleft hright
  rw [hleft,hright]
  have hout : X-leveque04_threeModeShiftSpeeds p*T ∉ ball (X+T/2) (T/4) := by
    intro hm
    rw [mem_ball,Real.dist_eq] at hm
    have habs := abs_lt.mp hm
    fin_cases p <;> norm_num [leveque04_threeModeShiftSpeeds] at habs <;> linarith
  rw [hagrees _ hout]

/-- The physical reference used by the genuine Godunov domain test has
the actual specified diagonal flux, satisfies its rectangle conservation law,
and recovers every continuous initial field. -/
theorem leveque04_threeModePhysicalCauchy_reference
    (initial : ℝ → Fin 3 → ℝ) (hcontinuous : Continuous initial) :
    (∀ x, linearCharacteristicEvolution (Pi.basisFun ℝ (Fin 3)) ![1,0,-1] initial x 0 = initial x) ∧
    IsRectangleConservationLawSolution
      (linearCharacteristicEvolution (Pi.basisFun ℝ (Fin 3)) ![1,0,-1] initial)
      (Matrix.diagonal ![1,0,-1]).mulVec := by
  apply linearCharacteristicEvolution_continuous_initial_reference
    (Matrix.diagonal ![1,0,-1]) (Pi.basisFun ℝ (Fin 3)) ![1,0,-1] _ initial hcontinuous
  intro p
  ext q
  by_cases h : q=p
  · subst q
    simp [Matrix.mulVec_diagonal,Pi.basisFun_apply]
  · simp [Matrix.mulVec_diagonal,Pi.basisFun_apply,h]

theorem leveque04_threePointFunctionalInterval_refuted :
    ¬Leveque04ThreePointFunctionalIntervalClaim := by
  intro h
  let width : ℕ → ℝ := fun n => 1/((n : ℝ)+1)
  let steps : ℕ → ℕ := fun n => n+1
  have hwidth (n : ℕ) : 0 < width n := by dsimp [width]; positivity
  have hsteps (n : ℕ) : 0 < steps n := by dsimp [steps]; omega
  have hscale (n : ℕ) : (steps n : ℝ)*width n = 1 := by
    dsimp [steps,width]
    simp only [Nat.cast_add,Nat.cast_one]
    field_simp
  have hw : Tendsto width atTop (nhds 0) := tendsto_one_div_add_atTop_nhds_zero_nat
  have heq := h 0 1 (by norm_num) width steps hwidth hsteps hscale hw
  have hx : (1/2 : ℝ) ∈ leveque04_threeModeFunctionalLimitingDomain 0 width steps := by
    rw [heq]
    norm_num
  obtain ⟨n,_,left,right,hagree,hdifferent⟩ := hx (1/4) (by norm_num) 0
  have hsame := leveque04_threeModeGodunov_fixedTime_interior_neighborhood_irrelevant
    0 1 (by norm_num) left right (by simpa only [zero_add] using hagree)
    (width n) (steps n) (hscale n)
  apply hdifferent
  exact hsame

theorem leveque04_threePointFunctionalDiagnosisWitness :
    Leveque04ThreePointFunctionalDiagnosisWitnessTarget := by
  refine ⟨leveque04_threePointFunctionalInterval_refuted,?_,?_,?_,?_⟩
  · intro j
    exact leveque04_threeModeGodunov_each_neighbor_essential j
  · intro initial hcontinuous
    simpa only [leveque04_threeModeShiftSpeeds] using
      leveque04_threeModePhysicalCauchy_reference initial hcontinuous
  · intro initial X T width steps hscale
    exact (leveque04_threeModeGodunov_fixedTime_refinement_exact initial X T width steps hscale).2
  · intro X T hT left right hagree width steps hscale
    exact leveque04_threeModeGodunov_fixedTime_interior_neighborhood_irrelevant
      X T hT left right hagree width steps hscale

end NumStability
