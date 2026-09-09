/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianGridGeometry
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalGeometry
import Mathlib.MeasureTheory.Integral.Pi
import Mathlib.Topology.Instances.Int

/-!
A nonempty finite selection of actual Cartesian cells, shared physical faces and restricted pushforward face measures.
-/

namespace NumStability.FiniteCartesian

open MeasureTheory
open FiniteCoordinate
open scoped BigOperators

variable {D : Type*} [Fintype D] [DecidableEq D] {m : ℕ}

theorem axis_right_eq_next_left (axis : OneDimensionalFiniteVolumeGrid) (j : ℤ) :
    axis.cellRight j = axis.cellLeft (j + 1) := by
  simpa using axis.adjacent (j + 1)

theorem axis_left_strictMono (axis : OneDimensionalFiniteVolumeGrid) :
    StrictMono axis.cellLeft := by
  apply strictMono_int_of_lt_succ
  intro j
  rw [← axis_right_eq_next_left]
  exact axis.cell_nonempty j

theorem axis_index_unique (axis : OneDimensionalFiniteVolumeGrid) {a b : ℤ} {x : ℝ}
    (ha : x ∈ Set.Ico (axis.cellLeft a) (axis.cellRight a))
    (hb : x ∈ Set.Ico (axis.cellLeft b) (axis.cellRight b)) : a = b := by
  have cannot {j k : ℤ} (hj : x ∈ Set.Ico (axis.cellLeft j) (axis.cellRight j))
      (hk : x ∈ Set.Ico (axis.cellLeft k) (axis.cellRight k)) (hjk : j < k) : False := by
    have hle : j + 1 ≤ k := by omega
    have h := (axis_left_strictMono axis).monotone hle
    rw [← axis_right_eq_next_left] at h
    exact (not_lt_of_ge (h.trans hk.1)) hj.2
  rcases lt_trichotomy a b with h | h | h
  · exact False.elim (cannot ha hb h)
  · exact h
  · exact False.elim (cannot hb ha h)

omit [Fintype D] [DecidableEq D] in
theorem cellBox_disjoint (axes : D → OneDimensionalFiniteVolumeGrid)
    {a b : D → ℤ} (hab : a ≠ b) :
    Disjoint (CartesianGrid.cellBox axes a) (CartesianGrid.cellBox axes b) := by
  apply Set.disjoint_left.mpr
  intro x hx hy
  apply hab
  funext d
  exact axis_index_unique (axes d) (hx d (Set.mem_univ d)) (hy d (Set.mem_univ d))

omit [DecidableEq D] in
theorem cellBox_measurable (axes : D → OneDimensionalFiniteVolumeGrid) (cell : D → ℤ) :
    MeasurableSet (CartesianGrid.cellBox axes cell) :=
  MeasurableSet.univ_pi fun _ => measurableSet_Ico

omit [DecidableEq D] in
theorem tangentialFaceBox_measurable (axes : D → OneDimensionalFiniteVolumeGrid)
    (d : D) (face : D → ℤ) : MeasurableSet (CartesianGrid.tangentialFaceBox axes d face) :=
  MeasurableSet.univ_pi fun _ => measurableSet_Ico

/-- The finite-volume cell partition of `D → ℝ` cut out by a nonempty finite set `active` of
Cartesian multi-indices: each active index `cell` is assigned the half-open box
`CartesianGrid.cellBox axes cell`, and the domain is the union of these boxes.  Distinct
indices give disjoint boxes (`cellBox_disjoint`) and every box is measurable
(`cellBox_measurable`). -/
def cells (axes : D → OneDimensionalFiniteVolumeGrid)
    (active : Finset (D → ℤ)) (hne : active.Nonempty) :
    FiniteVolumeCellPartition ↥active (D → ℝ) where
  domain := ⋃ cell : ↥active, CartesianGrid.cellBox axes cell.val
  cellRegion := fun cell => CartesianGrid.cellBox axes cell.val
  cells_nonempty := by
    obtain ⟨cell, hcell⟩ := hne
    exact ⟨⟨cell, hcell⟩⟩
  measurable_cell := fun cell => cellBox_measurable axes cell.val
  disjoint_cells := by
    intro a b hab
    exact cellBox_disjoint axes (fun h => hab (Subtype.ext h))
  covers_domain := by intro point; simp

