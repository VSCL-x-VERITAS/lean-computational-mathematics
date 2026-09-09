"""Actual read-only two-lane inventory exercise; writes no previews or runtime."""
import argparse,json
from pathlib import Path
from common import load,digest,canonical
from build_lane_inventory import build

p=argparse.ArgumentParser();p.add_argument('--topology',type=Path,required=True);a=p.parse_args()
fingerprints=['gates/leveque-finite-volume/artifacts/session-20260908/baseline-equation03-expression-fingerprints.json',
              'gates/leveque-finite-volume/artifacts/session-20260908/chapter01-current-expression-fingerprints-24b3.json']
topology,h=load(a.topology);results=[];inventories=[]
for lane in [i['id'] for i in topology['instances'] if i['role'] in ('formalization','reorganization')]:
    v=build(a.topology,lane,fingerprints,False);inventories.append(v)
    assert v['changed_file_count']==len(v['file_coverage'])==len(v['changed_blobs'])
    assert len(v['branch']['unique_assets'])==sum(x['unique'] for x in v['assets'])
    results.append({'lane_id':lane,'head':v['head'],'tree':v['tree'],'anchor':v['anchor'],
        'inventory_canonical_sha256':digest(canonical(v)),'assets':len(v['assets']),
        'changed_file_count':v['changed_file_count'],'open_rows':v['open_source_rows'],
        'unique_assets_retained':len(v['branch']['unique_assets']),'fingerprint_inputs':v['fingerprint_inputs'],
        'required_baseline_producer_transports':v['required_baseline_producer_transports']})
ids=[{x['asset_id'] for x in v['assets']} for v in inventories]
assert not ids[0]&ids[1]
equal_heads=inventories[0]['head']==inventories[1]['head']
if equal_heads:
    assert [(x['path'],x['sha256']) for x in inventories[0]['changed_blobs']]==[(x['path'],x['sha256']) for x in inventories[1]['changed_blobs']]
    assert [x['content_sha256'] for x in inventories[0]['assets']]==[x['content_sha256'] for x in inventories[1]['assets']]
assert load(a.topology)[1]==h
print(json.dumps({'scope':'Actual read-only Git-object inventories, no final preview/candidate/epoch',
    'topology_sha256':h,'lanes':results,'disjoint_origin_ids':True,'equal_heads_compared_bytewise':equal_heads,
    'closed_merge_not_claimed':True},indent=2))
