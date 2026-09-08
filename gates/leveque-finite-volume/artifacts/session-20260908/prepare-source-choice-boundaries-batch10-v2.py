from pathlib import Path
import json,hashlib
S=Path(__file__).resolve().parent;R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def ref(p):return dict(path=p.relative_to(R).as_posix(),sha256=sha(p))
prior=S/'prospective-source-choice-boundaries-batch10.json'
assert sha(prior)=='29454cddf004123bf48c1262d1cc55a7e5a88ed51fc85249c26f7ee2e426db7f'
data=json.loads(prior.read_bytes())
row=next(x for x in data['rows'] if x['row_id']=='LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION')
old_locator=row['source_locator']
audit=S/'audits/LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908/faithfulness'
assert sha(audit/'decision.json')=='4a99d9c61f874c30b7c2c8748faca51327d3066d81ed15c96d9d59fe93a12c9a'
assert sha(audit/'inputs/source_locator.json')=='5138ebf55521db78a275562f9f116c8465ced4a9bcdfed09682ad39a37e7ad1f'
row['source_locator']=ref(audit/'inputs/source_locator.json')
row['frozen_audits'] += [ref(audit/'decision.json'),ref(audit/'manifest.json')]
row['boundary'] += ' The later hyperbolic-problem-data audit explicitly resolves the governing residual/principal-matrix connection and records the remaining equation-domain/equal-state scope ambiguity; the earlier rejection remains preserved as history.'
dim=next(x for x in data['rows'] if x['row_id']=='LEV-CH01-DIMENSIONAL-SPLITTING')
dim['boundary']=dim['boundary'].replace('totality/exactness of numerical solvers is separate repairable implementation scope.','solver totality/exactness is a separate representation issue addressed by the compiled admitted information-method sweep and arbitrary full-line Cartesian correspondence; neither result resolves the logical-geometry convention.')
out=S/'prospective-source-choice-boundaries-batch10-v2.json'
with out.open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(data,indent=2)+'\n')
derivation=S/'source-choice-boundaries-batch10-v2-derivation.json'
with derivation.open('x',encoding='utf-8',newline='') as f:json.dump(dict(prior=ref(prior),output=ref(out),retained_prior_locator=old_locator,review='Root read full later RIEMANN decision and locator; retain both rejected audits and use latest locator. Clarify compiled DIM representation repair separately from pending source geometry. No local-exhaustion or source-acceptance assertion.'),f,indent=2)
print(json.dumps(dict(output=ref(out),derivation=ref(derivation))))

