"""Record current native runtime identity against the just-frozen syntax export tools."""
from pathlib import Path
import hashlib,json,os
F=Path(__file__).resolve().parent;D=F.parent
assert os.name=='nt'
xp=lambda p:Path('\\\\?\\'+str(p)) if not str(p).startswith('\\\\?\\') else p
sha=lambda p:hashlib.sha256(xp(p).read_bytes()).hexdigest()
previous=D/'physical-syntax-fingerprints/native-exit.json'
data=json.loads(xp(previous).read_bytes());assert data['exit_code']==0 and data['input_bytes_and_head_unchanged']
for pin in data['tools']:assert sha(Path(pin['path']))==pin['sha256']
out=F/'native-tools-post.json'
with xp(out).open('x',encoding='utf-8',newline='\n') as f:
    json.dump({'prior_native_receipt':{'path':str(previous),'sha256':sha(previous)},'current_tool_pins':data['tools'],
        'result':'Exact current runtime bytes match previously frozen native0 syntax export',
        'scope':'Post-run tool identity; source and toolchain configuration pre/post checks are separately retained. This does not claim a newly captured pre-run executable snapshot.'},f,indent=2);f.write('\n')
print(json.dumps({'path':str(out),'sha256':sha(out)}))
