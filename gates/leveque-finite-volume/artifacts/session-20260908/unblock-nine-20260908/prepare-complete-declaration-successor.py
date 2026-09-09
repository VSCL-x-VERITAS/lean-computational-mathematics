"""Create an append-only native check for accepted targets and explicit pending replacements."""
from pathlib import Path
import argparse, hashlib, json

D = Path(__file__).resolve().parent
S = D.parent
R = S.parents[3]
sha = lambda path: hashlib.sha256(path.read_bytes()).hexdigest()
read = lambda path: json.loads(path.read_bytes())
ref = lambda path: {'path': path.relative_to(R).as_posix(), 'sha256': sha(path)}
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--spec', type=Path, action='append', required=True)
parser.add_argument('--output', type=Path, required=True)
args = parser.parse_args()
destination = args.output.resolve()
assert destination.is_relative_to(D.resolve()) and not destination.exists()
gate_path = R / 'gates/leveque-finite-volume/chapter-01.json'
gate = read(gate_path)
by_id = {row['id']: row for row in gate['rows']}
assert len(by_id) == len(gate['rows']) == 57
rows = {}
for row in gate['rows']:
    if row['status'] in ['PROVED', 'REUSED']:
        task = read(R / row['faithfulness_task'])
        assert row['lean_declarations'] == [task['target']['declaration']]
        rows[row['id']] = task['target']
specs = []
selected_ids = set()
for path in args.spec:
    path = path.resolve()
    assert path.is_relative_to(D.resolve())
    spec = read(path)
    row_id = spec['row_id']
    assert row_id not in selected_ids
    selected_ids.add(row_id)
    assert by_id[row_id]['status'] in ['PROVED', 'REUSED', 'IN_PROGRESS']
    if row_id in rows:
        assert rows[row_id] == spec['target'], 'Cannot replace an accepted target without a new binding'
    rows[row_id] = spec['target']
    specs.append(ref(path))
expected = {row['id'] for row in gate['rows'] if row['status'] != 'SKIPPED'}
assert set(rows) == expected and len(rows) == 41
names = sorted(target['declaration'] for target in rows.values())
assert len(names) == len(set(names)) == 41
files = {}
for target in rows.values():
    path = R / target['path']
    assert path.resolve().is_relative_to(R.resolve()) and path.is_file()
    item = files.setdefault(target['path'], {**ref(path), 'declarations': []})
    item['declarations'].append(target['declaration'])
destination.mkdir()
check = destination / 'CompleteDeclarations.lean'
content = 'import ComputationalMathematics.Source.LeVeque.Chapter01\n\n' + '\n'.join(
    '#check ' + name + '\n#print axioms ' + name for name in names) + '\n'
with check.open('xb') as output:
    output.write(content.encode())
manifest = {'schema': 1, 'files': list(files.values()), 'declarations': names,
    'check_file': check.relative_to(R).as_posix(), 'check_file_sha256': sha(check), 'rows': rows,
    'selection_gate_sha256': sha(gate_path), 'replacement_specifications': specs,
    'scope': 'Exact 41 selected targets; this input file certifies neither native success nor source acceptance.'}
manifest_path = destination / 'manifest.json'
with manifest_path.open('xb') as output:
    output.write((json.dumps(manifest, indent=2) + '\n').encode())
print(json.dumps({'check': ref(check), 'manifest': ref(manifest_path), 'declarations': len(names)}))
