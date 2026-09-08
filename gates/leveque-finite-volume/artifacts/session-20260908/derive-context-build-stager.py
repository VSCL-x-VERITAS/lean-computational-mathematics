"""Stage only completed builds, a frozen nonacceptance, and immutable context inputs."""
from pathlib import Path
S=Path(__file__).resolve().parent
old=(S/'stage-acoustic-checkpoint.py').read_text()
tail='selection=S/'+old.split('selection=S/',1)[1]
tail=tail.replace('acoustic-checkpoint','context-build-checkpoint')
tail=tail.replace('"library-build*","all non-frozen audit output roots"','"all active audit outputs","context task faithfulness output still running"')
head='''from pathlib import Path
import hashlib,json,os,subprocess
S=Path(__file__).resolve().parent
R=S.parents[3]
assert os.name!="nt"
assert json.loads((S/"context-build-gate-exit.json").read_text())["exit_code"]==0
files={"gates/leveque-finite-volume/chapter-01.json",
 "ledgers/leveque-finite-volume/book-issues/leveque-finite-volume/chapters/chapter-01/issues.md"}
for p in S.iterdir():
 if p.is_file() and p.name.startswith((
  "library-build", "uniform-transport-nonaccepted-", "transport-context-root-prepared-",
  "audit-transport-context.config.json", "record-postcheckpoint-evidence.py", "postcheckpoint-evidence-68d710e.json",
  "complete-source-inventory-snapshot.py", "chapter01-source-inventory-coverage-v2.json",
  "source-ledger-before-uniform-context-", "gate-before-uniform-context-", "context-build-gate-",
  "context-build-organization-", "context-build-trackers-", "derive-context-build-stager.py",
  "stage-context-build-checkpoint.py"
 )):files.add(p.relative_to(R).as_posix())
for p in (S/"audits/LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908").rglob("*"):
 if p.is_file():files.add(p.relative_to(R).as_posix())
context=S/"audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908"
for name in ["audit-task.json","construction-receipt.json","dependency-environment-packet.json",
 "prepare-exit.json","prepare-output.txt","prepare-stderr.txt","prepared-receipt.json",
 "prepared-validation-exit.json","prepared-validation-output.txt","prepared-validation-stderr.txt"]:
 p=context/name
 assert p.is_file();files.add(p.relative_to(R).as_posix())
'''
dest=S/'stage-context-build-checkpoint.py';assert not dest.exists()
dest.write_text(head+tail,encoding='utf-8')
print(dest)
