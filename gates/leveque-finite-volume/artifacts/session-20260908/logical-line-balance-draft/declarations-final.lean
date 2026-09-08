import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxDifference
import ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting

/-!+# Supplied-volume conservative coordinate lines

Scratch algebraic specialization. Cells have indices `D → ℤ`. A face is indexed
by its direction and its right cell, so both incident cells use one value.
The numerical normal flux supplied here includes the face-area factor. No
physical chart, normal, area, volume measure, accuracy, or source convention
is inferred from these indices. Positive physical volumes are supplied data.
-/

open scoped BigOperators

namespace NumStability.LogicalLineBalanceDraft

variable {D E : Type*} [DecidableEq D] [AddCommGroup E] [Module ℝ E]

/-- The rule reads the actual coordinate line through the indexed shared face.
Its `E`-valued output is the supplied oriented, area-integrated normal flux. -/
def normalFaceFlux
    (rule : D → (D → ℤ) → ℝ → (ℤ → E) → E)
    (d : D) (dt : ℝ) (state : (D → ℤ) → E) (rightCell : D → ℤ) : E :=
  rule d rightCell dt (fun j => state (Function.update rightCell d j))

/-- The right face of a cell is the left face of its coordinate successor. -/
def netOutwardFlux (rule : D → (D → ℤ) → ℝ → (ℤ → E) → E)
    (d : D) (dt : ℝ) (state : (D → ℤ) → E) (cell : D → ℤ) : E :=
  normalFaceFlux rule d dt state (Function.update cell d (cell d + 1)) -
    normalFaceFlux rule d dt state cell

/-- One conservative coordinate-direction update with the supplied physical volume. -/
noncomputable def advance (volume : (D → ℤ) → ℝ)
    (rule : D → (D → ℤ) → ℝ → (ℤ → E) → E)
    (d : D) (dt : ℝ) (state : (D → ℤ) → E) (cell : D → ℤ) : E :=
  finiteVolumeCellAverageUpdate dt (volume cell) (state cell)
    (netOutwardFlux rule d dt state cell)

/-- The cell-total formula is a direct instance of the existing generic theorem. -/
theorem advance_mass_balance (volume : (D → ℤ) → ℝ)
    (hvolume : ∀ cell, 0 < volume cell)
    (rule : D → (D → ℤ) → ℝ → (ℤ → E) → E)
    (d : D) (dt : ℝ) (state : (D → ℤ) → E) (cell : D → ℤ) :
    volume cell • advance volume rule d dt state cell =
      volume cell • state cell - dt • netOutwardFlux rule d dt state cell :=
  cellVolume_smul_finiteVolumeCellAverageUpdate _ _ _ _ (hvolume cell).ne'

/-- No values outside this coordinate line can affect its updated states. -/
theorem advance_line_local (volume : (D → ℤ) → ℝ)
    (rule : D → (D → ℤ) → ℝ → (ℤ → E) → E)
    (d : D) (dt : ℝ) (state other : (D → ℤ) → E) (base : D → ℤ)
    (hline : ∀ j, state (Function.update base d j) = other (Function.update base d j)) :
    ∀ j, advance volume rule d dt state (Function.update base d j) =
      advance volume rule d dt other (Function.update base d j) := by
  intro j
  simp only [advance, finiteVolumeCellAverageUpdate, netOutwardFlux,
    normalFaceFlux, Function.update_self, Function.update_idem]
  rw [hline j, funext hline]

