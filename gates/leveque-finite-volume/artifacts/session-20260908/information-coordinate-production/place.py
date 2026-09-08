from pathlib import Path
import hashlib,json,re,subprocess
P=Path(__file__).resolve().parent;R=P.parents[4];S=P.parent;draft=S/'information-coordinate-sweep-draft'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def bind(p):return dict(path=p.relative_to(R).as_posix(),sha256=sha(p))
pins={draft/'manifest.json':'f97788bf1565c46bd16b1a6a961f4ea2c417d1568192be96373a771acb45148f',draft/'final-receipt.json':'9874960cb0e89b2445ab9a52f1950631a03e3736a7c264da3a7cf58394395229',draft/'full04-input.lean':'5dfbdec6ccfa0380cc17d4d609b1a616494aeb4cc41c9c2bfc641ade74db2dae'}
for p,h in pins.items():assert sha(p)==h,p
manifest=json.loads((draft/'manifest.json').read_bytes())
for b in manifest['fragments']:assert sha(R/b['path'])==b['sha256']
base=S/'cartesian-coordinate-line-composition-draft/final03-input.lean';assert sha(base)=='80c1f757cb9f214652494b6b7e4f8e6b962f3af16ea5f59ac955d2ad896d8c67'
geom=S/'cartesian-coordinate-line-composition-draft/Composition.lean.fragment';assert sha(geom)=='aecdafbf5fae8c5384a5df84f7e33cb0365b3e9b467d66b0aa5dcdfc0559c014'
FV='ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/'
paths=[FV+x for x in ['RiemannInformationCoordinateUpdate.lean','RiemannInformationCoordinateSweep.lean','CartesianGridGeometry.lean','CartesianCoordinateUpdate.lean','Examples/LeftStateCoordinateSweep.lean']]
for p in paths:assert not (R/p).exists(),p
cmd=['rg','-n',r'\b(RiemannInformationCoordinate|CartesianGrid|CartesianCoordinateUpdate|LeftStateCoordinateSweep)\b','ComputationalMathematics','.lake/packages/mathlib/Mathlib','-g','*.lean']
run=subprocess.run(cmd,cwd=R,stdout=subprocess.PIPE,stderr=subprocess.STDOUT);assert run.returncode==1
search=P/'search-01.txt';assert not search.exists();search.write_bytes(run.stdout)

def blocks(path):
 t=path.read_text(encoding='utf-8');t=re.sub(r'/--.*?-/\s*','',t,flags=re.S)
 matches=list(re.finditer(r'(?m)^(?:@\[[^\n]*\]\s*)?(?:noncomputable )?(?:def|theorem)\s+([\w.]+)',t))
 starts=[]
 for m in matches:
  prior=re.search(r'(?m)^omit [^\n]+ in\s*\Z',t[:m.start()]);starts.append(prior.start() if prior else m.start())
 result={}
 for i,m in enumerate(matches):
  v=t[starts[i]:starts[i+1] if i+1<len(matches) else len(t)]
  v=re.split(r'(?m)^(?:end |namespace |variable |open |#check|#print)',v)[0].strip()+'\n'
  result[m.group(1)]=v
 return result

core=blocks(draft/'Core.lean.fragment');cart=blocks(draft/'Cartesian.lean.fragment');witness=blocks(draft/'Witness.lean.fragment');oldgrid=blocks(base);oldgeom=blocks(geom)
common='''variable {D : Type*} [DecidableEq D] {m : ℕ}
variable {laws : D → OneDimensionalHyperbolicConservationLaw (Fin m)}
variable {Result : (d : D) → HyperbolicRiemannProblem (laws d) → Type*}
variable {Information : D → Type*}
variable (methods : (d : D) → ℝ → RiemannInformationFluxMethod (laws d) (Result d) (Information d))
'''
records=[]
def write(index,namespace,imports,description,prelude,names,parts):
 path=R/paths[index];data='/-\nSPDX-License-Identifier: MIT\n-/\n\n'+''.join('import '+x+'\n' for x in sorted(imports))+'\n/-!\n'+description+'\n-/\n\nnamespace '+namespace+'\n\n'+prelude+'\n\n'+'\n'.join(parts)+'\nend '+namespace+'\n'
 assert not re.search(r'\b(sorry|admit|axiom)\b',data)
 path.write_bytes(data.encode('utf-8'))
 records.append(dict(path=paths[index],module=paths[index][:-5].replace('/','.'),sha256=sha(path),declarations=[namespace+'.'+n for n in names],lines=len(data.splitlines())))

update=['FaceAdmitted','StageAdmitted','selectedFaceFlux','guardedRule','normalFaceFlux_of_admitted','admitted_face_observation','normalFaceFlux_fallback_independent','advance_fallback_independent','admitted_cell_mass_balance','admitted_finite_line_mass_balance']
sweep=['SweepAdmitted','sweepAdmitted_fallback_independent','sweep_fallback_independent','admission_at_prefix','executed_face_uses_selected_solve','admitted_two_stage_balance']
write(0,'NumStability.RiemannInformationCoordinate',['ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineBalance','ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationFluxMethod'],'# Admitted information routines in coordinate-line updates\n\nAn actual adjacent problem supplies the selected result and extracted face flux.\nThe off-domain extension has no solver meaning; admitted updates are independent\nof it. Cell and finite-line balances reuse the canonical shared-face executor.\nNo returned field, trace, accuracy assertion or total-routine assumption is added.','open scoped BigOperators\n\n'+common,update,[core[n] for n in update])
write(1,'NumStability.RiemannInformationCoordinate',['ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineSweep','ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationCoordinateUpdate'],'# Admitted successive coordinate-line updates\n\nEvery stage is admitted on its actual preceding output. The canonical ordered\nsweep is unchanged, and all operational results are independent of the arbitrary\noff-domain extension. Initial admission does not imply later admission.',common,sweep,[core[n] for n in sweep])

