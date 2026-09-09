from pathlib import Path
import datetime,hashlib,json,re
P=Path(__file__).resolve().parent
def disk(p):return Path('\\\\?\\'+str(p.resolve()))
def read(p):return disk(p).read_bytes()
def ref(p):
 b=read(p);return {'path':str(p),'sha256':hashlib.sha256(b).hexdigest(),'bytes':len(b)}
def load(p):return json.loads(read(p))
def check(r):
 p=Path(r['path']);assert ref(p)==r,r;return p
def write(name,obj):
 p=P/name;assert not disk(p).exists(),str(p)
 disk(p).write_text(json.dumps(obj,indent=2)+'\n',encoding='utf-8');return ref(p)
inventory=load(P/'generated-01/declarations.json')
outcomes=[];pins={}
for tag,kind,count in [('native-comparison-01','comparison',56),('native-joint-01','canonical_joint',14)]:
 f=P/tag;r=load(f/'receipt.json');assert r['actual_exit_code']==0 and r['inputs_unchanged']
 before=load(check(r['inputs_before']));after=load(check(r['inputs_after']));assert before==after
 for v in before:
  assert v['path'] not in pins or pins[v['path']]==v
  pins[v['path']]=v
 check(r['environment']);check(r['dependency_receipt']);check(r['native_receipt'])
 native=load(f/'native-receipt.json');assert native['actual_exit_code']==0
 output=read(check(native['output'])).decode();assert not read(check(native['stderr']))
 assert not re.search(r'\berror:|sorryAx',output)
 reported={}
 for name,values in re.findall(r"^'([^']+)' depends on axioms:\s*\[([^\]]*)\]",output,re.M):
  name=re.sub(r'\.\{[^}]*\}','',name)
  ax={x.strip() for x in values.split(',') if x.strip()}
  assert ax<={'propext','Classical.choice','Quot.sound'}
  assert name not in reported;reported[name]=sorted(ax)
 for name in re.findall(r"^'([^']+)' does not depend on any axioms",output,re.M):
  name=re.sub(r'\.\{[^}]*\}','',name)
  assert name not in reported;reported[name]=[]
 names={x['name'] for x in inventory[kind]}
 assert len(names)==count and set(reported)==names
 warnings=re.findall(r'warning:.*?(?=\n\n|\Z)',output,re.S)
 if kind=='comparison':
  assert len(warnings)==2 and all('automatically included section variable(s) unused' in w for w in warnings)
 else:assert not warnings
 outcomes.append({'tag':tag,'receipt':ref(f/'receipt.json'),'native_receipt':ref(f/'native-receipt.json'),
  'output':native['output'],'actual_exit_code':0,'declaration_count':count,'axioms':reported,'warnings':warnings})
for v in pins.values():check(v)
verification=write('verification.json',{'schema':1,'utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
 'native_exits':[0,0],'authored_declarations':70,'unique_current_pins_rechecked':len(pins),
 'all_report_names_exact':True,'axioms_only_allowed':True,'source_acceptance':False,
 'warning_note':'Two comparison-only automatically included unused section-variable warnings; joint has no warnings. No proof failure or retry occurred.'})
files=[ref(p) for p in sorted(P.rglob('*')) if p.is_file() and p.name not in {'manifest.json','final-receipt.json'}]
manifest=write('manifest.json',{'schema':1,'status':'frozen native canonical transport and joint evidence',
 'files':files,'outcomes':outcomes,'verification':verification,'production_written':False,
 'historical_policy':'Historical parents retained verbatim in provenance; current canonical closure bound separately by actual native receipts.',
 'source_comparison':'Latest admitted scratch proposal only; no equivalence to original rejected source target.',
 'specification_technique':'Both complete producers reused after explicit quality/operational transport; Prop proof roundtrips use proof irrelevance.'})
receipt=write('final-receipt.json',{'schema':1,'status':'native transport and canonical joint complete; source audit pending',
 'manifest':manifest,'verification':verification,'native_outcomes':[{k:x[k] for k in ['tag','receipt','actual_exit_code','declaration_count']} for x in outcomes],
 'source_acceptance':False,'production_written':False,'failed_native_attempts':0,'comparison_warning_count':2})
print(json.dumps(receipt,indent=2))
