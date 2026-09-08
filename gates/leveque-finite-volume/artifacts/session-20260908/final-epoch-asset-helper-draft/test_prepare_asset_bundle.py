"""Fixture-only regression checks; all Git commits live in a temporary test repo."""
from __future__ import annotations

import argparse
import copy
import json
from pathlib import Path
import subprocess
import tempfile

import prepare_asset_bundle as helper


HERE = Path(__file__).resolve().parent


def write(path, value):
    path.write_bytes(helper.canonical(value) + b'\n')


def fixture(root):
    repo = root / 'fixture-repo'
    repo.mkdir()

    def git(*args):
        result = subprocess.run(['git', '-c', 'core.longpaths=true', '-C', str(repo), *args],
                                stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=True)
        return result.stdout.decode().strip()

    git('init', '--quiet')
    git('config', 'user.name', 'Synthetic fixture')
    git('config', 'user.email', 'fixture@example.invalid')
    (repo / 'base.txt').write_text('Synthetic fixture only.\n', encoding='utf-8')
    git('add', 'base.txt')
    git('commit', '--quiet', '-m', 'fixture anchor')
    anchor = git('rev-parse', 'HEAD')
    (repo / 'Example.lean').write_text('-- Synthetic fingerprint fixture; no theorem is asserted.\n', encoding='utf-8')
    (repo / 'review.md').write_text('Fixture-only explicit association of old and new identities; no equality claim.\n', encoding='utf-8')
    records = []
    for index, name in enumerate(('Example.old', 'Example.new')):
        record = {'name': name, 'module': 'Example', 'kind': 'theorem',
                  'type_sha256': str(index + 1) * 64, 'value_sha256': str(index + 3) * 64,
                  'level_params_sha256': '5' * 64}
        records.append(record)
        write(repo / f'producer{index}.json', {'format': 'canonical-producer-identity-v1',
              'module': 'Example', 'declaration': name, 'kind': 'theorem',
              'type_sha256': record['type_sha256'], 'level_params_sha256': record['level_params_sha256']})
        write(repo / f'policy{index}.json', {'format': 'fixture-policy', 'meaning': f'explicit synthetic policy {index}'})
    fingerprints = {'normalization': 'SYNTHETIC TEST RECORDS, NOT NATIVE EVIDENCE',
                    'files': [{'path': 'Example.lean', 'sha256': helper.digest((repo / 'Example.lean').read_bytes())}],
                    'records': records}
    write(repo / 'fingerprints.json', fingerprints)
    git('add', '.')
    git('commit', '--quiet', '-m', 'fixture preview lane')
    head = git('rev-parse', 'HEAD')
    tree = git('rev-parse', 'HEAD^{tree}')
    git('commit', '--allow-empty', '--quiet', '-m', 'fixture recorded candidate')
    candidate = git('rev-parse', 'HEAD')
    topology = {'shared_anchor': anchor, 'campaign_head': {'instance_id': 'campaign', 'commit': anchor},
                'instances': [
                  {'id': 'work', 'role': 'formalization', 'head': head, 'ref': 'refs/heads/work', 'allowed_destinations': ['campaign']},
                  {'id': 'inspect', 'role': 'reorganization', 'head': anchor, 'ref': 'refs/heads/inspect', 'allowed_destinations': ['campaign']},
                  {'id': 'campaign', 'role': 'canonical', 'head': anchor, 'ref': 'refs/heads/integration/fixture'}]}
    paths = {k: root / (k + '.json') for k in ('preview', 'topology', 'request', 'status', 'mapping')}
    write(paths['topology'], topology)
    topology_hash = helper.load(paths['topology'])[1]
    request = {'request_id': 'a' * 64, 'task': 'prepare', 'remote_write_policy': 'forbid', 'admission_backend': 'none',
               'topology': {'sha256': topology_hash},
               'inputs': [{'instance_id': 'work', 'ref': 'refs/heads/work', 'commit': head, 'mode': 'merge'},
                          {'instance_id': 'inspect', 'ref': 'refs/heads/inspect', 'commit': anchor, 'mode': 'inspect'}],
               'destination': {'instance_id': 'campaign', 'expected_old_commit': anchor}}
    write(paths['request'], request)
    status = {'schema_version': 1, 'workflow_schema_version': 4, 'request_id': request['request_id'],
              'request_sha256': helper.load(paths['request'])[1], 'current_state': 'CANDIDATE', 'result_kind': 'candidate',
              'candidate': {'scratch_repository': str(repo), 'workspace': str(repo), 'commit': candidate,
                            'tree': tree, 'parents': [head], 'imported': False}}
    write(paths['status'], status)
    assets = [{'asset_id': 'module-example', 'concept_id': 'old-module-key', 'lane_id': 'work',
               'kind': 'module', 'unique': True, 'disposition': 'selected', 'content_sha256': '6' * 64,
               'module': 'Example', 'split_status': 'none'}]
    for index, record in enumerate(records):
        assets.append({'asset_id': f'declaration-{index}', 'concept_id': f'old-name-key-{index}', 'lane_id': 'work',
                       'kind': 'declaration', 'unique': True, 'disposition': 'selected' if index else 'retained-unresolved',
                       'content_sha256': helper.digest(helper.canonical(record)), 'module': 'Example', 'name': record['name'],
                       'module_asset_id': 'module-example', 'type_hash': record['type_sha256'], 'proof_hash': record['value_sha256']})
    preview = {'schema': 1, 'head': head, 'tree': tree, 'anchor': anchor, 'topology_sha256': topology_hash,
               'open_source_rows': [], 'deleted_files': [], 'assets': assets,
               'lane_heads': [{'instance_id': i['id'], 'head': i['head']} for i in topology['instances']],
               'fingerprint_inputs': [{'path': 'fingerprints.json', 'sha256': helper.digest((repo / 'fingerprints.json').read_bytes()),
                                       'normalization': fingerprints['normalization']}],
               'branches': [{'instance_id': 'work', 'ref': 'refs/heads/work', 'unique_assets': [a['asset_id'] for a in assets], 'disposition': 'retain'},
                            {'instance_id': 'inspect', 'ref': 'refs/heads/inspect', 'unique_assets': [], 'disposition': 'retain'}]}
    write(paths['preview'], preview)
    reference = lambda name: {'path': name, 'sha256': helper.digest((repo / name).read_bytes())}
    mapping = {'schema_version': 1, 'input_sha256': {}, 'review_evidence': reference('review.md'),
               'assets': [{'preview_asset_id': 'module-example', 'concept_id': 'module-example'}]}
    for index, record in enumerate(records):
        mapping['assets'].append({'preview_asset_id': f'declaration-{index}', 'concept_id': 'reviewed-associated-concept',
            'declaration_identity': {'module': 'Example', 'declaration': record['name'],
                                    'producer_payload': reference(f'producer{index}.json'), 'policy_payload': reference(f'policy{index}.json')}})
    return paths, mapping


