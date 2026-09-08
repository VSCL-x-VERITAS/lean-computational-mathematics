"""Write the root-reviewed source-choice dossier and proposed rows; never install a gate."""
from pathlib import Path
from datetime import datetime,timezone
from collections import Counter
import hashlib,json,os,subprocess
S=Path(__file__).resolve().parent;R=S.parents[3];P=S/'final-material-choice-review-80f5'
assert os.name!='nt'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();read=lambda p:json.loads(p.read_bytes())
def ref(p):return dict(path=p.relative_to(R).as_posix(),sha256=sha(p))
def write(p,v):
 with p.open('x',encoding='utf-8',newline='') as f:json.dump(v,f,indent=2,ensure_ascii=False);f.write('\n')
git=lambda *a:subprocess.check_output(['git','-c','core.longpaths=true',*a],cwd=R)
assert git('rev-parse','HEAD').decode().strip()=='80f5d4340d507dbc347a806717ff31c5a9aace72'
assert not git('diff','--name-only','HEAD','--','ComputationalMathematics','NumStability','docs/architecture/tiers.json').strip()
G=R/'gates/leveque-finite-volume/chapter-01.json';base=read(P/'base-active-gate.json');context=read(P/'context.json')
assert G.read_bytes()==(P/'base-active-gate.json').read_bytes()
assert sha(G)=='b5538b8881e3a3e58e6cc43aa03344072f4bb9d692516599144820f049599d2e'
assert sha(P/'context.json')=='7021c84cce0ea2b0b47f04f3cf4ecb929b5d053e129db56cbc9d3dd61a03bad6'
source=S/'prospective-source-choice-boundaries-batch10-v2.json'
projection=S/'current-thread-question-provenance-v2-batch10/projection.json'
prior=S/'nine-row-local-route-review-batch10/local-route-review.json'
assert sha(source)=='99fb785787ccfe7906b95ff0dc1d4d774bcd664673cc3c7c9323e9d29ae2c0c3'
assert sha(projection)=='15f55c43d5d3c50134b1861d82231e953c6644db4cd30561d0644640b3e11acc'
assert sha(prior)=='a1f573c281e28f67b42bc22cf01a3209a659eea74c8cf92a86efe401d23ad2cd'
labels={'source-inventory':'batch10-source-inventory','layout':'batch10-layout-retry','tiers':'batch10-tiers',
'compatibility':'batch10-compatibility','hygiene':'batch10-placeholders','audits':'batch10-closed-audits',
'declarations':'chapter01-final-declarations-80f5-retry','focused-build':'chapter01-final-focused-build-80f5',
'full-build':'chapter01-final-full-build-80f5'}
checks={}
for kind,label in labels.items():
 ep=S/(label+'-exit.json');op=S/(label+'-output.txt');e=read(ep)
 assert type(e['exit_code']) is int and e['exit_code']==0
 assert e.get('raw_output_sha256',e.get('output_sha256'))==sha(op)
 if kind in ['declarations','focused-build','full-build']:assert e['input_commit']==context['lean_current_head']
 checks[kind]=[ref(ep),ref(op)]
assert read(S/'batch10-closed-audits-output.txt')['closed_rows']==32
assert all(x['exit_code']==0 for x in read(S/'batch10-closed-audits-output.txt')['records'])
assert 'Layout contract satisfied' in (S/'batch10-layout-retry-output.txt').read_text(encoding='utf-8')
for label in ['batch10-graph-check','batch10-organization-preflight','root-batch10-campaign-checkpoint',
'batch10-trackers-after-staging-recovery','chapter01-final-question-projection-80f5']:
 e=read(S/(label+'-exit.json'))
 assert type(e['exit_code']) is int and e['exit_code']==0
 assert e.get('raw_output_sha256',e.get('output_sha256'))==sha(S/(label+'-output.txt'))
