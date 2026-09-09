/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CapacityCoordinateMethod
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineVariation
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalFluxError
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalCellMesh
import Mathlib.Analysis.Calculus.ContDiff.Defs
import Mathlib.Analysis.Calculus.ContDiff.FTaylorSeries

/-!
# High-resolution quality for refining physical meshes

A fixed physical measure, state domain and tensor flux are bound to each actual
refining mesh and supplied normal flux. References obey supplied measured directional
balances; tensor/normal data alone do not establish a continuum PDE equivalence.
Genuine C-infinity uses the inner ENat infinity explicitly. One reference certificate
has a fixed constant and threshold before every later level and admitted time step.
Positive input-step availability and quantitative oscillation control form core quality;
pairwise stability is a separate assumption of the perturbation theorem.
Boundary projections are normalized means on actual supplied regions. The zero-flux
quality theorem covers the full reference class, without selecting a profile predicate.
-/

namespace NumStability.PhysicalRefinementQuality
open MeasureTheory Filter NumStability NumStability.FiniteCoordinate
open scoped BigOperators Topology
variable {D FacePoint : Type*} [Fintype D] [MeasurableSpace FacePoint] {m : ℕ}
local notation "Point" => D → ℝ
local notation "State" => Fin m → ℝ

/-- A refining family of actual physical meshes and supplied conservative
methods. Single-grid execution does not require this structure. The fixed
physical flux and state domain are shared by every level; normals are supplied
geometric data, and no hyperbolicity of an integrated flux is inferred. -/
structure Family (D FacePoint : Type*) [Fintype D] [MeasurableSpace FacePoint] (m : ℕ) where
  Cell : ℕ → Type
  Face : ℕ → Type
  Line : ℕ → Type
  finiteCell : ∀ n, Fintype (Cell n)
  data : ∀ n, PhysicalData D (Cell n) (Face n) (D → ℝ) FacePoint m
  coordinates : ∀ n, LineCoordinates (m := m) D (Cell n) (Face n) (Line n)
  method : ∀ n, NumStability.CapacityCoordinate.Method (data n) (coordinates n)
  measure : Measure (D → ℝ)
  measure_eq : ∀ n, (data n).measure = measure
  states : D → Set (Fin m → ℝ)
  states_nonempty : ∀ d, (states d).Nonempty
  states_eq : ∀ n d, (data n).admissibleStates d = states d
  physicalFlux : (D → ℝ) → (Fin m → ℝ) → D → Fin m → ℝ
  normal : ∀ n, D → Face n → FacePoint → D → ℝ
  normal_flux_eq : ∀ n d face point state,
    (data n).normalFlux d face point state =
      ∑ k, normal n d face point k • physicalFlux ((data n).facePoint d face point) state k
  region : Set (D → ℝ)
  target : Set (D → ℝ)
  target_interior_nonempty : (interior target).Nonempty
  target_inside : target ⊆ region
  active_inside : ∀ n cell, (data n).cells.cellRegion cell ⊆ region
  target_covered : ∀ n x, x ∈ target → ∃ cell, x ∈ (data n).cells.cellRegion cell
  bounded_cells : ∀ n cell, Bornology.IsBounded ((data n).cells.cellRegion cell)
  mesh : ℕ → ℝ
  mesh_actual : ∀ n, mesh n = (by
    letI := finiteCell n
    exact NumStability.FiniteVolumeCellPartition.mesh (data n).cells)
  mesh_pos : ∀ n, 0 < mesh n
  mesh_tendsto : Tendsto mesh atTop (𝓝 0)
  horizon : ℝ
  horizon_pos : 0 < horizon
  boundaryRegion : ∀ n, D → Line n → ℤ → Set (D → ℝ)
  boundary_measurable : ∀ n d line j, MeasurableSet (boundaryRegion n d line j)
  boundary_positive : ∀ n d line j, measure (boundaryRegion n d line j) ≠ 0
  boundary_finite : ∀ n d line j, measure (boundaryRegion n d line j) ≠ ⊤
  boundary_inside : ∀ n d line j, boundaryRegion n d line j ⊆ region

