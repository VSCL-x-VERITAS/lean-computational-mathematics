"""Root adoption of conservative cache exclusions and four actual build log paths."""
from pathlib import Path
import copy
import hashlib
import json
import os

assert os.name != 'nt', 'Use POSIX launcher'
P = Path(__file__).resolve().parent
R = next(p for p in P.parents if (p / 'lakefile.toml').exists())
S = P.parent.parent
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
ref = lambda p: {'path': p.relative_to(R).as_posix(), 'sha256': sha(p)}
base = P / 'policy-final-physical-03-private-successor.json'
assert sha(base) == '8c2e359c6960e5b277019b45df3814b64f8aef995a0626c4d08788931245366b'
old = json.loads(base.read_bytes())
previous = json.loads((P / 'policy-final-physical-02.json').read_bytes())
assert {k for k in previous if previous[k] != old[k]} == {'generated_cache_suffixes', 'exclude_exact'}
assert set(old['generated_cache_suffixes']) - set(previous['generated_cache_suffixes']) == {'.ir', '.olean.private', '.olean.server'}
cache_dir = P / 'cache-policy-physical-03'
evidence = json.loads((cache_dir / 'cache-evidence.json').read_bytes())
assert len(evidence['artifacts']) == 8
for item in evidence['artifacts']:
    pin = item['file']
    assert sha(R / pin['path']) == pin['sha256']
    assert pin['path'] in old['exclude_exact'] and not pin['path'].endswith('.lean')
    assert item['actual_compile_exit'] == 0
assert len(set(old['exclude_exact']) - set(previous['exclude_exact'])) == 9
new = copy.deepcopy(old)
logs = []
for label, tail in [('focused', ['ComputationalMathematics.Source.LeVeque.Chapter01']), ('full', [])]:
    stem = 'unblock-nine-physical-final-global-' + label
    receipt = S / (stem + '-exit.json')
    output = S / (stem + '-output.txt')
    data = json.loads(receipt.read_bytes())
    expected = ['lake', '--quiet', '--log-level=error', 'build', *tail]
    assert data['exit_code'] == 0 and data['argv'] == expected and data['command'] == ' '.join(expected)
    assert sha(output) == data['output_sha256']
    for p in (receipt, output):
        entry = ref(p)
        assert entry['path'] not in old['allow_exact']
        new['allow_exact'].append(entry['path'])
        logs.append(entry)
assert len(new['archives']) == 7
assert {k for k in old if old[k] != new[k]} == {'allow_exact'}
out = P / 'policy-final-physical-04.json'
with out.open('xb') as f:
    f.write((json.dumps(new, indent=2) + '\n').encode())
record = {
    'kind': 'root-adopted-publication-policy-successor',
    'policy': ref(out), 'base': ref(base),
    'review': ref(cache_dir / 'REVIEW.md'),
    'cache_evidence': ref(cache_dir / 'cache-evidence.json'),
    'cache_tests': ref(cache_dir / 'tests.json'),
    'private_exclusion_evidence': ref(cache_dir / 'private-exclusion-evidence.json'),
    'added_actual_build_logs': logs,
    'root_assessment': 'Reviewed the conservative suffix/exclusion derivation and actual successful build commands. Preserve all existing source, archive and privacy dispositions. Final publication discovery and archive replay remain required.',
    'official_publication_checker_run': False, 'git_staging_run': False}
receipt_out = P / 'policy-final-physical-04-adoption.json'
with receipt_out.open('xb') as f:
    f.write((json.dumps(record, indent=2) + '\n').encode())
print(json.dumps({'policy': ref(out), 'adoption': ref(receipt_out)}))
