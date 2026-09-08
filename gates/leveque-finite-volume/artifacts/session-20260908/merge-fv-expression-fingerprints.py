"""Extend unchanged owner fingerprints with the actual native FV constants."""
from pathlib import Path
import collections,hashlib,importlib.util,json,subprocess
S=Path(__file__).resolve().parent;R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();read=lambda p:json.loads(p.read_bytes())
oldpath=S/'chapter01-current-expression-fingerprints-3239.json'
assert sha(oldpath)=='6ca24e74145d412e69237d0059c018cf12a1843f0d0609d0087638a51b5e233d'
old=read(oldpath);inp=S/'fv-expression-export-inputs.json'
assert sha(inp)=='94cce409a6907dd4467766f502710255cf2ab378864e99ee9e8f37f74d67ca57'
new=read(inp);assert old['normalization']==new['normalization']
for f in old['files']+new['files']:assert sha(R/f['path'])==f['sha256']
assert sha(R/new['exporter_path'])==new['exporter_sha256']
for label in ['fv-expression-export','fv-foundations-full-build','fv-foundations-graph-capture','fv-foundations-graph-check']:
 e=read(S/(label+'-exit.json'));assert type(e['exit_code']) is int and e['exit_code']==0,label
 assert e.get('raw_output_sha256',e.get('output_sha256'))==sha(S/(label+'-output.txt'))
e=read(S/'fv-expression-export-exit.json')
assert e['input_commit']==new['input_commit'] and e['command']=='lake env lean '+new['exporter_path']
parserpath=S/'freeze-chapter01-expression-fingerprints-v3.py'
assert sha(parserpath)=='fe089bb896ff20a624d9f34efbf957fea3c168a591ea9bfbd4235481dc595702'
spec=importlib.util.spec_from_file_location('fv_fingerprint_parser',parserpath)
parser=importlib.util.module_from_spec(spec);spec.loader.exec_module(parser)
added,raw=parser.records(R/'.lake/chapter01-fv-expressions.jsonl')
assert {r['module'] for r in added}==set(new['selected_modules'])
placement=read(S/'finite-volume-flux-production/placement-manifest.json')
expected={d['name'] for f in placement['new_files'] for d in f['declarations']}
assert len(expected)==15 and expected<={r['name'] for r in added}
assert not set(old['selected_modules'])&set(new['selected_modules'])
records=sorted(old['records']+added,key=lambda r:r['name'])
assert len({r['name'] for r in records})==len(records)
git=lambda *a:subprocess.check_output(['git','-c','core.longpaths=true',*a],cwd=R)
baseline='9e2225705fed906b1120d55105d607baabef57c9'
newpaths=git('diff','--name-only','--diff-filter=A',baseline,'HEAD','--','ComputationalMathematics').decode().splitlines()
assert len(newpaths)==66 and set(newpaths)==set(old['added_production_modules'])|{f['path'] for f in new['files']}
modified=git('diff','--name-only','--diff-filter=M',baseline,'HEAD','--','ComputationalMathematics').decode().splitlines()
assert set(modified)=={'ComputationalMathematics/Analysis.lean','ComputationalMathematics/Source/LeVeque/Chapter01.lean'}
assert not git('diff','--name-only','HEAD','--','ComputationalMathematics').strip()
graphpath=S/'architecture-graphs/checkpoint-4d4bc03d-fv.json';graph=read(graphpath)
assert graph['source']['module_count']==5943
newmodules={p[:-5].replace('/','.') for p in newpaths}
newconstants=[r for r in records if r['module'] in newmodules]
result={'schema':1,'input_commit':git('rev-parse','HEAD').decode().strip(),'source_tree_sha256':graph['source']['source_tree_sha256'],'compiled_graph_sha256':sha(graphpath),'normalization':old['normalization'],'counting_note':old['counting_note'],'hash_encoding':old['hash_encoding'],'prior_fingerprints_sha256':sha(oldpath),'additional_export_input_sha256':sha(inp),'additional_native_receipt_sha256':sha(S/'fv-expression-export-exit.json'),'additional_raw_ignored_stream':raw,'selected_modules':sorted(set(old['selected_modules'])|set(new['selected_modules'])),'files':sorted(old['files']+new['files'],key=lambda f:f['path']),'added_production_modules':newpaths,'declaration_count':len(records),'new_module_declaration_constants':len(newconstants),'constant_kinds':dict(collections.Counter(r['kind'] for r in records)),'records':records,'entry_point_additions':new['entry_point_additions'],'reuse_basis':'All 81 previous declaration-owner sources retain their exact hashes. Five disjoint new owners were exported from the current native compiled environment. The committed Analysis additions passed the both-root build and current graph checks. Structural evidence is not source acceptance or final candidate replay.'}
out=S/'chapter01-current-expression-fingerprints-4d4b.json'
with out.open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(result,indent=2,ensure_ascii=False)+'\n')
print(json.dumps({'path':out.relative_to(R).as_posix(),'sha256':sha(out),'selected_modules':len(result['selected_modules']),'additional_constants':len(added),'constants':len(records),'new_module_constants':len(newconstants),'kinds':result['constant_kinds'],'additional_raw_bytes':raw['bytes'],'source_tree_sha256':result['source_tree_sha256']}))

