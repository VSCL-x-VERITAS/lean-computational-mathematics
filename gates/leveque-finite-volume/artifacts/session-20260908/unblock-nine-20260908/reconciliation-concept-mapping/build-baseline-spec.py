"""Explicit baseline spec and prospective current source-owner observation only."""
from pathlib import Path
import json
import re
import prepare_mapping_catalogue as p

HERE = Path(__file__).resolve().parent
D = HERE.parent
R = D.parents[4]
S = D.parent


def main():
    spec = {'schema': 1, 'stage': 'baseline-draft', 'final_committed_head': None,
            'merge_lane': 'leveque-ch01-work', 'lanes': [], 'declaration_overrides': []}
    for lane in ('leveque-ch01-work', 'reorganization-baseline-inspection'):
        inv = HERE/lane/'inventory.json'
        data = p.read(inv)
        spec['lanes'].append({'lane_id': lane, 'inventory': p.reference(R, inv),
            'context': p.reference(R, HERE/lane/'origin-context-v3.json'),
            'fingerprints': [{k: item[k] for k in ('path', 'sha256')} for item in data['fingerprint_inputs']]})
    for side in ('old', 'new'):
        producer = S/'baseline-equation03-transport-draft'/(side + '-producer-identity.json')
        spec['declaration_overrides'].append({'declaration': p.read(producer)['declaration'],
            'concept_id': 'declaration-leveque-ch01-equation03-interpreted-producer',
            'producer_payload': p.reference(R, producer),
            'policy_payload': p.reference(R, S/'baseline-equation03-transport-draft'/(side + '-policy-domain.json'))})
    p.create(HERE/'baseline-spec.json', spec)
    manifest = D/'complete-declaration-manifest.json'
    value = p.read(manifest)
    rows = []
    file_pins = {item['path']: item['sha256'] for item in value['files']}
    for row, target in value['rows'].items():
        path = R/target['path']
        raw = path.read_bytes()
        p.require(p.sha(raw) == file_pins[target['path']], 'prospective owner changed; request fresh manifest: ' + row)
        rows.append({'row': row, 'target': target, 'owner': p.reference(R, path),
                     'imports': re.findall(r'^import\s+(\S+)', raw.decode().replace('\r\n', '\n'), re.M),
                     'meaning': 'Prospective current primary wrapper association; no source-acceptance or final-head assertion.'})
    p.create(HERE/'prospective-current-source-associations.json', {'schema': 1,
        'input_manifest': p.reference(R, manifest), 'rows': rows, 'final_committed_head': None,
        'source_acceptance': False,
        'pending': 'Root is independently correcting DIM and will supply the final source/fingerprint inventory; this observed list must not be used as a final source certificate.'})
    print(json.dumps({'spec': p.reference(R, HERE/'baseline-spec.json'),
                      'current_source_observation': p.reference(R, HERE/'prospective-current-source-associations.json')}))


if __name__ == '__main__':
    main()
