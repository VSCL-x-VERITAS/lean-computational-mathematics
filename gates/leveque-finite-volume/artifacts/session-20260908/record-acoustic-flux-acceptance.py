"""Freeze two more accepted rows without reclassifying unchanged mathematics."""
from pathlib import Path
import hashlib,json,subprocess
S=Path(__file__).resolve().parent;R=S.parents[3];sha=lambda b:hashlib.sha256(b).hexdigest()
items=[]
for ident,label,expected in [
 ('LEV-CH01-EQ-1.4-ACOUSTIC-MODEL-PRODUCTION-20260908','acoustic-model-row-closure','45c7565c2321a0981dd9c3c479106d7ef8deae388b631f289f6e753d1a07f87a'),
 ('LEV-CH01-LINEAR-FLUX-SPECIALIZATION-CANONICAL-20260908','linear-flux-row-closure','14727e8a7ac5b01aa6aa787861764e4b51aa7e22a0cae15df63a532eeadd26e6')]:
 p=S/'audits'/ident/'faithfulness/decision.json';assert sha(p.read_bytes())==expected
 d=json.loads(p.read_text());assert d['accepted'] and d['classification']=='faithful-equivalent'
 e=json.loads((S/(label+'-exit.json')).read_text());assert e['exit_code']==0
 items.append({'task':ident,'decision_sha256':expected,'findings':d['findings'],'root_complete_check':e,'output_sha256':sha((S/(label+'-output.txt')).read_bytes())})
org=S/'general-organization-verification.json';assert sha(org.read_bytes())=='00469cf32cc3110eae4443262c929ffda3efe6a7894b3399b5106e2c5638bb18'
record=json.loads(org.read_text())
assert sha((R/'docs/architecture/tiers.json').read_bytes())==record['tiers_sha256']
for f in record['files']+record['aggregates']:assert sha((R/f['path']).read_bytes())==f['sha256']
run=subprocess.run(['git','diff','--exit-code','8fc002c9805c634086fc6e7b77e1b69c388a4e2e','--','.',':(exclude)gates/**',':(exclude)ledgers/**'],cwd=R,stdout=subprocess.PIPE,stderr=subprocess.PIPE);assert run.returncode==0,run.stdout
G=R/'gates/leveque-finite-volume/chapter-01.json';g=json.loads(G.read_text())
closed=[r for r in g['rows'] if r['status'] in ['PROVED','REUSED','DISCREPANCY']];assert len(closed)==16
assert all(v==0 for v in g['verification_loops']['organization_completeness'].values())
path=R/'ledgers/leveque-finite-volume/book-issues/leveque-finite-volume/chapters/chapter-01/issues.md'
entries=[
('LEV-C1-ACOUSTIC-MODEL-ACCEPTANCE-022','| LEV-C1-ACOUSTIC-MODEL-ACCEPTANCE-022 | LEV-CH01-EQ-1.4-ONE-WAY-WAVE | actual acoustic connection and material-domain reduction | Equation (1.4) is connected to the pressure/velocity system and sound-speed formula surrounding (1.5)-(1.6) | The successor names the given system, exact p+rho*c*u combination and c=sqrt(K/rho), plus scalar hyperbolicity and rightward transport | accepted faithful-equivalent after independent adjudication, both implications yes | decision 45c7565c2321a0981dd9c3c479106d7ef8deae388b631f289f6e753d1a07f87a; report 3677ca6633b36fac9d9929ca81737cffa40e26d4959b9c087d1cd1ec07ce2e79; exact native proof and complete-validator exits 0 | Resolves the weaker-model rejection in issue 007 without rewriting its audit. The adjudicator independently uses (-K,-rho,p,-u) to cover the signed-parameter question and spatial reflection for complementary-mode coverage. Original roundtrip UND and physical interpretations remain recorded. |'),
('LEV-C1-LINEAR-FLUX-CLASSICAL-DOMAIN-023','| LEV-C1-LINEAR-FLUX-CLASSICAL-DOMAIN-023 | LEV-CH01-LINEAR-FLUX-SPECIALIZATION | explicit classical derivative domain | The source identifies the constant-matrix system as a conservation law with f(q)=Aq | The pointwise equivalence expressly assumes the spatial state derivative and retains temporal derivative existence on both sides | accepted faithful-equivalent, independent direct and roundtrip both yes/yes | decision 14727e8a7ac5b01aa6aa787861764e4b51aa7e22a0cae15df63a532eeadd26e6; report c973be18ebb76c0206d8d80e8f7c1540340d95515bf2c8e1dc1b4db4b4e87f39; complete-validator exit 0 | A singular matrix, including A=0, can hide spatial state irregularity in the composed flux. Do not drop the classical derivative premise, infer invertibility or hyperbolicity, or extend this equivalence to discontinuous weak solutions. The empty-dimensional case is harmless. |')]
for ident,entry in entries:
 before=path.read_bytes();assert ident.encode() not in before
 (S/('ledger-before-'+ident+'-'+sha(before)+'.bin')).write_bytes(before)
 path.write_bytes(before.rstrip(b'\r\n')+b'\n'+entry.encode()+b'\n')
result={'schema':1,'accepted':items,'unchanged_controlled_tree_since':'8fc002c9805c634086fc6e7b77e1b69c388a4e2e','controlled_git_diff_exit':run.returncode,'organization_evidence_sha256':sha(org.read_bytes()),'counts':{'formalized':16,'remaining':25,'denominator':41,'skipped':16,'deferred':0},'global_gate_evidence':'OPEN'}
p=S/'acoustic-flux-acceptance-verification.json';assert not p.exists();p.write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps({'receipt_sha256':sha(p.read_bytes()),'gate_sha256':sha(G.read_bytes()),'counts':result['counts']}))
