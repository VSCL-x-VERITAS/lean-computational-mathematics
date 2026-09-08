"""Freeze only checked new coordinate-line production and its exact preservation evidence."""
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

initial = json.loads((task / 'placement-initial.json').read_bytes())
for item in [initial['source'], initial['root_approval'], *initial['unchanged_dependencies']]:
    assert sha(item['path']) == item['sha256'], item['path']
for query in initial['searches']:
    assert query['exit_code'] in (0, 1)
    for key in ('stdout', 'stderr'):
        assert sha(query[key]['path']) == query[key]['sha256']
    assert not Path(query['stderr']['path']).read_bytes()

prior_receipt_path = session / 'logical-line-balance-draft/final-receipt.json'
assert sha(prior_receipt_path) == 'a6f2a094d7d249dce20807a68b9a223c97dd5e2246297ce86a69add8f188ca04'
prior = json.loads(prior_receipt_path.read_bytes())
for item in prior['artifacts']:
    assert sha(item['path']) == item['sha256'], item['path']

runs = []
for label in ('build-v1', 'declarations-v1'):
    receipt = json.loads((task / (label + '-exit.json')).read_bytes())
    assert type(receipt['exit_code']) is int and receipt['exit_code'] == 0
    assert sha(task / (label + '-output.txt')) == receipt['output_sha256']
    for item in receipt['inputs']:
        assert sha(item['path']) == item['sha256'] == sha(item['snapshot'])
    runs.append({'label': label, 'actual_exit': receipt['exit_code'],
      'receipt': record(task / (label + '-exit.json')), 'output': record(task / (label + '-output.txt'))})

out = (task / 'declarations-v1-output.txt').read_text(encoding='utf-8')
assert 'CANONICAL_AXIOMS_AND_TYPES_VERIFIED 16' in out
assert out.count('TYPE_PRESERVED ') == 16 and out.count('VALUE_PRESERVED ') == 6
assert not re.search(r'\b(?:error|warning):|sorryAx', out)
axioms = []
for item in initial['declaration_map']:
    name = item['canonical']
    match = re.search(re.escape("'" + name + "'") +
      r' (?:depends on axioms: \[([^\]]*)\]|does not depend on any axioms)', out)
    assert match, name
    found = sorted({s.strip() for s in (match[1] or '').split(',') if s.strip()})
    assert set(found) <= {'propext', 'Classical.choice', 'Quot.sound'}
    axioms.append({'name': name, 'axioms': found})
    assert 'TYPE_PRESERVED ' + item['draft'] + ' => ' + name in out

source = Path(initial['source']['path']).read_text(encoding='utf-8')
def blocks(text):
    matches = list(re.finditer(r'^(?:noncomputable )?(?:def|theorem) (\w+)', text, re.M))
    found = {}
    for index, match in enumerate(matches):
        end = matches[index + 1].start() if index + 1 < len(matches) else len(text)
        body = text[match.start():end]
        body = re.split(r'^/--|^namespace |^end ', body, maxsplit=1, flags=re.M)[0]
        found[match[1]] = re.sub(r'\s+', '', body)
    return found
original_blocks = blocks(source)
files, declarations = [], []
for expected, item in zip((8, 4, 4), initial['new_files'], strict=True):
    path = Path(item['path']); text = path.read_text(encoding='utf-8')
    assert sha(path) == item['sha256'] and b'\r' not in path.read_bytes()
    assert '/-!\n# ' in text and '/-!+#' not in text
    assert not re.search(r'LogicalLineBalanceDraft|\bsorry\b|\badmit\b|^#check|^#print|^axiom ', text, re.M)
    assert not path.with_suffix('').exists()
    new_blocks = blocks(text)
    assert len(new_blocks) == expected
    for name, body in new_blocks.items():
        assert body == original_blocks[name], (path, name)
    namespace = re.search(r'^namespace (\S+)', text, re.M)[1]
    declared = [{'name': namespace + '.' + name,
      'line': text[:match.start()].count('\n') + 1,
      'kind': match[1]} for match in re.finditer(r'^(?:noncomputable )?(def|theorem) (\w+)', text, re.M)
        for name in [match[2]]]
    declarations += declared
    module = path.relative_to(repo).with_suffix('').as_posix().replace('/', '.')
    dependencies = []
    for dependency in re.findall(r'^import (\S+)', text, re.M):
        dep = dependency.replace('.', '/')
        dependencies.append({'module': dependency, 'source': record(repo / (dep + '.lean')),
          'olean': record(repo / '.lake/build/lib/lean' / (dep + '.olean'))})
    if path.name == 'CoordinateLineBalance.lean':
        assert not any(d['module'].endswith('.OperatorSplitting') for d in dependencies)
    files.append({**record(path), 'module': module, 'lines': len(text.splitlines()),
      'declaration_count': expected, 'declarations': declared, 'direct_dependencies': dependencies,
      'olean': record(repo / '.lake/build/lib/lean' / (module.replace('.', '/') + '.olean'))})
assert {d['name'] for d in declarations} == {item['canonical'] for item in initial['declaration_map']}

manifest = {'kind': 'Canonical coordinate-line mathematics extraction', 'new_files': files,
  'total_lines': sum(f['lines'] for f in files), 'declaration_count': len(declarations),
  'declaration_map': initial['declaration_map'], 'exact_proof_and_definition_blocks_preserved': True,
  'type_comparisons': {'count': 16, 'result': 'Lean definitional equality'},
  'definition_value_comparisons': {'count': 6, 'result': 'Lean definitional equality'},
  'axiom_checks': axioms, 'native_runs': runs, 'source': initial['source'],
  'root_approval': initial['root_approval'], 'unchanged_dependencies': initial['unchanged_dependencies'],
  'prior_scratch_receipt': record(prior_receipt_path), 'prior_scratch_artifacts_reverified': len(prior['artifacts']),
  'selected_reuse': ['NumStability.cellVolume_smul_finiteVolumeCellAverageUpdate',
    'NumStability.sum_conservativeFluxDifferenceUpdate', 'NumStability.orderedOperatorSweep',
    'NumStability.orderedOperatorSweep_two', 'Function.update_self', 'Function.update_idem'],
  'source_faithfulness': None, 'geometry_interpretation': 'PENDING; no interpretation added',
  'scope': 'Three new leaves only. Supplied positive volumes and shared integrated normal fluxes; no source wrapper, geometry/physical solver inference, high-resolution or accuracy conclusion.'}
write_new(task / 'manifest.json', manifest)
artifacts = [record(path) for path in sorted(task.rglob('*')) if path.is_file()]
receipt = {'kind': 'Frozen coordinate-line canonical placement', 'manifest': record(task / 'manifest.json'),
  'review': record(task / 'REVIEW.md'), 'production_files': [{k: f[k] for k in ('path', 'sha256')} for f in files],
  'focused_native_exit': 0, 'declaration_native_exit': 0, 'type_comparisons': 16,
  'definition_value_comparisons': 6, 'allowed_axiom_checks': 16,
  'artifact_count': len(artifacts), 'artifacts': artifacts,
  'source_acceptance': False, 'existing_production_gate_or_audit_edits': False}
write_new(task / 'final-receipt.json', receipt)
print(json.dumps({'receipt': record(task / 'final-receipt.json'), 'manifest': record(task / 'manifest.json'),
  'review': record(task / 'REVIEW.md'), 'new_files': [{k: f[k] for k in ('path', 'sha256', 'lines', 'declaration_count')} for f in files],
  'artifacts': len(artifacts)}, indent=2))
