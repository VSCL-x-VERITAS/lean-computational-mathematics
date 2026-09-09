"""Preserve the first freeze guard; derive the final guard for the clean native attempt."""
import hashlib,json,os
from pathlib import Path
P=Path(__file__).resolve().parent
def n(p):return '\\\\?\\'+str(p)
def read(p):
 with open(n(p),'rb') as f:return f.read()
def write(p,b):
 with open(n(p),'xb') as f:f.write(b)
def ref(p):return {'path':str(p),'sha256':hashlib.sha256(read(p)).hexdigest()}
source=read(P/'freeze.py').decode()
start=source.index('searches=[]\n')
end=source.index('\nattempts=[]',start)
source=source[:start]+'''searches=load(P/'search-receipts.json')
assert len(searches)==len(queries)
for command,result in zip(queries,searches):
    assert result['command']==command and result['exit_code'] in (0,1)
    for key in ['stdout','stderr']:
        assert ref(resolved(result[key]))['sha256']==result[key]['sha256']
'''+source[end:]
source=source.replace("[('native-01',1),('native-02',0)]", "[('native-01',1),('native-02',0),('native-03',0)]")
source=source.replace("if label=='native-01' and p==P/'NetError.lean.fragment':", "if label!='native-03' and p==P/'NetError.lean.fragment':")
source=source.replace("final=P/'native-02'", "final=P/'native-03'")
assert source.count("final=P/'native-03'")==1
write(P/'freeze_v2.py',source.encode())
failure={'schema':1,'kind':'recorded exec_command result','command':[
 r'C:/Users/qed_s/AppData/Local/Programs/Python/Python312-arm64/python.exe','-X','utf8','-B',str(P/'freeze.py')],
 'actual_exit':1,'tool_chunk_id':'0d5220','tool_wall_time_seconds':0.726813833,
 'failure':'freeze.py line 64: assert not re.search(r\'\\b(error|warning):\',text); AssertionError',
 'script':ref(P/'freeze.py'),'input_output':ref(P/'native-02/lean-output.txt'),
 'cause':'Three unused integration-binder warnings in the successful native-02 proof.',
 'limits':'This is a structured record of the actual tool result, not a separately captured raw subprocess log.'}
write(P/'freeze-01-tool-result.json',(json.dumps(failure,indent=2)+'\n').encode())
write(P/'freeze-v2-derivation.json',(json.dumps({'original':ref(P/'freeze.py'),
 'successor':ref(P/'freeze_v2.py'),'derivation':ref(P/'derive_freeze_v2.py'),
 'changes':['Use unchanged captured scoped search receipts.','Verify all three native attempts and historical fragment snapshots.','Require clean native-03 output; preserve every original guard.']},indent=2)+'\n').encode())
print(json.dumps(ref(P/'freeze_v2.py')))
