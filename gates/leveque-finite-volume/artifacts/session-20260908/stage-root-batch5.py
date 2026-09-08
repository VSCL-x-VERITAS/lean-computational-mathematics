"""Stage completed audit evidence and the organized definition increment only."""
from pathlib import Path
import hashlib,json,subprocess,sys
S=Path(__file__).resolve().parent;R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
read=lambda p:json.loads(p.read_bytes())
helper=S/'stage-reviewed-audit-batch-v2.py'
assert sha(helper)=='38e62a21253e5fc594e1b83c25feacfadd5720cc69c23c6649cee7df17f376a5'
git=lambda *a:subprocess.check_output(['git','-c','core.longpaths=true',*a],cwd=R)
assert not git('diff','--cached','--name-only').strip(),'Unrelated staged input'
assert read(S/'definition-rebind-preparation/definition-organized-rebind-28/summary.json')['all_closed_artifacts_current'] is True
assert sha(S/'root-batch5-frozen-drafts-verification.json')=='9913d16db93186cd355ffa7398315f3829b2f11b046f0f0f7b22a58db5260680'
args=[sys.executable,str(helper),'--label','root-batch5-checkpoint']
for spec in [
 'LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION-PRODUCTION-20260908=b525d59b4604c818a66ed4c9453e4a1cb26c42eda6862f2cdc09b7b7f6cd8094',
 'LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908=be89b5bf7e066c64e3b24292d96d997d879ddb5c5342de79936263cf9ce9a052',
 'LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908=5bcb31b0d05629a35f39086f22f044187188ad043dd38ebebdc8518b6987b825',
 'LEV-CH01-FINITE-VOLUME-FLUX-UPDATE-CANONICAL-20260908=8660b099909f6f75de955b1ef62d176191887521f1e1c261f6dc645743074375',
 'LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908=c48f5b9e8e6121f618e8f54292a56c4f7f3daad9df513794a904bdfb2abaefe3',
 'LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908=44dfd5c682eb5fdcd9fabd7b747df0ccbabc280d31482e26861c714a7b56c1a4',
 'LEV-CH01-VARIABLE-COEFFICIENT-NONCONSERVATION-PRODUCTION-20260908=4c25a95e84a86fb7a3e126863ee1040ca77ee3862bd0d2317c01172f91896cbc']:
 args+=['--task',spec]
for label in ['root-batch5-gate','root-batch5-organization-preflight','root-batch5-trackers','root-batch5-closed-audits',
 'definition-corrected-layout','definition-organized-tiers','definition-organized-compatibility','definition-organized-hygiene',
 'definition-organized-full-build','definition-organized-graph-capture','definition-organized-graph-check','definition-expression-export',
 'equation10-recovery-independent-verification','baseline-equation03-expression-export-after-prepare','baseline-equation03-expression-freeze']:
 args+=['--verified-check',label]
files=set()
for raw in git('ls-files','--modified','--others','--exclude-standard','-z').split(b'\0'):
 if not raw:continue
 path=R/raw.decode()
 if path.parent==S:
  assert path.is_file() and not path.is_symlink()
  files.add(path.relative_to(R).as_posix())
for folder in ['material-interface-general-draft','finite-volume-flux-update-repair','nonconservation-integral-source-draft','definition-rebind-preparation']:
 for p in (S/folder).rglob('*'):
  if p.is_file():files.add(p.relative_to(R).as_posix())
for name in ['checkpoint-3239b41c4','checkpoint-3239b41c4-organized']:
 for ext in ['json','md']:files.add((S/'architecture-graphs'/(name+'.'+ext)).relative_to(R).as_posix())
files.update(['ComputationalMathematics/Analysis.lean','docs/architecture/tiers.json'])
for path in sorted(files):args+=['--file',path]
subprocess.run(args,cwd=R,check=True)
