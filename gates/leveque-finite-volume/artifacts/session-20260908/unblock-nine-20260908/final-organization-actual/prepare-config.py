"""Assemble exact inputs after root releases actual sorted receipts and review.

No Git, native compiler, organization measurement or gate mutation is invoked.
The unchanged released-reviewed capture/draft helpers do the later source scan.
"""
from pathlib import Path
import argparse
import hashlib
import importlib.util
import json
import sys

sys.dont_write_bytecode = True
P=Path(__file__).resolve().parent
R=P.parents[5]
D=P.parent
S=D.parent
H=D/'final-organization-successor-preparation'
sha=lambda b:hashlib.sha256(b).hexdigest()
observed={}

def pin(p):
    raw=p.read_bytes(); observed[p]=sha(raw)
    return {'path':p.relative_to(R).as_posix(),'sha256':sha(raw)}

def read(p):
    pin(p); return json.loads(p.read_bytes())

def bound(ref):
    assert set(ref)=={'path','sha256'}
    p=R/ref['path']
    assert p.resolve().is_relative_to(R) and not p.is_symlink()
    assert pin(p)==ref
    return p

def put(name,value):
    with (P/name).open('x',encoding='utf-8',newline='\n') as f:
        f.write(json.dumps(value,indent=2,ensure_ascii=True)+'\n')

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--ready-inputs',type=Path,required=True)
    parser.add_argument('--ready-sha256',required=True)
    args=parser.parse_args()
    raw=args.ready_inputs.read_bytes(); assert sha(raw)==args.ready_sha256
    ready=json.loads(raw)
    assert ready['status']=='ACTUAL_INPUTS_ROOT_RELEASED_FOR_CAPTURE_DRAFT'
    assert ready['root_release_text'].strip() and ready['manual_review_accepted'] is True
    for key in ('layout_receipt','layout_output','graph_json','graph_markdown','graph_receipt','graph_output',
                'manual_review','manual_review_data','manual_receipt','root_adoption'):
        bound(ready[key])
    graph=read(bound(ready['graph_json']))
    basename='unblock-nine-certified-high-resolution-sorted-source'
    assert ready['graph_json']['path'].endswith('/'+basename+'.json')
    assert ready['graph_markdown']['path'].endswith('/'+basename+'.md')
    graph_receipt=read(bound(ready['graph_receipt']))
    assert type(graph_receipt['exit_code']) is int and graph_receipt['exit_code']==0
    assert graph_receipt['output_sha256']==pin(bound(ready['graph_output']))['sha256']
    command=graph_receipt['command']
    assert basename in (command if isinstance(command,str) else ' '.join(command))
    assert (bound(ready['graph_output'])).stat().st_size>0, 'Empty/interrupted capture is not accepted'
    manual=read(bound(ready['manual_review_data']))
    scope_paths=manual['reviewed_changed_source_paths']
    scope_lists=manual['scope_assessment']['unit_scope']
    assert len(scope_paths)==137 and len(set(scope_paths))==137
    assert all(x.endswith('.lean') for x in scope_paths)
    assert len(manual['source_files'])==209
    for source in manual['source_files']: bound(source)
    expected_scope={'unexpected_changes','unclassified_modules','mixed_pending_split','duplicate_wrappers',
                    'placeholder_findings','canonical_placement_pending'}
    assert set(scope_lists)==expected_scope and all(x==[] for x in scope_lists.values())
    assert pin(R/'ComputationalMathematics/Analysis.lean')['sha256']=='1e247ea03ff424c89d1067c35cdca6593edb4cf2928dc234fd649ad95b94dabb'
    template=read(D/'final-organization-current-input-preparation/organization-template.current-snapshot.json')
    for key,value in list(template['tools'].items()): template['tools'][key]=pin(R/value['path'])
    put('organization-template.json',template)
    c=read(H/'config.template.json')
    c['pending_inputs']=[]
    c['expected_head']='5e3f63594aa964263469ada134aee2809559d50d'
    c['source_tree_sha256']=graph['source']['source_tree_sha256']
    c['topology']=pin(R/'.formalization/library-topology.json')
    c['gate']=pin(R/'gates/leveque-finite-volume/chapter-01.json')
    c['organization_template']=pin(P/'organization-template.json')
    c['graph']={'json':ready['graph_json'],'markdown':ready['graph_markdown']}
    c['expected_counts']={'production_modules':6012,'native_constants':1426,'native_owners':171,
                         'total_rows':57,'formalizable_rows':41,'skipped_rows':16}
    fps=read(D/'final-organization-current-input-preparation/frozen-evidence-catalog.json')['fingerprints']
    seventh=D/'riemann-certified-fingerprints/additional-expression-fingerprints.json'
    fp=read(seventh); assert len(fp['records'])==7 and len(fp['files'])==4
    fps.append({'inventory':pin(seventh),'expected_records':7,'expected_files':4,
        'provenance':[pin(D/'riemann-certified-fingerprints/final-receipt.json'),
                      pin(D/'riemann-certified-fingerprints/fingerprint-receipt.json')]})
    c['fingerprints']=fps
    review_evidence=[ready['manual_review'],ready['manual_review_data'],ready['manual_receipt'],ready['root_adoption'],
                     ready['graph_receipt'],ready['graph_output']]
    review_evidence += [pin(D/'analysis-casefold-order-repair/receipt.json'),
                       pin(S/'unblock-nine-final-sorted-full-build-exit.json'),
                       pin(S/'unblock-nine-final-sorted-full-build-output.txt')]
    for key in ('layout','tiers','compatibility','hygiene'):
        receipt=ready['layout_receipt'] if key=='layout' else pin(S/('unblock-nine-final-current-'+key+'-exit.json'))
        output=ready['layout_output'] if key=='layout' else pin(S/('unblock-nine-final-current-'+key+'-output.txt'))
        data=read(bound(receipt))
        assert type(data['exit_code']) is int and data['exit_code']==0
        assert data['input_commit']==c['expected_head']
        assert data['output_sha256']==pin(bound(output))['sha256']
        assert data['command']==['/usr/bin/python3',template['tools'][key]['path']]
        c['checker_executions'][key]={'receipt':receipt,'output':output,'expected_command':data['command'],
            'applicability_rationale':ready['applicability_rationale'][key],
            'evidence':review_evidence}
    manifest=D/'final-certified-complete-declarations/manifest.json'
    assert pin(manifest)['sha256']=='55f80b2eb6dadf90a68c6a5857db326882954b24d908b5b13524bb8228e69f59'
    c['complete_declaration_manifest']=pin(manifest)
    native_receipt=S/'unblock-nine-final-current-declarations-exit.json'
    native_output=S/'unblock-nine-final-current-declarations-output.txt'
    native=read(native_receipt)
    assert type(native['exit_code']) is int and native['exit_code']==0
    assert native['output_sha256']==pin(native_output)['sha256']=='ea279f27dcb48b2897ad8d11c55b714be4bdfdff9fab90dd9613dbe99b9acf0a'
    c['complete_native']={'receipt':pin(native_receipt),'output':pin(native_output),
        'expected_command':native['command'],'applicability_rationale':
            'Actual 41 selected/prospective declaration and axiom checks on unchanged target/dependency bytes. The sole later Analysis import-order correction changes no declaration owner or imported module set; native output does not assert source acceptance.',
        'evidence':review_evidence+[pin(manifest)]}
    c['placement_reviews']=[manual['placement_review_for_config']]
    assert c['placement_reviews'][0]['covered_source_paths']==scope_paths
    c['scope_assessment']={'rationale':
        'Exact independently reviewed 209-file Chapter01/native-owner dependency and single-Analysis-boundary scope; explicit six empty findings supported by source contracts, actual placement reviews and read-only path/tier/placeholder observations. This config requests a review-required draft only, without adopting measurement status or source acceptance.',
        'unit_scope':scope_lists}
    spec=importlib.util.spec_from_file_location('support',H/'support.py')
    support=importlib.util.module_from_spec(spec); spec.loader.exec_module(support)
    support.schema(c)
    for ref in support.all_refs(c): bound(ref)
    for p,h in observed.items(): assert sha(p.read_bytes())==h,'Changed while assembling: '+str(p)
    assert args.ready_inputs.read_bytes()==raw
    put('config.json',c)
    put('config-preparation-receipt.json',{'status':'EXACT_INPUTS_READY_FOR_READONLY_CAPTURE_DRAFT',
        'config':pin(P/'config.json'),'template':pin(P/'organization-template.json'),
        'ready_inputs':pin(args.ready_inputs),'source_tree_sha256':c['source_tree_sha256'],
        'observed_input_files':[{'path':p.relative_to(R).as_posix(),'sha256':h} for p,h in sorted(observed.items())],
        'measurement_run':False,'gate_modified':False})
    print(json.dumps({'config':pin(P/'config.json'),'source_tree_sha256':c['source_tree_sha256'],
                      'status':'ready-for-readonly-capture-draft'},indent=2))

if __name__=='__main__':main()
