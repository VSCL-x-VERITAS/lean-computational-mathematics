"""Freeze one successful bounded reference check; never rewrites prior attempts."""
from pathlib import Path
from datetime import datetime, timezone
import hashlib, json, os, re
P = Path(__file__).resolve().parent
R = next(p for p in P.parents if (p / 'lean-toolchain').is_file())
D = P.parent.parent
exec(compile((D / 'fv-local-domain-review/native-long-path-io.py').read_bytes(),
             'native-long-path-io.py', 'exec'), globals())

def ref(p):
    b = p.read_bytes()
    return {'path': p.relative_to(R).as_posix(), 'sha256': hashlib.sha256(b).hexdigest(), 'bytes': len(b)}

def write(p, value):
    raw = value if isinstance(value, bytes) else (json.dumps(value, indent=2, ensure_ascii=False) + '\n').encode()
    with p.open('xb') as f:
        f.write(raw)
    return ref(p)

A = P / 'native-04'
assert not (P / 'manifest.json').exists()
assert not (P / 'receipt.json').exists()
assert (P / 'Candidate.lean').read_bytes() == (A / 'Candidate.lean').read_bytes()
final = json.loads((A / 'receipt.json').read_text())
assert final['exit_code'] == 0 and final['inputs_unchanged']
assert final['canonical_imports'] and not final['source_judgment'] and not final['production_changes']
for name in ('lake', 'deps', 'lean'):
    r = json.loads((A / (name + '-receipt.json')).read_text())
    assert r['exit_code'] == 0
    for field in ('stdout', 'stderr'):
        p = Path(r[field]['path'])
        assert hashlib.sha256(p.read_bytes()).hexdigest() == r[field]['sha256']
    assert Path(r['stderr']['path']).read_bytes() == b''
pins = json.loads((A / 'input-pins.json').read_text())['inputs']
for item in pins:
    assert hashlib.sha256(Path(item['path']).read_bytes()).hexdigest() == item['sha256']
out = (A / 'lean-output.txt').read_text(encoding='utf-8')
assert not re.search(r'\b(error|warning|sorryAx)\b', out)
reports = re.findall(r"'([^']+)' depends on axioms: \[([^\]]*)\]", out)
assert len(reports) == 14 and len({n for n, _ in reports}) == 14
allowed = {'propext', 'Classical.choice', 'Quot.sound'}
for _, axioms in reports:
    assert {a.strip() for a in axioms.split(',')} <= allowed
assert '((⊤ : ℕ∞) : WithTop ℕ∞)' in (P / 'Candidate.lean').read_text(encoding='utf-8')
basis = P / 'basis'
basis.mkdir()
names = [
    'FiniteCartesianGeometry', 'FiniteCartesianReference', 'FinitePhysicalReferenceError',
    'CartesianCellProjection', 'CartesianGridGeometry',
    'Examples/CFLUnitShift', 'Examples/StationaryRiemannField',
]
sources = []
base = R / 'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume'
for name in names:
    src = base / (name + '.lean')
    dst = basis / (name.replace('/', '-') + '.lean.snapshot')
    copy = write(dst, src.read_bytes())
    assert copy['sha256'] == ref(src)['sha256']
    sources.append({'source': ref(src), 'copy': copy})
old = []
for attempt in ('native-01', 'native-02', 'native-03', 'native-04'):
    rr = json.loads((P / attempt / 'receipt.json').read_text())
    old.append({'attempt': attempt, 'exit_code': rr['exit_code'],
                'files': [ref(p) for p in sorted((P / attempt).iterdir()) if p.is_file()]})
assert [v['exit_code'] for v in old] == [1, 1, 0, 0]
previous = P.parent / 'reference-review'
manifest = {
    'schema_version': 1,
    'purpose': 'Artifact-only canonical-import nonconstant directional Cartesian reference',
    'candidate': ref(P / 'Candidate.lean'), 'runner': ref(P / 'run.py'),
    'freeze_runner': ref(Path(__file__)), 'review': ref(P / 'REVIEW.md'),
    'final_attempt': 'native-04', 'theorem_count': 14,
    'declarations': [n for n, _ in reports],
    'allowed_axioms': sorted(allowed), 'canonical_source_copies': sources,
    'native_attempts': old,
    'previous_review': [ref(previous / n) for n in ('manifest.json', 'receipt.json', 'UPDATE.md')],
    'source_judgment': False, 'production_changes': False,
    'mesh_or_quality_certificate': False,
}
m = write(P / 'manifest.json', manifest)
r = write(P / 'receipt.json', {
    'schema_version': 1, 'completed_at_utc': datetime.now(timezone.utc).isoformat(),
    'manifest': m, 'final_native_exit_code': 0, 'native_attempts_preserved': [1, 1, 0, 0],
    'verified_input_pin_count': len(pins), 'axiom_report_count': len(reports),
    'candidate_equals_compiled_snapshot': True, 'source_judgment': False,
    'production_changes': False,
})
print(json.dumps({'manifest': m, 'receipt': r, 'candidate': ref(P / 'Candidate.lean'),
                  'native_output': ref(A / 'lean-output.txt')}, indent=2))
