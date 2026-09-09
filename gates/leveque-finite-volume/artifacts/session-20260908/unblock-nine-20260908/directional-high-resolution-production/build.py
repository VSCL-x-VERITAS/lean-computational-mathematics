from pathlib import Path
import subprocess,hashlib,json,sys,time
P=Path(__file__).resolve().parent;R=P.parents[5]
label=sys.argv[1]
out=P/(label+'-output.txt');rec=P/(label+'-receipt.json')
assert not out.exists() and not rec.exists()
manifest=json.loads((P/'initial-placement.json').read_text())
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
pin=lambda p:{'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
pre=[pin(R/f['path']) for f in manifest['files']]
cmd=['C:/Users/qed_s/.elan/bin/lake.EXE','build']+[f['module'] for f in manifest['files']]
t=time.monotonic()
with out.open('xb') as h: p=subprocess.run(cmd,cwd=R,stdout=h,stderr=subprocess.STDOUT)
record={'command':cmd,'actual_exit_code':p.returncode,'elapsed_ms':int((time.monotonic()-t)*1000),
    'input_sources':pre,'sources_unchanged':all(sha(R/f['path'])==f['sha256'] for f in pre),
    'output':pin(out),'runner':pin(Path(__file__))}
rec.write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8',newline='\n')
print(json.dumps({'receipt':pin(rec),'actual_exit_code':p.returncode},indent=2))
if p.returncode: print(out.read_text(encoding='utf-8-sig'))
sys.exit(p.returncode)
