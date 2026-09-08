"""Freeze successful scratch mathematics, preserving every failed native attempt."""
from pathlib import Path
import hashlib, json, re

task = Path(__file__).resolve().parent
repo = task.parents[4]
session = task.parent

def sha(path): return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def record(path):
    path = Path(path).resolve()
    return {'path': str(path), 'sha256': sha(path), 'bytes': path.stat().st_size}
def write_new(path, value):
    assert not path.exists(), path
    path.write_bytes((json.dumps(value, indent=2) + '\n').encode())

provenance = json.loads((task / 'reuse-provenance.json').read_bytes())
for item in provenance['inputs']:
    assert sha(item['path']) == item['sha256'], item['path']
for query in provenance['searches']:
    for key in ('stdout', 'stderr'):
        assert sha(query[key]['path']) == query[key]['sha256']
    assert query['exit_code'] in (0, 1)
    assert Path(query['stderr']['path']).read_bytes() == b''

old_path = session / 'dimensional-splitting-lines-draft/final-evidence.json'
old = json.loads(old_path.read_bytes())
for item in old['files']:
    assert sha(repo / item['path']) == item['sha256'], item['path']
assert sha(repo / old['source']['path']) == old['source']['sha256']
for key in ('old_task', 'old_decision', 'old_report'):
    assert sha(repo / old[key]['path']) == old[key]['sha256']

candidate = task / 'candidate.lean'
text = candidate.read_text(encoding='utf-8')
assert b'\r' not in candidate.read_bytes()
assert not re.search(r'\bsorry\b|\badmit\b|^axiom ', text, re.M)
assert candidate.read_bytes() == (task / 'attempt-04-input.lean').read_bytes()
assert (task / 'declarations-final.lean').read_bytes() == (task / 'final-05-input.lean').read_bytes()
assert (task / 'declarations-final.lean').read_text(encoding='utf-8').startswith(text + '\n')

runs = []
for label, actual in [('attempt-01', 1), ('attempt-02', 1), ('final-03', 1),
                       ('attempt-04', 0), ('final-05', 0)]:
    path = task / (label + '-exit.json')
    result = json.loads(path.read_bytes())
    assert type(result['exit_code']) is int and result['exit_code'] == actual
    assert sha(result['input']) == result['input_sha256']
    assert sha(result['output']) == result['output_sha256']
    assert result['argv'][1:3] == ['env', 'lean']
    runs.append({'label': label, 'receipt': record(path), 'actual_exit': actual,
                 'input': record(result['input']), 'output': record(result['output'])})

output = (task / 'final-05-output.txt').read_text(encoding='utf-8')
assert not re.search(r'\b(?:error|warning):|sorryAx', output)
assert 'ALLOWED_AXIOMS_VERIFIED 21' in output
names = json.loads((task / 'declaration-list.json').read_bytes())
axioms = []
for name in names['new'] + names['reused']:
    match = re.search(re.escape("'" + name + "'") +
        r' (?:depends on axioms: \[([^\]]*)\]|does not depend on any axioms)', output)
    assert match, name
    found = sorted({s.strip() for s in (match[1] or '').split(',') if s.strip()})
    assert set(found) <= {'propext', 'Classical.choice', 'Quot.sound'}
    axioms.append({'name': name, 'axioms': found})
assert len(names['new']) == 16 and len(names['reused']) == 5

imports = []
for module in re.findall(r'^import (\S+)', text, re.M):
    path = module.replace('.', '/')
    imports.append({'module': module, 'source': record(repo / (path + '.lean')),
      'olean': record(repo / '.lake/build/lib/lean' / (path + '.olean'))})
reuse = [
 {'draft': 'advance_mass_balance', 'producer': 'NumStability.cellVolume_smul_finiteVolumeCellAverageUpdate',
  'adaptation': 'Apply to supplied positive volume and the coordinate right-minus-left face difference.'},
 {'draft': 'finite_line_mass_balance', 'producer': 'NumStability.sum_conservativeFluxDifferenceUpdate',
  'adaptation': 'Specialize to volume-weighted masses and shared faces along the finite coordinate line.'},
 {'draft': 'finite_line_mass_preserved', 'producer': 'finite_line_mass_balance',
  'adaptation': 'Equal exterior values remove the boundary difference.'},
 {'draft': 'adjacent_cells_mass_balance', 'producer': 'advance_mass_balance',
  'adaptation': 'Add two cell identities; Function.update_self/update_idem identify their common face.'},
 {'draft': 'sweep', 'producer': 'NumStability.orderedOperatorSweep',
  'adaptation': 'Map the finite direction-duration list to the actual conservative directional operators.'},
 {'draft': 'sweep_two', 'producer': 'NumStability.orderedOperatorSweep_two', 'adaptation': 'Direct specialization.'},
 {'draft': 'sweep_two_mass_balance', 'producer': 'advance_mass_balance',
  'adaptation': 'Two applications, with the second normal flux evaluated on the first updated state.'},
]
manifest = {'kind': 'Supplied-volume coordinate-line conservation scratch foundation',
  'candidate': record(candidate), 'candidate_lines': len(text.splitlines()),
  'new_declarations': names['new'], 'generic_declaration_count': 12, 'witness_declaration_count': 4,
  'new_axiom_checks': axioms[:16], 'reused_axiom_checks': axioms[16:], 'direct_imports': imports,
  'producer_reuse': reuse, 'native_runs': runs, 'all_24_initial_input_hashes_unchanged': True,
  'old_tensor_artifact_hashes_reverified': len(old['files']), 'old_tensor_evidence': record(old_path),
  'old_rejected_audit': old['old_decision'], 'pinned_primary_source': old['source'],
  'source_faithfulness': None, 'user_logical_grid_interpretation': 'PENDING; not adopted',
  'limits': 'Supplied positive volumes and area-integrated oriented normal-flux values; no physical chart, measure, metric, normal, area, constitutive-flux or Riemann certification inferred. No exact PDE/reference average, high-resolution, accuracy, entropy, stability, CFL or convergence claim.',
  'placement_proposal': 'Only if authorized: one new flat FiniteVolume/CoordinateLineBalance.lean generic leaf; keep witness separately. No source wrapper.'}
write_new(task / 'manifest.json', manifest)
artifacts = [record(path) for path in sorted(task.rglob('*')) if path.is_file()]
receipt = {'kind': 'Frozen scratch foundation evidence; not source acceptance',
  'manifest': record(task / 'manifest.json'), 'review': record(task / 'REVIEW.md'),
  'candidate': record(candidate), 'final_declaration_input': record(task / 'declarations-final.lean'),
  'candidate_actual_exit': 0, 'declaration_actual_exit': 0, 'axiom_checks': len(axioms),
  'artifact_count': len(artifacts), 'artifacts': artifacts, 'production_or_gate_edits': False}
write_new(task / 'final-receipt.json', receipt)
print(json.dumps({'receipt': record(task / 'final-receipt.json'), 'manifest': record(task / 'manifest.json'),
  'candidate': record(candidate), 'review': record(task / 'REVIEW.md'),
  'artifacts': len(artifacts), 'new_declarations': len(names['new']), 'axiom_checks': len(axioms)}, indent=2))
