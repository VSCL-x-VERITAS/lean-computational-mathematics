"""Read-only actual ref/delta/fingerprint discovery. Does not create a preview."""
import argparse,json
from pathlib import Path
from common import GitObjects,BlobBatch,load,decode_json,digest,checked_lanes

def main():
    p=argparse.ArgumentParser();p.add_argument('--topology',type=Path,required=True);a=p.parse_args()
    topology,h=load(a.topology);_,lanes=checked_lanes(topology)
    result={'topology_sha256':h,'anchor':topology['shared_anchor'],'lanes':[]}
    for ident,lane in lanes.items():
        g=GitObjects(lane['repository']);head=lane['head'];entries=g.tree(head);base=g.tree(topology['shared_anchor'])
        delta=[{'path':k,'old_oid':base.get(k,{}).get('oid'),'new_oid':entries.get(k,{}).get('oid')} for k in sorted(set(entries)|set(base)) if entries.get(k)!=base.get(k)]
        batch=BlobBatch(g)
        try:
            def blob(path):return batch.get(entries[path]['oid'],True)
            gate=decode_json(blob('gates/leveque-finite-volume/chapter-01.json'))
            needed={n for r in gate['rows'] if r['status'] in ('PROVED','REUSED') for n in r.get('lean_declarations',[])}
            candidates=[]
            for path in sorted(entries):
                if not path.endswith('.json') or 'expression-fingerprints' not in path:continue
                try:
                    value=decode_json(blob(path))
                    if not {'files','records','normalization'}<=set(value):continue
                    valid=all(src['path'] in entries and batch.get(entries[src['path']]['oid'])==src['sha256'] for src in value['files'])
                    if not valid:continue
                    names={r['name'] for r in value['records']}
                    candidates.append({'path':path,'sha256':digest(blob(path)),'records':len(names),'selected_coverage':sorted(needed&names),
                                       'normalization':value['normalization']})
                except (ValueError,KeyError,TypeError):continue
            covered={n for item in candidates for n in item['selected_coverage']}
            result['lanes'].append({'lane_id':ident,'ref':lane['ref'],'head':head,'tree':g.text('rev-parse',head+'^{tree}'),
                'delta_count':len(delta),'delta_sha256':digest(json.dumps(delta,sort_keys=True,separators=(',',':')).encode()),
                'deleted_files':[x['path'] for x in delta if x['new_oid'] is None],
                'gate_sha256':digest(blob('gates/leveque-finite-volume/chapter-01.json')),
                'closed_row_count':sum(r['status'] in ('PROVED','REUSED') for r in gate['rows']),
                'open_rows':[r['id'] for r in gate['rows'] if r['status'] not in ('PROVED','REUSED','SKIPPED')],
                'native_fingerprint_candidates':candidates,'selected_declarations_missing_from_candidates':sorted(needed-covered)})
        finally:batch.close()
    checked_lanes(topology)
    assert load(a.topology)[1]==h
    print(json.dumps(result,indent=2))
if __name__=='__main__':main()
