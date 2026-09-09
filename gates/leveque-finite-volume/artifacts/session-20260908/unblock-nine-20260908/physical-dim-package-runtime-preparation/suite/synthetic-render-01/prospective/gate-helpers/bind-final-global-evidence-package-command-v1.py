"""Project nine pinned successful checks into eight current Chapter 1 evidence records.

Additive successor to session/bind-final-gate-evidence-v3.py. No new mathematical
judgment is made. Default mode validates inputs without writing. --execute is an
explicit coordinator operation, available only after all 41 rows are closed.
Run the operational entry through the prepared POSIX workflow launcher.
"""
from pathlib import Path
import argparse
import copy
import hashlib
import importlib.util
import json
import os
import re
import tomllib

S = Path(__file__).resolve().parents[2]
R = S.parents[3]
CHECKS = ('source-inventory', 'layout', 'tiers', 'compatibility', 'hygiene',
          'audits', 'declarations', 'focused-build', 'full-build')
FORMAT = 'explicit-final-global-evidence-inputs-1'
QUALIFICATION = ('Audit acceptance is supplied by the exact sealed decisions, including '
                 'separately recorded user interpretations, coordinator-selected '
                 'interpretations and additive refinements where bound. Original source '
                 'ambiguities and stronger/scoped qualifications remain in their exact '
                 'row contracts. This projection supplies no new verdict.')


def require(ok, message):
    if not ok:
        raise ValueError(message)


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def unique_pairs(pairs):
    result = {}
    for key, value in pairs:
        require(key not in result, f'Duplicate JSON key: {key}')
        result[key] = value
    return result


def decode(data):
    return json.loads(data.decode('utf-8-sig'), object_pairs_hook=unique_pairs)


def read(path):
    return decode(path.read_bytes())


def encode(value):
    return (json.dumps(value, indent=2, ensure_ascii=False) + '\n').encode()


def repository_path(root, value):
    require(isinstance(value, str) and value and '\\' not in value, 'Invalid repository path')
    candidate = Path(value)
    require(not candidate.is_absolute() and not re.match(r'^[A-Za-z]:', value),
            f'Expected repository-relative path: {value}')
    resolved = (root / candidate).resolve()
    require(resolved.is_relative_to(root.resolve()), f'Path escapes repository: {value}')
    return resolved


def bound_file(root, reference, observed):
    require(isinstance(reference, dict) and set(reference) == {'path', 'sha256'}, 'Invalid file reference')
    require(isinstance(reference['sha256'], str)
            and re.fullmatch('[0-9a-f]{64}', reference['sha256']), 'Invalid file digest')
    path = repository_path(root, reference['path'])
    require(path.is_file() and sha(path) == reference['sha256'], f'Changed pinned file: {path}')
    require(path not in observed or observed[path] == reference['sha256'], 'Conflicting observed file pin: ' + str(path))
    observed[path] = reference['sha256']
    return path


def verify_receipt(receipt, data, input_commit, name):
    require(type(receipt.get('exit_code')) is int and receipt['exit_code'] == 0,
            f'{name}: requires actual integer zero exit')
    hashes = [receipt[k] for k in ('raw_output_sha256', 'output_sha256') if k in receipt]
    digest = hashlib.sha256(data).hexdigest()
    require(hashes and all(h == digest for h in hashes), f'{name}: output bytes mismatch')
    require(receipt.get('input_commit') == input_commit, f'{name}: input commit mismatch')
    require(type(receipt.get('elapsed_ms')) is int and receipt['elapsed_ms'] >= 0,
            f'{name}: missing actual elapsed time')


def python_command(root, command, script, tail=()):
    require(isinstance(command, list) and len(command) >= 2
            and all(isinstance(v, str) for v in command), 'Expected Python argv list')
    exe = command[0].replace('\\', '/').rsplit('/', 1)[-1].lower()
    require(exe in ('python3', 'python.exe'), f'Unexpected Python executable: {exe}')
    rest = command[1:]
    if rest[0] == '-B':
        rest = rest[1:]
    require(rest and (root / rest[0]).resolve() == script.resolve()
            and rest[1:] == list(tail), f'Wrong Python command: {command}')


def native_command(receipt, expected, name):
    require(receipt.get('argv') == expected, f'{name}: native argv mismatch')
    require(receipt.get('command') == ' '.join(expected), f'{name}: native command text mismatch')
    native = receipt.get('native_lake')
    require(isinstance(native, str) and native.replace('\\', '/').rsplit('/', 1)[-1].lower()
            == 'lake.exe', f'{name}: actual native Lake identity missing')


