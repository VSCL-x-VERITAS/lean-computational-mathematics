"""Freeze the read-only cache review and exact final restore-helper inspection."""
from pathlib import Path
import hashlib,json,os
H=Path(__file__).resolve().parent
S=H.parent
def native(p):
 p=Path(p)
 return Path('\\\\?\\'+str(p.resolve())) if os.name=='nt' and not str(p).startswith('\\\\?\\') else p
sha=lambda p:hashlib.sha256(native(p).read_bytes()).hexdigest()
def host(value):return Path('C:/'+value[3:]) if os.name=='nt' and value.startswith('/c/') else Path(value)
def write(name,obj):
 with (H/name).open('xb') as out:out.write((json.dumps(obj,indent=2)+'\n').encode())
receipt=json.loads((H/'check-01.exit.json').read_bytes());assert receipt['exit_code']==0
for item in receipt['inputs']+[receipt['output']]:assert sha(host(item['path']))==item['sha256']
verification=json.loads((H/'verification.json').read_bytes())
for item in verification['inputs']:assert sha(host(item['path']))==item['sha256']
extra=[]
for name,pin in [('restore-generated-capstone-caches.py','564494c9dcf1946006d99b44e081cadb4c5754a764d66866a2a8cac6959c44e1'),
 ('generated-capstone-cache-preservation/root-existing-replay.json','c759110be86ea628cd00202462095c91c2b6892b3e9adf60348e2f28546a9f64')]:
 p=S/name;assert sha(p)==pin
 extra.append({'path':str(p),'sha256':pin})
compile((S/'restore-generated-capstone-caches.py').read_text(encoding='utf-8'),'reviewed-restore-helper','exec')
replay=json.loads((S/'generated-capstone-cache-preservation/root-existing-replay.json').read_bytes())
assert replay['mode']=='verify-existing-only' and replay['restored']==[]
assert replay['mapping_sha256']==verification['mapping_sha256']
assert replay['source_acceptance'] is False and replay['old_verifiers_not_run'] is True
files=[]
for directory,dirs,names in os.walk(native(H)):
 dirs[:]=[d for d in dirs if d!='__pycache__']
 for name in names:
  p=Path(directory)/name;rel=Path(os.path.relpath(p,native(H))).as_posix()
  assert rel not in ['manifest.json','final-receipt.json'],'already frozen'
  files.append({'path':rel,'sha256':sha(p),'bytes':p.stat().st_size})
files.sort(key=lambda f:f['path'])
write('manifest.json',{'schema':1,'status':'BOUNDED_CACHE_REVIEW_COMPLETE',
 'verification_sha256':sha(H/'verification.json'),'actual_review_exit':0,'inputs':verification['inputs']+extra,
 'files':files,'git_or_operational_work_run':False,'source_acceptance':False,
 'conclusion':'Exact generated content is retained; explicit two-path restore mapping and helper address fresh-checkout cache paths. Existing absolute-path relocation remains outside this narrow restoration.'})
write('final-receipt.json',{'schema':1,'status':'REVIEW_FROZEN','manifest_sha256':sha(H/'manifest.json'),
 'review_sha256':sha(H/'REVIEW.md'),'verification_sha256':sha(H/'verification.json'),'actual_review_exit':0,
 'exit_receipt_sha256':sha(H/'check-01.exit.json'),'preservation_sha256':verification['mapping_sha256'],
 'restore_helper_sha256':extra[0]['sha256'],'source_acceptance':False,'terminal_verdict_asserted':False})
print(json.dumps({name:sha(H/name) for name in ['manifest.json','final-receipt.json','REVIEW.md','check-01.exit.json']}))
