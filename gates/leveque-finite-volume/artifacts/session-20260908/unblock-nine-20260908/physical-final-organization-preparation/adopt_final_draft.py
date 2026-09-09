"""Freeze root's actual review of the current organization draft; no measurement."""
from pathlib import Path
import copy
import hashlib
import json
import os
from datetime import datetime, timezone

assert os.name != 'nt', 'Run through the prepared POSIX launcher'
P = Path(__file__).resolve().parent
R = next(p for p in P.parents if (p / 'lakefile.toml').exists())
D = P / 'draft-final-01'
O = P / 'approved-final-01'
assert not O.exists(), 'Fresh output required'

def sha(raw):
    return hashlib.sha256(raw).hexdigest()

def ref(p):
    return {'path': p.relative_to(R).as_posix(), 'sha256': sha(p.read_bytes())}

def read(r):
    p = R / r['path']
    raw = p.read_bytes()
    assert sha(raw) == r['sha256'], str(p)
    return json.loads(raw)

def write(name, obj):
    p = O / name
    p.write_text(json.dumps(obj, indent=2) + '\n', encoding='utf-8', newline='\n')
    return ref(p)

inputs = read({'path': (D / 'organization-inputs.draft.json').relative_to(R).as_posix(),
               'sha256': '4fe084d54cdd6ddf43aa53d41e6668131aecc7c1826b21d880b3c35aea8bd0b1'})
manifest = json.loads((D / 'draft-manifest.json').read_bytes())
for item in manifest['files'] + manifest['helpers'] + [manifest['config']]:
    assert sha((R / item['path']).read_bytes()) == item['sha256'], item['path']
review = read(inputs['unit_scope_review'])
assert review['status'] == 'root-review-required'
assert len(review['source_files']) == 221
assert len(review['reviewed_changed_source_paths']) == 149
assert all(value == [] for value in review['unit_scope'].values())
for item in review['source_files'] + review['review_evidence']:
    assert sha((R / item['path']).read_bytes()) == item['sha256'], item['path']
lineage = json.loads((P / 'topology-authority-snapshot-01.json').read_bytes())
assert lineage['sha256'] == inputs['topology']['sha256']
snapshot = R / lineage['snapshot_path']
assert sha(snapshot.read_bytes()) == lineage['sha256']
assert lineage['owner'] == inputs['ratchet_owner'] == 'project-owner'
O.mkdir()
note = O / 'ROOT-ADOPTION.md'
note.write_text('''Root adopts the exact current organization review after inspecting the draft, its manifest, all four actual checker descriptors, the current manual contract/placement assessment, and the unchanged measurement implementation. The current source scope comprises 221 files and 149 changed source paths. The proposed six empty finding lists agree with that review; the measurement must independently recompute the measurable lists and repository ratchet.

The four applicability records are adopted for the exact current source, import and policy pins. Layout and hygiene use their actual successful post-parenthesis executions. Native structural equality supplies the explicit applicability link for earlier evidence; it is not a source-faithfulness judgment.

The topology input is changed only to the previously frozen byte-identical local authority snapshot. This keeps the historical measurement review stable when the operational lane head legitimately advances. The portable lineage receipt records the origin. Future reconciliation and candidate epochs must separately bind actual current topology and lane heads. No authority, future commit, audit acceptance, measured success or gate verdict is asserted by this adoption.
''', encoding='utf-8', newline='\n')
mapping = {}
for name, entry in inputs['supporting_executions'].items():
    old = entry['applicability_review']
    item = read(old)
    assert item['status'] == 'root-review-required'
    assert item['receipt_sha256'] == entry['receipt']['sha256']
    assert item['production_source_tree_sha256'] == review['production_source_tree_sha256']
    for evidence in item['review_evidence']:
        assert sha((R / evidence['path']).read_bytes()) == evidence['sha256'], evidence['path']
    item['status'] = 'reviewed-current-inputs'
    item['review_rationale'] = 'Root adopted the exact current applicability under ROOT-ADOPTION.md; the original draft and historical evidence remain preserved.'
    item['review_evidence'] += [ref(note), ref(P / 'topology-authority-snapshot-01.json')]
    new = write(name + '-applicability.json', item)
    mapping[old['path']] = new
    entry['applicability_review'] = new
review['status'] = 'reviewed-for-organization-measurement'
review['review_evidence'] = [mapping.get(item['path'], item) for item in review['review_evidence']]
review['review_evidence'] += [ref(note), ref(P / 'topology-authority-snapshot-01.json'), ref(D / 'draft-manifest.json')]
review['draft_assessment'] = 'Root adopts the preserved current manual assessment and six finding lists for exact-source measurement, as explained in ROOT-ADOPTION.md.'
inputs['unit_scope_review'] = write('unit-scope-review.json', review)
inputs['topology']['path'] = snapshot.as_posix()
inputs['status'] = 'reviewed-for-organization-measurement'
inputs['scope'] = 'Exact current source snapshot, actual checker applicability and historical byte-identical authority; measurement pending.'
final = write('organization-inputs.json', inputs)
receipt = write('adoption-receipt.json', {
    'kind': 'root-current-organization-draft-adoption',
    'recorded_at_utc': datetime.now(timezone.utc).isoformat(),
    'draft_manifest': ref(D / 'draft-manifest.json'),
    'root_review': ref(note), 'inputs': final,
    'measurement_run': False, 'gate_mutated': False,
    'source_tree_sha256': review['production_source_tree_sha256'],
    'topology_lineage': ref(P / 'topology-authority-snapshot-01.json')})
print(json.dumps({'inputs': final, 'receipt': receipt}))
