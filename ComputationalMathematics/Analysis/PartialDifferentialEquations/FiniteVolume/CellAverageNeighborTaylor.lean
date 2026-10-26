/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage
import ComputationalMathematics.Analysis.Calculus.FirstOrderTaylor

/-!
# Neighboring exact cell averages

For a smooth profile with Lipschitz derivative, neighboring fixed-width
cell averages have second-order Taylor expansions about the center
average. The first derivative is the profile's face-difference slope.
-/

namespace NumStability

/-- Both neighboring exact cell averages differ from the center
linearization by at most a quadratic term. -/
theorem oneDimensionalCellAverage_neighborTaylor
    (f f' : ℝ → ℝ) (K center width : ℝ)
    (hK : 0 ≤ K) (hwidth : 0 < width)
    (hf : ∀ x, HasDerivAt f (f' x) x)
    (hLip : ∀ x y, |f' x - f' y| ≤ K * |x - y|) :
    let avg : ℝ → ℝ := fun c =>
      oneDimensionalCellAverage f (c - width / 2) (c + width / 2)
    let slope := (f (center + width / 2) -
      f (center - width / 2)) / width
    |avg (center - width) - (avg center - width * slope)| ≤
        K * width ^ 2 ∧
      |avg (center + width) - (avg center + width * slope)| ≤
        K * width ^ 2 := by
  let avg : ℝ → ℝ := fun c =>
    oneDimensionalCellAverage f (c - width / 2) (c + width / 2)
  let slope : ℝ → ℝ := fun c =>
    (f (c + width / 2) - f (c - width / 2)) / width
  have hcont : Continuous f :=
    continuous_iff_continuousAt.mpr (fun x => (hf x).continuousAt)
  have hAvg : ∀ c, HasDerivAt avg (slope c) c := by
    intro c
    exact oneDimensionalCellAverage_hasDerivAt_center
      f width c hcont hwidth
  have hSlopeLip : ∀ x y, |slope x - slope y| ≤ K * |x - y| := by
    intro x y
    exact oneDimensionalCellAverage_faceSlope_lipschitz
      f f' K width x y hwidth hf hLip
  have hleft := firstOrderTaylorError_le_of_lipschitzDeriv
    avg slope K center (center - width) hK hAvg hSlopeLip
  have hright := firstOrderTaylorError_le_of_lipschitzDeriv
    avg slope K center (center + width) hK hAvg hSlopeLip
  change
    |avg (center - width) - (avg center - width * slope center)| ≤
        K * width ^ 2 ∧
      |avg (center + width) - (avg center + width * slope center)| ≤
        K * width ^ 2
  constructor
  · have hid : avg center + slope center * (center - width - center) =
        avg center - width * slope center := by ring
    rw [hid] at hleft
    have hpow : K * (center - width - center) ^ 2 = K * width ^ 2 := by ring
    rw [hpow] at hleft
    exact hleft
  · have hid : avg center + slope center * (center + width - center) =
        avg center + width * slope center := by ring
    rw [hid] at hright
    have hpow : K * (center + width - center) ^ 2 = K * width ^ 2 := by ring
    rw [hpow] at hright
    exact hright

end NumStability
