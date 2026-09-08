"""Root check of reviewed Cartesian/source alternatives, literal vector witness and interface capstone."""
from pathlib import Path
import hashlib,json,re
S=Path(__file__).resolve().parent;R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();read=lambda p:json.loads(p.read_bytes())
def resolve(s):
 s=s.replace('\\','/')
 s=re.sub(r'/+','/',s)
 if s.startswith('/c/'):s='C:/'+s[3:]
 p=Path(s)
 return p if p.is_absolute() else R/p
pins={'batch9-capstone-independent-review/final-receipt.json':'07ab55552e61c38dff7834dbf70d646c5b39575e856a406d07376d6dee266ba9',
 'density-capstone-vector-nonvacuity-draft/final-receipt.json':'57b809812d28a4762f31988f376fd2d5ec7de3760c6d8e5d7f74c1dd060473ac',
 'returned-field-interface-capstone-draft/final-receipt.json':'1798dd8a604a97e419723b1a7063ff25f3ededf2b0549ad473b008db1f76c161'}
bindings=[]
def walk(x):
 if isinstance(x,dict):
  if isinstance(x.get('path'),str) and isinstance(x.get('sha256'),str):
   p=resolve(x['path']);assert sha(p)==x['sha256'],x;bindings.append((str(p),x['sha256']))
  for y in x.values():walk(y)
 elif isinstance(x,list):
  for y in x:walk(y)
for p,h in pins.items():assert sha(S/p)==h,p;walk(read(S/p))
for p in ['batch9-capstone-independent-review/verification.json',
 'returned-field-interface-capstone-draft/manifest.json']:
 walk(read(S/p))
def axiom_reports(path,count):
 raw=path.read_text(encoding='utf-8')
 assert not re.search(r'\b(?:warning|error):|sorryAx',raw)
 reports=[]
 for name,ax in re.findall(r"'([^']+)' (?:depends on axioms:\s*\[([^\]]*)\]|does not depend on any axioms)",raw):
  name=re.sub(r'\.\{[^}]*\}$','',name)
  axioms=[re.sub(r'\.\{[^}]*\}$','',x.strip()) for x in ax.split(',') if x.strip()]
  assert set(axioms)<={'propext','Classical.choice','Quot.sound'},(name,axioms)
  reports.append({'declaration':name,'axioms':axioms})
 assert len(reports)==count,(str(path),len(reports),count)
 return reports
review=read(S/'batch9-capstone-independent-review/final-receipt.json')
actual=[]
for a in review['independent_replays']:
 n=read(resolve(a['receipt']['path']));walk(n)
 assert type(n['exit_code']) is int and n['exit_code']==0 and n['source_unchanged']
 assert sha(resolve(n['source']))==n['source_sha256_before']==n['source_sha256_after']
 assert n['command'][:3]==['C:/Users/qed_s/.elan/bin/lake.exe','env','lean']
 assert resolve(n['command'][3])==resolve(n['source'])
 assert sha(resolve(n['output']))==n['output_sha256']
 reports=axiom_reports(resolve(n['output']),a['axiom_report_count'])
 actual.append({'label':a['label'],'actual_exit':0,'output_sha256':n['output_sha256'],'axiom_reports':len(reports)})
assert sum(a['axiom_reports'] for a in actual)==67
d=read(S/'density-capstone-vector-nonvacuity-draft/final-receipt.json')
n=read(resolve(d['actual_native_receipt']['path']));walk(n)
assert type(n['exit_code']) is int and n['exit_code']==0 and n['source_unchanged'] and n['dependencies_unchanged']
assert sha(resolve(n['source']))==n['source_sha256_before']==n['source_sha256_after']==d['checked_source']['sha256']
assert resolve(n['command'][3])==resolve(n['source'])
assert sha(resolve(n['output']))==n['output_sha256']==d['native_output']['sha256']
assert resolve(d['exact_frozen_base']['path']).read_bytes() in resolve(n['source']).read_bytes()
assert resolve(d['fragment']['path']).read_bytes() in resolve(n['source']).read_bytes()
reports=axiom_reports(resolve(n['output']),26)
assert reports==d['axiom_reports'] and len(d['checked_new_declarations'])==10
interface=read(S/'returned-field-interface-capstone-draft/final-receipt.json')
n=read(resolve(interface['native_receipt']['path']));walk(n)
assert type(n['exit_code']) is int and n['exit_code']==0 and n['inputs_unchanged']
assert sha(resolve(interface['native_output']['path']))==n['output_sha256']
assert resolve(interface['candidate']['path']).read_bytes() in resolve(n['command'][3]).read_bytes()
for group in ['input_files','compiled_imports']:
 for path,h in n[group].items():assert sha(resolve(path))==h,path
axiom_reports(resolve(interface['native_output']['path']),7)
data={'schema':1,'status':'PASS','source_acceptance':False,'pins':pins,'bindings_verified':len(bindings),
 'unique_paths':len({p for p,h in bindings}),'independent_replays':actual,
 'density_new_declarations':10,'density_axiom_reports':26,'interface_declarations':7,
 'root_review':'Root read full Cartesian composition and prospective density/material/Riemann capstones, exact real-measure review, complete vector witness and complete returned-field interface capstone. No mathematical correction to stated scopes. The Fin 1 witness literally applies the full positive-dimensional density capstone and derives nonconservation for both production and depletion. The interface execution and conditional accuracy premises remain separate.',
 'retained_limits':['Unanswered source interpretation choices are not adopted.',
  'Prospective earlier mutable source versions were not snapshotted; final exact bytes have independent native replays.',
  'Separate observed canonical build entry is not promoted to a raw build receipt.',
  'Total exact/time-one Cartesian solver restriction has a separately actionable admitted-method repair in progress.',
  'Full returned-field/all-real method restriction has a separately actionable information-only alternative in progress.']}
out=S/'root-batch9-capstone-evidence-verification.json'
with out.open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(data,indent=2)+'\n')
print(json.dumps({'status':'PASS','sha256':sha(out),'bindings':len(bindings),'unique_paths':data['unique_paths'],
 'native_axiom_reports':100,'source_acceptance':False}))
