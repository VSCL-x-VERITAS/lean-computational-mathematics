from pathlib import Path
import hashlib,json
P=Path(__file__).resolve().parent
c=(P/'Composition.fragment').read_text(encoding='utf-8')
header=c.split('theorem coordinateExecution_physical_error',1)[1].split(' :\n    ∀ n ≤ steps',1)[0]
header=header.replace('(physical : ℕ → Point → ℝ → V)', '(physical : ℕ → (D → ℝ) → ℝ → V)')
header+='\n    (hschedule : ∀ d : D, ∃ n < steps, direction n = d)'
e=(P/'Execution.fragment').read_text(encoding='utf-8')
accuracy=e.split('theorem LineRealization.smooth_accuracy',1)[1].split(' :\n    ∃ p L',1)[1].split(' := by',1)[0]
accuracy='∃ p L'+accuracy
accuracy=accuracy.replace('State','V')
import re
accuracy=re.sub(r'\brealization\b','(method n)',accuracy)
accuracy=re.sub(r'\bd\b','(direction n)',accuracy)
q=(P/'Quality.lean').read_text(encoding='utf-8')
uniform=q.split('theorem LineFamily.HasControlledHighResolution.perturbed_accuracy',1)[1].split(' :\n    ∃ p L',1)[1].split(' := by',1)[0]
uniform='∃ p L'+uniform
uniform=re.sub(r'\bfamily\b','(family d line)',uniform.replace('State','V'))
prefix='''namespace NumStability.DirectionalCompleteRepair
open MeasureTheory DirectionalQualityRepair FiniteDirectionalRepair DirectionalPropagationRepair
open scoped BigOperators
variable {D Cell Face FacePoint Line : Type*} [Fintype D] [DecidableEq D] [Fintype Cell]
variable [MeasurableSpace FacePoint] {m : ℕ}
variable {data : PhysicalData D Cell Face (D → ℝ) FacePoint m}
variable {coord : LineCoordinates (m := m) D Cell Face Line} {family : D → Line → LineFamily m}
local notation "V" => Fin m → ℝ

/-- One complete conditional construction: supplied high-resolution line
families are the actual constituent operators, physical references conserve
on every time subinterval, finite successive execution retains boundary
transfer and explicit splitting errors, and Cartesian observations concern
the same physical data. Solver existence for arbitrary laws and composite
high temporal order are not asserted. -/
theorem coordinate_highResolution_sourceContract (hm : 0 < m) (hD : 0 < Fintype.card D)
'''
claim=''' :
    0 < m ∧ 0 < Fintype.card D ∧ (∀ d : D, ∃ n < steps, direction n = d) ∧
    (∀ d line, (family d line).HasControlledHighResolution) ∧
    (∀ d line, '''+uniform+''') ∧
    (∀ n ≤ steps, coordinateExecution method direction initial n =
      orderedOperatorSweep ((List.range n).map (coordinateStep method direction)) initial) ∧
    (∀ n < steps, ∀ cell,
      coordinateExecution method direction initial (n + 1) cell =
        (family (direction n) (coord.cellLine (direction n) cell)).advance
          ((method n).level (direction n) (coord.cellLine (direction n) cell))
          (coord.extract (direction n) (coord.cellLine (direction n) cell)
            (coordinateExecution method direction initial n)) (coord.cellIndex (direction n) cell)) ∧
    (∀ n < steps,
      (∑ cell, data.cellVolume cell • coordinateExecution method direction initial (n + 1) cell) =
      (∑ cell, data.cellVolume cell • coordinateExecution method direction initial n cell) -
        (method n).duration (direction n) • ∑ cell,
          ((method n).rule (direction n) ((method n).duration (direction n))
            (coordinateExecution method direction initial n) (data.rightFace (direction n) cell) -
           (method n).rule (direction n) ((method n).duration (direction n))
            (coordinateExecution method direction initial n) (data.leftFace (direction n) cell))) ∧
    (∀ n < steps, ∀ cell current other,
      (∀ c, coord.cellLine (direction n) c = coord.cellLine (direction n) cell → current c = other c) →
      advance data (method n).rule (direction n) ((method n).duration (direction n)) current cell =
        advance data (method n).rule (direction n) ((method n).duration (direction n)) other cell) ∧
    (∀ n < steps, ∀ cell, '''+accuracy+''') ∧
    (∀ n < steps, ∀ u ∈ Set.uIcc 0 ((method n).duration (direction n)),
      ∀ v ∈ Set.uIcc 0 ((method n).duration (direction n)), ∀ cell,
      data.cellVolume cell • (data.cellMean (physical n) cell v - data.cellMean (physical n) cell u) =
        ∫ τ in u..v, data.faceFlux (direction n) (physical n) (data.leftFace (direction n) cell) τ -
          data.faceFlux (direction n) (physical n) (data.rightFace (direction n) cell) τ) ∧
    (∀ n ≤ steps, ∀ cell,
      ‖coordinateExecution method direction initial n cell - data.cellMean (physical n) cell 0‖ ≤
        errorBudget amplification localDefect splittingDefect initialError n) ∧
    (∀ (axes : D → OneDimensionalFiniteVolumeGrid) (cellPosition : Cell → D → ℤ)
      (facePosition : D → Face → D → ℤ) (flux : D → V → V),
      FiniteCartesianRepair.CartesianIdentification data axes cellPosition facePosition flux →
      (∀ cell, data.cellVolume cell = CartesianGrid.cellVolume axes (cellPosition cell)) ∧
      (∀ (q : (D → ℝ) → ℝ → V) cell t, data.cellMean q cell t =
        cellVolumeAverage volume (CartesianGrid.cellBox axes (cellPosition cell)) (fun x => q x t)) ∧
      (∀ (q : ℝ → ℝ → V) d face t,
        data.faceFlux d (fun x τ => q (x d) τ) face t =
          CartesianGrid.faceArea axes d (facePosition d face) •
            flux d (q ((axes d).cellLeft (facePosition d face d)) t)) ∧
      (∀ (q : ℝ → ℝ → V) d, IsRectangleConservationLawSolution q (flux d) → ∀ cell s t,
        data.cellVolume cell • (data.cellMean (fun x τ => q (x d) τ) cell t -
          data.cellMean (fun x τ => q (x d) τ) cell s) =
          ∫ τ in s..t, data.faceFlux d (fun x τ => q (x d) τ) (data.leftFace d cell) τ -
            data.faceFlux d (fun x τ => q (x d) τ) (data.rightFace d cell) τ)) := by
  refine ⟨hm, hD, hschedule, quality, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · intro d line
    exact LineFamily.HasControlledHighResolution.perturbed_accuracy (family d line) (quality d line)
  · intro n _
    exact coordinateExecution_ordered method direction initial n
  · intro n _ cell
    rw [coordinateExecution_succ]
    exact (method n).advance_eq (direction n) _ cell
  · intro n _
    rw [coordinateExecution_succ]
    exact finite_mass_balance data (method n).rule (direction n) _ _
  · intro n _ cell current other h
    exact (method n).coordinate_local (direction n) current other cell h
  · intro n _ cell
    exact (method n).smooth_accuracy quality (direction n) cell
  · intro n hn u hu v hv cell
    exact ((href n hn).2.2.2 u hu v hv).2 cell
  · exact coordinateExecution_physical_error method direction quality initial physical steps
      amplification localDefect splittingDefect initialError leftError rightError href hinitial
      hactual hrefadmit hamplification hleft hright hlocal hsplit
  · intro axes cellPosition facePosition flux cart
    refine ⟨cart.cellVolume_eq, cart.cellMean_eq, cart.faceFlux_lift, ?_⟩
    intro q d hq cell s t
    exact cart.rectangle_balance_lift q d hq cell s t

end NumStability.DirectionalCompleteRepair
#check NumStability.DirectionalCompleteRepair.coordinate_highResolution_sourceContract
#print axioms NumStability.DirectionalCompleteRepair.coordinate_highResolution_sourceContract
'''
(P/'Primary.fragment').write_text(prefix+header+claim,encoding='utf-8',newline='\n')
names=['Finite.lean','Quality.lean','Execution.fragment','Propagation.lean','Composition.fragment','Lift.lean','FiniteCartesian.fragment','Primary.fragment']
texts=[(P/n).read_text(encoding='utf-8') for n in names]
imports=sorted(set(l for t in texts for l in t.splitlines() if l.startswith('import ')))
body='\n'.join('\n'.join(l for l in t.splitlines() if not l.startswith('import ')) for t in texts)
(P/'Primary.lean').write_text('\n'.join(imports)+'\n'+body+'\n',encoding='utf-8',newline='\n')
print(json.dumps({n:hashlib.sha256((P/n).read_bytes()).hexdigest() for n in names+['Primary.lean']},indent=2))
