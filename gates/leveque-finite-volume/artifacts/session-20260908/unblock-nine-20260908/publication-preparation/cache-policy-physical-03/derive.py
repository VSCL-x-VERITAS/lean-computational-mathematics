"""Conservative policy proposal and pure-function tests; no official scan or Git."""
from pathlib import Path, PurePosixPath
import ast, copy, hashlib, json, os, re
P=Path(__file__).resolve().parent;H=P.parent;D=H.parent;R=D.parents[4]
assert os.name!='nt' and R.name=='lean-computational-mathematics'
def digest(p):
 h=hashlib.sha256()
 with p.open('rb') as f:
  for b in iter(lambda:f.read(1024*1024),b''):h.update(b)
 return h.hexdigest()
def ref(p):return {'path':p.relative_to(R).as_posix(),'sha256':digest(p)}
def read(p):return json.loads(p.read_bytes())
def put(p,x):
 with p.open('xb') as f:f.write((json.dumps(x,indent=2)+'\n').encode())
def native_path(s):
 s=s.replace('\\','/')
 if re.match(r'^[A-Za-z]:/',s):s='/'+s[0].lower()+s[2:]
 q=Path(s).resolve();assert q.is_relative_to(R)
 return q
def bound(r):
 q=native_path(r['path']) if re.match(r'^[A-Za-z]:',r['path']) else R/r['path']
 assert q.is_file() and not q.is_symlink() and digest(q)==r['sha256'],r
 if 'bytes' in r:assert q.stat().st_size==r['bytes']
 return q
oldpath=H/'policy-final-physical-02.json'
assert digest(oldpath)=='d522c47acaf32a67309d08a3af1402e61b899ae1c9b4597aa6ace317060a9afa'
old=read(oldpath);new=copy.deepcopy(old)
checker=H/'check-publication-allowlist-v3.py'
assert digest(checker)=='8022f5e367fd9bdb8081e30634b29a038925211e2724a674c2022a380df7adc7'
tree=ast.parse(checker.read_text())
names={'safe_name','disposition','verify_policy'}
nodes=[n for n in tree.body if isinstance(n,ast.FunctionDef) and n.name in names]
assert len(nodes)==3
env={'PurePosixPath':PurePosixPath,'re':re}
exec(compile(ast.Module(body=nodes,type_ignores=[]),str(checker),'exec'),env)
check=env['verify_policy'];classify=env['disposition'];check(old)
receipt_refs=[
 {'path':(D/'ftaylor-options-03/receipt.json').relative_to(R).as_posix(),'sha256':'f194559a364e2e48dd06c7d82298515ce4a41ca5c8abff3e75cf35e6d3716624'},
 {'path':(D/'defs-setup-06/receipt.json').relative_to(R).as_posix(),'sha256':'73e5ba6352fb0f7798c94013fc5b2563649a6d321cc1f038a2a6d6fa9a3a34bc'}]
artifacts=[];sources=[];dependencies=[]
suffixes=('.olean','.ir','.olean.private','.olean.server')
for rr in receipt_refs:
 rp=bound(rr);receipt=read(rp)
 assert receipt['source_modified'] is False
 assert receipt.get('canonical_compiled_outputs_modified',receipt.get('canonical_outputs_modified')) is False
 compile_record=receipt['commands'][-1]
 assert compile_record['exit_code']==0
 assert all(x in compile_record['argv'] for x in ['-DautoImplicit=false','-DmaxSynthPendingDepth=3','-Dpp.unicode.fun=true'])
 assert bound(compile_record['stdout']).read_bytes()==b'' and bound(compile_record['stderr']).read_bytes()==b''
 ip=bound(receipt['inputs']);inputs=read(ip)
 for pin in inputs['pins']:dependencies.append(ref(bound(pin)))
 for item in receipt['scratch_artifacts']:
  q=bound(item);assert q.is_relative_to(rp.parent)
  if q.name.endswith('.lean'):
   sources.append(ref(q));continue
  assert q.name.endswith(suffixes),q
  artifacts.append({'file':ref(q),'bytes':q.stat().st_size,'receipt':rr,
    'actual_compile_exit':compile_record['exit_code'],'old_disposition':classify(q.relative_to(R).as_posix(),old),
    'origin':'Actual isolated exact-source native compilation; cache bytes retained locally.'})
