from pathlib import Path
import datetime,hashlib,json,re,sys
h=Path(__file__).resolve().parent
r=next(p for p in h.parents if (p/'lean-toolchain').is_file())
tag=sys.argv[1]
def read(p):return Path('\\\\?\\'+str(p.resolve())).read_bytes()
def ref(p):
 b=read(p);return {'path':str(p),'sha256':hashlib.sha256(b).hexdigest(),'bytes':len(b)}
def write(name,value):
 p=h/name
 if p.exists():raise SystemExit('Refusing overwrite: '+str(p))
 p.write_text(json.dumps(value,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
receipt=json.loads(read(h/tag/'receipt.json'))
assert receipt['actual_exit_code']==0 and receipt['inputs_unchanged']
for item in receipt['inputs_after']:assert ref(Path(item['path']))['sha256']==item['sha256'],item['path']
assert read(h/'Candidate.lean')==read(h/tag/'Candidate.lean.snapshot')
raw=read(h/tag/'output.txt');out=raw.decode()
assert 'sorryAx' not in out and ': error' not in out and ': warning' not in out
decls=json.loads(read(h/'declarations.json'))['declarations']
records=[];cursor=0
for decl in decls:
 name=decl['name'];start=raw.find(name.encode(),cursor);assert start>=cursor,name
 apos=raw.find(("'"+name+"' ").encode(),start);assert apos>=start,name
 end=raw.find(b'\n',apos);end=len(raw) if end<0 else end+1
 statement=raw[start:apos];line=raw[apos:end].decode().strip()
 if 'does not depend on any axioms' in line:axioms=[]
 else:
  match=re.fullmatch(re.escape("'"+name+"' depends on axioms: ")+r'\[(.*)\]',line);assert match,line
  axioms=[x.strip() for x in match.group(1).split(',') if x.strip()]
 assert set(axioms)<={'propext','Classical.choice','Quot.sound'},line
 records.append({**decl,'type_span':{'start_byte':start,'end_byte':apos,'sha256':hashlib.sha256(statement).hexdigest(),'exact_text':statement.decode()},'axioms':axioms})
 cursor=end
assert len(records)==21
write('proof-free-native-types.json',{'format':'proof-free-native-types-1','output':ref(h/tag/'output.txt'),'records':records})
write('verification.json',{'verified_at_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
 'actual_exit_code':0,'authored_declarations':len(records),'warnings':0,'all_axioms_allowed':True,
 'source_and_compiled_input_bindings':len(receipt['inputs_after']),'all_inputs_still_exact':True,
 'native_tools_observed_at_freeze':[ref(Path(p)) for p in ['C:/Users/qed_s/.elan/bin/lake.EXE','C:/Users/qed_s/.elan/toolchains/leanprover--lean4---v4.29.0-rc3/bin/lean.exe']],
 'input_scope':'Recursive canonical source/import closure plus direct Mathlib source/compiled boundary; not a claim of complete upstream declaration closure.',
 'candidate':ref(h/'Candidate.lean'),'native_receipt':ref(h/tag/'receipt.json'),'native_output':ref(h/tag/'output.txt'),
 'proposal':ref(h.parent/'dim-admission-quality-review/receipt.json'),
 'capacity_bridge_manifest':ref(h.parent/'physical-capacity-line-bridge/manifest.json'),
 'proof_free_types':ref(h/'proof-free-native-types.json'),
 'scope':'Inputwise availability and scalar same-dt quantitative witness only; no higher-order or source-acceptance claim.'})
write('manifest.json',{'format':'time-step-admission-manifest-1','files':[ref(p) for p in sorted(h.rglob('*')) if p.is_file()],
 'scope':'New scratch folder only; failed native attempts retained; production/source/audits/gate/Git unchanged.'})
write('final-receipt.json',{'format':'time-step-admission-receipt-1','created_at_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
 'status':'FROZEN bounded native0 slice; higher-order quality and physical projection remain pending',
 'manifest':ref(h/'manifest.json'),'candidate':ref(h/'Candidate.lean'),'verification':ref(h/'verification.json'),
 'review':ref(h/'REVIEW.md'),'future_quality':ref(h/'FUTURE-QUALITY-REQUIREMENTS.md'),
 'native_receipt':ref(h/tag/'receipt.json'),'native_output':ref(h/tag/'output.txt'),'declarations':ref(h/'declarations.json'),
 'source_acceptance':False,'production_changes':False,'audit_launched':False,
 'main_declarations':['TimeStepAdmissionDraft.Domain.jump_available','TimeStepAdmissionDraft.jump_available_with_oscillation',
 'TimeStepAdmissionDraft.CFL1.every_jump_available','TimeStepAdmissionDraft.CFL1.same_step_stability',
 'TimeStepAdmissionDraft.CFL1.oscillation_control','TimeStepAdmissionDraft.CFL1.jump_moves','TimeStepAdmissionDraft.CFL1.nonconstant_jump']})
print(json.dumps({'receipt':ref(h/'final-receipt.json'),'manifest':ref(h/'manifest.json'),'candidate':ref(h/'Candidate.lean'),'verification':ref(h/'verification.json')},indent=2))
