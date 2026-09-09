/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Hyperbolicity
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.LocalRectangleReference
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface
import Mathlib.Analysis.SpecialFunctions.Pow.Real

/-!
Refining full-line finite-volume families with actual mesh comparability, fixed-region coverage, uniform smooth-reference order, perturbation stability and oscillation control.
-/

open MeasureTheory Filter
open scoped BigOperators Topology
namespace NumStability.DirectionalLine
open NumStability.LocalConservationLaw
variable {m : ℕ}
local notation "State" => Fin m → ℝ
noncomputable def windowVariation (start : ℤ) (count : ℕ) (values : ℤ → State) : ℝ :=
  ∑ k ∈ Finset.range count, ‖values (start + k + 1) - values (start + k)‖

/-- Data of a refining one-dimensional numerical family. The full supplied
line is an input, while the explicit finite input window controls locality.
Its extra entries may be supplied boundary/ghost data. No boundary condition
or automatic admissibility outside the used window is inferred. -/
structure LineFamily (m : ℕ) where
  flux : ℝ → (Fin m → ℝ) → Fin m → ℝ
  states : Set (Fin m → ℝ)
  left : ℝ
  right : ℝ
  interval_nonempty : left < right
  hyperbolic : ∀ x ∈ Set.Icc left right, IsHyperbolicFluxOn (flux x) states
  horizon : ℝ
  horizon_pos : 0 < horizon
  grid : ℕ → OneDimensionalFiniteVolumeGrid
  mesh : ℕ → ℝ
  mesh_pos : ∀ n, 0 < mesh n
  mesh_tendsto : Tendsto mesh atTop (𝓝 0)
  meshRatio : ℝ
  meshRatio_pos : 0 < meshRatio
  dt : ℕ → ℝ
  dt_pos : ∀ n, 0 < dt n
  dt_le_horizon : ∀ n, dt n ≤ horizon
  cfl : ℝ
  cfl_pos : 0 < cfl
  activeStart : ℕ → ℤ
  activeCount : ℕ → ℕ
  activeCount_two_le : ∀ n, 2 ≤ activeCount n
  targetLeft : ℝ
  targetRight : ℝ
  target_nonempty : targetLeft < targetRight
  target_inside : left < targetLeft ∧ targetRight < right
  active_coverage : ∀ n x, x ∈ Set.Icc targetLeft targetRight →
    ∃ j ∈ Finset.Ico (activeStart n) (activeStart n + activeCount n),
      x ∈ Set.Icc ((grid n).cellLeft j) ((grid n).cellRight j)
  inputStart : ℕ → ℤ
  inputCount : ℕ → ℕ
  input_covers : ∀ n,
    Finset.Ico (activeStart n) (activeStart n + activeCount n) ⊆
      Finset.Ico (inputStart n) (inputStart n + inputCount n)
  input_geometry : ∀ n j, j ∈ Finset.Ico (inputStart n) (inputStart n + inputCount n) →
    left ≤ (grid n).cellLeft j ∧ (grid n).cellRight j ≤ right ∧
    (grid n).cellVolume j ≤ mesh n ∧ dt n ≤ cfl * (grid n).cellVolume j
  mesh_comparable : ∀ n j, j ∈ Finset.Ico (inputStart n) (inputStart n + inputCount n) →
    mesh n ≤ meshRatio * (grid n).cellVolume j
  numericalFlux : ℕ → (ℤ → Fin m → ℝ) → ℤ → Fin m → ℝ
  admitted : ℕ → (ℤ → Fin m → ℝ) → Prop
  line_local : ∀ n (q other : ℤ → Fin m → ℝ),
    (∀ j ∈ Finset.Ico (inputStart n) (inputStart n + inputCount n), q j = other j) →
    ∀ j ∈ Finset.Icc (activeStart n) (activeStart n + activeCount n),
      numericalFlux n q j = numericalFlux n other j

noncomputable def LineFamily.advance (family : LineFamily m) (n : ℕ) (values : ℤ → State)
    (j : ℤ) : State := riemannFiniteVolumeUpdate (family.grid n) (family.dt n) values
      (family.numericalFlux n values) j

def LineFamily.InitialProjection (family : LineFamily m) (n : ℕ)
    (q : ℝ → ℝ → State) (values : ℤ → State) : Prop :=
  ∀ j ∈ Finset.Ico (family.inputStart n) (family.inputStart n + family.inputCount n),
    values j = finiteVolumeCellAverageOn (family.grid n) (fun x => q x 0) j

