from pathlib import Path
import hashlib,json,ast
F=Path(__file__).resolve().parent;D=F.parent;S=D.parent;R=S.parents[3]
raw=lambda p:Path('\\\\?\\'+str(p.resolve())).read_bytes()
ref=lambda p:{'path':p.resolve().as_posix(),'sha256':hashlib.sha256(raw(p)).hexdigest()}
read=lambda p:json.loads(raw(p))
def write(n,d):
    p=F/n
    with p.open('x',encoding='utf-8',newline='\n') as f:json.dump(d,f,indent=2);f.write('\n')
    return ref(p)
mapping=read(F/'producer-reuse-map.json')
for item in mapping:
    for producer in item['producer_candidates']:
        if producer.get('owner_path','').endswith('InitialValue/RiemannJump.lean'):
            producer.clear();producer.update({'name':'NumStability.IsRiemannData.hasJumpAt','owner':ref(R/'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/RiemannDataJump.lean'),'selection_basis':'Actual canonical declaration owner resolved with current project rg; source wrapper calls this theorem.'})
    for evidence in item['evidence']:
        if evidence.get('path','').endswith('dim-local-characteristic-witness/reuse-searches.json'):
            evidence.clear();evidence.update(ref(D/'dim-local-characteristic-witness/searches.json'))
mapref=write('producer-reuse-map-reviewed.json',mapping)
data=read(F/'report-data.json');assert data['progress']=={'formalized':39,'denominator':41,'remaining':2,'percentage':95.12,'total_inventory':57,'skipped':16,'deferred':0,'nine_closed':7}
assert len(data['nine_rows'])==9 and len(data['all_accepted_rows'])==39
for row in data['all_accepted_rows']:
    p=Path(row['decision']['path']);assert ref(p)==row['decision'];j=read(p);assert j['accepted'] and j['classification']==row['classification']
newcheck=S/'unblock-nine-high-resolution-complete-declarations-exit.json';nc=read(newcheck);assert nc['exit_code']==0
newout=S/'unblock-nine-high-resolution-complete-declarations-output.txt';assert ref(newout)['sha256']==nc['output_sha256']
text=raw(F/'report-draft.md').decode().replace('producer-reuse-map.json','producer-reuse-map-reviewed.json')
text=text.replace("The full current accepted set has {'faithful-equivalent': 35, 'faithful-stronger': 4}.", 'The full current accepted set has 35 faithful-equivalent and 4 faithful-stronger classifications.')
text+='\n**Additional actual native result received before report freeze.** The current all41 declaration/axiom probe completed with exit0: `'+nc['command']+'`, '+str(nc['elapsed_ms'])+' ms. Receipt ['+newcheck.name+'](<'+newcheck.as_posix()+'>), SHA256 `'+ref(newcheck)['sha256']+'`; output SHA256 `'+nc['output_sha256']+'`. This does not assert that all41 source audits passed, nor replace final validation after the remaining Info-certified production increment.\n'
with (F/'report-draft-reviewed.md').open('x',encoding='utf-8',newline='\n') as f:f.write(text)
syntax=[]
for p in F.glob('*.py'):
    t=raw(p).decode();ast.parse(t);compile(t,str(p),'exec');syntax.append(ref(p))
live=[]
for item in read(F/'captured-inputs.json')['inputs']:
    p=Path(item['path']);now=ref(p);live.append({'path':item['path'],'captured_sha256':item['sha256'],'current_sha256':now['sha256'],'unchanged':now==item})
verification=write('verification.json',{'status':'REVIEW-DRAFT-CONTENT-VALIDATED-NOT-GATE-PASS','seven_accepted_decisions_verified':True,'all39_recorded_accepted_decisions_verified':True,'nine_rows':9,'gate_check_actual_exit':data['gate_check_actual_exit'],'gate_snapshot':data['gate_snapshot'],'producer_map':mapref,'current_all41_native_receipt':ref(newcheck),'current_all41_native_output':ref(newout),'syntax':syntax,'input_observations':live,'publication_or_integration_asserted':False})
manifest=write('manifest.json',{'status':'CURRENT REVIEW DRAFT','report':ref(F/'report-draft-reviewed.md'),'data':ref(F/'report-data.json'),'producer_map':mapref,'verification':verification,'files':[ref(p) for p in sorted(F.iterdir()) if p.is_file() and p.name not in ('manifest.json','final-receipt.json')],'root_must_derive_final_after_actual_all41_pass':True})
receipt=write('final-receipt.json',{'status':'FROZEN-CURRENT-REVIEW-DRAFT','report':ref(F/'report-draft-reviewed.md'),'manifest':manifest,'verification':verification,'gate_check_actual_exit':1,'final_gate_pass':False,'source_gate_audit_git_mutation':False,'remaining_rows':['LEV-CH01-RIEMANN-INTERFACE-FLUX','LEV-CH01-DIMENSIONAL-SPLITTING']})
print(json.dumps({'receipt':receipt,'report':ref(F/'report-draft-reviewed.md'),'verification':verification},indent=2))
