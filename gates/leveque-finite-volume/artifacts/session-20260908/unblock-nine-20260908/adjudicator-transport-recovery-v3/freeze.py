"""Freeze this preparation only; do not include or rewrite later root execution outputs."""
from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,importlib.util,ast
D=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('r',D/'recovery-v3.py')
r=importlib.util.module_from_spec(spec);spec.loader.exec_module(r)
def ref(path):return {'path':str(path),'sha256':hashlib.sha256(path.read_bytes()).hexdigest(),'bytes':len(path.read_bytes())}
def write(path,data):
    with path.open('x',encoding='utf-8') as out:json.dump(data,out,indent=2);out.write('\n')
plan=r.read(D/'dim-a2/plan.json')
assert r.sha(D/'dim-a2/plan.json')=='a3b1171226078de931417271f072a100f42eb246588340a6ae8d3e98e9c50eb8'
assert r.sha(D/'recovery-v3.py')=='a2dddf4c3d7ca324f44fe9034b76964514d4c1e4eee96ea72bb5e48f90ff9887'
for pin in plan['static_inputs']:r.verify(pin)
tests=r.read(D/'tests-exit.json');prepare=r.read(D/'dim-prepare-exit.json')
assert tests['exit_code']==prepare['exit_code']==0
assert b'Ran 30 tests' in (D/'tests-stderr.txt').read_bytes()
original=r.verify(plan['original_input']).read_bytes()
transport=r.read(r.verify(plan['original_transport']))
compact=r.verify(plan['input']).read_bytes()
assert r.reconstruct(compact,plan['mapping'],transport['inputs'])==original
old=D.parent/'adjudicator-transport-recovery/recovery-v2.py'
old_ast=ast.parse(old.read_text(encoding='utf-8'));new_ast=ast.parse((D/'recovery-v3.py').read_text(encoding='utf-8'))
functions=lambda tree:{x.name:ast.dump(x) for x in tree.body if isinstance(x,ast.FunctionDef)}
old_functions=functions(old_ast);new_functions=functions(new_ast)
unchanged=[name for name in old_functions if name!='deduplicate']
assert all(old_functions[name]==new_functions[name] for name in unchanged)
files=[D/name for name in ['derive.py','transport-functions.py.inc','recovery-v3.py','derivation.json',
    'test_recovery_v3.py','run-preparation-checks.py','tests-output.txt','tests-stderr.txt','tests-exit.json',
    'dim-prepare-output.txt','dim-prepare-stderr.txt','dim-prepare-exit.json','REVIEW.md','freeze.py',
    'dim-a2/plan.json','dim-a2/input.txt','dim-a2/manifest-before.json','dim-a2/agent-runs-before.json']]
files+=sorted(p for p in (D/'synthetic-fixtures').rglob('*') if p.is_file())
inputs=[old,D.parent/'adjudicator-transport-recovery/test_recovery_v2.py',
    D.parent/'adjudicator-transport-recovery/dim-size-analysis.json',
    D.parent/'adjudicator-transport-recovery/dim-prepare-exit.json']
manifest={'format':'additive-lossless-transport-preparation-inventory-3',
    'files':[ref(p) for p in files],'inputs':[ref(p) for p in inputs],
    'operational_input_pins':'See exact unchanged static_inputs in dim-a2/plan.json.',
    'original_packets_unchanged':True,'roles_invoked_by_preparer':False}
write(D/'manifest.json',manifest)
receipt={'format':'additive-lossless-transport-preparation-receipt-3',
    'frozen_at_utc':datetime.now(timezone.utc).isoformat(),'manifest':ref(D/'manifest.json'),
    'helper':ref(D/'recovery-v3.py'),'plan':ref(D/'dim-a2/plan.json'),
    'synthetic_tests':ref(D/'tests-exit.json'),'synthetic_test_count':30,
    'synthetic_test_exit_code':0,'actual_plan_preparation':ref(D/'dim-prepare-exit.json'),
    'actual_plan_preparation_exit_code':0,'original_characters':len(original.decode()),
    'prepared_characters':len(compact.decode()),'native_limit':r.LIMIT,
    'headroom_characters':r.LIMIT-len(compact.decode()),
    'prepared_input':ref(D/'dim-a2/input.txt'),
    'blind_reference_count':plan['mapping']['blind_reference_count'],
    'blind_referenced_bytes':plan['mapping']['blind_referenced_bytes'],
    'full_prompt_reconstruction_byte_equal':True,
    'json_all_nonformatting_bytes_unchanged':True,
    'original_wrapper_exit_code':plan['original_role_run_exit_code'],
    'unchanged_v2_operational_functions':unchanged,
    'roles_invoked_by_preparer':False,'final_adjudication_success_claimed':False}
write(D/'receipt.json',receipt)
print(json.dumps({'manifest':ref(D/'manifest.json'),'receipt':ref(D/'receipt.json'),
    'input':receipt['prepared_input'],'blind_reference_count':receipt['blind_reference_count']},indent=2))
