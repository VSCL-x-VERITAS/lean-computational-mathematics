"""Freeze only this additive documentation/input packet; no workflow action."""
import ast,hashlib,json,subprocess,sys
from pathlib import Path
P=Path(__file__).resolve().parent;D=P.parent;S=D.parent;R=S.parents[3];W=R.parent
def sha(b):return hashlib.sha256(b).hexdigest()
def load(p):return json.loads(p.read_bytes())
def ref(p):return {'path':p.relative_to(R).as_posix(),'sha256':sha(p.read_bytes())}
def new(p,v):
    with p.open('xb') as f:f.write((json.dumps(v,indent=2,ensure_ascii=True)+'\n').encode())
def copy(p,q):
    with q.open('xb') as f:f.write(p.read_bytes())
copy(P/'final-origin-inputs.template.json',P/'final-origin-inputs.checked-01.json.snapshot')
x=load(P/'final-origin-inputs.template.json');x['complete_declaration_manifest']=ref(D/'final-certified-complete-declarations/manifest.json')
(P/'final-origin-inputs.template.json').write_bytes((json.dumps(x,indent=2)+'\n').encode())
schema=W/'formalization-collaboration-v5.0.1/skills/book-formalization-migration/references/schemas/reconciliation-epoch.schema.json'
assert sha(schema.read_bytes())=='15bb5ad7c90672bdeb7466f6343a6f8622e7c07b34567a16fd19c95e8b626fd3'
copy(schema,P/'epoch-schema.snapshot.json')
new(P/'schema-provenance.json',{'source_path':schema.as_posix(),'source_sha256':sha(schema.read_bytes()),'snapshot':ref(P/'epoch-schema.snapshot.json'),'exact_bytes':True,'authority':'Unmodified schema reference only; no epoch or acceptance.'})
rootrel=P.relative_to(R).as_posix();cat={'path':rootrel+'/committed-capture/catalogue.json','sha256':None};rev={'path':rootrel+'/actual-root-mapping-review.json','sha256':None}
new(P/'payload-spec.template.json',{'catalogue':cat,'review':rev})
new(P/'mapping-review.template.json',{'schema':1,'status':None,'source_acceptance':False,'review':None,'mapping_semantics_sha256':None,
 'evidence':[ref(P/'README.md'),ref(P/'controlled-transport-inputs.json'),ref(P/'per-row-selection-map.json'),ref(D/'final-organization-manual-review/ROOT-ADOPTION.md')]})
new(P/'mapping-spec.template.json',{'catalogue':cat,'review':rev,'topology':{'path':'.formalization/library-topology.json','sha256':None},
 'request':{'path':None,'sha256':None},'status':{'path':None,'sha256':None},'epoch_schema':ref(P/'epoch-schema.snapshot.json'),
 'payload_files':{'path':rootrel+'/reviewed-payloads/payload-files.json','sha256':None}})
gate=R/'gates/leveque-finite-volume/chapter-01.json';expected=load(P/'observed-01/summary.json')['current_gate']['sha256']
assert sha(gate.read_bytes())==expected;copy(gate,P/'observed-gate.json.snapshot')
checks=[]
for name in ['capture_current_mapping.py','derive_final_origin_spec.py','assemble_preparation.py','finalize_preparation.py']:
    ast.parse((P/name).read_bytes());checks.append({'case':'final-syntax-'+name,'source':ref(P/name),'result':'PASS'})
inp=P/'final-origin-inputs.template.json';out=P/'null-final-input-MUST-NOT-EXIST.json'
argv=[sys.executable,'-B',str(P/'derive_final_origin_spec.py'),'--root',str(R),'--inputs',str(inp),'--inputs-sha256',sha(inp.read_bytes()),'--output',str(out)]
run=subprocess.run(argv,stdout=subprocess.PIPE,stderr=subprocess.STDOUT);(P/'null-final-input-rejection-output.txt').write_bytes(run.stdout)
assert run.returncode!=0 and not out.exists() and b'stale .formalization/library-topology.json' in run.stdout
checks.append({'case':'final-null-input-refused','command':argv,'input':ref(inp),'helper':ref(P/'derive_final_origin_spec.py'),'actual_exit':run.returncode,'output':ref(P/'null-final-input-rejection-output.txt'),'output_not_created':True})
m=load(D/'final-certified-complete-declarations/manifest.json'); ns=sorted(m['declarations'])
expected='import ComputationalMathematics.Source.LeVeque.Chapter01\n\n'+'\n'.join('#check '+n+'\n#print axioms '+n for n in ns)+'\n'
assert (R/m['check_file']).read_text(encoding='utf-8').replace('\r\n','\n')==expected
checks.append({'case':'candidate-existing-exact-41-native-input-format','manifest':ref(D/'final-certified-complete-declarations/manifest.json'),'check_file':ref(R/m['check_file']),'result':'PASS'})
new(P/'final-checks.json',{'source_acceptance':False,'checks':checks,'scope':'Actual syntax/input/refusal/format checks only; no candidate replay.'})
print(json.dumps({'status':'PREPARATION_ONLY','checks':len(checks),'helper_sha256':sha((P/'derive_final_origin_spec.py').read_bytes()),'schema_sha256':sha(schema.read_bytes())}))
