"""Reuse the exact existing serializer for ten disjoint new declaration owners."""
from pathlib import Path
import hashlib,json,subprocess
S=Path(__file__).resolve().parent;R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();read=lambda p:json.loads(p.read_bytes())
oldpath=S/'chapter01-current-expression-fingerprints-4d4b.json'
assert sha(oldpath)=='05f80d5c97bdeb92cdc2acabb13b19004568b79c80de02012b2c44ad8cd149df'
old=read(oldpath)
for f in old['files']:assert sha(R/f['path'])==f['sha256']
parent=S/'export-fv-declaration-expressions.lean'
assert sha(parent)=='a113427e9f67ce50dbf2081998aeea56adfdfc625b45dea2a0207db5843c5c9f'
assert sha(S/'root-batch8-placement-verification.json')=='cfa34484713dd89a97e0ab3bcaf67d5819b7dd003ea1447e924c97c4da7b1d39'
m=read(S/'batch8-analysis-imports.json');assert sha(R/m['path'])==m['after_sha256']
files=[{k:f[k] for k in ('path','sha256')} for f in m['all_new_files']]
for f in files:assert sha(R/f['path'])==f['sha256']
modules=sorted(f['path'][:-5].replace('/','.') for f in files)
assert len(modules)==10 and not set(modules)&set(old['selected_modules'])
code=parent.read_text(encoding='utf-8');start=code.index('private def selectedModules : Array String := #[\n');end=code.index('\n]\n\nrun_cmd do',start)
code=code[:start]+'private def selectedModules : Array String := #[\n'+',\n'.join('  '+json.dumps(x) for x in modules)+code[end:]
assert code.count('.lake/chapter01-fv-expressions.jsonl')==1
code=code.replace('.lake/chapter01-fv-expressions.jsonl','.lake/chapter01-batch8-expressions.jsonl')
p=S/'export-batch8-declaration-expressions.lean'
with p.open('x',encoding='utf-8',newline='\n') as f:f.write(code)
expected=list(read(S/'jump-balance-production/placement-manifest.json')['canonical_axiom_checks'])
expected += [x['name'] for x in read(S/'coordinate-line-production/manifest.json')['axiom_checks']]
expected += read(S/'rectangle-riemann-flux-production/final-receipt.json')['canonical_declarations']
assert len(expected)==len(set(expected))==43
head=subprocess.check_output(['git','-c','core.longpaths=true','rev-parse','HEAD'],cwd=R,text=True).strip()
assert head=='03c81fa2a551b5089133c958deedc4828899adbd'
record={'schema':1,'files':files,'selected_modules':modules,'expected_authored_declarations':sorted(expected),'exporter_path':p.relative_to(R).as_posix(),'exporter_sha256':sha(p),'normalization':old['normalization'],'prior_exporter_sha256':sha(parent),'prior_fingerprints_sha256':sha(oldpath),'input_commit':head,'entry_point_additions':m}
out=S/'batch8-expression-export-inputs.json'
with out.open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(record,indent=2)+'\n')
print(json.dumps({'inputs_sha256':sha(out),'exporter_sha256':sha(p),'modules':len(modules),'expected_authored_declarations':43}))
