from pathlib import Path
import os,json,re,hashlib,time
from compact import encode
D=Path(__file__).resolve().parent
exec(compile((D.parent/'fv-local-domain-review/native-long-path-io.py').read_bytes(),'shim','exec'),globals())
R=next(p for p in D.parents if (p/'lean-toolchain').is_file())
T=R/'gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-COORDINATE-HIGH-RESOLUTION-METHODS-PRODUCTION-20260908'
P=T/'faithfulness/orchestration';tr=json.loads((P/'d_transport.json').read_bytes());raw=(P/'d_input.txt').read_bytes()
canonical=(T/'faithfulness/inputs/direct_review_packet.md').read_bytes()
def ws(raw):
 out=bytearray();q=e=False
 for b in raw:
  if q:
   out.append(b)
   if e:e=False
   elif b==92:e=True
   elif b==34:q=False
  elif b==34:q=True;out.append(b)
  elif b not in b' \r\n\t':out.append(b)
 return bytes(out)
refs=[];c=raw
for item in tr['inputs']:
 p=Path(item['path'])
 if p.suffix!='.json':continue
 b=p.read_bytes();small=ws(b)
 def sub(m):
  token=m[0]
  if len(token)<256:return token
  value=json.loads(token);text=value.encode()
  if text not in canonical:return token
  modes=[mode for mode in (False,True) if json.dumps(value,ensure_ascii=mode).encode()==token]
  if not modes:return token
  start=canonical.index(text);end=start+len(text)
  marker=f'[[PACKET-JSON-STRING {start}:{end} ASCII {int(modes[0])}]]'.encode()
  refs.append({'token':len(token),'ref':len(marker)})
  return marker
 represented=re.sub(rb'"(?:[^"\\]|\\.)*"',sub,small)
 header=('\n\n'+item['label']+' SHA256 '+item['sha256']+'\n').encode()
 assert c.count(header+b)==1;c=c.replace(header+b,header+represented,1)
print('layer1_chars',len(c.decode()),'refs',len(refs),'saved_tokens',sum(x['token']-x['ref'] for x in refs))
a=c.index(canonical)
for minimum in (192,128,96,64):
 small,m=encode(c,minimum,(a,a+len(canonical)))
 print('minimum',minimum,'final_chars',len(small.decode()),'blocks',len(m['blocks']),'refs',len(m['references']))
