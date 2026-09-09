"""Additive configurable successor: assemble review-required organization inputs only."""
from support import *

def main():
    args,R,P,c,config_ref,guard,head,template,campaign,engine = setup('draft')
    capture_ref={'path':relative_path(args.capture_manifest),'sha256':args.capture_sha256}
    cap_path=guard.bind(capture_ref); capture=read(cap_path)
    require(capture.get('status')=='root-review-required' and capture.get('config')==config_ref and
            capture.get('input_commit')==head and capture.get('operational_measurement_run') is False,
            'capture does not match exact current configuration/HEAD')
    captured={}
    for value in capture['files']:
        path=guard.bind(value)
        require(path.parent==cap_path.parent and path.name not in captured, 'unexpected/duplicate capture file')
        captured[path.name]=value
    def observation(name): return read(guard.bind(captured[name]))
    obs=observation('current-source-observation.json')
    unit=observation('unit-source-pins.json')
    all_pins=observation('all-production-source-pins.json')['files']
    by_path={x['path']:x for x in all_pins}
    require(len(by_path)==len(all_pins), 'duplicate production pins')
    source,modules=engine.scan_sources(R)
    require(source['source_tree_sha256']==obs['production_source_tree_sha256']==c['source_tree_sha256'],
            'captured source snapshot no longer current')
    require(len(modules)==c['expected_counts']['production_modules'] and
            {m.path for m in modules}==set(by_path), 'full source census no longer exact')
    for value in all_pins: guard.bind(value)
    paths={x['path'] for x in unit['files']}
    require(len(paths)==len(unit['files']) and paths<=set(by_path), 'invalid unit pins')
    for value in unit['files']: require(value==by_path[value['path']], 'unit/source pin mismatch')
    module_paths={m.name:m.path for m in modules}
    source_modules={m.path:m for m in modules}
    todo=list(paths)
    while todo:
        path=todo.pop()
        for name in source_modules[path].imports:
            dep=module_paths.get(name)
            if dep and dep not in paths: paths.add(dep);todo.append(dep)
    require(paths=={x['path'] for x in unit['files']}, 'capture omitted native-owner import closure')
    semantic_paths=sorted(paths)
    paths.update(c['aggregate_boundaries'])
    changed=changed_sources(R,c['anchor'],source_modules)
    require(changed==obs['actual_changed_source_paths'] and set(changed)<=paths,
            'changed-path coverage no longer exact')
    require(set(changed)<={p for item in c['placement_reviews'] for p in item['covered_source_paths']},
            'placement review coverage missing')
    source_files=[by_path[p] for p in sorted(paths)]
    source_files_sha=sha(json.dumps(source_files,sort_keys=True,separators=(',',':'),ensure_ascii=True).encode())
    baseline_path=guard.bind(captured['protected-anchor-layout-exceptions.json'])
    policy_path=template['tools']['layout_policy']['path']
    require(baseline_path.read_bytes()==git(R,'show',c['anchor']+':'+policy_path), 'ratchet baseline differs from protected Git blob')
    require(guard.bind(captured['current-layout-exceptions.json']).read_bytes()==guard.bind(template['tools']['layout_policy']).read_bytes(),
            'current layout policy changed')
    executions=observation('actual-four-executions.json')['executions']
    require(set(executions)==set(CHECKS), 'missing captured checker')
    for key in CHECKS:
        require(executions[key]==execution(guard,c['checker_executions'][key],head,template['tools'][key]['path']),
                'captured execution disagrees with actual configured receipt')
    require(obs['campaign_owner']==campaign['owner'] and obs['topology_sha256']==c['topology']['sha256'],
            'topology authority changed')
    review_refs=[config_ref,capture_ref,*captured.values(),*c['graph'].values(),c['complete_declaration_manifest']]
    review_refs += [item['evidence'] for item in c['placement_reviews']]
    for key in CHECKS: review_refs += c['checker_executions'][key]['evidence']
    review_refs += c['complete_native']['evidence']
    unique={value['path']:value for value in review_refs}
    require(all(unique[x['path']]==x for x in review_refs), 'conflicting review evidence pins')
    review_refs=[unique[k] for k in sorted(unique)]
    final_guard(R,c,guard,engine,source,changed)
    P.mkdir()
    for key in CHECKS:
        write(P,key+'-applicability.draft.json',{'status':'root-review-required','scope':'exact configured current snapshot only',
            'receipt_sha256':executions[key]['receipt']['sha256'],
            'production_source_tree_sha256':c['source_tree_sha256'],'source_files_sha256':source_files_sha,
            'review_rationale':c['checker_executions'][key]['applicability_rationale'],
            'review_evidence':review_refs,'invalidated_by':'Any source/owner/import, policy, config, topology, HEAD, receipt or referenced evidence change.'})
        executions[key]['applicability_review']=guard.pin(P/(key+'-applicability.draft.json'))
    app_refs=[executions[k]['applicability_review'] for k in CHECKS]
    write(P,'unit-scope-review.draft.json',{'status':'root-review-required','scope':'exact configured current snapshot only',
        'anchor':c['anchor'],'production_source_tree_sha256':c['source_tree_sha256'],'source_files':source_files,
        'review_evidence':review_refs+app_refs,'reviewed_changed_source_paths':changed,
        'unit_scope':c['scope_assessment']['unit_scope'],'draft_assessment':c['scope_assessment']['rationale'],
        'placement_review_records':c['placement_reviews'],
        'scope_counts':{'semantic_and_dependency_files':len(semantic_paths),
            'aggregate_exposure_boundary_files':len(set(c['aggregate_boundaries'])-set(semantic_paths)),
            'unit_files':len(source_files),'production_modules':len(modules),'actual_changed_source_paths':len(changed)}})
    template.update(status='root-review-required',scope='exact configured snapshot; no measurement or adoption performed',
        topology={'path':str(guard.bind(c['topology'])),'sha256':c['topology']['sha256']},
        ratchet_owner=campaign['owner'],unit_scope_review=guard.pin(P/'unit-scope-review.draft.json'),
        ratchet_baseline=captured['protected-anchor-layout-exceptions.json'],
        supporting_executions={k:{f:executions[k][f] for f in ('receipt','output','command','applicability_review')} for k in CHECKS})
    write(P,'organization-inputs.draft.json',template)
    write(P,'supporting-review-pins.json',{'status':'current-snapshot-root-review-required','files':review_refs,
        'scope_source_files_sha256':source_files_sha})
    summary={'status':'root-review-required','final_measurement_run':False,
        'production_source_tree_sha256':c['source_tree_sha256'],'source_files':len(source_files),
        'semantic_dependency_files':len(semantic_paths),'changed_source_paths':len(changed),
        'ratchet_owner_from_actual_topology':campaign['owner'],'four_receipts_actual_exit_zero':True,
        'source_changes_during_draft_assembly':[],'inputs_sha256':sha((P/'organization-inputs.draft.json').read_bytes())}
    write(P,'draft-summary.json',summary)
    final_guard(R,c,guard,engine,source,changed)
    freeze_outputs(P,guard,'draft-manifest.json',config_ref,head)
    print(json.dumps(summary,indent=2))

if __name__=='__main__': main()
