"""Assemble actual all-41 evidence with the adopted DIM module-root v2 suite.

Additive successor; no gate writes or checker/audit execution. The output retains
the exact batch/global consumer schema. A separate assembly receipt records the
single current fingerprint inventory and helper provenance. Operational use is
POSIX-only. No authority, interpretation, acceptance or historical receipt is
manufactured here; the selected binders retain their complete validation duties.
"""
from pathlib import Path
import argparse
import ast
import hashlib
import importlib.util
import json
import os
import subprocess

D = Path(__file__).resolve().parent
S = D.parent
R = S.parents[3]
H = D / 'gate-helpers'
PREFIX = D.relative_to(R).as_posix() + '/'
PINS = {
    'prepare-final-current-evidence-inputs.py': '584f7ff9a7ad2ece92d0ce0ee4bf5cb12223d198c9dbd5e75fc8bc1303b1004c',
    'dim-module-root-preparation/manifest.json': '679dfb1a8444e179e29a9e3f59376cf22c73682685045fd4dbcb90bdbc08e905',
    'dim-module-root-preparation/ROOT-ADOPTION.md': '9f6fb7745c2aee1ad071659df53e42a8429075e5d9877255f43674508ef81381',
    'gate-helpers/final-global-evidence-input-template.json': '39e18c696bd04be35d870381327fc92c387ca33046a570066b54b183f35824ee',
    'physical-syntax-fingerprints/current-expression-fingerprints.json': '26817e845567840e94977e03a12fd89bb7b8ea3ba0ddc88d20c401e05036ac01',
    'physical-syntax-fingerprints/final-receipt.json': '2b0b08ccf1fe57558f21263a28550ee5627c61c515ef96d805e7a74c59abaf3d',
}
HELPERS = {
    'prepare': 'prepare-successor-audit-with-dim-module-roots-v2.py',
    'support': 'gate-helpers/qualified_row_support_dim_roots_v2.py',
    'qualified': 'gate-helpers/bind-qualified-row-dim-roots-v2.py',
    'closed': 'gate-helpers/validate-closed-row-audits-dim-roots-v2.py',
    'rebind_validator': 'gate-helpers/validate-closed-row-audits-rebind-dim-roots-v2.py',
    'batch': 'gate-helpers/rebind-accepted-row-batch-dim-roots-v2.py',
    'global': 'gate-helpers/bind-final-global-evidence-dim-roots-v2.py',
}
GLOBAL_EVIDENCE = {'source-inventory', 'layout', 'tiers', 'compatibility', 'hygiene',
                   'audits', 'declarations', 'focused-build', 'full-build'}


def require(ok, message):
    if not ok:
        raise ValueError(message)


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def unique_pairs(pairs):
    result = {}
    for key, value in pairs:
        require(key not in result, 'Duplicate JSON key: ' + key)
        result[key] = value
    return result


def read(path):
    return json.loads(path.read_bytes().decode('utf-8-sig'), object_pairs_hook=unique_pairs)


def encode(value):
    return (json.dumps(value, indent=2, ensure_ascii=False) + '\n').encode()


def ref(path):
    return {'path': path.relative_to(R).as_posix(), 'sha256': sha(path)}


class Reader:
    def __init__(self):
        self.observed = {}

    def path(self, value):
        require(isinstance(value, str) and value and '\\' not in value
                and ':' not in value and not Path(value).is_absolute(), 'Expected repository-relative path')
        path = (R / value).resolve()
        require(path.is_relative_to(R.resolve()), 'Path escapes repository')
        return path

    def observe(self, path):
        path = path.resolve()
        require(path.is_relative_to(R.resolve()), 'Observation escapes repository')
        digest = sha(path)
        require(path not in self.observed or self.observed[path] == digest, 'Input changed during assembly')
        self.observed[path] = digest
        return path

    def bound(self, item):
        require(isinstance(item, dict) and set(item) == {'path', 'sha256'}, 'Expected exact FileRef')
        path = self.observe(self.path(item['path']))
        require(self.observed[path] == item['sha256'], 'FileRef SHA mismatch: ' + item['path'])
        return path

    def unchanged(self):
        for path, digest in self.observed.items():
            require(sha(path) == digest, 'Input changed before write: ' + str(path))


