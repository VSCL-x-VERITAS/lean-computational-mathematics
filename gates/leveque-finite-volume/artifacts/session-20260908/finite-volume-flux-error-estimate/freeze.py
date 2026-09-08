"""Validate exact native checks and freeze this additive scratch extension."""
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
for item in ([provenance['source'], provenance['checked_combination']] + provenance['views'] +
             provenance['inputs'] + provenance['frozen_audit_files'] + provenance['frozen_prior_files']):
    assert entry(item['path'])['sha256'] == item['sha256'], item['path']
for run in provenance['commands']:
    for key in ['stdout', 'stderr']:
        assert entry(run[key]['path'])['sha256'] == run[key]['sha256']
manifest = json.loads((repo / 'lake-manifest.json').read_bytes())
assert next(p for p in manifest['packages'] if p['name'] == 'mathlib')['rev'] == provenance['mathlib_revision']
base = (task / 'frozen-base.lean').read_bytes()
estimate = (task / 'estimate-fragment.lean').read_bytes()
solver = (task / 'solver-link-fragment.lean').read_bytes()
header = b'import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearRectangleRiemannInterface\n'
assert base == (task.parent / 'finite-volume-flux-update-repair/candidate.lean').read_bytes()
combined = (task / 'combined-check.lean').read_bytes()
assert combined == header + base + b'\n' + estimate + b'\n' + solver
assert (task / 'declaration-checks.lean').read_bytes().startswith(combined + b'\n')
for body in [base, estimate, solver]:
    assert b'\r' not in body
    assert not re.search(rb'\b(sorry|admit|axiom|unsafe)\b', body)
runs = []
for label, name, code in [('estimates-v1', 'failed-estimate-v1.lean', 1),
                         ('combined-v1', 'failed-combined-v1.lean', 1),
                         ('combined-v2', 'failed-combined-v2.lean', 1),
                         ('combined-v3', 'combined-check.lean', 0),
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
assert len(axioms) == 35
assert {a['declaration'] for a in axioms} == set(names['new'] + names['frozen_base'] + names['existing'])
dependencies = [entry(line.strip()) for line in (task / 'combined-dependencies.stdout.txt').read_text().splitlines() if line.strip()]
excluded = {'final-receipt.json', 'freeze-output.txt', 'freeze-exit.json'}
artifacts = [entry(p) for p in sorted(task.iterdir()) if p.is_file() and p.name not in excluded]
receipt = {
    'kind': 'Additive conditional FV error bounds and actual selected linear-solver flux linkage',
    'combined_check': entry(task / 'combined-check.lean'),
    'estimate_fragment': entry(task / 'estimate-fragment.lean'), 'estimate_lines': estimate.count(b'\n'),
    'solver_fragment': entry(task / 'solver-link-fragment.lean'), 'solver_lines': solver.count(b'\n'),
    'frozen_base': entry(task / 'frozen-base.lean'), 'source_audit_verdict': None,
    'all_inputs_prior_draft_and_audit_rehashed_unchanged': True,
    'exact_combination_and_declaration_prefix_checked': True,
    'new_declarations': names['new'], 'native_runs': runs, 'axiom_checks': axioms,
    'direct_import_oleans': dependencies, 'artifacts': artifacts,
    'limits': 'No user quantitative convention adopted; generic finite-vector error bounds conditional on old/face errors; exact own-solver physical flux for integrated linear family; global physical accuracy still requires trace comparison; no canonical/gate/audit mutation.'}
path = task / 'final-receipt.json'
assert not path.exists()
path.write_bytes((json.dumps(receipt, indent=2) + '\n').encode('utf-8'))
print(json.dumps([entry(task / n) for n in ['combined-check.lean', 'estimate-fragment.lean',
    'solver-link-fragment.lean', 'source-and-reuse-review.md', 'input-provenance.json', 'final-receipt.json']], indent=2))
