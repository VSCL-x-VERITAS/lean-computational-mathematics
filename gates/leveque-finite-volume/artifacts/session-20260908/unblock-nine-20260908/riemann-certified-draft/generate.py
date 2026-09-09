"""Create additive scratch contracts by preserving the existing local clauses."""
from pathlib import Path
import hashlib,json
F=Path(__file__).resolve().parent
R=next(p for p in F.parents if (p/'lean-toolchain').exists())
base=R/'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume'
old=base/'LocalRiemannRoutineUpdate.lean'
source=R/'ComputationalMathematics/Source/LeVeque/Chapter01/RiemannLocalRoutineInterface.lean'
text=old.read_text(encoding='utf-8')
oldsource=source.read_text(encoding='utf-8')
def create(path,data):
    with path.open('x',encoding='utf-8',newline='\n') as out:out.write(data)
start=text.index('theorem routine_local_interface_contract')
end=text.index('    (∀ (leftReference : Reference leftProblem)')
head=text[start:end].replace('theorem routine_local_interface_contract','theorem certifiedRoutine_local_interface_contract')
needle='    (routine : Routine law Result Information)\n'
addition=needle+'    (errorBound : Problem law → ℝ) (haccuracy : routine.HasRiemannAccuracy errorBound)\n'
assert head.count(needle)==1
head=head.replace(needle,addition)
tail='''    ∃ (leftReference : Reference leftProblem) (rightReference : Reference rightProblem),
      IsRiemannData (fun x => leftReference.field x 0) left center ∧
      IsRiemannData (fun x => rightReference.field x 0) center right ∧
      (∀ x y u v, 0 ≤ u → u ≤ v → v ≤ t - s →
        (∫ z in x..y, leftReference.field z v) - (∫ z in x..y, leftReference.field z u) =
          ∫ τ in u..v, (law.flux (leftReference.field x τ) - law.flux (leftReference.field y τ))) ∧
      (∀ x y u v, 0 ≤ u → u ≤ v → v ≤ t - s →
        (∫ z in x..y, rightReference.field z v) - (∫ z in x..y, rightReference.field z u) =
          ∫ τ in u..v, (law.flux (rightReference.field x τ) - law.flux (rightReference.field y τ))) ∧
      IsOneDimensionalCellAverage (fun τ => law.flux (leftReference.field 0 τ)) 0 (t - s)
        leftReference.meanFlux ∧
      IsOneDimensionalCellAverage (fun τ => law.flux (rightReference.field 0 τ)) 0 (t - s)
        rightReference.meanFlux ∧
      0 ≤ errorBound leftProblem ∧ 0 ≤ errorBound rightProblem ∧
      ‖leftFlux - leftReference.meanFlux‖ ≤ errorBound leftProblem ∧
      ‖rightFlux - rightReference.meanFlux‖ ≤ errorBound rightProblem ∧
      ∀ oldBound leftComparison rightComparison : ℝ,
        ‖center - oneDimensionalCellAverage oldDensity a b‖ ≤ oldBound →
        ‖leftReference.meanFlux - oneDimensionalCellAverage leftPhysicalFlux s t‖ ≤ leftComparison →
        ‖rightReference.meanFlux - oneDimensionalCellAverage rightPhysicalFlux s t‖ ≤ rightComparison →
        ‖next - oneDimensionalCellAverage newDensity a b‖ ≤
          oldBound + (t - s) / (b - a) *
            ((errorBound leftProblem + leftComparison) + (errorBound rightProblem + rightComparison))'''
