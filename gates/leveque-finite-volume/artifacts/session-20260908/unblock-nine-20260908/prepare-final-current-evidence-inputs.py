"""Freeze explicit current evidence for an all-41 batch or final gate projection.

The caller supplies the actual proof-manifest FileRef and check/output FileRefs.
No historical check label is silently selected. The operational binders remain
responsible for full native, source, audit and gate validation.
"""
from pathlib import Path
import argparse
import hashlib
import importlib.util
import json
import os
import subprocess

D = Path(__file__).resolve().parent
S = D.parent
R = S.parents[3]
H = D / 'gate-helpers'
assert os.name != 'nt', 'Use the prepared POSIX launcher.'
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
read = lambda p: json.loads(p.read_bytes())
ref = lambda p: {'path': p.relative_to(R).as_posix(), 'sha256': sha(p)}
def bound(item):
    assert set(item) == {'path', 'sha256'}
    path = (R / item['path']).resolve()
    assert path.is_relative_to(R.resolve()) and sha(path) == item['sha256']
    return path
def module(name, path, digest):
    assert sha(path) == digest
    specification = importlib.util.spec_from_file_location(name, path)
    result = importlib.util.module_from_spec(specification)
    specification.loader.exec_module(result)
    return result

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('mode', choices=['batch', 'global'])
parser.add_argument('--bundle', required=True, type=Path)
parser.add_argument('--bundle-sha256', required=True)
parser.add_argument('--destination', required=True, type=Path)
args = parser.parse_args()
bundle_path = args.bundle.resolve()
assert bundle_path.is_relative_to(D.resolve()) and sha(bundle_path) == args.bundle_sha256
bundle = read(bundle_path)
assert set(bundle) == {'format', 'declaration_manifest', 'evidence'}
assert bundle['format'] == 'explicit-current-chapter-one-checks-1'
destination = args.destination.resolve()
assert destination.is_relative_to(D.resolve()) and not destination.exists()
q = module('final_current_q4', H / 'qualified_row_support_v4.py',
           '63c2f673e1c1c94e041fd4d07f8f54748114397885d7757d2d7b98273caecde9')
checker = q.gate_checker()
gate_path = R / 'gates/leveque-finite-volume/chapter-01.json'
gate = read(gate_path)
closed = sorted(row['id'] for row in gate['rows'] if row['status'] in ['PROVED', 'REUSED'])
assert len(closed) == 41 and len(gate['rows']) == 57
assert sum(row['status'] == 'SKIPPED' for row in gate['rows']) == 16
manifest_path = bound(bundle['declaration_manifest'])
manifest = read(manifest_path)
for item in manifest['files']:
    bound({key: item[key] for key in ('path', 'sha256')})
check = bound({'path': manifest['check_file'], 'sha256': manifest['check_file_sha256']})
assert sorted(manifest['declarations']) == sorted(name for row in gate['rows'] if row['id'] in closed for name in row['lean_declarations'])
assert sorted(manifest['rows']) == closed
for row in gate['rows']:
    if row['id'] in closed:
        task = read(R / row['faithfulness_task'])
        assert manifest['rows'][row['id']] == task['target']
head = subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=R).decode().strip()
evidence = bundle['evidence']
required = {'declarations'} if args.mode == 'batch' else set(('source-inventory', 'layout', 'tiers', 'compatibility', 'hygiene', 'audits', 'declarations', 'focused-build', 'full-build'))
assert set(evidence) == required
for name, pair in evidence.items():
    assert set(pair) == {'receipt', 'output'}
    receipt_path, output_path = bound(pair['receipt']), bound(pair['output'])
    receipt = read(receipt_path)
    assert type(receipt['exit_code']) is int and receipt['exit_code'] == 0
    assert receipt['input_commit'] == head and receipt['output_sha256'] == sha(output_path)
native = evidence['declarations']
assert read(bound(native['receipt']))['argv'] == ['lake', 'env', 'lean', manifest['check_file']]
bindings = checker.current_context(gate_path, 1)['bindings']
if args.mode == 'batch':
    data = {'schema': 1, 'expected_gate_sha256': sha(gate_path), 'expected_closed_row_ids': closed,
            'current_bindings': bindings,
            'current_native': {'proof_manifest': bundle['declaration_manifest'], 'check': ref(check), **native},
            'runtime_pins': ref(H / 'batch-rebind-runtime-pins.json')}
else:
    projection = module('final_current_projection3', H / 'bind-final-global-evidence-v3.py',
                        'e91823bfdba863cef3e8b9c1cc027f0da921ac9f62228297bdbe227cd7c47ddb')
    data = read(H / 'final-global-evidence-input-template.json')
    del data['_incomplete_preparation']
    data.update(input_commit=head, gate_sha256=sha(gate_path), rows_sha256=checker.canonical_sha256(gate['rows']),
                bindings=bindings, declaration_manifest=bundle['declaration_manifest'],
                audit_validator=projection.FINAL_VALIDATOR_PIN,
                validator_dependencies=projection.FINAL_VALIDATOR_DEPENDENCIES, evidence=evidence)
    audits = read(bound(evidence['audits']['output']))
    assert audits['mode'] == 'released-complete-validation' and audits['closed_rows'] == 41
    assert sorted(item['row'] for item in audits['records']) == closed
assert sha(bundle_path) == args.bundle_sha256
with destination.open('xb') as stream:
    stream.write((json.dumps(data, indent=2) + '\n').encode())
print(json.dumps({'mode': args.mode, 'input_commit': head, 'closed_rows': len(closed),
                  'bundle': ref(bundle_path), 'input': ref(destination)}))
