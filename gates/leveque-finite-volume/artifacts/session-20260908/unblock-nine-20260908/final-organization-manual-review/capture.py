"""Read-only POSIX Git/source capture for the independent organization review."""
from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,os,re,subprocess,sys
assert os.name!='nt','Use the unchanged POSIX launcher'
P=Path(__file__).resolve().parent
R=next(p for p in P.parents if (p/'lean-toolchain').is_file())
A='9e2225705fed906b1120d55105d607baabef57c9'
sha=lambda b:hashlib.sha256(b).hexdigest()
ref=lambda p:dict(path=p.relative_to(R).as_posix(),sha256=sha(p.read_bytes()))
commands=[]
def git(label,args):
 cmd=['git','--no-optional-locks','-c','core.longpaths=true',*args]
 result=subprocess.run(cmd,cwd=R,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
 with (P/(label+'.stdout.bin')).open('xb') as f:f.write(result.stdout)
 with (P/(label+'.stderr.txt')).open('xb') as f:f.write(result.stderr)
 commands.append(dict(command=cmd,exit_code=result.returncode,stdout=ref(P/(label+'.stdout.bin')),stderr=ref(P/(label+'.stderr.txt'))))
 assert result.returncode==0,(label,result.stderr)
 return result.stdout
head=git('head',['rev-parse','HEAD']).decode().strip()
anchor=git('anchor',['rev-parse',A]).decode().strip();assert anchor==A
anchor_raw=git('anchor-changed',['diff','--name-only','-z',A,'--','ComputationalMathematics','NumStability','docs/architecture/tiers.json'])
staged_raw=git('staged-changed',['diff','--cached','--name-only','-z','--','ComputationalMathematics','NumStability','docs/architecture/tiers.json'])
untracked=git('untracked-source',['ls-files','--others','--exclude-standard','-z','--','ComputationalMathematics','NumStability'])
anchor_names=sorted({x.decode() for x in anchor_raw.split(b'\0')+untracked.split(b'\0') if x})
staged_names=sorted(x.decode() for x in staged_raw.split(b'\0') if x)
def details(path):
 p=R/path;assert p.is_file() and not p.is_symlink(),path
 raw=p.read_bytes();text=raw.decode('utf-8')
 return {**ref(p),'lines':len(text.splitlines()),
  'imports':re.findall(r'^(?:public\s+)?import\s+(\S+)',text,re.M) if path.endswith('.lean') else [],
  'declarations':re.findall(r'^(?:(?:noncomputable|protected|private|unsafe)\s+)*(?:def|abbrev|structure|class|theorem|lemma|instance|axiom|constant)\s+([^\s(:{]+)',text,re.M) if path.endswith('.lean') else [],
  'module_doc':('/-!' in text) if path.endswith('.lean') else None}
source=[details(x) for x in anchor_names]
staged=[x for x in source if x['path'] in staged_names]
assert set(staged_names)<=set(anchor_names)
all_modules={p.relative_to(R).as_posix()[:-5].replace('/','.'):p for root in ('ComputationalMathematics','NumStability') for p in (R/root).rglob('*.lean')}
chapter=[p for name,p in all_modules.items() if name.startswith(('ComputationalMathematics.Source.LeVeque.Chapter01','NumStability.Source.LeVeque.Chapter01'))]
closure=set(chapter+[R/x['path'] for x in source if x['path'].endswith('.lean') and x['path']!='ComputationalMathematics/Analysis.lean'])
todo=list(closure)
while todo:
 p=todo.pop()
 for m in re.findall(r'^(?:public\s+)?import\s+(\S+)',p.read_text(),re.M):
  if m in all_modules and all_modules[m] not in closure:
   closure.add(all_modules[m]);todo.append(all_modules[m])
closure_pins=[ref(p) for p in sorted(closure)]
assert git('head-final',['rev-parse','HEAD']).decode().strip()==head
assert all(sha((R/x['path']).read_bytes())==x['sha256'] for x in source+closure_pins)
output={'schema':1,'status':'read-only-review-snapshot','observed_at_utc':datetime.now(timezone.utc).isoformat(),
 'anchor':A,'head':head,'commands':commands,'anchor_changed_paths':source,'staged_changed_paths':staged,
 'anchor_lean_count':sum(x['path'].endswith('.lean') for x in source),
 'staged_lean_count':sum(x['path'].endswith('.lean') for x in staged),
 'chapter_and_changed_dependency_closure':closure_pins,'single_aggregate_exposure_boundary':'ComputationalMathematics/Analysis.lean',
 'current_sources_unchanged_during_capture':True,'source_acceptance':False,'operational_measurement':False}
with (P/'snapshot.json').open('x',encoding='utf-8',newline='\n') as f:f.write(json.dumps(output,indent=2)+'\n')
print(json.dumps({'snapshot':ref(P/'snapshot.json'),'head':head,'anchor_lean_count':output['anchor_lean_count'],
 'staged_lean_count':output['staged_lean_count'],'chapter_dependency_count':len(closure)},indent=2))
