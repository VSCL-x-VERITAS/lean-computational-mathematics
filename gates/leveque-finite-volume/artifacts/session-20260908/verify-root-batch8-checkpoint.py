"""Verify batch-8 foundation organization and the unchanged 32 accepted source rows."""
from pathlib import Path
from collections import Counter
import hashlib,json,subprocess
S=Path(__file__).resolve().parent;R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();read=lambda p:json.loads(p.read_bytes())
bind=lambda p:{'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
git=lambda *a:subprocess.check_output(['git','-c','core.longpaths=true',*a],cwd=R)
head='03c81fa2a551b5089133c958deedc4828899adbd'
assert git('rev-parse','HEAD').decode().strip()==head
assert not git('diff','--name-only','--','ComputationalMathematics','NumStability').strip()
assert sha(R/'docs/architecture/tiers.json')=='b2b31b08695ca45d1594adc1709e714af0373c560e3bafbc1a8ede2e5f3e6510'
pins={
 'root-batch8-placement-verification.json':'cfa34484713dd89a97e0ab3bcaf67d5819b7dd003ea1447e924c97c4da7b1d39',
 'root-batch8-logical-line-verification.json':'72138928eae1c038a6f86a81ce4ef8c71acf6b911c7cbcc685f54d369dd27579',
 'batch7-rebind-preparation/batch8-foundations-rebind-32/summary.json':'eb45e93815ac5aecb004ab144f913657c431794738e94d7657d80162af3c5722',
 'current-thread-clarification-provenance-batch8.json':'2c21df1471dc2dcfaeb69e8d31f7682e41944d6ab176f134f69d41444bf91a30',
 'root-batch8-verification-notes-audit-records.json':'3657af1f3543b2b57f61df3d2ab530656e1d4642c70de1e52d7af1b2734f4977'
}
for path,expected in pins.items():assert sha(S/path)==expected,path
labels=['batch8-foundations-full-build-after-exposure','batch8-tiers','batch8-layout',
 'batch8-compatibility','batch8-hygiene','batch8-graph-capture','batch8-graph-check',
 'batch8-expression-export','batch8-closed-audits','batch8-organization-preflight',
 'batch8-gate','batch8-trackers','batch8-foundations-intro-campaign']
checks=[]
for label in labels:
 p=S/(label+'-exit.json');out=S/(label+'-output.txt');rec=read(p)
 assert type(rec['exit_code']) is int and rec['exit_code']==0,label
 assert rec.get('raw_output_sha256',rec.get('output_sha256'))==sha(out),label
 checks.append({'label':label,'receipt':bind(p),'output':bind(out)})
audits=read(S/'batch8-closed-audits-output.txt')
assert audits['closed_rows']==32 and all(x['exit_code']==0 for x in audits['records'])
G=R/'gates/leveque-finite-volume/chapter-01.json';g=read(G)
assert sha(G)=='be44bbc965afc54df979282166eaa4c2344e9161737009c8c40bb42d3160ffa6'
counts=Counter(x['status'] for x in g['rows'])
assert counts=={'PROVED':15,'REUSED':17,'READY':9,'SKIPPED':16}
classes=Counter(x['classification'] for x in g['rows'] if x['status'] in ('PROVED','REUSED'))
assert classes=={'faithful-equivalent':28,'faithful-stronger':4}
assert all(x['exit_code'] is None for x in g['verification_evidence'].values())
FP=S/'chapter01-current-expression-fingerprints-03c8.json';fp=read(FP)
assert fp['input_commit']==head and len(fp['selected_modules'])==96
assert fp['declaration_count']==401 and fp['new_module_declaration_constants']==338
for f in fp['files']:assert sha(R/f['path'])==f['sha256'],f['path']
graph=S/'architecture-graphs/checkpoint-03c81fa2-foundations.json'
assert fp['compiled_graph_sha256']==sha(graph)
assert fp['source_tree_sha256']==read(graph)['source']['source_tree_sha256']
record={'schema':1,'input_commit':head,'gate':bind(G),'status_counts':dict(counts),
 'classifications':dict(classes),'formalized_objects':32,'remaining_objects':9,'denominator':41,
 'percentage':78.05,'skipped':16,'deferred':0,
 'verification_artifacts':[bind(S/p) for p in pins]+[bind(FP)],
 'checks':checks,'graph':bind(graph),'tiers':bind(R/'docs/architecture/tiers.json'),
 'scope':'Current local material increment. Ten generic owners are exposed and checked; they do not close a source row. The same 32 accepted source rows retain their original sealed judgments and now have current bindings. Global final evidence remains OPEN; eight unadopted source-scope questions remain pending. No candidate or integration claim.'}
p=S/'root-batch8-checkpoint-verification.json'
with p.open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(record,indent=2)+'\n')
print(json.dumps({'verification':bind(p),'counts':dict(counts),'classes':dict(classes),'fingerprints':bind(FP)}))

