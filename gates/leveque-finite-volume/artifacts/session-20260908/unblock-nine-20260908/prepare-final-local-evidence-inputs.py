"""Freeze current all-41 inputs; refuse incomplete or stale native evidence."""
from pathlib import Path
import argparse, hashlib, importlib.util, json, os, subprocess

D = Path(__file__).resolve().parent
S = D.parent
R = S.parents[3]
H = D / 'gate-helpers'
assert os.name != 'nt'
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
read = lambda p: json.loads(p.read_bytes())
ref = lambda p: {'path': p.relative_to(R).as_posix(), 'sha256': sha(p)}

def module(name, path, digest):
    assert sha(path) == digest
    specification = importlib.util.spec_from_file_location(name, path)
    result = importlib.util.module_from_spec(specification)
    specification.loader.exec_module(result)
    return result

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('mode', choices=['batch', 'global'])
parser.add_argument('destination')
parser.add_argument('--audit-label')
args = parser.parse_args()
destination = Path(args.destination).resolve()
assert destination.is_relative_to(D.resolve()) and not destination.exists()
q = module('final_local_q', H / 'qualified_row_support_v3.py',
    '75bca786c37ea46940642b7db271d9501d3569c769e2081756da2e4a74905128')
checker = q.gate_checker()
gate_path = R / 'gates/leveque-finite-volume/chapter-01.json'
gate = read(gate_path)
closed = sorted(row['id'] for row in gate['rows'] if row['status'] in ['PROVED', 'REUSED'])
assert len(closed) == 41 and len(gate['rows']) == 57
assert sum(row['status'] == 'SKIPPED' for row in gate['rows']) == 16
manifest_path = D / 'local-complete-declaration-manifest.json'
manifest = read(manifest_path)
assert all(sha(R / item['path']) == item['sha256'] for item in manifest['files'])
assert sorted(manifest['declarations']) == sorted(name for row in gate['rows'] if row['id'] in closed for name in row['lean_declarations'])
assert sha(R / manifest['check_file']) == manifest['check_file_sha256']
declaration_label = 'unblock-nine-local-complete-declarations-02'
receipt_path = S / (declaration_label + '-exit.json')
output_path = S / (declaration_label + '-output.txt')
receipt = read(receipt_path)
assert type(receipt['exit_code']) is int and receipt['exit_code'] == 0
assert receipt['output_sha256'] == sha(output_path)
assert receipt['argv'] == ['lake', 'env', 'lean', manifest['check_file']]
bindings = checker.current_context(gate_path, 1)['bindings']
if args.mode == 'batch':
    assert args.audit_label is None
    data = {'schema': 1, 'expected_gate_sha256': sha(gate_path),
        'expected_closed_row_ids': closed, 'current_bindings': bindings,
        'current_native': {'proof_manifest': ref(manifest_path),
            'check': ref(R / manifest['check_file']), 'receipt': ref(receipt_path), 'output': ref(output_path)},
        'runtime_pins': ref(H / 'batch-rebind-runtime-pins.json')}
else:
    assert args.audit_label and '/' not in args.audit_label and '\\' not in args.audit_label
    projection = module('final_local_projection', H / 'bind-final-global-evidence-v2.py',
        'cbe2ed88c8c595b4db1771692852b2789886b21f9c4ef038f959ff0b8a9113af')
    data = read(H / 'final-global-evidence-input-template.json')
    del data['_incomplete_preparation']
    head = subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=R).decode().strip()
    assert head == data['input_commit'] == receipt['input_commit']
    data.update(gate_sha256=sha(gate_path), rows_sha256=checker.canonical_sha256(gate['rows']),
        bindings=bindings, declaration_manifest=ref(manifest_path),
        audit_validator=projection.FINAL_VALIDATOR_PIN,
        validator_dependencies=projection.FINAL_VALIDATOR_DEPENDENCIES)
    labels = {'source-inventory': 'unblock-nine-local-source-inventory',
        'layout': 'unblock-nine-local-organization-layout-02',
        'tiers': 'unblock-nine-local-organization-tiers',
        'compatibility': 'unblock-nine-local-organization-compatibility-02',
        'hygiene': 'unblock-nine-local-organization-hygiene',
        'declarations': declaration_label, 'focused-build': 'unblock-nine-local-final-focused',
        'full-build': 'unblock-nine-local-final-full-02', 'audits': args.audit_label}
    for name, label in labels.items():
        rp, op = S / (label + '-exit.json'), S / (label + '-output.txt')
        recorded = read(rp)
        assert type(recorded['exit_code']) is int and recorded['exit_code'] == 0
        assert recorded['input_commit'] == head and recorded['output_sha256'] == sha(op)
        data['evidence'][name] = {'receipt': ref(rp), 'output': ref(op)}
    audits = read(S / (args.audit_label + '-output.txt'))
    assert audits['mode'] == 'released-complete-validation' and audits['closed_rows'] == 41
    assert sorted(item['row'] for item in audits['records']) == closed
with destination.open('xb') as handle:
    handle.write((json.dumps(data, indent=2) + '\n').encode())
print(json.dumps({'mode': args.mode, 'closed_rows': len(closed), 'input': ref(destination)}))
