"""Extend exact unchanged owner fingerprints with 54 native definition constants."""
from pathlib import Path
import collections,hashlib,importlib.util,json,subprocess
S=Path(__file__).resolve().parent;R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();read=lambda p:json.loads(p.read_bytes())
oldpath=S/'chapter01-current-expression-fingerprints-7707.json'
assert sha(oldpath)=='374319bfa993ce386f53a52b0fced7c222158a9f1e21086f9ec26b8cea498682'
old=read(oldpath);inp=S/'definition-expression-export-inputs.json'
assert sha(inp)=='8d6d4ad5e61dbd46df1281c33c19010c9a7a2aec47b63f65c56fed96620eb2cc'
new=read(inp);assert old['normalization']==new['normalization']
for f in old['files']+new['files']:assert sha(R/f['path'])==f['sha256']
assert sha(R/new['exporter_path'])==new['exporter_sha256']
for label in ['definition-expression-export','definition-organized-full-build','definition-organized-graph-capture','definition-organized-graph-check']:
 e=read(S/(label+'-exit.json'));assert type(e['exit_code']) is int and e['exit_code']==0,label
 assert e.get('raw_output_sha256',e.get('output_sha256'))==sha(S/(label+'-output.txt'))
e=read(S/'definition-expression-export-exit.json')
assert e['input_commit']==new['input_commit'] and e['command']=='lake env lean '+new['exporter_path']
parser_path=S/'freeze-chapter01-expression-fingerprints-v3.py'
assert sha(parser_path)=='fe089bb896ff20a624d9f34efbf957fea3c168a591ea9bfbd4235481dc595702'
spec=importlib.util.spec_from_file_location('definition_fingerprint_parser',parser_path)
parser=importlib.util.module_from_spec(spec);spec.loader.exec_module(parser)
added,raw=parser.records(R/'.lake/chapter01-definition-expressions.jsonl')
assert len(added)==54 and {r['module'] for r in added}==set(new['selected_modules'])
assert {n for f in new['files'] for n in f['declarations']}<={r['name'] for r in added}
assert not set(old['selected_modules'])&set(new['selected_modules'])
records=sorted(old['records']+added,key=lambda r:r['name'])
assert len(records)==343 and len({r['name'] for r in records})==343
git=lambda *a:subprocess.check_output(['git','-c','core.longpaths=true',*a],cwd=R)
baseline='9e2225705fed906b1120d55105d607baabef57c9'
new_paths=git('diff','--name-only','--diff-filter=A',baseline,'HEAD','--','ComputationalMathematics').decode().splitlines()
assert len(new_paths)==61 and set(new_paths)==set(old['added_production_modules'])|{f['path'] for f in new['files']}
modified=git('diff','--name-only','--diff-filter=M',baseline,'HEAD','--','ComputationalMathematics').decode().splitlines()
assert set(modified)=={'ComputationalMathematics/Analysis.lean','ComputationalMathematics/Source/LeVeque/Chapter01.lean'}
dirty=git('diff','--name-only','HEAD','--','ComputationalMathematics').decode().splitlines()
assert dirty==['ComputationalMathematics/Analysis.lean']
correction=read(S/'definition-analysis-import-correction.json')
assert sha(R/correction['path'])==correction['after_sha256']
graphpath=S/'architecture-graphs/checkpoint-3239b41c4-organized.json';graph=read(graphpath)
new_modules={p[:-5].replace('/','.') for p in new_paths}
new_constants=[r for r in records if r['module'] in new_modules];assert len(new_constants)==280
result={'schema':1,'input_commit':git('rev-parse','HEAD').decode().strip(),
 'source_tree_sha256':graph['source']['source_tree_sha256'],'compiled_graph_sha256':sha(graphpath),
 'normalization':old['normalization'],'counting_note':old['counting_note'],'hash_encoding':old['hash_encoding'],
 'prior_fingerprints_sha256':sha(oldpath),'additional_export_input_sha256':sha(inp),
 'additional_native_receipt_sha256':sha(S/'definition-expression-export-exit.json'),'additional_raw_ignored_stream':raw,
 'selected_modules':sorted(set(old['selected_modules'])|set(new['selected_modules'])),
 'files':sorted(old['files']+new['files'],key=lambda f:f['path']),'added_production_modules':new_paths,
 'declaration_count':343,'new_module_declaration_constants':280,'constant_kinds':dict(collections.Counter(r['kind'] for r in records)),
 'records':records,'entry_point_correction_at_export':correction,
 'reuse_basis':'The previous 77 declaration-owner sources retain exact hashes. Four disjoint new owners were inspected in the current native compiled environment. The only additional production worktree change is the exact recorded Analysis import correction, covered by the repeated both-root build and current graph. This is structural identity evidence, not final candidate replay or source acceptance.'}
p=S/'chapter01-current-expression-fingerprints-3239.json';assert not p.exists()
p.write_text(json.dumps(result,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
print(json.dumps({'path':p.relative_to(R).as_posix(),'sha256':sha(p),'selected_modules':len(result['selected_modules']),
 'constants':343,'new_module_constants':280,'kinds':result['constant_kinds'],'additional_raw_bytes':raw['bytes'],
 'source_tree_sha256':result['source_tree_sha256']}))