FINAL_VALIDATOR_PIN = {'path': 'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/gate-helpers/validate-closed-row-audits-package-command-v1.py', 'sha256': 'df91e260a502a7dad57c2b8679a19080c36889ff6551a3569d15088a357a9b85'}
FINAL_VALIDATOR_DEPENDENCIES = [{'path': 'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/gate-helpers/qualified_row_support_package_command_v1.py', 'sha256': '945e37cf9fa63522f05f1e88c51e963c6dad5aac628f927d34b3f280d221851b'}, {'path': 'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/gate-helpers/qualified_row_support_dim_roots_v2.py', 'sha256': 'a593d38ed66d7e09804c5ecaadb2e436b22f699e6c8d0f94853999e52e1ea73e'}, {'path': 'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/gate-helpers/protected-baseline.json', 'sha256': 'ac260c0b09f90012c4474b8f4873b8790515858070892cdff6a98f006a483091'}, {'path': 'gates/leveque-finite-volume/artifacts/session-20260908/bind-audited-stronger-reused-row.py', 'sha256': '286f9932e8e0e2242bfaa663498e0ac97abea60e0af6fa8cd6b1cdbacfb63694'}, {'path': 'gates/leveque-finite-volume/artifacts/session-20260908/bind-audited-stronger-production-rows.py', 'sha256': '2b6e6d26931f831970479cfdae30f066d3712586363ef08e6ce0b830306782d6'}, {'path': 'gates/leveque-finite-volume/artifacts/session-20260908/bind-variable-consensus-stronger-row.py', 'sha256': 'e4b0e2d242e7fc7e91e955e3c828bc43992cc4748493c2f4b0d2bea2716f8b4c'}, {'path': 'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/selected-interpretations.json', 'sha256': 'cfde240a9dda9a58be99f85369b43e99003b0024c7147a33ffa8b071ca7dcf34'}, {'path': '.faithfulness-audit/scripts/validate_audit.py', 'sha256': '98893aecc90f52c9b7a63dbf211db3da5e42f26ecb6f132fbfb5098a7bf2ad20'}, {'path': '.faithfulness-audit/scripts/common.py', 'sha256': '1ce103fd5b6a9fbc55fa0be8fc57075f1211d3adbde27decafcf7304e703ceeb'}, {'path': '.faithfulness-audit/scripts/prepare_audit.py', 'sha256': 'f0a82d170c14eb9f2ece6cb897cb0bbc5d6e479b4e4f444f208598bd32e97347'}, {'path': '.faithfulness-audit/scripts/schema_validate.py', 'sha256': 'fcf767dee1f216632958acb8bbd8ebe30c54bc3d5934793933f8863bad0088c1'}]

QUALIFIED_RECORD_FIELDS = ('coordinator_selected_interpretation', 'interpretation_refinement_ref',
    'strengthening_evidence', 'qualified_binding_request', 'native_evidence',
    'source_context_extension', 'inherited_source_interpretation_packet', 'source_context_lineage')


def observe_reference_tree(root, value, observed):
    """Pin explicit FileRefs in a validated request/manifest without inventing references."""
    if isinstance(value, dict):
        if 'path' in value and 'sha256' in value:
            bound_file(root, {key: value[key] for key in ('path', 'sha256')}, observed)
        for child in value.values():
            observe_reference_tree(root, child, observed)
    elif isinstance(value, list):
        for child in value:
            observe_reference_tree(root, child, observed)


def match_qualified_record(record, row):
    for key in QUALIFIED_RECORD_FIELDS:
        if key in row or key in record:
            require(key in row and key in record and record[key] == row[key],
                    f'Qualification mismatch: {key}')