variable (family : Family D FacePoint m)

namespace Family

/-- Exact reference boundary data are measured averages of the supplied
boundary regions. They are inputs, not fictitious active physical cells. -/
noncomputable def referenceGhost (n : ℕ) (q : Point → ℝ → State) :
    D → family.Line n → ℤ → State :=
  fun d line j => cellVolumeAverage family.measure (family.boundaryRegion n d line j)
    (fun x => q x 0)

noncomputable def projected (n : ℕ) (q : Point → ℝ → State) (t : ℝ) : family.Cell n → State :=
  fun cell => (family.data n).cellMean q cell t

/-- Genuine smoothness includes incident boundary points. The reference is
fixed before the refinement level and obeys the same measured physical law
at every level. Boundary integrability is stated separately and explicitly. -/
def SmoothReference (d : D) (q : Point → ℝ → State) : Prop :=
  ContDiffOn ℝ ((⊤ : ℕ∞) : WithTop ℕ∞) (Function.uncurry q)
    (closure family.region ×ˢ Set.Icc 0 family.horizon) ∧
  (∀ n, (family.data n).ReferenceOn d q 0 family.horizon) ∧
  (∀ n line j, IntegrableOn (fun x => q x 0)
    (family.boundaryRegion n d line j) family.measure)

/-- One physical reference, one constant and one threshold. The certificate
is chosen before any later mesh level, time step or coordinate execution. -/
structure AccuracyCertificate (d : D) (q : Point → ℝ → State) (p : ℝ) where
  constant : ℝ
  constant_nonneg : 0 ≤ constant
  threshold : ℕ
  projection_available : ∀ n, threshold ≤ n → ∃ dt : ℝ,
    0 < dt ∧ dt ≤ family.horizon ∧
      ((family.method n).withGhost (family.referenceGhost n q)).Admitted d dt
        (family.projected n q 0)
  bound : ∀ n, threshold ≤ n → ∀ dt : ℝ, 0 < dt → dt ≤ family.horizon →
    ((family.method n).withGhost (family.referenceGhost n q)).Admitted d dt
      (family.projected n q 0) → ∀ cell,
    ‖advance (family.data n) ((family.method n).withGhost (family.referenceGhost n q)).rule
        d dt (family.projected n q 0) cell - family.projected n q dt cell‖ ≤
      constant * dt * family.mesh n ^ p

/-- Quantitative variation along actual coordinate adjacency. Each internal
edge is counted once as a left edge; a right exterior edge is added only when
the next physical lookup is absent. Both boundary sides are retained. -/
noncomputable def variation (n : ℕ) (d : D) (line : family.Line n)
    (ghost : D → family.Line n → ℤ → State) (current : family.Cell n → State) : ℝ := by
  letI := family.finiteCell n
  exact NumStability.FiniteCoordinate.LineCoordinates.onceEdgeVariation
    (family.coordinates n) d line ghost current

/-- Core quality contains higher smooth order, quantitative oscillation
control and a nonempty time-step domain for every admissible physical input.
It imposes no pairwise perturbation stability and no fixed CFL coefficient. -/
structure HasHighResolution : Prop where
  input_available : ∀ n d (ghost : D → family.Line n → ℤ → State)
    (current : family.Cell n → State),
    (∀ cell, current cell ∈ family.states d) →
    (∀ line j, (family.coordinates n).lookup d line j = none → ghost d line j ∈ family.states d) →
    ∃ dt : ℝ, 0 < dt ∧ dt ≤ family.horizon ∧
      ((family.method n).withGhost ghost).Admitted d dt current
  order : ∀ d, ∃ p : ℝ, 1 < p ∧ ∀ q : Point → ℝ → State,
    family.SmoothReference d q → Nonempty (family.AccuracyCertificate d q p)
  oscillation : ∀ d, ∃ K : ℝ, 0 ≤ K ∧ ∃ noise : ℕ → ℝ,
    (∀ n, 0 ≤ noise n) ∧ Tendsto noise atTop (𝓝 0) ∧
    ∀ n (ghost : D → family.Line n → ℤ → State) (current : family.Cell n → State)
      (dt : ℝ), 0 < dt → dt ≤ family.horizon →
      ((family.method n).withGhost ghost).Admitted d dt current → ∀ line,
      family.variation n d line ghost
          (advance (family.data n) ((family.method n).withGhost ghost).rule d dt current) ≤
        (1 + K * dt) * family.variation n d line ghost current + dt * noise n

