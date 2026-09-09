from pathlib import Path
import argparse, hashlib, json, shutil, subprocess, time
p=argparse.ArgumentParser();p.add_argument('label');a=p.parse_args()
P=Path(__file__).resolve().parent;R=next(x for x in P.parents if (x/'lean-toolchain').exists())
assert a.label.replace('-','').isalnum()
sha=lambda f:hashlib.sha256(f.read_bytes()).hexdigest()
source=P/'Candidate.lean';snapshot=P/(a.label+'-input.lean');assert not snapshot.exists();snapshot.write_bytes(source.read_bytes())
out=P/(a.label+'-output.txt');receipt=P/(a.label+'-exit.json');assert not out.exists() and not receipt.exists()
lake=shutil.which('lake');assert lake
imports=[line.split()[1] for line in source.read_text(encoding='utf-8').splitlines() if line.startswith('import ')]
dependencies=[]
for mod in imports:
 for f in [R/(mod.replace('.','/')+'.lean'),R/'.lake/build/lib/lean'/(mod.replace('.','/')+'.olean')]:
  assert f.exists(),f
  dependencies.append({'path':f.relative_to(R).as_posix(),'sha256':sha(f)})
argv=[lake,'env','lean',snapshot.relative_to(R).as_posix()]
start=time.monotonic()
with out.open('xb') as f:run=subprocess.run(argv,cwd=R,stdout=f,stderr=subprocess.STDOUT)
record={'command':argv,'actual_exit_code':run.returncode,'elapsed_ms':int((time.monotonic()-start)*1000),
 'input':{'path':snapshot.relative_to(R).as_posix(),'sha256':sha(snapshot)},
 'candidate_sha256':sha(source),'output':{'path':out.relative_to(R).as_posix(),'sha256':sha(out)},
 'dependencies_pre':dependencies,'dependencies_post_equal':all(sha(R/x['path'])==x['sha256'] for x in dependencies),
 'runner_sha256':sha(Path(__file__)),'no_git_invoked':True,'no_production_changed':True}
receipt.write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8',newline='\n')
print(json.dumps(record,indent=2));print(out.read_text(encoding='utf-8',errors='replace'))
raise SystemExit(run.returncode)
