"""Freeze verified small-bias artifacts, retaining all actual failed attempts."""
from pathlib import Path
import hashlib,json,os,re
P=Path(__file__).resolve().parent;D=P.parent;R=P.parents[5]
def n(p):return '\\\\?\\'+str(p)
def raw(p):
 with open(n(p),'rb') as f:return f.read()
def ref(p):
 b=raw(p)
 return {'path':p.relative_to(R).as_posix() if p.is_relative_to(R) else str(p),'sha256':hashlib.sha256(b).hexdigest(),'bytes':len(b)}
def read(p):return json.loads(raw(p))
def put(p,obj):
 b=obj if isinstance(obj,bytes) else (json.dumps(obj,indent=2)+'\n').encode()
 with open(n(p),'xb') as f:f.write(b)
def resolve(item):
 p=Path(item['path']);return p if p.is_absolute() else R/p
A=P/'native-03'
attempts=[];resolutions=[]
for folder in sorted(P.glob('native-*')):
 rec=read(folder/'receipt.json');lean=read(folder/'lean-receipt.json');lake=read(folder/'lake-receipt.json')
 assert rec['exit_code']==lean['exit_code']==lake['exit_code']
 for label in ['lake','deps','lean']:
  cr=read(folder/(label+'-receipt.json'))
  for key in ['stdout','stderr']:
   assert ref(resolve(cr[key]))['sha256']==cr[key]['sha256']
 for item in read(folder/'input-pins.json')['inputs']:
  actual=resolve(item)
  if ref(actual)['sha256']!=item['sha256']:
   assert actual==P/'Bias.lean.fragment',item
   actual=folder/'Bias.lean.fragment'
   assert ref(actual)['sha256']==item['sha256'],item
   assert raw(folder/'Candidate.lean').count(raw(actual))==1
   resolutions.append({'original':item,'same_attempt_snapshot':ref(actual)})
  assert ref(actual)['sha256']==item['sha256']
 attempts.append({'attempt':folder.name,'actual_exit':rec['exit_code'],'receipt':ref(folder/'receipt.json')})
assert read(A/'receipt.json')['exit_code']==0
output=raw(A/'lean-output.txt').decode()
assert not re.search(r'\b(error|warning):|sorryAx|Error pretty printing',output)
reports=[{'name':a,'axioms':re.findall(r'[A-Za-z_][\w.]*',b)} for a,b in re.findall(r"'([^']+)' depends on axioms:\s*\[([^]]*)\]",output,re.S)]
reports += [{'name':a,'axioms':[]} for a in re.findall(r"'([^']+)' does not depend on any axioms",output)]
assert len(reports)==70 and len({x['name'] for x in reports})==70
assert all(set(x['axioms'])<={'propext','Classical.choice','Quot.sound'} for x in reports)
names=read(P/'declarations.json');assert len(names)==12
assert set(names)<={x['name'] for x in reports}
base=D/'capacity-zero-flux-witness/native-01/Candidate.lean'
assert ref(base)['sha256']=='76a0ad0c917b836cfc4de35da405dc103a696a19354846a9f4d9d6cbd2055d74'
assert raw(A/'Candidate.lean').count(raw(base))==1
for item in read(P/'prerequisite-evidence.json')['source_compiled_pairs']:
 assert ref(resolve(item))['sha256']==item['sha256']
put(P/'verification.json',{'schema':1,'status':'PASS','actual_exit':0,'attempts':attempts,
 'historical_fragment_resolutions':resolutions,'final_input':ref(A/'Candidate.lean'),'base':ref(base),
 'declarations':names,'axiom_reports':reports,'source_acceptance':False})
files=[]
for directory,dirs,names in os.walk(n(P)):
 assert '__pycache__' not in dirs
 for name in names:files.append(ref(Path(directory.removeprefix('\\\\?\\'))/name))
put(P/'manifest.json',{'schema':1,'files':sorted(files,key=lambda x:x['path']),'artifact_only':True,'source_acceptance':False})
put(P/'receipt.json',{'schema':1,'status':'PASS','manifest':ref(P/'manifest.json'),'review':ref(P/'REVIEW.md'),
 'verification':ref(P/'verification.json'),'final_input':ref(A/'Candidate.lean'),'fragment':ref(P/'Bias.lean.fragment'),
 'actual_native_receipt':ref(A/'lean-receipt.json'),'actual_exit':0,'new_declarations':12,'axiom_reports':70,
 'empty_axiom_reports':sum(not x['axioms'] for x in reports),'warnings':0,'source_acceptance':False})
print(json.dumps({'receipt':ref(P/'receipt.json'),'manifest':ref(P/'manifest.json'),'input':ref(A/'Candidate.lean'),
 'fragment':ref(P/'Bias.lean.fragment'),'verification':ref(P/'verification.json')},indent=2))
