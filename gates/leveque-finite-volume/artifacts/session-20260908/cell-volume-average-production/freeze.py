"""Freeze actual native preservation evidence for two reviewed additive leaves."""
from pathlib import Path
import hashlib,json,re
P=Path(__file__).resolve().parent;S=P.parent;R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
read=lambda p:json.loads(p.read_bytes())
def binding(p):return {'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
assert sha(P/'placement-inputs.json')=='c7791025e50269abd0e74d719651f92dac725b3df5d918e7edf0664a5c4d1c72'
assert sha(P/'comparison-inputs.json')=='318b8cb88eb896af3037e9515b4576afa892e4aa9dbc7cf90b7294f015ec7b62'
m=read(P/'placement-inputs.json');c=read(P/'comparison-inputs.json')
seen=[]
def walk(v):
 if isinstance(v,dict):
  if isinstance(v.get('path'),str) and isinstance(v.get('sha256'),str):
   p=R/v['path'];assert sha(p)==v['sha256'],v;seen.append(v)
  for x in v.values():walk(x)
 elif isinstance(v,list):
  for x in v:walk(x)
walk(m);walk(c)
assert len(c['pairs'])==15 and sum(len(f['declarations']) for f in m['new_files'])==14
assert (R/c['old_candidate']['path']).read_bytes() in (R/c['checked_source']['path']).read_bytes()
receipts=[]
for label,args in [
 ('cell-volume-average-production-build',['lake','--quiet','--log-level=error','build']+[f['module'] for f in m['new_files']]),
 ('cell-volume-average-production-declarations',['lake','env','lean',c['checked_source']['path']])]:
 p=S/(label+'-exit.json');n=read(p);out=S/(label+'-output.txt')
 assert type(n['exit_code']) is int and n['exit_code']==0 and n['argv']==args
 assert n['input_commit']==m['input_commit'] and sha(out)==n['output_sha256']
 assert not re.search(r'\b(?:warning|error):|sorryAx',out.read_text(encoding='utf-8'))
 receipts.append({'receipt':binding(p),'output':binding(out),'elapsed_ms':n['elapsed_ms']})
raw=(S/'cell-volume-average-production-declarations-output.txt').read_text(encoding='utf-8')
reports={}
for old,new in c['pairs']:
 assert raw.count('TYPE_PRESERVED '+old+' => '+new)==1,(old,new)
 assert re.search(r'^'+re.escape(new)+r'(?:\.|\s|:)',raw,re.M),new
 match=re.search(re.escape("'"+new+"' depends on axioms:")+r'\s*\[([^\]]*)\]',raw)
 if match: ax=[re.sub(r'\.\{[^}]*\}$','',x.strip()) for x in match[1].split(',') if x.strip()]
 else:
  assert "'"+new+"' does not depend on any axioms" in raw,new
  ax=[]
 assert set(ax)<={'propext','Classical.choice','Quot.sound'},(new,ax)
 reports[new]=ax
assert 'CHECKED_PRODUCTION_DECLARATIONS 14' in raw and 'CHECKED_COMPOSITION_BRIDGES 1' in raw
data={'schema':1,'status':'PASS','source_acceptance':False,'production_declarations':14,
 'scratch_capstone_bridges':1,'type_comparisons':15,'actual_native_receipts':receipts,
 'production_sources':[{'path':f['path'],'sha256':f['sha256']} for f in m['new_files']],
 'artifacts':[binding(p) for p in sorted(P.iterdir()) if p.is_file() and p.name!='final-receipt.json'],
 'verified_bindings':len(seen),'axiom_reports':reports,
 'review':'Root full-file review and independent read-only code/evidence review found no required fixes. Source averaging choice remains pending.'}
out=P/'final-receipt.json'
with out.open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(data,indent=2)+'\n')
print(json.dumps({'status':'PASS','receipt':binding(out),'production_declarations':14,'scratch_bridges':1}))