def run(schema_path):
    checks = []
    with tempfile.TemporaryDirectory(prefix='fixture-only-', dir=HERE) as directory:
        root = Path(directory).resolve()
        assert root.is_relative_to(HERE)
        paths, mapping = fixture(root)
        original = {key: path.read_bytes() for key, path in paths.items() if key != 'mapping'}

        def bind():
            mapping['input_sha256'] = {key: helper.load(paths[key])[1] for key in ('preview', 'topology', 'request', 'status')}
            mapping['input_sha256']['epoch_schema'] = helper.load(schema_path)[1]
            write(paths['mapping'], mapping)

        def convert():
            return helper.prepare(paths['preview'], paths['topology'], paths['request'], paths['status'], paths['mapping'], schema_path)

        bind()
        before = {key: path.read_bytes() for key, path in paths.items()}
        result = convert()
        fields = result['epoch_fields']
        assert {x['instance_id'] for x in fields['lane_heads']} == {'work', 'inspect'}
        assert fields['candidate']['commit'] != helper.load(paths['preview'])[0]['head']
        assert len({a['asset_id'] for a in fields['assets']}) == 3
        assert fields['assets'][1]['module_asset_id'] == fields['assets'][0]['asset_id']
        assert fields['assets'][1]['disposition'] == 'retained-unresolved'
        assert fields['assets'][1]['producer'] != fields['assets'][2]['producer']
        assert fields['assets'][1]['concept_id'] == fields['assets'][2]['concept_id']
        assert set(fields) == {'candidate', 'lane_heads', 'assets', 'branches'}
        assert all(path.read_bytes() == before[key] for key, path in paths.items())
        assert result['pending'] and 'collisions' not in fields and 'validations' not in fields
        checks.append('conversion: lane filter, actual candidate, occurrence IDs, remapped links, retained evidence, no invented decisions')

        def refusal(label, key, mutate, expected):
            for name, data in original.items():
                paths[name].write_bytes(data)
            current_mapping = copy.deepcopy(mapping)
            if key == 'mapping':
                mutate(mapping)
            else:
                value = helper.load(paths[key])[0]
                mutate(value)
                write(paths[key], value)
            bind()
            try:
                convert()
            except helper.InputError as error:
                assert expected in str(error), (label, str(error))
            else:
                raise AssertionError('accepted invalid fixture: ' + label)
            mapping.clear()
            mapping.update(current_mapping)
            checks.append('refuses: ' + label)

        refusal('retained checkpoint status', 'status', lambda x: x.update(current_state='QUEUED', result_kind='retained'), 'actual recorded CANDIDATE')
        refusal('open source row', 'preview', lambda x: x.update(open_source_rows=['OPEN']), 'open source rows')
        refusal('deleted file', 'preview', lambda x: x.update(deleted_files=['gone.lean']), 'deleted files')
        refusal('forged candidate tree', 'status', lambda x: x['candidate'].update(tree='0' * 40), 'candidate tree mismatch')
        refusal('unmapped asset', 'mapping', lambda x: x['assets'].pop(), 'cover every preview asset')
        refusal('duplicate mapping', 'mapping', lambda x: x['assets'].append(copy.deepcopy(x['assets'][0])), 'duplicate identity mapping')
        refusal('review evidence mismatch', 'mapping', lambda x: x['review_evidence'].update(sha256='0' * 64), 'candidate evidence hash mismatch')
        refusal('implicit rename', 'mapping', lambda x: x['assets'][1]['declaration_identity'].update(declaration='Wrong.name'), 'identity renames')
        refusal('producer payload swapped', 'mapping', lambda x: x['assets'][1]['declaration_identity'].update(producer_payload=x['assets'][2]['declaration_identity']['producer_payload']), 'producer payload differs')
        refusal('unretained unique asset', 'preview', lambda x: x['branches'][0]['unique_assets'].pop(), 'not completely retained')
        refusal('invented supersession', 'preview', lambda x: x['assets'][1].update(disposition='superseded'), 'separate reviewed conversion')
        refusal('policy overwrite', 'preview', lambda x: x['assets'][1].update(policy_hash='0' * 64), 'overwrite prior identity')
        refusal('producer overwrite', 'preview', lambda x: x['assets'][1].update(producer='0' * 64), 'overwrite prior identity')
        refusal('wrong module owner', 'preview', lambda x: x['assets'][1].update(module_asset_id='declaration-1'), 'different owner')
        refusal('declaration metadata overwrite', 'preview', lambda x: x['assets'][1].update(declaration='Wrong.name'), 'overwrite prior identity')
        for key, data in original.items():
            paths[key].write_bytes(data)
        bind()
        paths['preview'].write_bytes(paths['preview'].read_bytes() + b' ')
        try:
            convert()
        except helper.InputError as error:
            assert 'exact preview bytes' in str(error)
        else:
            raise AssertionError('accepted stale preview hash')
        checks.append('refuses: changed preview bytes')
    print(json.dumps({'scope': 'synthetic fixture only; no production candidate or epoch', 'checks': checks,
                      'count': len(checks), 'released_epoch_schema_sha256': helper.load(schema_path)[1]}, indent=2))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--epoch-schema', type=Path, required=True)
    run(parser.parse_args().epoch_schema.resolve())
