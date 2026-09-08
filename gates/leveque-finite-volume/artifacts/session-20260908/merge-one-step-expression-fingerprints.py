"""Extend unchanged declaration fingerprints with the native two-declaration export."""
from pathlib import Path
import collections,hashlib,importlib.util,json,subprocess
S=Path(__file__).resolve().parent;R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();read=lambda p:json.loads(p.read_text(encoding='utf-8'))
old_path=S/'chapter01-declaration-expression-fingerprints-v3.json';assert sha(old_path)=='4048b8b6264bba40dade7e9e486f63ae9aebc750ed6e61e68a1dad8f77380919'
old=read(old_path);old_inputs=read(S/'chapter01-expression-export-v2-inputs.json');new_inputs=read(S/'one-step-expression-export-inputs.json')
assert old['input_manifest_sha256']==sha(S/'chapter01-expression-export-v2-inputs.json')
assert old['normalization']==new_inputs['normalization']
for f in old_inputs['files']+new_inputs['files']:assert sha(R/f['path'])==f['sha256']
assert sha(R/new_inputs['exporter_path'])==new_inputs['exporter_sha256']
receipt=read(S/'one-step-expression-export-exit.json');assert type(receipt['exit_code']) is int and receipt['exit_code']==0
assert receipt['input_commit']==new_inputs['input_commit'] and receipt['output_sha256']==sha(S/'one-step-expression-export-output.txt')
assert receipt['command']=='lake env lean '+new_inputs['exporter_path']
parser_path=S/'freeze-chapter01-expression-fingerprints-v3.py';assert sha(parser_path)=='fe089bb896ff20a624d9f34efbf957fea3c168a591ea9bfbd4235481dc595702'
spec=importlib.util.spec_from_file_location('fingerprint_parser',parser_path);parser=importlib.util.module_from_spec(spec);spec.loader.exec_module(parser)
added,raw=parser.records(R/'.lake/chapter01-one-step-expressions.jsonl')
expected={n for f in new_inputs['files'] for n in f['declarations']};assert len(added)==2 and {r['name'] for r in added}==expected
assert not set(old_inputs['selected_modules'])&set(new_inputs['selected_modules'])
records=sorted(old['records']+added,key=lambda r:r['name']);assert len(records)==289 and len({r['name'] for r in records})==289
git=lambda *a:subprocess.check_output(['git','-c','core.longpaths=true',*a],cwd=R)
baseline='9e2225705fed906b1120d55105d607baabef57c9'
new_paths=git('diff','--name-only','--diff-filter=A',baseline,'HEAD','--','ComputationalMathematics').decode().splitlines()
assert len(new_paths)==57 and set(new_paths)==set(old_inputs['added_production_modules'])|{f['path'] for f in new_inputs['files']}
modified=git('diff','--name-only','--diff-filter=M',baseline,'HEAD','--','ComputationalMathematics').decode().splitlines()
assert set(modified)=={'ComputationalMathematics/Analysis.lean','ComputationalMathematics/Source/LeVeque/Chapter01.lean'}
assert not git('diff','--name-only','HEAD','--','ComputationalMathematics').strip()
new_modules={p[:-5].replace('/','.') for p in new_paths};new_constants=[r for r in records if r['module'] in new_modules];assert len(new_constants)==226
result={'schema':1,'input_commit':git('rev-parse','HEAD').decode().strip(),'source_tree_sha256':'96d1d0396ef5e5df6d327906bc773f2bd122b1f35c16d6ed942f563a7c53bf47','normalization':old['normalization'],'counting_note':old['counting_note'],'hash_encoding':old['hash_encoding'],'prior_fingerprints_sha256':sha(old_path),'additional_export_input_sha256':sha(S/'one-step-expression-export-inputs.json'),'additional_native_receipt_sha256':sha(S/'one-step-expression-export-exit.json'),'additional_raw_ignored_stream':raw,'selected_modules':sorted(set(old_inputs['selected_modules'])|set(new_inputs['selected_modules'])),'files':sorted(old_inputs['files']+new_inputs['files'],key=lambda f:f['path']),'added_production_modules':new_paths,'declaration_count':289,'new_module_declaration_constants':226,'constant_kinds':dict(collections.Counter(r['kind'] for r in records)),'records':records,'reuse_basis':'The previous 75 selected module sources retain exact hashes. The only subsequent declaration-bearing additions are these two disjoint modules; the prior producers have no new imports. Both roots and the complete compiled architecture replay pass. This records structural identities for later candidate verification, not a final candidate or semantic acceptance.'}
p=S/'chapter01-current-expression-fingerprints-7707.json';assert not p.exists();p.write_text(json.dumps(result,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
print(json.dumps({'path':p.relative_to(R).as_posix(),'sha256':sha(p),'selected_modules':len(result['selected_modules']),'constants':289,'new_module_constants':226,'kinds':result['constant_kinds'],'additional_raw_bytes':raw['bytes']}))
