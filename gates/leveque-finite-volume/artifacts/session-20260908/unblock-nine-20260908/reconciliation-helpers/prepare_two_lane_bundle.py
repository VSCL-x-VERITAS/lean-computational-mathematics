"""Convert two real lane inventories plus an explicit reviewed mapping.

Only local prepare/forbid/none and one merge plus one inspection lane are supported.
All inspection occurrences are retained with exact origin semantics. This emits
candidate/lane_heads/assets/branches fragments only, never an epoch or acceptance.
"""
import argparse, copy, re
from pathlib import Path
from common import (GitObjects, canonical, digest, decode_json, load, require,
                    exact_keys, schema_check, checked_lanes, write_new, InputError)
from build_lane_inventory import build

def prepare(preview_paths, topology_path, request_path, status_path, mapping_path,
            epoch_schema_path, git_factory=GitObjects, inventory_builder=build):
    inputs = {k: load(p) for k, p in [('topology', topology_path), ('request', request_path),
              ('status', status_path), ('mapping', mapping_path), ('epoch_schema', epoch_schema_path)]}
    topology, request, status, mapping, schema = [inputs[k][0] for k in ('topology','request','status','mapping','epoch_schema')]
    previews, preview_hashes, preview_files = {}, {}, {}
    for path in preview_paths:
        v, h = load(path); lane = v['lane_id']
        require(lane not in previews, 'duplicate lane preview')
        previews[lane], preview_hashes[lane], preview_files[lane] = v, h, path
    exact_keys(mapping, ('schema_version','input_sha256','review_evidence','assets'), 'mapping')
    require(type(mapping['schema_version']) is int and mapping['schema_version'] == 2, 'mapping version')
    expected_hashes = {k: inputs[k][1] for k in ('topology','request','status','epoch_schema')}
    expected_hashes['previews'] = preview_hashes
    require(mapping['input_sha256'] == expected_hashes, 'mapping must bind all exact inputs and both previews')
    require(schema['properties']['schema_version']['const'] == 2 and schema['properties']['workflow_schema_version']['const'] == 3,
            'unsupported released epoch schema')
    instances, lanes = checked_lanes(topology, git_factory)
    require(set(previews) == set(lanes), 'inventories must cover exactly both work lanes')
    require(status.get('schema_version') == 1 and status.get('workflow_schema_version') == 4, 'status version')
    require(status.get('current_state') == 'CANDIDATE' and status.get('result_kind') == 'candidate',
            'requires actual recorded CANDIDATE, not retained checkpoint')
    require(request.get('task') == 'prepare' and request.get('remote_write_policy') == 'forbid' and request.get('admission_backend') == 'none',
            'only prepare/forbid/none is supported')
    require(re.fullmatch('[0-9a-f]{64}', request.get('request_id','')) is not None, 'invalid request ID')
    require(status.get('request_id') == request['request_id'] and status.get('request_sha256') == inputs['request'][1], 'request/status mismatch')
    require(request.get('topology',{}).get('sha256') == inputs['topology'][1], 'request topology mismatch')
    frozen = {i['instance_id']: i for i in request['inputs']}
    require(len(frozen) == len(request['inputs']) and set(frozen) == set(lanes), 'request must freeze exactly both work lanes')
    merge = [k for k, v in frozen.items() if v['mode'] == 'merge']
    require(len(merge) == 1 and all(i['mode'] in ('merge','inspect') for i in frozen.values()), 'requires one merge and one inspect lane')
    merge = merge[0]
    destination = request['destination']['instance_id']
    require(destination == topology['campaign_head']['instance_id'] and destination in instances, 'destination mismatch')
    require(instances[destination]['role'] in ('canonical','reconciliation'), 'invalid destination role')
    require(request['destination']['expected_old_commit'] == topology['campaign_head']['commit'], 'destination pin mismatch')
    require(request['destination']['ref'] == topology['campaign_head']['ref'], 'destination ref mismatch')
    for lane, v in lanes.items():
        require(frozen[lane]['commit'] == v['head'] and frozen[lane]['ref'] == v['ref'], 'frozen lane mismatch')
        require(destination in v['allowed_destinations'], 'lane route disallows destination')
        preview = previews[lane]
        require(preview.get('schema') == 2 and preview.get('artifact_kind') == 'lane-asset-inventory', 'unsupported inventory')
        require(preview.get('topology_sha256') == inputs['topology'][1], 'preview topology mismatch')
        require(preview.get('head') == v['head'] and preview.get('ref') == v['ref'], 'origin ref/head mismatch')
        require(preview.get('deleted_files') == [], 'deleted files need separate transport inventory')
        if lane == merge:
            require(preview.get('open_source_rows') == [] and preview.get('require_closed') is True, 'merge preview must require all source rows closed')
        # Rebuild the whole inventory from each origin's Git objects. This checks
        # content, coverage and gate selection, not merely a caller's hash strings.
        rebuilt = inventory_builder(topology_path, lane, [e['path'] for e in preview['fingerprint_inputs']], preview['require_closed'])
        require(rebuilt == preview, 'preview differs from complete origin Git inventory: ' + lane)
    selected = request.get('selected_units', [])
    require(len(selected) == 1 and selected[0].get('book_id') == 'leveque-finite-volume' and selected[0].get('unit_id') == '1',
            'bounded converter requires exact Chapter 1 selected unit')
    selected_gate = next(a for a in previews[merge]['assets'] if a['kind'] == 'gate')
    require(selected[0]['gate']['sha256'] == selected_gate['blob_sha256'], 'request gate differs from committed merge gate')
    recorded = status['candidate']
    candidate = {'instance_id': destination, 'commit': recorded['commit'], 'tree': recorded['tree']}
    schema_check(candidate, schema['properties']['candidate'], schema, 'candidate')
    cg = git_factory(recorded['scratch_repository'])
    require(cg.text('rev-parse', candidate['commit'] + '^{commit}') == candidate['commit'], 'candidate commit mismatch')
    require(cg.text('rev-parse', candidate['commit'] + '^{tree}') == candidate['tree'], 'candidate tree mismatch')
    require(cg.text('show','-s','--format=%P', candidate['commit']).split() == recorded['parents'] and recorded['parents'], 'candidate parents mismatch')
    require(previews[merge]['tree'] == candidate['tree'], 'candidate must equal merge-lane tree; changed merge content needs new review')
    require(request['destination']['expected_old_commit'] in cg.text('rev-list','--first-parent',candidate['commit']).splitlines(), 'destination first-parent ancestry mismatch')
    cg.run('merge-base','--is-ancestor',previews[merge]['head'],candidate['commit'])
    cg.run('merge-base','--is-ancestor',topology['shared_anchor'],candidate['commit'])
    cg.evidence(candidate['commit'], mapping['review_evidence'])
    originals, fingerprints = {}, {}
    for lane, preview in previews.items():
        origin_git = git_factory(lanes[lane]['repository']); records = {}
        for evidence in preview['fingerprint_inputs']:
            ref = {k: evidence[k] for k in ('path','sha256')}
            data = decode_json(origin_git.evidence(preview['head'], ref))
            require(data['normalization'] == evidence['normalization'], 'fingerprint normalization mismatch')
            for src in data['files']: origin_git.evidence(preview['head'], {k:src[k] for k in ('path','sha256')})
            for record in data['records']:
                if record['name'] in records: require(records[record['name']] == record, 'unequal native fingerprint overlap')
                records[record['name']] = record
        fingerprints[lane] = records
        for asset in preview['assets']:
            key = (lane, asset['asset_id'])
            require(asset['lane_id'] == lane and asset['origin_commit'] == preview['head'] and asset['origin_ref'] == preview['ref'], 'asset origin mismatch')
            require(key not in originals, 'duplicate origin asset')
            schema_check(asset, {'$ref':'#/$defs/asset'}, schema, 'origin asset')
            originals[key] = asset
    identities = {}
    for entry in mapping['assets']:
        exact_keys(entry, ('lane_id','preview_asset_id','concept_id','disposition'), 'mapping entry', ('declaration_identity',))
        key = (entry['lane_id'], entry['preview_asset_id'])
        require(key not in identities, 'duplicate identity mapping')
        identities[key] = entry
    require(set(identities) == set(originals), 'mapping must cover every origin occurrence exactly')
    ids = {k: 'occ-' + digest(canonical({'preview_sha256':preview_hashes[k[0]], 'lane_id':k[0],
           'head':previews[k[0]]['head'],'preview_asset_id':k[1]})) for k in originals}
    assets = []
    for key, before in originals.items():
        lane, aid = key; entry = identities[key]
        require(before['disposition'] in ('selected','retained-unresolved'), 'supersession/rejection needs separate reviewed conversion')
        expected_disposition = before['disposition'] if lane == merge else 'retained-unresolved'
        require(entry['disposition'] == expected_disposition, 'inspection must be retained and merge origin dispositions preserved')
        after = copy.deepcopy(before)
        after.update(asset_id=ids[key], concept_id=entry['concept_id'], disposition=entry['disposition'])
        after['origin_disposition'] = before['disposition']
        after['preview_origin'] = {'lane_id':lane,'asset_id':aid,'head':previews[lane]['head'],
                                  'ref':previews[lane]['ref'],'preview_sha256':preview_hashes[lane]}
        after['identity_review'] = copy.deepcopy(mapping['review_evidence'])
        after['candidate_selection_role'] = 'merge-origin' if lane == merge else 'inspection-retention-only'
        if 'current_source_certificate' in before:
            after['origin_current_source_certificate'] = before['current_source_certificate']
            after['current_source_certificate'] = before['current_source_certificate'] if lane == merge else False
        if 'module_asset_id' in before:
            owner_key = (lane,before['module_asset_id']); owner = originals.get(owner_key)
            require(owner and owner['kind'] == 'module' and owner.get('module') == before.get('module'), 'wrong origin module owner')
            after['module_asset_id'] = ids[owner_key]
        if before['kind'] == 'declaration':
            identity = entry.get('declaration_identity')
            exact_keys(identity, ('module','declaration','producer_payload','policy_payload'), 'declaration identity')
            name = identity['declaration']; require(name == before.get('name') and identity['module'] == before['module'], 'identity renames origin declaration')
            require(name in fingerprints[lane], 'missing origin native declaration')
            record = fingerprints[lane][name]
            require(record['module'] == before['module'] and digest(canonical(record)) == before['content_sha256'], 'native origin identity mismatch')
            require(record['type_sha256'] == before['type_hash'] and record['value_sha256'] == before['proof_hash'], 'native type/proof mismatch')
            producer = decode_json(cg.evidence(candidate['commit'],identity['producer_payload']))
            expected = {'format':'canonical-producer-identity-v1','module':identity['module'],'declaration':name,
                        'kind':record['kind'],'type_sha256':record['type_sha256'],'level_params_sha256':record['level_params_sha256']}
            require(producer == expected, 'producer payload differs from origin native identity')
            policy = decode_json(cg.evidence(candidate['commit'],identity['policy_payload']))
            require(isinstance(policy,dict) and policy, 'explicit reviewed origin policy payload required')
            ph, pr = digest(canonical(policy)), digest(canonical(producer))
            require('policy_hash' not in before or before['policy_hash'] == ph, 'policy identity overwrite')
            require('producer' not in before or before['producer'] == pr, 'producer identity overwrite')
            require('declaration' not in before or before['declaration'] == name, 'declaration identity overwrite')
            after.update(declaration=name,producer=pr,policy_hash=ph,identity_payloads=copy.deepcopy(identity))
        else: require('declaration_identity' not in entry, 'non-declaration identity is forbidden')
        schema_check(after, {'$ref':'#/$defs/asset'}, schema, 'converted asset')
        assets.append(after)
    branches = []
    for lane, preview in sorted(previews.items()):
        branch = copy.deepcopy(preview['branch'])
        require(branch['instance_id'] == lane and branch['ref'] == lanes[lane]['ref'] and branch['disposition'] == 'retain', 'invalid origin branch retention')
        expected = {aid for (origin,aid),a in originals.items() if origin == lane and a['unique']}
        require(len(branch['unique_assets']) == len(expected) and set(branch['unique_assets']) == expected, 'unique origin assets not completely retained')
        branch['unique_assets'] = [ids[(lane,k)] for k in branch['unique_assets']]
        schema_check(branch, {'$ref':'#/$defs/branch'}, schema, 'branch'); branches.append(branch)
    heads = [{'instance_id':k,'head':v['head']} for k,v in sorted(lanes.items())]
    schema_check(heads, schema['properties']['lane_heads'], schema, 'lane_heads')
    groups = {}
    for a in assets: groups.setdefault(a['concept_id'],[]).append(a['asset_id'])
    checked_lanes(topology, git_factory)
    for key,path in [('topology',topology_path),('request',request_path),('status',status_path),('mapping',mapping_path),('epoch_schema',epoch_schema_path)]:
        require(load(path)[1] == inputs[key][1], 'bound input changed during conversion: '+key)
    for lane,path in preview_files.items(): require(load(path)[1] == preview_hashes[lane], 'preview changed during conversion')
    return {'schema_version':2,'artifact_kind':'two-lane-candidate-asset-preparation',
        'epoch_fields':{'candidate':candidate,'lane_heads':heads,'assets':assets,'branches':branches},
        'input_sha256':{**expected_hashes,'mapping':inputs['mapping'][1]},'reviewed_concept_groups':groups,
        'lane_coverage':{k:{'head':v['head'],'ref':v['ref'],'changed_file_count':v['changed_file_count'],
                           'file_coverage':{p:ids[(k,a)] for p,a in v['file_coverage'].items()},
                           'origin_open_source_rows':v['open_source_rows']} for k,v in previews.items()},
        'pending':['Independent collision/transport decisions and complete affected-book verdicts.',
                   'Actual scoped organization and repository ratchet evidence.',
                   'Eight candidate-bound command receipts and released pristine verification.'],
        'limits':'No semantic equality, source verdict, epoch, candidate creation, admission or promotion. Inspection gate selections remain origin evidence only.'}

def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--preview', type=Path, action='append', required=True)
    for n in ('topology','request','status','mapping','epoch-schema','output'): p.add_argument('--'+n,type=Path,required=True)
    a = p.parse_args(); require(not a.output.exists(), 'output already exists')
    result = prepare(a.preview,a.topology,a.request,a.status,a.mapping,a.epoch_schema)
    write_new(a.output,result)
    print('Prepared two-lane structural asset fragments; no epoch or admission.')

if __name__ == '__main__':
    try: main()
    except (InputError,KeyError,TypeError,OSError,ValueError) as e: raise SystemExit('REFUSED: '+str(e))
