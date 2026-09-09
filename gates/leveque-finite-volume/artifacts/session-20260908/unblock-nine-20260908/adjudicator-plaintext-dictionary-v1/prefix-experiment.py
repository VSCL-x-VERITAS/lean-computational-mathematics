from pathlib import Path
from collections import Counter
import sys,os,json,re,time,importlib.util
D=Path(__file__).resolve().parent;R=next(p for p in D.parents if (p/'lean-toolchain').is_file())
exec(compile((D.parent/'fv-local-domain-review/native-long-path-io.py').read_bytes(),'shim','exec'),globals())
spec=importlib.util.spec_from_file_location('old',D.parent/'adjudicator-after-direct-recovery-preparation/adjudicator_transport.py');old=importlib.util.module_from_spec(spec);spec.loader.exec_module(old)
P=R/'gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-COORDINATE-HIGH-RESOLUTION-METHODS-PRODUCTION-20260908/faithfulness/orchestration'
raw=(P/'a_input.txt').read_bytes();inputs=json.loads((P/'a_transport.json').read_bytes())['inputs'];middle,j=old.json_layer(raw,inputs)
word=re.compile(rb'[@A-Za-z_][A-Za-z0-9_\'.]*');names=Counter(x[0] for x in word.finditer(middle))
count=Counter()
for value,n in names.items():
 for prefix in [value]+[value[:i+1] for i,b in enumerate(value) if b==46 and i>=11]:
  if len(prefix)>=12:count[prefix]+=n
selected=sorted((v for v,n in count.items() if n>=4 and (len(v)-8)*n-len(v)-30>50),key=lambda v:-((len(v)-8)*count[v]-len(v)-30))[:3000]
lookup={v:i+1 for i,v in enumerate(selected)};used=Counter()
def selected_prefix(value):
 if value in lookup:return value
 for i in range(len(value)-1,10,-1):
  if value[i]==46 and value[:i+1] in lookup:return value[:i+1]
 return None
for name,n in names.items():
 p=selected_prefix(name)
 if p:used[p]+=n
lookup={v:i+1 for i,v in enumerate(v for v in selected if used[v])};pool=bytearray()
for value,i in lookup.items():pool+=f'⟪A{i}⟫'.encode()+value+'⟪/A⟫\n'.encode()
def sub(m):
 p=selected_prefix(m[0])
 return f'⟪a{lookup[p]}⟫'.encode()+m[0][len(p):] if p else m[0]
aliased=word.sub(sub,middle)
protected=[]
for item in inputs:
 if Path(item['path']).suffix=='.png':continue
 h=word.sub(sub,old.header(item));a=aliased.index(h);protected.append([a,a+len(h)])
print('aliases',len(lookup),'aliased_chars',len(aliased.decode()),'pool_chars',len(pool.decode()),flush=True)
for minimum in (96,64,40):
 t=time.monotonic();c,b=old.dictionary(aliased,b'',sorted(protected),minimum)
 # Exact short-marker rendering size; offset/range interpretation remains decimal.
 savings=0
 for block in b['blocks']:
  ident=int(block['id'][1:]);savings+=len(block['opening'])+len(block['closing'])-len(f'⟦b{ident}⟧')-len('⟦/b⟧')
 for ref in b['references']:
  ident=int(ref['block'][1:]);savings+=len(ref['token'])-len(f'⟦{ident}:{ref["block_start"]}:{ref["block_end"]}⟧')
 print('minimum',minimum,'old_chars',len(c.decode())+len(pool.decode()),'short_chars',len(c.decode())+len(pool.decode())-savings,'blocks',len(b['blocks']),'refs',len(b['references']),'elapsed',time.monotonic()-t,flush=True)
