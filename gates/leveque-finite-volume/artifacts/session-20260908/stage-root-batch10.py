"""Stage the reviewed batch10 checkpoint and exact cache-path representation repair."""
from pathlib import Path
import hashlib,json,subprocess,sys
S=Path(__file__).resolve().parent;R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();read=lambda p:json.loads(p.read_bytes())
helper=S/'stage-reviewed-audit-batch-v2.py'
assert sha(helper)=='38e62a21253e5fc594e1b83c25feacfadd5720cc69c23c6649cee7df17f376a5'
git=lambda *a:subprocess.check_output(['git','-c','core.longpaths=true',*a],cwd=R)
assert git('rev-parse','HEAD').decode().strip()=='24b3a281d19aac39ee745a4168a877bd82f78208'
v=read(S/'root-batch10-checkpoint-verification.json')
assert sha(S/'root-batch10-checkpoint-verification.json')=='a1602dfc59b59f01b6ff00bd2c4c0a26640435894eab65dea37a118a493134cd'
assert sha(R/v['gate']['path'])==v['gate']['sha256']
assert sha(R/v['tiers']['path'])==v['tiers']['sha256']
for b in v['verification_artifacts']:assert sha(R/b['path'])==b['sha256']
excluded={x['original_path'] for x in v['cache_representation']}
assert set(git('diff','--cached','--name-only').decode().splitlines())==excluded
assert set(git('diff','--cached','--name-only','--diff-filter=D').decode().splitlines())==excluded
for x in v['cache_representation']:assert sha(R/x['original_path'])==sha(R/x['snapshot_path'])==x['original_sha256']
files={'docs/architecture/tiers.json'}
for raw in git('ls-files','--modified','--others','--exclude-standard','-z').split(b'\0'):
 if raw:
  p=R/raw.decode()
  if p.parent==S:
   assert p.is_file() and not p.is_symlink();files.add(p.relative_to(R).as_posix())
folders=['prospective-eigen-fv-qualification-review','information-interface-capstone-draft',
 'nine-row-local-route-review-batch10','nine-row-production-supplement-batch10',
 'blocked-gate-binding-preparation','blocked-gate-binding-transcript-order-v2',
 'blocked-gate-installer-independent-review','blocked-route-input-preparation-batch10',
 'batch10-organization-preparation','current-thread-question-provenance-v2-batch10',
 'generated-capstone-cache-preservation','generated-capstone-cache-review',
 'batch7-rebind-preparation/batch10-closed-rows-current']
for folder in folders:
 for p in (S/folder).rglob('*'):
  if p.is_file():
   assert not p.is_symlink() and '__pycache__' not in p.parts and p.suffix not in {'.pyc','.olean','.ilean'},p
   files.add(p.relative_to(R).as_posix())
for suffix in ['.json','.md']:files.add((S/('architecture-graphs/checkpoint-24b3a281-foundations'+suffix)).relative_to(R).as_posix())
assert not files&excluded
args=[sys.executable,str(helper),'--label','root-batch10-checkpoint','--task',
 'LEV-CH01-VARIABLE-COEFFICIENT-OPENING-CLAIM-PRODUCTION-20260908=df1b25f522c381164a7945df4b19660e7e03dc972bc419f19abb97d11ce7943e']
for check in v['checks']:args+=['--verified-check',check['label']]
for path in sorted(files):args+=['--file',path]
subprocess.run(args,cwd=R,check=True)
assert set(git('diff','--cached','--name-only','--diff-filter=D').decode().splitlines())==excluded
for path in excluded:
 assert not git('ls-files','--',path).strip()
 assert subprocess.run(['git','-c','core.longpaths=true','check-ignore','--quiet','--',path],cwd=R).returncode==0
assert not git('diff','--name-only','HEAD','--','ComputationalMathematics','NumStability').strip()
print(json.dumps(dict(exact_deleted_generated_paths=sorted(excluded),snapshots_retained=True)))

