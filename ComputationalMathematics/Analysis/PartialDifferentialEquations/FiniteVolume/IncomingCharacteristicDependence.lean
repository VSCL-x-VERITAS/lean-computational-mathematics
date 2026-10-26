/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RectangleRiemannInterface
import Mathlib.Logic.Function.DependsOn

/-!
# Incoming Characteristic Dependence

The principal API is `HasIncomingCharacteristicDependence`, with
`IncomingCharacteristicRiemannRun` exposing the actual interface execution.
This module is reusable API and makes no numbered-source claim.

Generic trace and physical-sample contracts for incoming characteristic
 dependence. These predicates only express dependence relative to the
 supplied coordinates and physical sample map; they do not certify that an
 arbitrary numerical method has those interpretations.
-/

namespace NumStability
abbrev IncomingCharacteristicSample (m : ℕ) := ℤ × Fin m
abbrev IncomingCharacteristicData (m : ℕ) :=
  IncomingCharacteristicSample m → ℝ

/-- Physical input contract for a selected characteristic trace. Sample
positions and the interface position determine the spatial side sets; these
maps must describe actual physical sample locations for the selected method. -/
structure IncomingCharacteristicPhysicalContract (m : ℕ) (Sample : Type*) where
  speed : Fin m → ℝ
  samplePosition : Sample → ℝ
  interfacePosition : ℝ

/-- All input components at physical sample positions left of the interface. -/
def physicalLeftIncomingSamples {m : ℕ} {Sample : Type*}
    (contract : IncomingCharacteristicPhysicalContract m Sample) : Set Sample :=
  {sample | contract.samplePosition sample < contract.interfacePosition}

/-- All input components at the interface or to its right. -/
def physicalRightIncomingSamples {m : ℕ} {Sample : Type*}
    (contract : IncomingCharacteristicPhysicalContract m Sample) : Set Sample :=
  {sample | contract.interfacePosition ≤ contract.samplePosition sample}

/-- Low-level directional dependence of each extracted characteristic trace
on the supplied physical side. The allowed sets include every input component
on that side; this does not assume family-isolated dependence. -/
def HasIncomingTraceDependence {m : ℕ} {Sample : Type*} {Information : Type*}
    (contract : IncomingCharacteristicPhysicalContract m Sample)
    (information : (Sample → ℝ) → Information)
    (traceCoordinate : Information → Fin m → ℝ) : Prop :=
  ∀ p,
    (0 < contract.speed p →
      DependsOn
        (fun data => traceCoordinate (information data) p)
        (physicalLeftIncomingSamples contract)) ∧
    (contract.speed p < 0 →
      DependsOn
        (fun data => traceCoordinate (information data) p)
        (physicalRightIncomingSamples contract))

/-- Complete incoming-characteristic method criterion. The first conjunct
requires the actual interface flux to factor through the entire extracted
trace vector, so other information cannot secretly control the flux. The
second constrains each trace by the physical side selected by its signed
speed. Both are relative to the supplied coordinates and physical sample
contract; the definition alone does not certify their interpretation for an
arbitrary law or solver. -/
def HasIncomingCharacteristicDependence {m : ℕ} {Sample : Type*}
    {Information Flux : Type*}
    (contract : IncomingCharacteristicPhysicalContract m Sample)
    (information : (Sample → ℝ) → Information)
    (traceCoordinate : Information → Fin m → ℝ)
    (actualInterfaceFlux : (Sample → ℝ) → Flux)
    (numericalFluxFromTraces : (Fin m → ℝ) → Flux) : Prop :=
  (∀ data, actualInterfaceFlux data =
    numericalFluxFromTraces (fun p => traceCoordinate (information data) p)) ∧
  HasIncomingTraceDependence contract information traceCoordinate

/-- Rectangle-certified Riemann run exposing its actual solve/extract/flux
path and a proposed full-trace flux formula. The full criterion checks that
the proposed formula really equals the method's actual flux. Reconstruction
may use any width stencil; the physical dependence condition is checked on the
resulting extracted trace. -/
structure IncomingCharacteristicRiemannRun
    {m : ℕ} {law : OneDimensionalHyperbolicConservationLaw (Fin m)}
    {Information : Type*}
    (method : RectangleRiemannInterfaceFluxMethod law Information)
    (Sample : Type*) where
  reconstruct : (Sample → ℝ) → ℤ → (Fin m → ℝ)
  admissible : ∀ (data : Sample → ℝ) (j : ℤ),
    method.domain
      (adjacentCellRiemannProblem law (fun k => reconstruct data k) j)
  traceCoordinate : Information → Fin m → ℝ
  numericalFluxFromTraces : (Fin m → ℝ) → (Fin m → ℝ)

namespace IncomingCharacteristicRiemannRun

variable {m : ℕ} {law : OneDimensionalHyperbolicConservationLaw (Fin m)}
  {Information : Type*}
  {method : RectangleRiemannInterfaceFluxMethod law Information}
  {Sample : Type*}

def actualInformation (run : IncomingCharacteristicRiemannRun method Sample)
    (data : Sample → ℝ) : Information :=
  adjacentCellRectangleRiemannInformation method
    (fun j => run.reconstruct data j) (fun j => run.admissible data j) 0

def actualInterfaceFlux (run : IncomingCharacteristicRiemannRun method Sample)
    (data : Sample → ℝ) : Fin m → ℝ :=
  rectangleRiemannInterfaceFlux method
    (fun j => run.reconstruct data j) (fun j => run.admissible data j) 0

def hasIncomingCharacteristicDependence
    (run : IncomingCharacteristicRiemannRun method Sample)
    (contract : IncomingCharacteristicPhysicalContract m Sample) : Prop :=
  HasIncomingCharacteristicDependence contract run.actualInformation
    run.traceCoordinate run.actualInterfaceFlux run.numericalFluxFromTraces

end IncomingCharacteristicRiemannRun

end NumStability
