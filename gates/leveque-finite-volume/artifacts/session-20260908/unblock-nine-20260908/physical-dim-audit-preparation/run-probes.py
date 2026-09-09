"""Run five split native probes against a successful hash-pinned canonical build."""
from pathlib import Path
import datetime,hashlib,json,os,re,shutil,subprocess,sys
P=Path(__file__).resolve().parent;R=P.parent.parents[4]
def disk(p):return Path('\\\\?\\'+str(p.resolve()))
def read(p):return disk(p).read_bytes()
def ref(p):
 b=read(p);return {'path':p.relative_to(R).as_posix() if p.is_relative_to(R) else str(p),
  'sha256':hashlib.sha256(b).hexdigest(),'bytes':len(b)}
def now():return datetime.datetime.now(datetime.timezone.utc).isoformat()
args=[x for x in sys.argv[1:] if x!='--child']
assert len(args)==2
source_tag,tag=args
assert re.fullmatch(r'probe-sources-[0-9]+',source_tag) and re.fullmatch(r'native-[0-9]+',tag)
build=R/'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/physical-production-promotion/owners-native-03-receipt.json'
assert ref(build)['sha256']=='662dfeb7725a719f41547caab64d62b321a4c6642ae4712fbd2d5de2b58d0abb'
assert json.loads(read(build))['actual_exit_code']==0
if '--child' not in sys.argv:
 raise SystemExit(subprocess.run(['C:/Users/qed_s/.elan/bin/lake.EXE','env',sys.executable,'-X','utf8','-B',
   str(P/'run-probes.py'),'--child',source_tag,tag],cwd=R).returncode)
OUT=P/tag;assert not disk(OUT).exists();disk(OUT).mkdir()
def js(name,data):disk(OUT/name).write_text(json.dumps(data,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
inventory_path=P/source_tag/'probe-inventory.json';inventory=json.loads(read(inventory_path))
lean=Path(shutil.which('lean'));assert lean.is_file()
assert ref(lean)['sha256']=='58da8685e404b9ad5bf7a5aadbe8fa4d3856d0d37feb61186a577171340dfd81'
env=os.environ.copy();assert env.get('LEAN_PATH')
pins={str(p):p for p in [build,P/'run-probes.py',inventory_path,P/source_tag/'preparation-receipt.json',
 R/'lean-toolchain',R/'lake-manifest.json',lean]}
modules=set()
def collect(module):
 if module in modules:return
 modules.add(module)
 if module.startswith('ComputationalMathematics.'):
  base=R;lib=R/'.lake/build/lib/lean'
 elif module.startswith('Mathlib.') or module=='Mathlib':
  base=R/'.lake/packages/mathlib';lib=base/'.lake/build/lib/lean'
 else:return
 p=base/(module.replace('.','/')+'.lean');q=lib/(module.replace('.','/')+'.olean')
 assert disk(p).is_file() and disk(q).is_file(),module
 pins[str(p)]=p;pins[str(q)]=q
 for line in read(p).decode('utf-8-sig').splitlines():
  m=re.fullmatch(r'\s*(?:(?:public|private)\s+)?import\s+([\w.]+)\s*',line)
  if m:collect(m.group(1))
for owner in inventory['current_owners']:
 p=R/owner['file']['path'];assert ref(p)==owner['file'];pins[str(p)]=p
for g in inventory['groups']:
 p=R/g['input']['path'];assert ref(p)==g['input'];pins[str(p)]=p
 disk(OUT/(g['file']+'.snapshot')).write_bytes(read(p))
 for line in read(p).decode().splitlines():
  m=re.fullmatch(r'import\s+([\w.]+)',line)
  if m:collect(m.group(1))
before=[ref(p) for p in pins.values()];js('inputs-before.json',before)
js('environment.json',{'LEAN_PATH':env['LEAN_PATH'],'lean':ref(lean),'module_count':len(modules),
 'root_build':ref(build),'source_inventory':ref(inventory_path),
 'closure_scope':'Current literal project/Mathlib sources and oleans; other package identities via environment and lake manifest.'})
results=[]
for g in inventory['groups']:
 source=R/g['input']['path'];stem=Path(g['file']).stem
 command=[str(lean),str(disk(source))];start=now()
 result=subprocess.run(command,cwd=R,env=env,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
 disk(OUT/(stem+'-output.txt')).write_bytes(result.stdout)
 disk(OUT/(stem+'-stderr.txt')).write_bytes(result.stderr)
 record={'command':command,'started_at_utc':start,'finished_at_utc':now(),'actual_exit_code':result.returncode,
  'input':ref(source),'output':ref(OUT/(stem+'-output.txt')),'stderr':ref(OUT/(stem+'-stderr.txt')),
  'expected_axiom_reports':g['expected_axiom_reports'],'proofs_printed':False}
 js(stem+'-receipt.json',record);results.append(record)
 print(json.dumps({'group':stem,'exit':result.returncode,'bytes':len(result.stdout)}),flush=True)
after=[ref(p) for p in pins.values()];js('inputs-after.json',after)
code=max(x['actual_exit_code'] for x in results)
if before!=after:code=2
js('receipt.json',{'actual_exit_code':code,'groups':results,'inputs_unchanged':before==after,
 'inputs_before':ref(OUT/'inputs-before.json'),'inputs_after':ref(OUT/'inputs-after.json'),
 'environment':ref(OUT/'environment.json'),'source_acceptance':False,'sealed_preparation':False,
 'status':'raw native captures; proof-free coverage and size validation still required'})
print(json.dumps({'receipt':ref(OUT/'receipt.json'),'actual_exit_code':code,'inputs_unchanged':before==after},indent=2),flush=True)
raise SystemExit(code)