def observe_qualified_record(root, record, row, qualified, bindings, observed):
    match_qualified_record(record, row)
    _, selected = qualified.choices()
    if row['id'] not in selected:
        require(not any(key in row or key in record for key in QUALIFIED_RECORD_FIELDS[3:]),
                'Historical row unexpectedly carries coordinator request/context fields')
        return
    require('qualified_binding_request' in row and 'native_evidence' in row,
            'Selected row requires exact qualified request and native references')
    request_path = bound_file(root, row['qualified_binding_request'], observed)
    request_bytes = request_path.read_bytes()
    checked = qualified.validate_bound_row(row, complete=False)
    request = checked['request']
    require(decode(request_bytes) == request, 'Qualified request changed during validation')
    require(request['current_bindings'] == bindings, 'Qualified request bindings are stale')
    require(record.get('native_axioms') == checked['axioms'], 'Native axiom record differs from exact request')
    require(record.get('manifest_sha256') == request['manifest']['sha256'], 'Qualified manifest record is stale')
    require(record['config'] == {'path': checked['config'].relative_to(root).as_posix(),
                                'sha256': sha(checked['config'])}, 'Qualified configuration record is stale')
    observe_reference_tree(root, request, observed)
    observe_reference_tree(root, checked['manifest'], observed)
    proof_path = bound_file(root, request['native']['proof_manifest'], observed)
    observe_reference_tree(root, read(proof_path), observed)
    native_receipt = read(bound_file(root, request['native']['receipt'], observed))
    if request['native']['receipt_kind'] == 'snapshots':
        for item in native_receipt['inputs']:
            for path_key, hash_key in (('path', 'sha256_before'), ('snapshot', 'snapshot_sha256')):
                path = qualified.runtime_path(item[path_key])
                bound_file(root, {'path': path.relative_to(root).as_posix(),
                                  'sha256': item[hash_key]}, observed)
    for path, digest in checked['audit_hashes'].items():
        absolute = Path(path).resolve()
        require(absolute.is_relative_to(root.resolve()), 'Audit provenance escapes repository')
        bound_file(root, {'path': absolute.relative_to(root).as_posix(), 'sha256': digest}, observed)
    if checked['source_context'] is not None:
        for reference in checked['source_context']['provenance']:
            bound_file(root, reference, observed)


def load_final_validator_support(root, manifest, observed):
    require(manifest['audit_validator'] == FINAL_VALIDATOR_PIN, 'Final validator must be the exact reviewed v8')
    refs = manifest['validator_dependencies']
    require(isinstance(refs, list) and len(refs) == len(FINAL_VALIDATOR_DEPENDENCIES),
            'Final validator dependency inventory is incomplete or duplicated')
    require({(item['path'], item['sha256']) for item in refs} ==
            {(item['path'], item['sha256']) for item in FINAL_VALIDATOR_DEPENDENCIES},
            'Final validator dependencies differ from reviewed v8 closure')
    bound_file(root, FINAL_VALIDATOR_PIN, observed)
    for reference in refs:
        bound_file(root, reference, observed)
    support_ref = next(item for item in refs if item['path'].endswith('/qualified_row_support_package_command_v1.py'))
    path = bound_file(root, support_ref, observed)
    spec = importlib.util.spec_from_file_location('final_global_qualified_package_command_v1', path)
    module = importlib.util.module_from_spec(spec)
    require(spec.loader is not None, 'Cannot load pinned qualified validator support')
    spec.loader.exec_module(module)
    require(module.ROOT.resolve() == root.resolve(), 'Qualified support repository differs')
    return module


