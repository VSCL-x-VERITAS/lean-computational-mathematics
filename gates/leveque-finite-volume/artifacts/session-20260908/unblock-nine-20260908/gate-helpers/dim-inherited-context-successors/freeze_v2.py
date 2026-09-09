"""Hash-only final freeze; no helpers imported or operational validators invoked."""
import hashlib,json,os
from pathlib import Path
P=Path(__file__).resolve().parent;H=P.parent;R=H.parents[5]
def n(p):return '\\\\?\\'+str(p)
def raw(p):
    with open(n(p),'rb') as f:return f.read()
def ref(p):
    name=p.relative_to(R).as_posix() if p.is_relative_to(R) else str(p)
    return {'path':name,'sha256':hashlib.sha256(raw(p)).hexdigest(),'bytes':len(raw(p))}
def read(p):return json.loads(raw(p))
def put(p,value):
    with open(n(p),'xb') as f:f.write((json.dumps(value,indent=2)+'\n').encode())
def path(item):
    p=Path(item['path']);return p if p.is_absolute() else R/p
observed={}
def check(item):
    p=path(item);actual=ref(p)
    assert actual['sha256']==item['sha256'],str(p)
    observed[actual['path']]=actual
def refs(value):
    if isinstance(value,dict):
        if isinstance(value.get('path'),str) and isinstance(value.get('sha256'),str):check(value)
        for x in value.values():refs(x)
    elif isinstance(value,list):
        for x in value:refs(x)

derivation=read(P/'derivation.json');refs(derivation)
deps=read(H/'source-context-v5-validator-dependencies.json');refs(deps)
olddeps=read(H/'source-context-v4-validator-dependencies.json');refs(olddeps)
summary=read(P/'guard-summary.json');refs(summary)
assert summary['passed'] and summary['inherited_tests']==43 and summary['added_tests']==27
assert summary['run']==70 and summary['failures']==summary['errors']==summary['skipped']==0
for label in ('derive-01','guards-01'):
    receipt=read(P/(label+'-receipt.json'));refs(receipt)
    assert receipt['actual_exit']==0 and not receipt['operational_validation'] and not receipt['gate_mutation']
for item in derivation['contexts']:
    context=read(path(item));refs(context)
for filename in ('derive-high-resolution-context-helpers.py','test-high-resolution-context-helpers.py',
                 'high-resolution-context-validation.fragment.py','high-resolution-context-helper-derivation.json',
                 'test-source-context-helpers.py','test-source-context-batch-rebind.py','test-batch-rebind.py',
                 'qualified_row_support_v2.py','qualified_row_support_v3.py','rebind-accepted-row-batch-v2.py',
                 'bind-final-global-evidence-v2.py'):
    observed[ref(H/filename)['path']]=ref(H/filename)
for directory,dirs,files in os.walk(n(P)):
    assert '__pycache__' not in dirs
    for filename in files:
        p=Path(directory.removeprefix('\\\\?\\'))/filename
        observed[ref(p)['path']]=ref(p)
outputs={k:v for k,v in read(P/'derive-01-stdout.txt').items()}
manifest={'schema':1,'status':'LOCAL_GUARDS_PASS_ROOT_REVIEW_REQUIRED',
 'files':sorted(observed.values(),key=lambda x:x['path']),'outputs':outputs,
 'operational_validations':0,'gate_mutations':0,'source_acceptance':False}
put(P/'manifest.json',manifest)
receipt={'schema':1,'status':'LOCAL_GUARDS_PASS_ROOT_REVIEW_REQUIRED','manifest':ref(P/'manifest.json'),
 'review':ref(P/'REVIEW.md'),'derivation':ref(P/'derivation.json'),'outputs':outputs,
 'guard_summary':ref(P/'guard-summary.json'),'actual_tests':70,'actual_test_exit':0,
 'inherited_tests':43,'added_tests':27,'operational_validations':0,'gate_mutations':0,'source_acceptance':False}
put(P/'receipt.json',receipt)
print(json.dumps({'receipt':ref(P/'receipt.json'),'manifest':ref(P/'manifest.json'),
 'derivation':ref(P/'derivation.json'),'files':len(observed)},indent=2))
