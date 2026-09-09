"""Assemble pinned frozen inputs and capture a native scratch check only."""
from pathlib import Path
from datetime import datetime, timezone
import hashlib,json,os,re,shutil,subprocess,sys,time
P=Path(__file__).resolve().parent;D=P.parent
R=next(p for p in P.parents if (p/'lean-toolchain').is_file())
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
ref=lambda p:{'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
assert os.name=='nt'
label=sys.argv[1];assert re.fullmatch('native-[0-9]+',label)
out=P/label;out.mkdir()
core=D/'directional-reference-repair/core-final02-CoreChecks.lean'
family=D/'dim-quality-family-witness/Candidate.lean'
geo=D/'finite-cartesian-geometry-draft/Cartesian.lean.fragment'
assert sha(core)=='bf3b8ec8ca39e66c4a41c6dbb9b51f7777ab805a8f6a7bb64749cb7ae9426a6a'
assert sha(family)=='6f081b7c7761447d9a707c49e31567715b20c46c9ac8014ced5203c97fe7acbb'
ct=core.read_text(encoding='utf-8');ft=family.read_text(encoding='utf-8');gt=geo.read_text(encoding='utf-8')
start='namespace NumStability.DirectionalQualityRepair';end='end NumStability.DirectionalQualityRepair'
def block(t):return t[t.index(start):t.index(end)+len(end)]
assert block(ct)==block(ft), 'Copied quality definitions differ'
ft=ft.replace(block(ft),'')
fragment=P/'Fixture.lean.fragment'
text=ct+'\n'+gt+'\n'+ft+'\n'+fragment.read_text(encoding='utf-8')
imports=sorted(set(re.findall(r'^import\s+(\S+)',text,re.M)))
text=re.sub(r'^(?:import|#check|#print axioms)\s+.*\n','',text,flags=re.M)
names=re.findall(r'^(?:noncomputable )?(?:def|theorem|abbrev)\s+([A-Za-z0-9_]+)',fragment.read_text(),re.M)
text='\n'.join('import '+m for m in imports)+'\nset_option maxRecDepth 4000\nset_option maxHeartbeats 1200000\n'+text
text+='\n'+'\n'.join('#check DIMJointPrimaryWitness.'+n+'\n#print axioms DIMJointPrimaryWitness.'+n for n in names)+'\n'
inp=out/'Input.lean';inp.write_text(text,encoding='utf-8',newline='\n')
pins={str(p):ref(p) for p in [core,family,geo,fragment,inp,Path(__file__),R/'lean-toolchain',R/'lake-manifest.json']}
queue=imports[:];seen=set()
while queue:
 m=queue.pop()
 if m in seen:continue
 seen.add(m)
 if m.startswith('ComputationalMathematics.'):
  owner=R/(m.replace('.','/')+'.lean');queue+=re.findall(r'^import\s+(\S+)',owner.read_text(),re.M)
  bases=[owner,R/'.lake/build/lib/lean'/(m.replace('.','/')+'.olean')]
 elif m.startswith('Mathlib.'):
  bases=[R/'.lake/packages/mathlib'/(m.replace('.','/')+'.lean'),R/'.lake/packages/mathlib/.lake/build/lib/lean'/(m.replace('.','/')+'.olean')]
 else:continue
 for p in bases:
  pins[str(p)]=ref(p)
  if p.suffix=='.olean':
   for suffix in ('.private','.server'):
    q=Path(str(p)+suffix)
    if q.exists():pins[str(q)]=ref(q)
lake=shutil.which('lake');assert lake and lake.lower().endswith('lake.exe')
argv=[lake,'env','lean',inp.relative_to(R).as_posix()]
starttime=datetime.now(timezone.utc).isoformat();timer=time.monotonic()
output=out/'output.txt'
with output.open('xb') as stream:result=subprocess.run(argv,cwd=R,stdout=stream,stderr=subprocess.STDOUT)
unchanged=all(sha(Path(p))==v['sha256'] for p,v in pins.items())
receipt={'schema':1,'command':argv,'exit_code':result.returncode,'elapsed_ms':int((time.monotonic()-timer)*1000),
 'started_at_utc':starttime,'finished_at_utc':datetime.now(timezone.utc).isoformat(),
 'input':ref(inp),'output':ref(output),'inputs':list(pins.values()),'inputs_unchanged':unchanged,
 'copied_quality_body_exact':True,'declarations':['DIMJointPrimaryWitness.'+n for n in names],
 'git_invocations':0,'source_acceptance':False}
with (out/'receipt.json').open('x',encoding='utf-8',newline='\n') as f:f.write(json.dumps(receipt,indent=2)+'\n')
print(json.dumps({'receipt':ref(out/'receipt.json'),'exit_code':result.returncode,'inputs_unchanged':unchanged},indent=2))
if result.returncode:print(output.read_text(encoding='utf-8'))
assert unchanged
raise SystemExit(result.returncode)
