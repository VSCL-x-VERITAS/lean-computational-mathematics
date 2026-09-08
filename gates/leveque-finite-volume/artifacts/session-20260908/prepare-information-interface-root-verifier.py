"""Derive read-only root verification from the reviewed frozen interface checker."""
from pathlib import Path
import hashlib,json
S=Path(__file__).resolve().parent
H=S/'information-interface-capstone-draft'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
src=H/'freeze.py'
original=src.read_text(encoding='utf-8')
cut="put('verification.json',dict("
assert original.count(cut)==1
body=original.split(cut)[0]
assert body.count("here=Path(__file__).resolve().parent;repo=here.parents[4];session=here.parent")==1
body=body.replace("here=Path(__file__).resolve().parent;repo=here.parents[4];session=here.parent","here=Path(__file__).resolve().parent/'information-interface-capstone-draft';repo=here.parents[4];session=here.parent")
body=body.replace("final_label=sys.argv[1]","final_label='native-05'")
body += """
for name in ['manifest.json','final-receipt.json','verification.json']:
 verify_pairs(json.loads((here/name).read_bytes()))
assert digest(here/'manifest.json')=='ed0061a2dd7da789aa3185c343ad30666611f435b3e11350a2ce060912d3db8c'
assert digest(here/'final-receipt.json')=='9ccb09671a50823c688a436bfbd3da4903e8c634d40c82697d75037ef159e65a'
assert final['command'][:3]==['C:/Users/qed_s/.elan/bin/lake.exe','env','lean']
assert Path(final['command'][3])==here/'native-05.lean'
assert all(type(json.loads(Path(x['receipt']['path']).read_bytes())['exit_code']) is int for x in attempts)
target=session/'root-information-interface-capstone-verification.json'
record=dict(status='PASS',source_acceptance=False,manifest=bind(here/'manifest.json'),final_receipt=bind(here/'final-receipt.json'),actual_native_attempts=attempts,
 authored=14,reused=10,final_reports=24,preserved_successful_base=13,historical_candidate_resolutions=resolution,
 local_dependencies=len(final['local_dependencies']),direct_mathlib_imports=len(final['direct_mathlib_imports']),
 root_review='Read complete candidate including literal two-face positive-step comparison, proof-free headers, full scope review and native/freezer code. Normalized averages, independent rectangle reference and per-interval AE rate preserved; actual admitted result at each face. Quantitative source convention remains pending; no full-field requirement inferred.')
with target.open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(record,indent=2)+'\\n')
print(json.dumps(dict(status='PASS',verification_sha256=digest(target),actual_exits={x['label']:x['exit_code'] for x in attempts},final_reports=24)))
"""
target=S/'verify-information-interface-capstone-root.py'
with target.open('x',encoding='utf-8',newline='') as f:f.write(body)
derivation=S/'information-interface-root-verifier-derivation.json'
with derivation.open('x',encoding='utf-8',newline='') as f:json.dump(dict(source=dict(path=str(src),sha256=sha(src)),derived=dict(path=str(target),sha256=sha(target)),change='Retain all reviewed verification assertions; fixed frozen directory/label, remove artifact-writing freeze tail, add strict actual native argv/exits and recursive manifest checks; only new root report is written.'),f,indent=2)
print(json.dumps(dict(derived=str(target),sha256=sha(target))))

