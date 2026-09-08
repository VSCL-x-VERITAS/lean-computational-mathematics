"""Build a structural asset fragment from explicit reviewed inputs; never an epoch.

Narrow supported case: one preview lane, other work lanes inspection-only at the
anchor, and a recorded candidate with exactly the preview tree. Read-only Git
object checks do not create candidates, change refs, or validate source meaning.
"""
from __future__ import annotations

import argparse
import copy
import hashlib
import json
import os
from pathlib import Path, PurePosixPath
import re
import subprocess


class InputError(ValueError):
    pass


def require(condition, message):
    if not condition:
        raise InputError(message)


def canonical(value):
    return json.dumps(value, sort_keys=True, separators=(',', ':'), ensure_ascii=True).encode('utf-8')


def digest(data):
    return hashlib.sha256(data).hexdigest()


def decode_json(data):
    def unique_object(pairs):
        result = {}
        for key, value in pairs:
            require(key not in result, 'duplicate JSON object key: ' + key)
            result[key] = value
        return result
    return json.loads(data, object_pairs_hook=unique_object)


def load(path):
    data = Path(path).read_bytes()
    return decode_json(data), digest(data)


def exact_keys(value, required, label, optional=()):
    require(isinstance(value, dict), label + ' must be an object')
    require(set(required) <= set(value) <= set(required) | set(optional), label + ': unexpected or missing fields')


def schema_check(value, schema, root, label):
    """Validate only the JSON Schema vocabulary used by the emitted fragments.

    The schema is read from the supplied released file, not copied or patched.
    Unknown validation keywords fail closed rather than being ignored.
    """
    allowed = {'$ref', 'type', 'properties', 'required', 'additionalProperties',
               'enum', 'const', 'pattern', 'minLength', 'minItems', 'items',
               'uniqueItems', 'minimum', 'title', 'description'}
    require(set(schema) <= allowed, label + ': unsupported schema vocabulary')
    if '$ref' in schema:
        require(len(schema) == 1 and schema['$ref'].startswith('#/'), 'unsupported reference')
        target = root
        for segment in schema['$ref'][2:].split('/'):
            target = target[segment]
        return schema_check(value, target, root, label)
    kinds = {'object': dict, 'array': list, 'string': str, 'boolean': bool, 'integer': int}
    if 'type' in schema:
        require(schema['type'] in kinds, label + ': unsupported type')
        require(type(value) is kinds[schema['type']], label + ': wrong type')
    if 'const' in schema:
        require(value == schema['const'] and type(value) is type(schema['const']), label + ': wrong constant')
    if 'enum' in schema:
        require(value in schema['enum'], label + ': invalid enum')
    if isinstance(value, str):
        require(len(value) >= schema.get('minLength', 0), label + ': empty string')
        if 'pattern' in schema:
            require(re.search(schema['pattern'], value) is not None, label + ': invalid pattern')
    if type(value) is int:
        require(value >= schema.get('minimum', value), label + ': below minimum')
    if isinstance(value, list):
        require(len(value) >= schema.get('minItems', 0), label + ': too few entries')
        if schema.get('uniqueItems'):
            require(len({canonical(v) for v in value}) == len(value), label + ': duplicate entries')
        for index, item in enumerate(value):
            schema_check(item, schema.get('items', {}), root, f'{label}[{index}]')
    if isinstance(value, dict):
        require(set(schema.get('required', ())) <= set(value), label + ': missing fields')
        properties = schema.get('properties', {})
        if schema.get('additionalProperties') is False:
            require(set(value) <= set(properties), label + ': extra fields')
        for key in set(value) & set(properties):
            schema_check(value[key], properties[key], root, label + '.' + key)


class GitObjects:
    def __init__(self, repository):
        self.repository = Path(repository)
        require(self.repository.is_dir(), 'recorded scratch repository is unavailable')
        self.environment = {k: v for k, v in os.environ.items() if not k.startswith('GIT_')}
        self.environment.update(GIT_CONFIG_GLOBAL=os.devnull, GIT_CONFIG_SYSTEM=os.devnull,
                                GIT_CONFIG_NOSYSTEM='1', GIT_NO_REPLACE_OBJECTS='1')

    def run(self, *args):
        result = subprocess.run(['git', '--no-replace-objects', '-c', 'core.longpaths=true',
                                 '-C', str(self.repository), *args], env=self.environment,
                                stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=False)
        require(result.returncode == 0, 'Git object check failed: ' + result.stderr.decode('utf-8', 'replace')[:400])
        return result.stdout

    def text(self, *args):
        return self.run(*args).decode('utf-8').strip()

    def evidence(self, commit, reference):
        exact_keys(reference, ('path', 'sha256'), 'candidate evidence reference')
        path = reference['path']
        require(isinstance(path, str) and path and '\\' not in path and ':' not in path
                and not PurePosixPath(path).is_absolute() and '..' not in PurePosixPath(path).parts,
                'evidence must name a candidate-relative Git blob')
        require(re.fullmatch('[0-9a-f]{64}', reference['sha256']) is not None, 'bad evidence hash')
        data = self.run('cat-file', 'blob', commit + ':' + path)
        require(digest(data) == reference['sha256'], 'candidate evidence hash mismatch: ' + path)
        return data


