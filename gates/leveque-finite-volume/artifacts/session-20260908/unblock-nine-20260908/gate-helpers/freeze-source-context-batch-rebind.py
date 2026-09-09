"""Capture synthetic tests and freeze their helpers; never invoke operational entry points."""
from pathlib import Path
from datetime import datetime, timezone
import hashlib
import json
import os
import subprocess
import sys

H0 = Path(__file__).resolve().parent
H = Path('\\\\?\\' + str(H0)) if os.name == 'nt' else H0
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
encode = lambda x: (json.dumps(x, indent=2) + '\n').encode()

def immutable(p, data):
    with p.open('xb') as handle:
        handle.write(data)

names = ['derive-source-context-batch-rebind.py', 'source-context-batch-rebind-derivation.json',
         'rebind-accepted-row-batch-v2.py', 'validate-closed-row-audits-rebind-v2.py',
         'test-source-context-batch-rebind.py', 'SOURCE-CONTEXT-BATCH-REBIND-USAGE.md',
         'freeze-source-context-batch-rebind.py']
inputs = ['rebind-accepted-row-batch.py', 'validate-closed-row-audits-v6.py',
          'rebind-validator-derivation.json', 'test-batch-rebind.py',
          'qualified_row_support_v3.py', 'source-context-v3-validator-dependencies.json',
          'rebind-unchanged-closed-rows.py', 'batch-rebind-runtime-pins.json']
before = {name: sha(H / name) for name in names + inputs}
out = H / 'source-context-batch-rebind-checks-01'
out.mkdir()
command = [sys.executable, '-B', str(H0 / 'test-source-context-batch-rebind.py')]
completed = subprocess.run(command, cwd=H0, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
immutable(out / 'output.txt', completed.stdout)
receipt = {'schema': 1, 'scope': 'synthetic guard tests only; no new source semantics',
           'command': command, 'exit_code': completed.returncode,
           'output_sha256': sha(out / 'output.txt'), 'model_roles': 0,
           'operational_rebinds': 0, 'gate_mutated': False,
           'inputs': [{'path': k, 'sha256_before': v, 'sha256_after': sha(H / k)}
                      for k, v in before.items()]}
immutable(out / 'receipt.json', encode(receipt))
assert completed.returncode == 0, 'Actual failed output/exit retained; no final freeze'
assert all(x['sha256_before'] == x['sha256_after'] for x in receipt['inputs'])
assert b'Ran 15 tests' in completed.stdout and completed.stdout.rstrip().endswith(b'OK')
derivation = json.loads((H / 'source-context-batch-rebind-derivation.json').read_bytes())
for section in ('batch', 'validator'):
    entry = derivation[section]
    assert sha(H / entry['source']['path']) == entry['source']['sha256']
    assert sha(H / entry['output']['path']) == entry['output']['sha256']
    text = (H / entry['source']['path']).read_text()
    for replacement in entry['exact_replacements']:
        assert text.count(replacement['before']) == 1
        text = text.replace(replacement['before'], replacement['after'])
    assert text.encode() == (H / entry['output']['path']).read_bytes()
names += ['source-context-batch-rebind-checks-01/output.txt',
          'source-context-batch-rebind-checks-01/receipt.json']
manifest = {'schema': 1, 'scope': 'additive source-context batch refresh preparation',
            'source_acceptance': False,
            'files': [{'path': n, 'sha256': sha(H / n)} for n in names],
            'frozen_inputs': [{'path': n, 'sha256': sha(H / n)} for n in inputs]}
immutable(H / 'source-context-batch-rebind-manifest.json', encode(manifest))
final = {'schema': 1, 'status': 'PASS_SYNTHETIC_CHECKS_ONLY',
         'completed_at_utc': datetime.now(timezone.utc).isoformat(),
         'main': derivation['batch']['output'], 'validator': derivation['validator']['output'],
         'manifest_sha256': sha(H / 'source-context-batch-rebind-manifest.json'),
         'test_receipt_sha256': sha(out / 'receipt.json'), 'actual_tests_exit': completed.returncode,
         'test_methods': 15, 'source_acceptance': False, 'new_source_semantics': False,
         'operational_rebinds': 0, 'gate_mutated': False, 'released_files_changed': False,
         'support': {'path': 'qualified_row_support_v3.py', 'sha256': sha(H / 'qualified_row_support_v3.py')},
         'dependencies': {'path': 'source-context-v3-validator-dependencies.json',
                          'sha256': sha(H / 'source-context-v3-validator-dependencies.json')}}
immutable(H / 'source-context-batch-rebind-final-receipt.json', encode(final))
print(json.dumps({'final_receipt_sha256': sha(H / 'source-context-batch-rebind-final-receipt.json'), **final}, indent=2))
