"""Visible plaintext phrase and fragment dictionaries, with exact original reconstruction.

This changes only the representation of the original role input. It never builds
an evidence bundle, chooses mathematical meanings, or invokes a model.
"""
from pathlib import Path
from collections import Counter
import hashlib,importlib.util,json,re
D=Path(__file__).resolve().parent
BASE=D.parent/'adjudicator-after-direct-recovery-preparation/adjudicator_transport.py'
assert hashlib.sha256(BASE.read_bytes()).hexdigest()=='6869e575a5efd884fd8c33897772c1cf438121bac66e5e7d2d12bd99cf88eecb'
spec=importlib.util.spec_from_file_location('pinned_exact_dictionary',BASE)
base=importlib.util.module_from_spec(spec);spec.loader.exec_module(base)
digest=base.digest
NOTICE=('PLAINTEXT TRANSPORT GRAMMAR — COMPLETE ORIGINAL ADJUDICATOR EVIDENCE\n'
 'The original documents follow in their original order under unchanged document headers and original SHA256 identities. Their complete text is represented by visible plaintext and exact shared-fragment references. No evidence or claim is omitted or summarized.\n'
 'Expansion order (mechanical concatenation; add no spaces or newlines):\n'
 '1. ⟦bN⟧...⟦/b⟧ labels a displayed fragment B-N. ⟦N⟧ means the whole displayed fragment; ⟦N:start:end⟧ means UTF-8 bytes [start,end) of its displayed content, BEFORE expanding phrase references. Replace these references and remove the b wrappers. Fragment contents have no fragment references; their phrase references are resolved at step 2.\n'
 '2. The final EXACT PHRASE TABLE defines ⟪AN⟫...⟪/A⟫ as the literal plaintext value A-N. ⟪aN⟫ elsewhere means exactly that value. Values contain no phrase or fragment references. They may include spaces, line breaks, punctuation or parts of an expression. Concatenate exactly; these labels are not renamed Lean declarations, unknown terms or assumptions.\n'
 '3. In the expanded JSON documents, [[AJ0]]text[[AJEND]] represents the JSON string obtained by quoting and escaping that exact text with literal Unicode; [[AJ1]]text[[AJEND]] uses JSON Unicode escapes. These wrappers are transport syntax, not string content. All other JSON token bytes are unchanged. Only original formatting whitespace outside strings is absent.\n'
 'The numbered fragments and phrase table are present in this same prompt. All terminal text remains visible; no binary codec, external retrieval, or tool is required. Native checks expand all three finite layers, verify exact JSON tokens and values, and reconstruct every byte of the original complete input including original JSON formatting. The full original source, direct and blind dossiers, judgments, triggers, types, definitions and bindings are available by this grammar. Original section hashes identify the expanded original documents. All five source images are unchanged.\n'
 'This is literal byte equality only, never name equivalence, mathematical rewriting or a requested interpretation. Independently adjudicate every issue under the ORIGINAL role instructions below. Remain a fresh one-turn, tool-free role. No requested verdict or new semantic evidence is supplied.\n'
 'END TRANSPORT GRAMMAR\n\n').encode()
POOL_HEADER=b'\n\nEXACT PHRASE TABLE (TRANSPORT ONLY; NOT ADDITIONAL EVIDENCE)\n'
POOL_FOOTER=b'END EXACT PHRASE TABLE\n'
ALIAS=re.compile('⟪a([1-9][0-9]*)⟫'.encode())
RESERVED=('⟪','⟦','EXACT PHRASE TABLE (TRANSPORT ONLY; NOT ADDITIONAL EVIDENCE)')

def headers_at(raw,inputs):
 spans=[]
 for x in inputs:
  if Path(x['path']).suffix=='.png':continue
  h=base.header(x);assert raw.count(h)==1
  a=raw.index(h);spans.append([a,a+len(h)])
 return sorted(spans)

