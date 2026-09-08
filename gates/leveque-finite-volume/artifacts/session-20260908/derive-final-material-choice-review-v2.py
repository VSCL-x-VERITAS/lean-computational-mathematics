from pathlib import Path
import hashlib,json
S=Path(__file__).resolve().parent
p=S/'prepare-final-material-choice-review-80f5.py'
old=p.read_text(encoding='utf-8')
needle="assert state['state']=='QUEUED' and state['result_kind']=='retained'"
assert old.count(needle)==1
new=old.replace(needle,"assert state['current_state']=='QUEUED' and state['result_kind']=='retained'\nassert state['request_sha256']==sha(request)\nassert any(x['gate_sha256']==sha(G) and x['verdict']=='ACTIVE' for x in state['checkpoint_evidence'])")
out=S/'prepare-final-material-choice-review-80f5-v2.py'
with out.open('x',encoding='utf-8',newline='\n') as f:f.write(new)
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
d=dict(schema=1,original_sha256=sha(p),derived_sha256=sha(out),change='Use the actual released status field current_state, not the CLI display key state; additionally verify request SHA and actual ACTIVE gate checkpoint evidence. Original failure occurred before any dossier/proposed-row output and is retained.')
with (S/'final-material-choice-review-v2-derivation.json').open('x',encoding='utf-8') as f:json.dump(d,f,indent=2);f.write('\n')
print(json.dumps(d))