def literal(path, name):
    nodes = [node.value for node in ast.parse(path.read_text(encoding='utf-8-sig')).body
             if isinstance(node, ast.Assign)
             and any(isinstance(target, ast.Name) and target.id == name for target in node.targets)]
    require(len(nodes) == 1, 'Expected one literal declaration: ' + name)
    return ast.literal_eval(nodes[0])


def suite(reader):
    pins = {name: {'path': PREFIX + name, 'sha256': digest} for name, digest in PINS.items()}
    for item in pins.values():
        reader.bound(item)
    manifest = read(reader.bound(pins['dim-module-root-preparation/manifest.json']))
    require(manifest['recommended_revision'] == 'v2', 'Wrong adopted helper revision')
    by_path = {item['path']: item for item in manifest['helpers']}
    require(len(by_path) == len(manifest['helpers']) == len(HELPERS)
            and set(by_path) == {PREFIX + name for name in HELPERS.values()}, 'Mixed helper suite')
    helpers = {key: by_path[PREFIX + name] for key, name in HELPERS.items()}
    for item in helpers.values():
        reader.bound(item)
    dependencies = read(reader.bound(manifest['dependencies']))
    require(dependencies['audit_validator'] == helpers['closed'], 'Dependency validator differs')
    for item in dependencies['validator_dependencies']:
        reader.bound(item)
    batch_pins = literal(reader.bound(helpers['batch']), 'PINNED')
    for filename, digest in batch_pins.items():
        reader.bound({'path': PREFIX + 'gate-helpers/' + filename, 'sha256': digest})
    require(batch_pins[Path(HELPERS['support']).name] == helpers['support']['sha256']
            and batch_pins[Path(HELPERS['rebind_validator']).name] == helpers['rebind_validator']['sha256']
            and batch_pins[Path(manifest['dependencies']['path']).name] == manifest['dependencies']['sha256'],
            'Batch selected helper pins differ')
    projection = reader.bound(helpers['global'])
    validator = literal(projection, 'FINAL_VALIDATOR_PIN')
    validator_dependencies = literal(projection, 'FINAL_VALIDATOR_DEPENDENCIES')
    require(validator == helpers['closed'], 'Global selected validator differs')
    actual = {(item['path'], item['sha256']) for item in validator_dependencies}
    require(len(actual) == len(validator_dependencies)
            and {(item['path'], item['sha256']) for item in dependencies['validator_dependencies']} <= actual
            and (helpers['support']['path'], helpers['support']['sha256']) in actual,
            'Mixed global validator dependencies')
    for item in validator_dependencies:
        reader.bound(item)
    return {'helpers': helpers, 'pins': pins, 'dependencies': manifest['dependencies'],
            'validator': validator, 'validator_dependencies': validator_dependencies,
            'runtime_pins': {'path': PREFIX + 'gate-helpers/batch-rebind-runtime-pins.json',
                             'sha256': batch_pins['batch-rebind-runtime-pins.json']}}


def current_fingerprints(reader, selected):
    inventory_ref = selected['pins']['physical-syntax-fingerprints/current-expression-fingerprints.json']
    receipt_ref = selected['pins']['physical-syntax-fingerprints/final-receipt.json']
    inventory, receipt = read(reader.bound(inventory_ref)), read(reader.bound(receipt_ref))
    require(receipt['fingerprints'] == inventory_ref, 'Fingerprint receipt selects another inventory')
    require(all(type(receipt[key]) is int and receipt[key] == 0 for key in
                ('actual_prepare_exit', 'actual_native_exit', 'actual_parse_archive_exit'))
            and receipt['all_source_olean_head_postchecks_passed'] is True,
            'Missing successful fingerprint export provenance')
    require(inventory['owner_count'] == len(inventory['files']) == 183
            and inventory['declaration_count'] == len(inventory['records']) == 1688,
            'Unexpected effective fingerprint coverage')
    require(len({item['path'] for item in inventory['files']}) == len(inventory['files']),
            'Duplicate fingerprint owner')
    for item in inventory['files']:
        reader.bound({key: item[key] for key in ('path', 'sha256')})
    return {'inventory': inventory_ref, 'receipt': receipt_ref, 'owner_count': 183,
            'declaration_count': 1688, 'recorded_input_commit': inventory['input_commit'],
            'meaning': 'One effective syntax inventory; source owners checked current. Historical export commit is not relabelled. No source acceptance or full definitional normalization.'}


