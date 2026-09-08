"""Retained native build/check attempts; each label is immutable."""
from pathlib import Path
from datetime import datetime, timezone
import hashlib,json,re,subprocess,sys,time
sys.stdout.reconfigure(encoding='utf-8')
P=Path(__file__).resolve().parent; R=P.parents[4]; S=P.parent
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
label,mode=sys.argv[1:3]; assert re.fullmatch('[a-z0-9-]+',label)
assert mode in ['build','checks','comparisons']
out=P/(label+'-output.txt');receipt=P/(label+'-exit.json')
assert not out.exists() and not receipt.exists()
mp=json.loads((P/'placement-map.json').read_bytes())
draft_manifest=S/'returned-riemann-field-draft/manifest.json'
deps=json.loads(draft_manifest.read_bytes())['dependencies_unchanged']
for d in deps: assert sha(R/d['path'])==d['sha256'],d['path']
sources=[R/x for x in mp['source_files']]
inputs=sources+[R/d['path'] for d in deps]+[P/'run.py',P/'place.py',P/'placement-map.json',draft_manifest,R/mp['draft']['path'],R/mp['root_review']['path']]
for src in sources:
    snapshot=P/(label+'-'+src.stem+'.lean'); assert not snapshot.exists()
    snapshot.write_bytes(src.read_bytes())
    inputs.append(snapshot)
cmd=['C:/Users/qed_s/.elan/bin/lake.exe']
qualified=[x['canonical'] for x in mp['declaration_map'] if x['canonical']]
if mode=='build':cmd+=['build']+mp['modules']
else:
    source=P/(label+'-input.lean'); assert not source.exists()
    prefix=''.join('import '+m+'\n' for m in mp['modules']).encode()
    text=b''
    if mode=='comparisons':
        f=P/'Comparisons.lean.fragment';inputs.append(f)
        text=(R/mp['draft']['path']).read_bytes()+b'\n\n'+f.read_bytes()+b'\n'
    checks='\n'.join(f'#check {x}\n#print axioms {x}' for x in qualified)
    source.write_bytes(prefix+b'\n'+text+checks.encode()+b'\n')
    inputs.append(source)
    cmd+=['env','lean',source.relative_to(R).as_posix()]
hashes={p.relative_to(R).as_posix():sha(p) for p in inputs}
compiled={}
mods=set(mp['modules'] if mode!='build' else [])
for src in sources:mods.update(re.findall(r'^import ([\w.]+)',src.read_text(encoding='utf-8'),re.M))
for mod in sorted(mods):
    if mode=='build' and mod in mp['modules']:continue
    rel=Path(*mod.split('.')).with_suffix('.olean')
    p=R/'.lake/build/lib/lean'/rel
    assert p.is_file(),p
    compiled[p.relative_to(R).as_posix()]=sha(p)
started=datetime.now(timezone.utc).isoformat();tick=time.monotonic()
with out.open('xb') as f: result=subprocess.run(cmd,cwd=R,stdout=f,stderr=subprocess.STDOUT)
unchanged=all(sha(R/x)==h for x,h in (hashes|compiled).items())
record=dict(schema=1,mode=mode,command=cmd,cwd=str(R),started_at_utc=started,completed_at_utc=datetime.now(timezone.utc).isoformat(),elapsed_ms=int(1000*(time.monotonic()-tick)),exit_code=result.returncode,input_files=hashes,compiled_imports=compiled,inputs_unchanged=unchanged,output_sha256=sha(out),checked_declarations=qualified if mode!='build' else [])
receipt.write_bytes((json.dumps(record,indent=2)+'\n').encode())
print(json.dumps(dict(receipt=str(receipt),exit_code=result.returncode,elapsed_ms=record['elapsed_ms'],output_sha256=record['output_sha256'])),flush=True)
if result.returncode:print(out.read_text(encoding='utf-8')[-18000:])
assert unchanged
sys.exit(result.returncode)
