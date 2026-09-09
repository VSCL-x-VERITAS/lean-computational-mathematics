"""Read-only source/Git snapshot for a root-review-required organization draft."""
from pathlib import Path
import collections
import hashlib
import json
import os
import subprocess
import sys

P = Path(__file__).resolve().parent
D = P.parent
S = D.parent
R = S.parents[3]
ANCHOR = '9e2225705fed906b1120d55105d607baabef57c9'
assert os.name != 'nt', 'Use POSIX workflow launcher'
sys.dont_write_bytecode = True
sys.path.insert(0, str(R / 'tools/architecture'))
import generate_baseline as engine

sha = lambda data: hashlib.sha256(data).hexdigest()
read = lambda p: json.loads(p.read_bytes())
def pin(path):
    return {'path': path.relative_to(R).as_posix(), 'sha256': sha(path.read_bytes())}
def git(*args):
    return subprocess.check_output(['git', '-c', 'core.longpaths=true', *args], cwd=R)
def write(name, value):
    with (P / name).open('x', encoding='utf-8', newline='\n') as stream:
        stream.write(json.dumps(value, indent=2, ensure_ascii=True) + '\n')

head = git('rev-parse', 'HEAD').decode().strip()
top_path = R / '.formalization/library-topology.json'
top_raw = top_path.read_bytes()
top = json.loads(top_raw)
assert top['shared_anchor'] == ANCHOR
graph_path = S / 'architecture-graphs/unblock-nine-final-source.json'
graph_raw = graph_path.read_bytes()
graph = json.loads(graph_raw)
source, modules = engine.scan_sources(R)
assert source['source_tree_sha256'] == graph['source']['source_tree_sha256'] == 'e52c933f50ca95d73628bbd0980125c5f6305a4f6ec05eadad8814ad18834079'
by_name = {m.name: m for m in modules}
by_path = {m.path: m for m in modules}
all_pins = [pin(R / m.path) for m in modules]
starts = {name for name in by_name if name == 'ComputationalMathematics.Source.LeVeque.Chapter01'
          or name.startswith('ComputationalMathematics.Source.LeVeque.Chapter01.')
          or name == 'NumStability.Source.LeVeque.Chapter01'
          or name.startswith('NumStability.Source.LeVeque.Chapter01.')}
closure, todo = set(), list(starts)
while todo:
    name = todo.pop()
    if name in closure:
        continue
    closure.add(name)
    todo.extend(i for i in by_name[name].imports if i in by_name and i not in closure)
fp_paths = [S / 'chapter01-current-expression-fingerprints-24b3.json',
            S / 'baseline-equation03-expression-fingerprints.json',
            D / 'final-fingerprints/additional-expression-fingerprints.json',
            D / 'local-replacement-fingerprints/additional-expression-fingerprints.json']
records, owners = {}, {}
for path in fp_paths:
    fp = read(path)
    for item in fp['files']:
        assert pin(R / item['path'])['sha256'] == item['sha256'], item['path']
        owners[item['path']] = item['sha256']
    for record in fp['records']:
        if record['name'] in records:
            assert records[record['name']] == record
        records[record['name']] = record
assert len(records) == 1089 and len(owners) == 147
closure |= {by_path[p].name for p in owners}
unit_paths = sorted({by_name[n].path for n in closure})
changed = set(git('diff', '--name-only', ANCHOR, '--').decode().splitlines())
changed.update(git('ls-files', '--others', '--exclude-standard').decode().splitlines())
changed = sorted(p for p in changed if p in by_path)
baseline_raw = git('show', ANCHOR + ':docs/architecture/layout-exceptions.json')
with (P / 'protected-anchor-layout-exceptions.json').open('xb') as stream:
    stream.write(baseline_raw)
with (P / 'current-layout-exceptions.json').open('xb') as stream:
    stream.write((R / 'docs/architecture/layout-exceptions.json').read_bytes())
analysis_path = 'ComputationalMathematics/Analysis.lean'
old_analysis = git('show', head + ':' + analysis_path)
new_analysis = (R / analysis_path).read_bytes()
with (P / 'Analysis-at-input-head.lean.txt').open('xb') as stream:
    stream.write(old_analysis)
with (P / 'Analysis-current.lean.txt').open('xb') as stream:
    stream.write(new_analysis)
old_imports = engine.IMPORT_RE.findall(engine.remove_lean_comments(old_analysis.decode('utf-8-sig')))
new_imports = engine.IMPORT_RE.findall(engine.remove_lean_comments(new_analysis.decode('utf-8-sig')))
def without_imports(raw):
    return '\n'.join(line for line in raw.decode('utf-8-sig').splitlines() if not line.startswith('import '))
analysis_delta = {'path': analysis_path, 'input_head': head, 'before_sha256': sha(old_analysis),
    'after_sha256': sha(new_analysis), 'added_imports': sorted(set(new_imports) - set(old_imports)),
    'removed_imports': sorted(set(old_imports) - set(new_imports)),
    'non_import_lines_equal': without_imports(old_analysis) == without_imports(new_analysis)}
