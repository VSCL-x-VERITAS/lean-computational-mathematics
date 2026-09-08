"""Root evidence verification of the completed, unselected left-mode alternative."""
from pathlib import Path
import hashlib,json,re
S=Path(__file__).resolve().parent;R=S.parents[3];P=S/'left-mode-alternative-evidence'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();read=lambda p:json.loads(p.read_bytes())
pins={'final-receipt.json':'836cda5822e090d2a5593b94aa0af698d9a200326146b8bc96e5fb49402433bf',
 'manifest.json':'713e94ef6923e4ff7006d7152a52361a4ed3b89467b0b96a1ac0b45be2875479',
 'Candidate.lean':'9a641179c8cb3c88bed78c3d99e5331968088d2063819b5ebfc07b41bdc5bbe9',
 'verification.json':'02533f36143cfe1e782fff3c2a261e5c6a41c5113166b9afa8c5f9bf8174ecba'}
for p,h in pins.items():assert sha(P/p)==h,p
m=read(P/'manifest.json');v=read(P/'verification.json');f=read(P/'final-receipt.json')
bindings=[]
def walk(x):
 if isinstance(x,dict):
  if isinstance(x.get('path'),str) and isinstance(x.get('sha256'),str):
   p=R/x['path'];assert sha(p)==x['sha256'],x;bindings.append(x)
  for y in x.values():walk(y)
 elif isinstance(x,list):
  for y in x:walk(y)
for d in [m,v,f]:walk(d)
n=read(P/'native03-final.json');walk(n)
assert type(n['exit_code']) is int and n['exit_code']==0
assert n['input_commit']=='6f3a06c80e2b53c947a30aad9d954ba7dbf8e959'
normal=lambda x:re.sub(r'/+','/',x.replace('\\','/')).lower()
assert list(map(normal,n['argv']))==['c:/users/qed_s/.elan/bin/lake.exe','env','lean',normal((P/'Candidate.lean').relative_to(R).as_posix())]
assert (P/'Candidate.lean').read_bytes()==(R/n['input']['path']).read_bytes()
assert (S/'left-mode-domain-draft/candidate.lean').read_bytes() in (P/'Candidate.lean').read_bytes()
names=sum(m['declarations'].values(),[])
assert len(set(names))==len(names)==29 and len(m['declarations']['new_fixture_declarations'])==18
raw=(R/n['output']['path']).read_text(encoding='utf-8')
assert not re.search(r'\b(?:warning|error):|sorryAx',raw)
for name in names:
 assert re.search(r'^'+re.escape(name)+r'(?:\.|\s|:)',raw,re.M),name
 match=re.search(re.escape("'"+name+"' depends on axioms:")+r'\s*\[([^\]]*)\]',raw)
 if match: ax=[re.sub(r'\.\{[^}]*\}$','',x.strip()) for x in match[1].split(',') if x.strip()]
 else:
  assert "'"+name+"' does not depend on any axioms" in raw,name
  ax=[]
 assert set(ax)<={'propext','Classical.choice','Quot.sound'} and ax==v['all_axiom_results'][name],(name,ax)
for a in v['native_attempts']:
 n0=read(R/a['receipt']['path']);walk(n0)
 assert type(n0['exit_code']) is int and n0['exit_code']==a['actual_exit']
 assert n0['input']==a['input'] and n0['output']==a['output']
assert [a['actual_exit'] for a in v['native_attempts']]==[1,0,0]
out=S/'root-batch9-left-alternative-verification.json'
data={'schema':1,'status':'PASS','source_acceptance':False,'pins':pins,
 'bindings_verified':len(bindings),'unique_paths':len({b['path'] for b in bindings}),
 'actual_native_exit':0,'elapsed_ms':n['elapsed_ms'],'native_output_sha256':n['output']['sha256'],
 'checked_declarations':29,'new_fixture_declarations':18,'unchanged_domain_declarations':1,
 'root_review':'Read full mathematical candidate, prospective contract and review. The nonconstant acoustic field has K=rho=1, pressure=x+t, velocity=-(x+t). Absolute-value profiles distinguish rectangle conservation and characteristic geometry from classical solutionhood, without excluding weak acoustic realizations. ContDiff top in the pinned library is analytic omega, a stronger witness regularity than ordinary smoothness. The old general-domain candidate is contained byte-for-byte.',
 'pending_interpretation_call':m['pending_interpretation_call'],
 'next':'Retain source q^2/w^2 ambiguity and the completed explicit-domain alternative pending the recorded user choice; no unchanged source audit replay.'}
with out.open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(data,indent=2)+'\n')
print(json.dumps({'status':'PASS','receipt':out.relative_to(R).as_posix(),'sha256':sha(out),'bindings':len(bindings),'checks':29}))
