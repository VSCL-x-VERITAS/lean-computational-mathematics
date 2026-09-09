"""Lossless adjudicator dictionary experiment; no role launch or semantic selection."""
import hashlib,json,re
from pathlib import Path
def digest(b):return hashlib.sha256(b).hexdigest()
def unique(pairs):
 d={}
 for k,v in pairs:
  assert k not in d;d[k]=v
 return d
def decode(raw):return json.loads(raw,object_pairs_hook=unique,parse_constant=lambda x:(_ for _ in ()).throw(ValueError(x)))
def header(x):return ('\n\n'+x['label']+' SHA256 '+x['sha256']+'\n').encode()
def ws(raw):
 value=decode(raw);out=bytearray();q=e=False
 for b in raw:
  if q:
   out.append(b)
   if e:e=False
   elif b==92:e=True
   elif b==34:q=False
  elif b==34:q=True;out.append(b)
  elif b not in b' \t\r\n':out.append(b)
 out=bytes(out);assert decode(out)==value;return out
TOKEN=re.compile(rb'"(?:[^"\\]|\\.)*"')
RESERVED=(b'[[AJ',b'[[AP:',b'[[AB:',b'[[AE:',b'[[AR:')
NOTICE=(b'[[ADJUDICATOR-LOSSLESS-NOTICE]]\n'
 b'This is a lossless transport representation of the complete original adjudicator input, with the same role boundaries and all original evidence. '
 b'The full direct_review_packet.md remains verbatim under its original header; call its UTF-8 bytes P. [[AP:start:end]] means P[start:end], using zero-based UTF-8 byte offsets. '
 b'[[AB:Bnnnn]] and [[AE:Bnnnn]] enclose an exact verbatim byte block present in this prompt. [[AR:Bnnnn:start:end]] means those exact block bytes. Substitute each reference without adding spaces or newlines and remove AB/AE wrappers. '
 b'After expanding these references, [[AJ0]]text[[AJEND]] denotes the JSON string token obtained by quoting and escaping that exact text with literal Unicode; [[AJ1]]text[[AJEND]] uses JSON Unicode escapes. '
 b'AJ wrappers are transport syntax, not part of the string value. All other original JSON token bytes are unchanged; only formatting whitespace outside strings is removed. '
 b'These references can occur inside any JSON string or expression; interpret every original document as its fully expanded complete content. All source, direct and blind dossiers, judgments and triggers are complete after exact expansion. '
 b'Every referenced byte is supplied verbatim in this same prompt, either in P or in an AB block. AB blocks contain no AP/AR references. Native reconstruction verifies the entire original input byte-for-byte, all JSON tokens/values, and original document hashes. '
 b'This is exact byte matching, with no mathematical or name equivalence, semantic summaries, omitted evidence, additional evidence, or desired verdict. All original attached source images are unchanged. '
 b'Apply the original fresh, one-turn, tool-free adjudicator instructions; independently inspect and resolve all evidence.\n[[END-ADJUDICATOR-LOSSLESS-NOTICE]]\n')

def json_layer(raw,inputs):
 assert not any(x in raw for x in RESERVED)
 canonical=next(x for x in inputs if Path(x['path']).name=='direct_review_packet.md')
 packet=Path(canonical['path']).read_bytes();assert digest(packet)==canonical['sha256']
 assert raw.count(header(canonical)+packet)==1
 docs=[];ops=[]
 for x in inputs:
  p=Path(x['path']);body=p.read_bytes();assert digest(body)==x['sha256'] and len(body)==x['bytes']
  if p.suffix=='.png':continue
  assert raw.count(header(x)+body)==1
  if p.suffix!='.json':continue
  small=ws(body);out=bytearray();cursor=0;spans=[]
  for match in TOKEN.finditer(small):
   token=match[0]
   if len(token)<80:continue
   value=decode(token)
   modes=[mode for mode in (False,True) if json.dumps(value,ensure_ascii=mode).encode()==token]
   if not modes:continue
   mode=modes[0];text=value.encode();opening=b'[[AJ1]]' if mode else b'[[AJ0]]';closing=b'[[AJEND]]'
   out+=small[cursor:match.start()];a=len(out);out+=opening+text+closing
   spans.append({'start':a,'end':len(out),'ascii':mode,'token_sha256':digest(token),'text_sha256':digest(text)})
   cursor=match.end()
  out+=small[cursor:];represented=bytes(out)
  a=raw.index(header(x)+body)+len(header(x));ops.append((a,a+len(body),represented))
  docs.append({'input':x,'references':spans,'represented_sha256':digest(represented)})
 out=bytearray();cursor=0
 for (a,z,body),doc in sorted(zip(ops,docs)):
  out+=raw[cursor:a];doc['start']=len(out);out+=body;doc['end']=len(out);cursor=z
 out+=raw[cursor:];middle=bytes(out)
 protected=[]
 # Keep instruction/metadata Markdown, all headers, and the primary direct packet verbatim.
 for x in inputs:
  p=Path(x['path'])
  if p.suffix=='.png':continue
  h=header(x);a=middle.index(h);protected.append((a,a+len(h)))
  if p.suffix=='.md' and p.name not in ('declaration_dossier.md','blind_dossier.md'):
   body=p.read_bytes();assert middle.count(h+body)==1;protected.append((a+len(h),a+len(h)+len(body)))
 # Merge adjacent protected intervals.
 merged=[]
 for a,z in sorted(protected):
  if merged and a<=merged[-1][1]:merged[-1][1]=max(z,merged[-1][1])
  else:merged.append([a,z])
 mapping={'canonical':canonical,'original_sha256':digest(raw),'middle_sha256':digest(middle),'documents':docs,'protected':merged}
 assert reconstruct_json(middle,mapping)==raw
 return middle,mapping