/-- Every interior shared-face value cancels, with arbitrary nonuniform volumes. -/
theorem finite_line_mass_balance (volume : (D → ℤ) → ℝ)
    (hvolume : ∀ cell, 0 < volume cell)
    (rule : D → (D → ℤ) → ℝ → (ℤ → E) → E)
    (d : D) (dt : ℝ) (state : (D → ℤ) → E)
    (base : D → ℤ) (start : ℤ) (count : ℕ) :
    (∑ k ∈ Finset.range count,
      volume (Function.update base d (start + k)) •
        advance volume rule d dt state (Function.update base d (start + k))) =
      (∑ k ∈ Finset.range count,
        volume (Function.update base d (start + k)) • state (Function.update base d (start + k))) -
      dt • (normalFaceFlux rule d dt state (Function.update base d (start + count)) -
        normalFaceFlux rule d dt state (Function.update base d start)) := by
  let mass : ℕ → E := fun k =>
    volume (Function.update base d (start + k)) • state (Function.update base d (start + k))
  let faces : ℕ → E := fun k =>
    normalFaceFlux rule d dt state (Function.update base d (start + k))
  calc
    _ = ∑ k ∈ Finset.range count, conservativeFluxDifferenceUpdate dt mass faces k := by
      apply Finset.sum_congr rfl
      intro k hk
      rw [advance_mass_balance volume hvolume]
      simp [conservativeFluxDifferenceUpdate, mass, faces, netOutwardFlux,
        Function.update_idem, add_assoc]
    _ = _ := by
      simpa [mass, faces] using sum_conservativeFluxDifferenceUpdate dt mass faces count

/-- Equal exterior face fluxes preserve the total physical mass on the finite line. -/
theorem finite_line_mass_preserved (volume : (D → ℤ) → ℝ)
    (hvolume : ∀ cell, 0 < volume cell)
    (rule : D → (D → ℤ) → ℝ → (ℤ → E) → E)
    (d : D) (dt : ℝ) (state : (D → ℤ) → E)
    (base : D → ℤ) (start : ℤ) (count : ℕ)
    (hboundary : normalFaceFlux rule d dt state (Function.update base d (start + count)) =
      normalFaceFlux rule d dt state (Function.update base d start)) :
    (∑ k ∈ Finset.range count,
      volume (Function.update base d (start + k)) •
        advance volume rule d dt state (Function.update base d (start + k))) =
      ∑ k ∈ Finset.range count,
        volume (Function.update base d (start + k)) • state (Function.update base d (start + k)) := by
  rw [finite_line_mass_balance volume hvolume, hboundary, sub_self, smul_zero, sub_zero]

/-- In two adjacent cells the same intermediate normal flux occurs with opposite signs. -/
theorem adjacent_cells_mass_balance (volume : (D → ℤ) → ℝ)
    (hvolume : ∀ cell, 0 < volume cell)
    (rule : D → (D → ℤ) → ℝ → (ℤ → E) → E)
    (d : D) (dt : ℝ) (state : (D → ℤ) → E) (cell : D → ℤ) :
    volume cell • advance volume rule d dt state cell +
      volume (Function.update cell d (cell d + 1)) •
        advance volume rule d dt state (Function.update cell d (cell d + 1)) =
      volume cell • state cell +
        volume (Function.update cell d (cell d + 1)) • state (Function.update cell d (cell d + 1)) -
      dt • (normalFaceFlux rule d dt state (Function.update cell d (cell d + 2)) -
        normalFaceFlux rule d dt state cell) := by
  rw [advance_mass_balance volume hvolume, advance_mass_balance volume hvolume]
  simp only [netOutwardFlux, Function.update_self, Function.update_idem]
  have hindex : cell d + 1 + 1 = cell d + 2 := by omega
  rw [hindex]
  module

/-- Execute the conservative directional operators in the supplied order.
Each rule is reevaluated on its actual intermediate state. -/
noncomputable def sweep (volume : (D → ℤ) → ℝ)
    (rule : D → (D → ℤ) → ℝ → (ℤ → E) → E)
    (stages : List (D × ℝ)) (state : (D → ℤ) → E) : (D → ℤ) → E :=
  orderedOperatorSweep (stages.map fun stage => advance volume rule stage.1 stage.2) state

theorem sweep_cons (volume : (D → ℤ) → ℝ)
    (rule : D → (D → ℤ) → ℝ → (ℤ → E) → E)
    (d : D) (dt : ℝ) (stages : List (D × ℝ)) (state : (D → ℤ) → E) :
    sweep volume rule ((d, dt) :: stages) state =
      sweep volume rule stages (advance volume rule d dt state) := rfl

