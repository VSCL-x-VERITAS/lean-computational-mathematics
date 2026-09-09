"""Read-only POSIX Git identity/presence check for the four new source owners."""
from pathlib import Path
import hashlib,json,os,subprocess
F=Path(__file__).resolve().parent;R=next(p for p in F.parents if (p/'lean-toolchain').exists())
assert os.name!='nt'
inputs=json.loads((F/'inputs.json').read_bytes())
git=lambda *a:subprocess.run(['git','--no-replace-objects',*a],cwd=R,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
head=git('rev-parse','HEAD');assert head.returncode==0 and head.stdout.decode().strip()==inputs['input_commit']
anchor='9e2225705fed906b1120d55105d607baabef57c9'
ancestor=git('merge-base','--is-ancestor',anchor,inputs['input_commit']);assert ancestor.returncode==0
records=[]
for item in inputs['files']:
 for revision in [inputs['input_commit'],anchor]:
  result=git('cat-file','-e',revision+':'+item['path'])
  records.append({'path':item['path'],'revision':revision,'command':['git','--no-replace-objects','cat-file','-e',revision+':'+item['path']],
   'actual_exit_code':result.returncode,'blob_present':result.returncode==0,
   'stderr':result.stderr.decode(),'stderr_sha256':hashlib.sha256(result.stderr).hexdigest()})
  assert result.returncode==128 and b'does not exist in' in result.stderr
assert git('rev-parse','HEAD').stdout==head.stdout
receipt={'scope':'Actual current HEAD and shared-anchor blob absence only; no future commit or lane assertion.',
 'actual_input_commit':inputs['input_commit'],'anchor':anchor,'ancestor_actual_exit_code':ancestor.returncode,
 'owner_count':4,'all_four_owners_absent_from_head_and_anchor':True,'records':records,'no_git_mutation':True}
with (F/'origin-presence.json').open('x',encoding='utf-8') as f:json.dump(receipt,f,indent=2);f.write('\n')
print(json.dumps({'owner_count':4,'all_absent':True,'sha256':hashlib.sha256((F/'origin-presence.json').read_bytes()).hexdigest()}))