def validate_audit_records(audit, closed, root, observed, qualified=None, bindings=None):
    require(audit.get('mode') == 'released-complete-validation', 'Audit inventory is not validation')
    require(type(audit.get('closed_rows')) is int and audit['closed_rows'] == 41
            and len(closed) == 41, 'Exactly 41 closed Lean rows required')
    records = audit.get('records')
    require(isinstance(records, list) and len(records) == 41
            and [x.get('row') for x in records] == [r['id'] for r in closed],
            'Audit records do not exactly cover current closed rows')
    for record, row in zip(records, closed, strict=True):
        require(type(record.get('exit_code')) is int and record['exit_code'] == 0,
                f"{row['id']}: complete audit validation failed")
        decision_path = repository_path(root, row['faithfulness_decision'])
        decision_bytes = decision_path.read_bytes()
        observed[decision_path] = hashlib.sha256(decision_bytes).hexdigest()
        require(record.get('decision_sha256') == observed[decision_path], 'Stale decision receipt')
        decision = decode(decision_bytes)
        task_path = repository_path(root, row['faithfulness_task'])
        task = read(task_path)
        observed[task_path] = sha(task_path)
        require(decision.get('accepted') is True and decision.get('task_id') == task['task_id']
                and record.get('task') == task['task_id'], 'Unaccepted or mismatched task decision')
        require(row['lean_declarations'] == [record.get('declaration')]
                == [task['target']['declaration']], 'Task/row/record declaration mismatch')
        for key in ('classification', 'lean_implies_source', 'source_implies_lean'):
            require(record.get(key) == row.get(key), f'Changed audit projection: {key}')
        require(decision.get('classification') == row.get('classification'), 'Changed classification')
        for key in ('lean_implies_source', 'source_implies_lean'):
            require(decision['implications'][key]['verdict'] == row.get(key), 'Changed implication')
        match_qualified_record(record, row)
        manifest_path = repository_path(root, task['audit_output']) / 'manifest.json'
        bound_file(root, {'path': manifest_path.relative_to(root).as_posix(),
                          'sha256': record.get('manifest_sha256')}, observed)
        if qualified is not None:
            observe_qualified_record(root, record, row, qualified, bindings, observed)
        else:
            require(not any(key in row or key in record for key in QUALIFIED_RECORD_FIELDS[3:]),
                    'Qualified records require the exact v8 support')
        bound_file(root, record['config'], observed)
        # Each inner command must be the released complete validator with its exact task.
        inner = record.get('command')
        require(isinstance(inner, list) and len(inner) == 6 and inner[1] == '-B'
                and (root / inner[2]).resolve() == (root / '.faithfulness-audit/scripts/validate_audit.py').resolve()
                and (root / inner[3]).resolve() == task_path
                and inner[4:] == ['--phase', 'complete'], 'Wrong inner complete-validation command')
        require(re.fullmatch('[0-9a-f]{64}', record.get('output_sha256', '')) is not None,
                'Missing actual complete-validation output digest')


def read_axioms(output, names, allowed):
    require(not re.search(r'(?m)^.*\.lean:\d+:\d+: error:', output), 'Native declaration error')
    result = []
    for name in names:
        found = re.findall(re.escape("'" + name + "' depends on axioms:") + r'\s*\[([^\]]*)\]', output)
        require(len(found) == 1, f'Expected one exact axiom report: {name}')
        axioms = sorted({v.strip() for v in found[0].split(',') if v.strip()})
        require(set(axioms) <= set(allowed), f'Unapproved axioms: {name}: {axioms}')
        # Actual #check forms may contain universes and explicit/implicit parameters.
        types = re.findall(r'(?m)^' + re.escape(name) + r'(?=\s|\.\{)', output)
        require(len(types) == 1, f'Expected one exact declaration type: {name}')
        result.append({'name': name, 'axioms': axioms})
    return result


