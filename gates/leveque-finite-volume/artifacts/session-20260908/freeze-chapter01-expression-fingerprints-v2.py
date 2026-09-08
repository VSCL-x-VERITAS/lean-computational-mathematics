"""Fingerprint the native structural expression stream without retaining huge proof strings."""
from pathlib import Path
import hashlib,json,re
S=Path(__file__).resolve().parent;R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
read=lambda p:json.loads(p.read_text(encoding='utf-8'))
class Stream:
 def __init__(self,path):
  self.file=path.open('rb',buffering=4096);self.digest=hashlib.sha256();self.bytes=0
 def take(self,n):
  b=self.file.read(n);assert len(b)==n;self.digest.update(b);self.bytes+=n;return b
 def peek(self):return self.file.peek(4096)
def token(stream,capture):
 digest=hashlib.sha256();parts=[]
 def take(n):
  data=stream.take(n);digest.update(data)
  if capture:parts.append(data)
  return data
 def string():
  assert take(1)==b'"'
  while True:
   part=stream.peek();assert part
   match=re.search(rb'["\\]',part)
   if match is None:take(len(part));continue
   delim=take(match.end())[-1:]
   if delim==b'"':return
   take(1)
 def value():
  c=stream.peek()[:1]
  if c==b'"':string()
  elif c==b'[':
   take(1)
   if stream.peek()[:1]!=b']':
    while True:
     value()
     if stream.peek()[:1]!=b',':break
     take(1)
   assert take(1)==b']'
  elif c==b'n':assert take(4)==b'null'
  else:raise ValueError('Unexpected export token '+repr(c))
 value()
 return digest.hexdigest(),(json.loads(b''.join(parts)) if capture else None)

def records(path):
 stream=Stream(path);out=[];largest_type=0
 while stream.peek():
  assert stream.take(1)==b'{';record={}
  while True:
   _,key=token(stream,True);assert stream.take(1)==b':'
   hashed,val=token(stream,key not in {'value','recursor_values'})
   record[key+'_sha256']=hashed
   if key not in {'value','recursor_values'}:record[key]=val
   c=stream.take(1)
   if c==b'}':break
   assert c==b','
  assert stream.take(1)==b'\n'
  assert {k[:-7] for k in record if k.endswith('_sha256')}=={'name','module','kind','level_params','type','value','recursor_values'}
  largest_type=max(largest_type,len(record['type']))
  out.append(record)
 stream.file.close()
 return out,{'bytes':stream.bytes,'sha256':stream.digest.hexdigest(),'largest_type_characters':largest_type}

def main():
 inputs=read(S/'chapter01-expression-export-v2-inputs.json')
 for item in inputs['files']:assert sha(R/item['path'])==item['sha256']
 assert sha(R/inputs['exporter_path'])==inputs['exporter_sha256']
 receipt=read(S/'chapter01-expression-export-v2-exit.json')
 assert receipt['exit_code']==0 and receipt['output_sha256']==sha(S/'chapter01-expression-export-v2-output.txt')
 assert receipt['input_commit']==inputs['input_commit']
 data,raw=records(R/'.lake/chapter01-declaration-expressions.jsonl')
 assert len(data)==287 and len({r['name'] for r in data})==len(data)
 modules=set(inputs['selected_modules']);assert all(r['module'] in modules for r in data)
 new={p[:-5].replace('/','.') for p in inputs['added_production_modules']}
 authored_new=[r for r in data if r['module'] in new];assert len(authored_new)==180,len(authored_new)
 for r in data:assert r['kind']!='axiom',r['name']
 result={'schema':1,'input_manifest_sha256':sha(S/'chapter01-expression-export-v2-inputs.json'),
  'native_receipt_sha256':sha(S/'chapter01-expression-export-v2-exit.json'),
  'native_output_sha256':sha(S/'chapter01-expression-export-v2-output.txt'),
  'raw_ignored_stream':raw,'declaration_count':len(data),'new_authored_declarations':len(authored_new),
  'normalization':inputs['normalization'],
  'hash_encoding':'SHA-256 of the exact compact JSON token encoding of each alpha-canonical structural expression. Body tokens are streamed without retaining their expanded strings.',
  'records':data}
 dest=S/'chapter01-declaration-expression-fingerprints-v2.json';assert not dest.exists()
 dest.write_text(json.dumps(result,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
 print(json.dumps({'artifact':dest.relative_to(R).as_posix(),'sha256':sha(dest),'declarations':len(data),'new_authored':len(authored_new),'raw_stream':raw}))
if __name__=='__main__':main()

