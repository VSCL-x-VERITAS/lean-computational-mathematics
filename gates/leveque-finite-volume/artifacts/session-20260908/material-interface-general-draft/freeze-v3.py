"""Task-local immutable receipt: no writes outside this draft directory."""
from pathlib import Path
import hashlib, json, os, re

assert os.name == 'nt'
task = Path(__file__).resolve().parent

def entry(path):
    path = Path(path).resolve()
    data = path.read_bytes()
    return {'path': str(path), 'sha256': hashlib.sha256(data).hexdigest(), 'bytes': len(data)}

provenance = json.loads((task / 'input-provenance.json').read_bytes())
for item in ([provenance['source'], provenance['candidate_at_dependency_check']] + provenance['views'] +
             provenance['inputs'] + provenance['policies'] + provenance['frozen_audit_files']):
    assert entry(item['path'])['sha256'] == item['sha256'], item['path']
for run in provenance['commands']:
    for key in ['stdout', 'stderr']:
        assert entry(run[key]['path'])['sha256'] == run[key]['sha256']

candidate = (task / 'candidate.lean').read_bytes()
checks = (task / 'declaration-checks.lean').read_bytes()
assert b'\r' not in candidate and checks.startswith(candidate + b'\n')
assert not re.search(rb'\b(sorry|admit|axiom|unsafe)\b', candidate)
runs = []
for label, name in [('first', 'first-candidate.lean'), ('final', 'candidate.lean'), ('declarations', 'declaration-checks.lean')]:
    run = json.loads((task / f'{label}-exit.json').read_bytes())
    assert run['exit_code'] == 0
    assert entry(task / name)['sha256'] == run['source_sha256']
    assert entry(task / f'{label}-output.txt')['sha256'] == run['output_sha256']
    assert run['argv'][1:3] == ['env', 'lean']
    runs.append(run)
output = (task / 'declarations-output.txt').read_text(encoding='utf-8')
assert not re.search(r'\berror:|\bwarning:|sorryAx', output)
axioms = []
for name, body in re.findall(r"^'(.+)' depends on axioms:\s*\[([^\]]*)\]", output, re.M):
    values = [s.strip() for s in body.split(',') if s.strip()]
    assert set(values) <= {'propext', 'Classical.choice', 'Quot.sound'}, (name, values)
    axioms.append({'declaration': name, 'axioms': values})
for name in re.findall(r"'([^']+)' does not depend on any axioms", output):
    axioms.append({'declaration': name, 'axioms': []})
names = json.loads((task / 'declaration-list.json').read_bytes())
assert len(axioms) == 24
assert {a['declaration'] for a in axioms} == set(names['new'] + names['existing'])
dependencies = [entry(line.strip()) for line in (task / 'candidate-dependencies.stdout.txt').read_text().splitlines() if line.strip()]
excluded = {'final-receipt-v3.json', 'freeze-v3-output.txt', 'freeze-v3-exit.json'}
artifacts = [entry(p) for p in sorted(task.iterdir()) if p.is_file() and p.name not in excluded]
receipt = {
    'kind': 'Scratch material/interface two-jump foundation',
    'candidate': entry(task / 'candidate.lean'), 'candidate_lines': candidate.count(b'\n'),
    'source_audit_verdict': None, 'all_bound_inputs_and_frozen_audit_rehashed_unchanged': True,
    'exact_candidate_prefix_checked': True, 'new_declarations': names['new'],
    'native_runs': runs, 'axiom_checks': axioms, 'direct_import_oleans': dependencies,
    'artifacts': artifacts,
    'limits': 'No canonical or gate changes; generic jump configuration only; global versus local medium scope and degenerate source convention unresolved; no PDE dynamics or physical material admissibility asserted.'}
path = task / 'final-receipt-v3.json'
assert not path.exists()
path.write_bytes((json.dumps(receipt, indent=2) + '\n').encode('utf-8'))
print(json.dumps([entry(task / n) for n in ['candidate.lean', 'source-and-reuse-review.md', 'input-provenance.json', 'final-receipt-v3.json']], indent=2))
