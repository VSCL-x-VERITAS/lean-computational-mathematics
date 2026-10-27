/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.IncomingCharacteristicDependence
import ComputationalMathematics.Source.LeVeque.Chapter04.LinearGodunovCharacteristicStep
import ComputationalMathematics.Source.LeVeque.Chapter04.UpwindWavePropagation
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearCharacteristicCoordinates
import Mathlib.Logic.Function.DependsOn
import Mathlib.Tactic.NormNum

/-!
# Upwind Incoming Dependence

Source correspondence: LeVeque, Finite Volume Methods for Hyperbolic
Problems (2002), Chapter 4, the upwind discussion on printed pages 72-75,
equations (4.24)-(4.25) and (4.29)-(4.30), and the system discussion on
printed pages 78-81. `upwindDirectionTargetV3` collects the selected linear,
signed scalar and acoustic results; `upwindDirectionTargetV3_proof` proves it.

Qualified LeVeque upwind results. The full-flux criterion is relative to the
supplied speed, characteristic-trace and physical-sample contracts. The
selected producer is the constant-linear rectangle-Riemann realization. No
claim is made for arbitrary nonlinear methods or unrestricted zero-speed
channels.
-/

namespace NumStability
/-- The selected constant-linear Godunov execution realizes the full
criterion. The physical contract uses actual integer cell positions and the
face between cells -1 and 0. Characteristic-coordinate input is mapped back
through the explicitly supplied eigenbasis/eigenrelation. The incoming side
sets contain every component on that side; the exact trace identities show
that this particular linear method uses the corresponding family sample. -/
def selectedLinearGodunovIncomingDependenceTargetV3 : Prop :=
  ∀ {m : ℕ}
    (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (hcoefficient : IsRealHyperbolicMatrix coefficient)
    (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (eigenbasis p) =
      waveSpeed p • eigenbasis p),
    let method := linearRectangleRiemannInterfaceFluxMethod coefficient
      hcoefficient eigenbasis waveSpeed heigen
    let run : IncomingCharacteristicRiemannRun method
        (IncomingCharacteristicSample m) := {
      reconstruct := fun data j =>
        eigenbasis.equivFun.symm (fun p => data (j, p))
      admissible := fun _ _ => True.intro
      traceCoordinate := fun information p => eigenbasis.equivFun information p
      numericalFluxFromTraces := fun traces =>
        coefficient.mulVec (eigenbasis.equivFun.symm traces)
    }
    let contract : IncomingCharacteristicPhysicalContract m
        (IncomingCharacteristicSample m) := {
      speed := waveSpeed
      samplePosition := fun sample => (sample.1 : ℝ)
      interfacePosition := (-1 / 2 : ℝ)
    }
    run.hasIncomingCharacteristicDependence contract ∧
    (∀ data,
      run.actualInterfaceFlux data =
        coefficient.mulVec (run.actualInformation data)) ∧
    (∀ data p, 0 < waveSpeed p →
      eigenbasis.equivFun (run.actualInformation data) p = data (-1, p)) ∧
    (∀ data p, waveSpeed p < 0 →
      eigenbasis.equivFun (run.actualInformation data) p = data (0, p)) ∧
    (∀ (old : ℤ → (Fin m → ℝ)) (ratio : ℝ) (i : ℤ),
      conservativeFluxDifferenceUpdateInt ratio old
        (rectangleRiemannInterfaceFlux method old (fun _ => True.intro)) i =
      leveque04_linearGodunovWaveStep eigenbasis waveSpeed ratio old i)

/-- Existing scalar producers state the positive left-incoming and negative
right-incoming flux and update formulas. -/
def scalarSignedUpwindIncomingProducerTargetV3 : Prop :=
  ∀ (timeStep cellWidth velocity : ℝ) (cellAverage : ℤ → ℝ) (i : ℤ),
    (0 < velocity →
      leveque04_positiveUpwindInterfaceFlux velocity cellAverage i =
        velocity * cellAverage (i - 1) ∧
      leveque04_positiveUpwindStep timeStep cellWidth velocity cellAverage i =
        cellAverage i - velocity * timeStep / cellWidth *
          (cellAverage i - cellAverage (i - 1))) ∧
    (velocity < 0 →
      leveque04_signedUpwindInterfaceFlux velocity cellAverage i =
        velocity * cellAverage i ∧
      leveque04_signedUpwindStep timeStep cellWidth velocity cellAverage i =
        cellAverage i - velocity * timeStep / cellWidth *
          (cellAverage (i + 1) - cellAverage i))

/-- Existing two-family selected Godunov producer for speeds `[-c,+c]`:
the negative family receives from the right and the positive family from the
left. -/
def acousticMixedSignLinearGodunovProducerTargetV3 : Prop :=
  ∀ (eigenbasis : Module.Basis (Fin 2) ℝ (Fin 2 → ℝ))
    (soundSpeed : ℝ) (hspeed : 0 < soundSpeed)
    (old : ℤ → (Fin 2 → ℝ)) (ratio : ℝ) (i : ℤ),
    let next := leveque04_linearGodunovWaveStep eigenbasis
      ![-soundSpeed, soundSpeed] ratio old i
    eigenbasis.equivFun next 0 =
      eigenbasis.equivFun (old i) 0 - ratio * (-soundSpeed) *
        (eigenbasis.equivFun (old (i + 1)) 0 - eigenbasis.equivFun (old i) 0) ∧
    eigenbasis.equivFun next 1 =
      eigenbasis.equivFun (old i) 1 - ratio * soundSpeed *
        (eigenbasis.equivFun (old i) 1 - eigenbasis.equivFun (old (i - 1)) 1)

/-- Complete proof-free target bundle: full-flux incoming dependence in the
selected linear system, scalar one-sided producers, and the mixed-sign system
producer. -/
def upwindDirectionTargetV3 : Prop :=
  selectedLinearGodunovIncomingDependenceTargetV3 ∧
  scalarSignedUpwindIncomingProducerTargetV3 ∧
  acousticMixedSignLinearGodunovProducerTargetV3

end NumStability

namespace NumStability

theorem selectedLinearGodunovIncomingDependenceTargetV3_proof :
    selectedLinearGodunovIncomingDependenceTargetV3 := by
  unfold selectedLinearGodunovIncomingDependenceTargetV3
  intro m coefficient hcoefficient eigenbasis waveSpeed heigen
  let method := linearRectangleRiemannInterfaceFluxMethod coefficient
    hcoefficient eigenbasis waveSpeed heigen
  let old : IncomingCharacteristicData m → ℤ → (Fin m → ℝ) :=
    fun data j => eigenbasis.equivFun.symm (fun p => data (j, p))
  let run : IncomingCharacteristicRiemannRun method
      (IncomingCharacteristicSample m) := {
    reconstruct := old
    admissible := fun _ _ => True.intro
    traceCoordinate := fun information p => eigenbasis.equivFun information p
    numericalFluxFromTraces := fun traces =>
      coefficient.mulVec (eigenbasis.equivFun.symm traces)
  }
  let contract : IncomingCharacteristicPhysicalContract m
      (IncomingCharacteristicSample m) := {
    speed := waveSpeed
    samplePosition := fun sample => (sample.1 : ℝ)
    interfacePosition := (-1 / 2 : ℝ)
  }
  change
    (run.hasIncomingCharacteristicDependence contract ∧
      (∀ data,
        run.actualInterfaceFlux data =
          coefficient.mulVec (run.actualInformation data)) ∧
      (∀ data p, 0 < waveSpeed p →
        eigenbasis.equivFun (run.actualInformation data) p = data (-1, p)) ∧
      (∀ data p, waveSpeed p < 0 →
        eigenbasis.equivFun (run.actualInformation data) p = data (0, p)) ∧
      (∀ (oldState : ℤ → (Fin m → ℝ)) (ratio : ℝ) (i : ℤ),
        conservativeFluxDifferenceUpdateInt ratio oldState
          (rectangleRiemannInterfaceFlux method oldState
            (fun _ => True.intro)) i =
        leveque04_linearGodunovWaveStep eigenbasis waveSpeed ratio oldState i))
  have hinformation (data : IncomingCharacteristicData m) :
      run.actualInformation data =
        linearRiemannSolution eigenbasis waveSpeed
          (old data (-1)) (old data (-1)) (old data 0) 0 1 := by
    rfl
  have hcoordinate (data : IncomingCharacteristicData m) (p : Fin m) :
      eigenbasis.equivFun (run.actualInformation data) p =
        riemannData
          (eigenbasis.equivFun (old data (-1)) p)
          (eigenbasis.equivFun (old data (-1)) p)
          (eigenbasis.equivFun (old data 0) p)
          (-waveSpeed p) := by
    rw [hinformation data]
    simpa [old] using
      (linearRiemannSolution_coordinate eigenbasis waveSpeed
        (old data (-1)) (old data (-1)) (old data 0) 0 1 p)
  have hleftTrace (data : IncomingCharacteristicData m) (p : Fin m)
      (hpos : 0 < waveSpeed p) :
      eigenbasis.equivFun (run.actualInformation data) p = data (-1, p) := by
    rw [hcoordinate data p]
    have hnegative : -waveSpeed p < 0 := neg_lt_zero.mpr hpos
    rw [riemannData, if_pos hnegative]
    change eigenbasis.equivFun (eigenbasis.equivFun.symm (fun q => data (-1, q))) p = data (-1, p)
    exact congrFun (eigenbasis.equivFun.apply_symm_apply (fun q => data (-1, q))) p
  have hrightTrace (data : IncomingCharacteristicData m) (p : Fin m)
      (hneg : waveSpeed p < 0) :
      eigenbasis.equivFun (run.actualInformation data) p = data (0, p) := by
    rw [hcoordinate data p]
    have hpositive : 0 < -waveSpeed p := neg_pos.mpr hneg
    rw [riemannData, if_neg (not_lt.mpr (le_of_lt hpositive)), if_pos hpositive]
    change eigenbasis.equivFun (eigenbasis.equivFun.symm (fun q => data (0, q))) p = data (0, p)
    exact congrFun (eigenbasis.equivFun.apply_symm_apply (fun q => data (0, q))) p
  have hfactor (data : IncomingCharacteristicData m) :
      run.actualInterfaceFlux data =
        run.numericalFluxFromTraces
          (fun p => run.traceCoordinate (run.actualInformation data) p) := by
    change coefficient.mulVec (run.actualInformation data) =
      coefficient.mulVec (eigenbasis.equivFun.symm
        (fun p => eigenbasis.equivFun (run.actualInformation data) p))
    rw [eigenbasis.equivFun.symm_apply_apply]
  have hdirection : run.hasIncomingCharacteristicDependence contract := by
    change HasIncomingCharacteristicDependence contract
      run.actualInformation run.traceCoordinate run.actualInterfaceFlux
      run.numericalFluxFromTraces
    unfold HasIncomingCharacteristicDependence HasIncomingTraceDependence
    refine ⟨hfactor, ?_⟩
    intro p
    constructor
    · intro hpos data data' hagree
      change eigenbasis.equivFun (run.actualInformation data) p =
        eigenbasis.equivFun (run.actualInformation data') p
      rw [hleftTrace data p hpos, hleftTrace data' p hpos]
      have hsample : (-1, p) ∈ physicalLeftIncomingSamples contract := by
        change ((-1 : ℤ) : ℝ) < (-1 / 2 : ℝ)
        norm_num
      exact hagree (-1, p) hsample
    · intro hneg data data' hagree
      change eigenbasis.equivFun (run.actualInformation data) p =
        eigenbasis.equivFun (run.actualInformation data') p
      rw [hrightTrace data p hneg, hrightTrace data' p hneg]
      have hsample : (0, p) ∈ physicalRightIncomingSamples contract := by
        change (-1 / 2 : ℝ) ≤ (0 : ℤ)
        norm_num
      exact hagree (0, p) hsample
  refine ⟨hdirection, ?_, ?_, ?_, ?_⟩
  · intro data
    rfl
  · intro data p hpos
    exact hleftTrace data p hpos
  · intro data p hneg
    exact hrightTrace data p hneg
  · intro oldState ratio i
    exact leveque04_linearGodunovWaveStep_selected coefficient hcoefficient
      eigenbasis waveSpeed heigen oldState ratio i

theorem scalarSignedUpwindIncomingProducerTargetV3_proof :
    scalarSignedUpwindIncomingProducerTargetV3 := by
  unfold scalarSignedUpwindIncomingProducerTargetV3
  intro timeStep cellWidth velocity cellAverage i
  constructor
  · intro hvelocity
    exact ⟨leveque04_equation24 velocity hvelocity cellAverage i,
      leveque04_equation25 timeStep cellWidth velocity cellAverage i hvelocity⟩
  · intro hvelocity
    exact ⟨leveque04_equation29 velocity hvelocity cellAverage i,
      leveque04_equation30 timeStep cellWidth velocity cellAverage i hvelocity⟩

theorem acousticMixedSignLinearGodunovProducerTargetV3_proof :
    acousticMixedSignLinearGodunovProducerTargetV3 := by
  unfold acousticMixedSignLinearGodunovProducerTargetV3
  intro eigenbasis soundSpeed hspeed oldState ratio i
  dsimp only
  have hnegative := leveque04_linearGodunovWaveStep_characteristic
    eigenbasis ![-soundSpeed, soundSpeed] ratio oldState i 0
  have hpositive := leveque04_linearGodunovWaveStep_characteristic
    eigenbasis ![-soundSpeed, soundSpeed] ratio oldState i 1
  constructor
  · rw [hnegative]
    simp only [Matrix.cons_val_zero, leveque04_positiveVelocity,
      max_eq_right (neg_nonpos.mpr hspeed.le),
      leveque04_negativeVelocity, min_eq_left (neg_nonpos.mpr hspeed.le)]
    ring
  · rw [hpositive]
    simp only [Matrix.cons_val_zero, Matrix.cons_val_one,
      leveque04_positiveVelocity, max_eq_left hspeed.le,
      leveque04_negativeVelocity, min_eq_right hspeed.le]
    ring

theorem upwindDirectionTargetV3_proof : upwindDirectionTargetV3 :=
  ⟨selectedLinearGodunovIncomingDependenceTargetV3_proof,
    scalarSignedUpwindIncomingProducerTargetV3_proof,
    acousticMixedSignLinearGodunovProducerTargetV3_proof⟩


end NumStability
