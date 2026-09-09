"""Assemble a fresh organization config from explicit current root-reviewed inputs.

This performs file/schema checks only. No Git, native build, organization capture,
draft, validator, gate operation, or source judgment is executed.
"""
from pathlib import Path
import argparse, hashlib, importlib.util, json, os, sys
sys.dont_write_bytecode=True
P=Path(__file__).resolve().parent;D=P.parent
R=next(p for p in P.parents if (p/'lean-toolchain').is_file())
exec(compile((D/'fv-local-domain-review/native-long-path-io.py').read_bytes(),'native-long-path-io.py','exec'),globals())
observed={}
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def pin(p):
    digest=sha(p)
    if p in observed:assert observed[p]==digest,str(p)
    observed[p]=digest
    return {'path':p.relative_to(R).as_posix(),'sha256':digest}
def bound(item):
    assert isinstance(item,dict) and set(item)=={'path','sha256'}
    rel=item['path'];assert isinstance(rel,str) and rel and '\\' not in rel and ':' not in rel
    assert all(x not in ('','.','..') for x in rel.split('/'))
    p=R/rel;assert p.resolve().is_relative_to(R) and not p.is_symlink()
    assert pin(p)==item,item['path'];return p
def read(item):return json.loads(bound(item).read_bytes())
def dump(p,obj):
    with p.open('x',encoding='utf-8',newline='\n') as f:json.dump(obj,f,indent=2);f.write('\n')
