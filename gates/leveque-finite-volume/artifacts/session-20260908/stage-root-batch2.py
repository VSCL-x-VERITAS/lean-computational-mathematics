"""Stage the reviewed second root audit increment; leave ongoing audit roles alone."""
from pathlib import Path
import json,subprocess,sys
S=Path(__file__).resolve().parent;R=S.parents[3]
files=set()
for pattern in ['root-batch2-*','smooth-bridge-*']:
 for path in S.glob(pattern):
  if path.is_file():files.add(path.relative_to(R).as_posix())
for name in ['bind-audited-stronger-reused-row.py','record-reviewed-audit-batch.py',
 'prepare-advection-sentence-task.py','derive-advection-sentence-pipeline.py','run-advection-sentence-audit-pipeline.py',
 'derive-second-order-classification-adapter.py','bind-second-order-classification-proved-row.py',
 'derive-second-order-schema-correction.py','bind-second-order-classification-proved-row-v2.py',
 'freeze-smooth-bridge-strengthening.py','bind-final-gate-evidence.py','stage-root-batch2.py',
 'advection-sentence-route-output.txt','advection-sentence-route-exit.json',
 'advection-sentence-prepare-output.txt','advection-sentence-prepare-exit.json']:
 path=S/name;assert path.is_file(),path;files.add(path.relative_to(R).as_posix())
for name in ['advection-flux-scope-review','stronger-adapter-review']:
 for path in (S/name).rglob('*'):
  if path.is_file():files.add(path.relative_to(R).as_posix())
tasks=[
 'LEV-CH01-FLUX-JACOBIAN-HYPERBOLICITY-PRODUCTION-20260908=09e4fe080c26f82b13d6b8f87d65ec3b525617c89d67a57a9a9eb37c16702359',
 'LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY-PRODUCTION-20260908=ec1f5ba91a50a7a6f18e3ff7065a9354ca62d628b572560ccadedb307423b439',
 'LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH-CANONICAL-20260908=923861c4036334a4c9cff5e5ebb3f3ffc9329c40c1fab4f1f0ad9559a0c58b53',
 'LEV-CH01-EQ-1.11-RIEMANN-DATA-CANONICAL-20260908=a108ae2f6b7f3c7128c62a56aa419ca59a5ffe365cfa436b549edb6666f65115',
 'LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908=82c70fc8aae81f9790650f4e5ed6410008c1bb222dd908a5f89691b4db94c329']
args=[sys.executable,'-B',str(S/'stage-reviewed-audit-batch.py'),'--label','root-batch2-checkpoint']
for task in tasks:args+=['--task',task]
for label in ['root-batch2-final-gate','root-batch2-org','root-batch2-audit-inventory',
 'root-batch2-flux-jacobian-closure','root-batch2-second-order-closure-schema-correct',
 'root-batch2-smooth-stronger-closure','root-batch2-equation11-closure']:
 args+=['--verified-check',label]
for path in sorted(files):args+=['--file',path]
subprocess.run(args,cwd=R,check=True)

