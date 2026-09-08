from pathlib import Path
import hashlib,json
P=Path(__file__).resolve().parent;R=P.parents[4];S=P.parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
plan=json.loads((P/'placement-map.json').read_bytes());frozen=S/'information-coordinate-sweep-draft/full04-input.lean'
assert sha(frozen)=='5dfbdec6ccfa0380cc17d4d609b1a616494aeb4cc41c9c2bfc641ade74db2dae'
namespace='NumStability.InformationCoordinatePlacementChecks';old='NumStability.InformationCoordinateSweepDraft';records=[];body='namespace '+namespace+'\n\nopen NumStability\n\n'
def add(name,statement,source,new,kind):
 global body
 body+='theorem '+name+' '+statement+' := rfl\n\n'
 records.append(dict(name=namespace+'.'+name,old=source,new=new,kind=kind))
for f in plan['files'][:2]:
 for new in f['declarations']:
  n=new.split('.')[-1];add('core_'+n,': @'+old+'.'+n+' = @'+new,old+'.'+n,new,'definitional type and value equality; proof irrelevance for theorems')
for new in plan['files'][2]['declarations']:
 n=new.split('.')[-1];source=('NumStability.TensorLinesDraft.TensorGrid.' if n in ['cellBox','cellVolume','faceArea','cellVolume_pos','cellVolume_eq_width_mul_area','cellBox_volume'] else 'NumStability.CartesianLineCompositionDraft.')+n
 statement='{D : Type*} [Fintype D] [DecidableEq D] (grid : TensorLinesDraft.TensorGrid D) :\n    '+new+' grid.axis = '+source+' grid'
 add('geometry_'+n,statement,source,new,'explicit old TensorGrid.axis transport; no nominal grid equality')
for n in ['areaWeightedRule','cartesian_full_line_update']:
 new='NumStability.CartesianCoordinateUpdate.'+n;source=old+'.'+n
 add('consumer_'+n,'{D : Type*} [Fintype D] [DecidableEq D] {m : ℕ} (grid : TensorLinesDraft.TensorGrid D) :\n    '+new+' (m := m) grid.axis = '+source+' (m := m) grid',source,new,'explicit axis transport of full-line computation/type')
for n in ['line_admission','selectedFaceFlux_on_line']:
 new='NumStability.CartesianCoordinateUpdate.'+n;source=old+'.'+n
 add('consumer_'+n,': @'+new+' = @'+source,source,new,'full method/line type equality')
params='''{D : Type*} [Fintype D] [DecidableEq D] {m : ℕ}
    {laws : D → OneDimensionalHyperbolicConservationLaw (Fin m)}
    {Result : (d : D) → HyperbolicRiemannProblem (laws d) → Type*}
    {Information : D → Type*}
    (methods : (d : D) → ℝ → RiemannInformationFluxMethod (laws d) (Result d) (Information d))
    (grid : TensorLinesDraft.TensorGrid D)'''
for n in ['guardedRule_eq_areaWeightedRule','cartesian_line_update','cartesian_measured_balance']:
 new='NumStability.CartesianCoordinateUpdate.'+n;source=old+'.'+n
 add('consumer_'+n,params+' :\n    '+new+' methods grid.axis = '+source+' methods grid',source,new,'explicit axis transport of admitted method statement')
for new in plan['files'][4]['declarations']:
 n=new.split('.')[-1];source=old+'.'+n
 add('example_'+n,': @'+new+' = @'+source,source,new,'exact frozen ordered-pair method and stripe-state computation/type')
body+='end '+namespace+'\n\n'+'\n'.join('#check '+x['name']+'\n#print axioms '+x['name'] for x in records)+'\n'
fragment=P/'Comparisons.lean.fragment';assert not fragment.exists();fragment.write_bytes(body.encode())
data=(''.join('import '+f['module']+'\n' for f in plan['files'])+'\n').encode()+frozen.read_bytes()+b'\n\n'+body.encode()
target=P/'Comparisons.lean';assert not target.exists();target.write_bytes(data)
out=P/'comparison-plan.json';assert not out.exists();out.write_bytes((json.dumps(dict(schema=1,frozen_input=dict(path=frozen.relative_to(R).as_posix(),sha256=sha(frozen)),comparison_input=dict(path=target.relative_to(R).as_posix(),sha256=sha(target)),comparisons=records,native_validation_pending=True,geometry_scope='Compare every old-grid observation at its actual axis projection. No inverse reconstructs the unused old directions field.'),indent=2)+'\n').encode())
assert len(records)==41
print(json.dumps(dict(comparisons=len(records),input_sha256=sha(target))))