assert len(artifacts)==8 and len(sources)==2
assert len({r['file']['path'] for r in artifacts})==8
for r in artifacts:assert not r['file']['path'].endswith('.lean')
evidence={'schema':1,'status':'VERIFIED_CACHE_ORIGINS_ONLY','publication_complete':False,
 'receipts':receipt_refs,'artifacts':artifacts,'preserved_source_copies':sources,
 'dependency_pins':dependencies,
 'limits':'Frozen two-module compilation outputs only. No census or exclusion of ongoing Laplace overlays; other caches are conservatively held by suffix. No source acceptance or staging authorization.'}
put(P/'cache-evidence.json',evidence)
evidence_ref=ref(P/'cache-evidence.json')
for suffix in ['.ir','.olean.private','.olean.server']:
 assert suffix not in new['generated_cache_suffixes'];new['generated_cache_suffixes'].append(suffix)
for row in artifacts:
 path=row['file']['path'];assert path not in new['exclude_exact']
 new['exclude_exact'][path]='Verified generated scratch cache; preserve locally. File SHA256 '+row['file']['sha256']+'; exact compilation receipt '+row['receipt']['sha256']+'; exclusion evidence '+evidence_ref['path']+' SHA256 '+evidence_ref['sha256']
check(new)
changed=[k for k in old if old[k]!=new[k]]
assert set(changed)=={'generated_cache_suffixes','exclude_exact'}
assert len(new['archives'])==7 and new['archives']==old['archives']
assert sum(x.startswith('ComputationalMathematics/') for x in new['allow_exact'])==59
assert new['allow_exact']==old['allow_exact'] and new['allow_prefixes']==old['allow_prefixes']
tests=[]
def test(label,path,want):
 actual=classify(path,new)[0];assert actual==want,(label,path,want,actual)
 tests.append({'label':label,'path':path,'expected':want,'actual':actual})
for x in artifacts:test('verified actual cache exclusion',x['file']['path'],'exclude')
for x in sources:test('exact source copy stays eligible',x['path'],'select')
prefix=D.relative_to(R).as_posix()+'/ongoing-unverified-probe/'
for suffix in new['generated_cache_suffixes']:test('unverified cache stays held',prefix+'Example'+suffix,'hold')
for suffix in ['.lean','.lean.fragment','.lean.snapshot','.json','.txt']:
 test('noncache evidence unchanged',prefix+'Example'+suffix,'select')
test('embedded suffix does not exclude Lean source',prefix+'Example.ir.lean','select')
for path in old['allow_exact']:
 assert classify(path,new)==classify(path,old),path
 tests.append({'label':'existing exact allow disposition unchanged','path':path,'actual':classify(path,new)[0]})
for entry in old['archives']:
 assert digest(bound(entry['receipt']))==entry['receipt']['sha256']
 bound(entry['archive'])
 test('all seven archives remain selected',entry['archive']['path'],'select')
 test('all seven raw streams stay excluded',entry['raw']['path'],'exclude')
test('unsafe path held','../outside.ir','hold')
test('unowned path stays excluded','unowned-diagnostic.txt','exclude')
policy_path=H/'policy-final-physical-03.json';put(policy_path,new)
put(P/'field-diff.json',{'original':ref(oldpath),'proposal':ref(policy_path),
 'changed_fields':changed,'added_hold_suffixes':['.ir','.olean.private','.olean.server'],
 'added_exact_exclusions':[x['file'] for x in artifacts],'unchanged_fields':[k for k in old if k not in changed],
 'selection_monotonicity':'Both changed fields can only replace a prior disposition with exclude or hold; neither adds a select branch.'})
put(P/'tests.json',{'schema':1,'status':'PASS','tests':tests,'test_count':len(tests),
 'checker':ref(checker),'called_functions':['verify_policy','disposition'],
 'official_checker_main_run':False,'git_called':False,'archives_rehashed':7,
 'archive_decompression_repeated':False,'raw_streams_rehashed':False})
assert digest(oldpath)=='d522c47acaf32a67309d08a3af1402e61b899ae1c9b4597aa6ace317060a9afa'
for item in artifacts:bound(item['file'])
print(json.dumps({'status':'PROPOSAL_ONLY','policy':ref(policy_path),'evidence':evidence_ref,
 'tests':ref(P/'tests.json'),'tests_passed':len(tests),'excluded_actual_caches':8,
 'previously_selected_cache_count':sum(x['old_disposition'][0]=='select' for x in artifacts)}))
