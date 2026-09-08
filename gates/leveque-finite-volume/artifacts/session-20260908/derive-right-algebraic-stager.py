from pathlib import Path
S=Path(__file__).resolve().parent
old=(S/'stage-equation08-context-checkpoint.py').read_text()
tail=old[old.index('selection=S/') :].replace('equation08-context-checkpoint','right-algebraic-checkpoint')
head='''from pathlib import Path
import hashlib,json,os,subprocess
S=Path(__file__).resolve().parent;R=S.parents[3]
assert os.name!="nt"
for label in ["right-algebraic-gate","right-algebraic-organization","right-algebraic-trackers","candidate-architecture-wrapper-check"]:
 assert json.loads((S/(label+"-exit.json")).read_text())["exit_code"]==0,label
files={"gates/leveque-finite-volume/chapter-01.json",
 "ledgers/leveque-finite-volume/book-issues/leveque-finite-volume/chapters/chapter-01/issues.md",
 "ledgers/leveque-finite-volume/skill-issues/book-formalization/leveque-finite-volume/sessions/codex-start-1-v5-0-1-20260908/issues.md"}
for p in S.iterdir():
 if p.is_file() and p.name.startswith(("right-algebraic-row-closure-","right-algebraic-gate-",
  "right-algebraic-organization-","right-algebraic-trackers-","record-right-algebraic-acceptance.py",
  "right-algebraic-acceptance-verification.json","ledger-before-right-acceptance-",
  "validate-candidate-architecture.py","candidate-architecture-wrapper-check-",
  "derive-right-algebraic-stager.py","stage-right-algebraic-checkpoint.py")):
  files.add(p.relative_to(R).as_posix())
for p in (S/"audits/LEV-CH01-ACOUSTICS-RIGHT-MODE-ALGEBRAIC-PRODUCTION-20260908").rglob("*"):
 if p.is_file():files.add(p.relative_to(R).as_posix())
'''
dest=S/'stage-right-algebraic-checkpoint.py';assert not dest.exists()
dest.write_text(head+tail,encoding='utf-8',newline='\n')
print(dest)
