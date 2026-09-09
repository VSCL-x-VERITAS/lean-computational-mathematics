"""One exact private diagnostic exclusion; never read or print its text content."""
from pathlib import Path,PurePosixPath
import ast,copy,hashlib,json,os,re
P=Path(__file__).resolve().parent;H=P.parent;D=H.parent;R=D.parents[4]
assert os.name!='nt'
def sha(p):
 h=hashlib.sha256()
 with p.open('rb') as f:
  for b in iter(lambda:f.read(1024*1024),b''):h.update(b)
 return h.hexdigest()
def ref(p):return {'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
def put(p,x):
 with p.open('xb') as f:f.write((json.dumps(x,indent=2)+'\n').encode())
base=H/'policy-final-physical-03.json'
assert sha(base)=='f20247c346a2901faff1aced68d35b9f2c8f39c736399afd69852630dea1ebec'
old=json.loads(base.read_bytes());new=copy.deepcopy(old)
private=D/'physical-dim-overlay-diagnostic/closure01/environment-stdout.txt'
assert private.is_file() and not private.is_symlink()
before=private.stat();r=ref(private);after=private.stat()
assert (before.st_size,before.st_mtime_ns)==(after.st_size,after.st_mtime_ns)
assert r['path'] not in old['exclude_exact'] and not r['path'].endswith('.lean')
evidence={'schema':1,'kind':'exact-private-runtime-diagnostic-exclusion','private_file':r,'bytes':after.st_size,
 'scope':'Filename, size and digest only. No private content copied, decoded, printed or selected for publication.',
 'basis':'Root request relayed by hyperbolicity_audit; raw child environment must remain private.',
 'publication_complete':False}
put(P/'private-exclusion-evidence.json',evidence)
new['exclude_exact'][r['path']]='Private raw child environment diagnostic; retain locally and never publish. Observed file SHA256 '+r['sha256']+'; metadata-only evidence '+ref(P/'private-exclusion-evidence.json')['path']+' SHA256 '+sha(P/'private-exclusion-evidence.json')
checker=H/'check-publication-allowlist-v3.py'
assert sha(checker)=='8022f5e367fd9bdb8081e30634b29a038925211e2724a674c2022a380df7adc7'
tree=ast.parse(checker.read_text());nodes=[n for n in tree.body if isinstance(n,ast.FunctionDef) and n.name in {'safe_name','disposition','verify_policy'}]
env={'PurePosixPath':PurePosixPath,'re':re};exec(compile(ast.Module(body=nodes,type_ignores=[]),str(checker),'exec'),env)
env['verify_policy'](new)
assert [k for k in old if old[k]!=new[k]]==['exclude_exact']
assert set(new['exclude_exact'])-set(old['exclude_exact'])=={r['path']}
assert env['disposition'](r['path'],old)[0]=='select'
assert env['disposition'](r['path'],new)[0]=='exclude'
assert env['disposition'](r['path']+'.lean',new)[0]=='select'
for path in old['allow_exact']:assert env['disposition'](path,new)==env['disposition'](path,old)
output=H/'policy-final-physical-03-private-successor.json';put(output,new)
put(P/'private-successor-diff.json',{'base':ref(base),'successor':ref(output),'changed_fields':['exclude_exact'],
 'added_exact_exclusion':r,'evidence':ref(P/'private-exclusion-evidence.json'),'prior_352_tests':ref(P/'tests.json'),
 'additional_checks_passed':['exact private path changes select to exclude','all old explicit allow dispositions unchanged','Lean suffix remains eligible'],
 'all_other_policy_fields_equal':True,'official_checker_main_run':False,'git_called':False})
assert sha(private)==r['sha256']
print(json.dumps({'status':'PROPOSAL_ONLY','policy':ref(output),'private_content_printed':False,
 'diff':ref(P/'private-successor-diff.json')}))
