"""Freeze the two exact canonical proof checks and their 24 declared results."""
from pathlib import Path
import hashlib, json, re
S = Path(__file__).resolve().parent
R = S.parents[3]
sha = lambda data: hashlib.sha256(data).hexdigest()
record = {'schema': 1, 'files': [], 'checks': []}
raw = []
for prefix in ['interface-transport', 'equation02-transport']:
    manifest = json.loads((S / (prefix + '-production-inputs.json')).read_text())
    for f in manifest['files']:
        assert sha((R / f['path']).read_bytes()) == f['sha256'], f['path']
    check_path = S / (prefix + '-production-checks.lean')
    assert sha(check_path.read_bytes()) == manifest['check_file_sha256']
    record['files'].extend(manifest['files'])
    for kind in ['build', 'checks']:
        path = S / (prefix + '-production-' + kind + '-output.txt')
        exit_path = S / (prefix + '-production-' + kind + '-exit.json')
        e = json.loads(exit_path.read_text(encoding='utf-8-sig'))
        assert e['exit_code'] == 0 and not isinstance(e['exit_code'], bool)
        data = path.read_bytes()
        record['checks'].append({'path': path.relative_to(R).as_posix(), 'sha256': sha(data),
            'exit': exit_path.relative_to(R).as_posix(), 'exit_sha256': sha(exit_path.read_bytes()), 'exit_code': 0})
        if kind == 'checks':
            raw.append(data)
            text = data.decode('utf-8-sig')
            for f in manifest['files']:
                for d in f['declarations']:
                    m = re.search(re.escape("'" + d + "' depends on axioms:") + r'\s*\[([^\]]*)\]', text)
                    assert m, d
                    assert {a.strip() for a in m.group(1).split(',') if a.strip()} <= {'propext', 'Classical.choice', 'Quot.sound'}
decls = [d for f in record['files'] for d in f['declarations']]
assert len(record['files']) == 8 and len(decls) == len(set(decls)) == 24
combined = S / 'transport-intro-24-axioms-output.txt'
combined.write_bytes(b'\n'.join(raw))
record['combined_raw_output'] = {'path': combined.relative_to(R).as_posix(), 'sha256': sha(combined.read_bytes()),
    'method': 'Concatenation in interface-transport then equation02-transport order, with one newline separator; component bytes retained unchanged.'}
record['source_audits'] = 'OPEN; proof success does not claim source acceptance.'
(S / 'transport-intro-proof-verification.json').write_text(json.dumps(record, indent=2)+'\n', encoding='utf-8')
print(json.dumps({'files': 8, 'declarations': 24, 'standard_axioms_only': True, 'source_audits': 'OPEN'}))
