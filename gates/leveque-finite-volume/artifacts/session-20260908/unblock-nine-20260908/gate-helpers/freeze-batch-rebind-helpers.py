"""Capture synthetic test exit and freeze these additive helpers; never run a rebind."""
from pathlib import Path
from datetime import datetime, timezone
import hashlib
import json
import subprocess
import sys

H = Path(__file__).resolve().parent
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
files = ['rebind-accepted-row-batch.py', 'validate-closed-row-audits-rebind.py',
         'derive-rebind-validator.py', 'rebind-validator-derivation.json', 'test-batch-rebind.py',
         'prepare-batch-rebind-runtime-pins.py', 'batch-rebind-runtime-pins.json',
         'BATCH-REBIND-USAGE.md', 'freeze-batch-rebind-helpers.py']
before = {name: sha(H/name) for name in files}
out = H/'batch-rebind-helper-checks-01'
out.mkdir()
command = [sys.executable, '-B', str(H/'test-batch-rebind.py')]
result = subprocess.run(command, cwd=H, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
(out/'output.txt').write_bytes(result.stdout)
receipt = {'schema': 1, 'scope': 'synthetic guard tests only', 'command': command,
           'exit_code': result.returncode, 'output_sha256': sha(out/'output.txt'),
           'operational_rebinds': 0, 'model_roles': 0, 'gate_mutated': False,
           'inputs': [{'path': name, 'sha256_before': before[name], 'sha256_after': sha(H/name)} for name in files]}
(out/'receipt.json').write_text(json.dumps(receipt, indent=2)+'\n', encoding='utf-8', newline='\n')
assert result.returncode == 0
assert all(x['sha256_before'] == x['sha256_after'] for x in receipt['inputs'])
files += ['batch-rebind-helper-checks-01/output.txt', 'batch-rebind-helper-checks-01/receipt.json']
manifest = {'schema': 1, 'source_acceptance': False, 'scope': 'additive batch rebind preparation only',
            'files': [{'path': name, 'sha256': sha(H/name)} for name in files]}
with (H/'batch-rebind-helper-manifest.json').open('xb') as f:
    f.write((json.dumps(manifest, indent=2)+'\n').encode())
final = {'schema': 1, 'status': 'PASS_SYNTHETIC_CHECKS_ONLY', 'source_acceptance': False,
         'completed_at_utc': datetime.now(timezone.utc).isoformat(),
         'main': {'path': 'rebind-accepted-row-batch.py', 'sha256': sha(H/'rebind-accepted-row-batch.py')},
         'validator': {'path': 'validate-closed-row-audits-rebind.py', 'sha256': sha(H/'validate-closed-row-audits-rebind.py')},
         'manifest_sha256': sha(H/'batch-rebind-helper-manifest.json'),
         'actual_tests_exit': result.returncode, 'test_receipt_sha256': sha(out/'receipt.json'),
         'operational_rebinds': 0, 'gate_mutated': False, 'released_files_changed': False}
with (H/'batch-rebind-helper-final-receipt.json').open('xb') as f:
    f.write((json.dumps(final, indent=2)+'\n').encode())
print(json.dumps({'final_receipt_sha256': sha(H/'batch-rebind-helper-final-receipt.json'), **final}, indent=2))