/-- Every two-state physical array, with admissible supplied boundary inputs,
has an actual positive admitted step. The side predicate may describe a jump. -/
theorem HasHighResolution.two_state_available (quality : family.HasHighResolution)
    (n : ℕ) (d : D) (ghost : D → family.Line n → ℤ → State)
    (left right : State) (hl : left ∈ family.states d) (hr : right ∈ family.states d)
    (side : family.Cell n → Prop) [DecidablePred side]
    (hg : ∀ line j, (family.coordinates n).lookup d line j = none → ghost d line j ∈ family.states d) :
    ∃ dt : ℝ, 0 < dt ∧ dt ≤ family.horizon ∧
      ((family.method n).withGhost ghost).Admitted d dt (fun cell => if side cell then left else right) := by
  apply quality.input_available n d ghost _ _ hg
  intro cell
  split <;> assumption

/-- The certificate's own fixed threshold admits an exact physical projection.
No selected execution can defeat this assertion by choosing a later threshold. -/
theorem AccuracyCertificate.available_at_threshold {d : D} {q : Point → ℝ → State} {p : ℝ}
    (certificate : family.AccuracyCertificate d q p) :
    ∃ dt : ℝ, 0 < dt ∧ dt ≤ family.horizon ∧
      ((family.method certificate.threshold).withGhost
        (family.referenceGhost certificate.threshold q)).Admitted d dt
          (family.projected certificate.threshold q 0) :=
  certificate.projection_available certificate.threshold le_rfl

/-- Optional stability transfers the same fixed certificate to actual cell
and boundary inputs. Both inputs use the same admitted time step; existence
of a different admissible step does not satisfy these premises. -/
theorem AccuracyCertificate.perturbed_at {d : D} {q : Point → ℝ → State} {p : ℝ}
    (certificate : family.AccuracyCertificate d q p) (n : ℕ) (hn : certificate.threshold ≤ n)
    (dt : ℝ) (hdt : 0 < dt) (hT : dt ≤ family.horizon)
    (ghost : D → family.Line n → ℤ → State) (current : family.Cell n → State)
    (hactual : ((family.method n).withGhost ghost).Admitted d dt current)
    (hprojected : ((family.method n).withGhost (family.referenceGhost n q)).Admitted d dt
      (family.projected n q 0))
    (A E G : ℝ) (hstable : (family.method n).StableAt d dt A)
    (hcell : ∀ cell, ‖current cell - family.projected n q 0 cell‖ ≤ E)
    (hghost : ∀ cell j,
      (family.coordinates n).lookup d ((family.coordinates n).cellLine d cell) j = none →
      ‖ghost d ((family.coordinates n).cellLine d cell) j -
        family.referenceGhost n q d ((family.coordinates n).cellLine d cell) j‖ ≤ G)
    (cell : family.Cell n) :
    ‖advance (family.data n) ((family.method n).withGhost ghost).rule d dt current cell -
      family.projected n q dt cell‖ ≤
        A * max E G + certificate.constant * dt * family.mesh n ^ p := by
  have hs := (family.method n).coordinate_stability_withGhost ghost (family.referenceGhost n q)
    d dt A hstable current (family.projected n q 0) hactual hprojected E G hcell hghost cell
  have ha := certificate.bound n hn dt hdt hT hprojected cell
  exact (norm_sub_le_norm_sub_add_norm_sub _ _ _).trans (add_le_add hs ha)

