"""Capture a genuine Lake build of explicitly placed current canonical sources."""
from pathlib import Path
import subprocess, hashlib, json, sys, time, os, re
P=Path(__file__).resolve().parent
R=P.parents[5]
native=lambda p:'\\\\?\\'+os.path.abspath(p) if os.name=='nt' else str(p)
def raw(p):
    with open(native(p),'rb') as stream:return stream.read()
def sha(p):return hashlib.sha256(raw(p)).hexdigest()
def pin(p):return {'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
def put(p,obj):
    with open(native(p),'xb') as stream:stream.write((json.dumps(obj,indent=2)+'\n').encode())
label=sys.argv[1]
assert re.fullmatch(r'[a-z0-9-]+',label)
manifest=P/sys.argv[2]
assert manifest.resolve().is_relative_to(P.resolve())
record=json.loads(raw(manifest))
files=record['actual_changed_files']
assert files and len(files)==len({f['path'] for f in files})
out=P/(label+'-output.txt')
rec=P/(label+'-receipt.json')
assert not out.exists() and not rec.exists()
pre=[]
for item in files:
    path=R/item['path']
    assert path.resolve().is_relative_to(R.resolve()) and path.suffix=='.lean'
    assert sha(path)==item['after_sha256']
    pre.append(pin(path))
command=['C:/Users/qed_s/.elan/bin/lake.EXE','build']+[f['path'][:-5].replace('/','.') for f in files]
start=time.monotonic()
with open(native(out),'xb') as stream:
    result=subprocess.run(command,cwd=R,stdout=stream,stderr=subprocess.STDOUT)
unchanged=all(sha(R/f['path'])==f['sha256'] for f in pre)
receipt={'command':command,'actual_exit_code':result.returncode,
 'elapsed_ms':int((time.monotonic()-start)*1000),'input_sources':pre,
 'placement_receipt':pin(manifest),'sources_unchanged':unchanged,
 'output':pin(out),'runner':pin(Path(__file__)),
 'source_acceptance':False,'proof_placeholder_scan_performed':False}
put(rec,receipt)
print(json.dumps({'receipt':pin(rec),'actual_exit_code':result.returncode,
                  'sources_unchanged':unchanged},indent=2),flush=True)
if result.returncode:print(raw(out).decode('utf-8',errors='replace')[-18000:])
assert unchanged,'canonical source changed during build'
raise SystemExit(result.returncode)
