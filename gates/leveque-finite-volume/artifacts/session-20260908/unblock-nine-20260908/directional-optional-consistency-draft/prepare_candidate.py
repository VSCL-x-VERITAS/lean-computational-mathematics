from pathlib import Path
import hashlib, json, re
P=Path(__file__).resolve().parent; R=P.parents[5]
fv=R/'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume'
old=(fv/'DirectionalMethodSweep.lean').read_text(encoding='utf-8')
example=(fv/'Examples/PhysicalIntervalSweep.lean').read_text(encoding='utf-8')
def consistency_hyp(s):
    start=s.index('    (hconstant :')
    end=s.index('    (stages :',start)
    return s[:start]+s[end:]
def consistency_conj(s):
    start=s.index('    (∀ d cell dt value,')
    end=s.index('    stages ≠ []',start) if '    stages ≠ []' in s[start:] else s.index('    [((0 : Fin 1)',start)
    return s[:start]+s[end:]
core=old[old.index('theorem directional_splitting_contract'):old.index('\nend NumStability.DirectionalFiniteVolume')]
core=consistency_conj(consistency_hyp(core)).replace('theorem directional_splitting_contract','theorem directional_splitting_without_exact_consistency',1)
core=core.replace('⟨hdimension, data.hyperbolic, hconstant, hnonempty','⟨hdimension, data.hyperbolic, hnonempty')
original=old[old.index('theorem directional_splitting_contract'):old.index('\nend NumStability.DirectionalFiniteVolume')]
recovery=original[:original.index(' := by')].replace('theorem directional_splitting_contract','theorem original_contract_recovered',1)+''' := by
  have h := directional_splitting_without_exact_consistency data hdimension rule admitted
    stages hnonempty hcover hpositive initial reference oldError faceError hreferences hadmitted hstates hold hface
  exact ⟨h.1, h.2.1, hconstant, h.2.2.1, h.2.2.2.1, h.2.2.2.2.1, h.2.2.2.2.2⟩

example : @original_contract_recovered = @DirectionalFiniteVolume.directional_splitting_contract := rfl
'''
optional='''/-- Optional exact consistency can be supplied for a selected admitted constant input.
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
'''
bias='''/-- Adding the same bias to all shared faces of one stage cancels in the update. -/
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
'''
witness=example[example.index('theorem simultaneous_contract'):example.index('\ntheorem unit_update')]
witness=consistency_conj(witness)
witness=witness.replace(' := directional_splitting_contract',' := directional_splitting_without_exact_consistency')
witness=witness.replace(' constant_consistent\n','\n')
witness=re.sub(r'\brule\b','biasedRule',witness)
witness=re.sub(r'\boldError\b','biasedOldError',witness)
witness=re.sub(r'\bfaceError\b','biasedFaceError',witness)
witness_intro='''namespace BiasedPhysicalInterval
open PhysicalIntervalSweep

local notation "Cell" => Fin 1 → ℤ
local notation "State" => Fin 1 → ℝ

def biasedRule (d : Fin 1) (cell : Cell) (dt : ℝ) (line : ℤ → State) : State :=
  PhysicalIntervalSweep.rule d cell dt line + 1

noncomputable def biasedOldError (before : List (Fin 1 × ℝ)) (_d : Fin 1) (_dt : ℝ) (cell : Cell) : ℝ :=
  ‖CoordinateLineBalance.sweep data.cellVolume biasedRule before initial cell -
    data.cellMean reference cell 0‖

noncomputable def biasedFaceError (before : List (Fin 1 × ℝ)) (d : Fin 1) (dt : ℝ) (cell : Cell) : ℝ :=
  ‖CoordinateLineBalance.normalFaceFlux biasedRule d dt
      (CoordinateLineBalance.sweep data.cellVolume biasedRule before initial) cell -
    faceAverage (data.faceFlux d reference) 0 dt cell‖

theorem biasedRule_not_exact_consistent :
    biasedRule 0 (fun _ => 0) 1 (fun _ => (0 : State)) ≠
      ∫ point, data.normalFlux 0 (fun _ => 0) point (0 : State) ∂data.faceMeasure 0 (fun _ => 0) := by
  simp [biasedRule, PhysicalIntervalSweep.rule, data]

'''
witness_end='''
theorem same_sweep (stages : List (Fin 1 × ℝ)) (state : Cell → State) :
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
'''
header='''import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.PhysicalIntervalSweep

open MeasureTheory
open scoped BigOperators
namespace NumStability.DirectionalOptionalConsistencyDraft
open DirectionalFiniteVolume
variable {D : Type*} [DecidableEq D] {m : ℕ}
local notation "Cell" => D → ℤ
local notation "State" => Fin m → ℝ

'''
candidate=header+core+'\n'+optional+'\n'+recovery+'\n'+bias+'\n'+witness_intro+witness+witness_end+'\nend NumStability.DirectionalOptionalConsistencyDraft\n'
with (P/'Candidate.lean').open('x',encoding='utf-8',newline='\n') as f:f.write(candidate)
names=['directional_splitting_without_exact_consistency','exact_constant_observation','original_contract_recovered','advance_shared_bias','sweep_shared_bias','BiasedPhysicalInterval.biasedRule','BiasedPhysicalInterval.biasedOldError','BiasedPhysicalInterval.biasedFaceError','BiasedPhysicalInterval.biasedRule_not_exact_consistent','BiasedPhysicalInterval.simultaneous_contract','BiasedPhysicalInterval.same_sweep','BiasedPhysicalInterval.nonconstant_execution']
checks='\n'.join(f'#check NumStability.DirectionalOptionalConsistencyDraft.{n}\n#print axioms NumStability.DirectionalOptionalConsistencyDraft.{n}' for n in names)+'\n'
with (P/'Check.lean').open('x',encoding='utf-8',newline='\n') as f:f.write(candidate+'\n'+checks)
with (P/'declarations.json').open('x',encoding='utf-8') as f:json.dump(names,f,indent=2)
print(json.dumps({'candidate_sha256':hashlib.sha256(candidate.encode()).hexdigest(),'declarations':len(names)}))