def closed_rows(gate):
    rows = gate['rows']
    require(len(rows) == 57 and len({row['id'] for row in rows}) == 57, 'Expected 57 unique rows')
    result = sorted((row for row in rows if row['status'] in ('PROVED', 'REUSED')), key=lambda row: row['id'])
    require(len(result) == 41 and sum(row['status'] == 'SKIPPED' for row in rows) == 16,
            'Exactly 41 closed and 16 skipped rows required')
    return result


def decision_matches(row, task, decision, accepted_pair):
    classification, pair = accepted_pair(decision)
    require(decision.get('task_id') == task['task_id'], 'Decision/task mismatch')
    require(row['lean_declarations'] == [task['target']['declaration']], 'Selected target mismatch')
    require(row.get('classification') == classification and tuple(row.get(key) for key in
            ('lean_implies_source', 'source_implies_lean')) == pair, 'Changed acceptance projection')


def evidence_receipt(receipt, output_sha, head):
    require(type(receipt.get('exit_code')) is int and receipt['exit_code'] == 0, 'Actual successful exit required')
    require(receipt.get('input_commit') == head, 'Evidence is not from current HEAD')
    require(receipt.get('output_sha256') == output_sha, 'Evidence output changed')
    require(type(receipt.get('elapsed_ms')) is int and receipt['elapsed_ms'] >= 0, 'Actual elapsed receipt required')


def audit_receipt(receipt, audit, closed, selected):
    command = receipt.get('command')
    require(isinstance(command, list) and len(command) in (4, 5)
            and Path(command[0]).name.lower() in ('python3', 'python.exe'),
            'Expected actual Python complete-validator invocation')
    rest = command[2:] if command[1] == '-B' else command[1:]
    require(len(rest) == 3 and (R / rest[0]).resolve() == (R / selected['validator']['path']).resolve()
            and rest[1:] == ['--validate', '--require-all-closed'],
            'Expected exact adopted complete-validator invocation')
    require(audit.get('mode') == 'released-complete-validation' and audit.get('closed_rows') == 41,
            'Actual all-closed audit validation required')
    records = audit.get('records')
    require(isinstance(records, list) and len(records) == 41
            and [record.get('row') for record in records] == [row['id'] for row in closed]
            and all(type(record.get('exit_code')) is int and record['exit_code'] == 0 for record in records),
            'Missing successful complete-validation records')


def load_support(path):
    specification = importlib.util.spec_from_file_location('final_current_dim_roots_v2', path)
    result = importlib.util.module_from_spec(specification)
    specification.loader.exec_module(result)
    return result


def current_head():
    return subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=R).decode().strip()


