import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Hyperbolicity
import Mathlib.Analysis.Calculus.ContDiff.Defs
import Mathlib.Analysis.SpecialFunctions.Pow.Real

open MeasureTheory Filter
open scoped BigOperators Topology
namespace NumStability.DirectionalQualityRepair

variable {m : ℕ}
local notation "State" => Fin m → ℝ

/-- A genuine local conservation reference, on all space/time subrectangles
of the supplied physical line problem. Values outside this box are unused. -/
def RectangleReferenceOn (q : ℝ → ℝ → State) (flux : State → State)
    (left right horizon : ℝ) : Prop :=
  (∀ t ∈ Set.Icc 0 horizon, IntervalIntegrable (fun x => q x t) volume left right) ∧
  (∀ x ∈ Set.Icc left right, IntervalIntegrable (fun t => flux (q x t)) volume 0 horizon) ∧
  ∀ a ∈ Set.Icc left right, ∀ b ∈ Set.Icc left right,
    ∀ s ∈ Set.Icc 0 horizon, ∀ t ∈ Set.Icc 0 horizon,
      (∫ x in a..b, q x t) - (∫ x in a..b, q x s) =
        ∫ τ in s..t, flux (q a τ) - flux (q b τ)

/-- Smoothness is a fixed mathematical condition, never a caller-chosen
eligibility predicate. The same local conservation law and state domain apply. -/
def SmoothReferenceOn (q : ℝ → ℝ → State) (flux : State → State)
    (states : Set State) (left right horizon : ℝ) : Prop :=
  ContDiffOn ℝ ⊤ (Function.uncurry q) (Set.Icc left right ×ˢ Set.Icc 0 horizon) ∧
  RectangleReferenceOn q flux left right horizon ∧
  ∀ x ∈ Set.Icc left right, ∀ t ∈ Set.Icc 0 horizon, q x t ∈ states

noncomputable def windowVariation (start : ℤ) (count : ℕ) (values : ℤ → State) : ℝ :=
  ∑ k ∈ Finset.range count, ‖values (start + k + 1) - values (start + k)‖

/-- Data of a refining one-dimensional numerical family. The full supplied
line is an input, while the explicit finite input window controls locality.
Its extra entries may be supplied boundary/ghost data. No boundary condition
or automatic admissibility outside the used window is inferred. -/
structure LineFamily (m : ℕ) where
  flux : (Fin m → ℝ) → Fin m → ℝ
  states : Set (Fin m → ℝ)
  hyperbolic : IsHyperbolicFluxOn flux states
  left : ℝ
  right : ℝ
  interval_nonempty : left < right
  horizon : ℝ
  horizon_pos : 0 < horizon
  grid : ℕ → OneDimensionalFiniteVolumeGrid
  mesh : ℕ → ℝ
  mesh_pos : ∀ n, 0 < mesh n
  mesh_tendsto : Tendsto mesh atTop (𝓝 0)
  dt : ℕ → ℝ
  dt_pos : ∀ n, 0 < dt n
  dt_le_horizon : ∀ n, dt n ≤ horizon
  cfl : ℝ
  cfl_pos : 0 < cfl
  activeStart : ℕ → ℤ
  activeCount : ℕ → ℕ
  activeCount_two_le : ∀ n, 2 ≤ activeCount n
  inputStart : ℕ → ℤ
  inputCount : ℕ → ℕ
  input_covers : ∀ n,
    Finset.Ico (activeStart n) (activeStart n + activeCount n) ⊆
      Finset.Ico (inputStart n) (inputStart n + inputCount n)
  input_geometry : ∀ n j, j ∈ Finset.Ico (inputStart n) (inputStart n + inputCount n) →
    left ≤ (grid n).cellLeft j ∧ (grid n).cellRight j ≤ right ∧
    (grid n).cellVolume j ≤ mesh n ∧ dt n ≤ cfl * (grid n).cellVolume j
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
    ∀ q : ℝ → ℝ → State, SmoothReferenceOn q family.flux family.states
      family.left family.right family.horizon →
      ∃ C : ℝ, 0 ≤ C ∧ ∃ N : ℕ, ∀ n, N ≤ n → ∀ values,
        family.InitialProjection n q values → family.admitted n values ∧
        ∀ j ∈ Finset.Ico (family.activeStart n) (family.activeStart n + family.activeCount n),
          ‖family.advance n values j -
            finiteVolumeCellAverageOn (family.grid n) (fun x => q x (family.dt n)) j‖ ≤
              C * family.dt n * (family.mesh n) ^ p
  oscillation : ∃ K : ℝ, 0 ≤ K ∧ ∃ noise : ℕ → ℝ,
    (∀ n, 0 ≤ noise n) ∧ Tendsto noise atTop (𝓝 0) ∧
    ∀ n values, family.admitted n values →
      windowVariation (family.activeStart n) (family.activeCount n - 1) (family.advance n values) ≤
        (1 + K * family.dt n) *
          windowVariation (family.inputStart n) (family.inputCount n - 1) values + family.dt n * noise n

end NumStability.DirectionalQualityRepair

#check NumStability.DirectionalQualityRepair.RectangleReferenceOn
#print axioms NumStability.DirectionalQualityRepair.RectangleReferenceOn
#check NumStability.DirectionalQualityRepair.SmoothReferenceOn
#print axioms NumStability.DirectionalQualityRepair.SmoothReferenceOn
#check NumStability.DirectionalQualityRepair.LineFamily
#print axioms NumStability.DirectionalQualityRepair.LineFamily
#check NumStability.DirectionalQualityRepair.LineFamily.HasControlledHighResolution
#print axioms NumStability.DirectionalQualityRepair.LineFamily.HasControlledHighResolution
