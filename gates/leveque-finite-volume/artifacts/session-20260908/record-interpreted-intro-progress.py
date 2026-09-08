"""Record checked transport owners, accepted decoupling, and preserved source findings."""
from pathlib import Path
import hashlib,json
S=Path(__file__).resolve().parent;R=S.parents[3];sha=lambda b:hashlib.sha256(b).hexdigest()
checks=[]
for label,expected in [('interpreted-transport-production-build',0),('interpreted-transport-production-checks',0),('interpreted-intro-layout',1),('interpreted-intro-tiers',1),('interpreted-intro-compatibility',0),('interpreted-intro-placeholders',0),('interpreted-intro-rebind-right',0),('two-wave-row-closure',0)]:
 e=json.loads((S/(label+'-exit.json')).read_text(encoding='utf-8-sig'));assert e['exit_code']==expected,label
 checks.append({'label':label,'exit_code':expected,'output_sha256':sha((S/(label+'-output.txt')).read_bytes()),'exit_sha256':sha((S/(label+'-exit.json')).read_bytes())})
layout=(S/'interpreted-intro-layout-output.txt').read_text(encoding='utf-8-sig')
for line in ['Lean modules: 5925','unclassified modules: 2','mixed modules: 0','modules missing module docs: 0','legacy naming exceptions: 0','declaration-bearing umbrellas: 0','unsorted aggregate imports: 0']:assert line in layout,line
assert 'unreachable' not in layout
assert '4 axiom report(s)' in (S/'interpreted-intro-placeholders-output.txt').read_text()
assert len(json.loads((S/'interpreted-intro-rebinding-receipt.json').read_text()))==7
verification=S/'interpreted-transport-production-verification.json'
assert sha(verification.read_bytes())=='1d29d6ff7cc0f87ba18075b5e0c184873466335eb7569f6886549455f7dccc32'
for f in json.loads(verification.read_text())['files']:assert sha((R/f['path']).read_bytes())==f['sha256']
decisions={}
for ident,expected,accepted in [
 ('LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908','f1b9a00bbc4a18c2dbc7d31a6dae87aecb561ff9dfcddb38e6a16d232afd29aa',False),
 ('LEV-CH01-ACOUSTICS-LEFT-MODE-CANONICAL-20260908','ea7b43ef78d9ee144b4095446c6a7c801f7d08dfebfc59f2069b9e19b94b36eb',False),
 ('LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION-CANONICAL-20260908','42af2da45a10ecf5fced133ef3f28ec0bdd370427b5ed762f3a72611346c7a1b',True)]:
 p=S/'audits'/ident/'faithfulness/decision.json';assert sha(p.read_bytes())==expected
 d=json.loads(p.read_text());assert d['accepted'] is accepted
 decisions[ident]={'decision_sha256':expected,'classification':d['classification'],'accepted':accepted}
