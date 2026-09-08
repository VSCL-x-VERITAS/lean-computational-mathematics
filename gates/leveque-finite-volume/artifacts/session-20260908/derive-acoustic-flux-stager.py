from pathlib import Path
S=Path(__file__).resolve().parent
base=(S/'stage-general-intro-checkpoint.py').read_text()
tail=base[base.index('g=json.loads((R/'):].replace('general-intro-checkpoint','acoustic-flux-checkpoint')
head="""from pathlib import Path
import hashlib,json,os,subprocess
S=Path(__file__).resolve().parent;R=S.parents[3]
assert os.name!='nt'
for label in ['acoustic-flux-gate','acoustic-flux-organization','acoustic-flux-trackers','acoustic-model-row-closure','linear-flux-row-closure']:
 assert json.loads((S/(label+'-exit.json')).read_text())['exit_code']==0,label
files={'gates/leveque-finite-volume/chapter-01.json',
 'ledgers/leveque-finite-volume/book-issues/leveque-finite-volume/chapters/chapter-01/issues.md',
 'ledgers/leveque-finite-volume/skill-issues/book-formalization/leveque-finite-volume/sessions/codex-start-1-v5-0-1-20260908/issues.md'}
for name in ['record-acoustic-flux-acceptance.py','acoustic-flux-acceptance-verification.json',
 'candidate-epoch-readiness-review.md','derive-acoustic-flux-stager.py','stage-acoustic-flux-checkpoint.py']:
 files.add((S/name).relative_to(R).as_posix())
prefixes=('acoustic-flux-','acoustic-model-row-closure-','linear-flux-row-closure-',
 'ledger-before-LEV-C1-ACOUSTIC-MODEL-ACCEPTANCE-022-',
 'ledger-before-LEV-C1-LINEAR-FLUX-CLASSICAL-DOMAIN-023-')
for p in S.iterdir():
 if p.is_file() and p.name.startswith(prefixes) and not p.name.startswith('acoustic-flux-checkpoint-'):
  files.add(p.relative_to(R).as_posix())
for ident in ['LEV-CH01-EQ-1.4-ACOUSTIC-MODEL-PRODUCTION-20260908','LEV-CH01-LINEAR-FLUX-SPECIALIZATION-CANONICAL-20260908']:
 for p in (S/'audits'/ident).rglob('*'):
  if p.is_file():files.add(p.relative_to(R).as_posix())
"""
p=S/'stage-acoustic-flux-checkpoint.py';assert not p.exists();p.write_text(head+tail,encoding='utf-8',newline='\n')