def phrases(middle,inputs):
 assert all(x.encode() not in middle for x in RESERVED)
 protected=headers_at(middle,inputs)
 count=Counter();words=re.findall(rb'\S+\s*',middle)
 for n in (1,2,3,4,6,8,12):
  for i in range(len(words)-n+1):
   value=b''.join(words[i:i+n])
   if 16<=len(value)<=1024:count[value]+=1
 names=Counter(x[0] for x in re.finditer(rb'[@A-Za-z_][A-Za-z0-9_\'.]*',middle))
 for value,n in names.items():
  for prefix in [value]+[value[:i+1] for i,b in enumerate(value) if b==46 and i>=11]:
   if len(prefix)>=12:count[prefix]+=n
 selected=sorted((v for v,n in count.items() if n>=4 and (len(v)-8)*n-len(v)-30>100),
  key=lambda v:-((len(v)-8)*count[v]-len(v)-30))[:5000]
 keys={}
 for v in selected:keys.setdefault(v[:8],[]).append(v)
 for values in keys.values():values.sort(key=len,reverse=True)
 positions=[];used=Counter();i=0;pi=0
 while i<len(middle):
  while pi<len(protected) and protected[pi][1]<=i:pi+=1
  if pi<len(protected) and protected[pi][0]<=i<protected[pi][1]:i=protected[pi][1];continue
  limit=protected[pi][0] if pi<len(protected) else len(middle)
  value=next((v for v in keys.get(middle[i:i+8],[]) if i+len(v)<=limit and middle.startswith(v,i)),None)
  if value:positions.append((i,i+len(value),value));used[value]+=1;i+=len(value)
  else:i+=1
 selected=[v for v in selected if used[v]>=2 and (len(v)-8)*used[v]-len(v)-30>0]
 lookup={v:i+1 for i,v in enumerate(selected)};out=bytearray();cursor=0
 for a,z,v in positions:
  if v not in lookup:continue
  out+=middle[cursor:a];out+=f'⟪a{lookup[v]}⟫'.encode();cursor=z
 out+=middle[cursor:];aliased=bytes(out)
 entries=[{'id':i,'value_sha256':digest(v),'value_bytes':len(v),'count':used[v]} for v,i in lookup.items()]
 values={i:v for v,i in lookup.items()}
 assert restore_phrases(aliased,entries,values)==middle
 return aliased,entries,values

def restore_phrases(aliased,entries,values):
 expected={x['id']:x for x in entries};seen=Counter()
 assert len(expected)==len(entries) and set(expected)==set(values)
 for ident,value in values.items():
  assert digest(value)==expected[ident]['value_sha256'] and len(value)==expected[ident]['value_bytes']
  assert all(x.encode() not in value for x in RESERVED)
 def sub(m):
  ident=int(m[1]);assert ident in expected;seen[ident]+=1;return values[ident]
 middle=ALIAS.sub(sub,aliased)
 assert all(seen[x['id']]==x['count'] for x in entries)
 assert '⟪'.encode() not in middle and '⟦'.encode() not in middle
 return middle

def short_markers(compact,b):
 operations=[];block_sizes={x['id']:x['original_end']-x['original_start'] for x in b['blocks']}
 for x in b['blocks']:
  ident=int(x['id'][1:]);opening=x['opening'].encode();closing=x['closing'].encode()
  operations.append((x['rendered_start'],x['rendered_start']+len(opening),f'⟦b{ident}⟧'.encode(),opening))
  operations.append((x['rendered_end']-len(closing),x['rendered_end'],'⟦/b⟧'.encode(),closing))
 for x in b['references']:
  assert x['kind']=='raw'
  ident=int(x['block'][1:]);a,z=x['block_start'],x['block_end']
  token=f'⟦{ident}⟧' if a==0 and z==block_sizes[x['block']] else f'⟦{ident}:{a}:{z}⟧'
  operations.append((x['rendered_start'],x['rendered_end'],token.encode(),x['token'].encode()))
 out=bytearray(NOTICE);cursor=len(base.NOTICE);spans=[]
 assert compact.startswith(base.NOTICE)
 for a,z,short,original in sorted(operations):
  assert cursor<=a<z<=len(compact) and compact[a:z]==original
  out+=compact[cursor:a];p=len(out);out+=short
  spans.append({'start':p,'end':len(out),'short':short.decode(),'original':original.decode()});cursor=z
 out+=compact[cursor:];return bytes(out),spans