/-- The existing ordered sweep really feeds the first update into the second. -/
theorem sweep_two (volume : (D → ℤ) → ℝ)
    (rule : D → (D → ℤ) → ℝ → (ℤ → E) → E)
    (d e : D) (dt ds : ℝ) (state : (D → ℤ) → E) :
    sweep volume rule [(d, dt), (e, ds)] state =
      advance volume rule e ds (advance volume rule d dt state) :=
  orderedOperatorSweep_two _ _ _

/-- Successive directional mass changes use their respective current numerical states. -/
theorem sweep_two_mass_balance (volume : (D → ℤ) → ℝ)
    (hvolume : ∀ cell, 0 < volume cell)
    (rule : D → (D → ℤ) → ℝ → (ℤ → E) → E)
    (d e : D) (dt ds : ℝ) (state : (D → ℤ) → E) (cell : D → ℤ) :
    volume cell • sweep volume rule [(d, dt), (e, ds)] state cell =
      volume cell • state cell - dt • netOutwardFlux rule d dt state cell -
        ds • netOutwardFlux rule e ds (advance volume rule d dt state) cell := by
  rw [sweep_two, advance_mass_balance volume hvolume, advance_mass_balance volume hvolume]

namespace Witness

def nonuniformVolume (cell : Unit → ℤ) : ℝ := if cell () = 0 then 1 else 2

def interiorFlux (_d : Unit) (rightCell : Unit → ℤ) (_dt : ℝ) (_line : ℤ → ℝ) : ℝ :=
  if rightCell () = 1 then 1 else 0

theorem nonuniformVolume_pos (cell : Unit → ℤ) : 0 < nonuniformVolume cell := by
  simp only [nonuniformVolume]
  split <;> norm_num

/-- Unequal positive volumes change the averages differently while conserving mass. -/
theorem unequal_volumes_nonzero_update :
    advance nonuniformVolume interiorFlux () 1 (fun _ => (0 : ℝ)) (fun _ => 0) = -1 ∧
    advance nonuniformVolume interiorFlux () 1 (fun _ => (0 : ℝ)) (fun _ => 1) = 1 / 2 ∧
    nonuniformVolume (fun _ => 0) •
        advance nonuniformVolume interiorFlux () 1 (fun _ => (0 : ℝ)) (fun _ => 0) +
      nonuniformVolume (fun _ => 1) •
        advance nonuniformVolume interiorFlux () 1 (fun _ => (0 : ℝ)) (fun _ => 1) = 0 := by
  norm_num [advance, finiteVolumeCellAverageUpdate, netOutwardFlux, normalFaceFlux,
    interiorFlux, nonuniformVolume]
  exact neg_add_cancel (1 : ℝ)

end Witness
end NumStability.LogicalLineBalanceDraft

