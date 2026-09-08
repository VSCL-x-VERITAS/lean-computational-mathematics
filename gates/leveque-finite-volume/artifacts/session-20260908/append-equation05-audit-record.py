"""Retain the accepted acoustic specification and its exact scope notes."""
from pathlib import Path
import hashlib,json
S=Path(__file__).resolve().parent;R=S.parents[3];sha=lambda b:hashlib.sha256(b).hexdigest()
ident='LEV-CH01-EQ-1.5-LINEAR-ACOUSTICS-PRODUCTION-20260908';task=S/'audits'/ident
dpath=task/'faithfulness/decision.json';assert sha(dpath.read_bytes())=='31ba8b6bef7b1ac587951f42738099305dd6e4a3249c5e1594a65c6152e73635'
d=json.loads(dpath.read_bytes());assert d['accepted'] and d['classification']=='faithful-equivalent'
check=S/'root-batch1-equation05-closure-exit.json';assert json.loads(check.read_bytes())['exit_code']==0
path=R/'ledgers/leveque-finite-volume/book-issues/leveque-finite-volume/chapters/chapter-01/issues.md';before=path.read_bytes()
entry_id='LEV-C1-ACOUSTIC-EQUATION-SPECIFICATION-026';assert entry_id.encode() not in before
backup=S/('ledger-before-'+entry_id+'-'+sha(before)+'.bin');backup.write_bytes(before)
entry='| '+entry_id+' | LEV-CH01-EQ-1.5-LINEAR-ACOUSTICS | model specification and material domain | Equation (1.5) introduces two governing equations without proving existence or physical derivation | The pointwise predicate is equivalent to four actual partial derivative witnesses and the exact two residual equations; density is nonzero | accepted faithful-equivalent, both implications yes, no adjudication | decision 31ba8b6bef7b1ac587951f42738099305dd6e4a3249c5e1594a65c6152e73635; report e6849dac5d94ca394c8f45474863f12ea740fc5eb561e27371b1a5c99ff3b581; complete and native proof validation exit 0 | Unrestricted bulk modulus and density sign concern the algebraic specification, not physical sound propagation. The direct judge resolved an earlier-task D006 reference against current D002 using the exact inventory; no unresolved dependency remains. |'
path.write_bytes(before.rstrip(b'\r\n')+b'\n'+entry.encode()+b'\n')
record={'schema':1,'task':ident,'decision_sha256':sha(dpath.read_bytes()),'report_sha256':sha((task/'faithfulness/report.md').read_bytes()),'root_closure_exit_sha256':sha(check.read_bytes()),'findings':d['findings'],'ledger_backup':backup.relative_to(R).as_posix(),'ledger_after_sha256':sha(path.read_bytes())}
destination=S/'equation05-audit-record.json';assert not destination.exists();destination.write_text(json.dumps(record,indent=2)+'\n')
print(json.dumps({'task':ident,'receipt_sha256':sha(destination.read_bytes()),'ledger_entry':entry_id}))
