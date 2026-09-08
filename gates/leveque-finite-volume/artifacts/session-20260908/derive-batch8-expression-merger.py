"""Derive the batch-8 merger without changing the preserved FV merger or expression parser."""
from pathlib import Path
import hashlib,json
S=Path(__file__).resolve().parent
parent=S/'merge-fv-expression-fingerprints.py'
src=parent.read_text(encoding='utf-8')
changes=[
("chapter01-current-expression-fingerprints-3239.json","chapter01-current-expression-fingerprints-4d4b.json"),
("6ca24e74145d412e69237d0059c018cf12a1843f0d0609d0087638a51b5e233d","05f80d5c97bdeb92cdc2acabb13b19004568b79c80de02012b2c44ad8cd149df"),
("fv-expression-export-inputs.json","batch8-expression-export-inputs.json"),
("94cce409a6907dd4467766f502710255cf2ab378864e99ee9e8f37f74d67ca57","b92840a966312c1e4f00dbd61239cd12727b6a0840e90e8fe52beb73ae1c3df2"),
("'fv-expression-export','fv-foundations-full-build','fv-foundations-graph-capture','fv-foundations-graph-check'","'batch8-expression-export','batch8-foundations-full-build-after-exposure','batch8-graph-capture','batch8-graph-check'"),
("fv-expression-export-exit.json","batch8-expression-export-exit.json"),
("chapter01-fv-expressions.jsonl","chapter01-batch8-expressions.jsonl"),
("placement=read(S/'finite-volume-flux-production/placement-manifest.json')\nexpected={d['name'] for f in placement['new_files'] for d in f['declarations']}\nassert len(expected)==15","expected=set(new['expected_authored_declarations'])\nassert len(expected)==43"),
("len(newpaths)==66","len(newpaths)==76"),
("checkpoint-4d4bc03d-fv.json","checkpoint-03c81fa2-foundations.json"),
("==5943","==5953"),
("All 81 previous declaration-owner sources retain their exact hashes. Five disjoint new owners","All 86 previous declaration-owner sources retain their exact hashes. Ten disjoint new owners")
]
for a,b in changes:
 assert a in src,a
 src=src.replace(a,b)
# The prior-path replacement also changes the output name, so set its unique assignment explicitly.
a="out=S/'chapter01-current-expression-fingerprints-4d4b.json'"
assert src.count(a)==1
src=src.replace(a,"out=S/'chapter01-current-expression-fingerprints-03c8.json'")
target=S/'merge-batch8-expression-fingerprints.py'
with target.open('x',encoding='utf-8',newline='') as f:f.write(src)
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
out=S/'batch8-expression-merger-derivation.json'
with out.open('x',encoding='utf-8',newline='') as f:
 json.dump({'parent':parent.name,'parent_sha256':sha(parent),'child':target.name,'child_sha256':sha(target),'changes':changes,'output_name':'chapter01-current-expression-fingerprints-03c8.json','parser_unchanged':True},f,indent=2);f.write('\n')
print(json.dumps({'merger':target.name,'sha256':sha(target),'derivation_sha256':sha(out)}))

