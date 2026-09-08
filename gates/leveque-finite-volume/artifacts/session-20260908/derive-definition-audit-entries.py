"""Derive strict one-role entries only after both new tasks finish preparation."""
from pathlib import Path
import ast, hashlib, json
S=Path(__file__).resolve().parent
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
records=[]
for kind,new,parent_name,parent_hash,replacements in [
 ('rectangle','LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908',
  'run-linear-riemann-measure-context-audit-pipeline.py','d81d7214cf6109a2d9ee26e0bb7c1dbc540d1478b737e43cc6cd378b66fa688b',[
    ('LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908','LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908')]),
 ('problem-data','LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908',
  'run-one-step-general-audit-pipeline.py','fe2392b733bf9e93a60affa0296264164ce0949f74f0a890024f67220a4fce26',[
    ('LEV-CH01-ONE-STEP-GENERAL-CURRENT-DATA-PRODUCTION-20260908','LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908'),
    ('general-domain-lineage.json','problem-data-lineage.json'),
    ('one-step-general-audit-route','riemann-problem-data-audit-route'),
    ('one-step-general-audit-prepare','riemann-problem-data-audit-prepare')])]:
 parent=S/parent_name; assert sha(parent)==parent_hash
 td=S/'audits'/new; out=td/'faithfulness'
 assert (out/'manifest.json').is_file() and not any((out/'agent_outputs').iterdir())
 if kind=='rectangle':
  handoff=td/'prepared-handoff-base.json'
  assert json.loads(handoff.read_bytes())['prepared_validation_exit_code']==0
  replacements.append(('45a9fa2d704f822871455c3c8923f5618d99a30953ee7d8d7539d1e69a828628',sha(handoff)))
 else:
  handoff=td/'problem-data-lineage.json'
  for label in ['riemann-problem-data-audit-route','riemann-problem-data-audit-prepare']:
   rec=json.loads((S/(label+'-exit.json')).read_bytes())
   assert rec['exit_code']==0 and rec['raw_output_sha256']==sha(S/(label+'-output.txt'))
  replacements.append(('9d378e48a5d5632f5b7bea33f397645b87433811b245231ca441fedc6d17718d',sha(handoff)))
 code=parent.read_text(encoding='utf-8')
 for old,fresh in replacements:
  assert code.count(old)==1,(old,code.count(old)); code=code.replace(old,fresh)
 code=code.replace('Run the untouched linear-Riemann native-measure successor','Run the untouched interpreted rectangle successor')
 ast.parse(code)
 dest=S/('run-definition-'+kind+'-audit-pipeline.py'); assert not dest.exists()
 dest.write_text(code,encoding='utf-8',newline='')
 records.append({'task_id':new,'parent':parent_name,'parent_sha256':parent_hash,'entry':dest.name,
                 'entry_sha256':sha(dest),'handoff_sha256':sha(handoff),'replacements':replacements,
                 'semantic_roles_invoked':False,'workers':1})
record=S/'definition-audit-entry-derivations.json'; assert not record.exists()
record.write_text(json.dumps({'schema':1,'entries':records,'preserved':'Exact sealed source, target and environment checks; source-only extraction; full blind masking; interpretation only to permitted source-aware judges; actual fresh role provenance and complete validation.'},indent=2)+'\n',encoding='utf-8')
print(json.dumps({'entries':records,'derivation_sha256':sha(record)}))
