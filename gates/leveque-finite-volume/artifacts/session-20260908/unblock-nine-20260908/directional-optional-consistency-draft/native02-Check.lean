import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.PhysicalIntervalSweep

open MeasureTheory
open scoped BigOperators
namespace NumStability.DirectionalOptionalConsistencyDraft
open DirectionalFiniteVolume
variable {D : Type*} [DecidableEq D] {m : ℕ}
local notation "Cell" => D → ℤ
local notation "State" => Fin m → ℝ

theorem directional_splitting_without_exact_consistency
    {Point FacePoint : Type*} [MeasurableSpace Point] [TopologicalSpace Point]
    [MeasurableSpace FacePoint] [Fintype D]
    (data : PhysicalData D Point FacePoint m)
    (hdimension : 0 < m)
    (rule : D → Cell → ℝ → (ℤ → State) → State)
    (admitted : D → Cell → ℝ → (ℤ → State) → Prop)
    (stages : List (D × ℝ)) (hnonempty : stages ≠ [])
    (hcover : ∀ d, ∃ dt, (d, dt) ∈ stages)
    (hpositive : ∀ stage ∈ stages, 0 < stage.2)
    (initial : Cell → State)
    (reference : List (D × ℝ) → D → ℝ → Point → ℝ → State)
    (oldError faceError : List (D × ℝ) → D → ℝ → Cell → ℝ)
    (hreferences : ∀ before d dt after, stages = before ++ (d, dt) :: after →
      data.ReferenceOn d (reference before d dt) 0 dt)
    (hadmitted : ∀ before d dt after, stages = before ++ (d, dt) :: after → ∀ cell,
      admitted d cell dt (fun j => CoordinateLineBalance.sweep data.cellVolume rule before initial
        (Function.update cell d j)))
    (hstates : ∀ before d dt after, stages = before ++ (d, dt) :: after → ∀ cell,
      CoordinateLineBalance.sweep data.cellVolume rule before initial cell ∈ data.admissibleStates d)
    (hold : ∀ before d dt after, stages = before ++ (d, dt) :: after → ∀ cell,
      ‖CoordinateLineBalance.sweep data.cellVolume rule before initial cell -
        data.cellMean (reference before d dt) cell 0‖ ≤ oldError before d dt cell)
    (hface : ∀ before d dt after, stages = before ++ (d, dt) :: after → ∀ cell,
      ‖CoordinateLineBalance.normalFaceFlux rule d dt
          (CoordinateLineBalance.sweep data.cellVolume rule before initial) cell -
        faceAverage (data.faceFlux d (reference before d dt)) 0 dt cell‖ ≤ faceError before d dt cell) :
    0 < m ∧
    (∀ d cell point, IsHyperbolicFluxOn (data.normalFlux d cell point) (data.admissibleStates d)) ∧
    stages ≠ [] ∧ (∀ d, ∃ dt, (d, dt) ∈ stages) ∧
    (∀ before d dt after, stages = before ++ (d, dt) :: after →
      let current := CoordinateLineBalance.sweep data.cellVolume rule before initial
      0 < dt ∧ data.ReferenceOn d (reference before d dt) 0 dt ∧
      (∀ cell, admitted d cell dt (fun j => current (Function.update cell d j))) ∧
      (∀ cell, current cell ∈ data.admissibleStates d) ∧
      CoordinateLineBalance.sweep data.cellVolume rule stages initial =
        CoordinateLineBalance.sweep data.cellVolume rule after
          (CoordinateLineBalance.advance data.cellVolume rule d dt current) ∧
      (∀ cell, data.cellVolume cell • CoordinateLineBalance.advance data.cellVolume rule d dt current cell =
        data.cellVolume cell • current cell - dt • CoordinateLineBalance.netOutwardFlux rule d dt current cell) ∧
      (∀ base start count,
        (∑ k ∈ Finset.range count, data.cellVolume (Function.update base d (start + k)) •
          CoordinateLineBalance.advance data.cellVolume rule d dt current (Function.update base d (start + k))) =
        (∑ k ∈ Finset.range count, data.cellVolume (Function.update base d (start + k)) •
          current (Function.update base d (start + k))) -
        dt • (CoordinateLineBalance.normalFaceFlux rule d dt current (Function.update base d (start + count)) -
          CoordinateLineBalance.normalFaceFlux rule d dt current (Function.update base d start))) ∧
      (∀ other base, (∀ j, current (Function.update base d j) = other (Function.update base d j)) →
        ∀ j, CoordinateLineBalance.advance data.cellVolume rule d dt current (Function.update base d j) =
          CoordinateLineBalance.advance data.cellVolume rule d dt other (Function.update base d j)) ∧
      ∀ cell, ‖CoordinateLineBalance.advance data.cellVolume rule d dt current cell -
          data.cellMean (reference before d dt) cell dt‖ ≤
        oldError before d dt cell + dt / data.cellVolume cell *
          (faceError before d dt cell + faceError before d dt (Function.update cell d (cell d + 1)))) ∧
    (∀ (axes : D → OneDimensionalFiniteVolumeGrid)
      (lineRule : D → Cell → ℝ → (ℤ → State) → State),
      data.cellVolume = CartesianGrid.cellVolume axes →
      rule = CartesianCoordinateUpdate.areaWeightedRule axes lineRule →
      (∀ cell, (volume (CartesianGrid.cellBox axes cell)).toReal = data.cellVolume cell) ∧
      (∀ d cell, (volume (CartesianGrid.tangentialFaceBox axes d cell)).toReal = CartesianGrid.faceArea axes d cell) ∧
      (∀ d dt state base,
        (fun j => CoordinateLineBalance.advance data.cellVolume rule d dt state (Function.update base d j)) =
        riemannFiniteVolumeUpdate (axes d) dt (fun j => state (Function.update base d j))
          (fun j => lineRule d (Function.update base d j) dt (fun k => state (Function.update base d k)))) ∧
      ∀ d (flux : State → State) (q : ℝ → ℝ → State), IsRectangleConservationLawSolution q flux → ∀ s t,
        IsDirectionalReference data.cellVolume
          (fun cell τ => finiteVolumeCellAverageOn (axes d) (fun x => q x τ) (cell d))
          (fun cell τ => CartesianGrid.faceArea axes d cell • flux (q ((axes d).cellLeft (cell d)) τ)) d s t) := by
  refine ⟨hdimension, data.hyperbolic, hnonempty, hcover, ?_, ?_⟩
  · intro before d dt after hstages
    dsimp only
    have hdt : 0 < dt := hpositive (d, dt) (by rw [hstages]; simp)
    have href := hreferences before d dt after hstages
    refine ⟨hdt, href, hadmitted before d dt after hstages, hstates before d dt after hstages, ?_,
      CoordinateLineBalance.advance_mass_balance data.cellVolume data.cellVolume_pos rule d dt _,
      CoordinateLineBalance.finite_line_mass_balance data.cellVolume data.cellVolume_pos rule d dt _, ?_, ?_⟩
    · subst stages
      simp [CoordinateLineBalance.sweep, orderedOperatorSweep, List.foldl_append]
    · intro other base hline
      exact CoordinateLineBalance.advance_line_local data.cellVolume rule d dt _ other base hline
    · intro cell
      simpa only [sub_zero] using advance_error_le data.cellVolume data.cellVolume_pos rule d
        (CoordinateLineBalance.sweep data.cellVolume rule before initial)
        (data.cellMean (reference before d dt)) (data.faceFlux d (reference before d dt))
        href.2.2.2.2 hdt cell (hold before d dt after hstages cell)
        (by simpa using hface before d dt after hstages cell)
        (by simpa using hface before d dt after hstages (Function.update cell d (cell d + 1)))
  · intro axes lineRule hvolume hrule
    rw [hvolume, hrule]
    exact ⟨CartesianGrid.cellBox_volume axes, CartesianGrid.tangentialFaceBox_volume axes,
      CartesianCoordinateUpdate.cartesian_full_line_update axes lineRule,
      fun d flux q hq s t => cartesian_reference axes d flux q hq s t⟩

