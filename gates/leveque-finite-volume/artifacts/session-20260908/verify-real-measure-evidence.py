"""Independently verify the frozen selected Mathlib measure evidence."""
from pathlib import Path
import hashlib, json, re, os
S = Path(__file__).resolve().parent
R = S.parents[3]
D = S / 'real-measure-dependency'
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
receipt = D / 'final-verification-v2.json'
assert sha(receipt) == '99f4c548c25abe02598b2b275a5931fa8ce4b2979be8d46100ea97200cbb95c4'
v = json.loads(receipt.read_text())
verified = []
for e in v['evidence']:
    assert sha(D / e['path']) == e['sha256'], e['path']
    verified.append(e)
p = json.loads((D / 'input-runtime-provenance-v2.json').read_text())
for e in p['selected_source_and_compiled_files']:
    assert sha(R / e['source_path']) == e['source_sha256'], e['source_path']
    assert sha(R / e['compiled_path']) == e['compiled_sha256'], e['compiled_path']
for e in p['immutable_inputs']:
    assert sha(R / e['path']) == e['sha256'], e['path']
def runtime_path(s):
    s=s.replace('\\', '/')
    if os.name != 'nt' and len(s)>2 and s[1]==':': s='/' + s[0].lower() + s[2:]
    return Path(s)
assert sha(runtime_path(p['lean_binary'])) == p['lean_binary_sha256']
for e in p['direct_runtime_imports']:
    assert sha(runtime_path(e['path'])) == e['sha256'], e['path']
axioms={}
for prefix in ['first','borel']:
    e=json.loads((D/(prefix+'-exit.json')).read_text(encoding='utf-8-sig'))
    assert e['exit_code']==0
    out=(D/(prefix+'-elaboration.txt')).read_text(encoding='utf-8-sig')
    assert not re.search(r'(^|\n).*error:',out)
    for name,items in re.findall(r"'([^']+)' depends on axioms:\s*\[([^\]]*)\]",out):
        found={x.strip() for x in items.split(',') if x.strip()}
        assert found <= {'propext','Quot.sound','Classical.choice'}
        axioms[name]=sorted(found)
assert set(axioms)==set(v['checked_axiom_declarations']), (set(axioms),v['checked_axiom_declarations'])
for command in v['commands']: assert command['exit_code']==0
for prefix in ['lean-version','lean-deps']:
    assert json.loads((D/(prefix+'-exit.json')).read_text(encoding='utf-8-sig'))['exit_code']==0
out={'schema':1,'worker_receipt_sha256':sha(receipt),'verified_evidence_files':len(verified),
     'selected_mathlib_owners':len(p['selected_source_and_compiled_files']),'axioms':axioms,
     'dossier_sha256':sha(D/'supplementary-declaration-dossier-v2.md'),
     'meaning':'The exact real instance and normalized interval measure are exposed by pinned native Lean output and existing theorem statements.',
     'scope':'Dependency evidence only; no independent source-faithfulness verdict or closure.'}
dest=S/'real-measure-root-verification.json'
assert not dest.exists()
dest.write_text(json.dumps(out,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'checked':len(axioms),'owners':out['selected_mathlib_owners'],'receipt_sha256':sha(dest)}))