def validate(root, session, gate_checker, inputs):
    observed = {inputs.resolve(): sha(inputs)}
    m = read(inputs)
    require(m.get('format') == FORMAT, 'Wrong final input format')
    require(re.fullmatch('[0-9a-f]{40}', m.get('input_commit', '')) is not None, 'Invalid input commit')
    checker_ref = m['gate_checker']
    require(set(checker_ref) == {'path', 'sha256'}, 'Invalid checker reference')
    expected_checker = (root / checker_ref['path']).resolve()
    require(gate_checker.resolve() == expected_checker and sha(expected_checker) == checker_ref['sha256'],
            'Configured released gate checker path/hash mismatch')
    observed[expected_checker] = checker_ref['sha256']
    spec = importlib.util.spec_from_file_location('final_global_released_gate', expected_checker)
    checker = importlib.util.module_from_spec(spec)
    require(spec.loader is not None, 'Cannot load pinned gate checker')
    spec.loader.exec_module(checker)
    gate_path = root / 'gates/leveque-finite-volume/chapter-01.json'
    original = gate_path.read_bytes()
    gate = decode(original)
    require(hashlib.sha256(original).hexdigest() == m['gate_sha256'], 'Current gate bytes changed')
    context = checker.current_context(gate_path, 1)
    require(gate['bindings'] == context['bindings'] == m['bindings'], 'Current binding mismatch')
    require(m['rows_sha256'] == checker.canonical_sha256(gate['rows']), 'Current rows changed')
    closed = sorted([r for r in gate['rows'] if r['status'] in checker.CLOSED_LEAN_STATUSES],
                    key=lambda r: r['id'])
    require(len(closed) == 41 and len(gate['rows']) == 57
            and all(r['status'] in checker.CLOSED_LEAN_STATUSES | {'SKIPPED'} for r in gate['rows']),
            'All 41 formalizable rows must already be closed, with 16 skipped')
    require(len({r['id'] for r in gate['rows']}) == 57, 'Duplicate inventory rows')
    snapshot = read(bound_file(root, m['source_inventory_snapshot'], observed))
    require(snapshot['source_sha256'] == checker.PINNED_SOURCE_SHA256, 'Source snapshot differs')
    bound_file(root, {'path': snapshot['source_path'], 'sha256': snapshot['source_sha256']}, observed)
    for reference in snapshot['reviews']:
        bound_file(root, {k: reference[k] for k in ('path', 'sha256')}, observed)
    by_id = {r['id']: r for r in gate['rows']}
    require(len(snapshot['rows']) == 57 and {r['id'] for r in snapshot['rows']} == set(by_id),
            'Reviewed source inventory coverage changed')
    require(snapshot['printed_pages'] == [1, 11] and snapshot['raw_pdf_pages'] == [23, 33],
            'Reviewed source page range changed')
    for entry in snapshot['rows']:
        row = by_id[entry['id']]
        for field in ('id', 'source_label', 'printed_page', 'pdf_page', 'row_kind', 'depends_on', 'source_proof'):
            require(entry[field] == row.get(field, ''), f'Reviewed source field changed: {field}')
        if entry['disposition'].get('formalizable') is True:
            require(row['status'] in checker.CLOSED_LEAN_STATUSES, 'Reviewed formalizable row is open')
        else:
            require(all(row.get(k) == v for k, v in entry['disposition'].items())
                    and row['status'] == 'SKIPPED' and not row.get('lean_declarations'),
                    'Reviewed skip disposition changed')
    declaration_manifest = read(bound_file(root, m['declaration_manifest'], observed))
    for reference in declaration_manifest['files']:
        bound_file(root, {k: reference[k] for k in ('path', 'sha256')}, observed)
    checkfile = bound_file(root, {'path': declaration_manifest['check_file'],
                                'sha256': declaration_manifest['check_file_sha256']}, observed)
    names = sorted({name for row in closed for name in row['lean_declarations']})
    require(names == declaration_manifest['declarations'] and len(names) == 41,
            'Native manifest must cover exactly the 41 current declarations')
    require(set(declaration_manifest['rows']) == {r['id'] for r in closed}, 'Native row map changed')
    for row in closed:
        mapping = declaration_manifest['rows'][row['id']]
        require([mapping['declaration']] == row['lean_declarations'], 'Native row declaration changed')
        require(any(f['path'] == mapping['path'] and mapping['declaration'] in f['declarations']
                    for f in declaration_manifest['files']), 'Native row owner missing')
    require(set(m['evidence']) == set(CHECKS), 'Exactly nine evidence entries required')
    receipts, outputs = {}, {}
    for name in CHECKS:
        entry = m['evidence'][name]
        require(set(entry) == {'receipt', 'output'}, f'{name}: invalid receipt/output entry')
        receipt = read(bound_file(root, entry['receipt'], observed))
        data = bound_file(root, entry['output'], observed).read_bytes()
        verify_receipt(receipt, data, m['input_commit'], name)
        receipts[name], outputs[name] = receipt, data.decode('utf-8-sig')
    capture = bound_file(root, m['capture_script'], observed)
    for name in CHECKS:
        require(receipts[name].get('capture_script_sha256') == sha(capture), f'{name}: capture script mismatch')
    scripts = {'source-inventory': session / 'verify-reviewed-source-coverage.py',
               'layout': root / 'tools/architecture/check_layout.py',
               'tiers': root / 'tools/architecture/check_tiers.py',
               'compatibility': root / 'tools/architecture/check_compatibility.py',
               'hygiene': root / 'tools/architecture/check_placeholders.py'}
    require(set(m['check_scripts']) == set(scripts), 'Pinned check-script inventory differs')
    for name, expected in scripts.items():
        actual = bound_file(root, m['check_scripts'][name], observed)
        require(actual == expected.resolve(), f'{name}: changed checker path')
        python_command(root, receipts[name]['command'], actual)
    validator = bound_file(root, m['audit_validator'], observed)
    python_command(root, receipts['audits']['command'], validator, ['--validate', '--require-all-closed'])
    for reference in m['validator_dependencies']:
        bound_file(root, reference, observed)
    native_command(receipts['declarations'], ['lake', 'env', 'lean', checkfile.relative_to(root).as_posix()], 'declarations')
    native_command(receipts['focused-build'], ['lake', '--quiet', '--log-level=error', 'build',
                   'ComputationalMathematics.Source.LeVeque.Chapter01'], 'focused-build')
    native_command(receipts['full-build'], ['lake', '--quiet', '--log-level=error', 'build'], 'full-build')
    require(len({receipts[n]['native_lake'] for n in ('declarations', 'focused-build', 'full-build')}) == 1,
            'Native checks were captured with different Lake paths')
    lakefile = bound_file(root, m['lakefile'], observed)
    require(lakefile == (root / 'lakefile.toml').resolve()
            and tomllib.loads(lakefile.read_text())['defaultTargets'] == ['ComputationalMathematics', 'NumStability'],
            'Full default build target list changed')
    layout = outputs['layout']
    for expected in ('unclassified modules: 0', 'mixed modules: 0', 'modules missing module docs: 0',
                     'legacy naming exceptions: 0', 'declaration-bearing umbrellas: 0',
                     'unsorted aggregate imports: 0', 'Layout contract satisfied'):
        require(expected in layout, f'Layout content missing: {expected}')
    require('tier contract passed:' in outputs['tiers'] and 'mixed 0, unclassified 0' in outputs['tiers'],
            'Tier result is not successful')
    require('compatibility contract passed:' in outputs['compatibility']
            and '0 production imports of historical paths' in outputs['compatibility'], 'Compatibility result differs')
    require('placeholder and axiom policy passed:' in outputs['hygiene'], 'Hygiene result differs')
    require('57 records; 41 formalizable; 16 skipped;' in outputs['source-inventory'], 'Source coverage result differs')
    organization = gate['verification_loops']['organization_completeness']
    require(all(type(v) is int and v == 0 for v in organization.values()), 'Nonzero organization counters')
    qualified = load_final_validator_support(root, m, observed)
    qualified.validate_preserved_rows(gate)
    validate_audit_records(decode(outputs['audits'].encode()), closed, root, observed, qualified, context['bindings'])
    axioms = read_axioms(outputs['declarations'], names, checker.ALLOWED_AXIOMS)
    paths, mismatches = checker.cross_gate_state(root, organization)
    require(not mismatches, 'Cross-gate organization mismatch')
    subject = checker.canonical_sha256({'book_id': checker.BOOK_ID, 'unit_kind': 'chapter', 'unit': 1,
              'chapter': 1, 'source_unit_sha256': checker.PINNED_SOURCE_SHA256, 'mode': 'default',
              'excluded_rows': [], 'rows': gate['rows']})
    bindings = checker.global_artifact_bindings(1, context, subject)
    return dict(root=root, session=session, gate_path=gate_path, original=original, gate=gate,
                context=context, checker=checker, manifest=m, receipts=receipts, observed=observed,
                closed=closed, names=names, axioms=axioms, paths=paths, organization=organization,
                subject=subject, bindings=bindings)


