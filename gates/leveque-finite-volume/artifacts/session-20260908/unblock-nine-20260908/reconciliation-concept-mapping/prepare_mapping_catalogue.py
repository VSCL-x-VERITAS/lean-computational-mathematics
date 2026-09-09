"""Draft exact origin concept/producer/policy catalogue from explicit pinned inputs.

No Git, candidate, gate, audit, receipt, or acceptance operation is available.
Catalogue policy prose is an explicit review proposal; final selection is external.
"""
import argparse
import hashlib
import json
from pathlib import Path
import re


def require(ok, message):
    if not ok:
        raise ValueError(message)


def canonical(value):
    return json.dumps(value, sort_keys=True, separators=(',', ':'), ensure_ascii=True).encode()


def sha(raw):
    return hashlib.sha256(raw).hexdigest()


def read(path):
    def unique(pairs):
        obj = {}
        for key, value in pairs:
            require(key not in obj, 'duplicate JSON key')
            obj[key] = value
        return obj
    return json.loads(path.read_bytes(), object_pairs_hook=unique)


def bound(root, ref):
    require(set(ref) == {'path', 'sha256'} and re.fullmatch('[0-9a-f]{64}', ref['sha256']), 'invalid reference')
    require(not Path(ref['path']).is_absolute() and '\\' not in ref['path'] and ':' not in ref['path'], 'expected repository-relative path')
    path = (root/ref['path']).resolve()
    require(path.is_relative_to(root.resolve()) and path.is_file(), 'missing or escaping input')
    require(sha(path.read_bytes()) == ref['sha256'], 'input hash changed: ' + ref['path'])
    return path


def reference(root, path):
    return {'path': path.resolve().relative_to(root.resolve()).as_posix(), 'sha256': sha(path.read_bytes())}


def create(path, value):
    with path.open('xb') as stream:
        stream.write((json.dumps(value, indent=2, ensure_ascii=True) + '\n').encode())


def stable_key(asset):
    kind = asset['kind']
    return {'declaration': asset.get('name'), 'module': asset.get('module'),
            'source-row': asset.get('row'), 'audit': asset.get('task_id'),
            'gate': asset.get('path'), 'proof': 'retained-session-and-organization-evidence'}[kind]