/-- Optional exact consistency can be supplied for a selected admitted constant input.
It is not an admission condition or a premise of the main splitting contract. -/
theorem exact_constant_observation
    {Point FacePoint : Type*} [MeasurableSpace Point] [TopologicalSpace Point]
    [MeasurableSpace FacePoint] (data : PhysicalData D Point FacePoint m)
    (rule : D → Cell → ℝ → (ℤ → State) → State)
    (admitted : D → Cell → ℝ → (ℤ → State) → Prop)
    (hconstant : ∀ d cell dt value, 0 < dt → value ∈ data.admissibleStates d →
      admitted d cell dt (fun _ => value) →
      Integrable (fun point => data.normalFlux d cell point value) (data.faceMeasure d cell) ∧
      rule d cell dt (fun _ => value) =
        ∫ point, data.normalFlux d cell point value ∂data.faceMeasure d cell)
    (d : D) (cell : Cell) (dt : ℝ) (value : State) (hdt : 0 < dt)
    (hstate : value ∈ data.admissibleStates d) (hadmit : admitted d cell dt (fun _ => value)) :
    Integrable (fun point => data.normalFlux d cell point value) (data.faceMeasure d cell) ∧
      rule d cell dt (fun _ => value) =
        ∫ point, data.normalFlux d cell point value ∂data.faceMeasure d cell :=
  hconstant d cell dt value hdt hstate hadmit

