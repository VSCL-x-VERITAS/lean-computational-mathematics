from pathlib import Path
import hashlib
import json
import re

base = Path(__file__).resolve().parent
repo = next(p for p in base.parents if (p / 'ComputationalMathematics').is_dir())

def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

def read(path):
    raw = path.read_bytes()
    return raw.decode('utf-16') if raw[:2] in (b'\xff\xfe', b'\xfe\xff') else raw.decode('utf-8-sig')

exit_record = json.loads(read(base / 'third-exit.json'))
assert exit_record['exit_code'] == 0
output = read(base / 'third-elaboration.txt')
assert not re.search(r'\bsorryAx\b|\berror:', output)
axioms = re.findall(r"'(NumStability\.[A-Za-z0-9_]+)' depends on axioms: \[(.*?)\]", output, re.S)
manifest = json.loads(read(base / 'canonical-drafts-manifest.json'))
expected = [name for item in manifest for name in item['declarations']]
assert len(expected) == 14
assert [name for name, _ in axioms] == expected
allowed = {'propext', 'Classical.choice', 'Quot.sound'}
for name, values in axioms:
    assert {a.strip() for a in values.split(',')} <= allowed, (name, values)
for item in manifest:
    path = base / item['draft_path']
    assert sha(path) == item['sha256']
    assert b'\r' not in path.read_bytes()
preserved = json.loads(read(base / 'preserved-owners.json'))
for item in preserved:
    assert sha(repo / item['path']) == item['sha256']
files = ['candidate.lean', 'third-elaboration.txt', 'third-exit.json',
         'canonical-drafts-manifest.json', 'canonical-declaration-checks.lean',
         'extraction-review.md', 'reuse-searches.json', 'preserved-owners.json',
         'second-failed-candidate.lean', 'second-elaboration.txt', 'second-exit.json',
         'first-elaboration.txt', 'first-exit.json']
receipt = {
    'status': 'combined_candidate_checked_canonical_placement_pending',
    'source_sha256': 'b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5',
    'native_command': exit_record['command'], 'native_exit_code': exit_record['exit_code'],
    'authored_declarations_checked': expected, 'allowed_axioms': sorted(allowed),
    'canonical_import_checks': 'pending coordinated production placement',
    'canonical_drafts': manifest, 'preserved_owners_unchanged': preserved,
    'evidence': [{'path': path, 'sha256': sha(base / path)} for path in files],
}
path = base / 'draft-verification.json'
assert not path.exists()
path.write_bytes((json.dumps(receipt, indent=2) + '\n').encode())
print(json.dumps({'receipt': str(path.relative_to(repo)), 'sha256': sha(path),
                  'candidate_sha256': sha(base / 'candidate.lean'), 'declarations': len(expected)}, indent=2))