def unchanged(state):
    for path, digest in state['observed'].items():
        require(sha(path) == digest, f'Input changed during verification: {path}')
    require(state['gate_path'].read_bytes() == state['original'], 'Gate changed during verification')
    now = state['checker'].current_context(state['gate_path'], 1)
    require(now['bindings'] == state['context']['bindings'], 'Released context changed during verification')


def execute(state, label):
    g = copy.deepcopy(state['gate'])
    checker = state['checker']
    context, closed, names = state['context'], state['closed'], state['names']
    G, organization, paths = state['gate_path'], state['organization'], state['paths']
    root, session = state['root'], state['session']
    payloads = {
        'source_inventory': {'row_ids': sorted(r['id'] for r in g['rows']),
            'page_coverage': [{'row_id': r['id'], 'printed_page': r['printed_page'], 'pdf_page': r['pdf_page']}
                              for r in sorted(g['rows'], key=lambda r: r['id'])],
            'printed_page_range': list(context['printed_range']), 'pdf_page_range': list(context['pdf_range'])},
        'organization_scan': {'counters': organization, 'unit_report': {'gate_path': G.relative_to(root).as_posix(),
            'chapter': 1, 'unit_audit_epoch': context['bindings']['unit_audit_epoch'],
            'unit_index_sha256': context['bindings']['unit_index_sha256'], 'counters': organization},
            'cross_gate_consistency': {'gate_paths': paths, 'counters': organization, 'mismatches': []}},
        'faithfulness_audit': {'rows': [{'row_id': r['id'], **{k: checker.text(r, k) for k in
            ('contract_hash', 'source_contract_sha256', 'blind_sha256', 'direct_sha256',
             'round_trip_sha256', 'adjudication_sha256')}} for r in closed]},
        'declaration_resolution': {'declarations': names}, 'axiom_check': {'declarations': state['axioms']},
        'hygiene_check': {'findings': [], 'scanned_paths': context['lean_changed_paths']},
        'focused_build': {'passed': ['ComputationalMathematics.Source.LeVeque.Chapter01']},
        'full_build': {'passed': ['ComputationalMathematics', 'NumStability']}}
    counts = {'source_inventory': len(g['rows']), 'organization_scan': len(paths), 'faithfulness_audit': len(closed),
              'declaration_resolution': len(names), 'axiom_check': len(names), 'hygiene_check': 0,
              'focused_build': 1, 'full_build': 2}
    primary = {'source_inventory': 'source-inventory', 'organization_scan': 'layout', 'faithfulness_audit': 'audits',
               'declaration_resolution': 'declarations', 'axiom_check': 'declarations', 'hygiene_check': 'hygiene',
               'focused_build': 'focused-build', 'full_build': 'full-build'}
    require(set(checker.EVIDENCE_NAMES) == set(payloads), 'Released evidence schema changed')
    destination = session / (label + '-global-evidence')
    require(not destination.exists(), 'Fresh output label required')
    unchanged(state)
    destination.mkdir()
    for name in checker.EVIDENCE_NAMES:
        command = state['receipts'][primary[name]]['command']
        command = command if isinstance(command, str) else json.dumps(command)
        artifact = {'schema_version': 1, 'check': name, 'bindings': state['bindings'], 'command': command,
                    'exit_code': 0, 'count': counts[name], 'payload': payloads[name]}
        path = destination / (name + '.json')
        path.write_bytes(encode(artifact))
        g['verification_evidence'][name] = {'command': command, 'artifact': path.relative_to(G.parent).as_posix(),
                                         'artifact_sha256': sha(path), 'exit_code': 0, 'count': counts[name]}
    defects, complete = checker.evidence_defects(g['verification_evidence'], gate_path=G, chapter=1,
        context=context, rows=g['rows'], organization=organization, used_artifacts=set())
    require(not defects and all(complete.values()) and len(complete) == 8, f'Global evidence defects: {defects}')
    require({k: v for k, v in g.items() if k != 'verification_evidence'}
            == {k: v for k, v in state['gate'].items() if k != 'verification_evidence'}, 'Unrequested gate mutation')
    unchanged(state)
    (destination / 'prior-gate.json').write_bytes(state['original'])
    (destination / 'consumed-receipts.json').write_bytes(encode({
        'input_manifest': state['manifest'], 'gate_subject_sha256': state['subject'],
        'receipts': state['receipts'], 'qualification': QUALIFICATION,
        'observed_files': [{'path': str(p), 'sha256': h} for p, h in state['observed'].items()],
        'nine_actual_checks': list(CHECKS)}))
    unchanged(state)
    G.write_bytes(encode(g))
    return {'bound_global_checks': len(complete), 'actual_check_receipts': 9, 'closed_rows': len(closed),
            'declarations': len(names), 'gate_sha256': sha(G),
            'scope': 'Evidence projection only; the unchanged released gate determines the chapter verdict.'}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--label', required=True)
    parser.add_argument('--gate-checker', type=Path, required=True)
    parser.add_argument('--inputs', type=Path, required=True)
    parser.add_argument('--execute', action='store_true')
    args = parser.parse_args()
    require(os.name != 'nt', 'Operational entry must use the prepared POSIX launcher')
    require(re.fullmatch('[A-Za-z0-9][A-Za-z0-9-]{0,79}', args.label), 'Invalid label')
    state = validate(R, S, args.gate_checker, args.inputs)
    unchanged(state)
    result = execute(state, args.label) if args.execute else {
        'mode': 'validated-no-writes', 'actual_check_receipts': 9, 'closed_rows': 41,
        'declarations': len(state['names']), 'input_manifest_sha256': sha(args.inputs),
        'qualification': QUALIFICATION}
    print(json.dumps(result, indent=2))


if __name__ == '__main__':
    main()