omit [Fintype D] in
theorem facePoint_measurable (axes : D → OneDimensionalFiniteVolumeGrid)
    (d : D) (face : D → ℤ) : Measurable (CartesianGrid.facePoint axes d face) := by
  apply measurable_pi_lambda
  intro e
  by_cases he : e = d
  · subst e
    simpa only [CartesianGrid.facePoint_normal] using
      (measurable_const : Measurable (fun _ : {e : D // e ≠ d} → ℝ => (axes d).cellLeft (face d)))
  · simpa only [CartesianGrid.facePoint_transverse axes d face _ e he] using
      (measurable_pi_apply (⟨e, he⟩ : {e : D // e ≠ d}))

/-- The surface measure on the face of Cartesian cell `face` normal to axis `d`, as a measure on
the ambient space `D → ℝ`: Lebesgue measure on the tangential coordinates, restricted to
`CartesianGrid.tangentialFaceBox axes d face`, pushed forward along the embedding
`CartesianGrid.facePoint axes d face` that fixes the `d`-th coordinate at the left endpoint of the
cell.  Its total mass is the face area (`faceMeasure_area`). -/
noncomputable def faceMeasure (axes : D → OneDimensionalFiniteVolumeGrid)
    (d : D) (face : D → ℤ) : Measure (D → ℝ) :=
  Measure.map (CartesianGrid.facePoint axes d face)
    (volume.restrict (CartesianGrid.tangentialFaceBox axes d face))

omit [Fintype D] in
theorem left_face_in_closure (axes : D → OneDimensionalFiniteVolumeGrid)
    (d : D) (cell : D → ℤ) (point : {e : D // e ≠ d} → ℝ)
    (hp : point ∈ CartesianGrid.tangentialFaceBox axes d cell) :
    CartesianGrid.facePoint axes d cell point ∈ closure (CartesianGrid.cellBox axes cell) := by
  apply mem_closure_pi.mpr
  intro e _
  rw [closure_Ico ((axes e).cell_nonempty (cell e)).ne]
  by_cases he : e = d
  · subst e
    rw [CartesianGrid.facePoint_normal]
    exact ⟨le_rfl, (axes d).cell_nonempty (cell d) |>.le⟩
  · rw [CartesianGrid.facePoint_transverse axes d cell point e he]
    exact ⟨(hp ⟨e, he⟩ (by trivial)).1, (hp ⟨e, he⟩ (by trivial)).2.le⟩

omit [Fintype D] in
theorem right_face_in_closure (axes : D → OneDimensionalFiniteVolumeGrid)
    (d : D) (cell : D → ℤ) (point : {e : D // e ≠ d} → ℝ)
    (hp : point ∈ CartesianGrid.tangentialFaceBox axes d
      (Function.update cell d (cell d + 1))) :
    CartesianGrid.facePoint axes d (Function.update cell d (cell d + 1)) point ∈
      closure (CartesianGrid.cellBox axes cell) := by
  rw [CartesianGrid.tangentialFaceBox_update] at hp
  apply mem_closure_pi.mpr
  intro e _
  rw [closure_Ico ((axes e).cell_nonempty (cell e)).ne]
  by_cases he : e = d
  · subst e
    rw [CartesianGrid.facePoint_normal, ← CartesianGrid.shared_face_position]
    exact ⟨(axes d).cell_nonempty (cell d) |>.le, le_rfl⟩
  · rw [CartesianGrid.facePoint_transverse axes d _ point e he]
    exact ⟨(hp ⟨e, he⟩ (by trivial)).1, (hp ⟨e, he⟩ (by trivial)).2.le⟩

theorem left_face_ae_incidence (axes : D → OneDimensionalFiniteVolumeGrid)
    (d : D) (cell : D → ℤ) :
    ∀ᵐ point ∂faceMeasure axes d cell, point ∈ closure (CartesianGrid.cellBox axes cell) := by
  apply (ae_map_iff (facePoint_measurable axes d cell).aemeasurable
    isClosed_closure.measurableSet).2
  filter_upwards [ae_restrict_mem (tangentialFaceBox_measurable axes d cell)] with point hp
  exact left_face_in_closure axes d cell point hp

theorem right_face_ae_incidence (axes : D → OneDimensionalFiniteVolumeGrid)
    (d : D) (cell : D → ℤ) :
    ∀ᵐ point ∂faceMeasure axes d (Function.update cell d (cell d + 1)),
      point ∈ closure (CartesianGrid.cellBox axes cell) := by
  apply (ae_map_iff (facePoint_measurable axes d _).aemeasurable
    isClosed_closure.measurableSet).2
  filter_upwards [ae_restrict_mem (tangentialFaceBox_measurable axes d _)] with point hp
  exact right_face_in_closure axes d cell point hp

/-- The `PhysicalData` instance of a nonempty finite selection `active` of Cartesian cells under
Lebesgue measure.  Faces are identified by multi-indices: the left face of a cell in direction `d`
is the cell's own index and its right face is the index with the `d`-th entry incremented, so
adjacent cells share one face ID (`data_shared_face`).  Face measures are the pushforward measures
`faceMeasure`, face points are ambient points, and the normal flux along axis `d` is the
direction-wise flux `flux d`, hyperbolic on `states d` by `hflux d`. -/
noncomputable def data (axes : D → OneDimensionalFiniteVolumeGrid)
    (active : Finset (D → ℤ)) (hne : active.Nonempty)
    (states : D → Set (Fin m → ℝ)) (flux : D → (Fin m → ℝ) → Fin m → ℝ)
    (hflux : ∀ d, IsHyperbolicFluxOn (flux d) (states d)) :
    PhysicalData D ↥active (D → ℤ) (D → ℝ) (D → ℝ) m where
  cells := cells axes active hne
  measure := volume
  positive := by
    intro cell
    have h := CartesianGrid.cellVolume_pos axes cell.val
    rw [← CartesianGrid.cellBox_volume] at h
    exact (ENNReal.toReal_pos_iff.mp h).1.ne'
  finite := by
    intro cell
    have h := CartesianGrid.cellVolume_pos axes cell.val
    rw [← CartesianGrid.cellBox_volume] at h
    exact (ENNReal.toReal_pos_iff.mp h).2.ne
  leftFace := fun _ cell => cell.val
  rightFace := fun d cell => Function.update cell.val d (cell.val d + 1)
  faceMeasure := faceMeasure axes
  facePoint := fun _ _ point => point
  left_incidence := fun d cell => left_face_ae_incidence axes d cell.val
  right_incidence := fun d cell => right_face_ae_incidence axes d cell.val
  admissibleStates := states
  normalFlux := fun d _ _ => flux d
  hyperbolic := fun d _ _ => hflux d

theorem data_cell_measure (axes : D → OneDimensionalFiniteVolumeGrid)
    (active : Finset (D → ℤ)) (hne : active.Nonempty)
    (states : D → Set (Fin m → ℝ)) (flux : D → (Fin m → ℝ) → Fin m → ℝ)
    (hflux : ∀ d, IsHyperbolicFluxOn (flux d) (states d)) (cell : ↥active) :
    (data axes active hne states flux hflux).measure.restrict
      ((data axes active hne states flux hflux).cells.cellRegion cell) =
      volume.restrict (CartesianGrid.cellBox axes cell.val) := rfl

theorem data_cellVolume (axes : D → OneDimensionalFiniteVolumeGrid)
    (active : Finset (D → ℤ)) (hne : active.Nonempty)
    (states : D → Set (Fin m → ℝ)) (flux : D → (Fin m → ℝ) → Fin m → ℝ)
    (hflux : ∀ d, IsHyperbolicFluxOn (flux d) (states d)) (cell : ↥active) :
    (data axes active hne states flux hflux).cellVolume cell =
      CartesianGrid.cellVolume axes cell.val := CartesianGrid.cellBox_volume axes cell.val

theorem data_face_measure (axes : D → OneDimensionalFiniteVolumeGrid)
    (active : Finset (D → ℤ)) (hne : active.Nonempty)
    (states : D → Set (Fin m → ℝ)) (flux : D → (Fin m → ℝ) → Fin m → ℝ)
    (hflux : ∀ d, IsHyperbolicFluxOn (flux d) (states d)) (d : D) (face : D → ℤ) :
    Measure.map ((data axes active hne states flux hflux).facePoint d face)
      ((data axes active hne states flux hflux).faceMeasure d face) =
      Measure.map (CartesianGrid.facePoint axes d face)
        (volume.restrict (CartesianGrid.tangentialFaceBox axes d face)) := by
  exact Measure.map_id

theorem data_shared_face (axes : D → OneDimensionalFiniteVolumeGrid)
    (active : Finset (D → ℤ)) (hne : active.Nonempty)
    (states : D → Set (Fin m → ℝ)) (flux : D → (Fin m → ℝ) → Fin m → ℝ)
    (hflux : ∀ d, IsHyperbolicFluxOn (flux d) (states d))
    (d : D) (left right : ↥active)
    (hadjacent : right.val = Function.update left.val d (left.val d + 1)) :
    (data axes active hne states flux hflux).rightFace d left =
      (data axes active hne states flux hflux).leftFace d right := hadjacent.symm

theorem data_left_position (axes : D → OneDimensionalFiniteVolumeGrid)
    (active : Finset (D → ℤ)) (hne : active.Nonempty)
    (states : D → Set (Fin m → ℝ)) (flux : D → (Fin m → ℝ) → Fin m → ℝ)
    (hflux : ∀ d, IsHyperbolicFluxOn (flux d) (states d)) (d : D) (cell : ↥active) :
    (data axes active hne states flux hflux).leftFace d cell = cell.val := rfl

theorem data_right_position (axes : D → OneDimensionalFiniteVolumeGrid)
    (active : Finset (D → ℤ)) (hne : active.Nonempty)
    (states : D → Set (Fin m → ℝ)) (flux : D → (Fin m → ℝ) → Fin m → ℝ)
    (hflux : ∀ d, IsHyperbolicFluxOn (flux d) (states d)) (d : D) (cell : ↥active) :
    (data axes active hne states flux hflux).rightFace d cell =
      Function.update cell.val d (cell.val d + 1) := rfl

theorem data_face_measurable (axes : D → OneDimensionalFiniteVolumeGrid)
    (active : Finset (D → ℤ)) (hne : active.Nonempty)
    (states : D → Set (Fin m → ℝ)) (flux : D → (Fin m → ℝ) → Fin m → ℝ)
    (hflux : ∀ d, IsHyperbolicFluxOn (flux d) (states d)) (d : D) (face : D → ℤ) :
    AEMeasurable ((data axes active hne states flux hflux).facePoint d face)
      ((data axes active hne states flux hflux).faceMeasure d face) := measurable_id.aemeasurable

theorem data_normal_flux (axes : D → OneDimensionalFiniteVolumeGrid)
    (active : Finset (D → ℤ)) (hne : active.Nonempty)
    (states : D → Set (Fin m → ℝ)) (flux : D → (Fin m → ℝ) → Fin m → ℝ)
    (hflux : ∀ d, IsHyperbolicFluxOn (flux d) (states d)) (d : D) (face : D → ℤ) :
    ∀ᵐ point ∂(data axes active hne states flux hflux).faceMeasure d face,
      ∀ value, (data axes active hne states flux hflux).normalFlux d face point value = flux d value := by
  exact Filter.Eventually.of_forall fun _ _ => rfl

theorem faceMeasure_area (axes : D → OneDimensionalFiniteVolumeGrid)
    (d : D) (face : D → ℤ) :
    (faceMeasure axes d face Set.univ).toReal = CartesianGrid.faceArea axes d face := by
  rw [faceMeasure, Measure.map_apply_of_aemeasurable
    (facePoint_measurable axes d face).aemeasurable MeasurableSet.univ]
  simpa using CartesianGrid.tangentialFaceBox_volume axes d face

end NumStability.FiniteCartesian

