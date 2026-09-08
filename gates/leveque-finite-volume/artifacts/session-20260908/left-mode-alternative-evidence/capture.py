"""Native scratch-only capture: preserve every input, command, output and exit."""
from pathlib import Path
import hashlib, json, os, shutil, subprocess, sys, time
D = Path(__file__).resolve().parent
R = D.parents[4]
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
def bound(p): return {'path': str(p.relative_to(R)).replace('\\','/'), 'sha256': sha(p)}
assert os.name == 'nt'
mode, label = sys.argv[1:3]
assert label.replace('-', '').isalnum()
out, receipt = D/(label+'.txt'), D/(label+'.json')
assert not out.exists() and not receipt.exists()
if mode == 'lean':
    src = D/'Candidate.lean'
    snapshot = D/(label+'-input.lean')
    assert not snapshot.exists()
    snapshot.write_bytes(src.read_bytes())
    argv = [shutil.which('lake'), 'env', 'lean', str(src.relative_to(R))]
elif mode == 'search':
    argv = ['rg', *sys.argv[3:]]
else:
    raise ValueError(mode)
head = subprocess.check_output(['git','-c','core.longpaths=true','rev-parse','HEAD'],cwd=R,text=True).strip()
start = time.monotonic()
with out.open('wb') as f:
    run = subprocess.run(argv,cwd=R,stdout=f,stderr=subprocess.STDOUT)
rec = {'argv':argv,'cwd':str(R),'exit_code':run.returncode,'elapsed_ms':int((time.monotonic()-start)*1000),'input_commit':head,'output':bound(out)}
if mode == 'lean': rec['input'] = bound(snapshot)
receipt.write_text(json.dumps(rec,indent=2)+'\n',encoding='utf-8',newline='\n')
print(json.dumps(rec))
if run.returncode or mode == 'search': sys.stdout.buffer.write(out.read_bytes())
raise SystemExit(run.returncode)
