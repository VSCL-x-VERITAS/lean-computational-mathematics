"""Stage four completed audits, their reviewed closures, and frozen repair evidence."""
from pathlib import Path
import hashlib,json,subprocess,sys
S=Path(__file__).resolve().parent;R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
read=lambda p:json.loads(p.read_bytes())
helper=S/'stage-reviewed-audit-batch-v2.py'
assert sha(helper)=='38e62a21253e5fc594e1b83c25feacfadd5720cc69c23c6649cee7df17f376a5'
git=lambda *a:subprocess.check_output(['git','-c','core.longpaths=true',*a],cwd=R)
assert not git('diff','--cached','--name-only').strip()
assert not git('diff','--name-only','--','ComputationalMathematics','NumStability','docs/architecture/tiers.json').strip(),'Production changed after verified organization checkpoint'
assert sha(S/'root-batch6-fv-estimate-verification.json')=='e3fd50df9f7f5f7338b79354274408b5b05baa1a11a74e5b2be028c0bb7819f9'
assert read(S/'batch6-rebind-preparation/batch6-preflight-31/summary.json')['exit_code']==0
args=[sys.executable,str(helper),'--label','root-batch6-checkpoint']
for task in [
 'LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908=d1725ddbd6c0f2013969af9fc50529a4cf50552002d9e1fb5bb285cdcb068edb',
 'LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908=44edb527ee90075daac4ed1ce93e91388f2e064838757954678fe04fbdee0648',
 'LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908=eb47998419d4a3ffed864a3df8abe133d9865083b808df11d0c28d0171ccf9cf',
 'LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908=f4bc6e665499951d8ddf5a80cba2f0c5ed5d548e97fef9fb9984a7b22012ccf8']:
 args+=['--task',task]
for label in ['root-batch6-gate-corrected','root-batch6-organization-preflight','root-batch6-trackers','root-batch6-closed-audits','stronger-production-witnesses-v2','stronger-production-closure-verification','equation10-interpreted-production-closure']:
 args+=['--verified-check',label]
files=set()
for raw in git('ls-files','--modified','--others','--exclude-standard','-z').split(b'\0'):
 if raw:
  path=R/raw.decode()
  if path.parent==S:
   assert path.is_file() and not path.is_symlink();files.add(path.relative_to(R).as_posix())
for folder in ['finite-volume-flux-error-estimate','batch6-rebind-preparation','stronger-production-preflight','stronger-production-closure']:
 for p in (S/folder).rglob('*'):
  if p.is_file():files.add(p.relative_to(R).as_posix())
for path in sorted(files):args+=['--file',path]
subprocess.run(args,cwd=R,check=True)
