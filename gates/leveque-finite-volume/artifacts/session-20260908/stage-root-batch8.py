"""Stage current organization evidence and the reviewed normalized-volume alternative."""
from pathlib import Path
import hashlib,json,subprocess,sys
S=Path(__file__).resolve().parent;R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();read=lambda p:json.loads(p.read_bytes())
helper=S/'stage-reviewed-audit-batch-v2.py'
assert sha(helper)=='38e62a21253e5fc594e1b83c25feacfadd5720cc69c23c6649cee7df17f376a5'
git=lambda *a:subprocess.check_output(['git','-c','core.longpaths=true',*a],cwd=R)
assert git('rev-parse','HEAD').decode().strip()=='03c81fa2a551b5089133c958deedc4828899adbd'
assert not git('diff','--cached','--name-only').strip()
assert not git('diff','--name-only','--','ComputationalMathematics','NumStability').strip()
assert sha(S/'root-batch8-checkpoint-verification.json')=='f899c8823805fbadda7059f4de0f5bd49d46c270909ea8174274e1e02ee46d12'
assert sha(S/'root-batch8-normalized-volume-verification.json')=='a5f2b308facad35f77011c08f1678f55cbe1bb0403f1d945495be1815c169f75'
assert sha(S/'root-batch8-average-verifier-note-audit-records.json')=='ea59c3367c643e9e7817617530a9e967bdbc5f31eb4a441cbc0778b60ddb8f87'
assert sha(R/'docs/architecture/tiers.json')=='b2b31b08695ca45d1594adc1709e714af0373c560e3bafbc1a8ede2e5f3e6510'
assert sha(R/'gates/leveque-finite-volume/chapter-01.json')=='be44bbc965afc54df979282166eaa4c2344e9161737009c8c40bb42d3160ffa6'
# The helper requires a selected frozen audit. This is the already accepted,
# byte-unchanged variable-coefficient task, not a new audit or source closure.
args=[sys.executable,str(helper),'--label','root-batch8-checkpoint','--task',
 'LEV-CH01-VARIABLE-COEFFICIENT-OPENING-CLAIM-PRODUCTION-20260908=df1b25f522c381164a7945df4b19660e7e03dc972bc419f19abb97d11ce7943e']
for check in read(S/'root-batch8-checkpoint-verification.json')['checks']:
 args+=['--verified-check',check['label']]
args+=['--verified-check','batch8-trackers-after-average']
files={'docs/architecture/tiers.json'}
for raw in git('ls-files','--modified','--others','--exclude-standard','-z').split(b'\0'):
 if raw:
  path=R/raw.decode()
  if path.parent==S:
   assert path.is_file() and not path.is_symlink();files.add(path.relative_to(R).as_posix())
for folder in ['heterogeneous-volume-average-draft','batch7-rebind-preparation/batch8-foundations-rebind-32']:
 for p in (S/folder).rglob('*'):
  if p.is_file():files.add(p.relative_to(R).as_posix())
for suffix in ['.json','.md']:
 files.add((S/('architecture-graphs/checkpoint-03c81fa2-foundations'+suffix)).relative_to(R).as_posix())
for path in sorted(files):args+=['--file',path]
subprocess.run(args,cwd=R,check=True)

