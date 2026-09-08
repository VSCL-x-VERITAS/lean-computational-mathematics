"""Freeze the bounded actual-proposal review without operational writes."""
from pathlib import Path
import hashlib,json,os
H=Path(__file__).resolve().parent
def native(p):
 p=Path(p)
 return Path('\\\\?\\'+str(p.resolve())) if os.name=='nt' and not str(p).startswith('\\\\?\\') else p
sha=lambda p:hashlib.sha256(native(p).read_bytes()).hexdigest()
def host(value):return Path('C:/'+value[3:]) if os.name=='nt' and value.startswith('/c/') else Path(value)
def write(name,obj):
 with (H/name).open('xb') as out:out.write((json.dumps(obj,indent=2)+'\n').encode())
exit_record=json.loads((H/'check-01.exit.json').read_bytes());assert exit_record['exit_code']==0
for item in exit_record['inputs']+[exit_record['output']]:assert sha(host(item['path']))==item['sha256']
review=json.loads((H/'verification.json').read_bytes())
assert review['status']=='MECHANICAL_CHECKS_PASSED' and len(review['input_files'])==338
for item in review['input_files']:assert sha(host(item['path']))==item['sha256'],item
files=[]
for directory,dirs,names in os.walk(native(H)):
 dirs[:]=[d for d in dirs if d!='__pycache__']
 for name in names:
  p=Path(directory)/name;rel=Path(os.path.relpath(p,native(H))).as_posix()
  assert rel not in ['manifest.json','final-receipt.json'],'already frozen'
  files.append({'path':rel,'sha256':sha(p),'bytes':p.stat().st_size})
files.sort(key=lambda f:f['path'])
write('manifest.json',{'schema':1,'status':'MECHANICAL_REVIEW_FROZEN','actual_check_exit':0,
 'preparation':review['preparation'],'proposal':review['proposal'],'operational_gate_sha256':review['operational_gate_sha256'],
 'actual_current_head_at_check':review['actual_current_head'],'verification_sha256':sha(H/'verification.json'),
 'input_files':review['input_files'],'files':files,'installer_run':False,
 'substantive_exhaustion_assessed':False,'source_acceptance':False,'terminal_verdict_asserted':False})
write('final-receipt.json',{'schema':1,'status':'MECHANICAL_REVIEW_FROZEN','actual_check_exit':0,
 'manifest_sha256':sha(H/'manifest.json'),'review_sha256':sha(H/'REVIEW.md'),
 'verification_sha256':sha(H/'verification.json'),'exit_receipt_sha256':sha(H/'check-01.exit.json'),
 'preparation_sha256':review['preparation']['sha256'],'proposal_sha256':review['proposal']['sha256'],
 'source_acceptance':False,'substantive_exhaustion_assessed':False,'installation_authorized':False,'terminal_verdict_asserted':False})
print(json.dumps({name:sha(H/name) for name in ['manifest.json','final-receipt.json','REVIEW.md','check-01.exit.json']}))
