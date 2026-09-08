"""Construct exact checkpoint selection, excluding all active audit roots."""
from pathlib import Path
S=Path(__file__).resolve().parent
src=(S/'stage-right-algebraic-checkpoint.py').read_text()
tail=src[src.index('selection=S/'):].replace('right-algebraic-checkpoint','interpreted-intro-checkpoint')
head="""from pathlib import Path
import hashlib,json,os,subprocess
S=Path(__file__).resolve().parent;R=S.parents[3]
assert os.name!="nt"
for label in ["interpreted-intro-gate","interpreted-intro-organization","interpreted-intro-trackers"]:
 assert json.loads((S/(label+"-exit.json")).read_text())["exit_code"]==0,label
files={"gates/leveque-finite-volume/chapter-01.json",
 "ledgers/leveque-finite-volume/book-issues/leveque-finite-volume/chapters/chapter-01/issues.md",
 "ledgers/leveque-finite-volume/skill-issues/book-formalization/leveque-finite-volume/sessions/codex-start-1-v5-0-1-20260908/issues.md"}
m=json.loads((S/"interpreted-transport-production-inputs.json").read_text())
files.update(x["path"] for x in m["files"]+m["aggregates"])
for name in ["run-native-lake-check.py","record-user-transport-interpretation.py","user-transport-interpretation-20260908.json",
 "place-interpreted-transport-domains.py","verify-interpreted-transport-production.py",
 "interpreted-transport-organization-review.md","derive-proved-rebind-adapter.py",
 "proved-rebind-adapter-derivation.json","rebind-audited-proved-row.py",
 "record-interpreted-intro-progress.py","derive-interpreted-intro-stager.py","stage-interpreted-intro-checkpoint.py"]:
 files.add((S/name).relative_to(R).as_posix())
prefixes=("interpreted-transport-production-","interpreted-intro-",
 "transport-domain-draft-check-","uniform-transport-domain-draft-check-",
 "rectangle-mass-derivative-", "two-wave-row-closure-",
 "chapter01-default-full-build-3d205d6-","chapter01-import-regressions-3d205d6-",
 "discontinuity-nonaccepted-complete-","left-mode-nonaccepted-complete-",
 "gate-before-interpreted-intro-",
 "ledger-before-LEV-C1-DISCONTINUITY-GENERALITY-014-",
 "ledger-before-LEV-C1-USER-TRANSPORT-INTERPRETATION-015-",
 "ledger-before-LEV-C1-LEFT-MODE-PROFILE-CONTEXT-016-",
 "ledger-before-BF-LEV-RUN-20260908-016-","ledger-before-BF-LEV-RUN-20260908-017-")
for p in S.iterdir():
 if p.is_file() and p.name.startswith(prefixes) and not p.name.startswith("interpreted-intro-checkpoint-"):
  files.add(p.relative_to(R).as_posix())
for name in ["transport-domain-context-review","transport-domain-draft","discontinuity-general-foundation"]:
 for p in (S/name).rglob("*"):
  if p.is_file():files.add(p.relative_to(R).as_posix())
for ident in ["LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908",
 "LEV-CH01-ACOUSTICS-LEFT-MODE-CANONICAL-20260908",
 "LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION-CANONICAL-20260908"]:
 for p in (S/"audits"/ident).rglob("*"):
  if p.is_file():files.add(p.relative_to(R).as_posix())
g=json.loads((R/"gates/leveque-finite-volume/chapter-01.json").read_text())
for row in g["rows"]:
 if row["status"] not in ["PROVED","REUSED","DISCREPANCY"]:continue
 for p in (R/row["faithfulness_task"]).parent.joinpath("gate-bindings").rglob("*"):
  if p.is_file():files.add(p.relative_to(R).as_posix())
"""
dest=S/'stage-interpreted-intro-checkpoint.py';assert not dest.exists();dest.write_text(head+tail,encoding='utf-8',newline='\n')
print(dest)

