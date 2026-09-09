"""Bind the current 38-row context refresh to actual final source/declaration evidence."""
from pathlib import Path
import hashlib,importlib.util,json,os
D=Path(__file__).resolve().parent;S=D.parent;R=S.parents[3];H=D/'gate-helpers'
assert os.name!='nt'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
support=H/'qualified_row_support_v2.py'
assert sha(support)=='c72831c1518610fe7c67bba22322b7418ced275a731bf3b474d9ed6ae8fe64da'
spec=importlib.util.spec_from_file_location('qualified_batch_input',support);q=importlib.util.module_from_spec(spec);spec.loader.exec_module(q)
gate_path=R/'gates/leveque-finite-volume/chapter-01.json';gate=json.loads(gate_path.read_bytes())
closed=sorted(r['id'] for r in gate['rows'] if r['status'] in ('PROVED','REUSED'));assert len(closed)==38
paths={'proof_manifest':D/'local-complete-declaration-manifest.json','check':D/'LocalCompleteDeclarations.lean',
 'receipt':S/'unblock-nine-local-complete-declarations-02-exit.json','output':S/'unblock-nine-local-complete-declarations-02-output.txt'}
ref=lambda p:{'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
native={key:ref(p) for key,p in paths.items()}
receipt=json.loads(paths['receipt'].read_bytes());manifest=json.loads(paths['proof_manifest'].read_bytes())
assert receipt['exit_code']==0 and receipt['output_sha256']==sha(paths['output'])
assert receipt['argv']==['lake','env','lean',manifest['check_file']]
assert all(sha(R/f['path'])==f['sha256'] for f in manifest['files'])
bindings=q.gate_checker().current_context(gate_path,1)['bindings']
data={'schema':1,'expected_gate_sha256':sha(gate_path),'expected_closed_row_ids':closed,'current_bindings':bindings,
 'current_native':native,'runtime_pins':ref(H/'batch-rebind-runtime-pins.json')}
out=D/'current-accepted-batch-input.json'
with out.open('xb') as f:f.write((json.dumps(data,indent=2)+'\n').encode())
print(json.dumps({'input':ref(out),'closed_rows':len(closed),'bindings':bindings}))
