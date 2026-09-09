from pathlib import Path
import hashlib,json
P=Path(__file__).resolve().parent
R=next(p for p in P.parents if (p/'lean-toolchain').exists())
old=P.parent/'dimensional-method-repair/Candidate.lean'
assert hashlib.sha256(old.read_bytes()).hexdigest()=='eb9fd7e8a6a528a17cbf252db2c0877dc510303fe736873f1b69d1b9c9248657'
t=old.read_text(encoding='utf-8-sig')
base='ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.'
ns='NumStability.DirectionalFiniteVolume'
header='/-\nSPDX-License-Identifier: MIT\n-/\n\n'
context='open MeasureTheory\nopen scoped BigOperators\n\nnamespace '+ns+'\n\nvariable {D : Type*} [DecidableEq D] {m : ℕ}\n\nlocal notation "Cell" => D → ℤ\nlocal notation "State" => Fin m → ℝ\n\n'
starts=[t.index('/-- Independent control-volume'),t.index('/-- Numerical old-average'),t.index('/-- A Cartesian directional'),t.index('/-- Supplied physical cells'),t.index('/-- One primary conjunction'),t.index('/-- The rejected coordinate-index')]
blocks=[t[a:b] for a,b in zip(starts,starts[1:]+[t.index('end NumStability.DirectionalMethodRepair')])]
specs=[
 ('DirectionalReference',['CellAverageEstimates'], 'Independent finite-volume directional references',blocks[0]),
 ('DirectionalReferenceError',['DirectionalReference','CoordinateLineBalance'], 'Directional update errors from independent physical references',blocks[1]),
 ('CartesianDirectionalReference',['DirectionalReference','CartesianCoordinateUpdate'], 'Cartesian realization of directional references',blocks[2]),
 ('PhysicalCoordinateGeometry',['DirectionalReference','CellVolumeAverage','@ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Hyperbolicity'], 'Physical cells and shared directional fluxes',blocks[3]),
 ('DirectionalMethodSweep',['DirectionalReferenceError','CartesianDirectionalReference','PhysicalCoordinateGeometry','CoordinateLineSweep'], 'Successive directional numerical methods with physical references',blocks[4]),
]
inventory=[]
for name,imports,title,body in specs:
 text=header+''.join('import '+(x[1:] if x.startswith('@') else base+x)+'\n' for x in imports)+'\n/-!\n# '+title+'\n\nThe physical references and numerical rules are independently supplied.\nAll admission, positive-step, domain and error hypotheses are explicit.\n-/\n\n'+context+body+'end '+ns+'\n'
 path=R/((base+name).replace('.','/')+'.lean');assert not path.exists(),path
 path.write_text(text,encoding='utf-8',newline='\n');inventory.append(dict(path=path.relative_to(R).as_posix(),module=base+name))
srcmod='ComputationalMathematics.Source.LeVeque.Chapter01.CoordinateDirectionalMethods'
statement=blocks[4][blocks[4].index('theorem directional_splitting_contract'):].split(' := by\n')[0]
statement=statement.replace('theorem directional_splitting_contract','theorem leveque01_coordinateDirectionalMethods_sourceContract')
body=' := by\n  exact DirectionalFiniteVolume.directional_splitting_contract data hdimension rule admitted hconstant\n    stages hnonempty hcover hpositive initial reference oldError faceError hreferences hadmitted hstates hold hface\n'
text=header+'import '+base+'DirectionalMethodSweep\n\n/-!\n# Successive physical directional methods for Chapter 1\n\nThis prospective correspondence uses the coordinator-selected logical-grid\ninterpretation under the recorded goal. Physical cells, shared normal fluxes,\npositive admitted stages and conditional reference errors are explicit.\nThe source does not supply a chart, boundary extension or error rate.\nFresh source-faithfulness review is required for the selected interpretation.\n-/\n\nopen MeasureTheory\nopen scoped BigOperators\n\nnamespace NumStability\nopen DirectionalFiniteVolume\nvariable {D : Type*} [DecidableEq D] {m : ℕ}\nlocal notation "Cell" => D → ℤ\nlocal notation "State" => Fin m → ℝ\n\n'+statement+body+'\nend NumStability\n'
path=R/(srcmod.replace('.','/')+'.lean');assert not path.exists();path.write_text(text,encoding='utf-8',newline='\n');inventory.append(dict(path=path.relative_to(R).as_posix(),module=srcmod))
(P/'initial-placement.json').write_text(json.dumps(inventory,indent=2)+'\n',encoding='utf-8')
(P/'old-example-fragment.lean.txt').write_text(blocks[5],encoding='utf-8')
print(json.dumps(inventory,indent=2))
