"""Freeze new-leaf placement only after actual native proof and exact input checks."""
from pathlib import Path
import hashlib, json, re

task = Path(__file__).resolve().parent
repo = task.parents[4]
session = task.parent

def digest(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()

def record(path):
    path = Path(path).resolve()
    return {'path': str(path), 'sha256': digest(path), 'bytes': path.stat().st_size}

def write_new(path, value):
    assert not path.exists(), path
    path.write_bytes((json.dumps(value, indent=2) + '\n').encode())

placement = json.loads((task / 'placement-initial.json').read_bytes())
for item in placement['existing_family_before']:
    assert digest(item['path']) == item['sha256'], item['path']

frozen_receipts = []
for directory, expected in [
    ('finite-volume-flux-update-repair', 'b80b7940589121c479769a24e96fdf380fe8182bd4b9dda04d6aa65b7aa0550a'),
    ('finite-volume-flux-error-estimate', '8dea7888d0a07cc3d5b448229aa344a358bd8cb3e0d69f009687c034f49be8b9')]:
    path = session / directory / 'final-receipt.json'
    assert digest(path) == expected
    contents = json.loads(path.read_bytes())
    for item in contents['artifacts']:
        assert digest(item['path']) == item['sha256'], item['path']
    frozen_receipts.append({**record(path), 'artifact_hashes_reverified': len(contents['artifacts'])})

runs = []
for label, expected_exit in [('build-v1', 0), ('declarations-v1', 1),
                             ('build-final', 0), ('declarations-v2', 0)]:
    path = task / (label + '-exit.json')
    receipt = json.loads(path.read_bytes())
    assert receipt['exit_code'] == expected_exit
    output = task / (label + '-output.txt')
    assert digest(output) == receipt['output_sha256']
    for item in receipt['inputs']:
        assert digest(item['snapshot']) == item['sha256']
        if label in ['build-final', 'declarations-v2']:
            assert digest(item['path']) == item['sha256']
    runs.append({'label': label, 'receipt': record(path), 'output': record(output),
                 'actual_exit': receipt['exit_code']})

output = (task / 'declarations-v2-output.txt').read_text(encoding='utf-8')
axioms = [{'name': name, 'axioms': [s.strip() for s in values.split(',') if s.strip()]}
          for name, values in re.findall(r"'([^']+)' depends on axioms: \[([^\]]*)\]", output)]
assert len(axioms) == 16, len(axioms)
allowed = {'propext', 'Classical.choice', 'Quot.sound'}
assert all(set(item['axioms']) <= allowed for item in axioms)
assert output.count('TYPE_PRESERVED ') == 14
assert output.count('TYPE_BRIDGE_BELOW ') == 1
assert 'CHECKED_CANONICAL_DECLARATIONS 15' in output
assert not re.search(r'\berror:', output)

mapping = []
for old, new in re.findall(r'^TYPE_PRESERVED (\S+) => (\S+)$', output, re.M):
    mapping.append({'draft': old, 'canonical': new, 'verification': 'Lean definitional type equality'})
mapping.append({
    'draft': 'NumStability.FVFluxEstimateDraft.linearRule_next_error_bound',
    'canonical': 'NumStability.linearRectangleRiemannInterfaceFlux_update_error_le',
    'verification': 'Exact original statement re-proved from canonical theorem using only numericalUpdate unfolding and sub_zero',
    'bridge': 'NumStability.FVFluxEstimateDraft.linearRule_next_error_bound_statement_preserved'})

removed = [
    {'draft': 'NumStability.FVFluxUpdateDraft.numericalUpdate',
     'replacement': 'riemannFiniteVolumeUpdate grid (t - s) old (rule s t old)',
     'reason': 'Existing operation already accepts arbitrary face-flux arrays; no new wrapper needed.'},
    {'draft': 'NumStability.FVFluxUpdateDraft.exactCellAverage_spec',
     'replacement': 'finiteVolumeCellAverageOn_spec grid _ (fun _ => hq.1 _ _ _) i',
     'reason': 'Existing spatial-average certificate directly applies using rectangle integrability.'},
    {'draft': 'NumStability.FVFluxEstimateDraft.selectedLinearSolve',
     'replacement': '(linearRectangleRiemannInterfaceFluxMethod A hA basis speeds heigen).solve problem trivial',
     'reason': 'Use the actual existing selected solver directly.'},
    {'draft': 'NumStability.FVFluxEstimateDraft.selectedLinearFlux',
     'replacement': 'method.numericalFluxFromInformation (method.extractInformation (method.solve problem trivial))',
     'reason': 'Use the actual existing extraction and flux operations directly.'},
    {'draft': 'NumStability.FVFluxEstimateDraft.linearRule',
     'replacement': 'rectangleRiemannInterfaceFlux method old (fun _ => trivial)',
     'reason': 'Existing rule already builds correctly ordered adjacent-cell data; generic time-parameter adapter is an inline lambda.'},
    {'draft': 'NumStability.FVFluxEstimateDraft.linearRule_eq_rectangleRiemannInterfaceFlux',
     'replacement': 'No replacement declaration: canonical statements already name rectangleRiemannInterfaceFlux.',
     'reason': 'Removed aliases make the old rfl bridge unnecessary.'},
]

files, declarations = [], []
for initial in placement['new_files']:
    path = Path(initial['path'])
    data = path.read_bytes()
    assert b'\r' not in data
    text = data.decode()
    assert not re.search(r'FVFlux\w*Draft|\bsorry\b|\badmit\b|^axiom ', text, re.M)
    assert not path.with_suffix('').exists()
    initial_text = (task / 'snapshots' / (initial['sha256'] + '.lean')).read_text(encoding='utf-8')
    assert re.sub(r'\s+', '', text) == re.sub(r'\s+', '', initial_text), path
    declared = []
    for match in re.finditer(r'^(private )?(?:noncomputable )?(def|theorem) (\w+)', text, re.M):
        private, kind, suffix = match.groups()
        matching = [item['name'] for item in axioms if item['name'].endswith('.' + suffix)]
        assert len(matching) == 1, (suffix, matching)
        item = {'name': matching[0], 'visibility': 'private' if private else 'public',
                'kind': kind, 'line': text[:match.start()].count('\n') + 1}
        declared.append(item)
        declarations.append(item)
    imports = re.findall(r'^import (\S+)', text, re.M)
    dependency_files = []
    for module in imports:
        source = repo / (module.replace('.', '/') + '.lean')
        olean = repo / '.lake/build/lib/lean' / (module.replace('.', '/') + '.olean')
        assert source.is_file() and olean.is_file()
        dependency_files.append({'module': module, 'source': record(source), 'olean': record(olean)})
    module = str(path.relative_to(repo).with_suffix('')).replace('\\', '.').replace('/', '.')
    olean = repo / '.lake/build/lib/lean' / (module.replace('.', '/') + '.olean')
    files.append({**record(path), 'module': module, 'lf_only': True,
                  'lines': len(text.splitlines()), 'declaration_count': len(declared),
                  'declarations': declared, 'direct_dependencies': dependency_files,
                  'compiled_olean': record(olean), 'initial_sha256': initial['sha256'],
                  'post_initial_changes': 'none' if digest(path) == initial['sha256'] else 'whitespace-only wrapping'})
assert len(declarations) == 15
assert sum(item['visibility'] == 'public' for item in declarations) == 13
assert len(mapping) == 15 and len(removed) == 6
declared_set = {item['name'] for item in declarations}
assert {item['canonical'] for item in mapping} == declared_set
origins = []
for folder, filename in [('finite-volume-flux-update-repair', 'candidate.lean'),
                         ('finite-volume-flux-error-estimate', 'estimate-fragment.lean'),
                         ('finite-volume-flux-error-estimate', 'solver-link-fragment.lean')]:
    path = session / folder / filename
    origins.append(record(path))
origin_names = set()
for item in origins:
    text = Path(item['path']).read_text(encoding='utf-8')
    namespace = re.search(r'^namespace (\S+)', text, re.M)[1]
    for name in re.findall(r'^(?:noncomputable )?(?:def|theorem) (\w+)', text, re.M):
        origin_names.add(namespace + '.' + name)
assert origin_names == {item['draft'] for item in mapping + removed}

manifest = {'kind': 'Generic FV extraction; no source interpretation or source wrapper',
            'new_files': files, 'declaration_mapping': mapping, 'eliminated_aliases': removed,
            'original_generic_declaration_count': 21, 'public_declaration_count': 13,
            'private_declaration_count': 2, 'total_lines': sum(item['lines'] for item in files),
            'frozen_origins': origins, 'existing_family_unchanged': placement['existing_family_before'],
            'source_audit_verdict': None, 'no_aggregate_tier_gate_ledger_audit_git_writes': True}
write_new(task / 'placement-manifest.json', manifest)

source_provenance = json.loads((session / 'finite-volume-flux-update-repair/input-provenance.json').read_bytes())
source_items = [source_provenance['source'], *source_provenance['views']]
for item in source_items:
    assert digest(item['path']) == item['sha256']
search = json.loads((task / 'search-provenance.json').read_bytes())
for item in search['source_files']:
    assert digest(item['path']) == item['sha256']
for item in search['captures']:
    assert digest(item['output']) == item['output_sha256']

# Nothing writes these artifact files after this enumeration. The receipt itself
# and any future verification output are intentionally outside its artifact list.
artifacts = [record(path) for path in sorted(task.rglob('*')) if path.is_file()]
receipt = {'kind': 'Frozen generic FV canonical placement',
           'placement_manifest': record(task / 'placement-manifest.json'),
           'review': record(task / 'placement-review.md'), 'native_runs': runs,
           'canonical_axiom_checks': axioms[:15], 'normalization_bridge_axioms': axioms[15],
           'type_preservation': {'definitional_comparisons': 14, 'sub_zero_bridge': 1},
           'frozen_prior_receipts_reverified': frozen_receipts,
           'primary_source_and_prior_view_hashes_reverified': source_items,
           'source_views_note': 'Viewed during frozen foundation tasks; this extraction makes no new source interpretation.',
           'artifacts': artifacts, 'source_audit_verdict': None,
           'limits': 'Conditional mathematical estimates only; no convergence/stability/CFL/tolerance choice; global-field solver comparison requires explicit trace-error premise; block mass bound allows cancellation; root owns aggregate/tier/full-build/audit/source integration.'}
write_new(task / 'final-receipt.json', receipt)
print(json.dumps({'receipt': record(task / 'final-receipt.json'),
                  'manifest': record(task / 'placement-manifest.json'),
                  'review': record(task / 'placement-review.md'),
                  'new_files': [{k: item[k] for k in ['path', 'sha256', 'lines', 'declaration_count']} for item in files],
                  'artifact_count': len(artifacts)}, indent=2))