assert sha(S/'root-batch10-checkpoint-retry-staged-verification.json')=='8d90e6b313abd9423c3d1b5930c409de74d0e4b5368772ff62fa1d497e2a254c'
checkpoint=read(S/'root-batch10-checkpoint-verification.json')
assert checkpoint['formalized_objects']==32 and checkpoint['remaining_objects']==9
for x in checkpoint['verification_artifacts']:assert sha(R/x['path'])==x['sha256']
request=R/'.formalization/reconciliation/requests/9bb83d655b85bd06d874a6b4bbf2b08676f81053d193bf5b8e74389416a1ffc7.json'
status=R/'.formalization/reconciliation/statuses/9bb83d655b85bd06d874a6b4bbf2b08676f81053d193bf5b8e74389416a1ffc7.json'
assert sha(request)=='7158c7f346080bccfb1e74a0b58488e042ed6cd5c1fcb957851d2faccfd2d0c3'
state=read(status)
assert state['state']=='QUEUED' and state['result_kind']=='retained'
common=[ref(S/n) for n in ['root-batch10-checkpoint-verification.json','root-batch10-checkpoint-retry-staged-verification.json',
'batch10-analysis-imports.json','batch10-tier-update.json','chapter01-current-expression-fingerprints-24b3.json',
'batch7-rebind-preparation/batch10-closed-rows-current/summary.json','root-generated-capstone-cache-review.json',
'generated-capstone-cache-preservation/preservation.json']]
common+=checks['layout']+checks['tiers']+checks['compatibility']+checks['hygiene']+checks['full-build']
rows=[];sources={x['row_id']:x for x in read(source)['rows']}
questions={x['question_id']:x for x in read(projection)['questions']}
for old in read(prior)['rows']:
 ident=old['row_id'];qid=old['question']['question_id'];question=questions[qid]
 assert question['status']=='pending' and ident in question['row_ids']
 assert not old['necessary_local_mathematics_identified']
 evidence=[]
 for x in old['evidence']:
  assert sha(R/x['path'])==x['sha256']
  b=dict(path=x['path'],sha256=x['sha256'])
  if b not in evidence:evidence.append(b)
 mathematics=old['current_mathematics'];consumer=old['consumer_evidence']
 supplements=[]
 if ident=='LEV-CH01-DIMENSIONAL-SPLITTING':
  supplements=[ref(S/n) for n in ['information-coordinate-production/manifest.json',
   'information-coordinate-production/normalized-files.json','nine-row-production-supplement-batch10/manifest.json',
   'root-nine-row-production-supplement-review.json','root-batch10-production-placement-verification.json']]
  mathematics+=' The five canonical leaves and all nine aggregate/tier additions are now committed and root-reviewed; all 41 production mappings and 199 native reports passed.'
  consumer='The final canonical arbitrary full-line Cartesian consumer, admitted information specialization and positive two-direction example preserve the frozen scratch contract. The explicit recursive admission bridge and actual axis projection were independently reviewed; final producer names/bytes are in the normalized inventory.'
 else:assert old['required_local_integration_or_evidence']==[]
 obstruction='The printed source does not select the following materially different formal scope, and the recorded user choice remains unanswered: '+old['source_boundary']
 attempted='Completed source/definition review, canonical reuse, explicit mathematical alternatives, native checks, organization, consumer checks and independent review. '+mathematics+' '+consumer
 resume='Receive the user choice recorded as '+qid+', select the source-facing contract under that explicit interpretation while preserving the source ambiguity, and run a fresh hash-bound statement-faithfulness audit before accepting this row.'
 route_items=[
 dict(kind='source-review',description=sources[ident]['boundary']+' The exact source locator and old decisions are preserved; no unanswered choice is adopted.',outcome='completed',evidence=[sources[ident]['source_locator']]+sources[ident]['frozen_audits']),
 dict(kind='canonical-reuse',description=mathematics+' Existing producer searches and exact byte bindings are retained.',outcome='completed',evidence=evidence+supplements),
 dict(kind='mathematical-alternatives',description=old['scope_qualification']+' The required prospective alternatives and domain qualifications have been checked. Proving an alternative does not determine which meaning the source intended.',outcome='completed',evidence=evidence+[ref(prior)]+supplements),
 dict(kind='native-checks',description='Historical native checks for the stated prospective mathematics and their current source/receipt pins were independently verified. Current 32 accepted declarations, focused chapter and full two-root builds pass at checkpoint 80f5d434; no prospective row gains acceptance from these checks.',outcome='completed',evidence=evidence+checks['declarations']+checks['focused-build']+checks['full-build']),
 dict(kind='organization',description='Final required producer placement, sorted aggregate exposure, exact tiers, compatibility, no-placeholder scan, current graph/fingerprints and unchanged accepted-row rebind are complete. The durable checkpoint is retained/queued with campaign heads unchanged. Exact generated-output snapshots preserve the repaired cache representation.',outcome='completed',evidence=common+supplements),
 dict(kind='consumer-checks',description=consumer,outcome='completed',evidence=evidence+supplements),
 dict(kind='review',description='Root has reviewed the full source-boundary dossier, complete mathematical alternatives and nonvacuous consumers, independent nine-row review and additive final DIM production review. Every previously identified necessary local integration item now has successful current receipts. No further necessary local proof, prerequisite, wrapper-independent consumer or organization task was identified before the recorded material source choice. Source-facing selection and a new audit depend on that answer.',outcome='completed',evidence=[ref(prior),ref(S/'nine-row-production-supplement-batch10/manifest.json'),ref(S/'root-nine-row-evidence-verification.json'),ref(S/'root-nine-row-production-supplement-review.json')]+common)]
 rows.append(dict(row_id=ident,question_id=qid,all_local_work_complete=True,remaining_local_actions=[],obstruction=obstruction,attempted_routes=attempted,resume_condition=resume,routes=route_items))
