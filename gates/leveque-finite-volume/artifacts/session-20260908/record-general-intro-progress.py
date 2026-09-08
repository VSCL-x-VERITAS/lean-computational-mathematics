"""Record actual general prerequisites and the two interpretation-qualified closures."""
from pathlib import Path
import hashlib,json
S=Path(__file__).resolve().parent;R=S.parents[3];sha=lambda b:hashlib.sha256(b).hexdigest()
checks=[]
for label,expected in [('general-propagation-discontinuity-build',0),('general-propagation-discontinuity-checks',0),('general-default-full-build',0),('general-intro-layout',1),('general-intro-tiers',1),('general-intro-compatibility',0),('general-intro-placeholders',0),('general-intro-rebind-right',0),('interpreted-equation02-row-closure',0),('interpreted-equation03-row-closure',0),('wave-equation-row-closure',0)]:
 e=json.loads((S/(label+'-exit.json')).read_text());assert e['exit_code']==expected,label
 checks.append({'label':label,'exit_code':expected,'output_sha256':sha((S/(label+'-output.txt')).read_bytes()),'exit_sha256':sha((S/(label+'-exit.json')).read_bytes())})
layout=(S/'general-intro-layout-output.txt').read_text()
for line in ['Lean modules: 5932','unclassified modules: 5','mixed modules: 0','modules missing module docs: 0','legacy naming exceptions: 0','declaration-bearing umbrellas: 0','unsorted aggregate imports: 0']:assert line in layout,line
assert '12 axiom report(s)' in (S/'general-intro-placeholders-output.txt').read_text()
assert len(json.loads((S/'general-intro-rebinding-receipt.json').read_text()))==9
v=S/'general-propagation-discontinuity-verification.json';assert sha(v.read_bytes())=='c57f0c51cd7c6cf38c6da3c1ed41bcdb571982ac3cbb7a7ef5d2a8e464f6381c'
m=json.loads(v.read_text())
for f in m['files']+m['aggregates']:assert sha((R/f['path']).read_bytes())==f['sha256']
G=R/'gates/leveque-finite-volume/chapter-01.json';before=G.read_bytes();g=json.loads(before)
closed=[r for r in g['rows'] if r['status'] in ['PROVED','REUSED','DISCREPANCY']];assert len(closed)==13
for eq,expected in [('1.2','32fe876cf53c15ab936bec9f89ceff49214a9eb48628b0e310d51f2910a37815'),('1.3','7592cfc9bc82067b1f89c4fa3c040111ab8e34ee3eb3e6264cfa9d1b0dacf79c')]:
 task=S/'audits'/('LEV-CH01-EQ-'+eq+'-INTERPRETED-DOMAINS-PRODUCTION-20260908')
 p=task/'faithfulness/decision.json';assert sha(p.read_bytes())==expected
 d=json.loads(p.read_text());assert d['accepted'] and d['classification']=='faithful-equivalent'
 row=next(r for r in closed if r['faithfulness_task']==(task/'audit-task.json').relative_to(R).as_posix())
 contract=json.loads((G.parent/row['source_contract_artifact']).read_text())['payload']['contract']
 assert '26f16aeef42a0c7de4865c4c00e9ba223a9ae53604abf55da427171f6bf8e16b' in contract['statement']
 assert 'source-only' in contract['statement'] and any('Adopted interpretation:' in x for x in contract['assumptions'])