end Family
end NumStability.PhysicalRefinementQuality


namespace NumStability.PhysicalRefinementQuality.Family
open MeasureTheory Filter NumStability NumStability.FiniteCoordinate
open scoped BigOperators Topology
variable {D FacePoint : Type*} [Fintype D] [MeasurableSpace FacePoint] {m : ℕ}
local notation "Point" => D → ℝ
local notation "State" => Fin m → ℝ

/-- The zero-flux method is a complete core-quality instance on every actual
refinement geometry. The physical reference class remains the entire genuine
smooth class of the shared law; its measured means are constant by conservation. -/
theorem zero_flux_quality (family : Family D FacePoint m)
    (hnum : ∀ n d line dt values j, (family.method n).numericalFlux d line dt values j = 0)
    (hadmit : ∀ n d line dt values, (family.method n).admitted d line dt values)
    (hphysical : ∀ n d face point state, (family.data n).normalFlux d face point state = 0) :
    family.HasHighResolution := by
  have admitted : ∀ n d ghost dt current,
      ((family.method n).withGhost ghost).Admitted d dt current := by
    intro n d ghost dt current cell
    exact hadmit n d _ dt _
  have identity : ∀ n d ghost dt current,
      advance (family.data n) ((family.method n).withGhost ghost).rule d dt current = current := by
    intro n d ghost dt current
    funext cell
    simp [advance, NumStability.CapacityCoordinate.Method.withGhost, NumStability.CapacityCoordinate.Method.rule,
      NumStability.FiniteCoordinate.PhysicalLine.faceRule, hnum, finiteVolumeCellAverageUpdate]
  refine ⟨?_, ?_, ?_⟩
  · intro n d ghost current _ _
    exact ⟨family.horizon, family.horizon_pos, le_rfl,
      admitted n d ghost family.horizon current⟩
  · intro d
    refine ⟨2, by norm_num, ?_⟩
    intro q hq
    refine ⟨{
      constant := 0
      constant_nonneg := le_rfl
      threshold := 0
      projection_available := ?_
      bound := ?_ }⟩
    · intro n _
      exact ⟨family.horizon, family.horizon_pos, le_rfl,
        admitted n d (family.referenceGhost n q) family.horizon (family.projected n q 0)⟩
    · intro n _ dt hdt hT _ cell
      rw [identity]
      have hface : ∀ face τ, (family.data n).faceFlux d q face τ = 0 :=
        fun face τ => NumStability.FiniteCoordinate.faceFlux_eq_zero (family.data n) d (hphysical n d) q face τ
      have hmean := NumStability.FiniteCoordinate.cellMean_eq_of_faceFlux_zero (family.data n) d q (hq.2.1 n) hface
        Set.left_mem_uIcc (Set.mem_uIcc_of_le hdt.le hT) cell
      change ‖(family.data n).cellMean q cell 0 - (family.data n).cellMean q cell dt‖ ≤ _
      rw [hmean]
      simp
  · intro d
    refine ⟨0, le_rfl, fun _ => 0, fun _ => le_rfl, tendsto_const_nhds, ?_⟩
    intro n ghost current dt _ _ _ line
    rw [identity]
    simp

/-- The zero-flux family's perturbation stability is proved separately from
core quality. No stability requirement has been inserted into that definition. -/
theorem zero_flux_stable (family : Family D FacePoint m)
    (hnum : ∀ n d line dt values j, (family.method n).numericalFlux d line dt values j = 0)
    (n : ℕ) (d : D) (dt : ℝ) : (family.method n).StableAt d dt 1 := by
  intro cell values other _ _ E _ herr
  simpa [NumStability.FiniteCoordinate.PhysicalLine.lineAdvance, hnum, finiteVolumeCellAverageUpdate] using
    herr ((family.coordinates n).cellIndex d cell)

end NumStability.PhysicalRefinementQuality.Family