def reconstruct_json(middle,m):
 assert digest(middle)==m['middle_sha256']
 operations=[]
 for doc in m['documents']:
  x=doc['input'];original=Path(x['path']).read_bytes();assert digest(original)==x['sha256'] and len(original)==x['bytes']
  body=middle[doc['start']:doc['end']];assert digest(body)==doc['represented_sha256']
  out=bytearray();cursor=0
  for s in doc['references']:
   a,z=s['start'],s['end'];assert cursor<=a<z<=len(body) and type(s['ascii']) is bool
   opening=b'[[AJ1]]' if s['ascii'] else b'[[AJ0]]';closing=b'[[AJEND]]'
   value=body[a:z];assert value.startswith(opening) and value.endswith(closing)
   text=value[len(opening):-len(closing)];assert digest(text)==s['text_sha256']
   token=json.dumps(text.decode(),ensure_ascii=s['ascii']).encode();assert digest(token)==s['token_sha256']
   out+=body[cursor:a];out+=token;cursor=z
  out+=body[cursor:];assert bytes(out)==ws(original) and decode(out)==decode(original)
  operations.append((doc['start'],doc['end'],original))
 out=bytearray();cursor=0
 for a,z,body in sorted(operations):
  assert cursor<=a<z<=len(middle);out+=middle[cursor:a];out+=body;cursor=z
 out+=middle[cursor:];raw=bytes(out);assert digest(raw)==m['original_sha256'];return raw

def discover(raw,packet,protected,minimum):
 index={};keylen=24;choices_limit=12
 # Immutable packet bytes are an explicit same-prompt dictionary even for earlier documents.
 for i in range(len(packet)-keylen):
  if packet[i]&0xc0==0x80:continue
  key=packet[i:i+keylen];a=index.setdefault(key,[]);a.append(('packet',i,0))
  if len(a)>choices_limit:del a[0]
 segments=[];current=0;i=0;matches=[];pi=0
 while i+minimum<=len(raw):
  while pi<len(protected) and protected[pi][1]<=i:pi+=1
  if pi<len(protected) and protected[pi][0]<=i<protected[pi][1]:
   segments.append((current,i));i=protected[pi][1];current=i;continue
  key=raw[i:i+keylen];choices=index.get(key,[]);best=None
  for kind,p,seg in reversed(choices):
   source=packet if kind=='packet' else raw
   end=len(packet) if kind=='packet' else (segments[seg][1] if seg<len(segments) else i)
   limit=min(end-p,len(raw)-i)
   if pi<len(protected):limit=min(limit,protected[pi][0]-i)
   if limit<minimum or source[p:p+minimum]!=raw[i:i+minimum]:continue
   n=minimum
   while n+256<=limit and source[p+n:p+n+256]==raw[i+n:i+n+256]:n+=256
   while n<limit and source[p+n]==raw[i+n]:n+=1
   while n and i+n<len(raw) and raw[i+n]&0xc0==0x80:n-=1
   if n>=minimum and (best is None or n>best[2]):best=(kind,p,n)
  if best and raw[i]&0xc0!=0x80:
   kind,p,n=best;matches.append({'kind':kind,'source_start':p,'source_end':p+n,'start':i,'end':i+n})
   segments.append((current,i));i+=n;current=i
  else:
   if raw[i]&0xc0!=0x80:
    choices.append(('raw',i,len(segments)))
    if len(choices)>choices_limit:del choices[0]
    index[key]=choices
   i+=1
 return matches

