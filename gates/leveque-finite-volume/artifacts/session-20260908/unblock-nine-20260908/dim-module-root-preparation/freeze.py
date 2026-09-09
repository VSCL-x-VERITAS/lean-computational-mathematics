"""Freeze reviewed helper preparation without executing any operational helper."""
from pathlib import Path
import ast, datetime, hashlib, json, os
P=Path(__file__).resolve().parent;D=P.parent
R=next(p for p in P.parents if (p/'lean-toolchain').is_file())
exec(compile((D/'fv-local-domain-review/native-long-path-io.py').read_bytes(),'native-long-path-io.py','exec'),globals())
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def ref(p):return {'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
def put(p,data):
    with p.open('x',encoding='utf-8',newline='\n') as f:json.dump(data,f,indent=2);f.write('\n')
def refs_in(obj):
    if isinstance(obj,dict):
        if set(obj)=={'path','sha256'}:yield obj
        else:
            for value in obj.values():yield from refs_in(value)
    elif isinstance(obj,list):
        for value in obj:yield from refs_in(value)
inputs={};outputs={}
for name in ['derivation.json','derivation-v2.json']:
    data=json.loads((P/name).read_bytes())
    for item in refs_in(data):
        path=R/item['path'];assert sha(path)==item['sha256'],item['path']
        inputs[item['path']]=item
    for item in data['derivations']:
        before=(R/item['parent']['path']).read_text(encoding='utf-8')
        for delta in item['replacements']:
            assert before.count(delta['before'])==1
            before=before.replace(delta['before'],delta['after'])
        assert before.encode()==(R/item['output']['path']).read_bytes()
        ast.parse(before);outputs[item['output']['path']]=item['output']
    deps=json.loads((R/data['dependencies']['path']).read_bytes())
    for item in refs_in(deps):
        assert sha(R/item['path'])==item['sha256'],item['path'];inputs[item['path']]=item
    outputs[data['dependencies']['path']]=data['dependencies']
tests=json.loads((P/'checks-01/checks-output.json').read_bytes())
receipt=json.loads((P/'checks-01/receipt.json').read_bytes())
assert receipt['exit_code']==0 and tests['count']==92 and all(x['result']=='PASS' for x in tests['checks'])
assert sha(P/'checks-01/stdout.txt')==receipt['stdout_sha256']
assert sha(P/'checks-01/stderr.txt')==receipt['stderr_sha256'] and (P/'checks-01/stderr.txt').read_bytes()==b''
assert sha(P/'checks.py')==receipt['checker_sha256']
plan=json.loads((P/'module-root-extension.json').read_bytes())
for item in plan['modules']:
    assert (R/item['mirror']['path']).read_bytes()==(R/item['upstream']['path']).read_bytes()
    assert sha(R/item['compiled']['path'])==item['compiled']['sha256']
for name in ['.faithfulness-audit/scripts/common.py','.faithfulness-audit/scripts/prepare_audit.py',
             'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/fv-local-domain-review/native-long-path-io.py']:
    inputs[name]=ref(R/name)
files=[]
for path in sorted(P.rglob('*')):
    if path.is_file():files.append(ref(path))
final=json.loads((P/'derivation-v2.json').read_bytes())
manifest={'format':'reviewed-exact-dim-module-root-helper-preparation-1',
    'reviewed_at':datetime.datetime.now(datetime.timezone.utc).isoformat(),
    'recommended_revision':'v2','helpers':[x['output'] for x in final['derivations']],
    'dependencies':final['dependencies'],'module_root_extension':final['module_root_extension'],
    'spec_extension':ref(P/'spec-extension-v2.json'),
    'inputs':list(inputs.values()),'generated_outputs':list(outputs.values()),'artifacts':files,
    'native_checks':ref(P/'checks-01/receipt.json'),'check_count':92,
    'operational_preparation_runs':0,'role_launches':0,'released_validator_runs':0,
    'gate_mutations':0,'production_mutations':0,'source_acceptance':False,
    'historical_canonical_five_hashes_not_asserted_current':True}
put(P/'manifest.json',manifest)
put(P/'receipt.json',{'format':'helper-preparation-freeze-1','manifest':ref(P/'manifest.json'),
    'review':ref(P/'REVIEW.md'),'native_test_receipt':ref(P/'checks-01/receipt.json'),
    'test_output':ref(P/'checks-01/checks-output.json'),'actual_test_exit_code':0,'check_count':92,
    'preserved_parent_and_generated_hashes':True,'exact_real_mirrors_verified':True,
    'source_acceptance':False,'operational_runs':0})
print(json.dumps({'manifest':ref(P/'manifest.json'),'receipt':ref(P/'receipt.json'),
                  'helpers':manifest['helpers'],'dependencies':manifest['dependencies']},indent=2))
