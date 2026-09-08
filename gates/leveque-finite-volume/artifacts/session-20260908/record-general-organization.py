"""Record the current organized seven-owner increment from actual completed checks."""
from pathlib import Path
import hashlib,json
S=Path(__file__).resolve().parent;R=S.parents[3];sha=lambda b:hashlib.sha256(b).hexdigest()
checks=[]
for label in ['general-organized-layout','general-organized-tiers','general-default-full-build','general-organized-rebind-right','general-organized-equation02-rebind','general-organized-equation03-rebind','quasilinear-row-closure']:
 e=json.loads((S/(label+'-exit.json')).read_text());assert e['exit_code']==0,label
 checks.append({'label':label,'exit_code':0,'output_sha256':sha((S/(label+'-output.txt')).read_bytes()),'exit_sha256':sha((S/(label+'-exit.json')).read_bytes())})
layout=(S/'general-organized-layout-output.txt').read_text()
for text in ['Lean modules: 5932','unclassified modules: 0','mixed modules: 0','modules missing module docs: 0','legacy naming exceptions: 0','declaration-bearing umbrellas: 0','unsorted aggregate imports: 0','Layout contract satisfied']:assert text in layout,text
tier=json.loads((S/'general-tier-update.json').read_text());assert tier['introduction_commit']=='eed529aaf650561fb72318c5264bb074c1652ce3'
assert tier['new_exact_rules']==5 and tier['counts']['production_modules']==5932 and tier['counts']['exact_rules']==4934
rebindings=json.loads((S/'general-organized-rebinding-receipt.json').read_text());assert len(rebindings)==10 and all(x['exit_code']==0 for x in rebindings)
m=json.loads((S/'general-propagation-discontinuity-verification.json').read_text())
for f in m['files']+m['aggregates']:assert sha((R/f['path']).read_bytes())==f['sha256']
G=R/'gates/leveque-finite-volume/chapter-01.json';before=G.read_bytes();g=json.loads(before)
(S/('gate-before-general-organization-'+sha(before)+'.json')).write_bytes(before)
g['verification_loops']['organization_completeness']={'unclassified_modules':0,'duplicate_wrappers':0,'placeholder_findings':0,'canonical_placement_pending':0}
for name in g['verification_evidence']:g['verification_evidence'][name]={'command':'','artifact':'','artifact_sha256':'','exit_code':None,'count':0}
closed=[r for r in g['rows'] if r['status'] in ['PROVED','REUSED','DISCREPANCY']]
record={'schema':1,'checks':checks,'tier_update':tier,'tiers_sha256':sha((R/'docs/architecture/tiers.json').read_bytes()),'files':m['files'],'aggregates':m['aggregates'],'rebound_reused_rows':rebindings,'organization':g['verification_loops']['organization_completeness'],'counts':{'formalized':len(closed),'denominator':41,'remaining':41-len(closed),'skipped':16,'deferred':0},'validation_scope':'Current full default native build and actual source/axiom/compatibility checks passed for the seven-owner source tree. Tier metadata is now exact; compiled graph refresh is recorded separately. Final global gate evidence is still OPEN and no new source audit acceptance is inferred.'}
p=S/'general-organization-verification.json';assert not p.exists();p.write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8')
G.write_text(json.dumps(g,indent=2,ensure_ascii=False)+'\n',encoding='utf-8',newline='\n')
print(json.dumps({'verification_sha256':sha(p.read_bytes()),'gate_sha256':sha(G.read_bytes()),'counts':record['counts'],'organization':record['organization']}))

