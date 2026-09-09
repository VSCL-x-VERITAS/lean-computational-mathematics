"""Artifact-only plaintext factoring experiment; no native role or audit mutation."""
from pathlib import Path
from collections import Counter
import sys,os,json,re,time,hashlib,importlib.util
D=Path(__file__).resolve().parent;R=next(p for p in D.parents if (p/'lean-toolchain').is_file())
exec(compile((D.parent/'fv-local-domain-review/native-long-path-io.py').read_bytes(),'shim','exec'),globals())
spec=importlib.util.spec_from_file_location('old',D.parent/'adjudicator-after-direct-recovery-preparation/adjudicator_transport.py');old=importlib.util.module_from_spec(spec);spec.loader.exec_module(old)
P=R/'gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-COORDINATE-HIGH-RESOLUTION-METHODS-PRODUCTION-20260908/faithfulness/orchestration'
raw=(P/'a_input.txt').read_bytes();inputs=json.loads((P/'a_transport.json').read_bytes())['inputs']
middle,j=old.json_layer(raw,inputs)
word=re.compile(rb'[@A-Za-z_][A-Za-z0-9_\'.]*')
count=Counter(x[0] for x in word.finditer(middle) if len(x[0])>=12)
selected=sorted((v for v,n in count.items() if n>=4 and (len(v)-8)*n-len(v)-30>50),key=lambda v:-((len(v)-8)*count[v]-len(v)-30))
selected=selected[:2000];lookup={v:i+1 for i,v in enumerate(selected)}
pool=bytearray();entries=[]
for value,i in lookup.items():
 opening=f'⟪A{i}⟫'.encode();closing='⟪/A⟫'.encode();pool+=opening+value+closing+b'\n'
 entries.append({'id':i,'value':value.decode(),'count':count[value]})
def sub(m):return f'⟪a{lookup[m[0]]}⟫'.encode() if m[0] in lookup else m[0]
aliased=word.sub(sub,middle)
print('alias entries',len(entries),'middlechars',len(middle.decode()),'aliasedchars',len(aliased.decode()),'poolchars',len(pool.decode()),flush=True)
# Keep original section headers protected in their represented form.
protected=[]
for item in inputs:
 if Path(item['path']).suffix=='.png':continue
 h=subbed=word.sub(sub,old.header(item));a=aliased.index(h);protected.append([a,a+len(h)])
for minimum in (96,64,40):
 t=time.monotonic();c,b=old.dictionary(aliased,b'',sorted(protected),minimum)
 print('minimum',minimum,'chars',len(c.decode())+len(pool.decode()),'blocks',len(b['blocks']),'refs',len(b['references']),'elapsed',time.monotonic()-t,flush=True)
 with (D/f'min-{minimum}.json').open('xb') as f:f.write((json.dumps({'minimum':minimum,'characters_with_pool':len(c.decode())+len(pool.decode()),'blocks':len(b['blocks']),'references':len(b['references']),'alias_entries':entries},indent=2)+'\n').encode())
