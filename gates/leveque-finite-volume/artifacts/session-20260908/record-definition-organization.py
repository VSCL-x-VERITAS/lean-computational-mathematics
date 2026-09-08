"""Bind the completed current-tree organization checks to this definition increment."""
from pathlib import Path
import collections,hashlib,json,re,subprocess
S=Path(__file__).resolve().parent;R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();read=lambda p:json.loads(p.read_bytes())
labels=['definition-corrected-layout','definition-organized-tiers','definition-organized-compatibility','definition-organized-hygiene',
 'definition-organized-full-build','definition-repairs-production-declarations','definition-organized-graph-capture',
 'definition-organized-graph-check','root-batch5-organization-preflight','root-batch5-closed-audits','root-batch5-trackers','root-batch5-gate']
checks=[]
for label in labels:
 e=read(S/(label+'-exit.json'));assert type(e['exit_code']) is int and e['exit_code']==0,label
 assert e.get('raw_output_sha256',e.get('output_sha256'))==sha(S/(label+'-output.txt'))
 checks.append({'label':label,'exit_sha256':sha(S/(label+'-exit.json')),'output_sha256':sha(S/(label+'-output.txt')),'actual_exit_code':0})
layout=(S/'definition-corrected-layout-output.txt').read_text()
for line in ['Lean modules: 5938','unclassified modules: 0','mixed modules: 0','modules missing module docs: 0',
 'legacy naming exceptions: 0','declaration-bearing umbrellas: 0','unsorted aggregate imports: 0','Layout contract satisfied']:assert line in layout,line
m=read(S/'definition-repairs-production-inputs.json')
for f in m['files']:assert sha(R/f['path'])==f['sha256']
assert sha(R/m['aggregate']['path'])==m['aggregate']['sha256']
correction=read(S/'definition-analysis-import-correction.json');assert sha(R/correction['path'])==correction['after_sha256']
tiers=read(S/'definition-repairs-tier-update.json');assert sha(R/'docs/architecture/tiers.json')==tiers['sha256']
rebind_path=S/'definition-rebind-preparation/definition-organized-rebind-28/summary.json'
rebind=read(rebind_path);assert rebind['exit_code']==0 and rebind['closed_count']==28 and rebind['all_closed_artifacts_current'] is True
graphpath=S/'architecture-graphs/checkpoint-3239b41c4-organized.json';graph=read(graphpath)
assert graph['source']['module_count']==5938 and graph['declarations']['declaration_count']==60415
fingers=S/'chapter01-current-expression-fingerprints-3239.json'
assert sha(fingers)=='6ca24e74145d412e69237d0059c018cf12a1843f0d0609d0087638a51b5e233d'
assert read(fingers)['source_tree_sha256']==graph['source']['source_tree_sha256']
git=lambda *a:subprocess.check_output(['git','-c','core.longpaths=true',*a],cwd=R,text=True)
added=git('diff','--name-only','--diff-filter=A','9e2225705fed906b1120d55105d607baabef57c9','HEAD','--','ComputationalMathematics').splitlines()
assert len(added)==61
pattern=r'^(?:(?:noncomputable|private|protected)\s+)*(def|theorem|structure|abbrev|inductive|opaque|lemma|class|instance)\b'
authored={p:dict(collections.Counter(re.findall(pattern,(R/p).read_text(encoding='utf-8'),re.M))) for p in added}
gate=read(R/'gates/leveque-finite-volume/chapter-01.json');closed=[r for r in gate['rows'] if r['status'] in ['PROVED','REUSED','DISCREPANCY']]
record={'schema':1,'checks':checks,'files':m['files'],'source_aggregate':m['aggregate'],'analysis_import_correction':correction,
 'tiers':tiers,'rebind_summary_sha256':sha(rebind_path),'source_tree_sha256':graph['source']['source_tree_sha256'],
 'graph':{'json_sha256':sha(graphpath),'markdown_sha256':sha(graphpath.with_suffix('.md')),'declarations':graph['declarations']['declaration_count'],
          'declaration_owner_modules':graph['declarations']['module_count'],'edge_counts':graph['declarations']['edge_counts']},
 'new_modules_from_integrated_baseline':61,'authored_declaration_keyword_counts':authored,
 'authored_keyword_total':sum(sum(d.values()) for d in authored.values()),
 'keyword_count_note':'Counts line-start authored declaration commands; compiled constants are separately fingerprinted and include generated fields, constructors and recursors.',
 'expression_fingerprints_sha256':sha(fingers),
 'organization':{'unclassified_modules':0,'duplicate_wrappers':0,'placeholder_findings':0,'canonical_placement_pending':0},
 'gate_observation':{'closed':len(closed),'denominator':41,'remaining':41-len(closed),'skipped':16,'deferred':0},
 'limitations':'Both-root native build and current compiled graphs are local evidence. Source audits for the new wrappers, global chapter closure, and pristine candidate replay remain separate.'}
p=S/'definition-organization-verification.json';assert not p.exists();p.write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'sha256':sha(p),'source_tree_sha256':record['source_tree_sha256'],'authored_keyword_total':record['authored_keyword_total'],
 'gate':record['gate_observation']}))
