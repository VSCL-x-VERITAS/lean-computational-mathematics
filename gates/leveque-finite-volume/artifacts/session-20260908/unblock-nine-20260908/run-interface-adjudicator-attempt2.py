"""Complete an unstarted adjudicator with lossless inline JSON transport."""
from pathlib import Path
from datetime import datetime, timezone
import hashlib
import json
import os
import subprocess
import sys

assert os.name == 'nt'
D = Path(__file__).resolve().parent
S = D.parent
R = S.parents[3]
tid = 'LEV-CH01-RIEMANN-INFORMATION-INTERFACE-INTERPRETED-PRODUCTION-20260908'
T = Path(chr(92) * 2 + '?' + chr(92) + str(S / 'audits' / tid))
O = T / 'faithfulness'
P = O / 'orchestration'
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
assert not (O / 'decision.json').exists() and not (O / 'agent_outputs/adjudicator.json').exists()
derivation = json.loads((D / 'lossless-adjudicator-transport-receipt.json').read_bytes())
assert sha(P / 'r-lossless-json.py') == derivation['successor']['sha256']
assert sha(P / 'r.py') == derivation['parent']['sha256']
pins = {str(p): sha(p) for p in [T / 'audit-task.json', O / 'manifest.json', T / 'user-interpretation-packet.json',
        P / 'adjudication_triggers.json', *(O / 'agent_outputs' / name for name in
        ('source_contract.json', 'blind_translation.json', 'direct_judge.json', 'roundtrip_judge.json'))]}
env = dict(os.environ, FAITHFULNESS_AUDIT_CONFIG='/c/' + str(D / (tid + '.config.json')).replace('\\', '/')[3:])
wrapper = R.parent / 'workflow-v5.0.1-local/run_workflow_posix.py'
steps = [
    [sys.executable, '-X', 'utf8', '-B', str(P / 'r-lossless-json.py'), tid, 'adjudicator', 'a2', '26,27,28'],
    [sys.executable, '-X', 'utf8', '-B', str(P / 'c.py'), tid, 'a2', 'adjudicator', 'adjudicator.json'],
    [sys.executable, '-X', 'utf8', '-B', str(wrapper), '.faithfulness-audit/scripts/finalize_audit.py', tid],
    [sys.executable, '-X', 'utf8', '-B', str(wrapper), '.faithfulness-audit/scripts/validate_audit.py', tid, '--phase', 'complete'],
]
receipt = {'task_id': tid, 'started_at_utc': datetime.now(timezone.utc).isoformat(), 'steps': [],
           'derivation_sha256': sha(D / 'lossless-adjudicator-transport-receipt.json'), 'original_input_pins': pins}
with (T / 'adjudicator-attempt2-output.txt').open('xb') as output:
    for index, command in enumerate(steps):
        assert all(sha(Path(path)) == digest for path, digest in pins.items())
        completed = subprocess.run(command, cwd=R, env=env, stdout=output, stderr=subprocess.STDOUT)
        receipt['steps'].append({'command': command, 'exit_code': completed.returncode})
        if completed.returncode:
            break
        if index == 0:
            assert json.loads((P / 'a2_transport.json').read_bytes())['exit_code'] == 0
receipt['completed_at_utc'] = datetime.now(timezone.utc).isoformat()
receipt['exit_code'] = receipt['steps'][-1]['exit_code']
receipt['output_sha256'] = sha(T / 'adjudicator-attempt2-output.txt')
assert all(sha(Path(path)) == digest for path, digest in pins.items())
if (O / 'decision.json').is_file():
    decision = json.loads((O / 'decision.json').read_bytes())
    receipt.update(decision_sha256=sha(O / 'decision.json'), classification=decision['classification'], accepted=decision['accepted'])
with (T / 'adjudicator-attempt2-receipt.json').open('xb') as f:
    f.write((json.dumps(receipt, indent=2) + '\n').encode())
print(json.dumps(receipt))
raise SystemExit(receipt['exit_code'])
