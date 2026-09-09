from pathlib import Path
import datetime,hashlib,json,re
h=Path(__file__).resolve().parent
def read(p):return Path('\\\\?\\'+str(p.resolve())).read_bytes()
def ref(p):
 b=read(p);return {'path':str(p),'sha256':hashlib.sha256(b).hexdigest(),'bytes':len(b)}
def write(name,value):
 p=h/name
 if p.exists():raise SystemExit('Refusing overwrite')
 p.write_text(json.dumps(value,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
attempt=h/'native-02'
rec=json.loads(read(attempt/'receipt.json'))
assert rec['actual_exit_code']==0 and rec['inputs_unchanged']
for item in rec['inputs_after']:assert ref(Path(item['path']))['sha256']==item['sha256'],item['path']
assert read(h/'Candidate.lean')==read(attempt/'Candidate.lean.snapshot')
raw=read(attempt/'native-output.txt');out=raw.decode()
assert read(attempt/'native-stderr.txt')==b''
assert ': warning' not in out and ': error' not in out and 'sorryAx' not in out
names=json.loads(read(h/'declarations.json'))['declarations']
records=[];cursor=0
for declaration in names:
 name=declaration['name'];start=raw.find(name.encode(),cursor);assert start>=cursor
 apos=raw.find(("'"+name+"' ").encode(),start);assert apos>=start
 end=raw.find(b'\n',apos);end=len(raw) if end<0 else end+1
 line=raw[apos:end].decode().strip()
 if 'depends on axioms: [' in line and not line.endswith(']'):
  close=raw.find(b']',apos);assert close>=apos
  newline=raw.find(b'\n',close);end=len(raw) if newline<0 else newline+1
  line=' '.join(raw[apos:end].decode().split())
 if 'does not depend on any axioms' in line:axioms=[]
 else:
  match=re.fullmatch(re.escape("'"+name+"' depends on axioms: ")+r'\[(.*)\]',line);assert match,line
  axioms=[x.strip() for x in match.group(1).split(',') if x.strip()]
 assert set(axioms)<={'propext','Classical.choice','Quot.sound'}
 statement=raw[start:apos]
 records.append({**declaration,'type_span':{'start_byte':start,'end_byte':apos,'sha256':hashlib.sha256(statement).hexdigest(),'exact_text':statement.decode()},'axioms':axioms})
 cursor=end
assert len(records)==18
assert out.count('CORE_QUALITY_STABILITY_SEPARATE')==1
write('proof-free-native-types.json',{'output':ref(attempt/'native-output.txt'),'records':records})
write('verification.json',{'verified_at_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'actual_exit_code':0,
 'declaration_checks':18,'all_axioms_allowed':True,'warnings':0,'cinfty_rfl_guard_passed':True,
 'core_stability_separation_guard':True,'source_compiled_input_bindings':len(rec['inputs_after']),
 'all_pins_still_exact':True,'overlay':ref(h.parent/'dim-five-owner-overlay/receipt.json'),
 'candidate':ref(h/'Candidate.lean'),'native_receipt':ref(attempt/'receipt.json'),'native_output':ref(attempt/'native-output.txt'),
 'scope':'Read-only frozen C-infinity overlay; interval-only time-step/core-quality repair; no source acceptance.'})
write('manifest.json',{'format':'interval-quality-repair-manifest-1','files':[ref(p) for p in sorted(h.rglob('*')) if p.is_file()]})
write('final-receipt.json',{'format':'interval-quality-repair-receipt-1','created_at_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
 'status':'FROZEN artifact-only interval family and core-quality separation, native0 under frozen C-infinity overlay',
 'manifest':ref(h/'manifest.json'),'candidate':ref(h/'Candidate.lean'),'verification':ref(h/'verification.json'),
 'native_receipt':ref(attempt/'receipt.json'),'native_output':ref(attempt/'native-output.txt'),'review':ref(h/'REVIEW.md'),
 'scope_limit':ref(h.parent/'dim-interval-quality-repair/SCOPE-LIMIT.md'),'declarations':ref(h/'declarations.json'),
 'source_acceptance':False,'production_changes':False,'audit_launched':False})
print(json.dumps({'receipt':ref(h/'final-receipt.json'),'candidate':ref(h/'Candidate.lean'),'verification':ref(h/'verification.json'),'manifest':ref(h/'manifest.json')},indent=2))
