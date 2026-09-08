from pathlib import Path
import subprocess,sys
S=Path(__file__).resolve().parent;R=S.parents[3]
tasks={'LEV-CH01-ADVECTION-LINEAR-FLUX-CONSERVED-CLAIM-CANONICAL-20260908':'c63c9040403aa195fa47ed240e0cfed9273ba98afc8d7bf8fba12f6d06037c26','LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-CANONICAL-20260908':'d1c97d14be0ffaaf83897b80df8759ebeb4f7167c597a84cddd2a95efb54d843','LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-MEASURE-CONTEXT-CANONICAL-20260908':'d2a133b2e23b485fba83a3beea97b27913bdc0dc13e6a71a3d36dddfe91b66d4','LEV-CH01-ONE-STEP-METHOD-DEFINITION-PRODUCTION-20260908':'407f81e19b77273538f53bce5cb3894398d0615ca932a6e87ca02f37071b80d7','LEV-CH01-ACOUSTICS-CONSERVATION-FORM-CANONICAL-20260908':'c02c795c1558de1ed8e5201175ea7767c171e71a7fd01f1554dbd8d47a09a702'}
args=[sys.executable,str(S/'stage-reviewed-audit-batch.py'),'--label','root-batch3-checkpoint']
tasks['LEV-CH01-ONE-STEP-GENERAL-CURRENT-DATA-PRODUCTION-20260908']='c4bd57bca215be6290d02c6376871db7695b2f1c38b780a159aa4d5eda1ce8cd'
args+=['--verified-check','root-batch3-one-step-general-closure','--verified-check','root-batch3-final-gate']
for task,decision in tasks.items():args+=['--task',task+'='+decision]
for label in ['root-batch3-current-gate','root-batch3-audit-inventory','root-batch3-cell-context-closure','root-batch3-acoustics-conservation-closure','root-batch3-advection-sentence-closure','one-step-architecture-graph-check','one-step-default-full-build']:
 args+=['--verified-check',label]
files={R/'docs/architecture/tiers.json'}
prefixes=('root-batch3-','one-step-','chapter01-expression-','export-chapter01-declaration-expressions','freeze-chapter01-expression-fingerprints','chapter01-declaration-expression-fingerprints','expression-fingerprint-','prepare-chapter01-expression-export','derive-chapter01-expression-export','derive-expression-fingerprint')
for p in S.iterdir():
 if p.is_file() and p.name.startswith(prefixes):files.add(p)
for folder in ['one-step-rebind-preparation']:
 files.update(p for p in (S/folder).rglob('*') if p.is_file())
for name in ['run-root-audit-queue.py','stage-root-batch3.py','record-one-step-organization.py','classify-one-step-general.py','prepare-one-step-general-audit-task.py','derive-one-step-general-pipeline.py','run-one-step-general-audit-pipeline.py','prepare-advection-sentence-task.py','derive-advection-sentence-pipeline.py','run-advection-sentence-audit-pipeline.py','prepare-cell-average-measure-context.py','recover-cell-average-measure-context-images.py','complete-cell-average-measure-context-preparation.py','finish-cell-average-measure-context-preparation.py','run-cell-average-measure-context-audit-pipeline.py','audit-cell-average-measure-context.config.json','inspect-candidate-planning-inputs.py']:
 files.add(S/name)
for suffix in ['json','md']:files.add(S/('architecture-graphs/checkpoint-7707ce2ec.'+suffix))
for p in sorted(files):
 assert p.is_file(),p
 args+=['--file',p.relative_to(R).as_posix()]
raise SystemExit(subprocess.run(args,cwd=R).returncode)
