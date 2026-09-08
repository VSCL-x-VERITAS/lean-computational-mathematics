"""Independent mechanical checks of one actual proposal; never prepare or install."""
from pathlib import Path
import collections,datetime,hashlib,importlib.util,json,os,re,sys
H=Path(__file__).resolve().parent
S=H.parent
R=S.parents[3]
B=S/'blocked-gate-binding-transcript-order-v2/blocked_gate_binding.py'
B_SHA='dbfb374e263b7b0a2f25e9d1b8815a3e65d4e4e0e693581c24a881299fa017a9'
P=B.parent/'runs/final-80f5/preparation.json'
P_SHA='c12dc8ca1662acd5a024188a1124e58d9f4a8f7c6882d6520c4d42254461f41e'
BASE_SHA='b5538b8881e3a3e58e6cc43aa03344072f4bb9d692516599144820f049599d2e'
HEAD='80f5d4340d507dbc347a806717ff31c5a9aace72'
I=S/'install-reviewed-blocked-gate-v3.py'
I_SHA='6e2fb502fbd341eaedee506710e5a49067bfbaa3f153bd34ee5f44638b389dad'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
assert os.name=='posix' and sys.flags.optimize==0 and sha(B)==B_SHA
spec=importlib.util.spec_from_file_location('mechanically_reviewed_binding',B)
b=importlib.util.module_from_spec(spec);spec.loader.exec_module(b)
reader=b.Reader(R);checker=b.load_checker(reader)
reader.raw(Path(__file__).resolve())
reader.raw(I,I_SHA)
prep=b.parse(reader.raw(P,P_SHA))
assert prep['kind']=='prepared-blocked-gate-proposal' and prep['status']=='PREPARED_UNVERIFIED'
original=reader.raw(b.GATE,BASE_SHA);base=b.parse(original)
assert base['chapter_gate']=='ACTIVE' and prep['base_gate_sha256']==BASE_SHA
proposed_bytes=reader.bound(prep['proposed_gate'],as_json=False);proposed=b.parse(proposed_bytes)
assert prep['proposed_gate']['sha256']=='e264dd1cea8cdc57b0389876aad410092df72c1ad48ca1fb73d14049374659c0'
for item in prep['input_files']:reader.raw(Path(item['path']),item['sha256'])
request=b.parse(reader.raw(Path(prep['request']['path']),prep['request']['sha256']))
b.closed(request,{'schema_version','kind','base_gate','proposed_rows','check_inputs','source_manifest','question_projection','route_manifest','receipts'},'actual request')
assert reader.bound(request['base_gate'],as_json=False)==original
explicit_rows=reader.bound(request['proposed_rows'])
assert b.encode(explicit_rows['rows'])==b.encode(proposed['rows'])
assert request['question_projection']==prep['question_projection']
context=checker.current_context(b.GATE,1)
assert context['lean_current_head']==prep['input_commit']==HEAD
assert context['bindings']==prep['bindings']==base['bindings']==proposed['bindings']
b.check_header(base,context,checker)
identities=b.parse(reader.raw(b.PINS['row_set'][0]))
b.check_transition(base,proposed['rows'],identities,checker)
before=b.keyed(base['rows']);after=b.keyed(proposed['rows'])
preserved=[];changed=[]
for row in base['rows']:
 row_id=row['id'];old_bytes=b.encode(row);new_bytes=b.encode(after[row_id])
 if row_id in identities['closed_rows'] or row_id in identities['skipped_rows']:
  assert old_bytes==new_bytes
  preserved.append({'row':row_id,'status':row['status'],'encoded_object_sha256':b.digest(old_bytes)})
 else:
  assert after[row_id]['status']=='HARD_BLOCKED' and after[row_id]['blocker_kind']=='material-user-choice'
  changed.append({'row':row_id,'before_status':row['status'],'after_status':after[row_id]['status'],
                  'changed_fields':[k for k in set(row)|set(after[row_id]) if b.encode(row.get(k))!=b.encode(after[row_id].get(k))]})