def execution(item):
    rec=read(item['receipt']);raw=bound(item['output']).read_bytes()
    assert type(rec['exit_code']) is int and rec['exit_code']==0
    assert rec['input_commit']=='5e3f63594aa964263469ada134aee2809559d50d'
    assert rec['output_sha256']==hashlib.sha256(raw).hexdigest()
    assert rec['command']==item['expected_command']
    assert isinstance(rec['elapsed_ms'],int) and rec['elapsed_ms']>=0
    for evidence in item['evidence']:bound(evidence)
    return rec

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--ready-inputs',type=Path,required=True)
    parser.add_argument('--ready-sha256',required=True)
    parser.add_argument('--out',required=True)
    a=parser.parse_args()
    assert '/' not in a.out and '\\' not in a.out and a.out.startswith('assembled-')
    O=P/a.out;assert not O.exists()
    assert sha(a.ready_inputs)==a.ready_sha256
    ready=json.loads(a.ready_inputs.read_bytes());pin(a.ready_inputs)
    assert set(ready)=={'schema','status','scope','scope_receipt','all_production_sources','manual_review',
        'root_adoption','topology','gate','graph','graph_execution','fingerprints',
        'complete_declaration_manifest','complete_native','checker_executions','placement_reviews'}
    assert ready['schema']==1 and ready['status']=='ROOT_RELEASED_CURRENT_ORGANIZATION_INPUTS'
    scope=read(ready['scope']);scope_receipt=read(ready['scope_receipt'])
    all_sources=read(ready['all_production_sources']);manual=read(ready['manual_review'])
    bound(ready['root_adoption'])
    assert scope['status']=='prepared-source-scope-not-organization-review'
    assert scope['input_commit']==scope_receipt['input_commit']=='5e3f63594aa964263469ada134aee2809559d50d'
    assert scope['anchor']==scope_receipt['anchor']=='9e2225705fed906b1120d55105d607baabef57c9'
    assert scope['source_tree_sha256']==scope_receipt['source_tree_sha256']==all_sources['source']['source_tree_sha256']
    assert all(x['exit_code']==0 for x in scope_receipt['commands'])
    for item in all_sources['files']:bound(item)
    for item in scope['source_files']:bound(item)
    # Every current production source is pinned; the ordinary capture will
    # independently rescan census/HEAD/import closure before emitting outputs.
    paths={x['path'] for x in scope['source_files']}
    assert len(paths)==len(scope['source_files']) and 'ComputationalMathematics/Analysis.lean' in paths
    assert set(scope['reviewed_changed_source_paths'])<=paths
    assert manual['status']=='root-reviewed-current-organization-scope'
    assert manual['source_tree_sha256']==scope['source_tree_sha256']
    assert manual['source_files']==scope['source_files']
    assert manual['reviewed_changed_source_paths']==scope['reviewed_changed_source_paths']
    assert manual['scope_assessment']['rationale'].strip()
    for item in manual['review_evidence']:bound(item)
    assert manual['review_evidence']
    template=json.loads((D/'final-organization-actual/organization-template.json').read_bytes())
    pin(D/'final-organization-actual/organization-template.json')
    template['tools']={k:pin(R/v['path']) for k,v in template['tools'].items()}
    top=read(ready['topology']);gate=read(ready['gate'])
    assert top['shared_anchor']==scope['anchor']
    campaign=next(x for x in top['campaigns'] if x['id']==template['campaign_id'])
    assert campaign['owner']
    graph=read(ready['graph']['json']);bound(ready['graph']['markdown'])
    assert graph['source']['source_tree_sha256']==scope['source_tree_sha256']
    graph_execution=execution(ready['graph_execution'])
    assert bound(ready['graph_execution']['output']).stat().st_size>0
    owners={};records={}
    for entry in ready['fingerprints']:
        fp=read(entry['inventory'])
        assert len(fp['files'])==entry['expected_files'] and len(fp['records'])==entry['expected_records']
        for item in fp['files']:
            bound({'path':item['path'],'sha256':item['sha256']})
            assert item['path'] in paths
            if item['path'] in owners:assert owners[item['path']]==item['sha256']
            owners[item['path']]=item['sha256']
        for record in fp['records']:
            if record['name'] in records:assert records[record['name']]==record,'conflicting current native records'
            records[record['name']]=record
        for item in entry['provenance']:bound(item)
    historical=json.loads((D/'final-organization-actual/config.json').read_bytes())
    old_owners=set()
    for entry in historical['fingerprints']:
        for item in read(entry['inventory'])['files']:old_owners.add(item['path'])
    assert old_owners<=set(owners),'Current inventory omits retained historical producer owners'
    assert set(scope['additional_owner_seeds'])<=set(owners),'Current inventory omits new producer owners'
    native_manifest=read(ready['complete_declaration_manifest'])
    for item in native_manifest['files']:bound({'path':item['path'],'sha256':item['sha256']})
    execution(ready['complete_native'])
    for entry in ready['checker_executions'].values():execution(entry)
    for item in ready['placement_reviews']:bound(item['evidence'])
    covered={p for item in ready['placement_reviews'] for p in item['covered_source_paths']}
    assert set(scope['reviewed_changed_source_paths'])<=covered
    formal=[x for x in gate['rows'] if x['status']!='SKIPPED']
    assert set(native_manifest['rows'])=={x['id'] for x in formal}
    common_evidence=[pin(a.ready_inputs),ready['scope'],ready['scope_receipt'],ready['all_production_sources'],
        ready['manual_review'],ready['root_adoption'],ready['graph_execution']['receipt'],ready['graph_execution']['output']]
    for entry in [ready['complete_native'],*ready['checker_executions'].values()]:
        refs=entry['evidence']+common_evidence
        unique={item['path']:item for item in refs}
        assert all(unique[item['path']]==item for item in refs),'conflicting evidence pins'
        entry['evidence']=list(unique.values())
    config={'schema':1,'kind':'current-organization-draft-config','pending_inputs':[],
        'expected_head':scope['input_commit'],'anchor':scope['anchor'],'source_tree_sha256':scope['source_tree_sha256'],
        'campaign_id':template['campaign_id'],'topology':ready['topology'],'gate':ready['gate'],
        'organization_template':{'path':(O/'organization-template.json').relative_to(R).as_posix(),
          'sha256':hashlib.sha256((json.dumps(template,indent=2)+'\n').encode()).hexdigest()},
        'graph':ready['graph'],'expected_counts':{'production_modules':all_sources['source']['module_count'],
          'native_constants':len(records),'native_owners':len(owners),'total_rows':len(gate['rows']),
          'formalizable_rows':len(formal),'skipped_rows':len(gate['rows'])-len(formal)},
        'fingerprints':ready['fingerprints'],'complete_declaration_manifest':ready['complete_declaration_manifest'],
        'complete_native':ready['complete_native'],'checker_executions':ready['checker_executions'],
        'placement_reviews':ready['placement_reviews'],'scope_assessment':manual['scope_assessment'],
        'aggregate_boundaries':['ComputationalMathematics/Analysis.lean']}
    support=D/'final-organization-successor-preparation/support.py'
    assert sha(support)=='ef3359be959f168b95c50db3e7440887d3fe8fcbbcb85b9e503383de176d621d'
    spec=importlib.util.spec_from_file_location('physical_org_schema',support)
    module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module)
    module.schema(config)  # Pure shape check; no capture/measurement invocation.
    for p,digest in observed.items():assert sha(p)==digest,('input changed',str(p))
    O.mkdir();dump(O/'organization-template.json',template)
    assert pin(O/'organization-template.json')==config['organization_template']
    dump(O/'config.json',config)
    dump(O/'receipt.json',{'format':'current-organization-config-assembly-1','config':pin(O/'config.json'),
        'ready_inputs':pin(a.ready_inputs),'observed_files':[{'path':p.relative_to(R).as_posix(),'sha256':h} for p,h in observed.items()],
        'derived_counts':config['expected_counts'],'actual_source_scope':ready['scope'],
        'capture_runs':0,'draft_runs':0,'organization_measurement_runs':0,'gate_mutations':0,'source_acceptance':False})
    print(json.dumps({'config':pin(O/'config.json'),'receipt':pin(O/'receipt.json')}))

if __name__=='__main__':main()
