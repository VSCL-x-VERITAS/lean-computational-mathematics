"""Independently bind ten reviewed generic leaves to actual compiled placement evidence."""
from pathlib import Path
import hashlib,json,re,subprocess
S=Path(__file__).resolve().parent;R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();read=lambda p:json.loads(p.read_bytes())
bind=lambda p:{'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
pins={
 'jump-balance-production/placement-manifest.json':'c17d1f2af68964af41d0a7d7453498effbc3da57d438718784b49e9038cb6cc9',
 'jump-balance-production/final-receipt.json':'1a691de9764edc9b89572dd82bbc4f74d5621400952ee631c0ec2875f875b52d',
 'coordinate-line-production/manifest.json':'d93e10ca68d5613f1b6c6b6a1a9ead8997783506e15d6b5543f828ff63d4a282',
 'coordinate-line-production/final-receipt.json':'aeb6893bfed0a59e0e6293dbf23098505ca7cf2cd854f3cb048cb7902097822d',
 'rectangle-riemann-flux-production/final-receipt.json':'c798594bc9965c5c7e7352b88793d1cb9278e2997f4c989ab7baf05cb9a4a8a1'}
seen=set();count=0
def walk(obj):
 global count
 if isinstance(obj,dict):
  if isinstance(obj.get('path'),str) and isinstance(obj.get('sha256'),str):
   p=R/obj['path'];assert sha(p)==obj['sha256'],str(p)
   if 'snapshot' in obj:assert sha(Path(obj['snapshot']))==obj['sha256']
   seen.add(str(p.resolve()));count+=1
  if isinstance(obj.get('input_sha256'),dict):
   for p,h in obj['input_sha256'].items():assert sha(R/p)==h
  for v in obj.values():walk(v)
 elif isinstance(obj,list):
  for v in obj:walk(v)
for name,h in pins.items():assert sha(S/name)==h;walk(read(S/name))
def verify_native(rec,out):
 assert type(rec['exit_code']) is int and rec['exit_code']==0
 assert rec['output_sha256']==sha(out)
 assert type(rec['elapsed_ms']) is int and rec['elapsed_ms']>=0
 command=rec.get('argv',rec.get('command'))
 assert command[0].lower().endswith('lake.exe') or command[0]=='lake'
 walk(rec)
 text=out.read_text(encoding='utf-8-sig');assert not re.search(r'\b(?:error|warning):|sorryAx',text)
 return text
def verify_axioms(text,items):
 for name,expected in items.items():
  found=re.findall(re.escape("'"+name+"' depends on axioms:")+r'\s*\[([^\]]*)\]',text)
  empty=text.count("'"+name+"' does not depend on any axioms")
  assert (len(found),empty) in [(1,0),(0,1)],name
  actual={x.strip() for x in found[0].split(',') if x.strip()} if found else set()
  assert actual==set(expected) and actual<={'propext','Classical.choice','Quot.sound'}
j=read(S/'jump-balance-production/placement-manifest.json')
for run in j['native_receipts']:
 rec=read(R/run['receipt']['path']);assert rec==run['result']
 verify_native(rec,R/run['raw_output']['path'])
verify_axioms((S/'jump-balance-production/declarations01-output.txt').read_text(encoding='utf-8-sig'),j['canonical_axiom_checks'])
verify_axioms((S/'jump-balance-production/comparisons01-output.txt').read_text(encoding='utf-8-sig'),j['comparison_axiom_checks'])
c=read(S/'coordinate-line-production/manifest.json')
for run in c['native_runs']:
 rec=read(R/run['receipt']['path']);assert rec['exit_code']==run['actual_exit']
 verify_native(rec,R/run['output']['path'])
ctext=(S/'coordinate-line-production/declarations-v1-output.txt').read_text(encoding='utf-8-sig')
verify_axioms(ctext,{x['name']:x['axioms'] for x in c['axiom_checks']})
assert ctext.count('TYPE_PRESERVED ')==16 and ctext.count('VALUE_PRESERVED ')==6
f=read(S/'rectangle-riemann-flux-production/final-receipt.json')
for run in f['native_receipts']:
 rec=read(R/run['receipt']['path']);assert rec==run['actual']
 verify_native(rec,R/run['output']['path'])
ftext=(S/'rectangle-riemann-flux-production-declarations-output.txt').read_text(encoding='utf-8-sig')
verify_axioms(ftext,{n:['propext','Classical.choice','Quot.sound'] for n in f['canonical_declarations']})
assert ftext.count('TYPE_PRESERVED ')==3
files=[*j['canonical_files'],*c['new_files'],*f['canonical_files']]
assert len(files)==10 and len({x['module'] for x in files})==10
normalized=[]
for x in files:
 path=R/x['path'];assert sha(path)==x['sha256']
 normalized.append({'module':x['module'],**bind(path),'lines':len(path.read_text(encoding='utf-8').splitlines())})
git=lambda *a:subprocess.check_output(['git','-c','core.longpaths=true',*a],cwd=R)
assert git('rev-parse','HEAD').decode().strip()=='1039d1b103f71c63052002803e46e779776b067d'
assert not git('diff','--name-only','--','ComputationalMathematics','NumStability').strip()
assert set(git('ls-files','--others','--exclude-standard','--','ComputationalMathematics','NumStability').decode().splitlines())=={x['path'] for x in normalized}
record={'schema':1,'input_commit':'1039d1b103f71c63052002803e46e779776b067d','files':sorted(normalized,key=lambda x:x['module']),'native_builds':3,'canonical_declaration_axiom_checks':43,'jump_balance_comparisons':30,'coordinate_type_comparisons':16,'coordinate_definition_value_comparisons':6,'rectangle_method_type_comparisons':3,'bound_occurrences_verified':count,'unique_bound_paths':len(seen),'evidence':[bind(S/p) for p in pins],'old_production_files_unchanged':True,'root_review':'All ten new files and their reviews read. Basic jump topology has no PDE dependency; balance temporal derivative and examples are separate; coordinate sweep imports its executor separately; actual returned Riemann flux comparisons retain explicit domain and error hypotheses. Existing general producers are reused. Source interpretation and new source audits remain pending.','source_acceptance':False}
dest=S/'root-batch8-placement-verification.json'
with dest.open('x',encoding='utf-8',newline='') as out:out.write(json.dumps(record,indent=2)+'\n')
print(json.dumps({'receipt':bind(dest),'files':len(normalized),'canonical_declarations':43,'total_lines':sum(x['lines'] for x in normalized),'bound_occurrences':count,'unique_paths':len(seen)}))
