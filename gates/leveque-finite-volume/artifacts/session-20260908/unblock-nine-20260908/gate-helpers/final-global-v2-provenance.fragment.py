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
    require(manifest['audit_validator'] == FINAL_VALIDATOR_PIN, 'Final validator must be the exact reviewed v6')
    refs = manifest['validator_dependencies']
    require(isinstance(refs, list) and len(refs) == len(FINAL_VALIDATOR_DEPENDENCIES),
            'Final validator dependency inventory is incomplete or duplicated')
    require({(item['path'], item['sha256']) for item in refs} ==
            {(item['path'], item['sha256']) for item in FINAL_VALIDATOR_DEPENDENCIES},
            'Final validator dependencies differ from reviewed v6 closure')
    bound_file(root, FINAL_VALIDATOR_PIN, observed)
    for reference in refs:
        bound_file(root, reference, observed)
    support_ref = next(item for item in refs if item['path'].endswith('/qualified_row_support_v3.py'))
    path = bound_file(root, support_ref, observed)
    spec = importlib.util.spec_from_file_location('final_global_qualified_v3', path)
    module = importlib.util.module_from_spec(spec)
    require(spec.loader is not None, 'Cannot load pinned qualified validator support')
    spec.loader.exec_module(module)
    require(module.ROOT.resolve() == root.resolve(), 'Qualified support repository differs')
    return module
