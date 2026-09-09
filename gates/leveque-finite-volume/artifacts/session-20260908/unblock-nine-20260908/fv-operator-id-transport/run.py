"""Run the exact-ID-compatible FV orchestrator; retain the original prepared helper."""
from pathlib import Path
from datetime import datetime, timezone
import hashlib, json, os, subprocess, sys
D=Path(__file__).resolve().parent
S=D.parent.parent
R=S.parents[3]
exec(compile((D.parent/'fv-local-domain-review/native-long-path-io.py').read_bytes(),
             'native-long-path-io','exec'),globals())
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
read=lambda p:json.loads(p.read_bytes())
tid='LEV-CH01-FV-LOCAL-FLUX-UPDATE-OPERATOR-QUALIFIED-20260908'
assert len(sys.argv)==2
spec_path=Path(sys.argv[1]).resolve()
assert sha(spec_path)=='7d7a3bbfacd584950ec66366e2d7e6f221998a336e9f5d0636fba88503be56ed'
spec=read(spec_path);assert spec['task_id']==tid
T=S/'audits'/tid;O=T/'faithfulness';P=O/'orchestration'
derivation=read(D/'derivation.json')
for name in ['parent','successor']:
    p=R/derivation[name]['path'];assert sha(p)==derivation[name]['sha256']
assert sha(P/'q.py')==derivation['parent']['sha256']
prep=T/'role-transport-preflight.json';preflight=read(prep)
assert preflight['blind_isolation_verified']
assert next(x for x in preflight['helpers'] if x['file']=='q.py')['successor_sha256']==sha(P/'q.py')
for item in preflight['helpers']:
    assert sha(P/item['file'])==item['successor_sha256']
assert not (O/'decision.json').exists()
for name in ['role-run-output.txt','role-run-stderr.txt','role-run-receipt.json']:
    assert not (T/name).exists()
pins={str(p):sha(p) for p in [spec_path,prep,P/'q.py',P/'r.py',P/'c.py',D/'q-operator-id.py',D/'derivation.json']}
command=[sys.executable,'-X','utf8','-B',str(D/'q-operator-id.py'),tid,spec['pages'],'2']
started=datetime.now(timezone.utc).isoformat()
print(json.dumps({'launching':tid,'command':command,'started_at_utc':started}),flush=True)
with (T/'role-run-output.txt').open('xb') as out,(T/'role-run-stderr.txt').open('xb') as err:
    completed=subprocess.run(command,cwd=R,stdout=out,stderr=err)
unchanged=all(sha(Path(p))==h for p,h in pins.items())
receipt={'command':command,'started_at_utc':started,'completed_at_utc':datetime.now(timezone.utc).isoformat(),
    'exit_code':completed.returncode,'stdout_sha256':sha(T/'role-run-output.txt'),
    'stderr_sha256':sha(T/'role-run-stderr.txt'),'prepared_transport_sha256':sha(prep),
    'transport_derivation_sha256':sha(D/'derivation.json'),'original_q_retained':True,
    'transport_inputs_unchanged':unchanged,'transport_input_pins':pins,
    'wrapper_exit_code':completed.returncode if unchanged else 2}
if (O/'decision.json').exists():
    decision=read(O/'decision.json')
    receipt.update(decision_sha256=sha(O/'decision.json'),classification=decision['classification'],accepted=decision['accepted'])
with (T/'role-run-receipt.json').open('xb') as handle:
    handle.write((json.dumps(receipt,indent=2)+'\n').encode())
print(json.dumps(receipt),flush=True)
raise SystemExit(receipt['wrapper_exit_code'])
