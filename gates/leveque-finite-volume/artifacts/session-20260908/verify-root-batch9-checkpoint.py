"""Verify the reviewed six-leaf increment, supporting alternatives and unchanged accepted source set."""
from pathlib import Path
from collections import Counter
import hashlib,json,subprocess
S=Path(__file__).resolve().parent;R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();read=lambda p:json.loads(p.read_bytes())
bind=lambda p:{'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
git=lambda *a:subprocess.check_output(['git','-c','core.longpaths=true',*a],cwd=R)
head='521f73a23a95a842928c581fa011a46379b3b547'
assert git('rev-parse','HEAD').decode().strip()==head
assert not git('diff','--name-only','--','ComputationalMathematics','NumStability').strip()
assert sha(R/'docs/architecture/tiers.json')=='d2e3d27cc54a09021083064eed68f45741e06b2255c672c0bd79dc2307002aa2'
pins={
 'root-batch9-production-placement-verification.json':'7972c821babf7148e14e7b4c3a8e2ad28fb04a072f795c224163dff7f393cddd',
 'root-batch9-left-alternative-verification.json':'001d20b4a682aa030787e5ab8b3484c45d35fa35967eb3012f916b7f320214a3',
 'root-batch9-capstone-evidence-verification.json':'d33c88b947de268fd3f66032a40835dd669b96418fd058f46fc5d741df2ff0e1',
 'batch7-rebind-preparation/batch9-foundations-rebind-32/summary.json':'9d98bfe2dc1912217439399fba4f6e4372f8ff29ca46638027365edc26133974',
 'current-thread-clarification-provenance-batch9.json':'764aeb5a5bc813c55d85165eca3ac1b98b71be98b6ab307b53cd59e0ee03989c',
 'root-batch9-reviewed-progress-audit-records.json':'07070aba4ba9455118bcb7b02b35bae4a80414c59e54d01288cb4a13084ddf36',
 'final-epoch-asset-helper-draft/final-receipt.json':'030c64325d425ca5d118ee3850e644374da20334ec17d08150379661a05fcee0'
}
for path,h in pins.items():assert sha(S/path)==h,path
labels=['batch9-foundations-full-build','batch9-tiers','batch9-layout','batch9-compatibility',
 'batch9-hygiene','batch9-graph-capture','batch9-graph-check','batch9-expression-export',
 'batch9-closed-audits','batch9-organization-preflight','batch9-gate','batch9-trackers',
 'root-batch9-campaign-before-exposure','root-batch9-asset-helper-fixtures']
checks=[]
for label in labels:
 p=S/(label+'-exit.json');out=S/(label+'-output.txt');n=read(p)
 assert type(n['exit_code']) is int and n['exit_code']==0,label
 assert n.get('raw_output_sha256',n.get('output_sha256'))==sha(out),label
 checks.append({'label':label,'receipt':bind(p),'output':bind(out)})
audits=read(S/'batch9-closed-audits-output.txt')
assert audits['mode']=='released-complete-validation' and audits['closed_rows']==32
assert len(audits['records'])==32 and all(x['exit_code']==0 for x in audits['records'])
G=R/'gates/leveque-finite-volume/chapter-01.json';g=read(G)
assert sha(G)=='4e9d0afc6c20c55b7475c0b332b2eb600cf0266a18f1b81607c8aaba89bb64d2'
counts=Counter(x['status'] for x in g['rows']);assert counts=={'PROVED':15,'REUSED':17,'READY':9,'SKIPPED':16}
classes=Counter(x['classification'] for x in g['rows'] if x['status'] in ['PROVED','REUSED'])
assert classes=={'faithful-equivalent':28,'faithful-stronger':4}
assert all(x['exit_code'] is None for x in g['verification_evidence'].values())
fp_path=S/'chapter01-current-expression-fingerprints-521f.json';fp=read(fp_path)
assert sha(fp_path)=='5c2dcd727b7103b6b47de8899505705a2db6de59beb97228dc6c0ed2677d8553'
assert fp['input_commit']==head and len(fp['selected_modules'])==102 and fp['declaration_count']==458
assert fp['new_module_declaration_constants']==395
for f in fp['files']:assert sha(R/f['path'])==f['sha256']
graph=S/'architecture-graphs/checkpoint-521f73a2-foundations.json'
assert fp['compiled_graph_sha256']==sha(graph)
assert fp['source_tree_sha256']==read(graph)['source']['source_tree_sha256']
record={'schema':1,'input_commit':head,'gate':bind(G),'status_counts':dict(counts),
 'classifications':dict(classes),'formalized_objects':32,'remaining_objects':9,'denominator':41,
 'percentage':78.05,'skipped':16,'deferred':0,'verification_artifacts':[bind(S/p) for p in pins]+[bind(fp_path)],
 'checks':checks,'graph':bind(graph),'tiers':bind(R/'docs/architecture/tiers.json'),
 'scope':'Six new generic owners and their exact introduction bytes passed native both-root build, preservation and current graph/organization checks. The same 32 accepted source rows retain their sealed judgments and refreshed context. Additional source alternatives, vector nonvacuity and synthetic epoch helper are reviewed but not source acceptance. Information-only solver and admitted coordinate-sweep repairs remain actionable. Global final evidence remains OPEN; no candidate or integration claim.'}
out=S/'root-batch9-checkpoint-verification.json'
with out.open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(record,indent=2)+'\n')
print(json.dumps({'status':'PASS','verification':bind(out),'counts':dict(counts),'classes':dict(classes)}))
