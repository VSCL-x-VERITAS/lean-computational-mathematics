/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.UnitHeatCapacityTarget

/-!
# Thermal conduction and diffusion with variable heat capacity

The unit-capacity identification is accompanied by the structural comparison
for general differentiable capacity. The energy gradient has a capacity-gradient
term and a scaled temperature-gradient term. Consequently a Fourier flux based
on temperature and a Fick flux based on energy need not agree. The explicit
witness records possible disagreement, not disagreement at every point.
This is a proof-free target for independent source audit.
-/

open Set

namespace NumStability.Leveque02Tracer

/-- Unit-capacity agreement and the general energy-gradient distinction. -/
def thermalDiffusionComparisonTarget : Prop :=
  unitHeatCapacityTarget ∧
  (∀ (temperature : ℝ → ℝ → ℝ) (capacity : ℝ → ℝ)
    (conductivity capacityGradient temperatureGradient x t : ℝ) (spaceDomain : Set ℝ),
    x ∈ spaceDomain → UniqueDiffWithinAt ℝ spaceDomain x →
    HasDerivWithinAt capacity capacityGradient spaceDomain x →
    HasDerivWithinAt (fun z => temperature z t) temperatureGradient spaceDomain x →
    HasDerivWithinAt (fun z => thermalEnergyDensity capacity temperature z t)
      (capacityGradient * temperature x t + capacity x * temperatureGradient) spaceDomain x ∧
    (fourierHeatFlux conductivity temperatureGradient =
      fickFlux conductivity
        (capacityGradient * temperature x t + capacity x * temperatureGradient) ↔
      conductivity * (capacityGradient * temperature x t +
        (capacity x - 1) * temperatureGradient) = 0)) ∧
  (∃ (capacity : ℝ → ℝ) (temperature : ℝ → ℝ → ℝ),
    capacity 0 ≠ capacity 1 ∧
    (∀ x ∈ Ioo (-1 : ℝ) 1, 0 < capacity x) ∧
    (∀ x t, 0 < temperature x t) ∧
    HasDerivAt (fun z => temperature z 0) 0 0 ∧
    HasDerivAt (fun z => thermalEnergyDensity capacity temperature z 0) 1 0 ∧
    fourierHeatFlux 1 0 ≠ fickFlux 1 1)

end NumStability.Leveque02Tracer
