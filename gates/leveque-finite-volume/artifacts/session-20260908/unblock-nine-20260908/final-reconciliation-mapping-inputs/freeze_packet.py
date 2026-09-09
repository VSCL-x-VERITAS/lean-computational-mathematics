"""Hash this preparation packet only; not a workflow completion receipt."""
from pathlib import Path
import datetime,hashlib,json
P=Path(__file__).resolve().parent;R=P.parents[5]
def sha(b):return hashlib.sha256(b).hexdigest()
def ref(p):return {'path':p.relative_to(R).as_posix(),'sha256':sha(p.read_bytes())}
def load(p):return json.loads(p.read_bytes())
def write(n,v):
    with (P/n).open('xb') as f:f.write((json.dumps(v,indent=2,ensure_ascii=True)+'\n').encode())
for stem in ['capture-01','assemble-01','finalize-01']:
    e=load(P/(stem+'-exit.json'));assert type(e['exit_code']) is int and e['exit_code']==0
    assert e['output_sha256']==sha((P/(stem+'-output.txt')).read_bytes())
files=[ref(p)|{'bytes':p.stat().st_size} for p in sorted(P.rglob('*')) if p.is_file() and '__pycache__' not in p.parts and p.name not in {'manifest.json','receipt.json'}]
write('manifest.json',{'schema':1,'kind':'reconciliation-mapping-preparation-manifest','source_acceptance':False,'files':files})
write('receipt.json',{'schema':1,'status':'PREPARATION_FROZEN_ROOT_REVIEW_REQUIRED','utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
 'manifest':ref(P/'manifest.json'),'review':ref(P/'README.md'),'final_origin_preparer':ref(P/'derive_final_origin_spec.py'),
 'summary':ref(P/'observed-01/summary.json'),'per_row_map':ref(P/'per-row-selection-map.json'),
 'transport_inputs':ref(P/'controlled-transport-inputs.json'),'actual_capture_exit':0,'actual_assembly_exit':0,'actual_finalization_exit':0,
 'check_receipts':[ref(P/'checks.json'),ref(P/'final-checks.json')],
 'boundaries':{'gate_mutated':False,'git_mutated':False,'topology_mutated':False,'released_files_mutated':False,'model_roles_run':False,
 'actual_request_created':False,'candidate_created':False,'epoch_created':False,'source_acceptance_claimed':False},
 'remaining':['Two actual audit decisions/qualified source bindings; final all41 gate and current complete evidence.',
 'Real committed work heads and authorized topology pins; root-reviewed actual origin mapping and payloads.',
 'Final origin audit/proof membership, actual candidate and all eight candidate/pristine replay receipts.']})
print(json.dumps({'receipt':ref(P/'receipt.json'),'manifest':ref(P/'manifest.json'),'files':len(files)}))
