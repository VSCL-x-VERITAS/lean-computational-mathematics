"""Stage three frozen audits, reviewed generic foundations and current organization evidence."""
from pathlib import Path
import hashlib,json,subprocess,sys
S=Path(__file__).resolve().parent;R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();read=lambda p:json.loads(p.read_bytes())
helper=S/'stage-reviewed-audit-batch-v2.py'
assert sha(helper)=='38e62a21253e5fc594e1b83c25feacfadd5720cc69c23c6649cee7df17f376a5'
git=lambda *a:subprocess.check_output(['git','-c','core.longpaths=true',*a],cwd=R)
assert not git('diff','--cached','--name-only').strip()
assert not git('diff','--name-only','--','ComputationalMathematics','NumStability').strip()
assert sha(S/'root-batch7-checkpoint-verification.json')=='9338182f225730ad4acf8ed86de49c5f948dcef8db22267406db8b5f99bb9995'
assert sha(R/'docs/architecture/tiers.json')=='7e7bd763431edadb9e87b4deb48e1bc7796a3294907b6b06f69c1a57304b244e'
assert sha(R/'gates/leveque-finite-volume/chapter-01.json')=='48c84dd75018ccbd527ce8659b358cdf3551f53d9d85cdef8ffa110aaec092be'
args=[sys.executable,str(helper),'--label','root-batch7-checkpoint']
for task in [
 'LEV-CH01-HETEROGENEOUS-CELL-AVERAGING-CANONICAL-20260908=6ee86257e622a3577b5e722e2def8d439ff3844d859c25ae6aea3831c9ed808e',
 'LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908=4a99d9c61f874c30b7c2c8748faca51327d3066d81ed15c96d9d59fe93a12c9a',
 'LEV-CH01-VARIABLE-COEFFICIENT-OPENING-CLAIM-PRODUCTION-20260908=df1b25f522c381164a7945df4b19660e7e03dc972bc419f19abb97d11ce7943e']:
 args+=['--task',task]
for check in read(S/'root-batch7-checkpoint-verification.json')['checks']:
 args+=['--verified-check',check['label']]
files={'docs/architecture/tiers.json'}
for raw in git('ls-files','--modified','--others','--exclude-standard','-z').split(b'\0'):
 if raw:
  path=R/raw.decode()
  if path.parent==S:
   assert path.is_file() and not path.is_symlink();files.add(path.relative_to(R).as_posix())
for folder in ['dimensional-splitting-lines-draft','baseline-equation03-transport-draft','batch6-rebind-preparation/fv-foundations-rebind-31','batch7-rebind-preparation']:
 for p in (S/folder).rglob('*'):
  if p.is_file():files.add(p.relative_to(R).as_posix())
for suffix in ['.json','.md']:
 files.add((S/('architecture-graphs/checkpoint-4d4bc03d-fv'+suffix)).relative_to(R).as_posix())
for path in sorted(files):args+=['--file',path]
subprocess.run(args,cwd=R,check=True)
