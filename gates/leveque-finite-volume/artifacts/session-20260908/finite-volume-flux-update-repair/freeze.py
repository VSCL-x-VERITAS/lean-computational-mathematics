"""Validate and freeze this scratch repair; never writes outside its own directory."""
from pathlib import Path
import hashlib, json, os, re

assert os.name == 'nt'
task = Path(__file__).resolve().parent
repo = task.parents[4]

def entry(path):
    path = Path(path).resolve()
    data = path.read_bytes()
    return {'path': str(path), 'sha256': hashlib.sha256(data).hexdigest(), 'bytes': len(data)}

provenance = json.loads((task / 'input-provenance.json').read_bytes())
for item in ([provenance['source'], provenance['candidate_at_dependency_check']] + provenance['views'] +
             provenance['inputs'] + provenance['frozen_audit_files']):
    assert entry(item['path'])['sha256'] == item['sha256'], item['path']
for run in provenance['commands']:
    for key in ['stdout', 'stderr']:
        assert entry(run[key]['path'])['sha256'] == run[key]['sha256']
manifest = json.loads((repo / 'lake-manifest.json').read_bytes())
mathlib = next(p for p in manifest['packages'] if p['name'] == 'mathlib')
assert mathlib['rev'] == provenance['mathlib_revision']

candidate = (task / 'candidate.lean').read_bytes()
source_fragment = (task / 'source-wrapper-fragment.lean').read_bytes()
witness_fragment = (task / 'witness-fragment.lean').read_bytes()
witness_import = b'import Mathlib.Analysis.SpecialFunctions.Integrals.Basic\n'
assert (task / 'source-wrapper-check.lean').read_bytes() == candidate + b'\n' + source_fragment
assert (task / 'witness-check.lean').read_bytes() == witness_import + candidate + b'\n' + witness_fragment
exact_prefix = witness_import + candidate + b'\n' + source_fragment + b'\n' + witness_fragment
assert (task / 'declaration-checks.lean').read_bytes().startswith(exact_prefix + b'\n')
for body in [candidate, source_fragment, witness_fragment]:
    assert b'\r' not in body
    assert not re.search(rb'\b(sorry|admit|axiom|unsafe)\b', body)
runs = []
for label, name, code in [('first', 'candidate.lean', 0), ('wrapper', 'source-wrapper-check.lean', 0),
                         ('witness', 'failed-witness-v1.lean', 1), ('witness-v2', 'witness-check.lean', 0),
                         ('declarations', 'declaration-checks.lean', 0)]:
    run = json.loads((task / f'{label}-exit.json').read_bytes())
    assert run['exit_code'] == code
    assert entry(task / name)['sha256'] == run['source_sha256']
    assert entry(task / f'{label}-output.txt')['sha256'] == run['output_sha256']
    assert run['argv'][1:3] == ['env', 'lean']
    assert Path(run['working_directory']).resolve() == repo
    runs.append(run)
output = (task / 'declarations-output.txt').read_text(encoding='utf-8')
assert not re.search(r'\berror:|\bwarning:|sorryAx', output)
axioms = []
for name, body in re.findall(r"^'(.+)' depends on axioms:\s*\[([^\]]*)\]", output, re.M):
    values = [s.strip() for s in body.split(',') if s.strip()]
    assert set(values) <= {'propext', 'Classical.choice', 'Quot.sound'}, (name, values)
    axioms.append({'declaration': name, 'axioms': values})
for name in re.findall(r"^'(.+)' does not depend on any axioms", output, re.M):
    axioms.append({'declaration': name, 'axioms': []})
names = json.loads((task / 'declaration-list.json').read_bytes())
assert len(axioms) == 32
assert {a['declaration'] for a in axioms} == set(names['new'] + names['existing'])
dependency_paths = set()
for filename in ['candidate-dependencies.stdout.txt', 'witness-dependencies.stdout.txt']:
    dependency_paths.update(line.strip() for line in (task / filename).read_text().splitlines() if line.strip())
dependencies = [entry(path) for path in sorted(dependency_paths)]
excluded = {'final-receipt.json', 'freeze-output.txt', 'freeze-exit.json'}
artifacts = [entry(p) for p in sorted(task.iterdir()) if p.is_file() and p.name not in excluded]
receipt = {
    'kind': 'Scratch finite-volume physical-flux error identity and source-contract proposal',
    'candidate': entry(task / 'candidate.lean'), 'candidate_lines': candidate.count(b'\n'),
    'source_fragment': entry(task / 'source-wrapper-fragment.lean'),
    'source_fragment_lines': source_fragment.count(b'\n'),
    'witness_fragment': entry(task / 'witness-fragment.lean'),
    'source_audit_verdict': None, 'all_bound_inputs_and_frozen_audit_rehashed_unchanged': True,
    'exact_candidate_and_fragment_concatenations_checked': True,
    'new_declarations': names['new'], 'native_runs': runs, 'axiom_checks': axioms,
    'direct_import_oleans': dependencies, 'artifacts': artifacts,
    'limits': 'Independent numerical array and arbitrary full-array flux rule; actual finite-vector rectangle law; both physical exterior faces; exact error accounting only, no adequacy/convergence/source-acceptance claim; scratch only.'}
path = task / 'final-receipt.json'
assert not path.exists()
path.write_bytes((json.dumps(receipt, indent=2) + '\n').encode('utf-8'))
print(json.dumps([entry(task / n) for n in ['candidate.lean', 'source-wrapper-fragment.lean',
    'witness-fragment.lean', 'source-and-reuse-review.md', 'input-provenance.json', 'final-receipt.json']], indent=2))
