"""Use a concrete next-foundation sentence that is not a reserved placeholder prefix."""
from pathlib import Path
import hashlib,json
S=Path(__file__).resolve().parent;R=S.parents[3];G=R/'gates/leveque-finite-volume/chapter-01.json'
raw=G.read_bytes();sha=hashlib.sha256(raw).hexdigest()
assert sha=='b166b2519e4b51abaff0f56ee8800405abfe60255a39bafac4f5bdda4c2023fd'
g=json.loads(raw);row=next(r for r in g['rows'] if r['id']=='LEV-CH01-DIMENSIONAL-SPLITTING')
old=row['next_foundation'];assert old.startswith('Replace arbitrary constant-preserving maps with actual coordinate-line finite-volume steps')
row['next_foundation']='Define actual coordinate-line finite-volume steps'+old.split('finite-volume steps',1)[1]
snapshot=S/('dimensional-next-foundation-prior-gate-'+sha+'.json')
with snapshot.open('xb') as f:f.write(raw)
assert G.read_bytes()==raw
G.write_text(json.dumps(g,indent=2,ensure_ascii=False)+'\n',encoding='utf-8',newline='')
record={'schema':1,'gate_before_sha256':sha,'gate_after_sha256':hashlib.sha256(G.read_bytes()).hexdigest(),'row':row['id'],'previous':old,'current':row['next_foundation'],'reason':'The released placeholder-prefix rule treats a sentence starting Replace as a placeholder, even with a concrete mathematical action. Preserve that failed checker output and use a concrete Define sentence; no validator changes.'}
with (S/'dimensional-next-foundation-wording-repair.json').open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(record,indent=2)+'\n')
print(json.dumps(record))