receipt_names = {'layout': 'unblock-nine-local-organization-layout-02',
                 'tiers': 'unblock-nine-local-organization-tiers',
                 'compatibility': 'unblock-nine-local-organization-compatibility-02',
                 'hygiene': 'unblock-nine-local-organization-hygiene'}
executions = {}
for key, label in receipt_names.items():
    receipt_path, output_path = S / (label + '-exit.json'), S / (label + '-output.txt')
    receipt = read(receipt_path)
    assert type(receipt['exit_code']) is int and receipt['exit_code'] == 0
    assert receipt['output_sha256'] == sha(output_path.read_bytes())
    assert receipt['input_commit'] == head
    executions[key] = {'receipt': pin(receipt_path), 'output': pin(output_path), 'command': receipt['command'],
                       'actual_elapsed_ms': receipt['elapsed_ms'], 'input_commit': receipt['input_commit']}
gate = read(R / 'gates/leveque-finite-volume/chapter-01.json')
prospective = read(D / 'local-complete-declaration-manifest.json')
target_rows = []
for row in gate['rows']:
    if row['status'] == 'SKIPPED':
        continue
    target = prospective['rows'][row['id']]
    target_rows.append({'row_id': row['id'], 'current_gate_status_observed': row['status'],
        'proposed_owner': target['path'], 'proposed_declaration': target['declaration'],
        'classification_observed': row.get('classification'), 'source_contract_sha256_observed': row.get('source_contract_sha256'),
        'current_gate_declarations_observed': row.get('lean_declarations', [])})
groups = collections.defaultdict(list)
for rec in records.values():
    if rec['module'].startswith('ComputationalMathematics.Source.LeVeque.Chapter01'):
        groups[(rec['type_sha256'], rec['value_sha256'])].append(rec['name'])
same = [names for names in groups.values() if len(names) > 1]
for item in all_pins:
    assert pin(R / item['path']) == item, item['path']
assert top_path.read_bytes() == top_raw and graph_path.read_bytes() == graph_raw
assert git('rev-parse', 'HEAD').decode().strip() == head
write('all-production-source-pins.json', {'status': 'current-snapshot', 'source_tree_sha256': source['source_tree_sha256'], 'files': all_pins})
write('unit-source-pins.json', {'status': 'current-snapshot-root-review-required', 'scope': 'All canonical and compatibility Chapter01 leaves/aggregates, transitive project imports, plus every native owner in all four committed-origin fingerprint inventories.',
    'source_tree_sha256': source['source_tree_sha256'], 'files': [pin(R / p) for p in unit_paths],
    'starts': sorted(starts), 'native_owner_count': len(owners), 'native_constant_count': len(records)})
write('current-source-observation.json', {'status': 'current-snapshot-root-review-required', 'input_commit': head,
    'anchor': ANCHOR, 'production_source_tree_sha256': source['source_tree_sha256'],
    'production_module_count': len(modules), 'unit_module_count': len(unit_paths),
    'actual_changed_source_paths': changed, 'changed_paths_outside_unit_dependency_closure': sorted(set(changed) - set(unit_paths)),
    'topology_sha256': sha(top_raw), 'campaign_owner': next(x['owner'] for x in top['campaigns'] if x['id'] == 'leveque-finite-volume-main-2026q3'),
    'graph_json': pin(graph_path), 'graph_markdown': pin(graph_path.with_suffix('.md')),
    'protected_anchor_legacy_sets': json.loads(baseline_raw)['legacy'],
    'current_legacy_sets': read(R / 'docs/architecture/layout-exceptions.json')['legacy'],
    'fingerprint_inputs': [pin(p) for p in fp_paths], 'source_changes_during_capture': []})
write('actual-four-executions.json', {'status': 'actual-successful-receipts-applicability-root-review-required', 'executions': executions})
write('analysis-only-import-delta.json', analysis_delta)
write('selected-and-prospective-targets.json', {'status': 'organizational-observation-no-new-acceptance', 'rows': target_rows,
    'same_native_type_and_value_groups_in_source_scope': same,
    'limits': 'Equal fingerprints are a search signal, not proof that differently selected source obligations or historical failed contracts are aliases.'})
print(json.dumps({'source_tree_sha256': source['source_tree_sha256'], 'production_modules': len(modules),
    'unit_modules': len(unit_paths), 'changed_source_paths': len(changed),
    'outside_unit_closure': sorted(set(changed)-set(unit_paths)),
    'analysis_imports_added': len(analysis_delta['added_imports']), 'analysis_imports_removed': len(analysis_delta['removed_imports']),
    'analysis_non_import_lines_equal': analysis_delta['non_import_lines_equal'],
    'same_source_fingerprint_groups': same}, indent=2))