theorem original_contract_recovered
    {Point FacePoint : Type*} [MeasurableSpace Point] [TopologicalSpace Point]
    [MeasurableSpace FacePoint] [Fintype D]
    (data : PhysicalData D Point FacePoint m)
    (hdimension : 0 < m)
    (rule : D → Cell → ℝ → (ℤ → State) → State)
    (admitted : D → Cell → ℝ → (ℤ → State) → Prop)
    (hconstant : ∀ d cell dt value, 0 < dt → value ∈ data.admissibleStates d →
      admitted d cell dt (fun _ => value) →
      Integrable (fun point => data.normalFlux d cell point value) (data.faceMeasure d cell) ∧
      rule d cell dt (fun _ => value) =
        ∫ point, data.normalFlux d cell point value ∂data.faceMeasure d cell)
    (stages : List (D × ℝ)) (hnonempty : stages ≠ [])
    (hcover : ∀ d, ∃ dt, (d, dt) ∈ stages)
    (hpositive : ∀ stage ∈ stages, 0 < stage.2)
    (initial : Cell → State)
    (reference : List (D × ℝ) → D → ℝ → Point → ℝ → State)
    (oldError faceError : List (D × ℝ) → D → ℝ → Cell → ℝ)
    (hreferences : ∀ before d dt after, stages = before ++ (d, dt) :: after →
      data.ReferenceOn d (reference before d dt) 0 dt)
    (hadmitted : ∀ before d dt after, stages = before ++ (d, dt) :: after → ∀ cell,
      admitted d cell dt (fun j => CoordinateLineBalance.sweep data.cellVolume rule before initial
        (Function.update cell d j)))
    (hstates : ∀ before d dt after, stages = before ++ (d, dt) :: after → ∀ cell,
      CoordinateLineBalance.sweep data.cellVolume rule before initial cell ∈ data.admissibleStates d)
    (hold : ∀ before d dt after, stages = before ++ (d, dt) :: after → ∀ cell,
      ‖CoordinateLineBalance.sweep data.cellVolume rule before initial cell -
        data.cellMean (reference before d dt) cell 0‖ ≤ oldError before d dt cell)
    (hface : ∀ before d dt after, stages = before ++ (d, dt) :: after → ∀ cell,
      ‖CoordinateLineBalance.normalFaceFlux rule d dt
          (CoordinateLineBalance.sweep data.cellVolume rule before initial) cell -
        faceAverage (data.faceFlux d (reference before d dt)) 0 dt cell‖ ≤ faceError before d dt cell) :
    0 < m ∧
    (∀ d cell point, IsHyperbolicFluxOn (data.normalFlux d cell point) (data.admissibleStates d)) ∧
    (∀ d cell dt value, 0 < dt → value ∈ data.admissibleStates d →
      admitted d cell dt (fun _ => value) →
      Integrable (fun point => data.normalFlux d cell point value) (data.faceMeasure d cell) ∧
      rule d cell dt (fun _ => value) =
        ∫ point, data.normalFlux d cell point value ∂data.faceMeasure d cell) ∧
    stages ≠ [] ∧ (∀ d, ∃ dt, (d, dt) ∈ stages) ∧
    (∀ before d dt after, stages = before ++ (d, dt) :: after →
      let current := CoordinateLineBalance.sweep data.cellVolume rule before initial
      0 < dt ∧ data.ReferenceOn d (reference before d dt) 0 dt ∧
      (∀ cell, admitted d cell dt (fun j => current (Function.update cell d j))) ∧
      (∀ cell, current cell ∈ data.admissibleStates d) ∧
      CoordinateLineBalance.sweep data.cellVolume rule stages initial =
        CoordinateLineBalance.sweep data.cellVolume rule after
          (CoordinateLineBalance.advance data.cellVolume rule d dt current) ∧
      (∀ cell, data.cellVolume cell • CoordinateLineBalance.advance data.cellVolume rule d dt current cell =
        data.cellVolume cell • current cell - dt • CoordinateLineBalance.netOutwardFlux rule d dt current cell) ∧
      (∀ base start count,
        (∑ k ∈ Finset.range count, data.cellVolume (Function.update base d (start + k)) •
          CoordinateLineBalance.advance data.cellVolume rule d dt current (Function.update base d (start + k))) =
        (∑ k ∈ Finset.range count, data.cellVolume (Function.update base d (start + k)) •
          current (Function.update base d (start + k))) -
        dt • (CoordinateLineBalance.normalFaceFlux rule d dt current (Function.update base d (start + count)) -
          CoordinateLineBalance.normalFaceFlux rule d dt current (Function.update base d start))) ∧
      (∀ other base, (∀ j, current (Function.update base d j) = other (Function.update base d j)) →
        ∀ j, CoordinateLineBalance.advance data.cellVolume rule d dt current (Function.update base d j) =
          CoordinateLineBalance.advance data.cellVolume rule d dt other (Function.update base d j)) ∧
      ∀ cell, ‖CoordinateLineBalance.advance data.cellVolume rule d dt current cell -
          data.cellMean (reference before d dt) cell dt‖ ≤
        oldError before d dt cell + dt / data.cellVolume cell *
          (faceError before d dt cell + faceError before d dt (Function.update cell d (cell d + 1)))) ∧
    (∀ (axes : D → OneDimensionalFiniteVolumeGrid)
      (lineRule : D → Cell → ℝ → (ℤ → State) → State),
      data.cellVolume = CartesianGrid.cellVolume axes →
      rule = CartesianCoordinateUpdate.areaWeightedRule axes lineRule →
      (∀ cell, (volume (CartesianGrid.cellBox axes cell)).toReal = data.cellVolume cell) ∧
      (∀ d cell, (volume (CartesianGrid.tangentialFaceBox axes d cell)).toReal = CartesianGrid.faceArea axes d cell) ∧
      (∀ d dt state base,
        (fun j => CoordinateLineBalance.advance data.cellVolume rule d dt state (Function.update base d j)) =
        riemannFiniteVolumeUpdate (axes d) dt (fun j => state (Function.update base d j))
          (fun j => lineRule d (Function.update base d j) dt (fun k => state (Function.update base d k)))) ∧
      ∀ d (flux : State → State) (q : ℝ → ℝ → State), IsRectangleConservationLawSolution q flux → ∀ s t,
        IsDirectionalReference data.cellVolume
          (fun cell τ => finiteVolumeCellAverageOn (axes d) (fun x => q x τ) (cell d))
          (fun cell τ => CartesianGrid.faceArea axes d cell • flux (q ((axes d).cellLeft (cell d)) τ)) d s t) := by
  have h := directional_splitting_without_exact_consistency data hdimension rule admitted
    stages hnonempty hcover hpositive initial reference oldError faceError hreferences hadmitted hstates hold hface
  exact ⟨h.1, h.2.1, hconstant, h.2.2.1, h.2.2.2.1, h.2.2.2.2.1, h.2.2.2.2.2⟩

