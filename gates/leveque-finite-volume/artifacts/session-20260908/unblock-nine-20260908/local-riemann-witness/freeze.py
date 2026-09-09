"""Verify actual native evidence and freeze this scratch packet only."""
from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path
import re
import subprocess

D = Path(__file__).resolve().parent
R = next(p for p in D.parents if (p / 'lean-toolchain').is_file())
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
def write(name, obj):
    with (D / name).open('xb') as handle:
        handle.write((json.dumps(obj, indent=2, ensure_ascii=False) + '\n').encode())

source = (D / 'Candidate.lean').read_text(encoding='utf-8')
assert '\r' not in source and b'\r' not in (D / 'Candidate.lean').read_bytes()
assert not re.search(r'\b(sorry|admit|axiom)\b', source)
names = ['LocalRiemannWitness.' + x for x in re.findall(
    r'^(?:noncomputable )?(?:def|abbrev|theorem) (\w+)', source, re.M)]
assert len(names) == len(set(names)) == 17
receipt = json.loads((D / 'native-02/receipt.json').read_text())
assert receipt['exit_code'] == 0 and receipt['inputs_unchanged']
assert receipt['output_sha256'] == sha(D / 'native-02/output.txt')
assert receipt['input_snapshot_sha256'] == sha(D / 'Candidate.lean') == sha(D / 'native-02/Candidate.lean.snapshot')
assert receipt['runner_sha256'] == sha(D / 'run.py')
for rec in receipt['inputs']:
    assert rec['sha256_before'] == rec['sha256_after'] == sha(R / rec['path'])
output = (D / 'native-02/output.txt').read_text(encoding='utf-8')
assert not re.search(r'error:|warning:|sorryAx', output)
reports = []
for match in re.finditer(r"'([^']+)' depends on axioms: \[([^]]*)\]", output):
    axioms = [x.strip() for x in match[2].split(',') if x.strip()]
    assert set(axioms) <= {'propext', 'Classical.choice', 'Quot.sound'}
    reports.append({'declaration': match[1], 'axioms': axioms})
for match in re.finditer(r"'([^']+)' does not depend on any axioms", output):
    reports.append({'declaration': match[1], 'axioms': []})
assert len(reports) == len(names) and {r['declaration'] for r in reports} == set(names)
assert all(re.search(r'^' + re.escape(name) + r'(?:[ .{:(]|$)', output, re.M) for name in names)
version_argv = ['C:/Users/qed_s/.elan/bin/lake.EXE', 'env', 'lean', '--version']
version = subprocess.run(version_argv, cwd=R, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
assert version.returncode == 0 and b'4.29.0-rc3' in version.stdout
with (D / 'native-version-output.txt').open('xb') as handle:
    handle.write(version.stdout)
write('native-version-receipt.json', {'argv': version_argv, 'cwd': str(R),
    'exit_code': version.returncode, 'output_sha256': sha(D / 'native-version-output.txt')})
write('declaration-checks.json', {'schema': 1, 'status': 'PASS', 'source_acceptance': False,
    'candidate_sha256': sha(D / 'Candidate.lean'), 'declarations': names,
    'lines': len(source.splitlines()), 'actual_native_exit': 0,
    'native_receipt_sha256': sha(D / 'native-02/receipt.json'),
    'output_sha256': sha(D / 'native-02/output.txt'), 'axiom_reports': reports})
files = []
for p in sorted(D.rglob('*')):
    if p.is_file() and '__pycache__' not in p.parts:
        files.append({'path': p.relative_to(D).as_posix(), 'sha256': sha(p), 'size': p.stat().st_size})
write('manifest.json', {'schema': 1, 'status': 'frozen-scratch-evidence',
    'source_acceptance': False, 'files': files})
write('final-receipt.json', {'schema': 1, 'status': 'PASS', 'source_acceptance': False,
    'frozen_at_utc': datetime.now(timezone.utc).isoformat(),
    'candidate_sha256': sha(D / 'Candidate.lean'), 'manifest_sha256': sha(D / 'manifest.json'),
    'review_sha256': sha(D / 'REVIEW.md'), 'native_exit': 0,
    'native_receipt_sha256': sha(D / 'native-02/receipt.json'),
    'native_output_sha256': sha(D / 'native-02/output.txt'),
    'declaration_checks_sha256': sha(D / 'declaration-checks.json'),
    'declaration_count': len(names), 'axiom_report_count': len(reports),
    'failed_attempts_preserved': ['native-01'], 'git_invocations': 0,
    'model_role_invocations': 0, 'production_mutations': 0,
    'scope': 'Information-only exact and genuinely nonexact flux applicability; no source verdict.'})
print(json.dumps({'final_receipt_sha256': sha(D / 'final-receipt.json'),
    **json.loads((D / 'final-receipt.json').read_text())}, indent=2))
