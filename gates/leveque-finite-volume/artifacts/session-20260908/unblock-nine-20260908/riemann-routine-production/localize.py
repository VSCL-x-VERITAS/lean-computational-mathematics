from pathlib import Path
import re, json, hashlib
R=Path(__file__).resolve().parents[6]
P=R/'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume'
E=Path(__file__).resolve().parent
u=P/'LocalRiemannRoutineUpdate.lean'
s=R/'ComputationalMathematics/Source/LeVeque/Chapter01/RiemannLocalRoutineInterface.lean'
for p,label in [(u,'update-before-localization'),(s,'source-build-01')]:
    (E/(label+'.lean.snapshot')).write_bytes(p.read_bytes())
x=u.read_text(encoding='utf8')
start=x.index('    (routine : Routine law Result Information)')
end=x.index('    (oldDensity newDensity',start)
x=x[:start]+'''    (routine : Routine law Result Information)
    (left center right : Fin m → ℝ)
    (hleftState : left ∈ law.states) (hcenterState : center ∈ law.states)
    (hrightState : right ∈ law.states)
    {a b s t : ℝ} (hab : a < b) (hst : s < t)
    (hleftDomain : routine.domain
      ⟨left, center, hleftState, hcenterState, t - s, sub_pos.mpr hst⟩)
    (hrightDomain : routine.domain
      ⟨center, right, hcenterState, hrightState, t - s, sub_pos.mpr hst⟩)
'''+x[end:]
x=x.replace('(physicalFlux : Face → ℝ → Fin m → ℝ)', '(leftPhysicalFlux rightPhysicalFlux : ℝ → Fin m → ℝ)')
x=x.replace('(physicalFlux leftFace)', 'leftPhysicalFlux').replace('(physicalFlux rightFace)', 'rightPhysicalFlux')
x=x.replace('physicalFlux leftFace', 'leftPhysicalFlux').replace('physicalFlux rightFace', 'rightPhysicalFlux')
x=x.replace('    let problem := adjacentProblem law leftCell rightCell old hstates (t - s) (sub_pos.mpr hst)\n', '''    let leftProblem : Problem law := ⟨left, center, hleftState, hcenterState, t - s, sub_pos.mpr hst⟩
    let rightProblem : Problem law := ⟨center, right, hcenterState, hrightState, t - s, sub_pos.mpr hst⟩
''')
x=x.replace('(problem leftFace)', 'leftProblem').replace('(problem rightFace)', 'rightProblem')
x=x.replace('(old (leftCell leftFace))', 'left').replace('(old (rightCell rightFace))', 'right')
x=x.replace('(old cell)', 'center').replace('old cell', 'center')
a=x.index('    (∀ face,')
b=x.index('    leftFlux =',a)
x=x[:a]+'''    leftProblem.left = left ∧ leftProblem.right = center ∧
    rightProblem.left = center ∧ rightProblem.right = right ∧
    leftProblem.duration = t - s ∧ rightProblem.duration = t - s ∧
'''+x[b:]
a=x.index(' := by\n  dsimp only',x.index('theorem routine_local_interface_contract'))
x=x[:a]+''' := by
  dsimp only
  let leftProblem : Problem law := ⟨left, center, hleftState, hcenterState, t - s, sub_pos.mpr hst⟩
  let rightProblem : Problem law := ⟨center, right, hcenterState, hrightState, t - s, sub_pos.mpr hst⟩
  let leftFlux := routine.flux leftProblem hleftDomain
  let rightFlux := routine.flux rightProblem hrightDomain
  have hfv := finiteVolumeLocalCell_error_contract oldDensity newDensity
    (fun side : Bool => if side then rightPhysicalFlux else leftPhysicalFlux)
    (fun _ : Unit => center) (fun _ side => if side then rightFlux else leftFlux)
    () false true hab hst holdDensity hnewDensity hleftFlux hrightFlux hphysicalBalance
  refine ⟨law.positive_dimension, law.hyperbolic, rfl, rfl, rfl, rfl, rfl, rfl,
    rfl, rfl, hfv.1, hfv.2.1, hfv.2.2.1, hfv.2.2.2.1,
    hfv.2.2.2.2.1, hfv.2.2.2.2.2.2.1, hfv.2.2.2.2.2.2.2.1,
    hfv.2.2.2.2.2.2.2.2, ?_⟩
  intro leftReference rightReference leftSolverBound rightSolverBound hleftError hrightError
  obtain ⟨hleftInitial, hleftMean, hleftComparison⟩ :=
    routine.reference_comparison leftProblem hleftDomain leftReference hleftError
  obtain ⟨hrightInitial, hrightMean, hrightComparison⟩ :=
    routine.reference_comparison rightProblem hrightDomain rightReference hrightError
  refine ⟨hleftInitial, hrightInitial, hleftMean, hrightMean, ?_⟩
  intro oldBound leftComparison rightComparison hold hleft hright
  exact hfv.2.2.2.2.2.2.2.2 oldBound
    (leftSolverBound + leftComparison) (rightSolverBound + rightComparison)
    hold (hleftComparison _ _ hleft) (hrightComparison _ _ hright)

end NumStability.LocalRiemannInformation
'''
# This leaf no longer uses the array-to-problem adapter.
x=x.replace('import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalRiemannInformationUpdate', 'import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalCellErrorBounds')
u.write_text(x,encoding='utf8',newline='\n')
y=s.read_text(encoding='utf8')
prefix=y[:y.index('    ∀ {Result')]
contract=x[x.index('    {Result'):x.index(' := by\n  dsimp only')]
contract=contract.replace('    {Result', '    ∀ {Result',1)
contract=contract.replace('    (oldDensity newDensity : ℝ → Fin m → ℝ)\n    (leftPhysicalFlux rightPhysicalFlux : ℝ → Fin m → ℝ)', '    (q : ℝ → ℝ → Fin m → ℝ)')
# Token substitutions avoid corrupting hypothesis identifiers.
for name,val in [('oldDensity','(fun x => q x s)'),('newDensity','(fun x => q x t)'),('leftPhysicalFlux','(fun τ => law.flux (q a τ))'),('rightPhysicalFlux','(fun τ => law.flux (q b τ))')]:
    contract=re.sub(r'\b'+name+r'\b',lambda _:val,contract)
contract=contract.replace('rightPhysicalFlux τ)) :','rightPhysicalFlux τ)),')
contract=contract.replace('(fun τ => law.flux (q b τ)) τ)) :','(fun τ => law.flux (q b τ)) τ)),')
proof=''' := by
  refine ⟨exists_biasedRoutine law bias, ?_⟩
  intro Result Information routine left center right hleftState hcenterState hrightState
    a b s t hab hst hleftDomain hrightDomain q
    holdDensity hnewDensity hleftFlux hrightFlux hphysicalBalance
  exact routine_local_interface_contract law routine left center right
    hleftState hcenterState hrightState hab hst hleftDomain hrightDomain
    (fun x => q x s) (fun x => q x t)
    (fun τ => law.flux (q a τ)) (fun τ => law.flux (q b τ))
    holdDensity hnewDensity hleftFlux hrightFlux hphysicalBalance

end NumStability
'''
s.write_text(prefix+contract+proof,encoding='utf8',newline='\n')
print(json.dumps({'updated':[str(u),str(s)]}))
