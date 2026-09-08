"""Inspect the existing task guard state without recovering or rewriting it."""
from pathlib import Path
import hashlib,json,sys
P=Path('/c/Users/qed_s/.codex/skills/book-formalization/scripts');sys.path.insert(0,str(P))
import formalization_session_guard as guard
session='01a07fae-4a67-7770-98b0-b95c4e393705'
path=guard.state_path(session);raw=path.read_bytes();state=json.loads(raw)
assert state.get('explicit_stop') is not True and state.get('malformed') is not True
assert state['gate']=='/c/Users/qed_s/OneDrive/Documents/ChatGPT/VSCL-x-VERITAS/lean-computational-mathematics/gates/leveque-finite-volume/chapter-01.json'
assert state['workflow_schema_version']==4
O=Path(__file__).resolve().parent
out={'session_id':session,'state_path':str(path),'state_sha256':hashlib.sha256(raw).hexdigest(),'explicit_stop':state.get('explicit_stop',False),'malformed':state.get('malformed',False),'gate':state['gate'],'closure_command':state['closure_command'],'workflow_schema_version':state['workflow_schema_version'],'guard_sha256':hashlib.sha256((P/'formalization_session_guard.py').read_bytes()).hexdigest()}
with (O/'existing-guard-state.json').open('xb') as f:f.write((json.dumps(out,indent=2)+'\n').encode())
print(json.dumps(out))
