"""Read planning inputs; this emits no epoch and claims no candidate validation."""
from pathlib import Path
import hashlib,json,subprocess
S=Path(__file__).resolve().parent;R=S.parents[3]
read=lambda p:json.loads(p.read_bytes())
g=read(S/'architecture-graphs/checkpoint-7707ce2ec.json')
print(json.dumps({'graph_keys':list(g),'graph_types':{k:type(v).__name__ for k,v in g.items()}},ensure_ascii=True))
for key in g:
 if isinstance(g[key],dict):print(json.dumps({'key':key,'subkeys':list(g[key])[:30]},ensure_ascii=True))
def git(*args):return subprocess.check_output(['git','-c','core.longpaths=true',*args],cwd=R)
base='9e2225705fed906b1120d55105d607baabef57c9'
old=git('show',base+':gates/leveque-finite-volume/chapter-01.json')
v=json.loads(old)
print(json.dumps({'baseline_gate_sha256':hashlib.sha256(old).hexdigest(),'keys':list(v),'rows':[{'id':r['id'],'status':r['status'],'lean':r.get('lean_declaration'),'producer':r.get('producer'),'target':r.get('target_declaration'),'faithfulness_task':r.get('faithfulness_task')} for r in v['rows']]},ensure_ascii=True))
f=read(S/'chapter01-current-expression-fingerprints-7707.json')
print(json.dumps({'fingerprint_keys':list(f),'fingerprint_types':{k:type(v).__name__ for k,v in f.items()}},ensure_ascii=True))
for key in f:
 if isinstance(f[key],list) and f[key] and isinstance(f[key][0],dict):print(json.dumps({'key':key,'first_record':f[key][0]},ensure_ascii=True)[:6500])