def main():
    require(os.name != 'nt', 'Use the prepared POSIX launcher')
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('mode', choices=['batch', 'global'])
    parser.add_argument('--bundle', required=True, type=Path)
    parser.add_argument('--bundle-sha256', required=True)
    parser.add_argument('--destination', required=True, type=Path)
    args = parser.parse_args()
    reader = Reader()
    reader.observe(Path(__file__))
    bundle_path, destination = args.bundle.resolve(), args.destination.resolve()
    assembly = destination.with_name(destination.name + '.assembly.json')
    require(bundle_path.is_relative_to(D.resolve()) and destination.is_relative_to(D.resolve()), 'Paths must be under D')
    require(not destination.exists() and not assembly.exists(), 'Outputs must be new')
    reader.bound({'path': bundle_path.relative_to(R).as_posix(), 'sha256': args.bundle_sha256})
    bundle = read(bundle_path)
    require(set(bundle) == {'format', 'declaration_manifest', 'evidence'}
            and bundle['format'] == 'explicit-current-chapter-one-checks-1', 'Wrong explicit bundle schema')
    selected = suite(reader)
    fingerprints = current_fingerprints(reader, selected)
    q = load_support(reader.bound(selected['helpers']['support']))
    checker = q.gate_checker()
    gate_path = reader.observe(R / 'gates/leveque-finite-volume/chapter-01.json')
    gate = read(gate_path)
    closed = closed_rows(gate)
    q.validate_preserved_rows(gate)
    manifest = read(reader.bound(bundle['declaration_manifest']))
    for item in manifest['files']:
        reader.bound({key: item[key] for key in ('path', 'sha256')})
    check = reader.bound({'path': manifest['check_file'], 'sha256': manifest['check_file_sha256']})
    require(sorted(manifest['declarations']) == sorted(name for row in closed for name in row['lean_declarations'])
            and sorted(manifest['rows']) == [row['id'] for row in closed], 'Declaration manifest differs from all selected rows')
    decisions = []
    for row in closed:
        task_path = reader.observe(reader.path(row['faithfulness_task']))
        decision_path = reader.observe(reader.path(row['faithfulness_decision']))
        task, decision = read(task_path), read(decision_path)
        decision_matches(row, task, decision, q.accepted_pair)
        require(manifest['rows'][row['id']] == task['target'], 'Manifest selected target differs')
        decisions.append({'row': row['id'], 'task': ref(task_path), 'decision': ref(decision_path)})
    head = current_head()
    evidence = bundle['evidence']
    require(set(evidence) == ({'declarations'} if args.mode == 'batch' else GLOBAL_EVIDENCE), 'Wrong check set')
    receipts = {}
    for name, pair in evidence.items():
        require(set(pair) == {'receipt', 'output'}, 'Wrong evidence pair schema')
        receipt_path, output_path = reader.bound(pair['receipt']), reader.bound(pair['output'])
        receipts[name] = read(receipt_path)
        evidence_receipt(receipts[name], sha(output_path), head)
    native = evidence['declarations']
    require(receipts['declarations'].get('argv') == ['lake', 'env', 'lean', manifest['check_file']], 'Wrong native declaration invocation')
    bindings = checker.current_context(gate_path, 1)['bindings']
    if args.mode == 'batch':
        data = {'schema': 1, 'expected_gate_sha256': reader.observed[gate_path],
                'expected_closed_row_ids': [row['id'] for row in closed], 'current_bindings': bindings,
                'current_native': {'proof_manifest': bundle['declaration_manifest'], 'check': ref(check), **native},
                'runtime_pins': selected['runtime_pins']}
    else:
        data = read(reader.bound(selected['pins']['gate-helpers/final-global-evidence-input-template.json']))
        del data['_incomplete_preparation']
        data.update(input_commit=head, gate_sha256=reader.observed[gate_path],
                    rows_sha256=checker.canonical_sha256(gate['rows']), bindings=bindings,
                    declaration_manifest=bundle['declaration_manifest'], audit_validator=selected['validator'],
                    validator_dependencies=selected['validator_dependencies'], evidence=evidence)
        audit_receipt(receipts['audits'], read(reader.bound(evidence['audits']['output'])), closed, selected)
    require(current_head() == head and checker.current_context(gate_path, 1)['bindings'] == bindings,
            'HEAD or current context changed during assembly')
    reader.unchanged()
    with destination.open('xb') as stream:
        stream.write(encode(data))
    provenance = {'format': 'reviewed-suite-current-evidence-assembly-1', 'mode': args.mode,
                  'scope': 'Input assembly only; no gate mutation, operational binder execution, new source verdict or authority',
                  'input_commit': head, 'closed_rows': 41, 'bundle': ref(bundle_path), 'input': ref(destination),
                  'helper_suite': selected, 'effective_fingerprints': fingerprints, 'accepted_decisions': decisions,
                  'observed_inputs': [{'path': path.relative_to(R).as_posix(), 'sha256': reader.observed[path]}
                                      for path in sorted(reader.observed)],
                  'consumer': selected['helpers'][args.mode],
                  'note': 'Consumer JSON schema is unchanged. Fingerprints belong to this provenance and organization/reconciliation inputs, not unsupported gate-binder fields.'}
    with assembly.open('xb') as stream:
        stream.write(encode(provenance))
    print(json.dumps({'mode': args.mode, 'input_commit': head, 'closed_rows': 41,
                      'input': ref(destination), 'assembly': ref(assembly)}))


if __name__ == '__main__':
    main()
