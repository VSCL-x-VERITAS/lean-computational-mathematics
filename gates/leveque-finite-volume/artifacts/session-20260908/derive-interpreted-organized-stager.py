from pathlib import Path
S=Path(__file__).resolve().parent
text=(S/'record-architecture-replay-verification.py').read_text()
repls={'chapter01-architecture-graph':'interpreted-architecture-graph',",'reviewed-source-coverage-check'":'','checkpoint-fc76135d6':'checkpoint-4a29be754','fc76135d6a90111301bf5ba7b2f8de8267daadce':'4a29be754145fb1099e35feb679df6d4e524acc8','5921':'5925','60343':'60347','272284':'272296','393161':'393185',"S/'architecture-replay-verification.json'":"S/'interpreted-architecture-replay-verification.json'",' Source coverage verifies the existing independent inventory, not pending Lean/source equivalence.':''}
for old,new in repls.items():assert old in text,old;text=text.replace(old,new)
p=S/'record-interpreted-architecture-verification.py';assert not p.exists();p.write_text(text,encoding='utf-8',newline='\n')
src=(S/'stage-right-algebraic-checkpoint.py').read_text();tail=src[src.index('selection=S/'):].replace('right-algebraic-checkpoint','interpreted-organized-checkpoint')
head="""from pathlib import Path
import hashlib,json,os,subprocess
S=Path(__file__).resolve().parent;R=S.parents[3]
assert os.name!="nt"
for label in ["interpreted-organized-gate","interpreted-organized-organization","interpreted-organized-trackers",
 "interpreted-architecture-graph-check","acoustic-eigenvalues-row-closure","eigenvalues-wave-speeds-nonaccepted-complete"]:
 assert json.loads((S/(label+"-exit.json")).read_text())["exit_code"]==0,label
files={"gates/leveque-finite-volume/chapter-01.json","docs/architecture/tiers.json",
 "ledgers/leveque-finite-volume/book-issues/leveque-finite-volume/chapters/chapter-01/issues.md",
 "ledgers/leveque-finite-volume/skill-issues/book-formalization/leveque-finite-volume/sessions/codex-start-1-v5-0-1-20260908/issues.md"}
for name in ["derive-interpreted-classification.py","classify-committed-interpreted.py",
 "record-interpreted-organization.py","interpreted-organization-verification.json","interpreted-tier-update.json",
 "repair-characteristic-converse-draft.py","prepare-eigenbasis-propagation-draft.py",
 "verify-general-foundation-drafts.py","general-discontinuity-root-verification.json",
 "record-user-discontinuity-interpretation.py","user-discontinuity-interpretation-20260908.json",
 "freeze-general-drafts-and-choices.py","record-acoustic-eigenvalues-acceptance.py",
 "acoustic-eigenvalues-acceptance-verification.json","derive-interpreted-organized-stager.py",
 "record-interpreted-architecture-verification.py","interpreted-architecture-replay-verification.json",
 "stage-interpreted-organized-checkpoint.py"]:
 files.add((S/name).relative_to(R).as_posix())
prefixes=("interpreted-organized-","interpreted-default-full-build-","interpreted-architecture-graph-",
 "characteristic-converse-draft-","eigenbasis-propagation-draft-","acoustic-eigenvalues-row-closure-",
 "eigenvalues-wave-speeds-nonaccepted-complete-","tiers-before-interpreted-",
 "gate-before-interpreted-organization-","gate-before-general-drafts-",
 "ledger-before-LEV-C1-ACOUSTIC-SPECTRAL-CONTEXT-017-",
 "ledger-before-LEV-C1-USER-DISCONTINUITY-INTERPRETATION-018-",
 "ledger-before-LEV-C1-EIGENVALUE-COMPONENT-COVERAGE-019-",
 "ledger-before-BF-LEV-RUN-20260908-018-")
for p in S.iterdir():
 if p.is_file() and p.name.startswith(prefixes) and not p.name.startswith("interpreted-organized-checkpoint-"):
  files.add(p.relative_to(R).as_posix())
for name in ["characteristic-converse-draft","discontinuity-general-capstone"]:
 for p in (S/name).rglob("*"):
  if p.is_file():files.add(p.relative_to(R).as_posix())
for suffix in [".json",".md"]:
 files.add((S/("architecture-graphs/checkpoint-4a29be754"+suffix)).relative_to(R).as_posix())
for ident in ["LEV-CH01-ACOUSTICS-EIGENVALUES-CANONICAL-20260908",
 "LEV-CH01-EIGENVALUES-WAVE-SPEEDS-CANONICAL-20260908"]:
 for p in (S/"audits"/ident).rglob("*"):
  if p.is_file():files.add(p.relative_to(R).as_posix())
g=json.loads((R/"gates/leveque-finite-volume/chapter-01.json").read_text())
for row in g["rows"]:
 if row["status"] not in ["PROVED","REUSED","DISCREPANCY"]:continue
 for p in (R/row["faithfulness_task"]).parent.joinpath("gate-bindings").rglob("*"):
  if p.is_file():files.add(p.relative_to(R).as_posix())
"""
p=S/'stage-interpreted-organized-checkpoint.py';assert not p.exists();p.write_text(head+tail,encoding='utf-8',newline='\n')
print('Created exact graph verifier and checkpoint stager; no staging performed yet.')
