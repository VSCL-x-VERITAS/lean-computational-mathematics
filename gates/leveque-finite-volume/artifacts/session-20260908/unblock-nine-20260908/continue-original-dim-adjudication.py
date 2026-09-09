"""Resume the unchanged q orchestrator after the reviewed direct recovery."""
from pathlib import Path
from datetime import datetime, timezone
import hashlib, json, os, subprocess, sys

assert os.name == 'nt'
D = Path(__file__).resolve().parent
S = D.parent
R = S.parents[3]
T = S / 'audits/LEV-CH01-COORDINATE-HIGH-RESOLUTION-METHODS-PRODUCTION-20260908'
O = Path('\\\\?\\' + str(T / 'faithfulness'))
P = O / 'orchestration'
dest = D / 'dim-original-adjudication-continuation-01'
assert not dest.exists()
assert not (O / 'decision.json').exists()
assert not (P / 'adjudication_triggers.json').exists()
sha = lambda path: hashlib.sha256(path.read_bytes()).hexdigest()
roles = {p.name: sha(p) for p in (O / 'agent_outputs').iterdir() if p.is_file()}
assert set(roles) == {'source_contract.json', 'blind_translation.json', 'direct_judge.json', 'roundtrip_judge.json'}
assert roles['direct_judge.json'] == '8de843b40e27cd6e54950d17f0887e46fbbf371d2a13fb7d1682efbd8b635097'
assert roles['roundtrip_judge.json'] == 'f2af3cf76f5d8a870c41e454fd175ab2f1e637732725c140c82db523d2fb75b4'
original = T / 'role-run-receipt.json'
assert json.loads(original.read_bytes())['exit_code'] == 1
assert sha(original) == '697c9141544f9726e7d147d440ebc693665758f53089a6d0ba491ff862492f82'
command = [sys.executable, '-X', 'utf8', '-B', str(P / 'q.py'), T.name, '26,27,28,125,126', '2']
dest.mkdir()
record = {'command': command, 'original_wrapper': {'path': str(original), 'sha256': sha(original), 'exit_code': 1}, 'unchanged_q_sha256': sha(P / 'q.py'), 'roles_before': roles, 'started_at_utc': datetime.now(timezone.utc).isoformat()}
with (dest / 'before.json').open('x', encoding='utf-8') as f:
    json.dump(record, f, indent=2)
print(json.dumps(record), flush=True)
with (dest / 'output.txt').open('xb') as stdout, (dest / 'stderr.txt').open('xb') as stderr:
    result = subprocess.run(command, cwd=R, stdout=stdout, stderr=stderr)
record.update(exit_code=result.returncode, completed_at_utc=datetime.now(timezone.utc).isoformat(), stdout_sha256=sha(dest / 'output.txt'), stderr_sha256=sha(dest / 'stderr.txt'))
record['original_four_roles_unchanged'] = all(sha(O / 'agent_outputs' / n) == h for n, h in roles.items())
record['original_wrapper_unchanged'] = sha(original) == record['original_wrapper']['sha256']
assert record['original_four_roles_unchanged'] and record['original_wrapper_unchanged']
if (O / 'decision.json').exists():
    decision = json.loads((O / 'decision.json').read_bytes())
    record.update(decision_sha256=sha(O / 'decision.json'), classification=decision['classification'], accepted=decision['accepted'])
with (dest / 'receipt.json').open('x', encoding='utf-8') as f:
    json.dump(record, f, indent=2)
print(json.dumps(record), flush=True)
raise SystemExit(result.returncode)
