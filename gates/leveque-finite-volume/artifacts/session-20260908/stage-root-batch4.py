"""Freeze this explicit completed audit increment, excluding all active tasks."""
from pathlib import Path
import hashlib,json,subprocess,sys
S=Path(__file__).resolve().parent;R=S.parents[3]
helper=S/'stage-reviewed-audit-batch.py'
args=[sys.executable,str(helper),'--label','root-batch4-checkpoint']
for spec in [
 'LEV-CH01-HYPERBOLIC-SYSTEM-SCALAR-DECOUPLING-PRODUCTION-20260908=172dc7c4f1ff64b44684cd87b6ac74bce597c6e7aa5eaae6158261a0ace71791',
 'LEV-CH01-RIEMANN-RAY-ZERO-VALUE-PRODUCTION-20260908=57ecf95fd583c87cef2572a1d46a89d11adf370897d705a539edfe1e88c8d44a',
 'LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908=d39e5f7d682275ebe7333695c0249c6e4ccffd7b81e0bc4bfa3c4930659e1216']:
 args+=['--task',spec]
for label in ['root-batch4-scalar-decoupling-closure','root-batch4-ray-zero-closure','root-batch4-first-gate','root-batch4-organization-preflight','root-batch4-closed-audits-corrected','one-step-expression-export','one-step-expression-fingerprint-merge']:
 args+=['--verified-check',label]
files=[
 'stage-root-batch4.py','recover-equation10-invalid-direct.py','inspect-audit-progress.py',
 'prepare-one-step-expression-export.py','export-one-step-declaration-expressions.lean',
 'one-step-expression-export-inputs.json','merge-one-step-expression-fingerprints.py',
 'chapter01-current-expression-fingerprints-7707.json'
]
for path in S.glob('root-batch4-first-results-*'):files.append(path.name)
files+=['root-batch4-closed-audits-output.txt','root-batch4-closed-audits-exit.json']
for name in sorted(set(files)):
 f=S/name;assert f.is_file();args+=['--file',f.relative_to(R).as_posix()]
subprocess.run(args,cwd=R,check=True)