example : @original_contract_recovered = @DirectionalFiniteVolume.directional_splitting_contract := rfl

/-- Adding the same bias to all shared faces of one stage cancels in the update. -/
theorem advance_shared_bias {E : Type*} [AddCommGroup E] [Module ℝ E]
    (volume : Cell → ℝ) (rule : D → Cell → ℝ → (ℤ → E) → E)
    (bias : D → ℝ → E) (d : D) (dt : ℝ) (state : Cell → E) :
    CoordinateLineBalance.advance volume
      (fun d cell dt line => rule d cell dt line + bias d dt) d dt state =
      CoordinateLineBalance.advance volume rule d dt state := by
  funext cell
  simp [CoordinateLineBalance.advance, CoordinateLineBalance.netOutwardFlux,
    CoordinateLineBalance.normalFaceFlux]

/-- Every finite sequence evaluates its rule on the same intermediate states. -/
theorem sweep_shared_bias {E : Type*} [AddCommGroup E] [Module ℝ E]
    (volume : Cell → ℝ) (rule : D → Cell → ℝ → (ℤ → E) → E)
    (bias : D → ℝ → E) (stages : List (D × ℝ)) (state : Cell → E) :
    CoordinateLineBalance.sweep volume
      (fun d cell dt line => rule d cell dt line + bias d dt) stages state =
      CoordinateLineBalance.sweep volume rule stages state := by
  induction stages generalizing state with
  | nil => rfl
  | cons stage tail ih =>
      rcases stage with ⟨d, dt⟩
      rw [CoordinateLineBalance.sweep_cons, CoordinateLineBalance.sweep_cons,
        advance_shared_bias, ih]

