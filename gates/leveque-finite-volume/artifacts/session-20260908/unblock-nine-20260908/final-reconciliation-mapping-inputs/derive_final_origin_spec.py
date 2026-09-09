"""Prepare a fresh catalogue INPUT from actual committed origin captures.

Pure file checks; no Git, candidate, request, audit, authority, or gate operation.
The output is a root-review-required proposal. The unchanged catalogue and emitter
still require exact final inventories and a separately authored real review.
"""
import argparse, hashlib, importlib.util, json
from pathlib import Path

def sha(b): return hashlib.sha256(b).hexdigest()
def need(x,m):
    if not x: raise ValueError(m)
def main():
    p=argparse.ArgumentParser(); p.add_argument('--root',type=Path,required=True)
    p.add_argument('--inputs',type=Path,required=True); p.add_argument('--inputs-sha256',required=True)
    p.add_argument('--output',type=Path,required=True); a=p.parse_args()
    root=a.root.resolve(); raw=a.inputs.read_bytes(); need(sha(raw)==a.inputs_sha256,'input hash')
    x=json.loads(raw); need(x['schema']==1 and x['kind']=='explicit-final-origin-spec-input','input kind')
    seen={}
    def bound(r):
        need(isinstance(r,dict) and set(r)=={'path','sha256'},'missing exact file reference')
        q=(root/r['path']).resolve(); need(q.is_relative_to(root) and q.is_file() and not q.is_symlink(),'input path')
        b=q.read_bytes(); need(sha(b)==r['sha256'],'stale '+r['path']); seen[q]=b; return json.loads(b)
    policy=bound(x['preparation_policy']); need(policy['kind']=='reconciliation-mapping-preparation-policy','policy kind')
    topology=bound(x['topology']); lanes={i['id']:i for i in topology['instances']}
    need(topology['shared_anchor']==policy['anchor'],'anchor drift')
    need(set(x['origins'])==set(policy['origin_fingerprint_paths']),'exact two lanes')
    catalogue_lanes=[]; groups={}; final_head=None
    for lane,entry in x['origins'].items():
        inv=bound(entry['inventory']); ctx=bound(entry['context'])
        need(inv['artifact_kind']=='lane-asset-inventory' and inv['schema']==2,'actual inventory required')
        need(inv['lane_id']==ctx['lane_id']==lane and inv['head']==ctx['origin_head']==lanes[lane]['head'],'origin mismatch')
        need(ctx['inventory_sha256']==entry['inventory']['sha256'] and inv['topology_sha256']==x['topology']['sha256'],'capture mismatch')
        paths=policy['origin_fingerprint_paths'][lane]
        refs=[{k:v[k] for k in ('path','sha256')} for v in inv['fingerprint_inputs']]
        need([r['path'] for r in refs]==paths,'exact ordered lane fingerprint paths')
        expected_refs=policy['current_work_fingerprint_refs'] if lane==policy['merge_lane'] else bound(policy['baseline_spec'])['lanes'][1]['fingerprints']
        need(refs==expected_refs,'explicit pinned origin fingerprint bytes')
        for r in refs: bound(r)
        if lane==policy['merge_lane']:
            need(inv['require_closed'] is True and inv['open_source_rows']==[],'merge is not closed')
            need(sum(r.get('origin_status') in ('PROVED','REUSED') for r in ctx['rows'])==41,'41 accepted rows required')
            targets=bound(x['complete_declaration_manifest'])
            need({r['row']:r['declarations'] for r in ctx['rows'] if r.get('origin_status') in ('PROVED','REUSED')}==
                 {k:[v['declaration']] for k,v in targets['rows'].items()},'exact compiled 41-target selection')
            final_head=inv['head']
        else: need(inv['head']==policy['inspection_head'],'inspection origin changed; explicit successor review required')
        catalogue_lanes.append({'lane_id':lane,'inventory':entry['inventory'],'context':entry['context'],'fingerprints':refs})
        for v in inv['assets']:
            if v['kind']=='declaration': continue
            key={'gate':v.get('path'),'source-row':v.get('row'),'module':v.get('module'),
                 'audit':v.get('task_id'),'proof':'retained-session-and-organization-evidence'}[v['kind']]
            need(isinstance(key,str) and key,'asset stable key'); groups.setdefault((v['kind'],key),[]).append(v)
    # The spelling is an explicit proposal, never a declaration of equivalence.
    # Separate only non-declaration variants; unchanged payloads keep common IDs.
    variants=[]
    for (kind,key),items in sorted(groups.items()):
        if len({v['content_sha256'] for v in items})<2: continue
        base=kind+'-'+sha(json.dumps(key,sort_keys=True,separators=(',',':'),ensure_ascii=True).encode())[:32]
        for v in items: variants.append({'lane_id':v['lane_id'],'kind':kind,'stable_key':key,'concept_id':base+'-origin-'+v['lane_id']})
    baseline=bound(policy['baseline_spec']); overrides=baseline['declaration_overrides']
    for v in overrides:
        bound(v['producer_payload']); bound(v['policy_payload'])
    spec={'schema':1,'stage':'final-origin-review-draft','final_committed_head':final_head,
          'merge_lane':policy['merge_lane'],'lanes':catalogue_lanes,'declaration_overrides':overrides,
          'provenance_concept_overrides':variants,
          'preparation_only':{'source_acceptance':False,'review_required':True,'input_ref':{'path':a.inputs.resolve().relative_to(root).as_posix(),'sha256':a.inputs_sha256},
                              'basis':'Exact origin captures plus separate non-declaration content variants; no change to declaration identities or selected source judgments.'}}
    for q,b in seen.items(): need(q.read_bytes()==b,'input changed')
    need(a.inputs.read_bytes()==raw,'input changed'); need(not a.output.exists(),'fresh output required')
    with a.output.open('xb') as f: f.write((json.dumps(spec,indent=2,ensure_ascii=True)+'\n').encode())
    print(json.dumps({'status':'ROOT_REVIEW_REQUIRED','output_sha256':sha(a.output.read_bytes()),'nondeclaration_variant_occurrences':len(variants),'final_origin_head':final_head,'source_acceptance':False}))
if __name__=='__main__': main()
