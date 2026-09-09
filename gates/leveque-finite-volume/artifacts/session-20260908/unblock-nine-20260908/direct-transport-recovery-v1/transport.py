"""Direct-only lossless representation; canonical direct packet always remains verbatim."""
import json,re,hashlib
from pathlib import Path
import compact
def digest(b):return hashlib.sha256(b).hexdigest()
def unique(pairs):
 d={}
 for k,v in pairs:
  assert k not in d,'duplicate JSON key';d[k]=v
 return d
def decode(raw):return json.loads(raw,object_pairs_hook=unique,parse_constant=lambda x:(_ for _ in ()).throw(ValueError(x)))
def compact_json(raw):
 value=decode(raw);out=bytearray();quoted=escaped=False
 for b in raw:
  if quoted:
   out.append(b)
   if escaped:escaped=False
   elif b==92:escaped=True
   elif b==34:quoted=False
  elif b==34:quoted=True;out.append(b)
  elif b not in b' \t\r\n':out.append(b)
 result=bytes(out);assert decode(result)==value;return result
def header(x):return ('\n\n'+x['label']+' SHA256 '+x['sha256']+'\n').encode()
JNOTICE=(b'[[PACKET-JSON-NOTICE]]\n'
 b'The complete direct_review_packet.md is supplied verbatim under its original document header. '
 b'Within dependency_inventory.json only, [[PACKET-JSON-STRING start:end ASCII n]] represents a JSON string token whose decoded text is exactly UTF-8 bytes [start,end) of that complete packet, counting from its first document byte. '
 b'ASCII 0 uses literal Unicode in JSON quoting; ASCII 1 uses JSON Unicode escapes. In both cases quote and escape that exact text as a JSON string. '
 b'This is an exact shared-text reference, not an object, null, unknown value or mathematical placeholder. Its whole decoded value is supplied verbatim in the packet in this same prompt. '
 b'Every original JSON token is reconstructed exactly; only formatting whitespace outside strings is removed. The orchestrator separately verifies identical parsed JSON values and exact reconstruction of original formatting from pinned original files. '
 b'The direct packet is never compressed or modified. Resolve other DX block references first; no canonical DX block contains a packet-string reference. This transport changes no role evidence or judgment standard.\n[[END-PACKET-JSON-NOTICE]]\n')
TOKEN=re.compile(rb'"(?:[^"\\]|\\.)*"')

def layer(raw,inputs):
 assert b'[[PACKET-JSON-' not in raw
 item=next(x for x in inputs if Path(x['path']).name=='direct_review_packet.md')
 canonical=Path(item['path']).read_bytes()
 assert digest(canonical)==item['sha256'] and raw.count(header(item)+canonical)==1
 docs=[];replacements=[]
 for x in inputs:
  p=Path(x['path']);body=p.read_bytes()
  assert digest(body)==x['sha256'] and len(body)==x['bytes']
  if p.suffix=='.png':continue
  assert raw.count(header(x)+body)==1
  if p.suffix!='.json':continue
  small=compact_json(body);parts=[];cursor=0;spans=[]
  if p.name=='dependency_inventory.json':
   for match in TOKEN.finditer(small):
    token=match[0]
    if len(token)<256:continue
    text=decode(token).encode('utf-8')
    if text not in canonical:continue
    modes=[v for v in (False,True) if json.dumps(text.decode(),ensure_ascii=v).encode()==token]
    if not modes:continue
    a=canonical.index(text);z=a+len(text);mode=modes[0]
    marker=f'[[PACKET-JSON-STRING {a}:{z} ASCII {int(mode)}]]'.encode()
    parts.append(small[cursor:match.start()]);start=sum(map(len,parts));parts.append(marker)
    spans.append({'start':start,'end':start+len(marker),'canonical_start':a,'canonical_end':z,
       'ascii':mode,'token_sha256':digest(token),'token_bytes':len(token),'marker':marker.decode()})
    cursor=match.end()
  parts.append(small[cursor:]);represented=b''.join(parts)
  start=raw.index(header(x)+body)+len(header(x))
  replacements.append((start,start+len(body),represented))
  docs.append({'input':x,'represented_sha256':digest(represented),'references':spans})
 result=bytearray(JNOTICE);cursor=0
 for (a,z,represented),doc in sorted(zip(replacements,docs)):
  result+=raw[cursor:a];doc['start']=len(result);result+=represented;doc['end']=len(result);cursor=z
 result+=raw[cursor:];result=bytes(result)
 # Only the two large JSON documents may contain DX dictionary substitutions.
 allowed=[(d['start'],d['end']) for d in docs if Path(d['input']['path']).name in ('dependency_inventory.json','dependency-environment-packet.json')]
 protected=[];cursor=0
 for a,z in sorted(allowed):
  if cursor<a:protected.append((cursor,a))
  cursor=z
 if cursor<len(result):protected.append((cursor,len(result)))
 for d in docs:
  protected += [(d['start']+s['start'],d['start']+s['end']) for s in d['references']]
 protected.sort()
 mapping={'format':'exact-direct-json-token-references-1','canonical':item,'documents':docs,
  'original_sha256':digest(raw),'layer_sha256':digest(result),'notice':JNOTICE.decode(),'protected':[list(x) for x in protected]}
 assert reconstruct_layer(result,mapping)==raw
 return result,mapping

