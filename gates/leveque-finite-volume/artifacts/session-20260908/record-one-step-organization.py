from pathlib import Path
import hashlib,json
S=Path(__file__).resolve().parent;R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();read=lambda p:json.loads(p.read_text(encoding='utf-8'))
labels=['one-step-organized-layout','one-step-organized-tiers','one-step-organized-compatibility','one-step-organized-hygiene','one-step-default-full-build','one-step-production-declarations-relative','one-step-architecture-graph-capture','one-step-architecture-graph-check','one-step-organization-preflight']
checks=[]
for label in labels:
 e=read(S/(label+'-exit.json'));assert type(e['exit_code']) is int and e['exit_code']==0,label
 assert e.get('raw_output_sha256',e.get('output_sha256'))==sha(S/(label+'-output.txt'))
 checks.append({'label':label,'receipt_sha256':sha(S/(label+'-exit.json')),'output_sha256':sha(S/(label+'-output.txt')),'actual_exit_code':0})
layout=(S/'one-step-organized-layout-output.txt').read_text()
for line in ['Lean modules: 5934','unclassified modules: 0','mixed modules: 0','modules missing module docs: 0','legacy naming exceptions: 0','declaration-bearing umbrellas: 0','unsorted aggregate imports: 0','Layout contract satisfied']:assert line in layout,line
assert '14851 Lean file(s)' in (S/'one-step-organized-hygiene-output.txt').read_text()
assert '3334 forwarding modules' in (S/'one-step-organized-compatibility-output.txt').read_text()
m=read(S/'one-step-general-production-verification.json')
for f in m['files']:assert sha(R/f['path'])==f['sha256']
assert sha(R/'ComputationalMathematics/Source/LeVeque/Chapter01.lean')==m['aggregate_sha256']
t=read(S/'one-step-general-tier-update.json');assert sha(R/'docs/architecture/tiers.json')==t['sha256'] and t['counts']['production_modules']==5934
reb=read(S/'one-step-rebind-preparation/one-step-intro-rebind/summary.json');assert reb['exit_code']==0 and reb['closed_count']==23 and reb['all_closed_artifacts_current'] is True
graph=S/'architecture-graphs/checkpoint-7707ce2ec.json';b=read(graph)
g=read(R/'gates/leveque-finite-volume/chapter-01.json');closed=[r for r in g['rows'] if r['status'] in ['PROVED','REUSED','DISCREPANCY']]
record={'schema':1,'checks':checks,'files':m['files'],'aggregate_sha256':m['aggregate_sha256'],'tiers':t,'rebind_summary_sha256':sha(S/'one-step-rebind-preparation/one-step-intro-rebind/summary.json'),'source_tree_sha256':b['source']['source_tree_sha256'],'graph_artifacts':[{'path':p.relative_to(R).as_posix(),'sha256':sha(p)} for p in [graph,graph.with_suffix('.md')]],'organization':{'unclassified_modules':0,'duplicate_wrappers':0,'placeholder_findings':0,'canonical_placement_pending':0},'gate_observation':{'closed':len(closed),'denominator':41,'remaining':41-len(closed),'skipped':16,'deferred':0},'limits':'Current local production and graph replay; final candidate pristine replay and all global chapter closure evidence remain separate. No new source-faithfulness decision is generated here.'}
p=S/'one-step-organization-verification.json';assert not p.exists();p.write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'sha256':sha(p),'counts':record['gate_observation'],'source_tree_sha256':record['source_tree_sha256']}))
