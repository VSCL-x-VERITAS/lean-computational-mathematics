from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,subprocess,sys,time,collections,re
F=Path(__file__).resolve().parent;D=F.parent;S=D.parent;R=S.parents[3];C=R.parent/'formalization-collaboration-v5.0.1';B=C/'books/candidates/leveque-finite-volume'
pins={}
def raw(p):return Path('\\\\?\\'+str(p.resolve())).read_bytes()
def ref(p):
    p=p.resolve();v={'path':p.as_posix(),'sha256':hashlib.sha256(raw(p)).hexdigest()};pins[v['path']]=v;return v
def read(p):ref(p);return json.loads(raw(p))
def write(name,obj):
    p=F/name
    with p.open('x',encoding='utf-8',newline='\n') as f:json.dump(obj,f,indent=2,ensure_ascii=False);f.write('\n')
    return ref(p)
gatepath=R/'gates/leveque-finite-volume/chapter-01.json';gb=raw(gatepath);gate=json.loads(gb);gatepin=ref(gatepath)
(F/'gate.snapshot.json').write_bytes(gb)
sel=read(D/'selected-interpretations.json');ids=[x for c in sel['choices'] for x in c['rows']]
rows=gate['rows'];counts=dict(collections.Counter(x['status'] for x in rows));accepted=[];nine=[]
for row in rows:
    item={k:row.get(k) for k in ('id','source_label','printed_page','pdf_page','status','classification','lean_declarations','lean_implies_source','source_implies_lean','adjudication_required','reuse_source')}
    if row.get('faithfulness_task'):
        taskpath=R/row['faithfulness_task'];task=read(taskpath);item['task']=ref(taskpath);item['target']={**task['target'],'file':ref(R/task['target']['path'])};item['source_locations']=task['source']['locations']
    if row.get('faithfulness_decision'):
        dp=R/row['faithfulness_decision'];decision=read(dp);item['decision']=ref(dp);item['decision_accepted']=decision['accepted'];item['decision_classification']=decision['classification'];item['decision_adjudicated']=decision['adjudicated'];item['decision_remaining_uncertainties']=decision.get('remaining_uncertainties',[])
    for field in ('coordinator_selected_interpretation','interpretation_refinement','qualified_binding_request','native_evidence'):
        if field in row:item[field]=row[field]
    for field in ('blind','direct','round_trip','source_contract'):
        if row.get(field+'_artifact'):
            p=R/'gates/leveque-finite-volume'/row[field+'_artifact'];item[field]=ref(p)
    if row['status'] in ('PROVED','REUSED','DISCREPANCY'):
        assert item['decision_accepted'] is True,row['id'];accepted.append(item)
    if row['id'] in ids:nine.append(item)
assert len(nine)==9
history_patterns=[r'ACOUSTICS-LEFT-MODE-',r'LEFT-MODE-INTERPRETED-',r'EIGENVALUES-(WAVE-SPEEDS|GENERAL-PROPAGATION|INTERPRETED-PROPAGATION)-',r'MATERIAL-(AVERAGING|AVG|INTERFACE)-',r'(NONCONSERVATION-SOURCE-TERMS|SOURCE-TERMS|SOURCE-SLICES)-',r'RIEMANN-(INITIAL-VALUE|HYPERBOLIC-PROBLEM|DEFINITION|MODEL)-',r'(FINITE-VOLUME-(LOCAL-)?FLUX-UPDATE|FV-LOCAL-FLUX-UPDATE)-',r'(RIEMANN-INFORMATION|LOCAL-RIEMANN|RIEMANN-INTERFACE)-',r'(DIMENSIONAL-SPLITTING|COORDINATE)-']
history=[]
for folder in sorted((S/'audits').iterdir()):
    if not any(re.search(p,folder.name) for p in history_patterns):continue
    decisionpath=folder/'faithfulness/decision.json'
    if not Path('\\\\?\\'+str(decisionpath.resolve())).exists():continue
    j=read(decisionpath);history.append({'task_id':j.get('task_id',folder.name),'decision':ref(decisionpath),'accepted':j['accepted'],'classification':j['classification'],'adjudicated':j['adjudicated'],'judge_classifications':j.get('judge_classifications'), 'remaining_uncertainties':j.get('remaining_uncertainties',[])})
