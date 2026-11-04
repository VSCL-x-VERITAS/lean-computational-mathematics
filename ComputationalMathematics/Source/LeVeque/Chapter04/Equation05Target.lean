/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalFluxAverage
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellVolumeAverage
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLinearEquiv

/-!
# Eq. (4.5): the exact physical time-averaged face-flux reference

Proof-free authoring draft outside the product tree. No admission, native
elaboration, target seal, statement review or proof acceptance is claimed.
Numerical F approximates this reference; no numerical equality or error rate
is asserted. The prescribed physical flux field includes explicit spatial or
derivative dependence, as noted on printed66. The literal state-flux case is
recorded as the exact application J(x,t)=f(q(x,t)). No PDE solve is assumed.
-/

namespace NumStability

open MeasureTheory
open scoped Interval

/-- Average the prescribed actual physical flux field in time at each fixed
spatial face. Spatial or derivative dependence imposes no state-only restriction. -/
def Leveque04TimeAveragedPhysicalFluxFieldTarget : Prop :=
  ∀ (m : ℕ), 0 < m →
    ∀ (grid : OneDimensionalFiniteVolumeGrid) (time : ℕ → ℝ)
      (physicalFluxField : ℝ → ℝ → (Fin m → ℝ)),
      (∀ n, time n < time (n + 1)) →
      (∀ j n, IntervalIntegrable
        (fun τ => physicalFluxField (grid.cellLeft j) τ) volume
        (time n) (time (n + 1))) →
      ∀ j n,
        let profile := fun τ => physicalFluxField (grid.cellLeft j) τ
        let start := time n
        let finish := time (n + 1)
        let duration := finish - start
        let mean := timeAveragedPhysicalFaceFlux grid physicalFluxField id start finish j
        0 < duration ∧
          IsOneDimensionalCellAverage profile start finish mean ∧
          mean = (1 / duration) • (∫ τ in start..finish, profile τ) ∧
          mean = (1 / duration) • (∫ τ in Set.Ioo start finish, profile τ) ∧
          mean = (1 / duration) • (∫ τ in Set.Icc start finish, profile τ) ∧
          duration • mean = (∫ τ in start..finish, profile τ) ∧
          IsCellVolumeAverage volume (Set.Ioo start finish) profile mean ∧
          (∀ p : Fin m,
            mean p = (1 / duration) *
              (∫ τ in Set.Ioo start finish, profile τ p))

/-- The whole reference definition and its literal printed state-flux
application. Nonlinear physical flux is evaluated before time integration. -/
def Leveque04TimeAveragedPhysicalFluxTarget : Prop :=
  Leveque04TimeAveragedPhysicalFluxFieldTarget ∧
  ∀ (m : ℕ), 0 < m →
    ∀ (grid : OneDimensionalFiniteVolumeGrid)
      (q : ℝ → ℝ → (Fin m → ℝ))
      (physicalFlux : (Fin m → ℝ) → (Fin m → ℝ))
      (start finish : ℝ), start < finish →
      ∀ j : ℤ,
      IntervalIntegrable (fun τ => physicalFlux (q (grid.cellLeft j) τ))
        volume start finish →
      timeAveragedPhysicalFaceFlux grid q physicalFlux start finish j =
        timeAveragedPhysicalFaceFlux grid
          (fun x τ => physicalFlux (q x τ)) id start finish j

end NumStability