def dictionary(raw,packet,protected,minimum):
 matches=discover(raw,packet,protected,minimum);bands=[]
 for m in sorted((x for x in matches if x['kind']=='raw'),key=lambda x:x['source_start']):
  if bands and m['source_start']<=bands[-1][1]:bands[-1][1]=max(bands[-1][1],m['source_end'])
  else:bands.append([m['source_start'],m['source_end']])
 for a,z in bands:assert all(z<=x['start'] or x['end']<=a for x in matches)
 ops=[];blocks=[]
 for i,(a,z) in enumerate(bands):
  ident=f'B{i+1:04d}';exact=raw[a:z];opening=f'[[AB:{ident}]]'.encode();closing=f'[[AE:{ident}]]'.encode()
  assert b'[[AP:' not in exact and b'[[AR:' not in exact
  blocks.append({'id':ident,'original_start':a,'original_end':z,'sha256':digest(exact),'opening':opening.decode(),'closing':closing.decode()})
  ops.append((a,z,opening+exact+closing,'block',i))
 for i,m in enumerate(matches):
  if m['kind']=='packet':
   a,z=m['source_start'],m['source_end'];exact=packet[a:z];token=f'[[AP:{a}:{z}]]'.encode()
  else:
   block=next(x for x in blocks if x['original_start']<=m['source_start']<m['source_end']<=x['original_end'])
   a=m['source_start']-block['original_start'];z=m['source_end']-block['original_start']
   m.update(block=block['id'],block_start=a,block_end=z);exact=raw[m['source_start']:m['source_end']]
   token=f'[[AR:{block["id"]}:{a}:{z}]]'.encode()
  m.update(sha256=digest(exact),token=token.decode());ops.append((m['start'],m['end'],token,'reference',i))
 out=bytearray(NOTICE);cursor=0
 for a,z,body,kind,i in sorted(ops):
  assert cursor<=a;out+=raw[cursor:a];obj=blocks[i] if kind=='block' else matches[i]
  obj['rendered_start']=len(out);out+=body;obj['rendered_end']=len(out);cursor=z
 out+=raw[cursor:];final=bytes(out)
 m={'format':'same-prompt-packet-and-byte-dictionary-1','minimum':minimum,'blocks':blocks,'references':matches,
  'middle_sha256':digest(raw),'final_sha256':digest(final),'notice':NOTICE.decode()}
 assert reconstruct_dictionary(final,m,packet)==raw;return final,m

def reconstruct_dictionary(final,m,packet):
 assert digest(final)==m['final_sha256'] and m['notice']==NOTICE.decode() and final.startswith(NOTICE)
 blocks={};ops=[]
 for b in m['blocks']:
  assert b['id'] not in blocks
  a,z=b['rendered_start'],b['rendered_end'];body=final[a:z];opening=b['opening'].encode();closing=b['closing'].encode()
  assert opening==f'[[AB:{b["id"]}]]'.encode() and closing==f'[[AE:{b["id"]}]]'.encode()
  assert body.startswith(opening) and body.endswith(closing)
  exact=body[len(opening):-len(closing)]
  assert digest(exact)==b['sha256'] and len(exact)==b['original_end']-b['original_start']
  blocks[b['id']]=exact;ops.append((a,z,exact))
 for s in m['references']:
  p,q=s['rendered_start'],s['rendered_end'];assert final[p:q]==s['token'].encode()
  if s['kind']=='packet':
   a,z=s['source_start'],s['source_end'];assert 0<=a<z<=len(packet)
   exact=packet[a:z];assert s['token']==f'[[AP:{a}:{z}]]'
  else:
   assert s['kind']=='raw';a,z=s['block_start'],s['block_end'];body=blocks[s['block']]
   assert 0<=a<z<=len(body);exact=body[a:z];assert s['token']==f'[[AR:{s["block"]}:{a}:{z}]]'
  assert digest(exact)==s['sha256'] and len(exact)==s['end']-s['start'];ops.append((p,q,exact))
 out=bytearray();cursor=len(NOTICE)
 for a,z,exact in sorted(ops):
  assert cursor<=a<z<=len(final);out+=final[cursor:a];out+=exact;cursor=z
 out+=final[cursor:];middle=bytes(out);assert digest(middle)==m['middle_sha256'];return middle

def encode(raw,inputs,minimum=64):
 middle,j=json_layer(raw,inputs);packet=Path(j['canonical']['path']).read_bytes()
 final,b=dictionary(middle,packet,j['protected'],minimum)
 assert final.count(header(j['canonical'])+packet)==1
 m={'format':'lossless-adjudicator-packet-dictionary-1','json_layer':j,'byte_layer':b,
  'original_sha256':digest(raw),'final_sha256':digest(final),'original_characters':len(raw.decode()),'final_characters':len(final.decode())}
 assert reconstruct(final,m)==raw;return final,m
def reconstruct(final,m):
 assert digest(final)==m['final_sha256']
 item=m['json_layer']['canonical'];packet=Path(item['path']).read_bytes();assert digest(packet)==item['sha256']
 assert final.count(header(item)+packet)==1
 raw=reconstruct_json(reconstruct_dictionary(final,m['byte_layer'],packet),m['json_layer'])
 assert digest(raw)==m['original_sha256'];return raw
