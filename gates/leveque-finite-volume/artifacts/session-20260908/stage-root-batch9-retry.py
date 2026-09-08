"""Stage completed batch-nine evidence only; retain active agent folders outside this checkpoint."""
from pathlib import Path
import hashlib,json,subprocess,sys
S=Path(__file__).resolve().parent;R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();read=lambda p:json.loads(p.read_bytes())
helper=S/'stage-reviewed-audit-batch-v2.py'
assert sha(helper)=='38e62a21253e5fc594e1b83c25feacfadd5720cc69c23c6649cee7df17f376a5'
git=lambda *a:subprocess.check_output(['git','-c','core.longpaths=true',*a],cwd=R)
assert git('rev-parse','HEAD').decode().strip()=='521f73a23a95a842928c581fa011a46379b3b547'
previous=read(S/'root-batch9-checkpoint-selection.json')
cache='gates/leveque-finite-volume/artifacts/session-20260908/batch9-capstone-independent-review/__pycache__/verify.cpython-312.pyc'
assert cache in previous['files']
staged=set(git('diff','--cached','--name-only').decode().splitlines())
assert staged<=set(previous['files']) and cache not in staged
assert read(S/'batch9-staging-cache-diagnostic-exit.json')['exit_code']==1
assert not git('diff','--name-only','--','ComputationalMathematics','NumStability').strip()
v=read(S/'root-batch9-checkpoint-verification.json')
assert sha(R/v['gate']['path'])==v['gate']['sha256']=='4e9d0afc6c20c55b7475c0b332b2eb600cf0266a18f1b81607c8aaba89bb64d2'
assert sha(R/v['tiers']['path'])==v['tiers']['sha256']
for b in v['verification_artifacts']:assert sha(R/b['path'])==b['sha256']
args=[sys.executable,str(helper),'--label','root-batch9-checkpoint-retry','--task',
 'LEV-CH01-VARIABLE-COEFFICIENT-OPENING-CLAIM-PRODUCTION-20260908=df1b25f522c381164a7945df4b19660e7e03dc972bc419f19abb97d11ce7943e']
for c in v['checks']:args+=['--verified-check',c['label']]
files=set(previous['files'])-{cache}
files.add('docs/architecture/tiers.json')
args+=['--verified-check','batch9-trackers-after-staging-recovery']
for raw in git('ls-files','--modified','--others','--exclude-standard','-z').split(b'\0'):
 if raw:
  p=R/raw.decode()
  if p.parent==S:
   assert p.is_file() and not p.is_symlink();files.add(p.relative_to(R).as_posix())
for folder in ['cartesian-coordinate-line-composition-draft','prospective-density-material-riemann-capstones-draft',
 'left-mode-alternative-evidence','batch9-capstone-independent-review','density-capstone-vector-nonvacuity-draft',
 'fv-update-capstone-draft','returned-field-interface-capstone-draft','final-epoch-asset-helper-draft',
 'typed-blocker-global-evidence-preparation','batch7-rebind-preparation/batch9-foundations-rebind-32']:
 for p in (S/folder).rglob('*'):
  if p.is_file() and p.relative_to(R).as_posix()!=cache:files.add(p.relative_to(R).as_posix())
for suffix in ['.json','.md']:
 files.add((S/('architecture-graphs/checkpoint-521f73a2-foundations'+suffix)).relative_to(R).as_posix())
for p in sorted(files):args+=['--file',p]
subprocess.run(args,cwd=R,check=True)
