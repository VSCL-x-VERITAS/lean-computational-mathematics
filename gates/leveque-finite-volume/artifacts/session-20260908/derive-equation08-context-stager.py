from pathlib import Path
S=Path(__file__).resolve().parent
old=(S/'stage-context-build-checkpoint.py').read_text()
tail=old[old.index('selection=S/') :]
tail=tail.replace('context-build-checkpoint','equation08-context-checkpoint')
tail=tail.replace('"all active audit outputs","context task faithfulness output still running"','"all still-active audit outputs"')
head='''from pathlib import Path
import hashlib,json,os,subprocess
S=Path(__file__).resolve().parent
R=S.parents[3]
assert os.name!="nt"
assert json.loads((S/"equation08-context-gate-exit.json").read_text())["exit_code"]==0
files={"gates/leveque-finite-volume/chapter-01.json",
 "ledgers/leveque-finite-volume/book-issues/leveque-finite-volume/chapters/chapter-01/issues.md"}
for p in S.iterdir():
 if p.is_file() and p.name.startswith((
  "chapter01-architecture-graph-", "record-architecture-replay-verification.py", "architecture-replay-verification.json",
  "verify-reviewed-source-coverage.py", "reviewed-source-coverage-check-", "record-weak-context-source-note.py",
  "weak-context-source-note.json", "source-ledger-before-weak-context-", "equation08-row-closure-",
  "transport-context-nonaccepted-complete", "record-context-audit-completion.py", "context-audit-completion-verification.json",
  "source-ledger-before-context-complete-", "gate-before-context-complete-", "equation08-context-gate-",
  "equation08-context-organization-", "equation08-context-trackers-", "derive-equation08-context-stager.py",
  "stage-equation08-context-checkpoint.py"
 )):files.add(p.relative_to(R).as_posix())
for ident in ["LEV-CH01-EQ-1.8-DEFINITION-CANONICAL-20260908", "LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908"]:
 for p in (S/"audits"/ident).rglob("*"):
  if p.is_file():files.add(p.relative_to(R).as_posix())
for p in (S/"architecture-graphs").glob("checkpoint-fc76135d6.*"):
 assert p.suffix in [".json",".md"];files.add(p.relative_to(R).as_posix())
'''
dest=S/'stage-equation08-context-checkpoint.py';assert not dest.exists()
dest.write_text(head+tail,encoding='utf-8',newline='\n')
print(dest)
