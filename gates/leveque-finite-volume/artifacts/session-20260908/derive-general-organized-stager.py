from pathlib import Path
S=Path(__file__).resolve().parent
base=(S/'stage-general-intro-checkpoint.py').read_text()
tail=base[base.index('g=json.loads((R/'):]
tail=tail.replace('general-intro-checkpoint','general-organized-checkpoint')
head="""from pathlib import Path
import hashlib,json,os,subprocess
S=Path(__file__).resolve().parent;R=S.parents[3]
assert os.name!='nt'
for label in ['general-organized-gate','general-organized-organization','general-organized-trackers','general-architecture-graph-check','quasilinear-row-closure']:
 assert json.loads((S/(label+'-exit.json')).read_text())['exit_code']==0,label
files={'gates/leveque-finite-volume/chapter-01.json','docs/architecture/tiers.json',
 'ledgers/leveque-finite-volume/book-issues/leveque-finite-volume/chapters/chapter-01/issues.md',
 'ledgers/leveque-finite-volume/skill-issues/book-formalization/leveque-finite-volume/sessions/codex-start-1-v5-0-1-20260908/issues.md'}
for name in ['derive-general-tier-classifier.py','classify-committed-general.py','general-tier-update.json',
 'derive-general-organization-recorder.py','record-general-organization.py','general-organization-verification.json',
 'derive-general-architecture-recorder.py','record-general-architecture-verification.py','general-architecture-replay-verification.json',
 'freeze-left-mode-domain-draft.py','record-classical-derivations-acceptance.py','classical-derivations-acceptance-verification.json',
 'derive-general-organized-stager.py','stage-general-organized-checkpoint.py']:
 files.add((S/name).relative_to(R).as_posix())
prefixes=('general-organized-','general-architecture-graph-','quasilinear-row-closure-',
 'left-mode-domain-draft-check-','tiers-before-general-','gate-before-general-organization-',
 'ledger-before-LEV-C1-CLASSICAL-DERIVATION-SCOPE-021-')
for p in S.iterdir():
 if p.is_file() and p.name.startswith(prefixes) and not p.name.startswith('general-organized-checkpoint-'):
  files.add(p.relative_to(R).as_posix())
for p in (S/'left-mode-domain-draft').rglob('*'):
 if p.is_file():files.add(p.relative_to(R).as_posix())
for suffix in ['.json','.md']:
 files.add((S/('architecture-graphs/checkpoint-eed529aaf'+suffix)).relative_to(R).as_posix())
for ident in ['LEV-CH01-EQ-1.9-QUASILINEAR-FORM-CANONICAL-20260908']:
 for p in (S/'audits'/ident).rglob('*'):
  if p.is_file():files.add(p.relative_to(R).as_posix())
"""
p=S/'stage-general-organized-checkpoint.py';assert not p.exists();p.write_text(head+tail,encoding='utf-8',newline='\n')
