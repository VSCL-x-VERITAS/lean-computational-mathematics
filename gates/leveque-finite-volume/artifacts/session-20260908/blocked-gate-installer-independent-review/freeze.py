"""Freeze bounded review evidence; never execute an installer."""
from pathlib import Path
import hashlib,json,os
H=Path(__file__).resolve().parent
def native(p):
    p=Path(p)
    return Path('\\\\?\\'+str(p.resolve())) if os.name=='nt' and not str(p).startswith('\\\\?\\') else p
sha=lambda p:hashlib.sha256(native(p).read_bytes()).hexdigest()
def host(value):
    return Path(value[1]+':/'+value[3:]) if os.name=='nt' and value.startswith('/c/') else Path(value)
def write(name,obj):
    with (H/name).open('xb') as out:out.write((json.dumps(obj,indent=2)+'\n').encode())
receipt=json.loads((H/'checks-01.exit.json').read_bytes());assert receipt['exit_code']==0
for item in receipt['inputs']+[receipt['output']]:assert sha(host(item['path']))==item['sha256'],item
checks=json.loads((H/'checks.json').read_bytes());assert checks['count']==13
for item in checks['subjects']:assert sha(host(item['path']))==item['sha256'],item
files=[]
for directory,dirs,names in os.walk(native(H)):
    dirs[:]=[d for d in dirs if d!='__pycache__']
    for name in names:
        p=Path(directory)/name
        relative=Path(os.path.relpath(p,native(H))).as_posix()
        assert relative not in ['manifest.json','final-receipt.json'],'already frozen'
        files.append(dict(path=relative,sha256=sha(p),bytes=p.stat().st_size))
files.sort(key=lambda item:item['path'])
write('manifest.json',dict(schema=1,status='BOUNDED_REVIEW_COMPLETE',
    final_target_sha256='6e2fb502fbd341eaedee506710e5a49067bfbaa3f153bd34ee5f44638b389dad',
    actual_test_exit=0,checks=13,subjects=checks['subjects'],files=files,
    required_finding=dict(id='F1',status='addressed-in-v3',scope='cross-gate set freshness'),
    source_acceptance=False,faithfulness_action='none',operational_installer_executed=False,
    limitations='Static and isolated fixtures; no real preparation, current-context, installation or terminal verification. Cooperative root-owned operational writers required.'))
write('final-receipt.json',dict(schema=1,status='REVIEW_FROZEN',actual_check_exit=0,
    manifest_sha256=sha(H/'manifest.json'),review_sha256=sha(H/'REVIEW.md'),
    checks_sha256=sha(H/'checks.json'),exit_receipt_sha256=sha(H/'checks-01.exit.json'),
    final_target_sha256='6e2fb502fbd341eaedee506710e5a49067bfbaa3f153bd34ee5f44638b389dad',
    operational_installer_executed=False,source_acceptance=False,installation_authorized=False))
print(json.dumps({name:sha(H/name) for name in ['manifest.json','final-receipt.json','REVIEW.md','checks-01.exit.json']}))
