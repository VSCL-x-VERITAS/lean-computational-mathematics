"""Freeze only additive publication-preparation artifacts, never publication."""
from pathlib import Path
import hashlib
import importlib.util
import json

P=Path(__file__).resolve().parent
R=P.parents[5]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
pin=lambda p:{'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
def put(name,obj):
    with (P/name).open('x',encoding='utf-8',newline='\n') as f:f.write(json.dumps(obj,indent=2)+'\n')

checker=P/'check-publication-allowlist-v3.py'
assert sha(checker)=='8022f5e367fd9bdb8081e30634b29a038925211e2724a674c2022a380df7adc7'
spec=importlib.util.spec_from_file_location('v3',checker)
m=importlib.util.module_from_spec(spec); spec.loader.exec_module(m)
policy=P/'policy-final-02.json'; p=json.loads(policy.read_bytes()); m.verify_policy(p)
assert sha(policy)=='0dc6d8d74c98c51284170c6c50119bf5423b53d663e8dcb0cfea02f46715ca10'
assert len(p['archives'])==5
for a in p['archives']:
    for key in ('receipt','archive'): assert sha(R/a[key]['path'])==a[key]['sha256']
    assert m.disposition(a['raw']['path'],p)[0]=='exclude'
assert m.disposition('.faithfulness-audit/VERSION',p)[0]=='exclude'
for label in ('final-policy-discovery-01','final-policy-prepare-01','final-policy-tests-01','final-policy-derive-02'):
    receipt=json.loads((P/('run-'+label)/'receipt.json').read_bytes())
    assert type(receipt['exit_code']) is int and receipt['exit_code']==0
    assert receipt['output_sha256']==sha(P/('run-'+label)/'output.txt')
names=['discover-final-policy.py','prepare-final-policy.py','derive-policy-final-02.py',
       'extend-final-policy-receipts.py','test-final-policy.py','freeze-final-policy.py',
       'policy-final-01.json','policy-final-01-derivation.json','policy-final-02.json','policy-final-02-derivation.json',
       'remaining-final-policy-inputs.json','FINAL-POLICY-REVIEW.md','receipt-extension.template.json']
files=[P/x for x in names]
for name in ['discovery-final-policy-01']+['run-'+x for x in
             ('final-policy-discovery-01','final-policy-prepare-01','final-policy-tests-01','final-policy-derive-02')]:
    files.extend(x for x in sorted((P/name).iterdir()) if x.is_file())
put('final-policy-manifest.json',{'schema':1,'status':'PREPARATION_FROZEN_ROOT_REVIEW_REQUIRED',
    'files':[pin(x) for x in files],'selected_policy':pin(policy),
    'unchanged_checker':pin(checker),'unchanged_base_policy':pin(P/'policy.json'),
    'publication_complete':False,'stage_or_git_mutation':False})
put('final-policy-receipt.json',{'schema':1,'status':'PREPARATION_FROZEN_ROOT_REVIEW_REQUIRED',
    'manifest':pin(P/'final-policy-manifest.json'),'policy':pin(policy),
    'review':pin(P/'FINAL-POLICY-REVIEW.md'),'checker':pin(checker),
    'exact_sources':46,'actual_audit_directories':21,'exact_session_receipts':183,
    'exact_graph_paths':6,'archives':5,'synthetic_tests':8,'actual_preparation_exits':[0,0,0,0],
    'final_operational_screen_run':False,'publication_complete':False})
print(json.dumps({'receipt':pin(P/'final-policy-receipt.json'),'manifest':pin(P/'final-policy-manifest.json'),
    'policy':pin(policy),'publication_complete':False},indent=2))
