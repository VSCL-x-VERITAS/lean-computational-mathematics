"""Restore only the two hash-pinned generated audit caches, or verify their current bytes."""
from pathlib import Path
import argparse,hashlib,json,os,subprocess
S=Path(__file__).resolve().parent;R=S.parents[3];P=S/'generated-capstone-cache-preservation'
p=argparse.ArgumentParser(description=__doc__);p.add_argument('--restore',action='store_true');p.add_argument('--label',required=True);a=p.parse_args()
assert os.name!='nt' and a.label.replace('-','').isalnum()
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
mapping=P/'preservation.json'
assert sha(mapping)=='3bd9a4893d9713259398d5ead7e9cadc4fd7b4792a51c2c5253f125e76837b4c'
m=json.loads(mapping.read_bytes())
expected={str((S/'prospective-density-material-riemann-capstones-draft'/n).relative_to(R).as_posix()) for n in ['capstones-final-03.olean','measure-final-02.olean']}
assert len(m['files'])==2 and {f['original_path'] for f in m['files']}==expected
for f in m['files']:
 original=R/f['original_path'];snap=R/f['snapshot_path']
 assert original.resolve().is_relative_to(R) and snap.resolve().is_relative_to(P)
 assert not original.is_symlink() and not snap.is_symlink()
 assert sha(snap)==f['snapshot_sha256']==f['original_sha256'] and snap.stat().st_size==f['bytes']
 if original.exists():assert sha(original)==f['original_sha256'] and original.stat().st_size==f['bytes']
 elif not a.restore:raise ValueError('Missing generated cache; explicit --restore required: '+f['original_path'])
out=P/(a.label+'-replay.json');assert not out.exists()
git=lambda *a:subprocess.check_output(['git','-c','core.longpaths=true',*a],cwd=R)
assert all(not git('ls-files','--',f['original_path']).strip() for f in m['files'])
restored=[]
if a.restore:
 gitdir=Path(git('rev-parse','--absolute-git-dir').decode().strip()).resolve()
 exclude=Path(git('rev-parse','--git-path','info/exclude').decode().strip())
 if not exclude.is_absolute():exclude=R/exclude
 exclude=exclude.resolve();assert exclude.is_relative_to(gitdir) and not exclude.is_symlink()
 before=exclude.read_bytes() if exclude.exists() else b''
 added=['/'+f['original_path'] for f in m['files'] if '/'+f['original_path'] not in before.decode('utf-8').splitlines()]
 if added:
  backup=P/(a.label+'-exclude-before.bin')
  with backup.open('xb') as stream:stream.write(before)
  after=before+(b'\n' if before and not before.endswith(b'\n') else b'')+''.join(x+'\n' for x in added).encode()
  assert not exclude.exists() or exclude.read_bytes()==before
  exclude.parent.mkdir(exist_ok=True);exclude.write_bytes(after)
 for f in m['files']:
  original=R/f['original_path']
  if not original.exists():
   with original.open('xb') as stream:stream.write((R/f['snapshot_path']).read_bytes())
   restored.append(f['original_path'])
for f in m['files']:
 assert sha(R/f['original_path'])==f['original_sha256']
 assert subprocess.run(['git','-c','core.longpaths=true','check-ignore','--quiet','--',f['original_path']],cwd=R).returncode==0
value=dict(schema=1,status='EXACT_CACHE_PATHS_VERIFIED',mapping_sha256=sha(mapping),mode='restore-missing-only' if a.restore else 'verify-existing-only',restored=restored,files=m['files'],source_acceptance=False,old_verifiers_not_run=True,scope='Generated output cache restoration only. Frozen receipts and absolute-path relocation limitations remain unchanged.')
with out.open('x',encoding='utf-8') as stream:json.dump(value,stream,indent=2);stream.write('\n')
print(json.dumps(dict(status=value['status'],receipt_sha256=sha(out),restored=restored)))

