"""Additive unexecuted commands and unresolved-input template; no operational emitter."""
from pathlib import Path
import copy,hashlib,json
P=Path(__file__).resolve().parent;D=P.parent;R=D.parents[4]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def ref(p):return {'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
def write(name,x):
    with (P/name).open('xb') as f:f.write((json.dumps(x,indent=2)+'\n').encode())
old=D/'final-reconciliation-mapping-inputs'
config=json.loads((P/'assessment-config.json').read_bytes())
policy=json.loads((R/config['preparation_policy']['path']).read_bytes())
commands=json.loads((old/'origin-command-sequence.json').read_bytes())
original=copy.deepcopy(commands)
prefix='final-reconciliation-mapping-inputs/committed-capture'
newprefix='physical-reconciliation-mapping-assessment/future-committed-capture'
for c in commands['commands']:
    argv=c['argv']
    if c.get('operation')=='actual-origin-inventory' and c.get('lane')==policy['merge_lane']:
        new=[];i=0;inserted=False
        while i<len(argv):
            if argv[i]=='--fingerprints':
                if not inserted:new.extend(['--fingerprints',policy['origin_fingerprint_paths'][policy['merge_lane']][0]]);inserted=True
                i+=2
            else:new.append(argv[i]);i+=1
        assert inserted;argv=new
    fixed=[]
    for v in argv:
        v=v.replace(prefix,newprefix)
        if v.endswith('/final-reconciliation-mapping-inputs/final-origin-inputs.json'):
            v=v.replace('/final-reconciliation-mapping-inputs/final-origin-inputs.json','/physical-reconciliation-mapping-assessment/final-origin-inputs.json')
        # Outer process is native Python: its script path must be a native path.
        if v.startswith('/c/'):v='C:/'+v[3:]
        fixed.append(v)
    c['argv']=fixed
commands.update(status='UNEXECUTED_ROOT_REVIEW_REQUIRED',source_acceptance=False,
    current_inventory_count=1,inspection_inventory_count=2,
    prerequisite='Actual final 41-row closure, final committed source/evidence HEAD and authorized topology pin are absent. These commands must not be run against the present 39-closed worktree.')
assert [c for c in commands['commands'] if c.get('operation')=='actual-origin-inventory'][0]['argv'].count('--fingerprints')==1
assert [c for c in commands['commands'] if c.get('operation')=='actual-origin-inventory'][1]['argv'].count('--fingerprints')==2
write('origin-command-sequence.json',commands)
template=json.loads((old/'final-origin-inputs.template.json').read_bytes())
template['preparation_policy']=config['preparation_policy']
template['complete_declaration_manifest']=config['complete_declaration_manifest']
for origin in template['origins'].values():
    for r in origin.values():r['path']=r['path'].replace(prefix,newprefix);assert r['sha256'] is None
write('final-origin-inputs.template.json',template)
pins=json.loads((old/'helper-pins.json').read_bytes())
for r in pins:assert sha(R/r['path'])==r['sha256'],r['path']
pins.extend([ref(old/'derive_final_origin_spec.py'),config['preparation_policy'],config['complete_declaration_manifest']])
write('reused-helper-pins.json',pins)
changes=json.loads((D/'physical-current-fingerprints/selected-record-changes.json').read_bytes())
from collections import Counter
write('post-inspection-evolution.json',{'source':ref(D/'physical-current-fingerprints/selected-record-changes.json'),
    'old_current_records':1426,'current_records':1688,'prior_selected_count':changes['prior_selected_count'],
    'fresh_selected_count':changes['fresh_selected_count'],'added_names':len(changes['added_names']),
    'relocated_names':len(changes['relocated_names']),
    'changed_record_count':sum(bool(v['changed_fields']) for v in changes['old_to_current']),
    'changed_field_counts':dict(Counter(k for v in changes['old_to_current'] for k in v['changed_fields'])),
    'removed_private_helper_ref':changes['exact_removed_private_helper'],
    'meaning':'Post-inspection DIM repair evolution only. All 559 protected inspection records were separately checked unchanged. These historical seven inputs are not current inventory arguments.'})
rows=json.loads((P/'observed-01/source-row-assessment.json').read_bytes())
write('remaining-inputs.json',{'status':'ROOT_REVIEW_REQUIRED','source_acceptance':False,
    'pending_final_source_decisions':[{'row':r['row'],'accepted_decision_ref':None} for r in rows if r['status']=='IN_PROGRESS'],
    'actual_final_commit':None,'actual_final_topology_ref':None,'actual_origin_inventories':None,
    'actual_origin_contexts':None,'actual_mapping_review':None,'candidate':None,
    'eight_ordered_candidate_validations':['source_coverage','import_graph','signature_graph','body_graph','declaration_resolution','focused_build','full_build','pristine_replay'],
    'meaning':'Unknown actual results remain absent. Native target selection is not source acceptance; no origin inventory, payload, catalogue, request, or candidate was created.'})
write('command-derivation.json',{'original':ref(old/'origin-command-sequence.json'),
    'successor':ref(P/'origin-command-sequence.json'),'template':ref(P/'final-origin-inputs.template.json'),
    'changes':['Replace seven work-lane --fingerprints arguments with exactly one current consolidated input; retain two inspection inputs.','Fresh future output names only; directories not created.','Native outer Python receives a native launcher path; inner arguments are converted by that launcher.','Bind current reviewed policy and current 41-target manifest in the unresolved template.'],
    'original_helper_reuse':'No operational origin/catalogue/emitter/converter/epoch helper needed a count change. Their original bytes remain pinned.'})
print(json.dumps({'commands':ref(P/'origin-command-sequence.json'),'template':ref(P/'final-origin-inputs.template.json'),'all_original_helper_pins_verified':True}))
