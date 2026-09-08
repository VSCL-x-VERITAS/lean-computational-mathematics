from pathlib import Path
S=Path(__file__).resolve().parent
base=(S/'stage-interpreted-intro-checkpoint.py').read_text()
start=base.index('g=json.loads((R/')
tail=base[start:]
tail=tail.replace('interpreted-intro-checkpoint','general-intro-checkpoint')
head="""from pathlib import Path
import hashlib,json,os,subprocess
S=Path(__file__).resolve().parent;R=S.parents[3]
assert os.name!='nt'
for label in ['general-intro-gate','general-intro-organization','general-intro-trackers']:
 assert json.loads((S/(label+'-exit.json')).read_text())['exit_code']==0,label
files={'gates/leveque-finite-volume/chapter-01.json',
 'ledgers/leveque-finite-volume/book-issues/leveque-finite-volume/chapters/chapter-01/issues.md',
 'ledgers/leveque-finite-volume/skill-issues/book-formalization/leveque-finite-volume/sessions/codex-start-1-v5-0-1-20260908/issues.md'}
m=json.loads((S/'general-propagation-discontinuity-production-inputs.json').read_text())
files.update(x['path'] for x in m['files']+m['aggregates'])
for name in ['place-general-propagation-discontinuity.py','derive-general-production-verifier.py',
 'verify-general-production.py','derive-interpreted-gate-adapter.py','bind-interpreted-proved-row.py',
 'record-general-intro-progress.py','derive-general-intro-stager.py','stage-general-intro-checkpoint.py',
 'audit-equation02-interpreted-domains.config.json','audit-equation03-interpreted-domains.config.json']:
 files.add((S/name).relative_to(R).as_posix())
prefixes=('general-propagation-discontinuity-','general-default-full-build-','general-intro-',
 'interpreted-equation02-row-closure-','interpreted-equation03-row-closure-',
 'interpreted-gate-adapter-','wave-equation-row-closure-','gate-before-general-intro-',
 'ledger-before-LEV-C1-INTERPRETED-TRANSPORT-ACCEPTANCE-020-',
 'ledger-before-BF-LEV-RUN-20260908-019-')
for p in S.iterdir():
 if p.is_file() and p.name.startswith(prefixes) and not p.name.startswith('general-intro-checkpoint-'):
  files.add(p.relative_to(R).as_posix())
for ident in ['LEV-CH01-EQ-1.2-INTERPRETED-DOMAINS-PRODUCTION-20260908',
 'LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908',
 'LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908']:
 for p in (S/'audits'/ident).rglob('*'):
  if p.is_file():files.add(p.relative_to(R).as_posix())
"""
p=S/'stage-general-intro-checkpoint.py';assert not p.exists();p.write_text(head+tail,encoding='utf-8',newline='\n')