source=R/'ledgers/leveque-finite-volume/book-issues/leveque-finite-volume/chapters/chapter-01/issues.md'
process=R/'ledgers/leveque-finite-volume/skill-issues/book-formalization/leveque-finite-volume/sessions/codex-start-1-v5-0-1-20260908/issues.md'
entries=[
(source,'LEV-C1-DISCONTINUITY-GENERALITY-014','| LEV-C1-DISCONTINUITY-GENERALITY-014 | LEV-CH01-DISCONTINUITY-INTEGRAL-LAW | restricted example and temporal ambiguity | The source compares general vector/nonlinear differential and integral conservation laws for discontinuous solutions; its exceptional-time convention is implicit | The fixed scalar moving-step witness establishes real discontinuity and rectangle balance, but not the general comparison | undetermined after independent adjudication; accepted false; Lean implies source no, source implies Lean unclear | decision f1b9a00bbc4a18c2dbc7d31a6dae87aecb561ff9dfcddb38e6a16d232afd29aa; report 63366b0cc711108b62f67198ac8955464cc8dc0557dc4677cf965a6eb069003d; root complete validation exit 0 | Preserve the audit. A general finite-vector rectangle-to-mass-derivative-almost-everywhere theorem is now proved and checked as a source-independent prerequisite. Complete the general discontinuity obstruction and correspondence; the temporal source interpretation remains separate from the user choice limited to equations (1.2)-(1.3). |'),
(source,'LEV-C1-USER-TRANSPORT-INTERPRETATION-015','| LEV-C1-USER-TRANSPORT-INTERPRETATION-015 | LEV-CH01-EQ-1.2-ADVECTION; LEV-CH01-EQ-1.3-ADVECTED-PROFILE | explicit user resolution of interpretation choice | The source ambiguity in issues 009, 010 and 012 remains preserved; later printed pp17-18 clarify the smooth case without specifying an exhaustive nonsmooth class | User adopted geometry for every real profile, classical solutions for differentiable profiles, and rectangle conservation for locally integrable profiles | interpretation adopted; fresh independent audits pending; prior undetermined decisions unchanged | exact user receipt SHA 26f16aeef42a0c7de4865c4c00e9ba223a9ae53604abf55da427171f6bf8e16b; checked production verification 1d29d6ff7cc0f87ba18075b5e0c184873466335eb7569f6886549455f7dccc32 | Audit the new necessary-and-sufficient domain compositions under the separately recorded interpretation. Do not attribute the convention to the printed book or extend it silently to other source rows. |'),
(source,'LEV-C1-LEFT-MODE-PROFILE-CONTEXT-016','| LEV-C1-LEFT-MODE-PROFILE-CONTEXT-016 | LEV-CH01-ACOUSTICS-LEFT-MODE | unresolved exhaustive profile regularity | The source distinguishes its second characteristic variable and a profile solution of the same left-moving equation; nonsmooth coverage is not exhaustive | Independent review confirms signs, mode PDE, and differentiable-profile branch without asserting q2 equals w2 | undetermined after adjudication; accepted false; source implies Lean yes, Lean implies source unclear | decision ea7b43ef78d9ee144b4095446c6a7c801f7d08dfebfc59f2069b9e19b94b36eb; report b62b579c64b19cc1afb51425592ade103959d26f5d177f93c61b020c6b380459 | Preserve the result and separate fields. Search for a general left-moving transport domain characterization and prepare the smallest source-specific repair. The user convention was expressly limited to equations (1.2)-(1.3). |'),
(process,'BF-LEV-RUN-20260908-016','| BF-LEV-RUN-20260908-016 | 2026-09-08 | user interpretation provenance and fresh audits | A material profile-domain choice remained after additional pinned-source review. The user explicitly adopted the proposed convention for equations (1.2)-(1.3). | user receipt 26f16aeef42a0c7de4865c4c00e9ba223a9ae53604abf55da427171f6bf8e16b; worker context review ec5198495494ed4d2c13b11099e71154704a5ab7d795d5158ca1436ccb7ae6be | Source text and user interpretation must remain distinguishable; a proof or prior audit does not settle an unstated convention. | recorded; fresh audit work active | Create new targets and configs with immutable user-input/environment binding; preserve exact blind packets and prior outcomes. Do not alter the selected PDF, profile or sealed kit. |'),
(process,'BF-LEV-RUN-20260908-017','| BF-LEV-RUN-20260908-017 | 2026-09-08 | native diagnostic display encoding | The first rectangle mass draft failed to resolve the root-namespace LocallyIntegrable theorem; the capture helper then failed to display Unicode diagnostics through CP1252. Raw Lean failure bytes and actual exit 1 had already been saved correctly. | rectangle-mass-derivative-check failure and before-repair snapshots; corrected native check output 8b28a1d09ee92b4fe17604bc82135b4ec48ecd7d1d50a19d3fbf29896a783dbc | A display exception must not overwrite or reinterpret the native compiler result. | repaired; all original evidence retained | Use explicit LocallyIntegrable.ae_hasDerivAt_integral and write raw captured bytes to stdout.buffer. Corrected draft and canonical proof checks independently exit 0. |')]
for path,ident,entry in entries:
 before=path.read_bytes();assert ident.encode() not in before
 (S/('ledger-before-'+ident+'-'+sha(before)+'.bin')).write_bytes(before)
 path.write_bytes(before.rstrip(b'\r\n')+b'\n'+entry.encode()+b'\n')
G=R/'gates/leveque-finite-volume/chapter-01.json';before=G.read_bytes();g=json.loads(before)
closed=[r for r in g['rows'] if r['status'] in ['PROVED','REUSED','DISCREPANCY']];assert len(closed)==9
(S/('gate-before-interpreted-intro-'+sha(before)+'.json')).write_bytes(before)
g['verification_loops']['organization_completeness']={'unclassified_modules':2,'duplicate_wrappers':0,'placeholder_findings':0,'canonical_placement_pending':0}
updates={
'LEV-CH01-EQ-1.2-ADVECTION':'The user explicitly adopted the recorded transport convention. The exact uniform-transport domain composition is now canonical and native checked. Complete fresh interpreted-domain v1 preparation and independent audit; preserve previous source uncertainty and old audits.',
'LEV-CH01-EQ-1.3-ADVECTED-PROFILE':'The user explicitly adopted the recorded transport convention. The translated-profile geometry and exact classical/rectangle domain composition is now canonical and native checked. Complete its fresh interpreted-domain audit; preserve the original source ambiguity and prior undetermined audits.',
'LEV-CH01-DISCONTINUITY-INTEGRAL-LAW':'The fixed witness audit is nonaccepted because it omits general vector/nonlinear scope and leaves temporal interpretation uncertain. A generic finite-vector rectangle-to-mass-derivative-almost-everywhere theorem is now proved and checked. Next formalize the general classical discontinuity obstruction and construct the source correspondence without extending the Eq1.2-1.3 user convention.',
'LEV-CH01-ACOUSTICS-LEFT-MODE':'The frozen audit confirms mode/sign/PDE and separates q2 from w2, but remains undetermined on exhaustive nonsmooth profile coverage. Search existing left-transport characterizations and prepare a precise source-specific repair; do not repeat the unchanged audit.'}
for row in g['rows']:
 if row['id'] in updates:assert row['status']=='READY';row['next_foundation']=updates[row['id']]
for name in g['verification_evidence']:g['verification_evidence'][name]={'command':'','artifact':'','artifact_sha256':'','exit_code':None,'count':0}
G.write_text(json.dumps(g,indent=2,ensure_ascii=False)+'\n',encoding='utf-8',newline='\n')
record={'schema':1,'checks':checks,'decisions':decisions,'new_files':4,'new_declarations':4,'formalized':9,'remaining':32,'denominator':41,'skipped':16,'deferred':0,'organization':g['verification_loops']['organization_completeness'],'next_organization':'Add two exact reusable-owner rules using the real addition commit and refresh measured census.'}
p=S/'interpreted-intro-progress-verification.json';assert not p.exists();p.write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'verification_sha256':sha(p.read_bytes()),'gate_sha256':sha(G.read_bytes()),'counts':record}))