geometry_names=['cellBox','cellVolume','faceArea','cellVolume_pos','cellVolume_eq_width_mul_area','cellBox_volume','faceArea_update','tangentialFaceBox','tangentialFaceBox_volume','tangentialFaceBox_update','facePoint','facePoint_normal','facePoint_transverse','shared_face_position']
grid_names=geometry_names[:6]
def axes(v):
 v=v.replace('(grid : TensorGrid D)','(axes : D → OneDimensionalFiniteVolumeGrid)').replace('Cell D','(D → ℤ)')
 v=v.replace('grid.axis','axes')
 for n in sorted(geometry_names,key=len,reverse=True):v=v.replace('grid.'+n,'CartesianGrid.'+n+' axes')
 v=v.replace('TensorGrid.','CartesianGrid.').replace('CartesianLineCompositionDraft.','CartesianGrid.')
 v=re.sub(r'\bgrid\b','axes',v)
 return v
parts=[]
for n in geometry_names:
 v=axes(oldgrid['TensorGrid.'+n] if n in grid_names else oldgeom[n])
 v=v.replace('def CartesianGrid.'+n,'def '+n).replace('theorem CartesianGrid.'+n,'theorem '+n)
 parts.append(v)
write(2,'NumStability.CartesianGrid',['ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface','Mathlib.MeasureTheory.Measure.Lebesgue.Basic'],'# Measured Cartesian finite-volume geometry\n\nThe data are an axis family of existing one-dimensional grids. Cell volume is\nthe product of widths; face area is the measure in transverse coordinates.\nNo nominal tensor-grid wrapper, logical chart, or PDE solver is introduced.', 'open MeasureTheory\nopen scoped BigOperators\n\nvariable {D : Type*} [Fintype D] [DecidableEq D]',geometry_names,parts)

consumer=['areaWeightedRule','cartesian_full_line_update','line_admission','selectedFaceFlux_on_line','guardedRule_eq_areaWeightedRule','cartesian_line_update','cartesian_measured_balance']
parts=[]
for n in consumer:
 v=axes(cart[n]).replace('[line, ','[').replace('[line]','[]')
 parts.append(v)
prelude=common.replace('[DecidableEq D]','[Fintype D] [DecidableEq D]')+'''
open MeasureTheory RiemannInformationCoordinate

local notation "line" => (fun (d : D) (base : D → ℤ)
  (state : (D → ℤ) → Fin m → ℝ) (j : ℤ) => state (Function.update base d j))
'''
write(3,'NumStability.CartesianCoordinateUpdate',['ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianGridGeometry','ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationCoordinateUpdate'],'# Cartesian consumers of full-line numerical flux rules\n\nArea weighting gives the actual one-dimensional finite-volume line restriction\nfor an arbitrary full-line flux rule. Admitted information routines specialize\nthat correspondence. Consistency or accuracy is not inferred for arbitrary rules.\nThe local line notation expands to a lambda and introduces no public alias.',prelude,consumer,parts)

example_names=['left_rule','left_sweep_admitted','left_unit_update','left_two_stage_nonvacuity']
method='(fun (_d : Fin 2) (_dt : ℝ) => LeftStateInformationFlux.method (StationaryRiemannField.transportLaw (m := 1)))'
stripe='(fun cell : Fin 2 → ℤ => if cell 1 = 0 then (0 : Fin 1 → ℝ) else 1)'
parts=[]
for n in example_names:
 v=witness[n].replace('leftMethods, ','').replace(', leftMethods','')
 v=v.replace('leftMethods',method).replace('Cell (Fin 2)','(Fin 2 → ℤ)')
 v=v.replace('simp [TensorLinesDraft.Witness.stripeState]','simp')
 v=v.replace('TensorLinesDraft.Witness.stripeState',stripe)
 parts.append(v)
write(4,'NumStability.LeftStateCoordinateSweep',['ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.LeftStateInformationFlux','ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationCoordinateSweep'],'# Two directional steps of the left-state information method\n\nThe existing ordered-pair routine and unit-speed law give a concrete positive\nunit-step sweep with distinct outputs. Its result contains no space-time field.\nThis finite example does not establish general accuracy or convergence.','open RiemannInformationCoordinate',example_names,parts)
out=P/'placement-map.json';assert not out.exists()
out.write_bytes((json.dumps(dict(schema=1,status='PLACED_UNVERIFIED',files=records,frozen_inputs=[bind(p) for p in list(pins)+[base,geom]+[R/x['path'] for x in manifest['fragments']]],search=dict(command=cmd,exit_code=run.returncode,output=bind(search)),eliminated=['generic locality alias','scratch Cell/line public aliases','fieldMethods/leftMethods aliases','old nominal TensorGrid wrapper','exact total LineSolver class'],geometry_transport='New axis-family observations are compared at old TensorGrid.axis; the unused old directions field is not reconstructed and no nominal grid equivalence is asserted.',source_acceptance=False),indent=2)+'\n').encode())
print(json.dumps(dict(files=len(records),declarations=sum(len(x['declarations']) for x in records),manifest_sha256=sha(out))))