def reconstruct_layer(result,mapping):
 assert digest(result)==mapping['layer_sha256'] and result.startswith(JNOTICE)
 item=mapping['canonical'];canonical=Path(item['path']).read_bytes()
 assert digest(canonical)==item['sha256'] and result.count(header(item)+canonical)==1
 operations=[]
 for doc in mapping['documents']:
  x=doc['input'];original=Path(x['path']).read_bytes()
  assert digest(original)==x['sha256'] and len(original)==x['bytes']
  body=result[doc['start']:doc['end']];assert digest(body)==doc['represented_sha256']
  cursor=0;restored=bytearray()
  for s in doc['references']:
   a,z=s['start'],s['end'];assert cursor<=a<z<=len(body)
   assert body[a:z]==s['marker'].encode()
   ca,cz=s['canonical_start'],s['canonical_end'];assert 0<=ca<cz<=len(canonical)
   assert type(s['ascii']) is bool
   assert s['marker']==f'[[PACKET-JSON-STRING {ca}:{cz} ASCII {int(s["ascii"])}]]'
   token=json.dumps(canonical[ca:cz].decode(),ensure_ascii=s['ascii']).encode()
   assert digest(token)==s['token_sha256'] and len(token)==s['token_bytes']
   restored+=body[cursor:a];restored+=token;cursor=z
  restored+=body[cursor:]
  assert bytes(restored)==compact_json(original) and decode(restored)==decode(original)
  operations.append((doc['start'],doc['end'],original))
 out=bytearray();cursor=len(JNOTICE)
 for a,z,original in sorted(operations):
  assert cursor<=a<z<=len(result);out+=result[cursor:a];out+=original;cursor=z
 out+=result[cursor:];raw=bytes(out);assert digest(raw)==mapping['original_sha256']
 return raw

def encode(raw,inputs):
 middle,j=layer(raw,inputs)
 final,b=compact.encode(middle,80,j['protected'])
 assert all(b'[[PACKET-JSON-' not in middle[x['original_start']:x['original_end']] for x in b['blocks'])
 m={'format':'lossless-direct-transport-1','original_sha256':digest(raw),
    'compact_sha256':digest(final),'original_characters':len(raw.decode()),
    'compact_characters':len(final.decode()),'json_layer':j,'byte_layer':b}
 assert reconstruct(final,m)==raw
 canonical=Path(j['canonical']['path']).read_bytes()
 assert final.count(header(j['canonical'])+canonical)==1
 return final,m
def reconstruct(final,mapping):
 assert digest(final)==mapping['compact_sha256']
 raw=reconstruct_layer(compact.reconstruct(final,mapping['byte_layer']),mapping['json_layer'])
 assert digest(raw)==mapping['original_sha256'];return raw