/-- The adopted quality convention has uniform refinement content.
Accuracy concerns every actual smooth local reference and its exact projected
inputs. Constants cannot be chosen after each mesh or as an output error norm.
Oscillation control uses the incoming finite window, including boundary data,
with uniform amplification and a vanishing additive rate. Exact TVD is a
stronger sufficient instance, not a restriction on every supplied family. -/
structure LineFamily.HasControlledHighResolution (family : LineFamily m) : Prop where
  order : ∃ p : ℝ, 1 < p ∧
    ∀ q : ℝ → ℝ → State, SpatialSmoothReferenceOn q family.flux family.states
      family.left family.right family.horizon →
      ∃ C : ℝ, 0 ≤ C ∧ ∃ N : ℕ, ∀ n, N ≤ n → ∀ values,
        family.InitialProjection n q values → family.admitted n values ∧
        ∀ j ∈ Finset.Ico (family.activeStart n) (family.activeStart n + family.activeCount n),
          ‖family.advance n values j -
            finiteVolumeCellAverageOn (family.grid n) (fun x => q x (family.dt n)) j‖ ≤
              C * family.dt n * (family.mesh n) ^ p
  stability : ∃ L : ℝ, 0 ≤ L ∧ ∀ n values other, family.admitted n values →
    family.admitted n other → ∀ E : ℝ, 0 ≤ E →
    (∀ j ∈ Finset.Ico (family.inputStart n) (family.inputStart n + family.inputCount n),
      ‖values j - other j‖ ≤ E) →
    ∀ j ∈ Finset.Ico (family.activeStart n) (family.activeStart n + family.activeCount n),
      ‖family.advance n values j - family.advance n other j‖ ≤ (1 + L * family.dt n) * E
  oscillation : ∃ K : ℝ, 0 ≤ K ∧ ∃ noise : ℕ → ℝ,
    (∀ n, 0 ≤ noise n) ∧ Tendsto noise atTop (𝓝 0) ∧
    ∀ n values, family.admitted n values →
      windowVariation (family.activeStart n) (family.activeCount n - 1) (family.advance n values) ≤
        (1 + K * family.dt n) *
          windowVariation (family.inputStart n) (family.inputCount n - 1) values + family.dt n * noise n

/-- Stability transfers the smooth-reference consistency estimate to actual
perturbed inputs. The supplied exterior entries participate in the incoming
error bound; no boundary accuracy is silently inferred. -/
theorem LineFamily.HasControlledHighResolution.perturbed_accuracy
    (family : LineFamily m) (quality : family.HasControlledHighResolution) :
    ∃ p L : ℝ, 1 < p ∧ 0 ≤ L ∧ ∀ q : ℝ → ℝ → State,
      SpatialSmoothReferenceOn q family.flux family.states family.left family.right family.horizon →
      ∃ C : ℝ, 0 ≤ C ∧ ∃ N : ℕ, ∀ n, N ≤ n → ∀ projected values,
        family.InitialProjection n q projected → family.admitted n values →
        ∀ E : ℝ, 0 ≤ E →
        (∀ j ∈ Finset.Ico (family.inputStart n) (family.inputStart n + family.inputCount n),
          ‖values j - projected j‖ ≤ E) →
        ∀ j ∈ Finset.Ico (family.activeStart n) (family.activeStart n + family.activeCount n),
          ‖family.advance n values j -
            finiteVolumeCellAverageOn (family.grid n) (fun x => q x (family.dt n)) j‖ ≤
            (1 + L * family.dt n) * E + C * family.dt n * (family.mesh n) ^ p := by
  obtain ⟨p, hp, accuracy⟩ := quality.order
  obtain ⟨L, hL, stability⟩ := quality.stability
  refine ⟨p, L, hp, hL, ?_⟩
  intro q hq
  obtain ⟨C, hC, N, hacc⟩ := accuracy q hq
  refine ⟨C, hC, N, ?_⟩
  intro n hn projected values hproj hvalues E hE herr j hj
  have ha := hacc n hn projected hproj
  exact (norm_sub_le_norm_sub_add_norm_sub (family.advance n values j) (family.advance n projected j)
    (finiteVolumeCellAverageOn (family.grid n) (fun x => q x (family.dt n)) j)).trans
      (add_le_add (stability n values projected hvalues ha.1 E hE herr j hj) (ha.2 j hj))

noncomputable def LineFamily.stabilityRate (family : LineFamily m)
    (quality : family.HasControlledHighResolution) : ℝ :=
  (Classical.indefiniteDescription (fun L : ℝ => 0 ≤ L ∧ ∀ n values other,
    family.admitted n values → family.admitted n other → ∀ E : ℝ, 0 ≤ E →
    (∀ j ∈ Finset.Ico (family.inputStart n) (family.inputStart n + family.inputCount n),
      ‖values j - other j‖ ≤ E) →
    ∀ j ∈ Finset.Ico (family.activeStart n) (family.activeStart n + family.activeCount n),
      ‖family.advance n values j - family.advance n other j‖ ≤ (1 + L * family.dt n) * E)
    quality.stability).val

theorem LineFamily.stabilityRate_spec (family : LineFamily m)
    (quality : family.HasControlledHighResolution) :
    0 ≤ family.stabilityRate quality ∧ ∀ n values other, family.admitted n values →
      family.admitted n other → ∀ E : ℝ, 0 ≤ E →
      (∀ j ∈ Finset.Ico (family.inputStart n) (family.inputStart n + family.inputCount n),
        ‖values j - other j‖ ≤ E) →
      ∀ j ∈ Finset.Ico (family.activeStart n) (family.activeStart n + family.activeCount n),
        ‖family.advance n values j - family.advance n other j‖ ≤
          (1 + family.stabilityRate quality * family.dt n) * E :=
  Classical.choose_spec quality.stability

end NumStability.DirectionalLine
