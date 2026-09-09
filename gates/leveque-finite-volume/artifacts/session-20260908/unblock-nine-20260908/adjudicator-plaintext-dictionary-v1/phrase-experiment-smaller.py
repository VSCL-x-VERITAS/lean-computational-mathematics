from pathlib import Path
from collections import Counter
import sys,os,json,re,time,importlib.util
D=Path(__file__).resolve().parent;R=next(p for p in D.parents if (p/'lean-toolchain').is_file())
exec(compile((D.parent/'fv-local-domain-review/native-long-path-io.py').read_bytes(),'shim','exec'),globals())
spec=importlib.util.spec_from_file_location('old',D.parent/'adjudicator-after-direct-recovery-preparation/adjudicator_transport.py');old=importlib.util.module_from_spec(spec);spec.loader.exec_module(old)
P=R/'gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-COORDINATE-HIGH-RESOLUTION-METHODS-PRODUCTION-20260908/faithfulness/orchestration'
raw=(P/'a_input.txt').read_bytes();inputs=json.loads((P/'a_transport.json').read_bytes())['inputs'];middle,j=old.json_layer(raw,inputs)
count=Counter();words=re.findall(rb'\S+\s*',middle)
for n in (1,2,3,4,6,8,12):
 for i in range(len(words)-n+1):
  phrase=b''.join(words[i:i+n])
  if 16<=len(phrase)<=1024:count[phrase]+=1
names=Counter(x[0] for x in re.finditer(rb'[@A-Za-z_][A-Za-z0-9_\'.]*',middle))
for value,n in names.items():
 for prefix in [value]+[value[:i+1] for i,b in enumerate(value) if b==46 and i>=11]:
  if len(prefix)>=12:count[prefix]+=n
selected=sorted((v for v,n in count.items() if n>=4 and (len(v)-8)*n-len(v)-30>100),key=lambda v:-((len(v)-8)*count[v]-len(v)-30))[:5000]
keys={}
for v in selected:keys.setdefault(v[:8],[]).append(v)
for values in keys.values():values.sort(key=len,reverse=True)
positions=[];used=Counter();i=0
while i<len(middle):
 value=next((v for v in keys.get(middle[i:i+8],[]) if middle.startswith(v,i)),None)
 if value:positions.append((i,i+len(value),value));used[value]+=1;i+=len(value)
 else:i+=1
selected=[v for v in selected if used[v]>=2 and (len(v)-8)*used[v]-len(v)-30>0]
lookup={v:i+1 for i,v in enumerate(selected)};pool=bytearray();out=bytearray();cursor=0
for a,z,v in positions:
 if v not in lookup:continue
 out+=middle[cursor:a];out+=f'⟪a{lookup[v]}⟫'.encode();cursor=z
out+=middle[cursor:];aliased=bytes(out)
for v,i in lookup.items():pool+=f'⟪A{i}⟫'.encode()+v+'⟪/A⟫\n'.encode()
print('phrase aliases',len(lookup),'middle',len(middle.decode()),'aliased',len(aliased.decode()),'pool',len(pool.decode()),flush=True)
for minimum in (56,48,40):
 t=time.monotonic();c,b=old.dictionary(aliased,b'',[],minimum);savings=0
 for block in b['blocks']:
  ident=int(block['id'][1:]);savings+=len(block['opening'])+len(block['closing'])-len(f'⟦b{ident}⟧')-len('⟦/b⟧')
 for ref in b['references']:
  ident=int(ref['block'][1:]);savings+=len(ref['token'])-len(f'⟦{ident}:{ref["block_start"]}:{ref["block_end"]}⟧')
 print('minimum',minimum,'old',len(c.decode())+len(pool.decode()),'short',len(c.decode())+len(pool.decode())-savings,'blocks',len(b['blocks']),'refs',len(b['references']),'elapsed',time.monotonic()-t,flush=True)
