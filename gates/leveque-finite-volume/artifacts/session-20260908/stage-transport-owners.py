"""Connect and stage the eight new owners without inventing introduction metadata."""
from pathlib import Path
import hashlib, json, subprocess
S = Path(__file__).resolve().parent
R = S.parents[3]
files = []
for name in ['interface-transport-production-inputs.json', 'equation02-transport-production-inputs.json']:
    files.extend(json.loads((S / name).read_text())['files'])
assert len(files) == 8
modules = [f['path'][:-5].replace('/', '.') for f in files]
records = []
for aggregate, prefix in [
    ('ComputationalMathematics/Analysis.lean', 'ComputationalMathematics.Analysis.'),
    ('ComputationalMathematics/Source/LeVeque/Chapter01.lean', 'ComputationalMathematics.Source.LeVeque.Chapter01.')]:
    p = R / aggregate
    before = p.read_bytes()
    lines = before.decode('utf-8').splitlines()
    indices = [i for i, line in enumerate(lines) if line.startswith('import ')]
    assert indices == list(range(min(indices), max(indices)+1))
    imports = {lines[i] for i in indices}
    additions = {'import ' + m for m in modules if m.startswith(prefix)}
    assert not additions.intersection(imports)
    lines[min(indices):max(indices)+1] = sorted(imports | additions, key=str.casefold)
    p.write_bytes(('\n'.join(lines)+'\n').encode('utf-8'))
    records.append({'path': aggregate, 'added': sorted(additions),
        'before_sha256': hashlib.sha256(before).hexdigest(), 'sha256': hashlib.sha256(p.read_bytes()).hexdigest()})
paths = [f['path'] for f in files] + [f['path'] for f in records]
subprocess.run(['git', '-c', 'core.longpaths=true', 'add', '--', *paths], cwd=R, check=True)
for path in paths:
    assert subprocess.check_output(['git', '-c', 'core.longpaths=true', 'show', ':' + path], cwd=R) == (R / path).read_bytes(), path
(S / 'transport-owner-staging.json').write_text(json.dumps({'schema': 1, 'files': files,
    'aggregates': records, 'exact_staged_bytes': True, 'tier_introduction_metadata': 'pending actual addition commit'}, indent=2)+'\n')
print(json.dumps({'production_files': 8, 'new_aggregate_imports': sum(len(r['added']) for r in records), 'exact_staged_bytes': True}))