namespace BiasedPhysicalInterval
open PhysicalIntervalSweep


def biasedRule (d : Fin 1) (cell : (Fin 1 → ℤ)) (dt : ℝ) (line : ℤ → (Fin 1 → ℝ)) : (Fin 1 → ℝ) :=
  PhysicalIntervalSweep.rule d cell dt line + 1

noncomputable def biasedOldError (before : List (Fin 1 × ℝ)) (_d : Fin 1) (_dt : ℝ) (cell : (Fin 1 → ℤ)) : ℝ :=
  ‖CoordinateLineBalance.sweep data.cellVolume biasedRule before initial cell -
    data.cellMean reference cell 0‖

noncomputable def biasedFaceError (before : List (Fin 1 × ℝ)) (d : Fin 1) (dt : ℝ) (cell : (Fin 1 → ℤ)) : ℝ :=
  ‖CoordinateLineBalance.normalFaceFlux biasedRule d dt
      (CoordinateLineBalance.sweep data.cellVolume biasedRule before initial) cell -
    faceAverage (data.faceFlux d reference) 0 dt cell‖

theorem biasedRule_not_exact_consistent :
    biasedRule 0 (fun _ => 0) 1 (fun _ => (0 : (Fin 1 → ℝ))) ≠
      ∫ point, data.normalFlux 0 (fun _ => 0) point (0 : (Fin 1 → ℝ)) ∂data.faceMeasure 0 (fun _ => 0) := by
  simp [biasedRule, PhysicalIntervalSweep.rule, data]

