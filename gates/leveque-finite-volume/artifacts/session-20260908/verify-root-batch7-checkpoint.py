"""Verify the current FV organization and 32 accepted rows before local checkpointing."""
from pathlib import Path
from collections import Counter
import hashlib,json,subprocess
S=Path(__file__).resolve().parent;R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();read=lambda p:json.loads(p.read_bytes())
bind=lambda p:{'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
git=lambda *a:subprocess.check_output(['git','-c','core.longpaths=true',*a],cwd=R)
assert git('rev-parse','HEAD').decode().strip()=='4d4bc03d138206b13024d8ef353ea85c89181a46'
assert not git('diff','--name-only','--','ComputationalMathematics','NumStability').strip()
assert sha(R/'docs/architecture/tiers.json')=='7e7bd763431edadb9e87b4deb48e1bc7796a3294907b6b06f69c1a57304b244e'
pins={
 'root-batch7-fv-placement-verification.json':'a987b8fada4261daa4d69848b99af317f6b489639d36c0a9ce1107a82dc042ce',
 'root-batch7-tensor-lines-verification.json':'55ef56c8f92d08d0ffff8c482acf4f5f92ec5c2481a05554ca910844bda96a2f',
 'root-equation03-transport-check-exit.json':'bb27b095082343ae068cdced129d7f3b228b13db8d0cd0e362a60daaae0d14b4',
 'chapter01-current-expression-fingerprints-4d4b.json':'05f80d5c97bdeb92cdc2acabb13b19004568b79c80de02012b2c44ad8cd149df',
 'batch6-rebind-preparation/fv-foundations-rebind-31/summary.json':'87260167d30544484b52614e7a3894d96746b47a75781be1d98fba342909759f',
 'batch7-rebind-preparation/batch7-preflight-32/summary.json':'3231c72335ee6a6f81bdf87d4c0ac9bce8609df9c2aa1a24f14f3ba1028d9227'
}
for path,expected in pins.items():assert sha(S/path)==expected,path
labels=['fv-foundations-full-build','fv-foundations-tiers','fv-foundations-layout','fv-foundations-compatibility','fv-foundations-hygiene','fv-foundations-graph-capture','fv-foundations-graph-check','fv-expression-export','root-batch7-closed-audits','root-batch7-organization-preflight','root-batch7-gate','root-batch7-rebind-preflight','root-batch7-trackers-after-pin-note','root-batch7-campaign-repinned','variable-consensus-production-closure']
checks=[]
for label in labels:
 p=S/(label+'-exit.json');out=S/(label+'-output.txt');rec=read(p)
 assert type(rec['exit_code']) is int and rec['exit_code']==0,label
 assert rec.get('raw_output_sha256',rec.get('output_sha256'))==sha(out),label
 checks.append({'label':label,'receipt':bind(p),'output':bind(out)})
audits=read(S/'root-batch7-closed-audits-output.txt')
assert audits['closed_rows']==32 and all(x['exit_code']==0 for x in audits['records'])
g=read(R/'gates/leveque-finite-volume/chapter-01.json')
counts=Counter(x['status'] for x in g['rows']);assert counts=={'PROVED':15,'REUSED':17,'READY':9,'SKIPPED':16}
classes=Counter(x['classification'] for x in g['rows'] if x['status'] in ('PROVED','REUSED'))
assert classes=={'faithful-equivalent':28,'faithful-stronger':4}
assert all(x['exit_code'] is None for x in g['verification_evidence'].values())
record={'schema':1,'input_commit':'4d4bc03d138206b13024d8ef353ea85c89181a46','gate':bind(R/'gates/leveque-finite-volume/chapter-01.json'),'status_counts':dict(counts),'classifications':dict(classes),'formalized_objects':32,'remaining_objects':9,'denominator':41,'percentage':78.05,'skipped':16,'deferred':0,'verification_artifacts':[bind(S/p) for p in pins],'checks':checks,'graph':bind(S/'architecture-graphs/checkpoint-4d4bc03d-fv.json'),'tiers':bind(R/'docs/architecture/tiers.json'),'scope':'Current local material increment; global final evidence remains OPEN. No source acceptance is inferred for the scratch tensor-lines, material-interface or source-balance drafts. No candidate or integration claim.'}
p=S/'root-batch7-checkpoint-verification.json'
with p.open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(record,indent=2)+'\n')
print(json.dumps({'verification':bind(p),'counts':dict(counts),'classes':dict(classes)}))
