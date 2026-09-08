"""Verify actual native checks and stage the exact new definition leaves."""
from pathlib import Path
import hashlib, json, re, subprocess
S = Path(__file__).resolve().parent
R = S.parents[3]
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
read = lambda p: json.loads(p.read_bytes())
def bind(p): return {'path': p.relative_to(R).as_posix(), 'sha256': sha(p)}
def writej(p, value):
    with p.open('x', encoding='utf-8', newline='') as f:
        f.write(json.dumps(value, indent=2) + '\n')
m = read(S / 'definition-repairs-production-inputs.json')
assert sha(S / 'definition-repairs-production-inputs.json') == '8789c90061b970c3a4160dd00574dac41d3a0f0957d3c6f51f224e0bab59d0aa'
for f in m['files']: assert sha(R / f['path']) == f['sha256']
assert sha(S / 'definition-repairs-production-checks.lean') == m['check_file_sha256']
assert sha(R / m['aggregate']['path']) == m['aggregate']['sha256']
checks = []
labels = ['definition-repairs-focused-build', 'definition-repairs-production-declarations']
for label in labels:
    e = read(S / (label + '-exit.json'))
    assert type(e['exit_code']) is int and e['exit_code'] == 0
    assert e['input_commit'] == m['input_commit']
    assert e['output_sha256'] == sha(S / (label + '-output.txt'))
    checks.append(e)
assert checks[1]['command'] == 'lake env lean gates/leveque-finite-volume/artifacts/session-20260908/definition-repairs-production-checks.lean'
text = (S / (labels[1] + '-output.txt')).read_text(encoding='utf-8-sig')
assert re.search(r'\berror:|sorryAx|\bwarning:', text) is None
for f in m['files']:
    for name in f['declarations']:
        pattern = re.escape("'" + name + "' depends on axioms:") + r'\s*\[([^\]]*)\]'
        found = re.search(pattern, text)
        assert found, name
        assert {x.strip() for x in found.group(1).split(',') if x.strip()} <= {'propext', 'Classical.choice', 'Quot.sound'}
receipt = S / 'definition-repairs-production-verification.json'
writej(receipt, {'schema': 1, 'files': m['files'], 'native_checks': checks,
    'input_manifest_sha256': sha(S / 'definition-repairs-production-inputs.json'),
    'native_output_sha256': sha(S / (labels[1] + '-output.txt')),
    'native_exit_receipt_sha256': sha(S / (labels[1] + '-exit.json')),
    'seven_checked_declarations_resolve_with_allowed_axioms': True, 'aggregate': m['aggregate'],
    'source_audits': 'Pending fresh independent audits; old rejected or undetermined producers remain retained.'})
paths = [R / f['path'] for f in m['files']] + [R / m['aggregate']['path']]
for folder in ['riemann-initial-value-hyperbolic-draft', 'equation10-rectangle-draft', 'definition-rebind-preparation']:
    paths += [p for p in (S / folder).rglob('*') if p.is_file()]
names = ['definition-repairs-production-inputs.json', 'definition-repairs-production-checks.lean',
    'definition-repairs-production-verification.json', 'place-definition-repairs.py',
    'verify-stage-definition-introduction.py', 'prepare-definition-rebind-package.py',
    'prepare-equation10-rectangle-draft.py']
for label in [*labels, 'definition-intro-campaign', 'equation10-rectangle-draft-check']:
    names += [label + '-exit.json', label + '-output.txt']
names += [p.name for p in S.glob('definition-repair-*-reuse-*.txt')]
names += [p.name for p in S.glob('definition-aggregate-before-*.bin')]
paths += [S / name for name in names]
rel = sorted({p.relative_to(R).as_posix() for p in paths})
git = lambda *a, **kw: subprocess.check_output(['git', '-c', 'core.longpaths=true', *a], cwd=R, **kw)
assert not git('diff', '--cached', '--name-only').strip(), 'Unrelated staged changes'
spec = S / 'definition-intro-pathspec.bin'
assert not spec.exists()
spec.write_bytes(b'\0'.join(x.encode() for x in rel) + b'\0')
git('add', '--pathspec-from-file=' + str(spec), '--pathspec-file-nul')
for p in rel: assert git('cat-file', 'blob', ':' + p) == (R / p).read_bytes(), p
dest = S / 'definition-intro-staged-verification.json'
writej(dest, {'files': [bind(R / p) for p in rel], 'all_git_blob_bytes_equal': True,
             'method': 'Complete POSIX traversal and actual git cat-file blob comparison'})
d = dest.relative_to(R).as_posix()
git('add', '--', d)
assert git('cat-file', 'blob', ':' + d) == dest.read_bytes()
print(json.dumps({'verified_files': len(rel), 'verification_sha256': sha(receipt), 'staging_receipt_sha256': sha(dest)}))
