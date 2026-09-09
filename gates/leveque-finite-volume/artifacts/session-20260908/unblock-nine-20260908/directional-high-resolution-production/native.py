from pathlib import Path
import hashlib,json,re,subprocess,sys,time
P=Path(__file__).resolve().parent;R=P.parents[5]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
ref=lambda p:{'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
label,filename=sys.argv[1:];out=P/(label+'-output.txt');receipt=P/(label+'-receipt.json')
assert not out.exists() and not receipt.exists()
source=P/filename;snapshot=P/(label+'-'+filename);snapshot.write_bytes(source.read_bytes())
dependencies={};todo=re.findall(r'^import\s+(\S+)',source.read_text(encoding='utf-8'),re.M);seen=set()
while todo:
    mod=todo.pop()
    if mod in seen:continue
    seen.add(mod)
    src=R/(mod.replace('.','/')+'.lean');ole=R/'.lake/build/lib/lean'/(mod.replace('.','/')+'.olean')
    if not src.exists():
        src=R/'.lake/packages/mathlib'/(mod.replace('.','/')+'.lean')
        ole=R/'.lake/packages/mathlib/.lake/build/lib/lean'/(mod.replace('.','/')+'.olean')
    if src.exists():
        for p in (src,ole):assert p.exists(),p;dependencies[str(p)]=ref(p)
        if mod.startswith('ComputationalMathematics.'):
            todo.extend(re.findall(r'^import\s+(\S+)',src.read_text(encoding='utf-8'),re.M))
for name in ('lean-toolchain','lake-manifest.json','lakefile.toml'):
    path=R/name;dependencies[str(path)]=ref(path)
command=['C:/Users/qed_s/.elan/bin/lake.EXE','env','lean',str(snapshot)]
start=time.monotonic()
with out.open('xb') as f:r=subprocess.run(command,cwd=R,stdout=f,stderr=subprocess.STDOUT)
record={'command':command,'actual_exit_code':r.returncode,'elapsed_ms':int((time.monotonic()-start)*1000),
        'source':ref(snapshot),'dependencies':list(dependencies.values()),
        'dependencies_unchanged':all(sha(Path(p))==v['sha256'] for p,v in dependencies.items()),
        'output':ref(out),'runner':ref(Path(__file__))}
receipt.write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8',newline='\n')
print(json.dumps({'receipt':ref(receipt),'actual_exit_code':r.returncode,'output':ref(out)},indent=2))
text=out.read_text(encoding='utf-8-sig')
print(text if r.returncode else 'Native Lean completed with no errors; exact output retained.')
raise SystemExit(r.returncode)
