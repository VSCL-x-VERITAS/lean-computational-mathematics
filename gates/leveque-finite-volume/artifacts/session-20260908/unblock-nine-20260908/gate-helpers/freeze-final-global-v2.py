"""Freeze only the additive final global binder and its fixture evidence."""
from pathlib import Path
from datetime import datetime,timezone
import hashlib,json
H=Path(__file__).resolve().parent;S=H.parents[1];R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
ref=lambda p:{'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
parent=H/'bind-final-global-evidence.py'
assert sha(parent)=='4eba0aa2194cda7d56cbf9e652ee8ee497a2809dedeafd982876ec3692baba5c'
tests=json.loads((H/'final-global-v2-tests.json').read_bytes())
assert tests['check_count']==39 and tests['helper_sha256']==sha(H/'bind-final-global-evidence-v2.py')
assert not tests['operational_gate_read_or_written'] and not tests['audit_roles_or_complete_validator_run']
deps=json.loads((H/'final-global-v2-validator-dependencies.json').read_bytes())
for item in [deps['audit_validator'],*deps['validator_dependencies']]:assert sha(R/item['path'])==item['sha256']
names=['bind-final-global-evidence-v2.py','final-global-v2-provenance.fragment.py',
 'derive-final-global-binder-v2.py','final-global-v2-validator-dependencies.json','final-global-v2.diff',
 'test-final-global-binder-v2.py','final-global-v2-tests.json','final-global-v2-review.md','freeze-final-global-v2.py']
receipt={'schema':1,'completed_at_utc':datetime.now(timezone.utc).isoformat(),
 'status':'PREPARED_NOT_EXECUTED','parent_unchanged':ref(parent),'files':[ref(H/name) for name in names],
 'audit_validator':deps['audit_validator'],'validator_dependencies':deps['validator_dependencies'],
 'fixture_checks':39,'eight_payloads_and_execute_preserved':True,'actual_fixture_exit':0,
 'operational_gate_read_or_written':False,'audit_roles_or_complete_validator_run':False,
 'source_or_semantic_changes':False,'remaining_actual_prerequisites':'Root supplies final accepted/bound rows, ordinary v6 all-closed validation, current gate context, and current integration receipt selection. Released gate verdict remains separate.'}
path=H/'final-global-v2-final-receipt.json'
with path.open('x',encoding='utf-8',newline='\n') as f:json.dump(receipt,f,indent=2);f.write('\n')
print(json.dumps({'receipt':ref(path),'helper':ref(H/'bind-final-global-evidence-v2.py'),'dependencies':ref(H/'final-global-v2-validator-dependencies.json')}))