assert len(preserved)==48 and len(changed)==9
assert sum(x['status'] in checker.CLOSED_LEAN_STATUSES for x in preserved)==32
assert sum(x['status']=='SKIPPED' for x in preserved)==16
assert set(base)==set(proposed)
top_changes=[key for key in base if b.encode(base[key])!=b.encode(proposed[key])]
assert set(top_changes)=={'chapter_gate','rows','verification_evidence'}
print(json.dumps({'phase':'exact-row-and-context-check','preserved_closed':32,'preserved_skipped':16,'typed_choice_rows':9,'current_head':HEAD}),flush=True)
b.check_provenance(request,proposed['rows'],context,reader,checker,identities)
route=reader.bound(request['route_manifest']);questions=reader.bound(request['question_projection'])
routes=[]
for item in route['rows']:
 assert item['all_local_work_complete'] is True and item['remaining_local_actions']==[]
 kinds=collections.Counter(r['kind'] for r in item['routes'])
 assert set(kinds)==b.ROUTE_KINDS
 routes.append({'row':item['row_id'],'question_id':item['question_id'],'route_categories':dict(kinds),
                'claims_checked_as_records_only':True})
m=reader.bound(request['check_inputs'])
assert m['bindings']==context['bindings'] and m['input_commit']==HEAD
assert m['source_gate_sha256']==BASE_SHA and m['rows_sha256']==checker.canonical_sha256(base['rows'])
accepted=sorted([r for r in proposed['rows'] if r['status'] in checker.CLOSED_LEAN_STATUSES],key=lambda r:r['id'])
names=sorted({n for row in accepted for n in row['lean_declarations']})
assert names==m['declarations']==prep['closed_declarations'] and type(m['count']) is int and m['count']==32
assert [x['row'] for x in m['files']]==[x['id'] for x in accepted]
for item,row in zip(m['files'],accepted,strict=True):
 assert item['declarations']==row['lean_declarations'] and item['contract_hash']==row['contract_hash'] and item['audit_task']==row['faithfulness_task']
 reader.raw(reader.path(item['path']),item['sha256'])
check_source=reader.raw(reader.path(m['check_file']),m['check_file_sha256']).decode('utf-8')
assert re.findall(r'^#check (\S+)$',check_source,re.M)==names
assert re.findall(r'^#print axioms (\S+)$',check_source,re.M)==names
receipts,axioms=b.consume_receipts(request,reader,m,names,accepted,checker)
assert len(axioms)==32 and all(set(x['axioms'])<=set(checker.ALLOWED_AXIOMS) for x in axioms)
native_output=reader.bound(request['receipts']['declarations']['output'],as_json=False).decode('utf-8-sig')
assert not re.search(r'(?m)^.*\.lean:\d+:\d+: (?:error|warning):|sorryAx',native_output)
assert prep['native_input_projection']['original_manifest']==request['check_inputs']
assert prep['native_input_projection']['base_rows_sha256']==checker.canonical_sha256(base['rows'])
assert prep['native_input_projection']['proposed_rows_sha256']==checker.canonical_sha256(proposed['rows'])
print(json.dumps({'phase':'provenance-and-native-receipts','receipt_count':9,'native_declarations':32,'all_native_commits':HEAD}),flush=True)
organization=proposed['verification_loops']['organization_completeness']
assert all(type(v) is int and v==0 for v in organization.values())
cross_before=checker.cross_gate_state(R,organization);assert not cross_before[1]
for path in cross_before[0]:reader.raw(reader.path(path))
payloads,counts=b.payloads_for(proposed,context,names,axioms,checker,reader)
subject=checker.canonical_sha256({'book_id':checker.BOOK_ID,'unit_kind':'chapter','unit':1,'chapter':1,
 'source_unit_sha256':checker.PINNED_SOURCE_SHA256,'mode':'default','excluded_rows':[],'rows':proposed['rows']})
assert subject==prep['gate_subject_sha256']
bindings=checker.global_artifact_bindings(1,context,subject)
primary={'source_inventory':'source-inventory','organization_scan':'layout','faithfulness_audit':'audits',
 'declaration_resolution':'declarations','axiom_check':'declarations','hygiene_check':'hygiene','focused_build':'focused-build','full_build':'full-build'}
artifact_records=[]
for name in checker.EVIDENCE_NAMES:
 record=proposed['verification_evidence'][name]
 path=b.GATE.parent/record['artifact']
 raw=reader.raw(path,record['artifact_sha256']);artifact=b.parse(raw)
 assert artifact['schema_version']==1 and artifact['check']==name
 assert artifact['bindings']==bindings and artifact['payload']==payloads[name]
 assert type(artifact['exit_code']) is int and artifact['exit_code']==0
 assert artifact['count']==record['count']==counts[name]
 command=receipts[primary[name]]['command'];command=command if isinstance(command,str) else json.dumps(command)
 assert artifact['command']==record['command']==command and record['exit_code']==0
 ref={'path':path.relative_to(R).as_posix(),'sha256':b.digest(raw)}
 assert ref in prep['artifacts']
 artifact_records.append({'name':name,'artifact':ref,'count':counts[name],'receipt_category':primary[name],'bindings_and_payload_exact':True})
