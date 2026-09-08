"""Preserve the independently adjudicated transport-context outcome."""
from pathlib import Path
import hashlib,json
S=Path(__file__).resolve().parent;R=S.parents[3]
sha=lambda b:hashlib.sha256(b).hexdigest()
A=S/'audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness'
expected={'manifest.json':'c84adeecc6ef459e9da6a1a303904690aa01688be8edcc01f19366293aeeb5b1','decision.json':'6c248e6e9a3daecce9a6b318a9760a15a18570e3ea57c204f330a4ecfe5930ae','report.md':'cf0608520f00a36a073d9c95bc1eeedad64ed3caac2c04ac58912bdfa2775a29'}
for name,digest in expected.items():assert sha((A/name).read_bytes())==digest
d=json.loads((A/'decision.json').read_text());assert not d['accepted'] and d['adjudicated'] and d['classification']=='undetermined'
assert d['implications']['source_implies_lean']['verdict']=='yes'
assert d['implications']['lean_implies_source']['verdict']=='unclear'
assert json.loads((S/'transport-context-nonaccepted-complete-corrected-exit.json').read_text())['exit_code']==0
assert json.loads((S/'equation08-row-closure-exit.json').read_text())['exit_code']==0
L=R/'ledgers/leveque-finite-volume/book-issues/leveque-finite-volume/chapters/chapter-01/issues.md'
before=L.read_bytes();ident='LEV-C1-TRANSPORT-ADMISSIBILITY-012';assert ident.encode() not in before
(S/('source-ledger-before-context-complete-'+sha(before)+'.bin')).write_bytes(before)
entry='| LEV-C1-TRANSPORT-ADMISSIBILITY-012 | LEV-CH01-EQ-1.3-ADVECTED-PROFILE; LEV-CH01-EQ-1.2-ADVECTION | exhaustive solution-domain ambiguity | Chapter 1 says any function without an exhaustive analytic profile class; the added weak-solution context does not settle that class | Fresh independent source, blind, direct, round-trip and adjudicator roles confirm the exact translated field and all analytic branches under their stated premises; native proof-free evidence resolves the ordinary length measure and integral nonvacuity | undetermined; accepted false; source implies Lean yes; Lean implies source unclear; no discrepancy certified | manifest c84adeecc6ef459e9da6a1a303904690aa01688be8edcc01f19366293aeeb5b1; decision 6c248e6e9a3daecce9a6b318a9760a15a18570e3ea57c204f330a4ecfe5930ae; report cf0608520f00a36a073d9c95bc1eeedad64ed3caac2c04ac58912bdfa2775a29; root released complete validation exit 0 | Retain all outcomes. Complete a bounded source-domain clarification using the pinned book, then seek a material user choice only if the intended analytic scope remains indeterminate. Do not repeat unchanged audits, label this a wrong measure, or silently restrict the source claim. Other Chapter 1 audits remain actionable. |\n'
L.write_bytes(before.rstrip(b'\r\n')+b'\n'+entry.encode())
G=R/'gates/leveque-finite-volume/chapter-01.json';beforeg=G.read_bytes();g=json.loads(beforeg)
(S/('gate-before-context-complete-'+sha(beforeg)+'.json')).write_bytes(beforeg)
for ident in ['LEV-CH01-EQ-1.3-ADVECTED-PROFILE','LEV-CH01-EQ-1.2-ADVECTION']:
 row=next(r for r in g['rows'] if r['id']==ident);assert row['status']=='READY'
 row['next_foundation']='Fresh Eq1.3 context/environment audit is complete and nonaccepted/undetermined. Exact measure, analytic operators and substantive nonvacuity are resolved; source implies Lean yes, reverse unclear only because the exhaustive source profile/solution class is unspecified. Complete bounded source-domain clarification and, if still needed, present the exact material interpretation choice while advancing other rows. Preserve prior audits; do not rerun unchanged roles or close a narrower class as equivalent.'
G.write_text(json.dumps(g,indent=2,ensure_ascii=False)+'\n',encoding='utf-8',newline='\n')
out=S/'context-audit-completion-verification.json';assert not out.exists()
out.write_text(json.dumps({'schema':1,'audit':expected,'root_complete_validation_output_sha256':sha((S/'transport-context-nonaccepted-complete-corrected-output.txt').read_bytes()),'retained_failed_invocation':'transport-context-nonaccepted-complete-exit.json records an incorrect validator path (exit 2); the corrected command uses the unchanged sealed scripts/validate_audit.py and actual complete validation succeeds. No audit bytes were altered.','source_ledger_sha256':sha(L.read_bytes()),'gate_sha256':sha(G.read_bytes()),'status':'Nonaccepted audit retained; source clarification remains actionable; all global checks stay OPEN.'},indent=2)+'\n',encoding='utf-8')
print(json.dumps({'receipt_sha256':sha(out.read_bytes()),'gate_sha256':sha(G.read_bytes()),'source_issue':ident,'formalized_rows':sum(r['status'] in ['PROVED','REUSED','DISCREPANCY'] for r in g['rows'])}))
