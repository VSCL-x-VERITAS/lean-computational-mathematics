from pathlib import Path
import hashlib,json,re
S=Path(__file__).resolve().parent;R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def write(name,x):
 p=S/name
 with p.open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(x,indent=2)+'\n')
 return {'path':str(p),'sha256':sha(p)}
B=S/'blocked-gate-binding-preparation'
assert sha(B/'preparation-files.json')=='57ea9891da5ca0a61a33f2af48f19c2a19ffeeb0d986917545441d3bd8b5eddd'
m=json.loads((B/'preparation-files.json').read_bytes())
for item in m['artifacts']:
 p=B/item['path'];assert sha(p)==item['sha256'] and p.stat().st_size==item['bytes'],p
for item in m['protected_inputs']:
 p=Path(item['path']);assert sha(p)==item['sha256'] and item['unchanged'] is True,p
check=json.loads((S/'root-batch10-blocked-binder-fixtures-exit.json').read_bytes())
assert check['exit_code']==0
assert sha(S/'root-batch10-blocked-binder-fixtures-output.txt')==check['raw_output_sha256']
out=write('root-blocked-binder-review.json',{'status':'REVIEWED_PREPARATION_ONLY','implementation_sha256':sha(B/'blocked_gate_binding.py'),'freeze_sha256':sha(B/'preparation-files.json'),'artifact_count':len(m['artifacts']),'protected_pins_verified':len(m['protected_inputs']),'fixture_exit':0,'fixture_tests':53,'fixture_output_sha256':check['raw_output_sha256'],'root_review':'Read full helper, tests, scope review and README. Exact all-nine transition, accepted/skipped preservation, pending question/provenance and route coverage, actual nine-receipt contracts, eight released evidence payloads and separately released-derived zero-actionable BLOCKED verification are present. Retained final-PASS binder and validators unchanged. Reviewed guard suite independently passed. No operational prepare, install or terminal verification has been executed.','limitations':['Synthetic tests exercise guard functions and actual released payload validation, not full real preparation or installation.','Source ambiguity and local route completion require actual substantive review; strings and hashes alone are insufficient.','All-nine fixed scenario must be reconsidered if any row closes or a local route remains. INTERFACE may rely on conditional-accuracy choice rather than the now-avoidable full-field representation choice.','Only additive immutable proposals are authorized after real final inputs exist; exact atomic installation remains separate root work.']})
print(json.dumps({'blocked_review':out}))