def unshorten(final,spans,main_end):
 assert final.startswith(NOTICE);out=bytearray(base.NOTICE);cursor=len(NOTICE)
 for x in spans:
  a,z=x['start'],x['end'];assert cursor<=a<z<=main_end and final[a:z]==x['short'].encode()
  out+=final[cursor:a];out+=x['original'].encode();cursor=z
 out+=final[cursor:main_end];return bytes(out)

def encode(raw,inputs):
 middle,j=base.json_layer(raw,inputs)
 aliased,entries,values=phrases(middle,inputs)
 compact,b=base.dictionary(aliased,b'',headers_at(aliased,inputs),40)
 short,spans=short_markers(compact,b);out=bytearray(short);main_end=len(out);out+=POOL_HEADER
 for entry in entries:
  ident=entry['id'];value=values[ident];opening=f'⟪A{ident}⟫'.encode();closing='⟪/A⟫'.encode()
  entry['pool_start']=len(out);out+=opening+value+closing+b'\n';entry['pool_end']=len(out)
 out+=POOL_FOOTER;final=bytes(out)
 mapping={'format':'adjudicator-visible-plaintext-dictionaries-1','original_sha256':digest(raw),
  'original_bytes':len(raw),'original_characters':len(raw.decode()),'final_sha256':digest(final),
  'final_bytes':len(final),'final_characters':len(final.decode()),'json_layer':j,'middle_sha256':digest(middle),
  'aliased_sha256':digest(aliased),'dictionary_layer':b,'short_markers':spans,'main_end':main_end,
  'phrase_entries':entries,'notice':NOTICE.decode(),'ordered_headers':[base.header(x).decode() for x in inputs if Path(x['path']).suffix!='.png']}
 assert reconstruct(final,mapping)==raw
 return final,mapping

def reconstruct(final,m):
 assert digest(final)==m['final_sha256'] and len(final)==m['final_bytes']
 assert m['notice']==NOTICE.decode() and final.startswith(NOTICE) and final.endswith(POOL_FOOTER)
 cursor=m['main_end'];assert final[cursor:cursor+len(POOL_HEADER)]==POOL_HEADER;cursor+=len(POOL_HEADER)
 values={}
 for x in m['phrase_entries']:
  ident=x['id'];assert ident not in values and x['pool_start']==cursor
  rendered=final[x['pool_start']:x['pool_end']];opening=f'⟪A{ident}⟫'.encode();closing='⟪/A⟫\n'.encode()
  assert rendered.startswith(opening) and rendered.endswith(closing)
  value=rendered[len(opening):-len(closing)];assert digest(value)==x['value_sha256'] and len(value)==x['value_bytes']
  values[ident]=value;cursor=x['pool_end']
 assert final[cursor:]==POOL_FOOTER
 compact=unshorten(final,m['short_markers'],m['main_end'])
 aliased=base.reconstruct_dictionary(compact,m['dictionary_layer'],b'')
 assert digest(aliased)==m['aliased_sha256']
 middle=restore_phrases(aliased,m['phrase_entries'],values);assert digest(middle)==m['middle_sha256']
 raw=base.reconstruct_json(middle,m['json_layer'])
 assert digest(raw)==m['original_sha256'] and len(raw)==m['original_bytes']
 # The original outer document identities and order remain visible, not referenced.
 positions=[]
 for h in m['ordered_headers']:
  token=h.encode();assert final[:m['main_end']].count(token)==1;positions.append(final.index(token))
 assert positions==sorted(positions)
 return raw
