from pathlib import Path
import hashlib,json,shutil,subprocess,sys,time
P=Path(__file__).resolve().parent
R=next(p for p in P.parents if (p/'lean-toolchain').exists())
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
ref=lambda p:dict(path=p.relative_to(R).as_posix(),sha256=sha(p))
label,mode,*args=sys.argv[1:]
out=P/(label+'-output.txt');rec=P/(label+'-receipt.json');snap=P/(label+'-sources');assert not out.exists() and not rec.exists() and not snap.exists();snap.mkdir()
inv=json.loads((P/'initial-placement.json').read_text());sources=[R/x['path'] for x in inv]
example=R/'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/Examples/PhysicalIntervalSweep.lean'
if example.exists():sources.append(example)
pins=[]
for p in sources:
 q=snap/(str(len(pins))+'.lean');q.write_bytes(p.read_bytes());pins.append(dict(**ref(p),snapshot=q.relative_to(R).as_posix()))
deps={}
for p in sources:
 for l in p.read_text(encoding='utf-8').splitlines():
  if l.startswith('import '):
   mod=l.split()[1];src=R/(mod.replace('.','/')+'.lean');ole=R/'.lake/build/lib/lean'/(mod.replace('.','/')+'.olean')
   if src not in sources:
    for f in (src,ole):
     if f.exists():deps[f.relative_to(R).as_posix()]=ref(f)
for n in ('lean-toolchain','lake-manifest.json','lakefile.toml'):deps[n]=ref(R/n)
argv=[shutil.which('lake'),'build',*args] if mode=='build' else [shutil.which('lake'),'env','lean',*args]
start=time.monotonic()
with out.open('xb') as f:run=subprocess.run(argv,cwd=R,stdout=f,stderr=subprocess.STDOUT)
record=dict(command=argv,actual_exit_code=run.returncode,elapsed_ms=int((time.monotonic()-start)*1000),sources=pins,dependencies=list(deps.values()),sources_unchanged=all(sha(R/x['path'])==x['sha256'] for x in pins),dependencies_unchanged=all(sha(R/x['path'])==x['sha256'] for x in deps.values()),output=ref(out),runner=ref(Path(__file__)))
rec.write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8',newline='\n');print(json.dumps({'receipt':ref(rec),'actual_exit_code':run.returncode,'output':ref(out)},indent=2));print(out.read_text(encoding='utf-8-sig'));raise SystemExit(run.returncode)
