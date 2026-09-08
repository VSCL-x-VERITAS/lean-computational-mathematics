"""Verify reviewed six-leaf placement evidence without selecting source contracts."""
from pathlib import Path
import hashlib,json,re
S=Path(__file__).resolve().parent;R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();read=lambda p:json.loads(p.read_bytes())
pins={'cell-volume-average-production/final-receipt.json':'abdeb84c3462b4d94a327e2b690150f98e46201ebe206b63b5c19ae558f3a6bc',
 'returned-field-production/final-receipt.json':'8e9aa4b4c6f2eb47ffdc237ddadc637bc8247c8ddbe3ba88a953f87778b10605'}
seen=[]
def walk(x):
 if isinstance(x,dict):
  if isinstance(x.get('path'),str) and isinstance(x.get('sha256'),str):
   assert sha(R/x['path'])==x['sha256'],x;seen.append(x)
  for y in x.values():walk(y)
 elif isinstance(x,list):
  for y in x:walk(y)
for p,h in pins.items():assert sha(S/p)==h,p;walk(read(S/p))
v=read(S/'cell-volume-average-production/comparison-inputs.json')
f=read(S/'returned-field-production/placement-map.json')
walk(v);walk(f)
files=[]
for a in v['new_files']:
 files.append({'path':a['path'],'module':a['module'],'sha256':a['sha256'],
  'declarations':[d['new'] for d in a['declarations']]})
for path,h in f['source_files'].items():
 files.append({'path':path,'module':path[:-5].replace('/','.'),'sha256':h,
  'declarations':[d['canonical'] for d in f['declaration_map'] if d.get('owner')==path]})
assert len(files)==6 and sum(len(x['declarations']) for x in files)==37
for x in files:x['lines']=len((R/x['path']).read_text(encoding='utf-8').splitlines())
assert len({n for x in files for n in x['declarations']})==37
ax=read(S/'returned-field-production/axiom-verification.json')
for label in ['build01','checks01','compare01']:
 p=S/'returned-field-production'/(label+'-exit.json');n=read(p)
 assert type(n['exit_code']) is int and n['exit_code']==0 and n['inputs_unchanged']
 for path,h in (n['input_files']|n['compiled_imports']).items():assert sha(R/path)==h,path
 rawpath=p.with_name(label+'-output.txt');assert sha(rawpath)==n['output_sha256']
 raw=rawpath.read_text(encoding='utf-8');assert not re.search(r'\b(?:warning|error):|sorryAx',raw)
 if label in ax['reports']:
  for name,expected in ax['reports'][label].items():
   match=re.search(re.escape("'"+name+"' depends on axioms:")+r'\s*\[([^\]]*)\]',raw)
   if match:actual=[re.sub(r'\.\{[^}]*\}$','',x.strip()) for x in match[1].split(',') if x.strip()]
   else:
    assert "'"+name+"' does not depend on any axioms" in raw,name
    actual=[]
   assert actual==expected and set(actual)<={'propext','Classical.choice','Quot.sound'},name
assert len(ax['reports']['checks01'])==23 and len(ax['reports']['compare01'])==73
out=S/'root-batch9-production-placement-verification.json'
data={'schema':1,'status':'PASS','source_acceptance':False,'files':files,'public_authored_declarations':37,
 'source_lines':sum(x['lines'] for x in files),'receipt_pins':pins,'bindings_verified':len(seen),
 'root_review':'Read all six complete sources, comparison generator and full returned-field comparison fragment. Fourteen volume declaration types plus one scratch composition are preserved. The nominal method types have explicit nine-field conversions, both round trips, eighteen projection checks, commuting flux/exact adapters, two error bridges and seventeen valid concrete type identities. Reusable laws, method, conditional estimates and examples have separate semantic owners. No source wrapper or pending interpretation is selected.'}
with out.open('x',encoding='utf-8',newline='') as f0:f0.write(json.dumps(data,indent=2)+'\n')
print(json.dumps({'status':'PASS','sha256':sha(out),'new_files':len(files),'public_authored_declarations':37,'lines':data['source_lines']}))