def prepare(preview_path, topology_path, request_path, status_path, mapping_path, epoch_schema_path):
    inputs = {}
    for key, path in [('preview', preview_path), ('topology', topology_path), ('request', request_path),
                      ('status', status_path), ('mapping', mapping_path), ('epoch_schema', epoch_schema_path)]:
        value, sha = load(path)
        inputs[key] = (value, sha)
    preview, topology, request, status, mapping, schema = [inputs[k][0] for k in
        ('preview', 'topology', 'request', 'status', 'mapping', 'epoch_schema')]
    exact_keys(mapping, ('schema_version', 'input_sha256', 'review_evidence', 'assets'), 'mapping')
    require(type(mapping['schema_version']) is int and mapping['schema_version'] == 1, 'mapping version')
    exact_keys(mapping['input_sha256'], ('preview', 'topology', 'request', 'status', 'epoch_schema'), 'input hashes')
    for key, expected in mapping['input_sha256'].items():
        require(expected == inputs[key][1], 'mapping does not bind exact ' + key + ' bytes')
    require(schema['properties']['schema_version']['const'] == 2
            and schema['properties']['workflow_schema_version']['const'] == 3, 'unsupported epoch schema')
    require(preview.get('schema') == 1, 'unsupported preview schema')
    require(preview.get('open_source_rows') == [], 'preview still has open source rows')
    require(preview.get('deleted_files') == [], 'deleted files need a separate converter/review')
    require(preview.get('topology_sha256') == inputs['topology'][1], 'preview topology mismatch')
    require(preview.get('anchor') == topology.get('shared_anchor'), 'preview anchor mismatch')
    require(status.get('schema_version') == 1 and status.get('workflow_schema_version') == 4, 'status version')
    require(status.get('current_state') == 'CANDIDATE' and status.get('result_kind') == 'candidate',
            'requires an actual recorded CANDIDATE, not a retained checkpoint')
    require(request.get('task') == 'prepare' and request.get('remote_write_policy') == 'forbid'
            and request.get('admission_backend') == 'none', 'only local prepare/forbid/none is supported')
    require(status.get('request_id') == request.get('request_id')
            and status.get('request_sha256') == inputs['request'][1], 'request/status mismatch')
    require(isinstance(request.get('request_id'), str)
            and re.fullmatch('[0-9a-f]{64}', request['request_id']) is not None, 'invalid request id')
    require(request.get('topology', {}).get('sha256') == inputs['topology'][1], 'request topology mismatch')
    instances = {i['id']: i for i in topology['instances']}
    require(len(instances) == len(topology['instances']), 'duplicate topology instance')
    lanes = {k: i for k, i in instances.items() if i['role'] in ('formalization', 'reorganization')}
    raw_assets = preview['assets']
    require(isinstance(raw_assets, list) and raw_assets, 'empty or missing preview assets')
    original = {a['asset_id']: a for a in raw_assets}
    require(len(original) == len(raw_assets), 'duplicate preview asset id')
    origins = {a['lane_id'] for a in raw_assets}
    require(len(origins) == 1 and origins <= set(lanes), 'supports exactly one inventoried work lane')
    origin = next(iter(origins))
    require(preview['head'] == lanes[origin]['head'], 'preview is not the pinned lane head')
    frozen = {i['instance_id']: i for i in request['inputs']}
    require(len(frozen) == len(request['inputs']) and set(frozen) == set(lanes), 'request must freeze exactly all work lanes')
    for key, lane in lanes.items():
        require(isinstance(lane['head'], str) and re.fullmatch('[0-9a-f]{40}', lane['head']) is not None, 'invalid lane commit')
        item = frozen[key]
        require(item['commit'] == lane['head'] and item['ref'] == lane['ref'], 'frozen lane mismatch: ' + key)
        require(item['mode'] == ('merge' if key == origin else 'inspect'), 'unsupported lane selection')
        if key != origin:
            require(lane['head'] == topology['shared_anchor'], 'nonempty inspection lane needs its own inventory')
    destination = request['destination']['instance_id']
    require(destination == topology['campaign_head']['instance_id'] and destination in instances,
            'candidate destination differs from campaign head')
    require(instances[destination]['role'] in ('canonical', 'reconciliation'), 'invalid candidate destination role')
    require(request['destination']['expected_old_commit'] == topology['campaign_head']['commit'], 'destination pin mismatch')
    for lane in lanes.values():
        require(destination in lane['allowed_destinations'], 'lane does not allow candidate destination')
    recorded = status['candidate']
    candidate = {'instance_id': destination, 'commit': recorded['commit'], 'tree': recorded['tree']}
    schema_check(candidate, schema['properties']['candidate'], schema, 'candidate')
    git = GitObjects(recorded['scratch_repository'])
    require(git.text('rev-parse', candidate['commit'] + '^{commit}') == candidate['commit'], 'candidate is not an exact commit')
    require(git.text('rev-parse', candidate['commit'] + '^{tree}') == candidate['tree'], 'candidate tree mismatch')
    require(git.text('show', '-s', '--format=%P', candidate['commit']).split() == recorded['parents'], 'candidate parents mismatch')
    require(recorded['parents'], 'candidate must have parents')
    require(git.text('rev-parse', preview['head'] + '^{tree}') == preview['tree'] == candidate['tree'],
            'candidate differs from preview tree; a new inventory/review is required')
    first_parents = git.text('rev-list', '--first-parent', candidate['commit']).splitlines()
    require(request['destination']['expected_old_commit'] in first_parents, 'destination first-parent ancestry mismatch')
    git.run('merge-base', '--is-ancestor', preview['head'], candidate['commit'])
    git.run('merge-base', '--is-ancestor', topology['shared_anchor'], candidate['commit'])
    git.evidence(candidate['commit'], mapping['review_evidence'])
    fingerprints = {}
    for evidence in preview['fingerprint_inputs']:
        data = decode_json(git.evidence(candidate['commit'], {'path': evidence['path'], 'sha256': evidence['sha256']}))
        require(data['normalization'] == evidence['normalization'], 'fingerprint normalization mismatch')
        for source_file in data['files']:
            git.evidence(candidate['commit'], {'path': source_file['path'], 'sha256': source_file['sha256']})
        for record in data['records']:
            require(record['name'] not in fingerprints, 'overlapping native declaration fingerprints')
            fingerprints[record['name']] = record
    identities = {}
    require(isinstance(mapping['assets'], list), 'mapping assets must be an array')
    for entry in mapping['assets']:
        exact_keys(entry, ('preview_asset_id', 'concept_id'), 'identity mapping', ('declaration_identity',))
        key = entry['preview_asset_id']
        require(key not in identities, 'duplicate identity mapping')
        identities[key] = entry
    require(set(identities) == set(original), 'identity mapping must cover every preview asset exactly')
    ids = {key: 'occ-' + digest(canonical({'preview_sha256': inputs['preview'][1],
           'lane_id': origin, 'head': preview['head'], 'preview_asset_id': key})) for key in original}
    assets = []
    for key, before in original.items():
        schema_check(before, {'$ref': '#/$defs/asset'}, schema, 'preview asset ' + key)
        require(before['disposition'] in ('selected', 'retained-unresolved'),
                'existing supersession/rejection needs a separate reviewed conversion')
        entry = identities[key]
        after = copy.deepcopy(before)
        after.update(asset_id=ids[key], concept_id=entry['concept_id'])
        after['preview_origin'] = {'asset_id': key, 'preview_sha256': inputs['preview'][1], 'lane_head': preview['head']}
        after['identity_review'] = copy.deepcopy(mapping['review_evidence'])
        if 'module_asset_id' in after:
            require(after['module_asset_id'] in ids, 'unresolved module asset reference')
            owner = original[after['module_asset_id']]
            require(owner['kind'] == 'module' and owner.get('module') == before.get('module'),
                    'module asset reference identifies a different owner')
            after['module_asset_id'] = ids[after['module_asset_id']]
        if before['kind'] == 'declaration':
            identity = entry.get('declaration_identity')
            exact_keys(identity, ('module', 'declaration', 'producer_payload', 'policy_payload'), 'declaration identity')
            name = identity['declaration']
            require(name == before.get('name') and identity['module'] == before.get('module'), 'identity renames preview declaration')
            require(name in fingerprints, 'missing native declaration record')
            record = fingerprints[name]
            require(record['module'] == identity['module'], 'native module differs from declaration identity')
            require(digest(canonical(record)) == before['content_sha256'], 'native record content differs from preview')
            require(record['type_sha256'] == before['type_hash'] and record['value_sha256'] == before['proof_hash'], 'native type/proof mismatch')
            producer = decode_json(git.evidence(candidate['commit'], identity['producer_payload']))
            expected = {'format': 'canonical-producer-identity-v1', 'module': identity['module'],
                        'declaration': name, 'kind': record['kind'], 'type_sha256': record['type_sha256'],
                        'level_params_sha256': record['level_params_sha256']}
            require(producer == expected, 'producer payload differs from native identity')
            policy = decode_json(git.evidence(candidate['commit'], identity['policy_payload']))
            require(isinstance(policy, dict) and policy, 'policy payload must be an explicit reviewed object')
            policy_hash = digest(canonical(policy))
            require('policy_hash' not in before or before['policy_hash'] == policy_hash, 'policy hash would overwrite prior identity')
            producer_hash = digest(canonical(producer))
            require('producer' not in before or before['producer'] == producer_hash,
                    'producer hash would overwrite prior identity')
            require('declaration' not in before or before['declaration'] == name,
                    'declaration metadata would overwrite prior identity')
            after.update(module=identity['module'], declaration=name,
                         producer=producer_hash, policy_hash=policy_hash,
                         identity_payloads={'producer': identity['producer_payload'], 'policy': identity['policy_payload']})
        else:
            require('declaration_identity' not in entry, 'non-declaration asset cannot receive declaration identity')
        schema_check(after, {'$ref': '#/$defs/asset'}, schema, 'converted asset ' + key)
        assets.append(after)
    branches = copy.deepcopy(preview['branches'])
    require(len(branches) == len(lanes) and {b['instance_id'] for b in branches} == set(lanes), 'branch ledger must cover exactly all work lanes')
    covered = set()
    for branch in branches:
        require(branch['ref'] == lanes[branch['instance_id']]['ref'] and branch['disposition'] == 'retain', 'only existing exact-ref retention is supported')
        for key in branch['unique_assets']:
            require(key in original and original[key]['unique'] is True and original[key]['lane_id'] == branch['instance_id'], 'invalid branch unique asset')
        covered.update(branch['unique_assets'])
        branch['unique_assets'] = [ids[key] for key in branch['unique_assets']]
        schema_check(branch, {'$ref': '#/$defs/branch'}, schema, 'branch')
    require(covered == {k for k, a in original.items() if a['unique']}, 'unique assets are not completely retained')
    lane_heads = [{'instance_id': key, 'head': lanes[key]['head']} for key in sorted(lanes)]
    schema_check(lane_heads, schema['properties']['lane_heads'], schema, 'lane_heads')
    groups = {}
    for asset in assets:
        groups.setdefault(asset['concept_id'], []).append(asset['asset_id'])
    return {'schema_version': 1, 'artifact_kind': 'candidate-asset-preparation',
            'epoch_fields': {'candidate': candidate, 'lane_heads': lane_heads, 'assets': assets, 'branches': branches},
            'input_sha256': {key: item[1] for key, item in inputs.items()},
            'reviewed_concept_groups': groups,
            'pending': ['Independent collision disposition review; shared concept ids do not prove equality.',
                        'Reviewed transports, affected-book verdicts and actual organization/ratchet scans.',
                        'All eight candidate-bound command receipts and released pristine verification.'],
            'limits': 'Structural conversion only. No epoch, semantic equality, collision resolution, source verdict, validation PASS, admission or promotion is asserted.'}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    for name in ('preview', 'topology', 'request', 'status', 'mapping', 'epoch-schema', 'output'):
        parser.add_argument('--' + name, type=Path, required=True)
    args = parser.parse_args()
    require(not args.output.exists(), 'output already exists; immutable inputs/results must not be overwritten')
    require(args.output.parent.is_dir(), 'output directory must already exist')
    result = prepare(args.preview, args.topology, args.request, args.status, args.mapping, args.epoch_schema)
    with args.output.open('x', encoding='utf-8', newline='\n') as stream:
        json.dump(result, stream, indent=2, ensure_ascii=False)
        stream.write('\n')
    print('Prepared structural asset bundle; candidate epoch and semantic decisions remain pending.')


if __name__ == '__main__':
    try:
        main()
    except (InputError, KeyError, TypeError, OSError, json.JSONDecodeError) as error:
        raise SystemExit('REFUSED: ' + str(error))
