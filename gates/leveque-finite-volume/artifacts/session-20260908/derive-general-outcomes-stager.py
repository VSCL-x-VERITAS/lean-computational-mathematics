from pathlib import Path
import hashlib,json
S=Path(__file__).resolve().parent
old=S/'stage-acoustic-flux-checkpoint.py';text=old.read_text()
text=text.replace("['acoustic-flux-gate','acoustic-flux-organization','acoustic-flux-trackers','acoustic-model-row-closure','linear-flux-row-closure']", "['general-outcomes-gate','general-outcomes-organization','general-outcomes-trackers','general-discontinuity-row-closure-correct-path']")
start=text.index("for name in [");end=text.index("for p in S.iterdir():",start)
text=text[:start]+'''for name in ['record-general-audit-outcomes.py','general-audit-outcomes-verification.json',
 'derive-general-outcomes-stager.py','stage-general-outcomes-checkpoint.py',
 'derive-discontinuity-gate-adapter.py','bind-discontinuity-interpreted-proved-row.py',
 'discontinuity-gate-adapter-derivation.json','general-outcomes-stager-derivation.json',
 'audit-discontinuity-interpreted-general.config.json','audit-eigenvalues-general-propagation.config.json']:
 files.add((S/name).relative_to(R).as_posix())
prefixes=('general-outcomes-','general-discontinuity-row-closure-',
 'ledger-before-LEV-C1-GENERAL-DISCONTINUITY-ACCEPTANCE-024-',
 'ledger-before-LEV-C1-GENERAL-PROPAGATION-REGULARITY-025-')
'''+text[end:]
text=text.replace('acoustic-flux-checkpoint-','general-outcomes-checkpoint-').replace('acoustic-flux-checkpoint','general-outcomes-checkpoint')
text=text.replace("['LEV-CH01-EQ-1.4-ACOUSTIC-MODEL-PRODUCTION-20260908','LEV-CH01-LINEAR-FLUX-SPECIALIZATION-CANONICAL-20260908']", "['LEV-CH01-DISCONTINUITY-INTERPRETED-GENERAL-PRODUCTION-20260908','LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908']")
p=S/'stage-general-outcomes-checkpoint.py';assert not p.exists();p.write_text(text,encoding='utf-8')
r=S/'general-outcomes-stager-derivation.json';assert not r.exists();r.write_text(json.dumps({'schema':1,'base':old.name,'base_sha256':hashlib.sha256(old.read_bytes()).hexdigest(),'derived':p.name,'derived_sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'changes':'Exact frozen two-task and root-evidence selection only; complete POSIX traversal and actual Git blob verification unchanged.'},indent=2)+'\n')