identity_paths={'user_attachment':Path('C:/Users/qed_s/.codex/attachments/2ad9273d-d8aa-4354-a2d3-2032ca9861f1/pasted-text.txt'),'source':B/'source/LeVeque_Finite_Volume_Methods_for_Hyperbolic_Problems_2002.pdf','profile':B/'module/book-profile.json','module_audit':B/'module/module-audit.json','unit_index':B/'module/unit-index.json','module_instructions':B/'module/instructions.md','reporting_policy':B/'module/references/reporting.md','gate_checker':B/'module/scripts/gate.py','release':C/'project-development/current/release.json','lean_toolchain':R/'lean-toolchain','lake_manifest':R/'lake-manifest.json','audit_kit_version':R/'.faithfulness-audit/VERSION','selection':D/'selected-interpretations.json','high_resolution_user_receipt':D/'user-high-resolution-interpretation-20260908.json'}
identities={k:ref(p) for k,p in identity_paths.items()};lm=read(R/'lake-manifest.json');mathlib=next(x for x in lm['packages'] if x['name']=='mathlib')
organization=read(D/'organization-high-resolution/receipt.json');fp=read(D/'dim-high-resolution-fingerprints/fingerprint-receipt.json')
topology=read(R/'.formalization/library-topology.json');latest=read(R/'.formalization/reconciliation/latest/aa1ff96998802d9fbd48e728b3573cff7c4272480d66a397699f8a050cf29560.json');status=read(R/f".formalization/reconciliation/statuses/{latest['request_id']}.json");request=ref(R/f".formalization/reconciliation/requests/{latest['request_id']}.json")
ledgers={}
for scope,base in [('book',R/'ledgers/leveque-finite-volume/book-issues/leveque-finite-volume/chapters/chapter-01'),('process',R/'ledgers/leveque-finite-volume/skill-issues/book-formalization/leveque-finite-volume/sessions/codex-start-1-v5-0-1-20260908')]:
    ledgers[scope]={}
    for name in ('issues.md','limitations.md','inconsistencies.md','tracker.json'):ledgers[scope][name]=ref(base/name)
    t=raw(base/'issues.md').decode();ledgers[scope]['last_ids']=re.findall(r'^\| (LEV-[^ |]+)',t,re.M)[-6:]
argv=[sys.executable,'-X','utf8','-B',str(R.parent/'workflow-v5.0.1-local/run_workflow_posix.py'),str(B/'module/scripts/gate.py'),'check',str(gatepath),'--unit','1','--mode','default']
start=time.monotonic()
with (F/'gate-check-output.txt').open('xb') as out,(F/'gate-check-stderr.txt').open('xb') as err:proc=subprocess.run(argv,cwd=R,stdout=out,stderr=err)
check=write('gate-check-receipt.json',{'command':argv,'actual_exit_code':proc.returncode,'elapsed_ms':int((time.monotonic()-start)*1000),'gate':gatepin,'gate_unchanged':raw(gatepath)==gb,'output':ref(F/'gate-check-output.txt'),'stderr':ref(F/'gate-check-stderr.txt'),'require_pass':False})
denom=len(rows)-counts.get('SKIPPED',0)-counts.get('DEFERRED',0)
data={'stage':'CURRENT REVIEW DRAFT — root review required, not final assertion','captured_at_utc':datetime.now(timezone.utc).isoformat(),'gate':gatepin,'gate_snapshot':ref(F/'gate.snapshot.json'),'stored_gate_verdict':gate['chapter_gate'],'gate_schema_version':gate['gate_schema_version'],'gate_check':check,'gate_check_actual_exit':proc.returncode,'progress':{'formalized':len(accepted),'denominator':denom,'remaining':denom-len(accepted),'percentage':round(100*len(accepted)/denom,2),'total_inventory':len(rows),'skipped':counts.get('SKIPPED',0),'deferred':counts.get('DEFERRED',0),'nine_closed':sum(r['status'] in ('PROVED','REUSED','DISCREPANCY') for r in nine)},'counts':counts,'classifications':dict(collections.Counter(r['classification'] for r in accepted)),'nine_rows':nine,'all_accepted_rows':accepted,'historical_audits':history,'identities':identities,'lean_version':raw(R/'lean-toolchain').decode().strip(),'mathlib':mathlib,'organization':{'receipt':ref(D/'organization-high-resolution/receipt.json'),'counts':organization['counts'],'tier_validation_failures':organization['actual_tier_validation_failures'],'full_final_scans_pending':True},'fingerprints':{'receipt':ref(D/'dim-high-resolution-fingerprints/final-receipt.json'),'constants':fp['combined_disjoint_constants'],'owners':fp['combined_owner_files'],'native_input_commit':fp['input_commit']},'integration':{'topology':ref(R/'.formalization/library-topology.json'),'campaign':topology['campaign_head'],'stable':topology['stable_destination'],'instances':topology['instances'],'latest_pointer':latest,'request':request,'status':ref(R/f".formalization/reconciliation/statuses/{latest['request_id']}.json"),'status_state':status['current_state'],'result_kind':status.get('result_kind'),'checkpoint_evidence':status.get('checkpoint_evidence'),'note':'Latest retained checkpoint binds the historical blocked gate, not this reopened current goal; no candidate or integration is inferred.'},'ledgers':ledgers}
write('report-data.json',data);write('captured-inputs.json',{'inputs':list(pins.values()),'no_source_gate_audit_git_mutation':True})
print(json.dumps({'progress':data['progress'],'counts':counts,'gate_check_actual_exit':proc.returncode,'gate_unchanged':raw(gatepath)==gb,'history_decisions':len(history)},indent=2))
