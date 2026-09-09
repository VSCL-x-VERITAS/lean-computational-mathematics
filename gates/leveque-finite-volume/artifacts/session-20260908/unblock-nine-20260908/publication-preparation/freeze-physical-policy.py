from pathlib import Path
import ast,hashlib,json
P=Path(__file__).resolve().parent
R=P.parents[5]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
ref=lambda p:dict(path=p.relative_to(R).as_posix(),sha256=sha(p))
read=lambda p:json.loads(p.read_bytes())
policy=P/'policy-final-physical-01.json'
derivation=P/'policy-final-physical-01-derivation.json'
assert sha(policy)=='e88daec76088ab2cbd8f4a0c54aeabebdc053ee4275afe521f11b97e0b38402d'
assert sha(derivation)=='9ce6300f1a58c093643bfcea0d376f78b5e8ed6a1c7ae840dcfe176f11ad4e90'
record=read(derivation)
run=P/'run-physical-policy-derive-01/receipt.json';receipt=read(run)
assert receipt['exit_code']==0
assert receipt['output_sha256']==sha(P/'run-physical-policy-derive-01/output.txt')
assert receipt['script_sha256']==sha(P/'derive-policy-physical-01.py')
assert record['changed_policy_fields']==['allow_exact','archives','exclude_exact']
assert len(record['added_production'])==13 and len(record['added_observed_session_files'])==52
assert len(record['classification_checks'])==93
for key in ('base_policy','checker','receipt_extension_rules_reused','source_build'):
    pin=record[key];assert sha(R/pin['path'])==pin['sha256']
syntax=[]
for name in ('derive-policy-physical-01.py','freeze-physical-policy.py'):
    path=P/name;source=path.read_text();ast.parse(source);compile(source,str(path),'exec');syntax.append(ref(path))
files=[ref(P/name) for name in ('derive-policy-physical-01.py','freeze-physical-policy.py','policy-final-physical-01.json',
    'policy-final-physical-01-derivation.json','PHYSICAL-POLICY-REVIEW.md','run-physical-policy-derive-01/receipt.json','run-physical-policy-derive-01/output.txt')]
data=dict(schema=1,status='FROZEN PROPOSAL; ROOT REVIEW AND FINAL CHECKER PENDING',files=files,policy=ref(policy),derivation=ref(derivation),
    review=ref(P/'PHYSICAL-POLICY-REVIEW.md'),actual_derivation_exit=0,classification_checks=93,syntax_checked=syntax,
    added_production_paths=13,added_observed_session_files=52,total_archives=7,old_archive_entries_preserved=5,
    future_audit_prefix_pending=record['future_audit_prefix_pending'],publication_complete=False,git_mutation=False,staging_performed=False)
out=P/'physical-policy-final-receipt.json'
with out.open('x',encoding='utf-8',newline='\n') as f:json.dump(data,f,indent=2);f.write('\n')
print(json.dumps({'receipt':ref(out),'policy':ref(policy),'review':ref(P/'PHYSICAL-POLICY-REVIEW.md'),'actual_derivation_exit':0},indent=2))
