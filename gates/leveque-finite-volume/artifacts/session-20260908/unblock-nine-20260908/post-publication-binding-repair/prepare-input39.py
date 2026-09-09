"""Assemble a 39-row checkpoint rebind request for the unchanged reviewed consumer.

This is not the final all-41 closure assembler. It supplies actual native results
to the consumer's existing 38--41-row protocol without changing any acceptance rule.
"""
from pathlib import Path
import hashlib
import importlib.util
import json
import os
import subprocess
from datetime import datetime, timezone

assert os.name == 'posix'
P = Path(__file__).resolve().parent
D, S = P.parent, P.parent.parent
R = next(p for p in P.parents if (p / 'lakefile.toml').is_file())
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
read = lambda p: json.loads(p.read_bytes())
ref = lambda p: {'path': p.relative_to(R).as_posix(), 'sha256': sha(p)}
consumer = D / 'gate-helpers/rebind-accepted-row-batch-package-command-v1.py'
assert sha(consumer) == '398e4eba8074602b5c870d1ccb677be8f1306398b399c208998531ccb15be30c'
spec = importlib.util.spec_from_file_location('unchanged_checkpoint_consumer', consumer)
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)
gate_path = R / 'gates/leveque-finite-volume/chapter-01.json'
gate_raw = gate_path.read_bytes()
assert hashlib.sha256(gate_raw).hexdigest() == '96b4f9054479ab03de116275dad733859113d3aabe57392c8b260bbcb35f208b'
gate = json.loads(gate_raw)
closed = sorted(row['id'] for row in gate['rows'] if row['status'] in ('PROVED', 'REUSED'))
assert len(closed) == 39
assert sum(row['status'] == 'SKIPPED' for row in gate['rows']) == 16
assert {row['id'] for row in gate['rows'] if row['status'] == 'IN_PROGRESS'} == {
    'LEV-CH01-DIMENSIONAL-SPLITTING', 'LEV-CH01-RIEMANN-INTERFACE-FLUX'}
manifest_path = D / 'physical-current-complete-declarations/manifest.json'
assert sha(manifest_path) == 'e49871475578e67516a545bba1083285ce5df8c10324a5f78c5d1ada6186a860'
manifest = read(manifest_path)
check = R / manifest['check_file']
assert sha(check) == manifest['check_file_sha256']
for item in manifest['files']:
    assert sha(R / item['path']) == item['sha256'], item['path']
head = subprocess.check_output(['git', '-C', str(R), 'rev-parse', 'HEAD']).decode().strip()
assert head == 'b8ccf0d8bd610b599b13708e8c8518771bcf71ab'
capture = D / 'capture-check.py'
assert sha(capture) == 'db1280f152c591b72d6e8542c64f7f814ed5ab6a8dda8a88736e19227ace29a8'
executions = {}
for label in ('full-build', 'declarations'):
    receipt = S / ('post-publication-binding-repair-' + label + '-exit.json')
    output = S / ('post-publication-binding-repair-' + label + '-output.txt')
    data = read(receipt)
    assert type(data['exit_code']) is int and data['exit_code'] == 0
    assert data['input_commit'] == head and data['output_sha256'] == sha(output)
    assert data['capture_script_sha256'] == sha(capture)
    expected = ['lake', 'build', 'ComputationalMathematics', 'NumStability'] if label == 'full-build' else [
        'lake', 'env', 'lean', manifest['check_file']]
    assert data['argv'] == expected and data['command'] == ' '.join(expected)
    executions[label] = {'receipt': ref(receipt), 'output': ref(output)}
bindings = module.q.gate_checker().current_context(gate_path, 1)['bindings']
module.refresh_bindings(gate['bindings'], bindings)
request = {'schema': 1, 'expected_gate_sha256': sha(gate_path),
           'expected_closed_row_ids': closed, 'current_bindings': bindings,
           'current_native': {'proof_manifest': ref(manifest_path), 'check': ref(check),
                              **executions['declarations']},
           'runtime_pins': ref(D / 'gate-helpers/batch-rebind-runtime-pins.json')}
assert gate_path.read_bytes() == gate_raw
destination = P / 'input39.json'
with destination.open('xb') as handle:
    handle.write((json.dumps(request, indent=2) + '\n').encode())
record = {'kind': 'actual-39-row-checkpoint-rebind-input', 'recorded_at_utc': datetime.now(timezone.utc).isoformat(),
          'input_commit': head, 'input': ref(destination), 'consumer': ref(consumer),
          'execution_evidence': executions, 'unchanged_selected_target_manifest': ref(manifest_path),
          'closed_rows': 39, 'pending_rows': 2, 'new_audit_decisions': False,
          'gate_mutated': False, 'all_41_closure_claimed': False}
with (P / 'input39-preparation.json').open('xb') as handle:
    handle.write((json.dumps(record, indent=2) + '\n').encode())
print(json.dumps(record, indent=2))
