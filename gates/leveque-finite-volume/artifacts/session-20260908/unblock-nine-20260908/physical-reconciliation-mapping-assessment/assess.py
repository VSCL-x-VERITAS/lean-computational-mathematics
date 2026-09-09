"""Read-only worktree mapping analysis; never a lane inventory or authority.

Run through the existing POSIX launcher. Writes one fresh analysis directory.
The caller pins actual config and gate bytes; pending source rows stay pending.
"""
import argparse, collections, hashlib, json, re
from pathlib import Path

def digest(b): return hashlib.sha256(b).hexdigest()
def canonical(x): return json.dumps(x,sort_keys=True,separators=(',',':'),ensure_ascii=True).encode()
def require(x,m):
    if not x: raise ValueError(m)
def main():
    p=argparse.ArgumentParser(); p.add_argument('--root',type=Path,required=True)
    p.add_argument('--config',type=Path,required=True); p.add_argument('--config-sha256',required=True)
    p.add_argument('--gate-sha256',required=True); p.add_argument('--output',type=Path,required=True); a=p.parse_args()
    root=a.root.resolve(); here=Path(__file__).resolve().parent; d=here.parent; s=d.parent
    require(not a.output.exists(),'output exists'); pins={}
    def read(path):
        path=path.resolve(); require(path.is_relative_to(root),'input outside repository')
        b=path.read_bytes(); pins[path.relative_to(root).as_posix()]=digest(b); return json.loads(b)
    def ref(path):
        path=path.resolve(); return {'path':path.relative_to(root).as_posix(),'sha256':digest(path.read_bytes())}
    def bound(r):
        q=root/r['path']; require(digest(q.read_bytes())==r['sha256'],'stale input: '+r['path']); return read(q)
    require(digest(a.config.read_bytes())==a.config_sha256,'config hash'); config=read(a.config)
    gatepath=root/'gates/leveque-finite-volume/chapter-01.json'
    require(digest(gatepath.read_bytes())==a.gate_sha256,'gate hash'); gate=read(gatepath)
    topology=bound(config['topology']); policy=bound(config['preparation_policy'])
    require([e['inventory'] for e in config['fingerprints']]==policy['current_work_fingerprint_refs'],'policy exact current refs')
    records={}; owners={}; fps=[]; origins={}
    for entry in config['fingerprints']:
        f=bound(entry['inventory']); require(len(f['records'])==entry['expected_records'],'record count')
        fps.append({'inventory':entry['inventory'],'records':len(f['records']),'owners':len(f['files']),
                    'native_provenance':{k:f[k] for k in ['input_manifest','native_receipt','native_output','native_raw_archive'] if k in f}})
        for v in f['files']:
            require(digest((root/v['path']).read_bytes())==v['sha256'],'owner drift '+v['path'])
            require(v['path'] not in owners or owners[v['path']]==v['sha256'],'owner conflict'); owners[v['path']]=v['sha256']
        for v in f['records']:
            require(v['name'] not in records or records[v['name']]==v,'unequal overlap'); records[v['name']]=v
            origins.setdefault(v['name'],[]).append(entry['inventory'])
    require((len(records),len(owners),len(fps))==(config['expected_records'],config['expected_owners'],len(policy['current_work_fingerprint_refs'])),'explicit current census')
    base=read(d/'reconciliation-concept-mapping/baseline-catalogue.json')
    bi=read(d/'reconciliation-concept-mapping/reorganization-baseline-inspection/inventory.json')
    bc=read(d/'reconciliation-concept-mapping/reorganization-baseline-inspection/origin-context-v3.json')
    bs=read(d/'reconciliation-concept-mapping/baseline-spec.json')
    old={v['declaration']:v for v in base['assets'] if v['kind']=='declaration' and v['lane_id']=='reorganization-baseline-inspection'}
    oldrows={v['row']:v for v in bc['rows']}; override={v['declaration']:v for v in bs['declaration_overrides']}
    selected={}; rowdata=[]; openrows=[]
    for row in gate['rows']:
        result={'row':row['id'],'status':row['status'],'declarations':row.get('lean_declarations',[]),
                'row_sha256':digest(canonical(row)),'old_context':oldrows[row['id']]}
        if row['status'] in ('PROVED','REUSED'):
            task=read(root/row['faithfulness_task']); contractpath=root/'gates/leveque-finite-volume'/row['source_contract_artifact']
            require(digest(contractpath.read_bytes())==row['source_contract_sha256'],'contract ref')
            contract=read(contractpath)['payload']['contract']
            require(digest(json.dumps(contract,sort_keys=True,separators=(',',':'),ensure_ascii=False).encode())==row['contract_hash'],'gate contract digest')
            context={'row':row['id'],'source':task['source'],'contract':contract}
            result.update(current_context=context,contract_ref=ref(contractpath),task_ref=ref(root/row['faithfulness_task']),
                          decision_ref=ref(root/row['faithfulness_decision']),classification=row['classification'])
            result['same_old_selected_contract']=oldrows[row['id']].get('contract')==contract and oldrows[row['id']].get('source')==task['source']
            for n in row['lean_declarations']: selected.setdefault(n,[]).append(context)
        elif row['status']!='SKIPPED': openrows.append(row['id'])
        rowdata.append(result)
    future=bound(config['complete_declaration_manifest'])
    future_names=set(future['declarations']); require(len(future_names)==41 and future_names<=set(records),'current target inventory')
    assessment=[]; newpolicies=[]
    for n,r in sorted(records.items()):
        producer={'format':'canonical-producer-identity-v1','module':r['module'],'declaration':n,'kind':r['kind'],
                  'type_sha256':r['type_sha256'],'level_params_sha256':r['level_params_sha256']}
        policy={'format':'exact-declaration-policy-domain-proposal-v1','module':r['module'],'declaration':n,'kind':r['kind'],
                'type_sha256':r['type_sha256'],'level_params_sha256':r['level_params_sha256'],
                'meaning':'Preserve exactly this native Lean signature and the explicit selected source contracts below; impose no unrecorded simplification of parameters, regularity, representation or conclusion strength.',
                'selected_source_contracts':selected.get(n,[]),'extra_source_claim':None}
        concept='declaration-'+digest(canonical(n))[:32]
        if n in override:
            ov=override[n]; require(bound(ov['producer_payload'])==producer,'old producer override changed')
            policy=bound(ov['policy_payload']); concept=ov['concept_id']
        pending=n in future_names and n not in selected
        pd=digest(canonical(producer)); qd=None if pending else digest(canonical(policy))
        v={'declaration':n,'module':r['module'],'owner_sha256':owners[r['module'].replace('.','/')+'.lean'],
           'concept_id':concept,'type_sha256':r['type_sha256'],'proof_sha256':r['value_sha256'],
           'producer_sha256':pd,'policy_sha256':qd,'selected_rows':[x['row'] for x in selected.get(n,[])],
           'prospective_primary':n in future_names,'pending_final_policy':pending,'native_inputs':origins[n]}
        if n in old:
            ov=old[n]; changes={k:ov[ok]!=nv for k,ok,nv in [('producer','producer_payload_id',pd),('policy','policy_payload_id',qd),('proof','proof_sha256',r['value_sha256'])]}
            if pending: changes['policy']=None
            v.update(origin='retained-existing-declaration',old_producer_sha256=ov['producer_payload_id'],old_policy_sha256=ov['policy_payload_id'],changes=changes,
                     required_review='explicit policy/full-reaudit transport' if changes['policy'] else 'exact producer/proof/policy retention' if not any(changes.values()) else 'explicit changed controlled hashes review')
        else: v.update(origin='new-declaration',required_review='new producer: explicit source selection where present; no cross-name replacement inferred')
        assessment.append(v)
        if qd is not None and (n not in old or old[n]['policy_payload_id']!=qd): newpolicies.append({'declaration':n,'producer':producer,'policy':policy})
    require(set(old)<=set(records),'lost old native declaration')
    manual=bound(config['manual_review'])
    head=manual['input_commit']; require(head==config['expected_head'],'manual recorded HEAD')
    require(manual['anchor']==config['anchor'],'manual anchor')
    paths=manual['reviewed_changed_source_paths']; require(len(paths)==config['expected_changed_paths'],'manual changed scope')
    require(len(manual['source_files'])==config['expected_semantic_paths'],'manual semantic scope')
    for item in manual['source_files']:
        require(digest((root/item['path']).read_bytes())==item['sha256'],'manual source drift '+item['path'])
    staged=None
    protected={}
    for item in bs['lanes'][1]['fingerprints']:
        for r in bound(item)['records']:
            require(r['name'] not in protected,'duplicate inspection record')
            protected[r['name']]=r
    require(set(protected)==set(old),'inspection catalogue/record names')
    protected_differences=[{'name':n,'fields':[k for k in sorted(set(v)|set(records[n])) if v.get(k)!=records[n].get(k)]}
                          for n,v in sorted(protected.items()) if n not in records or v!=records[n]]
    require(not protected_differences,'protected inspection record changed')
    variants=[]
    for v in bi['assets']:
        payload=None
        if v['kind']=='gate': payload=gate
        elif v['kind']=='source-row': payload=next(r for r in gate['rows'] if r['id']==v['row'])
        elif v['kind']=='module':
            q=root/v['path']; payload={'module':v['module'],'path':v['path'],'source_sha256':digest(q.read_bytes()),'imports':re.findall(r'^import\s+(\S+)',q.read_text(encoding='utf-8'),re.M)}
        if payload is not None and digest(canonical(payload))!=v['content_sha256']:
            key=v.get('row',v.get('module',v.get('path')))
            variants.append({'kind':v['kind'],'stable_key':key,'old_content_sha256':v['content_sha256'],'current_observed_content_sha256':digest(canonical(payload)),
                'proposal':'Retain separate lane-qualified provenance concept IDs; do not call differing non-declaration payloads identical.'})
    summary={'artifact_kind':'uncommitted-mapping-analysis-not-lane-inventory','source_acceptance':False,'candidate':None,
             'observed_head':head,'anchor':config['anchor'],'topology':config['topology'],'current_gate':ref(gatepath),
             'status_counts':dict(collections.Counter(r['status'] for r in gate['rows'])),'open_rows':openrows,
             'native_records':len(records),'native_owners':len(owners),'native_inventories':len(fps),'retained_baseline_records':len(old),
             'new_records':len(set(records)-set(old)),'source_wrapper_records':sum('.Source.LeVeque.' in r['module'] for r in records.values()),
             'changed_lean_paths_from_anchor':len(paths),'semantic_review_paths':len(manual['source_files']),
             'scope_provenance':config['manual_review'],'scope_collection':'Frozen manual review; no new Git invocation',
             'all_protected_records_byte_equal_as_json_values':not protected_differences,'current_staged_lean_paths':None,
             'provisional_final_module_assets':len(set(owners)|set(paths)),
             'changed_existing_controlled_payloads':[v for v in assessment if v['origin']=='retained-existing-declaration' and any(x is True for x in v['changes'].values())],
             'pending_final_commit':None,'pending_candidate':None,'limits':['No live audit judgments were read. Existing accepted gate rows are observed, not independently recertified.',
             'Audit/proof asset member sets and unique-obligation counts require the real final committed inventory; no future counts fabricated.',
             'All prospective targets have native records; the two pending policies are intentionally null.']}
    for p,h in pins.items(): require(digest((root/p).read_bytes())==h,'input changed during read '+p)
    for p,h in owners.items(): require(digest((root/p).read_bytes())==h,'owner changed during read '+p)
    require(bound(config['manual_review'])==manual,'manual changed')
    a.output.mkdir()
    outputs={'summary.json':summary,'fingerprint-inputs.json':fps,'declaration-assessment.json':assessment,
             'source-row-assessment.json':[{k:v for k,v in row.items() if k not in ('old_context','current_context')} for row in rowdata],
             'nondeclaration-variants.json':variants,
             'current-source-scope.json':{'source_files':[ref(root/p) for p in paths],'staged_lean_paths':staged,'fingerprinted_owners':[{'path':p,'sha256':h} for p,h in sorted(owners.items())]},
             'input-pins.json':[{'path':p,'sha256':h} for p,h in sorted(pins.items())]}
    for n,v in outputs.items(): (a.output/n).write_bytes((json.dumps(v,indent=2,ensure_ascii=True)+'\n').encode())
    print(json.dumps(summary,indent=2))
if __name__=='__main__': main()
