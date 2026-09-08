"""Freeze the optional request-constructor preparation, not an operational request."""
from pathlib import Path
import hashlib,json,os
H=Path(__file__).resolve().parent
def native(p):
 p=Path(p)
 return Path('\\\\?\\'+str(p.resolve())) if os.name=='nt' and not str(p).startswith('\\\\?\\') else p
sha=lambda p:hashlib.sha256(native(p).read_bytes()).hexdigest()
def host(value):return Path(value[1]+':/'+value[3:]) if os.name=='nt' and value.startswith('/c/') else Path(value)
def write(name,obj):
 with (H/name).open('xb') as out:out.write((json.dumps(obj,indent=2)+'\n').encode())
for name,expected in [('checks-01.exit.json',1),('checks-02.exit.json',0)]:
 receipt=json.loads((H/name).read_bytes());assert receipt['exit_code']==expected
 for item in receipt['inputs']+[receipt['output']]:assert sha(host(item['path']))==item['sha256'],item
checks=json.loads((H/'checks.json').read_bytes());assert checks['count']==17
assert checks['constructor_sha256']==sha(H/'construct_request.py')
for item in checks['inputs']:assert sha(host(item['path']))==item['sha256'],item
assert not (H/'runs').exists(),'No operational request output permitted in this freeze'
files=[]
for directory,dirs,names in os.walk(native(H)):
 dirs[:]=[d for d in dirs if d!='__pycache__']
 for name in names:
  p=Path(directory)/name;rel=Path(os.path.relpath(p,native(H))).as_posix()
  assert rel not in ['manifest.json','final-receipt.json'],'already frozen'
  files.append({'path':rel,'sha256':sha(p),'bytes':p.stat().st_size})
files.sort(key=lambda f:f['path'])
write('manifest.json',{'schema':1,'status':'OPTIONAL_PREPARATION_ONLY','constructor_sha256':sha(H/'construct_request.py'),
 'test_exit':0,'tests':17,'failed_harness_exit':1,'source_acceptance':False,'operational_request_created':False,
 'route_completion_asserted':False,'inputs':checks['inputs'],'files':files,
 'limits':'Root-authored complete inputs remain required. No constructor main/construct, prepare, installer, current_context, Git or model/audit role run. Supplied context is not independently refreshed by this constructor.'})
write('final-receipt.json',{'schema':1,'status':'PREPARATION_FROZEN','manifest_sha256':sha(H/'manifest.json'),
 'constructor_sha256':sha(H/'construct_request.py'),'readme_sha256':sha(H/'README.md'),
 'test_exit':0,'tests':17,'test_receipt_sha256':sha(H/'checks-02.exit.json'),
 'source_acceptance':False,'operational_request_created':False,'route_completion_asserted':False})
print(json.dumps({name:sha(H/name) for name in ['manifest.json','final-receipt.json','construct_request.py','README.md','checks-02.exit.json']}))