source=R/'ledgers/leveque-finite-volume/book-issues/leveque-finite-volume/chapters/chapter-01/issues.md'
process=R/'ledgers/leveque-finite-volume/skill-issues/book-formalization/leveque-finite-volume/sessions/codex-start-1-v5-0-1-20260908/issues.md'
entries=[
(source,'LEV-C1-INTERPRETED-TRANSPORT-ACCEPTANCE-020','| LEV-C1-INTERPRETED-TRANSPORT-ACCEPTANCE-020 | LEV-CH01-EQ-1.2-ADVECTION; LEV-CH01-EQ-1.3-ADVECTED-PROFILE | interpretation-qualified closure | Original arbitrary-profile wording leaves the exact classical and integral domains implicit; the PDF-only ambiguity remains preserved | The user-adopted convention is explicitly represented by exact necessary-and-sufficient differentiability and local interval-integrability domains and unrestricted geometric translation | Both fresh audits accept faithful-equivalent, yes in both directions; Eq1.3 required independent adjudication resolving the native real-measure identification | decisions 32fe876cf53c15ab936bec9f89ceff49214a9eb48628b0e310d51f2910a37815 and 7592cfc9bc82067b1f89c4fa3c040111ab8e34ee3eb3e6264cfa9d1b0dacf79c; user receipt 26f16aeef42a0c7de4865c4c00e9ba223a9ae53604abf55da427171f6bf8e16b; root complete validators exit 0 | The gate source contracts explicitly retain the user interpretation and original source-account hash. Do not report unqualified PDF-only equivalence or remove earlier nonaccepted audits, the original roundtrip UND, or the contextual (11.33) issue. |'),
(process,'BF-LEV-RUN-20260908-019','| BF-LEV-RUN-20260908-019 | 2026-09-08 | interpretation-aware legacy gate projection | Accepted decisions for the exact transport-domain targets expressly qualify both implications by the recorded user convention | bind-interpreted-proved-row.py and interpreted-gate-adapter-derivation.json; complete validators and exact native proof receipts | An ordinary source-only contract projection would lose this qualification | resolved by a session-local adapter; released schema and validators unchanged | Verify row/source scope and exact environment-bound user receipt; include the adopted convention and preserved limitations in the structured hashed gate contract; rebind only an unchanged contract. |')]
for path,ident,entry in entries:
 original=path.read_bytes();assert ident.encode() not in original
 (S/('ledger-before-'+ident+'-'+sha(original)+'.bin')).write_bytes(original)
 path.write_bytes(original.rstrip(b'\r\n')+b'\n'+entry.encode()+b'\n')
(S/('gate-before-general-intro-'+sha(before)+'.json')).write_bytes(before)
g['verification_loops']['organization_completeness']={'unclassified_modules':5,'duplicate_wrappers':0,'placeholder_findings':0,'canonical_placement_pending':0}
for row in g['rows']:
 if row['id']=='LEV-CH01-EIGENVALUES-WAVE-SPEEDS':
  assert row['status']=='READY';row['next_foundation']='The complete-eigenbasis propagation target is now canonical, compiled and axiom checked. Complete the fresh general-propagation audit; preserve the old structurally rejected single-mode target and explicit joint differentiability.'
 if row['id']=='LEV-CH01-DISCONTINUITY-INTEGRAL-LAW':
  assert row['status']=='READY';row['next_foundation']='The general arbitrary-flux finite-vector comparison and positive-time jump witness are canonical, compiled and axiom checked. Complete the fresh audit under the separately recorded rectangle/a.e.-mass-rate and spatial-state-differentiability user convention; preserve source ambiguity and the conservative-residual distinction.'
for name in g['verification_evidence']:g['verification_evidence'][name]={'command':'','artifact':'','artifact_sha256':'','exit_code':None,'count':0}
record={'schema':1,'checks':checks,'new_files':7,'new_declarations':12,'formalized':13,'remaining':28,'denominator':41,'skipped':16,'deferred':0,'organization':g['verification_loops']['organization_completeness'],'next_organization':'Add five exact reusable-owner rules using the actual addition commit and refresh the measured census.'}
p=S/'general-intro-progress-verification.json';assert not p.exists();p.write_text(json.dumps(record,indent=2)+'\n')
G.write_text(json.dumps(g,indent=2,ensure_ascii=False)+'\n',encoding='utf-8',newline='\n')
print(json.dumps({'verification_sha256':sha(p.read_bytes()),'gate_sha256':sha(G.read_bytes()),'counts':record}))