assert len(prep['artifacts'])==len(artifact_records)==8
complete=b.validate_proposed(proposed,context,checker,reader)
assert complete==prep['complete_proposed_evidence_checks'] and all(complete.values())
assert checker.cross_gate_state(R,organization)==cross_before
construction_evidence=[]
for label in ['final-material-choice-request-80f5','final-material-choice-prepare-80f5']:
 exit_path=S/(label+'-exit.json');output_path=S/(label+'-output.txt')
 rec=b.parse(reader.raw(exit_path));raw=reader.raw(output_path,rec['raw_output_sha256'])
 assert type(rec['exit_code']) is int and rec['exit_code']==0
 parsed=b.parse(raw)
 if 'preparation' in parsed:assert parsed['preparation']=={'path':P.relative_to(R).as_posix(),'sha256':P_SHA}
 else:
  assert parsed['request']=={'path':Path(prep['request']['path']).relative_to(R).as_posix(),'sha256':prep['request']['sha256']}
  construction=reader.bound(parsed['construction'])
  assert construction['request_sha256']==prep['request']['sha256'] and construction['prepare_run'] is False and construction['installation_run'] is False
 construction_evidence.append({'label':label,'command':rec['command'],'exit_code':0,'exit_sha256':sha(exit_path),'output_sha256':b.digest(raw)})
reader.unchanged()
context_after=checker.current_context(b.GATE,1)
assert context_after==context and checker.cross_gate_state(R,organization)==cross_before
assert b.GATE.read_bytes()==original and sha(P)==P_SHA and sha(I)==I_SHA
lock=S/'blocked-gate-installation.lock';assert not lock.is_symlink()
assert len(reader.transcript_watches)==1
result={'schema':1,'kind':'independent-actual-blocked-proposal-mechanical-review','status':'MECHANICAL_CHECKS_PASSED',
 'checked_at_utc':datetime.datetime.now(datetime.timezone.utc).isoformat().replace('+00:00','Z'),
 'preparation':{'path':P.relative_to(R).as_posix(),'sha256':P_SHA},'proposal':prep['proposed_gate'],
 'operational_gate_sha256':BASE_SHA,'operational_gate_still_active':True,'actual_current_head':HEAD,
 'actual_bindings':context['bindings'],'preserved_rows':preserved,'changed_rows':changed,'top_level_changed_fields':top_changes,
 'route_record_checks':routes,'substantive_exhaustion_independently_assessed':False,
 'source_projection':request['question_projection'],'live_projection_checked_at_boundaries':True,
 'native_receipts':[{'category':k,'exit':request['receipts'][k]['exit'],'output':request['receipts'][k]['output'],
                     'command':v['command'],'exit_code':v['exit_code'],'input_commit':v.get('input_commit')} for k,v in receipts.items()],
 'native_axioms':axioms,'artifacts':artifact_records,'complete_proposed_evidence_checks':complete,
 'construction_and_preparation_actual_receipts':construction_evidence,
 'cross_gate_state':cross_before,'installer':{'path':I.relative_to(R).as_posix(),'sha256':I_SHA,
 'data_prerequisites_rechecked':True,'lock_acquired':False,'installer_run':False,
 'future_requirements':'Root reviews substantive exhaustion, chooses a fresh label, holds its cooperative lock and repeats all current input/context/projection/cross-gate checks at installation. This check grants no installation authority.'},
 'input_files':[{'path':str(p),'sha256':h} for p,h in sorted(reader.observed.items())],
 'writes':'Only this new review directory','new_audit_or_native_build_run':False,'terminal_verdict_asserted':False,'source_acceptance':False}
with (H/'verification.json').open('xb') as out:out.write(b.encode(result))
print(json.dumps({'phase':'complete','verified_input_files':len(reader.observed),'verification_sha256':sha(H/'verification.json'),
 'operational_gate_unchanged':True,'installer_run':False,'terminal_claim':False}),flush=True)