#check NumStability.LogicalLineBalanceDraft.normalFaceFlux
#print axioms NumStability.LogicalLineBalanceDraft.normalFaceFlux
#check NumStability.LogicalLineBalanceDraft.netOutwardFlux
#print axioms NumStability.LogicalLineBalanceDraft.netOutwardFlux
#check NumStability.LogicalLineBalanceDraft.advance
#print axioms NumStability.LogicalLineBalanceDraft.advance
#check NumStability.LogicalLineBalanceDraft.advance_mass_balance
#print axioms NumStability.LogicalLineBalanceDraft.advance_mass_balance
#check NumStability.LogicalLineBalanceDraft.advance_line_local
#print axioms NumStability.LogicalLineBalanceDraft.advance_line_local
#check NumStability.LogicalLineBalanceDraft.finite_line_mass_balance
#print axioms NumStability.LogicalLineBalanceDraft.finite_line_mass_balance
#check NumStability.LogicalLineBalanceDraft.finite_line_mass_preserved
#print axioms NumStability.LogicalLineBalanceDraft.finite_line_mass_preserved
#check NumStability.LogicalLineBalanceDraft.adjacent_cells_mass_balance
#print axioms NumStability.LogicalLineBalanceDraft.adjacent_cells_mass_balance
#check NumStability.LogicalLineBalanceDraft.sweep
#print axioms NumStability.LogicalLineBalanceDraft.sweep
#check NumStability.LogicalLineBalanceDraft.sweep_cons
#print axioms NumStability.LogicalLineBalanceDraft.sweep_cons
#check NumStability.LogicalLineBalanceDraft.sweep_two
#print axioms NumStability.LogicalLineBalanceDraft.sweep_two
#check NumStability.LogicalLineBalanceDraft.sweep_two_mass_balance
#print axioms NumStability.LogicalLineBalanceDraft.sweep_two_mass_balance
#check NumStability.LogicalLineBalanceDraft.Witness.nonuniformVolume
#print axioms NumStability.LogicalLineBalanceDraft.Witness.nonuniformVolume
#check NumStability.LogicalLineBalanceDraft.Witness.interiorFlux
#print axioms NumStability.LogicalLineBalanceDraft.Witness.interiorFlux
#check NumStability.LogicalLineBalanceDraft.Witness.nonuniformVolume_pos
#print axioms NumStability.LogicalLineBalanceDraft.Witness.nonuniformVolume_pos
#check NumStability.LogicalLineBalanceDraft.Witness.unequal_volumes_nonzero_update
#print axioms NumStability.LogicalLineBalanceDraft.Witness.unequal_volumes_nonzero_update
#check NumStability.cellVolume_smul_finiteVolumeCellAverageUpdate
#print axioms NumStability.cellVolume_smul_finiteVolumeCellAverageUpdate
#check NumStability.sum_conservativeFluxDifferenceUpdate
#print axioms NumStability.sum_conservativeFluxDifferenceUpdate
#check NumStability.orderedOperatorSweep_two
#print axioms NumStability.orderedOperatorSweep_two
#check Function.update_self
#print axioms Function.update_self
#check Function.update_idem
#print axioms Function.update_idem

open Lean Elab Command in
run_cmd do
  let names : List Name := [``NumStability.LogicalLineBalanceDraft.normalFaceFlux, ``NumStability.LogicalLineBalanceDraft.netOutwardFlux, ``NumStability.LogicalLineBalanceDraft.advance, ``NumStability.LogicalLineBalanceDraft.advance_mass_balance, ``NumStability.LogicalLineBalanceDraft.advance_line_local, ``NumStability.LogicalLineBalanceDraft.finite_line_mass_balance, ``NumStability.LogicalLineBalanceDraft.finite_line_mass_preserved, ``NumStability.LogicalLineBalanceDraft.adjacent_cells_mass_balance, ``NumStability.LogicalLineBalanceDraft.sweep, ``NumStability.LogicalLineBalanceDraft.sweep_cons, ``NumStability.LogicalLineBalanceDraft.sweep_two, ``NumStability.LogicalLineBalanceDraft.sweep_two_mass_balance, ``NumStability.LogicalLineBalanceDraft.Witness.nonuniformVolume, ``NumStability.LogicalLineBalanceDraft.Witness.interiorFlux, ``NumStability.LogicalLineBalanceDraft.Witness.nonuniformVolume_pos, ``NumStability.LogicalLineBalanceDraft.Witness.unequal_volumes_nonzero_update, ``NumStability.cellVolume_smul_finiteVolumeCellAverageUpdate, ``NumStability.sum_conservativeFluxDifferenceUpdate, ``NumStability.orderedOperatorSweep_two, ``Function.update_self, ``Function.update_idem]
  for name in names do
    let axioms ← Lean.collectAxioms name
    for axiomName in axioms do
      unless [``propext, ``Classical.choice, ``Quot.sound].contains axiomName do
        throwError "Disallowed axiom {axiomName} in {name}"
  logInfo m!"ALLOWED_AXIOMS_VERIFIED {names.length}"
