"""Retain a qualified acceptance and a distinct unresolved source-scope audit."""
from pathlib import Path
import hashlib,json,subprocess
S=Path(__file__).resolve().parent;R=S.parents[3];sha=lambda b:hashlib.sha256(b).hexdigest()
records=[]
for ident,expected,accepted in [
 ('LEV-CH01-DISCONTINUITY-INTERPRETED-GENERAL-PRODUCTION-20260908','42e6f5a80be35b8c8723905f19066fcd31b315323debf4477525b8fa160f0b56',True),
 ('LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908','22dba9b9b51021adfdd3276c752702d8567946e4db95675bb1bdc3875d93803e',False)]:
 p=S/'audits'/ident/'faithfulness/decision.json';assert sha(p.read_bytes())==expected
 d=json.loads(p.read_text());assert d['accepted'] is accepted
 records.append({'task':ident,'decision_sha256':expected,'classification':d['classification'],'findings':d['findings'],'remaining_uncertainties':d['remaining_uncertainties']})
e=json.loads((S/'general-discontinuity-row-closure-correct-path-exit.json').read_text());assert e['exit_code']==0
org=S/'general-organization-verification.json';assert sha(org.read_bytes())=='00469cf32cc3110eae4443262c929ffda3efe6a7894b3399b5106e2c5638bb18'
record=json.loads(org.read_text());assert sha((R/'docs/architecture/tiers.json').read_bytes())==record['tiers_sha256']
for f in record['files']+record['aggregates']:assert sha((R/f['path']).read_bytes())==f['sha256']
run=subprocess.run(['git','-c','core.longpaths=true','diff','--exit-code','8fc002c9805c634086fc6e7b77e1b69c388a4e2e','--','.',':(exclude)gates/**',':(exclude)ledgers/**'],cwd=R,stdout=subprocess.PIPE,stderr=subprocess.PIPE);assert run.returncode==0,run.stdout
G=R/'gates/leveque-finite-volume/chapter-01.json';before=G.read_bytes();g=json.loads(before)
assert sum(r['status'] in ['PROVED','REUSED','DISCREPANCY'] for r in g['rows'])==17
row=next(r for r in g['rows'] if r['id']=='LEV-CH01-EIGENVALUES-WAVE-SPEEDS');assert row['status']=='READY'
row['next_foundation']='The complete-eigenbasis propagation theorem is compiled; its fresh audit remains undetermined solely on whether the source includes less regular waves than global joint differentiability. The exact classical-interpretation question is pending. Preserve the rejected single-mode and unresolved general audits; continue independent obligations without inventing a source regularity convention.'
(S/('general-outcomes-prior-gate-'+sha(before)+'.json')).write_bytes(before)
G.write_text(json.dumps(g,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
path=R/'ledgers/leveque-finite-volume/book-issues/leveque-finite-volume/chapters/chapter-01/issues.md'
entries=[
 ('LEV-C1-GENERAL-DISCONTINUITY-ACCEPTANCE-024','| LEV-C1-GENERAL-DISCONTINUITY-ACCEPTANCE-024 | LEV-CH01-DISCONTINUITY-INTEGRAL-LAW | generality and separately adopted solution convention | The discontinuity paragraph leaves temporal and classical regularity conventions implicit | Arbitrary finite vector dimension and flux; rectangle conservation yields mass-rate equality almost everywhere for each fixed spatial interval, while a spatial jump excludes state differentiability and classical solutionhood | accepted faithful-equivalent under the exact user interpretation | decision 42e6f5a80be35b8c8723905f19066fcd31b315323debf4477525b8fa160f0b56; report 8abda1b95945a279157e456c564314b979770d30cdfa3d8f7d57a0e8aa839163; receipt b27e7d260e93edcd5408daa8c5d291ba8bfefd9e66a079480ae6b940aa869030; root complete and native proof validation exit 0 | Resolves the former scalar-only coverage gap under the recorded interpretation. Preserve the PDF-only ambiguity, interval-dependent null sets, distinction from a weaker composed-flux residual, and separate smooth-data shock-formation obligation. |'),
 ('LEV-C1-GENERAL-PROPAGATION-REGULARITY-025','| LEV-C1-GENERAL-PROPAGATION-REGULARITY-025 | LEV-CH01-EIGENVALUES-WAVE-SPEEDS | solution-class ambiguity after structural repair | Pages 1-3 leave the regularity of component waves unspecified | The general theorem supplies a complete real eigenbasis, exact scalar decoupling and translation/reconstruction for globally jointly differentiable solutions | undetermined after independent adjudication; source implies Lean yes, Lean implies source unclear | decision 22dba9b9b51021adfdd3276c752702d8567946e4db95675bb1bdc3875d93803e; report 90766e79ef47fdd2be0e2b51ad758cf21b05066d15487f3cd22e98105dd51ddf | No spectral, sign, coordinate or vacuity defect remains. Do not call potentially reduced applicability faithful-stronger. The user classical-interpretation question is pending; no choice is inferred from earlier transport or discontinuity replies. |')]
for ident,entry in entries:
 data=path.read_bytes();assert ident.encode() not in data
 (S/('ledger-before-'+ident+'-'+sha(data)+'.bin')).write_bytes(data)
 path.write_bytes(data.rstrip(b'\r\n')+b'\n'+entry.encode()+b'\n')
result={'schema':1,'audits':records,'root_discontinuity_complete_check':e,'unchanged_controlled_tree_since':'8fc002c9805c634086fc6e7b77e1b69c388a4e2e','controlled_git_diff_exit':run.returncode,'organization_evidence_sha256':sha(org.read_bytes()),'counts':{'formalized':17,'remaining':24,'denominator':41,'skipped':16,'deferred':0},'global_gate_evidence':'OPEN','preserved_operational_failure':'general-discontinuity-row-closure-exit.json: incorrect log basename, failed before any gate mutation; corrected-path invocation validated exact existing native evidence.'}
p=S/'general-audit-outcomes-verification.json';assert not p.exists();p.write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps({'receipt_sha256':sha(p.read_bytes()),'gate_sha256':sha(G.read_bytes()),'counts':result['counts']}))
