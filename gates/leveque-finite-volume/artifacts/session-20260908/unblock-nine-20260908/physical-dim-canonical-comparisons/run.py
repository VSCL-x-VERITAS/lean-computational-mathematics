"""Native comparison runner; requires an actual hash-pinned successful root build receipt."""
from pathlib import Path
import argparse, datetime, hashlib, json, os, re, shutil, subprocess, sys
HERE=Path(__file__).resolve().parent
R=HERE.parent.parents[4]
def disk(p): return Path('\\\\?\\'+str(p.resolve()))
def read(p): return disk(p).read_bytes()
def ref(p):
    b=read(p)
    return {'path':str(p),'sha256':hashlib.sha256(b).hexdigest(),'bytes':len(b)}
def now(): return datetime.datetime.now(datetime.timezone.utc).isoformat()
ap=argparse.ArgumentParser()
ap.add_argument('--source',required=True)
ap.add_argument('--tag',required=True)
ap.add_argument('--build-receipt',required=True)
ap.add_argument('--build-sha256',required=True)
ap.add_argument('--child',action='store_true')
args=ap.parse_args()
assert re.fullmatch(r'native-[a-z0-9-]+',args.tag)
assert re.fullmatch(r'[0-9a-f]{64}',args.build_sha256)
source=(HERE/args.source).resolve()
assert source.is_relative_to(HERE) and source.suffix=='.lean'
build=(R/args.build_receipt).resolve()
assert build.is_relative_to(R)
build_ref=ref(build)
assert build_ref['sha256']==args.build_sha256, 'root build receipt hash mismatch'
build_data=json.loads(read(build))
assert build_data.get('actual_exit_code')==0, 'expected root receipt actual_exit_code=0'
if not args.child:
    cmd=['C:/Users/qed_s/.elan/bin/lake.EXE','env',sys.executable,'-X','utf8','-B',str(HERE/'run.py'),
         '--child','--source',args.source,'--tag',args.tag,
         '--build-receipt',args.build_receipt,'--build-sha256',args.build_sha256]
    raise SystemExit(subprocess.run(cmd,cwd=R).returncode)
folder=HERE/args.tag
assert not disk(folder).exists(), 'refuse native attempt overwrite'
disk(folder).mkdir()
disk(folder/'Input.lean').write_bytes(read(source))
lean=shutil.which('lean'); assert lean
env=os.environ.copy(); assert env.get('LEAN_PATH')
assert ref(Path(lean))['sha256']=='58da8685e404b9ad5bf7a5aadbe8fa4d3856d0d37feb61186a577171340dfd81'
pins={str(p):p for p in [source,HERE/'run.py',source.parent/'preparation-receipt.json',
     source.parent/'source-provenance.json',source.parent/'declarations.json',
     R/'lean-toolchain',R/'lake-manifest.json',Path(lean),build]}
modules=set()
def collect(module):
    if module in modules: return
    modules.add(module)
    if module.startswith('ComputationalMathematics.'):
        base=R; lib=R/'.lake/build/lib/lean'
    elif module.startswith('Mathlib.') or module=='Mathlib':
        base=R/'.lake/packages/mathlib'; lib=base/'.lake/build/lib/lean'
    else: return
    p=base/(module.replace('.','/')+'.lean')
    q=lib/(module.replace('.','/')+'.olean')
    assert disk(p).is_file(),str(p)
    assert disk(q).is_file(),str(q)
    pins[str(p)]=p; pins[str(q)]=q
    for line in read(p).decode('utf-8-sig').splitlines():
        match=re.fullmatch(r'\s*(?:(?:public|private)\s+)?import\s+([\w.]+)\s*',line)
        if match: collect(match.group(1))
for line in read(source).decode().splitlines():
    match=re.fullmatch(r'\s*import\s+([\w.]+)\s*',line)
    if match: collect(match.group(1))
before=[ref(p) for p in pins.values()]
def js(name,obj): disk(folder/name).write_text(json.dumps(obj,indent=2)+'\n',encoding='utf-8')
js('inputs-before.json',before)
js('environment.json',{'LEAN_PATH':env['LEAN_PATH'],'lean':ref(Path(lean)),
   'module_count':len(modules),'root_build_receipt':build_ref,
   'pin_scope':'Current literal project/Mathlib import-source and olean closure; other package identities via environment/manifest. Historical scratch receipts are provenance only.'})
def capture(name,cmd):
    began=now()
    proc=subprocess.run(cmd,cwd=R,env=env,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
    disk(folder/(name+'-output.txt')).write_bytes(proc.stdout)
    disk(folder/(name+'-stderr.txt')).write_bytes(proc.stderr)
    rec={'command':cmd,'cwd':str(R),'started_at_utc':began,'finished_at_utc':now(),
      'actual_exit_code':proc.returncode,'output':ref(folder/(name+'-output.txt')),
      'stderr':ref(folder/(name+'-stderr.txt'))}
    js(name+'-receipt.json',rec)
    return proc,rec
dep,dr=capture('dependencies',[lean,'--deps',str(disk(source))])
if dep.returncode:
    js('receipt.json',{'actual_exit_code':dep.returncode,'phase':'dependencies','dependency_receipt':ref(folder/'dependencies-receipt.json')})
    raise SystemExit(dep.returncode)
proc,nr=capture('native',[lean,str(disk(source))])
after=[ref(p) for p in pins.values()]
js('inputs-after.json',after)
js('receipt.json',{'actual_exit_code':proc.returncode,'inputs_before':ref(folder/'inputs-before.json'),
   'inputs_after':ref(folder/'inputs-after.json'),'inputs_unchanged':before==after,
   'environment':ref(folder/'environment.json'),'dependency_receipt':ref(folder/'dependencies-receipt.json'),
   'native_receipt':ref(folder/'native-receipt.json'),'source_acceptance':False,
   'scope':'Canonical transport/computational observations or joint applicability, identified by exact input; no historical pin relabeling.'})
print(json.dumps({'actual_exit_code':proc.returncode,'inputs_unchanged':before==after,
     'receipt':ref(folder/'receipt.json'),'output':nr['output']},indent=2))
if proc.returncode:
    print(proc.stdout.decode(errors='replace'))
    print(proc.stderr.decode(errors='replace'))
raise SystemExit(proc.returncode if before==after else 2)
