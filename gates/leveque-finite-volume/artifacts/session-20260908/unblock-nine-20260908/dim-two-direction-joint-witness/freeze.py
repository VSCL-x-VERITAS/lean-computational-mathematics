from pathlib import Path
import datetime,hashlib,json,re
h=Path(__file__).resolve().parent
r=next(p for p in h.parents if (p/'lean-toolchain').is_file())
def read(p):return Path('\\\\?\\'+str(p.resolve())).read_bytes()
def ref(p):
 b=read(p);return {'path':str(p),'sha256':hashlib.sha256(b).hexdigest(),'bytes':len(b)}
def write(name,value):
 p=h/name
 if p.exists():raise SystemExit('Refusing overwrite: '+str(p))
 p.write_text(json.dumps(value,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
receipt=json.loads(read(h/'native-05/receipt.json'))
assert receipt['actual_exit_code']==0 and receipt['inputs_unchanged']
for item in receipt['inputs_after']:assert ref(Path(item['path']))['sha256']==item['sha256'],item['path']
assert read(h/'Candidate.lean')==read(h/'native-05/Candidate.lean.snapshot')
raw=read(h/'native-05/output.txt');output=raw.decode('utf-8')
assert 'sorryAx' not in output and ': error' not in output and ': warning' not in output
decls=json.loads(read(h/'declarations.json'))['declarations']
records=[];cursor=0
for decl in decls:
 name=decl['name'];start=raw.find(name.encode(),cursor)
 assert start>=cursor
 marker=("'"+name+"' ").encode();apos=raw.find(marker,start);assert apos>=start
 end=raw.find(b'\n',apos)
 if end<0:end=len(raw)
 else:end+=1
 statement=raw[start:apos]
 axiomline=raw[apos:end].decode().strip()
 if 'does not depend on any axioms' in axiomline:axioms=[]
 else:
  match=re.fullmatch(re.escape("'"+name+"' depends on axioms: ")+r'\[(.*)\]',axiomline)
  assert match,axiomline
  axioms=[x.strip() for x in match.group(1).split(',') if x.strip()]
 assert set(axioms)<={'propext','Classical.choice','Quot.sound'}
 records.append({**decl,'type_span':{'start_byte':start,'end_byte':apos,'sha256':hashlib.sha256(statement).hexdigest(),'exact_text':statement.decode()},'axioms':axioms})
 cursor=end
assert len(records)==52
write('proof-free-native-types.json',{'format':'proof-free-native-types-1','output':ref(h/'native-05/output.txt'),'records':records})
native_tools=[Path('C:/Users/qed_s/.elan/bin/lake.EXE'),Path('C:/Users/qed_s/.elan/toolchains/leanprover--lean4---v4.29.0-rc3/bin/lean.exe')]
write('verification.json',{'verified_at_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
 'actual_exit_code':0,'authored_declarations':52,'all_axioms_allowed':True,'warnings':0,
 'source_and_compiled_input_bindings':len(receipt['inputs_after']),'all_inputs_still_exact':True,
 'native_tools_observed_at_freeze':[ref(p) for p in native_tools],
 'candidate':ref(h/'Candidate.lean'),'native_receipt':ref(h/'native-05/receipt.json'),
 'native_output':ref(h/'native-05/output.txt'),'proof_free_types':ref(h/'proof-free-native-types.json'),
 'status':'Current-canonical applicability only; mandatory fresh replay after pending C-infinity repair; no source acceptance.'})
write('manifest.json',{'format':'two-direction-joint-applicability-manifest-1','files':[ref(p) for p in sorted(h.rglob('*')) if p.is_file()],
 'scope':'New scratch folder only; all prior failures retained; canonical/source/audit/gate/Git unchanged.'})
write('final-receipt.json',{'format':'two-direction-joint-applicability-receipt-1','created_at_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
 'status':'FROZEN current-canonical native0; pending C-infinity replay',
 'manifest':ref(h/'manifest.json'),'candidate':ref(h/'Candidate.lean'),'verification':ref(h/'verification.json'),
 'review':ref(h/'REVIEW.md'),'native_receipt':ref(h/'native-05/receipt.json'),'declarations':ref(h/'declarations.json'),
 'source_acceptance':False,'production_changes':False,'operational_audit_launched':False,
 'main_declarations':['DIMTwoDirectionJointWitness.full_application','DIMTwoDirectionJointWitness.joint_applicability',
 'DIMTwoDirectionJointWitness.first_stage_moves','DIMTwoDirectionJointWitness.second_stage_moves','DIMTwoDirectionJointWitness.numerical_flux_nonzero']})
print(json.dumps({'receipt':ref(h/'final-receipt.json'),'manifest':ref(h/'manifest.json'),'candidate':ref(h/'Candidate.lean'),'verification':ref(h/'verification.json')},indent=2))
