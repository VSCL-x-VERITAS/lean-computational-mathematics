"""Independent parser of the displayed grammar; does not use encoder mappings."""
import json,re,hashlib
from pathlib import Path
from plaintext import NOTICE,POOL_HEADER,POOL_FOOTER
def digest(b):return hashlib.sha256(b).hexdigest()
def strict(raw):
 def pairs(items):
  result={}
  for k,v in items:
   assert k not in result;result[k]=v
  return result
 return json.loads(raw,object_pairs_hook=pairs,parse_constant=lambda x:(_ for _ in ()).throw(ValueError(x)))
def tokens(raw):
 strict(raw);out=bytearray();quoted=escaped=False
 for c in raw:
  if quoted:
   out.append(c)
   if escaped:escaped=False
   elif c==92:escaped=True
   elif c==34:quoted=False
  elif c==34:quoted=True;out.append(c)
  elif c not in b' \r\n\t':out.append(c)
 assert not quoted and not escaped
 return bytes(out)
def expand_display(final):
 assert final.startswith(NOTICE) and final.endswith(POOL_FOOTER)
 body,pool=final[len(NOTICE):-len(POOL_FOOTER)].split(POOL_HEADER)
 phrase={};cursor=0
 for m in re.finditer('⟪A([1-9][0-9]*)⟫(.*?)⟪/A⟫\n'.encode(),pool,re.S):
  assert m.start()==cursor;cursor=m.end();ident=int(m[1]);assert ident not in phrase
  value=m[2];assert '⟪'.encode() not in value and '⟦'.encode() not in value
  phrase[ident]=value
 assert cursor==len(pool) and set(phrase)==set(range(1,len(phrase)+1))
 blocks={}
 block_pattern=re.compile('⟦b([1-9][0-9]*)⟧(.*?)⟦/b⟧'.encode(),re.S)
 for m in block_pattern.finditer(body):
  ident=int(m[1]);assert ident not in blocks and '⟦'.encode() not in m[2]
  blocks[ident]=m[2]
 assert set(blocks)==set(range(1,len(blocks)+1))
 # Parse block wrappers and references in ONE pass: block content is never rescanned.
 syntax=re.compile('⟦b([1-9][0-9]*)⟧(.*?)⟦/b⟧|⟦([1-9][0-9]*)(?::([0-9]+):([0-9]+))?⟧'.encode(),re.S)
 def fragment(m):
  if m[1]:return m[2]
  value=blocks[int(m[3])]
  if m[4] is None:return value
  a,z=int(m[4]),int(m[5]);assert 0<=a<z<=len(value)
  answer=value[a:z];answer.decode();return answer
 expanded=syntax.sub(fragment,body);assert '⟦'.encode() not in expanded
 used=set()
 def alias(m):
  ident=int(m[1]);used.add(ident);return phrase[ident]
 expanded=re.sub('⟪a([1-9][0-9]*)⟫'.encode(),alias,expanded)
 assert '⟪'.encode() not in expanded and used==set(phrase)
 return expanded
def reconstruct(final,inputs):
 """Expand visible labels, restore exact string tokens, then pinned JSON formatting."""
 middle=expand_display(final);ops=[];headers=[]
 for item in inputs:
  path=Path(item['path']);raw=path.read_bytes()
  assert digest(raw)==item['sha256'] and len(raw)==item['bytes']
  if path.suffix=='.png':continue
  header=('\n\n'+item['label']+' SHA256 '+item['sha256']+'\n').encode()
  assert middle.count(header)==1;headers.append((middle.index(header),header,item,raw))
 assert [a for a,*_ in headers]==sorted(a for a,*_ in headers)
 for i,(a,header,item,raw) in enumerate(headers):
  if Path(item['path']).suffix!='.json':continue
  start=a+len(header)
  end=headers[i+1][0] if i+1<len(headers) else len(middle)
  represented=middle[start:end]
  def string(m):return json.dumps(m[2].decode(),ensure_ascii=m[1]==b'1').encode()
  restored=re.sub(rb'\[\[AJ([01])\]\](.*?)\[\[AJEND\]\]',string,represented,flags=re.S)
  # The assembler appends a final non-document instruction after the last JSON.
  expected=tokens(raw);assert restored.startswith(expected)
  suffix=restored[len(expected):]
  assert strict(expected)==strict(raw)
  assert b'[[AJ' not in restored
  ops.append((start,end,raw+suffix))
 out=bytearray();cursor=0
 for a,z,value in ops:
  assert cursor<=a<z;out+=middle[cursor:a];out+=value;cursor=z
 out+=middle[cursor:]
 return bytes(out)
