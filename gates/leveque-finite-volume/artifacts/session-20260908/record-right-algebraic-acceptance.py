"""Append the exact resolution of the prior acoustic parameter-domain question."""
from pathlib import Path
import hashlib,json
S=Path(__file__).resolve().parent;R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
A=S/'audits/LEV-CH01-ACOUSTICS-RIGHT-MODE-ALGEBRAIC-PRODUCTION-20260908/faithfulness'
expected={'manifest.json':'65a9abb3dc3a5eb643e18fbd14764a6da83139f0a82703f44954ebd632c64875','decision.json':'45316df1b3205224ed64258b2bc0e5a6b34238b9a57018e623225290ed181f96','report.md':'a13b5a44e66843221ac0fa5f4ac47c69769ff786428a8c91b273b254097c53a3'}
for name,digest in expected.items():assert sha(A/name)==digest
d=json.loads((A/'decision.json').read_text())
assert d['accepted'] and d['adjudicated'] and d['classification']=='faithful-equivalent' and not d['remaining_uncertainties']
assert all(v['verdict']=='yes' for v in d['implications'].values())
assert d['judge_classifications']=={'direct':'faithful-equivalent','roundtrip':'undetermined'}
assert json.loads((S/'right-algebraic-row-closure-exit.json').read_text())['exit_code']==0
G=R/'gates/leveque-finite-volume/chapter-01.json';g=json.loads(G.read_text())
row=next(r for r in g['rows'] if r['id']=='LEV-CH01-ACOUSTICS-RIGHT-MODE')
assert row['status']=='PROVED' and row['lean_declarations']==['NumStability.leveque01_acousticsRightMode_of_pos_ratio']
records={}
entries=[
 ('ledgers/leveque-finite-volume/book-issues/leveque-finite-volume/chapters/chapter-01/issues.md','LEV-C1-ACOUSTIC-DOMAIN-RESOLVED-013',
  '| LEV-C1-ACOUSTIC-DOMAIN-RESOLVED-013 | LEV-CH01-ACOUSTICS-RIGHT-MODE | resolution of source issue 008 | The earlier audit left the relation between physical positive parameters and the algebraic positive-ratio domain uncertain | The new theorem uses only positive K/rho and the actual acoustic system; independent adjudication confirms the exact right-mode PDE and supplies sign-reversal correspondence if individual physical positivity is inherited | faithful-equivalent; accepted true after adjudication; both implications yes; no remaining uncertainty | manifest 65a9abb3dc3a5eb643e18fbd14764a6da83139f0a82703f44954ebd632c64875; decision 45316df1b3205224ed64258b2bc0e5a6b34238b9a57018e623225290ed181f96; report a13b5a44e66843221ac0fa5f4ac47c69769ff786428a8c91b273b254097c53a3; root complete validator and exact proof receipt closure exit 0 | Row PROVED. Retain the earlier undetermined physical-domain audit and original new roundtrip uncertainty. No claim of physical realizability for both-negative material coefficients is added. |'),
 ('ledgers/leveque-finite-volume/skill-issues/book-formalization/leveque-finite-volume/sessions/codex-start-1-v5-0-1-20260908/issues.md','BF-LEV-RUN-20260908-015',
  '| BF-LEV-RUN-20260908-015 | 2026-09-08 | sealed v1 dependency evidence follow-up | The acoustic blind dossier omitted the full D001 structure fields; the full direct dossier contained the exact four fields. The real-measure frontier from issue013 now also has a completed fresh contextual adjudication. | Right decision 45316df1b3205224ed64258b2bc0e5a6b34238b9a57018e623225290ed181f96 resolves structure evidence; transport-context decision 6c248e6e9a3daecce9a6b318a9760a15a18570e3ea57c204f330a4ecfe5930ae resolves exact measure and integral nonvacuity. Root released complete validators exit 0. | A blind packet limitation must remain visible in original role outputs and cannot be erased by copying a later conclusion. | evidence questions resolved by independent adjudication; separate transport source admissibility remains unresolved | Preserve all role classifications, prompts and environment hashes. The acoustic gate uses the accepted adjudicated conclusion; the transport row stays READY for its distinct source-domain clarification. Sealed kit and earlier decisions remain unchanged. |')]
for rel,ident,entry in entries:
 p=R/rel;before=p.read_bytes();assert ident.encode() not in before
 digest=hashlib.sha256(before).hexdigest();(S/('ledger-before-right-acceptance-'+digest+'.bin')).write_bytes(before)
 p.write_bytes(before.rstrip(b'\r\n')+b'\n'+entry.encode()+b'\n');records[rel]=sha(p)
out=S/'right-algebraic-acceptance-verification.json';assert not out.exists()
out.write_text(json.dumps({'schema':1,'audit':expected,'ledgers':records,'gate_sha256':sha(G),'proof_manifest_sha256':sha(S/'right-domain-production-inputs.json'),'actual_closure_output_sha256':sha(S/'right-algebraic-row-closure-output.txt'),'original_roundtrip_preserved':'undetermined','accepted_final_classification':'faithful-equivalent','formalized_objects':8,'reused_objects':7,'proved_objects':1},indent=2)+'\n',encoding='utf-8')
print(json.dumps({'receipt_sha256':sha(out),'ledgers':records,'formalized_objects':8}))