theorem simultaneous_contract :
    0 < 1 ∧
    (∀ d cell point, IsHyperbolicFluxOn (data.normalFlux d cell point) (data.admissibleStates d)) ∧
    [((0 : Fin 1), (1 : ℝ))] ≠ [] ∧ (∀ d, ∃ dt, (d, dt) ∈ [((0 : Fin 1), (1 : ℝ))]) ∧
    (∀ before d dt after, [((0 : Fin 1), (1 : ℝ))] = before ++ (d, dt) :: after →
      let current := CoordinateLineBalance.sweep data.cellVolume biasedRule before initial
      0 < dt ∧ data.ReferenceOn d ((fun (_before : List (Fin 1 × ℝ)) (_d : Fin 1) (_dt : ℝ) => reference) before d dt) 0 dt ∧
      (∀ cell, (fun (_d : Fin 1) (_cell : (Fin 1 → ℤ)) (_dt : ℝ) (_line : ℤ → (Fin 1 → ℝ)) => True) d cell dt (fun j => current (Function.update cell d j))) ∧
      (∀ cell, current cell ∈ data.admissibleStates d) ∧
      CoordinateLineBalance.sweep data.cellVolume biasedRule [((0 : Fin 1), (1 : ℝ))] initial =
        CoordinateLineBalance.sweep data.cellVolume biasedRule after
          (CoordinateLineBalance.advance data.cellVolume biasedRule d dt current) ∧
      (∀ cell, data.cellVolume cell • CoordinateLineBalance.advance data.cellVolume biasedRule d dt current cell =
        data.cellVolume cell • current cell - dt • CoordinateLineBalance.netOutwardFlux biasedRule d dt current cell) ∧
      (∀ base start count,
        (∑ k ∈ Finset.range count, data.cellVolume (Function.update base d (start + k)) •
          CoordinateLineBalance.advance data.cellVolume biasedRule d dt current (Function.update base d (start + k))) =
        (∑ k ∈ Finset.range count, data.cellVolume (Function.update base d (start + k)) •
          current (Function.update base d (start + k))) -
        dt • (CoordinateLineBalance.normalFaceFlux biasedRule d dt current (Function.update base d (start + count)) -
          CoordinateLineBalance.normalFaceFlux biasedRule d dt current (Function.update base d start))) ∧
      (∀ other base, (∀ j, current (Function.update base d j) = other (Function.update base d j)) →
        ∀ j, CoordinateLineBalance.advance data.cellVolume biasedRule d dt current (Function.update base d j) =
          CoordinateLineBalance.advance data.cellVolume biasedRule d dt other (Function.update base d j)) ∧
      ∀ cell, ‖CoordinateLineBalance.advance data.cellVolume biasedRule d dt current cell -
          data.cellMean ((fun (_before : List (Fin 1 × ℝ)) (_d : Fin 1) (_dt : ℝ) => reference) before d dt) cell dt‖ ≤
        biasedOldError before d dt cell + dt / data.cellVolume cell *
          (biasedFaceError before d dt cell + biasedFaceError before d dt (Function.update cell d (cell d + 1)))) ∧
    (∀ (axes : (Fin 1) → OneDimensionalFiniteVolumeGrid)
      (lineRule : (Fin 1) → (Fin 1 → ℤ) → ℝ → (ℤ → (Fin 1 → ℝ)) → (Fin 1 → ℝ)),
      data.cellVolume = CartesianGrid.cellVolume axes →
      biasedRule = CartesianCoordinateUpdate.areaWeightedRule axes lineRule →
      (∀ cell, (volume (CartesianGrid.cellBox axes cell)).toReal = data.cellVolume cell) ∧
      (∀ d cell, (volume (CartesianGrid.tangentialFaceBox axes d cell)).toReal = CartesianGrid.faceArea axes d cell) ∧
      (∀ d dt state base,
        (fun j => CoordinateLineBalance.advance data.cellVolume biasedRule d dt state (Function.update base d j)) =
        riemannFiniteVolumeUpdate (axes d) dt (fun j => state (Function.update base d j))
          (fun j => lineRule d (Function.update base d j) dt (fun k => state (Function.update base d k)))) ∧
      ∀ d (flux : (Fin 1 → ℝ) → (Fin 1 → ℝ)) (q : ℝ → ℝ → (Fin 1 → ℝ)), IsRectangleConservationLawSolution q flux → ∀ s t,
        IsDirectionalReference data.cellVolume
          (fun cell τ => finiteVolumeCellAverageOn (axes d) (fun x => q x τ) (cell d))
          (fun cell τ => CartesianGrid.faceArea axes d cell • flux (q ((axes d).cellLeft (cell d)) τ)) d s t) := directional_splitting_without_exact_consistency
  data (by decide) biasedRule (fun _ _ _ _ => True)
  [(0, 1)] (by simp) (by intro d; fin_cases d; exact ⟨1, by simp⟩)
  (by intro stage h; simp only [List.mem_singleton] at h; subst stage; norm_num)
  initial (fun _ _ _ => reference) biasedOldError biasedFaceError
  (fun _ d dt _ _ => reference_on reference reference_conserved d 0 dt)
  (by intros; trivial) (by intros; trivial)
  (by intros; exact le_rfl) (by intros; exact le_rfl)

