"""Restage the exact reviewed selection with rename-aware postcondition repaired."""
from pathlib import Path
import hashlib,json,subprocess,sys
S=Path(__file__).resolve().parent;R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();read=lambda p:json.loads(p.read_bytes())
git=lambda *a:subprocess.check_output(['git','-c','core.longpaths=true',*a],cwd=R)
helper=S/'stage-reviewed-audit-batch-v2.py'
assert sha(helper)=='38e62a21253e5fc594e1b83c25feacfadd5720cc69c23c6649cee7df17f376a5'
assert git('rev-parse','HEAD').decode().strip()=='24b3a281d19aac39ee745a4168a877bd82f78208'
previous=read(S/'root-batch10-checkpoint-selection.json')
assert sha(S/'root-batch10-checkpoint-staged-verification.json')=='b5353fd161c1ce1af10d6fdca9b486baa05d0d065d45ad8f5309901da428980a'
cache=read(S/'generated-capstone-cache-preservation/preservation.json')
excluded={x['original_path'] for x in cache['files']}
assert set(git('diff','--cached','--no-renames','--name-only','--diff-filter=D').decode().splitlines())==excluded
staged=set(git('diff','--cached','--no-renames','--name-only').decode().splitlines())
assert staged <= set(previous['files'])|excluded|{(S/'root-batch10-checkpoint-staged-verification.json').relative_to(R).as_posix()}
v=read(S/'root-batch10-checkpoint-verification.json')
assert sha(R/v['gate']['path'])==v['gate']['sha256']
for ref in v['verification_artifacts']:assert sha(R/ref['path'])==ref['sha256']
files=set(previous['files'])
for raw in git('ls-files','--modified','--others','--exclude-standard','-z').split(b'\0'):
 if raw:
  p=R/raw.decode()
  if p.parent==S:
   assert p.is_file() and not p.is_symlink();files.add(p.relative_to(R).as_posix())
assert not files&excluded
args=[sys.executable,str(helper),'--label','root-batch10-checkpoint-retry','--task',
 'LEV-CH01-VARIABLE-COEFFICIENT-OPENING-CLAIM-PRODUCTION-20260908=df1b25f522c381164a7945df4b19660e7e03dc972bc419f19abb97d11ce7943e']
for x in v['checks']:args+=['--verified-check',x['label']]
args+=['--verified-check','batch10-trackers-after-staging-recovery']
for path in sorted(files):args+=['--file',path]
subprocess.run(args,cwd=R,check=True)
assert set(git('diff','--cached','--no-renames','--name-only','--diff-filter=D').decode().splitlines())==excluded
for x in cache['files']:
 assert not git('ls-files','--',x['original_path']).strip()
 assert git('cat-file','blob',':'+x['snapshot_path'])==(R/x['original_path']).read_bytes()
assert not git('diff','--name-only','HEAD','--','ComputationalMathematics','NumStability').strip()
print(json.dumps(dict(status='EXACT_STAGE_VERIFIED',same_content_snapshot_renames=2)))