def catalogue(root, spec):
    require(spec.get('schema') == 1 and spec.get('stage') in ('baseline-draft', 'final-origin-review-draft'), 'wrong stage/schema')
    require(len(spec['lanes']) == 2, 'exactly two explicit lanes required')
    overrides = {x['declaration']: x for x in spec.get('declaration_overrides', [])}
    require(len(overrides) == len(spec.get('declaration_overrides', [])), 'duplicate declaration override')
    provenance_overrides = {(x['lane_id'], x['kind'], x['stable_key']): x['concept_id']
                            for x in spec.get('provenance_concept_overrides', [])}
    require(len(provenance_overrides) == len(spec.get('provenance_concept_overrides', [])), 'duplicate provenance override')
    require(all(key[1] != 'declaration' for key in provenance_overrides), 'declaration concepts require declaration override')
    assets, lanes, payloads, source_wrappers = [], [], {}, []
    used_overrides = set()
    used_provenance = set()
    for entry in spec['lanes']:
        inventory = read(bound(root, entry['inventory']))
        context = read(bound(root, entry['context']))
        lane = inventory['lane_id']
        require(lane == entry['lane_id'] and lane not in [x['lane_id'] for x in lanes], 'duplicate/wrong lane')
        require(inventory['schema'] == 2 and inventory['artifact_kind'] == 'lane-asset-inventory', 'wrong inventory')
        require(context['lane_id'] == lane and context['origin_head'] == inventory['head']
                and context['inventory_sha256'] == entry['inventory']['sha256'], 'context differs from origin')
        require(len(inventory['assets']) == len({x['asset_id'] for x in inventory['assets']}), 'duplicate origin asset')
        require(set(inventory['branch']['unique_assets']) == {x['asset_id'] for x in inventory['assets'] if x['unique']},
                'lost unique obligation')
        require(len(inventory['file_coverage']) == inventory['changed_file_count'] == len(inventory['changed_blobs']), 'incomplete blob coverage')
        if spec['stage'] == 'final-origin-review-draft' and lane == spec['merge_lane']:
            require(spec.get('final_committed_head') == inventory['head'], 'final explicit head differs from merge inventory')
            require(inventory['require_closed'] is True and inventory['open_source_rows'] == [], 'final merge origin remains open')
        records, record_refs, owner_refs = {}, {}, {}
        expected_fps = [{k: f[k] for k in ('path', 'sha256')} for f in inventory['fingerprint_inputs']]
        require(entry['fingerprints'] == expected_fps, 'not the exact origin fingerprint input list')
        for ref in entry['fingerprints']:
            fp = read(bound(root, ref))
            for item in fp['files']:
                if item['path'] in owner_refs:
                    require(owner_refs[item['path']] == item['sha256'], 'conflicting owner pin')
                owner_refs[item['path']] = item['sha256']
            for record in fp['records']:
                name = record['name']
                require(name not in records or records[name] == record, 'conflicting native record')
                records[name] = record
                record_refs.setdefault(name, []).append(ref)
        row_context = {x['row']: x for x in context['rows']}
        modules = {a['module']: a for a in inventory['assets'] if a['kind'] == 'module'}
        row_assets = {a['row']: a for a in inventory['assets'] if a['kind'] == 'source-row'}
        require(set(row_context) == set(row_assets), 'row context incomplete')
        audit_assets = [a for a in inventory['assets'] if a['kind'] == 'audit']
        for asset in inventory['assets']:
            key = stable_key(asset)
            require(isinstance(key, str) and key, 'asset lacks stable identity key')
            concept = asset['kind'] + '-' + sha(canonical(key))[:32]
            provenance_key = (lane, asset['kind'], key)
            if provenance_key in provenance_overrides:
                concept = provenance_overrides[provenance_key]
                require(isinstance(concept, str) and re.fullmatch('[A-Za-z0-9][A-Za-z0-9._-]*', concept), 'invalid provenance concept')
                used_provenance.add(provenance_key)
            out = {'lane_id': lane, 'preview_asset_id': asset['asset_id'], 'kind': asset['kind'],
                   'stable_key': key, 'concept_id': concept, 'origin_content_sha256': asset['content_sha256'],
                   'origin_head': inventory['head'], 'origin_disposition': asset['disposition'],
                   'proposed_disposition': asset['disposition'] if lane == spec['merge_lane'] else 'retained-unresolved',
                   'unique_obligation_retained': asset['unique'],
                   'review_status': 'proposed-explicit-origin-identity-not-accepted'}
            if asset['kind'] == 'audit':
                out.update(target=asset['target'], recorded_accepted=asset['recorded_accepted'],
                           certificate_role='origin provenance only; candidate acceptance must be independently rebound',
                           origin_selected_source_row=asset['selected_source_row'])
            elif asset['kind'] == 'source-row':
                out.update(origin_status=asset['status'], exact_origin_target_declarations=asset['declarations'],
                           selected_task=asset['faithfulness_task'], source_locator=asset['source_locator'])
            elif asset['kind'] == 'declaration':
                name, module = asset['name'], asset['module']
                record = records[name]
                require(record['module'] == module and sha(canonical(record)) == asset['content_sha256'], 'native declaration mismatch')
                require(record['type_sha256'] == asset['type_hash'] and record['value_sha256'] == asset['proof_hash'], 'native expression mismatch')
                owner = module.replace('.', '/') + '.lean'
                require(modules[module]['source_blob_sha256'] == owner_refs[owner], 'native owner mismatch')
                producer = {'format': 'canonical-producer-identity-v1', 'module': module, 'declaration': name,
                            'kind': record['kind'], 'type_sha256': record['type_sha256'],
                            'level_params_sha256': record['level_params_sha256']}
                selected = [row_context[row] for row in asset['selected_source_rows']]
                require(all(name in row['declarations'] for row in selected), 'wrong selected source target')
                signature = sorted(set(re.findall(r'Lean\.Expr\.const `([^\s]+)', record['type'])))
                own_signature = [{'declaration': n, 'module': records[n]['module'], 'type_sha256': records[n]['type_sha256'],
                                  'value_sha256': records[n]['value_sha256']} for n in signature if n in records]
                policy = {'format': 'exact-declaration-policy-domain-proposal-v1', 'module': module, 'declaration': name,
                          'kind': record['kind'], 'type_sha256': record['type_sha256'],
                          'level_params_sha256': record['level_params_sha256'],
                          'meaning': 'Preserve exactly this native Lean signature and the explicit selected source contracts below; impose no unrecorded simplification of parameters, regularity, representation or conclusion strength.',
                          'selected_source_contracts': [{'row': row['row'], 'source': row['source'], 'contract': row['contract']} for row in selected],
                          'extra_source_claim': None}
                if name in overrides:
                    override = overrides[name]; used_overrides.add(name)
                    preserved_producer = read(bound(root, override['producer_payload']))
                    require(preserved_producer == producer, 'preserved producer differs from native identity')
                    policy = read(bound(root, override['policy_payload']))
                    out['concept_id'] = override['concept_id']
                    out['preserved_payloads'] = {k: override[k] for k in ('producer_payload', 'policy_payload')}
                for kind, value in [('producer', producer), ('policy', policy)]:
                    digest = sha(canonical(value))
                    require(digest not in payloads or payloads[digest]['content'] == value, 'payload collision')
                    payloads[digest] = {'kind': kind, 'content': value, 'canonical_sha256': digest}
                    out[kind + '_payload_id'] = digest
                out.update(module=module, declaration=name, native_record_sources=record_refs[name],
                           owner={'path': owner, 'sha256': owner_refs[owner]}, proof_sha256=record['value_sha256'],
                           selected_source_rows=asset['selected_source_rows'],
                           signature_dependencies=signature, inventoried_signature_dependencies=own_signature,
                           dependency_scope='Exact constants occurring in the native type only; not body/proof dependencies or transitive closure.')
                if '.Source.LeVeque.' in module:
                    associations = [{'task_id': a['task_id'], 'recorded_accepted': a['recorded_accepted'],
                                     'origin_selected_source_row': a['selected_source_row'],
                                     'current_candidate_acceptance': False}
                                    for a in audit_assets if a['target']['declaration'] == name]
                    source_wrappers.append({'lane_id': lane, 'declaration': name, 'module': module,
                        'owner': out['owner'], 'selected_source_rows': asset['selected_source_rows'],
                        'origin_selected_contract_refs': [r['contract_ref'] for r in selected],
                        'historical_audit_associations': associations,
                        'generic_signature_dependencies': [n for n in signature if n in records and '.Source.' not in records[n]['module']],
                        'direct_owner_imports': modules[module]['imports'],
                        'role': 'origin-selected-source-wrapper' if selected else 'retained-source-facing-statement-without-current-selection'})
            assets.append(out)
        lanes.append({'lane_id': lane, 'inventory': entry['inventory'], 'context': entry['context'],
                      'head': inventory['head'], 'tree': inventory['tree'], 'assets': len(inventory['assets']),
                      'unique_obligations': len(inventory['branch']['unique_assets']),
                      'changed_blobs': inventory['changed_file_count'], 'origin_open_rows': inventory['open_source_rows']})
    require(spec['merge_lane'] in [lane['lane_id'] for lane in lanes], 'merge lane absent')
    require(used_overrides == set(overrides), 'unused override')
    require(used_provenance == set(provenance_overrides), 'unused provenance override')
    groups = {}
    for asset in assets:
        groups.setdefault(asset['concept_id'], []).append({'lane_id': asset['lane_id'], 'preview_asset_id': asset['preview_asset_id']})
    return {'schema': 1, 'artifact_kind': 'origin-mapping-review-catalogue', 'stage': spec['stage'],
            'final_committed_head': spec.get('final_committed_head'), 'candidate': None,
            'source_acceptance': False, 'merge_lane': spec['merge_lane'], 'lanes': lanes, 'assets': assets,
            'concept_groups': groups, 'payloads': list(payloads.values()), 'source_wrappers': source_wrappers,
            'limits': ['Proposed concepts identify preserved named declarations or source/audit/module objects. Common names alone are not a semantic equality proof; all origin content and controlled hashes remain separate.',
                       'Only the explicit Eq1.3 override groups the old and new differently named source producers; its prior full-reaudit transport remains separately required.',
                       'Historical certificates are origin provenance; neither their acceptance nor their source policy is promoted to current candidate acceptance.',
                       'Final root-reviewed origin inventories, final committed source fingerprints, source policy refinements, candidate status and eight replay receipts remain required.']}


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--root', type=Path, required=True)
    p.add_argument('--spec', type=Path, required=True)
    p.add_argument('--spec-sha256', required=True)
    p.add_argument('--output', type=Path, required=True)
    args = p.parse_args()
    require(sha(args.spec.read_bytes()) == args.spec_sha256, 'spec hash mismatch')
    spec = read(args.spec)
    output = catalogue(args.root.resolve(), spec)
    require(sha(args.spec.read_bytes()) == args.spec_sha256, 'spec changed')
    output['input_spec'] = reference(args.root, args.spec)
    create(args.output, output)
    print(json.dumps({'status': 'DRAFT_ONLY', 'lanes': output['lanes'], 'assets': len(output['assets']),
                      'payloads': len(output['payloads']), 'source_wrapper_occurrences': len(output['source_wrappers']),
                      'output_sha256': sha(args.output.read_bytes()), 'source_acceptance': False}, indent=2))


if __name__ == '__main__':
    main()
