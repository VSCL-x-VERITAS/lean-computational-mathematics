"""Capture the exact durable ACTIVE base and current controlled context for final review."""
from pathlib import Path
import hashlib,importlib.util,json,os
S=Path(__file__).resolve().parent;R=S.parents[3];W=R.parent
assert os.name!='nt'
G=R/'gates/leveque-finite-volume/chapter-01.json'
C=W/'formalization-collaboration-v5.0.1/books/candidates/leveque-finite-volume/module/scripts/gate.py'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
assert sha(C)=='3e9cc58beb58f9f63f2736c4d50125ca6c42116104b64982f3dfc2d3f8afb104'
spec=importlib.util.spec_from_file_location('final_context_checker',C);checker=importlib.util.module_from_spec(spec);spec.loader.exec_module(checker)
original=G.read_bytes();g=json.loads(original);ctx=checker.current_context(G,1)
assert ctx['lean_current_head']=='80f5d4340d507dbc347a806717ff31c5a9aace72'
assert g['bindings']==ctx['bindings'] and g['chapter_gate']=='ACTIVE'
assert sha(G)=='b5538b8881e3a3e58e6cc43aa03344072f4bb9d692516599144820f049599d2e'
m=json.loads((S/'chapter01-final-current-80f5-inputs.json').read_bytes())
assert m['bindings']==ctx['bindings'] and m['input_commit']==ctx['lean_current_head'] and m['source_gate_sha256']==sha(G)
P=S/'final-material-choice-review-80f5';P.mkdir(exist_ok=False)
with (P/'base-active-gate.json').open('xb') as f:f.write(original)
snapshot={**ctx,'lean_root':ctx['lean_root'].as_posix()}
with (P/'context.json').open('x',encoding='utf-8') as f:json.dump(snapshot,f,indent=2);f.write('\n')
assert G.read_bytes()==original and checker.current_context(G,1)==ctx
print(json.dumps(dict(base_sha256=sha(P/'base-active-gate.json'),context_sha256=sha(P/'context.json'),input_commit=ctx['lean_current_head'],bindings=ctx['bindings'])))