theorem same_sweep (stages : List (Fin 1 × ℝ)) (state : (Fin 1 → ℤ) → (Fin 1 → ℝ)) :
    CoordinateLineBalance.sweep data.cellVolume biasedRule stages state =
      CoordinateLineBalance.sweep data.cellVolume PhysicalIntervalSweep.rule stages state := by
  exact sweep_shared_bias data.cellVolume PhysicalIntervalSweep.rule (fun _ _ => 1) stages state

theorem nonconstant_execution :
    initial (fun _ => 1) = 1 ∧
    CoordinateLineBalance.sweep data.cellVolume biasedRule [(0, 1)] initial (fun _ => 1) = 0 ∧
    CoordinateLineBalance.sweep data.cellVolume biasedRule [(0, 1)] initial (fun _ => 2) = 1 ∧
    reference (-1) 0 = 0 ∧ reference 1 0 = 1 := by
  simp only [same_sweep]
  exact PhysicalIntervalSweep.nonconstant_execution

end BiasedPhysicalInterval

end NumStability.DirectionalOptionalConsistencyDraft

#check NumStability.DirectionalOptionalConsistencyDraft.directional_splitting_without_exact_consistency
#print axioms NumStability.DirectionalOptionalConsistencyDraft.directional_splitting_without_exact_consistency
#check NumStability.DirectionalOptionalConsistencyDraft.exact_constant_observation
#print axioms NumStability.DirectionalOptionalConsistencyDraft.exact_constant_observation
#check NumStability.DirectionalOptionalConsistencyDraft.original_contract_recovered
#print axioms NumStability.DirectionalOptionalConsistencyDraft.original_contract_recovered
#check NumStability.DirectionalOptionalConsistencyDraft.advance_shared_bias
#print axioms NumStability.DirectionalOptionalConsistencyDraft.advance_shared_bias
#check NumStability.DirectionalOptionalConsistencyDraft.sweep_shared_bias
#print axioms NumStability.DirectionalOptionalConsistencyDraft.sweep_shared_bias
#check NumStability.DirectionalOptionalConsistencyDraft.BiasedPhysicalInterval.biasedRule
#print axioms NumStability.DirectionalOptionalConsistencyDraft.BiasedPhysicalInterval.biasedRule
#check NumStability.DirectionalOptionalConsistencyDraft.BiasedPhysicalInterval.biasedOldError
#print axioms NumStability.DirectionalOptionalConsistencyDraft.BiasedPhysicalInterval.biasedOldError
#check NumStability.DirectionalOptionalConsistencyDraft.BiasedPhysicalInterval.biasedFaceError
#print axioms NumStability.DirectionalOptionalConsistencyDraft.BiasedPhysicalInterval.biasedFaceError
#check NumStability.DirectionalOptionalConsistencyDraft.BiasedPhysicalInterval.biasedRule_not_exact_consistent
#print axioms NumStability.DirectionalOptionalConsistencyDraft.BiasedPhysicalInterval.biasedRule_not_exact_consistent
#check NumStability.DirectionalOptionalConsistencyDraft.BiasedPhysicalInterval.simultaneous_contract
#print axioms NumStability.DirectionalOptionalConsistencyDraft.BiasedPhysicalInterval.simultaneous_contract
#check NumStability.DirectionalOptionalConsistencyDraft.BiasedPhysicalInterval.same_sweep
#print axioms NumStability.DirectionalOptionalConsistencyDraft.BiasedPhysicalInterval.same_sweep
#check NumStability.DirectionalOptionalConsistencyDraft.BiasedPhysicalInterval.nonconstant_execution
#print axioms NumStability.DirectionalOptionalConsistencyDraft.BiasedPhysicalInterval.nonconstant_execution