proof=''' := by
  dsimp only
  let leftProblem : Problem law := ⟨left, center, hleftState, hcenterState, t - s, sub_pos.mpr hst⟩
  let rightProblem : Problem law := ⟨center, right, hcenterState, hrightState, t - s, sub_pos.mpr hst⟩
  have hlocal := routine_local_interface_contract law routine left center right
    hleftState hcenterState hrightState hab hst hleftDomain hrightDomain
    oldDensity newDensity leftPhysicalFlux rightPhysicalFlux
    holdDensity hnewDensity hleftFlux hrightFlux hphysicalBalance
  rcases hlocal with ⟨hdim, hhyp, hll, hlr, hrl, hrr, hlt, hrt, hlf, hrf,
    hold, hnew, hleftMean, hrightMean, hvolume, hupdate, hbalance, hdirect, hcompare⟩
  obtain ⟨leftReference, hleftError⟩ := haccuracy leftProblem hleftDomain
  obtain ⟨rightReference, hrightError⟩ := haccuracy rightProblem hrightDomain
  obtain ⟨hleftInitial, hrightInitial, hleftAverage, hrightAverage, hreferenceBound⟩ :=
    hcompare leftReference rightReference (errorBound leftProblem) (errorBound rightProblem)
      hleftError hrightError
  exact ⟨hdim, hhyp, hll, hlr, hrl, hrr, hlt, hrt, hlf, hrf,
    hold, hnew, hleftMean, hrightMean, hvolume, hupdate, hbalance, hdirect,
    leftReference, rightReference, hleftInitial, hrightInitial,
    leftReference.rectangle, rightReference.rectangle, hleftAverage, hrightAverage,
    (norm_nonneg _).trans hleftError, (norm_nonneg _).trans hrightError,
    hleftError, hrightError, hreferenceBound⟩
'''
create(F/'Update.lean.fragment','namespace NumStability.LocalRiemannInformation\nopen NumStability\n\n'+head+tail+proof+'\nend NumStability.LocalRiemannInformation\n')
start=oldsource.index('    ∀ {Result : Problem law → Type*}')
end=oldsource.index('    (∀ (leftReference : Reference leftProblem)')
sh=oldsource[start:end].replace('    ∀ {Result','    {Result',1)
assert sh.count(needle)==1
sh=sh.replace(needle,addition)
sh=sh.replace('(_hab :','(hab :').replace('(_holdDensity :','(holdDensity :').replace('(_hnewDensity :','(hnewDensity :').replace('(_hleftFlux :','(hleftFlux :').replace('(_hrightFlux :','(hrightFlux :').replace('(_hphysicalBalance :','(hphysicalBalance :')
sh=sh.replace(' τ)),\n    let leftProblem',' τ)) :\n    let leftProblem')
assert ' τ)),\n    let leftProblem' not in sh
st=tail
for oldname,newname in [('oldDensity','(fun x => q x s)'),('newDensity','(fun x => q x t)'),
    ('leftPhysicalFlux','(fun τ => law.flux (q a τ))'),('rightPhysicalFlux','(fun τ => law.flux (q b τ))')]:
    st=st.replace(oldname,newname)
sp=''' := by
  exact certifiedRoutine_local_interface_contract law routine errorBound haccuracy left center right
    hleftState hcenterState hrightState hab hst hleftDomain hrightDomain
    (fun x => q x s) (fun x => q x t)
    (fun τ => law.flux (q a τ)) (fun τ => law.flux (q b τ))
    holdDensity hnewDensity hleftFlux hrightFlux hphysicalBalance
'''
create(F/'Source.lean.fragment','namespace NumStability\nopen LocalRiemannInformation\n\ntheorem leveque01_certifiedRiemannRoutineInterface_sourceContract {m : ℕ}\n    (law : Law m)\n'+sh+st+sp+'\nend NumStability\n')
create(F/'reuse-inputs.json',json.dumps([{'path':str(p.relative_to(R)).replace('\\','/'),'sha256':hashlib.sha256(p.read_bytes()).hexdigest()} for p in [old,source,base/'LocalRiemannRoutine.lean',base/'LocalRiemannInformation.lean',base/'Examples/BiasedLocalRiemannRoutine.lean',base/'LocalCellErrorBounds.lean']],indent=2)+'\n')
print('Generated additive Accuracy/Update/Source scratch inputs. No production writes.')
