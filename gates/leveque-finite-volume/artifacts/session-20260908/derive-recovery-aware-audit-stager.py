"""Allow staging the one independently verified recovery, retaining both failures."""
from pathlib import Path
import ast, hashlib, json
S=Path(__file__).resolve().parent
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
parent=S/'stage-reviewed-audit-batch.py'
assert sha(parent)=='b91aa4b6ef9061bfcdfa1a34379578b6e50842ccc1c2f286670f18e6d6d2aed2'
code=parent.read_text(encoding='utf-8')
old=" receipt=read(taskdir/'root-pipeline-receipt.json');assert receipt['exit_code']==0"
new=""" receipt=read(taskdir/'root-pipeline-receipt.json')
 if ident=='LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908':
  assert expected=='be89b5bf7e066c64e3b24292d96d997d879ddb5c5342de79936263cf9ce9a052'
  assert receipt['exit_code']==1
  assert sha(taskdir/'root-pipeline-receipt.json')=='bb5fdf2b74d7f74a7a341c41231c6e8adf757b445c9fbf6f99db1129fb7b69d3'
  assert sha(taskdir/'root-recovery-verification.json')=='3ed3022f187ca9a64d2c12f8dea7ae279a556c13c1c4cfede15cc3a72d9dbf53'
  verified=read(taskdir/'root-recovery-verification.json')
  assert verified['complete_validation']['exit_code']==0
  assert verified['original_receipts_and_invalid_judgment_preserved'] is True
  assert verified['all_actual_agent_provenance_preserved'] is True
  assert verified['all_recorded_child_exits_match_expected'] is True
  for name in ['manifest','decision','report']:
   suffix='.md' if name=='report' else '.json'
   assert sha(taskdir/'faithfulness'/(name+suffix))==verified[name+'_sha256']
  assert sha(taskdir/'root-recovery-receipt.json')=='fb0c614d385c08a2e4f6dd45fadc15dd7c9a89cd199846a4b6963ca67bfec4e1'
  assert read(S/'equation10-recovery-independent-verification-exit.json')['exit_code']==0
  assert sha(S/'equation10-recovery-independent-verification-output.txt')=='3cda22f3af4422f52f0a8befe91e8fa7dec7d118625870bcbbf0e90917e784a8'
 else:assert receipt['exit_code']==0"""
assert code.count(old)==1; code=code.replace(old,new)
ast.parse(code)
dest=S/'stage-reviewed-audit-batch-v2.py'; assert not dest.exists()
dest.write_text(code,encoding='utf-8',newline='')
record=S/'recovery-aware-stager-derivation.json'; assert not record.exists()
record.write_text(json.dumps({'parent_sha256':sha(parent),'derived_sha256':sha(dest),
 'change':'One exact hash-pinned original Eq1.10 task may be staged despite its preserved failed driver receipts, only with the independent released complete-validator exit 0 and raw verification. All other tasks require original root exit 0.',
 'preserved':'All source/task/decision hashes, original failures, actual role provenance, exact POSIX file selection and actual Git blob-byte verification. No audit acceptance or gate change.'},indent=2)+'\n',encoding='utf-8')
print(json.dumps({'stager_sha256':sha(dest),'derivation_sha256':sha(record)}))
