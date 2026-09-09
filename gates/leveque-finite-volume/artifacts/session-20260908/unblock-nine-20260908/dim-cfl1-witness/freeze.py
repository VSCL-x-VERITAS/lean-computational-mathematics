"""Verify existing native evidence and write a scratch-only immutable manifest."""
from pathlib import Path
import hashlib
import json
import re

D = Path(__file__).resolve().parent
R = next(p for p in D.parents if (p / 'lean-toolchain').is_file())
W = R.parent
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
ref = lambda p: {'path': str(p.relative_to(W)).replace('\\', '/'), 'sha256': sha(p)}

def emit(name, data):
    with (D / name).open('xb') as handle:
        handle.write((json.dumps(data, indent=2) + '\n').encode())

decls = json.loads((D / 'declarations.json').read_text())['declarations']
candidate = (D / 'Candidate.lean').read_bytes()
assert b'\r' not in candidate
assert (D / 'Checks.lean').read_bytes().startswith(candidate)
assert not re.search(rb'\b(sorry|admit|unsafe)\b', candidate)
attempts = []
dependencies = {}
for i in range(1, 5):
    p = D / f'native-{i:02d}'
    r = json.loads((p / 'receipt.json').read_text())
    assert r['exit_code'] == (1 if i == 1 else 0)
    assert sha(p / 'output.txt') == r['output_sha256']
    snapshots = list(p.glob('*.lean.snapshot'))
    assert len(snapshots) == 1 and sha(snapshots[0]) == r['input_snapshot_sha256']
    runner = D / ('run-native-01-02.py.snapshot' if i < 3 else
                  'run.py' if i == 3 else 'run-checks.py')
    assert sha(runner) == r['runner_sha256']
    assert r['inputs_unchanged'] and r['git_invocations'] == r['model_role_invocations'] == 0
    for inp in r['inputs']:
        assert inp['sha256_before'] == inp['sha256_after']
        if not inp['path'].startswith(str(D.relative_to(R)).replace('\\', '/')):
            assert sha(R / inp['path']) == inp['sha256_after']
            dependencies[inp['path']] = inp['sha256_after']
    attempts.append({'receipt': ref(p / 'receipt.json'), 'actual_exit': r['exit_code'],
                     'input': ref(snapshots[0]), 'output': ref(p / 'output.txt'),
                     'runner': ref(runner)})
assert (D / 'native-03/Candidate.lean.snapshot').read_bytes() == candidate
assert (D / 'native-04/Checks.lean.snapshot').read_bytes() == (D / 'Checks.lean').read_bytes()
output = (D / 'native-04/output.txt').read_text()
assert not any(x in output for x in ['error:', 'warning:', 'sorryAx'])
reports = {}
for name, body in re.findall(r"'([^']+)' depends on axioms: \[([^]]*)\]", output):
    reports[name] = [s.strip() for s in body.split(',') if s.strip()]
for name in re.findall(r"'([^']+)' does not depend on any axioms", output):
    reports[name] = []
assert set(reports) == {'CFL1RefinementWitness.' + n for n in decls}
assert all(set(xs) <= {'propext', 'Classical.choice', 'Quot.sound'} for xs in reports.values())
emit('axiom-verification.json', {'schema': 1, 'status': 'PASS', 'actual_exit': 0,
     'output': ref(D / 'native-04/output.txt'), 'reports': reports, 'count': len(reports)})

pdf = W / 'formalization-collaboration/books/candidates/leveque-finite-volume/source/LeVeque_Finite_Volume_Methods_for_Hyperbolic_Problems_2002.pdf'
assert sha(pdf) == 'b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5'
source = {'pdf': ref(pdf), 'primary_context': 'raw 28 / printed 6 Section 1.3; raw 29 / printed 7 continuation',
          'rendered_pages_inspected': [ref(W / f'workflow-v5.0.1-local/chapter01-source-review/page-{i:03d}.png') for i in (28, 29, 32)],
          'literal_interpretation': ref(D.parent / 'user-high-resolution-interpretation-20260908.json')}
files = [ref(p) for p in sorted(D.rglob('*')) if p.is_file() and '__pycache__' not in p.parts]
emit('manifest.json', {'schema': 1, 'status': 'PASS_SCRATCH_WITNESS_ONLY', 'source_acceptance': False,
     'full_local_reference_quality_instance': False, 'candidate': ref(D / 'Candidate.lean'),
     'declarations': decls, 'declaration_count': len(decls), 'lines': len(candidate.splitlines()),
     'source': source, 'attempts': attempts, 'dependencies': dependencies, 'files': files,
     'remaining_mathematics': 'Local rectangle-to-classical-to-characteristic representation on the supplied physical box, before a full arbitrary-local-reference quality instance.'})
emit('receipt.json', {'schema': 1, 'status': 'PASS_SCRATCH_WITNESS_ONLY', 'source_acceptance': False,
     'manifest': ref(D / 'manifest.json'), 'candidate': ref(D / 'Candidate.lean'),
     'checks': ref(D / 'Checks.lean'), 'native_receipt': ref(D / 'native-04/receipt.json'),
     'actual_exit': 0, 'axiom_reports': len(reports), 'review': ref(D / 'REVIEW.md')})
print(json.dumps({'receipt': ref(D / 'receipt.json'), 'candidate': ref(D / 'Candidate.lean'),
                  'manifest': ref(D / 'manifest.json'), 'actual_exit': 0, 'axiom_reports': len(reports)}, indent=2))