assert len(rows)==9 and len({x['question_id'] for x in rows})==8
dossier=dict(schema_version=1,kind='reviewed-local-work-exhaustion',input_commit=context['lean_current_head'],
bindings=context['bindings'],source_manifest_sha256=sha(source),question_projection_sha256=sha(projection),
reviewer='Codex root; substantive review of the frozen source boundaries, independent nine-row review, final DIM production supplement and actual current integration/native evidence',
reviewed_at_utc=datetime.now(timezone.utc).isoformat().replace('+00:00','Z'),rows=rows)
route=P/'route-manifest.json';write(route,dossier)
refs=dict(source_manifest=ref(source),question_projection=ref(projection),route_manifest=ref(route))
evidence_string='; '.join(k+'='+v['path']+'#sha256='+v['sha256'] for k,v in refs.items())
byid={x['row_id']:x for x in rows};proposed=json.loads(json.dumps(base['rows']))
for row in proposed:
 if row['id'] not in byid:continue
 assert row['status']=='READY' and not row.get('blocked_by')
 rr=byid[row['id']]
 for key in ['next_foundation','next_action','open_reason','current_target']:row.pop(key,None)
 row.update(status='HARD_BLOCKED',blocker_kind='material-user-choice',
 obstruction=rr['obstruction'],attempted_routes=rr['attempted_routes'],
 blocking_evidence=evidence_string,resume_condition=rr['resume_condition'])
assert Counter(x['status'] for x in proposed)==dict(PROVED=15,REUSED=17,HARD_BLOCKED=9,SKIPPED=16)
proposed_path=P/'proposed-rows.json';write(proposed_path,dict(rows=proposed))
params=dict(schema_version=1,kind='root-reviewed-blocked-request-inputs',base_gate=ref(P/'base-active-gate.json'),
 proposed_rows=ref(proposed_path),check_inputs=ref(S/'chapter01-final-current-80f5-inputs.json'),
 **refs,context=ref(P/'context.json'),receipt_labels=labels)
write(P/'constructor-inputs.json',params)
assert G.read_bytes()==(P/'base-active-gate.json').read_bytes()
print(json.dumps(dict(route_manifest=ref(route),proposed_rows=ref(proposed_path),constructor_inputs=ref(P/'constructor-inputs.json'),operational_gate_unchanged=True,source_acceptance=False)))

