"""Check actual local native receipts and freeze scratch mathematical evidence."""
from pathlib import Path
import hashlib
import json
import re

D = Path(__file__).resolve().parent
R = next(p for p in D.parents if (p / 'lean-toolchain').is_file())
W = R.parent
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
ref = lambda p: {'path': p.relative_to(R).as_posix(), 'sha256': sha(p)}

def emit(name, obj):
    with (D / name).open('xb') as f:
        f.write((json.dumps(obj, indent=2) + '\n').encode())

candidate = (D / 'Candidate.lean').read_bytes()
connected = (D / 'Connected.lean').read_bytes()
checks = (D / 'Checks.lean').read_bytes()
assert checks.startswith(connected) and b'\r' not in candidate
assert not re.search(rb'\b(sorry|admit|unsafe)\b', connected)
original = D.parent / 'dim-cfl1-witness/Candidate.lean'
assert sha(original) == '4a4eb85edcab8720bc86516a3988f88b61b508c71f7ab36a6c7ec36cb65cc4ac'
imports, bodies = [], []
for path in [original, D / 'Candidate.lean']:
    lines = path.read_text().splitlines(keepends=True)
    imports += [x for x in lines if x.startswith('import ') and x not in imports]
    bodies.append(''.join(x for x in lines if not x.startswith('import ')))
assert connected == (''.join(imports) + '\n' + ''.join(bodies) +
                     (D / 'Connection.lean.fragment').read_text()).encode()

origin = D.parent / 'directional-reference-repair'
origin_receipt = origin / 'quality01-receipt.json'
assert sha(origin_receipt) == '48d4aa6f6107baaf5e2feca98dcfba0ef64241ddc61f52f98bb8b6284616e099'
oq = json.loads(origin_receipt.read_text())
assert oq['actual_exit_code'] == 0 and oq['dependencies_unchanged']
for entry in [oq['source'], oq['output']]:
    assert sha(R / entry['path']) == entry['sha256']
qs = (D / 'quality01-Quality.lean.snapshot').read_bytes()
assert sha(D / 'quality01-Quality.lean.snapshot') == oq['source']['sha256']
qt = qs.decode()
fragment = qt[qt.index('/-- A genuine local'):qt.index('noncomputable def windowVariation')].encode()
assert fragment == (D / 'Predicate-definitions.lean.fragment').read_bytes()
assert fragment in candidate

content_index = {}
for path in D.rglob('*'):
    if path.is_file() and '__pycache__' not in path.parts:
        content_index.setdefault(sha(path), []).append(path)
attempts, bindings, dependencies = [], [], {}
for i in range(1, 8):
    folder = D / f'native-{i:02d}'
    receipt_path = folder / 'receipt.json'
    receipt = json.loads(receipt_path.read_text())
    assert receipt['exit_code'] == (1 if i <= 5 else 0)
    assert sha(folder / 'output.txt') == receipt['output_sha256']
    assert receipt['inputs_unchanged']
    assert receipt['git_invocations'] == receipt['model_role_invocations'] == 0
    main = next(p for p in folder.glob('*.lean.snapshot')
                if sha(p) == receipt['input_snapshot_sha256'])
    runner = D / ('run.py' if i <= 4 else 'run-connected.py' if i <= 6 else 'run-checks.py')
    assert sha(runner) == receipt['runner_sha256']
    for entry in receipt['inputs']:
        assert entry['sha256_before'] == entry['sha256_after']
        path = R / entry['path']
        if sha(path) == entry['sha256_before']:
            resolved = path
        else:
            resolved = next(iter(content_index.get(entry['sha256_before'], [])), None)
            assert resolved is not None, entry
        bindings.append({'recorded_path': entry['path'], 'sha256': entry['sha256_before'],
                         'resolved': ref(resolved), 'attempt': i})
        if not path.is_relative_to(D):
            dependencies[entry['path']] = entry['sha256_before']
    attempts.append({'receipt': ref(receipt_path), 'actual_exit': receipt['exit_code'],
                     'main_input': ref(main), 'output': ref(folder / 'output.txt'), 'runner': ref(runner)})
assert (D / 'native-07/Checks.lean.snapshot').read_bytes() == checks

names = json.loads((D / 'declarations.json').read_text())['declarations']
output = (D / 'native-07/output.txt').read_text()
assert not any(x in output for x in ['error:', 'warning:', 'sorryAx'])
reports = {}
for name, body in re.findall(r"'([^']+)' depends on axioms: \[([^]]*)\]", output):
    reports[name] = [x.strip() for x in body.split(',') if x.strip()]
for name in re.findall(r"'([^']+)' does not depend on any axioms", output):
    reports[name] = []
assert set(reports) == {'DimLocalCharacteristicWitness.' + x for x in names}
assert all(set(xs) <= {'propext', 'Classical.choice', 'Quot.sound'} for xs in reports.values())
emit('verification.json', {'schema': 1, 'status': 'PASS', 'bindings': bindings,
     'axiom_reports': reports, 'axiom_count': len(reports), 'final_actual_exit': 0,
     'copied_predicate_span_exact': True, 'combined_construction_exact': True})
source_packet = D.parent / 'dim-cfl1-witness/manifest.json'
source_refs = json.loads(source_packet.read_text())['source']
emit('manifest.json', {'schema': 1, 'status': 'PASS_LOCAL_REFERENCE_MATHEMATICS',
     'source_acceptance': False, 'full_quality_family_instance': False,
     'candidate': ref(D / 'Candidate.lean'), 'connection_fragment': ref(D / 'Connection.lean.fragment'),
     'connected': ref(D / 'Connected.lean'), 'checks': ref(D / 'Checks.lean'),
     'declarations': names, 'declaration_count': len(names), 'attempts': attempts,
     'dependencies': dependencies, 'origin_native_receipt': ref(origin_receipt),
     'prior_witness': ref(original), 'prior_source_packet': ref(source_packet),
     'source_context': source_refs, 'files': [ref(p) for p in sorted(D.rglob('*'))
         if p.is_file() and '__pycache__' not in p.parts]})
emit('receipt.json', {'schema': 1, 'status': 'PASS_LOCAL_REFERENCE_MATHEMATICS',
     'source_acceptance': False, 'manifest': ref(D / 'manifest.json'),
     'candidate': ref(D / 'Candidate.lean'), 'connected': ref(D / 'Connected.lean'),
     'connection_fragment': ref(D / 'Connection.lean.fragment'), 'review': ref(D / 'REVIEW.md'),
     'native_receipt': ref(D / 'native-07/receipt.json'), 'actual_exit': 0, 'axiom_reports': len(reports)})
print(json.dumps({'receipt': ref(D / 'receipt.json'), 'candidate': ref(D / 'Candidate.lean'),
                  'connected': ref(D / 'Connected.lean'), 'manifest': ref(D / 'manifest.json'),
                  'actual_exit': 0, 'axiom_reports': len(reports)}, indent=2))
